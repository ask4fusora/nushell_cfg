module aichat {
    use modules/assert *

    export def info []: nothing -> record {
        assert binary exists aichat

        $env.AICHAT_SHELL = $nu.current-exe
        ^aichat --info | str trim | lines | split column -r '\s+' key value | transpose --header-row --as-record
    }
}

export use extern.nu *
export use aichat
export use commit-message *

export-env {
    use keybinds.nu *
    keybinds init
}
