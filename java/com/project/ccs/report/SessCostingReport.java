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
 * @author Ngurah Wirata
 */
public class SessCostingReport {
    public static int getCostingItemCount(SrcCostingReport srcCostingReport) {
        CONResultSet dbrs = null;
        int total=0;
        try {
            
            String sql = "";
            sql = "SELECT count(ci.costing_item_id) " +
                    "FROM `pos_costing_item` as ci " +
                    "inner join pos_costing c on ci.costing_id=c.costing_id " +
                    "inner join pos_item_master as im on ci.item_master_id=im.item_master_id ";
            
            String where = "";
            if(srcCostingReport.getLocationId()!=0){
                where = "c.location_id="+srcCostingReport.getLocationId();
            }

            if(srcCostingReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and c.date between '"+JSPFormater.formatDate(srcCostingReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcCostingReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = "c.date between '"+JSPFormater.formatDate(srcCostingReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcCostingReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcCostingReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and c.status='"+srcCostingReport.getStatus()+"'";
                }else{
                    where = "c.status='"+srcCostingReport.getStatus()+"'";
                }
            }

            if(srcCostingReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcCostingReport.getItemCategoryId();
                }else{
                    where = "im.item_group_id="+srcCostingReport.getItemCategoryId();
                }
            }
            if(srcCostingReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcCostingReport.getCode()+"%'";
                }else{
                    where = "im.code='"+srcCostingReport.getCode()+"'";
                }
            }
            
            if(srcCostingReport.getItem_name().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcCostingReport.getItem_name()+"%'";
                }else{
                    where = "im.name='"+srcCostingReport.getItem_name()+"'";
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
                total=rs.getInt(1);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return total;
    }
    
    public static Vector getItemCosting(SrcCostingReport srcCostingReport, int type, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            
              sql = "SELECT sum(pi.qty) as qty, im.code, im.barcode, im.name, p.number, " +
                    "sum(pi.amount) as amount, pi.price, p.location_id " +
                    "FROM pos_costing_item as pi " +
                    "inner join pos_costing p on pi.costing_id=p.costing_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            

            String where = "";
            if(srcCostingReport.getLocationId()!=0){
                where = " p.location_id="+srcCostingReport.getLocationId();
            }

           

            if(srcCostingReport.getIgnoreDate() == 0){
                if(where.length()>0){
                    where = where + " and p.date between '"+JSPFormater.formatDate(srcCostingReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcCostingReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }else{
                    where = " p.date between '"+JSPFormater.formatDate(srcCostingReport.getFromDate(), "yyyy-MM-dd 00:00:01")+"'"+
                            " and '"+JSPFormater.formatDate(srcCostingReport.getToDate(), "yyyy-MM-dd 23:59:59")+"'";
                }
            }

            if(srcCostingReport.getStatus().length()>0){
                if(where.length()>0){
                    where = where + " and p.status='"+srcCostingReport.getStatus()+"'";
                }else{
                    where = " p.status='"+srcCostingReport.getStatus()+"'";
                }
            }

            if(srcCostingReport.getItemCategoryId()!=0){
                if(where.length()>0){
                    where = where + " and im.item_group_id="+srcCostingReport.getItemCategoryId();
                }else{
                    where = " im.item_group_id="+srcCostingReport.getItemCategoryId();
                }
            }
            if(srcCostingReport.getCode().length()>0){
                if(where.length()>0){
                    where = where + " and im.code like '%"+srcCostingReport.getCode()+"%'";
                }else{
                    where = " im.code like '%"+srcCostingReport.getCode()+"%'";
                }
            }
            
            if(srcCostingReport.getItem_name().length()>0){
                if(where.length()>0){
                    where = where + " and im.name like '%"+srcCostingReport.getItem_name()+"%'";
                }else{
                    where = " im.name like '%"+srcCostingReport.getItem_name()+"%'";
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
            sql = sql + " group by im.item_master_id, p.location_id ";
            if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
                }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                }
            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                CostingReport costingReport = new  CostingReport();
                costingReport.setItemCode(rs.getString("code"));
                costingReport.setItemName(rs.getString("name"));
                costingReport.setTotalQty(rs.getDouble("qty"));
                costingReport.setNumber(rs.getString("number"));
                Location loc= DbLocation.fetchExc(rs.getLong("location_id"));
                costingReport.setLocationName(loc.getName());
                     

                list.add(costingReport);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    
    
}
