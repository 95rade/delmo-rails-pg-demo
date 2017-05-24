# Demo of Delmo

This repository is for a demonstration of [Delmo](https://github.com/bodymindarts/delmo). Delmo was originally written to help us test the failover and disaster recovery modes of [Dingo PostgreSQL](https://www.dingotiles.com/dingo-postgresql/) clusters. It has subsequently been used to test Stark & Wayne [Habitat plans](https://github.com/starkandwayne/habitat-plans) for clustered services such as Redis, PostgreSQL, Consul and more.

## The demo overview

In this repo is a Ruby on Rails app that uses PostgreSQL: a distributed system of two things. The `web` app requires the `db` database. But what is the right behavior if the `db` is missing? An ugly `500` status page for the user to see? Or can we put in some behavior within the app to specifically handle the `db` temporarily being unavailable (downtime, network partition, HA failover).

First step is to write a system test that runs the `web` and `db` components of the system, turns off the `db` and confirms that the `web` app fails horribly.

![webapp-dev-500](webapp-dev-500.png)

The next step is to reproduce the problem in controlled environment that we can programmatically manipulate. Delmo uses `docker-compose`. In this production-esque environment, the Rails app shows a more cryptic error:

![webapp-prod-500](webapp-prod-500.png)prod

Then we can fix the Rails app so that it does something useful whilst the database is missing - say display a static-only version of the site, without any dynamic interactive features. Whatever is useful to your users.

The third step is to write a failing test using Delmo - to programmatically deploy the application and its database, stop the database and show that the application fails, when we'd rather that it worked.

Finally, we will upgrade the application to work if the database is missing. Our Delmo test scenario will run and show that `web` app no longer fails when `db` is missing.

The system test will be run by Delmo, and the `web` and `db` components are containers within a `docker-compose` deployment that Delmo will manage.

## Tutorial

This repo has four branches representing the four stages of the tutorial/demo:

* [`git checkout step-1`](https://github.com/starkandwayne/delmo-rails-pg-demo/tree/step-1#readme) - the original basic Rails app that fails when PostgreSQL is not available
* [`git checkout step-2`](https://github.com/starkandwayne/delmo-rails-pg-demo/tree/step-2#readme) - Docker-ize the Rails app and reproduce the error within a `docker-compose` environment
* [`git checkout step-3`](https://github.com/starkandwayne/delmo-rails-pg-demo/tree/step-3#readme) - Delmo test suite to show a failing test
* [`git checkout step-4`](https://github.com/starkandwayne/delmo-rails-pg-demo/tree/step-4#readme) - Rails app fixed to handle the `PG::ConnectionBad` error and show a static page (not the `500` error page).

The read me of each step will lead on to the next step/branch.

Get started:

```
git clone https://github.com/starkandwayne/delmo-rails-pg-demo
cd delmo-rails-pg-demo
git checkout step-1
cat README.md
```
