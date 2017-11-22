@echo off

set cwd=%cd%
set webserverVagrant=E:\WebServer

cd /d %webserverVagrant% && vagrant %*
cd /d %cwd%

set cwd=
set webserverVagrant=