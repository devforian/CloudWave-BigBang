userdata
#!/bin/bash
# Update the package list
yum update -y
# Install Ruby and AWS CodeDeploy Agent
mkdir build
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
chmod +x ./install
sudo yum install -y ruby
sudo ./install auto
sudo service codedeploy-agent status
# Install Docker
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
# Pull Docker image from S3 bucket and run it
sudo aws s3 cp s3://cicd-component-bucket-313416823553/my-docker-image.tar /tmp/
sudo docker load -i /home/ec2-user/my-docker-image.tar
sudo docker run -d -p 80:3000 seungzaelee/bb-react:latest