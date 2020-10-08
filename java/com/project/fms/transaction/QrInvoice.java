/*
 * QrInvoice.java
 *
 * Created on January 16, 2008, 3:38 PM
 */

package com.project.fms.transaction;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.general.*;
import com.project.*;

import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.receiving.*;
import com.project.ccs.postransaction.purchase.Purchase;
import com.project.ccs.postransaction.purchase.DbPurchase;
import com.project.util.JSPFormater;
import java.util.Vector;

/**
 *
 * @author  Valued Customer
 */
public class QrInvoice {
    
    /** Creates a new instance of QrInvoice */
    public QrInvoice() {
    }
    
    public static Vector searchInvoice(InvoiceSrc invSrc){        
        
        Vector result = new Vector();
        try{
            String sql = "select v.vendor_id as vendor_id," +
                    " v.name as vendor_name," +
                    " v.code as code," +
                    " r."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" as receive_id, "+
                    " r."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" as purchase_id, "+
                    " r."+DbReceive.colNames[DbReceive.COL_TYPE_AP]+" as type_ap, "+
                    " r."+DbReceive.colNames[DbReceive.COL_CURRENCY_ID]+" as currency_id, "+
                    " r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" as due_date, "+
                    " r."+DbReceive.colNames[DbReceive.COL_NUMBER]+" as number, "+
                    " r."+DbReceive.colNames[DbReceive.COL_DATE]+" as date, "+
                    " r."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" as app_date, "+
                    " r."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" as invoice_number, "+
                    " r."+DbReceive.colNames[DbReceive.COL_LOCATION_ID]+" as location_id, "+
                    " r."+DbReceive.colNames[DbReceive.COL_NOTE]+" as note "+
                    " from pos_receive r inner join vendor v on r.vendor_id = v.vendor_id where r.status = 'CHECKED' and r.payment_status <> "+I_Project.INV_STATUS_FULL_PAID+" and r.type_ap not in ("+DbReceive.TYPE_AP_REC_ADJ_BY_QTY+","+DbReceive.TYPE_AP_REC_ADJ_BY_PRICE+") ";
            
            if(invSrc.getVendorId()!=0){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+invSrc.getVendorId();
            }
            
            if(invSrc.getOverDue()==0){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" between '"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+" 00:00:00' and '"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+" 23:59:59' ";            
            }
        
            if(invSrc.getVndInvNumber().length()>0){
                sql = sql + " and ( lower(r."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+") like '%"+invSrc.getVndInvNumber().toLowerCase()+"%'"+
                " or lower(r."+DbReceive.colNames[DbReceive.COL_DO_NUMBER]+") like '%"+invSrc.getVndInvNumber().toLowerCase()+"%')";
            }        
                    
            if(invSrc.getInvNumber().length()>0){
                sql = sql + " and lower(r."+DbReceive.colNames[DbReceive.COL_NUMBER]+") like '%"+invSrc.getInvNumber().toLowerCase()+"%' ";
            }
        
            if(invSrc.getStatusOverdue()!=0){
                if(invSrc.getStatusOverdue()==1){
                    sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" < '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+" 23:59:59'"; 
                }else{
                    sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" >= '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+" 00:00:00'"; 
                }
            }
        
            if(invSrc.getLocationId() != null && invSrc.getLocationId().length() >  0){            
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_LOCATION_ID]+" in ("+invSrc.getLocationId()+") ";
            } 
            
            sql = sql + " order by v.name,r."+DbReceive.colNames[DbReceive.COL_DATE]+" desc";
            
            CONResultSet crs = null;
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){                
                    Vendor v = new Vendor();
                    long vendorId = rs.getLong("vendor_id");
                    v.setOID(vendorId);
                    v.setName(rs.getString("vendor_name"));
                    v.setCode(rs.getString("code"));
                    
                    Receive r = new Receive();
                    r.setOID(rs.getLong("receive_id"));
                    r.setPurchaseId(rs.getLong("purchase_id"));
                    r.setTypeAp(rs.getInt("type_ap"));
                    r.setCurrencyId(rs.getLong("currency_id"));                       
                    r.setDueDate(rs.getDate("due_date"));
                    r.setNumber(rs.getString("number"));                    
                    r.setDate(rs.getDate("date"));
                    r.setApproval1Date(rs.getDate("app_date")); 
                    r.setInvoiceNumber(rs.getString("invoice_number"));
                    r.setLocationId(rs.getLong("location_id"));
                    r.setNote(rs.getString("note"));
                    r.setVendorId(vendorId);
                    Vector vx = new Vector();
                    vx.add(v);
                    vx.add(r);
                    result.add(vx);
                }
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }finally{
                CONResultSet.close(crs);
            }
        }catch(Exception e){}
        
        
        return result;        
        
    }
    
    
    public static Vector searchForInvoice(InvoiceSrc invSrc){
        
        Vector result = new Vector();
        
        String sql = "select distinct v.* from "+DbVendor.DB_VENDOR+" v inner join "+DbReceive.DB_RECEIVE+" i "+
            " on i."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" = "+
            " v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID];
        
        sql = sql + " where i."+DbReceive.colNames[DbReceive.COL_STATUS]+"='"+I_Project.DOC_STATUS_CHECKED+"' "+
                " and ( i."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+"<>"+I_Project.INV_STATUS_FULL_PAID +") and i."+DbReceive.colNames[DbReceive.COL_TYPE_AP]+" not in ("+DbReceive.TYPE_AP_REC_ADJ_BY_QTY+","+DbReceive.TYPE_AP_REC_ADJ_BY_PRICE+") ";
        
        if(invSrc.getVendorId()!=0){
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+invSrc.getVendorId();
        }
        
        if(invSrc.getOverDue()==0){
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"='"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+"'";            
        }
        
        if(invSrc.getVndInvNumber().length()>0){
            sql = sql + " and (i."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%'"+
                " or i."+DbReceive.colNames[DbReceive.COL_DO_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%')";
        }
        
        if(invSrc.getInvNumber().length()>0){
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_NUMBER]+" like '%"+invSrc.getInvNumber()+"%' ";
        }
        
        if(invSrc.getStatusOverdue()!=0){
            if(invSrc.getStatusOverdue()==1){
                sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" < '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+"'"; 
            }else{
                sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" >= '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+"'"; 
            }
        }
        
        if(invSrc.getLocationId() != null && invSrc.getLocationId().length() >  0){            
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_LOCATION_ID]+" in ("+invSrc.getLocationId()+") ";
        }
        
        CONResultSet crs = null;
        
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){                
                Vendor v = new Vendor();
                DbVendor.resultToObject(rs, v);                
                Vector openInvoices = getOpenInvoiceByVendor(v.getOID(), invSrc);                
                if(openInvoices!=null && openInvoices.size()>0){
                    Vector vx = new Vector();
                    vx.add(v);
                    vx.add(openInvoices);
                    result.add(vx);
                }
            }
        }
        catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static Vector getOpenInvoiceByVendor(long vendorId, InvoiceSrc invSrc){
        
        Vector result = new Vector();
        
        String sql = "select * from "+DbReceive.DB_RECEIVE+" i "+
            " where i."+DbReceive.colNames[DbReceive.COL_STATUS]+"='"+I_Project.DOC_STATUS_CHECKED+"' "+
            " and ( i."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+"<>"+I_Project.INV_STATUS_FULL_PAID +") and i."+DbReceive.colNames[DbReceive.COL_TYPE_AP]+" not in ("+DbReceive.TYPE_AP_REC_ADJ_BY_QTY+","+DbReceive.TYPE_AP_REC_ADJ_BY_PRICE+") ";
        
        if(vendorId!=0){
            sql = sql +" and i."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+vendorId;
        }
        
        if(invSrc.getOverDue()==0){
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"='"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+"'";            
        }
        
        if(invSrc.getVndInvNumber().length()>0){
            sql = sql + " and (i."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%'"+
                " or i."+DbReceive.colNames[DbReceive.COL_DO_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%')";            
        }
        
        if(invSrc.getInvNumber().length()>0){
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_NUMBER]+" like '%"+invSrc.getInvNumber()+"%' ";
        }
        
        if(invSrc.getStatusOverdue()!=0){
            if(invSrc.getStatusOverdue()==1){
                sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" < '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+"'"; 
            }else{
                sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" >= '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+"'"; 
            }
        }
        
        if(invSrc.getLocationId() != null && invSrc.getLocationId().length() >  0){            
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_LOCATION_ID]+" in ("+invSrc.getLocationId()+") ";
        }
        
        sql = sql + " order by i."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+",i."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" desc ";
        
        CONResultSet crs = null;
        
        try{
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                
                Purchase purc = new Purchase();                
                try{
                    purc = DbPurchase.fetchExc(purc.getOID());
                }catch(Exception e){}
                
                Receive i = new Receive();
                DbReceive.resultToObject(rs, i);
                Vector vx = new Vector();                
                vx.add(purc);
                vx.add(i);
                
                result.add(vx);
            }
        }
        catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }    
    
    
    public static Purchase getPurchase(long purchaseId){
        Purchase purchase = new Purchase();
        CONResultSet crs = null;
        
        try{
            
            String sql = "select "+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+","
                    +DbPurchase.colNames[DbPurchase.COL_NUMBER]+","
                    +DbPurchase.colNames[DbPurchase.COL_PURCH_DATE]+" from "
                    +DbPurchase.DB_PURCHASE+" where "+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+" = "+purchaseId;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                try{
                    purchase.setOID(rs.getLong(DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]));
                    purchase.setNumber(rs.getString(DbPurchase.colNames[DbPurchase.COL_NUMBER]));
                    Date tm = CONHandler.convertDate(rs.getDate(DbPurchase.colNames[DbPurchase.COL_PURCH_DATE]), rs.getTime(DbPurchase.colNames[DbPurchase.COL_PURCH_DATE]));                    
                    purchase.setPurchDate(tm);
                }catch(Exception e){}        
            }
            
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return purchase;        
    }
    
    
    public static Vector getListIncoming(int limitStart,int recordToGet,String nomorDocument,long srcVendorId,int ignore, Date startDate,Date endDate){
        CONResultSet crs = null;
        Vector result = new Vector();
        try{
            
            String sql = "select r.receive_id as receive_id,r.vendor_id as vendor_id,r.number as number,r.date as date,r.location_id as location_id,r.status as status,r.note as note," +
                    "sum(ri.total_amount) as amount,"+
                    "truncate((sum(ri.total_amount) * r.discount_percent)/100,2) as discount,"+                    
                    "truncate((sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100))*r.tax_percent/100,2) as tax,"+
                    "truncate(sum(ri.total_amount)  - ((sum(ri.total_amount) * r.discount_percent)/100) + ((sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100))*r.tax_percent/100),2) as total from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id ";
            
            sql = sql + " where r."+DbReceive.colNames[DbReceive.COL_TYPE_AP] + " in (" + DbReceive.TYPE_AP_NO + "," + DbReceive.TYPE_AP_REC_ADJ_BY_PRICE + "," + DbReceive.TYPE_AP_REC_ADJ_BY_QTY + ") and r." + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + I_Project.DOC_STATUS_APPROVED + "' ";
            
            if (nomorDocument != null && nomorDocument.length() > 0) {                
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + nomorDocument + "%' ";
            }

            if (srcVendorId != 0) {                
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + srcVendorId;
            }

            if (ignore == 0 ) {
                sql = sql+" and r." + DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00' and " +
                            " '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59' ";
            }
            
            sql = sql + " group by r.receive_id ";
                        
            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                try{
                    Receive receive = new Receive();
                    receive.setOID(rs.getLong("receive_id"));
                    receive.setNumber(rs.getString("number"));
                    receive.setDate(rs.getDate("date"));
                    receive.setLocationId(rs.getLong("location_id"));
                    receive.setNote(rs.getString("note"));
                    receive.setStatus(rs.getString("status"));
                    receive.setTotalAmount(rs.getDouble("total"));
                    receive.setVendorId(rs.getLong("vendor_id"));
                    result.add(receive);                    
                }catch(Exception e){}        
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return result;
    }
    
    public static Receive getIncoming(long receiveId){
        CONResultSet crs = null;
        Receive receive = new Receive();
        try{
            
            String sql = "select r.receive_id as receive_id,r.vendor_id as vendor_id,r.number as number,r.date as date,r.location_id as location_id,r.status as status,r.note as note,r.unit_usaha_id as unit_usaha_id," +
                    " r."+DbReceive.colNames[DbReceive.COL_TOTAL_TAX]+" as tmp_tax,"+
                    " r."+DbReceive.colNames[DbReceive.COL_DISCOUNT_TOTAL]+" as tmp_discount,"+
                    " sum(ri.total_amount) as amount,"+
                    
                    " truncate((sum(ri.total_amount) * r.discount_percent)/100,2) as discount,"+                    
                    " truncate((sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100))*r.tax_percent/100,2) as tax, "+
                    " truncate(sum(ri.total_amount)  - ((sum(ri.total_amount) * r.discount_percent)/100) + ((sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100))*r.tax_percent/100),2) as grand_total "+
                    " from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id ";
            
            sql = sql + " where r."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID] + " = " + receiveId+" group by r."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID];
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                try{                    
                    receive.setOID(rs.getLong("receive_id"));
                    String number = rs.getString("number");
                    receive.setNumber(number);
                    receive.setDate(rs.getDate("date"));
                    receive.setLocationId(rs.getLong("location_id"));
                    receive.setNote(rs.getString("note"));
                    receive.setStatus(rs.getString("status"));
                    receive.setVendorId(rs.getLong("vendor_id"));       
                    receive.setTotalAmount(rs.getDouble("amount"));                    
                    
                    long unitUsahaId = rs.getLong("unit_usaha_id");
                    double tmpTax = rs.getDouble("tmp_tax");
                    double tmpDiscount = rs.getDouble("tmp_discount");
                    
                    double tax = rs.getDouble("tax");
                    double discount = rs.getDouble("discount");
                    
                    if(unitUsahaId==1){                        
                        receive.setDiscountTotal(tmpDiscount);
                        receive.setTotalTax(tmpTax);
                    }else{                        
                        receive.setDiscountTotal(discount);
                        receive.setTotalTax(tax);
                    }
                               
                }catch(Exception e){}        
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return receive;
    }
    
    
    
    public static double getTotal(int type,long receiveId){
        double total = 0;
        try{
            if(type == 2){
                total = getTotalRetur(receiveId);
            }else{
                Receive r = getIncoming(receiveId);
                total = r.getTotalAmount() + r.getTotalTax() - r.getDiscountTotal();                
            }
        }catch(Exception e){}
        return total;
    }
    
    public static double getTotalRetur(long receiveId){
        CONResultSet crs = null;
        double total = 0;
        try{
            String sql = "select sum(ri.total_amount) - r.discount_total + r.total_tax as total "+
                         " from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id "+
                         "where r.receive_id = "+receiveId;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                try{                    
                    total = rs.getDouble("total");
                }catch(Exception e){}        
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return total;
        
    }
    
    public static double getIncomingByReference(long referenceId){
        CONResultSet crs = null;        
        double result = 0;
        try{
            
            String sql = "select r.receive_id as receive_id,r.vendor_id as vendor_id,r.number as number,r.date as date,r.location_id as location_id,r.status as status,r.note as note,r.unit_usaha_id as unit_usaha_id," +
                    " r."+DbReceive.colNames[DbReceive.COL_TOTAL_TAX]+" as tmp_tax,"+
                    " r."+DbReceive.colNames[DbReceive.COL_DISCOUNT_TOTAL]+" as tmp_discount,"+
                    " sum(ri.total_amount) as amount,"+
                    " truncate((sum(ri.total_amount) * r.discount_percent)/100,2) as discount,"+                    
                    " truncate((sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100))*r.tax_percent/100,2) as tax, "+
                    " truncate(sum(ri.total_amount)  - ((sum(ri.total_amount) * r.discount_percent)/100) + ((sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100))*r.tax_percent/100),2) as grand_total "+
                    " from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id ";
            
            sql = sql + " where r."+DbReceive.colNames[DbReceive.COL_REFERENCE_ID] + " = " + referenceId+" and r."+DbReceive.colNames[DbReceive.COL_STATUS]+" = '"+I_Project.DOC_STATUS_CHECKED+"' group by r."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID];
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                try{ 
                    double totalAmount = rs.getDouble("amount"); 
                    long unitUsahaId = rs.getLong("unit_usaha_id");
                    double tmpTax = rs.getDouble("tmp_tax");
                    double tmpDiscount = rs.getDouble("tmp_discount");
                    
                    double tax = rs.getDouble("tax");
                    double discount = rs.getDouble("discount");
                    double tmpResult = 0;
                    if(unitUsahaId==1){                                               
                        tmpResult = totalAmount + tmpTax - tmpDiscount;
                    }else{                        
                        tmpResult = totalAmount + tax - discount;
                    }
                    
                    result = result + tmpResult;
                }catch(Exception e){}        
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return result;
    }
    
    /*public static double getTotalIncoming(long receiveId){
        CONResultSet crs = null;
        double total = 0;
        try{            
            String sql =    "select sum(total) as total from ( "+
                            "select 0 as idx, "+
                            "truncate(sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100) + ((sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100))*r.tax_percent/100),2) as total "+
                            "from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.receive_id = "+receiveId+" union "+
                            "select 1 as idx, "+
                            "truncate(sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100) + ((sum(ri.total_amount) - ((sum(ri.total_amount) * r.discount_percent)/100))*r.tax_percent/100),2) as total "+
                            "from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.reference_id = "+receiveId+" and r."+DbReceive.colNames[DbReceive.COL_STATUS]+" = '"+I_Project.DOC_STATUS_CHECKED+"' ) as datax ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                try{                    
                    total = rs.getDouble("total");
                }catch(Exception e){}        
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return total;
    }
    
    public static double getIncomingByReference(long referenceId){
        CONResultSet crs = null;        
        double result = 0;
        try{
            
            String sql = "select r.receive_id as receive_id,r.vendor_id as vendor_id,r.number as number,r.date as date,r.location_id as location_id,r.status as status,r.note as note,sum((ri.qty*ri.amount)-ri.discount_amount) as amount,"+
                    "round((sum((ri.qty*ri.amount)-ri.discount_amount)* r.discount_percent)/100,2) as discount,"+
                    "round(sum((ri.qty*ri.amount)-ri.discount_amount) - round((sum((ri.qty*ri.amount)-ri.discount_amount)* r.discount_percent)/100,2),2) as sub_total,"+
                    "round(( round(sum((ri.qty*ri.amount)-ri.discount_amount) - round((sum((ri.qty*ri.amount)-ri.discount_amount)* r.discount_percent)/100,2),2) ) * r.tax_percent/100,2) as tax,"+
                    "round(sum((ri.qty*ri.amount)-ri.discount_amount) - round((sum((ri.qty*ri.amount)-ri.discount_amount)* r.discount_percent)/100,2),2) + round(( round(sum((ri.qty*ri.amount)-ri.discount_amount) - round((sum((ri.qty*ri.amount)-ri.discount_amount)* r.discount_percent)/100,2),2) )  * r.tax_percent/100,2) as total from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id ";
            
            sql = sql + " where r."+DbReceive.colNames[DbReceive.COL_REFERENCE_ID] + " = " + referenceId+" and r."+DbReceive.colNames[DbReceive.COL_STATUS]+" = '"+I_Project.DOC_STATUS_CHECKED+"' group by r."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID];
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                try{                   
                    double subTotal = rs.getDouble("amount");
                    double discTotal = rs.getDouble("discount");
                    double tax = rs.getDouble("tax");
                    result = result + (subTotal - discTotal + tax);
                }catch(Exception e){}        
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return result;
    }*/
    
    
    public static int getCountIncoming(String nomorDocument,long srcVendorId,int ignore, Date startDate,Date endDate){
        CONResultSet crs = null;        
        int total = 0;
        try{
            
            String sql = "select count(*) as total from ( select r.receive_id as total from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id ";
            
            sql = sql + " where r."+DbReceive.colNames[DbReceive.COL_TYPE_AP] + " in (" + DbReceive.TYPE_AP_NO + "," + DbReceive.TYPE_AP_REC_ADJ_BY_PRICE + "," + DbReceive.TYPE_AP_REC_ADJ_BY_QTY + ") and r." + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + I_Project.DOC_STATUS_APPROVED + "' ";
            
            if (nomorDocument != null && nomorDocument.length() > 0) {                
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + nomorDocument + "%' ";
            }

            if (srcVendorId != 0) {                
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + srcVendorId;
            }

            if (ignore == 0 ) {
                sql = sql+" and r." + DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00' and " +
                            " '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59' ";
            }
            
            sql = sql + " group by r.receive_id ) as x ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                try{
                    total = rs.getInt("total");
                }catch(Exception e){}        
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return total;
    }
    
    
    
    //Edited
    public static Vector getOpenInvoiceByVendorPendingPO(long vendorId, InvoiceSrc invSrc){
        
        Vector result = new Vector();
        
        String where = "";
        
                if(vendorId != 0){                    
                    where = where +" and pr."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+vendorId;
                }
        
                if(invSrc.getOverDue()==0){                    
                    where = where + " and pr."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"='"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+"'";            
                }
        
                if(invSrc.getVndInvNumber().length()>0){                    
                    where = where + " and (pr."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%'"+
                        " or pr."+DbReceive.colNames[DbReceive.COL_DO_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%')";            
                }
                
                String sql = "select ppid,recid,appdate,invnumber,duedate,app1date,currid,vend,dt,lc from ("+                        
                    " select pr."+DbReceive.colNames[DbReceive.COL_LOCATION_ID]+" as lc,pr."+DbReceive.colNames[DbReceive.COL_DATE]+" as dt,pr."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" as vend, pr."+DbReceive.colNames[DbReceive.COL_CURRENCY_ID]+" currid, pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" as app1date,pr."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" as duedate, pr."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" as invnumber,pp."+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+" as ppid, pr."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" as recid,pp."+DbPurchase.colNames[DbPurchase.COL_APPROVAL_2_DATE]+" as appdate from "+DbReceive.DB_RECEIVE+" pr inner join "+DbPurchase.DB_PURCHASE+" pp on pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" = pp."+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+" where pr."+DbReceive.colNames[DbReceive.COL_STATUS]+" = 'CHECKED' and pr."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" != 2 and pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" != 0 and pp."+DbPurchase.colNames[DbPurchase.COL_APPROVAL_2_DATE]+" is not null "+where+" union "+
                    " select pr."+DbReceive.colNames[DbReceive.COL_LOCATION_ID]+" as lc,pr."+DbReceive.colNames[DbReceive.COL_DATE]+" as dt,pr."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" as vend ,pr."+DbReceive.colNames[DbReceive.COL_CURRENCY_ID]+" currid, pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" as app1date,pr."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" as duedate, pr."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" as invnumber,0 as ppid,pr."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" as recid,pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" as appdate from "+DbReceive.DB_RECEIVE+" pr where pr."+DbReceive.colNames[DbReceive.COL_STATUS]+" = 'CHECKED' and pr."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" != 2 and pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" = 0 and pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" is not null "+where+") as r order by vend,appdate desc";
     
        CONResultSet crs = null;
        
        try{
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                
                Purchase purc = new Purchase();                
                Receive i = new Receive();
                i.setPurchaseId(rs.getLong("ppid"));
                i.setOID(rs.getLong("recid"));
                i.setInvoiceNumber(rs.getString("invnumber"));
                i.setDueDate(rs.getDate("duedate"));
                i.setApproval1Date(rs.getDate("app1date"));
                i.setCurrencyId(rs.getLong("currid"));
                i.setVendorId(rs.getLong("vend"));
                i.setDate(rs.getDate("dt"));
                i.setLocationId(rs.getLong("lc"));
                
                Vector vx = new Vector();                
                vx.add(purc);
                vx.add(i);
                
                result.add(vx);
            }
        }
        catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }    
    
    
    public static Vector getOpenInvoiceByParameter(long vendorId, InvoiceSrc invSrc,BankpoPayment bpp){
        
        Vector result = new Vector();        
        Vector vBppd = DbBankpoPaymentDetail.list(0, 0, DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = "+bpp.getOID(), null);
        
        String whereOR = "";
        if(vBppd != null && vBppd.size() > 0){
            
            for(int ib = 0;ib < vBppd.size(); ib++){
                
                BankpoPaymentDetail bpd = (BankpoPaymentDetail)vBppd.get(ib);
                if(bpd.getInvoiceId() != 0){
                    if(whereOR.length() > 0){
                        whereOR = whereOR + " and ";
                    }                    
                    whereOR = whereOR + DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" != "+bpd.getInvoiceId();
                }
            }
        }
        
        String sql = "select * from "+DbReceive.DB_RECEIVE+" i "+
            " where i."+DbReceive.colNames[DbReceive.COL_STATUS]+"='"+I_Project.DOC_STATUS_CHECKED+"' "+
            " and ( i."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+"<>"+I_Project.INV_STATUS_FULL_PAID+" ) and i."+DbReceive.colNames[DbReceive.COL_TYPE_AP]+
            " not in ("+DbReceive.TYPE_AP_REC_ADJ_BY_QTY+","+DbReceive.TYPE_AP_REC_ADJ_BY_PRICE+") ";
            
        if(whereOR.length() > 0){
            sql = sql + " and ( "+whereOR+" ) ";
        }
        
        if(vendorId!=0){
            sql = sql +" and i."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+vendorId;
        }
        
        if(invSrc.getOverDue()==0){
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"='"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+"'";            
        }
        
        if(invSrc.getVndInvNumber().length()>0){
            sql = sql + " and (i."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%'"+
                " or i."+DbReceive.colNames[DbReceive.COL_DO_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%')";            
        }
        
        if(invSrc.getStatusOverdue()!=0){
            if(invSrc.getStatusOverdue()==1){
                sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" < '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+"'"; 
            }else{
                sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" >= '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+"'"; 
            }
        }
        
        if(invSrc.getLocationId() != null && invSrc.getLocationId().length() >  0){            
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_LOCATION_ID]+" in ("+invSrc.getLocationId()+") ";
        }
        
        sql = sql + " order by i."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+","+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" desc ";
        
        CONResultSet crs = null;
        
        try{
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                
                Purchase purc = new Purchase();
                
                try{
                    purc = DbPurchase.fetchExc(purc.getOID());
                }catch(Exception e){
                    System.out.println("[exception] "+e.toString());
                }
                
                Receive i = new Receive();
                DbReceive.resultToObject(rs, i);
                Vector vx = new Vector();
                vx.add(purc);
                vx.add(i);
                result.add(vx);
            }
        }
        catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static Vector getOpenInvoiceByParameterPendingPO(long vendorId, InvoiceSrc invSrc,BankpoPayment bpp){
        
        Vector result = new Vector();        
        Vector vBppd = DbBankpoPaymentDetail.list(0, 0, DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = "+bpp.getOID(), null);
        
        String whereOR = "";
        if(vBppd != null && vBppd.size() > 0){
            
            for(int ib = 0;ib < vBppd.size(); ib++){
                
                BankpoPaymentDetail bpd = (BankpoPaymentDetail)vBppd.get(ib);
                if(bpd.getInvoiceId() != 0){
                    if(whereOR.length() > 0){
                        whereOR = whereOR + " and ";
                    }                    
                    whereOR = whereOR + DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" != "+bpd.getInvoiceId();
                }
            }
        }
            
        if(whereOR.length() > 0){
            whereOR = " and ( "+whereOR+" ) ";
        }   
        
        String where = "";
        
                if(vendorId != 0){                    
                    where = where +" and pr."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+vendorId;
                }
        
                if(invSrc.getOverDue()==0){                    
                    where = where + " and pr."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"='"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+"'";            
                }
        
                if(invSrc.getVndInvNumber().length()>0){                    
                    where = where + " and (pr."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%'"+
                        " or pr."+DbReceive.colNames[DbReceive.COL_DO_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%')";            
                }
                
                String sql = "select ppid,recid,appdate,invnumber,duedate,app1date,currid,vend,dt from ("+                        
                    " select pr."+DbReceive.colNames[DbReceive.COL_DATE]+" as dt,pr."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" as vend, pr."+DbReceive.colNames[DbReceive.COL_CURRENCY_ID]+" currid, pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" as app1date,pr."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" as duedate, pr."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" as invnumber,pp."+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+" as ppid, pr."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" as recid,pp."+DbPurchase.colNames[DbPurchase.COL_APPROVAL_2_DATE]+" as appdate from "+DbReceive.DB_RECEIVE+" pr inner join "+DbPurchase.DB_PURCHASE+" pp on pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" = pp."+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+" where pr."+DbReceive.colNames[DbReceive.COL_STATUS]+" = 'CHECKED' "+whereOR+" and pr."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" != 2 and pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" != 0 and pp."+DbPurchase.colNames[DbPurchase.COL_APPROVAL_2_DATE]+" is not null "+where+" union "+
                    " select pr."+DbReceive.colNames[DbReceive.COL_DATE]+" as dt,pr."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" as vend ,pr."+DbReceive.colNames[DbReceive.COL_CURRENCY_ID]+" currid, pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" as app1date,pr."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+" as duedate, pr."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" as invnumber,0 as ppid,pr."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" as recid,pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" as appdate from "+DbReceive.DB_RECEIVE+" pr where pr."+DbReceive.colNames[DbReceive.COL_STATUS]+" = 'CHECKED' "+whereOR+" and pr."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" != 2 and pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" = 0 and pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" is not null "+where+") as r order by vend,appdate desc";
     
        
        
        CONResultSet crs = null;
        
        try{
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                
                Purchase purc = new Purchase();
                Receive i = new Receive();
                i.setPurchaseId(rs.getLong("ppid"));
                i.setOID(rs.getLong("recid"));
                i.setInvoiceNumber(rs.getString("invnumber"));
                i.setDueDate(rs.getDate("duedate"));
                i.setApproval1Date(rs.getDate("app1date"));
                i.setCurrencyId(rs.getLong("currid"));
                i.setVendorId(rs.getLong("vend"));
                i.setDate(rs.getDate("dt"));                
                
                Vector vx = new Vector();
                vx.add(purc);
                vx.add(i);
                result.add(vx);
            }
        }
        catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    
    public static Vector getOpenInvoiceByVendor(long vendorId, InvoiceSrc invSrc,BankpoPayment bpp){
        
        Vector result = new Vector();        
        Vector vBppd = DbBankpoPaymentDetail.list(0, 0, DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = "+bpp.getOID(), null);
        
        String whereOR = "";
        if(vBppd != null && vBppd.size() > 0){
            
            for(int ib = 0;ib < vBppd.size(); ib++){
                
                BankpoPaymentDetail bpd = (BankpoPaymentDetail)vBppd.get(ib);
                if(bpd.getInvoiceId() != 0){
                    if(whereOR.length() > 0){
                        whereOR = whereOR + " or ";
                    }                    
                    whereOR = whereOR + DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = "+bpd.getInvoiceId();
                }
            }
        }
        
        String sql = "select * from "+DbReceive.DB_RECEIVE+" i "+
            " where i."+DbReceive.colNames[DbReceive.COL_STATUS]+"='"+I_Project.DOC_STATUS_CHECKED+"' "+
            " and ( i."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+"<>"+I_Project.INV_STATUS_FULL_PAID; 
            
        if(whereOR.length() > 0){
            sql = sql + " or "+whereOR;
        }
            
        sql = sql +" ) ";
        
        if(vendorId!=0){
            sql = sql +" and i."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+vendorId;
        }
        
        if(invSrc.getOverDue()==1){
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"<='"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+"'";            
        }
        else{
            sql = sql + " and i."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"='"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+"'";            
        }
        
        if(invSrc.getVndInvNumber().length()>0){
            sql = sql + " and (i."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%'"+
                " or i."+DbReceive.colNames[DbReceive.COL_DO_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%')";            
        }
        
        sql = sql + " order by i."+DbReceive.colNames[DbReceive.COL_VENDOR_ID];
        
        CONResultSet crs = null;
        
        try{
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                
                Purchase purc = new Purchase();
                
                try{
                    purc = DbPurchase.fetchExc(purc.getOID());
                }catch(Exception e){
                    System.out.println("[exception] "+e.toString());
                }
                
                Receive i = new Receive();
                DbReceive.resultToObject(rs, i);
                Vector vx = new Vector();
                vx.add(purc);
                vx.add(i);
                result.add(vx);
            }
        }
        catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;        
    }
    
    public static ItemMaster getItem(long itemId){
        
        ItemMaster im = new ItemMaster();
        CONResultSet crs = null;
        try{
            String sql = "select "+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as item_id, "+
                            DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" as item_group_id,"+
                            DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                            DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as cogs,"+
                            DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as code,"+
                            DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as name from "+DbItemMaster.DB_ITEM_MASTER+
                            " where "+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = "+itemId;
                            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();               
            while(rs.next()){
                im.setOID(rs.getLong("item_id"));
                im.setItemGroupId(rs.getLong("item_group_id"));
                im.setNeedRecipe(rs.getInt("need_recipe"));
                im.setCogs(rs.getDouble("cogs"));
                im.setCode(rs.getString("code"));
                im.setName(rs.getString("name"));
            }                
                        
                    
        }catch(Exception e){
        }finally{
            CONResultSet.close(crs);
        }
        return im;
    }
    
    public static ItemGroup getGroup(long groupId){
        
        ItemGroup ig = new ItemGroup();
        CONResultSet crs = null;
        try{
            String sql = "select "+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as item_group_id, "+
                            DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv, "+
                            DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_EXPENSE_JASA]+" as acc_jasa,"+
                            DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_BONUS_INCOME]+" as acc_bonus, "+
                            DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as name from "+DbItemGroup.DB_ITEM_GROUP+
                            " where "+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = "+groupId;
                            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();               
            while(rs.next()){
                ig.setOID(rs.getLong("item_group_id"));                
                ig.setAccountInv(rs.getString("acc_inv"));
                ig.setAccountExpenseJasa(rs.getString("acc_jasa"));
                ig.setAccountBonusIncome(rs.getString("acc_bonus"));
                ig.setName(rs.getString("name"));
            }                                        
                    
        }catch(Exception e){
        }finally{
            CONResultSet.close(crs);
        }
        return ig;
    }
    
}
