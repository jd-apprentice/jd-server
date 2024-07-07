resource "cloudflare_firewall_rule" "tfer--jonathan-002E-com-002E-ar_22a0f0b23dc74b7991e7941361036a8e" {
  action      = "block"
  description = "Port"
  filter_id   = "${cloudflare_filter.tfer--jonathan-002E-com-002E-ar_39eb2396835647e6ba854710c8a80104.id}"
  paused      = "false"
  zone_id     = "4061473c4743ef8753f7df7741ba7c4a"
}

resource "cloudflare_firewall_rule" "tfer--jonathan-002E-com-002E-ar_75ed480e1e234467ab3e6e671bf25d3d" {
  action      = "block"
  description = "Argentina"
  filter_id   = "${cloudflare_filter.tfer--jonathan-002E-com-002E-ar_95b96d1b2ce1477bb48c2906ee7530c1.id}"
  paused      = "false"
  zone_id     = "4061473c4743ef8753f7df7741ba7c4a"
}

resource "cloudflare_firewall_rule" "tfer--jonathan-002E-com-002E-ar_b65106d57cee4f7da085886a7b7a17c7" {
  action      = "block"
  description = "Block"
  filter_id   = "${cloudflare_filter.tfer--jonathan-002E-com-002E-ar_adb21d583c4643e5a10830f5f318efe7.id}"
  paused      = "false"
  zone_id     = "4061473c4743ef8753f7df7741ba7c4a"
}

resource "cloudflare_firewall_rule" "tfer--jonathan-002E-com-002E-ar_e4ef2602542b4295ac8b32f4cdd8aa57" {
  action      = "block"
  description = "AI Scrapers and Crawlers rule"
  filter_id   = "${cloudflare_filter.tfer--jonathan-002E-com-002E-ar_6700026523d64b11aaaa7cce8024e953.id}"
  paused      = "false"
  zone_id     = "4061473c4743ef8753f7df7741ba7c4a"
}
