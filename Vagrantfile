Vagrant.configure("2") do |config|
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.define "box1" do |box1|
    box1.vm.box = "hashicorp/precise64"
  end

  config.vm.define "box2" do |box2|
    box2.vm.box = "hashicorp/precise64"
  end
end