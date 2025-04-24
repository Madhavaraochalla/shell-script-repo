#!/bin/bash

set -e

echo "Creating Grafana deployment YAML..."

cat <<EOF > grafana-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  labels:
    app: grafana
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
        - name: grafana
          image: grafana/grafana:latest
          ports:
            - containerPort: 3000
          volumeMounts:
            - name: grafana-storage
              mountPath: /var/lib/grafana
          env:
            - name: GF_SECURITY_ADMIN_USER
              value: "admin"
            - name: GF_SECURITY_ADMIN_PASSWORD
              value: "admin"
      volumes:
        - name: grafana-storage
          emptyDir: {}

---
apiVersion: v1
kind: Service
metadata:
  name: grafana
spec:
  selector:
    app: grafana
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: NodePort
EOF

echo "Applying Grafana deployment..."
kubectl apply -f grafana-deployment.yaml

echo "Waiting for Grafana pod to be ready..."
kubectl rollout status deployment/grafana

echo "Launching Grafana service in browser..."
minikube service grafana

