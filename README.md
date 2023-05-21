# Test MariaDB AWS

This project sets up a number of hosts and configures master replication on the first node from the list of masters and slaves on all slave nodes.

## Prerequisites

The following tools need to be installed:

- Terraform
- Ansible
- AWS CLI

### Terraform Installation

#### Linux

```bash
wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip
unzip terraform_1.0.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

#### MacOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Ansible Installation

#### Linux

```bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

#### MacOS

```bash
brew install ansible
```

### AWS CLI Installation

[AWS CLI](https://aws.amazon.com/cli/?nc1=h_ls)


### AWS Configuration

Create a file at ~/.aws/credentials and include the following:
```bash
[default]
aws_access_key_id = <YOUR_AWS_ACCESS_KEY_ID>
aws_secret_access_key = <YOUR_AWS_ACCESS_KEY_VALUE>
region = <REGION>
```
Then, create a KeyPair in AWS with the name admin_kp.pem and download it to the project root.


### Ansible install role from galaxy ###
```bash
ansible-galaxy collection install community.proxysql --upgrade
```

### Deployment

1. Navigate to the **`./terraform/`** directory and run terraform init, then terraform apply.

2. After applying, you can access the hosts from the inventory using the command **`ssh -i admin_kp.pem ubuntu@<HOST_IP>`**.

3. Navigate to the **`./ansible/`** directory and run **`ansible-playbook -i inventory.yml playbooks/main.yml --extra-vars "replication_password=<REPLICATION_USER_PASSWORD>"`**. In extra-vars, specify the password for the REPLICATION_USER, which will be used for replication.

Passwords for root and dbadmin are stored in **`/root/`** on each of the hosts - **`.mariapass`** and **`.mariapass_dbadmin`**.

## Built With

- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- [AWS CLI](https://aws.amazon.com/cli/)


## Authors

Aleksei Khamidov

## License

This project is licensed under the MIT License.