#!/bin/bash

sudo yum update

readonly RUBY_TEENY_VERSION='1'
readonly DB_PASSWORD='redmine'
readonly READMINE_VERSION='redmine-3.4.2'
readonly SMTP_ADDRESS='localhost'
readonly SMTP_DOMAIN='example.com'

#1. CentOSの設定
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm

#2. 必要なパッケージのインストール
sudo yum groupinstall -y "Development Tools"
sudo yum install -y openssl-devel \
  readline-devel \
  zlib-devel \
  curl-devel \
  libyaml-devel \
  libffi-devel \
  postgresql-server \
  postgresql-devel \
  httpd httpd-devel \
  ImageMagick \
  ImageMagick-devel \
  ipa-pgothic-fonts

#3. Rubyのインストール
readonly SRC_DIR='/usr/local/src'
cd ${SRC_DIR}
readonly RUBY_VERSION="ruby-${RUBY_MAJOR_VERSION}.${RUBY_TEENY_VERSION}"
curl -O https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR_VERSION}/${RUBY_VERSION}.tar.gz
tar xvf ${RUBY_VERSION}.tar.gz
cd ${RUBY_VERSION}
./configure --disable-install-doc
make
sudo make install
cd
ruby -v
sudo $(which gem) install bundler --no-rdoc --no-ri

#4. PostgreSQLの設定
sudo postgresql-setup initdb
readonly PG_HBA_CONF='/var/lib/pgsql/data/pg_hba.conf'
sudo cp ${PG_HBA_CONF} ${PG_HBA_CONF}.org
line=$(sudo grep -n '# TYPE  DATABASE        USER            ADDRESS                 METHOD' ${PG_HBA_CONF}.org  | sed -e 's/:.*//g')
text="host    redmine         redmine         127.0.0.1/32            md5\nhost    redmine         redmine         ::1/128                 md5"
sudo sed -e "${line}a ${text}" ${PG_HBA_CONF}.org | sudo tee ${PG_HBA_CONF}

sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service


sudo -u postgres cd /var/lib/pgsql
sudo -u postgres psql -c "CREATE USER redmine WITH PASSWORD '${DB_PASSWORD}';"
sudo -u postgres psql -c "CREATE DATABASE redmine OWNER redmine ENCODING 'UTF-8' LC_COLLATE 'ja_JP.UTF-8' TEMPLATE template0;"
cd -

#5. Redmineのダウンロード
cd ${SRC_DIR}
readonly READMINE_DIR='/var/lib/redmine'
curl -O http://www.redmine.org/releases/${READMINE_VERSION}.tar.gz
tar -zxvf ${READMINE_VERSION}.tar.gz
sudo mv ${READMINE_VERSION} ${READMINE_DIR}

cat <<EOT | sudo tee ${READMINE_DIR}/config/database.yml
production:
  adapter: postgresql
  database: redmine
  host: localhost
  username: redmine
  password: "${DB_PASSWORD}"
  encoding: utf8
EOT

cat <<EOT | sudo tee ${READMINE_DIR}/config/configuration.yml
production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: "${SMTP_ADDRESS}"
      port: 25
      domain: "${SMTP_DOMAIN}"
  rmagick_font_path: /usr/share/fonts/ipa-pgothic/ipagp.ttf
EOT

cd $READMINE_DIR
sudo $(which bundle) install --without development test --path vendor/bundle

#6. Redmineの初期設定と初期データ登録
sudo $(which bundle) exec rake generate_secret_token
sudo $(which bundle) exec rake db:migrate RAILS_ENV=production
sudo $(which bundle) exec rake redmine:load_default_data RAILS_ENV=production REDMINE_LANG=ja

#7. Passengerのインストール
sudo $(which gem) install passenger --no-rdoc --no-ri
sudo $(which passenger-install-apache2-module) --auto --languages ruby
sudo $(which passenger-install-apache2-module) --snippet

#7. Apacheの設定
cat <<EOT | sudo tee /etc/httpd/conf.d/redmine.conf
# Redmineの画像ファイル・CSSファイル等へのアクセスを許可する設定。
# Apache 2.4のデフォルトではサーバ上の全ファイルへのアクセスが禁止されている。
<Directory "${READMINE_DIR}/public">
  Require all granted
</Directory>

$(passenger-install-apache2-module --snippet)

# 必要に応じてPassengerのチューニングのための設定を追加（任意）。
# 詳しくはPhusion Passenger users guide(https://www.phusionpassenger.com/library/config/apache/reference/)参照。
PassengerMaxPoolSize 20
PassengerMaxInstancesPerApp 4
PassengerPoolIdleTime 864000
PassengerStatThrottleRate 10

Header always unset "X-Powered-By"
Header always unset "X-Runtime"
EOT

sudo systemctl start httpd.service
sudo systemctl enable httpd.service

#8. Apache上のPassengerでRedmineを実行するための設定
sudo chown -R apache:apache $READMINE_DIR
readonly HTTPD_CONF='/etc/httpd/conf/httpd.conf'
sudo cp ${HTTPD_CONF} ${HTTPD_CONF}.org
search='DocumentRoot "/var/www/html"'
replace='DocumentRoot "'${READMINE_DIR}'/public"'
sed -e "s#${search}#${replace}#" ${HTTPD_CONF}.org | sudo tee ${HTTPD_CONF}
sudo service httpd configtest
sudo systemctl restart httpd.service
