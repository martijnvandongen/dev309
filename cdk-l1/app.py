#!/usr/bin/env python3
import os
import aws_cdk as cdk
from demo.demo_stack import DemoStack
app = cdk.App()
DemoStack(app, "demo-stack-cdk-l1")
app.synth()
