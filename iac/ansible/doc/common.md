# Restrict execution on 1 host
```
ansible-playbook -i inventory/k8s-test -u ansible playbooks/k8s-test.yml --limit k8s-tst04
```
