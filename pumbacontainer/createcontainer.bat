@echo off
REM run latest stable Pumba docker image (from master repository)
docker run -itd -v /var/run/docker.sock:/var/run/docker.sock gaiaadm/pumba:master ./pumba kill --interval 10s --signal SIGTERM

