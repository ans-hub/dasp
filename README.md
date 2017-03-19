# Dasp (Data Spider)

This bash script is provides get data for any period from different text sources separated into fields, one or more of which contains date/time. Such as Apache server logs, /etc/syslogs, json data source and others. Script may work with gz, may compare dates without leading zeros, with custom months, without years, separated in similar fields, etc.

## Usage

Usage of this script is explained by the example for Apache server access logs. Usage for other popular data sources see below in section "Most common aliases"

### Install
~~~~
git clone https://github.com/ans-hub/dasp.git
~~~~

### Make script executable:
~~~~
$ chmod +x dasp
~~~~

### Make symbolic link to script
~~~~ 
$ sudo ln -s ~/folder_with_dasp_app/dasp /usr/local/bin/dasp
~~~~
*Note: in next steps all code writed without "./", as if you have performed command above.*

### Read built-in help for command usage:
~~~~
$ dasp -h
~~~~
### Build options for script and test it in shell:
~~~~
$ dasp -s logs/ -f "*access*log" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1 -t /tmp/.dasp~ "yestarday" "now"
~~~~
### If get of data has ended successfully, set it to the alias:
~~~~
$ alias apache_access="dasp -s logs/ -f "*access*log" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1 -t /tmp/.dasp~"
~~~~
### Usage examples:
~~~~
$ apache_access "yesterday"
$ apache_access "yesterday 14:00:05" "today 12:00"
$ apache_access "2008" "2010" 1> ~/.apache_2008_2010
~~~~
### Another way to use dasp is create wrapper script
In this case usage of dasp is more pretty:
~~~~
$ ./wrapper "2 days ago" "yesterday" own_filter_1 own_filter_2
~~~~
For example, [https://github.io/ans-hub/osvalt](https://github.io/ans-hub/osvalt) - old-school viewer: apache log tool (wrapper to the dasp)

## Most common data source

Apache logs
~~~~
$ dasp -s logs/ -f "*access*" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1
~~~~
Syslogs
~~~~
$ dasp -s /var/log/ -f "syslog.*" -d " " -w "%b %-d %H:%M:%S" -k "1&2&3"
~~~~
Your own data sources:
~~~~
$ dasp -h
~~~~

## More data source examples:

Examples with different mock data source you may find in test case script "dasp_test_main"

## Recemmendations:

Use -t option to improve perfomance

## Known issues:

Getting logs without years in log line (such as syslog) is realised, but there is no way in this version to compare logs for different years period. This feature will have been realised in future version.

Current version not work with logs that contains milliseconds.

Current version not working with time zones