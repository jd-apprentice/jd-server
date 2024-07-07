resource "cloudflare_filter" "tfer--jonathan-002E-com-002E-ar_39eb2396835647e6ba854710c8a80104" {
  expression = "not cf.edge.server_port in {80 443}"
  paused     = "false"
  zone_id    = "4061473c4743ef8753f7df7741ba7c4a"
}

resource "cloudflare_filter" "tfer--jonathan-002E-com-002E-ar_6700026523d64b11aaaa7cce8024e953" {
  expression = "(cf.verified_bot_category eq \"AI Crawler\")"
  paused     = "false"
  zone_id    = "4061473c4743ef8753f7df7741ba7c4a"
}

resource "cloudflare_filter" "tfer--jonathan-002E-com-002E-ar_95b96d1b2ce1477bb48c2906ee7530c1" {
  expression = "(not ip.geoip.country in {\"AR\"} and http.request.full_uri contains \"https://notes.jonathan.com.ar\") or (http.request.full_uri contains \"https://mari.jonathan.com.ar\")"
  paused     = "false"
  zone_id    = "4061473c4743ef8753f7df7741ba7c4a"
}

resource "cloudflare_filter" "tfer--jonathan-002E-com-002E-ar_adb21d583c4643e5a10830f5f318efe7" {
  expression = "(http.request.uri.path contains \"wp-\") or (http.request.uri.path contains \".php\") or (http.request.uri.path contains \".xml\" and not http.request.uri contains \"/rss.xml\")"
  paused     = "false"
  zone_id    = "4061473c4743ef8753f7df7741ba7c4a"
}
