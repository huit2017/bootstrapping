# provisioning - bootstrapping

## VirtualBox - OSのインストール
1. VirtualBoxの起動
1. OS名称はconetos73
1. Memory 8GB, HD1TB
1. USB、オーディオののチェックを外す
1. デバイスのフロッピーディスクを外す
1. Minimal ISOをCDにセット
1. check Diskを避けて起動する
1. ソフトは最小構成
1. ハードの構成は
1. ネットワークはDHCPを一つONにする
1. root/vagrant vagrant/vagrant管理者にチェック

## VirtualBox - 仮想マシンの軽量化
```
yum -y install git
git clone git@github.com:huit2017/bootstrapping.git
sh clean.sh
shutodown -h now
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
