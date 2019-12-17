Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # 业务前缀
    modulePrefixName = "test"
    moduleStartIp = "192.168.33.1"
    nodesNum = 2

    # 根据业务前缀生成node节点信息
    masterNodeIp = "#{moduleStartIp}0"
    masterNodeName = "#{modulePrefixName}-master"
    nodeHash = Hash.new
    hosts = "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4\n"
    hosts += "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6\n"
    hosts += "#{masterNodeIp} #{masterNodeName} \n"
    nodeHash[masterNodeIp]=masterNodeName
    (1...nodesNum+1).each do |nodeNum|
    	workerNodeIp = "#{moduleStartIp}#{nodeNum}"
    	workerNodeName = "#{modulePrefixName}-node#{nodeNum}"
    	hosts += "#{workerNodeIp} #{workerNodeName} \n"
    	nodeHash[workerNodeIp]=workerNodeName
    end

    updateHostsCommand = <<-ABC
    	echo -e "#{hosts}" >> /etc/hosts
    ABC

    # 开始创建节点
    nodeHash.each{ |nodeIp,nodeName|
    	config.vm.define "#{nodeName}" do |node|
    		config.ssh.username = "vagrant"
			config.ssh.password = "vagrant"
			node.vm.box = "centosbyzb"
			node.vm.provider "virtualbox" do |v|
			  v.name = nodeName
			  v.customize ["modifyvm", :id, "--memory", "1024"]
			end    	
			node.vm.network :private_network, ip: nodeIp
			node.vm.hostname = nodeName
			# 检查防火墙
			node.vm.provision "shell", path: "scripts/setup-centos.sh"	
			# 配置hosts

			node.vm.provision "shell", inline: updateHostsCommand	

			puts "#{nodeName}:#{nodeIp} done"
		end
    }

    # 各个节点免登
    nodeHash.each{ |nodeIp,nodeName|
		nodeHash.each{ |otherNodeIp,otherNodeName|
			config.vm.define nodeName do |node|	
				# 配置hosts
				if nodeName != otherNodeName
							sshCommand = <<-EOF
								ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
								cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys  	
								echo -e "Host *\nStrictHostKeyChecking no\nUserKnownHostsFile=/dev/null" >> ~/.ssh/config
								sshpass -p 'vagrant' ssh-copy-id -f -i ~/.ssh/id_rsa.pub #{otherNodeName}
							EOF
					#node.vm.provision "shell", inline: sshCommand
				end
			end
		}
	}

end
