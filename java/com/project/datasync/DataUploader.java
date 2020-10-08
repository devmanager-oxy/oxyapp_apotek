/*
 * DataUploader.java
 *
 * Created on March 20, 2008, 5:41 PM
 */

package com.project.datasync;

import com.project.ccs.postransaction.stock.DbStock;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
//import com.project.fms.master.*;
//import com.project.fms.transaction.*;
import com.project.util.*;
import com.project.system.*;
import com.project.util.encript.*;
import com.project.fms.transaction.*;
import com.project.fms.activity.*;
import com.project.fms.master.*;


/**
 *
 * @author  Valued Customer
 */
public class DataUploader {
    
    /** Creates a new instance of DataUploader */
    public DataUploader() {
    }
    
    public static String uplaodData(String str){
        
        System.out.println("\n---- START UPLOAD ----- \n");
        
        String message = "";
        
        try{
            
            boolean stop = false;
            int i = 0;
            StringReader sr = new StringReader(str);
            LineNumberReader ln = new LineNumberReader(sr);
            
            Vector strBuffer = new Vector(1,1);
            
            while(!stop){
                
                String s = ln.readLine();
                
                System.out.println("upload line : "+i);
                
                //jika string tidak null dan bukan comment dan panjangnya > 1
                if(s!=null && s.length()>0){
                    message = proceedToDB(s, message);
                }					

                i = i+1;
                ln.setLineNumber(i);
                if(s==null){
                        stop = true;
                }
            }

            sr.close();
            ln.close();
        }
        catch(Exception e){
            message = "Err - exception on starting upload";
            System.out.println("Exception e : "+e.toString());
        }
        
        if(message.length()>0){
            message = "Start uploading data :\n"+ message;
        }
        else{
            message = "Upload process complete.";
        }
        
        System.out.println("\n---- END UPLOAD ----- \n");
        
        try{
            BackupHistory bh = new BackupHistory();
            bh.setDate(new Date());
            //bh.setStartDate(startDate);
            //bh.setEndDate(endDate);
            bh.setNote("Upload data");
            bh.setType(DbBackupHistory.TYPE_UPLOAD);
            
            DbBackupHistory.insertExc(bh);
        }
        catch(Exception e){
        }
        
        return message;
        
    }
    
    
    public static String uplaodDataRetail(String str){
        
        System.out.println("\n---- START UPLOAD ----- \n");
        
        String message = "";
        
        try{
            
            boolean stop = false;
            int i = 0;
            StringReader sr = new StringReader(str);
            LineNumberReader ln = new LineNumberReader(sr);
            
            Vector strBuffer = new Vector(1,1);
            
            while(!stop){
                
                String s = ln.readLine();
                
                System.out.println("upload line : "+i);
                
                //jika string tidak null dan bukan comment dan panjangnya > 1
                if(s!=null && s.length()>0){
                    message = proceedToDBRetail(s, message);
                }					

                i = i+1;
                ln.setLineNumber(i);
                if(s==null){
                        stop = true;
                }
            }

            sr.close();
            ln.close();
            DbStock.procedStockSales();
        }
        catch(Exception e){
            message = "Err - exception on starting upload";
            System.out.println("Exception e : "+e.toString());
        }
        
        if(message.length()>0){
            message = "Start uploading data :\n"+ message;
        }
        else{
            message = "Upload process complete.";
        }
        
        System.out.println("\n---- END UPLOAD ----- \n");
        
        try{
            BackupHistory bh = new BackupHistory();
            bh.setDate(new Date());
            //bh.setStartDate(startDate);
            //bh.setEndDate(endDate);
            bh.setNote("Upload data");
            bh.setType(DbBackupHistory.TYPE_UPLOAD);
            
            DbBackupHistory.insertExc(bh);
        }
        catch(Exception e){
        }
        
        return message;
        
    }
    
    
    private static String proceedToDB(String s, String message){
        
        if(s!=null && s.length()>3){
        	
        	String table = s.substring(0,s.indexOf("(*)"));
            String query = s.substring(s.indexOf("(*)")+3,s.length());
        
            
            String enType = query.substring(query.length()-1, query.length());

            //System.out.println("enType : "+enType);

            String data = query.substring(0, query.length()-1);

            //System.out.println("data : "+data);
            
            StringTokenizer strTok = new StringTokenizer(data, "|");
            Vector content = new Vector();
            while(strTok.hasMoreTokens()){  
                String stx = strTok.nextToken();
                if(stx.equals(TextLibrary.strNull)){
                    content.add("");  
                }
                else{
                    content.add(stx);  
                }
            }

            if(enType!=null && enType.length()>0){ 

                //System.out.println("\ncontent : "+content);
                //System.out.println("\ncontent size : "+content.size()+"");

                if(content!=null && content.size()>0){                                
                    try{
                        
                        //System.out.println("in uploading ..");
                        table = TextDecriptor.decriptText(enType,table);
                        String sql = TextDecriptor.decriptText(enType,(String)content.get(0));
                        
                        System.out.println("table : "+table);
            			System.out.println("sql : "+sql);

                        
                        //sql = CONLogger.reverseToQuery(sql);
                        
                        //System.out.println(sql+"\n");
                        
                        try{
                            
                            CONHandler.execUpdate(sql);
                            System.out.println("--- upload success ---");
                            
                            //proses periode jika gl
                            if(table.equalsIgnoreCase(DbGl.DB_GL)){
                            	updatePeriodeGL(sql,table);
                            	System.out.println("--- update gl periode success  ---");
                            }
                            //proses priode jika module
                            else if(table.equalsIgnoreCase(DbModule.DB_MODULE)){
                            	updatePeriodeModule(sql,table);
                            	System.out.println("--- update module periode success  ---");
                            }
                            
                        }
                        catch(Exception ex){
                           System.out.println("--- FAILED ---");
                           //message = message + "<br><font color='green'>data already exist, ok</font>";
                           message = message + "<br><font color='red'>FAILED - Err - Can't process query : "+sql+"</font>"; 
                        }

                    }
                    catch(Exception e){
                        System.out.println(e.toString());
                        message = message + "<br><font color='red'>Err - Can't parse data to object, "+(String)content.get(0)+"</font>"; 
                    }
                }
                else{
                    message = message + "<br><font color='red'>Err - Not a valid data count, "+(String)content.get(0)+"</font>";                    
                }
            }
            else{
                message = message + "<br><font color='red'>Err - Not a valid encript type, "+(String)content.get(0)+"</font>"; 
            }
        }
        
        return message;
    }
    
    private static String proceedToDBRetail(String s, String message){
        
        if(s!=null && s.length()>3){
        	
            //String table = s.substring(0,s.indexOf("(*)"));
            //String query = s.substring(s.indexOf("(*)")+3,s.length());
        
            
            String enType = s.substring(s.length()-1, s.length());

            //System.out.println("enType : "+enType);

            String data = s.substring(0, s.length()-1);

            //System.out.println("data : "+data);
            
            StringTokenizer strTok = new StringTokenizer(data, "|");
            Vector content = new Vector();
            while(strTok.hasMoreTokens()){  
                String stx = strTok.nextToken();
                if(stx.equals(TextLibrary.strNull)){
                    content.add("");  
                }
                else{
                    content.add(stx);  
                }
            }

            if(enType!=null && enType.length()>0){ 

                //System.out.println("\ncontent : "+content);
                //System.out.println("\ncontent size : "+content.size()+"");

                if(content!=null && content.size()>0){                                
                    try{
                        
                        //System.out.println("in uploading ..");
                        //table = TextDecriptor.decriptText(enType,table);
                        String sql = TextDecriptor.decriptText(enType,(String)content.get(0));
                        
                        //System.out.println("table : "+table);
            			System.out.println("sql : "+sql);

                        
                        //sql = CONLogger.reverseToQuery(sql);
                        
                        //System.out.println(sql+"\n");
                        
                        try{
                            
                            CONHandler.execUpdate(sql);
                            System.out.println("--- upload success ---");
                            
                            //proses periode jika gl
                           // if(table.equalsIgnoreCase(DbGl.DB_GL)){
                           // 	updatePeriodeGL(sql,table);
                           // 	System.out.println("--- update gl periode success  ---");
                           // }
                            //proses priode jika module
                           // else if(table.equalsIgnoreCase(DbModule.DB_MODULE)){
                          //  	updatePeriodeModule(sql,table);
                            //	System.out.println("--- update module periode success  ---");
                           // }
                            
                        }
                        catch(Exception ex){
                           System.out.println("--- FAILED ---");
                           //message = message + "<br><font color='green'>data already exist, ok</font>";
                           message = message + "<br><font color='red'>FAILED - Err - Can't process query : "+sql+"</font>"; 
                        }

                    }
                    catch(Exception e){
                        System.out.println(e.toString());
                        message = message + "<br><font color='red'>Err - Can't parse data to object, "+(String)content.get(0)+"</font>"; 
                    }
                }
                else{
                    message = message + "<br><font color='red'>Err - Not a valid data count, "+(String)content.get(0)+"</font>";                    
                }
            }
            else{
                message = message + "<br><font color='red'>Err - Not a valid encript type, "+(String)content.get(0)+"</font>"; 
            }
        }
        
        return message;
    }
    
    
    public static long getOID(String sql, String table){
    	long result = 0;
    	
    	if(sql!=null && sql.length()>0){
    		
    		int idx = sql.indexOf("INSERT INTO "+table);
    		
    		//adalah insert
    		if(idx>-1){
    			
    			sql = sql.substring(sql.indexOf("VALUES (")+8, sql.length()).trim();
	
				//out.println("<br><br>-> "+sql);
				
				sql = sql.substring(0, sql.indexOf(",")).trim();
				
    		}
    		//update
    		else{
    			idx = sql.indexOf("UPDATE "+table);
    			if(idx>-1){
    				//jika table gl
    				if(table.equalsIgnoreCase(DbGl.DB_GL)){
    					sql = sql.substring(sql.indexOf(DbGl.colNames[DbGl.COL_GL_ID])+8, sql.length()-1).trim();
    				}
    				//table module
    				else{
    					sql = sql.substring(sql.indexOf(DbModule.colNames[DbModule.COL_MODULE_ID])+12, sql.length()-1).trim();
    				}
    			}
    		}
    		
			System.out.println("oid : "+sql);
			
			result = Long.parseLong(sql);    		
			
			//out.println("-><br><br> result : "+result);	
					
    	}
    	
    	return result;
    }
        
    public static void updatePeriodeGL(String sql, String table){
    	long oid = getOID(sql, table);
    	try{
    		Periode p = DbPeriode.getOpenPeriod();
    		sql = "update "+DbGl.DB_GL+" set "+DbGl.colNames[DbGl.COL_PERIOD_ID]+"="+p.getOID()+
    					 " where "+DbGl.colNames[DbGl.COL_GL_ID]+"="+oid;
    		
    		CONHandler.execUpdate(sql);			 	
    		
    	}
    	catch(Exception e){
    		System.out.println(e.toString());
    	}
    	
    } 
    	
    public static void updatePeriodeModule(String sql, String table){
    	
    	long oid = getOID(sql, table);
    	try{
    		ActivityPeriod p = DbActivityPeriod.getOpenPeriod();
    		
    		sql = "update "+DbModule.DB_MODULE+" set "+DbModule.colNames[DbModule.COL_ACTIVITY_PERIOD_ID]+"="+p.getOID()+
    					 " where "+DbModule.colNames[DbModule.COL_MODULE_ID]+"="+oid;
    		
    		CONHandler.execUpdate(sql);			 	
    		
    	}
    	catch(Exception e){
    		System.out.println(e.toString());
    	}
    }
    
}
