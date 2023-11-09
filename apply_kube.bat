@echo off
setlocal enabledelayedexpansion

set "kubectl_command=kubectl apply -f"

for /r deploy\k8s %%f in (*.yaml) do (
  set "file=%%f"
  %kubectl_command% !file!
)

echo "All YAML files in deploy\k8s and its subdirectories applied successfully."

endlocal
