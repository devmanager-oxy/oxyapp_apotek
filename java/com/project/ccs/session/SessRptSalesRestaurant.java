/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.ccs.posmaster.Shift;
import java.sql.ResultSet;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.SalesClosingJournal;
import com.project.ccs.sql.SQLGeneral;
import com.project.general.DbLocation;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.fms.master.*;
import com.project.util.JSPFormater;
import java.sql.SQLException;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author 
 */
public class SessRptSalesRestaurant {
    public static Vector reportSlsRestaurant(long locationId, Date tanggal, Date tanggalEnd) {
        Vector result = new Vector();
        CONResultSet crs = null;
        try {
        String where ="";
        if (locationId!=0){
            where =" where location_id=" + locationId;
        }
        String sqlsls ="SELECT location_id, tanggal, SUM(room) AS room, SUM(nett) AS nett, SUM(nett)+SUM(room) AS subtotal,SUM(tax) AS tax,  SUM(total) AS total FROM ("
                + "(SELECT location_id, LEFT(DATE,10) AS tanggal, '0' AS room, SUM(((qty*selling_price)-discount_item-global_diskon)) AS nett, SUM(tax) AS tax, SUM(((qty*selling_price)-discount_item-global_diskon)+tax) AS total FROM sales_tax_service WHERE (TO_DAYS(DATE) BETWEEN TO_DAYS('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') AND TO_DAYS('" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + "') AND item_group_id !='504404557803214075') GROUP BY TO_DAYS(DATE), location_id)"
                + "UNION"
                + "(SELECT location_id, LEFT(DATE,10) AS tanggal, SUM(((qty*selling_price)-discount_item-global_diskon)) AS room, '0' AS nett, SUM(tax) AS tax, SUM(((qty*selling_price)-discount_item-global_diskon)+tax) AS total FROM sales_tax_service WHERE (TO_DAYS(DATE) BETWEEN TO_DAYS('" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + "') AND TO_DAYS('" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + "') AND item_group_id ='504404557803214075') GROUP BY TO_DAYS(DATE), location_id)"
                + ") AS sls "+ where +" GROUP BY TO_DAYS(tanggal)";

        crs = CONHandler.execQueryResult(sqlsls);
        ResultSet rs = crs.getResultSet();
        
        while (rs.next()) {
            RptSalesRestaurant rest = new RptSalesRestaurant();
            rest.setTanggal(rs.getDate("tanggal"));
            rest.setSlsRoom(rs.getLong("room"));
            rest.setNettSls(rs.getDouble("nett"));
            rest.setTax(rs.getDouble("tax"));
            result.add(rest);
        }
        return result;
        } catch (Exception e){
        }finally{
            CONResultSet.close(crs);
        }
        return null;
    }

    public static double getCardPayment (long locationId, long merchantId, Date tanggal) {
        CONResultSet crs = null;
        double total=0;

        String sqlPayment ="SELECT p.pay_date, p.pay_type, p.merchant_id, SUM(p.amount*(100/(100+m.persen_expense))) AS jml FROM pos_payment p INNER JOIN pos_sales s ON p.sales_id=s.sales_id inner join merchant m on p.merchant_id=m.merchant_id "
                + "WHERE TO_DAYS(s.date)=TO_DAYS('"+ tanggal +"') AND p.pay_type IN ('1','2') and s.location_id='"+ locationId +"' and p.merchant_id='"+ merchantId +"' GROUP BY p.pay_type, p.merchant_id";
        try {
        
        crs = CONHandler.execQueryResult(sqlPayment);
        ResultSet rs = crs.getResultSet();

        if (!rs.next()){
            total=0;
        }else{
            total = rs.getDouble("jml");
        }
        return total;

        } catch (Exception e){
            System.out.println("Err : " + e.getMessage());
        }
        finally{
            CONResultSet.close(crs);
        }
        return 0;
    }

    
    public static double getCardFeeByDate (long locationId, Date tanggal) {
        CONResultSet crs = null;
        double cardFee=0;

        String sql ="SELECT p.pay_date, p.pay_type, p.merchant_id, SUM(p.amount) AS tot, SUM(p.amount*((m.persen_expense)/(100+m.persen_expense))) AS cardFee, m.persen_expense FROM pos_payment p INNER JOIN pos_sales s ON p.sales_id=s.sales_id INNER JOIN merchant m ON p.merchant_id=m.merchant_id "
                + "WHERE TO_DAYS(s.date)=TO_DAYS('"+ tanggal +"') AND p.pay_type IN ('1','2') AND s.location_id='"+ locationId +"' GROUP BY p.pay_type, p.merchant_id";

        try {

        crs = CONHandler.execQueryResult(sql);
        ResultSet rs = crs.getResultSet();

        if (!rs.next()){
            cardFee=0;
        }else{
            cardFee = rs.getDouble("cardFee");
        }
        return cardFee;

        } catch (Exception e){
            System.out.println("Err : " + e.getMessage());
        }
        finally{
            CONResultSet.close(crs);
        }
        return 0;

    }
}
