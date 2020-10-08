/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.ga;

import com.project.ccs.I_Ccs;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbStockMin;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.postransaction.order.Order;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;
import com.project.ccs.postransaction.stock.*;
import com.project.general.DbLocation;
import com.project.general.Location;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class DbGeneralAffairDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_GENERAL_AFFAIR_DETAIL = "pos_general_affair_detail";
    
    public static final int COL_GENERAL_AFFAIR_DETAIL_ID = 0;
    public static final int COL_GENERAL_AFFAIR_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_QTY = 3;
    public static final int COL_PRICE = 4;
    public static final int COL_AMOUNT = 5;
    
    public static final String[] colNames = {
        "general_affair_detail_id",
        "general_affair_id",
        "item_master_id",
        "qty",
        "price",
        "amount"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public DbGeneralAffairDetail() {
    }

    public DbGeneralAffairDetail(int i) throws CONException {
        super(new DbGeneralAffairDetail());
    }

    public DbGeneralAffairDetail(String sOid) throws CONException {
        super(new DbGeneralAffairDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGeneralAffairDetail(long lOid) throws CONException {
        super(new DbGeneralAffairDetail(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return DB_POS_GENERAL_AFFAIR_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGeneralAffairDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        GeneralAffairDetail generalAffairDetail = fetchExc(ent.getOID());
        ent = (Entity) generalAffairDetail;
        return generalAffairDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((GeneralAffairDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((GeneralAffairDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static GeneralAffairDetail fetchExc(long oid) throws CONException {
        try {
            GeneralAffairDetail generalAffairDetail = new GeneralAffairDetail();
            DbGeneralAffairDetail pstGeneralAffairDetail = new DbGeneralAffairDetail(oid);
            generalAffairDetail.setOID(oid);

            generalAffairDetail.setGeneralAffairId(pstGeneralAffairDetail.getlong(COL_GENERAL_AFFAIR_ID));
            generalAffairDetail.setItemMasterId(pstGeneralAffairDetail.getlong(COL_ITEM_MASTER_ID));
            generalAffairDetail.setQty(pstGeneralAffairDetail.getdouble(COL_QTY));
            generalAffairDetail.setPrice(pstGeneralAffairDetail.getdouble(COL_PRICE));
            generalAffairDetail.setAmount(pstGeneralAffairDetail.getdouble(COL_AMOUNT));

            return generalAffairDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGeneralAffairDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(GeneralAffairDetail generalAffairDetail) throws CONException {
        try {
            DbGeneralAffairDetail pstGeneralAffairDetail = new DbGeneralAffairDetail(0);

            pstGeneralAffairDetail.setLong(COL_GENERAL_AFFAIR_ID, generalAffairDetail.getGeneralAffairId());
            pstGeneralAffairDetail.setLong(COL_ITEM_MASTER_ID, generalAffairDetail.getItemMasterId());
            pstGeneralAffairDetail.setDouble(COL_QTY, generalAffairDetail.getQty());
            pstGeneralAffairDetail.setDouble(COL_PRICE, generalAffairDetail.getPrice());
            pstGeneralAffairDetail.setDouble(COL_AMOUNT, generalAffairDetail.getAmount());

            pstGeneralAffairDetail.insert();
            generalAffairDetail.setOID(pstGeneralAffairDetail.getlong(COL_GENERAL_AFFAIR_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGeneralAffairDetail(0), CONException.UNKNOWN);
        }
        return generalAffairDetail.getOID();
    }

    public static long updateExc(GeneralAffairDetail generalAffairDetail) throws CONException {
        try {
            if (generalAffairDetail.getOID() != 0) {
                DbGeneralAffairDetail pstGeneralAffairDetail = new DbGeneralAffairDetail(generalAffairDetail.getOID());

                pstGeneralAffairDetail.setLong(COL_GENERAL_AFFAIR_ID, generalAffairDetail.getGeneralAffairId());
                pstGeneralAffairDetail.setLong(COL_ITEM_MASTER_ID, generalAffairDetail.getItemMasterId());
                pstGeneralAffairDetail.setDouble(COL_QTY, generalAffairDetail.getQty());
                pstGeneralAffairDetail.setDouble(COL_PRICE, generalAffairDetail.getPrice());
                pstGeneralAffairDetail.setDouble(COL_AMOUNT, generalAffairDetail.getAmount());

                pstGeneralAffairDetail.update();
                return generalAffairDetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGeneralAffairDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGeneralAffairDetail pstGeneralAffairDetail = new DbGeneralAffairDetail(oid);
            pstGeneralAffairDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGeneralAffairDetail(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_POS_GENERAL_AFFAIR_DETAIL;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                GeneralAffairDetail generalAffairDetail = new GeneralAffairDetail();
                resultToObject(rs, generalAffairDetail);
                lists.add(generalAffairDetail);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, GeneralAffairDetail generalAffairDetail) {
        try {
            generalAffairDetail.setOID(rs.getLong(DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_GENERAL_AFFAIR_DETAIL_ID]));
            generalAffairDetail.setGeneralAffairId(rs.getLong(DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_GENERAL_AFFAIR_ID]));
            generalAffairDetail.setItemMasterId(rs.getLong(DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_ITEM_MASTER_ID]));
            generalAffairDetail.setQty(rs.getDouble(DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_QTY]));
            generalAffairDetail.setPrice(rs.getDouble(DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_PRICE]));
            generalAffairDetail.setAmount(rs.getDouble(DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_AMOUNT]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long gaItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_GENERAL_AFFAIR_DETAIL + " WHERE " +
                    DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_GENERAL_AFFAIR_DETAIL_ID] + " = " + gaItemId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_GENERAL_AFFAIR_DETAIL_ID] + ") FROM " + DB_POS_GENERAL_AFFAIR_DETAIL;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static void proceedStock(GeneralAffair generalAffair) {

        Vector temp = DbGeneralAffairDetail.list(0, 0, colNames[COL_GENERAL_AFFAIR_ID] + "=" + generalAffair.getOID(), "");
        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                GeneralAffairDetail ci = (GeneralAffairDetail) temp.get(i);
                int x = cekStock(I_Ccs.TYPE_GA,generalAffair.getOID(),ci.getOID());
                if(x==0){
                    insertStockGA(generalAffair, ci);
                }
                
            }
            //proses transfer
            for (int i = 0; i < temp.size(); i++) {
                GeneralAffairDetail ci = (GeneralAffairDetail) temp.get(i);
                ItemMaster im = new ItemMaster();
                try {
                    im = DbItemMaster.fetchExc(ci.getOID());
                } catch (Exception e) {}
                checkRequestTransfer(im, generalAffair.getLocationId());
            }
        }
    }

    public static void insertStockGA(GeneralAffair cos, GeneralAffairDetail ci) {
        ItemMaster im = new ItemMaster();
        try {
            im = DbItemMaster.fetchExc(ci.getItemMasterId());
            Stock stock = new Stock();
            stock.setCostingId(cos.getOID());
            stock.setCostingItemId(ci.getOID());
            stock.setInOut(DbStock.STOCK_OUT);
            stock.setItemBarcode(im.getBarcode());
            stock.setItemCode(im.getCode());
            stock.setItemMasterId(im.getOID());
            stock.setItemName(im.getName());
            stock.setLocationId(cos.getLocationId());            
            stock.setDate(cos.getApproval1Date());            
            stock.setPrice(ci.getPrice());
            stock.setTotal(ci.getPrice() * ci.getQty());
            stock.setQty(ci.getQty());
            stock.setType(I_Ccs.TYPE_GA);
            stock.setUnitId(im.getUomStockId());            
            stock.setUserId(cos.getUserId());
            stock.setStatus(cos.getStatus());
            long oid = DbStock.insertExc(stock);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
    
    public static int cekStock(int type,long mainId,long detailId){
        CONResultSet dbrs = null;
        int x = 0;
        try{
            String sql = "select count(*) as qty from pos_stock where "+DbStock.colNames[DbStock.COL_COSTING_ID]+" = "+mainId+" and "+DbStock.colNames[DbStock.COL_COSTING_ITEM_ID]+" = "+detailId+" and "+DbStock.colNames[DbStock.COL_TYPE]+" = "+type;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                x = rs.getInt("qty");
            }
            rs.close();
            
        }catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);            
        }
        return x;
    }

    public static void checkRequestTransfer(ItemMaster im, long locationId) {

        long itemMasterId = im.getOID();
        try {
            DbOrder.deleteOrder(itemMasterId, locationId);
        } catch (Exception ex) {}

        if (im.getIsAutoOrder() == 1) {

            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(locationId);
            } catch (Exception ex) {
            }

            if (loc.getAktifAutoOrder() == 1 && im.getIsActive() == 1 && im.getNeedRecipe() == 0) {

                double minStock = DbStockMin.getStockMinValue(locationId, itemMasterId);

                if (minStock > 0) {

                    double totalStock = DbStock.getItemTotalStock(locationId, itemMasterId);
                    if (totalStock < 0) {
                        totalStock = 0;
                    }

                    double totalPoPrev = DbStock.getTotalPo(locationId, itemMasterId);// mencari total po yg masih outstanding
                    double totalRequest = DbOrder.getTotalOrder(locationId, itemMasterId); // qty yg sudah pernah di order dengan status draft   
                    double totalTransferDraft = DbStock.getTotalTransfer(locationId, itemMasterId);//mencari transfer ke lokasi ini yang masih out standing

                    if ((totalStock + totalRequest + totalTransferDraft) <= (minStock - im.getDeliveryUnit())) {

                        double qtyRequest = 0;
                        if (im.getDeliveryUnit() > 0) {
                            qtyRequest = (((minStock - (totalRequest + totalStock + totalTransferDraft))) / im.getDeliveryUnit());
                        }
                        qtyRequest = Math.floor(qtyRequest) * im.getDeliveryUnit();

                        if (totalRequest > 0) {//jika sebelumnya sudah ada order maka update qtynya dengan sejumlah order yg baru + qty order sebelumna
                            Vector vOrder = DbOrder.list(0, 0, "im." + DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + itemMasterId + " and ao." + DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + locationId + " and ao." + DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                            if (vOrder != null && vOrder.size() > 0) {
                                Order odrPrev = (Order) vOrder.get(0);
                                try {
                                    odrPrev.setQtyOrder(qtyRequest);
                                    odrPrev.setQtyStock((totalStock));
                                    DbOrder.updateExc(odrPrev);
                                } catch (Exception ex) {

                                }
                            }
                        } else {
                            //otomatis buatkan order;
                            try {

                                int nextCounter;
                                nextCounter = DbOrder.getNextCounter();

                                Order order = new Order();
                                order.setCounter(nextCounter);
                                order.setPrefixNumber(DbOrder.getNumberPrefix());
                                order.setNumber(DbOrder.getNextNumber(nextCounter));
                                order.setQtyOrder(qtyRequest);
                                order.setDate(new Date());
                                order.setQtyStock((totalStock + totalRequest));
                                order.setQtyPoPrev(totalPoPrev);
                                order.setQtyStandar(minStock);
                                order.setLocationId(locationId);
                                order.setItemMasterId(itemMasterId);
                                order.setStatus("DRAFT");
                                DbOrder.insertExc(order);
                            } catch (Exception ex) {}
                        }


                    } else {
                        if ((totalStock + totalTransferDraft) >= (minStock - im.getDeliveryUnit())) {
                            Vector vOrder = DbOrder.list(0, 0, "im." + DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + itemMasterId + " and ao." + DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + locationId + " and ao." + DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                            if (vOrder != null && vOrder.size() > 0) {
                                Order odrPrev = (Order) vOrder.get(0);
                                try {
                                    odrPrev.setStatus("APPROVED");
                                    DbOrder.updateExc(odrPrev);
                                } catch (Exception ex) {

                                }
                            }
                        } else {


                            if (totalRequest != 0) {
                                Vector vOrder = DbOrder.list(0, 0, "im." + DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + itemMasterId + " and ao." + DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + locationId + " and ao." + DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                                if (vOrder != null && vOrder.size() > 0) {
                                    Order odrPrev = (Order) vOrder.get(0);
                                    try {
                                        //jika terjadi perubahan poprev dan standar stock maka update order yg masih draft
                                        if ((odrPrev.getQtyPoPrev() != totalPoPrev) || (odrPrev.getQtyStandar() != minStock)) {

                                            double qtyRequest;

                                            qtyRequest = (((minStock - (totalRequest + totalStock + totalTransferDraft))) / im.getDeliveryUnit());
                                            qtyRequest = Math.floor(qtyRequest) * im.getDeliveryUnit();
                                            if (qtyRequest > 0) {
                                                odrPrev.setQtyPoPrev(totalPoPrev);
                                                odrPrev.setQtyOrder(qtyRequest);
                                                odrPrev.setQtyStock((totalStock));
                                                odrPrev.setQtyStandar(minStock);

                                                odrPrev.setDate(new Date());
                                                DbOrder.updateExc(odrPrev);
                                            }
                                        }


                                    } catch (Exception ex) {

                                    }
                                }

                            }

                        }
                    }

                }//min stock>0

            }//if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){

        }//if(im.getIsAutoOrder()==1){
    }

    public static int deleteAllItem(long oidGA) {
        int result = 0;
        String sql = "delete from " + DB_POS_GENERAL_AFFAIR_DETAIL + " where " + colNames[COL_GENERAL_AFFAIR_ID] + " = " + oidGA;
        try {
            CONHandler.execUpdate(sql);
        } catch (Exception e) {
            result = -1;
        }

        return result;
    }
    
    public static long deleteStock(String where ) throws CONException {
        try {
            String sql = "DELETE FROM " + DbStock.DB_POS_STOCK +
                        " WHERE " + where;
            CONHandler.execUpdate(sql);
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {}
        return 1;
    }

    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    GeneralAffairDetail generalAffairDetail = (GeneralAffairDetail) list.get(ls);
                    if (oid == generalAffairDetail.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }

        return start;
    }

    public static double getTotalQty(long gaId, String colNames) {
        CONResultSet dbrs = null;
        double totalQty = 0.0;
        try {
            String sql = "SELECT SUM(" + colNames + ") as TOTALQTY FROM " + DB_POS_GENERAL_AFFAIR_DETAIL + " WHERE " +
                    DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_GENERAL_AFFAIR_ID] + " = " + gaId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                totalQty = rs.getDouble("TOTALQTY");
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return totalQty;
        }
    }
}
