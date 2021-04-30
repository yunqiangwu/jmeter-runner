#!/usr/bin/env bash


docker run -ti --rm -v `pwd`:/app --workdir /app registry.cn-hangzhou.aliyuncs.com/jajabjbj/jmeter-runner:1 /app/run.sh

# for /F %%i in ('chdir') do ( set PWD=%%i)
# docker run -ti --rm -v    :/app registry.cn-hangzhou.aliyuncs.com/jajabjbj/jmeter-runner:1 bash
