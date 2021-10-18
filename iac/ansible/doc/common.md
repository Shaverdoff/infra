# Restrict execution on 1 host
```
ansible-playbook -i inventory/k8s-test -u ansible playbooks/k8s-test.yml --limit k8s-tst04
```
### Restrict tasks with tags
```
ansible-playbook -i inventory/heketi -u ansible playbooks/heketi.yml --tags gluster_client 

- name: install clients
  import_tasks: gluster_client.yml
  when: "(gluster_client is defined and gluster_client == 'true')"
  tags:
    - "gluster_client"
```
