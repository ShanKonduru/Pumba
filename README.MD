# To get help from pumba
```shell
pumba --help
```

## Kill command Help
```shell
pumba --help kill
```
```output
NAME:
   pumba kill - kill specified containers

USAGE:
   pumba [global options] kill [command options] containers (name, list of names, RE2 regex)

DESCRIPTION:
   send termination signal to the main process inside target container(s)

OPTIONS:
   --signal value, -s value  termination signal, that will be sent by Pumba to the main process inside target container(s) (default: "SIGKILL")
   --limit value, -l value   limit to number of container to kill (0: kill all matching) (default: 0)
```

## pause Container command Help
```shell
pumba --help pause
```
```output
NAME:
   pumba pause - pause all processes

USAGE:
   pumba pause [command options] containers (name, list of names, RE2 regex)

DESCRIPTION:
   pause all running processes within target containers

OPTIONS:
   --duration value, -d value  pause duration: should be smaller than recurrent interval; use with optional unit suffix: 'ms/s/m/h'

```

## Stop container command Help
```shell
pumba --help stop
```
```output
NAME:
   pumba stop - stop containers

USAGE:
   pumba stop [command options] containers (name, list of names, RE2 regex)

DESCRIPTION:
   stop the main process inside target containers, sending  SIGTERM, and then SIGKILL after a grace period

OPTIONS:
   --time value, -t value  seconds to wait for stop before killing container (default 10) (default: 10)

```

## Remove container command Help
```shell
pumba --help rm 
```
```output
NAME:
   pumba rm - remove containers

USAGE:
   pumba rm [command options] containers (name, list of names, RE2 regex)

DESCRIPTION:
   remove target containers, with links and voluems

OPTIONS:
   --force, -f    force the removal of a running container (with SIGKILL, default: true)
   --links, -l    remove container links (default: false)
   --volumes, -v  remove volumes associated with the container (default: true)

```

## Network Emulation command Help
```shell
pumba --help netem  
```
```output
NAME:
   Pumba netem - delay, loss, duplicate and re-order (run 'netem') packets, to emulate different network problems

USAGE:
   Pumba netem command [command options] [arguments...]

COMMANDS:
     delay      delay egress traffic
     loss
     duplicate
     corrupt
     rate       limit egress traffic

OPTIONS:
   --duration value, -d value   network emulation duration; should be smaller than recurrent interval; use with optional unit suffix: 'ms/s/m/h'
   --interface value, -i value  network interface to apply delay on (default: "eth0")
   --target value, -t value     target IP filter; comma separated. netem will impact only on traffic to target IP(s)
   --tc-image value             Docker image with tc (iproute2 package); try 'gaiadocker/iproute2'
   --help, -h                   show help

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


# usefull links

```url
https://medium.com/hackernoon/pumba-chaos-testing-for-docker-1b8815c6b61e
```