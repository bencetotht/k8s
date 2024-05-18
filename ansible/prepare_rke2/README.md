# Running the playbook:
- Edit the `hosts.ini` file and adjust the variables accordingly in the `all.yaml` file
- Run the playbook with your ssh key file
```bash
ansible-playbook site.yaml -i ./inventory/hosts.ini --key-file ~/.ssh/id-rsa
```