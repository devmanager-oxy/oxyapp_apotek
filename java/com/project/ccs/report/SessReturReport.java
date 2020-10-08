/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.general.DbVendor; 
import com.project.general.Vendor;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author Adnyana Eka Yasa
 */
public class SessReturReport {

    public static Vector getReturReport(SrcReturReport srcReturReport) {

        Vector list = new Vector();
        switch (srcReturReport.getTypeReport()) {
            case SrcReturReport.GROUP_BY_SUPPLIER:
                list = getPOBySupplier(srcReturReport);
                break;
            case SrcReturReport.GROUP_BY_SUB_CATEGORY:
                list = getPOBySubCategory(srcReturReport);
                break;
            case SrcReturReport.GROUP_BY_CATEGORY:
                list = getPOByCategory(srcReturReport);
                break;
            case SrcReturReport.GROUP_BY_ITEM:
                list = getPOByItem(srcReturReport);
                break;
        }
        return list;
    }

    public static Vector getPOBySupplier(SrcReturReport srcReturReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector(); 
        try {
            String sql = "SELECT number, count(retur_id) as cnt, vendor_id, sum(total_amount) as total_amount " +
                    "FROM `pos_retur` ";

            String where = "";
            if(srcReturReport.getVendorId()!=0){
                where = "vendor_id="+srcReturReport.getVendorId();
            }

            if(srcReturReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and location_id="+srcReturReport.getLocationId();
                }else{
                    where = "location_id="+srcReturReport.getLocationId();
                }
            }

            if(srcReturReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and date between '"+JSPFormater.formatDate(srcReturReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReturReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "date between '"+JSPFormater.formatDate(srcReturReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReturReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReturReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and status='"+srcReturReport.getStatus()+"'";
                }else{
                    where = "status='"+srcReturReport.getStatus()+"'";
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcReturReport.getGroupBy()){
                case SrcReturReport.GROUP_TRANSAKSI:
                    sql = sql + "retur_id ";
                    break;
                case SrcReturReport.GROUP_SUPPLIER:
                    sql = sql + "vendor_id ";
                    break;
            }

            System.out.println("SQL : " + sql); 
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                ReturReport returReport = new ReturReport();
                switch(srcReturReport.getGroupBy()){
                    case SrcReturReport.GROUP_TRANSAKSI:
                        returReport.setPurchNumber(rs.getString("number"));
                        break;
                    case SrcReturReport.GROUP_SUPPLIER:
                        returReport.setPurchNumber(""+rs.getInt("cnt"));
                        break;
                }

                returReport.setPurchAmount(rs.getDouble("total_amount"));
                //long vendorOid = rs.getLong("vendor_id");
                returReport.setVendorId(rs.getLong("vendor_id"));  
                
                /*
                Vendor vendor = new Vendor();
                try {
                    vendor = DbVendor.fetchExc(vendorOid);
                } catch (Exception ex) {
                    System.out.println("Err >>> : " + ex.toString());
                }
                returReport.setVendorName(vendor.getName());
                 */
                list.add(returReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOByCategory(SrcReturReport srcReturReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_retur_item` as pi " +
                    "inner join pos_retur p on pi.retur_id=p.retur_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_group as ic on im.item_group_id=ic.item_group_id ";

            String where = "";
            if(srcReturReport.getVendorId()!=0){
                where = "p.vendor_id="+srcReturReport.getVendorId();
            }

            if(srcReturReport.getLocationId()!=0){
                if(where.length()>0){ 
                    where = where + " and p.location_id="+srcReturReport.getLocationId();
                }else{
                    where = "p.location_id="+srcReturReport.getLocationId();
                }
            }

            if(srcReturReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReturReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReturReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReturReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReturReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReturReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReturReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcReturReport.getStatus()+"'";
                }
            }

            if(srcReturReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcReturReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcReturReport.getItemCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcReturReport.getGroupBy()){
                case SrcReturReport.GROUP_TRANSAKSI:
                    sql = sql + "p.retur_id ";
                    break;
                case SrcReturReport.GROUP_CATEGORY:
                    sql = sql + "ic.item_group_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReturReport returReport = new ReturReport();
                returReport.setItemCategory(rs.getString("name"));
                returReport.setTotalQty(rs.getDouble("qty"));
                returReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcReturReport.getGroupBy()==SrcReturReport.GROUP_TRANSAKSI){
                    returReport.setPurchNumber(rs.getString("number"));
                }else{
                    returReport.setPurchNumber("");
                }
 
                list.add(returReport);
            }   
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOBySubCategory(SrcReturReport srcReturReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_retur_item` as pi " +
                    "inner join pos_retur p on pi.retur_id=p.retur_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";

            String where = "";
            if(srcReturReport.getVendorId()!=0){
                where = "p.vendor_id="+srcReturReport.getVendorId();
            }

            if(srcReturReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.location_id="+srcReturReport.getLocationId();
                }else{
                    where = "p.location_id="+srcReturReport.getLocationId();
                }
            }

            if(srcReturReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReturReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReturReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReturReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReturReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReturReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReturReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcReturReport.getStatus()+"'";
                }
            }

            if(srcReturReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcReturReport.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcReturReport.getItemCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";  

            switch(srcReturReport.getGroupBy()){
                case SrcReturReport.GROUP_TRANSAKSI:
                    sql = sql + "p.retur_id ";
                    break;
                case SrcReturReport.GROUP_SUB_CATEGORY:
                    sql = sql + "ic.item_category_id ";
                    break;   
            } 

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                ReturReport returReport = new ReturReport();
                returReport.setItemCategory(rs.getString("name"));
                returReport.setTotalQty(rs.getDouble("qty"));
                returReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcReturReport.getGroupBy()==SrcReturReport.GROUP_TRANSAKSI){
                    returReport.setPurchNumber(rs.getString("number"));
                }else{
                    returReport.setPurchNumber("");
                }

                list.add(returReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOByItem(SrcReturReport srcReturReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            
            if(srcReturReport.getGroupBy()==SrcReturReport.GROUP_TRANSAKSI){
              sql = "SELECT pi.qty, im.code, im.barcode, im.name, p.number, p.vendor_id, " +
                    "pi.total_amount, pi.amount " +
                    "FROM `pos_retur_item` as pi " +
                    "inner join pos_retur p on pi.retur_id=p.retur_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }else{
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_retur_item` as pi " +
                    "inner join pos_retur p on pi.retur_id=p.retur_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }

            String where = "";
            if(srcReturReport.getVendorId()!=0){
                where = "p.vendor_id="+srcReturReport.getVendorId();
            }

            if(srcReturReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.location_id="+srcReturReport.getLocationId();
                }else{
                    where = "p.location_id="+srcReturReport.getLocationId();
                }
            }

            if(srcReturReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReturReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReturReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReturReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReturReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReturReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReturReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcReturReport.getStatus()+"'";
                }
            }

            if(srcReturReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcReturReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcReturReport.getItemCategoryId();
                }
            }

            if(srcReturReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcReturReport.getItemSubCategoryId();
                }else{
                    where = "im.item_category_id="+srcReturReport.getItemSubCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            //sql = sql + " group by ";

            /*
            switch(srcReturReport.getGroupBy()){
                case SrcReturReport.GROUP_TRANSAKSI:
                    sql = sql + "p.retur_id ";
                    break;
                case SrcReturReport.GROUP_ITEM:
                    sql = sql + "im.item_master_id ";
                    break;
            }
             */
            
            if(srcReturReport.getGroupBy()==SrcReturReport.GROUP_ITEM){
                sql = sql + "group by im.item_master_id ";
            }

            System.out.println("SQL qr: " + sql);
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReturReport returReport = new ReturReport();
                returReport.setItemCode(rs.getString("code"));
                returReport.setBarcode(rs.getString("barcode"));
                returReport.setItemName(rs.getString("name"));
                returReport.setTotalQty(rs.getDouble("qty"));
                returReport.setPurchAmount(rs.getDouble("total_amount")); 
                

                if(srcReturReport.getGroupBy()==SrcReturReport.GROUP_TRANSAKSI){
                    returReport.setPurchNumber(rs.getString("number"));
                }else{ 
                    returReport.setPurchNumber("");
                }

                list.add(returReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }
}
