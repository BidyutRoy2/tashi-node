# Run Tashi Network Node Free/VPS/WSL

Don't have PC/VPS Follow Setp Free Run with Google IDX

## 🖥️ 1. Installing VM in Google IDX

### ▶️ Google IDX: [HERE](https://idx.google.com/)

1. Sign up on Google IDX.
2. Create a new workspace using this repository (**Do NOT change the repo name**):

### ▶️ Enter Repository URL
```
https://github.com/BidyutRoy2/idx-vps.git
```

### Open Terminal & 

### ▶️ Fix Error Enter Dev Code

<details>
<summary><b>Click to view and copy the Script</b></summary>

```
{ pkgs, ... }: {
  channel = "stable-24.05";

  packages = with pkgs; [
    unzip
    openssh
    git
    qemu_kvm
    sudo
    cdrkit
    cloud-utils
    qemu
  ];

  env = {
    EDITOR = "nano";
  };

  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];

    workspace = {
      onCreate = { };
      onStart = { };
    };

    previews = {
      enable = false;
    };
  };
}
```
</details>

### ▶️ VM Setup Command

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/BidyutRoy2/idx-vps/refs/heads/main/vps.sh)
```
- Create New VM & Ubuntu 22.04
- After Installsation Complete
- Start Your VM

# Install Tashi Network Node 

## Register [HERE](https://t.me/hiddengemnews/15891)
- Connect New Solana Wallet
- Complete All Social Tasl
- Install Node & Earn More Xp

### Now Follow Step

```
sudo apt update && sudo apt install wget curl
```

```
source <(wget -O - https://raw.githubusercontent.com/BidyutRoy2/BidyutRoy2/refs/heads/main/installation/docker.sh)
```
```
sudo ufw enable
```
```
sudo ufw allow 39065/udp
```
```
sudo ufw allow 9000/tcp
```

```
/bin/bash -c "$(curl -fsSL https://depin.tashi.network/install.sh)" -
```

## How to Install Multiple Node in Single Device Check Video In Our Telegram Channel

```
docker run --rm -it --volume tashi-depin-worker-0:/home/worker/auth --platform linux/amd64 ghcr.io/tashigg/tashi-depin-worker:0 interactive-setup /home/worker/auth
```
```
docker run --restart always -p 9011:9000 -p 39066:39065 -d --volume tashi-depin-worker-1:/home/worker/auth --platform linux/amd64 ghcr.io/tashigg/tashi-depin-worker:0 run /home/worker/auth
```


