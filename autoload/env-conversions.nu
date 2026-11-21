use modules/env-conversion *

$env.ENV_CONVERSIONS = {
    CWD: {
        from_string: { path expand -s }
    }

    EDITOR: {
        from_string: { split row -r '\s+' }
        to_string: { str join (char space) }
    }
}
