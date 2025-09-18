param(
    [string]$VMStartUTC,
    [string]$LogLine
)

if (-not $VMStartUTC -or -not $LogLine) {
    Write-Host "Usage: .\oom_time_windows.ps1 ""<VM_START_UTC>"" ""<LOG_LINE>""" -ForegroundColor Yellow
    Write-Host "Example: .\oom_time_windows.ps1 ""2025-09-15 10:00:00"" ""[25177317.860607] Memory cgroup out of memory""" -ForegroundColor Yellow
    exit 1
}

# 1. Extract uptime in seconds (integer part before dot)
$UptimeMatch = [regex]::Match($LogLine, '^\[(\d+)\.')
if (-not $UptimeMatch.Success) {
    Write-Host "Error: Cannot extract timestamp from log" -ForegroundColor Red
    exit 1
}
$UPTIME_SEC = [int]$UptimeMatch.Groups[1].Value

# 2. Convert start time to DateTime (UTC)
try {
    $VM_START_DATETIME = [DateTime]::ParseExact($VMStartUTC, "yyyy-MM-dd HH:mm:ss", $null)
}
catch {
    Write-Host "Error: Invalid start time format. Use: yyyy-MM-dd HH:mm:ss" -ForegroundColor Red
    exit 1
}

# 3. Add uptime
$OOM_DATETIME = $VM_START_DATETIME.AddSeconds($UPTIME_SEC)

# 4. Convert to Moscow time (UTC+3)
$OOM_TIME_MOSCOW = $OOM_DATETIME.AddHours(3)
$OOM_TIME_FORMATTED = $OOM_TIME_MOSCOW.ToString("yyyy-MM-dd HH:mm:ss")

# Output in English to avoid encoding issues
Write-Host "Log: $LogLine"
Write-Host "OOM Time (MSK): $OOM_TIME_FORMATTED MSK"
Write-Host ""
Write-Host "Calculation details:"
Write-Host "VM Start (UTC): $VMStartUTC"
Write-Host "Uptime seconds: $UPTIME_SEC"
Write-Host "OOM Time (UTC): $($OOM_DATETIME.ToString('yyyy-MM-dd HH:mm:ss')) UTC"
Write-Host "OOM Time (MSK): $OOM_TIME_FORMATTED MSK"
