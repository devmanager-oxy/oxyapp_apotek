/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.ccs.postransaction.sales.DbCreditPayment;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.JSPFormater;

/**
 *
 * @author Roy
 */
public class SessCreditTransaction {

    public static Vector getTotalAmount(String nomorFaktur, String member, int limitStart, int recordToGet) {
        Vector result = new Vector();
        try {

            String sql = "select s." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id, s." + DbSales.colNames[DbSales.COL_DATE] + " as date,s." + DbSales.colNames[DbSales.COL_NUMBER] + " as number,s." + DbSales.colNames[DbSales.COL_NAME] + " as name,sum((sd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + "* sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + ")-sd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as total,s.global_diskon as global_diskon,s.vat_amount as vat_amount,s.service_amount as service_amount,s.diskon_kartu as diskon_kartu " +
                    " from " + DbSales.DB_SALES + " s inner join " + DbSalesDetail.DB_SALES_DETAIL + " sd on s." + DbSales.colNames[DbSales.COL_SALES_ID] + " = sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " where s." + DbSales.colNames[DbSales.COL_TYPE] + " = 1 and s." + DbSales.colNames[DbSales.COL_PAYMENT_STATUS] + " = 1 ";

            if (nomorFaktur != null && nomorFaktur.length() > 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_NUMBER] + " like '%" + nomorFaktur + "%'";
            }

            if (member != null && member.length() > 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_NAME] + " like '%" + member + "%'";
            }

            sql = sql + " group by s.sales_id order by s.date ";

            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }

            CONResultSet crs = null;

            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {

                    CreditMember cm = new CreditMember();
                    cm.setSalesId(rs.getLong("sales_id"));
                    cm.setDate(rs.getDate("date"));
                    cm.setNumber(rs.getString("number"));
                    cm.setCustomer(rs.getString("name"));

                    double total = rs.getDouble("total");
                    double globalDiskon = rs.getDouble("global_diskon");
                    double vatAmount = rs.getDouble("vat_amount");
                    double serviceAmount = rs.getDouble("service_amount");
                    double diskonCard = rs.getDouble("diskon_kartu");

                    double piutang = total - globalDiskon + vatAmount + serviceAmount - diskonCard;
                    cm.setTotal(piutang);

                    cm.setPaid(DbCreditPayment.getTotalPayment(DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + "=" + cm.getSalesId()));
                    double retur = 0;
                    try {
                        retur = getTotalAmount(cm.getSalesId());
                        cm.setRetur(retur);
                    } catch (Exception e) {
                    }
                    result.add(cm);
                }
            } catch (Exception e) {
            } finally {
                CONResultSet.close(crs);
            }

        } catch (Exception e) {
        }

        return result;
    }

    public static double getTotalAmount(long salesId) {
        try {

            String sql = "select s.sales_id as sales_id, s.date as date,s.number as number,s.name as name,sum((sd.qty * sd.selling_price)-sd.discount_amount) as total,s.global_diskon as global_diskon,s.vat_amount as vat_amount,s.service_amount as service_amount,s.diskon_kartu as diskon_kartu " +
                    " from " + DbSales.DB_SALES + " s inner join " + DbSalesDetail.DB_SALES_DETAIL + " sd on s." + DbSales.colNames[DbSales.COL_SALES_ID] + " = sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + 
                    " where s." + DbSales.colNames[DbSales.COL_SALES_RETUR_ID] + " = " + salesId + " group by s.sales_id ";

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    double total = rs.getDouble("total");
                    double globalDiskon = rs.getDouble("global_diskon");
                    double vatAmount = rs.getDouble("vat_amount");
                    double serviceAmount = rs.getDouble("service_amount");                    
                    double diskonCard = rs.getDouble("diskon_kartu");
                    double piutang = total - globalDiskon + vatAmount + serviceAmount - diskonCard;
                    return piutang;
                }
            } catch (Exception e) {
            } finally {
                CONResultSet.close(crs);
            }

        } catch (Exception e) {
        }

        return 0;
    }
    
    public static Vector listCreditMember(int limitStart, int recordToGet,String number,String name){
        
        CONResultSet crs = null;
        Vector result = new Vector();
        try{
            String str = "";
            if(number != null && number.length() > 0){
                str = " and lower(s.number) like '"+number.trim().toLowerCase()+"' ";
            }            
            
            String sql = "select sales_id,number,date,c.customer_id,c.name,payment_status,sub_total,global_diskon,payment,retur,truncate(balance,2) as balance from ( "+
            
                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.date as date,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,0 as payment,0 as retur,(tb2.sub_total-tb2.global_diskon-0-0) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.date as date,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.date as date,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.date as date,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,0 as payment,sum(tb3.grand_total) as retur,(tb2.sub_total-tb2.global_diskon-0-sum(tb3.grand_total)) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.date as date,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.date as date,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is not null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.date as date,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,tb2.payment as payment,0 as retur,(tb2.sub_total-tb2.global_diskon-tb2.payment-0) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.date as date,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.date as date,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is not null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.date as date,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,tb2.payment as payment,sum(tb3.grand_total) as retur,(tb2.sub_total-tb2.global_diskon-tb2.payment-sum(tb3.grand_total)) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.date as date,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.date as date,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is not null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is not null group by tb2.sales_id having balance > 0) as t inner join customer c on t.customer_id= c.customer_id group by t.sales_id order by t.date";
            
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }

            if(name != null && name.length() >0){
                sql = sql + "where c.name like '"+name.trim().toLowerCase()+"' ";
            }         
            
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
               Vector tmp = new Vector(); 
               tmp.add(String.valueOf(rs.getLong("sales_id"))); 
               tmp.add(rs.getString("number"));  
               tmp.add(String.valueOf(JSPFormater.formatDate(rs.getDate("date"), "dd/MM/yyyy")));
               tmp.add(String.valueOf(rs.getLong("customer_id"))); 
               tmp.add(rs.getString("name"));  
               tmp.add(String.valueOf(rs.getInt("payment_status"))); 
               tmp.add(String.valueOf(rs.getDouble("sub_total"))); 
               tmp.add(String.valueOf(rs.getDouble("global_diskon"))); 
               tmp.add(String.valueOf(rs.getDouble("payment"))); 
               tmp.add(String.valueOf(rs.getDouble("retur"))); 
               tmp.add(String.valueOf(rs.getDouble("balance")));                
               result.add(tmp);
            }
            
        }catch(Exception e){}
        finally {
                CONResultSet.close(crs);
        }
        return result;
        
    }
    
    
    public static double totalCredit(long customerId){
        
        CONResultSet crs = null;
        double result = 0;
        try{
            String str = " and s.customer_id = '"+customerId+"' ";                     
            
            String sql = "select sum(truncate(balance,2)) as balance from ( "+
            
                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.date as date,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,0 as payment,0 as retur,(tb2.sub_total-tb2.global_diskon-0-0) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.date as date,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.date as date,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.date as date,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,0 as payment,sum(tb3.grand_total) as retur,(tb2.sub_total-tb2.global_diskon-0-sum(tb3.grand_total)) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.date as date,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.date as date,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is not null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.date as date,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,tb2.payment as payment,0 as retur,(tb2.sub_total-tb2.global_diskon-tb2.payment-0) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.date as date,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.date as date,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is not null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.date as date,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,tb2.payment as payment,sum(tb3.grand_total) as retur,(tb2.sub_total-tb2.global_diskon-tb2.payment-sum(tb3.grand_total)) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.date as date,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.date as date,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is not null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is not null group by tb2.sales_id having balance > 0) as tbx";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
              result = rs.getDouble("balance");
            }
            
        }catch(Exception e){}
        finally {
                CONResultSet.close(crs);
        }
        return result;
        
    }
    
    public static int countCreditMember(String number,String name){
        
        CONResultSet crs = null;
        int result = 0;
        
        try{
            String str = "";
            if(number != null && number.length() > 0){
                str = " and lower(s.number) like '"+number.trim().toLowerCase()+"' ";
            }            
            
            String sql = "select count(sales_id) as total from ( "+
            
                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,0 as payment,0 as retur,(tb2.sub_total-tb2.global_diskon-0-0) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,0 as payment,sum(tb3.grand_total) as retur,(tb2.sub_total-tb2.global_diskon-0-sum(tb3.grand_total)) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is not null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,tb2.payment as payment,0 as retur,(tb2.sub_total-tb2.global_diskon-tb2.payment-0) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is not null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is null group by tb2.sales_id having balance > 0 union "+

                        " select tb2.sales_id as sales_id,tb2.number as number,tb2.customer_id as customer_id,tb2.payment_status as payment_status,tb2.sub_total as sub_total,tb2.global_diskon as global_diskon,tb2.payment as payment,sum(tb3.grand_total) as retur,(tb2.sub_total-tb2.global_diskon-tb2.payment-sum(tb3.grand_total)) as balance from "+
                        " (select tb1.sales_id,tb1.number,tb1.customer_id as customer_id,tb1.payment_status as payment_status,tb1.sub_total,tb1.global_diskon,sum(cp.rate*cp.amount) as payment from "+
                        " (select s.sales_id as sales_id,s.number as number,s.customer_id as customer_id,s.payment_status as payment_status,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.type = 1 and s.payment_status = 1 "+str+" group by s.sales_id) as tb1 left join "+
                        " pos_credit_payment cp on tb1.sales_id = cp.sales_id where cp.sales_id is not null group by tb1.sales_id) as tb2 "+
                        " left join "+
                        " (select s.sales_id as sales_id,s.sales_retur_id as sales_retur_id,s.number as number,sum((sd.qty*sd.selling_price)-sd.discount_amount) as sub_total,s.global_diskon as global_diskon,(sum((sd.qty*sd.selling_price)-sd.discount_amount) - s.global_diskon) as grand_total from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_retur_id != 0 group by s.sales_id) as tb3 on "+
                        " tb2.sales_id = tb3.sales_retur_id where tb3.sales_retur_id is not null group by tb2.sales_id having balance > 0) as t inner join customer c on t.customer_id= c.customer_id ";

            if(name != null && name.length() >0){
                sql = sql + "where c.name like '"+name.trim().toLowerCase()+"' ";
            }                     
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
               result = rs.getInt("total");
            }
            
        }catch(Exception e){}
        finally {
                CONResultSet.close(crs);
        }
        return result;
        
    }
    
    public static double getCreditLimit(long customerId){
        double result = 0;
        CONResultSet crs = null;
        try{
            String sql = "select "+DbCustomer.colNames[DbCustomer.COL_CREDIT_LIMIT]+" from "+DbCustomer.DB_CUSTOMER+
                    " where "+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = "+customerId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
               result = rs.getInt(DbCustomer.colNames[DbCustomer.COL_CREDIT_LIMIT]);
            }
            
        }catch(Exception e){}
        finally {
                CONResultSet.close(crs);
        }        
        
        return result;
    }
    
    
    
    
}



