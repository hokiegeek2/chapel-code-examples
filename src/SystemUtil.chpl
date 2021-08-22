module SystemUtil {

    proc getEnvVariable(name: string, default: string=""): string {
        extern proc getenv(name : c_string) : c_string;
        var val = getenv(name.localize().c_str()): string;
        if val.isEmpty() { val = ""; }
        return val;
    }

}