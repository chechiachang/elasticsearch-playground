SHELL:=/bin/bash
UNAME_S := $(shell uname -s)

# https://opendistro.github.io/for-elasticsearch-docs/docs/security-configuration/generate-certificates/
certificate:
	# Root CA
	openssl genrsa -out certs/root-ca-key.pem 2048
	openssl req -new -x509 -sha256 -subj "/C=TW/ST=Taiwan/L=Taipei/O=CheChia/CN=chechia.net" -key certs/root-ca-key.pem -out certs/root-ca.pem
	# Admin cert
	openssl genrsa -out certs/admin-key-temp.pem 2048
	openssl pkcs8 -inform PEM -outform PEM -in certs/admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out certs/admin-key.pem
	openssl req -new -subj "/C=TW/ST=Taiwan/L=Taipei/O=CheChia/CN=chechia.net" -key certs/admin-key.pem -out certs/admin.csr
	openssl x509 -req -in certs/admin.csr -CA certs/root-ca.pem -CAkey certs/root-ca-key.pem -CAcreateserial -sha256 -out certs/admin.pem
	# Node cert
	openssl genrsa -out certs/node-key-temp.pem 2048
	openssl pkcs8 -inform PEM -outform PEM -in certs/node-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out certs/node-key.pem
	openssl req -new -subj "/C=TW/ST=Taiwan/L=Taipei/O=CheChia/CN=chechia.net" -key certs/node-key.pem -out certs/node.csr
	openssl x509 -req -in certs/node.csr -CA certs/root-ca.pem -CAkey certs/root-ca-key.pem -CAcreateserial -sha256 -out certs/node.pem
	# Cleanup
	rm certs/admin-key-temp.pem
	rm certs/admin.csr
	rm certs/node-key-temp.pem
	rm certs/node.csr

docker-compose:
	docker-compose up -d

docker-compose-down:
	docker-compose down -v
