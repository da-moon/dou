#!/usr/bin/env python3
# vim: filetype=python syntax=python softtabstop=4 tabstop=4 shiftwidth=4 fileencoding=utf-8 expandtab
# code: language=python insertSpaces=true tabSize=4
import os
import json
from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.security import Vault
from diagrams.onprem.client import User
from diagrams.azure.compute import AvailabilitySets,VM
from diagrams.azure.general import Resourcegroups
from diagrams.azure.network import LoadBalancers,VirtualNetworks
from diagrams.custom import Custom
from diagrams.azure.security import KeyVaults
from urllib.request import urlretrieve
from random import getrandbits
from ipaddress import IPv4Network, IPv4Address
import petname

# Loading Icons
dirname = os.path.dirname(__file__)
icons_json_path = os.path.abspath('../../icons.json')
with open(icons_json_path, "r") as fd:
    icons = json.load(fd)
for k in icons:
    i = icons[k]
    icon_file_path = os.path.abspath(
        os.path.join(
          os.path.dirname(icons_json_path),
          i["icon"]
        )
    )
    icons[k]["icon"]=icon_file_path
    if i["url"] is not None and not os.path.isfile(icon_file_path):
        urlretrieve(i["url"], icon_file_path)

graph_attr = {
    "bgcolor": "transparent",
    "dpi": "192"
}
central_us_subnet = IPv4Network("10.216.0.0/24")
east_us_2_subnet = IPv4Network("10.219.0.0/24")
cluster_node_count=5
with Diagram("",show=False,graph_attr=graph_attr,direction="LR"):
    vault_operator=User("Vault Operator")
    with Cluster("On-Demand Jumpbox") :
        jb=Custom("", icons["azure-bastion"]["icon"])
        vault_operator >> Edge(color="darkblue",style="bold") <<   jb

    with Cluster("Staging"):

        Resourcegroups()
        infra={
            "Central-US":"Primary",
            "EAST-US-2": "DR",
        }
        vm_pool={}
        virtual_networks=[]
        vault_client=User("Vault Client")
        for cluster_region,cluster_type in infra.items():
            nodes={}
            with Cluster(cluster_region):
                keyvault = KeyVaults("Trusted Secret Store")
                availablityset_nodes=[]
                node_subnet=central_us_subnet
                if cluster_region == "EAST-US-2":
                    node_subnet=east_us_2_subnet
                with Cluster("Vnet"):
                    virtual_networks.append(VirtualNetworks())
                    with Cluster("scale-set"):
                        AvailabilitySets(cluster_type)
                        name="vault"
                        # ─────────────────────────────────────────────────────────────────
                        for count in range(0,cluster_node_count):
                            nodes[petname.Generate()] = str(IPv4Address(node_subnet.network_address + getrandbits(node_subnet.max_prefixlen - node_subnet.prefixlen)))
                        node_idx = 1
                        for node_name, ip in nodes.items():
                            with Cluster(node_name) :
                                node=VM(ip)
                                with Cluster("") :
                                    agent = Vault(f"{name}-{node_idx}")
                                availablityset_nodes.append(node)
                            node_idx+=1
                        # if cluster_type == "Primary":
                        vault_ingress = LoadBalancers("Vault Ingress Load Balancer")
                        for i in availablityset_nodes :
                            i >> Edge(color="firebrick",style="dashed") << vault_ingress
                        for i in availablityset_nodes :
                            i >> Edge(color="darkgreen",style="dashed") << keyvault
                        vault_client >> Edge(color="darkblue",style="bold") <<   vault_ingress
            vm_pool[cluster_type]=availablityset_nodes
            jb >> Edge(color="firebrick",style="bold") << availablityset_nodes

        vm_list=[]
        for cluster_type,regional_vm_list in vm_pool.items():
            vm_list.extend(regional_vm_list)
        for i in range(0,len(vm_list)) :
            first = (i + 1) % len(vm_list)
            second = (i - 1) % len(vm_list)
            vm_list[first] >> Edge(color="firebrick",style="dashed") << vm_list[second]
        # virtual_networks[0] >> Edge(color="green",style="bold",label="VNet Peering") << virtual_networks[1]
        # from diagrams.custom import Custom
        # # datacenter_vault_ingress - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - consul_ingress
