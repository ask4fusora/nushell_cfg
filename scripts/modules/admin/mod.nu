use modules/assert *

export def elevate []: nothing -> nothing {
    assert binary exists sudo
    ^sudo nu
}

export def --wrapped sudo [...args]: nothing -> oneof<string, binary> {
    assert binary exists sudo
    let command = $args | str join (char space)
    ^sudo nu -c $command
}
