output "main" {
   value = aws_vpc.main.id
}

output "public" {
    value = aws_subnet.public.id
  
}

output "private" {
    value = aws_subnet.private.id
  
}

output "database" {
    value = aws_subnet.database.id
  
}

output "private_pods" {
    value = aws_subnet.private_pods.id
  
}

output "igw" {
    value = aws_internet_gateway.igw.id
  
}

output "public_internet_access" {
  value = aws_route_table.public_internet_access.id
}

output "eip" {
    value = aws_eip.eip.id
  
}

output "ngw" {
    value = aws_nat_gateway.ngw.id
}

output "aws_network_acl" {
    value = aws_network_acl.database.id
  
}