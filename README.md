# bootstrapping

## ゲストOSの作成 - VirtualBox

1. VirtualBoxの設定
  1. VirtualBoxの起動
  1. OS名称はconetos73
  1. システム - メインメモリー 8GB, フロッピーディスクを外す
  1. ストレージ - 1TB, Minimal ISOをCDにセット
  1. オーディオ - オーディオを有効化チェックを外す
  1. ネットワーク - NAT
  1. ポート - USBコントロラーを有効化チェックを外す

1. VirtualBoxにゲストOS(CentOS7.3)のインストール
  1. check Diskを避けて起動する
  1. インストールの概要
    1. ソフトウェアの選択 - 最小限のインストール
    1. インストール先
    1. ネットワークとホスト名 - DCHPを1つON
  1. ユーザーの設定 - root/vagrant vagrant/vagrant管理者にチェック

1. ゲストOSの軽量化
```
yum -y install git
git clone git@github.com:huit2017/bootstrapping.git
sh clean.sh
shutdown -h now
```

## Vagrant Boxの作成、初期化 - Vagrant
```
vagrant package --base centos73
vagrant box add centos73 package.box
rm package.box
vagrant init centos73
```
## ゲストOS起動、ログイン
```
vagrant up
ssh vagrant@192.168.43.53
```
