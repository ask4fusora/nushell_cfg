# The `diroverlay:` overlay-name prefix is reserved in order for this module to work.

use modules/path

const diroverlay_prefix = 'diroverlay:'
const diroverlay_file_name = 'overlay.nu'
const diroverlay_hook_annotation = 'is_diroverlay_hook'

def diroverlay-files []: string -> list<string> {
    path ancestors | each { path join $diroverlay_file_name } | where { path exists }
}

def diroverlay-name []: string -> string {
    $diroverlay_prefix + $in
}

def "to diroverlay-hook" []: oneof<string, closure> -> record {
    {code: $in} | insert $diroverlay_hook_annotation true
}

def diroverlay-cleanup-hook []: nothing -> record {
    {
        $env.config.hooks.pre_prompt = $env.config.hooks.pre_prompt
        | where not ($it | get -o $diroverlay_hook_annotation)
    }
    | to diroverlay-hook
}

def diroverlay-zero-hook []: nothing -> record {
    'overlay use zero' | to diroverlay-hook
}

export def --env sync [cwd?: directory, --reload(-r)]: nothing -> nothing {
    let overlay_root = if $cwd == null { $env.PWD } else { $cwd }
    let active_diroverlay_names = (
        overlay list
        | where active
        | get name
        | where ($it | str starts-with $diroverlay_prefix)
    )
    let overlay_files_to_activate = $overlay_root | diroverlay-files
    let overlay_names_to_activate = (
        $overlay_files_to_activate | each { diroverlay-name }
    )
    let overlay_names_to_hide = (
        $active_diroverlay_names | difference $overlay_names_to_activate
    )
    let overlay_hide_hooks = (
        $overlay_names_to_hide
        | each {
            $"overlay hide '($in)'" | to diroverlay-hook
        }
    )
    let overlay_use_hooks = (
        $overlay_files_to_activate
        | zip $overlay_names_to_activate
        | each {
            $"overlay use --reload=($reload) '($in.0)' as '($in.1)'" | to diroverlay-hook
        }
    )

    $env.config.hooks.pre_prompt = (
        $env.config.hooks.pre_prompt
        | where not ($it | get -o $diroverlay_hook_annotation)
        | append $overlay_hide_hooks
        | append $overlay_use_hooks
        | append (diroverlay-zero-hook)
        | append (diroverlay-cleanup-hook)
    )
}

export-env {
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD?
        | default []
        | append {|_, cwd| sync $cwd }
    )
}
