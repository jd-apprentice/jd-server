# Android 🤖

Android can be used to host applications with Termux
From there I can do a variety of things with Nodejs or Python

## Android devices available 🧰

### List 📓

- TV Box Noga ULTRA10+
- 2 Android phones with at least 8gb storage
 
### 05/12/2023 ⏰

Now I have been confirm that I can expose static web services from android devices

In the android device we run:

`termux`
`http-server`

And in another server we have:

`cloudflare-tunnel`

The way it works is I expose the webpage with `http-server` at port 8080 with `npx http-server <path-to-folder> &`, then I'll go to cloudflare public hostnames and add a new one 

![image](https://github.com/jd-apprentice/jd-server/assets/68082746/c11e1fb7-9a33-4ef7-8ec2-219c81363b1d)

with `HTTP://<device-ip>:<port>`
