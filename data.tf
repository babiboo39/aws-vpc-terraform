data "aws_customer_gateway" "cgw" {
    filter {
        name   = "tag:Name"
        values = ["<TAG_VALUE>"]
    }
}