resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  

  tags = {
    Name = "Curso_Eks_${var.project_name}"
    Terraform = true
  }
}

# Associação para segundo range vpc _ DOC RFC: 
resource "aws_vpc_ipv4_cidr_block_association" "main" {
    count = length(var.vpc_additional_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.vpc_additional_cidrs[count.index]

  
}




/*          Subnet_publica                       */
resource "aws_subnet" "public" {
  for_each = var.public_subnet


  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.project_name}_${each.key}"
  }

  depends_on = [ aws_vpc_ipv4_cidr_block_association.main ]
}

## RTB - Public ###

resource "aws_route_table" "public_internet_access" {
  vpc_id = aws_vpc.main

  tags = {
    Name = "${var.project_name}_public"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public_internet_access.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
   
}

## RTB - Association public ##

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_internet_access.id
}

## EIP ###

resource "aws_eip" "eip" {
  for_each = var.public_subnet

  domain = "vpc"

  tags = {
    Name = "eip-${each.key}"
  }
}

### NGW ###

resource "aws_nat_gateway" "ngw" {
  for_each = var.public_subnet

  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "NAT_${each.key}"
  }

}




/*        Subnet_privada.              */

resource "aws_subnet" "private" {
  for_each = var.priv_subnet


  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}


### RTB - Priv ###

resource "aws_route_table" "private" {
  for_each = var.priv_subnet

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}_priv"
  }
  
}

resource "aws_route" "private" {
  for_each = var.priv_subnet

  route_table_id = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  
  
  gateway_id = aws_internet_gateway.igw.id  
   
}

## RTB - Association priv ##

resource "aws_route_table_association" "private" {
  for_each = var.priv_subnet

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}




/* Subnet_database */ 

resource "aws_subnet" "database" {
  for_each = var.database_subnet


  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }

  depends_on = [ aws_vpc_ipv4_cidr_block_association.main ]
}

### NACL's ####

resource "aws_network_acl" "database" {
  vpc_id = aws_vpc.main.id

  egress = {
    rule_no = 200
    protocol = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  tags = {
    Name = "${var.project_name}_database_acl"
  }
  
}

resource "aws_network_acl_rule" "deny" {
  network_acl_id = aws_network_acl.database.id
  rule_number = "300"
  rule_action = "deny"

  protocol = "-1"

  cidr_block = "0.0.0.0/0"
  from_port = 0 
  to_port = 0  
}

resource "aws_network_acl_rule" "allow_3306" {
  for_each = var.priv_subnet

  network_acl_id = aws_network_acl.database.id
  rule_number = 10 + each.key
  rule_action = "allow"

  protocol = "tcp"

  cidr_block = aws_subnet.private[each.key].cidr_block
  from_port = 3306 
  to_port = 3306  
}

resource "aws_network_acl_rule" "allow_6379" {
  for_each = var.priv_subnet

  network_acl_id = aws_network_acl.database.id
  rule_number = 20 + each.key
  rule_action = "allow"

  protocol = "tcp"

  cidr_block = aws_subnet.private[each.key].cidr_block
  from_port = 6379
  to_port = 6379 
}

resource "aws_network_acl_association" "database" {
  for_each = var.database_subnet
  
  network_acl_id = aws_network_acl.database.id
  subnet_id = aws_subnet.database[each.key].id
}



/* Subnet_public_pods */ 

resource "aws_subnet" "private_pods" {
  for_each = var.private_pods


  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}