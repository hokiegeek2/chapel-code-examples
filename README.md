# chapel-code-examples

The curl example leverages the Chapel Curl and URL modules. The Linux/UNIX curl command such as this to read from the Kubernetes API looks like this...

```
curl -k --url https://localhost:6443/namespaces/ --cert user.crt:s3cret --key user.key --cacert /etc/kubernetes/ssl/kube-ca.pem
```

...

and in Chapel it looks like this...

```
use URL;
use Curl;


# Import the C CURL setopt variables
extern const CURLOPT_VERBOSE:CURLoption;
extern const CURLOPT_USERNAME:CURLoption;
extern const CURLOPT_PASSWORD:CURLoption;
extern const CURLOPT_USE_SSL:CURLoption;
extern const CURLOPT_S
extern const CURLOPT_SSLKEY:CURLoption;
extern const CURLOPT_KEYPASSWD:CURLoption;
extern const CURLOPT_SSLCERTTYPE:CURLoption;
extern const CURLOPT_CAPATH:CURLoption;
extern const CURLOPT_CAINFO:CURLoption;

try {
    // Create the url reader
    var urlreader = openUrlReader('https://localhost:6443/namespaces/');

    // Configure the url reader for SSL
    Curl.setopt(urlreader, CURLOPT_VERBOSE, true);
    Curl.setopt(urlreader, CURLOPT_USE_SSL, true);
    Curl.setopt(urlreader, CURLOPT_SSLCERT, 'user.crt');
    Curl.setopt(urlreader, CURLOPT_SSLKEY, 'user.key');
    Curl.setopt(urlreader, CURLOPT_KEYPASSWD, 's3cret');
    Curl.setopt(urlreader, CURLOPT_CAINFO, '/etc/kubernetes/ssl/kube-ca.pem');
    Curl.setopt(urlreader, CURLOPT_CAPATH, '/etc/kubernetes/ssl');

    var str:bytes;

    while(urlreader.readline(str)) {
        write(str);
    }
} catch e : Error {
    // Do better error handling than this....
    try! writeln(e);
}
```
