/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.interfaces;

import com.project.ccs.posmaster.Shift;
import java.sql.ResultSet;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.SalesClosingJournal;
import com.project.ccs.sql.SQLGeneral;
import com.project.general.DbLocation;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import com.project.fms.master.*;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
/**
 *
 * @author Roy
 */
public class InterfaceSetoranKasir {

    public static Vector reportSetoranGroupByDate(long locationId, Date tanggal, Date tanggalEnd) {
        Vector result = new Vector();
        Connection conn = null;
        Statement stmt = null; 
        
        try {
            
            Class.forName("com.mysql.jdbc.Driver");            
            conn = DriverManager.getConnection(CONHandlerInterface.getDbUrl()+CONHandlerInterface.getDbName(),CONHandlerInterface.getDbUser(),CONHandlerInterface.getDbPassword());
            stmt = conn.createStatement();
            
            String where = " s."+DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + " 23:59:59' ";
            if (locationId != 0) {
                where = where + " and s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + locationId;
            }

            String sql = "select idx,date,sales_detail_id,type,pay_type,sum(cash) as cash,sum(credit) as credit,sum(cashback) as cashback,sum(system) as system from ( ";            
            
            //Single Payment , Card
            String sql3 = "select 2 as idx,date,sales_id,sales_detail_id,type,pay_type,0 as cash,sum(amount) as credit, 0 as cashback,0 as system from ( "+
                        " select date,sales_id,sales_detail_id,type,pay_type,sum(amount) as amount from ( "+
                        " select sl.date as date,sl.sales_id as sales_id,sd.sales_detail_id as sales_detail_id,sl.type as type,sl.pay_type as pay_type,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount from "+
                        "(select s.sales_id,s.date,s.type as type,p.pay_type as pay_type from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id where "+where+" group by s.sales_id having count(p.payment_id)=1 ) sl "+
                        " inner join pos_sales_detail sd on sl.sales_id = sd.sales_id where sl.type in (0,1) group by sl.sales_id "+
                        " union "+
                        " select sl.date as date,sl.sales_id as sales_id,sd.sales_detail_id as sales_detail_id,sl.type as type,sl.pay_type as pay_type,sum((sd.qty * sd.selling_price)-sd.discount_amount)*-1 as amount from "+
                        " (select s.sales_id,s.date,s.type as type,p.pay_type as pay_type from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id where "+where+" group by s.sales_id having count(p.payment_id)=1 ) sl "+
                        " inner join pos_sales_detail sd on sl.sales_id = sd.sales_id where sl.type in (2,3) group by sl.sales_id ) as x group by sales_id) as y where pay_type in (1,2) group by to_days(date) ";

            //Single Payment, Cash back
            String sql4 = "select 3 as idx,date,sales_id,sales_detail_id,type,pay_type,0 as cash,0 as credit,sum(amount) as cashback,0 as system from ( "+
                        " select date,sales_id,sales_detail_id,type,pay_type,sum(amount) as amount from ( "+
                        " select sl.date as date,sl.sales_id as sales_id,sd.sales_detail_id as sales_detail_id,sl.type as type,sl.pay_type as pay_type,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount from "+
                        " (select s.sales_id,s.date,s.type as type,p.pay_type as pay_type from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id where "+where+" group by s.sales_id having count(p.payment_id)=1 ) sl "+
                        " inner join pos_sales_detail sd on sl.sales_id = sd.sales_id where sl.type in (0,1) group by sl.sales_id "+
                        " union "+
                        " select sl.date as date,sl.sales_id as sales_id,sd.sales_detail_id as sales_detail_id,sl.type as type,sl.pay_type as pay_type,sum((sd.qty * sd.selling_price)-sd.discount_amount)*-1 as amount from "+
                        " (select s.sales_id,s.date,s.type as type,p.pay_type as pay_type from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id where "+where+" group by s.sales_id having count(p.payment_id)=1 ) sl "+
                        " inner join pos_sales_detail sd on sl.sales_id = sd.sales_id where sl.type in (2,3) group by sl.sales_id ) as x group by sales_id) as y where pay_type = 9 group by to_days(date) ";
            
            //multi payment, credit
            String sql7 = "select idx, date,sales_id,sales_detail_id,type,pay_type,cash,sum(credit) as credit,cashback,0 as system from( "+
                        " select 6 as idx,tb1.date as date,tb1.sales_id as sales_id,tb1.sales_detail_id as sales_detail_id,tb1.type as type,tb1.pay_type as pay_type,0 as cash,p.amount as credit,0 as cashback from "+
                        " (select sl.date as date,sl.sales_id as sales_id,sd.sales_detail_id as sales_detail_id,sl.type as type,sl.pay_type as pay_type,pamount as amount from "+
                        " (select s.sales_id,s.date,s.type as type,p.pay_type as pay_type,p.amount as pamount from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id where "+where+" group by s.sales_id having count(p.payment_id)>1 ) sl "+
                        " inner join pos_sales_detail sd on sl.sales_id = sd.sales_id group by sl.sales_id) as tb1 inner join pos_payment p on tb1.sales_id = p.sales_id where p.pay_type in (1,2) group by tb1.sales_id) as tb group by date ";
            
            String sql8 = "select idx, date,sales_id,sales_detail_id,type,pay_type,cash,credit,sum(cashback) as cashback,0 as system from( "+
                         " select 7 as idx,tb1.date as date,tb1.sales_id as sales_id,tb1.sales_detail_id as sales_detail_id,tb1.type as type,tb1.pay_type as pay_type,0 as cash,0  as credit,p.amount as cashback from "+
                         " (select sl.date as date,sl.sales_id as sales_id,sd.sales_detail_id as sales_detail_id,sl.type as type,sl.pay_type as pay_type,pamount as amount from "+
                         " (select s.sales_id,s.date,s.type as type,p.pay_type as pay_type,p.amount as pamount from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id where "+where+" group by s.sales_id having count(p.payment_id)>1 ) sl "+
                         " inner join pos_sales_detail sd on sl.sales_id = sd.sales_id group by sl.sales_id) as tb1 inner join pos_payment p on tb1.sales_id = p.sales_id where p.pay_type = 9 group by tb1.sales_id) as tb group by date ";
                  
            String sql9 ="select 8 as idx,date,sales_id,sales_detail_id,type,0 as pay_type,0 cash,0 as credit,0 as cashback, sum(omset) as system from ( " +
                        " select s.date as date,s.sales_id as sales_id,psd.sales_detail_id as sales_detail_id,s.type as type, sum((psd.qty * psd.selling_price)- psd.discount_amount) as omset from pos_sales s inner join pos_sales_detail psd on s.sales_id = psd.sales_id " +
                        " where "+where+" and s.type in (0,1) group by to_days(s.date) union " +
                        " select s.date as date,s.sales_id as sales_id,psd.sales_detail_id as sales_detail_id,s.type as type, sum((psd.qty * psd.selling_price)- psd.discount_amount)*-1 as omset from pos_sales s inner join pos_sales_detail psd on s.sales_id = psd.sales_id " +
                        " where "+where+" and s.type in (2,3) group by to_days(s.date)) as x group by to_days(date) ";            
            
            sql = sql + sql3+" union "+sql4+" union "+sql7+" union "+sql8+" union "+sql9+" ) as xxx group by to_days(date) order by date";
            
            ResultSet rs = stmt.executeQuery(sql); 

            while (rs.next()) {
                Date tgl = rs.getDate("date");
                double cash = rs.getDouble("cash");
                double credit = rs.getDouble("credit");
                double cashback = rs.getDouble("cashback");
                double system = rs.getDouble("system");
                
                Vector tmpReport = new Vector();
                tmpReport.add(JSPFormater.formatDate(tgl, "dd/MM/yyyy"));
                tmpReport.add("" + cash);
                tmpReport.add("" + credit);
                tmpReport.add("" + cashback);                
                tmpReport.add("" + system);                
                result.add(tmpReport);
            }

        }catch (SQLException se) {
            se.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) {
                    conn.close();
                }
            } catch (SQLException se) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return result;

    }
    
}
