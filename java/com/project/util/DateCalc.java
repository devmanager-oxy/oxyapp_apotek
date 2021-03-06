

package com.project.util;
import java.util.*;

public class DateCalc
    {
    public static final  long DAY_MILLI_SECONDS =  86400000;
    public static final  long SECONDS_MILLI_SECONDS =  1000;
    public static final  long MINUTES_MILLI_SECONDS =  60000;
    public static final  long HOURS_MILLI_SECONDS 	=  3600000;

    public static long dayDifference(Date dateFrom, Date dateTo)
        {
           //System.out.println("dateFrom.getTime() : "+dateFrom.getTime());
           //System.out.println("dateTo.getTime() : "+dateTo.getTime());

           long lnTemp0 =  dateTo.getTime() - dateFrom.getTime(); // get the time in milli seconds

           //System.out.println("lnTemp0 : "+lnTemp0);
           long lnTemp1 =  lnTemp0 / DAY_MILLI_SECONDS;  // get number of days

           if( (lnTemp0 % DAY_MILLI_SECONDS) > 0)
           {
              lnTemp1++; // add
           }
           return lnTemp1;
        }



	public static long timeDifference(Date dateFrom, Date dateTo)
        {
           long lnTemp0 =  dateTo.getTime() - dateFrom.getTime(); // get the time in milli seconds
           return  lnTemp0;
        }


    }

