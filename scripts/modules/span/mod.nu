module span {
    export def combine [a: record<start: int, end: int>, b: record<start: int, end: int>]: nothing -> record<start: int, end: int> {
        {
            start: ([$a.start $b.start] | math min)
            end: ([$a.end $b.end] | math max)
        }
    }
}

export use span
