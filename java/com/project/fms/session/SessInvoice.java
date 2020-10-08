/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;
import com.project.ccs.postransaction.receiving.DbReceive;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;
import com.project.general.DbVendor;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
/**
 *
 * @author Roy
 */
public class SessInvoice {
    
    public static Vector getListPostingInvoice(long periodId,String nomorJurnal,long vendorId,int ignore,Date start,Date end,int non,int konsinyasi,int komisi){
        CONResultSet dbrs = null;
        Vector result = new Vector();
        try{
            String sql = "select distinct bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" as bankpo_payment_id,bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_COA_ID]+" as coa_id,bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" as journal_number,bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+" as trans_date,bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_MEMO]+" as memo,bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_CURRENCY_ID]+" as currency_id " +
                    " from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bd on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" inner join "+DbReceive.DB_RECEIVE+" r on r."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = bd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID]+
                    " inner join "+DbVendor.DB_VENDOR+" v on r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" = v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                    " where (bp."+ DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS] + " = 0 OR bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS] + " IS NULL ) AND bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + "!=" + DbBankpoPayment.TYPE_PEMBELIAN_TUNAI;
            
            if(periodId != 0){
                sql = sql + " and bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_PERIODE_ID]+" = "+periodId;
            }
            
            if(nomorJurnal != null && nomorJurnal.length() > 0){
                sql = sql + " and bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]+" like '"+nomorJurnal+"'";
            }
            
            if(vendorId != 0){
                sql = sql + " and r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+" = "+vendorId;
            }
            
            if(ignore==0){
                sql = sql + " and to_days(bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+") >= to_days('"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"') and to_days(bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]+") <= to_days('"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"')";
            }
            
            String wherex = "";
            if(non == 0 && konsinyasi == 0 && komisi ==0){                
                sql = sql + " and ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = -1 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = -1 )";                
            }else{
            
                if(!(non == 1 && konsinyasi == 1 && komisi ==1)){
                    if(non == 1 || konsinyasi == 1 || komisi ==1){
                        if(konsinyasi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = " + 1;
                            }
                        if(komisi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = " + 1;
                        }
                
                        if(non ==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 0 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = 0 )";
                        }
                        
                        sql = sql +" and ( "+wherex+" ) ";
                    }
                }
            }
            
            
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                BankpoPayment bp = new BankpoPayment();
                bp.setOID(rs.getLong("bankpo_payment_id"));
                bp.setCoaId(rs.getLong("coa_id"));
                bp.setJournalNumber(rs.getString("journal_number"));
                bp.setTransDate(rs.getDate("trans_date"));   
                bp.setMemo(rs.getString("memo"));
                bp.setCurrencyId(rs.getLong("currency_id"));
                result.add(bp);       
            }
            return result;

        }catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return null;
    }

}
