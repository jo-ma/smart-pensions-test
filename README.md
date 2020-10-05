# Smart Pension Infrastructure Test

## Overview

This repo contains a simple web API application and IaC to provision the infrastructure and deploy the application on AWS EKS.  The API application is a simple API written in Python that can be used to track reasons why an employer should hire a potential candidate.  The environment serves as a solution to the Smart Pension infrastructure test.  Both the API application and infrastructure configuration should not be considered appropriate for a production deployment, see [Some Considerations for a Production Deployment](#-some-considerations-for-a-production-deployment) for more information.

## Structure and Description

```bash
.
├── api                    # Root directory for the API app
│   ├── Dockerfile         # Dockerfile for the API app
│   ├── Pipfile
│   ├── Pipfile.lock
│   ├── requirements.txt
│   └── src                # Source code directory for the API app code
│       ├── app.py         # API code
│       ├── db.py          # Database read/write code
│       ├── models.py      # Object model definition
│       └── test_app.py    # Unit tests
├── eks                    # Directory for Terraform configuration for an AWS EKS deployment
│   ├── api_svc_deploy.tf  # Kubernetes service and deployment manifests for the API service
│   ├── cluster.tf         # EKS cluster definition utilizing the terraform-aws-modules/eks/aws module
│   ├── deploy.tfvars      # Deployment variables
│   ├── main.tf            # Central configuration for Terraform provider
│   ├── outputs.tf         # Output variables
│   ├── rds.tf             # RDS definition for a MySQL database
│   ├── variables.tf       # Variables definition folder
│   └── vpc.tf             # VPC configuration utilizing the terraform-aws-modules/vpc/aws module
├── demo                   # Directory for a basic demo python script
│   ├── demo.py            # The file to run for the demo, see section below for details
│   ├── Pipfile
│   └── Pipfile.lock
└── README.md
``` 
*There are additional comments in the individual files*

## Deployment
The AWS CLI >=v.2.0.49 should be installed and credentials configured.

Terraform >=v.0.13.14 should be installed.

An AWS account will be required and a user with appropriate IAM permissions.  The easiest approach would be to use a fresh AWS test account and a user with Administrator permissions, but I would not recommended that practice for regular work.

1. Navigate to the **eks directory**
2. Configure the variables in the **deploy.tfvars** appropriately.  You will probably only need to update the **aws_profile** and **aws_region** variables to the appropriate values for your AWS CLI configuration and preferred AWS region.
3. Execute a Terraform init command
```bash
terraform init
```
4. Execute a Terraform apply command
```bash
terraform apply -var-file="deploy.tfvars"
```
5. Review the plan and type **yes** on prompt to execute
6. On completion of the apply the **API endpoint** will be provided as an **output variable**
```bash
Outputs:

api_endpoint = a8d45defee8d34afc9c51a2fa1e0a8ae-478952727.us-east-1.elb.amazonaws.com
```
### Deployment Notes

- Deployment can take approximately 20 minutes, the majority accounted for by provisioning the EKS cluster and RDS instance.  
- The docker image is hosted in an open, ECR repo.  If you rebuild and push it do a different repo you will need to update the app_image variable to the new location.  
- If you want to access the kubernetes cluster using kubectl, you can copy the config to your kubectl config and then run any kubectl command.  
```bash
cp kubeconfig_smart-pension-reasons ~/.kube/config
```

### Demo

There is a small demo available that posts some data to the API service, then gets the data from the service and prints in a user friendly fashion.  

To run the demo follow these instructions:

1. **Copy** the **api_endpoint output** from the deployment 
2. Navigate to the **demo directory**
3. The demo script expects the API endpoint as an argument, execute the demo with the following command:
```bash
python demo.py [endpoint]  
```

An example using the output variable above is:
```bash
python demo.py a8d45defee8d34afc9c51a2fa1e0a8ae-478952727.us-east-1.elb.amazonaws.com  
```
4. Make sure to check the output in the console  

### Destroy Deployment
1. Execute a Terrafrom destroy command
```bash
terraform destroy -var-file="deploy.tfvars"  
```
2. Review the plan and type **yes** on prompt to execute

## Usage
You can utilize the API from the command line with commands similar to:

```bash
curl -d '{"reason":"Test"}' -X POST [endpoint]/reason  
   
curl [endpoint]/reason
```

### Examples
```bash
curl -d '{"reason":"Test"}' -X POST a8d45defee8d34afc9c51a2fa1e0a8ae-478952727.us-east-1.elb.amazonaws.com/reason
{"id":"e1fbb1ed-574a-4451-b21e-a500cf2c6091","reason":"Test"}
```

```bash
curl a8d45defee8d34afc9c51a2fa1e0a8ae-478952727.us-east-1.elb.amazonaws.com/reason
{"e1fbb1ed-574a-4451-b21e-a500cf2c6091":{"id":"e1fbb1ed-574a-4451-b21e-a500cf2c6091","reason":"Test"}}
```

## API Documentation

## Reasons
To add a reason you create a Reason object.  You can retrieve all reasons currently in the datastore.

### Endpoints
| Request | Path    | Body              | Response |
| :---:   | :---:   | :---:             | :---:    |
| POST    | /reason | {"reason":"Test"} | {"id":"e1fbb1ed-574a-4451-b21e-a500cf2c6091","reason":"Test"} |
| GET     | /reason | n/a               | {"e1fbb1ed-574a-4451-b21e-a500cf2c6091":{"id":"e1fbb1ed-574a-4451-b21e-a500cf2c6091","reason":"Test"}} |
### The Reason object
```json
{  
    "id": "0eb08dfe-f52d-4b9c-b037-b1eda9f5be3f",  
    "reason": "This is a sample reason"  
}
```
**id** *string*  
UUID used as a unique identifier for the reason.
  
**reason** *string*  
The actual text string representing the reason.

## Some Considerations for a Production Deployment  
This is not meant to represent an exhaustive list.  Some considerations are:

- Observability tools to surface logs, metrics and traces
- Permissions configuration using IAM and RBAC for least privilege permissions pattern
- Improved automated testing for code coverage and security
- Load testing
- EKS and Kubernetes auto-scaling configuration
- Authentication and authorization
- TLS for the public endpoint and data encryption in transit and at rest 
- Securely handling secrets using HashiCorp vault or similar
- Optimizing the Dockerfile for size
- A more robust management of migrations for database structure
- Improve the API application for better error handling and reliability
- Optimize the Terraform configuration for reliable deployments
- Vetting of Terraform modules for security and best practice configurations

## Known Issues
1. Occasionally a Terraform apply will timeout.  Generally Terraform apply can be executed again to complete the deployment.
2. Occasionally a Terraform destroy will timeout.  Sometimes this can be resolved by executing an additional Terraform destroy.  Sometimes the AWS services not destroyed may require manual removal.