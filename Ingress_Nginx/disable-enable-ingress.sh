#!/bin/bash

SERVICE_NAME="ingress-nginx-controller"
NAMESPACE="ingress-nginx"

echo "=============================="
echo "💡 Troca de tipo de Service"
echo "1 - Setar como LoadBalancer"
echo "2 - Setar como ClusterIP"
echo "=============================="
read -p "Escolha uma opção [1-2]: " OPCAO

if [[ "$OPCAO" == "1" ]]; then
  echo "🔁 Alterando para LoadBalancer..."
  kubectl patch svc $SERVICE_NAME -n $NAMESPACE -p '{"spec": {"type": "LoadBalancer"}}'
elif [[ "$OPCAO" == "2" ]]; then
  echo "🔁 Alterando para ClusterIP..."
  kubectl patch svc $SERVICE_NAME -n $NAMESPACE -p '{"spec": {"type": "ClusterIP"}}'
else
  echo "❌ Opção inválida. Use 1 ou 2."
  exit 1
fi

echo "✅ Tipo de service alterado. Verifique com:"
echo "   kubectl get svc -n $NAMESPACE"

