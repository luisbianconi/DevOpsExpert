#!/bin/bash
echo "Usuário: admin"
echo "Senha: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo)"
