/*
 * QrAR.java
 *
 * Created on October 9, 2008, 12:04 AM
 */

package com.project.fms.ar;

import java.util.*;
import java.sql.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.crm.project.*;
import com.project.crm.*;
import com.project.general.*;
import com.project.I_Project;
import com.project.util.*;
import com.project.ccs.postransaction.receiving.*;
import com.project.fms.transaction.*;

/**
 *
 * @author  Valued Customer
 */
public class QrAR {
    
    /** Creates a new instance of QrAR */
    public QrAR() {
    }
    
    //public static Vector list(int start, int recordToGet, long customerId, String projName, String projNum, long companyId){
    public static Vector list(int start, int recordToGet, long customerId, String projName, String projNum){
        
        Vector result = new Vector();
        
        CONResultSet crs = null;        
        try{
        
        String sql = " SELECT distinct p.* FROM "+DbProject.DB_PROJECT+" p inner join "+DbProjectTerm.DB_PROJECT_TERM+" pt "+
                     " on p."+DbProject.colNames[DbProject.COL_PROJECT_ID]+" = pt."+DbProjectTerm.colNames[DbProjectTerm.COL_PROJECT_ID]+
                     " where pt."+DbProjectTerm.colNames[DbProjectTerm.COL_STATUS]+"="+I_Crm.TERM_STATUS_READY_TO_INV;
                     if(customerId!=0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_CUSTOMER_ID]+"="+customerId;
                     }
                     if(projName.length()>0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_NAME]+" like '%"+projName+"%'";
                     }
                     if(projNum.length()>0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_NUMBER]+" like '%"+projNum+"%'";
                     }
               
                     //sql = sql + " and p."+DbProject.colNames[DbProject.COL_COMPANY_ID]+"="+companyId;
                                
                     sql = sql + " order by pt."+DbProjectTerm.colNames[DbProjectTerm.COL_DUE_DATE]+", "+
                           "p."+DbProject.colNames[DbProject.COL_DATE]+", "+
                           "p."+DbProject.colNames[DbProject.COL_NAME];
                     
                     if(recordToGet>0){
                         sql = sql +" limit "+start+","+recordToGet;
                     }
                     
              System.out.println(sql);
              
              crs = CONHandler.execQueryResult(sql);
              ResultSet rs = crs.getResultSet();
              while(rs.next()){
                  //Vector temp = new Vector();
                  Project p = new Project();
                  //ProjectTerm pt = new ProjectTerm();
                  DbProject.resultToObject(rs, p); 
                  //DbProjectTerm.resultToObject(rs, pt);
                  //temp.add(p);
                  //temp.add(pt);
                  //result.add(temp);
                  result.add(p);
              }
                     
        }
        catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    //public static int getCount(long customerId, String projName, String projNum, long companyId){
    public static int getCount(long customerId, String projName, String projNum){    
        
        int result = 0;
        
        CONResultSet crs = null;        
        try{
        
        String sql = " SELECT count(p."+DbProject.colNames[DbProject.COL_PROJECT_ID]+") FROM "+DbProject.DB_PROJECT+" p inner join "+DbProjectTerm.DB_PROJECT_TERM+" pt "+
                     " on p."+DbProject.colNames[DbProject.COL_PROJECT_ID]+" = pt."+DbProjectTerm.colNames[DbProjectTerm.COL_PROJECT_ID]+
                     " where pt."+DbProjectTerm.colNames[DbProjectTerm.COL_STATUS]+"="+I_Crm.TERM_STATUS_READY_TO_INV;
                     if(customerId!=0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_CUSTOMER_ID]+"="+customerId;
                     }
                     if(projName.length()>0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_NAME]+" like '%"+projName+"%'";
                     }
                     if(projNum.length()>0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_NUMBER]+" like '%"+projNum+"%'";
                     }
        
                     //sql = sql + " and p."+DbProject.colNames[DbProject.COL_COMPANY_ID]+"="+companyId;
                     
                     sql = sql + " order by pt."+DbProjectTerm.colNames[DbProjectTerm.COL_DUE_DATE]+", "+
                           "p."+DbProject.colNames[DbProject.COL_DATE]+", "+
                           "p."+DbProject.colNames[DbProject.COL_NAME];
                     
              System.out.println(sql);
              
              crs = CONHandler.execQueryResult(sql);
              ResultSet rs = crs.getResultSet();
              while(rs.next()){
                  result = rs.getInt(1);
              }
                     
        }
        catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    public static Vector list(int start, int recordToGet, long customerId, String projName, String projNum, long unitUsahaId){
        
        Vector result = new Vector();
        
        CONResultSet crs = null;        
        try{
        
        String sql = " SELECT distinct p.* FROM "+DbProject.DB_PROJECT+" p inner join "+DbProjectTerm.DB_PROJECT_TERM+" pt "+
                     " on p."+DbProject.colNames[DbProject.COL_PROJECT_ID]+" = pt."+DbProjectTerm.colNames[DbProjectTerm.COL_PROJECT_ID]+
                     " where pt."+DbProjectTerm.colNames[DbProjectTerm.COL_STATUS]+"="+I_Crm.TERM_STATUS_READY_TO_INV;
                     if(customerId!=0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_CUSTOMER_ID]+"="+customerId;
                     }
                     if(projName.length()>0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_NAME]+" like '%"+projName+"%'";
                     }
                     if(projNum.length()>0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_NUMBER]+" like '%"+projNum+"%'";
                     }
                     if(unitUsahaId!=0){
                         //sql = sql + " and p."+DbProject.colNames[DbProject.COL_UNIT_USAHA_ID]+" ="+unitUsahaId;
                     }
               
                     //sql = sql + " and p."+DbProject.colNames[DbProject.COL_COMPANY_ID]+"="+companyId;
                                
                     sql = sql + " order by pt."+DbProjectTerm.colNames[DbProjectTerm.COL_DUE_DATE]+", "+
                           "p."+DbProject.colNames[DbProject.COL_DATE]+", "+
                           "p."+DbProject.colNames[DbProject.COL_NAME];
                     
                     if(recordToGet>0){
                         sql = sql +" limit "+start+","+recordToGet;
                     }
                     
              System.out.println(sql);
              
              crs = CONHandler.execQueryResult(sql);
              ResultSet rs = crs.getResultSet();
              while(rs.next()){
                  //Vector temp = new Vector();
                  Project p = new Project();
                  //ProjectTerm pt = new ProjectTerm();
                  DbProject.resultToObject(rs, p); 
                  //DbProjectTerm.resultToObject(rs, pt);
                  //temp.add(p);
                  //temp.add(pt);
                  //result.add(temp);
                  result.add(p);
              }
                     
        }
        catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    //public static int getCount(long customerId, String projName, String projNum, long companyId){
    public static int getCount(long customerId, String projName, String projNum, long unitUsahaId){    
        
        int result = 0;
        
        CONResultSet crs = null;        
        try{
        
        String sql = " SELECT count(p."+DbProject.colNames[DbProject.COL_PROJECT_ID]+") FROM "+DbProject.DB_PROJECT+" p inner join "+DbProjectTerm.DB_PROJECT_TERM+" pt "+
                     " on p."+DbProject.colNames[DbProject.COL_PROJECT_ID]+" = pt."+DbProjectTerm.colNames[DbProjectTerm.COL_PROJECT_ID]+
                     " where pt."+DbProjectTerm.colNames[DbProjectTerm.COL_STATUS]+"="+I_Crm.TERM_STATUS_READY_TO_INV;
                     if(customerId!=0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_CUSTOMER_ID]+"="+customerId;
                     }
                     if(projName.length()>0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_NAME]+" like '%"+projName+"%'";
                     }
                     if(projNum.length()>0){
                         sql = sql + " and p."+DbProject.colNames[DbProject.COL_NUMBER]+" like '%"+projNum+"%'";
                     }
                     if(unitUsahaId!=0){
                        // sql = sql + " and p."+DbProject.colNames[DbProject.COL_UNIT_USAHA_ID]+" ="+unitUsahaId;
                     }
        
                     //sql = sql + " and p."+DbProject.colNames[DbProject.COL_COMPANY_ID]+"="+companyId;
                     
                     sql = sql + " order by pt."+DbProjectTerm.colNames[DbProjectTerm.COL_DUE_DATE]+", "+
                           "p."+DbProject.colNames[DbProject.COL_DATE]+", "+
                           "p."+DbProject.colNames[DbProject.COL_NAME];
                     
              System.out.println(sql);
              
              crs = CONHandler.execQueryResult(sql);
              ResultSet rs = crs.getResultSet();
              while(rs.next()){
                  result = rs.getInt(1);
              }
                     
        }
        catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    //For Payment Search
    //public static Vector list(String whereClause, String orderClause, long companyId){
    public static Vector list(String whereClause, String orderClause){
        
        Vector result = new Vector();
        
        CONResultSet crs = null;        
        try{
        
            String sql = " SELECT a.* FROM "+DbARInvoice.DB_AR_INVOICE+" a, "+DbProject.DB_PROJECT+" b "+
                         //" Where a."+DbARInvoice.colNames[DbARInvoice.COL_COMPANY_ID]+"="+companyId+ " and a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID]+
                         //" and a."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;
                         " Where a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID]+
                         " and a."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;

            if (whereClause.length()>0){
                sql = sql + " and "+ whereClause;
            }
            if (orderClause.length()>0){
                sql = sql + " Order By " + orderClause;
            }

            System.out.println(sql);

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	ARInvoice arInv = new ARInvoice();
              	DbARInvoice.resultToObject(rs, arInv);
              	result.add(arInv);
            }
        }
        catch(Exception e){            
        }
        finally{
            CONResultSet.close(crs);
        }        
        return result;
    }
    
    //public static Vector list(String whereClause, String orderClause, long companyId){
    public static Vector list(int start, int recordToGet, String whereClause, String orderClause){
        
        Vector result = new Vector();
        
        CONResultSet crs = null;        
        try{
        
            String sql = " SELECT a.* FROM "+DbARInvoice.DB_AR_INVOICE+" a, "+DbProject.DB_PROJECT+" b "+
                         //" Where a."+DbARInvoice.colNames[DbARInvoice.COL_COMPANY_ID]+"="+companyId+ " and a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID]+
                         //" and a."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;
                         " Where a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID]+
                         " and a."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;

            if (whereClause.length()>0){
                sql = sql + " and "+ whereClause;
            }
            if (orderClause.length()>0){
                sql = sql + " Order By " + orderClause;
            }
            
            if(recordToGet>0){
                sql = sql + " limit "+start+","+recordToGet;
            }

            System.out.println(sql);

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	ARInvoice arInv = new ARInvoice();
              	DbARInvoice.resultToObject(rs, arInv);
              	result.add(arInv);
            }
        }
        catch(Exception e){            
        }
        finally{
            CONResultSet.close(crs);
        }    
        
        //------------------------------------------------------------
        //get from sales credit
        crs = null;        
        try{
        
            String sql = "";// SELECT a.* FROM "+DbARInvoice.DB_AR_INVOICE+" a, "+DbSales.DB_SALES+" b "+
                         //" Where a."+DbARInvoice.colNames[DbARInvoice.COL_COMPANY_ID]+"="+companyId+ " and a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID]+
                         //" and a."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;
                         //" Where a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbSales.colNames[DbSales.COL_SALES_ID]+
                         //" and a."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;

            if (whereClause.length()>0){
                sql = sql + " and "+ whereClause;
            }
            if (orderClause.length()>0){
                sql = sql + " Order By " + orderClause;
            }
            
            if(recordToGet>0){
                sql = sql + " limit "+start+","+recordToGet;
            }

            System.out.println(sql);

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	ARInvoice arInv = new ARInvoice();
              	DbARInvoice.resultToObject(rs, arInv);
              	result.add(arInv);
            }
        }
        catch(Exception e){            
        }
        finally{
            CONResultSet.close(crs);
        } 
        
        
        return result;
    }
    
    //public static Vector list(String whereClause, String orderClause, long companyId){
    public static int getCount(String whereClause){
        
        int result = 0;
        
        CONResultSet crs = null;        
        try{
        
            String sql = " SELECT count(a."+DbARInvoice.colNames[DbARInvoice.COL_AR_INVOICE_ID]+") FROM "+DbARInvoice.DB_AR_INVOICE+" a, "+DbProject.DB_PROJECT+" b "+
                         //" Where a."+DbARInvoice.colNames[DbARInvoice.COL_COMPANY_ID]+"="+companyId+ " and a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID]+
                         //" and a."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;
                         " Where a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID]+
                         " and a."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;

            if (whereClause.length()>0){
                sql = sql + " and "+ whereClause;
            }
            
            System.out.println(sql);

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	result = rs.getInt(1);
            }
        }
        catch(Exception e){            
        }
        finally{
            CONResultSet.close(crs);
        }        
        return result;
    }
    
    //For Aging Search
    //public static Vector list(long oidCustomer, int ageDate, int ageRange, long companyId){
    public static Vector list(long oidCustomer, int ageDate, int ageRange, long unitUsahaId){
   
        //current =>  '<= now'
        Date dtNowA = new Date();
        Date dtNowB = (Date)dtNowA.clone();
        dtNowB.setDate(dtNowB.getDate()-30);
        
        //Over 30 =>  '1-30'
        Date dtNow30A = (Date)dtNowA.clone();
        dtNow30A.setDate(dtNow30A.getDate()+1);
        Date dtNow30B = (Date)dtNowA.clone();
        dtNow30B.setDate(dtNow30B.getDate()+30);
        
        //Over 60 =>  '31-60'
        Date dtNow60A = (Date)dtNowA.clone();
        dtNow60A.setDate(dtNow60A.getDate()+31);
        Date dtNow60B = (Date)dtNowA.clone();
        dtNow60B.setDate(dtNow60B.getDate()+60);

        //Over 90 =>  '61-90'
        Date dtNow90A = (Date)dtNowA.clone();
        dtNow90A.setDate(dtNow90A.getDate()+61);
        Date dtNow90B = (Date)dtNowA.clone();
        dtNow90B.setDate(dtNow90B.getDate()+90);
        
        //Over 120 =>  '90+'
        Date dtNow120A = (Date)dtNowA.clone();
        dtNow120A.setDate(dtNow120A.getDate()+91);        
                
        //get list customer by company        
        String whereClause = "";        
        Vector vCustomer = new Vector(1,1);
        
        if(oidCustomer!=0){
            try{
                Customer customer = DbCustomer.fetchExc(oidCustomer);
                vCustomer.add(customer);
            }catch(Exception e){}
        }else{
            vCustomer = DbCustomer.list(0,0,"","");
        }
        
        //Create Vector to Store Detail
        Vector result = new Vector();
        SesAgingAnalysis sesAgingAnalysis = new SesAgingAnalysis();
        
        if(vCustomer!=null && vCustomer.size()>0){
            for(int i=0; i<vCustomer.size(); i++){
                Customer customer = (Customer)vCustomer.get(i);
                //Get Invoice not Fully Paid                
                whereClause = DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID]+"="+customer.getOID()+" and "+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;
                
                // Last Payment                 
                Vector vx = DbArPayment.list(0, 1, DbArPayment.colNames[DbArPayment.COL_CUSTOMER_ID]+"="+customer.getOID(), DbArPayment.colNames[DbArPayment.COL_TRANSACTION_DATE]+" desc");
                ArPayment arPay = new ArPayment();
                if(vx!=null && vx.size()>0){
                    arPay = (ArPayment)vx.get(0);
                }
                
                if(ageDate==I_Project.AGE_DUE_DATE){
                    whereClause = whereClause + " and "+DbARInvoice.colNames[DbARInvoice.COL_DUE_DATE];
                }else{
                    whereClause = whereClause + " and "+DbARInvoice.colNames[DbARInvoice.COL_TRANS_DATE];
                }
                
                //get cureent                
                String whereCurrent = whereClause;
                whereCurrent = whereCurrent + " <= '"+JSPFormater.formatDate(dtNowA, "yyyy-MM-dd")+"'";                
                Vector vArInvCurrent = new Vector(1,1);
                vArInvCurrent = DbARInvoice.list(0,0, whereCurrent, "");                             
                
                // get Over 1-30 (BESOK + 30 HARI)                
                String whereOver30 = whereClause;
                whereOver30 = whereOver30 + " between '"+JSPFormater.formatDate(dtNow30A, "yyyy-MM-dd")+"' and '"+ JSPFormater.formatDate(dtNow30B, "yyyy-MM-dd")+"'";                
                Vector vArInvOver30 = new Vector(1,1);
                vArInvOver30 = DbARInvoice.list(0,0, whereOver30, "");                             
 
                //get Over 60 -> 31-60                
                String whereOver60 = whereClause;
                whereOver60 = whereOver60 + " between '"+JSPFormater.formatDate(dtNow60A, "yyyy-MM-dd")+"' and '"+ JSPFormater.formatDate(dtNow60B, "yyyy-MM-dd")+"'";                
                Vector vArInvOver60 = new Vector(1,1);
                vArInvOver60 = DbARInvoice.list(0,0, whereOver60, "");                             

                //get Over 90 -> 61-90                
                String whereOver90 = whereClause;
                whereOver90 = whereOver90 + " between '"+JSPFormater.formatDate(dtNow90A, "yyyy-MM-dd")+"' and '"+ JSPFormater.formatDate(dtNow90B, "yyyy-MM-dd")+"'";
                Vector vArInvOver90 = new Vector(1,1);
                vArInvOver90 = DbARInvoice.list(0,0, whereOver90, "");                             

                //get Over 90+                
                String whereOver120 = whereClause;
                whereOver120 = whereOver120 + " >= '"+JSPFormater.formatDate(dtNow120A, "yyyy-MM-dd")+"'";                
                Vector vArInvOver120 = new Vector(1,1);
                vArInvOver120 = DbARInvoice.list(0,0, whereOver120, "");                             
                
                //Store Data 
                sesAgingAnalysis = new SesAgingAnalysis();                
                
                sesAgingAnalysis.setCustomerName(customer.getName());
                sesAgingAnalysis.setCustomerCode(customer.getCode());
                double totCurrent = getTotalInvoice(vArInvCurrent, unitUsahaId);
                sesAgingAnalysis.setAgeCurrent(totCurrent);
                double totOvr30 = getTotalInvoice(vArInvOver30, unitUsahaId);
                sesAgingAnalysis.setAgeOver30(totOvr30);
                double totOvr60 = getTotalInvoice(vArInvOver60, unitUsahaId);
                sesAgingAnalysis.setAgeOver60(totOvr60);
                double totOvr90 = getTotalInvoice(vArInvOver90, unitUsahaId);
                sesAgingAnalysis.setAgeOver90(totOvr90);
                double totOvr120 = getTotalInvoice(vArInvOver120, unitUsahaId);
                sesAgingAnalysis.setAgeOver120(totOvr120);
                sesAgingAnalysis.setLastPaymentAmount(arPay.getArCurrencyAmount());
                sesAgingAnalysis.setLastPaymentDate(arPay.getTransactionDate());
                if(totCurrent > 0 || totOvr30 > 0 || totOvr60 > 0 || totOvr90 > 0 || totOvr120 > 0){
                    result.add(sesAgingAnalysis);
                }
            }
        }   
        return result;
    }  
    
    //By Roy Andika
    public static Vector listAgingAR(long oidCustomer, int ageDate, String formNumbComp){
   
        //current =>  '<= now'
        Date dtNowA = new Date();
        Date dtNowB = (Date)dtNowA.clone();
        dtNowB.setDate(dtNowB.getDate()-30);
        
        //Over 30 =>  '1-30'
        Date dtNow30A = (Date)dtNowA.clone();
        dtNow30A.setDate(dtNow30A.getDate()+1);
        Date dtNow30B = (Date)dtNowA.clone();
        dtNow30B.setDate(dtNow30B.getDate()+30);
        
        //Over 60 =>  '31-60'
        Date dtNow60A = (Date)dtNowA.clone();
        dtNow60A.setDate(dtNow60A.getDate()+31);
        Date dtNow60B = (Date)dtNowA.clone();
        dtNow60B.setDate(dtNow60B.getDate()+60);

        //Over 90 =>  '61-90'
        Date dtNow90A = (Date)dtNowA.clone();
        dtNow90A.setDate(dtNow90A.getDate()+61);
        Date dtNow90B = (Date)dtNowA.clone();
        dtNow90B.setDate(dtNow90B.getDate()+90);
        
        //Over 120 =>  '90+'
        Date dtNow120A = (Date)dtNowA.clone();
        dtNow120A.setDate(dtNow120A.getDate()+91);        
                
        //get list customer by company        
        String whereClause = "";        
        Vector vCustomer = new Vector(1,1);
        
        if(oidCustomer!=0){
            try{
                Customer customer = DbCustomer.fetchExc(oidCustomer);
                vCustomer.add(customer);
            }catch(Exception e){}
        }else{
            //vCustomer = DbCustomer.list(0,0,"","");
            vCustomer = getCustomer();            
        }
        
        //Create Vector to Store Detail
        Vector result = new Vector();
        SesAgingAnalysis sesAgingAnalysis = new SesAgingAnalysis();
        
        if(vCustomer!=null && vCustomer.size()>0){
            for(int i=0; i<vCustomer.size(); i++){
                AgingCustomer aCustomer = (AgingCustomer)vCustomer.get(i);
                //Get Invoice not Fully Paid                
                whereClause = DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID]+"="+aCustomer.getCustomerId()+" and "+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+"!="+I_Project.INV_STATUS_FULL_PAID;
                
                // Last Payment                 
                Vector vx = DbArPayment.list(0, 1, DbArPayment.colNames[DbArPayment.COL_CUSTOMER_ID]+"="+aCustomer.getCustomerId(), DbArPayment.colNames[DbArPayment.COL_TRANSACTION_DATE]+" desc");
                ArPayment arPay = new ArPayment();
                if(vx!=null && vx.size()>0){
                    arPay = (ArPayment)vx.get(0);
                }
                
                if(ageDate==I_Project.AGE_DUE_DATE){
                    whereClause = whereClause + " and "+DbARInvoice.colNames[DbARInvoice.COL_DUE_DATE];
                }else{
                    whereClause = whereClause + " and "+DbARInvoice.colNames[DbARInvoice.COL_TRANS_DATE];
                }
                
                //get cureent                
                String whereCurrent = whereClause;
                whereCurrent = whereCurrent + " <= '"+JSPFormater.formatDate(dtNowA, "yyyy-MM-dd")+"'";                
                Vector vArInvCurrent = new Vector(1,1);
                vArInvCurrent = DbARInvoice.list(0,0, whereCurrent, "");                             
                
                // get Over 1-30 (BESOK + 30 HARI)                
                String whereOver30 = whereClause;
                whereOver30 = whereOver30 + " between '"+JSPFormater.formatDate(dtNow30A, "yyyy-MM-dd")+"' and '"+ JSPFormater.formatDate(dtNow30B, "yyyy-MM-dd")+"'";                
                Vector vArInvOver30 = new Vector(1,1);
                vArInvOver30 = DbARInvoice.list(0,0, whereOver30, "");                             
 
                //get Over 60 -> 31-60                
                String whereOver60 = whereClause;
                whereOver60 = whereOver60 + " between '"+JSPFormater.formatDate(dtNow60A, "yyyy-MM-dd")+"' and '"+ JSPFormater.formatDate(dtNow60B, "yyyy-MM-dd")+"'";                
                Vector vArInvOver60 = new Vector(1,1);
                vArInvOver60 = DbARInvoice.list(0,0, whereOver60, "");                             

                //get Over 90 -> 61-90                
                String whereOver90 = whereClause;
                whereOver90 = whereOver90 + " between '"+JSPFormater.formatDate(dtNow90A, "yyyy-MM-dd")+"' and '"+ JSPFormater.formatDate(dtNow90B, "yyyy-MM-dd")+"'";
                Vector vArInvOver90 = new Vector(1,1);
                vArInvOver90 = DbARInvoice.list(0,0, whereOver90, "");                             

                //get Over 90+                
                String whereOver120 = whereClause;
                whereOver120 = whereOver120 + " >= '"+JSPFormater.formatDate(dtNow120A, "yyyy-MM-dd")+"'";                
                Vector vArInvOver120 = new Vector(1,1);
                vArInvOver120 = DbARInvoice.list(0,0, whereOver120, "");                             
                
                //Store Data 
                sesAgingAnalysis = new SesAgingAnalysis();               
                
                sesAgingAnalysis.setCustomerName(aCustomer.getName());
                sesAgingAnalysis.setCustomerCode(aCustomer.getCode());
                double totCurrent = getTotalInvoice(vArInvCurrent,formNumbComp);
                sesAgingAnalysis.setAgeCurrent(totCurrent);
                double totOvr30 = getTotalInvoice(vArInvOver30,formNumbComp);
                sesAgingAnalysis.setAgeOver30(totOvr30);
                double totOvr60 = getTotalInvoice(vArInvOver60,formNumbComp);
                sesAgingAnalysis.setAgeOver60(totOvr60);
                double totOvr90 = getTotalInvoice(vArInvOver90,formNumbComp);
                sesAgingAnalysis.setAgeOver90(totOvr90);
                double totOvr120 = getTotalInvoice(vArInvOver120,formNumbComp);                
                sesAgingAnalysis.setAgeOver120(totOvr120);
                
                if (formNumbComp.equals("#,##0")) {
                    sesAgingAnalysis.setLastPaymentAmount(Math.round(arPay.getArCurrencyAmount()));
                }else{
                    sesAgingAnalysis.setLastPaymentAmount(arPay.getArCurrencyAmount());
                }                
                sesAgingAnalysis.setLastPaymentDate(arPay.getTransactionDate());
                
                if(totCurrent > 0 || totOvr30 > 0 || totOvr60 > 0 || totOvr90 > 0 || totOvr120 > 0){
                    result.add(sesAgingAnalysis);
                }
            }
        }   
        return result;
    }
    
    
    public static Vector getCustomer(){
        
        Vector result = new Vector();
        
        try{
            String sql = "select distinct c."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" as customer_id, "+
                    " c."+DbCustomer.colNames[DbCustomer.COL_CODE]+" as code, "+
                    " c."+DbCustomer.colNames[DbCustomer.COL_NAME]+" as name "+
                    " from "+DbCustomer.DB_CUSTOMER+" c inner join "+DbARInvoice.DB_AR_INVOICE+" ai on c."+
                    DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = ai."+DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID]+
                    " where ai."+DbARInvoice.colNames[DbARInvoice.COL_STATUS]+" != "+I_Project.INV_STATUS_FULL_PAID+" order by c."+DbCustomer.colNames[DbCustomer.COL_NAME];
            
            CONResultSet crs = null;
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    AgingCustomer ac = new AgingCustomer();
                    ac.setCustomerId(rs.getLong("customer_id"));
                    ac.setCode(rs.getString("code"));
                    ac.setName(rs.getString("name"));
                    result.add(ac);
                }
                rs.close();
            }catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
        }catch(Exception e){}
        
        return null;
    }
    
    //For Aging Search
    //public static Vector list(long oidCustomer, int ageDate, int ageRange, long companyId){
    public static Vector listApAging(long oidVendor, int ageDate, int ageRange, long unitUsahaId){
   
        //current
        Date dtNow = new Date();
        
        //1-30
        Date dtNowA = (Date)dtNow.clone();
        
        Date dtNowA1 = (Date)dtNow.clone();
        dtNowA1.setDate(dtNowA1.getDate()+1);
        Date dtNowB = (Date)dtNowA.clone();
        dtNowB.setDate(dtNowB.getDate()+30);
        
        //31-60
        Date dtNow30A = (Date)dtNowA.clone();
        dtNow30A.setDate(dtNow30A.getDate()+31);
        Date dtNow30B = (Date)dtNowA.clone();
        dtNow30B.setDate(dtNow30B.getDate()+60);
        
        //61-90
        Date dtNow60A = (Date)dtNowA.clone();
        dtNow60A.setDate(dtNow60A.getDate()+61);
        Date dtNow60B = (Date)dtNowA.clone();
        dtNow60B.setDate(dtNow60B.getDate()+90);

        //91-120
        Date dtNow90A = (Date)dtNowA.clone();
        dtNow90A.setDate(dtNow90A.getDate()+91);
        Date dtNow90B = (Date)dtNowA.clone();
        dtNow90B.setDate(dtNow90B.getDate()+120);
        
        //120+
        Date dtNow120A = (Date)dtNowA.clone();
        dtNow120A.setDate(dtNow120A.getDate()+121);
     
        String whereClause = "";
        if(oidVendor>0){            
            whereClause = DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"="+oidVendor;
        }
        
        Vector vVendor = new Vector(1,1);
        
        vVendor = DbVendor.list(0,0, whereClause,"");
        
        //Create Vector to Store Detail
        Vector result = new Vector();
        SesAgingAnalysis sesAgingAnalysis = new SesAgingAnalysis();
        
        if(vVendor!=null && vVendor.size()>0){
            for(int i=0; i<vVendor.size(); i++){

                Vendor vendor = (Vendor)vVendor.get(i);
                
                //Store Data 
                sesAgingAnalysis = new SesAgingAnalysis();                
                sesAgingAnalysis.setCustomerCode(vendor.getCode());
                sesAgingAnalysis.setCustomerName(vendor.getName());
                //current
                double totCurr = getTotalAPBalanceByVendor(vendor.getOID(), dtNow, null, unitUsahaId);
                sesAgingAnalysis.setAgeCurrent(totCurr);
                //1-30
                double totCurr30 = getTotalAPBalanceByVendor(vendor.getOID(), dtNowA1, dtNowB, unitUsahaId);
                sesAgingAnalysis.setAgeOver30(totCurr30);
                //31-60
                double totCurr60 = getTotalAPBalanceByVendor(vendor.getOID(), dtNow30A, dtNow30B, unitUsahaId);
                sesAgingAnalysis.setAgeOver60(totCurr60);
                //61-90
                double totCurr90 = getTotalAPBalanceByVendor(vendor.getOID(), dtNow60A, dtNow60B, unitUsahaId);
                sesAgingAnalysis.setAgeOver90(totCurr90);
                //91+
                double totCurr120 = getTotalAPBalanceByVendor(vendor.getOID(), null, dtNow90A, unitUsahaId);
                sesAgingAnalysis.setAgeOver120(totCurr120);                
                sesAgingAnalysis.setLastPaymentAmount(0);
                sesAgingAnalysis.setLastPaymentDate(new Date());                
                
                if(totCurr > 0 || totCurr30 > 0 || totCurr60 > 0 || totCurr90 > 0 || totCurr120 > 0){                
                    result.add(sesAgingAnalysis);
                }
            }
        }   
        return result; 
    }  
    
    public static Vector listApAging(long oidVendor,String code){
   
        //current
        Date dtNow = new Date();        
        //1-30
        Date dtNowA = (Date)dtNow.clone();
        
        Date dtNowA1 = (Date)dtNow.clone();
        dtNowA1.setDate(dtNowA1.getDate()+1);
        Date dtNowB = (Date)dtNowA.clone();
        dtNowB.setDate(dtNowB.getDate()+30);
        
        //31-60
        Date dtNow30A = (Date)dtNowA.clone();
        dtNow30A.setDate(dtNow30A.getDate()+31);
        Date dtNow30B = (Date)dtNowA.clone();
        dtNow30B.setDate(dtNow30B.getDate()+60);
        
        //61-90
        Date dtNow60A = (Date)dtNowA.clone();
        dtNow60A.setDate(dtNow60A.getDate()+61);
        Date dtNow60B = (Date)dtNowA.clone();
        dtNow60B.setDate(dtNow60B.getDate()+90);

        //91-120
        Date dtNow90A = (Date)dtNowA.clone();
        dtNow90A.setDate(dtNow90A.getDate()+91);
        Date dtNow90B = (Date)dtNowA.clone();
        dtNow90B.setDate(dtNow90B.getDate()+120);
        
        //120+
        Date dtNow120A = (Date)dtNowA.clone();
        dtNow120A.setDate(dtNow120A.getDate()+121);
     
        String whereClause = "";
        if(oidVendor>0){            
            whereClause = DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"="+oidVendor;
        }
        
        if(code != null && code.length() > 0){
            if(whereClause != null && whereClause.length() > 0){
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbVendor.colNames[DbVendor.COL_CODE]+" like '%"+code+"%' ";
        }
        
        Vector vVendor = new Vector(1,1);        
        vVendor = DbVendor.list(0,0, whereClause,DbVendor.colNames[DbVendor.COL_NAME]);
        
        //Create Vector to Store Detail
        Vector result = new Vector();
        SesAgingAnalysis sesAgingAnalysis = new SesAgingAnalysis();
        
        if(vVendor!=null && vVendor.size()>0){
            for(int i=0; i<vVendor.size(); i++){

                Vendor vendor = (Vendor)vVendor.get(i);
                
                //Store Data 
                sesAgingAnalysis = new SesAgingAnalysis();                
                sesAgingAnalysis.setCustomerCode(vendor.getCode());
                sesAgingAnalysis.setCustomerName(vendor.getName());
                //current
                //double totCurr = getTotalAPBalanceByVendor(vendor.getOID(), dtNow, null);
                double totCurr = getTotalAgingAP(vendor.getOID(), dtNow, null);
                sesAgingAnalysis.setAgeCurrent(totCurr);
                //1-30
                //double totCurr30 = getTotalAPBalanceByVendor(vendor.getOID(), dtNowA1, dtNowB);
                double totCurr30 = getTotalAgingAP(vendor.getOID(), dtNowA1, dtNowB);                
                sesAgingAnalysis.setAgeOver30(totCurr30);
                //31-60
                //double totCurr60 = getTotalAPBalanceByVendor(vendor.getOID(), dtNow30A, dtNow30B);
                double totCurr60 = getTotalAgingAP(vendor.getOID(), dtNow30A, dtNow30B);
                sesAgingAnalysis.setAgeOver60(totCurr60);
                //61-90
                //double totCurr90 = getTotalAPBalanceByVendor(vendor.getOID(), dtNow60A, dtNow60B);
                double totCurr90 = getTotalAgingAP(vendor.getOID(), dtNow60A, dtNow60B);
                sesAgingAnalysis.setAgeOver90(totCurr90);
                //91+
                //double totCurr120 = getTotalAPBalanceByVendor(vendor.getOID(), null, dtNow90A);
                double totCurr120 = getTotalAgingAP(vendor.getOID(), null, dtNow90A);                
                sesAgingAnalysis.setAgeOver120(totCurr120);                
                sesAgingAnalysis.setLastPaymentAmount(0);
                sesAgingAnalysis.setLastPaymentDate(new Date());                
                
                if(totCurr > 0 || totCurr30 > 0 || totCurr60 > 0 || totCurr90 > 0 || totCurr120 > 0){                
                    result.add(sesAgingAnalysis);
                }
            }
        }   
        return result; 
    }  
    
    public static double getTotalAgingAP(long oidVendor, Date startDate, Date endDate){                
        try{
    
            String sql = "select vendor_id,code,name,sum(q) as tot from " +
                        " (select v." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " as vendor_id,v." + DbVendor.colNames[DbVendor.COL_CODE] + " as code,v." + DbVendor.colNames[DbVendor.COL_NAME] + " as name,sum(" + DbReceive.colNames[DbReceive.COL_TOTAL_AMOUNT] + " - " + DbReceive.colNames[DbReceive.COL_DISCOUNT_TOTAL] + " + " + DbReceive.colNames[DbReceive.COL_TOTAL_TAX] + ") as q from " + DbReceive.DB_RECEIVE + " r inner join " + DbVendor.DB_VENDOR + " v on r." + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + " = v." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + 
                        " where " + DbReceive.colNames[DbReceive.COL_STATUS] + " = 'CHECKED' and " + DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS_POSTED] + " != 2 and r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" = "+oidVendor;                        
            
            if(startDate!=null && endDate!=null){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+
                    " >= '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
                    " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"<='"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"'";
            }else if(startDate!=null){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+
                    "<='"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'";
            }else if(endDate!=null){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+
                    ">='"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"'";
            }
            sql = sql +" group by v." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                        " union " +
                        " select v." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " as vendor_id,v." + DbVendor.colNames[DbVendor.COL_CODE] + " as code,v." + DbVendor.colNames[DbVendor.COL_NAME] + " as name,sum(bd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT] + ") *-1 as q from " + DbReceive.DB_RECEIVE + " r inner join " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bd on r." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] + " = bd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " inner join " + DbBankpoPayment.DB_BANKPO_PAYMENT + " b on bd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " = b." + DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + " inner join " + DbVendor.DB_VENDOR + " v on r." + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + " = v." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];
            sql = sql + " where r." + DbReceive.colNames[DbReceive.COL_STATUS] + " = 'CHECKED' and r." + DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS_POSTED] + " != 2 and b." + DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS] + "='Paid' and b." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = 0 and r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" = "+oidVendor;                        
            if(startDate!=null && endDate!=null){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+
                    " >= '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
                    " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"<='"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"'";
            }else if(startDate!=null){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+
                    "<='"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'";
            }else if(endDate!=null){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+
                    ">='"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"'";
            }        
            sql = sql + " group by v." + DbVendor.colNames[DbVendor.COL_NAME] + " ) as x group by name";
            
            CONResultSet crs = null;
            double result = 0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble("tot");
                }
            }catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
            
        }catch(Exception e){}
        
        return 0;

    }
    
    public static double getTotalAPBalanceByVendor(long oidVendor, Date startDate, Date endDate){                
        double totalInvoice = DbReceive.getTotalInvoiceByVendor(oidVendor, startDate, endDate);
        double totalPayment = DbBankpoPayment.getTotalPaymentByVendor(oidVendor, startDate, endDate);        
        return totalInvoice - totalPayment;
    }  
    
    public static double getTotalAPBalanceByVendor(long oidVendor, Date startDate, Date endDate, long unitUsahaId){
        
        double totalInvoice = DbReceive.getTotalInvoiceByVendor(oidVendor, startDate, endDate, unitUsahaId);
        double totalPayment = DbBankpoPayment.getTotalPaymentByVendor(oidVendor, startDate, endDate, unitUsahaId);
        
        return totalInvoice - totalPayment;
    }  
    

    public static double getTotalInvoice(Vector listx, long unitUsahaId){
        double result = 0;
        double resultDetail = 0;
        double resultPayment = 0;
        
        if(listx!=null && listx.size()>0){
            
            for(int i=0; i<listx.size(); i++){
                
                ARInvoice arInvoice = (ARInvoice)listx.get(i);                
                //get Invoice Detail
                Vector vArInvDetail = new Vector(1,1);
                vArInvDetail = DbARInvoiceDetail.list(0,0, DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID]+"="+arInvoice.getOID(),"");
                    
                if(vArInvDetail != null && vArInvDetail.size()>0 ){
                    for(int ix = 0 ; ix < vArInvDetail.size() ; ix++){
                        ARInvoiceDetail aRInvoiceDetail = (ARInvoiceDetail)vArInvDetail.get(ix);
                        resultDetail = resultDetail + aRInvoiceDetail.getTotalAmount();
                    }
                }

                //get Invoice Payment
                Vector vArInvPayment = new Vector(1,1);
                vArInvPayment = DbArPayment.list(0,0, DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID]+"="+arInvoice.getOID(),"");
                resultPayment = resultPayment + (DbArPayment.getTotalDetailPayment(vArInvPayment));
                
            }
        }
        result = resultDetail - resultPayment;
        
        return result;
    }
    
    public static double getTotalInvoice(Vector listx, String formNumbComp){
        double result = 0;
        double resultDetail = 0;
        double resultPayment = 0;
        
        if(listx!=null && listx.size()>0){
            
            for(int i=0; i<listx.size(); i++){
                
                ARInvoice arInvoice = (ARInvoice)listx.get(i);                
                //get Invoice Detail
                Vector vArInvDetail = new Vector(1,1);
                vArInvDetail = DbARInvoiceDetail.list(0,0, DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID]+"="+arInvoice.getOID(),"");
                    
                if(vArInvDetail != null && vArInvDetail.size()>0 ){
                    for(int ix = 0 ; ix < vArInvDetail.size() ; ix++){
                        ARInvoiceDetail aRInvoiceDetail = (ARInvoiceDetail)vArInvDetail.get(ix);
                        if (formNumbComp.equals("#,##0")) {
                            resultDetail = resultDetail + Math.round(aRInvoiceDetail.getTotalAmount());  // untuk pembulatan
                        }else{                        
                            resultDetail = resultDetail + aRInvoiceDetail.getTotalAmount();
                        }
                    }
                }

                //get Invoice Payment
                Vector vArInvPayment = new Vector(1,1);
                vArInvPayment = DbArPayment.list(0,0, DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID]+"="+arInvoice.getOID(),"");
                resultPayment = resultPayment + (DbArPayment.getTotalDetailPayment(vArInvPayment,formNumbComp));
                
            }
        }
        result = resultDetail - resultPayment;
        
        return result;
    }
    
    
    //For Archives Search
    //public static Vector listArchives(String whereClause, String orderClause, long companyId){
    public static Vector listArchives(String whereClause, String orderClause){    
        
        Vector result = new Vector();
        
        CONResultSet crs = null;        
        try{
        
            String sql = " SELECT a.* FROM "+DbARInvoice.DB_AR_INVOICE+" a, "+DbProject.DB_PROJECT+" b "+
                         //" Where a."+DbARInvoice.colNames[DbARInvoice.COL_COMPANY_ID]+"="+companyId+ " and a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID];
                         " Where a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID];

            if (whereClause.length()>0){
                sql = sql + " and "+ whereClause;
            }
            if (orderClause.length()>0){
                sql = sql + " Order By " + orderClause;
            }

            System.out.println(sql);

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	ARInvoice arInv = new ARInvoice();
              	DbARInvoice.resultToObject(rs, arInv);
              	result.add(arInv);
            }
        }
        catch(Exception e){            
        }
        finally{
            CONResultSet.close(crs);
        }   
        
        //------------------------------------- get archive from sales ----
        crs = null;        
        try{
        
            String sql = "";// SELECT a.* FROM "+DbARInvoice.DB_AR_INVOICE+" a, "+DbSales.DB_SALES+" b "+
                         //" Where a."+DbARInvoice.colNames[DbARInvoice.COL_COMPANY_ID]+"="+companyId+ " and a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbProject.colNames[DbProject.COL_PROJECT_ID];
                         //" Where a."+DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+"=b."+DbSales.colNames[DbSales.COL_SALES_ID];

            //if (whereClause.length()>0){
            //    sql = sql + " and "+ whereClause;
            //}
            //if (orderClause.length()>0){
            //    sql = sql + " Order By " + orderClause;
            //}

            System.out.println(sql);

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	ARInvoice arInv = new ARInvoice();
              	DbARInvoice.resultToObject(rs, arInv);
              	result.add(arInv);
            }
        }
        catch(Exception e){            
        }
        finally{
            CONResultSet.close(crs);
        }   
        
        
        return result;
    }
    
    
    public static Vector gabungCustomer(Vector vCustomer, Vector vCustomerSales){
        
        if(vCustomer!=null && vCustomer.size()>0){
            for(int i=0; i<vCustomer.size(); i++){
                Customer c = (Customer)vCustomer.get(i);
                if(vCustomerSales!=null && vCustomerSales.size()>0){
                    for(int x=0; x<vCustomerSales.size(); x++){
                        Customer cx = (Customer)vCustomerSales.get(x);
                        if(cx.getOID()==c.getOID()){
                            vCustomerSales.remove(x);
                            break;
                        }
                    }
                }
            }
        }
        
        if(vCustomerSales!=null && vCustomerSales.size()>0){
            vCustomer.addAll(vCustomerSales);
        }
        
        return vCustomer;
        
    }
    

}
