export-env {
    $env.config.hooks.env_change.ENV_CONVERSIONS = (
        $env.config.hooks.env_change.ENV_CONVERSIONS?
        | default []
        | append {|before, after|
            let new_keys = ($after | columns) | difference ($before | default {} | columns)
            let env_change_hooks = $env.config.hooks.env_change
            let new_env_change_hooks = (
                $new_keys
                | par-each {|key|
                    let env_conversion_hook = {|before, after|
                        let pending = $env.__ENV_CONVERSION_PENDING? | default {}
                        let expected = $pending | get -o $key

                        $env.__ENV_CONVERSION_PENDING = ($pending | reject -o $key)

                        if $after == $expected { return }

                        if ($after | describe) != 'string' { return }

                        let convert_fn = (
                            $env.ENV_CONVERSIONS
                            | get -o $key
                            | get -o from_string
                        )
                        if $convert_fn == null { return }

                        try {
                            let converted = ($after | do --env $convert_fn $after) # Support both piping and positional.

                            load-env {($key): $converted}

                            if $converted != $after {
                                $env.__ENV_CONVERSION_PENDING = (
                                    $env.__ENV_CONVERSION_PENDING?
                                    | default {}
                                    | upsert $key { $converted }
                                )
                            }
                        } catch {|err|
                            let diagnostic = (
                                $err.details
                                | update msg $'Failed to convert `$env.($key)`: ($err.msg)'
                            )

                            error make $diagnostic
                        }
                    }

                    {
                        ($key): (
                            $env_change_hooks
                            | get -o $key
                            | default []
                            | append $env_conversion_hook
                        )
                    }
                }
                | reduce --fold={} {|env_change_hook_entry, acc|
                    $acc | merge $env_change_hook_entry
                }
            )

            $env.config.hooks.env_change = (
                $env.config.hooks.env_change | merge $new_env_change_hooks
            )
        }
    )

    $env.ENV_CONVERSIONS = {
        CWD: {
            from_string: { path expand -s }
        }
    }
}
