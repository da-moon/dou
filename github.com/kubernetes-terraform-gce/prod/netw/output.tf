output "network_id"             { value = "${module.node-network.network_id}" }
output "network_self_link"      { value = "${module.node-network.network_self_link}" }

output "allow_tcp_fw_id"        { value = "${module.allow-tcp-fw.allow_tcp_fw_id}" }
output "allow_tcp_fw_self_link" { value = "${module.allow-tcp-fw.allow_tcp_fw_self_link}" }
