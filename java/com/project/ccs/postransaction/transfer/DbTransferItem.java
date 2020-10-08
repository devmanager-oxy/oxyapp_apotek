package com.project.ccs.postransaction.transfer;

//import com.gargoylesoftware.htmlunit.javascript.host.Location;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;
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
import com.project.ccs.postransaction.stock.*;
import com.project.ccs.report.SessTransferAnalist;
import com.project.ccs.report.SrcTransferReport;
import com.project.general.DbLocation;
import com.project.general.*;
import com.project.util.*;

public class DbTransferItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_TRANSFER_ITEM = "pos_transfer_item";
    public static final int COL_TRANSFER_ITEM_ID = 0;
    public static final int COL_TRANSFER_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_QTY = 3;
    public static final int COL_PRICE = 4;
    public static final int COL_AMOUNT = 5;
    public static final int COL_NOTE = 6;
    public static final int COL_EXP_DATE = 7;
    public static final int COL_TYPE = 8;
    public static final int COL_QTY_REQUEST = 9;
    public static final int COL_ITEM_BARCODE = 10;
    public static final int COL_QTY_STOCK = 11;
    
    public static final String[] colNames = {
        "transfer_item_id", 
        "transfer_id",
        "item_master_id",
        "qty",
        "price",
        "amount",
        "note",
        "exp_date",
        "type",
        "qty_request",
        "item_barcode",
        "qty_stock"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_FLOAT
    };
    public static final int TYPE_NON_CONSIGMENT = 0;
    public static final int TYPE_CONSIGMENT = 1;
    
    public DbTransferItem() {
    }

    public DbTransferItem(int i) throws CONException {
        super(new DbTransferItem());
    }

    public DbTransferItem(String sOid) throws CONException {
        super(new DbTransferItem(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbTransferItem(long lOid) throws CONException {
        super(new DbTransferItem(0));
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
        return DB_POS_TRANSFER_ITEM;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbTransferItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        TransferItem transferitem = fetchExc(ent.getOID());
        ent = (Entity) transferitem;
        return transferitem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((TransferItem) ent);
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

    public static TransferItem fetchExc(long oid) throws CONException {
        try {
            TransferItem transferitem = new TransferItem();
            DbTransferItem pstTransferItem = new DbTransferItem(oid);
            transferitem.setOID(oid);

            transferitem.setTransferId(pstTransferItem.getlong(COL_TRANSFER_ID));
            transferitem.setItemMasterId(pstTransferItem.getlong(COL_ITEM_MASTER_ID));
            transferitem.setQty(pstTransferItem.getdouble(COL_QTY));
            transferitem.setPrice(pstTransferItem.getdouble(COL_PRICE));
            transferitem.setAmount(pstTransferItem.getdouble(COL_AMOUNT));
            transferitem.setNote(pstTransferItem.getString(COL_NOTE));
            transferitem.setExpDate(pstTransferItem.getDate(COL_EXP_DATE));
            transferitem.setType(pstTransferItem.getInt(COL_TYPE));
            transferitem.setQtyRequest(pstTransferItem.getdouble(COL_QTY_REQUEST));
            transferitem.setItemBarcode(pstTransferItem.getString(COL_ITEM_BARCODE));
            transferitem.setQtyStock(pstTransferItem.getdouble(COL_QTY_STOCK));
            
            return transferitem;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferItem(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(TransferItem transferitem) throws CONException {
        try {
            DbTransferItem pstTransferItem = new DbTransferItem(0);

            pstTransferItem.setLong(COL_TRANSFER_ID, transferitem.getTransferId());
            pstTransferItem.setLong(COL_ITEM_MASTER_ID, transferitem.getItemMasterId());
            pstTransferItem.setDouble(COL_QTY, transferitem.getQty());
            pstTransferItem.setDouble(COL_PRICE, transferitem.getPrice());
            pstTransferItem.setDouble(COL_AMOUNT, transferitem.getAmount());
            pstTransferItem.setString(COL_NOTE, transferitem.getNote());
            pstTransferItem.setDate(COL_EXP_DATE, transferitem.getExpDate());
            pstTransferItem.setInt(COL_TYPE, transferitem.getType());
            pstTransferItem.setDouble(COL_QTY_REQUEST, transferitem.getQtyRequest());
            pstTransferItem.setString(COL_ITEM_BARCODE, transferitem.getItemBarcode());
            pstTransferItem.setDouble(COL_QTY_STOCK, transferitem.getQtyStock());
            
            pstTransferItem.insert();
            transferitem.setOID(pstTransferItem.getlong(COL_TRANSFER_ITEM_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferItem(0), CONException.UNKNOWN);
        }
        return transferitem.getOID();
    }

    public static long updateExc(TransferItem transferitem) throws CONException {
        try {
            if (transferitem.getOID() != 0) {
                DbTransferItem pstTransferItem = new DbTransferItem(transferitem.getOID());

                pstTransferItem.setLong(COL_TRANSFER_ID, transferitem.getTransferId());
                pstTransferItem.setLong(COL_ITEM_MASTER_ID, transferitem.getItemMasterId());
                pstTransferItem.setDouble(COL_QTY, transferitem.getQty());
                pstTransferItem.setDouble(COL_PRICE, transferitem.getPrice());
                pstTransferItem.setDouble(COL_AMOUNT, transferitem.getAmount());
                pstTransferItem.setString(COL_NOTE, transferitem.getNote());
                pstTransferItem.setDate(COL_EXP_DATE, transferitem.getExpDate());
                pstTransferItem.setInt(COL_TYPE, transferitem.getType());
                pstTransferItem.setDouble(COL_QTY_REQUEST, transferitem.getQtyRequest());
                pstTransferItem.setString(COL_ITEM_BARCODE, transferitem.getItemBarcode());
                pstTransferItem.setDouble(COL_QTY_STOCK, transferitem.getQtyStock());
                pstTransferItem.update();
                return transferitem.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferItem(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbTransferItem pstTransferItem = new DbTransferItem(oid);
            pstTransferItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferItem(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_TRANSFER_ITEM;
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
                TransferItem transferitem = new TransferItem();
                resultToObject(rs, transferitem);
                lists.add(transferitem);
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

    public static Vector listRequest(long itemMasterId) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT t.transfer_id, t.number, t.to_location_id, ti.item_master_id, ti.qty from pos_transfer t inner join pos_transfer_item ti on t.transfer_id=ti.transfer_id where t.status='REQUEST' order by ti.item_master_id";
            
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                //TransferItem transferitem = new TransferItem();
                SessTransferAnalist st = new SessTransferAnalist();
                st.setItemMasterId(rs.getLong("item_master_id"));
                    ItemMaster im = DbItemMaster.fetchExc(rs.getLong("item_master_id"));
                st.setItemName(im.getName());
                st.setTransferId(rs.getLong("transfer_id"));
                st.setTransferNumber(rs.getString("number"));
                Location location = location = DbLocation.fetchExc(rs.getLong("to_location_id"));
                st.setLocationName(location.getName());
                st.setQty(rs.getDouble("qty"));
                st.setToLocationId(rs.getLong("to_location_id"));
                
                lists.add(st);
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
    
    public static Vector listRequestByLocation(long locationId) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT t.transfer_id, t.number, t.to_location_id, ti.item_master_id, ti.qty from pos_transfer t inner join pos_transfer_item ti on t.transfer_id=ti.transfer_id where t.status='REQUEST' and t.to_location_id=" + locationId +" order by ti.item_master_id";
            
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                //TransferItem transferitem = new TransferItem();
                SessTransferAnalist st = new SessTransferAnalist();
                st.setItemMasterId(rs.getLong("item_master_id"));
                    ItemMaster im = DbItemMaster.fetchExc(rs.getLong("item_master_id"));
                st.setItemName(im.getName());
                st.setTransferId(rs.getLong("transfer_id"));
                st.setTransferNumber(rs.getString("number"));
                Location location = location = DbLocation.fetchExc(rs.getLong("to_location_id"));
                st.setLocationName(location.getName());
                st.setQty(rs.getDouble("qty"));
                st.setToLocationId(rs.getLong("to_location_id"));
                
                lists.add(st);
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
    
    public static Vector getItemTransfer(SrcTransferReport srcTransferReport) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            
            String sql = "";
            //if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_TRANSAKSI){
             // sql = "SELECT pi.item_master_id, im.name, " +
                  
            //}else{
              sql = "SELECT pi.item_master_id " +
                    "FROM `pos_transfer_item` as pi " +
                    "inner join pos_transfer p on pi.transfer_id=p.transfer_id " +
                    "inner join pos_item_master as im on pi.item_master_id=im.item_master_id ";
            //}

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
            //consigment or nonconsigment
            //if(where.length()>0){
            //    where = where + " and p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
            //}else{
            //    where = "p." + DbTransfer.colNames[DbTransfer.COL_TYPE]+ "=" + type;
            //}
            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;

            
            sql = sql + " group by ";

            switch(srcTransferReport.getGroupBy()){
                case SrcTransferReport.GROUP_TRANSAKSI:
                    sql = sql + "p.transfer_id ";
                    break;
                case SrcTransferReport.GROUP_ITEM:
                    sql = sql + "im.item_master_id ";
                    break;
            }
             
            
            //if(srcTransferReport.getGroupBy()==SrcTransferReport.GROUP_ITEM){
            //    sql = sql + "group by im.item_master_id ";
           // }

            
            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TransferItem transferItem = new TransferItem();
                transferItem.setItemMasterId((rs.getLong("item_master_id")));
                

                list.add(transferItem);
            } 
        } catch (Exception e) {
            System.out.println("Err >>> : " + e.toString());
        }
        return list;
    }

    
    private static void resultToObject(ResultSet rs, TransferItem transferitem) {
        try {
            transferitem.setOID(rs.getLong(DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID]));
            transferitem.setTransferId(rs.getLong(DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ID]));
            transferitem.setItemMasterId(rs.getLong(DbTransferItem.colNames[DbTransferItem.COL_ITEM_MASTER_ID]));
            transferitem.setQty(rs.getDouble(DbTransferItem.colNames[DbTransferItem.COL_QTY]));
            transferitem.setPrice(rs.getDouble(DbTransferItem.colNames[DbTransferItem.COL_PRICE]));
            transferitem.setAmount(rs.getDouble(DbTransferItem.colNames[DbTransferItem.COL_AMOUNT]));
            transferitem.setNote(rs.getString(DbTransferItem.colNames[DbTransferItem.COL_NOTE]));
            transferitem.setExpDate(rs.getDate(DbTransferItem.colNames[DbTransferItem.COL_EXP_DATE]));
            transferitem.setType(rs.getInt(DbTransferItem.colNames[DbTransferItem.COL_TYPE]));
            transferitem.setQtyRequest(rs.getDouble(DbTransferItem.colNames[DbTransferItem.COL_QTY_REQUEST]));
            transferitem.setItemBarcode(rs.getString(DbTransferItem.colNames[DbTransferItem.COL_ITEM_BARCODE]));
            transferitem.setQtyStock(rs.getDouble(DbTransferItem.colNames[DbTransferItem.COL_QTY_STOCK]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long transferItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_TRANSFER_ITEM + " WHERE " +
                    DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID] + " = " + transferItemId;

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
            String sql = "SELECT COUNT(" + DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID] + ") FROM " + DB_POS_TRANSFER_ITEM;
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

    public static double getTotalTransferAmount(long transferOID){
        double result = 0;
        CONResultSet crs = null;
        try{
            String sql = " select sum("+DbTransferItem.colNames[DbTransferItem.COL_AMOUNT]+") from "+DB_POS_TRANSFER_ITEM+
                         " where "+colNames[COL_TRANSFER_ID]+"="+transferOID;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                result = rs.getDouble(1);
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        return result;
    }
    
    public static int deleteAllItem(long oidTransfer){
        
        int result = 0;
        
        String sql = "delete from "+DB_POS_TRANSFER_ITEM+" where "+colNames[COL_TRANSFER_ID]+" = "+oidTransfer;
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }
    
    
    public static void proceedStock(Transfer transfer){
        
        System.out.println("in inserting stock - transfer ...");    
            
        Vector temp = DbTransferItem.list(0,0, colNames[COL_TRANSFER_ID]+"="+transfer.getOID(), "");
        
        //System.out.println("temp : "+temp);    
        
        if(temp!=null && temp.size()>0){
            for(int i=0; i<temp.size(); i++){
                TransferItem ri = (TransferItem)temp.get(i);                
                insertTransferGoods(transfer, ri);                
            }            
        }
        
    }
    
    public static void insertTransferGoods(Transfer rec, TransferItem ri){
            
        ItemMaster im = new ItemMaster();
        //Uom uom = new Uom();

        //---- keluarkan stock --------

        try{

            //System.out.println("inserting new stock ...");
            im = DbItemMaster.fetchExc(ri.getItemMasterId());
            //uom = DbUom.fetchExc(im.getUomStockId());

            Stock stock = new Stock();
            stock.setTransferId(ri.getTransferId());
            stock.setInOut(DbStock.STOCK_OUT);
            stock.setItemBarcode(im.getBarcode());
            stock.setItemCode(im.getCode());
            stock.setItemMasterId(im.getOID());
            stock.setItemName(im.getName());
            stock.setLocationId(rec.getFromLocationId());
            stock.setDate(rec.getApproval1Date());//Date());
            stock.setNoFaktur(rec.getNumber());
            //harga ambil harga average terakhir
            stock.setPrice(im.getCogs());
            stock.setTotal(im.getCogs()*ri.getQty());
            stock.setQty(ri.getQty());
            stock.setType(DbStock.TYPE_TRANSFER);
            stock.setUnitId(im.getUomStockId());
            stock.setUnit("");//uom.getUnit());
            stock.setUserId(rec.getUserId());
            stock.setType_item(rec.getType());
            stock.setTransfer_item_id(ri.getOID());
            stock.setStatus(rec.getStatus());
            
            long oidS = DbStock.insertExc(stock);
            
            System.out.println("in DbTransferItem - transfer out ... done ");
            
            if(oidS!=0){
                try{

                    //System.out.println("inserting new stock ...");
                    stock.setInOut(DbStock.STOCK_IN);
                    stock.setLocationId(rec.getToLocationId());
                    stock.setType(DbStock.TYPE_TRANSFER_IN);
                    
                    DbStock.insertExc(stock);
                    
                    System.out.println("transfer in ... done -- ^_^ ");

                    /*Stock stockIn = new Stock();
                    stockIn.setTransferId(ri.getTransferId());
                    stockIn.setInOut(DbStock.STOCK_IN);
                    stockIn.setItemBarcode(im.getBarcode());
                    stockIn.setItemCode(im.getCode());
                    stockIn.setItemMasterId(im.getOID());
                    stockIn.setItemName(im.getName());
                    stockIn.setLocationId(rec.getToLocationId());
                    stockIn.setDate(rec.getApproval1Date());//Date());
                    stockIn.setNoFaktur(rec.getNumber());
                    //harga ambil harga average terakhir
                    stockIn.setPrice(im.getCogs());
                    stockIn.setTotal(im.getCogs()*ri.getQty());
                    stockIn.setQty(ri.getQty());
                    stockIn.setType(DbStock.TYPE_TRANSFER_IN);
                    stockIn.setUnitId(im.getUomStockId());
                    stockIn.setUnit("");//uom.getUnit());
                    stockIn.setUserId(rec.getUserId());
                    stockIn.setType_item(rec.getType());
                    stockIn.setTransfer_item_id(ri.getOID());
                    stockIn.setStatus(rec.getStatus());
                    
                    DbStock.insertExc(stockIn);

                    System.out.println("transfer in ... done ");
                     */ 
                }
                catch(Exception e){

                    System.out.println(e.toString());
                }
            }

            
        }
        catch(Exception e){
            System.out.println(e.toString());
        }

        
    }
    
    
    public static void proceedStockIn(Transfer transfer){
        
        //System.out.println("in inserting stock - transfer ...");    
            
        Vector temp = DbTransferItem.list(0,0, colNames[COL_TRANSFER_ID]+"="+transfer.getOID(), "");
        
        //System.out.println("temp : "+temp);    
        
        if(temp!=null && temp.size()>0){
            for(int i=0; i<temp.size(); i++){
                TransferItem ri = (TransferItem)temp.get(i);                
                DbStock.insertTransferGoodsIn(transfer, ri);                
            }            
        }
        
    }
    
    
    
}
