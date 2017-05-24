# Delmo demo - Step 3

Delmo will allow us to recreate this failure scenario without manual steps.

In this step we will use Delmo bring up the `docker-compose` cluster, run `docker-compose stop db` and then run a test script to assert that the web is still working (status `200` rather than HTTP status `500`).

In Step 3 this test will fail. We will fix it in Step 4.

## Run tests

To run delmo/docker-compose against a docker-machine, use the `-m machine-name` flag:

```
delmo -m my-docker-machine
```

To run delmo/docker-compose against a local docker daemon:

```
delmo --localhost <DOCKER_HOST_IP>
```
or

```
export DOCKER_HOST_IP=<DOCKER_HOST_IP>
delmo
```

The output will look similar to:

```
Running test 'db-outage'...
Starting 'db-outage' Runtime...
Creating network "dboutage_default" with the default driver
Creating dboutage_db_1
Creating dboutage_web_1
Creating dboutage_tests_1
Executing - <Wait: home-page-running, Timeout: 30s>
(1) home-page-running | HTTP/1.1 200 OK
(1) home-page-running | X-Frame-Options: SAMEORIGIN
(1) home-page-running | X-XSS-Protection: 1; mode=block
(1) home-page-running | X-Content-Type-Options: nosniff
(1) home-page-running | Content-Type: text/html; charset=utf-8
(1) home-page-running | ETag: W/"c997a266038736ed13e7db1f11a524b2"
(1) home-page-running | Cache-Control: max-age=0, private, must-revalidate
(1) home-page-running | Set-Cookie: _blog_session=eWd0UFRtS0dzRzZHU0Q1Q0V3TDZSaWxQNVJ2djJUU2RzWDYyMWNYbUV0NTY1WEJPNFNhelNFU09JMmY4RkNwOWFJODlhRnZpdGJ3dkJJS0VTV1A4RTJqcXZMcGcxRXF0TTdEaTV3SWdSR1NKSWVvTWRMcElXS1o2TDhzU1YrbmlvL1A5LzN6alFraDl5WVVYRFg5YXRnPT0tLWM1VUFuWnZCdkdhQkc5cmRSN0t2K3c9PQ%3D%3D--3ee4b44bf29e6b5a265caa28a87722b0dca3e528; path=/; HttpOnly
(1) home-page-running | X-Request-Id: 2d8ca2a0-a13f-4100-8ad9-a2998cd24d76
(1) home-page-running | X-Runtime: 0.650900
(1) home-page-running |
Executing - <Destroy: [db]>
Killing dboutage_db_1 ... done
Going to remove dboutage_db_1
Removing dboutage_db_1 ... done
Executing - <Wait: db-stopped, Timeout: 30s>
db-stopped |
(1) db-stopped | ++ rake db:version
(1) db-stopped | + [[ X != \X ]]
(1) db-stopped | + echo db cannot be accessed... good.
(1) db-stopped | db cannot be accessed... good.
(1) db-stopped | + exit 0
Executing - <Wait: home-page-running, Timeout: 30s>
(1) home-page-running | curl: (22) The requested URL returned error: 500 Internal Server Error
(2) home-page-running | curl: (22) The requested URL returned error: 500 Internal Server Error
FAIL! Step - <Wait: home-page-running, Timeout: 30s> did not complete as expected.
REASON - Task 'home-page-running' never completed successfully
```

## Test scripts

In the test output above we are running the same `home-page-running` test twice - once when the `web` and `db` containers are running, and once when only `web` container is running. It is the latter occasion that we get the `500` status failure.

The `home-page-running` test is just a simple shell script `delmo/tasks/home-page-running.sh`:

```bash
#!/bin/bash

set -e

curl -f -I http://web:3000/
```

You could make this as advanced as you like, and write it in any programming language you like. The point is it can also be as simple as you like - a simple `curl -f` to check that the endpoint basically works (`200`), rather than basically fails (`500`).

## Delmo test suite

When we run `delmo` we are implicitly running `delmo -f delmo.yml`.

The `delmo.yml` file describes one or more test scenarios. Each test scenario starts with a fresh `docker-compose up` cluster.

From `delmo.yml` we are describing a single test scenario:

```yaml
tests:
- name: db-outage
  spec:
  - {wait: home-page-running, timeout: 30}
  - destroy: [db]
  - {wait: db-stopped, timeout: 30}
  - {wait: home-page-running, timeout: 30}
```

The test `db-outage` has four steps:
1. Check that the `web` home page works with the full `docker-compose up` cluster running.
2. Stop the `db` container.
3. Confirm that the `db` container is not working.
4. Check that the `web` home page works now.

The `home-page-running` and `db-stopped` actions map to executable commands defined elsewhere in `delmo.yml`:

```yaml
tasks:
- {name: db-stopped, command: "/tasks/db-stopped.sh"}
- {name: home-page-running, command: "/tasks/home-page-running.sh"}
```

The commands referenced, such as `/tasks/home-page-running.sh`, are relative to the Docker container within which they are executed.

That is, when `delmo` is running there is an additional container within which our delmo tasks are executed. The tasks above are not run within `web` nor `db`; rather they are run within an additional container.

The `docker-compose.yml` in Step 3 includes this additional container:

```yaml
services:
  ...
  tests:
    build: ./delmo/
    image: demo-blog-tests
    depends_on:
      - db
      - web
```

When `delmo` runs, it will re-build this `tests` container image each time.

The `Dockerfile` in the example above will be found within `delmo/` subfolder:

```dockerfile
FROM demo-blog

COPY ./tasks/  /tasks

CMD ["/bin/true"]
```

The `tests` container in this example project is built using the `web` image - so it has Ruby in it and the Rails web app. We could use this in our test tasks if we wanted. We could also install any other dependencies we want for our test tasks.

The `delmo/tasks/*` files are copied into the image's `/tasks/` folder.

## Next

In the next step we will fix the Rails app so that we can make the Delmo test scenario pass.

```
git checkout step-4
cat README.md
```
