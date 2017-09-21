#!/bin/bash

readonly PROJECT_NAME=huitbot
readonly HUBOT_OWNER=huit
readonly HUBOT_NAME=hoime
readonly HUBOT_DESCRIPTION="I study hubot."
readonly HUBOT_SLACK_TOKEN=xoxb-xxxxxxxxxxxxxx
readonly HUBOT_ADAPTER=slack

sudo yum update -y
sudo yum install  -y epel-release npm git
sudo npm install -g yo generator-hubot coffee-script@1.12.6
sudo npm install hubot-heroku-keepalive --save
sudo mkdir ${PROJECT_NAME}
sudo cd ${PROJECT_NAME}
yo hubot --owner="${HUBOT_OWNER}" --name="{HUBOT_NAME}" --description="${HUBOT_DESCRIPTION}" --adapter="${HUBOT_ADAPTER=}"
# package.js #edit node-v
# external-scripts.json # "hubot-heroku-keepalive"

sudo yum install -y wget
sudo wget https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-linux-x64.tar.gz -O heroku.tar.gz
sudo mkdir -p /usr/local/lib
sudo mv heroku-cli-v6.14.24-72dfccf-linux-x64 /usr/local/lib/heroku
sudo ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
# heroku login

#heroku addons:create rediscloud
heroku create ${PROJECT_NAME}
heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=https://${PROJECT_NAME}.herokuapp.com/
heroku config:set HUBOT_HEROKU_WAKEUP_TIME=8:00
heroku config:set HUBOT_HEROKU_SLEEP_TIME=24:00
heroku config:set HUBOT_HEROKU_KEEPALIVE_INTERVAL=5
heroku config:set TZ=Asia/Tokyo

export HUBOT_SLACK_TOKEN;bin/hubot -a slack

git init
git add .
git commit -m "Initial commit"
git push heroku master
