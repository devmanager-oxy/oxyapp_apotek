

package com.project.main.db;

import java.util.*;

public class OIDGenerator
{
    //appIdx = 7 app srv application Fin & Inv
    //appIdx = 5 app srv application Sales    
    //appIdx = 9 app srv Database Fin & Inv
    //appIdx = 6 app srv Download app download    
    //appIdx = 8 app srv Download app Fin & Inv
    private static int appIdx = 7;
    
    private static OIDGenerator oidGenerator = null;
    static long lastOID=0;

    public OIDGenerator()
    {
    }

    public OIDGenerator(int appIndex)
    {
        getOIDGenerator();
        appIdx = appIndex;
    }

	public static OIDGenerator getOIDGenerator()
    {
        if(oidGenerator == null) {
            oidGenerator = new OIDGenerator();
        }
        return  oidGenerator;
    }


    public int getAppIndex(){
    	return appIdx;
    }

    public void setAppIndex(int idx){
    	appIdx = idx;
    }

    synchronized public static long generateOID()
    {
        Date dateGenerated = new Date();
        long oid = dateGenerated.getTime() + (0x0100000000000000L * appIdx);
        while(lastOID== oid){
	        try{
	            Thread.sleep(1);
	        }catch(Exception e){}
            dateGenerated = new Date();
			oid=dateGenerated.getTime() + (0x0100000000000000L * appIdx);
            //System.out.print("try oid="+oid);
        }
		//System.out.print("new oid="+oid);
        lastOID=oid;
        return oid;
    }


} // end of OIDGenerator
