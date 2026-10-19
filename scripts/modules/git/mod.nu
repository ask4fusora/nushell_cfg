# C:\Users\ask4fusora\.local\opt\scoop\apps\git\current\usr\bin\core_perl

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
