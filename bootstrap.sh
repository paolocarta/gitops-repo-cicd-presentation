kubectl apply -f infra/management-cluster/namespaces
kubectl apply -f infra/management-cluster/argocd -n argocd
# app of apps
kubectl apply -f bootstrap