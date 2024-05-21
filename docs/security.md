# Security Section

If you find anything wrong with the security of my server please let me know.
Contact me at [email](mailto:jonathan.com.ar)

## Scan for security vulnerabilities 🛡️

![scan](webcopilot.png)

## Nmap 🌐

```bash
nmap -sC jonathan.com.ar 
Starting Nmap 7.80 ( https://nmap.org ) at 2024-05-21 13:07 -03
Nmap scan report for jonathan.com.ar (172.67.179.186)
Host is up (0.018s latency).
Other addresses for jonathan.com.ar (not scanned): 104.21.75.180 2606:4700:3035::ac43:b3ba 2606:4700:3034::6815:4bb4
Not shown: 996 filtered ports
PORT     STATE SERVICE
80/tcp   open  http
|_http-title: Did not follow redirect to https://jonathan.com.ar/
443/tcp  open  https
|_http-title: /
| ssl-cert: Subject: commonName=jonathan.com.ar
| Subject Alternative Name: DNS:jonathan.com.ar, DNS:*.jonathan.com.ar
| Not valid before: 2024-04-01T03:18:50
|_Not valid after:  2024-06-30T03:18:49
8080/tcp open  http-proxy
|_http-title: Attention Required! | Cloudflare
8443/tcp open  https-alt
|_http-title: Attention Required! | Cloudflare
| ssl-cert: Subject: commonName=jonathan.com.ar
| Subject Alternative Name: DNS:jonathan.com.ar, DNS:*.jonathan.com.ar
| Not valid before: 2024-04-01T03:18:50
|_Not valid after:  2024-06-30T03:18:49

Nmap done: 1 IP address (1 host up) scanned in 8.76 seconds
```