# Dasp (Data Spider)

This bash script is perform get data for any period from different text sources with separated fields and contains date/time field. 

## Usage

#### Make script executable:

        chmod +x dasp

#### Build (or choose from list below) command parametrs
        
        ./dasp

#### Run for testing ang decide if your query is right, has setting option -b (debug)

        query -b

#### It it is all right, set builded command to alias:

        alias apache_logs="./dasp -d"

#### Run:

        apache_logs "yestrday" "now"


## Most common aliases

* Apache logs

        alias dasp_apache_access='dasp -s ~/logs ' -d " " -f '*access*log' -o 1 -k 4 -w '[D/M/Y:h:m:s' -m '%b'

* Nginx logs

        alias dasp_apache_access='dasp -s ~/logs ' -d " " -f '*access*log' -o 1 -k 4 -w '[D/M/Y:h:m:s' -m '%b'

* Syslogs

        alias dasp_apache_access='dasp -s ~/logs ' -d " " -f '*access*log' -o 1 -k 4 -w '[D/M/Y:h:m:s' -m '%b'

* Php logs

        alias dasp_apache_access='dasp -s ~/logs ' -d " " -f '*access*log' -o 1 -k 4 -w '[D/M/Y:h:m:s' -m '%b'

## Known issues

### 1. 

## Developing

* Preffered style guide is [https://google.github.io/styleguide/shell.xml](https://google.github.io/styleguide/shell.xml)

