data "aws_customer_gateway" "cgw_moratel" {
    filter {
        name   = "tag:Name"
        values = ["<TAG_VALUE>"]
    }
}