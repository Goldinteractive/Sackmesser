# Deployment
    
## Setup 
For each project you need to setup your machine to save the SSH credentials. If mysql and mysqldump aren't globally available, it will ask you to give the path to the binaries.
 
% = Environment (e.g. production, staging). Depending on the configured environments.
      
```shell
$ make deploy-setup-%
```
### Configuration

`.config/deployment` is the configuration for the project. For each environment there exists a `.config/deployment.environment` (e.g. .config/deployment.production)

## Deploy the project

Before any deploy should be made a release should be created:

```shell
$ make release
```

After that the project is ready to be deployed:

```shell
$ make deploy-%
```
% = Environment

For a patch-deploy a release doesn't need to be created. But before each full deploy, `make release` should be executed.

Right now there are 2 ways to deploy the project: full-deploy and patch-deploy. With full-deploy all the files will be deployed and with patch-deploy
only the changed files will be uploaded. 


### Rollback

If there was a problem with a full-deployment you can rollback to the previous revision:

```shell
$ make rollback-%
```

% = Environment

# Data Synchronization

To synchronize data you can use `make pull-data-%` to get the data from the given environment or `make push-data-%` to push.

# Database Synchronization

To synchronize the database you can use `make pull-data-db-%` to get the db from the given environment or `make push-data-db-%` to push.




