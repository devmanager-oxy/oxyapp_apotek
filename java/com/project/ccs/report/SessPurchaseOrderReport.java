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
public class SessPurchaseOrderReport {

    public static Vector getPurchaseOrderReport(SrcPurchaseOrderReport srcPurchaseOrder) {
        Vector list = new Vector();
        switch (srcPurchaseOrder.getTypeReport()) {  
            case SrcPurchaseOrderReport.GROUP_BY_SUPPLIER:
                list = getPOBySupplier(srcPurchaseOrder);
                break;
            case SrcPurchaseOrderReport.GROUP_BY_SUB_CATEGORY:
                list = getPOBySubCategory(srcPurchaseOrder);
                break;
            case SrcPurchaseOrderReport.GROUP_BY_CATEGORY:
                list = getPOByCategory(srcPurchaseOrder);
                break;
            case SrcPurchaseOrderReport.GROUP_BY_ITEM:
                list = getPOByItem(srcPurchaseOrder);
                break;
        }
        return list;
    }

    public static Vector getPOBySupplier(SrcPurchaseOrderReport srcPurchaseOrder) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT number, count(purchase_id) as cnt, vendor_id, sum(total_amount) as total_amount " +
                         "FROM pos_purchase ";

            String where = "";
            if(srcPurchaseOrder.getVendorId()!=0){
                where = "vendor_id="+srcPurchaseOrder.getVendorId();
            }

            if(srcPurchaseOrder.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and location_id="+srcPurchaseOrder.getLocationId();
                }else{
                    where = "location_id="+srcPurchaseOrder.getLocationId();
                }
            }

            if(srcPurchaseOrder.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and purch_date between '"+JSPFormater.formatDate(srcPurchaseOrder.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcPurchaseOrder.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "purch_date between '"+JSPFormater.formatDate(srcPurchaseOrder.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcPurchaseOrder.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcPurchaseOrder.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and status='"+srcPurchaseOrder.getStatus()+"'";
                }else{
                    where = "status='"+srcPurchaseOrder.getStatus()+"'";
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcPurchaseOrder.getGroupBy()){
                case SrcPurchaseOrderReport.GROUP_TRANSAKSI:
                    sql = sql + "purchase_id ";
                    break;
                case SrcPurchaseOrderReport.GROUP_SUPPLIER:
                    sql = sql + "vendor_id ";
                    break;
            }

            System.out.println("SQL : " + sql); 
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                PurchaseOrderReport purchOrderReport = new PurchaseOrderReport();
                switch(srcPurchaseOrder.getGroupBy()){
                    case SrcPurchaseOrderReport.GROUP_TRANSAKSI:
                        purchOrderReport.setPurchNumber(rs.getString("number"));
                        break;
                    case SrcPurchaseOrderReport.GROUP_SUPPLIER:
                        purchOrderReport.setPurchNumber(""+rs.getInt("cnt"));
                        break;
                }

                purchOrderReport.setPurchAmount(rs.getDouble("total_amount"));
                purchOrderReport.setVendorId(rs.getLong("vendor_id"));
                
                /*
                long vendorOID = purchOrderReport.getVendorId();
                Vendor vendor = new Vendor();
                try {
                    vendor = DbVendor.fetchExc(vendorOID);
                } catch (Exception ex) {
                    System.out.println("Err v >>> : " + ex.toString());
                }
                purchOrderReport.setVendorName(vendor.getName());
                 */

                list.add(purchOrderReport);
            }
        } catch (Exception e) {
            System.out.println("Err al >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOByCategory(SrcPurchaseOrderReport srcPurchaseOrder) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_purchase_item` as pi " +
                    "inner join pos_purchase p on pi.purchase_id=p.purchase_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_group as ic on im.item_group_id=ic.item_group_id ";

            String where = "";
            if(srcPurchaseOrder.getVendorId()!=0){
                where = "p.vendor_id="+srcPurchaseOrder.getVendorId();
            }

            if(srcPurchaseOrder.getLocationId()!=0){
                if(where.length()>0){ 
                    where = where + " and p.location_id="+srcPurchaseOrder.getLocationId();
                }else{
                    where = "p.location_id="+srcPurchaseOrder.getLocationId();
                }
            }

            if(srcPurchaseOrder.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.purch_date between '"+JSPFormater.formatDate(srcPurchaseOrder.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcPurchaseOrder.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.purch_date between '"+JSPFormater.formatDate(srcPurchaseOrder.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcPurchaseOrder.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcPurchaseOrder.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcPurchaseOrder.getStatus()+"'";
                }else{
                    where = "p.status='"+srcPurchaseOrder.getStatus()+"'";
                }
            }

            if(srcPurchaseOrder.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcPurchaseOrder.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcPurchaseOrder.getItemCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcPurchaseOrder.getGroupBy()){
                case SrcPurchaseOrderReport.GROUP_TRANSAKSI:
                    sql = sql + "p.purchase_id ";
                    break;
                case SrcPurchaseOrderReport.GROUP_CATEGORY:
                    sql = sql + "ic.item_group_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PurchaseOrderReport purchOrderReport = new PurchaseOrderReport();
                purchOrderReport.setItemCategory(rs.getString("name"));
                purchOrderReport.setTotalQty(rs.getDouble("qty"));
                purchOrderReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcPurchaseOrder.getGroupBy()==SrcPurchaseOrderReport.GROUP_TRANSAKSI){
                    purchOrderReport.setPurchNumber(rs.getString("number"));
                }else{
                    purchOrderReport.setPurchNumber("");
                }
 
                list.add(purchOrderReport);
            }   
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOBySubCategory(SrcPurchaseOrderReport srcPurchaseOrder) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_purchase_item` as pi " +
                    "inner join pos_purchase p on pi.purchase_id=p.purchase_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";

            String where = "";
            if(srcPurchaseOrder.getVendorId()!=0){
                where = "p.vendor_id="+srcPurchaseOrder.getVendorId();
            }

            if(srcPurchaseOrder.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.location_id="+srcPurchaseOrder.getLocationId();
                }else{
                    where = "p.location_id="+srcPurchaseOrder.getLocationId();
                }
            }

            if(srcPurchaseOrder.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.purch_date between '"+JSPFormater.formatDate(srcPurchaseOrder.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcPurchaseOrder.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.purch_date between '"+JSPFormater.formatDate(srcPurchaseOrder.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcPurchaseOrder.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcPurchaseOrder.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcPurchaseOrder.getStatus()+"'";
                }else{
                    where = "p.status='"+srcPurchaseOrder.getStatus()+"'";
                }
            }

            if(srcPurchaseOrder.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcPurchaseOrder.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcPurchaseOrder.getItemCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";  

            switch(srcPurchaseOrder.getGroupBy()){
                case SrcPurchaseOrderReport.GROUP_TRANSAKSI:
                    sql = sql + "p.purchase_id ";
                    break;
                case SrcPurchaseOrderReport.GROUP_SUB_CATEGORY:
                    sql = sql + "ic.item_category_id ";
                    break;   
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PurchaseOrderReport purchOrderReport = new PurchaseOrderReport();
                purchOrderReport.setItemCategory(rs.getString("name"));
                purchOrderReport.setTotalQty(rs.getDouble("qty"));
                purchOrderReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcPurchaseOrder.getGroupBy()==SrcPurchaseOrderReport.GROUP_TRANSAKSI){
                    purchOrderReport.setPurchNumber(rs.getString("number"));
                }else{
                    purchOrderReport.setPurchNumber("");
                }

                list.add(purchOrderReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOByItem(SrcPurchaseOrderReport srcPurchaseOrder) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            if(srcPurchaseOrder.getGroupBy()==SrcPurchaseOrderReport.GROUP_TRANSAKSI){
              sql = "SELECT pi.qty, im.code, im.barcode, im.name, p.number, p.vendor_id, " +
                    "pi.total_amount, pi.amount " +
                    "FROM `pos_purchase_item` as pi " +
                    "inner join pos_purchase p on pi.purchase_id=p.purchase_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }else{
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_purchase_item` as pi " +
                    "inner join pos_purchase p on pi.purchase_id=p.purchase_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }

            String where = "";
            if(srcPurchaseOrder.getVendorId()!=0){
                where = "p.vendor_id="+srcPurchaseOrder.getVendorId();
            }

            if(srcPurchaseOrder.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.location_id="+srcPurchaseOrder.getLocationId();
                }else{
                    where = "p.location_id="+srcPurchaseOrder.getLocationId();
                }
            }

            if(srcPurchaseOrder.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.purch_date between '"+JSPFormater.formatDate(srcPurchaseOrder.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcPurchaseOrder.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.purch_date between '"+JSPFormater.formatDate(srcPurchaseOrder.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcPurchaseOrder.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcPurchaseOrder.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcPurchaseOrder.getStatus()+"'";
                }else{
                    where = "p.status='"+srcPurchaseOrder.getStatus()+"'";
                }
            }

            if(srcPurchaseOrder.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcPurchaseOrder.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcPurchaseOrder.getItemCategoryId();
                }
            }

            if(srcPurchaseOrder.getItemSubCategoryId()!=0){ 
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcPurchaseOrder.getItemSubCategoryId();
                }else{
                    where = "im.item_category_id="+srcPurchaseOrder.getItemSubCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;
            
            /*
            sql = sql + " group by ";

            switch(srcPurchaseOrder.getGroupBy()){
                case SrcPurchaseOrderReport.GROUP_TRANSAKSI:
                    sql = sql + "p.purchase_id ";
                    break;
                case SrcPurchaseOrderReport.GROUP_ITEM:
                    sql = sql + "im.item_master_id ";
                    break;
            }
             */
            
            if(srcPurchaseOrder.getGroupBy()==SrcPurchaseOrderReport.GROUP_ITEM){
                sql = sql + "group by im.item_master_id ";
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PurchaseOrderReport purchOrderReport = new PurchaseOrderReport();
                purchOrderReport.setItemCode(rs.getString("code"));
                purchOrderReport.setItemName(rs.getString("name"));
                purchOrderReport.setTotalQty(rs.getDouble("qty"));
                purchOrderReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcPurchaseOrder.getGroupBy()==SrcPurchaseOrderReport.GROUP_TRANSAKSI){
                    purchOrderReport.setPurchNumber(rs.getString("number"));
                }else{
                    purchOrderReport.setPurchNumber("");
                }

                list.add(purchOrderReport);
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
