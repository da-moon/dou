#!/usr/bin/env python3
# vim: filetype=python syntax=python softtabstop=4 tabstop=4 shiftwidth=4 fileencoding=utf-8 expandtab
# code: language=python insertSpaces=true tabSize=4
import os
import json
from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.security import Vault
from diagrams.onprem.client import User
from diagrams.azure.compute import VMScaleSet,VM
from diagrams.azure.general import Resourcegroups
from diagrams.azure.network import ApplicationGateway,VirtualNetworks
from diagrams.azure.devops import Pipelines
from diagrams.custom import Custom
from diagrams.azure.security import KeyVaults
from diagrams.azure.compute import VM,VMImages
from diagrams.onprem.iac import Ansible
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
with Diagram("",show=False,graph_attr=graph_attr):
    with Cluster(""):
        with Cluster("CI/CD"):
            pipeline=Pipelines()
            with Cluster("Standard Image Builder"):
                packer = Custom("",icons["packer"]["icon"])
                provisioner=Ansible("Provisioner")
                packer >> provisioner
        with Cluster("Standard Image"):
            rg=Resourcegroups()
            vm = VM()
            # packer >> Edge(color="firebrick",style="dashed",label="Manage Lifecycle") >> vm
            provisioner >> Edge(color="green",style="bold",label="Provision") >> vm
            # VirtualNetworks()
        gallery=VMImages()
        vm >> Edge(color="darkblue",style="bold",label="Store") >> gallery
        # pipeline - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - vm
        # pipeline - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - gallery
        # vm - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - gallery
        # pipeline - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - packer
        # pipeline - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - provisioner
