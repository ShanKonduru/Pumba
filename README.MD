# To get help from pumba
```shell
pumba --help
```

```shell
Pumba version v0.2.0
NAME:
   Pumba - Pumba is a resilience testing tool, that helps applications tolerate random Docker container failures: process, network and performance.
USAGE:
   pumba [global options] command [command options] containers (name, list of names, RE2 regex)
VERSION:
   v0.2.0
COMMANDS:
     kill     kill specified containers
     netem    emulate the properties of wide area networks
     pause    pause all processes
     stop     stop containers
     rm       remove containers
     help, h  Shows a list of commands or help for one command
GLOBAL OPTIONS:
   --host value, -H value      daemon socket to connect to (default: "unix:///var/run/docker.sock") [$DOCKER_HOST]
   --tls                       use TLS; implied by --tlsverify
   --tlsverify                 use TLS and verify the remote [$DOCKER_TLS_VERIFY]
   --tlscacert value           trust certs signed only by this CA (default: "/etc/ssl/docker/ca.pem")
   --tlscert value             client certificate for TLS authentication (default: "/etc/ssl/docker/cert.pem")
   --tlskey value              client key for TLS authentication (default: "/etc/ssl/docker/key.pem")
   --debug                     enable debug mode with verbose logging
   --json                      produce log in JSON format: Logstash and Splunk friendly
   --slackhook value           web hook url; send Pumba log events to Slack
   --slackchannel value        Slack channel (default #pumba) (default: "#pumba")
   --interval value, -i value  recurrent interval for chaos command; use with optional unit suffix: 'ms/s/m/h'
   --random, -r                randomly select single matching container from list of target containers
   --dry                       dry runl does not create chaos, only logs planned chaos commands
   --help, -h                  show help
   --version, -v               print the version

```

# stop random container once in a 10 minutes
```shell
pumba --random --interval 10m kill --signal SIGSTOP
```

# every 15 minutes kill `mysql` container 
```shell
pumba --interval 15m kill --signal SIGTERM mysql
```
# every hour remove containers starting with "hp"
```shell
pumba --interval 1h rm re2:^hp &
```

# every 30 seconds kill "worker1" and "worker2" containers 
# and every 3 minutes stop "queue" container
```shell
pumba --interval 30s kill --signal SIGKILL worker1 worker2 &
pumba --interval 3m stop queue &
```

# Once in 5 minutes, Pumba will delay for 2 seconds (2000ms) 
# egress traffic for some (randomly chosen) container,
# named `result...` (matching `^result` regexp) on `eth2` 
# network interface.
# Pumba will restore normal connectivity after 2 minutes. 
# Print debug trace to STDOUT too.

```shell
pumba --debug --interval 5m --random netem --duration 2m --interface eth2 delay --amount 2000 re2:^result
```