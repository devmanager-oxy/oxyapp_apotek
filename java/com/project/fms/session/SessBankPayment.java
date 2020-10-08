/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.fms.activity.*;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.DbBankpoGroupDetail;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;
import com.project.util.JSPFormater;
/**
 *
 * @author Roy
 */

public class SessBankPayment {

    public static double getPaymentBankPo(long bankpoPaymentId) {
        double result = 0;
        CONResultSet crs = null;        
        try {
            
            String sql = "select sum("+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT]+") from "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" where "+
                        DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = "+bankpoPaymentId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
    
    public static Vector getBankpoList(int limitStart, int recordToGet,long vendorId,
            String jurnalNumber,int ignoreDate,Date tglBuatStart,Date tglBuatEnd,
            long periodId,int ignoreTransDate,Date transDate,String strGrp){
        Vector result = new Vector();
        CONResultSet crs = null;  
        try{
            
            String whereClause = " b."+DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS] + " in ('" + DbBankpoPayment.STATUS_POSTED + "','" + DbBankpoPayment.STATUS_PARTIALY_PAID + "') and b."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS] + "= 1 and b." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA;
            
             if (ignoreDate == 0) {                
                whereClause = whereClause + " and b." +DbBankpoPayment.colNames[DbBankpoPayment.COL_DATE] + " between '" + JSPFormater.formatDate(tglBuatStart, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tglBuatEnd, "yyyy-MM-dd") + " 23:59:59'";
            }
            
            if (ignoreTransDate == 0) {
                whereClause = whereClause + " and b." +DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + " 00:00:00' and '"+ JSPFormater.formatDate(transDate, "yyyy-MM-dd") + " 23:59:59'";
            }

            if (jurnalNumber.length() > 0) {                
                whereClause = whereClause + " and b." +DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + jurnalNumber + "%' ";
            }

            if (periodId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }                
                whereClause = whereClause + " and b."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + " 23:59:59' ";
            }
            
            
            String sql = "select bankpo_payment_id,coa_id,journal_number,date,trans_date,periode_id,memo,vendor_id from ( "+
                            " select distinct b.bankpo_payment_id as bankpo_payment_id, "+
                            " b.coa_id as coa_id,b.journal_number as journal_number,b.date as date,b.trans_date as trans_date,b.periode_id as periode_id,b.memo as memo, "+
                            " bd.vendor_id as vendor_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id where "+whereClause+" ) as bankpo_payment ";
                        
            String str = SessBankPayment.oidVendorGroup(strGrp);
            
            if(vendorId != 0){                
                if(str != null && str.length() > 0){
                   str = str+","+vendorId;
                   sql = sql + " where vendor_id in ("+str+") ";
                }else{
                    sql = sql + " where vendor_id = "+vendorId;
                }
            }else{
                if(str != null && str.length() > 0){
                    sql = sql + " where vendor_id in ("+str+") ";
                }
            }
            
            sql = sql + " order by trans_date desc ";
            
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
            while (rs.next()) {
                BankpoPayment bp = new BankpoPayment();
                bp.setOID(rs.getLong("bankpo_payment_id"));
                bp.setCoaId(rs.getLong("coa_id"));
                bp.setJournalNumber(rs.getString("journal_number"));
                bp.setDate(rs.getDate("date"));
                bp.setTransDate(rs.getDate("trans_date"));
                bp.setPeriodeId(rs.getLong("periode_id"));
                bp.setVendorId(rs.getLong("vendor_id"));
                bp.setMemo(rs.getString("memo"));
                result.add(bp);
            }
            
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
    
    public static int getCountBankpoList(long vendorId,
            String jurnalNumber,int ignoreDate,Date tglBuatStart,Date tglBuatEnd,
            long periodId,int ignoreTransDate,Date transDate,String strGrp){
        int result = 0;
        CONResultSet crs = null;  
        try{
            
            String whereClause = " b."+DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS] + " in ('" + DbBankpoPayment.STATUS_POSTED + "','" + DbBankpoPayment.STATUS_PARTIALY_PAID + "') and b."+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS] + "= 1 and b." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA;
            
             if (ignoreDate == 0) {                
                whereClause = whereClause + " and b." +DbBankpoPayment.colNames[DbBankpoPayment.COL_DATE] + " between '" + JSPFormater.formatDate(tglBuatStart, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tglBuatEnd, "yyyy-MM-dd") + " 23:59:59'";
            }
            
            if (ignoreTransDate == 0) {
                whereClause = whereClause + " and b." +DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + " 00:00:00' and '"+ JSPFormater.formatDate(transDate, "yyyy-MM-dd") + " 23:59:59'";
            }

            if (jurnalNumber.length() > 0) {                
                whereClause = whereClause + " and b." +DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + jurnalNumber + "%' ";
            }

            if (periodId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }                
                whereClause = whereClause + " and b."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + " 23:59:59' ";
            }
            
            
            String sql = "select count(bankpo_payment_id) as total from ( "+
                            " select distinct b.bankpo_payment_id as bankpo_payment_id, "+
                            " b.coa_id as coa_id,b.journal_number as journal_number,b.date as date,b.trans_date as trans_date,b.periode_id as periode_id,b.memo as memo, "+
                            " bd.vendor_id as vendor_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id where "+whereClause+" ) as bankpo_payment ";
            
            String str = SessBankPayment.oidVendorGroup(strGrp);
            
            if(vendorId != 0){                
                if(str != null && str.length() > 0){
                   str = str+","+vendorId;
                   sql = sql + " where vendor_id in ("+str+") ";
                }else{
                    sql = sql + " where vendor_id = "+vendorId;
                }
            }else{
               if(str != null && str.length() > 0){
                    sql = sql + " where vendor_id in ("+str+") ";
                }
            }
            
            sql = sql + " order by trans_date desc ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getInt("total");
            }
            
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
    
    public static String getVendorName(long vendorId){
        CONResultSet crs = null;  
        String name = "";
        try{
            String sql = "select "+DbVendor.colNames[DbVendor.COL_NAME]+" as name from "+DbVendor.DB_VENDOR+" where "+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"= "+vendorId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                name = rs.getString("name");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return name;
        
    }
    
    public static void updateRefBankpoDetail(long groupDetailId,long refId){
        CONResultSet crs = null; 
        try{
            String sql = "update "+DbBankpoGroupDetail.DB_BANK_PO_GROUP_DETAIL+" set "+DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_REF_ID]+" = "+refId+
                    " where "+DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_BANKPO_GROUP_DETAIL_ID]+" = "+groupDetailId;
            CONHandler.execUpdate(sql);
            
        }catch(Exception e){}
        finally {
            CONResultSet.close(crs);
        }
        
    }
    
    
    public static Vector vendorGroup(){
        Vector result = new Vector();
        CONResultSet crs = null; 
        try{
            String sql = "select group_name from vendor_group group by group_name order by group_name";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                String name = rs.getString("group_name");
                result.add(name);
            }
        }catch(Exception e){}
        
        finally {
            CONResultSet.close(crs);
        }
        return result;
    }
    
    
    public static String oidVendorGroup(String name){        
        CONResultSet crs = null; 
        String strOId = "";
        try{
            String sql = "select vendor_id from vendor_group where group_name = '"+name+"' ";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                if(strOId != null && strOId.length() > 0){
                    strOId = strOId+",";
                }
                long oid = rs.getLong("vendor_id");
                strOId = strOId + String.valueOf(oid);
            }
        }catch(Exception e){}
        
        finally {
            CONResultSet.close(crs);
        }
        return strOId;
    }
    
    
    
}
