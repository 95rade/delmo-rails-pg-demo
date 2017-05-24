
## Run tests

```
delmo -m my-docker-machine
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
