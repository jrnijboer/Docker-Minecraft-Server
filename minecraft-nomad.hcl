job "minecraft" {
    datacenters = ["mydc"]
    group "server" {
        volume "world" {
            type      = "host"
            source    = "world-minecraft-vanilla"
            read_only = false
        }
        volume "config" {
            type      = "host"
            source    = "config-minecraft-vanilla"
            read_only = false
        }
        network {
            port "minecraft" {
                static = 25565
                to = 25565
            }
        }
        task "container" {
            driver = "docker"
            config {
                image = "jrnijboer/minecraft-vanilla:1.16.5"
                ports = ["minecraft"]
            }
            env {
                JAVA_MEMORY = "1200m"
                RCON_PASSWORD = "tfarcenim"
            }
            resources {
                memory = 1500 # MB
            }
            volume_mount {
                volume      = "config"
                destination = "/minecraft/config"
            }
            volume_mount {
                volume      = "world"
                destination = "/minecraft/world"
            }
        }
    }
}

