clusterid = "my-test-cluster"
dns_domain = "nip.io"
region = "us-east-1"
profile = "default"
public_cidr_subnets = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24"]
private_cidr_subnets = ["172.16.16.0/20", "172.16.32.0/20", "172.16.48.0/20"]
ec2_type_bastion = "t2.large"
ec2_type_master = "t2.xlarge"
ec2_type_infra = "t2.large"
ec2_type_node = "t2.large"

# us-east-1
rhel_ami_id = "ami-6871a115"

# us-east-2
#rhel_ami_id = "ami-03291866"