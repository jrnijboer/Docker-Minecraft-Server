datacenter = "mydc"
data_dir = "/var/lib/nomad"
bind_addr = "0.0.0.0"

server {
  enabled = true
  bootstrap_expect = 1
  encrypt = "somesecretvalue"
  raft_protocol = 3
}

client {
  enabled       = true
  network_speed = 100
}

tls {
  http = true
  rpc  = true

  ca_file   = "/etc/nomad.d/tls/nomad-ca.pem"
  cert_file = "/etc/nomad.d/tls/nomad-server.pem"
  key_file  = "/etc/nomad.d/tls/nomad-server-key.pem"

  verify_server_hostname = true
  verify_https_client    = true
}

client {
  host_volume "world-minecraft-vanilla" {
    path = "/var/nomad-volume/minecraft-vanilla/world"
    read_only = false
  }

  host_volume "config-minecraft-vanilla" {
    path = "/var/nomad-volume/minecraft-vanilla/config"
    read_only = false
  }
}
