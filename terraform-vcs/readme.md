# what

- create a github repo
- create a terraform workspace, connect to that github repo so it can deploy

# how to run

```
terraform apply -var-file=main.tfvars
```

to destroy, first go to workspace Settings, destroy the infrastructure managed by terraform vcs

then run

```
terraform destroy -var-file=main.tfvars
```
