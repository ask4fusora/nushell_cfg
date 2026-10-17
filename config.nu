$env.config.show_banner = false

$env.config.edit_mode = "vi"
$env.config.cursor_shape = {vi_insert: line, vi_normal: block}

$env.config.shell_integration.osc7 = true

$env.config.max_last_result_size = 500MB

$env.config.completions.algorithm = "Fuzzy"

$env.config.history.file_format = "Sqlite"

use modules/utils *
use modules/fzf
use modules/cloudflared
use modules/from
use modules/env *
use modules/aichat *
use modules/zoxide *
use modules/yazi *
use modules/gh-cli *
use modules/os *
use modules/sys *
use modules/admin *
use modules/uv-python *
use nu-scripts/custom-completions/uv/uv-completions.nu *
use modules/zed *
use modules/starship *
use nu-scripts/custom-completions/scoop/scoop-completions.nu *
use nu-scripts/custom-completions/winget/winget-completions.nu *
use nu-scripts/custom-completions/typst/typst-completions.nu *
use nu-scripts/custom-completions/podman/podman-completions.nu *
use nu-scripts/custom-completions/ssh/ssh-completions.nu *
use nu-scripts/custom-completions/rg/rg-completions.nu *
use nu-scripts/custom-completions/op/op-completions.nu *
use nu-scripts/custom-completions/bat/bat-completions.nu *
