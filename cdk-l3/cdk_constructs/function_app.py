from aws_cdk import (
    Duration,
    Stack,
    aws_sqs as sqs,
    aws_dynamodb as dynamodb,
    aws_ec2 as ec2,
    aws_lambda as lambda_,
    aws_iam as iam,
    aws_s3 as s3,
    aws_cloudfront as cloudfront,
    aws_cloudfront_origins as origins
)
from constructs import Construct

class FunctionApp(Construct):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_dynamodb/Table.html
        table = dynamodb.Table(self, "lists",
            partition_key=dynamodb.Attribute(name="PK", type=dynamodb.AttributeType.STRING),
            sort_key=dynamodb.Attribute(name="SK", type=dynamodb.AttributeType.STRING),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST
        )

        # https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_ec2/Vpc.html
        vpc = ec2.Vpc(self, "VPC",
            ip_addresses=ec2.IpAddresses.cidr("10.0.0.0/16"),
            create_internet_gateway=False,
            max_azs=1,
            subnet_configuration=[
                ec2.SubnetConfiguration(
                    name="single",
                    cidr_mask=24,
                    subnet_type=ec2.SubnetType.PRIVATE_ISOLATED
                )
            ],
            gateway_endpoints={
                "DynamoDB": ec2.GatewayVpcEndpointOptions(
                    service=ec2.GatewayVpcEndpointAwsService.DYNAMODB
                )
            }
        )

        # https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_iam/Role.html
        role = iam.Role(self, "FunctionRole",
            assumed_by=iam.ServicePrincipal("lambda.amazonaws.com"),
            managed_policies=[
                iam.ManagedPolicy.from_aws_managed_policy_name("service-role/AWSLambdaBasicExecutionRole"),
                iam.ManagedPolicy.from_aws_managed_policy_name("service-role/AWSLambdaVPCAccessExecutionRole")
            ]
        )
        role.add_to_policy(iam.PolicyStatement(
            actions=["dynamodb:*"],
            resources=[table.table_arn]
        ))

        s3_bucket = s3.Bucket.from_bucket_name(self, "source", 
            bucket_name='dev309'
        )

        # https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_lambda/Function.html
        function = lambda_.Function(self, "Function",
            runtime=lambda_.Runtime.PYTHON_3_12,
            handler="main.lambda_handler",
            role=role,
            code=lambda_.Code.from_bucket(s3_bucket, "app.zip"),
            vpc=vpc,
            vpc_subnets=ec2.SubnetSelection(
                subnet_type=ec2.SubnetType.PRIVATE_ISOLATED
            ),
            environment={
                #"LISTS_TABLE": cfn_table.table_name
                "LISTS_TABLE": table.table_name
            }
        )

        # https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_lambda/Function.html#aws_cdk.aws_lambda.Function.add_function_url
        furl = function.add_function_url(
            auth_type=lambda_.FunctionUrlAuthType.NONE,
            cors=lambda_.FunctionUrlCorsOptions(
                allow_credentials=True,
                allowed_origins=["*"],
                allowed_headers=["date", "keep-alive"],
                exposed_headers=["keep-alive", "date"]
            )
        )

        # https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_cloudfront/CachePolicy.html#cachepolicy
        cache_policy = cloudfront.CachePolicy(self, "CachePolicy",
            default_ttl=Duration.seconds(0),
            min_ttl=Duration.seconds(0),
            max_ttl=Duration.seconds(1000),
            cookie_behavior=cloudfront.CacheCookieBehavior.all(),
            query_string_behavior=cloudfront.CacheQueryStringBehavior.all()
        )
        
        # https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_cloudfront/Distribution.html
        cloudfront.Distribution(self, "distro",
            default_behavior=cloudfront.BehaviorOptions(
                origin=origins.FunctionUrlOrigin(
                    lambda_function_url=furl
                ),
                cache_policy=cache_policy
            ),
            default_root_object="index.html"
        )
