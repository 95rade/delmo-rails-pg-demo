# Delmo demo - Step 1

This is a normal Rails app. It requires PostgreSQL locally. If you don't have Ruby and/or PostgreSQL setup, then fear not - just [skip to the next step](#next) where we dockerize it all.

```
bundle install
bin/rails s
```

View the application at https://localhost:3000

## Next

In the next step we will containerize this Rails app using Docker, and run a small `docker-compose` cluster with this `web` app linked to a PostgreSQL `db` container.

```
git checkout step-2
cat README.md
```
