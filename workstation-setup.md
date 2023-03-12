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
$ ansible-playbook -i inventory mac.yml -c local --extra-vars "username=$USER homedir=~"`
```

Ubuntu:
```
$ cd emmettbutler/ansible
$ ansible-playbook -i inventory ubuntu.yml -c local --extra-vars "username=$USER homedir=~"`
```

Nixos:
```
$ cd emmettbutler/nixos
$ sudo nixos-rebuild switch --impure --verbose --flake .
$ cd ../ansible
$ ansible-playbook -i inventory nix.yml -c local --extra-vars "username=$USER homedir=~" -e 'ansible_python_interpreter=/run/current-system/sw/bin/python'`
```
