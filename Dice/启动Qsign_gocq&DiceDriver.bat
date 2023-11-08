start cmd /K "Start_Qsign.bat"
timeout /t 10
start cmd /K "go-cqhttp.exe -faststart"
timeout /t 10
start cmd /K "DiceDriver.Gocq.Lite.exe"