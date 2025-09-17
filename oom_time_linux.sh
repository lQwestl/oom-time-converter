#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Использование: $0 \"<VM_START_UTC>\" \"<LOG_LINE>\""
    echo "Пример: $0 \"2025-09-15 10:00:00\" \"[25177317.860607] Memory cgroup out of memory: ...\""
    exit 1
fi

# Параметры
VM_START_UTC="$1"
LOG_LINE="$2"

# 1. Вырезаем uptime в секундах (целая часть до точки)
UPTIME_SEC=$(echo "$LOG_LINE" | grep -oP '^\[\K[0-9]+')

# 2. Конвертируем время старта в epoch (UTC)
VM_START_EPOCH=$(date -u -d "$VM_START_UTC" +%s)

# 3. Прибавляем uptime
OOM_EPOCH=$((VM_START_EPOCH + UPTIME_SEC))

# 4. Переводим в человекочитаемый вид (MSK = UTC+3)
OOM_TIME=$(TZ="Europe/Moscow" date -d "@$OOM_EPOCH" "+%Y-%m-%d %H:%M:%S %Z")

echo "Лог: $LOG_LINE"
echo "Время OOM (MSK): $OOM_TIME"
