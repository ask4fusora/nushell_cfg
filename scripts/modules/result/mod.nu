module result {
    export type Result = record<ok: bool, result: any>

    export def ok []: any -> record<ok: bool, result: any> {
        {ok: true, result: $in}
    }

    export def err []: any -> record<ok: bool, result: any> {
        {ok: false, result: $in}
    }
}

export use result
export use result Result
