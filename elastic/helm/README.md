Elasticsearch Helm
===

This document describe steps of install elasticsearch with helm chart.

# Chart

- [Elastic](https://github.com/elastic/helm-charts)

```
kpt pkg get git@github.com:elastic/helm-charts.git@7.8.0 elastic
```

# GKE

Use tainted node
```
kubectl get nodes --selector cloud.google.com/gke-nodepool=preemptible*
kubectl taint nodes nodename preemptible=true:PreferNoSchedule
```

# Install

Elastic
```
kubectl apply -f storageclass.yaml

NAMESPACE=elasticsearch
RELEASE=elasticsearch

helm install -n ${NAMESPACE} --values=elasticsearch-values.yaml --dry-run ${RELEASE} elastic/elasticsearch
helm install -n ${NAMESPACE} --values=elasticsearch-values.yaml ${RELEASE} elastic/elasticsearch
```

# Upgrade

### Replace pods

ex. update affinity / tolerations

1. Make sure your service has
  1. correct updateStrategy config
  1. sufficient replicas
1. Update elasticsearch-values.yaml
1. `helm install -n ${NAMESPACE} --values=elasticsearch-values.yaml ${RELEASE} elastic/elasticsearch`
1. Service update will operates with auto-scaling constrains (ex. max surge, max unavailable...)
1. Monitoring high availability status if needed

# Bitnami (Elastic Alternative) 

without APM GUI support

```
kubectl apply -f storageclass.yaml

NAMESPACE=elasticsearch

RELEASE=elasticsearch-1
helm repo add bitnami https://charts.bitnami.com/bitnami/elasticsearch
helm install -n ${NAMESPACE} --values=bitnami-values.yaml --dry-run ${RELEASE} bitnami/elasticsearch

helm install -n ${NAMESPACE} --values=bitnami-values.yaml ${RELEASE} bitnami/elasticsearch
```

# Access

```
kubectl port-forward --namespace elasticsearch svc/elasticsearch-1-coordinating-only 9200:9200 &
curl http://127.0.0.1:9200/

kubectl port-forward --namespace elasticsearch svc/elasticsearch-1-kibana 5601:5601
open http://127.0.0.1:5601/
```

---

# Kibana

```
NAMESPACE=elasticsearch

RELEASE=kibana
helm install -n ${NAMESPACE} --values=kibana-values.yaml --dry-run ${RELEASE} elastic/kibana
helm install -n ${NAMESPACE} --values=kibana-values.yaml ${RELEASE} elastic/kibana
```

---

# Apm server


```
NAMESPACE=elasticsearch

RELEASE=apm-server
helm install -n ${NAMESPACE} --values=apm-server-values.yaml --dry-run ${RELEASE} elastic/apm-server
helm install -n ${NAMESPACE} --values=apm-server-values.yaml ${RELEASE} elastic/apm-server
```
