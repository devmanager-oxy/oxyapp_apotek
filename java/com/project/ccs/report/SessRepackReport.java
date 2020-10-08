/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.report;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.postransaction.repack.*;
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
 * @author Ngurah Wirata
 */
public class SessRepackReport {
    public static int getRepackItemCount(SrcRepackReport srcRepackReport) {
        CONResultSet dbrs = null;
        int total=0;
        try {
            
            String sql = "";
                sql = "SELECT im.code, im.barcode, im.name, p.number, " +
                    " p.location_id, pi.type " +
                    "FROM pos_repack_item as pi " +
                    "inner join pos_repack p on pi.repack_id=p.repack_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id  " ;
                
                   
            String where = "";
            if(srcRepackReport.getLocationId()!=0){
                where = " p.location_id="+srcRepackReport.getLocationId();
            }

           

            if(srcRepackReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcRepackReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcRepackReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = " p.date between '"+JSPFormater.formatDate(srcRepackReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcRepackReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcRepackReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcRepackReport.getStatus()+"'";
                }else{
                    where = " p.status='"+srcRepackReport.getStatus()+"'";
                }
            }

            if(srcRepackReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcRepackReport.getItemCategoryId();
                }else{
                    where = " im.item_group_id="+srcRepackReport.getItemCategoryId();
                }
            }
            if(srcRepackReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcRepackReport.getItemCategoryId();
                }else{
                    where = " im.item_group_id="+srcRepackReport.getItemCategoryId();
                }
            }
            if(srcRepackReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcRepackReport.getCode()+"%'";
                }else{
                    where = " im.code like '%"+srcRepackReport.getCode()+"%'";
                }
            }
            
            if(srcRepackReport.getItem_name().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcRepackReport.getItem_name()+"%'";
                }else{
                    where = " im.name like '%"+srcRepackReport.getItem_name()+"%'";
                }
            }
            
            if(srcRepackReport.getType()>-1){
                if(where.length()>0){
                    where = where + " and pi.type ="+ srcRepackReport.getType();
                }else{
                    where = " pi.type ="+ srcRepackReport.getType();
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
            
            //if(srcCostingReport.getGroupBy()==SrcTransferReport.GROUP_ITEM){
            //    sql = sql + "group by im.item_master_id ";
            //}

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total=total+1;
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return total;
    }
    
    public static Vector getItemRepack(SrcRepackReport srcRepackReport, int type, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            
              sql = "SELECT pi.qty, im.item_group_id, im.code, im.barcode, im.name, p.number, " +
                    " p.location_id, pi.type " +
                    "FROM pos_repack_item as pi " +
                    "inner join pos_repack p on pi.repack_id=p.repack_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
                    
              
              
            String where = "";
            if(srcRepackReport.getLocationId()!=0){
                where = " p.location_id="+srcRepackReport.getLocationId();
            }

           

            if(srcRepackReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcRepackReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcRepackReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = " p.date between '"+JSPFormater.formatDate(srcRepackReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcRepackReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcRepackReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcRepackReport.getStatus()+"'";
                }else{
                    where = " p.status='"+srcRepackReport.getStatus()+"'";
                }
            }
            
            if(srcRepackReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcRepackReport.getItemCategoryId();
                }else{
                    where = " im.item_group_id="+srcRepackReport.getItemCategoryId();
                }
            }
            
            
            
            if(srcRepackReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcRepackReport.getItemCategoryId();
                }else{
                    where = " im.item_group_id="+srcRepackReport.getItemCategoryId();
                }
            }
            if(srcRepackReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcRepackReport.getCode()+"%'";
                }else{
                    where = " im.code like '%"+srcRepackReport.getCode()+"%'";
                }
            }
            
            if(srcRepackReport.getItem_name().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcRepackReport.getItem_name()+"%'";
                }else{
                    where = " im.name like '%"+srcRepackReport.getItem_name()+"%'";
                }
            }
            
            if(srcRepackReport.getType()>-1){
                if(where.length()>0){
                    where = where + " and pi.type ="+ srcRepackReport.getType();
                }else{
                    where = " pi.type ="+ srcRepackReport.getType();
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
            
            //if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_ITEM){
            //    sql = sql + "group by im.item_master_id ";
            //}
            //sql = sql + " group by im.item_master_id, p.location_id ";
            if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
                }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                }
            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                RepackReport repackReport = new  RepackReport();
                repackReport.setItemCode(rs.getString("code"));
                repackReport.setItemName(rs.getString("name"));
                repackReport.setTotalQty(rs.getDouble("qty"));
                repackReport.setNumber(rs.getString("number"));
                Location loc= DbLocation.fetchExc(rs.getLong("location_id"));
                repackReport.setLocationName(loc.getName());
                repackReport.setType(rs.getInt("type"));
                ItemGroup ig= DbItemGroup.fetchExc(rs.getLong("item_group_id"));
                repackReport.setItemCategoryName(ig.getName());

                list.add(repackReport);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    
    
}
