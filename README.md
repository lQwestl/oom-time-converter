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
## Настройка для windows

В PowerShell (От Администратора) вводим команду:
```bash
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Получаем вывод и соглашаемся (Y):
```bash
Изменение политики выполнения
Политика выполнения защищает компьютер от ненадежных сценариев. Изменение политики выполнения может поставить под
угрозу безопасность системы, как описано в разделе справки, вызываемом командой about_Execution_Policies и
расположенном по адресу https:/go.microsoft.com/fwlink/?LinkID=135170 . Вы хотите изменить политику выполнения?
[Y] Да - Y  [A] Да для всех - A  [N] Нет - N  [L] Нет для всех - L  [S] Приостановить - S  [?] Справка
(значением по умолчанию является "N"):Y
```
Пример запуска и получение вывода:
```bash
.\oom_time_windows.ps1 "2025-05-09 10:18:17" "[9417604.415473] I/O error, dev sdb"
Log: [9417604.415473] I/O error, dev sdb
OOM Time (MSK): 2025-08-26 13:18:21 MSK

Calculation details:
VM Start (UTC): 2025-05-09 10:18:17
Uptime seconds: 9417604
OOM Time (UTC): 2025-08-26 10:18:21 UTC
OOM Time (MSK): 2025-08-26 13:18:21 MSK
```

## Входные данные

**Время старта ВМ** — указывается в UTC. Можно получить из:
- cloud-init логов
- команды `last reboot`
- системных логов загрузки
- `date -d "$(</proc/uptime awk '{print $1}') seconds ago"`

  

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
