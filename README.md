# OOM Log Time Converter

Скрипт для конвертации времени из логов ядра Linux (`Memory cgroup out of memory`) в человекочитаемый формат (`MSK, UTC+3`).

В логах Linux время указывается в секундах с момента запуска виртуальной машины (`uptime`).  
Этот скрипт берёт время старта ВМ (в `UTC`), прибавляет uptime из лога и возвращает точное время события в MSK (`UTC+3`).

---

## Установка
Склонируйте репозиторий и дайте права на запуск:

```bash
git clone https://github.com/lQwestl/oom-time-converter.git
cd oom-time-converter
chmod +x oom_time_linux.sh && chmod +x oom_time_mac.sh
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
- Строка из лога с OOM, где в начале указано uptime в секундах "[число.число]".

# Пример использования:
```bash
./oom_time_linux.sh "2024-11-28 11:04:49" "[25177317.860607] Memory cgroup out of memory: Killed process 3689775 (php) ..."
```
или
```bash
./oom_time_linux.sh "2024-11-28 11:04:49" "[25177317.860607]"
```
для `oom_time_mac.sh` аналогично.

# Дополнительно

На Linux используется `date -d`, на macOS — `date -j -f`.
Если хотите получать вывод в другой таймзоне — замените `Europe/Moscow` на нужную (например, `UTC`, `Europe/Berlin`, `Asia/Almaty`).

