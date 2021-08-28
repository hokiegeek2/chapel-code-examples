echo $NAMESPACE
echo $K8S_HOST
echo $ENDPOINT_NAME
echo $ENDPOINT_IP
echo $ENDPOINT_PORT

PAYLOAD='
{
  "kind": "Endpoints",
  "apiVersion": "v1",
  "metadata": {
    "name": "$ENDPOINT_NAME"
  },
  "subsets": [
     {
         "addresses": [
           {
                    "ip": "$ENDPOINT_IP"
           }
         ],
         "ports": [
           {
                    "port": $ENDPOINT_PORT,
                    "protocol": "TCP"
           }
         ]
     }
  ]
}
'

echo $PAYLOAD

curl -k \
    -X POST \
    --cert $CERT_FILE \
    --key $KEY_FILE \
    --cacert $CACERT_FILE \
    -d @- \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    $K8S_HOST/api/v1/namespaces/$NAMESPACE/endpoints <<'EOF'
{
  "kind": "Endpoints",
  "apiVersion": "v1",
  "metadata": {
    "name": "arkouda"
  },
  "subsets": [
     {
         "addresses": [
           {
                    "ip": "192.168.1.6"
           }
         ],
         "ports": [
           {
                    "port": 5555,
                    "protocol": "TCP"
           }
         ]
     }
  ]
}
