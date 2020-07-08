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

# Operation

Storage resize

https://kubernetes.io/blog/2018/07/12/resizing-persistent-volumes-using-kubernetes/

```
# Increase disk on GCP GUI (affect actual size limit)

# Add visible size to GKE (does not affect actual size limit)
kubectl edit pv pvc-73c1e667-c287-4b26-8715-65a02eea6455
kubectl -n elasticsearch edit pvc data-opendistro-es-master-0
```

# Access

NodePort: node-lb:32586/TCP
