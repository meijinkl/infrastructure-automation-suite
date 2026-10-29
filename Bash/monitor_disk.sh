#!/usr/bin/env bash

# Правильное чтение .env файла (сохраняет пробелы в кавычках)
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

MOUNT_POINT="${MOUNT_POINT:-/}"
THRESHOLD="${THRESHOLD:-85}"
SMTP_SERVER="${SMTP_SERVER:-smtp.gmail.com}"
SMTP_PORT="${SMTP_PORT:-465}"
SMTP_USER="${SMTP_USER:-your_email@gmail.com}"
SMTP_PASS="${SMTP_PASS:-your_app_password}"
ALERT_EMAIL="${ALERT_EMAIL:-admin@example.com}"

USED_PERCENT=$(df -P "$MOUNT_POINT" | awk 'NR==2 {print $5}' | tr -d '%')
FREE_PERCENT=$((100 - USED_PERCENT))

echo "Проверка диска $MOUNT_POINT: свободно ${FREE_PERCENT}% (порог: ${THRESHOLD}%)"

if [ "$FREE_PERCENT" -lt "$THRESHOLD" ]; then
    echo "ВНИМАНИЕ: Свободного места менее ${THRESHOLD}%! Отправка алерта на ${ALERT_EMAIL}..."
    
    SUBJECT="Disk Space Alert on $(hostname) - ${MOUNT_POINT}"
    BODY="Warning! Free disk space on $(hostname) for mount ${MOUNT_POINT} is ${FREE_PERCENT}% (Threshold: ${THRESHOLD}%)."
    
    curl --ssl-reqd \
         --url "smtps://${SMTP_SERVER}:${SMTP_PORT}" \
         --mail-from "${SMTP_USER}" \
         --mail-rcpt "${ALERT_EMAIL}" \
         --user "${SMTP_USER}:${SMTP_PASS}" \
         -T <(echo -e "From: ${SMTP_USER}\nTo: ${ALERT_EMAIL}\nSubject: ${SUBJECT}\n\n${BODY}")
    
    if [ $? -eq 0 ]; then
        echo "Алерт успешно отправлен."
    else
        echo "Ошибка при отправке алерта!"
    fi
else
    echo "Места достаточно. Алерт не требуется."
fi