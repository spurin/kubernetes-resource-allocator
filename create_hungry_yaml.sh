#!/bin/bash

# Check for correct usage and provide instructions if incorrect
if [ $# -ne 2 ]; then
  echo "🚫 Usage: $0 <node-name> <percentage>"
  echo "   <node-name> : Name of the Kubernetes node"
  echo "   <percentage> : Desired percentage of CPU and Memory to use"
  exit 1
fi

node_name=$1
percentage_usage=$2

# Retrieve the total CPU (in cores) and memory from the specified node
echo "🔍 Querying node '$node_name' for total resources (kubectl describe node/${node_name}) ..."
total_cpu_cores=$(kubectl get node "$node_name" -o jsonpath='{.status.capacity.cpu}')
total_memory=$(kubectl get node "$node_name" -o jsonpath='{.status.capacity.memory}')

# Convert memory from KiB to MiB by dividing by 1024 and round up to avoid underutilization
total_memory_mib=$(echo "$total_memory" | awk '{print ($1/1024) + 0.499999}')

echo "📊 Initial CPU in cores: $total_cpu_cores cores ($(echo $total_cpu_cores | awk '{print int($1*1000)}') millicores)"
echo "📊 Initial Memory in MiB: $total_memory_mib MiB"

# Convert CPU cores to millicores and calculate the desired percentage of the total CPU and memory
cpu_calculated=$(echo "$total_cpu_cores" | awk -v percentage="$percentage_usage" '{printf "%.0f", $1 * 1000 * (percentage / 100)}')
memory_calculated=$(echo "$total_memory_mib" | awk -v percentage="$percentage_usage" '{printf "%.0f", $1 * (percentage / 100)}')

echo "🔢 Calculated CPU to request: $cpu_calculated millicores (${percentage_usage}% of total)"
echo "🔢 Calculated Memory to request: $memory_calculated MiB (${percentage_usage}% of total)"

# Create hungry.yaml with the computed resources
cat <<EOF > hungry.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: hungry
---
apiVersion: v1
kind: Pod
metadata:
  name: hungry
  namespace: hungry
spec:
  nodeName: "$node_name"
  containers:
  - name: hungry
    image: busybox
    command: ["sleep"]
    args: ["infinity"]
    resources:
      requests:
        cpu: "${cpu_calculated}m"
        memory: "${memory_calculated}Mi"
EOF

echo "✅ hungry.yaml has been created with pod/hungry in namespace hungry with the desired resource requests"
