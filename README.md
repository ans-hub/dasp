# Dasp (Data Spider)

This bash script is provides get data for any period from different text sources separated into fields, one or more of which contains date/time. Such as Apache server logs, nginx logs, /etc/syslogs and others.

## Usage

Usage of this script is explained by the example for Apache server access logs. Usage for other popular data sources see below in section "Most common aliases"

### Make script executable:
~~~~
$ chmod +x dasp
~~~~

### Make symbolic link to script
~~~~ 
$ sudo ln -s dasp 
~~~~
*Note: in next steps all code writed without "./", as if you have performed command above.*

### Build options for script and test it in shell:
~~~~
$ dasp -s logs/ -f "*access*log" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1 -t /tmp/.dasp~ "yestarday" "now"
~~~~
### If get of data has ended successfully, set it to the alias:
~~~~
$ alias apache_access="dasp -s logs/ -f "*access*log" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1 -t /tmp/.dasp~"
~~~~
### Subsequent usage:
~~~~
apache_access "yesterday"
apache_access "yesterday 14:00:05" "today 12:00"
apache_access "2008" "2010" 1> ~/.apache_2008_2010
~~~~
## Most common aliases

Apache logs
~~~~
dasp -s logs/ -f "*access*log" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1 -t /tmp/.dasp~
~~~~
Nginx logs
~~~~
dasp -s logs/ -f "*access*log" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1 -t /tmp/.dasp~
~~~~
Syslogs
~~~~
dasp -s logs/ -f "*access*log" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1 -t /tmp/.dasp~
~~~~
Php logs
~~~~
dasp -s logs/ -f "*access*log" -d " " -w "[%Y-%b-%d:%H:%M:%S" -k 4 -o 1 -t /tmp/.dasp~
~~~~
Your own data sources:
~~~~
dasp -h
~~~~

## Known issues

#### Script is getting date/time only from timestamp of file.

In this way to search over files, that where archived early, you may set option -o at 10000. This perform script to search all files in dir