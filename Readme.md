# Instructions
 Follow the instructions below to deploys the infrastruce using terraform.
 Deployments to each environment are performed using tfvar files with environment specific parameters.

## Note
1. Parameters for the backend configuration files must be set before creating the backend 
2. Parameters on the backend configuration files must be set before backend creation
3. The backend for the terraform statefile must be created and initialized for each environment


## Build Infrastructure
### Create s3 bucket for Terraform backend
Create and s3 bucket following the steps below:

1. Dont use upper case characters in the bucket name.
2. Disable public access.
3. Enable versioning.
4. Enable server-side encryption.
5. Update the backend_<env>.conf files for each environment in the /backend folder with the bucketname.

### Build Infrastructure
 *Do not perform the steps below without creating the s3 backend*
2. Initialize terraform and backend - `terraform init -backend-config="./backend/<env>.conf"`
3. Create infrastructure - `terraform apply -var-file=env/<env>.tfvars --auto-approve`

## Destroy Infrastructure
1. Destroy infrastructure - `terraform destroy -var-file=env/<env>.tfvars --auto-approve`
