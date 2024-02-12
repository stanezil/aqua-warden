# Aqua Runtime Security POV Tool

## Overview
The Aqua Runtime Security POV Tool is an interactive command-line tool designed to explore various security features provided by Aqua Security within Kubernetes environments. It allows users to experience real-time malware protection, drift prevention, and other security controls offered by Aqua.

## Features
- Deploy and manage a test container within a Kubernetes cluster.
- Test real-time malware protection with delete actions.
- Test drift prevention controls.
- Test block cryptocurrency mining.
- Test block fileless execution (with drift prevention disabled).
- Test reverse shell detection.
- Test executables blocked.
- Exec into the test container

## Usage
1. Ensure you have `kubectl` configured to connect to your Kubernetes cluster.
2. Run the script by executing `./aqua-runtime-poc.sh`.
3. Follow the on-screen prompts to deploy the test container and perform security tests.

## Requirements
- Bash shell
- `kubectl` configured to connect to a Kubernetes cluster
- Aqua Enforcer daemonset deployed in the Kubernetes cluster

## Installation
1. Clone this repository to your local machine.
2. Ensure you have the necessary permissions to execute the script (`chmod +x aqua-runtime-poc.sh`).

## Usage Example
```bash
./aqua-runtime-poc.sh
```

## Credits
Stan Hoe, Solution Architect APJ
