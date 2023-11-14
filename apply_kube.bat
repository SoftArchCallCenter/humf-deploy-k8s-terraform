@echo off
setlocal enabledelayedexpansion

set "kubectl_command=kubectl apply -f"

for /r deploy\k8s\config-secret %%f in (*.yaml) do (
  set "file=%%f"
  %kubectl_command% !file!
)
echo "Apply config and secret."

for /r deploy\k8s\mysql-service %%f in (*.yaml) do (
  set "file=%%f"
  %kubectl_command% !file!
)
echo "Apply mysql."

rem Wait for 30 seconds before applying the next file
timeout /t 30 /nobreak >nul
echo "Wait ..."

for /r deploy\k8s %%f in (*.yaml) do (
  set "file=%%f"
  %kubectl_command% !file!
)

echo "All YAML files in deploy\k8s and its subdirectories applied successfully."

endlocal
