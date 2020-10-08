/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
import java.util.Vector;
import com.project.util.*;
import com.project.general.*;
import java.util.Date;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.admin.User;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbReceiveItem;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.receiving.ReceiveItem;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
/**
 *
 * @author Roy
 */
public class SessReceive {

    public static int countReceive(long srcVendorId,String nomorDocument,
            int srcIgnore,Date srcStartDate,Date srcEndDate,
            long locationId,int non,int konsinyasi,int komisi){
        
        int total = 0;        
        CONResultSet dbrs = null;
        try{
            String whereClause = " where r."+DbReceive.colNames[DbReceive.COL_TYPE_AP] + " in (" + DbReceive.TYPE_AP_NO + "," + DbReceive.TYPE_AP_REC_ADJ_BY_PRICE + "," + DbReceive.TYPE_AP_REC_ADJ_BY_QTY + ") and r." + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + I_Project.DOC_STATUS_APPROVED + "' ";
            
            if (nomorDocument != null && nomorDocument.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " r."+DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + nomorDocument + "%' ";
            }

            if (srcVendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + srcVendorId;
            }

            if (srcIgnore == 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }                                
                whereClause = whereClause+" r."+DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' " +
                    " and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' ";
                
            }
            
            if(locationId != 0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " r."+DbReceive.colNames[DbReceive.COL_LOCATION_ID] + "=" + locationId;
            }
            
            String wherex = "";
            if(non == 0 && konsinyasi == 0 && komisi ==0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = -1 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = -1 )";
                
            }else{
            
                if(!(non == 1 && konsinyasi == 1 && komisi ==1)){
                    if(non == 1 || konsinyasi == 1 || komisi ==1){
                        if(konsinyasi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = " + 1;
                            }
                        if(komisi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = " + 1;
                        }
                
                        if(non ==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 0 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = 0 )";
                        }
                        
                        if (whereClause.length() > 0) {
                            whereClause = whereClause + " and ";
                        }
                        
                        whereClause = whereClause +" ( "+wherex+" ) ";
                    }
                }
            }
            
            
            String sql = "select count(r.receive_id) as total from pos_receive r inner join vendor v on r.vendor_id = v.vendor_id "+whereClause;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total = rs.getInt("total");
            }
            rs.close();
            
        }catch(Exception e){
        }finally {
            CONResultSet.close(dbrs);
        }
        
        return total;
    }
    
    
    public static Vector listReceive(int limitStart, int recordToGet,long srcVendorId,String nomorDocument,
            int srcIgnore,Date srcStartDate,Date srcEndDate,
            long locationId,int non,int konsinyasi,int komisi){
        
        Vector result = new Vector();        
        CONResultSet dbrs = null;
        try{
            String whereClause = " where r."+DbReceive.colNames[DbReceive.COL_TYPE_AP] + " in (" + DbReceive.TYPE_AP_NO + "," + DbReceive.TYPE_AP_REC_ADJ_BY_PRICE + "," + DbReceive.TYPE_AP_REC_ADJ_BY_QTY + ") and r." + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + I_Project.DOC_STATUS_APPROVED + "' ";
            
            if (nomorDocument != null && nomorDocument.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " r."+DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + nomorDocument + "%' ";
            }

            if (srcVendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " r."+DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + srcVendorId;
            }

            if (srcIgnore == 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }                                
                whereClause = whereClause+" r."+DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' " +
                    " and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' ";
                
            }
            
            if(locationId != 0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " r."+DbReceive.colNames[DbReceive.COL_LOCATION_ID] + "=" + locationId;
            }
            
            String wherex = "";
            if(non == 0 && konsinyasi == 0 && komisi ==0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = -1 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = -1 )";
                
            }else{
            
                if(!(non == 1 && konsinyasi == 1 && komisi ==1)){
                    if(non == 1 || konsinyasi == 1 || komisi ==1){
                        if(konsinyasi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = " + 1;
                            }
                        if(komisi==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " v." + DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = " + 1;
                        }
                
                        if(non ==1){
                            if(wherex != null && wherex.length() > 0){ wherex = wherex+" or ";}
                                wherex = wherex + " ( v." + DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 0 and v."+DbVendor.colNames[DbVendor.COL_IS_KOMISI]+" = 0 )";
                        }
                        
                        if (whereClause.length() > 0) {
                            whereClause = whereClause + " and ";
                        }
                        
                        whereClause = whereClause +" ( "+wherex+" ) ";
                    }
                }
            }
            
            
            String sql = "select r.* from pos_receive r inner join vendor v on r.vendor_id = v.vendor_id "+whereClause;
            
            sql = sql + " order by r."+DbReceive.colNames[DbReceive.COL_DATE] + " desc,r." + DbReceive.colNames[DbReceive.COL_NUMBER] + " desc";            
            
            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Receive receive = new Receive();
                DbReceive.resultToObject(rs, receive);
                result.add(receive);
            }
            rs.close();
            return result;
            
        }catch(Exception e){
        }finally {
            CONResultSet.close(dbrs);
        }
        
        return result;
    }
    
    public static long postingReceive(long receiveId, User user,Company comp,ExchangeRate er) {
        try {
            boolean item = itemTrue(receiveId);
            if (item) {
                Receive receive = DbReceive.fetchExc(receiveId);
                Periode p = DbPeriode.getPeriodByTransDate(receive.getApproval1Date());
                if (receive.getVendorId() == 0 || p.getOID() == 0 || p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                    return 0;
                }

                Location loc = new Location();
                try {
                    loc = DbLocation.fetchExc(receive.getLocationId());
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + loc.getOID();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt == null || segmentDt.size() <= 0) {
                        return 0;
                    }
                } catch (Exception e) {
                }

                Vector purchItems = DbReceiveItem.list(0, 0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + " = " + receiveId, null);

                if (purchItems != null && purchItems.size() > 0) {
                    for (int i = 0; i < purchItems.size(); i++) {
                        ReceiveItem ri = (ReceiveItem) purchItems.get(i);
                        long oidx = loc.getCoaApId();
                        Vendor vx = new Vendor();
                        try {
                            vx = DbVendor.fetchExc(receive.getVendorId());
                        } catch (Exception e) {
                        }

                        if (vx.getOID() != 0) {
                            if (vx.getLiabilitiesType() == DbVendor.LIABILITIES_TYPE_GROSIR) {
                                oidx = loc.getCoaApGrosirId();
                            } else {
                                oidx = loc.getCoaApId();
                            }
                        }

                        if (ri.getIsBonus() == DbReceiveItem.BONUS) {
                            ItemMaster im = new ItemMaster();
                            ItemGroup igx = new ItemGroup();
                            try {
                                im = DbItemMaster.fetchExc(ri.getItemMasterId());
                                igx = DbItemGroup.fetchExc(im.getItemGroupId());
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }

                            Vector vOtherIncome = DbCoa.list(0, 1, DbCoa.colNames[DbCoa.COL_CODE] + "='" + igx.getAccountBonusIncome() + "'", "");
                            Coa coaOtherIncome = new Coa();
                            if (vOtherIncome != null && vOtherIncome.size() > 0) {
                                coaOtherIncome = (Coa) vOtherIncome.get(0);
                                oidx = coaOtherIncome.getOID();
                            }
                        }
                        if (oidx != 0) {
                            try {
                                Coa coa = DbCoa.fetchExc(oidx);
                                if (coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                                    if (coa.getAccountClass() != DbCoa.ACCOUNT_CLASS_SP) {
                                        updateCoa(ri.getOID(),oidx);                                        
                                    } else {
                                        return 0;
                                    }
                                } else {
                                    return 0;
                                }
                            } catch (Exception e) {
                            }
                        } else {
                            return 0;
                        }
                    }
                }

                if (receive.getStatus() != null && receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                    receive.setApproval2(user.getOID());
                    receive.setStatus(I_Project.DOC_STATUS_CHECKED);
                    long result = DbReceive.postJournal(receive, p.getOID(), comp, er);
                    if(result != 0){
                        updateChecked(receiveId,p.getOID(),user.getOID());
                    }
                }
            }
        } catch (Exception e) {
        }

        return 1;
    }
    
    
    public static void updateChecked(long receiveId,long periodId,long userId){
        CONResultSet dbrs = null;
        try{
            String sql = "update "+DbReceive.DB_RECEIVE+" set "+DbReceive.colNames[DbReceive.COL_STATUS]+"='"+I_Project.DOC_STATUS_CHECKED+"',"+
                    DbReceive.colNames[DbReceive.COL_PERIOD_ID]+" = "+periodId+","+DbReceive.colNames[DbReceive.COL_APPROVAL_2]+"="+userId+","+
                    DbReceive.colNames[DbReceive.COL_APPROVAL_2_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss")+"' where "+
                    DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = "+receiveId;
                    
            CONHandler.execUpdate(sql);
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        
    }
    
    public static void updateCoa(long receiveItemId,long coaId){
        CONResultSet dbrs = null;
        try{
            String sql = "update "+DbReceiveItem.DB_RECEIVE_ITEM+" set "+DbReceiveItem.colNames[DbReceiveItem.COL_AP_COA_ID]+"='"+coaId+"' "+
                    " where "+DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID]+" = "+receiveItemId;
                    
            CONHandler.execUpdate(sql);
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        
    }

    public static boolean itemTrue(long receiveId) {
        CONResultSet dbrs = null;
        try {
            String sql = "select ri.receive_item_id from pos_receive_item ri left join pos_item_master m on ri.item_master_id = m.item_master_id where ri.receive_id = " + receiveId + " and m.item_master_id is null";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                return false;
            }
            rs.close();
        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
        return true;
    }
}
