# OOM Log Time Converter

Скрипт для конвертации времени из логов ядра Linux (`Memory cgroup out of memory`) в человекочитаемый формат MSK (UTC+3).

В логах Linux время указывается в секундах с момента запуска виртуальной машины (uptime). Этот скрипт берёт время старта ВМ в UTC, прибавляет uptime из лога и возвращает точное время события в MSK (UTC+3).

## Установка

Склонируйте репозиторий и дайте права на выполнение:

```bash
git clone https://github.com/lQwestl/oom-time-converter.git
cd oom-time-converter
chmod +x oom_time_linux.sh && chmod +x oom_time_mac.sh
```

## Использование

Скрипт принимает два аргумента:

1. **Время старта виртуальной машины** в UTC (формат: `YYYY-MM-DD HH:MM:SS`)
2. **Строка из лога** с OOM событием или просто uptime в формате `[число.число]`

### Примеры использования

```bash
./oom_time_linux.sh "2024-11-28 11:04:49" "[25177317.860607] Memory cgroup out of memory: Killed process 3689775 (php)"
```

или просто с uptime:

```bash
./oom_time_linux.sh "2024-11-28 11:04:49" "[25177317.860607]"
```

Для macOS используйте `oom_time_mac.sh` аналогично.

### Пример вывода

```
Лог: [25177317.860607] Memory cgroup out of memory: Killed process 3689775 (php)
Время OOM (MSK): 2026-06-02 13:15:17 MSK
```

## Входные данные

**Время старта ВМ** — указывается в UTC. Можно получить из:
- cloud-init логов
- команды `last reboot`
- системных логов загрузки

**Строка лога** — пример из dmesg, kern.log или syslog:

```
[25177317.860607] Memory cgroup out of memory: Killed process 3689775 (php) total-vm:185960kB, anon-rss:105564kB, file-rss:22424kB, shmem-rss:0kB, UID:10000 pgtables:340kB oom_score_adj:-997
```

## Дополнительные настройки

- **Linux**: использует `date -d`
- **macOS**: использует `date -j -f`

Для изменения часового пояса замените `Europe/Moscow` в скрипте на нужную зону:
- `UTC`
- `Europe/Berlin`
- `Asia/Almaty`
- другие зоны из базы tzdata
