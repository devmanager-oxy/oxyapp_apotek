/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.interfaces;

import java.sql.ResultSet;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import com.project.fms.master.*;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Roy
 */
public class InterfaceSales {

    public static Vector getKomisiSales(long locationId, Date startDate, Date endDate) {

        Vector result = new Vector();
        Connection conn = null;
        Statement stmt = null;

        String or = "";
        try{
            or = DbSystemProperty.getValueByName("OID_CATEGORY_SIMPATINDO_PULSA");
        }catch(Exception e){} 
        
        if(or.equals("Not initialized")){
            or = "";
        }else{
            or = " or m.item_category_id = "+or;
        }  
        
        try {

            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONHandlerInterface.getDbUrl() + CONHandlerInterface.getDbName(), CONHandlerInterface.getDbUser(), CONHandlerInterface.getDbPassword());
            stmt = conn.createStatement();

            String sql = "select vid, vcode, vname, vkomisi, mitem_id, " +
                    " mcode, mname, sum(qty) as xqty, " +
                    " sum(amount) as xamount,vkonsinyasi_margin,mcategory_id from ( " +
                    " select 0 as idxx,v.vendor_id as vid, v.code as vcode, v.name as vname, v.komisi_margin as vkomisi, m.item_master_id as mitem_id,v.percent_margin as vkonsinyasi_margin,m.item_category_id as mcategory_id, " +
                    " m.code as mcode, m.name as mname, sum(psd.qty) as qty, " +
                    " (sum(psd.qty * psd.selling_price)-sum(psd.discount_amount)) as amount from pos_sales ps " +
                    " inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                    " inner join pos_item_master m on psd.product_master_id = item_master_id " +
                    " inner join vendor v on v.vendor_id=m.default_vendor_id " +
                    " where  ps.location_id = " + locationId +
                    " and  to_days(ps.date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') " +
                    " and to_days(ps.date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                    " and  psd.status_komisi=0 and (m.type_item=2 "+or+") and ps.type in (0,1) " +
                    " group by m.item_master_id, v.vendor_id " +
                    " union " +
                    " select 1 as idxx,v.vendor_id as vid, v.code as vcode, v.name as vname, v.komisi_margin as vkomisi, m.item_master_id as mitem_id,v.percent_margin as vkonsinyasi_margin,m.item_category_id as mcategory_id, " +
                    " m.code as mcode, m.name as mname, sum(psd.qty)*-1 as qty, " +
                    " (sum(psd.qty * psd.selling_price)-sum(psd.discount_amount))*-1 as amount from pos_sales ps " +
                    " inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                    " inner join pos_item_master m on psd.product_master_id = item_master_id " +
                    " inner join vendor v on v.vendor_id=m.default_vendor_id " +
                    " where  ps.location_id = " + locationId +
                    " and  to_days(ps.date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') " +
                    " and to_days(ps.date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                    " and  psd.status_komisi=0 and (m.type_item=2 "+or+") and ps.type in (2,3) " +
                    " group by m.item_master_id, v.vendor_id " +
                    " ) as x group by mitem_id, vid " +
                    " order by vname, mname ";

            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                long vid = rs.getLong("vid");
                String vcode = rs.getString("vcode");
                String vname = rs.getString("vname");
                double vkomisi = rs.getDouble("vkomisi");
                long im = rs.getLong("mitem_id");
                String icode = rs.getString("mcode");
                String iname = rs.getString("mname");
                
                double qty = rs.getDouble("xqty");
                double amount = rs.getDouble("xamount");                
                double vkonsinyasi = rs.getDouble("vkonsinyasi_margin");
                long imCategory = rs.getLong("mcategory_id");

                if(qty != 0){ //jika total sales tidak sama dengan 0
                    Vector temp = new Vector();
                    temp.add("" + vid);//0
                    temp.add("" + vcode);//1
                    temp.add("" + vname);//2
                    temp.add("" + vkomisi);//3
                    temp.add("" + im);//4
                    temp.add("" + icode);//5
                    temp.add("" + iname);//6
                    temp.add("" + qty);//7
                    temp.add("" + amount);//8
                    temp.add("" + vkonsinyasi);//9
                    temp.add("" + imCategory);//10
                    result.add(temp);
                }
            }

        } catch (SQLException se) {
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
    
    public static int updateKomisi(Date start,Date end,long locationId,long itemId){
        
        if(start == null || end == null || locationId == 0 || itemId == 0){            
            return 0;
        }
        
        Connection conn = null;
        Statement stmt = null;
        try{
             
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONHandlerInterface.getDbUrl() + CONHandlerInterface.getDbName(), CONHandlerInterface.getDbUser(), CONHandlerInterface.getDbPassword());
            stmt = conn.createStatement();
            
            String sql = "select sd.sales_detail_id as sd_id from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                    " where sd.product_master_id = "+itemId+" and s.date between '"+JSPFormater.formatDate(start, "yyyy-MM-dd")+" 00:00:00' and '"+JSPFormater.formatDate(end, "yyyy-MM-dd")+" 23:59:59' and s.location_id = "+locationId;
            
            ResultSet rs = stmt.executeQuery(sql);
			
            while(rs.next()){
                long salesDetailId = rs.getLong("sd_id");
                if(salesDetailId != 0){
                    updateStatusKomisi(salesDetailId);
                }
            }
            rs.close();
             
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
        return 1;
    }
    
    public static void updateStatusKomisi(long salesDetailId){
        Connection conn = null;
        Statement stmt = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");            
            conn = DriverManager.getConnection(CONHandlerInterface.getDbUrl() + CONHandlerInterface.getDbName(), CONHandlerInterface.getDbUser(), CONHandlerInterface.getDbPassword());            
            String sql = "update pos_sales_detail set status_komisi=1 where sales_detail_id  = " + salesDetailId;             
            stmt = conn.createStatement();
            stmt.executeUpdate(sql);             
             
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
     }
    
}
