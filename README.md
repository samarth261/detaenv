# What is this?
This is a containerised app to push code into deta.sh

## Starting the app
```
$ cd <the dir with docker compose file>
$ # edit the docker-compose.yml file to include the source and destination directories.
$ # copy the id_rsa.pub file and also the token to access deta space. Refer https://deta.space/docs/en/basics/cli
$ # Access token file is of this format {"access_token":"<token>"}
$ docker compose build --build-arg username=$(whoami) --build-arg userid=${UID} --build-arg password=<password>
$ docker compose up -d
```
There is an ssh server started on port 8022 on the host.
```
$ ssh $(whoami)@localhost -p 8022
```

To stop the container run this in the directory with the docker-compose file.
```
$ docker compose down
```