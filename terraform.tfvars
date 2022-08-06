vpc = {
    name        = "development-vpc"
    cidr_block  = "172.16.0.0/12"
}
# ============= Subnets Variables ============= #
public_subnets = {
    name        = "Public_Subnet"
    cidr_block  = "172.16.1.0/24"
}

private_subnets = {
    private-subnet-1 = {
        name        = "private-subnet-1"
        cidr_block  = "172.16.2.0/24"
    }
    private-subnet-2 = {
        name        = "private-subnet-2"
        cidr_block  = "172.16.3.0/24"
    }
    private-subnet-3 = {
        name        = "private-subnet-3"
        cidr_block  = "172.16.4.0/24"
    }
    private-subnet-4 = {
        name        = "private-subnet-4"
        cidr_block  = "172.16.5.0/24"
    }
    private-subnet-5 = {
        name        = "private-subnet-5"
        cidr_block  = "172.16.6.0/24"
    }
}

# ========= DHCP Options ========== #
dhcp_opts = {
    name                = "<DHCP_NAME>"
    domain_name         = "<DOMAIN_NAME>"
    domain_name_servers = ["<DOMAIN_NAME_SERVER>"]
    ntp_servers         = ["<NTP_SERVERS>"]
}

# ======== For RTB if you has VGW ======== #
destination_cidr_block = ["<CIDR_BLOCK>", "<CIDR_BLOCK>", "<CIDR_BLOCK>"]

# ============= STS vars =========== #
sts = {
    local_ipv4_network_cidr = "<CIDR_BLOCK>"
    remote_ipv4_network_cidr = "<CIDR_BLOCK>"
}