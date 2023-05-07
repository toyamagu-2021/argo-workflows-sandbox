# ArgoWorkflows RBAC test

## Command

1. `helmfile sync .`
1. `ARGO_TOKEN="Bearer $(kubectl get secret -n argo-workflows test.service-account-token -o=jsonpath='{.data.token}' | base64 --decode)"`
1. `echo $ARGO_TOKEN`
1. `k port-forward -n argo-workflows svc/argo-workflows-server 2746:2746`
1. `http://localhost:2746/`
