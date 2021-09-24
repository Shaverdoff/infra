# ALLURE TESTOPS
https://docs.qameta.io/allure-testops/integrations/gitlab/main/

# Register on ALLURE TESTOPS
get a creds from them


# Install 
# docker login with user/password from allure
export user=qametaaccess password=42d21041-29ad-4862-b64d-08bcc3bf123123

docker login --username=$user --password=$password https://index.docker.io/v1/

# get docker-compose
wget https://docs.qameta.io/allure-testops/dist/allure-testops.zip
unzip allure-testops.zip

#edit .env
Check our release notes and update VERSION line of .env file.
Update LICENSE line of .env. file with the license information you received from our sales team.
Update JWT_SECRET line with the output of the following command: openssl rand -base64 16
# start
docker-compose pull       # will download all necessary images
docker-compose up -d      # will start the configuration
http://10.3.3.191:8080/login
admin/admin


# INTEGRATION WITH GITLAB
# server configure
wget https://github.com/allure-framework/allurectl/releases/latest/download/allurectl_linux_386 -O ./allurectl
chmod +x ./allurectl

# gitlab-configure
# create access token on gitlab for allure
https://git.company.ru/-/profile/personal_access_tokens
Token name - allure
Scope - api
ny1tmMrMRDB71aqweqwe

# allure configure
1) Create credentials for Gitlab in Administration section in Allure TestOps
click on profile/administration/credentials/create (select type type - Token and paste token from gitlab)
2) Create the build server for Gitlab system
Allure/menu/Administration/Build Server/Create
Endpoint - your gitlab instance e.g. https://git.company.ru
Type - gitlab
Credentials - select token name created at the previous step - gitlab
3) create API tokens
ALLURE/PROFILE/YOUR PROFILE/API_TOKEN/Create
f39basd7-eae5-4326-b7d5-17bed6bsad64





# GITLAB PROJECT CONFIGURE
# gitlab configure, create variables in project
ALLURE_ENDPOINT - https://allure.company.ru
# access token for allure
ALLURE_TOKEN - f39basd7-eae5-4326-b7d5-17bed6bsad64
# Allure TestOps project ID to which you are going to upload the results
ALLURE_PROJECT_ID - 1 

# ALLURE SIDE
go to http://allure/project/1/jobs
in JOB tabs configure project and select build server
also add ENV VARIABLE
BRANCH master(branch-name)




