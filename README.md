<img src="/misc/aqua_warden_1x1.png" width="300" height="300">


# 🛡️ Warden: The Aqua Runtime Security POV Tool 🛡️

## Overview
Warden, the Aqua Runtime Security POV Tool, is an interactive command-line tool designed to explore various security features provided by Aqua Security within Kubernetes environments. It allows users to experience Real-Time malware Protection, Drift Prevention, and other security controls offered by Aqua.

<img src="/misc/aqua-warden-demo.gif" height="500">

## Features
1. Deploy a test container within a Kubernetes cluster
2. Test Real-time Malware Protection with delete action
3. Test Drift Prevention 
4. Test Block Cryptocurrency Mining
5. Test Block Fileless Exec 
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
- Internet access to docker regsitry or push aqua-warden test image (stanhoe/aqua-warden:latest) to local registry
- Permissions to deploy container in the Kubernetes cluster (stanhoe/aqua-warden:latest)

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

<img src="/misc/aqua-warden-advanced-commands.png" height="300">

## Additional commands
Set the custom daemonset name where the Aqua Enforcer is deployed (default: aqua-agent,kube-enforcer-ds)
```bash
./aqua-warden.sh --daemonset <value>, -d <value>
```
Show help menu which contains the list of commands 
```bash
./aqua-warden.sh --help, -h
```
Reference local registry image (default: stanhoe/aqua-warden:latest)
```bash
./aqua-warden.sh --image <image_name>, -i <image_name>
```
Skip test prerequisites instructions
```bash
./aqua-warden.sh --no-instructions, -n
```
Show the current Aqua Warden build version
```bash
./aqua-warden.sh --version, -v
```

## Aqua Warden Image
https://github.com/stanezil/aqua-warden-image

## Credits
Stan Hoe, Solution Architect APJ (stan.hoe@aquasec.com)
##
Rhett Sandal, Principal Support Engineer, for testing the update release! 
##
Guitmz for his memrun project: https://github.com/guitmz/memrun
