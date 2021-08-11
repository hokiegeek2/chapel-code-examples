module CurlFun {
    use URL;
    use Curl;

    proc main() {
        extern const CURLOPT_VERBOSE:CURLoption;
        extern const CURLOPT_USERNAME:CURLoption;
        extern const CURLOPT_PASSWORD:CURLoption;
        extern const CURLOPT_USE_SSL:CURLoption;
        extern const CURLOPT_SSLCERT:CURLoption;
        extern const CURLOPT_SSLKEY:CURLoption;
        extern const CURLOPT_KEYPASSWD:CURLoption;
        extern const CURLOPT_SSLCERTTYPE:CURLoption;
        extern const CURLOPT_CAPATH:CURLoption;
        extern const CURLOPT_CAINFO:CURLoption;

        var str:bytes;
        try {
            # read from kubernetes
            var urlreader = openUrlReader('https://localhost:6443/namespaces/');
            var handle = getCurlHandle(urlreader);

            Curl.setopt(urlreader, CURLOPT_VERBOSE, true);
            Curl.setopt(urlreader, CURLOPT_USE_SSL, true);
            Curl.setopt(urlreader, CURLOPT_SSLCERT, 'arkouda.crt');
            Curl.setopt(urlreader, CURLOPT_SSLKEY, 'arkouda.key');
            Curl.setopt(urlreader, CURLOPT_KEYPASSWD, 's3cret');
            Curl.setopt(urlreader, CURLOPT_CAINFO, '/etc/kubernetes/ssl/kube-ca.pem');
            Curl.setopt(urlreader, CURLOPT_CAPATH, '/etc/kubernetes/ssl');

            while(urlreader.readline(str)) {
                write(str);
            }
        } catch e : Error{
            try! writeln(e);
        }
    }
}
