Workstation Setup
=================

Clone this repo into `~/git`

Mac: `ansible-playbook -i inventory mac.yml -c local --extra-vars "username=$USER homedir=~"`
Ubuntu: `ansible-playbook -i inventory ubuntu.yml -c local --extra-vars "username=$USER homedir=~"`
Nixos:

```
$ sudo nixos-rebuild switch --impure --verbose --flake ~/git/emmettbutler/nixos
$ ansible-playbook -i inventory nix.yml -c local --extra-vars "username=$USER homedir=~" -e 'ansible_python_interpreter=/run/current-system/sw/bin/python'`
```
