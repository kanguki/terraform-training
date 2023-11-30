locals {
  services_by_env = {
    dev = {
      nodered = {
        image_in         = "nodered/node-red:latest"
        count_in         = 1
        internal_data_in = "/data"
        internal_port_in = 1880
      }
      influxdb = {
        image_in         = "quay.io/influxdb/influxdb:v2.0.2"
        count_in         = 1
        internal_data_in = "/var/lib/influxdb"
        internal_port_in = 8086
      }
      grafana = {
        image_in = "grafana/grafana:latest"
        count_in         = 1
        internal_data_in = "/var/lib/grafana"
        internal_port_in = 3000
      }
    }
    prod = {
      nodered = {
        image_in         = "nodered/node-red:latest-minimal"
        count_in         = 2
        internal_data_in = "/data"
        internal_port_in = 1880
      }
      influxdb = {
        image_in         = "quay.io/influxdb/influxdb:v2.0.2"
        count_in         = 1
        internal_data_in = "/var/lib/influxdb"
        internal_port_in = 8086
      }
      grafana = {
        image_in = "grafana/grafana:latest"
        count_in         = 1
        internal_data_in = "/var/lib/grafana"
        internal_port_in = 3000
      }
    }
  }
  env      = terraform.workspace
  services = local.services_by_env[local.env]
}