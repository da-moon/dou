# Available parameters and their default values for the Consul chart.

# Holds values that affect multiple components of the chart.
global:
  # The main enabled/disabled setting. If true, servers,
  # clients, Consul DNS and the Consul UI will be enabled. Each component can override
  # this default via its component-specific "enabled" config. If false, no components
  # will be installed by default and per-component opt-in is required, such as by
  # setting `server.enabled` to true.
  enabled: true

  # The default log level to apply to all components which do not otherwise override this setting.
  # It is recommended to generally not set this below "info" unless actively debugging due to logging verbosity.
  # One of "debug", "info", "warn", or "error".
  # @type: string
  logLevel: "info"

  # Enable all component logs to be output in JSON format.
  # @type: boolean
  logJSON: false

  # Set the prefix used for all resources in the Helm chart. If not set,
  # the prefix will be `<helm release name>-consul`.
  # @type: string
  name: null

  # The domain Consul will answer DNS queries for
  # (see `-domain` (https://consul.io/docs/agent/options#_domain)) and the domain services synced from
  # Consul into Kubernetes will have, e.g. `service-name.service.consul`.
  domain: consul

  # The name (and tag) of the Consul Docker image for clients and servers.
  # This can be overridden per component. This should be pinned to a specific
  # version tag, otherwise you may inadvertently upgrade your Consul version.
  #
  # Examples:
  #
  # ```yaml
  # # Consul 1.10.0
  # image: "consul:1.10.0"
  # # Consul Enterprise 1.10.0
  # image: "hashicorp/consul-enterprise:1.10.0-ent"
  # ```
  # @default: hashicorp/consul:<latest version>
  image: "hashicorp/consul:1.10.0"

  # Array of objects containing image pull secret names that will be applied to each service account.
  # This can be used to reference image pull secrets if using a custom consul or consul-k8s-control-plane Docker image.
  # See https://kubernetes.io/docs/concepts/containers/images/#using-a-private-registry for reference.
  #
  # Example:
  #
  # ```yaml
  # imagePullSecrets:
  #   - name: pull-secret-name
  #   - name: pull-secret-name-2
  # ```
  # @type: array<map>
  imagePullSecrets: []

  # The name (and tag) of the consul-k8s-control-plane Docker
  # image that is used for functionality such as catalog sync.
  # This can be overridden per component.
  # @default: hashicorp/consul-k8s-control-plane:<latest version>
  imageK8S: "hashicorp/consul-k8s-control-plane:0.33.0"

  # The name of the datacenter that the agents should
  # register as. This can't be changed once the Consul cluster is up and running
  # since Consul doesn't support an automatic way to change this value currently:
  # https://github.com/hashicorp/consul/issues/1858.
  datacenter: dc1

  # Controls whether pod security policies are created for the Consul components
  # created by this chart. See https://kubernetes.io/docs/concepts/policy/pod-security-policy/.
  enablePodSecurityPolicies: false

  # Configures which Kubernetes secret to retrieve Consul's
  # gossip encryption key from (see `-encrypt` (https://consul.io/docs/agent/options#_encrypt)). If secretName or
  # secretKey are not set, gossip encryption will not be enabled. The secret must
  # be in the same namespace that Consul is installed into.
  #
  # The secret can be created by running:
  #
  # ```shell
  # $ kubectl create secret generic consul-gossip-encryption-key --from-literal=key=$(consul keygen)
  # ```
  #
  # To reference, use:
  #
  # ```yaml
  # global:
  #   gossipEncryption:
  #     secretName: consul-gossip-encryption-key
  #     secretKey: key
  # ```
  gossipEncryption:
    # secretName is the name of the Kubernetes secret that holds the gossip
    # encryption key. The secret must be in the same namespace that Consul is installed into.
    secretName: ""
    # secretKey is the key within the Kubernetes secret that holds the gossip
    # encryption key.
    secretKey: ""

  # A list of addresses of upstream DNS servers that are used to recursively resolve DNS queries.
  # These values are given as `-recursor` flags to Consul servers and clients.
  # See https://www.consul.io/docs/agent/options#_recursor for more details.
  # If this is an empty array (the default), then Consul DNS will only resolve queries for the Consul top level domain (by default `.consul`).
  # @type: array<string>
  recursors: []

  # Enables TLS (https://learn.hashicorp.com/tutorials/consul/tls-encryption-secure)
  # across the cluster to verify authenticity of the Consul servers and clients.
  # Requires Consul v1.4.1+.
  tls:
    # If true, the Helm chart will enable TLS for Consul
    # servers and clients and all consul-k8s-control-plane components, as well as generate certificate
    # authority (optional) and server and client certificates.
    enabled: false

    # If true, turns on the auto-encrypt feature on clients and servers.
    # It also switches consul-k8s-control-plane components to retrieve the CA from the servers
    # via the API. Requires Consul 1.7.1+.
    enableAutoEncrypt: false

    # A list of additional DNS names to set as Subject Alternative Names (SANs)
    # in the server certificate. This is useful when you need to access the
    # Consul server(s) externally, for example, if you're using the UI.
    # @type: array<string>
    serverAdditionalDNSSANs: []

    # A list of additional IP addresses to set as Subject Alternative Names (SANs)
    # in the server certificate. This is useful when you need to access the
    # Consul server(s) externally, for example, if you're using the UI.
    # @type: array<string>
    serverAdditionalIPSANs: []

    # If true, `verify_outgoing`, `verify_server_hostname`,
    # and `verify_incoming_rpc` will be set to `true` for Consul servers and clients.
    # Set this to false to incrementally roll out TLS on an existing Consul cluster.
    # Please see https://consul.io/docs/k8s/operations/tls-on-existing-cluster
    # for more details.
    verify: true

    # If true, the Helm chart will configure Consul to disable the HTTP port on
    # both clients and servers and to only accept HTTPS connections.
    httpsOnly: true

    # A Kubernetes secret containing the certificate of the CA to use for
    # TLS communication within the Consul cluster. If you have generated the CA yourself
    # with the consul CLI, you could use the following command to create the secret
    # in Kubernetes:
    #
    # ```bash
    # kubectl create secret generic consul-ca-cert \
    #     --from-file='tls.crt=./consul-agent-ca.pem'
    # ```
    caCert:
      # The name of the Kubernetes secret.
      secretName: null
      # The key of the Kubernetes secret.
      secretKey: null

    # A Kubernetes secret containing the private key of the CA to use for
    # TLS communication within the Consul cluster. If you have generated the CA yourself
    # with the consul CLI, you could use the following command to create the secret
    # in Kubernetes:
    #
    # ```bash
    # kubectl create secret generic consul-ca-key \
    #     --from-file='tls.key=./consul-agent-ca-key.pem'
    # ```
    #
    # Note that we need the CA key so that we can generate server and client certificates.
    # It is particularly important for the client certificates since they need to have host IPs
    # as Subject Alternative Names. In the future, we may support bringing your own server
    # certificates.
    caKey:
      # The name of the Kubernetes secret.
      secretName: null
      # The key of the Kubernetes secret.
      secretKey: null

  # [Enterprise Only] `enableConsulNamespaces` indicates that you are running
  # Consul Enterprise v1.7+ with a valid Consul Enterprise license and would
  # like to make use of configuration beyond registering everything into
  # the `default` Consul namespace. Additional configuration
  # options are found in the `consulNamespaces` section of both the catalog sync
  # and connect injector.
  enableConsulNamespaces: false

  # Configure ACLs.
  acls:

    # If true, the Helm chart will automatically manage ACL tokens and policies
    # for all Consul and consul-k8s-control-plane components.
    # This requires Consul >= 1.4.
    manageSystemACLs: false

    # A Kubernetes secret containing the bootstrap token to use for
    # creating policies and tokens for all Consul and consul-k8s-control-plane components.
    # If set, we will skip ACL bootstrapping of the servers and will only
    # initialize ACLs for the Consul clients and consul-k8s-control-plane system components.
    bootstrapToken:
      # The name of the Kubernetes secret.
      secretName: null
      # The key of the Kubernetes secret.
      secretKey: null

    # If true, an ACL token will be created that can be used in secondary
    # datacenters for replication. This should only be set to true in the
    # primary datacenter since the replication token must be created from that
    # datacenter.
    # In secondary datacenters, the secret needs to be imported from the primary
    # datacenter and referenced via `global.acls.replicationToken`.
    createReplicationToken: false

    # replicationToken references a secret containing the replication ACL token.
    # This token will be used by secondary datacenters to perform ACL replication
    # and create ACL tokens and policies.
    # This value is ignored if `bootstrapToken` is also set.
    replicationToken:
      # The name of the Kubernetes secret.
      secretName: null
      # The key of the Kubernetes secret.
      secretKey: null

  # Configure federation.
  federation:
    # If enabled, this datacenter will be federation-capable. Only federation
    # via mesh gateways is supported.
    # Mesh gateways and servers will be configured to allow federation.
    # Requires `global.tls.enabled`, `meshGateway.enabled` and `connectInject.enabled`
    # to be true. Requires Consul 1.8+.
    enabled: false

    # If true, the chart will create a Kubernetes secret that can be imported
    # into secondary datacenters so they can federate with this datacenter. The
    # secret contains all the information secondary datacenters need to contact
    # and authenticate with this datacenter. This should only be set to true
    # in your primary datacenter. The secret name is
    # `<global.name>-federation` (if setting `global.name`), otherwise
    # `<helm-release-name>-consul-federation`.
    createFederationSecret: false

  # Configures metrics for Consul service mesh
  metrics:
    # Configures the Helm chart’s components
    # to expose Prometheus metrics for the Consul service mesh. By default
    # this includes gateway metrics and sidecar metrics.
    # @type: boolean
    enabled: false

    # Configures consul agent metrics. Only applicable if
    # `global.metrics.enabled` is true.
    # @type: boolean
    enableAgentMetrics: false

    # Configures the retention time for metrics in Consul clients and
    # servers. This must be greater than 0 for Consul clients and servers
    # to expose any metrics at all.
    # Only applicable if `global.metrics.enabled` is true.
    # @type: string
    agentMetricsRetentionTime: 1m

    # If true, mesh, terminating, and ingress gateways will expose their
    # Envoy metrics on port `20200` at the `/metrics` path and all gateway pods
    # will have Prometheus scrape annotations. Only applicable if `global.metrics.enabled` is true.
    # @type: boolean
    enableGatewayMetrics: true

  # For connect-injected pods, the consul sidecar is responsible for metrics merging. For ingress/mesh/terminating
  # gateways, it additionally ensures the Consul services are always registered with their local Consul client.
  # @recurse: false
  # @type: map
  consulSidecarContainer:
    resources:
      requests:
        memory: "25Mi"
        cpu: "20m"
      limits:
        memory: "50Mi"
        cpu: "20m"

  # The name (and tag) of the Envoy Docker image used for the
  # connect-injected sidecar proxies and mesh, terminating, and ingress gateways.
  # See https://www.consul.io/docs/connect/proxies/envoy for full compatibility matrix between Consul and Envoy.
  # @default: envoyproxy/envoy-alpine:<latest supported version>
  imageEnvoy: "envoyproxy/envoy-alpine:v1.18.3"

  # Configuration for running this Helm chart on the Red Hat OpenShift platform.
  # This Helm chart currently supports OpenShift v4.x+.
  openshift:
    # If true, the Helm chart will create necessary configuration for running
    # its components on OpenShift.
    enabled: false

# Server, when enabled, configures a server cluster to run. This should
# be disabled if you plan on connecting to a Consul cluster external to
# the Kube cluster.
server:

  # If true, the chart will install all the resources necessary for a
  # Consul server cluster. If you're running Consul externally and want agents
  # within Kubernetes to join that cluster, this should probably be false.
  # @default: global.enabled
  # @type: boolean
  enabled: "-"

  # The name of the Docker image (including any tag) for the containers running
  # Consul server agents.
  # @type: string
  image: null

  # The number of server agents to run. This determines the fault tolerance of
  # the cluster. Please see the deployment table (https://consul.io/docs/internals/consensus#deployment-table)
  # for more information.
  replicas: 1 

  # The number of servers that are expected to be running.
  # It defaults to server.replicas.
  # In most cases the default should be used, however if there are more
  # servers in this datacenter than server.replicas it might make sense
  # to override the default. This would be the case if two kube clusters
  # were joined into the same datacenter and each cluster ran a certain number
  # of servers.
  # @type: int
  bootstrapExpect: null

  # [Enterprise Only] This value refers to a Kubernetes secret that you have created
  # that contains your enterprise license. It is required if you are using an
  # enterprise binary. Defining it here applies it to your cluster once a leader
  # has been elected. If you are not using an enterprise image or if you plan to
  # introduce the license key via another route, then set these fields to null.
  # Note: the job to apply license runs on both Helm installs and upgrades.
  enterpriseLicense:
    # The name of the Kubernetes secret that holds the enterprise license.
    # The secret must be in the same namespace that Consul is installed into.
    secretName: null
    # The key within the Kubernetes secret that holds the enterprise license.
    secretKey: null
    # Manages license autoload. Required in Consul 1.10.0+, 1.9.7+ and 1.8.12+.
    enableLicenseAutoload: true

  # A Kubernetes secret containing a certificate & key for the server agents to use
  # for TLS communication within the Consul cluster. Cert needs to be provided with
  # additional DNS name SANs so that it will work within the Kubernetes cluster:
  #
  # ```bash
  # consul tls cert create -server -days=730 -domain=consul -ca=consul-agent-ca.pem \
  #     -key=consul-agent-ca-key.pem -dc={{datacenter}} \
  #     -additional-dnsname="{{fullname}}-server" \
  #     -additional-dnsname="*.{{fullname}}-server" \
  #     -additional-dnsname="*.{{fullname}}-server.{{namespace}}" \
  #     -additional-dnsname="*.{{fullname}}-server.{{namespace}}.svc" \
  #     -additional-dnsname="*.server.{{datacenter}}.{{domain}}" \
  #     -additional-dnsname="server.{{datacenter}}.{{domain}}"
  # ```
  #
  # If you have generated the
  # server-cert yourself with the consul CLI, you could use the following command
  # to create the secret in Kubernetes:
  #
  # ```bash
  # kubectl create secret generic consul-server-cert \
  #     --from-file='tls.crt=./dc1-server-consul-0.pem'
  #     --from-file='tls.key=./dc1-server-consul-0-key.pem'
  # ```
  serverCert:
    # The name of the Kubernetes secret.
    secretName: null

  # Exposes the servers' gossip and RPC ports as hostPorts. To enable a client
  # agent outside of the k8s cluster to join the datacenter, you would need to
  # enable `server.exposeGossipAndRPCPorts`, `client.exposeGossipPorts`, and
  # set `server.ports.serflan.port` to a port not being used on the host. Since
  # `client.exposeGossipPorts` uses the hostPort 8301,
  # `server.ports.serflan.port` must be set to something other than 8301.
  exposeGossipAndRPCPorts: false

  # Configures ports for the consul servers.
  ports:
    # Configures the LAN gossip port for the consul servers. If you choose to
    # enable `server.exposeGossipAndRPCPorts` and `client.exposeGossipPorts`,
    # that will configure the LAN gossip ports on the servers and clients to be
    # hostPorts, so if you are running clients and servers on the same node the
    # ports will conflict if they are both 8301. When you enable
    # `server.exposeGossipAndRPCPorts` and `client.exposeGossipPorts`, you must
    # change this from the default to an unused port on the host, e.g. 9301. By
    # default the LAN gossip port is 8301 and configured as a containerPort on
    # the consul server Pods.
    serflan:
      port: 8301

  # This defines the disk size for configuring the
  # servers' StatefulSet storage. For dynamically provisioned storage classes, this is the
  # desired size. For manually defined persistent volumes, this should be set to
  # the disk size of the attached volume.
  storage: 10Gi

  # The StorageClass to use for the servers' StatefulSet storage. It must be
  # able to be dynamically provisioned if you want the storage
  # to be automatically created. For example, to use local
  # (https://kubernetes.io/docs/concepts/storage/storage-classes/#local)
  # storage classes, the PersistentVolumeClaims would need to be manually created.
  # A `null` value will use the Kubernetes cluster's default StorageClass. If a default
  # StorageClass does not exist, you will need to create one.
  # @type: string
  storageClass: null

  # This will enable/disable Connect (https://consul.io/docs/connect). Setting this to true
  # _will not_ automatically secure pod communication, this
  # setting will only enable usage of the feature. Consul will automatically initialize
  # a new CA and set of certificates. Additional Connect settings can be configured
  # by setting the `server.extraConfig` value.
  connect: true

  serviceAccount:
    # This value defines additional annotations for the server service account. This should be formatted as a multi-line
    # string.
    #
    # ```yaml
    # annotations: |
    #   "sample/annotation1": "foo"
    #   "sample/annotation2": "bar"
    # ```
    #
    # @type: string
    annotations: null

  # The resource requests (CPU, memory, etc.)
  # for each of the server agents. This should be a YAML map corresponding to a Kubernetes
  # ResourceRequirements (https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#resourcerequirements-v1-core)
  # object. NOTE: The use of a YAML string is deprecated.
  #
  # Example:
  #
  # ```yaml
  # resources:
  #   requests:
  #     memory: '100Mi'
  #     cpu: '100m'
  #   limits:
  #     memory: '100Mi'
  #     cpu: '100m'
  # ```
  #
  # @recurse: false
  # @type: map
  resources:
    requests:
      memory: "100Mi"
      cpu: "100m"
    limits:
      memory: "100Mi"
      cpu: "100m"

  # The security context for the server pods. This should be a YAML map corresponding to a
  # Kubernetes [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) object.
  # By default, servers will run as non-root, with user ID `100` and group ID `1000`,
  # which correspond to the consul user and group created by the Consul docker image.
  # Note: if running on OpenShift, this setting is ignored because the user and group are set automatically
  # by the OpenShift platform.
  # @type: map
  # @recurse: false
  securityContext:
    runAsNonRoot: true
    runAsGroup: 1000
    runAsUser: 100
    fsGroup: 1000

  # The container securityContext for each container in the server pods.  In
  # addition to the Pod's SecurityContext this can
  # set the capabilities of processes running in the container and ensure the
  # root file systems in the container is read-only.
  # @type: map
  # @recurse: true
  containerSecurityContext:
    # The consul server agent container
    # @type: map
    # @recurse: false
    server: null

  # This value is used to carefully
  # control a rolling update of Consul server agents. This value specifies the
  # partition (https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#partitions)
  # for performing a rolling update. Please read the linked Kubernetes documentation
  # and https://www.consul.io/docs/k8s/upgrade#upgrading-consul-servers for more information.
  updatePartition: 0

  # This configures the PodDisruptionBudget (https://kubernetes.io/docs/tasks/run-application/configure-pdb/)
  # for the server cluster.
  disruptionBudget:
    # This will enable/disable registering a PodDisruptionBudget for the server
    # cluster. If this is enabled, it will only register the budget so long as
    # the server cluster is enabled.
    enabled: true

    # The maximum number of unavailable pods. By default, this will be
    # automatically computed based on the `server.replicas` value to be `(n/2)-1`.
    # If you need to set this to `0`, you will need to add a
    # --set 'server.disruptionBudget.maxUnavailable=0'` flag to the helm chart installation
    # command because of a limitation in the Helm templating language.
    # @type: integer
    maxUnavailable: null

  # A raw string of extra JSON configuration (https://consul.io/docs/agent/options) for Consul
  # servers. This will be saved as-is into a ConfigMap that is read by the Consul
  # server agents. This can be used to add additional configuration that
  # isn't directly exposed by the chart.
  #
  # Example:
  #
  # ```yaml
  # extraConfig: |
  #   {
  #     "log_level": "DEBUG"
  #   }
  # ```
  #
  # This can also be set using Helm's `--set` flag using the following syntax:
  #
  # ```shell
  # --set 'server.extraConfig="{"log_level": "DEBUG"}"'
  # ```
  extraConfig: |
    {}

  # A list of extra volumes to mount for server agents. This
  # is useful for bringing in extra data that can be referenced by other configurations
  # at a well known path, such as TLS certificates or Gossip encryption keys. The
  # value of this should be a list of objects.
  #
  # Example:
  #
  # ```yaml
  # extraVolumes:
  #   - type: secret
  #     name: consul-certs
  #     load: false
  # ```
  #
  # Each object supports the following keys:
  #
  # - `type` - Type of the volume, must be one of "configMap" or "secret". Case sensitive.
  #
  # - `name` - Name of the configMap or secret to be mounted. This also controls
  #   the path that it is mounted to. The volume will be mounted to `/consul/userconfig/<name>`.
  #
  # - `load` - If true, then the agent will be
  #   configured to automatically load HCL/JSON configuration files from this volume
  #   with `-config-dir`. This defaults to false.
  #
  # @type: array<map>
  extraVolumes: []

  # This value defines the affinity (https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity)
  # for server pods. It defaults to allowing only a single server pod on each node, which
  # minimizes risk of the cluster becoming unusable if a node is lost. If you need
  # to run more pods per node (for example, testing on Minikube), set this value
  # to `null`.
  #
  # Example:
  #
  # ```yaml
  # affinity: |
  #   podAntiAffinity:
  #     requiredDuringSchedulingIgnoredDuringExecution:
  #       - labelSelector:
  #           matchLabels:
  #             app: {{ template "consul.name" . }}
  #             release: "{{ .Release.Name }}"
  #             component: server
  #       topologyKey: kubernetes.io/hostname
  # ```
  affinity: |
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app: {{ template "consul.name" . }}
              release: "{{ .Release.Name }}"
              component: server
          topologyKey: kubernetes.io/hostname

  # Toleration settings for server pods. This
  # should be a multi-line string matching the Tolerations
  # (https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) array in a Pod spec.
  tolerations: ""

  # Pod topology spread constraints for server pods.
  # This should be a multi-line YAML string matching the `topologySpreadConstraints` array
  # (https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/) in a Pod Spec.
  #
  # This requires K8S >= 1.18 (beta) or 1.19 (stable).
  #
  # Example:
  #
  # ```yaml
  # topologySpreadConstraints: |
  #   - maxSkew: 1
  #     topologyKey: topology.kubernetes.io/zone
  #     whenUnsatisfiable: DoNotSchedule
  #     labelSelector:
  #       matchLabels:
  #         app: {{ template "consul.name" . }}
  #         release: "{{ .Release.Name }}"
  #         component: server
  # ```
  topologySpreadConstraints: ""

  # This value defines `nodeSelector` (https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector)
  # labels for server pod assignment, formatted as a multi-line string.
  #
  # Example:
  #
  # ```yaml
  # nodeSelector: |
  #   beta.kubernetes.io/arch: amd64
  # ```
  #
  # @type: string
  nodeSelector: null

  # This value references an existing
  # Kubernetes `priorityClassName` (https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#pod-priority)
  # that can be assigned to server pods.
  priorityClassName: ""

  # Extra labels to attach to the server pods. This should be a YAML map.
  #
  # Example:
  #
  # ```yaml
  # extraLabels:
  #   labelKey: label-value
  #   anotherLabelKey: another-label-value
  # ```
  #
  # @type: map
  extraLabels: null

  # This value defines additional annotations for
  # server pods. This should be formatted as a multi-line string.
  #
  # ```yaml
  # annotations: |
  #   "sample/annotation1": "foo"
  #   "sample/annotation2": "bar"
  # ```
  #
  # @type: string
  annotations: null

  # Server service properties.
  service:
    # Annotations to apply to the server service.
    #
    # ```yaml
    # annotations: |
    #   "annotation-key": "annotation-value"
    # ```
    #
    # @type: string
    annotations: null

  # A list of extra environment variables to set within the stateful set.
  # These could be used to include proxy settings required for cloud auto-join
  # feature, in case kubernetes cluster is behind egress http proxies. Additionally,
  # it could be used to configure custom consul parameters.
  # @type: map
  extraEnvironmentVars: {}

# Configuration for Consul servers when the servers are running outside of Kubernetes.
# When running external servers, configuring these values is recommended
# if setting `global.tls.enableAutoEncrypt` to true
# or `global.acls.manageSystemACLs` to true.
externalServers:
  # If true, the Helm chart will be configured to talk to the external servers.
  # If setting this to true, you must also set `server.enabled` to false.
  enabled: false

  # An array of external Consul server hosts that are used to make
  # HTTPS connections from the components in this Helm chart.
  # Valid values include IPs, DNS names, or Cloud auto-join string.
  # The port must be provided separately below.
  # Note: `client.join` must also be set to the hosts that should be
  # used to join the cluster. In most cases, the `client.join` values
  # should be the same, however, they may be different if you
  # wish to use separate hosts for the HTTPS connections.
  # @type: array<string>
  hosts: []

  # The HTTPS port of the Consul servers.
  httpsPort: 8501

  # The server name to use as the SNI host header when connecting with HTTPS.
  # @type: string
  tlsServerName: null

  # If true, consul-k8s-control-plane components will ignore the CA set in
  # `global.tls.caCert` when making HTTPS calls to Consul servers and
  # will instead use the consul-k8s-control-plane image's system CAs for TLS verification.
  # If false, consul-k8s-control-plane components will use `global.tls.caCert` when
  # making HTTPS calls to Consul servers.
  # **NOTE:** This does not affect Consul's internal RPC communication which will
  # always use `global.tls.caCert`.
  useSystemRoots: false

  # If you are setting `global.acls.manageSystemACLs` and
  # `connectInject.enabled` to true, set `k8sAuthMethodHost` to the address of the Kubernetes API server.
  # This address must be reachable from the Consul servers.
  # Please see the Kubernetes Auth Method documentation (https://consul.io/docs/acl/auth-methods/kubernetes).
  #
  # You could retrieve this value from your `kubeconfig` by running:
  #
  # ```shell
  # kubectl config view \
  #   -o jsonpath="{.clusters[?(@.name=='<your cluster name>')].cluster.server}"
  # ```
  #
  # @type: string
  k8sAuthMethodHost: null

# Values that configure running a Consul client on Kubernetes nodes.
client:
  # If true, the chart will install all
  # the resources necessary for a Consul client on every Kubernetes node. This _does not_ require
  # `server.enabled`, since the agents can be configured to join an external cluster.
  # @default: global.enabled
  # @type: boolean
  enabled: "-"

  # The name of the Docker image (including any tag) for the containers
  # running Consul client agents.
  # @type: string
  image: null

  # A list of valid `-retry-join` values (https://consul.io/docs/agent/options#retry-join).
  # If this is `null` (default), then the clients will attempt to automatically
  # join the server cluster running within Kubernetes.
  # This means that with `server.enabled` set to true, clients will automatically
  # join that cluster. If `server.enabled` is not true, then a value must be
  # specified so the clients can join a valid cluster.
  # @type: array<string>
  join: null

  # An absolute path to a directory on the host machine to use as the Consul
  # client data directory. If set to the empty string or null, the Consul agent
  # will store its data in the Pod's local filesystem (which will
  # be lost if the Pod is deleted). Security Warning: If setting this, Pod Security
  # Policies _must_ be enabled on your cluster and in this Helm chart (via the
  # `global.enablePodSecurityPolicies` setting) to prevent other pods from
  # mounting the same host path and gaining access to all of Consul's data.
  # Consul's data is not encrypted at rest.
  # @type: string
  dataDirectoryHostPath: null

  # If true, agents will enable their GRPC listener on
  # port 8502 and expose it to the host. This will use slightly more resources, but is
  # required for Connect.
  grpc: true

  # nodeMeta specifies an arbitrary metadata key/value pair to associate with the node
  # (see https://www.consul.io/docs/agent/options.html#_node_meta)
  nodeMeta:
    pod-name: $${HOSTNAME}
    host-ip: $${HOST_IP}

  # If true, the Helm chart will expose the clients' gossip ports as hostPorts.
  # This is only necessary if pod IPs in the k8s cluster are not directly routable
  # and the Consul servers are outside of the k8s cluster.
  # This also changes the clients' advertised IP to the `hostIP` rather than `podIP`.
  exposeGossipPorts: false

  serviceAccount:
    # This value defines additional annotations for the client service account. This should be formatted as a multi-line
    # string.
    #
    # ```yaml
    # annotations: |
    #   "sample/annotation1": "foo"
    #   "sample/annotation2": "bar"
    # ```
    #
    # @type: string
    annotations: null

  # Resource settings for Client agents.
  # NOTE: The use of a YAML string is deprecated. Instead, set directly as a
  # YAML map.
  # @recurse: false
  # @type: map
  resources:
    requests:
      memory: "100Mi"
      cpu: "100m"
    limits:
      memory: "100Mi"
      cpu: "100m"

  # The security context for the client pods. This should be a YAML map corresponding to a
  # Kubernetes [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) object.
  # By default, servers will run as non-root, with user ID `100` and group ID `1000`,
  # which correspond to the consul user and group created by the Consul docker image.
  # Note: if running on OpenShift, this setting is ignored because the user and group are set automatically
  # by the OpenShift platform.
  # @type: map
  # @recurse: false
  securityContext:
    runAsNonRoot: true
    runAsGroup: 1000
    runAsUser: 100
    fsGroup: 1000

  # The container securityContext for each container in the client pods.  In
  # addition to the Pod's SecurityContext this can
  # set the capabilities of processes running in the container and ensure the
  # root file systems in the container is read-only.
  # @type: map
  # @recurse: true
  containerSecurityContext:
    # The consul client agent container
    # @type: map
    # @recurse: false
    client: null
    # The acl-init initContainer
    # @type: map
    # @recurse: false
    aclInit: null
    # The tls-init initContainer
    # @type: map
    # @recurse: false
    tlsInit: null

  # A raw string of extra JSON configuration (https://consul.io/docs/agent/options) for Consul
  # clients. This will be saved as-is into a ConfigMap that is read by the Consul
  # client agents. This can be used to add additional configuration that
  # isn't directly exposed by the chart.
  #
  # Example:
  #
  # ```yaml
  # extraConfig: |
  #   {
  #     "log_level": "DEBUG"
  #   }
  # ```
  #
  # This can also be set using Helm's `--set` flag using the following syntax:
  #
  # ```shell
  # --set 'client.extraConfig="{"log_level": "DEBUG"}"'
  # ```
  extraConfig: |
    {}

  # A list of extra volumes to mount for client agents. This
  # is useful for bringing in extra data that can be referenced by other configurations
  # at a well known path, such as TLS certificates or Gossip encryption keys. The
  # value of this should be a list of objects.
  #
  # Example:
  #
  # ```yaml
  # extraVolumes:
  #   - type: secret
  #     name: consul-certs
  #     load: false
  # ```
  #
  # Each object supports the following keys:
  #
  # - `type` - Type of the volume, must be one of "configMap" or "secret". Case sensitive.
  #
  # - `name` - Name of the configMap or secret to be mounted. This also controls
  #   the path that it is mounted to. The volume will be mounted to `/consul/userconfig/<name>`.
  #
  # - `load` - If true, then the agent will be
  #   configured to automatically load HCL/JSON configuration files from this volume
  #   with `-config-dir`. This defaults to false.
  #
  # @type: array<map>
  extraVolumes: []

  # Toleration Settings for Client pods
  # This should be a multi-line string matching the Toleration array
  # in a PodSpec.
  # The example below will allow Client pods to run on every node
  # regardless of taints
  #
  # ```yaml
  # tolerations: |
  #   - operator: Exists
  # ```
  tolerations: ""

  # nodeSelector labels for client pod assignment, formatted as a multi-line string.
  # ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
  #
  # Example:
  #
  # ```yaml
  # nodeSelector: |
  #   beta.kubernetes.io/arch: amd64
  # ```
  # @type: string
  nodeSelector: null

  # Affinity Settings for Client pods, formatted as a multi-line YAML string.
  # ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  #
  # Example:
  #
  # ```yaml
  # affinity: |
  #   nodeAffinity:
  #     requiredDuringSchedulingIgnoredDuringExecution:
  #       nodeSelectorTerms:
  #       - matchExpressions:
  #         - key: node-role.kubernetes.io/master
  #           operator: DoesNotExist
  # ```
  # @type: string
  affinity: null

  # This value references an existing
  # Kubernetes `priorityClassName` (https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#pod-priority)
  # that can be assigned to client pods.
  priorityClassName: ""

  # This value defines additional annotations for
  # client pods. This should be formatted as a multi-line string.
  #
  # ```yaml
  # annotations: |
  #   "sample/annotation1": "foo"
  #   "sample/annotation2": "bar"
  # ```
  #
  # @type: string
  annotations: null

  # Extra labels to attach to the client pods. This should be a regular YAML map.
  #
  # Example:
  #
  # ```yaml
  # extraLabels:
  #   labelKey: label-value
  #   anotherLabelKey: another-label-value
  # ```
  #
  # @type: map
  extraLabels: null

  # A list of extra environment variables to set within the stateful set.
  # These could be used to include proxy settings required for cloud auto-join
  # feature, in case kubernetes cluster is behind egress http proxies. Additionally,
  # it could be used to configure custom consul parameters.
  # @type: map
  extraEnvironmentVars: {}

  # This value defines the Pod DNS policy (https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy)
  # for client pods to use.
  # @type: string
  dnsPolicy: null

  # hostNetwork defines whether or not we use host networking instead of hostPort in the event
  # that a CNI plugin doesn't support `hostPort`. This has security implications and is not recommended
  # as doing so gives the consul client unnecessary access to all network traffic on the host.
  # In most cases, pod network and host network are on different networks so this should be
  # combined with `dnsPolicy: ClusterFirstWithHostNet`
  hostNetwork: false

  # updateStrategy for the DaemonSet.
  # See https://kubernetes.io/docs/tasks/manage-daemon/update-daemon-set/#daemonset-update-strategy.
  # This should be a multi-line string mapping directly to the updateStrategy
  #
  # Example:
  #
  # ```yaml
  # updateStrategy: |
  #   rollingUpdate:
  #     maxUnavailable: 5
  #   type: RollingUpdate
  # ```
  #
  # @type: string
  updateStrategy: null

  # [Enterprise Only] Values for setting up and running snapshot agents
  # (https://consul.io/commands/snapshot/agent)
  # within the Consul clusters. They are required to be co-located with Consul clients,
  # so will inherit the clients' nodeSelector, tolerations and affinity.
  snapshotAgent:
    # If true, the chart will install resources necessary to run the snapshot agent.
    enabled: false

    # The number of snapshot agents to run.
    replicas: 2

    # A Kubernetes secret that should be manually created to contain the entire
    # config to be used on the snapshot agent.
    # This is the preferred method of configuration since there are usually storage
    # credentials present. Please see Snapshot agent config (https://consul.io/commands/snapshot/agent#config-file-options)
    # for details.
    configSecret:
      # The name of the Kubernetes secret.
      secretName: null
      # The key of the Kubernetes secret.
      secretKey: null

    serviceAccount:
      # This value defines additional annotations for the snapshot agent service account. This should be formatted as a
      # multi-line string.
      #
      # ```yaml
      # annotations: |
      #   "sample/annotation1": "foo"
      #   "sample/annotation2": "bar"
      # ```
      #
      # @type: string
      annotations: null

    # Resource settings for snapshot agent pods.
    # @recurse: false
    # @type: map
    resources:
      requests:
        memory: "50Mi"
        cpu: "50m"
      limits:
        memory: "50Mi"
        cpu: "50m"

    # Optional PEM-encoded CA certificate that will be added to the trusted system CAs.
    # Useful if using an S3-compatible storage exposing a self-signed certificate.
    #
    # Example:
    #
    # ```yaml
    # caCert: |
    #   -----BEGIN CERTIFICATE-----
    #   MIIC7jCCApSgAwIBAgIRAIq2zQEVexqxvtxP6J0bXAwwCgYIKoZIzj0EAwIwgbkx
    #   ...
    # ```
    # @type: string
    caCert: null

# Configuration for DNS configuration within the Kubernetes cluster.
# This creates a service that routes to all agents (client or server)
# for serving DNS requests. This DOES NOT automatically configure kube-dns
# today, so you must still manually configure a `stubDomain` with kube-dns
# for this to have any effect:
# https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/#configure-stub-domain-and-upstream-dns-servers
dns:
  # @type: boolean
  enabled: "-"

  # Used to control the type of service created. For
  # example, setting this to "LoadBalancer" will create an external load
  # balancer (for supported K8S installations)
  type: ClusterIP

  # Set a predefined cluster IP for the DNS service.
  # Useful if you need to reference the DNS service's IP
  # address in CoreDNS config.
  # @type: string
  clusterIP: null

  # Extra annotations to attach to the dns service
  # This should be a multi-line string of
  # annotations to apply to the dns Service
  # @type: string
  annotations: null

  # Additional ServiceSpec values
  # This should be a multi-line string mapping directly to a Kubernetes
  # ServiceSpec object.
  # @type: string
  additionalSpec: null

# Values that configure the Consul UI.
ui:
  # If true, the UI will be enabled. This will
  # only _enable_ the UI, it doesn't automatically register any service for external
  # access. The UI will only be enabled on server agents. If `server.enabled` is
  # false, then this setting has no effect. To expose the UI in some way, you must
  # configure `ui.service`.
  # @default: global.enabled
  # @type: boolean
  enabled: "-"

  # Configure the service for the Consul UI.
  service:
    # This will enable/disable registering a
    # Kubernetes Service for the Consul UI. This value only takes effect if `ui.enabled` is
    # true and taking effect.
    enabled: true

    # The service type to register.
    # @type: string
    type: null

    # Set the port value of the UI service.
    port:

      # HTTP port.
      http: 80

      # HTTPS port.
      https: 443

    # Optionally set the nodePort value of the ui service if using a NodePort service.
    # If not set and using a NodePort service, Kubernetes will automatically assign
    # a port.
    nodePort:

      # HTTP node port
      # @type: integer
      http: null

      # HTTPS node port
      # @type: integer
      https: null

    # Annotations to apply to the UI service.
    #
    # Example:
    #
    # ```yaml
    # annotations: |
    #   'annotation-key': annotation-value
    # ```
    # @type: string
    annotations: null

    # Additional ServiceSpec values
    # This should be a multi-line string mapping directly to a Kubernetes
    # ServiceSpec object.
    # @type: string
    additionalSpec: null

  # Configure Ingress for the Consul UI.
  # If `global.tls.enabled` is set to `true`, the Ingress will expose
  # the port 443 on the UI service. Please ensure the Ingress Controller
  # supports SSL pass-through and it is enabled to ensure traffic forwarded
  # to port 443 has not been TLS terminated.
  ingress:
    # This will create an Ingress resource for the Consul UI.
    # @type: boolean
%{ if contains(keys(values),"domain") ~}
    enabled: true
%{ else ~}
    enabled: false
%{ endif ~}

    # pathType override - see: https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types
    pathType: Prefix

    # hosts is a list of host name to create Ingress rules.
    #
    # ```yaml
    # hosts:
    #   - host: foo.bar
    #     paths:
    #       - /example
    #       - /test
    # ```
    #
    # @type: array<map>
    hosts: 
      - host: consul.${lookup(values,"domain","127-0-0-1.nip.io")}
        paths:
          - /

    # tls is a list of hosts and secret name in an Ingress
    # which tells the Ingress controller to secure the channel.
    #
    # ```yaml
    # tls:
    #   - hosts:
    #     - chart-example.local
    #     secretName: testsecret-tls
    # ```
    # @type: array<map>
    tls: []

    # Annotations to apply to the UI ingress.
    #
    # Example:
    #
    # ```yaml
    # annotations: |
    #   'annotation-key': annotation-value
    # ```
    # @type: string
    annotations: |
      'kubernetes.io/ingress.class': "nginx"
      'nginx.ingress.kubernetes.io/auth-type': "basic"
      'nginx.ingress.kubernetes.io/auth-secret': "basic-auth"
      'nginx.ingress.kubernetes.io/auth-realm': 'Authentication Required - foo'


  # Configurations for displaying metrics in the UI.
  metrics:
    # Enable displaying metrics in the UI. The default value of "-"
    # will inherit from `global.metrics.enabled` value.
    # @type: boolean
    # @default: global.metrics.enabled
    enabled: "-"
    # Provider for metrics. See
    # https://www.consul.io/docs/agent/options#ui_config_metrics_provider
    # This value is only used if `ui.enabled` is set to true.
    # @type: string
    provider: "prometheus"

    # baseURL is the URL of the prometheus server, usually the service URL.
    # This value is only used if `ui.enabled` is set to true.
    # @type: string
    baseURL: http://prometheus-server

# Configure the catalog sync process to sync K8S with Consul
# services. This can run bidirectional (default) or unidirectionally (Consul
# to K8S or K8S to Consul only).
#
# This process assumes that a Consul agent is available on the host IP.
# This is done automatically if clients are enabled. If clients are not
# enabled then set the node selection so that it chooses a node with a
# Consul agent.
syncCatalog:
  # True if you want to enable the catalog sync. Set to "-" to inherit from
  # global.enabled.
  enabled: false

  # The name of the Docker image (including any tag) for consul-k8s-control-plane
  # to run the sync program.
  # @type: string
  image: null

  # If true, all valid services in K8S are
  # synced by default. If false, the service must be annotated
  # (https://consul.io/docs/k8s/service-sync#sync-enable-disable) properly to sync.
  # In either case an annotation can override the default.
  default: true

  # Optional priorityClassName.
  priorityClassName: ""

  # If true, will sync Kubernetes services to Consul. This can be disabled to
  # have a one-way sync.
  toConsul: true

  # If true, will sync Consul services to Kubernetes. This can be disabled to
  # have a one-way sync.
  toK8S: true

  # Service prefix to prepend to services before registering
  # with Kubernetes. For example "consul-" will register all services
  # prepended with "consul-". (Consul -> Kubernetes sync)
  # @type: string
  k8sPrefix: null

  # List of k8s namespaces to sync the k8s services from.
  # If a k8s namespace is not included in this list or is listed in `k8sDenyNamespaces`,
  # services in that k8s namespace will not be synced even if they are explicitly
  # annotated. Use `["*"]` to automatically allow all k8s namespaces.
  #
  # For example, `["namespace1", "namespace2"]` will only allow services in the k8s
  # namespaces `namespace1` and `namespace2` to be synced and registered
  # with Consul. All other k8s namespaces will be ignored.
  #
  # To deny all namespaces, set this to `[]`.
  #
  # Note: `k8sDenyNamespaces` takes precedence over values defined here.
  # @type: array<string>
  k8sAllowNamespaces: ["*"]

  # List of k8s namespaces that should not have their
  # services synced. This list takes precedence over `k8sAllowNamespaces`.
  # `*` is not supported because then nothing would be allowed to sync.
  #
  # For example, if `k8sAllowNamespaces` is `["*"]` and `k8sDenyNamespaces` is
  # `["namespace1", "namespace2"]`, then all k8s namespaces besides `namespace1`
  # and `namespace2` will be synced.
  # @type: array<string>
  k8sDenyNamespaces: ["kube-system", "kube-public"]

  # [DEPRECATED] Use k8sAllowNamespaces and k8sDenyNamespaces instead. For
  # backwards compatibility, if both this and the allow/deny lists are set,
  # the allow/deny lists will be ignored.
  # k8sSourceNamespace is the Kubernetes namespace to watch for service
  # changes and sync to Consul. If this is not set then it will default
  # to all namespaces.
  # @type: string
  k8sSourceNamespace: null

  # [Enterprise Only] These settings manage the catalog sync's interaction with
  # Consul namespaces (requires consul-ent v1.7+).
  # Also, `global.enableConsulNamespaces` must be true.
  consulNamespaces:
    # Name of the Consul namespace to register all
    # k8s services into. If the Consul namespace does not already exist,
    # it will be created. This will be ignored if `mirroringK8S` is true.
    consulDestinationNamespace: "default"

    # If true, k8s services will be registered into a Consul namespace
    # of the same name as their k8s namespace, optionally prefixed if
    # `mirroringK8SPrefix` is set below. If the Consul namespace does not
    # already exist, it will be created. Turning this on overrides the
    # `consulDestinationNamespace` setting.
    # `addK8SNamespaceSuffix` may no longer be needed if enabling this option.
    mirroringK8S: false

    # If `mirroringK8S` is set to true, `mirroringK8SPrefix` allows each Consul namespace
    # to be given a prefix. For example, if `mirroringK8SPrefix` is set to "k8s-", a
    # service in the k8s `staging` namespace will be registered into the
    # `k8s-staging` Consul namespace.
    mirroringK8SPrefix: ""

  # Appends Kubernetes namespace suffix to
  # each service name synced to Consul, separated by a dash.
  # For example, for a service 'foo' in the default namespace,
  # the sync process will create a Consul service named 'foo-default'.
  # Set this flag to true to avoid registering services with the same name
  # but in different namespaces as instances for the same Consul service.
  # Namespace suffix is not added if 'annotationServiceName' is provided.
  addK8SNamespaceSuffix: true

  # Service prefix which prepends itself
  # to Kubernetes services registered within Consul
  # For example, "k8s-" will register all services prepended with "k8s-".
  # (Kubernetes -> Consul sync)
  # consulPrefix is ignored when 'annotationServiceName' is provided.
  # NOTE: Updating this property to a non-null value for an existing installation will result in deregistering
  # of existing services in Consul and registering them with a new name.
  # @type: string
  consulPrefix: null

  # Optional tag that is applied to all of the Kubernetes services
  # that are synced into Consul. If nothing is set, defaults to "k8s".
  # (Kubernetes -> Consul sync)
  # @type: string
  k8sTag: null

  # Defines the Consul synthetic node that all services
  # will be registered to.
  # NOTE: Changing the node name and upgrading the Helm chart will leave
  # all of the previously sync'd services registered with Consul and
  # register them again under the new Consul node name. The out-of-date
  # registrations will need to be explicitly removed.
  consulNodeName: "k8s-sync"

  # Syncs services of the ClusterIP type, which may
  # or may not be broadly accessible depending on your Kubernetes cluster.
  # Set this to false to skip syncing ClusterIP services.
  syncClusterIPServices: true

  # Configures the type of syncing that happens for NodePort
  # services. The valid options are: ExternalOnly, InternalOnly, ExternalFirst.
  #
  # - ExternalOnly will only use a node's ExternalIP address for the sync
  # - InternalOnly use's the node's InternalIP address
  # - ExternalFirst will preferentially use the node's ExternalIP address, but
  #   if it doesn't exist, it will use the node's InternalIP address instead.
  nodePortSyncType: ExternalFirst

  # Refers to a Kubernetes secret that you have created that contains
  # an ACL token for your Consul cluster which allows the sync process the correct
  # permissions. This is only needed if ACLs are enabled on the Consul cluster.
  aclSyncToken:
    # The name of the Kubernetes secret.
    secretName: null
    # The key of the Kubernetes secret.
    secretKey: null

  # This value defines `nodeSelector` (https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector)
  # labels for catalog sync pod assignment, formatted as a multi-line string.
  #
  # Example:
  #
  # ```yaml
  # nodeSelector: |
  #   beta.kubernetes.io/arch: amd64
  # ```
  #
  # @type: string
  nodeSelector: null

  # Affinity Settings
  # This should be a multi-line string matching the affinity object
  # @type: string
  affinity: null

  # Toleration Settings
  # This should be a multi-line string matching the Toleration array
  # in a PodSpec.
  # @type: string
  tolerations: null

  serviceAccount:
    # This value defines additional annotations for the mesh gateways' service account. This should be formatted as a
    # multi-line string.
    #
    # ```yaml
    # annotations: |
    #   "sample/annotation1": "foo"
    #   "sample/annotation2": "bar"
    # ```
    #
    # @type: string
    annotations: null

  # Resource settings for sync catalog pods.
  # @recurse: false
  # @type: map
  resources:
    requests:
      memory: "50Mi"
      cpu: "50m"
    limits:
      memory: "50Mi"
      cpu: "50m"

  # Override global log verbosity level. One of "debug", "info", "warn", or "error".
  # @type: string
  logLevel: ""

  # Override the default interval to perform syncing operations creating Consul services.
  # @type: string
  consulWriteInterval: null

  # Extra labels to attach to the sync catalog pods. This should be a YAML map.
  #
  # Example:
  #
  # ```yaml
  # extraLabels:
  #   labelKey: label-value
  #   anotherLabelKey: another-label-value
  # ```
  #
  # @type: map
  extraLabels: null

# Configures the automatic Connect sidecar injector.
connectInject:
  # True if you want to enable connect injection. Set to "-" to inherit from
  # global.enabled.
  enabled: false

  # The number of deployment replicas.
  replicas: 2

  # Image for consul-k8s-control-plane that contains the injector.
  # @type: string
  image: null

  # If true, the injector will inject the
  # Connect sidecar into all pods by default. Otherwise, pods must specify the
  # injection annotation (https://consul.io/docs/k8s/connect#consul-hashicorp-com-connect-inject)
  # to opt-in to Connect injection. If this is true, pods can use the same annotation
  # to explicitly opt-out of injection.
  default: false

  # Configures Transparent Proxy for Consul Service mesh services.
  # Using this feature requires Consul 1.10.0-beta1+.
  transparentProxy:
    # If true, then all Consul Service mesh will run with transparent proxy enabled by default,
    # i.e. we enforce that all traffic within the pod will go through the proxy.
    # This value is overridable via the "consul.hashicorp.com/transparent-proxy" pod annotation.
    defaultEnabled: true

    # If true, we will overwrite Kubernetes HTTP probes of the pod to point to the Envoy proxy instead.
    # This setting is recommended because with traffic being enforced to go through the Envoy proxy,
    # the probes on the pod will fail because kube-proxy doesn't have the right certificates
    # to talk to Envoy.
    # This value is also overridable via the "consul.hashicorp.com/transparent-proxy-overwrite-probes" annotation.
    # Note: This value has no effect if transparent proxy is disabled on the pod.
    defaultOverwriteProbes: true

  # Configures metrics for Consul Connect services. All values are overridable
  # via annotations on a per-pod basis.
  metrics:
    # If true, the connect-injector will automatically
    # add prometheus annotations to connect-injected pods. It will also
    # add a listener on the Envoy sidecar to expose metrics. The exposed
    # metrics will depend on whether metrics merging is enabled:
    #   - If metrics merging is enabled:
    #     the Consul sidecar will run a merged metrics server
    #     combining Envoy sidecar and Connect service metrics,
    #     i.e. if your service exposes its own Prometheus metrics.
    #   - If metrics merging is disabled:
    #     the listener will just expose Envoy sidecar metrics.
    # This will inherit from `global.metrics.enabled`.
    defaultEnabled: "-"
    # Configures the Consul sidecar to run a merged metrics server
    # to combine and serve both Envoy and Connect service metrics.
    # This feature is available only in Consul v1.10.0 or greater.
    defaultEnableMerging: false
    # Configures the port at which the Consul sidecar will listen on to return
    # combined metrics. This port only needs to be changed if it conflicts with
    # the application's ports.
    defaultMergedMetricsPort: 20100
    # Configures the port Prometheus will scrape metrics from, by configuring
    # the Pod annotation `prometheus.io/port` and the corresponding listener in
    # the Envoy sidecar.
    # NOTE: This is *not* the port that your application exposes metrics on.
    # That can be configured with the
    # `consul.hashicorp.com/service-metrics-port` annotation.
    defaultPrometheusScrapePort: 20200
    # Configures the path Prometheus will scrape metrics from, by configuring the pod
    # annotation `prometheus.io/path` and the corresponding handler in the Envoy
    # sidecar.
    # NOTE: This is *not* the path that your application exposes metrics on.
    # That can be configured with the
    # `consul.hashicorp.com/service-metrics-path` annotation.
    defaultPrometheusScrapePath: "/metrics"

  # Used to pass arguments to the injected envoy sidecar.
  # Valid arguments to pass to envoy can be found here: https://www.envoyproxy.io/docs/envoy/latest/operations/cli
  # e.g "--log-level debug --disable-hot-restart"
  # @type: string
  envoyExtraArgs: null

  # Optional priorityClassName.
  priorityClassName: ""

  # The Docker image for Consul to use when performing Connect injection.
  # Defaults to global.image.
  # @type: string
  imageConsul: null

  # Override global log verbosity level. One of "debug", "info", "warn", or "error".
  # @type: string
  logLevel: ""

  serviceAccount:
    # This value defines additional annotations for the injector service account. This should be formatted as a
    # multi-line string.
    #
    # ```yaml
    # annotations: |
    #   "sample/annotation1": "foo"
    #   "sample/annotation2": "bar"
    # ```
    #
    # @type: string
    annotations: null

  # Resource settings for connect inject pods.
  # @recurse: false
  # @type: map
  resources:
    requests:
      memory: "50Mi"
      cpu: "50m"
    limits:
      memory: "50Mi"
      cpu: "50m"

  # Sets the failurePolicy for the mutating webhook. By default this will cause pods not part of the consul installation to fail scheduling while the webhook
  # is offline. This prevents a pod from skipping mutation if the webhook were to be momentarily offline.
  # Once the webhook is back online the pod will be scheduled.
  # In some environments such as Kind this may have an undesirable effect as it may prevent volume provisioner pods from running
  # which can lead to hangs. In these environments it is recommend to use "Ignore" instead.
  # This setting can be safely disabled by setting to "Ignore".
  failurePolicy: "Fail"

  # Selector for restricting the webhook to only
  # specific namespaces. This should be set to a multiline string.
  # See https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#matching-requests-namespaceselector
  # for more details.
  #
  # Example:
  #
  # ```yaml
  # namespaceSelector: |
  #   matchLabels:
  #     namespace-label: label-value
  # ```
  # @type: string
  namespaceSelector: null

  # List of k8s namespaces to allow Connect sidecar
  # injection in. If a k8s namespace is not included or is listed in `k8sDenyNamespaces`,
  # pods in that k8s namespace will not be injected even if they are explicitly
  # annotated. Use `["*"]` to automatically allow all k8s namespaces.
  #
  # For example, `["namespace1", "namespace2"]` will only allow pods in the k8s
  # namespaces `namespace1` and `namespace2` to have Connect sidecars injected
  # and registered with Consul. All other k8s namespaces will be ignored.
  #
  # To deny all namespaces, set this to `[]`.
  #
  # Note: `k8sDenyNamespaces` takes precedence over values defined here and
  # `namespaceSelector` takes precedence over both since it is applied first.
  # `kube-system` and `kube-public` are never injected, even if included here.
  # @type: array<string>
  k8sAllowNamespaces: ["*"]

  # List of k8s namespaces that should not allow Connect
  # sidecar injection. This list takes precedence over `k8sAllowNamespaces`.
  # `*` is not supported because then nothing would be allowed to be injected.
  #
  # For example, if `k8sAllowNamespaces` is `["*"]` and k8sDenyNamespaces is
  # `["namespace1", "namespace2"]`, then all k8s namespaces besides "namespace1"
  # and "namespace2" will be available for injection.
  #
  # Note: `namespaceSelector` takes precedence over this since it is applied first.
  # `kube-system` and `kube-public` are never injected.
  # @type: array<string>
  k8sDenyNamespaces: []

  # [Enterprise Only] These settings manage the connect injector's interaction with
  # Consul namespaces (requires consul-ent v1.7+).
  # Also, `global.enableConsulNamespaces` must be true.
  consulNamespaces:
    # Name of the Consul namespace to register all
    # k8s pods into. If the Consul namespace does not already exist,
    # it will be created. This will be ignored if `mirroringK8S` is true.
    consulDestinationNamespace: "default"

    # Causes k8s pods to be registered into a Consul namespace
    # of the same name as their k8s namespace, optionally prefixed if
    # `mirroringK8SPrefix` is set below. If the Consul namespace does not
    # already exist, it will be created. Turning this on overrides the
    # `consulDestinationNamespace` setting.
    mirroringK8S: false

    # If `mirroringK8S` is set to true, `mirroringK8SPrefix` allows each Consul namespace
    # to be given a prefix. For example, if `mirroringK8SPrefix` is set to "k8s-", a
    # pod in the k8s `staging` namespace will be registered into the
    # `k8s-staging` Consul namespace.
    mirroringK8SPrefix: ""

  # Selector labels for connectInject pod assignment, formatted as a multi-line string.
  # ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
  #
  # Example:
  #
  # ```yaml
  # nodeSelector: |
  #   beta.kubernetes.io/arch: amd64
  # ```
  # @type: string
  nodeSelector: null

  # Affinity Settings
  # This should be a multi-line string matching the affinity object
  # @type: string
  affinity: null

  # Toleration Settings
  # This should be a multi-line string matching the Toleration array
  # in a PodSpec.
  # @type: string
  tolerations: null

  # Query that defines which Service Accounts
  # can authenticate to Consul and receive an ACL token during Connect injection.
  # The default setting, i.e. serviceaccount.name!=default, prevents the
  # 'default' Service Account from logging in.
  # If set to an empty string all service accounts can log in.
  # This only has effect if ACLs are enabled.
  #
  # See https://www.consul.io/docs/acl/acl-auth-methods.html#binding-rules
  # and https://www.consul.io/docs/acl/auth-methods/kubernetes.html#trusted-identity-attributes
  # for more details.
  # Requires Consul >= v1.5.
  aclBindingRuleSelector: "serviceaccount.name!=default"

  # If you are not using global.acls.manageSystemACLs and instead manually setting up an
  # auth method for Connect inject, set this to the name of your auth method.
  overrideAuthMethodName: ""

  # Refers to a Kubernetes secret that you have created that contains
  # an ACL token for your Consul cluster which allows the Connect injector the correct
  # permissions. This is only needed if Consul namespaces [Enterprise Only] and ACLs
  # are enabled on the Consul cluster and you are not setting
  # `global.acls.manageSystemACLs` to `true`.
  # This token needs to have `operator = "write"` privileges to be able to
  # create Consul namespaces.
  aclInjectToken:
    # The name of the Kubernetes secret.
    # @type: string
    secretName: null
    # The key of the Kubernetes secret.
    # @type: string
    secretKey: null

  sidecarProxy:
    # Set default resources for sidecar proxy. If null, that resource won't
    # be set.
    # These settings can be overridden on a per-pod basis via these annotations:
    #
    # - `consul.hashicorp.com/sidecar-proxy-cpu-limit`
    # - `consul.hashicorp.com/sidecar-proxy-cpu-request`
    # - `consul.hashicorp.com/sidecar-proxy-memory-limit`
    # - `consul.hashicorp.com/sidecar-proxy-memory-request`
    # @type: map
    resources:
      requests:
        # Recommended default: 100Mi
        # @type: string
        memory: null
        # Recommended default: 100m
        # @type: string
        cpu: null
      limits:
        # Recommended default: 100Mi
        # @type: string
        memory: null
        # Recommended default: 100m
        # @type: string
        cpu: null

  # Resource settings for the Connect injected init container.
  # @recurse: false
  # @type: map
  initContainer:
    resources:
      requests:
        memory: "25Mi"
        cpu: "50m"
      limits:
        memory: "150Mi"
        cpu: "50m"

# Controller handles config entry custom resources.
# Requires consul >= 1.8.4.
# ServiceIntentions require consul 1.9+.
controller:
  # Enables the controller for managing custom resources.
  enabled: false

  # The number of deployment replicas.
  replicas: 1

  # Log verbosity level. One of "debug", "info", "warn", or "error".
  # @type: string
  logLevel: ""

  serviceAccount:
    # This value defines additional annotations for the controller service account. This should be formatted as a
    # multi-line string.
    #
    # ```yaml
    # annotations: |
    #   "sample/annotation1": "foo"
    #   "sample/annotation2": "bar"
    # ```
    #
    # @type: string
    annotations: null

  # Resource settings for controller pods.
  # @recurse: false
  # @type: map
  resources:
    limits:
      cpu: 100m
      memory: 50Mi
    requests:
      cpu: 100m
      memory: 50Mi

  # Optional YAML string to specify a nodeSelector config.
  # @type: string
  nodeSelector: null

  # Optional YAML string to specify tolerations.
  # @type: string
  tolerations: null

  # Affinity Settings
  # This should be a multi-line string matching the affinity object
  # @type: string
  affinity: null

  # Optional priorityClassName.
  priorityClassName: ""

  # Refers to a Kubernetes secret that you have created that contains
  # an ACL token for your Consul cluster which grants the controller process the correct
  # permissions. This is only needed if you are managing ACLs yourself (i.e. not using
  # `global.acls.manageSystemACLs`).
  #
  # If running Consul OSS, requires permissions:
  # ```hcl
  # operator = "write"
  # service_prefix "" {
  #   policy = "write"
  #   intentions = "write"
  # }
  # ```
  # If running Consul Enterprise, talk to your account manager for assistance.
  aclToken:
    # The name of the Kubernetes secret.
    # @type: string
    secretName: null
    # The key of the Kubernetes secret.
    # @type: string
    secretKey: null

# Mesh Gateways enable Consul Connect to work across Consul datacenters.
meshGateway:
  # If mesh gateways are enabled, a Deployment will be created that runs
  # gateways and Consul Connect will be configured to use gateways.
  # See https://www.consul.io/docs/connect/mesh_gateway.html
  # Requirements: consul 1.6.0+ if using
  # global.acls.manageSystemACLs.
  enabled: false

  # Number of replicas for the Deployment.
  replicas: 2

  # What gets registered as WAN address for the gateway.
  wanAddress:
    # source configures where to retrieve the WAN address (and possibly port)
    # for the mesh gateway from.
    # Can be set to either: `Service`, `NodeIP`, `NodeName` or `Static`.
    #
    # - `Service` - Determine the address based on the service type.
    #
    #   - If `service.type=LoadBalancer` use the external IP or hostname of
    #     the service. Use the port set by `service.port`.
    #
    #   - If `service.type=NodePort` use the Node IP. The port will be set to
    #     `service.nodePort` so `service.nodePort` cannot be null.
    #
    #   - If `service.type=ClusterIP` use the `ClusterIP`. The port will be set to
    #     `service.port`.
    #
    #   - `service.type=ExternalName` is not supported.
    #
    # - `NodeIP` - The node IP as provided by the Kubernetes downward API.
    #
    # - `NodeName` - The name of the node as provided by the Kubernetes downward
    #   API. This is useful if the node names are DNS entries that
    #   are routable from other datacenters.
    #
    # - `Static` - Use the address hardcoded in `meshGateway.wanAddress.static`.
    source: "Service"

    # Port that gets registered for WAN traffic.
    # If source is set to "Service" then this setting will have no effect.
    # See the documentation for source as to which port will be used in that
    # case.
    port: 443

    # If source is set to "Static" then this value will be used as the WAN
    # address of the mesh gateways. This is useful if you've configured a
    # DNS entry to point to your mesh gateways.
    static: ""

  # The service option configures the Service that fronts the Gateway Deployment.
  service:
    # Whether to create a Service or not.
    enabled: true

    # Type of service, ex. LoadBalancer, ClusterIP.
    type: LoadBalancer

    # Port that the service will be exposed on.
    # The targetPort will be set to meshGateway.containerPort.
    port: 443

    # Optionally set the nodePort value of the service if using a NodePort service.
    # If not set and using a NodePort service, Kubernetes will automatically assign
    # a port.
    # @type: integer
    nodePort: null

    # Annotations to apply to the mesh gateway service.
    #
    # Example:
    #
    # ```yaml
    # annotations: |
    #   'annotation-key': annotation-value
    # ```
    # @type: string
    annotations: null

    # Optional YAML string that will be appended to the Service spec.
    # @type: string
    additionalSpec: null

  # If set to true, gateway Pods will run on the host network.
  hostNetwork: false

  # dnsPolicy to use.
  # @type: string
  dnsPolicy: null

  # Consul service name for the mesh gateways.
  # Cannot be set to anything other than "mesh-gateway" if
  # global.acls.manageSystemACLs is true since the ACL token
  # generated is only for the name 'mesh-gateway'.
  consulServiceName: "mesh-gateway"

  # Port that the gateway will run on inside the container.
  containerPort: 8443

  # Optional hostPort for the gateway to be exposed on.
  # This can be used with wanAddress.port and wanAddress.useNodeIP
  # to expose the gateways directly from the node.
  # If hostNetwork is true, this must be null or set to the same port as
  # containerPort.
  # NOTE: Cannot set to 8500 or 8502 because those are reserved for the Consul
  # agent.
  # @type: integer
  hostPort: null

  serviceAccount:
    # This value defines additional annotations for the mesh gateways' service account. This should be formatted as a
    # multi-line string.
    #
    # ```yaml
    # annotations: |
    #   "sample/annotation1": "foo"
    #   "sample/annotation2": "bar"
    # ```
    #
    # @type: string
    annotations: null

  # Resource settings for mesh gateway pods.
  # NOTE: The use of a YAML string is deprecated. Instead, set directly as a
  # YAML map.
  # @recurse: false
  # @type: map
  resources:
    requests:
      memory: "100Mi"
      cpu: "100m"
    limits:
      memory: "100Mi"
      cpu: "100m"

  # Resource settings for the `copy-consul-bin` init container.
  # @recurse: false
  # @type: map
  initCopyConsulContainer:
    resources:
      requests:
        memory: "25Mi"
        cpu: "50m"
      limits:
        memory: "150Mi"
        cpu: "50m"

  # By default, we set an anti-affinity so that two gateway pods won't be
  # on the same node. NOTE: Gateways require that Consul client agents are
  # also running on the nodes alongside each gateway pod.
  affinity: |
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app: {{ template "consul.name" . }}
              release: "{{ .Release.Name }}"
              component: mesh-gateway
          topologyKey: kubernetes.io/hostname

  # Optional YAML string to specify tolerations.
  # @type: string
  tolerations: null

  # Optional YAML string to specify a nodeSelector config.
  # @type: string
  nodeSelector: null

  # Optional priorityClassName.
  priorityClassName: ""

  # Annotations to apply to the mesh gateway deployment.
  #
  # Example:
  #
  # ```yaml
  # annotations: |
  #   'annotation-key': annotation-value
  # ```
  # @type: string
  annotations: null

# Configuration options for ingress gateways. Default values for all
# ingress gateways are defined in `ingressGateways.defaults`. Any of
# these values may be overridden in `ingressGateways.gateways` for a
# specific gateway with the exception of annotations. Annotations will
# include both the default annotations and any additional ones defined
# for a specific gateway.
# Requirements: consul >= 1.8.0
ingressGateways:
  # Enable ingress gateway deployment. Requires `connectInject.enabled=true`
  # and `client.enabled=true`.
  enabled: false

  # Defaults sets default values for all gateway fields. With the exception
  # of annotations, defining any of these values in the `gateways` list
  # will override the default values provided here. Annotations will
  # include both the default annotations and any additional ones defined
  # for a specific gateway.
  defaults:
    # Number of replicas for each ingress gateway defined.
    replicas: 2

    # The service options configure the Service that fronts the gateway Deployment.
    service:
      # Type of service: LoadBalancer, ClusterIP or NodePort. If using NodePort service
      # type, you must set the desired nodePorts in the `ports` setting below.
      type: ClusterIP

      # Ports that will be exposed on the service and gateway container. Any
      # ports defined as ingress listeners on the gateway's Consul configuration
      # entry should be included here. The first port will be used as part of
      # the Consul service registration for the gateway and be listed in its
      # SRV record. If using a NodePort service type, you must specify the
      # desired nodePort for each exposed port.
      # @type: array<map>
      # @default: [{port: 8080, port: 8443}]
      # @recurse: false
      ports:
        - port: 8080
          nodePort: null
        - port: 8443
          nodePort: null

      # Annotations to apply to the ingress gateway service. Annotations defined
      # here will be applied to all ingress gateway services in addition to any
      # service annotations defined for a specific gateway in `ingressGateways.gateways`.
      #
      # Example:
      #
      # ```yaml
      # annotations: |
      #   'annotation-key': annotation-value
      # ```
      # @type: string
      annotations: null

      # Optional YAML string that will be appended to the Service spec.
      # @type: string
      additionalSpec: null

    serviceAccount:
      # This value defines additional annotations for the ingress gateways' service account. This should be formatted
      # as a multi-line string.
      #
      # ```yaml
      # annotations: |
      #   "sample/annotation1": "foo"
      #   "sample/annotation2": "bar"
      # ```
      #
      # @type: string
      annotations: null

    # Resource limits for all ingress gateway pods
    # @recurse: false
    # @type: map
    resources:
      requests:
        memory: "100Mi"
        cpu: "100m"
      limits:
        memory: "100Mi"
        cpu: "100m"

    # Resource settings for the `copy-consul-bin` init container.
    # @recurse: false
    # @type: map
    initCopyConsulContainer:
      resources:
        requests:
          memory: "25Mi"
          cpu: "50m"
        limits:
          memory: "150Mi"
          cpu: "50m"

    # By default, we set an anti-affinity so that two of the same gateway pods
    # won't be on the same node. NOTE: Gateways require that Consul client agents are
    # also running on the nodes alongside each gateway pod.
    affinity: |
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchLabels:
                app: {{ template "consul.name" . }}
                release: "{{ .Release.Name }}"
                component: ingress-gateway
            topologyKey: kubernetes.io/hostname

    # Optional YAML string to specify tolerations.
    # @type: string
    tolerations: null

    # Optional YAML string to specify a nodeSelector config.
    # @type: string
    nodeSelector: null

    # Optional priorityClassName.
    priorityClassName: ""

    # Annotations to apply to the ingress gateway deployment. Annotations defined
    # here will be applied to all ingress gateway deployments in addition to any
    # annotations defined for a specific gateway in `ingressGateways.gateways`.
    #
    # Example:
    #
    # ```yaml
    # annotations: |
    #   "annotation-key": 'annotation-value'
    # ```
    # @type: string
    annotations: null

    # [Enterprise Only] `consulNamespace` defines the Consul namespace to register
    # the gateway into. Requires `global.enableConsulNamespaces` to be true and
    # Consul Enterprise v1.7+ with a valid Consul Enterprise license.
    # Note: The Consul namespace MUST exist before the gateway is deployed.
    consulNamespace: "default"

  # Gateways is a list of gateway objects. The only required field for
  # each is `name`, though they can also contain any of the fields in
  # `defaults`. Values defined here override the defaults except in the
  # case of annotations where both will be applied.
  # @type: array<map>
  gateways:
    - name: ingress-gateway

# Configuration options for terminating gateways. Default values for all
# terminating gateways are defined in `terminatingGateways.defaults`. Any of
# these values may be overridden in `terminatingGateways.gateways` for a
# specific gateway with the exception of annotations. Annotations will
# include both the default annotations and any additional ones defined
# for a specific gateway.
# Requirements: consul >= 1.8.0
terminatingGateways:
  # Enable terminating gateway deployment. Requires `connectInject.enabled=true`
  # and `client.enabled=true`.
  enabled: false

  # Defaults sets default values for all gateway fields. With the exception
  # of annotations, defining any of these values in the `gateways` list
  # will override the default values provided here. Annotations will
  # include both the default annotations and any additional ones defined
  # for a specific gateway.
  defaults:
    # Number of replicas for each terminating gateway defined.
    replicas: 2

    # A list of extra volumes to mount. These will be exposed to Consul in the path `/consul/userconfig/<name>/`.
    #
    # Example:
    #
    # ```yaml
    # extraVolumes:
    #   - type: secret
    #     name: my-secret
    #     items: # optional items array
    #       - key: key
    #         path: path # secret will now mount to /consul/userconfig/my-secret/path
    # ```
    # @type: array<map>
    extraVolumes: []

    # Resource limits for all terminating gateway pods
    # @recurse: false
    # @type: map
    resources:
      requests:
        memory: "100Mi"
        cpu: "100m"
      limits:
        memory: "100Mi"
        cpu: "100m"

    # Resource settings for the `copy-consul-bin` init container.
    # @recurse: false
    # @type: map
    initCopyConsulContainer:
      resources:
        requests:
          memory: "25Mi"
          cpu: "50m"
        limits:
          memory: "150Mi"
          cpu: "50m"

    # By default, we set an anti-affinity so that two of the same gateway pods
    # won't be on the same node. NOTE: Gateways require that Consul client agents are
    # also running on the nodes alongside each gateway pod.
    affinity: |
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchLabels:
                app: {{ template "consul.name" . }}
                release: "{{ .Release.Name }}"
                component: terminating-gateway
            topologyKey: kubernetes.io/hostname

    # Optional YAML string to specify tolerations.
    # @type: string
    tolerations: null

    # Optional YAML string to specify a nodeSelector config.
    # @type: string
    nodeSelector: null

    # Optional priorityClassName.
    # @type: string
    priorityClassName: ""

    # Annotations to apply to the terminating gateway deployment. Annotations defined
    # here will be applied to all terminating gateway deployments in addition to any
    # annotations defined for a specific gateway in `terminatingGateways.gateways`.
    #
    # Example:
    #
    # ```yaml
    # annotations: |
    #   'annotation-key': annotation-value
    # ```
    # @type: string
    annotations: null

    serviceAccount:
      # This value defines additional annotations for the terminating gateways' service account. This should be
      # formatted as a multi-line string.
      #
      # ```yaml
      # annotations: |
      #   "sample/annotation1": "foo"
      #   "sample/annotation2": "bar"
      # ```
      #
      # @type: string
      annotations: null

    # [Enterprise Only] `consulNamespace` defines the Consul namespace to register
    # the gateway into. Requires `global.enableConsulNamespaces` to be true and
    # Consul Enterprise v1.7+ with a valid Consul Enterprise license.
    # Note: The Consul namespace MUST exist before the gateway is deployed.
    consulNamespace: "default"

  # Gateways is a list of gateway objects. The only required field for
  # each is `name`, though they can also contain any of the fields in
  # `defaults`. Values defined here override the defaults except in the
  # case of annotations where both will be applied.
  # @type: array<map>
  gateways:
    - name: terminating-gateway

# Configures a demo Prometheus installation.
prometheus:
  # When true, the Helm chart will install a demo Prometheus server instance
  # alongside Consul.
  enabled: false

# Control whether a test Pod manifest is generated when running helm template.
# When using helm install, the test Pod is not submitted to the cluster so this
# is only useful when running helm template.
tests:
  enabled: true
