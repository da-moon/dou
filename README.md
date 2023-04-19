![](https://www.datocms-assets.com/2885/1547508589-hashiconf.svg)
# Raffle
This repo contains the open source terraform (v0.12.6) code in order to select the lucky people of the DevOps practice in DigitalOnUs that will assist to the
[Hashiconf](https://hashiconf.hashicorp.com) event.


## Instructions

In the _terraform.tf_ file you'll find a couple of lists:*participants* and *certified*:

```yaml
  participants = [
      "Name"
  ]
  certified = [
      "Name"
  ]
```

Each list contains the names of the people in the DevOps practice at [DigitalOnUs](https://www.digitalonus.com/), so each collaborator that is interested in going to the [Hashiconf](https://hashiconf.hashicorp.com) event should commit a Pull Request with his name in any or both lists depending on the following criteria:

- If you are not yet certified in any of the [Hashicorp](https://www.hashicorp.com/) tools (Terraform, Vault, Consul or Nomad) you should put your name only in the *participants* list.
- If you have a certification you can put your name in both lists.

In order to make this fairly, candidates with a certification would have a double chance to win.

## prerequisites to participate

- Have a professional interest in going
- Not much affecton on your billable hours
- Share the knowledge with the other guys that were not able to go

## dates
- The last day for doing your pull request is Thu 15th before noon
- The raffle will take place in the DevOps meeting that day
