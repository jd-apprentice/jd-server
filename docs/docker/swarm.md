# Docker swarm configuration

## Create a swarm

```bash
docker swarm init
```

## Join a swarm

```bash
docker swarm join --token <token> <ip>:<port>
```

## Create a NFS volume

On the manager node:

```bash
sudo apt install nfs-kernel-server
sudo mkdir -p /var/nfs/swarm
sudo nano /etc/exports
/var/nfs/swarm *(rw,sync,no_subtree_check)
sudo systemctl restart nfs-kernel-server
```

On the worker node:

```bash
sudo apt install nfs-common
sudo mkdir -p /mnt/swarm
sudo mount <manager_ip>:/var/nfs/swarm /mnt/swarm
```

## Deploy a stack

Create a `compose.yml` file:

```yaml
services:

  opengist:
    image: ghcr.io/thomiceli/opengist:1.7
    user: 61000:61000
    security_opt:
      - no_new_privileges:true
      - seccomp:unconfined
    deploy:
      replicas: 3
      placement:
        max_replicas_per_node: 1
      resources:
        limits:
          cpus: '0.50'
          memory: 50m
    ports:
      - "6157:6157"
    volumes:
      - type: volume
        source: shared
        target: /var/nfs/swarm
        volume:
          nocopy: true
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

volumes:
  shared:
    driver: local
    driver_opts:
      type: nfs
      o: addr=node03.local,nolock,soft,rw
      device: ":/var/nfs/swarm"
```

Deploy the stack:

```bash
docker stack deploy -c compose.yml opengist
```