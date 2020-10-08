package com.project.ccs.postransaction.costing;

import com.project.I_Project;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.session.GrpPost;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.transaction.DbGl;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbExchangeRate;
import com.project.general.ExchangeRate;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;

public class DbCosting extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_COSTING = "pos_costing";
    public static final int COL_COSTING_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_COUNTER = 2;
    public static final int COL_NUMBER = 3;
    public static final int COL_NOTE = 4;
    public static final int COL_APPROVAL_1 = 5;
    public static final int COL_APPROVAL_2 = 6;
    public static final int COL_APPROVAL_3 = 7;
    public static final int COL_STATUS = 8;
    public static final int COL_LOCATION_ID = 9;
    public static final int COL_USER_ID = 10;
    public static final int COL_PREFIX_NUMBER = 11;
    public static final int COL_POSTED_STATUS = 12;
    public static final int COL_POSTED_BY_ID = 13;
    public static final int COL_POSTED_DATE = 14;
    public static final int COL_EFFECTIVE_DATE = 15;
    public static final  int COL_LOCATION_POST_ID = 16;         
    
    public static final String[] colNames = {
        "costing_id",
        "date",
        "counter",
        "number",
        "note",
        "approval_1",
        "approval_2",
        "approval_3",
        "status",
        "location_id",
        "user_id",
        "prefix_number",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date",
        "location_post_id"	
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG	
    };

    public DbCosting() {
    }

    public DbCosting(int i) throws CONException {
        super(new DbCosting());
    }

    public DbCosting(String sOid) throws CONException {
        super(new DbCosting(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCosting(long lOid) throws CONException {
        super(new DbCosting(0));
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
        return DB_POS_COSTING;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCosting().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Costing costing = fetchExc(ent.getOID());
        ent = (Entity) costing;
        return costing.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Costing) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Costing) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Costing fetchExc(long oid) throws CONException {
        try {
            Costing costing = new Costing();
            DbCosting pstCosting = new DbCosting(oid);
            costing.setOID(oid);

            costing.setDate(pstCosting.getDate(COL_DATE));
            costing.setCounter(pstCosting.getInt(COL_COUNTER));
            costing.setNumber(pstCosting.getString(COL_NUMBER));
            costing.setNote(pstCosting.getString(COL_NOTE));
            costing.setApproval1(pstCosting.getlong(COL_APPROVAL_1));
            costing.setApproval2(pstCosting.getlong(COL_APPROVAL_2));
            costing.setApproval3(pstCosting.getlong(COL_APPROVAL_3));
            costing.setStatus(pstCosting.getString(COL_STATUS));
            costing.setLocationId(pstCosting.getlong(COL_LOCATION_ID));
            costing.setUserId(pstCosting.getlong(COL_USER_ID));
            costing.setPrefixNumber(pstCosting.getString(COL_PREFIX_NUMBER));
            costing.setPostedStatus(pstCosting.getInt(COL_POSTED_STATUS));
            costing.setPostedById(pstCosting.getlong(COL_POSTED_BY_ID));
            costing.setPostedDate(pstCosting.getDate(COL_POSTED_DATE));
            costing.setEffectiveDate(pstCosting.getDate(COL_EFFECTIVE_DATE));
            costing.setLocationPostId(pstCosting.getlong(COL_LOCATION_POST_ID));

            return costing;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCosting(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Costing costing) throws CONException {
        try {
            DbCosting pstCosting = new DbCosting(0);
            pstCosting.setDate(COL_DATE, costing.getDate());
            pstCosting.setInt(COL_COUNTER, costing.getCounter());
            pstCosting.setString(COL_NUMBER, costing.getNumber());
            pstCosting.setString(COL_NOTE, costing.getNote());
            pstCosting.setLong(COL_APPROVAL_1, costing.getApproval1());
            pstCosting.setLong(COL_APPROVAL_2, costing.getApproval2());
            pstCosting.setLong(COL_APPROVAL_3, costing.getApproval3());
            pstCosting.setString(COL_STATUS, costing.getStatus());
            pstCosting.setLong(COL_LOCATION_ID, costing.getLocationId());
            pstCosting.setLong(COL_USER_ID, costing.getUserId());
            pstCosting.setString(COL_PREFIX_NUMBER, costing.getPrefixNumber());
            pstCosting.setInt(COL_POSTED_STATUS, costing.getPostedStatus());
            pstCosting.setLong(COL_POSTED_BY_ID, costing.getPostedById());
            pstCosting.setDate(COL_POSTED_DATE, costing.getPostedDate());
            pstCosting.setDate(COL_EFFECTIVE_DATE, costing.getEffectiveDate());
            pstCosting.setLong(COL_LOCATION_POST_ID, costing.getLocationPostId());

            pstCosting.insert();
            costing.setOID(pstCosting.getlong(COL_COSTING_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCosting(0), CONException.UNKNOWN);
        }
        return costing.getOID();
    }

    public static long updateExc(Costing costing) throws CONException {
        try {
            if (costing.getOID() != 0) {
                DbCosting pstCosting = new DbCosting(costing.getOID());

                pstCosting.setDate(COL_DATE, costing.getDate());
                pstCosting.setInt(COL_COUNTER, costing.getCounter());
                pstCosting.setString(COL_NUMBER, costing.getNumber());
                pstCosting.setString(COL_NOTE, costing.getNote());
                pstCosting.setLong(COL_APPROVAL_1, costing.getApproval1());
                pstCosting.setLong(COL_APPROVAL_2, costing.getApproval2());
                pstCosting.setLong(COL_APPROVAL_3, costing.getApproval3());
                pstCosting.setString(COL_STATUS, costing.getStatus());
                pstCosting.setLong(COL_LOCATION_ID, costing.getLocationId());
                pstCosting.setLong(COL_USER_ID, costing.getUserId());
                pstCosting.setString(COL_PREFIX_NUMBER, costing.getPrefixNumber());
                pstCosting.setInt(COL_POSTED_STATUS, costing.getPostedStatus());
                pstCosting.setLong(COL_POSTED_BY_ID, costing.getPostedById());
                pstCosting.setDate(COL_POSTED_DATE, costing.getPostedDate());
                pstCosting.setDate(COL_EFFECTIVE_DATE, costing.getEffectiveDate());
                pstCosting.setLong(COL_LOCATION_POST_ID, costing.getLocationPostId());
                
                pstCosting.update();
                return costing.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCosting(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCosting pstCosting = new DbCosting(oid);
            pstCosting.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCosting(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_COSTING;
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
                Costing costing = new Costing();
                resultToObject(rs, costing);
                lists.add(costing);
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

    private static void resultToObject(ResultSet rs, Costing costing) {
        try {
            costing.setOID(rs.getLong(DbCosting.colNames[DbCosting.COL_COSTING_ID]));
            costing.setDate(rs.getDate(DbCosting.colNames[DbCosting.COL_DATE]));
            costing.setCounter(rs.getInt(DbCosting.colNames[DbCosting.COL_COUNTER]));
            costing.setNumber(rs.getString(DbCosting.colNames[DbCosting.COL_NUMBER]));
            costing.setNote(rs.getString(DbCosting.colNames[DbCosting.COL_NOTE]));
            costing.setApproval1(rs.getLong(DbCosting.colNames[DbCosting.COL_APPROVAL_1]));
            costing.setApproval2(rs.getLong(DbCosting.colNames[DbCosting.COL_APPROVAL_2]));
            costing.setApproval3(rs.getLong(DbCosting.colNames[DbCosting.COL_APPROVAL_3]));
            costing.setStatus(rs.getString(DbCosting.colNames[DbCosting.COL_STATUS]));
            costing.setLocationId(rs.getLong(DbCosting.colNames[DbCosting.COL_LOCATION_ID]));
            costing.setUserId(rs.getLong(DbCosting.colNames[DbCosting.COL_USER_ID]));
            costing.setPrefixNumber(rs.getString(DbCosting.colNames[DbCosting.COL_PREFIX_NUMBER]));
            costing.setPostedStatus(rs.getInt(DbCosting.colNames[DbCosting.COL_POSTED_STATUS]));
            costing.setPostedById(rs.getLong(DbCosting.colNames[DbCosting.COL_POSTED_BY_ID]));
            costing.setPostedDate(rs.getDate(DbCosting.colNames[DbCosting.COL_POSTED_DATE]));
            costing.setEffectiveDate(rs.getDate(DbCosting.colNames[DbCosting.COL_EFFECTIVE_DATE]));
            costing.setLocationPostId(rs.getLong(DbCosting.colNames[DbCosting.COL_LOCATION_POST_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long costingId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_COSTING + " WHERE " +
                    DbCosting.colNames[DbCosting.COL_COSTING_ID] + " = " + costingId;

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
            String sql = "SELECT COUNT(" + DbCosting.colNames[DbCosting.COL_COSTING_ID] + ") FROM " + DB_POS_COSTING;
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
                    Costing costing = (Costing) list.get(ls);
                    if (oid == costing.getOID()) {
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

    public static int getNextCounter() {
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
    }
    
    public static Vector groupPosting(long costingId,String oidException){
        CONResultSet dbrs = null;
        Vector result = new Vector();
        try{
            String sql ="select m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" as grp_id,sum(ad."+DbCostingItem.colNames[DbCostingItem.COL_QTY]+" * ad."+DbCostingItem.colNames[DbCostingItem.COL_PRICE]+") as amount,g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as name,g." +DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+",g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COSTING]+                    
                    " from "+DbCostingItem.DB_POS_COSTING_ITEM+" ad inner join "+DbItemMaster.DB_ITEM_MASTER+" m on ad."+DbCostingItem.colNames[DbCostingItem.COL_ITEM_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" where ad."+DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID]+" = "+costingId;
            
            if(oidException != null && oidException.length() > 0){
                sql = sql +" and "+DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID]+" not in ("+oidException+")";
            }
            
            sql = sql + " group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                GrpPost grpPost = new GrpPost();
                grpPost.setItemGroupId(rs.getLong("grp_id"));
                double amount = rs.getDouble("amount");            
                String name = rs.getString("name");            
                if(amount != 0){
                    grpPost.setValue(amount);
                    grpPost.setName(name);
                    grpPost.setAccInv(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]));
                    grpPost.setAccCosting(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COSTING]));
                    result.add(grpPost);
                }
            }
            rs.close();
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        
        return result;
    }
    
    public static int postJournal(Costing cst, Vector details, long userId, long pId, Hashtable hCoaId,long expLocation,String oidException){
        try {
            cst = DbCosting.fetchExc(cst.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Vector result = groupPosting(cst.getOID(),oidException);
        
        ExchangeRate eRate = new ExchangeRate();
        try {
            eRate = DbExchangeRate.getStandardRate();
        } catch (Exception e) {}

        long periodId = 0;
        Periode periode = new Periode();
        if (pId == 0) {
            periode = DbPeriode.getPeriodByTransDate(cst.getEffectiveDate());
            periodId = periode.getOID();
        } else {
            try {
                periode = DbPeriode.fetchExc(pId);
            } catch (Exception e) {
            }
            periodId = periode.getOID();
        }

        long segment1_id = 0;        
        long segmentExpenseId = 0;
        
        if (cst.getLocationId() != 0) {
            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + cst.getLocationId();
            Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);

            if (segmentDt != null && segmentDt.size() > 0) {
                SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                if(sd.getRefSegmentDetailId() != 0){
                    segment1_id = sd.getRefSegmentDetailId();
                }else{
                    segment1_id = sd.getOID();
                }
            }
        }
        
        if(expLocation != 0){
            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + expLocation;
            Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);

            if (segmentDt != null && segmentDt.size() > 0) {
                SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                if(sd.getRefSegmentDetailId() != 0){
                    segmentExpenseId = sd.getRefSegmentDetailId();
                }else{
                    segmentExpenseId = sd.getOID();
                }
            }        
        }else{    
            segmentExpenseId = segment1_id;
        }

        //Untuk mengecek setup coa inventory dan coa HPP agar semua ada, jika tidak maka posting di batalkan        
        boolean coaALL = true;

        if (periodId == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
            coaALL = false;
        }

        for (int j = 0; j < details.size(); j++) {
            CostingItem costingItem = (CostingItem) details.get(j);
            try {
                ItemMaster im = new ItemMaster();
                im = DbItemMaster.fetchExc(costingItem.getItemMasterId());

                if (im.getOID() == 0) {
                    coaALL = false;
                }

                try {
                    if (im.getOID() != 0) {
                        ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());                        
                        String coaExpCode = "";                        
                        try{
                            if(hCoaId.get(""+costingItem.getOID()) != null){
                                Coa c = (Coa)hCoaId.get(""+costingItem.getOID());                                 
                                if(c.getOID() != 0){
                                    c = DbCoa.fetchExc(c.getOID());
                                    coaExpCode = c.getCode();
                                }else {
                                    coaExpCode = ig.getAccountCosting();
                                }
                            }else{
                                coaExpCode = ig.getAccountCosting();
                            }
                        }catch(Exception e){}
                        
                        //expense                        
                        if (coaExpCode .length() <= 0) {
                            coaALL = false;
                        }
                        
                        //account inventory
                        if (ig.getAccountInv().length() <= 0) {
                            coaALL = false;
                        }else{
                            Coa coaInv = new Coa();
                            try{
                                coaInv = DbCoa.getCoaByCode(ig.getAccountInv());
                            }catch(Exception e){}
                            if(coaInv.getOID() ==0){
                                coaALL = false;
                                break;
                            }                            
                        }
                    }

                } catch (Exception e) {
                    coaALL = false;
                }

            } catch (Exception e) {
                coaALL = false;
            }

            if (coaALL == false) {
                break;
            }
        }
        
        if(result != null && result.size() > 0){
            for(int i = 0 ; i < result.size();i++){
                GrpPost grpPost = (GrpPost)result.get(i);
                if(grpPost.getAccCosting() == null || grpPost.getAccCosting().length()<=0){
                    coaALL = false;                    
                }else{
                    Coa coaExp = new Coa();
                    try{
                        coaExp = DbCoa.getCoaByCode(grpPost.getAccCosting());
                    }catch(Exception e){}
                    if(coaExp.getOID() ==0){
                        coaALL = false;                    
                    }
                }
                
                if(grpPost.getAccInv()==null || grpPost.getAccInv().length()<=0){
                    coaALL = false;
                    break;
                }else{
                    Coa coaInv = new Coa();
                    try{
                        coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                    }catch(Exception e){}
                    if(coaInv.getOID() ==0){
                        coaALL = false;
                        break;
                    }
                }
            }
        }

        if (coaALL == false) {
            return 0;
        }

        if (periode.getOID() == 0) {
            return 0;
        }

        if (periode.getStatus().compareTo("Closed") == 0) {
            return 0;
        }

        if (cst.getOID() != 0 && ((details != null && details.size() > 0) || (result != null && result.size() > 0)) && eRate.getOID() != 0 && coaALL == true){

            long oid = DbGl.postJournalMain(periode.getTableName(),0, cst.getEffectiveDate(), cst.getCounter(), cst.getNumber(), cst.getPrefixNumber(), I_Project.JOURNAL_TYPE_COSTING,
                    cst.getNote(), userId, "", cst.getOID(), "", cst.getEffectiveDate(), periode.getOID());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {

                    //journalnya Expense pada inventory              
                    CostingItem costingItem = (CostingItem) details.get(i);
                    ItemMaster im = new ItemMaster();

                    try {

                        im = DbItemMaster.fetchExc(costingItem.getItemMasterId());
                        try {
                            Coa coaExp = new Coa();
                            Coa coaInv = new Coa();

                            ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                            try {
                                String coaExpCode = "";
                                try{
                                    if(hCoaId.get(""+costingItem.getOID()) != null){
                                        Coa c = (Coa)hCoaId.get(""+costingItem.getOID());                                 
                                        if(c.getOID() != 0){
                                            c = DbCoa.fetchExc(c.getOID());
                                            coaExpCode = c.getCode();
                                        }else {
                                            coaExpCode = ig.getAccountCosting();
                                        }
                                    }else{
                                        coaExpCode = ig.getAccountCosting();
                                    }
                                }catch(Exception e){}
                                
                                if (coaExpCode.length() > 0) {
                                    coaExp = DbCoa.getCoaByCode(coaExpCode);
                                }
                                
                            } catch (Exception e) {
                            }

                            try {
                                if (ig.getAccountInv().length() > 0) {
                                    coaInv = DbCoa.getCoaByCode(ig.getAccountInv());
                                }
                            } catch (Exception e) {
                            }
                            
                            if((costingItem.getQty() * costingItem.getPrice()) != 0){
                                
                                String notes = cst.getNote();
                                if(notes != null && notes.length() > 0){
                                    notes = notes+", ";
                                }                        
                                notes = "Costing/Spoil Number ("+cst.getNumber()+") "+notes + " category barang "+ig.getName();

                                DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaInv.getOID(), (costingItem.getQty() * costingItem.getPrice()), 0,
                                        (costingItem.getQty() * costingItem.getPrice()), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                    
                                DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaExp.getOID(), 0, (costingItem.getQty() * costingItem.getPrice()),
                                        (costingItem.getQty() * costingItem.getPrice()), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segmentExpenseId, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }

                        } catch (Exception e) {
                        }
                    } catch (Exception e) {
                    }
                }
                
                if(result != null && result.size() > 0){
                    for(int i = 0 ; i < result.size();i++){
                        GrpPost grpPost = (GrpPost)result.get(i);
                        
                        String notes = cst.getNote();
                        if(notes != null && notes.length() > 0){
                            notes = notes+", ";
                        }                        
                        notes = "Costing/Spoil Number ("+cst.getNumber()+") "+notes + " category barang "+grpPost.getName();
                        
                        Coa coaExp = new Coa();
                        Coa coaInv = new Coa();
                        
                        try{
                            coaExp = DbCoa.getCoaByCode(grpPost.getAccCosting());
                        }catch(Exception e){}
                        
                        try{
                            coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                        }catch(Exception e){}
                        
                        DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaInv.getOID(), grpPost.getValue(), 0,
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                    
                        DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaExp.getOID(), 0, grpPost.getValue(),
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segmentExpenseId, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                    }
                }
            }
            
            //update status
            if (oid != 0) {
                try {
                    cst.setLocationPostId(expLocation);
                    cst.setStatus(I_Project.STATUS_DOC_POSTED);
                    cst.setPostedStatus(1);
                    cst.setPostedById(userId);
                    cst.setPostedDate(new Date());
                    DbCosting.updateExc(cst);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
            return 1;

        } else {
            return 0;
        }
    }
    
     public static Vector listCosting(String whereClause,String whereClause2, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select * from (" +
                    " select * from pos_costing where location_post_id != 0 "+whereClause+" union "+
                    " select * from pos_costing where location_post_id = 0 "+whereClause2+") as x group by costing_id ";
            
           
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Costing costing = new Costing();
                resultToObject(rs, costing);
                lists.add(costing);
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
}
