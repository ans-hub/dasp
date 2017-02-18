# Awk library for dasp script
#
# Perfom iterate data with different date formats


BEGIN {
  # Form custom months array like ....

  split (MONTHS_CUSTOM, a, ",");
  for (i=1; i<=12; i++) {
      months[a[i]] = sprintf("%02d", i);
      # print months["únor"] > "/dev/stderr";
  }
  
  # Form dateFormat in array by splitting string and reverse it 
  #  to array like dateFmt["%Y"]=2, ["%m"]=4
  #  in -> vdate_format; out -> dateFmt

  dateStr=DATE_FORMAT;
  # Split array with separators not ascii and not %
  split(dateStr, arr, "[^\045\060-\071\101-\132\141-\172\200-\377]");
  for (key in arr) {
      if (arr[key] != "") {
        if (arr[key] == "%Y" || arr[key] == "%y"){ arr[key] = "%Y" }
        if (arr[key] == "%b" || arr[key] == "%B" || arr[key] == "%m") { arr[key] = "%m" }
        dateFmt[arr[key]] = key ;
        #print arr[key] " - " key
      }
  }

  # Define witch format is used in month abbr
  #   example: %b,%B or %m

}
{
  # Working with current record - sourceDate
  #   in -> currDate; out -> currDateStr
  if (DEBUG == "true"){
    print "debug: awk_output is " $DATE_FIELD > "/dev/stderr";
  }
  
  currDate = $DATE_FIELD; # may be "$"DATE_FIELD ?
  # print currDate;

  # Convert current date to needle format for comparing
  split(currDate, arrC, "[^\060-\071\101-\132\141-\172\200-\377]");      # make arr [1]="2009" [3]="May"
  
  currDateStr = arrC [dateFmt["%Y"]] \
                months[arrC [dateFmt["%m"]]] \
                arrC [dateFmt["%d"]] \
                arrC [dateFmt["%H"]] \
                arrC [dateFmt["%M"]] \
                arrC [dateFmt["%S"]];
}
{
  # Main comapare operation
  # .. compare dates as numbers like YMHhms = 20170101200005)
  if (DEBUG == "true"){
    print "debug: awk_compare is " currDateStr " " DATE_START " " DATE_END > "/dev/stderr";
    DEBUG = "false";
  }
  if (currDateStr >= DATE_START && currDateStr <= DATE_END){
      # print "CD - " currDateStr "; SD - " dateStart "; ED - " dateEnd;
      print $0;
  }            
}