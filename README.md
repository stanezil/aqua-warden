<img src="/misc/aqua_warden_1x1.png" width="300" height="300">


# 🛡️ Warden: The Aqua Runtime Security POV Tool 🛡️

## Overview
Warden, the Aqua Runtime Security POV Tool, is an interactive command-line tool designed to explore various security features provided by Aqua Security within Kubernetes environments. It allows users to experience Real-Time malware Protection, Drift Prevention, and other security controls offered by Aqua.

<img src="/misc/aqua-warden-demo.gif" height="300">

## Features
1. Deploy a test container within a Kubernetes cluster.
2. Test Real-time Malware Protection with delete action.
3. Test Drift Prevention 
4. Test block cryptocurrency mining.
5. Test Block Fileless Exec (drift prevention must be disabled)
6. Test Block Reverse Shell
7. Test Executables Blocked (ps)
8. Test Block Container Exec

## Usage
1. Ensure you have `kubectl` configured to connect to your Kubernetes cluster.
2. Run the script by executing `./aqua-warden.sh`.
3. Follow the on-screen prompts to deploy the test container and perform security tests.

## Requirements
- Bash shell
- `kubectl` configured to connect to a Kubernetes cluster
- Aqua Enforcer daemonset deployed in the Kubernetes cluster
- Permissions to deploy containers in the Kubernetes cluster (stanhoe/ubuntu-wget:latest and stanhoe/centos-nc:7)

## Installation
1. Clone this repository to your local machine
2. Ensure you have the necessary permissions to execute the script (`chmod +x aqua-warden.sh`)

## Usage Example
```bash
# Default mode - utilizes stanhoe/aqua-warden:latest image
./aqua-warden.sh

# Advanced mode
./aqua-warden.sh --no-instructions --image <image_name>
./aqua-warden.sh -n -i <image_name>
```

## Additional commands
Skip test prerequisites instructions
```bash
./aqua-warden.sh --no-instructions OR -n
```
Reference local registry image
```bash
./aqua-warden.sh --image <image_name> OR -i <image_name>
```

## Credits
Stan Hoe, Solution Architect APJ (stan.hoe@aquasec.com)
