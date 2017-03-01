# Awk library for dasp script - performs get data for date range
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
#__________________________________________________________________________

# PREPARING OPERATIONS AT STARTS

BEGIN {
  
  # Fields of date in dataSource

  split(DATE_FIELD, arrDf, "&");

  # Form custom months array like months["Feb"] = 02

  split (MONTHS_CUSTOM, a, ",");
  for (i=1; i<=12; i++) {
    months[a[i]] = sprintf("%02d", i);
  }

  # Split date_format and reverse it in array like dateFmt["%Y"] = 1
  # by separators which is not % and A-Za-z0-9 and other langs

  split(DATE_FORMAT, arr, "[^\045\060-\071\101-\132\141-\172\200-\377]");
  
  for (key in arr) {
      if (arr[key] != "") { 
        if (arr[key] == "%Y" || arr[key] == "%y"){ arr[key] = "%Y" }
        if (arr[key] == "%b" || arr[key] == "%B" || arr[key] == "%m") { arr[key] = "%m" }
        dateFmt[arr[key]] = key ;
      }
  }

  # Split start and end dates in array like arrSt[1] = 2017
  # by separators which is not A-Za-z0-9 and other langs

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
  
# WORKING WITH EACH LINE OF FILE

{

  # Catenate date fields in one to get current date like "2017 02/11 21:11:00"
  
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

  # Split current date to comparable format for comparing to format like arrC[1] = 2017
  # by separators which is not A-Za-z0-9 and other langs

  split(currDate, arrC, "[^\060-\071\101-\132\141-\172\200-\377]");
  
  # It would be work, because positions of elements in array dateFmt and arrC 
  # is similar 

  currDateStr = arrC [dateFmt["%Y"]] \
                months[arrC [dateFmt["%m"]]] \
                arrC [dateFmt["%d"]] \
                arrC [dateFmt["%H"]] \
                arrC [dateFmt["%M"]] \
                arrC [dateFmt["%S"]] \
                arrC [dateFmt["%s"]];
}

# COMPARE DATES AS NUMBERS

{
  
  # Compare strings like YMHhms = 20170101200005)

  if (DEBUG == "true"){
    print "debug: awk_compare is " currDateStr " " DATE_START " " DATE_END > "/dev/stderr";
    DEBUG = "false";
  }
  
  if (currDateStr >= DATE_START && currDateStr <= DATE_END){
      print $0;
  }            
}