module aichat {
    use modules/assert *

    export def info []: nothing -> record {
        assert binary exists aichat
        ^aichat --info | detect columns --no-headers | transpose --header-row --as-record
    }
}

export use extern.nu *
export use aichat
export use commit-message *

export-env {
    use keybinds.nu *
    keybinds init

    $env.AICHAT_SHELL = which ^nu | get 0.path
}
