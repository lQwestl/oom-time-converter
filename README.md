# OOM Log Time Converter

Скрипт для конвертации времени из логов ядра Linux (`Memory cgroup out of memory`) в человекочитаемый формат (`MSK, UTC+3`).

В логах Linux время указывается в секундах с момента запуска виртуальной машины (`uptime`).  
Этот скрипт берёт время старта ВМ (в `UTC`), прибавляет uptime из лога и возвращает точное время события в MSK (`UTC+3`).

---

## Установка
Склонируйте репозиторий и дайте права на запуск:

```bash
git clone [https://github.com/<your-repo>/oom-time-converter.git](https://github.com/lQwestl/oom-time-converter.git)
cd oom-time-converter
chmod +x oom_time.sh
```

# Скрипт принимает два аргумента:
1) Время старта виртуальной машины в `UTC` (`YYYY-MM-DD HH:MM:SS`)
2) Строка из лога с OOM

# Пример:
```bash
./oom_time.sh "2024-11-28 11:04:49" "[25177317.860607] Memory cgroup out of memory: Killed process 3689775 (php)"
```
или
```bash
./oom_time.sh "2024-11-28 11:04:49" "[25177317.860607]"
```

# Вывод:
```
Лог: [25177317.860607] Memory cgroup out of memory: Killed process 3689775 (php)
Время OOM (MSK): 2026-06-02 13:15:17 MSK
```

# Входные данные
- Время старта ВМ — задаётся в `UTC` (например, из `cloud-init` или `last reboot`).
- `LOG_LINE` — строка из dmesg, kern.log или syslog, содержащая OOM событие.

# Пример строки:
```bash
[25177317.860607] Memory cgroup out of memory: Killed process 3689775 (php) total-vm:185960kB, anon-rss:105564kB, file-rss:22424kB, shmem-rss:0kB, UID:10000 pgtables:340kB oom_score_adj:-997
```
# Использование

Скрипт принимает два аргумента:
- Время старта виртуальной машины в UTC (YYYY-MM-DD HH:MM:SS)
- Строка из лога с OOM

```bash
./oom_time.sh "2024-11-28 11:04:49" "[25177317.860607] Memory cgroup out of memory: Killed process 3689775 (php)"
```

# Скрипт

```bash
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
```

# Дополнительно

Скрипт работает на `Linux` и требует утилиты `date` с поддержкой `-d` и `TZ`.
Если хотите получать вывод в другой таймзоне — замените `Europe/Moscow` на нужную (например, `UTC`, `Europe/Berlin`, `Asia/Almaty`).
Работает с любыми строками логов ядра, где в начале указано uptime в секундах ([число.число]).
