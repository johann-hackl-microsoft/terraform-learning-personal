# terraform-learning-personal

Personal learning of terraform stuff.

Commands:

- `az login --tenant fdpo.onmicrosoft.com`
- `terraform init`
- `terraform fmt --recursive`
- `terraform validate`
- `terraform plan -out main.tfplan`
- `terraform apply main.tfplan`
- `terraform plan -destroy -out main.destroy.tfplan`
- `terraform apply main.destroy.tfplan`

## Basics

### Complex variables

```bash
cd C:\source\LearningVarious\terraform-learning-personal\Basics\Complex-variables
az login --tenant fdpo.onmicrosoft.com
terraform init
terraform fmt --recursive
terraform validate

terraform plan --var-file=env-full.tfvars --out main-full.tfplan
terraform apply --var-file=env-full.tfvars --out main-full.tfplan
terraform plan --var-file=env-full.tfvars --destroy -out main-full.tfplan
terraform apply --var-file=env-full.tfvars --out main-full.tfplan

terraform plan --var-file=env-min.tfvars --out main-min.tfplan
terraform apply --var-file=env-min.tfvars --out main-min.tfplan
terraform plan --var-file=env-min.tfvars --destroy -out main-min.tfplan
terraform apply --var-file=env-min.tfvars --out main-min.tfplan
```

### Distict-Elements-Creation

```cmd
cd C:\source\LearningVarious\terraform-learning-personal\Basics\Distict-Elements-Creation
terraform init
terraform fmt --recursive
terraform validate

echo "without version"
terraform apply

echo "only one version specified"
terraform apply -var 'setup_cb_version=V1.0'

echo "same version specified twice => no changes"
terraform apply -var 'setup_cb_version=V1.0' -var 'codebeamer_cb_version=V1.0'

echo "different version specified, no matter the order => first one creates a new file, second one results in no changes"
terraform apply -var 'setup_cb_version=V1.0' -var 'codebeamer_cb_version=V1.1'
terraform apply -var 'setup_cb_version=V1.1' -var 'codebeamer_cb_version=V1.0'

echo "change one version => replace older version with some new version"
terraform apply -var 'setup_cb_version=V1.1' -var 'codebeamer_cb_version=V1.2'


```

## External-File-Integration

### Locals-based-on-files

```cmd
cd C:\source\LearningVarious\terraform-learning-personal\External-File-Integration\Locals-based-on-files

echo "without version"
terraform apply -auto-approve
terraform output
```
