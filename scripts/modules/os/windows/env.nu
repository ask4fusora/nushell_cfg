export def --env install-windows-env [] {
    require-executable scoop

    let git_bin = (
        $env.GIT_INSTALL_ROOT
        | path join usr bin
        | path expand -n
    )

    $env.PATH = (
        $env.PATH
        | append [
            $git_bin
        ]
        | uniq
    )
}
