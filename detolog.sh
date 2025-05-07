#!/bin/bash

CONFIG="config.ini"
source <(grep = "$CONFIG" | sed 's/ *= */=/g')

mkdir -p alerts

awk '{print $1" "$2" "$3"\t"$0}' "$LOG_FILE" > "$TEMP_FILE"

echo -e "Timestamp\t\t\tMessage\t\t\tThreatScore\tSeverity" > alerts/threat_summary.txt
> alerts/high_threats.txt

while IFS=$'\t' read -r timestamp message; do
    score=0
    lower_msg=$(echo "$message" | tr '[:upper:]' '[:lower:]')

    [[ "$lower_msg" == *"failed password"* ]] && score=$((score + 3))
    [[ "$lower_msg" == *"authentication failure"* ]] && score=$((score + 2))
    [[ "$lower_msg" == *"sudo"* && "$lower_msg" == *"incorrect password"* ]] && score=$((score + 2))
    [[ "$lower_msg" == *"port scan"* ]] && score=$((score + 2))
    [[ "$lower_msg" == *"blacklisted"* || "$lower_msg" == *"denied"* ]] && score=$((score + 5))

    if (( score >= 5 )); then
        severity="High"
        echo -e "$timestamp\t$message\t$score\t$severity" >> alerts/high_threats.txt
    elif (( score >= 3 )); then
        severity="Medium"
    elif (( score > 0 )); then
        severity="Low"
    else
        severity="None"
    fi

    echo -e "$timestamp\t$message\t$score\t$severity" >> alerts/threat_summary.txt
done < "$TEMP_FILE"

echo "[INFO] Analysis done. High threats in alerts/high_threats.txt"

# Send email if enabled
if [[ "$EMAIL_ALERTS" == "true" && -s alerts/high_threats.txt ]]; then
    python3 utils/mailer.py alerts/high_threats.txt
fi