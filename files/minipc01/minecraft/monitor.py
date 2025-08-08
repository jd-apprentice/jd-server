
import re
import requests
import subprocess
import threading

CONTAINERS_MAP = {
    "demo_server-mc-creative-1": "[DEV] Servidor Creativo 1.2.7",
    "demo_server-mc-survival-1": "[DEV] Servidor Survival 1.2.4",
}

DISCORD_WEBHOOK_URL = "..."

JOIN_REGEX = re.compile(r": (\w+) joined the game")
LEAVE_REGEX = re.compile(r": (\w+) left the game")

def send_discord_message(message):
    data = {"content": message}
    try:
        response = requests.post(DISCORD_WEBHOOK_URL, json=data)
        if response.status_code != 204:
            print(f"Error enviando mensaje a Discord: {response.status_code} {response.text}")
    except Exception as e:
        print(f"Error enviando mensaje a Discord: {e}")

def monitor_docker_logs(container_name, friendly_name):
    process = subprocess.Popen(
        ["docker", "logs", "--since", "5m", "-f", container_name],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        universal_newlines=True
    )

    print(f"Escuchando logs del contenedor {container_name} (últimos 5 minutos)...")

    for line in process.stdout:
        line = line.strip()

        join_match = JOIN_REGEX.search(line)
        if join_match:
            player = join_match.group(1)
            msg = f":green_circle: **{player}** se ha conectado al servidor **{friendly_name}**!"
            print(msg)
            send_discord_message(msg)

        leave_match = LEAVE_REGEX.search(line)
        if leave_match:
            player = leave_match.group(1)
            msg = f":red_circle: **{player}** se ha desconectado del servidor **{friendly_name}**!"
            print(msg)
            send_discord_message(msg)

if __name__ == "__main__":
    threads = []
    for container_name, friendly_name in CONTAINERS_MAP.items():
        t = threading.Thread(target=monitor_docker_logs, args=(container_name, friendly_name))
        t.daemon = True
        t.start()
        threads.append(t)

    print("Monitores lanzados para todos los servidores.")

    try:
        while True:
            pass
    except KeyboardInterrupt:
        print("Saliendo...")