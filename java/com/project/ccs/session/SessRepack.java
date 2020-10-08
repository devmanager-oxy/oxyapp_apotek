/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.postransaction.repack.DbRepack;
import com.project.ccs.postransaction.repack.DbRepackItem;
import com.project.ccs.postransaction.repack.Repack;
import com.project.ccs.postransaction.repack.RepackItem;
import com.project.ccs.report.RepackReport;
import com.project.ccs.report.SrcRepackReport;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
import com.project.util.JSPFormater;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author Roy
 */
public class SessRepack {

    public static Vector getItemRepack(SrcRepackReport srcRepackReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();

        Vector locations = DbLocation.listAll();
        Hashtable hlocation = new Hashtable();

        if (locations != null && locations.size() > 0) {
            for (int x = 0; x < locations.size(); x++) {
                Location l = (Location) locations.get(x);
                hlocation.put("" + l.getOID(), l.getName());
            }
        }

        Vector categorys = DbItemGroup.listAll();
        Hashtable hcategorys = new Hashtable();

        if (categorys != null && categorys.size() > 0) {
            for (int x = 0; x < categorys.size(); x++) {
                ItemGroup c = (ItemGroup) categorys.get(x);
                hcategorys.put("" + c.getOID(), c.getName());
            }
        }

        try {

            String sql = "";

            sql = "SELECT pi.qty, im.item_group_id, im.code, im.barcode, im.name, p.number, " +
                    " p.location_id, pi.type " +
                    "FROM pos_repack_item as pi " +
                    "inner join pos_repack p on pi.repack_id=p.repack_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";

            String where = "";
            if (srcRepackReport.getLocationId() != 0) {
                where = " p.location_id=" + srcRepackReport.getLocationId();
            }

            if (srcRepackReport.getIgnoreDate() == 0) {
                if (where.length() > 0) {
                    where = where + " and p.date between '" + JSPFormater.formatDate(srcRepackReport.getFromDate(), "yyyy-MM-dd 00:00:00") + "'" +
                            " and '" + JSPFormater.formatDate(srcRepackReport.getToDate(), "yyyy-MM-dd 23:59:59") + "'";
                } else {
                    where = " p.date between '" + JSPFormater.formatDate(srcRepackReport.getFromDate(), "yyyy-MM-dd 00:00:00") + "'" +
                            " and '" + JSPFormater.formatDate(srcRepackReport.getToDate(), "yyyy-MM-dd 23:59:59") + "'";
                }
            }

            if (srcRepackReport.getStatus().length() > 0) {
                if (where.length() > 0) {
                    where = where + " and p.status='" + srcRepackReport.getStatus() + "'";
                } else {
                    where = " p.status='" + srcRepackReport.getStatus() + "'";
                }
            }

            if (srcRepackReport.getItemCategoryId() != 0) {
                if (where.length() > 0) {
                    where = where + " and im.item_group_id=" + srcRepackReport.getItemCategoryId();
                } else {
                    where = " im.item_group_id=" + srcRepackReport.getItemCategoryId();
                }
            }


            if (srcRepackReport.getCode().length() > 0) {
                if (where.length() > 0) {
                    where = where + " and im.code like '%" + srcRepackReport.getCode() + "%'";
                } else {
                    where = " im.code like '%" + srcRepackReport.getCode() + "%'";
                }
            }

            if (srcRepackReport.getItem_name().length() > 0) {
                if (where.length() > 0) {
                    where = where + " and im.name like '%" + srcRepackReport.getItem_name() + "%'";
                } else {
                    where = " im.name like '%" + srcRepackReport.getItem_name() + "%'";
                }
            }

            if (srcRepackReport.getType() > -1) {
                if (where.length() > 0) {
                    where = where + " and pi.type =" + srcRepackReport.getType();
                } else {
                    where = " pi.type =" + srcRepackReport.getType();
                }
            }


            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                RepackReport repackReport = new RepackReport();
                repackReport.setItemCode(rs.getString("code"));
                repackReport.setItemName(rs.getString("name"));
                repackReport.setTotalQty(rs.getDouble("qty"));
                repackReport.setNumber(rs.getString("number"));
                try {
                    repackReport.setLocationName(String.valueOf(hlocation.get("" + rs.getLong("location_id"))));
                } catch (Exception e) {
                }
                repackReport.setType(rs.getInt("type"));
                try {
                    repackReport.setItemCategoryName(String.valueOf(hcategorys.get("" + rs.getLong("item_group_id"))));
                } catch (Exception e) {
                }
                list.add(repackReport);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }

    public static Vector getTransactionRepack(SrcRepackReport srcRepackReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();

        try {

            String sql = "";

            sql = "SELECT p.* FROM pos_repack p ";

            String where = "";
            if (srcRepackReport.getLocationId() != 0) {
                where = " p.location_id=" + srcRepackReport.getLocationId();
            }

            if (srcRepackReport.getIgnoreDate() == 0) {
                if (where.length() > 0) {
                    where = where + " and p.date between '" + JSPFormater.formatDate(srcRepackReport.getFromDate(), "yyyy-MM-dd 00:00:00") + "'" +
                            " and '" + JSPFormater.formatDate(srcRepackReport.getToDate(), "yyyy-MM-dd 23:59:59") + "'";
                } else {
                    where = " p.date between '" + JSPFormater.formatDate(srcRepackReport.getFromDate(), "yyyy-MM-dd 00:00:00") + "'" +
                            " and '" + JSPFormater.formatDate(srcRepackReport.getToDate(), "yyyy-MM-dd 23:59:59") + "'";
                }
            }

            if (srcRepackReport.getStatus().length() > 0) {
                if (where.length() > 0) {
                    where = where + " and p.status='" + srcRepackReport.getStatus() + "'";
                } else {
                    where = " p.status='" + srcRepackReport.getStatus() + "'";
                }
            }

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by p.repack_id";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Repack repack = new Repack();
                repack.setOID(rs.getLong(DbRepack.colNames[DbRepack.COL_REPACK_ID]));
                repack.setDate(rs.getDate(DbRepack.colNames[DbRepack.COL_DATE]));
                repack.setCounter(rs.getInt(DbRepack.colNames[DbRepack.COL_COUNTER]));
                repack.setNumber(rs.getString(DbRepack.colNames[DbRepack.COL_NUMBER]));
                repack.setNote(rs.getString(DbRepack.colNames[DbRepack.COL_NOTE]));
                repack.setApproval1(rs.getLong(DbRepack.colNames[DbRepack.COL_APPROVAL_1]));
                repack.setApproval2(rs.getLong(DbRepack.colNames[DbRepack.COL_APPROVAL_2]));
                repack.setApproval3(rs.getLong(DbRepack.colNames[DbRepack.COL_APPROVAL_3]));
                repack.setStatus(rs.getString(DbRepack.colNames[DbRepack.COL_STATUS]));
                repack.setLocationId(rs.getLong(DbRepack.colNames[DbRepack.COL_LOCATION_ID]));
                repack.setUserId(rs.getLong(DbRepack.colNames[DbRepack.COL_USER_ID]));
                repack.setPrefixNumber(rs.getString(DbRepack.colNames[DbRepack.COL_PREFIX_NUMBER]));
                repack.setPostedStatus(rs.getInt(DbRepack.colNames[DbRepack.COL_POSTED_STATUS]));
                repack.setPostedById(rs.getLong(DbRepack.colNames[DbRepack.COL_POSTED_BY_ID]));
                repack.setPostedDate(rs.getDate(DbRepack.colNames[DbRepack.COL_POSTED_DATE]));
                repack.setEffectiveDate(rs.getDate(DbRepack.colNames[DbRepack.COL_EFFECTIVE_DATE]));
                list.add(repack);
            }
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }
    
    public static RepackItem getQty(long repackId,int type){
        CONResultSet dbrs = null;
        double totalQty = 0;
        double totalCogs = 0;
        RepackItem ri = new RepackItem();
        try {
            String sql = "select sum(" + DbRepackItem.colNames[DbRepackItem.COL_QTY] +") as tot_qty,sum(" + DbRepackItem.colNames[DbRepackItem.COL_COGS] +") as tot_cogs from " + DbRepackItem.DB_POS_REPACK_ITEM + " where " +
                    DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + " = " + repackId+" and "+DbRepackItem.colNames[DbRepackItem.COL_TYPE]+" = "+type;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                totalQty = rs.getDouble("tot_qty");
                totalCogs = rs.getDouble("tot_cogs");
                ri.setQty(totalQty);
                ri.setCogs(totalCogs);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return ri;
    }
    
}
