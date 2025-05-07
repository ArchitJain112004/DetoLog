import subprocess
from utils.mailer import send_alert_email
import threading

LOG_FILE = "config.ini"

def monitor_log():
    with open(LOG_FILE) as f:
        for line in f:
            if line.startswith("LOG_FILE"):
                log_path = line.strip().split("=")[-1]
                break

    process = subprocess.Popen(["sudo", "tail", "-F", log_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    for line in process.stdout:
        print(line.strip())

        if any(threat in line.lower() for threat in ["authentication failure", "failed password", "port scan", "blacklisted"]):
            send_alert_email("DetoLog: Intrusion Detected", f"Detected threat:\n{line}") 

if __name__ == "__main__":
    threading.Thread(target=monitor_log, daemon=True).start()
    input("Press Enter to stop...\n")