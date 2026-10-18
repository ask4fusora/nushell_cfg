use modules/ansi

const ansi_text = ansi magenta_dimmed
const ansi_admin_left_prompt = ansi red_dimmed
const ansi_multiline_indicator = ansi white_dimmed

export-env {
    let ansi_number = ansi $env.config.color_config.shape_int
    let ansi_left_prompt = if (is-admin) { $ansi_admin_left_prompt } else { $ansi_text }

    load-env {
        STARSHIP_CONFIG: (
            $nu.default-config-dir
            | path join scripts modules starship starship.toml
        ),
        STARSHIP_SHELL: "nu",
        STARSHIP_SESSION_KEY: (random chars --length=16),

        PROMPT_MULTILINE_INDICATOR: ('· ' | ansi apply $ansi_multiline_indicator),
        PROMPT_INDICATOR_VI_INSERT: '',
        PROMPT_INDICATOR_VI_NORMAL: '',
        PROMPT_COMMAND: ($'(char nl)runs ' | ansi apply $ansi_left_prompt),
        PROMPT_COMMAND_RIGHT: {
            assert binary exists starship

            let active_overlay_count = overlay list | where active | length
            let prompts = [
                $'('overlays' | ansi apply $ansi_text) ($active_overlay_count | into string | ansi apply $ansi_number)'
                (^starship prompt --right --terminal-width=(term size | get columns))
            ]

            $prompts | str join (char space)
        }
    }
}
