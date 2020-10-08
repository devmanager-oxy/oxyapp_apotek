/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbPriceType;
import com.project.ccs.posmaster.DbUom;
import com.project.ccs.posmaster.DbVendorItem;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbReceiveItem;
import com.project.ccs.postransaction.sales.DbPayment;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.sales.Sales;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.general.DbBank;
import com.project.general.DbCustomer;
import com.project.general.DbLocation;
import com.project.general.DbMerchant;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class SessReportSales {

    public static Vector ReportSalesByMember(Date start, Date end, int ignore, String member, long locationId, long cstId) {
        CONResultSet crs = null;
        try {

            String sql = "select ps." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as cstId " +
                    ", cst." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as name " +
                    ", pl." + DbLocation.colNames[DbLocation.COL_NAME] + " as locName " +
                    ",pl." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " as locId " +
                    ",ps." + DbSales.colNames[DbSales.COL_DATE] + " as date" +
                    ",ps." + DbSales.colNames[DbSales.COL_NUMBER] + " as number" +
                    ",ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " as salesId " +
                    ",sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as tot " +
                    ",ps." + DbSales.colNames[DbSales.COL_TYPE] + " as type from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd " +
                    " on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbCustomer.DB_CUSTOMER + " cst on ps." + DbSales.colNames[DbSales.COL_CUSTOMER_ID] + " = cst." +
                    DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " inner join " + DbLocation.DB_LOCATION + " pl on ps." +
                    DbSales.colNames[DbSales.COL_LOCATION_ID] + " = pl." + DbLocation.colNames[DbLocation.COL_LOCATION_ID];

            String where = "";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (cstId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "ps." + DbSales.colNames[DbSales.COL_CUSTOMER_ID] + " = " + cstId;
            }

            if (member.length() > 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "cst." + DbCustomer.colNames[DbCustomer.COL_NAME] + " like '%" + member + "%' ";
            }

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_DATE] + " >= '" + JSPFormater.formatDate(start, "yyyy-MM-dd") + " 00:00:00' and ps." + DbSales.colNames[DbSales.COL_DATE] + " <= '" + JSPFormater.formatDate(end, "yyyy-MM-dd") + " 23:59:59'";
            }

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " order by cst." + DbCustomer.colNames[DbCustomer.COL_NAME] + "," + "pl." + DbLocation.colNames[DbLocation.COL_NAME] + ",ps." + DbSales.colNames[DbSales.COL_DATE] + ",ps." + DbSales.colNames[DbSales.COL_NUMBER];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            Vector result = new Vector();

            while (rs.next()) {

                ReportSalesMember rpt = new ReportSalesMember();

                rpt.setCustomerId(rs.getLong("cstId"));
                rpt.setNameCustomer(rs.getString("name"));
                rpt.setLocationName(rs.getString("locName"));
                rpt.setLocationId(rs.getLong("locId"));
                rpt.setDateTransaction(rs.getDate("date"));
                rpt.setNumber(rs.getString("number"));
                rpt.setSalesId(rs.getLong("salesId"));
                rpt.setAmount(rs.getDouble("tot"));
                rpt.setType(rs.getInt("type"));

                result.add(rpt);
            }

            return result;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector ReportItemConsignedByCost(Date start, Date end, int ignore, long vendorId, long groupId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID];

            String where = "";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "s." + DbStock.colNames[DbStock.COL_DATE] + " between '" + JSPFormater.formatDate(start, "yyyy-MM-dd 00:00:00") + "' and '" + JSPFormater.formatDate(end, "yyyy-MM-dd 00:00:00") + "' ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = " + groupId;
            }

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Vector result = new Vector();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                result.add(rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector ReportItemConsignedByCost(Date start, Date end, int ignore, long vendorId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = "";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "s." + DbStock.colNames[DbStock.COL_DATE] + " between '" + JSPFormater.formatDate(start, "yyyy-MM-dd 00:00:00") + "' and '" + JSPFormater.formatDate(end, "yyyy-MM-dd 00:00:00") + "' ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }
            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HB;

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Vector result = new Vector();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                result.add(rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector reportItemConsignedByCost(long vendorId) {

        CONResultSet crs = null;

        try {
            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = "";

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HB;

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Vector result = new Vector();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                result.add(rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector ReportItemConsignedBySelling(Date start, Date end, int ignore, long vendorId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = "";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "s." + DbStock.colNames[DbStock.COL_DATE] + " between '" + JSPFormater.formatDate(start, "yyyy-MM-dd 00:00:00") + "' and '" + JSPFormater.formatDate(end, "yyyy-MM-dd 00:00:00") + "' ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }
            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HJ;

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Vector result = new Vector();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                result.add(rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector reportItemConsignedBySelling(long vendorId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code " +
                    " from " + DbItemMaster.DB_ITEM_MASTER + " m inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = "";

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }
            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HJ;

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by m." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Vector result = new Vector();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName("");
                result.add(rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector reportItemBeliPutus(long vendorId, long itemGroupId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code " +
                    " from " + DbItemMaster.DB_ITEM_MASTER + " m inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = "";

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (itemGroupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + itemGroupId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }
            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_BELI_PUTUS;

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by m." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Vector result = new Vector();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportBeliPutus rpt = new ReportBeliPutus();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName("");
                result.add(rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable ReportConsignedByCostBegining(Date start, int ignore, long vendorId, int type, long groupId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + "*s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , m." +
                    DbItemMaster.colNames[DbItemMaster.COL_COGS] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID];

            String where = "";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "s." + DbStock.colNames[DbStock.COL_DATE] + " < '" + JSPFormater.formatDate(start, "yyyy-MM-dd 00:00:00") + "' ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = " + groupId;
            }

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable reportConsignedByCostBegining(Date start, int ignore, long vendorId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + " * s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , m." +
                    DbItemMaster.colNames[DbItemMaster.COL_COGS] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = "";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") < to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HB;

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable reportConsignedByCostBeginingSelling(Date start, int ignore, long vendorId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + "*s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , m." +
                    DbItemMaster.colNames[DbItemMaster.COL_COGS] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = " s." + DbStock.colNames[DbStock.COL_TYPE] + " in (" + DbStock.TYPE_INCOMING_GOODS + "," + DbStock.TYPE_SALES + "," + DbStock.TYPE_TRANSFER + "," + DbStock.TYPE_TRANSFER_IN + "," + DbStock.TYPE_RETUR_GOODS + "," + DbStock.TYPE_ADJUSTMENT + "," + DbStock.TYPE_OPNAME + ") ";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") < to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HJ;

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable reportBeliPutusBeginingSelling(Date start, int ignore, long vendorId, long locationId, long itemGroupId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + "*s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , m." +
                    DbItemMaster.colNames[DbItemMaster.COL_COGS] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = "";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") < to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') ";
            }

            if (itemGroupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + itemGroupId;
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_BELI_PUTUS;

            if (where.length() > 0) {
                where = " where " + where;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportBeliPutus rpt = new ReportBeliPutus();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable ReportConsignedByCost(Date start, Date end, int ignore, long vendorId, int type, long groupId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + "*s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , m." +
                    DbItemMaster.colNames[DbItemMaster.COL_COGS] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID];

            String where = " where s." + DbStock.colNames[DbStock.COL_TYPE] + " = " + type;

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "s." + DbStock.colNames[DbStock.COL_DATE] + " between '" + JSPFormater.formatDate(start, "yyyy-MM-dd 00:00:00") + "' and '" + JSPFormater.formatDate(end, "yyyy-MM-dd 00:00:00") + "' ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = " + groupId;
            }

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable reportConsignedByCost(Date start, Date end, int ignore, long vendorId, int type, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + "*s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , m." +
                    DbItemMaster.colNames[DbItemMaster.COL_COGS] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = " where s." + DbStock.colNames[DbStock.COL_TYPE] + " = " + type;

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }
            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HB;

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable reportConsignedBySelling(Date start, Date end, int ignore, long vendorId, int type, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + "*s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , m." +
                    DbItemMaster.colNames[DbItemMaster.COL_COGS] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = " where s." + DbStock.colNames[DbStock.COL_TYPE] + " = " + type;

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }
            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HJ;

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable reportConsignedBySellingReceive(Date start, Date end, int ignore, long vendorId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + "*s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , m." +
                    DbItemMaster.colNames[DbItemMaster.COL_COGS] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = " where ( s." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_INCOMING_GOODS + " or s." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_TRANSFER_IN + " ) ";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }
            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI + " and vnd." + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HJ;

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable reportBeliPutusBySelling(Date start, Date end, int ignore, long vendorId, int type, long locationId, long itemGroupId) {

        CONResultSet crs = null;

        try {

            String sql = "select  m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterId ,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name,m." +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code,l." +
                    DbLocation.colNames[DbLocation.COL_NAME] + " as loc, sum(s." + DbStock.colNames[DbStock.COL_QTY] + "*s." + DbStock.colNames[DbStock.COL_IN_OUT] + ") qty , s." +
                    DbStock.colNames[DbStock.COL_PRICE] + " as price  " +
                    " from " + DbStock.DB_POS_STOCK + " s inner join " + DbItemMaster.DB_ITEM_MASTER + " m  on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " = s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " inner join " + DbLocation.DB_LOCATION + " l on l." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = s." + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                    " inner join " + DbVendor.DB_VENDOR + " vnd on m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID];

            String where = " where s." + DbStock.colNames[DbStock.COL_TYPE] + " = " + type;

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";
            }

            if (itemGroupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + itemGroupId;
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }
            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_BELI_PUTUS;

            sql = sql + where + " group by s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + ",m." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + ",s." + DbStock.colNames[DbStock.COL_DATE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportBeliPutus rpt = new ReportBeliPutus();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable reportConsignedBySellingPosSales(Date start, Date end, int ignore, long vendorId, long locationId) {

        CONResultSet crs = null;

        try {

            String where = "";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ")  <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI;

            if (where.length() > 0) {
                where = " and " + where;
            }

            String sql = "select masterId,sum(qty) as xqty,loc,name,code,price from ( " +
                    " select 0 as idxx,psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " as masterId ," +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty," +
                    " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " as loc," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," +
                    " psd." + DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE] + " as price " +
                    " from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + where + " group by im." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] +
                    " union select 1 as idxx,psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " as masterId ," +
                    " sum(-1 * psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty," +
                    " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " as loc," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," +
                    " psd." + DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE] + " as price " +
                    " from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + where + " group by im." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " ) as tot group by masterId ";

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                double qty = 0;
                try {
                    qty = rs.getDouble("xqty");
                    if (qty != 0) {
                        qty = qty * -1;
                    }
                } catch (Exception e) {
                }
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(qty);
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;

    }

    public static Hashtable reportConsignedBySellingPosSalesRetur(Date start, Date end, int ignore, long vendorId, long locationId) {

        CONResultSet crs = null;

        try {

            String sql = "select psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " as masterId ," +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty," +
                    " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " as loc," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," +
                    " psd." + DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE] + " as price " +
                    " from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];

            String where = " ( ps." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_RETUR_CASH + " or ps." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_RETUR_CREDIT + " ) ";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ")  <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI;

            if (where.length() > 0) {
                sql = sql + " where " + where;
            }

            sql = sql + " group by im." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by ps." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",im." + DbItemMaster.colNames[DbItemMaster.COL_CODE];

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(-1 * rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;

    }

    public static Hashtable reportConsignedBySellingPosSalesBefore(Date start, long locationId, long itemMasterId) {

        CONResultSet crs = null;

        try {

            String sql = "select psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " as masterId ," +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty," +
                    " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " as loc," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," +
                    " psd." + DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE] + " as price " +
                    " from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];


            String where = "";
            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = " + itemMasterId;

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_KONSINYASI;

            if (where.length() > 0) {
                sql = sql + " where " + where;
            }

            sql = sql + " group by im." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " order by ps." + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ",im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " limit 0,1";

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportConsigCost rpt = new ReportConsigCost();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(-1 * rs.getDouble("qty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
                return result;
            }

            return result;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;

    }

    public static double reportConsignedBySellingPrice(long locationId, long itemMasterId) {

        Location location = new Location();
        try {
            location = DbLocation.fetchExc(locationId);
        } catch (Exception e) {
        }

        String golPrice = location.getGol_price();

        String sql = "select ";

        if (golPrice.compareTo("gol_1") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_1];
        } else if (golPrice.compareTo("gol_2") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_2];
        } else if (golPrice.compareTo("gol_3") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_3];
        } else if (golPrice.compareTo("gol_4") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_4];
        } else if (golPrice.compareTo("gol_5") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_5];
        } else if (golPrice.compareTo("gol_6") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_6];
        } else if (golPrice.compareTo("gol_7") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_7];
        } else if (golPrice.compareTo("gol_8") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_7];
        } else if (golPrice.compareTo("gol_9") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_9];
        } else if (golPrice.compareTo("gol_10") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_10];
        } else if (golPrice.compareTo("gol_11") == 0) {
            sql = sql + DbPriceType.colNames[DbPriceType.COL_GOL_11];
        }

        CONResultSet crs = null;

        try {

            String sqlExc = sql + " from " + DbPriceType.DB_PRICE_TYPE + " where " + DbPriceType.colNames[DbPriceType.COL_ITEM_MASTER_ID] + " = " + itemMasterId;

            double result = 0;
            crs = CONHandler.execQueryResult(sqlExc);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                double price = rs.getDouble(1);
                return price;
            }

            return result;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return 0;

    }

    public static Hashtable reportBeliPutusBySellingPosSales(Date start, Date end, int ignore, long vendorId, long locationId, long itemGroupId) {

        CONResultSet crs = null;

        try {

            String where = "";

            if (ignore != 1) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ")  <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";
            }

            if (itemGroupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + itemGroupId;
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM] + " = " + DbItemMaster.TYPE_ITEM_BELI_PUTUS;

            if (where.length() > 0) {
                where = " and " + where;
            }

            String sql = "select masterId,sum(qty) as xqty,loc,name,code,price from ( " +
                    " select psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " as masterId ," +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty," +
                    " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " as loc," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," +
                    " psd." + DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE] + " as price " +
                    " from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + where + " group by im." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] +
                    " union select psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " as masterId ," +
                    " sum(-1 * psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty," +
                    " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " as loc," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," +
                    " psd." + DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE] + " as price " +
                    " from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + where + " group by im." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " ) as tot group by masterId ";

            Hashtable result = new Hashtable();
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                ReportBeliPutus rpt = new ReportBeliPutus();
                rpt.setItemMasterId(rs.getLong("masterId"));
                rpt.setDescription(rs.getString("name"));
                rpt.setSku(rs.getString("code"));
                rpt.setLocationName(rs.getString("loc"));
                rpt.setQty(-1 * rs.getDouble("xqty"));
                rpt.setCost(rs.getDouble("price"));
                result.put("" + rpt.getItemMasterId(), rpt);
            }

            return result;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;

    }

    public static double price(long itemId, String golPrice) {
        CONResultSet crs = null;
        try {

            String sql = "select " + golPrice + " from " + DbPriceType.DB_PRICE_TYPE + " where " + DbPriceType.colNames[DbPriceType.COL_ITEM_MASTER_ID] + " = " + itemId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                double price = rs.getDouble(1);
                return price;
            }

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return 0;

    }

    public static Vector listSalesReport(Date startDate, Date endDate, long locationId, long groupId) {
        CONResultSet crs = null;
        try {

            String sql = "select ic." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as icCode, " +
                    "ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as icId, " +
                    "ic." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as icName, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as imId, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as imCode, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as imName, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as selling " +
                    " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " inner join " + DbItemGroup.DB_ITEM_GROUP + " ic on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID];

            String where = "";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + groupId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + "') ";

            if (where.length() > 0) {
                sql = sql + " where ";
            }

            sql = sql + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " order by ic." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + ",im." + DbItemMaster.colNames[DbItemMaster.COL_CODE];


            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                RptSalesCategory rsc = new RptSalesCategory();
                rsc.setCategoriId(rs.getLong("icId"));
                rsc.setCode(rs.getString("icCode"));
                rsc.setCategory(rs.getString("icName"));
                rsc.setItemMasterId(rs.getLong("imId"));
                rsc.setName(rs.getString("imName"));
                rsc.setJumlah(rs.getDouble("qty"));
                rsc.setSelling(rs.getDouble("selling"));
                rsc.setSku(rs.getString("imCode"));
                result.add(rsc);
            }
            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector listSalesReportByCategory(Date startDate, Date endDate, long locationId, long groupId, long vendorId) {
        CONResultSet crs = null;
        try {
            String where = "";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + groupId;
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + "') ";

            if (where.length() > 0) {
                where = " and " + where;
            }

            String sql = "select gid, cdx,igname,cd,masterid,nm, sum(totqty) as ttqty,seliing,sum(tot) as tttot, vndx, sum(totdis) as tdiskon " +
                    " from (select ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + where +
                    " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " union " +
                    " select ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * -1) as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " * -1) as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * -1) as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " ) as xx group by masterid,seliing order by igname,cd ";


            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                RptSalesCategory rsc = new RptSalesCategory();
                rsc.setCategoriId(rs.getLong("gid"));
                rsc.setCode(rs.getString("cdx"));
                rsc.setCategory(rs.getString("igname"));
                rsc.setItemMasterId(rs.getLong("masterid"));
                rsc.setName(rs.getString("nm"));
                rsc.setJumlah(rs.getDouble("ttqty"));
                rsc.setSelling(rs.getDouble("seliing"));
                rsc.setSku(rs.getString("cd"));
                rsc.setVendor(rs.getString("vndx"));
                rsc.setDiskon(rs.getDouble("tdiskon"));
                if (rsc.getJumlah() != 0) {
                    result.add(rsc);
                }
            }
            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector listSalesReportBySubCategory(Date startDate, Date endDate, long locationId, long groupId, long vendorId) {
        CONResultSet crs = null;
        try {
            String where = "";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + groupId;
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + "') ";

            if (where.length() > 0) {
                where = " and " + where;
            }

            String sql = "select gid, cdx,igname,sub_id,cd,masterid,nm, sum(totqty) as ttqty,seliing,sum(tot) as tttot, vndx, sum(totdis) as tdiskon " +
                    " from (select ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + where +
                    " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " union " +
                    " select ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * -1) as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " * -1) as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * -1) as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " ) as xx group by masterid,seliing order by igname,cd ";


            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                RptSalesCategory rsc = new RptSalesCategory();
                rsc.setCategoriId(rs.getLong("gid"));
                rsc.setCode(rs.getString("cdx"));
                rsc.setSubCategoryId(rs.getLong("sub_id"));
                rsc.setCategory(rs.getString("igname"));
                rsc.setItemMasterId(rs.getLong("masterid"));
                rsc.setName(rs.getString("nm"));
                rsc.setJumlah(rs.getDouble("ttqty"));
                rsc.setSelling(rs.getDouble("seliing"));
                rsc.setSku(rs.getString("cd"));
                rsc.setVendor(rs.getString("vndx"));
                rsc.setDiskon(rs.getDouble("tdiskon"));
                if (rsc.getJumlah() != 0) {
                    result.add(rsc);
                }
            }
            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector listSalesReportByQty(Date startDate, Date endDate, long locationId, long groupId, String code, String name) {
        CONResultSet crs = null;
        try {
            String sqlGabung = "";
            Vector vloc = new Vector();

            if (locationId == 0) {
                vloc = DbLocation.list(0, 0, " type='Store' ", "");

            } else {
                try {
                    Location loc = DbLocation.fetchExc(locationId);
                    vloc.add(loc);
                } catch (Exception ex) {

                }

            }

            String locnames = "";
            String sumlocnames = "";

            for (int i = 0; i < vloc.size(); i++) {
                Location loc = new Location();
                loc = (Location) vloc.get(i);
                locnames = locnames + ", loc_" + loc.getCode();
                sumlocnames = sumlocnames + ", sum(loc_" + loc.getCode() + ") as tot_" + loc.getCode();

            }


            if (vloc.size() > 0) {
                String sqlunion = "";
                for (int i = 0; i < vloc.size(); i++) {
                    Location loc = new Location();
                    loc = (Location) vloc.get(i);
                    locationId = loc.getOID();
                    String where = "";
                    if (locationId != 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
                    }

                    if (groupId != 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " im." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + groupId;
                    }

                    if (code.length() > 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " (im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + code + "%' or im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + code + "%') ";
                    }

                    if (name.length() > 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + name + "%' ";
                    }

                    if (where.length() > 0) {
                        where = where + " and ";
                    }

                    where = where + " to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + "') and to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + "') ";



                    String fields = "";
                    for (int j = 0; j < vloc.size(); j++) {
                        Location loca = new Location();
                        loca = (Location) vloc.get(j);
                        if (i == j) {
                            fields = fields + ", sum(sd.qty) as loc_" + loca.getCode() + " ";
                        } else {
                            fields = fields + ", 0 as loc_" + loca.getCode() + " ";
                        }

                    }

                    sqlunion = sqlunion + " select im.item_master_id as idmaster, ig.code as codeGroup, ig.name as groupname, im.code, im.name" + fields +
                            " from pos_sales_detail sd inner join pos_item_master im on sd.product_master_id=im.item_master_id " +
                            " inner join pos_sales s on sd.sales_id=s.sales_id " +
                            " inner join pos_item_group ig on im.item_group_id=ig.item_group_id where " +
                            where + " group by sd.product_master_id";
                    if ((i + 1) < vloc.size()) {
                        sqlunion = sqlunion + " union ";
                    }


                }

                sqlGabung = " select idmaster, codeGroup, groupname, code, name" + sumlocnames + " from (" + sqlunion + ") as xx group by idmaster";
            }

            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                Vector vitem = new Vector();
                vitem.add(rs.getLong("idmaster"));
                vitem.add(rs.getString("codeGroup"));
                vitem.add(rs.getString("groupname"));
                vitem.add(rs.getString("code"));
                vitem.add(rs.getString("name"));
                for (int b = 0; b < vloc.size(); b++) {
                    Location loc = new Location();
                    loc = (Location) vloc.get(b);
                    vitem.add(rs.getDouble("tot_" + loc.getCode()));
                }
                result.add(vitem);

            }
            return result;



        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector getTotalQtySales(Date startDate, Date endDate, long locationId, long itemMasterId) {
        CONResultSet crs = null;
        try {
            String sqlGabung = "";
            Vector vloc = new Vector();

            if (locationId == 0) {
                vloc = DbLocation.list(0, 0, " type='Store' ", "");

            } else {
                try {
                    Location loc = DbLocation.fetchExc(locationId);
                    vloc.add(loc);
                } catch (Exception ex) {

                }

            }

            String locnames = "";
            String sumlocnames = "";

            for (int i = 0; i < vloc.size(); i++) {
                Location loc = new Location();
                loc = (Location) vloc.get(i);
                locnames = locnames + ", loc_" + loc.getCode();
                sumlocnames = sumlocnames + ", sum(loc_" + loc.getCode() + ") as tot_" + loc.getCode();

            }


            if (vloc.size() > 0) {
                String sqlunion = "";
                for (int i = 0; i < vloc.size(); i++) {
                    Location loc = new Location();
                    loc = (Location) vloc.get(i);
                    locationId = loc.getOID();
                    String where = "";
                    if (locationId != 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
                    }
                    if (itemMasterId != 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = " + itemMasterId;
                    }
                    if (where.length() > 0) {
                        where = where + " and ";
                    }

                    where = where + " to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + "') and to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + "') ";



                    String fields = "";
                    for (int j = 0; j < vloc.size(); j++) {
                        Location loca = new Location();
                        loca = (Location) vloc.get(j);
                        if (i == j) {
                            fields = fields + ", sum(sd.qty) as loc_" + loca.getCode() + " ";
                        } else {
                            fields = fields + ", 0 as loc_" + loca.getCode() + " ";
                        }

                    }

                    sqlunion = sqlunion + " select sd.product_master_id as idmaster " + fields +
                            " from pos_sales s inner join pos_sales_detail sd on s.sales_id=sd.sales_id " +
                            " where " +
                            where + " group by sd.product_master_id";
                    if ((i + 1) < vloc.size()) {
                        sqlunion = sqlunion + " union ";
                    }


                }

                sqlGabung = " select idmaster " + sumlocnames + " from (" + sqlunion + ") as xx group by idmaster";
            }

            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {

                result.add(rs.getLong("idmaster"));

                for (int b = 0; b < vloc.size(); b++) {
                    Location loc = new Location();
                    loc = (Location) vloc.get(b);
                    result.add(rs.getDouble("tot_" + loc.getCode()));
                }


            }
            return result;



        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;

    }

    public static Hashtable listSalesNonReturReport(Date startDate, Date endDate, long locationId, long groupId) {

        CONResultSet crs = null;
        try {

            String sql = "select ic." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as icCode, " +
                    "ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as icId, " +
                    "ic." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as icName, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as imId, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as imCode, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as imName, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as selling " +
                    " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " inner join " + DbItemGroup.DB_ITEM_GROUP + " ic on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID];

            String where = " ( ps." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_CASH + " or ps." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_CREDIT + " ) ";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + groupId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + "') ";

            if (where.length() > 0) {
                sql = sql + " where ";
            }

            sql = sql + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " order by ic." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + ",im." + DbItemMaster.colNames[DbItemMaster.COL_CODE];


            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Hashtable result = new Hashtable();

            while (rs.next()) {
                RptSalesCategory rsc = new RptSalesCategory();
                rsc.setCategoriId(rs.getLong("icId"));
                rsc.setCode(rs.getString("icCode"));
                rsc.setCategory(rs.getString("icName"));
                rsc.setItemMasterId(rs.getLong("imId"));
                rsc.setName(rs.getString("imName"));
                rsc.setJumlah(rs.getDouble("qty"));
                rsc.setSelling(rs.getDouble("selling"));
                rsc.setSku(rs.getString("imCode"));
                result.put("" + rsc.getItemMasterId(), rsc);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Hashtable listSalesReturReport(Date startDate, Date endDate, long locationId, long groupId) {

        CONResultSet crs = null;
        try {

            String sql = "select ic." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as icCode, " +
                    "ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as icId, " +
                    "ic." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as icName, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as imId, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as imCode, " +
                    "im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as imName, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as selling " +
                    " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " inner join " + DbItemGroup.DB_ITEM_GROUP + " ic on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID];

            String where = " ( ps." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_RETUR_CASH + " or ps." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_RETUR_CREDIT + " ) ";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ic." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + groupId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + "') ";

            if (where.length() > 0) {
                sql = sql + " where ";
            }

            sql = sql + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " order by ic." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + ",im." + DbItemMaster.colNames[DbItemMaster.COL_CODE];


            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Hashtable result = new Hashtable();

            while (rs.next()) {
                RptSalesCategory rsc = new RptSalesCategory();
                rsc.setCategoriId(rs.getLong("icId"));
                rsc.setCode(rs.getString("icCode"));
                rsc.setCategory(rs.getString("icName"));
                rsc.setItemMasterId(rs.getLong("imId"));
                rsc.setName(rs.getString("imName"));
                rsc.setJumlah(rs.getDouble("qty"));
                rsc.setSelling(rs.getDouble("selling"));
                rsc.setSku(rs.getString("imCode"));
                result.put("" + rsc.getItemMasterId(), rsc);
            }

            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector listSalesReportKomisi(Date startDate, Date endDate, long locationId, long vendorId) {

        try {

            Vector vDate = new Vector();
            try {
                vDate = getDate(startDate, endDate);
            } catch (Exception e) {
            }

            CONResultSet crs = null;

            if (vDate != null && vDate.size() > 0) {

                Vector result = new Vector();

                int counter = 1;
                for (int i = 0; i < vDate.size(); i++) {

                    ReportDate rd = (ReportDate) vDate.get(i);

                    String sql = "select ps." + DbSales.colNames[DbSales.COL_DATE] + " as dt " +
                            ",im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name " +
                            ",im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku " +
                            ",sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty " +
                            ",sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as total " +
                            ", un." + DbUom.colNames[DbUom.COL_UNIT] + " as unit from " +
                            DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." +
                            DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " inner join " + DbVendor.DB_VENDOR + " v on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = v." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                            " inner join " + DbUom.DB_UOM + " un on im." + DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES_ID] + " = un." + DbUom.colNames[DbUom.COL_UOM_ID] +
                            "  where ps." + DbSales.colNames[DbSales.COL_DATE] + " >= '" + JSPFormater.formatDate(rd.getPrmDate(), "yyyy-MM-dd") + " 00:00:00' and ps." + DbSales.colNames[DbSales.COL_DATE] + " <= '" + JSPFormater.formatDate(rd.getPrmDate(), "yyyy-MM-dd") + " 23:59:59' and v." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " = " + vendorId +
                            " and ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId +
                            " group by to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ")";

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    while (rs.next()) {
                        ReportKomisi rk = new ReportKomisi();
                        rk.setCounter(counter);
                        rk.setTanggal(rs.getDate("dt"));
                        rk.setName(rs.getString("name"));
                        rk.setSku(rs.getString("sku"));
                        rk.setQty(rs.getDouble("qty"));
                        rk.setTotJual(rs.getDouble("total"));
                        rk.setStn(rs.getString("unit"));
                        result.add(rk);

                    }
                    counter++;
                }
                return result;
            }

        } catch (Exception e) {
        }
        return null;
    }

    public static Vector getDate(Date start, Date end) {

        CONResultSet crs = null;
        try {
            String sql = "select " + DbSales.colNames[DbSales.COL_DATE] + " from " + DbSales.DB_SALES + " where to_days(" + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(" + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') group by to_days(" + DbSales.colNames[DbSales.COL_DATE] + ") order by " + DbSales.colNames[DbSales.COL_DATE];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                ReportDate rd = new ReportDate();
                rd.setPrmDate(rs.getDate(1));
                result.add(rd);
            }
            return result;

        } catch (Exception e) {
        }

        return null;
    }

    public static Vector reportKomisiOld(long locationId, long vendorId, Date start, Date to) {

        CONResultSet crs = null;
        try {

            String sql = "select ps." + DbSales.colNames[DbSales.COL_NUMBER] + " as number," +
                    " ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " as salesId," +
                    " ps." + DbSales.colNames[DbSales.COL_DATE] + " as date," +
                    " m." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," +
                    " m." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name," +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty," +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as sellingprice," +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + ") as amount from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " m on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = " + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];

            String where = "";
            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(to, "yyyy-MM-dd") + "')";

            if (where.length() > 0) {
                sql = sql + " where " + where;
            }

            sql = sql + " group by ps." + DbSales.colNames[DbSales.COL_SALES_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " order by ps." + DbSales.colNames[DbSales.COL_DATE] + "," + DbSales.colNames[DbSales.COL_NUMBER];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                ReportKomisi reportKomisi = new ReportKomisi();

                reportKomisi.setSalesId(rs.getLong("salesId"));
                reportKomisi.setName(rs.getString("name"));
                reportKomisi.setSalesNumber(rs.getString("number"));
                reportKomisi.setQty(rs.getDouble("qty"));
                reportKomisi.setTanggal(rs.getDate("date"));
                reportKomisi.setSku(rs.getString("code"));
                reportKomisi.setSellingPrice(rs.getDouble("sellingprice"));
                reportKomisi.setTotJual(rs.getDouble("amount"));

                result.add(reportKomisi);

            }
            return result;

        } catch (Exception e) {
        }

        return null;
    }

    public static Vector reportKomisi(long locationId, long vendorId, Date start, Date to) {

        CONResultSet crs = null;
        try {

            String where = " and m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " ps." + DbSales.colNames[DbSales.COL_DATE] + " >= '" + JSPFormater.formatDate(start, "yyyy-MM-dd") + " 00:00:00' and ps." + DbSales.colNames[DbSales.COL_DATE] + " <= '" + JSPFormater.formatDate(to, "yyyy-MM-dd") + " 23:59:59 '";

            String sql = " select number,sales_id,date,code,name,sum(qty) as x_qty,sum(selling_price) as x_selling_price,sum(amount) as x_amount,sum(discount_amount) as x_discount_amount from ( " +
                    " select ps.number as number,ps.sales_id as sales_id,ps.date as date,m.code as code,m.name as name,sum(psd.qty) as qty,psd.selling_price,sum(psd.qty * psd.selling_price) as amount,sum(psd.discount_amount) as discount_amount " +
                    " from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_item_master m on psd.product_master_id = m.item_master_id " +
                    " where m.type_item = 2 and ps.type in(0,1) " + where +
                    " group by ps.sales_id,psd.selling_price " +
                    " union " +
                    " select ps.number as number,ps.sales_id as sales_id,ps.date as date,m.code as code,m.name as name,sum(psd.qty) *-1 as qty,psd.selling_price,sum(psd.qty * psd.selling_price)*-1 as amount,sum(psd.discount_amount)*-1 as discount_amount " +
                    " from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_item_master m on psd.product_master_id = m.item_master_id " +
                    " where m.type_item = 2 and ps.type in(2,3) " + where +
                    " group by ps.sales_id,psd.selling_price ) as x group by sales_id,selling_price order by date,number";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                ReportKomisi reportKomisi = new ReportKomisi();

                reportKomisi.setSalesId(rs.getLong("sales_id"));
                reportKomisi.setName(rs.getString("name"));
                reportKomisi.setSalesNumber(rs.getString("number"));
                reportKomisi.setQty(rs.getDouble("x_qty"));
                reportKomisi.setTanggal(rs.getDate("date"));
                reportKomisi.setSku(rs.getString("code"));
                reportKomisi.setSellingPrice(rs.getDouble("x_selling_price"));
                reportKomisi.setTotJual(rs.getDouble("x_amount"));
                reportKomisi.setDiscount(rs.getDouble("x_discount_amount"));

                result.add(reportKomisi);

            }
            return result;

        } catch (Exception e) {
        }

        return null;
    }

    public static Vector reportKomisiByDate(long locationId, long vendorId, Date start, Date to) {

        CONResultSet crs = null;
        try {

            String where = " and m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(to, "yyyy-MM-dd") + "')";

            String sql = " select number,sales_id,date,code,name,sum(qty) as x_qty,sum(selling_price) as x_selling_price,sum(amount) as x_amount,sum(discount_amount) as x_discount_amount from ( " +
                    " select ps.number as number,ps.sales_id as sales_id,ps.date as date,m.code as code,m.name as name,sum(psd.qty) as qty,psd.selling_price,sum((psd.qty * psd.selling_price)-psd.discount_amount) as amount,sum(psd.discount_amount) as discount_amount  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_item_master m on psd.product_master_id = m.item_master_id  where m.type_item = 2 and ps.type in(0,1) " + where + " group by year(ps.date),month(ps.date),date(ps.date) " +
                    " union " +
                    " select ps.number as number,ps.sales_id as sales_id,ps.date as date,m.code as code,m.name as name,sum(psd.qty) *-1 as qty,psd.selling_price,sum((psd.qty * psd.selling_price)-psd.discount_amount)*-1 as amount,sum(psd.discount_amount)*-1 as discount_amount  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_item_master m on psd.product_master_id = m.item_master_id  where m.type_item = 2 and ps.type in(2,3) " + where + " group by year(ps.date),month(ps.date),date(ps.date) " +
                    " ) as x group by year(date),month(date),date(date) order by date;";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                ReportKomisi reportKomisi = new ReportKomisi();

                reportKomisi.setSalesId(rs.getLong("sales_id"));
                reportKomisi.setName(rs.getString("name"));
                reportKomisi.setSalesNumber(rs.getString("number"));
                reportKomisi.setQty(rs.getDouble("x_qty"));
                reportKomisi.setTanggal(rs.getDate("date"));
                reportKomisi.setSku(rs.getString("code"));
                reportKomisi.setSellingPrice(rs.getDouble("x_selling_price"));
                reportKomisi.setTotJual(rs.getDouble("x_amount"));
                reportKomisi.setDiscount(rs.getDouble("x_discount_amount"));

                result.add(reportKomisi);

            }
            return result;

        } catch (Exception e) {
        }

        return null;
    }

    public static Vector incomingKomisi(long locationId, long vendorId, Date start, Date to) {

        CONResultSet crs = null;
        try {

            String sql = "select ps." + DbSales.colNames[DbSales.COL_NUMBER] + " as number," +
                    " ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " as salesId," +
                    " ps." + DbSales.colNames[DbSales.COL_DATE] + " as date," +
                    " m." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," +
                    " m." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name," +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty," +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as sellingprice," +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + ") as amount, psd.sales_detail_id as sales_detail from " +
                    DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " m on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = " + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];

            String where = "";
            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(to, "yyyy-MM-dd") + "')";

            if (where.length() > 0) {
                sql = sql + " where " + where;
            }

            sql = sql + " group by ps." + DbSales.colNames[DbSales.COL_SALES_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " order by ps." + DbSales.colNames[DbSales.COL_DATE] + "," + DbSales.colNames[DbSales.COL_NUMBER];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Vector vdet = new Vector();

                vdet.add(rs.getLong("sales_detail"));
                vdet.add(rs.getString("number"));
                vdet.add(rs.getString("code"));
                vdet.add(rs.getString("name"));
                vdet.add(rs.getDouble("qty"));
                vdet.add(rs.getDate("date"));
                vdet.add(rs.getDouble("sellingprice"));
                vdet.add(rs.getDouble("amount"));

                result.add(vdet);

            }
            return result;

        } catch (Exception e) {
        }

        return null;
    }

    public static double getLastCOGS(long locationId, long itemMasterId, Date endDate) {

        CONResultSet crs = null;

        try {

            String sql = "select sd." + DbSalesDetail.colNames[DbSalesDetail.COL_COGS] + " from " + DbSalesDetail.DB_SALES_DETAIL + " sd inner join " +
                    DbSales.DB_SALES + " s on sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = s." + DbSales.colNames[DbSales.COL_SALES_ID];

            String where = " to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (itemMasterId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = " + itemMasterId;
            }

            sql = sql + " where " + where + " order by s." + DbSales.colNames[DbSales.COL_DATE] + " desc limit 0,1";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                double salesPrice = rs.getDouble(1);
                return salesPrice;

            }
            return 0;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return 0;
    }

    public static Hashtable getVLastCOGS(Date endDate, long vendorId, long locationId, long itemGroupId) {

        CONResultSet crs = null;

        try {

            String sql = "select sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " as item_master,sd." + DbSalesDetail.colNames[DbSalesDetail.COL_COGS] + " as cogs from " + DbSalesDetail.DB_SALES_DETAIL + " sd inner join " +
                    DbSales.DB_SALES + " s on sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = s." + DbSales.colNames[DbSales.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] +
                    " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];

            String where = " to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (itemGroupId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = " + itemGroupId;
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " m." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " s." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            sql = sql + " where " + where + " group by sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " order by sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + ",s." + DbSales.colNames[DbSales.COL_DATE] + " desc";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Hashtable hCogs = new Hashtable();

            while (rs.next()) {
                long itemMasterId = rs.getLong("item_master");
                double salesPrice = rs.getDouble("cogs");
                hCogs.put("" + itemMasterId, "" + salesPrice);
            }
            return hCogs;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return null;
    }

    public static Vector getMerchantSales(Date startDate, Date endDate, long locationId, int typePayment) {

        CONResultSet crs = null;
        try {
            String sql = "select b." + DbBank.colNames[DbBank.COL_NAME] + " as bank, " +
                    " ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id, " +
                    " ps." + DbSales.colNames[DbSales.COL_NUMBER] + " as number," +
                    " ps." + DbSales.colNames[DbSales.COL_DATE] + " as date," +
                    " m." + DbMerchant.colNames[DbMerchant.COL_DESCRIPTION] + " as desc, " +
                    " m." + DbMerchant.colNames[DbMerchant.COL_PERSEN_EXPENSE] + " as exp, " +
                    " m." + DbMerchant.colNames[DbMerchant.COL_CODE_MERCHANT] + " as code, " +
                    " pp." + DbPayment.colNames[DbPayment.COL_MERCHANT_ID] + " as merchant_id, " +
                    " from " + DbSales.DB_SALES + " ps inner join " + DbPayment.DB_PAYMENT + " pp on ps." + DbSales.colNames[DbSales.COL_SALES_ID] +
                    " = pp." + DbPayment.colNames[DbPayment.COL_SALES_ID] + " left join " + DbMerchant.DB_MERCHANT + " m on pp." + DbPayment.colNames[DbPayment.COL_MERCHANT_ID] + " = m." + DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID] +
                    " left join " + DbBank.DB_BANK + " b on m." + DbMerchant.colNames[DbMerchant.COL_BANK_ID] + " = b." + DbBank.colNames[DbBank.COL_BANK_ID] +
                    " where ps.location_id = 504404510178813622 and to_days(ps.date) >= to_days('2013-05-01') and to_days(ps.date) <= to_days('2013-05-31') and pay_type in (1,2);";

            String where = ""; // ps."+DbSales.colNames[DbSales.COL_];

            if (locationId != 0) {
                if (where != null && where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return null;
    }

    public static Vector getKonsinyasiBP(Date startDate, Date endDate, long suplierId, long locationId) {

        CONResultSet crs = null;
        try {

            String sql = "select sku,item_id,item_name,sum(stock_opening) as opening,sum(qty_pembelian) as receiving,sum(qty_tin) as transfer_in,sum(qty_sold) - sum(qty_ret) as sold,sum(qty_tout) as transfer_out,sum(adj) as adjustment,sum(retur) as stock_retur  from ( " +
                    " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,sum(" + DbStock.colNames[DbStock.COL_QTY] + " * " + DbStock.colNames[DbStock.COL_IN_OUT] + ") as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                    " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") < to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + suplierId;

            if (locationId != 0) {
                sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }
            sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";

            sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, sum(" + DbStock.colNames[DbStock.COL_QTY] + ") as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                    " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_INCOMING_GOODS + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + suplierId;

            if (locationId != 0) {
                sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";

            sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,sum(" + DbStock.colNames[DbStock.COL_QTY] + ") as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur  " +
                    " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_TRANSFER_IN + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + suplierId;

            if (locationId != 0) {
                sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }
            sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";

            sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name, 0 as stock_opening, 0 as qty_pembelian,0 as qty_tin,sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty_sold, 0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                    " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (" + DbSales.TYPE_CASH + "," + DbSales.TYPE_CREDIT + ") and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + suplierId;
            if (locationId != 0) {
                sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }
            sql = sql + " group by psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " union ";

            sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name, 0 as stock_opening, 0 as qty_pembelian,0 as qty_tin,0 as qty_sold, sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ")as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                    " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (" + DbSales.TYPE_RETUR_CASH + "," + DbSales.TYPE_RETUR_CREDIT + ") and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + suplierId;
            if (locationId != 0) {
                sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }
            sql = sql + " group by psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " union ";

            sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,sum(" + DbStock.colNames[DbStock.COL_QTY] + ") as qty_tout,0 as adj, 0 as retur " +
                    " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_TRANSFER + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + suplierId;
            if (locationId != 0) {
                sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }
            sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";


            sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,sum(" + DbStock.colNames[DbStock.COL_QTY] + ") as adj, 0 as retur " +
                    " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_ADJUSTMENT + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + suplierId;
            if (locationId != 0) {
                sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }
            sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";

            sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, sum(" + DbStock.colNames[DbStock.COL_QTY] + ") as retur " +
                    " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_RETUR_GOODS + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + suplierId;
            if (locationId != 0) {
                sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }
            sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + ") as x group by item_id ";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Hashtable hCogs = new Hashtable();

            while (rs.next()) {
                ReportKonsinyasiBP rpt = new ReportKonsinyasiBP();
                rpt.setItemMasterId(suplierId);

                long itemMasterId = rs.getLong("item_master");
                double salesPrice = rs.getDouble("cogs");
                hCogs.put("" + itemMasterId, "" + salesPrice);
            }


        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return null;
    }

    public static double getLastHargaBeli(long itemMasterId, Date endDate, long vendorId) {
        CONResultSet crs = null;
        try {
            String sql = "select " + DbVendorItem.colNames[DbVendorItem.COL_LAST_PRICE] + " from " + DbVendorItem.DB_VENDOR_ITEM + " where " +
                    DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID] + " = " + itemMasterId + " and " +
                    " ( to_days(" + DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') or " + DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE] + " is null ) ";

            if (vendorId != 0) {
                sql = sql + " and " + DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID] + " = " + vendorId;
            }

            sql = sql + " order by " + DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE] + " desc limit 0,1 ";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                double tmpPrice = rs.getDouble(1);
                return tmpPrice;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return 0;
    }

    public static double getLastHargaBeli(long itemMasterId) {
        CONResultSet crs = null;
        try {
            String sql = "select " + DbVendorItem.colNames[DbVendorItem.COL_LAST_PRICE] + " from " + DbVendorItem.DB_VENDOR_ITEM + " where " +
                    DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID] + " = " + itemMasterId + " order by " + DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE] + " desc limit 0,1";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                double tmpPrice = rs.getDouble(1);
                return tmpPrice;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return 0;
    }

    public static double getLastPrice(long itemMasterId, Date endDate) {

        CONResultSet crs = null;

        try {

            String sql = " select ri." + DbReceiveItem.colNames[DbReceiveItem.COL_AMOUNT] + " from " + DbReceive.DB_RECEIVE + " r inner join " + DbReceiveItem.DB_RECEIVE_ITEM + " ri " +
                    " on r." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] + " = ri." + DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] +
                    " where r." + DbReceive.colNames[DbReceive.COL_TYPE_AP] + " = " + DbReceive.TYPE_AP_NO + " and " +
                    " to_days(r." + DbReceive.colNames[DbReceive.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";

            if (itemMasterId != 0) {
                sql = sql + " and ri." + DbReceiveItem.colNames[DbReceiveItem.COL_ITEM_MASTER_ID] + " = " + itemMasterId;
            }

            sql = sql + " order by r." + DbReceive.colNames[DbReceive.COL_DATE] + " desc limit 0,1 ";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                double tmpPrice = rs.getDouble(1);
                return tmpPrice;
            }


        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return 0;
    }

    public static double getTotalQtySalesByLoc(Date startDate, Date endDate, long locationId, long itemMasterId) {
        CONResultSet crs = null;
        double result = 0;
        try {

            String sql = "select sum(sd.qty) as jum from pos_sales s inner join pos_sales_detail sd on s.sales_id=sd.sales_id where s.location_id=" + locationId + " and sd.product_master_id=" + itemMasterId + " and to_days(s.date) between to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {

                result = rs.getDouble("jum");

            }
            return result;



        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return result;


    }

    public static double getTotalQtySale(Date startDate, Date endDate, long locationId, long itemMasterId) {
        CONResultSet crs = null;
        double result = 0;
        try {
            String sql = "";
            if (locationId != 0) {
                sql = "select sum(sd.qty) as jum from pos_sales s inner join pos_sales_detail sd on s.sales_id=sd.sales_id where s.location_id=" + locationId + " and sd.product_master_id=" + itemMasterId + " and to_days(s.date) between to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            } else {
                sql = "select sum(sd.qty) as jum from pos_sales s inner join pos_sales_detail sd on s.sales_id=sd.sales_id where sd.product_master_id=" + itemMasterId + " and to_days(s.date) between to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {

                result = rs.getDouble("jum");

            }
            return result;



        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return result;

    }

    public static Vector listSalesByLocation(Date start, Date end, long locationId, int salesType, int paymentType, long userId) {
        CONResultSet crs = null;
        try {

            String sql = "select s.* from " + DbSales.DB_SALES + " s left join " + DbPayment.DB_PAYMENT + " p on s." + DbSales.colNames[DbSales.COL_SALES_ID] +
                    " = p." + DbPayment.colNames[DbPayment.COL_SALES_ID] + " where to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') " +
                    " and to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') and s." + DbSales.colNames[DbSales.COL_SALES_TYPE] + " = " + DbSales.TYPE_NON_CONSIGMENT;

            if (locationId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (salesType != -1) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_TYPE] + " = " + salesType;
            }

            if (paymentType != -1) {
                sql = sql + " and p." + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + paymentType;
            }

            if (userId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_USER_ID] + " = " + userId;
            }

            sql = sql + " order by " + DbSales.colNames[DbSales.COL_DATE] + "," + DbSales.colNames[DbSales.COL_NUMBER];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                Sales sales = new Sales();

                sales.setOID(rs.getLong(DbSales.colNames[DbSales.COL_SALES_ID]));
                sales.setDate(rs.getDate(DbSales.colNames[DbSales.COL_DATE]));
                sales.setNumber(rs.getString(DbSales.colNames[DbSales.COL_NUMBER]));
                sales.setNumberPrefix(rs.getString(DbSales.colNames[DbSales.COL_NUMBER_PREFIX]));
                sales.setCounter(rs.getInt(DbSales.colNames[DbSales.COL_COUNTER]));
                sales.setName(rs.getString(DbSales.colNames[DbSales.COL_NAME]));
                sales.setCustomerId(rs.getLong(DbSales.colNames[DbSales.COL_CUSTOMER_ID]));
                sales.setCustomerPic(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC]));
                sales.setCustomerPicPhone(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC_PHONE]));
                sales.setCustomerAddress(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_ADDRESS]));
                sales.setStartDate(rs.getDate(DbSales.colNames[DbSales.COL_START_DATE]));
                sales.setEndDate(rs.getDate(DbSales.colNames[DbSales.COL_END_DATE]));
                sales.setCustomerPicPosition(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC_POSITION]));
                sales.setEmployeeId(rs.getLong(DbSales.colNames[DbSales.COL_EMPLOYEE_ID]));
                sales.setUserId(rs.getLong(DbSales.colNames[DbSales.COL_USER_ID]));
                sales.setEmployeeHp(rs.getString(DbSales.colNames[DbSales.COL_EMPLOYEE_HP]));
                sales.setDescription(rs.getString(DbSales.colNames[DbSales.COL_DESCRIPTION]));
                sales.setStatus(rs.getInt(DbSales.colNames[DbSales.COL_STATUS]));
                sales.setAmount(rs.getDouble(DbSales.colNames[DbSales.COL_AMOUNT]));
                sales.setCurrencyId(rs.getLong(DbSales.colNames[DbSales.COL_CURRENCY_ID]));
                sales.setCompanyId(rs.getLong(DbSales.colNames[DbSales.COL_COMPANY_ID]));
                sales.setCategoryId(rs.getLong(DbSales.colNames[DbSales.COL_CATEGORY_ID]));
                sales.setDiscountPercent(rs.getDouble(DbSales.colNames[DbSales.COL_DISCOUNT_PERCENT]));
                sales.setDiscountAmount(rs.getDouble(DbSales.colNames[DbSales.COL_DISCOUNT_AMOUNT]));
                sales.setVat(rs.getInt(DbSales.colNames[DbSales.COL_VAT]));
                sales.setVatPercent(rs.getDouble(DbSales.colNames[DbSales.COL_VAT_PERCENT]));
                sales.setVatAmount(rs.getDouble(DbSales.colNames[DbSales.COL_VAT_AMOUNT]));
                sales.setDiscount(rs.getInt(DbSales.colNames[DbSales.COL_DISCOUNT]));
                sales.setWarrantyStatus(rs.getInt(DbSales.colNames[DbSales.COL_WARRANTY_STATUS]));
                sales.setWarrantyDate(rs.getDate(DbSales.colNames[DbSales.COL_WARRANTY_DATE]));
                sales.setWarrantyReceive(rs.getString(DbSales.colNames[DbSales.COL_WARRANTY_RECEIVE]));
                sales.setManualStatus(rs.getInt(DbSales.colNames[DbSales.COL_MANUAL_STATUS]));
                sales.setManualDate(rs.getDate(DbSales.colNames[DbSales.COL_MANUAL_DATE]));
                sales.setManualReceive(rs.getString(DbSales.colNames[DbSales.COL_MANUAL_RECEIVE]));
                sales.setNoteClosing(rs.getString(DbSales.colNames[DbSales.COL_NOTE_CLOSING]));
                sales.setBookingRate(rs.getDouble(DbSales.colNames[DbSales.COL_BOOKING_RATE]));
                sales.setExchangeAmount(rs.getDouble(DbSales.colNames[DbSales.COL_EXCHANGE_AMOUNT]));
                sales.setProposalId(rs.getLong(DbSales.colNames[DbSales.COL_PROPOSAL_ID]));
                sales.setUnitUsahaId(rs.getLong(DbSales.colNames[DbSales.COL_UNIT_USAHA_ID]));
                sales.setType(rs.getInt(DbSales.colNames[DbSales.COL_TYPE]));
                sales.setPphType(rs.getInt(DbSales.colNames[DbSales.COL_PPH_TYPE]));
                sales.setPphPercent(rs.getDouble(DbSales.colNames[DbSales.COL_PPH_PERCENT]));
                sales.setPphAmount(rs.getDouble(DbSales.colNames[DbSales.COL_PPH_AMOUNT]));
                sales.setSalesType(rs.getInt(DbSales.colNames[DbSales.COL_SALES_TYPE]));
                sales.setMarketingId(rs.getLong(DbSales.colNames[DbSales.COL_MARKETING_ID]));
                sales.setLocation_id(rs.getLong(DbSales.colNames[DbSales.COL_LOCATION_ID]));
                sales.setPaymentStatus(rs.getInt(DbSales.colNames[DbSales.COL_PAYMENT_STATUS]));
                sales.setCashCashierId(rs.getLong(DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]));
                sales.setShift_id(rs.getLong(DbSales.colNames[DbSales.COL_SHIFT_ID]));
                sales.setCash_master_id(rs.getLong(DbSales.colNames[DbSales.COL_CASH_MASTER_ID]));
                sales.setPostedStatus(rs.getInt(DbSales.colNames[DbSales.COL_POSTED_STATUS]));
                sales.setPostedById(rs.getLong(DbSales.colNames[DbSales.COL_POSTED_BY_ID]));
                sales.setPostedDate(rs.getDate(DbSales.colNames[DbSales.COL_POSTED_DATE]));
                sales.setEffectiveDate(rs.getDate(DbSales.colNames[DbSales.COL_EFFECTIVE_DATE]));
                sales.setStatus_stock(rs.getInt(DbSales.colNames[DbSales.COL_STATUS_STOCK]));
                sales.setSalesReturId(rs.getLong(DbSales.colNames[DbSales.COL_SALES_RETUR_ID]));
                sales.setServiceAmount(rs.getDouble(DbSales.colNames[DbSales.COL_SERVICE_AMOUNT]));
                sales.setServicePercent(rs.getDouble(DbSales.colNames[DbSales.COL_SERVICE_PERCENT]));
                sales.setSpgId(rs.getLong(DbSales.colNames[DbSales.COL_SPG_ID]));
                sales.setGlobalDiskon(rs.getDouble(DbSales.colNames[DbSales.COL_GLOBAL_DISKON]));
                sales.setGlobalDiskonPercent(rs.getDouble(DbSales.colNames[DbSales.COL_GLOBAL_DISKON_PERCENT]));
                sales.setSopirId(rs.getLong(DbSales.colNames[DbSales.COL_SOPIR_ID]));
                sales.setHelperId(rs.getLong(DbSales.colNames[DbSales.COL_HELPER_ID]));
                sales.setDiskonKartu(rs.getDouble(DbSales.colNames[DbSales.COL_DISKON_KARTU]));
                sales.setTableId(rs.getLong(DbSales.colNames[DbSales.COL_TABLE_ID]));
                sales.setWaitressId(rs.getLong(DbSales.colNames[DbSales.COL_WAITRESS_ID]));
                sales.setJumlahOrang(rs.getInt(DbSales.colNames[DbSales.COL_JUMLAH_ORANG]));
                sales.setBiayaKartu(rs.getDouble(DbSales.colNames[DbSales.COL_BIAYA_KARTU]));
                result.add(sales);
            }

            return result;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());

        } finally {
            CONResultSet.close(crs);
        }
        return null;
    }

    public static Vector listSalesReportBySubCategory2(Date startDate, Date endDate, long locationId, String groupId, long vendorId) {
        CONResultSet crs = null;
        try {
            String where = "";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId.length() > 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " in ( " + groupId + ") ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " ps." + DbSales.colNames[DbSales.COL_DATE] + " >= '" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + " 00:00:00' and ps." + DbSales.colNames[DbSales.COL_DATE] + " <= '" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + " 23:59:59' ";

            if (where.length() > 0) {
                where = " and " + where;
            }

            String sql = "select gid, cdx,igname,sub_id,cd,masterid,nm, sum(totqty) as ttqty,seliing,sum(tot) as tttot, vndx, sum(totdis) as tdiskon " +
                    " from (select 0 as xx,ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + where +
                    " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " union " +
                    " select 1 as xx,ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * -1) as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " * -1) as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * -1) as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " ) as xx group by masterid,seliing order by igname,cd ";


            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                RptSalesCategory rsc = new RptSalesCategory();
                rsc.setCategoriId(rs.getLong("gid"));
                rsc.setCode(rs.getString("cdx"));
                rsc.setSubCategoryId(rs.getLong("sub_id"));
                rsc.setCategory(rs.getString("igname"));
                rsc.setItemMasterId(rs.getLong("masterid"));
                rsc.setName(rs.getString("nm"));
                rsc.setJumlah(rs.getDouble("ttqty"));
                rsc.setSelling(rs.getDouble("seliing"));
                rsc.setSku(rs.getString("cd"));
                rsc.setVendor(rs.getString("vndx"));
                rsc.setDiskon(rs.getDouble("tdiskon"));
                if (rsc.getJumlah() != 0 || rsc.getDiskon() != 0) {
                    result.add(rsc);
                }
            }
            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector listSalesReportBySubCategory(Date startDate, Date endDate, long locationId, String groupId, long vendorId, int orderBy) {
        CONResultSet crs = null;
        try {
            String where = "";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId.length() > 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " in ( " + groupId + ") ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " ps." + DbSales.colNames[DbSales.COL_DATE] + " >= '" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + " 00:00:00' and ps." + DbSales.colNames[DbSales.COL_DATE] + " <= '" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + " 23:59:59' ";

            if (where.length() > 0) {
                where = " and " + where;
            }

            String sql = "select gid, cdx,igname,sub_id,cd,masterid,nm, sum(totqty) as ttqty,seliing,sum(tot) as tttot, vndx, sum(totdis) as tdiskon " +
                    " from (select 0 as xx,ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + where +
                    " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " union " +
                    " select 1 as xx,ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * -1) as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " * -1) as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * -1) as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " ) as xx group by masterid,seliing ";

            if (orderBy == 0) {
                sql = sql + " order by igname,totqty ";
            } else {
                sql = sql + " order by igname,cd ";
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                RptSalesCategory rsc = new RptSalesCategory();
                rsc.setCategoriId(rs.getLong("gid"));
                rsc.setCode(rs.getString("cdx"));
                rsc.setSubCategoryId(rs.getLong("sub_id"));
                rsc.setCategory(rs.getString("igname"));
                rsc.setItemMasterId(rs.getLong("masterid"));
                rsc.setName(rs.getString("nm"));
                rsc.setJumlah(rs.getDouble("ttqty"));
                rsc.setSelling(rs.getDouble("seliing"));
                rsc.setSku(rs.getString("cd"));
                rsc.setVendor(rs.getString("vndx"));
                rsc.setDiskon(rs.getDouble("tdiskon"));
                if (rsc.getJumlah() != 0 || rsc.getDiskon() != 0) {
                    result.add(rsc);
                }
            }
            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static Vector listSalesReportCategoryByQty(Date startDate, Date endDate, long locationId, String groupId, long vendorId, int orderBy) {

        try {
            String where = "";
            if (locationId != 0) {                
                where = where + " and ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (vendorId != 0) {                
                where = where + " and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            where = where + " and ps." + DbSales.colNames[DbSales.COL_DATE] + " >= '" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + " 00:00:00' and ps." + DbSales.colNames[DbSales.COL_DATE] + " <= '" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + " 23:59:59' ";
            
            Vector list = listSalesReportCategory(startDate, endDate, locationId, groupId, vendorId);
            Vector result = new Vector();
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    RptSalesCategory objRsc = (RptSalesCategory) list.get(i);
                    
                    String sqlWhere = where;
                    if (groupId.length() > 0) {                        
                        sqlWhere = sqlWhere + " and ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " +objRsc.getCategoriId();
                    }
                    
                    CONResultSet crs = null;
                    try {
                        String sql = "select gid, cdx,igname,sub_id,cd,masterid,nm, sum(totqty) as ttqty,seliing,sum(tot) as tttot, vndx, sum(totdis) as tdiskon " +
                                " from (select 0 as xx,ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                                " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid, " +
                                " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                                " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd, " +
                                " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                                " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                                " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                                " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as totqty, " +
                                " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                                " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                                " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as totdis, " +
                                " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + sqlWhere +
                                " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + 
                                " union " +                                
                                " select 1 as xx,ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                                " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid," +
                                " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                                " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd," +
                                " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                                " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                                " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                                " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * -1) as totqty, " +
                                " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                                " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                                " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " * -1) as totdis, " +
                                " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * -1) as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                                " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + sqlWhere + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " ) as xx group by masterid,seliing ";

                        if (orderBy == 0) {
                            sql = sql + " order by igname,totqty desc";
                        } else {
                            sql = sql + " order by igname,cd ";
                        }
                        System.out.println("sql "+sql);
                        crs = CONHandler.execQueryResult(sql);
                        ResultSet rs = crs.getResultSet();
                        
                        while (rs.next()) {
                            RptSalesCategory rsc = new RptSalesCategory();
                            rsc.setCategoriId(rs.getLong("gid"));
                            rsc.setCode(rs.getString("cdx"));
                            rsc.setSubCategoryId(rs.getLong("sub_id"));
                            rsc.setCategory(rs.getString("igname"));
                            rsc.setItemMasterId(rs.getLong("masterid"));
                            rsc.setName(rs.getString("nm"));
                            rsc.setJumlah(rs.getDouble("ttqty"));
                            rsc.setSelling(rs.getDouble("seliing"));
                            rsc.setSku(rs.getString("cd"));
                            rsc.setVendor(rs.getString("vndx"));
                            rsc.setDiskon(rs.getDouble("tdiskon"));
                            if (rsc.getJumlah() != 0 || rsc.getDiskon() != 0) {
                                result.add(rsc);
                            }
                        }

                    } catch (Exception e) {
                    }finally {
                        CONResultSet.close(crs);
                    }
                }

            }
            return result;
        } catch (Exception e) {
        } 

        return null;
    }

    public static Vector listSalesReportCategory(Date startDate, Date endDate, long locationId, String groupId, long vendorId) {
        CONResultSet crs = null;
        try {
            String where = "";
            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (groupId.length() > 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " in ( " + groupId + ") ";
            }

            if (vendorId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
            }

            if (where.length() > 0) {
                where = where + " and ";
            }

            where = where + " ps." + DbSales.colNames[DbSales.COL_DATE] + " >= '" + JSPFormater.formatDate(startDate, " yyyy-MM-dd") + " 00:00:00' and ps." + DbSales.colNames[DbSales.COL_DATE] + " <= '" + JSPFormater.formatDate(endDate, " yyyy-MM-dd") + " 23:59:59' ";

            if (where.length() > 0) {
                where = " and " + where;
            }

            String sql = "select gid, cdx,igname,sub_id,cd,masterid,nm, sum(totqty) as ttqty,seliing,sum(tot) as tttot, vndx, sum(totdis) as tdiskon " +
                    " from (select 0 as xx,ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] + " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + where +
                    " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " union " +
                    " select 1 as xx,ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " as sub_id, " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * -1) as totqty, " +
                    " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                    " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " * -1) as totdis, " +
                    " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * -1) as tot from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                    " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+") as tablexx group by gid ";

            sql = sql + " order by ttqty desc ";
            
            System.out.println("sql group "+sql);
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                RptSalesCategory rsc = new RptSalesCategory();
                rsc.setCategoriId(rs.getLong("gid"));
                rsc.setCode(rs.getString("cdx"));
                rsc.setSubCategoryId(rs.getLong("sub_id"));
                rsc.setCategory(rs.getString("igname"));
                rsc.setItemMasterId(rs.getLong("masterid"));
                rsc.setName(rs.getString("nm"));
                rsc.setJumlah(rs.getDouble("ttqty"));
                rsc.setSelling(rs.getDouble("seliing"));
                rsc.setSku(rs.getString("cd"));
                rsc.setVendor(rs.getString("vndx"));
                rsc.setDiskon(rs.getDouble("tdiskon"));
                if (rsc.getJumlah() != 0 || rsc.getDiskon() != 0) {
                    result.add(rsc);
                }
            }
            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }
}
