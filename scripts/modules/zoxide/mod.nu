export-env {
    $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD?
    | default []
    | append {|_, cwd|
        assert binary exists zoxide
        ^zoxide add -- $cwd
    }
}

export def --env --wrapped z [...rest: directory] {
    assert binary exists zoxide

    let path = match $rest {
        [] => { "~" }
        ["-"] => { "-" }
        [$arg] => {
            let path_type = try {
                $arg | path expand | path type
            } catch { null }

            if $path_type == "dir" { $arg } else {
                ^zoxide query --exclude=(pwd) -- $arg | str trim -r -c "\n"
            }
        }
        _ => {
            ^zoxide query --exclude=(pwd) -- ...$rest | str trim -r -c "\n"
        }
    }

    cd $path
}

export def --env --wrapped zi [...rest: directory] {
    assert binary exists zoxide
    cd $'(^zoxide query --exclude=(pwd) --interactive -- ...$rest | str trim -r -c "\n")'
}
