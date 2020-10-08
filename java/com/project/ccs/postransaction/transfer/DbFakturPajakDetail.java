package com.project.ccs.postransaction.transfer;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;
import com.project.ccs.postransaction.*;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.sales.SalesDetail;
import com.project.ccs.postransaction.stock.*;

public class DbFakturPajakDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_FAKTUR_PAJAK_DETAIL = "faktur_pajak_detail";
    public static final int COL_FAKTUR_PAJAK_DETAIL_ID = 0;
    public static final int COL_FAKTUR_PAJAK_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_ITEM_NAME = 3;
    public static final int COL_TOTAL=4;
    public static final int COL_DISCOUNT=5;
    public static final int COL_QTY=6;
    public static final int COL_TRANSFER_ID=7;
    public static final int COL_PRICE = 8;
    public static final int COL_SALES_ID = 9;
    public static final int COL_DATE = 10;
    public static final int COL_COUNTER = 11;
    
    public static final String[] colNames = {
        "faktur_pajak_detail_id", 
        "faktur_pajak_id",
        "item_master_id",
        "item_name",
        "total",
        "discount",   
        "qty",
        "transfer_id",
        "price",
        "sales_id",
        "date",
        "counter"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT
    };
    
    public DbFakturPajakDetail() {
    }

    public DbFakturPajakDetail(int i) throws CONException {
        super(new DbFakturPajakDetail());
    }

    public DbFakturPajakDetail(String sOid) throws CONException {
        super(new DbFakturPajakDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFakturPajakDetail(long lOid) throws CONException {
        super(new DbFakturPajakDetail(0));
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
        return DB_POS_FAKTUR_PAJAK_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbFakturPajakDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        FakturPajakDetail fakturDetail = fetchExc(ent.getOID());
        ent = (Entity) fakturDetail;
        return fakturDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((FakturPajakDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((TransferItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static FakturPajakDetail fetchExc(long oid) throws CONException {
        try {
            FakturPajakDetail fakturDetail = new FakturPajakDetail();
            DbFakturPajakDetail pstTransferItem = new DbFakturPajakDetail(oid);
            fakturDetail.setOID(oid);

            fakturDetail.setFakturPajakId(pstTransferItem.getlong(COL_FAKTUR_PAJAK_ID));
            fakturDetail.setItemMasterId(pstTransferItem.getlong(COL_ITEM_MASTER_ID));
            fakturDetail.setItemName(pstTransferItem.getString(COL_ITEM_NAME));
            fakturDetail.setTotal(pstTransferItem.getdouble(COL_TOTAL));            
            fakturDetail.setDiscount(pstTransferItem.getdouble(COL_DISCOUNT));
            fakturDetail.setQty(pstTransferItem.getdouble(COL_QTY));
            fakturDetail.setTransferId(pstTransferItem.getlong(COL_TRANSFER_ID));
            fakturDetail.setPrice(pstTransferItem.getdouble(COL_PRICE));
            fakturDetail.setSalesId(pstTransferItem.getlong(COL_SALES_ID));
            fakturDetail.setDate(pstTransferItem.getDate(COL_DATE));
            fakturDetail.setCounter(pstTransferItem.getInt(COL_COUNTER));
            
            return fakturDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFakturPajakDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(FakturPajakDetail fakturDetail) throws CONException {
        try {
            DbFakturPajakDetail pstTransferItem = new DbFakturPajakDetail(0);

            pstTransferItem.setLong(COL_FAKTUR_PAJAK_ID, fakturDetail.getFakturPajakId());
            pstTransferItem.setLong(COL_ITEM_MASTER_ID, fakturDetail.getItemMasterId());
            pstTransferItem.setString(COL_ITEM_NAME, fakturDetail.getItemName());
            pstTransferItem.setDouble(COL_TOTAL, fakturDetail.getTotal());
            pstTransferItem.setDouble(COL_DISCOUNT, fakturDetail.getDiscount());
            pstTransferItem.setDouble(COL_QTY, fakturDetail.getQty());
            pstTransferItem.setLong(COL_TRANSFER_ID, fakturDetail.getTransferId());
            pstTransferItem.setDouble(COL_PRICE, fakturDetail.getPrice());
            pstTransferItem.setLong(COL_SALES_ID, fakturDetail.getSalesId());
            pstTransferItem.setDate(COL_DATE, fakturDetail.getDate());
            pstTransferItem.setInt(COL_COUNTER, fakturDetail.getCounter());
            
            pstTransferItem.insert();
            fakturDetail.setOID(pstTransferItem.getlong(COL_FAKTUR_PAJAK_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFakturPajakDetail(0), CONException.UNKNOWN);
        }
        return  fakturDetail.getOID();
    }

    public static long updateExc(FakturPajakDetail fakturPajakDetail) throws CONException {
        try {
            if (fakturPajakDetail.getOID() != 0) {
                DbFakturPajakDetail pstTransferItem = new DbFakturPajakDetail(fakturPajakDetail.getOID());

                pstTransferItem.setLong(COL_FAKTUR_PAJAK_ID, fakturPajakDetail.getFakturPajakId());
                pstTransferItem.setLong(COL_ITEM_MASTER_ID, fakturPajakDetail.getItemMasterId());
                pstTransferItem.setString(COL_ITEM_NAME, fakturPajakDetail.getItemName());
                pstTransferItem.setDouble(COL_TOTAL, fakturPajakDetail.getTotal());
                pstTransferItem.setDouble(COL_DISCOUNT, fakturPajakDetail.getDiscount());
                pstTransferItem.setDouble(COL_QTY, fakturPajakDetail.getQty());
                pstTransferItem.setLong(COL_TRANSFER_ID, fakturPajakDetail.getTransferId());
                pstTransferItem.setDouble(COL_PRICE, fakturPajakDetail.getPrice());
                pstTransferItem.setLong(COL_SALES_ID, fakturPajakDetail.getSalesId());
                pstTransferItem.setDate(COL_DATE, fakturPajakDetail.getDate());
                pstTransferItem.setInt(COL_COUNTER, fakturPajakDetail.getCounter());
                
                pstTransferItem.update();
                return fakturPajakDetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFakturPajakDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFakturPajakDetail pstTransferItem = new DbFakturPajakDetail(oid);
            pstTransferItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFakturPajakDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_FAKTUR_PAJAK_DETAIL;
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
                FakturPajakDetail fakturDetail = new FakturPajakDetail();
                resultToObject(rs, fakturDetail);
                lists.add(fakturDetail);
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

    private static void resultToObject(ResultSet rs, FakturPajakDetail fakturDetail) {
        try {
            fakturDetail.setOID(rs.getLong(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_DETAIL_ID]));
            fakturDetail.setFakturPajakId(rs.getLong(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID]));
            fakturDetail.setItemMasterId(rs.getLong(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_ITEM_MASTER_ID]));
            fakturDetail.setItemName(rs.getString(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_ITEM_NAME]));
            fakturDetail.setTotal(rs.getDouble(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_TOTAL]));
            fakturDetail.setDiscount(rs.getDouble(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_DISCOUNT]));            
            fakturDetail.setQty(rs.getDouble(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_QTY]));
            fakturDetail.setTransferId(rs.getLong(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_TRANSFER_ID]));
            fakturDetail.setPrice(rs.getDouble(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_PRICE]));
            fakturDetail.setSalesId(rs.getLong(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_SALES_ID]));
            fakturDetail.setDate(rs.getDate(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_DATE]));
            fakturDetail.setCounter(rs.getInt(DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_COUNTER]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long transferItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_FAKTUR_PAJAK_DETAIL + " WHERE " +
                    DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_DETAIL_ID] + " = " + transferItemId;

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
            String sql = "SELECT COUNT(" + DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_DETAIL_ID] + ") FROM " + DB_POS_FAKTUR_PAJAK_DETAIL;
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
                    TransferItem transferitem = (TransferItem) list.get(ls);
                    if (oid == transferitem.getOID()) {
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
   
    
    public static int deleteAllItem(long oidFaktur){
        
        int result = 0;
        
        String sql = "delete from "+DB_POS_FAKTUR_PAJAK_DETAIL+" where "+colNames[COL_FAKTUR_PAJAK_ID]+" = "+oidFaktur;
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }
    
     public static int deleteAllItem(String where){
        
        int result = 0;
        
        String sql = "delete from "+DB_POS_FAKTUR_PAJAK_DETAIL+" where "+where;
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }
     
     public static int getCount(long transferId) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_DETAIL_ID] + ") FROM " + DB_POS_FAKTUR_PAJAK_DETAIL
                    + " WHERE "+DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_TRANSFER_ID]+" = "+transferId;

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
     
     public static int getCountSales(long salesId) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_DETAIL_ID] + ") FROM " + DB_POS_FAKTUR_PAJAK_DETAIL
                    + " WHERE "+DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_SALES_ID]+" = "+salesId;

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
     
     public static int updateCounter(long fakturPajakDetailId,int counter){
        
        int result = 0;
        
        String sql = "update "+DB_POS_FAKTUR_PAJAK_DETAIL+" set "+DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_COUNTER]+" = "+counter+" where "+colNames[COL_FAKTUR_PAJAK_DETAIL_ID]+" = "+fakturPajakDetailId;
        
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }
     
     
     public static Vector getSalesDetail(String where,String order ){
         CONResultSet dbrs = null;
         try{
             
             String sql = "SELECT sd.* from "+DbSalesDetail.DB_SALES_DETAIL+" sd inner join "+DbItemMaster.DB_ITEM_MASTER+" im on sd."
                     +DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];
                     
             if(where.length() > 0)        {
                 sql = sql +" where "+where;
             }
             
             if(order.length() > 0){
                 sql = sql + " order by "+order;
             }
              
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
             
            Vector result = new Vector();
            
            while(rs.next()) {
                SalesDetail salesDetail = new SalesDetail();
                salesDetail.setOID(rs.getLong(DbSalesDetail.colNames[DbSalesDetail.COL_SALES_DETAIL_ID]));
                salesDetail.setSalesId(rs.getLong(DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]));
		salesDetail.setProductMasterId(rs.getLong(DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]));
		salesDetail.setSquence(rs.getInt(DbSalesDetail.colNames[DbSalesDetail.COL_SQUENCE]));
		salesDetail.setCogs(rs.getDouble(DbSalesDetail.colNames[DbSalesDetail.COL_COGS]));
		salesDetail.setSellingPrice(rs.getDouble(DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]));
		salesDetail.setStatus(rs.getInt(DbSalesDetail.colNames[DbSalesDetail.COL_STATUS]));
		salesDetail.setCurrencyId(rs.getLong(DbSalesDetail.colNames[DbSalesDetail.COL_CURRENCY_ID]));
		salesDetail.setCompanyId(rs.getLong(DbSalesDetail.colNames[DbSalesDetail.COL_COMPANY_ID]));
		salesDetail.setQty(rs.getDouble(DbSalesDetail.colNames[DbSalesDetail.COL_QTY]));
		salesDetail.setTotal(rs.getDouble(DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL]));
                salesDetail.setDiscountPercent(rs.getDouble(DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_PERCENT]));
                salesDetail.setDiscountAmount(rs.getDouble(DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]));
                salesDetail.setProposalId(rs.getLong(DbSalesDetail.colNames[DbSalesDetail.COL_PROPOSAL_ID]));
                salesDetail.setSalesType(rs.getInt(DbSalesDetail.colNames[DbSalesDetail.COL_SALES_TYPE]));
                salesDetail.setSerial_number(rs.getString(DbSalesDetail.colNames[DbSalesDetail.COL_SERIAL_NUMBER]));
		result.add(salesDetail);
            }
            rs.close();
            return result;
         }catch(Exception e){
            System.out.println("[exception] "+e.toString());
         } finally {
            CONResultSet.close(dbrs);
         }
         return null;
         
     }
    
}
