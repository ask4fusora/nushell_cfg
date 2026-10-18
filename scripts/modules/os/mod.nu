export def --wrapped cb [...rest] {
    match $nu.os-info.name {
        "windows" => {
            assert binary exists win32yank
            ^win32yank ...$rest
        }
    }
}
