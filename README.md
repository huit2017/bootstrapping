# bootstrapping

## VirtualBox - 設定
1. VirtualBoxの起動
1. OS名称はconetos73
1. システム - メインメモリー 8GB, フロッピーディスクを外す
1. ストレージ - 1TB, Minimal ISOをCDにセット
1. オーディオ - オーディオを有効化チェックを外す
1. ネットワーク - NAT
1. ポート - USBコントロラーを有効化チェックを外す

## VirtualBox - OSのインストール
1. check Diskを避けて起動する
1. インストールの概要
 1. ソフトウェアの選択 - 最小限のインストール
 1. インストール先
 1. ネットワークとホスト名 - DCHPを1つON
1. ユーザーの設定 - root/vagrant vagrant/vagrant管理者にチェック

## VirtualBox - 仮想マシンの軽量化
```
yum -y install git
git clone git@github.com:huit2017/bootstrapping.git
sh clean.sh
shutdown -h now
```

## Vagrant - boxの作成
```
vagrant package --base centos73
vagrant box add centos73 package.box
rm package.box
```

## Vagrant - 仮想マシンの起動
```
mkdir provisioning
cd provisioning
vagrant init centos73
vagrant up
```
## Vagrant - 仮想マシンへログイン
```
vagrant ssh control
```
