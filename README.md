### tf_testing

## Purpose of the Repo
Terraform unit testing for the Infrastructure defined in tf manifest.

### The problem with Unit Testing.
Terraform does not include any built-in means to mock the behavior of a provider / modules / Cloud resources. 
So a terraform module is generally tested using integration testing rather than unit testing, e.g. by writing a testing-only 
Terraform configuration that calls the module in question with suitable arguments to exercise the behaviors we wish to test.
The testing process is then to run terraform apply within that test configuration and observe it making the intended changes. 
Once you are finished testing you can run terraform destroy to clean up the temporary infrastructure that the test configuration declared.
A typical Terraform module doesn't have much useful behavior in itself and instead is just a wrapper around provider behaviors, 
so integration testing is often a more practical approach than unit testing in order to achieve confidence 
that the module will behave as expected in real use.


### How to Solve this problem
Out of different solutions provided like
```text
Terratest by terragrunt
Hashicorp Sentinel
Terraspec
```

This document stresses the CNCF incubating project OPA, Open Policy Agent 
```text
https://www.openpolicyagent.org/.
``` 

It comes with out of the integration with other cloud native project 
```
https://www.openpolicyagent.org/docs/latest/ecosystem/
```
 
 
OPA - Unit testing based on Enforcing Policies.
The idea is to write policies in a declarative language Rego and enforce policies in microservices, Kubernetes, 
CI/CD pipelines, terraform and more as a validation step before the resources actually get deployed.
 
 
OPA generates policy decisions by evaluating the query input and against policies and data. 
OPA and Rego are domain-agnostic making it useful across any kind of invariant policies.
``` text 
Which users can access which resources.
Which subnets egress traffic is allowed to.
Which clusters a workload must be deployed to.
Which registries binaries can be downloaded from.
Which OS capabilities a container can execute with.
Which times of day the system can be accessed at.
```
Policy decisions are not limited to simple yes/no or allow/deny answers. Like query inputs, your policies can generate arbitrary structured data as output.
 
 
 
### References

https://www.openpolicyagent.org/docs/latest/

https://www.openpolicyagent.org/docs/latest/terraform/
