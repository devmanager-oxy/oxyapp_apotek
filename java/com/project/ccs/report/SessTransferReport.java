/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.ccs.postransaction.transfer.DbTransfer;
import com.project.general.DbVendor; 
import com.project.general.Vendor;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.sql.ResultSet;
import java.util.Vector;
import com.project.general.DbLocation;
import com.project.general.Location;

/**
 *
 * @author Adnyana Eka Yasa
 */
public class SessTransferReport {

    public static Vector getTransferReport(SrcTransferReport srcTransferReport) {
        Vector list = new Vector();
        switch (srcTransferReport.getTypeReport()) {
            case SrcTransferReport.GROUP_BY_SUPPLIER:
               // list = getPOBySupplier(srcTransferReport);
                break;
            case SrcTransferReport.GROUP_BY_SUB_CATEGORY:
                list = getTransferBySubCategory(srcTransferReport);
                break;
            case SrcTransferReport.GROUP_BY_CATEGORY:
                list = getPOByCategory(srcTransferReport);
                break;
            case SrcTransferReport.GROUP_BY_ITEM:
                list = getPOByItem(srcTransferReport);
                break;
            case SrcTransferReport.GROUP_BY_LOCATION:
                list = getTransferByLocation(srcTransferReport);
                break; 
        }
        return list;
    }
    public static Vector getTransferReport(SrcTransferReport srcTransferReport, int type) {
        Vector list = new Vector();
        switch (srcTransferReport.getTypeReport()) {
            case SrcTransferReport.GROUP_BY_SUPPLIER:
                //list = getPOBySupplier(srcTransferReport);
                break;
            case SrcTransferReport.GROUP_BY_SUB_CATEGORY:
                list = getTransferBySubCategory(srcTransferReport, type);
                break;
            case SrcTransferReport.GROUP_BY_CATEGORY:
                list = getPOByCategory(srcTransferReport, type);
                break;
            case SrcTransferReport.GROUP_BY_ITEM:
                list = getPOByItem(srcTransferReport, type);
                break;
            case SrcTransferReport.GROUP_BY_LOCATION:
                list = getTransferByLocation(srcTransferReport, type);
                break; 
        }
        return list;
    }
    public static Vector getTransferReport(SrcTransferReport srcTransferReport, int type, int limitStart, int recordToGet) {
        Vector list = new Vector();
        switch (srcTransferReport.getTypeReport()) {
            case SrcTransferReport.GROUP_BY_SUPPLIER:
                list = getPOBySupplier(srcTransferReport, type, limitStart, recordToGet);
                break;
            case SrcTransferReport.GROUP_BY_SUB_CATEGORY:
                list = getTransferBySubCategory(srcTransferReport, type);
                break;
            case SrcTransferReport.GROUP_BY_CATEGORY:
                list = getPOByCategory(srcTransferReport, type);
                break;
            case SrcTransferReport.GROUP_BY_ITEM:
                list = getPOByItem(srcTransferReport, type, limitStart, recordToGet);
                break;
            case SrcTransferReport.GROUP_BY_LOCATION:
                list = getTransferByLocation(srcTransferReport, type);
                break; 
            case SrcTransferReport.GROUP_BY_TRANSAKSI:
                list = getTransferByTransaksi(srcTransferReport, type, limitStart, recordToGet);
                break; 
        }
        return list;
    }

    
    
    public static Vector getPOBySupplier(SrcTransferReport srcTransferReport, int type, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
              sql = "SELECT pi.qty, im.code, im.barcode, im.name, p.number, " +
                    "pi.amount, pi.price, p.from_location_id, p.to_location_id, v.vendor_id " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_vendor_item v on pi.item_master_id = v.item_master_id  " ;
            }else{
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, " +
                    "sum(pi.amount) as amount, pi.price, p.from_location_id, p.to_location_id, v.vendor_id " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_vendor_item v on pi.item_master_id = v.item_master_id " ;
            }

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }
            
            if(srcTransferReport.getVendorId()!=0){
                if(where.length()>0){
                    where = where + " and v.vendor_id="+srcTransferReport.getVendorId();
                }else{
                    where = "v.vendor_id="+srcTransferReport.getVendorId();
                }
            }
            
            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcTransferReport.getItemCategoryId();
                }
            }
            if(srcTransferReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcTransferReport.getCode()+"%'";
                }else{
                    where = "im.code='"+srcTransferReport.getCode()+"'";
                }
            }
            
            if(srcTransferReport.getItem_name().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcTransferReport.getItem_name()+"%'";
                }else{
                    where = "im.name='"+srcTransferReport.getItem_name()+"'";
                }
            }

            if(srcTransferReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemSubCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemSubCategoryId();
                }
            }
            if(where.length()>0){
                where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
            }else{
                where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
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
            
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_ITEM){
                sql = sql + "group by im.item_master_id ";
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
                TransferReport transferReport = new TransferReport();
                transferReport.setItemCode(rs.getString("code"));
                transferReport.setItemName(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("amount"));
                transferReport.setVendorId(rs.getLong("vendor_id"));
                Location loc= DbLocation.fetchExc(rs.getLong("from_location_id"));
                    transferReport.setLocationName(loc.getName());
                loc = DbLocation.fetchExc(rs.getLong("to_location_id"));
                    transferReport.setLocationToName(loc.getName());
                if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                    transferReport.setPurchNumber(rs.getString("number"));
                }else{
                    transferReport.setPurchNumber(""); 
                }

                list.add(transferReport);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }

    public static Vector getTransferByLocation(SrcTransferReport srcTransferReport, int type) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT number, count(transfer_id) as cnt, from_location_id, to_location_id  " +
                    "FROM `pos_transfer` as pt inner join pos_location as pl " +
                    "on pt.from_location_id=pl.location_id ";

            String where = ""; 
            if(srcTransferReport.getLocationToId()!=0){
                where = "pt.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){  
                    where = where + " and pt.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "pt.from_location_id="+srcTransferReport.getLocationId();
                }
            }
  
            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and pt.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "pt.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and pt.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "pt.status='"+srcTransferReport.getStatus()+"'";
                }
            }
                if(where.length()>0){
                    where = where + " and pt." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type;
                }else{
                    where = "pt." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type;
                }
                    
            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "pt.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_LOCATION:
                    sql = sql + "pt.from_location_id ";
                    break;
                case SrcTransferReport.GROUP_TO_LOCATION:
                    sql = sql + "pt.to_location_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TransferReport transferReport = new TransferReport();
                switch(srcTransferReport.getGroupBy()){
                    case SrcTransferReport.GROUP_TRANSAKSI:
                        transferReport.setPurchNumber(rs.getString("number"));
                        break;
                    case SrcTransferReport.GROUP_LOCATION:
                        transferReport.setPurchNumber(""+rs.getInt("cnt"));
                        break;
                    case SrcTransferReport.GROUP_TO_LOCATION:
                        transferReport.setPurchNumber(""+rs.getInt("cnt"));
                        break;
                } 

                // transferReport.setPurchAmount(rs.getDouble("total_amount"));
                long fromLocationOid = rs.getLong("from_location_id");
                long ToLocationOid = rs.getLong("to_location_id");

                Location location = new Location();
                try {
                    location = DbLocation.fetchExc(fromLocationOid);

                } catch (Exception ex) {
                    System.out.println("Err >>> : " + ex.toString());
                }
                transferReport.setLocationName(location.getName());

                // location to
                Location toLocation = new Location();
                try {
                    toLocation = DbLocation.fetchExc(ToLocationOid);

                } catch (Exception ex) {
                    System.out.println("Err >>> : " + ex.toString());
                }
                transferReport.setLocationToName(toLocation.getName());

                list.add(transferReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    public static Vector getTransferByLocation(SrcTransferReport srcTransferReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT number, count(transfer_id) as cnt, from_location_id, to_location_id  " +
                    "FROM `pos_transfer` as pt inner join pos_location as pl " +
                    "on pt.from_location_id=pl.location_id ";

            String where = ""; 
            if(srcTransferReport.getLocationToId()!=0){
                where = "pt.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){  
                    where = where + " and pt.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "pt.from_location_id="+srcTransferReport.getLocationId();
                }
            }
  
            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and pt.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "pt.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and pt.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "pt.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "pt.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_LOCATION:
                    sql = sql + "pt.from_location_id ";
                    break;
                case SrcTransferReport.GROUP_TO_LOCATION:
                    sql = sql + "pt.to_location_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TransferReport transferReport = new TransferReport();
                switch(srcTransferReport.getGroupBy()){
                    case SrcTransferReport.GROUP_TRANSAKSI:
                        transferReport.setPurchNumber(rs.getString("number"));
                        break;
                    case SrcTransferReport.GROUP_LOCATION:
                        transferReport.setPurchNumber(""+rs.getInt("cnt"));
                        break;
                    case SrcTransferReport.GROUP_TO_LOCATION:
                        transferReport.setPurchNumber(""+rs.getInt("cnt"));
                        break;
                } 

                // transferReport.setPurchAmount(rs.getDouble("total_amount"));
                long fromLocationOid = rs.getLong("from_location_id");
                long ToLocationOid = rs.getLong("to_location_id");

                Location location = new Location();
                try {
                    location = DbLocation.fetchExc(fromLocationOid);

                } catch (Exception ex) {
                    System.out.println("Err >>> : " + ex.toString());
                }
                transferReport.setLocationName(location.getName());

                // location to
                Location toLocation = new Location();
                try {
                    toLocation = DbLocation.fetchExc(ToLocationOid);

                } catch (Exception ex) {
                    System.out.println("Err >>> : " + ex.toString());
                }
                transferReport.setLocationToName(toLocation.getName());

                list.add(transferReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    public static Vector getPOByCategory(SrcTransferReport srcTransferReport, int type) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {   
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, " +
                    "sum(pi.amount) as total_amount, pi.price " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_group as ic on im.item_group_id=ic.item_group_id ";

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){ 
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcTransferReport.getItemCategoryId();
                }
            }
            if(where.length()>0){
                where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type ;
               
            }else{
                where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type ;
            }
            
            if(where.length()>0){
                where = " where "+where;
            }
            

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "p.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_CATEGORY:
                    sql = sql + "ic.item_group_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TransferReport transferReport = new TransferReport();
                transferReport.setItemCategory(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                    transferReport.setPurchNumber(rs.getString("number"));
                }else{
                    transferReport.setPurchNumber("");
                }
 
                list.add(transferReport);
            }   
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    public static Vector getPOByCategory(SrcTransferReport srcTransferReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {   
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, " +
                    "sum(pi.amount) as total_amount, pi.price " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_group as ic on im.item_group_id=ic.item_group_id ";

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){ 
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcTransferReport.getItemCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "p.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_CATEGORY:
                    sql = sql + "ic.item_group_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TransferReport transferReport = new TransferReport();
                transferReport.setItemCategory(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                    transferReport.setPurchNumber(rs.getString("number"));
                }else{
                    transferReport.setPurchNumber("");
                }
 
                list.add(transferReport);
            }   
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }

    public static Vector getTransferBySubCategory(SrcTransferReport srcTransferReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {   
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, " +
                    "sum(pi.amount) as total_amount, pi.amount " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemCategoryId();
                }
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            sql = sql + " group by ";  

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "p.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_SUB_CATEGORY:
                    sql = sql + "ic.item_category_id ";
                    break;   
            } 

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                TransferReport transferReport = new TransferReport();
                transferReport.setItemCategory(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                    transferReport.setPurchNumber(rs.getString("number"));
                }else{
                    transferReport.setPurchNumber("");
                }

                list.add(transferReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    public static Vector getTransferBySubCategory(SrcTransferReport srcTransferReport, int type) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {   
            String sql = "SELECT sum(pi.qty) as qty, ic.name, p.number, " +
                    "sum(pi.amount) as total_amount, pi.amount " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemCategoryId();
                }
            }
            if(where.length()> 0){
                where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type; 
            }else{
                where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type; 
            }
            
            if(where.length()>0){
                where = " where "+where;
            }
            
            
            
            sql = sql + where;

            sql = sql + " group by ";  

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "p.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_SUB_CATEGORY:
                    sql = sql + "ic.item_category_id ";
                    break;   
            } 

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                TransferReport transferReport = new TransferReport();
                transferReport.setItemCategory(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("total_amount"));

                if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                    transferReport.setPurchNumber(rs.getString("number"));
                    
                }else{
                    transferReport.setPurchNumber("");
                }

                list.add(transferReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    
    public static Vector getTransferByTransaksi(SrcTransferReport srcTransferReport, int type, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {   
            String sql = "SELECT p.transfer_id, sum(pi.qty) as qty, ic.name, p.number, " +
                    "sum(pi.amount) as total_amount, pi.amount, p.from_location_id, p.to_location_id, p.date " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getNumber().length()>0){
                if(where.length()>0){
                    where = where + " and p.number like '%"+srcTransferReport.getNumber()+"%'";
                }else{
                    where = "p.number like '%"+srcTransferReport.getNumber()+"%'";
                }
            }

                
            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemCategoryId();
                }
            }
            if(where.length()> 0){
                where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type; 
            }else{
                where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type; 
            }
            
            if(where.length()>0){
                where = " where "+where;
            }
            
            
            
            sql = sql + where;

            sql = sql + " group by p.transfer_id ";  

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
                TransferReport transferReport = new TransferReport();
                transferReport.setOID(rs.getLong("transfer_id"));
                transferReport.setItemCategory(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("total_amount"));
                Location loc = new Location();
                try{
                    loc = DbLocation.fetchExc(rs.getLong("from_location_id"));
                    transferReport.setLocationName(loc.getName());
                    loc = DbLocation.fetchExc(rs.getLong("to_location_id"));
                    transferReport.setLocationToName(loc.getName());
                }catch(Exception ex){
                    
                }
                //if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                transferReport.setPurchNumber(rs.getString("number"));
                transferReport.setDate(rs.getDate("date"))    ;
                //}else{
                //    transferReport.setPurchNumber("");
                //}

                list.add(transferReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    
    public static Vector getPOByItem(SrcTransferReport srcTransferReport, int type) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
              sql = "SELECT pi.qty, im.code, im.barcode, im.name, p.number, " +
                    "pi.amount, pi.price " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }else{
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, " +
                    "sum(pi.amount) as amount, pi.price " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcTransferReport.getItemCategoryId();
                }
            }
            if(srcTransferReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcTransferReport.getCode()+"%'";
                }else{
                    where = "im.code='"+srcTransferReport.getCode()+"'";
                }
            }
            
            if(srcTransferReport.getItem_name().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcTransferReport.getItem_name()+"%'";
                }else{
                    where = "im.name='"+srcTransferReport.getItem_name()+"'";
                }
            }

            if(srcTransferReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemSubCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemSubCategoryId();
                }
            }
            if(where.length()>0){
                where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
            }else{
                where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
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
            
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_ITEM){
                sql = sql + "group by im.item_master_id ";
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TransferReport transferReport = new TransferReport();
                transferReport.setItemCode(rs.getString("code"));
                transferReport.setItemName(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("amount"));

                if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                    transferReport.setPurchNumber(rs.getString("number"));
                }else{
                    transferReport.setPurchNumber(""); 
                }

                list.add(transferReport);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    public static int getTransferItemCount(SrcTransferReport srcTransferReport) {
        CONResultSet dbrs = null;
        int total=0;
        try {
            
            String sql = "";
            sql = "SELECT count(pi.transfer_item_id) " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            
            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcTransferReport.getItemCategoryId();
                }
            }
            if(srcTransferReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcTransferReport.getCode()+"%'";
                }else{
                    where = "im.code='"+srcTransferReport.getCode()+"'";
                }
            }
            
            if(srcTransferReport.getItem_name().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcTransferReport.getItem_name()+"%'";
                }else{
                    where = "im.name='"+srcTransferReport.getItem_name()+"'";
                }
            }

            if(srcTransferReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemSubCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemSubCategoryId();
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
            
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_ITEM){
                sql = sql + "group by im.item_master_id ";
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total=rs.getInt(1);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return total;
    }
    
    public static int getTransferCount(SrcTransferReport srcTransferReport) {
        CONResultSet dbrs = null;
        int total=0;
        try {
            
            String sql = "";
            //sql = "SELECT count(p.transfer_id) " +
            //        "FROM `pos_transfer` as p " ;
            sql = "SELECT count(distinct p.transfer_id) " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";        
            
            String where = "p.type=0";
            if(srcTransferReport.getLocationToId()!=0){
                where = where+" and p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getNumber().length()>0){
                if(where.length()>0){
                    where = where + " and p.number like '%"+srcTransferReport.getNumber()+"%'";
                }else{
                    where = "p.number like '%"+srcTransferReport.getNumber()+"%'";
                }
            }
                   
            
            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;
           
            System.out.println("SQL : " + sql);
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total=rs.getInt(1);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return total;
    }
    
    
    
    
    public static Vector getPOByItem(SrcTransferReport srcTransferReport, int type, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
              sql = "SELECT pi.qty, im.code, im.barcode, im.name, p.number, " +
                    "pi.amount, pi.price, p.from_location_id, p.to_location_id " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }else{
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, " +
                    "sum(pi.amount) as amount, pi.price, p.from_location_id, p.to_location_id " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcTransferReport.getItemCategoryId();
                }
            }
            if(srcTransferReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcTransferReport.getCode()+"%'";
                }else{
                    where = "im.code='"+srcTransferReport.getCode()+"'";
                }
            }
            
            if(srcTransferReport.getItem_name().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcTransferReport.getItem_name()+"%'";
                }else{
                    where = "im.name='"+srcTransferReport.getItem_name()+"'";
                }
            }

            if(srcTransferReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemSubCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemSubCategoryId();
                }
            }
            if(where.length()>0){
                where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
            }else{
                where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
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
            
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_ITEM){
                sql = sql + "group by im.item_master_id ";
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
                TransferReport transferReport = new TransferReport();
                transferReport.setItemCode(rs.getString("code"));
                transferReport.setItemName(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("amount"));
                Location loc= DbLocation.fetchExc(rs.getLong("from_location_id"));
                    transferReport.setLocationName(loc.getName());
                loc = DbLocation.fetchExc(rs.getLong("to_location_id"));
                    transferReport.setLocationToName(loc.getName());
                if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                    transferReport.setPurchNumber(rs.getString("number"));
                }else{
                    transferReport.setPurchNumber(""); 
                }

                list.add(transferReport);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    
    
    public static Vector getPOByItem(SrcTransferReport srcTransferReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
              sql = "SELECT pi.qty, im.code, im.barcode, im.name, p.number, " +
                    "pi.amount, pi.price " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }else{
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, " +
                    "sum(pi.amount) as amount, pi.price " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            }

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcTransferReport.getItemCategoryId();
                }
            }

            if(srcTransferReport.getItemSubCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemSubCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemSubCategoryId();
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
            
            if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_ITEM){
                sql = sql + "group by im.item_master_id ";
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TransferReport transferReport = new TransferReport();
                transferReport.setItemCode(rs.getString("code"));
                transferReport.setItemName(rs.getString("name"));
                transferReport.setTotalQty(rs.getDouble("qty"));
                transferReport.setPurchAmount(rs.getDouble("amount"));

                if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
                    transferReport.setPurchNumber(rs.getString("number"));
                }else{
                    transferReport.setPurchNumber(""); 
                }

                list.add(transferReport);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    public static double getTotalTransferByTransaksi(SrcTransferReport srcTransferReport, int type) {
        CONResultSet dbrs = null;
        double totalTransfer =0;
        try {   
            String sql = "select sum(total_amount) as total from ((SELECT p.transfer_id, sum(pi.qty) as qty, ic.name, p.number, " +
                    "sum(pi.amount) as total_amount, pi.amount, p.from_location_id, p.to_location_id, p.date " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id " +
                    "inner join pos_item_category as ic on im.item_category_id=ic.item_category_id ";

            String where = "";
            if(srcTransferReport.getLocationToId()!=0){
                where = "p.to_location_id="+srcTransferReport.getLocationToId();
            }

            if(srcTransferReport.getLocationId()!=0){
                if(where.length()>0){
                    where = where + " and p.from_location_id="+srcTransferReport.getLocationId();
                }else{
                    where = "p.from_location_id="+srcTransferReport.getLocationId();
                }
            }

            if(srcTransferReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "p.date between '"+JSPFormater.formatDate(srcTransferReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcTransferReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcTransferReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcTransferReport.getStatus()+"'";
                }else{
                    where = "p.status='"+srcTransferReport.getStatus()+"'";
                }
            }

            if(srcTransferReport.getNumber().length()>0){
                if(where.length()>0){
                    where = where + " and p.number like '%"+srcTransferReport.getNumber()+"%'";
                }else{
                    where = "p.number like '%"+srcTransferReport.getNumber()+"%'";
                }
            }

                
            if(srcTransferReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_category_id="+srcTransferReport.getItemCategoryId();
                }else{
                    where = "im.item_category_id="+srcTransferReport.getItemCategoryId();
                }
            }
            if(where.length()> 0){
                where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type; 
            }else{
                where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE] + "=" + type; 
            }
            
            if(where.length()>0){
                where = " where "+where;
            }
            
            
            
            sql = sql + where;

            sql = sql + " group by p.transfer_id ";  

           sql = sql + " )) as tabel  ";
            
           
            
            System.out.println("SQL : " + sql);
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                
                totalTransfer =  rs.getDouble("total");
                
                
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return totalTransfer;
    }
    
}