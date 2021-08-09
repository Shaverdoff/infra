```
before_script:
    - 'which ssh-agent || ( yum install update -y && yuminstall openssh-client -y )'
    - eval $(ssh-agent -s)
    - mkdir -p ~/.ssh/
    - chmod 700 ~/.ssh/
    - echo "${SSH_PRIVATE_KEY}" | tr -d '\r' | ssh-add - > /dev/null
```
