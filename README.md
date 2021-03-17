# VirtualboxWSL2

A plugin for Vagrant that fixes `vagrant up` and `vagrant ssh` when executed from WSL2.

Two things happen on top of normal Vagrant behavior:
- the second port forwarding entry is created on 0.0.0.0 that allows to ssh to VirtualBox VM from WSL2 on Windows IP.
- Windows IP is automatically selected for `vagrant ssh` command instead of localhost.

## Installation

```
vagrant plugin install virtualbox_WSL2
```

## Usage

Nothing special, just use standard `vagrant up` and `vagrant ssh` commands.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/karandash8/virtualbox_WSL2.
