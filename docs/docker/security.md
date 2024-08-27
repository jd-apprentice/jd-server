# Docker Practices to secure your containers

## Overview

```yml
  dashdot:
    image: mauricenino/dashdot
    user: 1000:1000
    restart: always
    security_opt:
      - seccomp:~/security/default.json
      - no-new-privileges:true
    ports:
      - "3001:3001"
    volumes:
      - "/:/mnt/host:ro"
    environment:
      DASHDOT_ENABLE_CPU_TEMPS: 'true'
```

The property of the `security_opt` is used to enable seccomp, which is used to reduce the amount of system calls available to the container.

The `no-new-privileges` applies when you are running a container where an attacker manages to get access as a low privilege user. If you have a miss-configured suid binary, the attacker may abuse it and escalate privileges inside the container. Which, may allow him to escape from it.

The `user` property is used to set the user ID and group ID of the container, instead of the root user.

## Links

- https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html
- https://book.hacktricks.xyz/linux-hardening/privilege-escalation/docker-security