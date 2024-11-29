# DEV309 - How to choose between AWS CloudFormation, Terraform, and AWS CDK

The files in the repository belong to the session DEV309 which I presented at AWS re:Invent 2024. 

> Unfortunately I didn't find the time to refactor all solutions. Therefore there might be bugs, it lacks some (inline) documentation, and not every solution is 100% aligned. This is still my plan for early 2025, until that time you're able to use this repo as a source of inspiration.

### Session abstract 

Both HashiCorp Terraform and AWS CloudFormation have attracted large numbers of fans from the moment they were launched, with AWS CDK gaining more traction as well. However, highly opinionated users have often only used one, sometimes two of these tools, and their experiences are not up to date with the latest features and possibilities. In this session, explore high-paced, live coding examples with all three, and then dive deep into some specific scenarios. At the end, leave with the ability to make informed decisions and select the best tool for the job.

### Folder Structure

I presented 9 ways to deploy the same app using tools: CloudFormation, Terraform and CDK.

* **app**. This folder contains the application. In the root of the folder is a zipped version of the app.
* **cfn-l1**. This folder contains the template to deploy a CloudFormation stack.
* **cfn-l2**. This folder contains the Sceptre + CloudFormation project.
* **cfn-l2-with-tf**. This folder contains the project where we deploy CloudFormation stacks using Terraform.
* **cdk-l1**. This folder contains the project with CDK using L1-constructs, for example: "CfnVpc"
* **cdk-l2**. This folder contains the project with CDK using L2-constructs, for example: "Vpc"
* **cdk-l3**. This folder contains the project with CDK using L3-construct which I created: "FunctionApp".
* **tf-l1**. This folder contains the basic project built with Terraform where I use the native AWS provider for all resources.
* **tf-l2**. This folder contains the basic project built with Terraform where I use publicly available modules for common resources.
* **tf-l3**. This folder contains the tf-l2 converted into a shared module.