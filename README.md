# provisioning - bootstrapping

## vagrant boxの作成
```
vagrant package --base centos73
vagrant box add centos73 package.box
vagrant box list
```

## Vagrant起動
```
mkdir provisioning
cd provisioning
vagrant init centos73
vagrant up
```

## 仮想マシンを修正
1. winscpで仮想マシンにログイン
2. C:\Users\%username%\.vagrant.d\insecure_private_keyを/home/vagrantにコピー
3. puttyで仮想マシンにログイン

```
mkdir .ssh; chmod 700 .ssh
sudo ssh-keygen -yf insecure_private_key > .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
rm insecure_private_key
```

## Vagrantにて仮想マシンの作成
```
mkdir centos73VM
cd centos73VM
vagrant init centos73
vagrant up
```
- ※↓
- default: Warning: Authentication failure. Retrying...
- vagrant ssh-config
- IdentityFileにあるinsecure_private_keyファイル(秘密鍵)より公開鍵を作成する
