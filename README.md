# Demo of Delmo

This repository is for a demonstration of [Delmo](https://github.com/bodymindarts/delmo). Delmo was originally written to help us test the failover and disaster recovery modes of [Dingo PostgreSQL](https://www.dingotiles.com/dingo-postgresql/) clusters. It has subsequently been used to test Stark & Wayne [Habitat plans](https://github.com/starkandwayne/habitat-plans) for clustered services such as Redis, PostgreSQL, Consul and more.

## The demo overview

In this repo is a Ruby on Rails app that uses PostgreSQL: a distributed system of two things. The `web` app requires the `db` database. But what is the right behavior if the `db` is missing? An ugly `500` status page for the user to see? Or can we put in some behavior within the app to specifically handle the `db` temporarily being unavailable (downtime, network partition, HA failover).

First step is to write a system test that runs the `web` and `db` components of the system, turns off the `db` and confirms that the `web` app fails horribly.

Then we can fix the Rails app so that it does something useful whilst the database is missing - say display a static-only version of the site, without any dynamic interactive features. Whatever is useful to your users.

Finally, our system test will run and show that `web` app no longer fails when `db` is missing.

The system test will be run by Delmo, and the `web` and `db` components are containers within a `docker-compose` deployment that Delmo will manage.

## This repo

This repo has three tags representing the three stages:

* `git checkout step-1` - the original basic Rails app that fails when PostgreSQL is not available
* `git checkout step-2` - Docker-ize the Rails app and include a `docker-compose.yml` to reproduce the error within a Docker environment
* `git checkout step-3` - Delmo test suite to show a failing test
* `git checkout step-4` - Rails app fixed to handle the `PG::ConnectionBad` error and show a static page (not the `500` error page).
