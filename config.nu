$env.config.show_banner = false

$env.config.shell_integration.osc7 = true

$env.config.completions.algorithm = "Fuzzy"

$env.config.history.file_format = "Sqlite"

$env.config.max_last_result_size = 500MB

use modules/utils *
use modules/from *
use modules/vi *
use modules/env *
use modules/aichat *
use modules/zoxide *
use modules/yazi *
use modules/gh-cli *
use modules/os *
use modules/sys *
use modules/admin *
use modules/uv-python *
use modules/cloudflared *
use nu-scripts/custom-completions/uv/uv-completions.nu *
use modules/zed *
use modules/starship *
use modules/fzf *
use nu-scripts/custom-completions/scoop/scoop-completions.nu *
use nu-scripts/custom-completions/winget/winget-completions.nu *
use nu-scripts/custom-completions/typst/typst-completions.nu *
use nu-scripts/custom-completions/podman/podman-completions.nu *
use nu-scripts/custom-completions/ssh/ssh-completions.nu *
use nu-scripts/custom-completions/rg/rg-completions.nu *
use nu-scripts/custom-completions/op/op-completions.nu *
use nu-scripts/custom-completions/bat/bat-completions.nu *
