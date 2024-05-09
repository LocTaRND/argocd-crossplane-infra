# argocd-crossplane-infra

# Azure
- Using azcli version 2.56.0 (error with latest version 2.60.0 https://github.com/crossplane-contrib/provider-azure/issues/380)
    az ad sp create-for-rbac --sdk-auth --role Owner --scopes /subscriptions/<subscriptionsid>

- Registry:
    Microsoft.Network
    Microsoft.ContainerService