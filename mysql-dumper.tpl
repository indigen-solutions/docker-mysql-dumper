{{/*Foreach container*/}}
{{ range $container, $ }}
    {{/*Only work on containers that have a MYSQL_DUMPER evironment var set.*/}}
    {{if contains $container.Env "MYSQL_DUMPER"}}
        {{ $port := or $container.Env.MYSQL_DUMPER_PORT "3306"}}
        verbose "Found container [{{$container.Name}}].";
        {{ $addresses := where $container.Addresses "Port" $port}}
        {{/* If the container expose a valid port.*/}}
        {{ with $address := index $addresses 0 }}
            {{/*Loop throught all database*/}}
            {{range $database, split $container.Env.MYSQL_DUMPER  ","}}
                {{$user := or $container.Env.MYSQL_DUMPER_USER "root"}}
                {{$password := or $container.Env.MYSQL_DUMPER_PASSWORD $container.Env.MYSQL_ROOT_PASSWORD ""}}
                {{$ip := $address.IP}}
                {{$options := or $container.Env.MYSQL_DUMPER_OPTIONS ""}}
                log "Dumping {{$container.Name}}.{{$database}} ...";
                verbose "Using port [{{$port}}] with user [{{$user}}] and options [{{$options}}]";
                mysqldump -h '{{$ip}}'
                    -u '{{$user}}'
                    {{if $password }}'-p{{$password}}'{{end}}
                    {{$options}}
                    '{{$database}}'
                | gzip > './{{$container.Name}}.{{$database}}.sql.gz';
                log "Dumping {{$container.Name}}.{{$database}} success.";
            {{end}}
        {{else}}
           verbose "The port [{{$port}}] was not found on [{{$container.Name}}].";
        {{end}}
    {{end}}
{{end}}
