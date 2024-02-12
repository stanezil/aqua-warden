<img src="/Logo/aqua_warden_1x1.png" width="300" height="300">


# 🛡️ Warden: The Aqua Runtime Security POV Tool 🛡️

## Overview
Warden, the Aqua Runtime Security POV Tool, is an interactive command-line tool designed to explore various security features provided by Aqua Security within Kubernetes environments. It allows users to experience Real-Time malware Protection, Drift Prevention, and other security controls offered by Aqua.

<img src="/Logo/aqua-warden-demo.gif" height="300">

## Features
- Deploy and manage a test container within a Kubernetes cluster.
- Test real-time malware protection with delete actions.
- Test drift prevention controls.
- Test block cryptocurrency mining.
- Test block fileless execution (with drift prevention disabled).
- Test reverse shell detection.
- Test executables blocked. (Currently only detection due to a bug in SLK-76766)
- Exec into the test container

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
1. Clone this repository to your local machine.
2. Ensure you have the necessary permissions to execute the script (`chmod +x aqua-warden.sh`).

## Usage Example
```bash
./aqua-warden.sh
```

## Credits
Stan Hoe, Solution Architect APJ (stan.hoe@aquasec.com)
