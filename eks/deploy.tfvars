/*
    Set variable for the Terraform configuration in this file
    For a simple deployment you should only need to change:
        aws_profile - set to the appropriate value based on your AWS CLI configuration
        aws_region - set to the region you are using in your AWS account
    
    If you rebuild the API docker image and push it to a different repo, you can update the app_image value accordingly. 
*/
aws_profile = "bridgit"
aws_region = "us-east-1"

app_image = "404997700178.dkr.ecr.us-east-1.amazonaws.com/smart-pensions-test"

api_service_name = "api-service"
app_name = "smart-pension-reasons"
db = "api"
db_password = "fvyuIiWe8TDlFQuQ"
db_username = "app"
env = "dev"