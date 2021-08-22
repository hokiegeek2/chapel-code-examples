 curl -k \
    -X POST \
    -d @- \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    localhost:3000/posts <<'EOF'
    {"foo": "bar"}
EOF