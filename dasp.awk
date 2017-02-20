# Awk library for dasp script
#
# Input command:
#
# awk \
#   -v DATE_START="${awk_start}" \
#   -v DATE_END="${awk_end}" \
#   -v DATE_FORMAT="${SRC_DATE_FORMAT}" \
#   -v DATE_FIELD="${SRC_DATE_FIELD}" \
#   -v MONTHS_CUSTOM="${MONTHS_CUSTOM}" \
#   -v DEBUG="${DEBUG}" \
#   -F "${SRC_DATA_SEPAR}" \
#   -f "$(sys_workdir)/dasp.awk"
#

###############################################################################
# Perfom iterate data with different date formats
# 
# Date comparing doing by next algorithm:
#
# Start_date, end_date and current_date are reduced to a common format like
# CCYYMMDDHHMMSSs. Any of elements may be not here, from left to right, or from
# right to left. but not from center.
#
# Reducing to a common format is made by following steps:
# - splitting in array and reverse DATE_FORMAT like dateFmt["%Y"] = 2
# - all symbols not in regex are sets as separators, and for example splitted
#   date in format ";[%Y%m" results in array like arr[0]="", arr[1]="[",
#   arr[2]="%Y", arr[3]="%m". When reverse it: arr["%Y"]=2, arr["%m"]=3
# - next, change some not meaning to program formats in that program mean
# - as is DATE_START and DATE_END is in the format like DATE_FORMAT, splitting this
#   variables gave same values order in results array. Do the same steps, but 
#   not reversing it. As result: dateSt[2] = 2017. So now we may get values from
#   dateSt in this way: arrSt[dateFmt[%Y]]=2017. ans so on.
# - now we cat build comparable format by concatenate arrays element in those order
#   we need
# - working with the date_current is similar, but months value is exchanged by custom
#   months 
#
# Using shell command $date for comparing is very expensive
#
###############################################################################

BEGIN {
  
  # Fields of date in dataSource

  split(DATE_FIELD, arrDf, "&");

  # Form custom months array like months["Feb"] = 02

  split (MONTHS_CUSTOM, a, ",");
  for (i=1; i<=12; i++) {
    months[a[i]] = sprintf("%02d", i);
  }

  # Split date_format and reverse it in array like dateFmt["%Y"] = 1

  split(DATE_FORMAT, arr, "[^\045\060-\071\101-\132\141-\172\200-\377]");
  for (key in arr) {
      if (arr[key] != "") { 
        if (arr[key] == "%Y" || arr[key] == "%y"){ arr[key] = "%Y" }
        if (arr[key] == "%b" || arr[key] == "%B" || arr[key] == "%m") { arr[key] = "%m" }
        dateFmt[arr[key]] = key ;
      }
  }

  # Split start and end dates in array like arrSt[1] = 2017
  
  split(DATE_START, arrSt, "[^\060-\071\101-\132\141-\172\200-\377]");
  split(DATE_END, arrEn, "[^\060-\071\101-\132\141-\172\200-\377]");


  # Form start_date and end_date in comparable format like "20170203140000"
  
  DATE_START = arrSt [dateFmt["%Y"]] \
               arrSt [dateFmt["%m"]] \
               arrSt [dateFmt["%d"]] \
               arrSt [dateFmt["%H"]] \
               arrSt [dateFmt["%M"]] \
               arrSt [dateFmt["%S"]] \
               arrSt [dateFmt["%s"]];
               
  DATE_END =   arrEn [dateFmt["%Y"]] \
               arrEn [dateFmt["%m"]] \
               arrEn [dateFmt["%d"]] \
               arrEn [dateFmt["%H"]] \
               arrEn [dateFmt["%M"]] \
               arrEn [dateFmt["%S"]] \
               arrEn [dateFmt["%s"]];
}
  
  # Working with current record - sourceDate

{

  # Form current date fields as package of user defined field numbers
  
  i=0;
  for (key in arrDf) {
    if (i!=0) {
      currDate = currDate FS $arrDf[key];
    } else {
      currDate = $arrDf[key]
    }
    i++;
  }

  if (DEBUG == "true"){
    print "debug: awk_output is " currDate> "/dev/stderr";
  }

  # Convert current date to comparable format for comparing

  split(currDate, arrC, "[^\060-\071\101-\132\141-\172\200-\377]");
  
  currDateStr = arrC [dateFmt["%Y"]] \
                months[arrC [dateFmt["%m"]]] \
                arrC [dateFmt["%d"]] \
                arrC [dateFmt["%H"]] \
                arrC [dateFmt["%M"]] \
                arrC [dateFmt["%S"]] \
                arrC [dateFmt["%s"]];
}
{
  # Compare dates as numbers like YMHhms = 20170101200005)
  
  if (DEBUG == "true"){
    print "debug: awk_compare is " currDateStr " " DATE_START " " DATE_END > "/dev/stderr";
    DEBUG = "false";
  }
  
  if (currDateStr >= DATE_START && currDateStr <= DATE_END){
      print $0;
  }            
}