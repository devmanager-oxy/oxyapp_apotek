/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.ga;


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
/**
 *
 * @author Roy
 */
public class DbGeneralAffair extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language{
    
    public static final String DB_POS_GENERAL_AFFAIR = "pos_general_affair";
    
    public static final int COL_GENERAL_AFFAIR_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_TRANSACTION_DATE = 2;    
    public static final int COL_COUNTER = 3;
    public static final int COL_NUMBER = 4;
    public static final int COL_NOTE = 5;
    public static final int COL_APPROVAL_1 = 6;
    public static final int COL_APPROVAL_1_DATE = 7;    
    public static final int COL_STATUS = 8;
    public static final int COL_LOCATION_ID = 9;
    public static final int COL_USER_ID = 10;
    public static final int COL_PREFIX_NUMBER = 11;
    public static final int COL_POSTED_STATUS = 12;
    public static final int COL_POSTED_BY_ID = 13;
    public static final int COL_POSTED_DATE = 14;    
    public static final  int COL_LOCATION_POST_ID = 15;       
    
    public static final String[] colNames = {
        "general_affair_id",
        "date",
        "date_trans",
        "counter",
        "number",
        "note",
        "approval_1",
        "approval_1_date",
        "status",
        "location_id",
        "user_id",
        "prefix_number",
        "posted_status",
        "posted_by_id",
        "posted_date",        
        "location_post_id"	
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID, //general_affair_id
        TYPE_DATE, //date
        TYPE_DATE, //date_trans
        TYPE_INT, //counter
        TYPE_STRING, //number        
        TYPE_STRING, //note        
        TYPE_LONG, //approval_1
        TYPE_DATE, //approval_1_date
        TYPE_STRING, //status
        TYPE_LONG, //location_id         
        TYPE_LONG, //user_id
        TYPE_STRING, //prefix_number        
        TYPE_INT, //posted_status
        TYPE_LONG, //posted_by_id
        TYPE_DATE,//posted_date        
        TYPE_LONG //location_post_id	
    };

    public DbGeneralAffair() {
    }

    public DbGeneralAffair(int i) throws CONException {
        super(new DbGeneralAffair());
    }

    public DbGeneralAffair(String sOid) throws CONException {
        super(new DbGeneralAffair(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGeneralAffair(long lOid) throws CONException {
        super(new DbGeneralAffair(0));
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
        return DB_POS_GENERAL_AFFAIR;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGeneralAffair().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        GeneralAffair generalAffair = fetchExc(ent.getOID());
        ent = (Entity) generalAffair;
        return generalAffair.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((GeneralAffair) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((GeneralAffair) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static GeneralAffair fetchExc(long oid) throws CONException {
        try {
            GeneralAffair generalAffair = new GeneralAffair();
            DbGeneralAffair pstCosting = new DbGeneralAffair(oid);
            generalAffair.setOID(oid);

            generalAffair.setDate(pstCosting.getDate(COL_DATE));
            generalAffair.setTransactionDate(pstCosting.getDate(COL_TRANSACTION_DATE));
            generalAffair.setCounter(pstCosting.getInt(COL_COUNTER));
            generalAffair.setNumber(pstCosting.getString(COL_NUMBER));            
            generalAffair.setNote(pstCosting.getString(COL_NOTE));
            generalAffair.setApproval1(pstCosting.getlong(COL_APPROVAL_1));
            generalAffair.setApproval1Date(pstCosting.getDate(COL_APPROVAL_1_DATE));                  
            generalAffair.setStatus(pstCosting.getString(COL_STATUS));
            generalAffair.setLocationId(pstCosting.getlong(COL_LOCATION_ID));            
            generalAffair.setUserId(pstCosting.getlong(COL_USER_ID));
            generalAffair.setPrefixNumber(pstCosting.getString(COL_PREFIX_NUMBER));
            generalAffair.setPostedStatus(pstCosting.getInt(COL_POSTED_STATUS));
            generalAffair.setPostedById(pstCosting.getlong(COL_POSTED_BY_ID));
            generalAffair.setPostedDate(pstCosting.getDate(COL_POSTED_DATE));            
            generalAffair.setLocationPostId(pstCosting.getlong(COL_LOCATION_POST_ID));

            return generalAffair;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGeneralAffair(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(GeneralAffair generalAffair) throws CONException {
        try {
            DbGeneralAffair pstCosting = new DbGeneralAffair(0);
            pstCosting.setDate(COL_DATE, generalAffair.getDate());
            pstCosting.setDate(COL_TRANSACTION_DATE , generalAffair.getTransactionDate());
            pstCosting.setInt(COL_COUNTER, generalAffair.getCounter());
            pstCosting.setString(COL_NUMBER, generalAffair.getNumber());
            pstCosting.setString(COL_NOTE, generalAffair.getNote());            
            pstCosting.setLong(COL_APPROVAL_1, generalAffair.getApproval1());
            pstCosting.setDate(COL_APPROVAL_1_DATE, generalAffair.getApproval1Date());
            pstCosting.setString(COL_STATUS, generalAffair.getStatus());
            pstCosting.setLong(COL_LOCATION_ID, generalAffair.getLocationId());
            pstCosting.setLong(COL_USER_ID, generalAffair.getUserId());
            pstCosting.setString(COL_PREFIX_NUMBER, generalAffair.getPrefixNumber());
            pstCosting.setInt(COL_POSTED_STATUS, generalAffair.getPostedStatus());
            pstCosting.setLong(COL_POSTED_BY_ID, generalAffair.getPostedById());
            pstCosting.setDate(COL_POSTED_DATE, generalAffair.getPostedDate());            
            pstCosting.setLong(COL_LOCATION_POST_ID, generalAffair.getLocationPostId());
            pstCosting.insert();
            generalAffair.setOID(pstCosting.getlong(COL_GENERAL_AFFAIR_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGeneralAffair(0), CONException.UNKNOWN);
        }
        return generalAffair.getOID();
    }

    public static long updateExc(GeneralAffair generalAffair) throws CONException {
        try {
            if (generalAffair.getOID() != 0) {
                DbGeneralAffair pstCosting = new DbGeneralAffair(generalAffair.getOID());

                pstCosting.setDate(COL_DATE, generalAffair.getDate());
                pstCosting.setDate(COL_TRANSACTION_DATE , generalAffair.getTransactionDate());
                pstCosting.setInt(COL_COUNTER, generalAffair.getCounter());
                pstCosting.setString(COL_NUMBER, generalAffair.getNumber());
                pstCosting.setString(COL_NOTE, generalAffair.getNote());            
                pstCosting.setLong(COL_APPROVAL_1, generalAffair.getApproval1());
                pstCosting.setDate(COL_APPROVAL_1_DATE, generalAffair.getApproval1Date());
                pstCosting.setString(COL_STATUS, generalAffair.getStatus());
                pstCosting.setLong(COL_LOCATION_ID, generalAffair.getLocationId());
                pstCosting.setLong(COL_USER_ID, generalAffair.getUserId());
                pstCosting.setString(COL_PREFIX_NUMBER, generalAffair.getPrefixNumber());
                pstCosting.setInt(COL_POSTED_STATUS, generalAffair.getPostedStatus());
                pstCosting.setLong(COL_POSTED_BY_ID, generalAffair.getPostedById());
                pstCosting.setDate(COL_POSTED_DATE, generalAffair.getPostedDate());            
                pstCosting.setLong(COL_LOCATION_POST_ID, generalAffair.getLocationPostId());
                
                pstCosting.update();
                return generalAffair.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGeneralAffair(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGeneralAffair pstCosting = new DbGeneralAffair(oid);
            pstCosting.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGeneralAffair(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_GENERAL_AFFAIR;
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
                GeneralAffair generalAffair = new GeneralAffair();
                resultToObject(rs, generalAffair);
                lists.add(generalAffair);
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

    private static void resultToObject(ResultSet rs, GeneralAffair generalAffair) {
        try {
            generalAffair.setOID(rs.getLong(DbGeneralAffair.colNames[DbGeneralAffair.COL_GENERAL_AFFAIR_ID]));            
            generalAffair.setDate(rs.getDate(DbGeneralAffair.colNames[DbGeneralAffair.COL_DATE]));
            generalAffair.setTransactionDate(rs.getDate(DbGeneralAffair.colNames[DbGeneralAffair.COL_TRANSACTION_DATE]));
            generalAffair.setCounter(rs.getInt(DbGeneralAffair.colNames[DbGeneralAffair.COL_COUNTER]));
            generalAffair.setNumber(rs.getString(DbGeneralAffair.colNames[DbGeneralAffair.COL_NUMBER]));
            generalAffair.setNote(rs.getString(DbGeneralAffair.colNames[DbGeneralAffair.COL_NOTE]));
            generalAffair.setApproval1(rs.getLong(DbGeneralAffair.colNames[DbGeneralAffair.COL_APPROVAL_1]));
            generalAffair.setApproval1Date(rs.getDate(DbGeneralAffair.colNames[DbGeneralAffair.COL_APPROVAL_1_DATE]));            
            generalAffair.setStatus(rs.getString(DbGeneralAffair.colNames[DbGeneralAffair.COL_STATUS]));
            generalAffair.setLocationId(rs.getLong(DbGeneralAffair.colNames[DbGeneralAffair.COL_LOCATION_ID]));
            generalAffair.setUserId(rs.getLong(DbGeneralAffair.colNames[DbGeneralAffair.COL_USER_ID]));
            generalAffair.setPrefixNumber(rs.getString(DbGeneralAffair.colNames[DbGeneralAffair.COL_PREFIX_NUMBER]));
            generalAffair.setPostedStatus(rs.getInt(DbGeneralAffair.colNames[DbGeneralAffair.COL_POSTED_STATUS]));
            generalAffair.setPostedById(rs.getLong(DbGeneralAffair.colNames[DbGeneralAffair.COL_POSTED_BY_ID]));
            generalAffair.setPostedDate(rs.getDate(DbGeneralAffair.colNames[DbGeneralAffair.COL_POSTED_DATE]));            
            generalAffair.setLocationPostId(rs.getLong(DbGeneralAffair.colNames[DbGeneralAffair.COL_LOCATION_POST_ID]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long costingId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_GENERAL_AFFAIR + " WHERE " +
                    DbGeneralAffair.colNames[DbGeneralAffair.COL_GENERAL_AFFAIR_ID] + " = " + costingId;

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
            String sql = "SELECT COUNT(" + DbGeneralAffair.colNames[DbGeneralAffair.COL_GENERAL_AFFAIR_ID] + ") FROM " + DB_POS_GENERAL_AFFAIR;
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
                    GeneralAffair generalAffair = (GeneralAffair) list.get(ls);
                    if (oid == generalAffair.getOID()) {
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
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_GENERAL_AFFAIR + " where " +
                    colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix() + "' ";

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
        code = code + "GA";
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

      
    public static Vector groupPosting(long gaId,String oidException){
        CONResultSet dbrs = null;
        Vector result = new Vector();
        try{
            String sql ="select m.item_group_id as grp_id,sum(ad.qty * ad.price) as amount,g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as name,g." +DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+",g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_AJUSTMENT]+                    
                    " from pos_general_affair_detail ad inner join pos_item_master m on ad.item_master_id = m.item_master_id inner join pos_item_group g on m.item_group_id = g.item_group_id where general_affair_id = "+gaId;
            
            if(oidException != null && oidException.length() > 0){
                sql = sql +" and "+DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_GENERAL_AFFAIR_DETAIL_ID]+" not in ("+oidException+")";
            }
            
            sql = sql + " group by m.item_group_id ";
            
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
    
    
    public static int postJournal(GeneralAffair ga, Vector details, long userId, long pId, Hashtable hCoaId,long expLocation,String oidException){
          
        Vector result = groupPosting(ga.getOID(),oidException);
        
        ExchangeRate eRate = new ExchangeRate();
        try {
            eRate = DbExchangeRate.getStandardRate();
        } catch (Exception e) {}

        long periodId = 0;
        Periode periode = new Periode();
        if (pId == 0) {
            periode = DbPeriode.getPeriodByTransDate(ga.getApproval1Date());
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
        
        if (ga.getLocationId() != 0) {
            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + ga.getLocationId();
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
        
        if(expLocation == 0){
            expLocation = ga.getLocationPostId();
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
        }

        //Untuk mengecek setup coa inventory dan coa HPP agar semua ada, jika tidak maka posting di batalkan        
        boolean coaALL = true;

        if (periodId == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
            coaALL = false;
        }

        
        if(result != null && result.size() > 0){
            for(int i = 0 ; i < result.size();i++){
                GrpPost grpPost = (GrpPost)result.get(i);
                if(grpPost.getAccAdjusment() == null || grpPost.getAccAdjusment().length()<=0){
                    coaALL = false;                    
                }else{
                    Coa coaExp = new Coa();
                    try{
                        coaExp = DbCoa.getCoaByCode(grpPost.getAccAdjusment());
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
        
        for (int j = 0; j < details.size(); j++) {            
            GeneralAffairDetail generalAffairDetail = (GeneralAffairDetail) details.get(j);
            try {
                ItemMaster im = new ItemMaster();
                im = DbItemMaster.fetchExc(generalAffairDetail.getItemMasterId());

                if (im.getOID() == 0) {
                    coaALL = false;
                }

                try {
                    if (im.getOID() != 0) {
                        ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());                        
                        String coaExpCode = "";                        
                        try{
                            if(hCoaId.get(""+generalAffairDetail.getOID()) != null){
                                Coa c = (Coa)hCoaId.get(""+generalAffairDetail.getOID());                                 
                                if(c.getOID() != 0){
                                    c = DbCoa.fetchExc(c.getOID());
                                    coaExpCode = c.getCode();
                                }else {
                                    coaExpCode = ig.getAccountAjustment();
                                }
                            }else{
                                coaExpCode = ig.getAccountAjustment();
                            }
                        }catch(Exception e){}
                        
                        //expense                        
                        if (coaExpCode==null || coaExpCode.length() <= 0) {
                            coaALL = false;
                        }
                        
                        //account inventory
                        if (ig.getAccountInv()==null || ig.getAccountInv().length() <= 0) {
                            coaALL = false;
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

        if(segment1_id == 0 || segmentExpenseId==0){
            return 0;
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

        if (ga.getOID() != 0 && ((details != null && details.size() > 0) || (result != null && result.size() > 0))  && eRate.getOID() != 0 && coaALL == true){

            long oid = DbGl.postJournalMain(periode.getTableName(),0, ga.getApproval1Date(), ga.getCounter(), ga.getNumber(), ga.getPrefixNumber(), I_Project.JOURNAL_TYPE_GENERAL_AFFAIR,
                    ga.getNote(), userId, "", ga.getOID(), "", ga.getApproval1Date(), periode.getOID());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {

                    //journalnya Expense pada inventory              
                    GeneralAffairDetail gad = (GeneralAffairDetail) details.get(i);
                    ItemMaster im = new ItemMaster();

                    try {

                        im = DbItemMaster.fetchExc(gad.getItemMasterId());
                        try {
                            Coa coaExp = new Coa();
                            Coa coaInv = new Coa();

                            ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                            try {
                                String coaExpCode = "";
                                try{
                                    if(hCoaId.get(""+gad.getOID()) != null){
                                        Coa c = (Coa)hCoaId.get(""+gad.getOID());                                 
                                        if(c.getOID() != 0){
                                            c = DbCoa.fetchExc(c.getOID());
                                            coaExpCode = c.getCode();
                                        }else {
                                            coaExpCode = ig.getAccountAjustment();
                                        }
                                    }else{
                                        coaExpCode = ig.getAccountAjustment();
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
                            
                            
                            if((gad.getQty() * gad.getPrice()) != 0){

                                String notes = ga.getNote();
                                if(notes != null && notes.length() > 0){
                                    notes = notes+", ";
                                }
                                notes = "GA Number : ("+ga.getNumber()+") "+notes+" category "+ig.getName();
                                
                                DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaInv.getOID(), (gad.getQty() * gad.getPrice()), 0,
                                        (gad.getQty() * gad.getPrice()), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                    
                                DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaExp.getOID(), 0, (gad.getQty() * gad.getPrice()),
                                        (gad.getQty() * gad.getPrice()), eRate.getCurrencyIdrId(), oid, notes, 0,
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
                        
                        String notes = ga.getNote();
                        if(notes != null && notes.length() > 0){
                            notes = notes+", ";
                        }
                        notes = "GA Number : ("+ga.getNumber()+") "+notes+" category "+grpPost.getName();
                        
                        Coa coaExp = new Coa();
                        Coa coaInv = new Coa();
                        
                        try{
                            coaExp = DbCoa.getCoaByCode(grpPost.getAccAdjusment());
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
                                    
                        DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaExp.getOID(), 0,grpPost.getValue(),
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
                    ga.setLocationPostId(expLocation);
                    ga.setStatus(I_Project.STATUS_DOC_POSTED);
                    ga.setPostedStatus(1);
                    ga.setPostedById(userId);
                    ga.setPostedDate(new Date());
                    DbGeneralAffair.updateExc(ga);                    
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
            return 1;

        } else {
            return 0;
        }
    }
    
}
