# argo-workflows-sso

## Procedure

1. Create GitHub OAuth app and memo `client_secret` and `client_id`
1. `cp sample.env .env`
1. Edit file
1. `source sample.env`
1. `helmfile sync .`
1. `k port-forward -n argo-workflows argo-server 2746:2746`
1. `k port-forward -n argo-cd argo-cd-argocd-server 8080:8080`

## DNS resolve

- `/etc/hosts`
  - `127.0.0.1  .    argo-cd-argocd-server.argo-cd.svc.cluster.local`
