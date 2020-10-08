
package com.project.ccs.postransaction.repack;

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
import com.project.fms.session.SessRePosting;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.GlDetail;
import com.project.general.DbExchangeRate;
import com.project.general.ExchangeRate;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.DbSystemProperty;
import com.project.util.lang.I_Language;

public class DbRepack extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_REPACK = "pos_repack";
    public static final int COL_REPACK_ID = 0;
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
    
    public static final String[] colNames = {
        "repack_id",
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
        "effective_date"
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
    };

    public DbRepack() {
    }

    public DbRepack(int i) throws CONException {
        super(new DbRepack());
    }

    public DbRepack(String sOid) throws CONException {
        super(new DbRepack(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbRepack(long lOid) throws CONException {
        super(new DbRepack(0));
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
        return DB_POS_REPACK;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbRepack().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Repack repack = fetchExc(ent.getOID());
        ent = (Entity) repack;
        return repack.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Repack) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Repack) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Repack fetchExc(long oid) throws CONException {
        try {
            Repack repack = new Repack();
            DbRepack pstRepack = new DbRepack(oid);
            repack.setOID(oid);

            repack.setDate(pstRepack.getDate(COL_DATE));
            repack.setCounter(pstRepack.getInt(COL_COUNTER));
            repack.setNumber(pstRepack.getString(COL_NUMBER));
            repack.setNote(pstRepack.getString(COL_NOTE));
            repack.setApproval1(pstRepack.getlong(COL_APPROVAL_1));
            repack.setApproval2(pstRepack.getlong(COL_APPROVAL_2));
            repack.setApproval3(pstRepack.getlong(COL_APPROVAL_3));
            repack.setStatus(pstRepack.getString(COL_STATUS));
            repack.setLocationId(pstRepack.getlong(COL_LOCATION_ID));
            repack.setUserId(pstRepack.getlong(COL_USER_ID));            
            repack.setPrefixNumber(pstRepack.getString(COL_PREFIX_NUMBER));
            
            repack.setPostedStatus(pstRepack.getInt(COL_POSTED_STATUS));
            repack.setPostedById(pstRepack.getlong(COL_POSTED_BY_ID));
            repack.setPostedDate(pstRepack.getDate(COL_POSTED_DATE));
            repack.setEffectiveDate(pstRepack.getDate(COL_EFFECTIVE_DATE));
            return repack;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRepack(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Repack repack) throws CONException {
        try {
            DbRepack pstRepack = new DbRepack(0);

            pstRepack.setDate(COL_DATE, repack.getDate());
            pstRepack.setInt(COL_COUNTER, repack.getCounter());
            pstRepack.setString(COL_NUMBER, repack.getNumber());
            pstRepack.setString(COL_NOTE, repack.getNote());
            pstRepack.setLong(COL_APPROVAL_1, repack.getApproval1());
            pstRepack.setLong(COL_APPROVAL_2, repack.getApproval2());
            pstRepack.setLong(COL_APPROVAL_3, repack.getApproval3());
            pstRepack.setString(COL_STATUS, repack.getStatus());
            pstRepack.setLong(COL_LOCATION_ID, repack.getLocationId());
            pstRepack.setLong(COL_USER_ID, repack.getUserId());
            pstRepack.setString(COL_PREFIX_NUMBER, repack.getPrefixNumber());            
            
            pstRepack.setInt(COL_POSTED_STATUS, repack.getPostedStatus());            
            pstRepack.setLong(COL_POSTED_BY_ID, repack.getPostedById());            
            pstRepack.setDate(COL_POSTED_DATE, repack.getPostedDate());            
            pstRepack.setDate(COL_EFFECTIVE_DATE, repack.getEffectiveDate());      

            pstRepack.insert();
            repack.setOID(pstRepack.getlong(COL_REPACK_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRepack(0), CONException.UNKNOWN);
        }
        return repack.getOID();
    }

    public static long updateExc(Repack repack) throws CONException {
        try {
            if (repack.getOID() != 0) {
                DbRepack pstRepack = new DbRepack(repack.getOID());

                pstRepack.setDate(COL_DATE, repack.getDate());
                pstRepack.setInt(COL_COUNTER, repack.getCounter());
                pstRepack.setString(COL_NUMBER, repack.getNumber());
                pstRepack.setString(COL_NOTE, repack.getNote());
                pstRepack.setLong(COL_APPROVAL_1, repack.getApproval1());
                pstRepack.setLong(COL_APPROVAL_2, repack.getApproval2());
                pstRepack.setLong(COL_APPROVAL_3, repack.getApproval3());
                pstRepack.setString(COL_STATUS, repack.getStatus());
                pstRepack.setLong(COL_LOCATION_ID, repack.getLocationId());
                pstRepack.setLong(COL_USER_ID, repack.getUserId());                
                pstRepack.setString(COL_PREFIX_NUMBER, repack.getPrefixNumber());  
                pstRepack.setInt(COL_POSTED_STATUS, repack.getPostedStatus());            
                pstRepack.setLong(COL_POSTED_BY_ID, repack.getPostedById());            
                pstRepack.setDate(COL_POSTED_DATE, repack.getPostedDate());            
                pstRepack.setDate(COL_EFFECTIVE_DATE, repack.getEffectiveDate());            
            
                pstRepack.update();
                return repack.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRepack(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbRepack pstRepack = new DbRepack(oid);
            pstRepack.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRepack(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_REPACK;
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
                Repack repack = new Repack();
                resultToObject(rs, repack);
                lists.add(repack);
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

    private static void resultToObject(ResultSet rs, Repack repack) {
        try {
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

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long costingId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_REPACK + " WHERE " +
                    DbRepack.colNames[DbRepack.COL_REPACK_ID] + " = " + costingId;

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
            String sql = "SELECT COUNT(" + DbRepack.colNames[DbRepack.COL_REPACK_ID] + ") FROM " + DB_POS_REPACK;
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
                    Repack repack = (Repack) list.get(ls);
                    if (oid == repack.getOID()) {
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
                try{
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_POS_REPACK+" where "+
                        colNames[COL_PREFIX_NUMBER]+"='"+getNumberPrefix()+"' ";
                    
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        result = rs.getInt(1);
                    }
                    
                    result = result + 1;
                    
                }
                catch(Exception e){
                    
                }
                finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
    }

    public static String getNumberPrefix() {
        String code = "";        
        code = code + "RPC";
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
    
    public static boolean hasoutputRepack(long oidRepack) {
        boolean result = false;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select count(repack_item_id) from pos_repack_item where repack_id="+ oidRepack + " and type=1";
                    int jum=0;
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        jum = rs.getInt(1);
                    }
                    
                    if(jum!=0){
                        result= true;
                        return result;
                    }
                    
                }
                catch(Exception e){
                    
                }
                finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
    }
    
    
     public static Vector groupPosting(long repakcId){
        CONResultSet dbrs = null;
        Vector result = new Vector();
        try{
            String sql ="select m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" as grp_id,sum(ad."+DbRepackItem.colNames[DbRepackItem.COL_QTY]+" * ad."+DbRepackItem.colNames[DbRepackItem.COL_COGS]+") as amount,g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as name,g." +DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+",g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_AJUSTMENT]+                    
                    " from "+DbRepackItem.DB_POS_REPACK_ITEM+" ad inner join "+DbItemMaster.DB_ITEM_MASTER+" m on ad."+DbRepackItem.colNames[DbRepackItem.COL_ITEM_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" where ad."+DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID]+" = "+repakcId+" and ad."+DbRepackItem.colNames[DbRepackItem.COL_TYPE]+" = "+DbRepackItem.TYPE_INPUT;
            
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
                    grpPost.setAccAdjusment(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_AJUSTMENT]));
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
   
    
    public static int postJournal(Repack repack, Vector details, long userId, long pId) {        

        try {
            repack = DbRepack.fetchExc(repack.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Vector result = groupPosting(repack.getOID());
        
        int output = DbRepackItem.getCount(DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID]+" = "+repack.getOID()+" and "+DbRepackItem.colNames[DbRepackItem.COL_TYPE]+" = "+DbRepackItem.TYPE_OUTPUT);
        
        long periodId = 0;
        Periode periode = new Periode();
        if (pId == 0) {
            try{
                periode = DbPeriode.getPeriodByTransDate(repack.getEffectiveDate());
            }catch(Exception e){}
            periodId = periode.getOID();
        } else {
            try {
                periode = DbPeriode.fetchExc(pId);
            } catch (Exception e) {
            }
            periodId = periode.getOID();
        }

        ExchangeRate eRate = new ExchangeRate();
        try {
            eRate = DbExchangeRate.getStandardRate();
        } catch (Exception e) {
        }

        long segment1_id = 0;
        if (repack.getLocationId() != 0) {
            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + repack.getLocationId();
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

        //Untuk mengecek setup coa inventory dan coa HPP agar semua ada, jika tidak maka posting di batalkan        
        boolean coaALL = true;

        if (periodId == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
            coaALL = false;
        }
        
         if(result != null && result.size() > 0){
            for(int i = 0 ; i < result.size();i++){
                GrpPost grpPost = (GrpPost)result.get(i);
                
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
        
        Coa coaOpeningBalance = new Coa();
        if(details != null && details.size() > 0){
            for (int j = 0; j < details.size(); j++) {
                RepackItem repackItem = (RepackItem) details.get(j);            
                try {
                
                    ItemMaster im = new ItemMaster();
                    im = DbItemMaster.fetchExc(repackItem.getItemMasterId());
                    if (im.getOID() == 0) {
                        coaALL = false;
                    }

                    try {
                        if (im.getOID() != 0) {
                            ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                            if (ig.getAccountInv() == null || ig.getAccountInv().length() <= 0) {
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
        }else{
            try{                
                long oidOpeningBalance = 0;                    
                oidOpeningBalance = Long.parseLong(DbSystemProperty.getValueByName("OID_COA_OPENING_BALANCE"));
                coaOpeningBalance = DbCoa.fetchExc(oidOpeningBalance);
            }catch(Exception e){}
            if(coaOpeningBalance.getOID() == 0){
                 coaALL = false;
            }
        }
       
        if (coaALL == false) {
            return 0;
        }
        
        if(result==null || result.size() <= 0 ){            
            return 0;
        }

        if (repack.getOID() != 0 && ((result != null && result.size() > 0))  && eRate.getOID() != 0 && coaALL == true) {
            long oid = DbGl.postJournalMain(periode.getTableName(),0, repack.getEffectiveDate() , repack.getCounter(), repack.getNumber(), repack.getPrefixNumber(), I_Project.JOURNAL_TYPE_REPACK,
                    repack.getNote(), userId, "", repack.getOID(), "", repack.getEffectiveDate(), periodId);

            if (oid != 0) {
                
                double totalIn = 0;
                double totalOutput = 0;
                
                if(result != null && result.size() > 0){
                    for(int i = 0 ; i < result.size();i++){
                        GrpPost grpPost = (GrpPost)result.get(i);
                        
                        String notes = repack.getNote();
                        if(notes != null && notes.length() > 0){
                            notes = notes+", ";
                        }                        
                        notes = "Repack Number ("+repack.getNumber()+") "+notes + "category barang "+grpPost.getName();
                        Coa coaInv = new Coa();
                        
                        try{
                            coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                        }catch(Exception e){}
                        
                        DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaInv.getOID(), grpPost.getValue(), 0,
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                        totalIn = totalIn + grpPost.getValue();
                    }
                }
                
                long oidGlDetail = 0;
                
                if(details != null && details.size() > 0){
                     for (int j = 0; j < details.size(); j++) {
                        RepackItem repackItem = (RepackItem) details.get(j);
                        ItemMaster im = new ItemMaster();                        
                        try {
                            im = DbItemMaster.fetchExc(repackItem.getItemMasterId());
                            ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                            Coa coaInv = DbCoa.getCoaByCode(ig.getAccountInv());
                        
                            String notes = repack.getNote();
                            if(notes != null && notes.length() > 0){
                                notes = notes+", ";
                            }
                            notes = "Repack Number ("+repack.getNumber()+") "+notes + "category barang "+ig.getName();
                        
                            double balance = (repackItem.getCogs() * repackItem.getQty());
                        
                            if(j==(output-1)){
                                balance = totalIn - totalOutput;
                            }else{
                                totalOutput = totalOutput + (repackItem.getCogs() * repackItem.getQty());
                            }
                        
                            if(repackItem.getType() == 0){                                                                
                                oidGlDetail = DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaInv.getOID(), balance, 0,
                                        balance, eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);                            
                            }else{                                
                                oidGlDetail = DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaInv.getOID(), 0, balance,
                                        balance, eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }
                        }catch(Exception e){}
                    }   
                    
                    
                }else{                    
                    try{                    
                        if(coaOpeningBalance.getOID() != 0){
                            String notes = repack.getNote();
                            if(notes != null && notes.length() > 0){
                                notes = notes+", ";
                            }
                            notes = "Repack Number ("+repack.getNumber()+") "+notes;
                            
                            oidGlDetail = DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaOpeningBalance.getOID(), 0, totalIn,
                                        totalIn, eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);                            
                            
                        }
                    }catch(Exception e){}
                    
                }
                 
                GlDetail gdDebet = SessRePosting.getDebet(oid);
                double tDebet = gdDebet.getDebet();
                double tCredit = gdDebet.getCredit();
                double balance = tCredit - tDebet;
                String strAmount = JSPFormater.formatNumber((balance), "###,###.##");
                
                if (strAmount.compareToIgnoreCase("0.00") != 0 && strAmount.compareToIgnoreCase("-0.00") != 0 && oidGlDetail != 0 && balance > -500 && balance < 500) {
                    try{
                        GlDetail gdx = DbGlDetail.fetchExc(oidGlDetail);
                        
                        if(gdx.getDebet() != 0){
                            double amountx = gdx.getDebet() + balance;
                            gdx.setDebet(amountx);
                            gdx.setForeignCurrencyAmount(amountx);
                        }else{
                            double amountx = gdx.getCredit() + balance;                            
                            gdx.setCredit(amountx);
                            gdx.setForeignCurrencyAmount(amountx);
                        }
                        try {
                            DbGlDetail.updateExc(gdx);
                        } catch (Exception e) {}
                    
                    }catch(Exception e){}
                }
                
                 try {
                    updateRepackPosted(repack.getOID(),userId);
                     
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
            
            return 1;
        } else {
            return 0;
        }
    }
    
    
    public static void updateRepackPosted(long repackId,long userId){
        CONResultSet crs = null;
        try{
            String sql = "update "+DbRepack.DB_POS_REPACK+" set "+DbRepack.colNames[DbRepack.COL_STATUS]+" = '"+I_Project.DOC_STATUS_POSTED+"',"+
                    DbRepack.colNames[DbRepack.COL_POSTED_STATUS]+" = 1,"+
                    DbRepack.colNames[DbRepack.COL_POSTED_BY_ID]+" = "+userId+","+
                    DbRepack.colNames[DbRepack.COL_POSTED_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss")+"' where "+DbRepack.colNames[DbRepack.COL_REPACK_ID]+" = "+repackId;
                    
            CONHandler.execUpdate(sql);
            
        }catch(Exception e){}finally{
            CONResultSet.close(crs);
        }   
    }
    
    public static double getCogs(long oidMaster){
        CONResultSet dbrs = null;
        try{
            String sql = "select "+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" from "+DbItemMaster.DB_ITEM_MASTER+" where "+
                    DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = "+oidMaster;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while(rs.next()){
                    double cogs = rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_COGS]);
                    return cogs;
                }
            
        }catch(Exception e){
            System.out.println("[e] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        return 0;
    }
}
