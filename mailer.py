import smtplib
import configparser
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import sys

config = configparser.ConfigParser()
config.read("config.ini")

def send_alert_email(subject, body):
    email = config["EMAIL"]
    msg = MIMEMultipart()
    msg["From"] = email["enter_sender_email"]
    msg["To"] = email["enter_reciever_email"]
    msg["Subject"] = subject
    msg.attach(MIMEText(body, "plain"))

    try:
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
            server.login(email["sender"], email["password"])
            server.send_message(msg)
        print("Email sent successfully.") 
    except Exception as e:
        print(f"[!] Email failed: {e}")

if __name__ == "__main__":
    with open(sys.argv[1], "r") as f:
        send_alert_email("DetoLog High Severity Report", f.read())