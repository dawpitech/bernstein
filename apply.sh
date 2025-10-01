#! /usr/bin/env sh
kubectl apply -f cadvisor.daemonset.yaml
kubectl apply -f postgres.secret.yaml \
    -f postgres.configmap.yaml \
    -f postgres.volume.yaml \
    -f postgres.deployment.yaml \
    -f postgres.service.yaml
kubectl apply -f redis.configmap.yaml \
    -f redis.deployment.yaml \
    -f redis.service.yaml
kubectl apply -f poll.deployment.yaml \
    -f worker.deployment.yaml \
    -f result.deployment.yaml \
    -f poll.service.yaml \
    -f result.service.yaml \
    -f poll.ingress.yaml \
    -f result.ingress.yaml
kubectl apply -f traefik.rbac.yaml \
    -f traefik.deployment.yaml \
    -f traefik.service.yaml

echo "Waiting for DB pod to be available..."
kubectl wait --for=condition=ready pod -l app=postgres --timeout=120s

echo "Waiting for DB ready state..."
sleep 10

echo "CREATE TABLE IF NOT EXISTS votes \
(id text PRIMARY KEY, vote text NOT NULL);" \
    | kubectl exec -i $(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}') -c postgres -- psql -U user -d db

echo "Done."
