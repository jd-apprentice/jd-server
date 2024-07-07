resource "cloudflare_zone" "tfer--jonathan-002E-com-002E-ar" {
  paused = "false"
  plan   = "free"
  type   = "full"
  zone   = "jonathan.com.ar"
}
