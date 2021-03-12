require 'vagrant'

require_relative "virtualbox_WSL2/version"

module VirtualboxWSL2
  include VagrantPlugins::ProviderVirtualBox::Util::CompileForwardedPorts
  include VagrantPlugins::ProviderVirtualBox

  module WSL2CompileForwardedPorts
    include Vagrant::Util::ScopedHashOverride

    # This method compiles the forwarded ports into {ForwardedPort}
    # models.
    def compile_forwarded_ports(config)
      mappings = {}

      config.vm.networks.each do |type, options|
        if type == :forwarded_port
          guest_port = options[:guest]
          host_port  = options[:host]
          host_ip    = options[:host_ip]
          protocol   = options[:protocol] || "tcp"
          options    = scoped_hash_override(options, :virtualbox)
          id         = options[:id]

          # If the forwarded port was marked as disabled, ignore.
          next if options[:disabled]

          key = "#{host_ip}#{protocol}#{host_port}"
          mappings[key] =
            VagrantPlugins::ProviderVirtualBox::Model::ForwardedPort.new(id, host_port, guest_port, options)
        end
      end

      # Creating the second port forwarding entry for connections from WSL2 via Windows IP
      mappings.dup.each do |k, v|
        if Vagrant::Util::Platform.wsl? and k.start_with?("127.0.0.1tcp") and (v.id == "ssh")
          host_ip       = "0.0.0.0"
          host_port     = v.host_port
          guest_port    = v.guest_port
          protocol      = v.protocol
          id            = "ssh_wsl2"
          auto_correct  = v.auto_correct
          adapter       = v.adapter
          guest_ip      = v.guest_ip

          key = "#{host_ip}#{protocol}#{host_port}"
          mappings[key] =
            VagrantPlugins::ProviderVirtualBox::Model::ForwardedPort.new(id, host_port, guest_port, {:host_ip => host_ip, :protocol => protocol, :auto_correct => auto_correct, :adapter => adapter, :guest_ip => guest_ip})
        end
      end

      mappings.values
    end
  end

  module WSL2Provider
    # Returns the SSH info for accessing the VirtualBox VM.
    def ssh_info
      # If the VM is not running that we can't possibly SSH into it
      return nil if state.id != :running

      # Return what we know. The host is always "127.0.0.1" because
      # VirtualBox VMs are always local. The port we try to discover
      # by reading the forwarded ports.
      host_ip = "127.0.0.1"

      # If we run on WSL2, we need to ssh through Windows IP, which is set as the default route
      if Vagrant::Util::Platform.wsl?
        result = Vagrant::Util::Subprocess.execute("/bin/sh", "-c", "ip route | grep default | grep -Po '\\d+.\\d+.\\d+.\\d+'")
        if result.exit_code == 0
          host_ip = result.stdout.strip
        end
      end

      return {
        host: host_ip,
        port: @driver.ssh_port(@machine.config.ssh.guest_port)
      }
    end
  end
end

module VagrantPlugins
  module ProviderVirtualBox
    module Util
      module CompileForwardedPorts
        prepend VirtualboxWSL2::WSL2CompileForwardedPorts
      end
    end
  end
end

module VagrantPlugins
  module ProviderVirtualBox
    class Provider < Vagrant.plugin("2", :provider)
      prepend VirtualboxWSL2::WSL2Provider
    end
  end
end
