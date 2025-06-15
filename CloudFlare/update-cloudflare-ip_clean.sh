#!/bin/bash

# ⚠️ Configurações (edite conforme necessário)
CF_ZONE_ID=""
CF_API_TOKEN=""

# 🚀 Obter o IP do LoadBalancer
LB_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

if [ -z "$LB_IP" ]; then
  echo "❌ IP do LoadBalancer não encontrado. Verifique se está ativo."
  exit 1
fi

echo "🌐 IP atual do LoadBalancer: $LB_IP"

# 🔍 Listar todos os domínios dos Ingress
INGRESS_HOSTS=$(kubectl get ingress --all-namespaces -o jsonpath="{range .items[*]}{.spec.rules[*].host}{'\n'}{end}" | sort -u)

echo "🔧 Atualizando os seguintes domínios:"
echo "$INGRESS_HOSTS"

# 🔁 Iterar por cada hostname
for HOST in $INGRESS_HOSTS; do
  echo "⏳ Atualizando $HOST..."

  RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?name=$HOST" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')

  if [ "$RECORD_ID" == "null" ] || [ -z "$RECORD_ID" ]; then
    echo "⚠️  DNS record não encontrado para $HOST. Pulando..."
    continue
  fi

  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'"$HOST"'","content":"'"$LB_IP"'","ttl":120,"proxied":false}' > /dev/null

  echo "✅ Atualizado: $HOST → $LB_IP"
done

