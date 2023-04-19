#!/usr/bin/env python3
# vim: filetype=python syntax=python softtabstop=4 tabstop=4 shiftwidth=4 fileencoding=utf-8 expandtab
# code: language=python insertSpaces=true tabSize=4
import os
import json
from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.security import Vault
from diagrams.onprem.client import User
from diagrams.azure.compute import AvailabilitySets, VM
from diagrams.azure.general import Resourcegroups
from diagrams.azure.network import LoadBalancers, VirtualNetworks
from diagrams.onprem.iac import Ansible
from diagrams.custom import Custom
from diagrams.azure.security import KeyVaults
from diagrams.azure.devops import Pipelines
from diagrams.programming.flowchart import StartEnd
from urllib.request import urlretrieve
from random import getrandbits
from ipaddress import IPv4Network, IPv4Address
import petname
from diagrams.onprem.iac import Terraform
from diagrams.programming.language import Go, Javascript
from diagrams.azure.compute import SharedImageGalleries, VMImages, ImageDefinitions, ImageVersions


from diagrams.azure.network import VirtualNetworks
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
    icons[k]["icon"] = icon_file_path
    if i["url"] is not None and not os.path.isfile(icon_file_path):
        urlretrieve(i["url"], icon_file_path)

graph_attr = {
    # "bgcolor": "transparent",
    "layout": "dot",
    "compound": "true",
    "splines": "spline",
    "dpi": "192",
    "fontsize": "60",
    "compund": "True",
    'pad': '0.1',
}
node_attr = {
    "fontsize": "20",
}
edge_attr = {
    "minlen": "2.0",
    "penwidth": "2.0",
    "concentrate": "true"
}
with Diagram("", show=False, graph_attr=graph_attr, edge_attr=edge_attr, node_attr=node_attr, direction="LR"):
    with Cluster("resource group"):
        rg = Resourcegroups("")
        with Cluster("Builder"):
            sp = User("\n Service \nprincipal")
            packer = Custom("", icons["packer"]["icon"])
        with Cluster("Vnet"):
            vnet = VirtualNetworks("")
            with Cluster("Image Gallery"):
                gallery = SharedImageGalleries("")
                with Cluster("Image"):
                    images = VMImages("")
                    # ImageDefinitions("")
                    ImageVersions("")
        # sp - Edge(minlen="2",ltail="cluster_Image",label="CRUD") - images
            sp >> packer >> gallery
            packer >> vnet
