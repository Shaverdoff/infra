# 4.2 to 4.4
```
mongo
# get current featureCompatibilityVersion version
db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )
### The operation should return a result that includes "featureCompatibilityVersion" : { "version" : "4.2" }.
# To set or update featureCompatibilityVersion, run the following command:
db.adminCommand( { setFeatureCompatibilityVersion: "4.2" } )
```
# 4.4 to 5.0
```
mongo
# get current featureCompatibilityVersion version
db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )
### The operation should return a result that includes "featureCompatibilityVersion" : { "version" : "4.4" }.
# To set or update featureCompatibilityVersion, run the following command:
db.adminCommand( { setFeatureCompatibilityVersion: "4.4" } )
```
