use std-rfc/pb

export-env {
    $env.config.hooks.pre_execution ++= [
        { pb indeterminate }
    ]
    $env.config.hooks.pre_prompt ++= [
        { pb clear }
    ]
}
