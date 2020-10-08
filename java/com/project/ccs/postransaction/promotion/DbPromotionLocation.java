package com.project.ccs.postransaction.promotion;

import com.project.ccs.postransaction.promotion.*;
import com.project.I_Project;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;


public class DbPromotionLocation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_PROMOTION_LOCATION = "pos_promotion_location";
    public static final int COL_PROMOTION_LOCATION_ID = 0;
    public static final int COL_PROMOTION_ID = 1;
    public static final int COL_LOCATION_ID = 2;
    public static final int COL_LOCATION_NAME = 3;
    
    
    public static final String[] colNames = {
        "promotion_location_id",
        "promotion_id",
        "location_id",
        "location_name"
        
        
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING
    };

    public DbPromotionLocation() {
    }

    public DbPromotionLocation(int i) throws CONException {
        super(new DbPromotionLocation());
    }

    public DbPromotionLocation(String sOid) throws CONException {
        super(new DbPromotionLocation(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPromotionLocation(long lOid) throws CONException {
        super(new DbPromotionLocation(0));
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
        return DB_POS_PROMOTION_LOCATION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPromotionLocation().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PromotionLocation promotionLocation = fetchExc(ent.getOID());
        ent = (Entity) promotionLocation;
        return promotionLocation.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PromotionLocation) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PromotionLocation) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PromotionLocation fetchExc(long oid) throws CONException {
        try {
            PromotionLocation promotionLocation = new PromotionLocation();
            DbPromotionLocation pstPromotion = new DbPromotionLocation(oid);
            promotionLocation.setOID(oid);

            promotionLocation.setPromotionId(pstPromotion.getlong(COL_PROMOTION_ID));
            promotionLocation.setLocationId(pstPromotion.getlong(COL_LOCATION_ID));
            promotionLocation.setLocationName(pstPromotion.getString(COL_LOCATION_NAME));
            
            return promotionLocation;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPromotionLocation(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PromotionLocation promotionLocation) throws CONException {
        try {
            DbPromotionLocation pstPromotion = new DbPromotionLocation(0);

            pstPromotion.setLong(COL_PROMOTION_ID, promotionLocation.getPromotionId());
            pstPromotion.setLong(COL_LOCATION_ID, promotionLocation.getLocationId());
            pstPromotion.setString(COL_LOCATION_NAME, promotionLocation.getLocationName());
            
            
           

            pstPromotion.insert();
            promotionLocation.setOID(pstPromotion.getlong(COL_PROMOTION_LOCATION_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPromotionLocation(0), CONException.UNKNOWN);
        }
        return promotionLocation.getOID();
    }

    public static long updateExc(PromotionLocation promotionLocation) throws CONException {
        try {
            if (promotionLocation.getOID() != 0) {
                DbPromotionLocation pstPromotion = new DbPromotionLocation(promotionLocation.getOID());

                pstPromotion.setLong(COL_PROMOTION_ID, promotionLocation.getPromotionId());
                pstPromotion.setLong(COL_LOCATION_ID, promotionLocation.getLocationId());
                pstPromotion.setString(COL_LOCATION_NAME, promotionLocation.getLocationName());
                
                
                pstPromotion.update();
                return promotionLocation.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPromotionLocation(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPromotionLocation pstPromotion = new DbPromotionLocation(oid);
            pstPromotion.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPromotionLocation(0), CONException.UNKNOWN);
        }
        return oid;
    }
    public static void deleteRecords( String s)
    throws CONException {
        
        Connection connection = null;
        Statement statement = null;
        try {
            connection = getConnection();
            statement = getStatement(connection);
            String s1 = "DELETE FROM " + DB_POS_PROMOTION_LOCATION + " WHERE " + s;
            statement.executeUpdate(s1);
            //CONLog.info(s1);
            
                CONLogger.insertLogs(s1, DB_POS_PROMOTION_LOCATION);
            
        }
        catch(SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(null, sqlexception);
        }
        finally {
            closeStatement(statement);
            closeConnection(connection);
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_POS_PROMOTION_LOCATION;
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
                PromotionLocation promotionLocation = new PromotionLocation();
                resultToObject(rs, promotionLocation);
                lists.add(promotionLocation);
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

    private static void resultToObject(ResultSet rs, PromotionLocation promotionLocation) {
        try {
            promotionLocation.setOID(rs.getLong(DbPromotionLocation.colNames[DbPromotionLocation.COL_PROMOTION_ID]));
            promotionLocation.setPromotionId(rs.getLong(DbPromotionLocation.colNames[DbPromotionLocation.COL_PROMOTION_ID]));
            promotionLocation.setLocationId(rs.getLong(DbPromotionLocation.colNames[DbPromotionLocation.COL_LOCATION_ID]));
            promotionLocation.setLocationName(rs.getString(DbPromotionLocation.colNames[DbPromotionLocation.COL_LOCATION_NAME]));
            
            
           
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long promotionLocationId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_PROMOTION_LOCATION + " WHERE " +
                    DbPromotionLocation.colNames[DbPromotionLocation.COL_PROMOTION_LOCATION_ID] + " = " + promotionLocationId;

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
    
    public static int checkLocation(long locationId, long promoLocationId) {
        CONResultSet dbrs = null;
       int result = 0;
        try {
            String sql = "SELECT * FROM " + DB_POS_PROMOTION_LOCATION + " WHERE " +
                    DbPromotionLocation.colNames[DbPromotionLocation.COL_LOCATION_ID] + " = " + locationId +
                    " and "+ DbPromotionLocation.colNames[DbPromotionLocation.COL_PROMOTION_ID] + " = " + promoLocationId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = 1;
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
            String sql = "SELECT COUNT(" + DbPromotionLocation.colNames[DbPromotionLocation.COL_PROMOTION_LOCATION_ID] + ") FROM " + DB_POS_PROMOTION_LOCATION;
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
                    PromotionLocation promotionLocation = (PromotionLocation) list.get(ls);
                    if (oid == promotionLocation.getOID()) {
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

   /* public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_COSTING + " where " +
                    colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix() + "' ";

            System.out.println(sql);

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }

            result = result + 1;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static String getNumberPrefix() {
        String code = "";
        Company sysCompany = DbCompany.getCompany();
        code = code + sysCompany.getCostingGoodsCode();

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }

    public static String getNextNumber(int ctr) {

        String code = getNumberPrefix();

        if (ctr < 10) {
            code = code + "000" + ctr;
        } else if (ctr < 100) {
            code = code + "00" + ctr;
        } else if (ctr < 1000) {
            code = code + "0" + ctr;
        } else {
            code = code + ctr;
        }
        return code;
    }*/
    
    /*public static int postJournal(PromotionLocation cst, Vector details, long userId){

        try {
            cst = DbPromotion.fetchExc(cst.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        ExchangeRate eRate = new ExchangeRate();
        try {
            eRate = DbExchangeRate.getStandardRate();
        } catch (Exception e) {
        }
        
        long segment1_id = 0;
        
        if(cst.getLocationId() != 0){
             String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID]+"="+cst.getLocationId();                    
             Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    
             if(segmentDt != null && segmentDt.size() > 0){
                SegmentDetail sd = (SegmentDetail)segmentDt.get(0);
                segment1_id = sd.getOID();
             }             
        }

        //Untuk mengecek setup coa inventory dan coa HPP agar semua ada, jika tidak maka posting di batalkan        
        boolean coaALL = true;

        for (int j = 0; j < details.size(); j++) {
            CostingItem costingItem = (CostingItem) details.get(j);
            try {
                ItemMaster im = new ItemMaster();
                im = DbItemMaster.fetchExc(costingItem.getItemMasterId());
                
                if(im.getOID() == 0){
                    coaALL = false;
                }
                    
                try {                    
                    if(im.getOID() != 0 ){
                        ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                    
                        //expense
                        if (ig.getAccountCosting().length() <= 0){
                            coaALL = false;
                        }
                        
                        //account inventory
                        if (ig.getAccountInv().length() <= 0) {
                            coaALL = false;
                        }    
                    }

                } catch (Exception e) {
                    coaALL = false;
                }

            } catch (Exception e) {
                coaALL = false;
            }
            
            if(coaALL == false){
                break;
            }
        }
        
        if(coaALL == false){
            return 0;
        }

        if (cst.getOID() != 0 && details != null && details.size() > 0 && eRate.getOID() != 0 && coaALL == true){

            long oid = DbGl.postJournalMain(0, cst.getDate(), cst.getCounter(), cst.getNumber(), cst.getPrefixNumber(), I_Project.JOURNAL_TYPE_COSTING,
                    cst.getNote(), userId, "", cst.getOID(), "", cst.getDate());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {

                    //journalnya Expense pada inventory              
                    CostingItem costingItem = (CostingItem) details.get(i);
                    ItemMaster im = new ItemMaster();

                    Coa coaExp = new Coa();
                    Coa coaInv = new Coa();

                    try {

                        im = DbItemMaster.fetchExc(costingItem.getItemMasterId());
                        try {
                            ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());

                            try {
                                if (ig.getAccountCosting().length() > 0) {
                                    coaExp = DbCoa.getCoaByCode(ig.getAccountCosting());
                                }
                            } catch (Exception e) {}

                            try {
                                if (ig.getAccountInv().length() > 0) {
                                    coaInv = DbCoa.getCoaByCode(ig.getAccountInv());
                                }
                            } catch (Exception e) {
                            }

                        } catch (Exception e) {
                        }

                    } catch (Exception e) {
                    }

                    String notes = "PromotionLocation " + im.getName()+" qty "+ costingItem.getQty();

                    
                    DbGl.postJournalDetail(eRate.getValueIdr(), coaInv.getOID(), costingItem.getAmount(), 0,
                            costingItem.getAmount(), eRate.getCurrencyIdrId(), oid, notes, 0,
                            segment1_id, 0, 0, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0);

                    
                    DbGl.postJournalDetail(eRate.getValueIdr(), coaExp.getOID(), 0, costingItem.getAmount(),
                            costingItem.getAmount(), eRate.getCurrencyIdrId(), oid, notes, 0,
                            segment1_id, 0, 0, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0);
                }
            }
            //update status
            if (oid != 0) {
                try {
                    cst.setStatus(I_Project.DOC_STATUS_POSTED);
                    cst.setPostedStatus(1);
                    cst.setPostedById(userId);
                    cst.setPostedDate(new Date());

                    Date dt = new Date();

                    String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                            DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                            DbPeriode.colNames[DbPeriode.COL_END_DATE];

                    Vector temp = DbPeriode.list(0, 0, where, "");

                    if (temp != null && temp.size() > 0) {
                        cst.setEffectiveDate(new Date());
                    } else {
                        Periode per = DbPeriode.getOpenPeriod();
                        cst.setEffectiveDate(per.getEndDate());
                    }

                    DbPromotion.updateExc(cst);

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
            return 1;
            
        }else{
            return 0;
        }
    }*/
}
