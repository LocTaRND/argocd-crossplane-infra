#!/bin/bash

while getopts a: flag
do
    case "${flag}" in
        a) action=${OPTARG};;
    esac
done

case $action in
  "argo")
    # Set Namespace variable
    NAMESPACE="argocd"
    NAMESPACE_EXISTS=$(kubectl get ns | grep $NAMESPACE | wc -l)

    # Create Argo CD namespace if it doesn't exist
    if [ $NAMESPACE_EXISTS -eq 0 ]; then
      kubectl create namespace $NAMESPACE
    fi

    # Install Argo CD
    kubectl apply -n $NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    # Optional: Wait for Argo CD to be fully deployed
    echo "Waiting for Argo CD components to be deployed..."
    kubectl wait --for=condition=available --timeout=600s deployment --all -n $NAMESPACE

    echo "Argo CD has been successfully installed in namespace $NAMESPACE"

    ;;
  "crossplane")
    kubectl apply -f crossplane-application.yaml
    ;;
  "aws")
    kubectl create secret generic aws-secret -n crossplane-system --from-file=creds=./aws-credentials.txt
    kubectl apply -f infrastructure/argocd/crossplane/aws/eks-application-crossplane.yaml
    ;;

  "azure")
    kubectl create secret generic azure-secret -n crossplane-system --from-file=creds=./azure-credentials.json
    kubectl apply -f infrastructure/argocd/crossplane/azure/aks-application-crossplane.yaml
    ;;    
esac