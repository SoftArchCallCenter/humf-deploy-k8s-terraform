#!/bin/bash

kubectl_command="kubectl apply -f"

# Apply config and secret files
for file in deploy/k8s/config-secret/*.yaml; do
  $kubectl_command "$file"
done
echo "Apply config and secret."

# Apply MySQL files
for file in deploy/k8s/mysql-service/*.yaml; do
  $kubectl_command "$file"
done
echo "Apply mysql."

# Wait for 30 seconds before applying the next file
sleep 30
echo "Wait ..."

# Apply all other YAML files in deploy/k8s and its subdirectories
for file in deploy/k8s/**/*.yaml; do
  $kubectl_command "$file"
done

echo "All YAML files in deploy/k8s and its subdirectories applied successfully."
