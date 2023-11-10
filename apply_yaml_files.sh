#!/bin/bash

kubectl_command="kubectl apply -f"

for file in $(find deploy/k8s -name "*.yaml")
do
  $kubectl_command $file
done

echo "All YAML files in deploy/k8s and its subdirectories applied successfully."
