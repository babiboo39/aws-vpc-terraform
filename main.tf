# VPN Site-to-Site
resource "aws_vpn_gateway" "vgw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.environment}_AWS_VGW"
    }
}

resource "aws_vpn_connection" "sts" {
    vpn_gateway_id              = aws_vpn_gateway.vgw.id
    customer_gateway_id         = data.aws_customer_gateway.cgw_sf.id
    type                        = "ipsec.1"
    static_routes_only          = true
    local_ipv4_network_cidr     = var.sts["local_ipv4_network_cidr"]
    remote_ipv4_network_cidr    = var.sts["local_ipv4_network_cidr"]
    tags = {
      Name = "${var.environment}_vpn-conn-aws-jkt"
    }
}

# Create VPC Resource
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc["cidr_block"]

    tags = {
        Name = var.vpc["name"]
    }
}

# ================== Optional ============= #
# DHCP Options
resource "aws_vpc_dhcp_options" "dhcp_opts" {
    domain_name          = var.dhcp_opts["domain_name"]
    domain_name_servers  = var.dhcp_opts["domain_name_servers"]
    ntp_servers          = var.dhcp_opts["ntp_servers"]

    tags = {
        Name = "${var.environment}_${var.dhcp_opts["name"]}"
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id          = aws_vpc.vpc.id
    dhcp_options_id = aws_vpc_dhcp_options.dhcp_opts.id
}
# ========================================= #

# Subnets
# Igw for Public Subnet
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.environment}-igw"
    }
}

# EIP for NAT GW
resource "aws_eip" "nat_eip" {
    vpc         = true
    depends_on  = [aws_internet_gateway.igw]
}

# NAT
resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = element(aws_subnet.public_subnets.*.id, 0)

    tags = {
      Name          = "${var.environment}-NATGW"
      environment   = "${var.environment}"
    }
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnets["cidr_block"]

    tags = {
        Name = "${var.environment}_${var.public_subnets["name"]}"
    }
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
    vpc_id = aws_vpc.vpc.id
    for_each = var.private_subnets
    cidr_block = each.value.cidr_block

    tags = {
        Name = "${var.environment}_${each.value.name}"
    }
}

# Routing tables 
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.environment}-rtb-private"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.environment}_rtb-public"
    }
}

# Route for IGW and NGW
resource "aws_route" "public_igw" {
    route_table_id          = aws_route_table.public.id
    destination_cidr_block  = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.igw.id
}

resource "aws_route" "private_ngw" {
    route_table_id          = aws_route_table.private.id
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.ngw.id
}

# Route table association
resource "aws_route_table_association" "public" {
    count           = length(var.public_subnets["cidr_block"])
    subnet_id       = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    for_each        = aws_subnet.private_subnets
    subnet_id       = each.value.id
    route_table_id  = aws_route_table.private.id
}

# ================= OPTIONAL =============== #
# Additional Route for RTB private and public
resource "aws_route" "private_rtb" {
    route_table_id          = aws_route_table.private.id
    count                   = length(var.destination_cidr_block)
    destination_cidr_block  = element(var.destination_cidr_block, count.index)
    gateway_id              = aws_vpn_gateway.vgw.id
}

resource "aws_route" "public_rtb" {
    route_table_id          = aws_route_table.public.id
    count                   = length(var.destination_cidr_block)
    destination_cidr_block  = element(var.destination_cidr_block, count.index)
    gateway_id              = aws_vpn_gateway.vgw.id
}
# ========================================= #




