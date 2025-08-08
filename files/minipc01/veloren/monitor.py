#!/usr/bin/env python3

import subprocess
import re
import requests
import time
import sys

DOCKER_CONTAINER = "veloren-game-server-master"
DISCORD_WEBHOOK = "..."

ansi_escape = re.compile(r'\x1b\[[0-9;]*m')

def send_discord(msg):
    try:
        resp = requests.post(DISCORD_WEBHOOK, json={"content": msg})
        if resp.status_code != 204:
            print(f"[WARN] Discord webhook responded {resp.status_code} - {resp.text}")
    except Exception as e:
        print(f"[ERROR] Failed to send discord message: {e}")

def monitor_docker_logs():
    clients = {}
    pending_pids = []

    while True:
        try:
            print(f"[INFO] Starting docker logs for container {DOCKER_CONTAINER}...")
            proc = subprocess.Popen(
                ["docker", "logs", "--since=1m", "-f", DOCKER_CONTAINER],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                bufsize=1,
            )

            for line in proc.stdout:
                line = line.rstrip('\n')
                line = ansi_escape.sub('', line)
                print("line repr:", repr(line))

                handshake_match = re.search(r'This Handshake is now configured! pid=(\w+)', line)
                print("handshake_match:", handshake_match)
                if handshake_match:
                    pid = handshake_match.group(1)
                    print(f"Handshake detected, pid={pid} agregado a pending_pids")
                    pending_pids.append(pid)
                    continue

                user_match = re.search(r'New User username="([^"]+)"', line)
                print("user_match:", user_match)
                print("pending_pids:", pending_pids)
                if user_match:
                    username = user_match.group(1)
                    if pending_pids:
                        pid = pending_pids.pop(0)
                        clients[pid] = {"username": username, "connected_at": time.time()}
                        print(f"Nuevo usuario '{username}' asignado a pid {pid}")
                        send_discord(f"✅ **{username}** se ha conectado")
                    else:
                        print(f"Nuevo usuario '{username}' sin pid pendiente")
                    continue

                disconnect_match = re.search(r'client_disconnect{pid=(\w+)', line)
                print("disconnect_match:", disconnect_match)
                if disconnect_match:
                    pid = disconnect_match.group(1)
                    if pid in clients:
                        username = clients[pid]["username"]
                        send_discord(f"❌ **{username}** se ha desconectado")
                        del clients[pid]
                    else:
                        print(f"Desconexión de pid={pid} que no está en clients")

        except Exception as e:
            print(f"[ERROR] Exception in monitoring loop: {e}", file=sys.stderr)
            print("[INFO] Restarting docker logs monitor in 5 seconds...")
            time.sleep(5)

if __name__ == "__main__":
    monitor_docker_logs()