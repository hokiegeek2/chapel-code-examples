module CurlUtil {
    use IO;
    use URL;
    use Curl;
    use List;
    use SystemUtil;
    
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
    extern const CURLOPT_CUSTOMREQUEST:CURLoption;
    extern const CURLOPT_POSTFIELDS:CURLoption;
    extern const CURLOPT_POSTFIELDSIZE:CURLoption;
    extern const CURLOPT_HTTPHEADER:CURLoption;
    extern const CURLOPT_READDATA:CURLoption;
    extern const CURLOPT_UPLOAD:CURLoption;
    extern const CURLOPT_WRITEFUNCTION:CURLoption;
    extern const CURLOPT_WRITEDATA:CURLoption;
    extern const CURLOPT_URL:CURLoption;

    class CurlReader {
    
      var urlreader: channel;
      
       proc init() {
           urlreader = openUrlReader(getEnvVariable('CURL_URL'));

           Curl.setopt(urlreader, CURLOPT_VERBOSE, true);
           Curl.setopt(urlreader, CURLOPT_USE_SSL, true);
           Curl.setopt(urlreader, CURLOPT_SSLCERT, getEnvVariable('CERT_FILE'));
           Curl.setopt(urlreader, CURLOPT_SSLKEY, getEnvVariable('KEY_FILE'));
           Curl.setopt(urlreader, CURLOPT_CAINFO, getEnvVariable('CACERT_FILE'));
           Curl.setopt(urlreader, CURLOPT_CAPATH, getEnvVariable('CAPATH',''));           
           Curl.setopt(urlreader, CURLOPT_KEYPASSWD, getEnvVariable('CERT_PASSWD',''));      
       }

       proc curlRead(url : string) : string {
           var urlreader = openUrlReader(getEnvVariable('CURL_URL'));
           
       }
    }

    proc read() throws {
        var str:bytes;
        var urlreader = openUrlReader(getEnvVariable('CURL_URL'));

        Curl.setopt(urlreader, CURLOPT_VERBOSE, true);
        Curl.setopt(urlreader, CURLOPT_USE_SSL, true);
        Curl.setopt(urlreader, CURLOPT_SSLCERT, getEnvVariable('CERT_FILE'));
        Curl.setopt(urlreader, CURLOPT_SSLKEY, getEnvVariable('KEY_FILE'));
        Curl.setopt(urlreader, CURLOPT_CAINFO, getEnvVariable('CACERT_FILE'));
        Curl.setopt(urlreader, CURLOPT_CAPATH, getEnvVariable('CAPATH',''));           
        Curl.setopt(urlreader, CURLOPT_KEYPASSWD, getEnvVariable('CERT_PASSWD',''));

        while(urlreader.readline(str)) {
            write(str);
        }   
    }

    proc write() throws {        
        var curl = Curl.easyInit();
        Curl.easySetopt(curl, CURLOPT_URL, getEnvVariable('CURL_URL'));

        var args = new Curl.slist();
        args.append("Accept: application/json");
        args.append("Content-Type: application/json-patch+json");
        args.append("charset: utf-8");
        Curl.setopt(curl, CURLOPT_HTTPHEADER, args);
        
        Curl.setopt(curl, CURLOPT_VERBOSE, true);
        Curl.setopt(curl, CURLOPT_USE_SSL, true);
        Curl.setopt(curl, CURLOPT_SSLCERT, getEnvVariable('CERT_FILE'));
        Curl.setopt(curl, CURLOPT_SSLKEY, getEnvVariable('KEY_FILE'));
        Curl.setopt(curl, CURLOPT_CAINFO, getEnvVariable('CACERT_FILE'));
        Curl.setopt(curl, CURLOPT_CAPATH, getEnvVariable('CAPATH',''));           
        Curl.setopt(curl, CURLOPT_KEYPASSWD, getEnvVariable('CERT_PASSWD',''));

        Curl.setopt(curl, CURLOPT_CUSTOMREQUEST, 'PATCH');
        
        var payload = '[{"op": "replace", "path": "/subsets", "value": [{"addresses": [{"ip": "192.168.1.22"}]}]}]';
        var numChars = payload.size;
        
        Curl.setopt(curl, CURLOPT_POSTFIELDS, payload);

        var ret = Curl.easyPerform(curl);

        args.free();
        Curl.easyCleanup(curl);     
    }
    
    proc simpleWrite(format: string='plain-text') throws {
        var urlwriter = openUrlWriter('http://localhost:3000/posts');
        
        if format == 'plain-text' {
            
            var curl = Curl.easyInit();
            Curl.easySetopt(curl, CURLOPT_URL, 'http://localhost:3000/posts');
            Curl.easySetopt(curl, CURLOPT_VERBOSE, true);

            var args = new Curl.slist();
            args.append("Accept: application/json");
            args.append("Content-Type: application/json");

            Curl.easySetopt(curl, CURLOPT_HTTPHEADER, args);

            //var jsonPayload = '{"foo": "bar"}';
            var jsonPayload = '{"foo": "bar", "foo-two":"bizz"}';
            Curl.easySetopt(curl, CURLOPT_POSTFIELDS, jsonPayload);
            Curl.easySetopt(curl, CURLOPT_CUSTOMREQUEST, 'POST');

            writeln("calling perform");

            var ret = Curl.easyPerform(curl);

            writeln("perform returned ", ret);

            args.free();
            Curl.easyCleanup(curl);            
        } else {
            var args = new Curl.slist();
            args.append("Accept: application/json");
            args.append("Content-Type: application/json");

            Curl.setopt(urlwriter, CURLOPT_VERBOSE, true);
            Curl.setopt(urlwriter, CURLOPT_HTTPHEADER, args);
            writeln("The HTTPHEADER ARGS via Curl.slist %t".format(args));
            var jsonPayload = '{"foo": "bar", "foo-two":"bizz"}';
            var payload = 'simple text';
            //Curl.setopt(urlwriter, CURLOPT_POSTFIELDS,payload);
            Curl.setopt(urlwriter, CURLOPT_POSTFIELDS, jsonPayload);
            //Curl.setopt(urlwriter, CURLOPT_WRITEFUNCTION, c_ptrTo(curl_write_string):c_void_ptr);
            //Curl.setopt(urlwriter, CURLOPT_WRITEDATA, jsonPayload);
            Curl.setopt(urlwriter, CURLOPT_CUSTOMREQUEST, 'POST');
            urlwriter.write(jsonPayload.size);
            //urlwriter.write(payload.size);
        }

        //urlwriter.flush();
        //urlwriter.close();
        try! writeln("Completed simpleWrite");
    }

    proc curl_write_string(contents: c_void_ptr, size:size_t, nmemb:size_t, userp: c_void_ptr) {
      var realsize:size_t = size * nmemb;
      var bufptr = userp:c_ptr(curl_str_buf);
      ref buf = bufptr.deref();
      try! writeln('In curl_write_string %t'.format(buf));
      if buf.len + realsize < buf.alloced {
        // OK
      } else {
        var newsize = 2 * buf.alloced + realsize;
        var oldsize = buf.len;
        var newbuf:c_ptr(uint(8));
        newbuf = c_calloc(uint(8), newsize);
        if newbuf == nil then
          return 0;
        c_memcpy(newbuf, buf.mem, oldsize);
        c_free(buf.mem);
        buf.mem = newbuf;
      }

      c_memcpy(c_ptrTo(buf.mem[buf.len]), contents, realsize);
      buf.len += realsize;
      buf.mem[buf.len] = 0;

      return realsize;
    }
    
    record curl_str_buf {
      var mem:c_ptr(uint(8));
      var len: size_t;
      var alloced: size_t;
    }

    proc main() {
        try {
            write();
        } catch e : Error{
            try! writeln(e);
        }
    }
}
