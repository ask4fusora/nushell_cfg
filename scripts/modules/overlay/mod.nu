# The `diroverlay:` overlay-name prefix is reserved in order for this module to work.
# To use an overlay, is to use a module. Specifically, this module is wildcard
# imported. This is equivalent to `use overlay.nu *`.

module overlay {
    module diroverlay {
        use modules/path *

        const overlay_name_prefix = 'diroverlay:'
        const overlay_file_name = 'overlay.nu'
        const hook_annotation = 'is_diroverlay_hook'

        export def "to hook" []: oneof<string, closure> -> record {
            {code: $in} | insert $hook_annotation true
        }

        export def is-diroverlay []: record<name: string, active: bool> -> bool {
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
        let diroverlay_root = $root | default $env.PWD
        let active_diroverlays = (
            overlay list
            | where active
            | where ($it | diroverlay is-diroverlay)
        )
        let diroverlays_to_ensure_activated = (
            $diroverlay_root
            | diroverlay files
            | zip $in
            | into record
            | transpose file name
            | update name { diroverlay name }
        )
        let diroverlay_names_to_hide = (
            $active_diroverlays
            | get name
            | difference $diroverlays_to_ensure_activated.name
        )
        let overlay_hide_hooks = (
            $diroverlay_names_to_hide
            | each {
                $"overlay hide '($in)'" | diroverlay to hook
            }
        )
        let overlay_use_hooks = (
            $diroverlays_to_ensure_activated
            | if $reload { $in } else {
                where name not-in $active_diroverlays.name
            }
            | each {
                $"overlay use --reload=($reload) '($in.file)' as '($in.name)'"
                | diroverlay to hook
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
