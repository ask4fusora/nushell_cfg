export-env {
    if $env.GIT_INSTALL_ROOT? != null {
        $env.PATH ++= [
            (
                $env.GIT_INSTALL_ROOT
                | path join 'usr' 'bin'
            )
        ]
    }
}
