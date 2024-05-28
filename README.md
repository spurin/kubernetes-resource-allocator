# Kubernetes Resource Allocator Script

This script, `create_requested_yaml.sh`, automates the creation of a Kubernetes pod specification file that requests a specified percentage of CPU and memory resources from a designated node. It is especially useful for scenarios that require precise resource management and testing within a Kubernetes environment.

## Overview

The `create_requested_yaml.sh` script queries a specified Kubernetes node for its total CPU and memory resources, calculates a user-defined percentage of these resources, and generates a yaml file. This file defines a named pod in a specified namespace that requests these calculated resources, using the Kubernetes `busybox` container to minimally impact the node.

## Requirements

- **Kubernetes Cluster:** Access to a Kubernetes cluster and authorization to view node and resource details are required
- **kubectl:** The script uses `kubectl` to interact with the Kubernetes cluster
- **Bash Shell:** The script is written for a bash shell environment
- **Awk:** `awk` is utilized for calculations and should be installed in your environment

## Usage

```bash
./create_requested_yaml.sh <node-name> <percentage>
```

- `<namespace>` : Kubernetes namespace for the pod
- `<pod-name>` : Name of the Kubernetes pod
- `<node-name>` : Name of the Kubernetes node
- `<percentage>` : Desired percentage of CPU and Memory to use

Upon successful execution, the script will:

- Display the total CPU and memory resources of the specified node
- Show the calculated CPU and memory requests in millicores and MiB, respectively
- Create a yaml file in the current directory with the pod specification

Output Example:

```
root@control-plane:~# ./create_requested_yaml.sh hungry worker-1 worker-1 95
🔍 Querying node 'worker-1' for total resources (kubectl describe node/worker-1) ...
📊 Initial CPU in cores: 20 cores (20000 millicores)
📊 Initial Memory in MiB: 7838.93 MiB
🔢 Calculated CPU to request: 19000 millicores (95% of total)
🔢 Calculated Memory to request: 7447 MiB (95% of total)
✅ hungry-worker-1.yaml has been created with pod/worker-1 in namespace hungry with the desired resource requests

root@control-plane:~# cat hungry-worker-1.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: hungry
---
apiVersion: v1
kind: Pod
metadata:
  name: worker-1
  namespace: hungry
spec:
  nodeName: "worker-1"
  containers:
  - name: worker-1
    image: busybox
    command: ["sleep"]
    args: ["infinity"]
    resources:
      requests:
        cpu: "19000m"
        memory: "7447Mi"
```
