Workstation Setup
=================

```
$ mkdir ~/git
$ cd ~/git
$ git clone https://github.com/emmettbutler/emmettbutler.git
```

Mac:
```
$ cd emmettbutler/ansible
$ brew install ansible
$ ansible-playbook -i inventory mac.yml --ask-become-pass -c local --extra-vars "username=$USER homedir=~"`
```

Ubuntu:

[Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html\#installing-ansible-on-ubuntu)

```
$ cd emmettbutler/ansible
$ apt install ansible
$ ansible-playbook -i inventory ubuntu.yml --ask-become-pass -c local --extra-vars "username=$USER homedir=~"`
```

Nixos:
```
$ cd emmettbutler/nixos
$ sudo nixos-rebuild switch --impure --verbose --flake .
$ cd ../ansible
$ ansible-playbook -i inventory nix.yml -c local --extra-vars "username=$USER homedir=~" -e 'ansible_python_interpreter=/run/current-system/sw/bin/python'`
```
