from aws_cdk import (
    Duration,
    Stack
)
from constructs import Construct
from cdk_constructs.function_app import FunctionApp

class DemoStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        FunctionApp(self, "FunctionApp")
