module cloudflared {
    export def "tunnel dns delete" [
        --origincert: oneof<string, nothing> # The account certificate file path for one of your zones.
    ]: nothing -> record {
        let cert_path = (
            $origincert
            # See https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/configure-tunnels/run-parameters/#origincert.
            | default $env.TUNNEL_ORIGIN_CERT?
            | default ($nu.home-dir | path join ".cloudflared" "cert.pem")
        )
        if not ($cert_path | path exists) {
            error make --unspanned {
                msg: 'No Cloudflare Tunnel certificate found for current host.'
                help: $'Verify that you are logged in and the certificate file exists at `($cert_path)`.'
            }
        }

        let credentials = (
            open --raw $cert_path
            | lines
            | skip until {|line| $line == "-----BEGIN ARGO TUNNEL TOKEN-----" }
            | skip 1
            | take until {|line| $line == "-----END ARGO TUNNEL TOKEN-----" }
            | str join
            | decode base64
            | decode
            | from json
        )

        let headers = {Authorization: $"Bearer ($credentials.apiToken)"}

        let dns_url_record = {
            scheme: 'https'
            host: 'api.cloudflare.com'
            path: $'/client/v4/zones/($credentials.zoneID)/dns_records'
        }

        let cname_query = {type: CNAME, per_page: 5000} | url build-query
        let cname_url_record = $dns_url_record | merge {query: $cname_query}

        let cname_dns_records = (
            http get --headers=$headers ($cname_url_record | url join)
            | get result
            | where content =~ '\.cfargotunnel\.com\.?$'
        )
        if ($cname_dns_records | is-empty) {
            error make --unspanned {msg: "No Cloudflare Tunnel DNS record found."}
        }

        let selected_dns_record = $cname_dns_records | input list -f
        if $selected_dns_record == null {
            error make --unspanned {msg: "No DNS record chosen.", help: "Choose a DNS record to delete."}
        }

        let response = (
            http delete
            --headers=$headers
            (
                $dns_url_record
                | update path {|rec| $rec.path + $'/($selected_dns_record.id)' }
                | url join
            )
        )

        $response | merge deep {result: {name: $selected_dns_record.name}}
    }
}

export use cloudflared
