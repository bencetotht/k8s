#!/bin/bash
node_n=3
for i in $(seq 1 $node_n); do
  echo "Generating key for etcd-node${i}"

  openssl genrsa -out etcd-node${i}.key 2048

  openssl req -new -key etcd-node${i}.key -out etcd-node${i}.csr \
    -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/OU=YourUnit/CN=etcd-node${i}" \
    -config temp_${i}.cnf

  openssl x509 -req -in etcd-node${i}.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -out etcd-node${i}.crt -days 7300 -sha256 -extensions v3_req -extfile temp_${i}.cnf
done
