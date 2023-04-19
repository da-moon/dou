#!/usr/bin/env python3
# vim: filetype=python syntax=python softtabstop=4 tabstop=4 shiftwidth=4 fileencoding=utf-8 expandtab
# code: language=python insertSpaces=true tabSize=4

from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.network import Nginx,Envoy
from diagrams.onprem.container import LXC
from diagrams.onprem.security import Vault
from diagrams.onprem.client import User
from diagrams.aws.compute import EC2
from diagrams.generic.virtualization import Vmware
from random import getrandbits
from ipaddress import IPv4Network, IPv4Address
import petname
graph_attr = {
    "bgcolor": "transparent",
    "dpi": "192"
}
us_east_subnet = IPv4Network("52.23.63.224/27")
us_west_subnet = IPv4Network("54.70.204.128/27")
lxd_subnet= IPv4Network("10.9.169.128/28")
with Diagram("",show=False,graph_attr=graph_attr):
    with Cluster():
        infra={
            "us-east-1":str(IPv4Address(us_east_subnet.network_address + getrandbits(us_east_subnet.max_prefixlen - us_east_subnet.prefixlen))),
            "us-west-2":str(IPv4Address(us_west_subnet.network_address + getrandbits(us_west_subnet.max_prefixlen - us_west_subnet.prefixlen))),
        }
        lxd_nodes=[]
        vault_ingress=[]
        for cluster_name,lb_ip in infra.items():
            with Cluster(cluster_name):
                machine_type=EC2()
                vault_agents=[]
                dc_vault_lxd_nodes=[]
                dc_ingress_nodes=[]
                with Cluster("Vault DC") as vault_dc :
                    # ─── INGRESS LXD NODE ────────────────────────────────────────────
                    name="vault"
                    with Cluster(f"{petname.Generate()}") :
                        node=LXC(str(IPv4Address(lxd_subnet.network_address + getrandbits(lxd_subnet.max_prefixlen - lxd_subnet.prefixlen))))
                        with Cluster("") :
                            ingress = Nginx("LXD-ingress")
                            vault_ingress.append(ingress)
                        dc_ingress_nodes.append(node)

                    # ─────────────────────────────────────────────────────────────────
                    nodes={
                        f"{petname.Generate()}":str(IPv4Address(lxd_subnet.network_address + getrandbits(lxd_subnet.max_prefixlen - lxd_subnet.prefixlen))),
                        f"{petname.Generate()}":str(IPv4Address(lxd_subnet.network_address + getrandbits(lxd_subnet.max_prefixlen - lxd_subnet.prefixlen))),
                        f"{petname.Generate()}":str(IPv4Address(lxd_subnet.network_address + getrandbits(lxd_subnet.max_prefixlen - lxd_subnet.prefixlen))),
                    }
                    node_idx = 0
                    # ─── LXD DATA PLANE ──────────────────────────────────────────────
                    for i in range(0,len(vault_agents)) :
                        first = (i + 1) % len(vault_agents)
                        second = (i - 1) % len(vault_agents)
                        label=""
                        vault_agents[first] \
                            >> Edge(color="magenta",style="dashed",label=label) << \
                        vault_agents[second]
                # ─── LXD NODE AGGREGATION ────────────────────────────────────────
                lxd_nodes.extend(dc_vault_lxd_nodes)
                lxd_nodes.extend(dc_ingress_nodes)
        for i in range(0,len(lxd_nodes)) :
            first = (i + 1) % len(lxd_nodes)
            second = (i - 1) % len(lxd_nodes)
            # print(f"first {first}")
            # print(f"second {second}")
            label=""
            # if abs(first-second) == len(lxd_nodes) -1 :
                # label="LXD Control Plane"

            lxd_nodes[first] >> Edge(color="firebrick",style="dashed") << lxd_nodes[second]
        from diagrams.custom import Custom
        datacenter_vault_ingress = Envoy("Datacenter Vault Ingress")
        # datacenter_vault_ingress - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - consul_ingress
        User("Vault Client") >> Edge(color="darkblue",style="bold") <<   datacenter_vault_ingress  >> Edge(color="darkmagenta",style="bold") << vault_ingress
