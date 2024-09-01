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
....
```

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.0.242:6443 K3S_TOKEN=.... sh -
reboot
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