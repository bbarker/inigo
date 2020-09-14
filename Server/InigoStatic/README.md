
# Local

To run locally, simply run:

```bash
make local-server
```

# Deployment

Make sure you have `~/InigoServer.tfvars` set.

Then first, build the server:

```bash
make server
```

Next, plan the terraform changes:

```bash
terraform plan -var-file=~/InigoStatic.tfvars
```

Finally, apply the terraform changes:

```bash
terraform apply -var-file=~/InigoServer.tfvars
```

Then everything should be running.
