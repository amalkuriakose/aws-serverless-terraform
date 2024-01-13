output "lambda_function_name" {
  value = aws_lambda_function.lambda_function.function_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = [for item in aws_subnet.public_subnets : item.id]
}

output "private_subnets" {
  value = [for item in aws_subnet.private_subnets : item.id]
}

output "igw" {
  value = aws_internet_gateway.igw.id
}

output "natgw" {
  value = aws_nat_gateway.natgw.id
}

output "natgw-eip" {
  value = aws_eip.eip.public_ip
}