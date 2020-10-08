/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.session;


import com.project.crm.report.Arsip;
import com.project.crm.transaction.DbPembayaran;
import com.project.general.DbCustomer;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Roy Andika
 */
public class SessPembayaran {
    
    public static int TYPE_AIR_LIMBAH = 0;
    public static int TYPE_IRIGASI    = 1;
    
    /**
     * @Author  Roy Andika
     * @param   typePembayaran : 0 = Limbah, 1 = Irigasi
     * @return
     */
    public static Vector listArsipPembayaran(int typePembayaran,String noInvoice,String noPembayaran,
            long customerId,boolean all_date,Date tglMulai,Date tglSelesai,int limitStart,int recordToGet, String order){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "";
            
            if(typePembayaran == DbPembayaran.PAYMENT_SOURCE_IRIGASI){ // Jika type Irigasi
                
                sql = "SELECT pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID]+" as pembayaranId,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TYPE]+" as type,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]+" as noBkm,"+                        
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_KWITANSI]+" as kwitansi,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_INVOICE]+" as invoice,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" as tanggal,"+                        
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" as trans_source,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+" as jumlah,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID]+" as limbahId,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID]+" as irigasiId,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_MATA_UANG_ID]+" as mata_uang,"+                         
                        "customer."+DbCustomer.colNames[DbCustomer.COL_NAME]+" as customer "+ 
                        " FROM "+DbPembayaran.DB_CRM_PEMBAYARAN+" pembayaran INNER JOIN "+
                        DbCustomer.DB_CUSTOMER+" customer on pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = "+
                        "customer."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                        " WHERE pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" = "+DbPembayaran.PAYMENT_SOURCE_IRIGASI;
                
            }else{ // Jika type Limbah
                
                sql = "SELECT pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID]+" as pembayaranId,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TYPE]+" as type,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]+" as noBkm,"+                        
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_KWITANSI]+" as kwitansi,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_INVOICE]+" as invoice,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" as tanggal, "+    
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" as trans_source,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+" as jumlah,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID]+" as limbahId,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID]+" as irigasiId,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_MATA_UANG_ID]+" as mata_uang,"+                         
                        "customer."+DbCustomer.colNames[DbCustomer.COL_NAME]+" as customer "+
                        " FROM "+DbPembayaran.DB_CRM_PEMBAYARAN+" pembayaran INNER JOIN "+
                        DbCustomer.DB_CUSTOMER+" customer on pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = "+
                        "customer."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                        " WHERE pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" = "+DbPembayaran.PAYMENT_SOURCE_LIMBAH;                
            }
            
            if(noInvoice != null && noInvoice.length() > 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_INVOICE]+" like '%"+noInvoice+"%' ";
            }
            
            if(noPembayaran != null && noPembayaran.length() > 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]+" like '%"+noPembayaran+"%' ";
            }
            
            if(customerId != 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = '"+customerId+"' ";
            }
            
            if(all_date == false){
                sql = sql + " AND ( pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" BETWEEN '"+
                        JSPFormater.formatDate(tglMulai,"yyyy-MM-dd")+"' AND '"+JSPFormater.formatDate(tglSelesai,"yyyy-MM-dd")+"' )";
            }
            
            if (limitStart == 0 && recordToGet == 0)
                sql = sql + "";
            else
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            Vector result = new Vector();
            
            while(rs.next()){
                
                Arsip arsip = new Arsip();
                arsip.setPembayaranId(rs.getLong("pembayaranId"));
                arsip.setTypePembayaran(rs.getInt("type"));
                arsip.setNoPembayaran(rs.getString("noBkm"));  
                arsip.setKwitansi(rs.getString("kwitansi"));
                arsip.setNoInvoice(rs.getString("invoice"));
                arsip.setTanggal(rs.getDate("tanggal"));
                arsip.setCustomer(rs.getString("customer"));
                arsip.setTransaction_source(rs.getInt("trans_source"));
                arsip.setMataUangId(rs.getLong("mata_uang"));
                arsip.setJumlahPembayaran(rs.getDouble("jumlah"));
                arsip.setIrigasiId(rs.getLong("irigasiId"));
                arsip.setLimbahId(rs.getLong("limbahId"));
                result.add(arsip);
                
            }
            
            return result;
            
        }catch(Exception E){
            System.out.println("[exception] "+E.toString());
        }
        
        return null;
    }
    
    
    public static Vector listArsipPembayaran(int typePembayaran,String noInvoice,String noPembayaran,
            long customerId,boolean all_date,Date tglMulai,Date tglSelesai){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "";
            
            if(typePembayaran == DbPembayaran.PAYMENT_SOURCE_IRIGASI){ // Jika type Irigasi
                
                sql = "SELECT pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID]+" as pembayaranId,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TYPE]+" as type,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]+" as noBkm,"+                        
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_KWITANSI]+" as kwitansi,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_INVOICE]+" as invoice,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" as tanggal,"+   
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" as trans_source,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+" as jumlah,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID]+" as limbahId,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID]+" as irigasiId,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_MATA_UANG_ID]+" as mata_uang,"+                         
                        "customer."+DbCustomer.colNames[DbCustomer.COL_NAME]+" as customer "+ 
                        " FROM "+DbPembayaran.DB_CRM_PEMBAYARAN+" pembayaran INNER JOIN "+
                        DbCustomer.DB_CUSTOMER+" customer on pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = "+
                        "customer."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                        " WHERE pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" = "+DbPembayaran.PAYMENT_SOURCE_IRIGASI;
                
            }else{ // Jika type Limbah
                
                sql = "SELECT pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID]+" as pembayaranId,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TYPE]+" as type,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]+" as noBkm,"+                        
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_KWITANSI]+" as kwitansi,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_INVOICE]+" as invoice,"+
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" as tanggal, "+     
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" as trans_source,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+" as jumlah,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID]+" as limbahId,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID]+" as irigasiId,"+ 
                        "pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_MATA_UANG_ID]+" as mata_uang,"+                         
                        "customer."+DbCustomer.colNames[DbCustomer.COL_NAME]+" as customer "+
                        " FROM "+DbPembayaran.DB_CRM_PEMBAYARAN+" pembayaran INNER JOIN "+
                        DbCustomer.DB_CUSTOMER+" customer on pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = "+
                        "customer."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                        " WHERE pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" = "+DbPembayaran.PAYMENT_SOURCE_LIMBAH;                
            }
            
            if(noInvoice != null && noInvoice.length() > 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_INVOICE]+" = '"+noInvoice+"' ";
            }
            
            if(noPembayaran != null && noPembayaran.length() > 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]+" = '"+noPembayaran+"' ";
            }
            
            if(customerId != 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = '"+customerId+"' ";
            }
            
            if(all_date == false){
                sql = sql + " AND ( pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" BETWEEN '"+
                        JSPFormater.formatDate(tglMulai,"yyyy-MM-dd")+"' AND '"+JSPFormater.formatDate(tglSelesai,"yyyy-MM-dd")+"' )";
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            Vector result = new Vector();
            
            while(rs.next()){
                
                Arsip arsip = new Arsip();
                arsip.setPembayaranId(rs.getLong("pembayaranId"));
                arsip.setTypePembayaran(rs.getInt("type"));
                arsip.setNoPembayaran(rs.getString("noBkm"));  
                arsip.setKwitansi(rs.getString("kwitansi"));
                arsip.setNoInvoice(rs.getString("invoice"));
                arsip.setTanggal(rs.getDate("tanggal"));
                arsip.setCustomer(rs.getString("customer"));
                arsip.setTransaction_source(rs.getInt("trans_source"));            
                arsip.setMataUangId(rs.getLong("mata_uang"));
                arsip.setJumlahPembayaran(rs.getDouble("jumlah"));
                arsip.setIrigasiId(rs.getLong("irigasiId"));
                arsip.setLimbahId(rs.getLong("limbahId"));
                result.add(arsip);
                
            }
            
            return result;
            
        }catch(Exception E){
            System.out.println("[exception] "+E.toString());
        }
        
        return null;
    }
    
    
    public static int countListArsipPembayaran(int typePembayaran,String noInvoice,String noPembayaran,
            long customerId,boolean all_date,Date tglMulai,Date tglSelesai){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "";
            
            if(typePembayaran == DbPembayaran.PAYMENT_SOURCE_IRIGASI){ // Jika type Irigasi
                
                sql = "SELECT COUNT(pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID]+") "+
                        " FROM "+DbPembayaran.DB_CRM_PEMBAYARAN+" pembayaran INNER JOIN "+
                        DbCustomer.DB_CUSTOMER+" customer on pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = "+
                        "customer."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                        " WHERE pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" = "+DbPembayaran.PAYMENT_SOURCE_IRIGASI;
                
            }else{ // Jika type Limbah
                
                sql = "SELECT COUNT(pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID]+") "+                        
                        " FROM "+DbPembayaran.DB_CRM_PEMBAYARAN+" pembayaran INNER JOIN "+
                        DbCustomer.DB_CUSTOMER+" customer on pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = "+
                        "customer."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                        " WHERE pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]+" = "+DbPembayaran.PAYMENT_SOURCE_LIMBAH;                
                
            }
            
            if(noInvoice != null && noInvoice.length() > 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_INVOICE]+" = '"+noInvoice+"' ";
            }
            
            if(noPembayaran != null && noPembayaran.length() > 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]+" = '"+noPembayaran+"' ";
            }
            
            if(customerId != 0){
                sql = sql + " AND pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]+" = '"+customerId+"' ";
            }
            
            if(all_date == false){
                sql = sql + " AND ( pembayaran."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" BETWEEN '"+
                        JSPFormater.formatDate(tglMulai,"yyyy-MM-dd")+"' AND '"+JSPFormater.formatDate(tglSelesai,"yyyy-MM-dd")+"' )";
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()){
                return rs.getInt(1);
            }
            
        }catch(Exception E){
            System.out.println("[exception] "+E.toString());
        }
        
        return 0;
    }

}
