use modules/assert *

export def "bin ls" []: nothing -> table {
    assert binary exists bin
    ^bin ls | str trim | detect columns
}
