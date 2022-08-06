# AWS VPC Terraform
This repository content is creating AWS VPC using Terraform
## Use Case
---
The Use case that used in this repository is to create a VPC, Subnets (Private and Public Subnets), Setting DHCP Options, Create Virtual Private Gateway and Site-to-site Connection using existing customer gateway, and also create Route tables and assigning subnets to the route table.

### Brief Explanation
---
#### `main.tf`
This file basically consist of all the resource that we want to create in our AWS account. In this file, you can define all the resource that you want to create, such as vpc, site-to-site vpn, route table, subnets, etc. 

#### `provider.tf`
Where you define all of the provider you need.

#### `data.tf`
This file consist the datasource, where I can call the existing resource on our AWS account. You are not necessarily have this file, since you can basically just everything in one terraform file, but if you want to easily manage and trace the error without scrolling too much in a single file, you can divide to several terraform file, based on the resource or the purpose. For example, if you want to create AWS Resources such as EC2, VPC, EKS, and etc, instead of putting every resource in one file, you can make several files like `ec2.tf`,`vpc.tf`,`eks.tf` and etc, based on the purpose of the file.

#### `outputs.tf`
If you want to show something like the IP address or maybe password (that randomly generated), you can define it in this file.

#### `variables.tf`
Just as the name, this file is where you define all the variables that used in your terraform (if you use variables).

#### `terraform.tfvars`
This file is not mandatory, I simply use it to define all the values for each variables that I use. Basically, we can just hardcode everything in the `main.tf` or any other terraform files. But imagine if you have several terraform files such as `ec2.tf`,`vpc.tf`,`eks.tf`. Then I need to create it for several environemt (`development`, `staging`, `production`) where each values of its variables is different. So by using `terraform.tfvars`, instead of change every values on each files, you can just change it in this file instead.

## Usage
---
### Before Using
---
As you can see in the `terraform.tfvars` file, there are several variables value that you can change by the exact value that you want, for example:
```
dhcp_opts = {
    name                = "<DHCP_NAME>"
    domain_name         = "<DOMAIN_NAME>"
    domain_name_servers = ["<DOMAIN_NAME_SERVER>"]
    ntp_servers         = ["<NTP_SERVERS>"]
}
```
Here you can just change the value to meet your need, for example:
```
dhcp_opts = {
    name                = "dhcp_opts_example"
    domain_name         = "example.com"
    domain_name_servers = ["10.5.2.1"]
    ntp_servers         = ["172.34.5.6"]
}
```
And also for the `<CIDR_BLOCK>` values that I put on the file, you can change it to your need.

### Using the File
---
```
terraform init
```
Then validate your resource to see how many resource that will be created using 
```
terraform plan
```
After confirming, execute
```
terraform apply
```

*Thank you, and keep learning and sharing - babiboo :pig_nose:*