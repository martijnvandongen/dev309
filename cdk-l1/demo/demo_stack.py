from aws_cdk import (
    Duration,
    Stack,
    aws_ec2 as ec2
)
from constructs import Construct

class DemoStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # result of this block is 4 (!) lines of CloudFormation code
        vpc_l1 = ec2.CfnVPC(self, "VPCL1",
            cidr_block="10.0.0.0/16"
        )

        # result of this block ~400 lines of CloudFormation code
        vpc_l2 = ec2.Vpc(self, "VPCL2",
            ip_addresses=ec2.IpAddresses.cidr("10.0.0.0/16")
        )
