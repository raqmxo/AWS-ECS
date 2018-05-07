resource "aws_instance" "web" {
  ami           = "ami-9a562df2"
  instance_type = "t2.micro"
}
