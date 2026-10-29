module path {
    export def ancestors [
        --no-symlink(-n) = true # Do not resolve symbolic links.
    ]: string -> list<string> {
        let path = $in | path expand -n
        let init_dir = match ($path | path type) {
            null => { return [] }
            'file' => ($path | path dirname)
            _ => $path
        }

        $init_dir | path split | generate {|part, prev_path|
            let joined_path = $prev_path | path join $part
            {out: $joined_path, next: $joined_path}
        } ''
    }
}

export use path
