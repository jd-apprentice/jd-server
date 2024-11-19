# Overview

## Enable cgroups

Standard Raspberry Pi OS installations do not start with cgroups enabled. K3S needs cgroups to start the systemd service. cgroupscan be enabled by appending cgroup_memory=1 cgroup_enable=memory to /boot/cmdline.txt.

## Install K3S

```bash
curl -sfL https://get.k3s.io | sh -
```

## Install Kompose

Used to convert docker-compose.yml to kubernetes manifests.

```bash
pacman -S kompose
```

### Convert

```bash
kompose convert -f name.yaml
```

You need at least`<name>-<service>.yaml` and `<name>-<deployment>.yaml`

Here are the examples that i'm using

```yml
# infobae-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    io.kompose.service: infobae-api
  name: infobae-api
spec:
  ports:
    - name: 'tcp'
      port: 3000
      targetPort: 3000
  selector:
    io.kompose.service: infobae-api
  type: LoadBalancer
```

```yml
# infobae-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    io.kompose.service: infobae-api
  name: infobae-api
spec:
  replicas: 1
  selector:
    matchLabels:
      io.kompose.service: infobae-api
  template:
    metadata:
      labels:
        io.kompose.service: infobae-api
    spec:
      containers:
        - image: dyallo/infobae_api
          name: infobae-api
          ports:
            - containerPort: 3000
              protocol: TCP
      restartPolicy: Always
```

To apply the manifests use

```bash
kubectl apply -f .
```

This will create the service and deployment for infobae-api, we can also scale the deployment using

```bash
kubectl scale deployment infobae-api --replicas=3
```

And display the service

```bash
kubectl get service infobae-api
NAME          TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
infobae-api   LoadBalancer   10.43.214.234   192.168.0.242   3000:31073/TCP   104m
```

Also display the deployment

```bash
kubectl get deployment infobae-api
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
infobae-api   3/3     3            3           105m
```

We can curl the service

```bash
curl localhost:3000/api/infobae
{"lastmod":"2024-09-01T02:48:03.052Z","link":"https://www.infobae.com/america/agencias/2024/09/01/la-defensa-rusa-derriba-mas-de-14-vehiculos-aereos-ucranianos-sobre-briansk-lipetsk-y-belgorod/"}
```

## Join the cluster

In the master node run

```shell
ip addr | grep 192.168
```

And grab the IP, then obtain the token

```shell
sudo cat /var/lib/rancher/k3s/server/node-token
```

To enable the server to be HA we need to init the server as a cluster

```shell
sudo nano /etc/systemd/system/k3s.service
## Add the following
ExecStart=/usr/local/bin/k3s server --cluster-init
sudo systemctl daemon-reload
sudo systemctl restart k3s
```

```bash
## In the worker node
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.0.242:6443 K3S_TOKEN=.... sh -
## In the master node
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.30.4+k3s1 K3S_TOKEN="..." sh -s server --server https://<MASTER_IP>:6443
```

To have separate deployments we can do something like this

```yaml
# infobae-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    io.kompose.service: infobae-api
  name: infobae-api-worker
spec:
  replicas: 1
  selector:
    matchLabels:
      io.kompose.service: infobae-api
  template:
    metadata:
      labels:
        io.kompose.service: infobae-api
    spec:
      containers:
        - image: dyallo/infobae_api
          name: infobae-api
          ports:
            - containerPort: 3000
              protocol: TCP
      restartPolicy: Always

---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    io.kompose.service: infobae-api
  name: infobae-api-master
spec:
  replicas: 2
  selector:
    matchLabels:
      io.kompose.service: infobae-api
  template:
    metadata:
      labels:
        io.kompose.service: infobae-api
    spec:
      containers:
        - image: dyallo/infobae_api
          name: infobae-api
          ports:
            - containerPort: 3000
              protocol: TCP
      restartPolicy: Always

```

```shell
dyallo@node03:~/www/k3s/infobae $ kubectl get nodes
NAME     STATUS     ROLES                  AGE     VERSION
node02   Ready      worker                 69m     v1.30.4+k3s1
node03   Ready      control-plane,master   4h32m   v1.30.4+k3s1

dyallo@node03:~/www/k3s/infobae $ kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
infobae-api-master-5f4894dd7f-7mlw5   1/1     Running   0          26m
infobae-api-master-5f4894dd7f-mmz6z   1/1     Running   0          23m
infobae-api-worker-5f4894dd7f-62vxg   1/1     Running   0          12m

dyallo@node03:~/www/k3s/infobae $ kubectl get services
NAME          TYPE           CLUSTER-IP      EXTERNAL-IP                   PORT(S)          AGE
infobae-api   LoadBalancer   10.43.194.206   192.168.0.150,192.168.0.242   3000:32581/TCP   33m
kubernetes    ClusterIP      10.43.0.1       <none>
```

Now if we do a request to any of the external IPs we should see the LoadBalancer working

```shell
dyallo@node03:~/www/k3s/infobae $ curl --silent 192.168.0.242:3000/api/infobae | jq
{
  "lastmod": "2024-09-01T19:26:26.101Z",
  "link": "https://www.infobae.com/mexico/2024/08/31/tragedia-en-jiutepec-tres-ninos-murieron-por-derrumbe-tras-fuertes-lluvias-en-morelos/",
  "hostname": "infobae-api-worker-78bfd84f84-vjkx9"
}
dyallo@node03:~/www/k3s/infobae $ curl --silent 192.168.0.242:3000/api/infobae | jq
{
  "lastmod": "2024-09-01T19:26:26.101Z",
  "link": "https://www.infobae.com/mexico/2024/08/31/tragedia-en-jiutepec-tres-ninos-murieron-por-derrumbe-tras-fuertes-lluvias-en-morelos/",
  "hostname": "infobae-api-master-d8fcffbd-h9f9r"
}
```

## Disable Programming

Once we have our k3s cluster running we can disable scheduling on the nodes (master for example)

```shell
kubectl cordon node03
kubectl get nodes -o wide
NAME     STATUS                     ROLES                  AGE     VERSION        INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION      CONTAINER-RUNTIME
node00   Ready                      worker                 44h     v1.30.4+k3s1   192.168.0.253   <none>        Debian GNU/Linux 11 (bullseye)   6.1.21-v8+          containerd://1.7.20-k3s1
node01   NotReady                   worker                 44h     v1.30.4+k3s1   192.168.0.251   <none>        Debian GNU/Linux 11 (bullseye)   6.1.21-v8+          containerd://1.7.20-k3s1
node02   Ready                      worker                 3d18h   v1.30.4+k3s1   192.168.0.150   <none>        Debian GNU/Linux 11 (bullseye)   6.1.21-v8+          containerd://1.7.20-k3s1
node03   Ready,SchedulingDisabled   control-plane,master   3d22h   v1.30.4+k3s1   192.168.0.242   <none>        Debian GNU/Linux 12 (bookworm)   6.6.31+rpt-rpi-v8   containerd://1.7.20-k3s1
```

### Do not use the control plane for deployments

```shell
k get pods -o wide
NAME                                  READY   STATUS    RESTARTS   AGE    IP           NODE     NOMINATED NODE   READINESS GATES
infobae-api-worker-5f4894dd7f-2tf8s   1/1     Running   0          108m   10.42.2.13   node01   <none>           <none>
infobae-api-worker-5f4894dd7f-6j8cb   1/1     Running   0          105m   10.42.1.22   node02   <none>           <none>
infobae-api-worker-5f4894dd7f-zvxxn   1/1     Running   0          109m   10.42.3.18   node00   <none>           <none>
```

Here my master (node03) is not in charge of any deployment.

### Links

- https://rpi4cluster.com/
- https://k3s.rocks/install-setup/
- https://k8s-docs.netlify.app/en/docs/reference/kubectl/cheatsheet/