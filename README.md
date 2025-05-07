# 🔐 DetoLog – Real-Time Intrusion Detection System

**DetoLog** is a lightweight, real-time Intrusion Detection System (IDS) built using Bash and Python. It monitors system logs, analyzes suspicious activity, and sends email alerts for high-severity threats.

## 📌 Features

- 🛡️ Detects failed login attempts, port scans, blacklisted IPs, and sudo misuse
- 📧 Sends real-time email alerts for high-risk activities
- 📝 Generates threat summary reports
- ⚙️ Configurable via `config.ini`

## 🛠️ Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/ArchitJain112004/DetoLog.git
   cd DetoLog
    chmod +x detolog.sh
    ./detolog.sh
Real-time monitoring:
    python3 realtime_monitor.py
 
Alert Example:
Subject: DetoLog: Intrusion Detected
Detected threat:
May 07 12:04:22 mymachine sshd[1234]: Failed password for root from 192.168.0.5