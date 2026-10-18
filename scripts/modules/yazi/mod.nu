module ext {
    export def --wrapped ya [...args: directory]: nothing -> nothing {
        assert binary exists yazi
        ^yazi ...$args
    }

    export def --env --wrapped y [...args: directory]: nothing -> nothing {
        assert binary exists yazi

        let temp_file = mktemp -t "yazi_cwd.XXXXXX"
        ^yazi ...$args --cwd-file=($temp_file)
        let cwd = open $temp_file
        if $cwd != (pwd) and ($cwd | path exists) { cd $cwd }
        rm -fp $temp_file
    }
}

export use ext *
