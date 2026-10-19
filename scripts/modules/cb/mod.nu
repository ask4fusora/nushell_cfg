# Clipboard module.

use modules/span
use modules/assert

module ext {
    export def cb [
        --input(-i) # Input mode.
        --output(-o) # Output mode.
        --help(-h) # Display help for this command.
    ]: [nothing -> string, string -> nothing] {
        if $input and $output or not ($input or $output) {
            error make {
                msg: 'Invalid flags.'
                help: 'Choose either input mode or output mode.'
                labels: [
                    {
                        text: 'either input mode or output mode can be chosen'
                        span: (
                            span combine (metadata $input).span (metadata $output).span
                        )
                    }
                ]
            }
        }

        let pipeline_input = $in

        if $input and $pipeline_input == null {
            error make {
                code: 'nu::shell::pipeline_mismatch'
                msg: 'Pipeline empty.'
                labels: [
                    {
                        text: 'input mode requires value to be piped in'
                        span: (metadata $help).span
                    }
                ]
            }
        }

        if $output and $pipeline_input != null {
            let input_type = $pipeline_input | describe
            error make {
                code: 'nu::parser::input_type_mismatch'
                msg: $'Command does not support ($input_type) input.'
                labels: [
                    {
                        text: $"output mode doesn't support ($input_type) input"
                        span: (metadata $help).span
                    }
                ]
            }
        }

        match $nu.os-info.name {
            "windows" => {
                assert binary exists win32yank

                $pipeline_input
                | ^win32yank ...(
                    [
                        (if $input { -i }),
                        (if $output { -o })
                    ]
                    | compact
                )
            }
        }
    }
}

export use ext *
