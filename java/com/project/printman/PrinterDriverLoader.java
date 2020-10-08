
package com.project.printman;
/* 
 * @author ktanjana
 * @version 1.0
 * Copyright : PT. project Sora Jayate , 2003
 */

import javax.comm.*;

import java.util.*;
import java.io.*;
 
public class PrinterDriverLoader  implements Runnable, Serializable {
    
    public PrinterDriverLoader(OXY_PrintObj prnOb) {
        try{
            this.prnObj = prnOb;
            PrnConfig prConf = OXY_PrinterXML.getPrnConfig(prnObj.getPrnIndex());
            String prnDriverClass =  prConf.getPrnDrvClassName();
            i_PrnDriver = (I_OXY_PrinterDriver) Class.forName(prnDriverClass).newInstance();
            i_PrnDriver.initPrinter(prConf);
            i_PrnDriver.setCPI(this.prnObj.getCpiIndex());
        }catch(Exception e){
            System.out.println(" ! EXC : PrinterDriverLoader =  "+e.toString());            
        }
    }
    
    public OXY_PrintObj getPrnObj(){ return prnObj; }
    
    public void setPrnObj(OXY_PrintObj prnObj){ this.prnObj = prnObj; }
    
    public int getPrnIndex() {
        
        return     prnObj.getPrnIndex();
    }
    
    private void setPage(){
        i_PrnDriver.setPageWidth(prnObj.getPageWidth()) ;
        i_PrnDriver.setPageLength(prnObj.getPageLength());
        // i_PrnDriver.setLeftMargin(prnObj.getLeftMargin());
        i_PrnDriver.setRightMargin(prnObj.getRightMargin());
        i_PrnDriver.setTopMargin(prnObj.getTopMargin());
        i_PrnDriver.setButtomMargin(prnObj.getBottomMargin());
        
        // if(prnObj.getSpacing()!=0)
        //    i_PrnDriver.setVtSpacing(prnObj.getVerticalSpacing(),prnObj.getSpacing());
        // else
        //    i_PrnDriver.setVtSpacing(prnObj.getVerticalSpacing());
        
        //i_PrnDriver.setFont(prnObj.getFont());
    }
    
    public void run() {
        try{
            // printing process
            // set Page
            setPage();
            Thread.sleep(threadSleep);
            // print lines
            printObject(prnObj);
            Thread.sleep(threadSleep);
            // i_PrnDriver.formFeed();
            i_PrnDriver.endPrinting();
            OXY_PrinterService.removePrnDriverLoader(getPrnIndex());
        }catch(Exception e){
            System.out.println(" ! EXC : PrinterDriverLoader > run =  "+e.toString());
            
        }
    }
    
    public I_OXY_PrinterDriver getPrnDriver(){
        return i_PrnDriver;    }
    
    
    public void setPrnDriver(I_OXY_PrinterDriver i_PrnDriver){
        this.i_PrnDriver = i_PrnDriver;
    }
    
    public int getThreadSleep(){
        return threadSleep;
    }
    
    public void setThreadSleep(int threadSleep){
        this.threadSleep = threadSleep;
    }
    
    public boolean printObject(OXY_PrintObj prnObj){
        Vector lines = prnObj.getLines();
        System.out.println(" >>>>>>>>> START PRINTING ON PRINTER INDEX: " +  prnObj.getPrnIndex());
        int pages = lines.size() / prnObj.getPageLength();                
        int leftPage = lines.size() % prnObj.getPageLength();        
        int totpages = 1;
        	
        if(pages==0){
            pages = 1;
            leftPage = 0;
            totpages = 1;
        }else{
        	if(leftPage < 0)
        		leftPage = leftPage * -1;
        		
        	if(leftPage > 0){
        		totpages = pages + 1;
        	}
        	
        	/*try{
        		totpages = ((pages / 3) * 1) + pages;
        	}catch(Exception e){
        			totpages = pages + 1;
        		}*/
        }
        
        int lnSkip = 1;
        int number = 1;  
        if(lines!=null && lines.size()>0){
            for(int i=0;(i<lines.size()) && continuePrint ;i++){
                String str = (String)lines.get(i);
                
                try{
                    while (pausePrinter && continuePrint){
                        errCode = i_PrnDriver.ST_PAUSED;
                        Thread.sleep(threadSleep*20);
                    }
                    
                    boolean bool = false; //i_PrnDriver.isPrinterTimedOut();
                    while(bool && continuePrint){ // && continuePrint
                        errCode = i_PrnDriver.ST_ERR_PAPER_OUT;
                        Thread.sleep(threadSleep*10);
                        System.out.println(" ! ERR : > printObject =  at line "+ i + " => "+i_PrnDriver.errMessage[errCode]);
                        bool = i_PrnDriver.isPrinterTimedOut();
                        if (bool) continuePrint = false; // for test only
                    }
                    if( continuePrint==false) {
                        errCode= i_PrnDriver.ST_ERR_PRINTING_CANCELED;
                        return false;
                    }
                    errCode= i_PrnDriver.ST_PRINTING;
                    //System.out.println(str);
                    //if((i+1) <= (pages*prnObj.getPageLength())||(leftPage>0)){//for check condition line to print                        
                        // System.out.println(str);
                        if(prnObj.getPageLength()==lnSkip){
                        	
                            //String s = "page"+number+" - "+pages;
                            //i_PrnDriver.println(s);
                       /*
                        for(int f=0;f<prnObj.getSkipLineIsPaperFix();f++){
                            i_PrnDriver.println(" ");
                        }
                        lnSkip = 0;
                        if(i<=prnObj.getIndexEndHeader())
                            lnSkip = printHeader(prnObj);
                        */
                            
                            
                            i_PrnDriver.println(str);
                            
                            // print footer page not fit
                            printFooter(prnObj);
                            printPageNumber(prnObj,number,totpages,true,lnSkip);
                            number++;
                            	
                            /*for(int f=0;f<prnObj.getSkipLineIsPaperFix();f++){
                                i_PrnDriver.println(" ");
                            }*/
                            lnSkip = 0;
                            //if(i<=prnObj.getIndexEndHeader())
                            lnSkip = printHeader(prnObj);                            
                        }else{
                            i_PrnDriver.println(str);  
                        } 
                    //}
                    
                   /*
                    }
                   i_PrnDriver.println(str);
                    */
                    
                    Thread.sleep(threadSleep);
                }catch(Exception e){
                    System.out.println(" ! EXC : PrinterDriverLoader > printObject =  "+e.toString());
                }
                lnSkip++;  
            }
            // last printing 
            
            printPageNumber(prnObj,number,totpages,true,lnSkip);
            
            System.out.println(">>>>>>> End Printing");
            return true;
        }
        return false;
    }
    
    // for print header
    public int printHeader(OXY_PrintObj prnObj){
        int line = 0;
        Vector header = prnObj.getHeader();
        if(header!=null && header.size()>0){
            for(int i=0;i<header.size();i++){
                String str = (String)header.get(i);
                i_PrnDriver.println(str);
                line++;
            }
        }
        return line;
    }
    
    // for print footer
    public void printFooter(OXY_PrintObj prnObj){
        Vector footer = prnObj.getFooter();
        if(footer!=null && footer.size()>0){
            for(int i=0;i<footer.size();i++){
                String str = (String)footer.get(i);
                i_PrnDriver.println(str);
            }
        }
    }

    // for print last for skip row
    public void printVloop(OXY_PrintObj prnObj){
        Vector vloop = prnObj.getVloop();
        if(vloop!=null && vloop.size()>0){
            for(int i=0;i<vloop.size();i++){
                String str = (String)vloop.get(i);
                i_PrnDriver.println(str);
            }
        }
    }

    // for print page per page
    public void printPageNumber(OXY_PrintObj prnObj, int page, 
    	int pageTotal, boolean isNewPageAndLastPage, int currLine){
    		
    	String strPrintPage = "";
    	String strPrint = "";
    	strPrintPage = "Halaman "+page+" dari "+pageTotal;
    	int total = strPrintPage.length();
    	int totLoop = 80;
    	try{
    		switch(prnObj.getCpiIndex()){
    			case 0: // 80 carakter
    				totLoop = 80 - total;
    				break;
    			case 1: // 96 carakter
    				totLoop = 96 - total;
    				break;
    			case 2: // 136 carakter
    				totLoop = 136 - total;
    				break;
    			case 3: // > 136 carakter
    				totLoop = 136 - total;  
    				break;
    		}
    		
			for(int k=0;k<totLoop;k++){
				strPrint = strPrint + " "; 
			}
			strPrint = strPrint + strPrintPage;
    		i_PrnDriver.println(strPrint);  
    		
    		// space for new page
    		if(isNewPageAndLastPage){
	    		if(prnObj.getUseSpaceRowBlankForNewPaper()==true){
	    			int totalRowSpace = 0; 
	    			
	    			if(prnObj.getPageLength()==currLine){
	    				totalRowSpace = prnObj.getSpaceRowBlankForNewPaper();
	    			}else{ 
	    				totalRowSpace = ((prnObj.getPageLength() - currLine) + prnObj.getSpaceRowBlankForNewPaper() + prnObj.getSkipLineIsPaperFix());
	    			} 
	    			  
	    			for(int j=0;j<totalRowSpace;j++){
	    				// System.out.println("TESTING>>>> "+j);
	    				i_PrnDriver.println(" ");
	    			}
	    		}
    		}
    	}catch(Exception e){   
    			System.out.println("ERR >>> printPageNumber : "+e.toString());			
    		}    	
    }

    public boolean getContinuePrint(){ return continuePrint; }
    
    public void setContinuePrint(boolean continuePrint){ this.continuePrint = continuePrint; }
    
    public int getErrCode(){ return errCode; }
    
    public void setErrCode(int errCode){ this.errCode = errCode; }
    
    public void pausePrint(){pausePrinter=true;}
    public void resumePrint(){pausePrinter=false;}
    public void cancelPrint(){continuePrint=false;}
    
    /** @link dependency */
    /*#I_OXY_PrinterDriver lnkI_OXY_PrinterDriver;*/
    private OXY_PrintObj prnObj;
    private I_OXY_PrinterDriver i_PrnDriver;
    //private int threadSleep=400;
    //private int threadSleep=40;
    private int threadSleep=100;
    private boolean continuePrint=true;
    private int errCode=0;
    private boolean pausePrinter=false;
    
}
