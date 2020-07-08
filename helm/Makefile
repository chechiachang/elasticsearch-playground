
kpt:
	kpt pkg get https://github.com/opendistro-for-elasticsearch/security.git/securityconfig@v1.8.0.0 configs
	cp configs/elasticsearch.yml.example configs/elasticsearch.yml

# Remote k8s

configs:
	kubectl create configmap game-config --from-file=configs
