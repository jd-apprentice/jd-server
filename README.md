# Local Server

Basic Network Diagram
![image](docs/networking/Basic_Approach.png)

Complete Network Diagram
![image](docs/networking/V1.1.png)

# Table of Contents 🏠

- [Demos 📺](#demos-📺)
    - [Portfolio 📄](#portfolio-📄)
    - [Arcade 🕹](#arcade-🕹)
        - [Gameplay 🕹](#gameplay-🕹)
    - [PiHole 🕳](#pihole-🕳)
- [Available Hardware 🖥](#available-hardware-🖥)
- [Random stuff 🎉](#random-stuff-🎉)
- [Utility Links 🔗](#utility-links-🔗)
- [OS Details 📰](#os-details-📰)
- [Hardware Details 📰](#hardware-details-📰)
- [Project Track 🛤](#track-🛤)

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