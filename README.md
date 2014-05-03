Dockworker Cookbook
-------------------
This cookbook contains two components: a Packer template to build a Docker-capable Ubuntu 13.04 AMI & a cookbook that creates Docker images & containers for memcached

Requirements
-----
This cookbook looks for an encrypted data bag named `docker` with a data bag item named `auth`. This holds your password for logging into https://index.docker.io. The format of the data bag item should look something like this:

```
{
  "id" : "auth",
  "registry_pwd": "super_secret_password"
}
```

Once the encrypted data bag has been uploaded to a Chef server, you should download the encrypted JSON to a local `data_bags` directory in your chef-repo. You can do this easily by running `knife download /data_bags/docker` from the root of your chef-repo.

In order to provision the created AMI, it is highly recommended that you use [knife-ec2](https://github.com/opscode/knife-ec2). As part of the setup of this knife plugin, you should set some local environment variables to avoid passing credentials over the command line:

```
export AWS_ACCESS_KEY='myamazonaccesskey'
export AWS_SECRET_KEY='myamazonsecretkey'
```

Usage
-----
The first step is to put the `packer-ubuntu-amazon.json` file in the root of your chef-repo and create an AMI that is enabled with Docker provisioning bits:

```
mv packer-ubuntu-amazon.json ../../packer-ubuntu-amazon.json
packer build packer-ubuntu-amazon.json
```

Once the AMI is completed, you can bootstrap an EC2 server using this new AMI with `knife ec2`:

```
knife ec2 server create -I ami-XXXXXX -f m3.medium --aws-access-key-id $AWS_ACCESS_KEY --aws-secret-access-key $AWS_SECRET_KEY --ssh-key my_keypair --ssh-user ubuntu --identity-file ~/.ssh/my_keypair.pem --ebs-size 40 --run-list 'recipe[dockworker::provisioner], recipe[dockworker::base_image], recipe[dockworker::run_containers]'
```

You should be able to verify that memcached is running by logging into the newly created instance and testing the status of the Docker container and the memcached process:

```
sudo docker ps

CONTAINER ID        IMAGE                  COMMAND                CREATED             STATUS              PORTS                      NAMES
f3c333f82ca2        memcached_img:latest   /bin/sh -c memcached   19 minutes ago      Up 19 minutes       0.0.0.0:45001->11211/tcp   memcached_img
```

```
telnet localhost 45001

Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
stats
STAT pid 7
STAT uptime 802
STAT time 1399123034
STAT version 1.4.14 (Ubuntu)
...
```
