# TESTING your k8s cluster with SONOBUOY
https://github.com/vmware-tanzu/sonobuoy
```
# ON MASTER NODE
https://github.com/vmware-tanzu/sonobuoy/releases
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.54.0/sonobuoy_0.54.0_linux_amd64.tar.gz
tar -xvf sonobuoy_0.54.0_linux_amd64.tar.gz
# To launch conformance tests (ensuring CNCF conformance) and wait until they are finished run:
./sonobuoy run --wait
# Get the results from the plugins (e.g. e2e test results):
results=$(sonobuoy retrieve)
# Inspect results for test failures. This will list the number of tests failed and their names:
sonobuoy results $results

### Monitoring Sonobuoy during a run
# You can check on the status of each of the plugins running with:
sonobuoy status
# You can also inspect the logs of all Sonobuoy containers:
sonobuoy logs
```
