export-env {
    require-executable starship

    load-env {
        STARSHIP_CONFIG: (
            $nu.config-path
            | path dirname
            | path join scripts modules starship starship.toml
        )
        STARSHIP_SHELL: "nu"
        STARSHIP_SESSION_KEY: (random chars --length=16)

        PROMPT_MULTILINE_INDICATOR: $"(ansi white_dimmed)· "

        PROMPT_INDICATOR_VI_INSERT: {||
            let user_style = if (is-admin) {
                ansi red
            } else {
                ansi magenta_dimmed
            }

            $"($user_style)runs(ansi reset) "
        }

        PROMPT_INDICATOR_VI_NORMAL: {||
            let user_style = if (is-admin) {
                ansi red
            } else {
                ansi magenta_dimmed
            }

            $"($user_style)prompts(ansi reset) "
        }

        PROMPT_COMMAND: "",
        PROMPT_COMMAND_RIGHT: {||
            ^starship prompt --right --terminal-width=(term size | get columns)
        }
    }
}
