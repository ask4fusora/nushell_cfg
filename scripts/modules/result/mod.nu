# TODO: use `export type Result` on 0.117.0.
module result {
    export def ok []: any -> record<ok: bool, result: any> {
        {ok: true, result: $in}
    }

    export def err []: any -> record<ok: bool, result: any> {
        {ok: false, result: $in}
    }
}

export use result
