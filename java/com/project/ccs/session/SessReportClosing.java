/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;


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
import com.project.fms.master.DbSegmentDetail;
import com.project.general.Merchant;

/**
 *
 * @author Roy
 */
public class SessReportClosing {
    
    public static SalesClosingJournal getDataSummaryClosingSinglePayment(Date tanggal, long locationId, long cashCashierId) {
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
                        amount = amountRetur * -1;
                        break;

                    case 3:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        transfer = 0;
                        retur = rs.getDouble("tot");
                        amount = retur * -1;
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
    
    public static SalesClosingJournal getDataSummaryClosingMultyPayment(Date tanggal, long locationId, long cashCashierId) {
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
                        bon = tmpcash*-1;
                        cash = 0;  //old
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
                        
                        Vector amountRetur = getRetur(salesId);
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
                        bon = tmpcash*-1;
                        cash = 0;
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
                        
                        Vector amountRetur = getRetur(salesId);
                        
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
    
    public static Vector getRetur(long salesId){
        CONResultSet crs = null;
        try{
            String sql = " select sales_id,sum(amount) as x_amount,sum(buy) as x_buy,sum(retur) as x_retur,sum(discount_amount) as discount_amount from " +
                    "(select s.sales_id as sales_id,sum(sd.qty * sd.selling_price)*-1 as amount,0 as buy,sum((sd.qty * sd.selling_price)-sd.discount_amount)*-1 as retur,sum(sd.discount_amount)*-1 as discount_amount from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_id = "+salesId+" and sd.qty > 0 group by s.sales_id " +
                    " union "+
                    " select s.sales_id as sales_id,sum(sd.qty * sd.selling_price)*-1 as amount,sum((sd.qty * sd.selling_price)-sd.discount_amount)*-1 as buy,0 as retur,sum(sd.discount_amount)*-1 as discount_amount from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_id = "+salesId+" and sd.qty < 0 group by s.sales_id )as x group by sales_id ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()){
                Vector result = new Vector();
                long salesOid = 0;
                double buy = 0;
                double retur = 0;
                double discount = 0;
                double amount = 0;
                try{
                    salesOid = rs.getLong("sales_id");
                    buy = rs.getDouble("x_buy");
                    retur = rs.getDouble("x_retur");                    
                    discount = rs.getDouble("discount_amount");                    
                    amount = rs.getDouble("x_amount");                    
                }catch(Exception e){}
                
                result.add(""+salesOid);
                result.add(""+buy);
                result.add(""+retur);                
                result.add(""+discount);  
                result.add(""+amount);  
                
                return result;
            }            
                         
        }catch(Exception e){}
        
        return null;
    }
    
    public static String getUserShift(long cashCashierId){
        CONResultSet crs = null;
        try{            
            String sql = "select s.full_name as full_name from pos_cash_cashier cc inner join sysuser s on cc.user_id = s.user_id where cc.cash_cashier_id = "+cashCashierId;
             
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
    
    
    public static int getTypeReport(long locationId){
        CONResultSet crs = null;
        int typeReport = 0;
        try{
            String sql = "select "+DbSegmentDetail.colNames[DbSegmentDetail.COL_TYPE_SALES_REPORT]+" from "+DbSegmentDetail.DB_SEGMENT_DETAIL+" where "+DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID]+" = "+locationId;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                typeReport = rs.getInt(DbSegmentDetail.colNames[DbSegmentDetail.COL_TYPE_SALES_REPORT]);                
            }
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return typeReport;
        
    }
    
    public static Vector getListCard(long locationId,long bankId,int type){
        CONResultSet crs = null;
        Vector result = new Vector();
        try{
            String sql = "select m.merchant_id,m.persen_expense,m.description,m.type_payment from merchant m inner join bank b on m.bank_id = b.bank_id where m.location_id = "+locationId+" and b.bank_id = "+bankId+" and type_payment = "+type;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                Merchant m = new Merchant();
                m.setOID(rs.getLong("merchant_id"));
                m.setPersenExpense(rs.getDouble("persen_expense"));
                m.setDescription(rs.getString("description"));
                result.add(m);
                
            }
            
        }catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
    
    public static double getAmountCard(long locationId,Date date,long merchantId){
        CONResultSet crs = null;
        double total = 0;
        try{
            String sql = "select sum(total) as tot from ( "+
                        " select sum(p.amount) as total from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id inner join merchant m on p.merchant_id = m.merchant_id where s.type in (0,1) and s.location_id = "+locationId+" and s.date >= '"+JSPFormater.formatDate(date, "yyyy-MM-dd")+" 00:00:00' and s.date <= '"+JSPFormater.formatDate(date, "yyyy-MM-dd")+" 23:59:59' and m.merchant_id = "+merchantId+" union "+
                        " select sum(p.amount) as total from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id inner join merchant m on p.merchant_id = m.merchant_id where s.type in (2,3) and s.location_id = "+locationId+" and s.date >= '"+JSPFormater.formatDate(date, "yyyy-MM-dd")+" 00:00:00' and s.date <= '"+JSPFormater.formatDate(date, "yyyy-MM-dd")+" 23:59:59' and m.merchant_id = "+merchantId+" ) as x ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                total = rs.getDouble("tot");
            }
            
        }catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return total;
    }
    
     public static Date getDatePayment(long locationId,Date date,long merchantId){
        CONResultSet crs = null;
        Date dt = new Date();
        try{
            String sql = "select s.date as dt,s.number,m.merchant_id,b.payment_date as pay_date  from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id inner join merchant m on p.merchant_id = m.merchant_id inner join bank_payment b on p.payment_id = b.referensi_id where s.location_id = "+locationId+" and s.date >= '"+JSPFormater.formatDate(date, "yyyy-MM-dd")+" 00:00:00' and s.date <= '"+JSPFormater.formatDate(date, "yyyy-MM-dd")+" 23:59:59' and m.merchant_id = "+merchantId;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){                
                return rs.getDate("pay_date");
            }
            
        }catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return null;
    }
}
