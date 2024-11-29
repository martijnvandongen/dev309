# CloudFormation L2

## Install

Install sceptre:

```text
brew install sceptre 
```

## Project Structure

```text
.
├── config
│   ├── config.yaml
│   └── demo
│       ├── config.yaml
│       ├── dynamodb.yaml
│       ├── lambda.yaml
│       └── vpc.yaml
├── readme.md
└── templates
    ├── dynamodb.yaml
    ├── lambda.yaml
    └── vpc.yaml
```

## Validate & Deploy

To validate

```text
sceptre validate demo
```

To deploy the stack

```text
sceptre launch demo
```

```text
sceptre delete demo
```

