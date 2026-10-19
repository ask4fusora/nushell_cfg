$env.config.show_banner = false

$env.config.edit_mode = "vi"
$env.config.cursor_shape = {vi_insert: line, vi_normal: block}

let env_editor = $env.EDITOR?
if $env_editor != null {
    $env.config.buffer_editor = $env_editor | split row -r '\s+'
}

$env.config.shell_integration.osc7 = true

$env.config.max_last_result_size = 500MB

$env.config.completions.algorithm = "Fuzzy"

$env.config.history.file_format = "Sqlite"

use modules/ansi *
use modules/path *
use modules/fzf
use modules/cloudflared
use modules/from
use modules/starship
use modules/overlay
use modules/zed *
use modules/yazi *
use modules/zoxide *
use modules/admin *
use modules/aichat *
use modules/gh-cli *
use modules/cb *
use modules/uv *
use nu-scripts/custom-completions/git/git-completions.nu *
use nu-scripts/custom-completions/uv/uv-completions.nu *
use nu-scripts/custom-completions/scoop/scoop-completions.nu *
use nu-scripts/custom-completions/winget/winget-completions.nu *
use nu-scripts/custom-completions/typst/typst-completions.nu *
use nu-scripts/custom-completions/podman/podman-completions.nu *
use nu-scripts/custom-completions/ssh/ssh-completions.nu *
use nu-scripts/custom-completions/rg/rg-completions.nu *
use nu-scripts/custom-completions/op/op-completions.nu *
use nu-scripts/custom-completions/bat/bat-completions.nu *
