# Delmo demo - Step 2

In this step we will containerize this Rails app using Docker, and run a small `docker-compose` cluster with this `web` app linked to a PostgreSQL `db` container.

```
docker-compose up
```

View the application at https://docker-ip:5000

To show the "missing database" issue, in another terminal window run:

```
docker-compose stop db
```

Now view the application again at https://docker-ip:5000 and it should fail.

## Next

Next we will introduce Delmo to show this failure case within a simple test.

```
git checkout step-3
cat README.md
```
