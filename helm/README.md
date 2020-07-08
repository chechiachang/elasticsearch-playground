Helm
===

# GKE

Use tainted node
```
kubectl get nodes --selector cloud.google.com/gke-nodepool=elasticsearch
kubectl taint nodes --selector cloud.google.com/gke-nodepool=elasticsearch purpose=elasticsearch:NoSchedule
```

### Taint & affinity

Node affinity
```
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: cloud.google.com/gke-nodepool
            operator: In
            values:
            - elasticsearch
```

TODO disallow master & worker on the same node

Add tolerations to helm values.yaml
```
  tolerations:
    - key: "purpose"
      operator: "Equal"
      value: "elasticsearch"
      effect: "NoSchedule"
```

# Install

Install
```
git clone https://github.com/opendistro-for-elasticsearch/opendistro-build
helm package opendistro-build/helm/opendistro-es

kubectl create namespace elasticsearch
kubectl apply -f storageclass.yaml
helm install -n elasticsearch --values=values.yaml opendistro-es opendistro-es-1.8.0.tgz
```

Use
```
kubectl port-forward -n elasticsearch deployment/opendistro-es-kibana 5601
```

Delete
```
helm delete -n elasticsearch opendistro-es
```
