# The `diroverlay:` overlay-name prefix is reserved in order for this module to work.

module overlay {
    module diroverlay {
        use modules/path *

        const overlay_name_prefix = 'diroverlay:'
        const overlay_file_name = 'overlay.nu'
        const hook_annotation = 'is_diroverlay_hook'

        export def "to hook" []: oneof<string, closure> -> record {
            {code: $in} | insert $hook_annotation true
        }

        export def is-diroverlay []: record -> bool {
            $in | get name | str starts-with $overlay_name_prefix
        }

        export def files []: string -> list<string> {
            path ancestors | each { path join $overlay_file_name } | where { path exists }
        }

        export def name []: string -> string {
            $overlay_name_prefix + $in
        }

        export def cleanup-hook []: nothing -> record {
            {
                $env.config.hooks.pre_prompt = (
                    $env.config.hooks.pre_prompt
                    | where not ($it | get -o $hook_annotation)
                )
            }
            | to hook
        }

        export def zero-hook []: nothing -> record {
            'overlay use zero' | to hook
        }
    }

    use diroverlay

    export def --env sync [root?: directory, --reload(-r)]: nothing -> nothing {
        let sync_root = if $root == null { $env.PWD } else { $root }
        let overlay_files_to_activate = $sync_root | diroverlay files
        let overlay_names_to_activate = (
            $overlay_files_to_activate | each { diroverlay name }
        )
        let overlay_names_to_hide = (
            overlay list
            | where active
            | where ($it | diroverlay is-diroverlay)
            | difference $overlay_names_to_activate
        )
        let overlay_hide_hooks = (
            $overlay_names_to_hide
            | each {
                $"overlay hide '($in)'" | diroverlay to hook
            }
        )
        let overlay_use_hooks = (
            $overlay_files_to_activate
            | zip $overlay_names_to_activate
            | each {
                $"overlay use --reload=($reload) '($in.0)' as '($in.1)'" | diroverlay to hook
            }
        )

        $env.config.hooks.pre_prompt = (
            $env.config.hooks.pre_prompt
            | append $overlay_hide_hooks
            | append $overlay_use_hooks
            | append (diroverlay zero-hook)
            | append (diroverlay cleanup-hook)
        )
    }
}

export use overlay

export-env {
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD?
        | default []
        | append {|_, cwd| overlay sync $cwd }
    )
}
