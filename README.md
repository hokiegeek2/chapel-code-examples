# chapel-code-examples

The curl example leverages the Chapel Curl and URL modules. The Linux/UNIX curl command such as this to read from the Kubernetes API looks like this...

```
curl -k --url https://localhost:6443/namespaces/ --cert user.crt:s3cret --key user.key --cacert /etc/kubernetes/ssl/kube-ca.pem
```

...and in Chapel it looks like this...

```
    var urlreader = openUrlReader('https://localhost:6443/namespaces/');
  
    Curl.setopt(urlreader, CURLOPT_VERBOSE, true);
    Curl.setopt(urlreader, CURLOPT_USE_SSL, true);
    Curl.setopt(urlreader, CURLOPT_SSLCERT, 'user.crt');
    Curl.setopt(urlreader, CURLOPT_SSLKEY, 'user.key');
    Curl.setopt(urlreader, CURLOPT_KEYPASSWD, 's3cret');
    Curl.setopt(urlreader, CURLOPT_CAINFO, '/etc/kubernetes/ssl/kube-ca.pem');
    Curl.setopt(urlreader, CURLOPT_CAPATH, '/etc/kubernetes/ssl');

    while(urlreader.readline(str)) {
        write(str);
    }
```
