#!/bin/bash

#1. CentOSの設定
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm

#2. 必要なパッケージのインストール
sudo yum groupinstall -y "Development Tools"
sudo yum install -y openssl-devel readline-devel zlib-devel curl-devel libyaml-devel libffi-devel postgresql-server postgresql-devel httpd httpd-devel ImageMagick ImageMagick-devel ipa-pgothic-fonts

#3. Rubyのインストール
ruby_major_version="2.4"
ruby_teeny_version="1"
ruby_version="ruby-${ruby_major_version}.${ruby_teeny_version}"
curl -O https://cache.ruby-lang.org/pub/ruby/${ruby_major_version}/${ruby_version}.tar.gz
tar xvf ${ruby_version}.tar.gz
cd ${ruby_version}
./configure --disable-install-doc
make
sudo make install
cd ..
ruby -v
sudo `which gem` install bundler --no-rdoc --no-ri

#4. PostgreSQLの設定
sudo postgresql-setup initdb
pg_hba_conf="/var/lib/pgsql/data/pg_hba.conf"
sudo cp $pg_hba_conf ${pg_hba_conf}.org
line=`sudo grep -n '# TYPE  DATABASE        USER            ADDRESS                 METHOD' ${pg_hba_conf}.org  | sed -e 's/:.*//g'`
text="host    redmine         redmine         127.0.0.1/32            md5\nhost    redmine         redmine         ::1/128                 md5"
sudo sed -e "${line}a ${text}" ${pg_hba_conf}.org | sudo tee ${pg_hba_conf}

sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service

db_password="redmine"
sudo -u postgres cd /var/lib/pgsql
sudo -u postgres psql -c "CREATE USER redmine WITH PASSWORD '${db_password}';"
sudo -u postgres psql -c "CREATE DATABASE redmine OWNER redmine ENCODING 'UTF-8' LC_COLLATE 'ja_JP.UTF-8' TEMPLATE template0;"
cd -

#5. Redmineのダウンロード
redmine_version="redmine-3.4.2"
redmine_dir="/var/lib/redmine"
curl -O http://www.redmine.org/releases/${redmine_version}.tar.gz
tar -zxvf ${redmine_version}.tar.gz
sudo mv ${redmine_version} $redmine_dir

cat << EOT | sudo tee ${redmine_dir}/config/database.yml
production:
  adapter: postgresql
  database: redmine
  host: localhost
  username: redmine
  password: "${db_password}"
  encoding: utf8
EOT

cat << EOT | sudo tee ${redmine_dir}/config/configuration.yml
production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: "localhost"
      port: 25
      domain: "example.com"
  rmagick_font_path: /usr/share/fonts/ipa-pgothic/ipagp.ttf
EOT

cd $redmine_dir
sudo `which bundle` install --without development test --path vendor/bundle

#6. Redmineの初期設定と初期データ登録
sudo `which bundle` exec rake generate_secret_token
sudo `which bundle` exec rake db:migrate RAILS_ENV=production
sudo `which bundle` exec rake redmine:load_default_data RAILS_ENV=production REDMINE_LANG=ja

#7. Passengerのインストール
sudo `which gem` install passenger --no-rdoc --no-ri
sudo `which passenger-install-apache2-module` --auto --languages ruby
sudo `which passenger-install-apache2-module` --snippet

#7. Apacheの設定
apache2_module_snippet=`passenger-install-apache2-module --snippet`
cat << EOT | sudo tee /etc/httpd/conf.d/redmine.conf
# Redmineの画像ファイル・CSSファイル等へのアクセスを許可する設定。
# Apache 2.4のデフォルトではサーバ上の全ファイルへのアクセスが禁止されている。
<Directory "${redmine_dir}/public">
  Require all granted
</Directory>

# Passengerの基本設定。
# passenger-install-apache2-module --snippet で表示された設定を記述。
# 環境によって設定値が異なるため以下の5行はそのまま転記せず、必ず
# passenger-install-apache2-module --snippet で表示されたものを使用すること。
#
$apache2_module_snippet

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
sudo chown -R apache:apache $redmine_dir
httpd_conf="/etc/httpd/conf/httpd.conf"
sudo cp $httpd_conf ${httpd_conf}.org
search='DocumentRoot "/var/www/html"'
replace='DocumentRoot "'$redmine_dir'/public"'
sed -e "s#${search}#${replace}#" ${httpd_conf}.org | sudo tee $httpd_conf
sudo service httpd configtest
sudo systemctl restart httpd.service
