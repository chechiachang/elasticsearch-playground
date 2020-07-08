Helm
===

# GKE

Use tainted node
```
kubectl get nodes --selector cloud.google.com/gke-nodepool=elasticsearch
kubectl taint nodes --selector cloud.google.com/gke-nodepool=elasticsearch purpose=elasticsearch:NoSchedule
```

Add tolerations to helm values.yaml
```
  tolerations:
    - key: "purpose"
      operator: "Equal"
      value: "elasticsearch"
      effect: "NoSchedule"
```

# Deploy

https://github.com/opendistro-for-elasticsearch/opendistro-build/tree/master/helm#elasticsearchyml-config

```
git clone https://github.com/opendistro-for-elasticsearch/opendistro-build
cd opendistro-build/helm/opendistro-es/
helm package .

kubectl create namespace es
helm install -n es --values=values.yaml opendistro-es opendistro-es-1.8.0.tgz

kubectl port-forward -n es deployment/opendistro-es-kibana 5601
```

helm delete -n es opendistro-es
