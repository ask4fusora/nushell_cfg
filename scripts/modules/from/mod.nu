module from {
    # Parse `docker-compose --format=json ...` output and create table.
    export def docker-compose []: string -> table { "[" + $in + "]" | from json }

    # Parse text as .env and create table.
    export def env []: string -> table {
        lines
        | split column '#' # remove comments
        | get column0
        | parse "{key}={value}"
        | update value {
            str trim                      # Trim whitespace between value and inline comments
            | str trim -c '"'             # unquote double-quoted values
            | str trim -c "'"             # unquote single-quoted values
            | str replace -a "\\n" "\n"   # replace `\n` with newline char
            | str replace -a "\\r" "\r"   # replace `\r` with carriage return
            | str replace -a "\\t" "\t"   # replace `\t` with tab
        }
        | transpose -r -d
    }
}

export use from
