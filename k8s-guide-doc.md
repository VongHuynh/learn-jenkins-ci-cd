# DEPLOYMENT K8S DODUMENT


1. apply config maps:
kubectl apply -f <config-map.yaml>

2. apply deployment apps:
kubectl apply -f <deployment-app.yaml>

3. Configuring Load Balancing with TLS Encryptionon a Kubernetes Cluster
 helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
 helm repo update
 helm install ingress-nginx ingress-nginx/ingress-nginx

 - Access your NodeBalancer’s assigned external IP address.
 kubectl -n default get services -o wide ingress-nginx-controller

 - Then, need copy ip public config in your domain

 4. Create a TLS Certificate Using cert-manage
 - Install cert-manager’s CRDs.
 kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml

 - Create a cert-manager namespace.
 kubectl create namespace cert-manager

 - Add the Helm repository which contains the cert-manager Helm chart.
 helm repo add cert-manager https://charts.jetstack.io

 - Update your Helm repositories.
 helm repo update

 - Install the cert-manager Helm chart.
helm install \
my-cert-manager cert-manager/cert-manager \
--namespace cert-manager \
--version v1.8.0

- Verify that the corresponding cert-manager pods are now running.
kubectl get pods --namespace cert-manager

5. Create a ClusterIssuer Resource
kubectl apply -f acme-issuer-prod.yaml

6. Enable HTTPS for your Application(also apply ingress)
kubectl apply ingress-controller.yaml

--- 10m later, domain will have https.


# SOME COMMAND NEED FOR OPS

1. get all service in cluster
- kubectl get svc

2. get pod
- kubectl get pods

3. view container in pod 
- kubectl describe pod <your-pod>

4. get logs container
- kubectl logs -f <container id>
- kubectl logs <pod-name> <container-name>
- kubectl logs -l app=<deployment-name> --namespace pre

5. roll back version k8s
view history deployment:
- kubectl rollout history deploy <deployment-name> -n <namespace>
- kubectl rollout undo deployment <deployment-name> --to-revision=<revision-id> -n <namespace>