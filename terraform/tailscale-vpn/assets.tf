# add machine
data "tailscale_device" "agora-router-pve1" {
    hostname = "agora-router-pve1"
}

# disable key expiration 
resource "tailscale_device_key" "machine-1" {
  device_id           = data.tailscale_device.machine-1.id
  key_expiry_disabled = true
}

# subnet router
resource "tailscale_device_subnet_routes" "router-01" {
  device_id = data.tailscale_device.router-01.id
  routes = [
    "10.10.10.0/24",
  ]
}

# ACLs
resource "tailscale_acl" "default" {
  acl = jsonencode({
    acls : [
      {
			action: "accept",
			src: ["group:mygroup"],
			dst: [
				"10.10.10.0/24:*",
			],
		},
		{
			action: "accept",
			src: ["autogroup:owner"],
			dst: ["*:*"],
		},
    ],
  })
}