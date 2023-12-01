locals {
  services_by_env = {
    dev = {
      nodered = {
        image_in         = "nodered/node-red:latest"
        count_in         = 1
        internal_port_in = 1880
        volumes = [
          { vol = "/data", name = "data" },
        ]
      }
      influxdb = {
        image_in         = "quay.io/influxdb/influxdb:v2.0.2"
        count_in         = 1
        internal_port_in = 8086
        volumes = [
          { vol = "/var/lib/influxdb", name = "data" },
        ]
      }
      grafana = {
        image_in         = "grafana/grafana:latest"
        count_in         = 1
        internal_port_in = 3000
        volumes = [
          { vol = "/var/lib/grafana", name = "data" },
          { vol = "/etc/grafana", name = "configuaration" },
        ]
      }
    }
    prod = {
      nodered = {
        image_in         = "nodered/node-red:latest-minimal"
        count_in         = 2
        internal_data_in = "/data"
        internal_port_in = 1880
        volumes = [
          { vol = "/data" },
        ]
      }
      influxdb = {
        image_in         = "quay.io/influxdb/influxdb:v2.0.2"
        count_in         = 1
        internal_port_in = 8086
        volumes = [
          { vol = "/var/lib/influxdb" },
        ]
      }
      grafana = {
        image_in         = "grafana/grafana:latest"
        count_in         = 1
        internal_port_in = 3000
        volumes = [
          { vol = "/var/lib/grafana" },
          { vol = "/etc/grafana" },
        ]
      }
    }
  }
  env      = terraform.workspace
  services = local.services_by_env[local.env]
}