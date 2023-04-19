# What is IaC? 🏗

Infrastructure as Code (IaC) is the management of infrastructure (networks, virtual machines, load balancers, and connection topology) in a descriptive model, using the same versioning as DevOps team uses for source code. Like the principle that the same source code generates the same binary, an IaC model generates the same environment every time it is applied. IaC is a key DevOps practice and is used in conjunction with continuous delivery.

## IaC solves real problems
Infrastructure as Code evolved to solve the problem of environment drift in the release pipeline. Without IaC, teams must maintain the settings of individual deployment environments. Over time, each environment becomes a snowflake, that is, a unique configuration that cannot be reproduced automatically. Inconsistency among environments leads to issues during deployments. With snowflakes, administration and maintenance of infrastructure involves manual processes which were hard to track and contributed to errors.

Idempotence is a principle of Infrastructure as Code. Idempotence is the property that a deployment command always sets the target environment into the same configuration, regardless of the environment's starting state. Idempotency is achieved by either automatically configuring an existing target or by discarding the existing target and recreating a fresh environment.

Accordingly, with IaC, teams make changes to the environment description and version the configuration model, which is typically in well-documented code formats such as JSON. The release pipeline executes the model to configure target environments. If the team needs to make changes, they edit the source, not the target.

## IaC delivers real benefits
Infrastructure as Code enables DevOps teams to test applications in production-like environments early in the development cycle. These teams expect to provision multiple test environments reliably and on demand. Infrastructure represented as code can also be validated and tested to prevent common deployment issues. At the same time, the cloud dynamically provisions and tears down environments based on IaC definitions.

Teams who implement IaC can deliver stable environments rapidly and at scale. Teams avoid manual configuration of environments and enforce consistency by representing the desired state of their environments via code. Infrastructure deployments with IaC are repeatable and prevent runtime issues caused by configuration drift or missing dependencies. DevOps teams can work together with a unified set of practices and tools to deliver applications and their supporting infrastructure rapidly, reliably, and at scale.

## Prefer declarative definitions
The preferred approach to IaC is to use declarative definition files where possible. A definition file specifies the what an environment requires and not necessarily the how. In other words, it may define the specific version and configuration of a server component as a requirement, but does not specify the process for installing and configuring it. This abstraction allows for greater flexibility in the middle, such as optimized techniques the infrastructure provider may employ. It also helps reduce the technical debt of maintaining imperative code, such as deployment scripts, that can accrue over time.

There is no single standard syntax for declarative IaC. Different platforms support different, and often multiple, file formats, such as YAML, JSON, and XML. As a result, the decision to select a syntax for describing IaC usually comes down to the requirements of the target platform.

## Using IaC on Cloud
most of the cloud provider native support for IaC. Teams can define declarative templates that specify the infrastructure required to deploy their solutions.

Teams can also use the IaC supported by popular third party platforms, such as Terraform.

![](https://decidesoluciones.es/wp-content/uploads/2022/01/Terraform.png)

> For more information, visit [Infrastructure as Code by Wikipedia](https://en.wikipedia.org/wiki/Infrastructure_as_code)