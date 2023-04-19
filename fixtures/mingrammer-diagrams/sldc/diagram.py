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
    "bgcolor": "transparent",
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
    packaging_cluster = Cluster(
        "Packaging", graph_attr={"fontsize": "30"}, direction="LR")
    with packaging_cluster:
        config = Custom("\n  configuration \nartifacts", icons["config"]["icon"])
        package = Custom("\nbinaries", icons["package"]["icon"])
        with Cluster("Tooling", direction="LR"):
            runner_packaging = Pipelines("\nRunner")
            packer = Custom("\nBuilder", icons["packer"]["icon"])
            ansible=Ansible("\nProvisioner")
            runner_packaging >> packer >> ansible
        # runner_packaging - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - config
        # runner_packaging - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - package
        config - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - package
    provision_cluster = Cluster(
        "Provision", graph_attr={"fontsize": "30"}, direction="LR")
    with provision_cluster:
        azure = Custom("\n\n  Infrastructure  \nOn\nAzure", icons["azure"]["icon"])
        with Cluster("Tooling", graph_attr={"fontsize": "20"}, direction="LR"):
            runner_provision = Pipelines("\nRunner")
            provisioner_tf=Terraform("\nProvisioner")
            runner_provision >>provisioner_tf
    deploy_and_configure_cluster = Cluster(
        "Deploy and Configure", graph_attr={"fontsize": "30"}, direction="LR")
    with deploy_and_configure_cluster:
        vault = Vault("\nVault Cluster")
        with Cluster("Tooling", graph_attr={"fontsize": "20"}, direction="LR"):
            runner_deploy = Pipelines("\nRunner")
            configurer_tf = Terraform("\nConfigurer")
            runner_deploy >> configurer_tf
    integration_and_api_tests_cluster = Cluster(
        "Integration And API tests", graph_attr={"fontsize": "30"}, direction="LR")
    with integration_and_api_tests_cluster:
        with Cluster("API Tests", graph_attr={"fontsize": "25"}, direction="LR"):
            with Cluster("Tooling", graph_attr={"fontsize": "20"}, direction="TB"):

                runner_k6 = Pipelines("\nRunner")
                k6 = Custom("\nK6 Runtime", icons["k6"]["icon"])
                js = Javascript("\nTest Cases")
                runner_k6 >> k6 >> js
            api=Vault("\nVault API")
        with Cluster("Unit Test", graph_attr={"fontsize": "25"}, direction="LR"):
            with Cluster("Tooling", graph_attr={"fontsize": "20"}, direction="TB"):
                gruntwork = Custom("\n  Terragrunt\n SDK",
                                   icons["gruntwork"]["icon"])
                go = Go("\nToolchain")
                runner_go = Pipelines("\nRunner")
                runner_go >> go >> gruntwork
            iac=Terraform("\n\n\n  Infrastructure\nas\nCode")
    # ─────────────────────────────────────────────────────────────────
    ansible >> Edge(minlen="2", ltail="cluster_Packaging",
                   lhead="cluster_Provision") >> runner_provision
    provisioner_tf >> Edge(minlen="2", ltail="cluster_Provision",
                  lhead="cluster_Deploy and Configure") >> runner_deploy
    configurer_tf >> Edge(minlen="2", ltail="cluster_Deploy and Configure",
                  lhead="cluster_Integration And API tests") >> runner_k6
    js - Edge(minlen="2",penwidth="0.0", ltail="cluster_API Tests",
                  lhead="cluster_Unit Test") - iac


    # js - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - iac
    # vault - Edge(penwidth="0.0") - Custom("","transparent.png") - Edge(penwidth="0.0") - gruntwork
