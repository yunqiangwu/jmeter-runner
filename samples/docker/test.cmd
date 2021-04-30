for /F %%i in ('chdir') do ( set PWD=%%i)
echo PWD: %PWD%
@echo docker run -ti --rm -v %PWD%:/app registry.cn-hangzhou.aliyuncs.com/jajabjbj/jmeter-runner:1 bash
