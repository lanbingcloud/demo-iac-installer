# ---k3s---
k3s-uninstall.sh
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.14+k3s1 sh -s - server --disable servicelb --disable traefik --disable metrics-server
cp /etc/rancher/k3s/k3s.yaml ${HOME}/.kube/k3s-config
cp /etc/rancher/k3s/k3s.yaml ${HOME}/.kube/config
export KUBECONFIG=${HOME}/.kube/config

# ---argocd---
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch service argocd-server -n argocd -p '{"metadata":{"annotations":{"traefik.ingress.kubernetes.io/service.serverstransport":"traefik-default@kubernetescrd"}}}'

# ---argocd app---
kubectl apply -f ./project.yaml -f ./app.yaml

# ---argoevents secret---
kubectl create namespace argo-events
kubectl apply -f ./argo-events/overlays/production/secret-github-access.yaml
