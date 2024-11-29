
module "cloudfront_lambda_app" {
    source = "./modules/cloudfront_lambda_app"

    stack_name = "example"
    lambda_source = "../app.zip"
}