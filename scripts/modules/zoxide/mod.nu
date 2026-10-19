use modules/assert *

export def --env --wrapped z [...rest: directory]: nothing -> nothing {
    assert binary exists zoxide

    let path = match $rest {
        [] => { "~" }
        ["-"] => { "-" }
        [$arg] => {
            let path_type = try {
                $arg | path expand -s | path type
            } catch { null }

            if $path_type == "dir" { $arg } else {
                ^zoxide query --exclude=($env.PWD) -- $arg | str trim -r -c "\n"
            }
        }
        _ => {
            ^zoxide query --exclude=($env.PWD) -- ...$rest | str trim -r -c "\n"
        }
    }

    cd $path
}

export def --env --wrapped zi [...rest: directory]: nothing -> nothing {
    assert binary exists zoxide
    cd $'(^zoxide query --exclude=($env.PWD) --interactive -- ...$rest | str trim -r -c "\n")'
}

export-env {
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD?
        | default []
        | append {|_, cwd|
            assert binary exists zoxide
            ^zoxide add -- $cwd
        }
    )
}
