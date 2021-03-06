### How to Run

## Requirements

The following tools are needed in order to execute the code:

- [Terraform](https://www.terraform.io/)
- [opa](https://www.openpolicyagent.org/docs/latest/#running-opa)

## Generating a terraform plan

execute the following commands (note that valid AWS credentials need to be available, as we are deploying AWS resources).
 
```bash
terraform init
terraform plan -out=tfplan
terraform show -json tfplan | jq > tfplan.json
```

## Evaluating the plan

```bash
# opa eval --format pretty --data terraform.rego --input tfplan.json "data.terraform.analysis.authz"
# opa eval --format pretty --data terraform.rego --input tfplan.json "data.terraform.analysis.score"
```
