/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import com.project.admin.DbUser;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.postransaction.sales.DbPayment;
import com.project.ccs.postransaction.sales.DbReturnPayment;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.JSPFormater;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.sales.SalesClosingJournal;


/**
 *
 * @author Roy
 */
public class SessClosingSummary {

    public static String getUserShift(long locationOid, Date tanggal,long cashCashierId){
        CONResultSet crs = null;
        try{            
            String sql = "select s."+DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]+" as cash_cashier_id,u."+DbUser.colNames[DbUser.COL_FULL_NAME]+" as full_name from "+DbSales.DB_SALES+" s inner join "+DbUser.DB_APP_USER +" u on s."+DbSales.colNames[DbSales.COL_USER_ID]+" = u."+DbUser.colNames[DbUser.COL_USER_ID]+
                    " where s."+DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]+" = "+cashCashierId+" and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal, "yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationOid+" limit 1 ";
             
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                return rs.getString("full_name");                
            }
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return "";
        
    }
    
    public static SalesClosingJournal getDataSummaryClosingVold(Date tanggal, long locationId, long cashCashierId) {
        CONResultSet crs = null;        
        SalesClosingJournal salesClosing = new SalesClosingJournal();
        try {
            String sql = "select p." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id," +
                        " p." + DbSales.colNames[DbSales.COL_TYPE] + " as type, " +
                        " p." + DbSales.colNames[DbSales.COL_SALES_RETUR_ID] + " as sales_retur_id, " +
                        " p." + DbSales.colNames[DbSales.COL_NUMBER] + " as number, " +
                        " p." + DbSales.colNames[DbSales.COL_DATE] + " as date, " +
                        " p." + DbSales.colNames[DbSales.COL_NAME] + " as name, " +
                        " sum((pd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+") - pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+" ) as tot , sum(pd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as discount_dt " +
                        " from " + DbSales.DB_SALES + " as p inner join " + DbSalesDetail.DB_SALES_DETAIL + " as pd on " +
                        " p." + DbSales.colNames[DbSales.COL_SALES_ID] + " = pd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " as it on pd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + "=it." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                        " where to_days(p." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') and to_days(p." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') ";

            if (locationId != 0){
                sql = sql + " and p." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }
            
            if (cashCashierId != 0){
                sql = sql + " and p." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }            
            
            sql = sql + " group by p." + DbSales.colNames[DbSales.COL_SALES_ID] + " order by p.number";   
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
           
            double totCash = 0;
            double totCard = 0;
            double totDebit = 0;
            double totTransfer = 0;
            double totBon = 0;
            double totDiscount = 0;
            double totRetur = 0;
            double totAmount = 0;
            
            double cash = 0;
            double card = 0;
            double debit = 0;
            double transfer = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;
            double amountRetur = 0;
            
            while (rs.next()) {
                
                cash = rs.getDouble("tot");
                long salesId = rs.getLong("sales_id");
               
                double kembalian = 0;
                try{
                    if(salesId != 0){
                        kembalian = getTotalReturn(salesId);
                    }
                }catch(Exception e){}
                
                cash = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian; 
                card = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);                
                debit = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                                    
                transfer = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);   
                               
                discount = rs.getDouble("discount_dt");
                amount = cash + card + debit + transfer + discount;
                amountRetur = cash + card + debit + transfer + discount;
               
                retur = 0;
                bon = 0;
                
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        bon = rs.getDouble("tot");
                        amount = bon + discount;
                        break;

                    case 2:
                        cash = cash * -1;
                        card = card * -1;
                        transfer = transfer *-1;
                        retur = amountRetur;
                        amount = 0;
                        break;

                    case 3:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        transfer = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;
                }

                totCash = totCash + cash;
                totCard = totCard + card;
                totDebit = totDebit + debit;
                totTransfer = totTransfer + transfer;
                totBon = totBon + bon;
                totDiscount = totDiscount + discount;
                totRetur = totRetur + retur;
                totAmount = totAmount + amount;
            }

            // setting for object
            salesClosing.setInvoiceNumber("");
            salesClosing.setTglJam(new Date());
            salesClosing.setMember("");
            salesClosing.setCash(totCash);
            salesClosing.setCCard(totCard);
            salesClosing.setDCard(totDebit);
            salesClosing.setTransfer(totTransfer);
            salesClosing.setBon(totBon);
            salesClosing.setDiscount(totDiscount);
            salesClosing.setRetur(totRetur);
            salesClosing.setAmount(totAmount);

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return salesClosing;
    }
    
    
    public static SalesClosingJournal getDataSummaryClosing(Date tanggal, long locationId, long cashCashierId) {
        CONResultSet crs = null;        
        SalesClosingJournal salesClosing = new SalesClosingJournal();
        try {
             String where = " to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') and to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') ";           
                       
            if (locationId != 0){
                where = where + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }
            
            if (cashCashierId != 0){
                where = where + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }  
            
            String sql =" select sales_id,number,name,date,amount,discount,location_id,type,sales_retur_id,posted_status,payment_id,currency_id,pay_type,pay_date,pamount,rate,cost_card_amount,cost_card_percent,cc_id,bank_id,merchant_id,type_data from ( "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,1 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s inner join pos_payment p on s.sales_id = p.sales_id group by s.sales_id having count(p.payment_id)=1 "+
                        " union "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,0 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s left join pos_payment p on s.sales_id = p.sales_id where p.sales_id is null group by s.sales_id "+
                        " union "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,2 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s inner join pos_payment p on s.sales_id = p.sales_id group by s.sales_id having count(p.payment_id)>1 "+
                        " ) as x group by sales_id order by number ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();   
           
            double totCash = 0;
            double totCard = 0;
            double totDebit = 0;
            double totTransfer = 0;
            double totBon = 0;
            double totDiscount = 0;
            double totRetur = 0;
            double totAmount = 0;
            double totCashBack = 0;
            
            double cash = 0;
            double card = 0;
            double debit = 0;
            double transfer = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;
            double cashBack = 0;
            
            while (rs.next()) {
                
                cash = 0;
                card = 0;
                debit = 0;
                transfer = 0;
                bon = 0;
                discount = 0;
                retur = 0;
                amount = 0;
                cashBack = 0;
                
                double tmpcash = rs.getDouble("amount");
                int typeData = rs.getInt("type_data");
                int saleType = rs.getInt("type");
                long salesId = rs.getLong("sales_id");      
                discount = rs.getDouble("discount");
                int payType = rs.getInt("pay_type");
                
                if(typeData == 0){
                    if(saleType == 0){ //cash                        
                        cash = tmpcash;                        
                        amount = cash + discount;                        
                    }else if(saleType == 1){ // credit                     
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        bon = tmpcash;
                        amount = bon + discount;
                        
                    }else if(saleType == 2){ //retur cash
                        
                        Vector amountRetur = DbSales.getRetur(salesId);
                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}
                        
                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}
                        
                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}
                        
                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}
                        
                        double selisih = xbuy + xretur;
                        
                        cash = selisih;                        
                        if(xretur != 0){
                            retur = xretur*-1;
                        }  
                        discount = xdiscount;
                        amount = amountx;
                        
                    }else if(saleType == 3){ //retur credit
                        cash = tmpcash*-1;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        amount = (tmpcash + discount)*-1;  
                    }else if(saleType == 9){ //cash                        
                        cashBack = tmpcash;                        
                        amount = cash + discount;                        
                    }
                    
                }else if(typeData == 1){
                    
                    if(saleType == 0){ //cash
                        if(payType == DbPayment.PAY_TYPE_CASH){
                            cash = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                            card = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                            debit = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                            transfer = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CASH_BACK){
                            cashBack = tmpcash;
                        }       
                        amount = (cash + card + debit + transfer + cashBack)+ discount;
                        
                    }else if(saleType == 1){ // credit                     
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        cashBack = 0;
                        bon = tmpcash;
                        amount = bon + discount;
                        
                    }else if(saleType == 2){ //retur cash
                        
                        Vector amountRetur = DbSales.getRetur(salesId);
                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}
                        
                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}
                        
                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}
                        
                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}
                        
                        double selisih = xbuy + xretur;
                        
                        if(selisih != 0){
                            if(payType == DbPayment.PAY_TYPE_CASH){
                                cash = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                                card = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                                debit = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                                transfer = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_CASH_BACK){
                                cashBack = selisih;
                            }
                        }else{
                            cash = 0;
                            card = 0;
                            debit = 0;
                            transfer = 0;
                            cashBack = 0;
                        }
                        
                        if(xretur != 0){
                            retur = xretur*-1;
                        }     
                        
                        discount = xdiscount;                                                
                        amount = amountx;
                        
                    }else if(saleType == 3){ //retur credit
                        cash = tmpcash*-1;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        amount = (tmpcash + discount)*-1; 
                    }else if(saleType == 9){ //cash back
                        if(payType == DbPayment.PAY_TYPE_CASH){
                            cash = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                            card = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                            debit = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                            transfer = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CASH_BACK ){
                            cashBack = tmpcash;
                        }    
                        amount = (cash + card + debit + transfer + cashBack)+ discount;                        
                    }
                    
                }else if(typeData == 2){
                    
                    if(saleType == 0){ //cash   
                        
                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}
                
                        cash = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);                
                        debit = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                                    
                        transfer = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);  
                        cashBack = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);  
                        
                        amount = tmpcash + discount;
                        
                    }else if(saleType == 1){ // credit                     
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        cashBack = 0;
                        bon = tmpcash;
                        amount = bon + discount;
                        
                    }else if(saleType == 2){ //retur cash
                        
                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}
                        
                        Vector amountRetur = DbSales.getRetur(salesId);
                        
                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}
                        
                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}
                        
                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}
                        
                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}
                        
                
                        cash = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);                
                        debit = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                                    
                        transfer = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);                          
                        cashBack = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);                          
                        
                        retur = xretur;
                        discount = xdiscount;
                        amount = amountx;
                        
                    }else if(saleType == 3){ //retur credit
                        cash = tmpcash*-1;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        cashBack = 0;
                        amount = (tmpcash + discount)*-1; 
                        
                    }else if(saleType == 9){ //cash back
                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}
                
                        cash = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);                
                        debit = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                                    
                        transfer = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);  
                        cashBack = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);  
                        
                        amount = tmpcash + discount;                   
                    }
                }

                totCash = totCash + cash;
                totCard = totCard + card;
                totDebit = totDebit + debit;
                totTransfer = totTransfer + transfer;
                totCashBack = totCashBack + cashBack;
                totBon = totBon + bon;
                totDiscount = totDiscount + discount;
                totRetur = totRetur + retur;
                totAmount = totAmount + amount;
            }

            // setting for object
            salesClosing.setInvoiceNumber("");
            salesClosing.setTglJam(new Date());
            salesClosing.setMember("");
            salesClosing.setCash(totCash);
            salesClosing.setCCard(totCard);
            salesClosing.setDCard(totDebit);
            salesClosing.setTransfer(totTransfer);
            salesClosing.setCashBack(totCashBack);
            salesClosing.setBon(totBon);
            salesClosing.setDiscount(totDiscount);
            salesClosing.setRetur(totRetur);
            salesClosing.setAmount(totAmount);

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return salesClosing;
    }
    
    public static double getTotalReturn(long salesId){
        CONResultSet crs = null;        
        try{
            String sql = "select sum("+DbReturnPayment.colNames[DbReturnPayment.COL_AMOUNT]+") from "+DbReturnPayment.DB_RETURN_PAYMENT+" where "+DbReturnPayment.colNames[DbReturnPayment.COL_SALES_ID]+" = "+salesId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                return rs.getDouble(1);
            }
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        
        return 0;
    }
      
}
