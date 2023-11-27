# Local Server

Basic Network Diagram
![image](docs/networking/Basic_Approach.png)

Complete Network Diagram
![image](docs/networking/V1.1.png)

# Table of Contents 🏠

- [Demos 📺](#demos-)
    - [Portfolio 📄](#portfolio-)
    - [Arcade 🕹](#arcade-)
        - [Gameplay 🕹](#gameplay-)
    - [PiHole 🕳](#pihole-)
    - [TheLounge 💬](#irc-client-)
    - [Status Page 🗽](#status-page-)
- [Available Hardware 🖥](#available-hardware-)
- [Random stuff 🎉](#random-stuff-)
- [Project Track 🛤](#track-)
- [Folder Structure 📁](#folder-structure-)

## Demos 📺

### Portfolio 📄

A simple portfolio made with http-server, like nginx autoindex but made with nodejs.

![portfolio](assets/portfolio.png)

### Arcade 🕹

Arcade online for self hosted games, made with Nostalgist.

For the game itself this is the repo [arcade](https://github.com/jd-apprentice/-Arcade-Online-)

![page](assets/page.png)
![game](assets/game.png)

### Gameplay 🕹

https://github.com/jd-apprentice/jd-server/assets/68082746/00fbb0d2-e05d-4913-b20a-b2d3f0a9e939

### PiHole 🕳

PiHole is a DNS sinkhole that blocks ads on the network level.

![pihole](assets/pihole.png)

### IRC Client 💬

Thelounge is a IRC client for the web

![image](https://github.com/jd-apprentice/jd-server/assets/68082746/9a05ba5d-1e48-4839-98cc-d55ac4724955)

### Status Page 🗽

Uptime kuma for status in my own services

![image](https://github.com/jd-apprentice/jd-server/assets/68082746/9a557680-2af8-4c28-8a5a-27d886d9b1c0)

## Shared Server 📡

This is a folder that can be written in the webserver, for personal usage with friends, it has one time pin with cloudflare before the user can access the folder.

![zero trust](/assets/zero_trust.png)
![shared](/assets/shared.png)

## Available hardware 🖥

- 240GB SSD
- 500 Watts Generic PSU
- 2GB DDR3
- Untested A8 7650K
- Untested 500GB HDD

#### Random stuff 🎉

- TV Box 4 Cores (ARM) 2GB RAM 16GB MicroSD
- Notebook Celeron N4002 2 Cores 4GB DDR4 240GB SSD
- Notebook R5 5500U 6/12 Cores 8GB DDR4 500GB SSD
- Raspberry Pi Zero 2 W

## Track 🛤

- Project tracking is being made [Here](https://github.com/users/jd-apprentice/projects/4/views/1)

## Folder structure 📁

```
🌳 jd-server/
┣ 📁 assets/
┃ ┣ 📄 game.png
┃ ┣ 📄 page.png
┃ ┣ 📄 pihole.png
┃ ┗ 📄 portfolio.png
┣ 📁 docker/
┃ ┣ 📄 arcade.Dockerfile
┃ ┣ 📄 portfolio.Dockerfile
┃ ┗ 📄 server.compose.yml
┣ 📁 docs/
┃ ┣ 📁 networking/
┃ ┃ ┣ 📄 Basic Approach.excalidraw
┃ ┃ ┣ 📄 Basic_Approach.png
┃ ┃ ┣ 📄 Network_JD_2.excalidraw
┃ ┃ ┣ 📄 README.md
┃ ┃ ┗ 📄 V1.1.png
┃ ┣ 📄 android.md
┃ ┗ 📄 arch.md
┣ 📁 portfolio/
┃ ┣ 📄 Jonathan_Dyallo_2023_Devops_Eng.pdf
┃ ┗ 📄 homelab.txt
┣ 📁 scripts/
┃ ┗ 📄 ventoy.sh
┣ 📄 .gitignore
┗ 📄 README.md
```
