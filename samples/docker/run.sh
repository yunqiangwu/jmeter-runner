#!/usr/bin/env bash

set -e

rm -rf ./output ./test-res.jtl ./top_file.csv

jmeter -n -t ./webide-test.jmx -l test-res.jtl -e -o ./output --jmeterproperty top_file_path=./top_file.csv --jmeterproperty test_size=6

export CMDRunnerPath=$JMETER_HOME/lib
export top_csv_file=./top_file.csv

java -jar $CMDRunnerPath/cmdrunner-2.2.jar  --tool Reporter --generate-png ${top_csv_file%.*}_PerfMon.png --input-jtl ${top_csv_file} --plugin-type PerfMon
