# What is this?
This is a containerised app to push code into deta.sh

## Starting the app
```
cd <the dir with docker compose file>
docker compose build
docker compose up -d
# There is an ssh server started on port 8022 on the host.
ssh samarth@localhost -p 8022
```