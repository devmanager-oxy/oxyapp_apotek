package com.project.ccs.postransaction.adjusment;

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
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;
import java.util.Date;

public class DbAdjusment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_ADJUSMENT = "pos_adjusment";
    
    public static final int COL_ADJUSMENT_ID = 0;
    public static final int COL_COUNTER = 1;
    public static final int COL_NUMBER = 2;
    public static final int COL_DATE = 3;
    public static final int COL_STATUS = 4;
    public static final int COL_NOTE = 5;
    public static final int COL_APPROVAL_1 = 6;
    public static final int COL_APPROVAL_2 = 7;
    public static final int COL_APPROVAL_3 = 8;
    public static final int COL_USER_ID = 9;
    public static final int COL_LOCATION_ID = 10;
    public static final int COL_PREFIX_NUMBER = 11;
    public static final int COL_APPROVAL_1_DATE = 12;
    public static final int COL_APPROVAL_2_DATE = 13;
    public static final int COL_APPROVAL_3_DATE = 14;
    public static final int COL_TYPE = 15;
    public static final int COL_COMPANY_ID = 16;
    public static final int COL_POSTED_STATUS = 17;
    public static final int COL_POSTED_BY_ID = 18;
    public static final int COL_POSTED_DATE = 19;
    public static final int COL_EFFECTIVE_DATE = 20;
    
    public static final String[] colNames = {
        "adjusment_id",
        "counter",
        "number",
        "date",
        "status",
        "note",
        "approval_1",
        "approval_2",
        "approval_3",
        "user_id",
        "location_id",
        "prefix_number",
        "approval_1_date",
        "approval_2_date",
        "approval_3_date",
        "type",
        "company_id",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE
    };
    
    public static final int TYPE_NON_CONSIGMENT = 0;
    public static final int TYPE_CONSIGMENT = 1;

    public DbAdjusment() {
    }

    public DbAdjusment(int i) throws CONException {
        super(new DbAdjusment());
    }

    public DbAdjusment(String sOid) throws CONException {
        super(new DbAdjusment(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbAdjusment(long lOid) throws CONException {
        super(new DbAdjusment(0));
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
        return DB_POS_ADJUSMENT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbAdjusment().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Adjusment adjusment = fetchExc(ent.getOID());
        ent = (Entity) adjusment;
        return adjusment.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Adjusment) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Adjusment) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Adjusment fetchExc(long oid) throws CONException {
        try {
            Adjusment adjusment = new Adjusment();
            DbAdjusment pstAdjusment = new DbAdjusment(oid);
            adjusment.setOID(oid);

            adjusment.setCounter(pstAdjusment.getInt(COL_COUNTER));
            adjusment.setNumber(pstAdjusment.getString(COL_NUMBER));
            adjusment.setDate(pstAdjusment.getDate(COL_DATE));
            adjusment.setStatus(pstAdjusment.getString(COL_STATUS));
            adjusment.setNote(pstAdjusment.getString(COL_NOTE));
            adjusment.setApproval1(pstAdjusment.getlong(COL_APPROVAL_1));
            adjusment.setApproval2(pstAdjusment.getlong(COL_APPROVAL_2));
            adjusment.setApproval3(pstAdjusment.getlong(COL_APPROVAL_3));
            adjusment.setUserId(pstAdjusment.getlong(COL_USER_ID));

            adjusment.setLocationId(pstAdjusment.getlong(COL_LOCATION_ID));
            adjusment.setPrefixNumber(pstAdjusment.getString(COL_PREFIX_NUMBER));
            adjusment.setApproval1_date(pstAdjusment.getDate(COL_APPROVAL_1_DATE));
            adjusment.setApproval2_date(pstAdjusment.getDate(COL_APPROVAL_2_DATE));
            adjusment.setApproval3_date(pstAdjusment.getDate(COL_APPROVAL_3_DATE));
            adjusment.setType(pstAdjusment.getInt(COL_TYPE));
            adjusment.setCompany_id(pstAdjusment.getlong(COL_COMPANY_ID));

            adjusment.setPostedStatus(pstAdjusment.getInt(COL_POSTED_STATUS));
            adjusment.setPostedById(pstAdjusment.getlong(COL_POSTED_BY_ID));
            adjusment.setPostedDate(pstAdjusment.getDate(COL_POSTED_DATE));
            adjusment.setEffectiveDate(pstAdjusment.getDate(COL_EFFECTIVE_DATE));

            return adjusment;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAdjusment(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Adjusment adjusment) throws CONException {
        try {
            DbAdjusment pstAdjusment = new DbAdjusment(0);

            pstAdjusment.setInt(COL_COUNTER, adjusment.getCounter());
            pstAdjusment.setString(COL_NUMBER, adjusment.getNumber());
            pstAdjusment.setDate(COL_DATE, adjusment.getDate());
            pstAdjusment.setString(COL_STATUS, adjusment.getStatus());
            pstAdjusment.setString(COL_NOTE, adjusment.getNote());
            pstAdjusment.setLong(COL_APPROVAL_1, adjusment.getApproval1());
            pstAdjusment.setLong(COL_APPROVAL_2, adjusment.getApproval2());
            pstAdjusment.setLong(COL_APPROVAL_3, adjusment.getApproval3());
            pstAdjusment.setLong(COL_USER_ID, adjusment.getUserId());

            pstAdjusment.setLong(COL_LOCATION_ID, adjusment.getLocationId());
            pstAdjusment.setString(COL_PREFIX_NUMBER, adjusment.getPrefixNumber());
            pstAdjusment.setDate(COL_APPROVAL_1_DATE, adjusment.getApproval1_date());
            pstAdjusment.setDate(COL_APPROVAL_2_DATE, adjusment.getApproval2_date());
            pstAdjusment.setDate(COL_APPROVAL_3_DATE, adjusment.getApproval3_date());
            pstAdjusment.setInt(COL_TYPE, adjusment.getType());
            pstAdjusment.setLong(COL_COMPANY_ID, adjusment.getCompany_id());

            pstAdjusment.setInt(COL_POSTED_STATUS, adjusment.getPostedStatus());
            pstAdjusment.setLong(COL_POSTED_BY_ID, adjusment.getPostedById());
            pstAdjusment.setDate(COL_POSTED_DATE, adjusment.getPostedDate());
            pstAdjusment.setDate(COL_EFFECTIVE_DATE, adjusment.getEffectiveDate());

            pstAdjusment.insert();
            adjusment.setOID(pstAdjusment.getlong(COL_ADJUSMENT_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAdjusment(0), CONException.UNKNOWN);
        }
        return adjusment.getOID();
    }

    public static long updateExc(Adjusment adjusment) throws CONException {
        try {
            if (adjusment.getOID() != 0) {
                DbAdjusment pstAdjusment = new DbAdjusment(adjusment.getOID());

                pstAdjusment.setInt(COL_COUNTER, adjusment.getCounter());
                pstAdjusment.setString(COL_NUMBER, adjusment.getNumber());
                pstAdjusment.setDate(COL_DATE, adjusment.getDate());
                pstAdjusment.setString(COL_STATUS, adjusment.getStatus());
                pstAdjusment.setString(COL_NOTE, adjusment.getNote());
                pstAdjusment.setLong(COL_APPROVAL_1, adjusment.getApproval1());
                pstAdjusment.setLong(COL_APPROVAL_2, adjusment.getApproval2());
                pstAdjusment.setLong(COL_APPROVAL_3, adjusment.getApproval3());
                pstAdjusment.setLong(COL_USER_ID, adjusment.getUserId());

                pstAdjusment.setLong(COL_LOCATION_ID, adjusment.getLocationId());
                pstAdjusment.setString(COL_PREFIX_NUMBER, adjusment.getPrefixNumber());
                pstAdjusment.setDate(COL_APPROVAL_1_DATE, adjusment.getApproval1_date());
                pstAdjusment.setDate(COL_APPROVAL_2_DATE, adjusment.getApproval2_date());
                pstAdjusment.setDate(COL_APPROVAL_3_DATE, adjusment.getApproval3_date());
                pstAdjusment.setInt(COL_TYPE, adjusment.getType());
                pstAdjusment.setLong(COL_COMPANY_ID, adjusment.getCompany_id());
                pstAdjusment.setInt(COL_POSTED_STATUS, adjusment.getPostedStatus());
                pstAdjusment.setLong(COL_POSTED_BY_ID, adjusment.getPostedById());
                pstAdjusment.setDate(COL_POSTED_DATE, adjusment.getPostedDate());
                pstAdjusment.setDate(COL_EFFECTIVE_DATE, adjusment.getEffectiveDate());

                pstAdjusment.update();
                return adjusment.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAdjusment(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbAdjusment pstAdjusment = new DbAdjusment(oid);
            pstAdjusment.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAdjusment(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_ADJUSMENT;
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
                Adjusment adjusment = new Adjusment();
                resultToObject(rs, adjusment);
                lists.add(adjusment);
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

    private static void resultToObject(ResultSet rs, Adjusment adjusment) {
        try {
            adjusment.setOID(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_ADJUSMENT_ID]));
            adjusment.setCounter(rs.getInt(DbAdjusment.colNames[DbAdjusment.COL_COUNTER]));
            adjusment.setNumber(rs.getString(DbAdjusment.colNames[DbAdjusment.COL_NUMBER]));
            adjusment.setDate(rs.getDate(DbAdjusment.colNames[DbAdjusment.COL_DATE]));
            adjusment.setStatus(rs.getString(DbAdjusment.colNames[DbAdjusment.COL_STATUS]));
            adjusment.setNote(rs.getString(DbAdjusment.colNames[DbAdjusment.COL_NOTE]));
            adjusment.setApproval1(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_1]));
            adjusment.setApproval2(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_2]));
            adjusment.setApproval3(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_3]));
            adjusment.setUserId(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_USER_ID]));

            adjusment.setUserId(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_LOCATION_ID]));
            adjusment.setPrefixNumber(rs.getString(DbAdjusment.colNames[DbAdjusment.COL_PREFIX_NUMBER]));
            adjusment.setApproval1_date(rs.getDate(DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_1_DATE]));
            adjusment.setApproval2_date(rs.getDate(DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_2_DATE]));
            adjusment.setApproval3_date(rs.getDate(DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_3_DATE]));
            adjusment.setLocationId(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_LOCATION_ID]));
            adjusment.setType(rs.getInt(DbAdjusment.colNames[DbAdjusment.COL_TYPE]));
            adjusment.setCompany_id(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_COMPANY_ID]));
            adjusment.setPostedStatus(rs.getInt(DbAdjusment.colNames[DbAdjusment.COL_POSTED_STATUS]));
            adjusment.setPostedById(rs.getLong(DbAdjusment.colNames[DbAdjusment.COL_POSTED_BY_ID]));
            adjusment.setPostedDate(rs.getDate(DbAdjusment.colNames[DbAdjusment.COL_POSTED_DATE]));
            adjusment.setEffectiveDate(rs.getDate(DbAdjusment.colNames[DbAdjusment.COL_EFFECTIVE_DATE]));


        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long adjusmentId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_ADJUSMENT + " WHERE " +
                    DbAdjusment.colNames[DbAdjusment.COL_ADJUSMENT_ID] + " = " + adjusmentId;

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
            String sql = "SELECT COUNT(" + DbAdjusment.colNames[DbAdjusment.COL_ADJUSMENT_ID] + ") FROM " + DB_POS_ADJUSMENT;
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
                    Adjusment adjusment = (Adjusment) list.get(ls);
                    if (oid == adjusment.getOID()) {
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
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_ADJUSMENT + " where " +
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
        code = code + sysCompany.getAdjustmentCode();

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

    public static Vector groupPosting(long adjId, String oidException) {
        CONResultSet dbrs = null;
        Vector result = new Vector();
        try {
            String sql = "select m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " as grp_id,sum(ad." + DbAdjusmentItem.colNames[DbAdjusmentItem.COL_QTY_BALANCE] + " * ad." + DbAdjusmentItem.colNames[DbAdjusmentItem.COL_PRICE] + ") as amount,g." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as name,g." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV] + ",g." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_AJUSTMENT] +
                    " from " + DbAdjusmentItem.DB_POS_ADJUSMENT_ITEM + " ad inner join " + DbItemMaster.DB_ITEM_MASTER + " m on ad." + DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ITEM_MASTER_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " g on m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = g." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " where ad." + DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ID] + " = " + adjId;

            if (oidException != null && oidException.length() > 0) {
                sql = sql + " and " + DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ITEM_ID] + " not in (" + oidException + ")";
            }

            sql = sql + " group by m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                GrpPost grpPost = new GrpPost();
                grpPost.setItemGroupId(rs.getLong("grp_id"));
                double amount = rs.getDouble("amount");
                String name = rs.getString("name");
                if (amount != 0) {
                    grpPost.setValue(amount);
                    grpPost.setName(name);
                    grpPost.setAccInv(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]));
                    grpPost.setAccAdjusment(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_AJUSTMENT]));
                    result.add(grpPost);
                }
            }
            rs.close();
        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static int postJournal(Adjusment adj, Vector details, Hashtable hCoaId, long userId, long pId, String oidException) {

        try {
            adj = DbAdjusment.fetchExc(adj.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        Vector result = groupPosting(adj.getOID(), oidException);

        long periodId = 0;
        Periode periode = new Periode();
        if (pId == 0) {
            periode = DbPeriode.getPeriodByTransDate(adj.getApproval1_date());
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
        if (adj.getLocationId() != 0) {
            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + adj.getLocationId();
            Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);

            if (segmentDt != null && segmentDt.size() > 0) {
                SegmentDetail sd = (SegmentDetail) segmentDt.get(0);

                if (sd.getRefSegmentDetailId() != 0) {
                    segment1_id = sd.getRefSegmentDetailId();
                } else {
                    segment1_id = sd.getOID();
                }

            }
        }

        //Untuk mengecek setup coa inventory dan coa HPP agar semua ada, jika tidak maka posting di batalkan        
        boolean coaALL = true;

        if (periodId == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
            coaALL = false;
        }

        if (coaALL == false) {
            return 0;
        }

        for (int i = 0; i < details.size(); i++) {

            //journalnya inventory pada HPP                    
            AdjusmentItem adjustmentItem = (AdjusmentItem) details.get(i);
            ItemMaster im = new ItemMaster();
            try {
                try {
                    im = DbItemMaster.fetchExc(adjustmentItem.getItemMasterId());
                } catch (Exception e) {
                }

                if (im.getOID() == 0) {
                    coaALL = false;
                }

                try {
                    if (im.getOID() != 0) {
                        ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());

                        String coaCogsCode = "";
                        try {
                            if (hCoaId.get("" + adjustmentItem.getOID()) != null) {
                                Coa c = (Coa) hCoaId.get("" + adjustmentItem.getOID());
                                if (c.getOID() != 0) {
                                    c = DbCoa.fetchExc(c.getOID());
                                    coaCogsCode = c.getCode();
                                } else {
                                    coaCogsCode = ig.getAccountAjustment();
                                    try {
                                        c = DbCoa.getCoaByCode(coaCogsCode);
                                    } catch (Exception e) {
                                    }
                                    if (c.getOID() == 0) {
                                        coaALL = false;
                                    }
                                }
                            } else {
                                coaCogsCode = ig.getAccountAjustment();
                                Coa c = new Coa();
                                try {
                                    c = DbCoa.getCoaByCode(coaCogsCode);
                                } catch (Exception e) {
                                }
                                if (c.getOID() == 0) {
                                    coaALL = false;
                                }
                            }
                        } catch (Exception e) {
                        }

                        //cogs                        
                        if (coaCogsCode.length() <= 0) {
                            coaALL = false;
                        }

                        if (ig.getAccountInv().length() <= 0) {
                            coaALL = false;
                        } else {
                            Coa c = new Coa();
                            try {
                                c = DbCoa.getCoaByCode(ig.getAccountInv());
                            } catch (Exception e) {
                            }
                            if (c.getOID() == 0) {
                                coaALL = false;
                            }
                        }
                    }
                } catch (Exception e) {
                }
            } catch (Exception e) {
            }
        }


        if (result != null && result.size() > 0) {
            for (int i = 0; i < result.size(); i++) {
                GrpPost grpPost = (GrpPost) result.get(i);
                if (grpPost.getAccAdjusment() == null || grpPost.getAccAdjusment().length() <= 0) {
                    coaALL = false;
                } else {
                    Coa coaCogs = new Coa();
                    try {
                        coaCogs = DbCoa.getCoaByCode(grpPost.getAccAdjusment());
                    } catch (Exception e) {
                    }
                    if (coaCogs.getOID() == 0) {
                        coaALL = false;
                    }
                }

                if (grpPost.getAccInv() == null || grpPost.getAccInv().length() <= 0) {
                    coaALL = false;
                    break;
                } else {
                    Coa coaInv = new Coa();
                    try {
                        coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                    } catch (Exception e) {
                    }
                    if (coaInv.getOID() == 0) {
                        coaALL = false;
                        break;
                    }
                }
            }
        }


        if (adj.getOID() != 0 && eRate.getOID() != 0 && coaALL == true) {

            if (((details != null && details.size() > 0) || (result != null && result.size() > 0))) {

                long oid = DbGl.postJournalMain(periode.getTableName(), 0, adj.getApproval1_date(), adj.getCounter(), adj.getNumber(), adj.getPrefixNumber(), I_Project.JOURNAL_TYPE_ADJUSMENT,
                        adj.getNote(), userId, "", adj.getOID(), "", adj.getDate(), periodId);

                if (oid != 0) {

                    for (int i = 0; i < details.size(); i++) {
                        //journalnya inventory pada HPP/Shringkage                    
                        AdjusmentItem adjustmentItem = (AdjusmentItem) details.get(i);
                        ItemMaster im = new ItemMaster();

                        try {

                            try {
                                im = DbItemMaster.fetchExc(adjustmentItem.getItemMasterId());
                            } catch (Exception e) {
                            }

                            Coa coaInv = new Coa();
                            Coa coaHpp = new Coa();

                            try {
                                if (im.getOID() != 0) {
                                    ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());

                                    String coaCogsCode = "";
                                    try {
                                        if (hCoaId.get("" + adjustmentItem.getOID()) != null) {
                                            Coa c = (Coa) hCoaId.get("" + adjustmentItem.getOID());
                                            if (c.getOID() != 0) {
                                                c = DbCoa.fetchExc(c.getOID());
                                                coaCogsCode = c.getCode();
                                            } else {
                                                coaCogsCode = ig.getAccountAjustment();
                                            }
                                        } else {
                                            coaCogsCode = ig.getAccountAjustment();
                                        }
                                    } catch (Exception e) {
                                    }

                                    if (coaCogsCode.length() > 0) {
                                        coaHpp = DbCoa.getCoaByCode(coaCogsCode);
                                    }

                                    if (ig.getAccountInv().length() > 0) {
                                        coaInv = DbCoa.getCoaByCode(ig.getAccountInv());
                                    }

                                    if ((adjustmentItem.getPrice() * adjustmentItem.getQtyBalance()) != 0) {

                                        String notes = adj.getNote();
                                        if (notes != null && notes.length() > 0) {
                                            notes = notes + ", ";
                                        }
                                        notes = "Adjusment Number (" + adj.getNumber() + ") " + notes + " category barang " + ig.getName();

                                        if ((adjustmentItem.getPrice() * adjustmentItem.getQtyBalance()) > 0) {
                                            //Kredit = Hpp
                                            DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaHpp.getOID(), (adjustmentItem.getPrice() * adjustmentItem.getQtyBalance()), 0,
                                                    (adjustmentItem.getPrice() * adjustmentItem.getQtyBalance()), eRate.getCurrencyIdrId(), oid, notes, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);

                                            //Debet = Inv
                                            DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaInv.getOID(), 0, (adjustmentItem.getPrice() * adjustmentItem.getQtyBalance()),
                                                    (adjustmentItem.getPrice() * adjustmentItem.getQtyBalance()), eRate.getCurrencyIdrId(), oid, notes, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);

                                        } else {
                                            //Debet = Hpp
                                            DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaHpp.getOID(), 0, (adjustmentItem.getPrice() * adjustmentItem.getQtyBalance())*-1,
                                                    (adjustmentItem.getPrice() * adjustmentItem.getQtyBalance())*-1, eRate.getCurrencyIdrId(), oid, notes, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);

                                            //Credit = Inv
                                            DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaInv.getOID(), (adjustmentItem.getPrice() * adjustmentItem.getQtyBalance())*-1, 0,
                                                    (adjustmentItem.getPrice() * adjustmentItem.getQtyBalance())*-1, eRate.getCurrencyIdrId(), oid, notes, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                        }
                                    }
                                }
                            } catch (Exception e) {
                            }
                        } catch (Exception e) {
                        }
                    }

                    if (result != null && result.size() > 0) {
                        for (int i = 0; i < result.size(); i++) {
                            GrpPost grpPost = (GrpPost) result.get(i);

                            String notes = adj.getNote();
                            if (notes != null && notes.length() > 0) {
                                notes = notes + ", ";
                            }
                            notes = "Adjusment Number (" + adj.getNumber() + ") " + notes + " category barang " + grpPost.getName();

                            Coa coaHpp = new Coa();
                            Coa coaInv = new Coa();

                            try {
                                coaHpp = DbCoa.getCoaByCode(grpPost.getAccAdjusment());
                            } catch (Exception e) {
                            }

                            try {
                                coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                            } catch (Exception e) {
                            }

                            if (grpPost.getValue() > 0) {
                                //Kredit = Hpp
                                DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaHpp.getOID(), grpPost.getValue(), 0,
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                //Debet = Inv
                                DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaInv.getOID(), 0, grpPost.getValue(),
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                            } else {
                                //Debet = Hpp
                                DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaHpp.getOID(), 0, grpPost.getValue()*-1,
                                        grpPost.getValue()*-1, eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                //Credit = Inv
                                DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaInv.getOID(), grpPost.getValue()*-1, 0,
                                        grpPost.getValue()*-1, eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }
                        }
                    }
                }

                //update status
                if (oid != 0) {
                    try {
                        adj.setStatus(I_Project.DOC_STATUS_POSTED);
                        adj.setPostedStatus(1);
                        adj.setPostedById(userId);
                        adj.setPostedDate(new Date());

                        Date dt = new Date();
                        String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                DbPeriode.colNames[DbPeriode.COL_END_DATE];

                        Vector temp = DbPeriode.list(0, 0, where, "");

                        if (temp != null && temp.size() > 0) {
                            adj.setEffectiveDate(new Date());
                        } else {
                            Periode per = new Periode();
                            if (periodId != 0) {
                                try {
                                    per = DbPeriode.fetchExc(periodId);
                                } catch (Exception e) {
                                    per = DbPeriode.getOpenPeriod();
                                }
                            }
                            adj.setEffectiveDate(per.getEndDate());
                        }

                        DbAdjusment.updateExc(adj);

                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
                return 1;

            } else { // jika detail tidak ada, maka langsung update status ke posted

                try {
                    adj.setStatus(I_Project.DOC_STATUS_POSTED);
                    adj.setPostedStatus(1);
                    adj.setPostedById(userId);
                    adj.setPostedDate(new Date());

                    Date dt = new Date();
                    String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                            DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                            DbPeriode.colNames[DbPeriode.COL_END_DATE];

                    Vector temp = DbPeriode.list(0, 0, where, "");

                    if (temp != null && temp.size() > 0) {
                        adj.setEffectiveDate(new Date());
                    } else {
                        Periode per = new Periode();
                        if (periodId != 0) {
                            try {
                                per = DbPeriode.fetchExc(periodId);
                            } catch (Exception e) {
                                per = DbPeriode.getOpenPeriod();
                            }
                        }
                        adj.setEffectiveDate(per.getEndDate());
                    }

                    DbAdjusment.updateExc(adj);

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
                return 1;

            }

        } else {
            return 0;
        }
    }
}
