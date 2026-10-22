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
                        if ($after | describe) != 'string' { return }

                        let convert_fn = (
                            $env.ENV_CONVERSIONS
                            | get -o $key
                            | get -o from_string
                        )
                        if $convert_fn == null { return }

                        load-env {
                            ($key): ($after | do --env $convert_fn $after) # Support both piping and positional.
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
            from_string: {|s|
                print 'converted'
                $s | path expand -s
            }
        }
    }
}
