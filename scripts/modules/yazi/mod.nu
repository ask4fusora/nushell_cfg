use modules/assert *

export def --wrapped ya [...args: string]: nothing -> nothing {
    assert binary exists yazi
    ^yazi ...$args
}

export def --env --wrapped y [...args: string]: nothing -> nothing {
    assert binary exists yazi

    let temp_file = mktemp -t "yazi_cwd.XXXXXX"
    ^yazi ...$args --cwd-file=($temp_file)
    let cwd = open $temp_file
    if $cwd != $env.PWD and ($cwd | path exists) { cd $cwd }
    rm -fp $temp_file
}
