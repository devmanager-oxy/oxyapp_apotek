/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.general.DbLocation;
import com.project.general.DbVendor; 
import com.project.general.Location;
import com.project.general.Vendor;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Adnyana Eka Yasa
 */
public class SessReceiveReport {

    public static Vector getReceiveReport(SrcReceiveReport srcReceiveReport) {
        Vector list = new Vector();
        switch (srcReceiveReport.getTypeReport()) {
            case SrcReceiveReport.GROUP_BY_SUPPLIER:
                list = getPOBySupplier(srcReceiveReport);
                break;
            case SrcReceiveReport.GROUP_BY_SUB_CATEGORY:
                list = getPOBySubCategory(srcReceiveReport);
                break;
            case SrcReceiveReport.GROUP_BY_CATEGORY:
                list = getPOByCategory(srcReceiveReport);
                break;
            case SrcReceiveReport.GROUP_BY_ITEM:
                list = getPOByItem(srcReceiveReport);
                break;
        }
        return list;
    }

     public static Vector getReceiveReport(SrcReceiveReport srcReceiveReport, int type, int limitStart, int recordToGet) {
        Vector list = new Vector();
        switch (srcReceiveReport.getTypeReport()) {
            case SrcReceiveReport.GROUP_BY_SUPPLIER:
                //list = getPOBySupplier(srcReceiveReport, type, limitStart, recordToGet);
                break;
            case SrcReceiveReport.GROUP_BY_SUB_CATEGORY:
                //list = getTransferBySubCategory(srcReceiveReport, type);
                break;
            case SrcReceiveReport.GROUP_BY_CATEGORY:
                //list = getPOByCategory(srcReceiveReport, type);
                break;
            case SrcReceiveReport.GROUP_BY_ITEM:
                list = getPOByItem(srcReceiveReport, type, limitStart, recordToGet);
                break;
            case SrcReceiveReport.GROUP_BY_TRANSAKSI:
                list = getReceiveByTransaksi(srcReceiveReport, type, limitStart, recordToGet);
                break;     
            
        }
        return list;
    }
     
     public static Vector getPOByItem(SrcReceiveReport srcReceiveReport, int type, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            if(recordToGet==0){
                recordToGet=20;
            }
            String sql = "";
            if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_TRANSAKSI){
              sql = "SELECT pi.qty, im.code, im.barcode, im.name, p.number, " +
                    "pi.amount, p.location_id " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }else{
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, " +
                    "sum(pi.amount) as amount, p.location_id " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }

            String where = "";
            if(srcReceiveReport.getLocationId()!=0){
                where = " p.location_id="+srcReceiveReport.getLocationId();
            }
            

            if(srcReceiveReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = " p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReceiveReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReceiveReport.getStatus()+"'";
                }else{
                    where = " p.status='"+srcReceiveReport.getStatus()+"'";
                }
            }

            if(srcReceiveReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcReceiveReport.getItemCategoryId();
                }else{
                    where = " im.item_group_id="+srcReceiveReport.getItemCategoryId();
                }
            }
            if(srcReceiveReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcReceiveReport.getCode()+"%'";
                }else{
                    where = " im.code='"+srcReceiveReport.getCode()+"'";
                }
            }
            
            if(srcReceiveReport.getItemName().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcReceiveReport.getItemName()+"%'";
                }else{
                    where = " im.name='"+srcReceiveReport.getItemName()+"'";
                }
            }

            if(srcReceiveReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcReceiveReport.getItemSubCategoryId();
                }else{
                    where = " im.item_category_id="+srcReceiveReport.getItemSubCategoryId();
                }
            }
            //if(where.length()>0){
            //    where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
            //}else{
             //   where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
            //}
            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            /*
            sql = sql + " group by ";

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "p.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_ITEM:
                    sql = sql + "im.item_master_id ";
                    break;
            }
             */
            
            if(srcReceiveReport.getGroupBy()==srcReceiveReport.GROUP_ITEM){
                sql = sql + " group by im.item_master_id ";
            }

            if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
            }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
            }
            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReceiveReport receiveReport = new ReceiveReport();
                receiveReport.setItemCode(rs.getString("code"));
                receiveReport.setItemName(rs.getString("name"));
                receiveReport.setTotalQty(rs.getDouble("qty"));
                receiveReport.setPurchAmount(rs.getDouble("amount"));
                Location loc= DbLocation.fetchExc(rs.getLong("location_id"));
                receiveReport.setLocationName(loc.getName());
                
                if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_TRANSAKSI){
                    receiveReport.setPurchNumber(rs.getString("number"));
                }else{
                    receiveReport.setPurchNumber(""); 
                }

                list.add(receiveReport);
            } 
        } catch (Exception e){
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    
    public static Vector getPOBySupplier(SrcReceiveReport srcReceiveReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector(); 
        try {
            String sql = "SELECT number, count(receive_id) as cnt, vendor_id, sum(total_amount) as total_amount " +
                    "FROM `pos_receive` ";

            String where = "";
            if(srcReceiveReport.getVendorId()!=0){
                where = "vendor_id="+srcReceiveReport.getVendorId();
            }

            if(srcReceiveReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and location_id="+srcReceiveReport.getLocationId();
                }else{
                    where = "location_id="+srcReceiveReport.getLocationId();
                }
            }

            if(srcReceiveReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReceiveReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and status='"+srcReceiveReport.getStatus()+"'";
                }else{
                    where = "status='"+srcReceiveReport.getStatus()+"'";
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcReceiveReport.getGroupBy()){
                case SrcReceiveReport.GROUP_TRANSAKSI:
                    sql = sql + "receive_id ";   
                    break;
                case SrcReceiveReport.GROUP_SUPPLIER:
                    sql = sql + "vendor_id ";
                    break;
            }

            System.out.println("SQL : " + sql); 
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                ReceiveReport receiveReport = new ReceiveReport();
                switch(srcReceiveReport.getGroupBy()){
                    case SrcReceiveReport.GROUP_TRANSAKSI:
                        receiveReport.setPurchNumber(rs.getString("number"));
                        break;
                    case SrcReceiveReport.GROUP_SUPPLIER:
                        receiveReport.setPurchNumber(""+rs.getInt("cnt"));
                        break;
                }

                receiveReport.setPurchAmount(rs.getDouble("total_amount"));
                
                //long vendorOid = rs.getLong("vendor_id");
                receiveReport.setVendorId(rs.getLong("vendor_id")); 
                /*
                Vendor vendor = new Vendor();
                try {
                    vendor = DbVendor.fetchExc(vendorOid);
                } catch (Exception ex) {
                    System.out.println("Err >>> : " + ex.toString());
                }
                receiveReport.setVendorName(vendor.getName());
                 */

                list.add(receiveReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOByCategory(SrcReceiveReport srcReceiveReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_group as ic on im.item_group_id=ic.item_group_id ";

            String where = "";
            if(srcReceiveReport.getVendorId()!=0){
                where = "p.vendor_id="+srcReceiveReport.getVendorId();
            }

            if(srcReceiveReport.getLocationId()!=0){
                if(where.length()>0){ 
                    where = where + " and p.location_id="+srcReceiveReport.getLocationId();
                }else{
                    where = "p.location_id="+srcReceiveReport.getLocationId();
                }
            }

            if(srcReceiveReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReceiveReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReceiveReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcReceiveReport.getStatus()+"'";
                }
            }

            if(srcReceiveReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcReceiveReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcReceiveReport.getItemCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcReceiveReport.getGroupBy()){
                case SrcReceiveReport.GROUP_TRANSAKSI:
                    sql = sql + "p.receive_id ";
                    break;
                case SrcReceiveReport.GROUP_CATEGORY:
                    sql = sql + "ic.item_group_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReceiveReport receiveReport = new ReceiveReport();
                receiveReport.setItemCategory(rs.getString("name"));
                receiveReport.setTotalQty(rs.getDouble("qty"));
                receiveReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_TRANSAKSI){
                    receiveReport.setPurchNumber(rs.getString("number"));
                }else{
                    receiveReport.setPurchNumber("");
                }
 
                list.add(receiveReport);
            }   
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOBySubCategory(SrcReceiveReport srcReceiveReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";

            String where = "";
            if(srcReceiveReport.getVendorId()!=0){
                where = "p.vendor_id="+srcReceiveReport.getVendorId();
            }

            if(srcReceiveReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.location_id="+srcReceiveReport.getLocationId();
                }else{
                    where = "p.location_id="+srcReceiveReport.getLocationId();
                }
            }

            if(srcReceiveReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReceiveReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReceiveReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcReceiveReport.getStatus()+"'";
                }
            }

            if(srcReceiveReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcReceiveReport.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcReceiveReport.getItemCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";  

            switch(srcReceiveReport.getGroupBy()){
                case SrcReceiveReport.GROUP_TRANSAKSI:
                    sql = sql + "p.receive_id ";
                    break;
                case SrcReceiveReport.GROUP_SUB_CATEGORY:
                    sql = sql + "ic.item_category_id ";
                    break;   
            } 

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                ReceiveReport receiveReport = new ReceiveReport();
                receiveReport.setItemCategory(rs.getString("name"));
                receiveReport.setTotalQty(rs.getDouble("qty"));
                receiveReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_TRANSAKSI){
                    receiveReport.setPurchNumber(rs.getString("number"));
                }else{
                    receiveReport.setPurchNumber("");
                }

                list.add(receiveReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }

    public static Vector getPOByItem(SrcReceiveReport srcReceiveReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_TRANSAKSI){
              sql = "SELECT pi.qty, im.code, im.barcode, im.name, p.number, p.vendor_id, " +
                    "pi.total_amount, pi.amount " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }else{
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, p.vendor_id, " +
                    "sum(pi.total_amount) as total_amount, pi.amount " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }

            String where = "";
            if(srcReceiveReport.getVendorId()!=0){
                where = "p.vendor_id="+srcReceiveReport.getVendorId();
            }

            if(srcReceiveReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.location_id="+srcReceiveReport.getLocationId();
                }else{
                    where = "p.location_id="+srcReceiveReport.getLocationId();
                }
            }

            if(srcReceiveReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReceiveReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReceiveReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcReceiveReport.getStatus()+"'";
                }
            }

            if(srcReceiveReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcReceiveReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcReceiveReport.getItemCategoryId();
                }
            }

            if(srcReceiveReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcReceiveReport.getItemSubCategoryId();
                }else{
                    where = "im.item_category_id="+srcReceiveReport.getItemSubCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            //sql = sql + " group by ";

            /*
            switch(srcReceiveReport.getGroupBy()){
                case SrcReceiveReport.GROUP_TRANSAKSI:
                    sql = sql + "p.receive_id ";
                    break;
                case SrcReceiveReport.GROUP_ITEM:
                    sql = sql + "im.item_master_id ";
                    break;
            }
             */
            
            if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_ITEM){
                sql = sql + "group by im.item_master_id ";
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReceiveReport receiveReport = new ReceiveReport();
                receiveReport.setItemCode(rs.getString("code"));
                receiveReport.setItemName(rs.getString("name"));
                receiveReport.setTotalQty(rs.getDouble("qty"));
                receiveReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_TRANSAKSI){
                    receiveReport.setPurchNumber(rs.getString("number"));
                }else{
                    receiveReport.setPurchNumber("");
                }

                list.add(receiveReport); 
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        
        finally{
            CONResultSet.close(dbrs);
        }
        
        return list;
    }
    
    public static int getReceiveItemCount(SrcReceiveReport srcReceiveReport) {
        CONResultSet dbrs = null;
        int total=0;
        try {
            
            String sql = "";
            sql = "SELECT count(pi.receive_item_id) " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            
            String where = "";
            if(srcReceiveReport.getLocationId()!=0){
                where = " p.location_id="+srcReceiveReport.getLocationId();
            }

            

            if(srcReceiveReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReceiveReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReceiveReport.getStatus()+"'";
                }else{
                    where = " p.status='"+srcReceiveReport.getStatus()+"'";
                }
            }

            if(srcReceiveReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcReceiveReport.getItemCategoryId();
                }else{
                    where = " im.item_group_id="+srcReceiveReport.getItemCategoryId();
                }
            }
             if(srcReceiveReport.getVendorId()!=0){
                if(where.length()>0){
                    where = where + " and p.vendor_id="+srcReceiveReport.getVendorId();
                }else{
                    where = " p.vendor_id="+srcReceiveReport.getVendorId();
                }
            }
            
            if(srcReceiveReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcReceiveReport.getCode()+"%'";
                }else{
                    where = " im.code='"+srcReceiveReport.getCode()+"'";
                }
            }
            
            if(srcReceiveReport.getItemName().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcReceiveReport.getItemName()+"%'";
                }else{
                    where = " im.name='"+srcReceiveReport.getItemName()+"'";
                }
            }

            if(srcReceiveReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcReceiveReport.getItemSubCategoryId();
                }else{
                    where = " im.item_category_id="+srcReceiveReport.getItemSubCategoryId();
                }
            }
            
            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            /*
            sql = sql + " group by ";

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "p.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_ITEM:
                    sql = sql + "im.item_master_id ";
                    break;
            }
             */
            
            if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_ITEM){
                sql = sql + " group by im.item_master_id ";
            }
            if(srcReceiveReport.getGroupBy()==SrcReceiveReport.GROUP_TRANSAKSI){
                sql = sql + " group by im.item_master_id ";
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total= total + 1 ;
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return total;
    }
    
    public static Vector getReceiveByTransaksi(SrcReceiveReport srcReceiveReport, int type, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {   
            String sql = "SELECT p.receive_id, sum(pi.qty) as qty, ic.name, p.number, " +
                    "sum(pi.total_amount) as total_amount, pi.amount, p.location_id, p.date, v.name as nama_vendor " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id " + 
                    "inner join vendor v on p.vendor_id=v.vendor_id ";

            String where = "";
            

            if(srcReceiveReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.location_id="+srcReceiveReport.getLocationId();
                }else{
                    where = "p.location_id="+srcReceiveReport.getLocationId();
                }
            }

            if(srcReceiveReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReceiveReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReceiveReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcReceiveReport.getStatus()+"'";
                }
            }

            if(srcReceiveReport.getNumber().length()>0){
                if(where.length()>0){
                    where = where + " and p.number like '%"+srcReceiveReport.getNumber()+"%'";
                }else{
                    where = "p.number like '%"+srcReceiveReport.getNumber()+"%'";
                }
            }
            if(srcReceiveReport.getVendorId()!=0){
                if(where.length()>0){
                    where = where + " and p.vendor_id="+srcReceiveReport.getVendorId();
                }else{
                    where = "p.vendor_id="+srcReceiveReport.getVendorId();
                }
            }
                
            if(srcReceiveReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcReceiveReport.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcReceiveReport.getItemCategoryId();
                }
            }
            if(where.length()> 0){
                where = where + " and p." + DbReceive.colNames[DbReceive.COL_TYPE_AP] + "=0"; 
            }else{
                where = "p." + DbReceive.colNames[DbReceive.COL_TYPE_AP] + "=0" ; 
            }
            
            if(where.length()>0){
                where = " where "+where;
            }
            
            
            
            sql = sql + where;

            sql = sql + " group by p.receive_id ";  

            sql = sql + " order by p.date, p.number"; 
            
            if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
                }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
            }
            
            System.out.println("SQL : " + sql);
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                ReceiveReport receiveReport = new ReceiveReport();
                receiveReport.setOID(rs.getLong("receive_id"));
                receiveReport.setItemCategory(rs.getString("name"));
                receiveReport.setTotalQty(rs.getDouble("qty"));
                receiveReport.setPurchAmount(rs.getDouble("total_amount"));
                receiveReport.setVendorName(rs.getString("nama_vendor"));
                Location loc = new Location();
                try{
                    
                    loc = DbLocation.fetchExc(rs.getLong("location_id"));
                    receiveReport.setLocationName(loc.getName());
                }catch(Exception ex){
                    
                }
                //if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                receiveReport.setPurchNumber(rs.getString("number"));
                receiveReport.setDate(rs.getDate("date"))    ;
                //}else{
                //    transferReport.setPurchNumber("");
                //}

                list.add(receiveReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    public static int getCountReceiveByTransaksi(SrcReceiveReport srcReceiveReport) {
        CONResultSet dbrs = null;
        int tot=0;
        try {   
            String sql = "SELECT count(distinct p.receive_id) as tot " +
                    "FROM `pos_receive_item` as pi " +
                    "inner join pos_receive p on pi.receive_id=p.receive_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";

            String where = "";
            

            if(srcReceiveReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.location_id="+srcReceiveReport.getLocationId();
                }else{
                    where = "p.location_id="+srcReceiveReport.getLocationId();
                }
            }

            if(srcReceiveReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcReceiveReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcReceiveReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcReceiveReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcReceiveReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcReceiveReport.getStatus()+"'";
                }
            }

            if(srcReceiveReport.getNumber().length()>0){
                if(where.length()>0){
                    where = where + " and p.number like '%"+srcReceiveReport.getNumber()+"%'";
                }else{
                    where = "p.number like '%"+srcReceiveReport.getNumber()+"%'";
                }
            }
            if(srcReceiveReport.getVendorId()!=0){
                if(where.length()>0){
                    where = where + " and p.vendor_id="+srcReceiveReport.getVendorId();
                }else{
                    where = "p.vendor_id="+srcReceiveReport.getVendorId();
                }
            }
                
            if(srcReceiveReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcReceiveReport.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcReceiveReport.getItemCategoryId();
                }
            }
            if(where.length()> 0){
                where = where + " and p." + DbReceive.colNames[DbReceive.COL_TYPE_AP] + "=0"; 
            }else{
                where = "p." + DbReceive.colNames[DbReceive.COL_TYPE_AP] + "=0" ; 
            }
            
            if(where.length()>0){
                where = " where "+where;
            }
            
            
            
            sql = sql + where;

                                  
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                tot=rs.getInt("tot");
                return tot;
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return tot;
    }
    
    public static Vector getReceiveMainData(Date startDate, Date endDate, SrcReceiveReport srcReceiveReport, int order){
            String sql;
            
                sql = "select po.receive_id, po.date, po.number, v.name as vendor, po.total_amount, po.total_tax, po.discount_total, po.status, p.name as lokasi from pos_receive po "+
                        " inner join vendor " +
                        " v on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"=po.vendor_id "+
                        " inner join pos_location p on po.location_id=p.location_id "+
                        " where number like 'IN%' and po.type_ap=0 " ;
                        if(srcReceiveReport.getIgnoreDate()==0){
                            sql = sql + " and po.date "+ 
                                " between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+" 00:00:00'"+
                                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+" 23:59:59' ";
                        }
                        if(srcReceiveReport.getLocationId() != 0){
                            sql = sql + " and po.location_id=" +  srcReceiveReport.getLocationId();
                        }
                        if(srcReceiveReport.getVendorId() != 0){
                            sql = sql + " and po.vendor_id=" +  srcReceiveReport.getVendorId();
                        }
                        if(srcReceiveReport.getStatus().length()> 0 && srcReceiveReport.getStatus()!=null ){
                            sql = sql + " and po.status='" +  srcReceiveReport.getStatus() + "'";
                        }
                                                   
                        if(order==0){
                            sql = sql + " order by v."+DbVendor.colNames[DbVendor.COL_NAME];
                        }
                        else{
                            sql = sql + " order by po.date";
                        }
                        
                        System.out.println(sql);
                                                
            CONResultSet crs = null;
            Vector result = new Vector();
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Vector vDetail = new Vector();
                    vDetail.add(rs.getLong("receive_id"));
                    vDetail.add("" + JSPFormater.formatDate(rs.getDate("date"), "dd/MM/yyyy"));
                    vDetail.add(rs.getString("number"));
                    vDetail.add(rs.getString("vendor"));
                    vDetail.add(rs.getDouble("total_amount"));
                    vDetail.add(rs.getDouble("total_tax"));
                    vDetail.add(rs.getDouble("discount_total"));
                    vDetail.add(rs.getString("status"));
                    vDetail.add(rs.getString("lokasi"));
                    
                    result.add(vDetail);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                        
        }
      


}
