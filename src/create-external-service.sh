curl -k \
    -X POST \
    --cert $CERT_FILE \
    --key $KEY_FILE \
    --cacert $CACERT_FILE \
    -d @- \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    $K8S_HOST/api/v1/namespaces/$NAMESPACE/services <<'EOF'
{
   "apiVersion": "v1",
   "kind": "Service",
   "metadata": {
     "name": "$SERVICE_NAME"
   },
   "spec": {"ports": [{"port": $PORT,"protocol": "TCP","targetPort": $TARGET_PORT}]}
}
