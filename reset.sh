#! /usr/bin/env sh

kubectl delete deployment --all
kubectl delete deployment -n kube-public --all
kubectl delete daemonset cadvisor -n kube-system
kubectl delete service --all
kubectl delete pod --all
kubectl delete ingress --all
kubectl delete persistentvolumeclaims postgres-pvc
