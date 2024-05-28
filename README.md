# Kubernetes Resource Allocator Script

This script, `create_hungry_yaml.sh`, automates the creation of a Kubernetes pod specification file that requests a specified percentage of CPU and memory resources from a designated node. It is especially useful for scenarios that require precise resource management and testing within a Kubernetes environment.

## Overview

The `create_hungry_yaml.sh` script queries a specified Kubernetes node for its total CPU and memory resources, calculates a user-defined percentage of these resources, and generates a `hungry.yaml` file. This file defines a pod named "hungry" that requests these calculated resources, using the Kubernetes `busybox` container to minimally impact the node.

## Requirements

- **Kubernetes Cluster:** Access to a Kubernetes cluster and authorization to view node and resource details are required
- **kubectl:** The script uses `kubectl` to interact with the Kubernetes cluster
- **Bash Shell:** The script is written for a bash shell environment
- **Awk:** `awk` is utilized for calculations and should be installed in your environment

## Usage

```bash
./create_hungry_yaml.sh <node-name> <percentage>
```

- `<node-name>`: The name of the Kubernetes node from which resources will be allocated
- `<percentage>`: The percentage of the total CPU and memory resources to request, as a whole number

Upon successful execution, the script will:

- Display the total CPU and memory resources of the specified node.
- Show the calculated CPU and memory requests in millicores and MiB, respectively.
- Create a hungry.yaml file in the current directory with the pod specification.

Output Example:

```
$ create_hungry_yaml.sh worker-2 95
🔍 Querying node 'worker-2' for total resources (kubectl describe node/worker-2) ...
📊 Initial CPU in cores: 20 cores (20000 millicores)
📊 Initial Memory in MiB: 7838.93 MiB
🔢 Calculated CPU to request: 19000 millicores (95% of total)
🔢 Calculated Memory to request: 7447 MiB (95% of total)
✅ hungry.yaml has been created with pod/hungry in namespace hungry with the desired resource requests
```
