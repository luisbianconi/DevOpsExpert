import os
import requests
import json

def lambda_handler(event, context):
    argocd_url = os.environ['ARGOCD_URL']
    token = os.environ['ARGOCD_TOKEN']
    app_name = "giropops-senhas"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    try:
        sync_url = f"{argocd_url}/api/v1/applications/{app_name}/sync"
        r = requests.post(sync_url, headers=headers, json={})  # body vazio, mas JSON válido

        return {
            'statusCode': r.status_code,
            'body': r.text
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Erro ao acionar ArgoCD: {str(e)}"
        }

