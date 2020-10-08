package com.project.ccs.postransaction.memberpoint;

import com.project.I_Project;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.transaction.DbGl;
import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbCustomer;
import com.project.general.DbExchangeRate;
import com.project.general.DbLocation;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.ExchangeRate;
import com.project.general.Location;
import com.project.general.SystemDocNumber;
import java.sql.ResultSet;
import java.util.Date;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;

public class DbMemberPoint extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_MEMBER_POINT = "pos_member_point";
    public static final int COL_MEMBER_POINT_ID = 0;
    public static final int COL_CUSTOMER_ID = 1;
    public static final int COL_DATE = 2;
    public static final int COL_POINT = 3;
    public static final int COL_IN_OUT = 4;
    public static final int COL_TYPE = 5;
    public static final int COL_POINT_UNIT_VALUE = 6;
    public static final int COL_SALES_ID = 7;
    public static final int COL_GROUP_TYPE = 8;
    public static final int COL_ITEM_GROUP_ID = 9;
    public static final int COL_POSTED_STATUS = 10;
    public static final int COL_POSTED_BY_ID = 11;
    public static final int COL_POSTED_DATE = 12;
    public static final int COL_LOCATION_ID = 13;
    public static final String[] colNames = {
        "member_point_id",
        "customer_id",
        "date",
        "point",
        "in_out",
        "type",
        "point_unit_value",
        "sales_id",
        "group_type",
        "item_group_id",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "location_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG
    };
    public static int TYPE_CASH_BACK_ADD_POINT = 0;
    public static int TYPE_CASH_BACK_USE_PAYMENT = 1;
    public static int TYPE_CASH_BACK_NO_PAYMENT = 2;
    public static int TYPE_CASH_BACK_OPENING = 3;
    public static int TYPE_CASH_BACK_LANGSUNG = 4;

    public DbMemberPoint() {
    }

    public DbMemberPoint(int i) throws CONException {
        super(new DbMemberPoint());
    }

    public DbMemberPoint(String sOid) throws CONException {
        super(new DbMemberPoint(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbMemberPoint(long lOid) throws CONException {
        super(new DbMemberPoint(0));
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
        return DB_POS_MEMBER_POINT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbMemberPoint().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        MemberPoint memberpoint = fetchExc(ent.getOID());
        ent = (Entity) memberpoint;
        return memberpoint.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((MemberPoint) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((MemberPoint) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static MemberPoint fetchExc(long oid) throws CONException {
        try {
            MemberPoint memberpoint = new MemberPoint();
            DbMemberPoint pstMemberPoint = new DbMemberPoint(oid);
            memberpoint.setOID(oid);

            memberpoint.setCustomerId(pstMemberPoint.getlong(COL_CUSTOMER_ID));
            memberpoint.setDate(pstMemberPoint.getDate(COL_DATE));
            memberpoint.setPoint(pstMemberPoint.getdouble(COL_POINT));
            memberpoint.setInOut(pstMemberPoint.getInt(COL_IN_OUT));
            memberpoint.setType(pstMemberPoint.getInt(COL_TYPE));
            memberpoint.setPointUnitValue(pstMemberPoint.getdouble(COL_POINT_UNIT_VALUE));
            memberpoint.setSalesId(pstMemberPoint.getlong(COL_SALES_ID));
            memberpoint.setgroupType(pstMemberPoint.getInt(COL_GROUP_TYPE));
            memberpoint.setItemGroupId(pstMemberPoint.getlong(COL_ITEM_GROUP_ID));

            memberpoint.setPostedStatus(pstMemberPoint.getInt(COL_POSTED_STATUS));
            memberpoint.setPostedById(pstMemberPoint.getlong(COL_POSTED_BY_ID));
            memberpoint.setPostedDate(pstMemberPoint.getDate(COL_POSTED_DATE));
            memberpoint.setLocationId(pstMemberPoint.getlong(COL_LOCATION_ID));

            return memberpoint;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemberPoint(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(MemberPoint memberpoint) throws CONException {
        try {
            DbMemberPoint pstMemberPoint = new DbMemberPoint(0);

            pstMemberPoint.setLong(COL_CUSTOMER_ID, memberpoint.getCustomerId());
            pstMemberPoint.setDate(COL_DATE, memberpoint.getDate());
            pstMemberPoint.setDouble(COL_POINT, memberpoint.getPoint());
            pstMemberPoint.setInt(COL_IN_OUT, memberpoint.getInOut());
            pstMemberPoint.setInt(COL_TYPE, memberpoint.getType());
            pstMemberPoint.setDouble(COL_POINT_UNIT_VALUE, memberpoint.getPointUnitValue());
            pstMemberPoint.setLong(COL_SALES_ID, memberpoint.getSalesId());
            pstMemberPoint.setInt(COL_GROUP_TYPE, memberpoint.getGroupType());
            pstMemberPoint.setLong(COL_ITEM_GROUP_ID, memberpoint.getItemGroupId());

            pstMemberPoint.setInt(COL_POSTED_STATUS, memberpoint.getPostedStatus());
            pstMemberPoint.setLong(COL_POSTED_BY_ID, memberpoint.getPostedById());
            pstMemberPoint.setDate(COL_POSTED_DATE, memberpoint.getPostedDate());
            pstMemberPoint.setLong(COL_LOCATION_ID, memberpoint.getLocationId());

            pstMemberPoint.insert();
            memberpoint.setOID(pstMemberPoint.getlong(COL_MEMBER_POINT_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemberPoint(0), CONException.UNKNOWN);
        }
        return memberpoint.getOID();
    }

    public static long updateExc(MemberPoint memberpoint) throws CONException {
        try {
            if (memberpoint.getOID() != 0) {
                DbMemberPoint pstMemberPoint = new DbMemberPoint(memberpoint.getOID());

                pstMemberPoint.setLong(COL_CUSTOMER_ID, memberpoint.getCustomerId());
                pstMemberPoint.setDate(COL_DATE, memberpoint.getDate());
                pstMemberPoint.setDouble(COL_POINT, memberpoint.getPoint());
                pstMemberPoint.setInt(COL_IN_OUT, memberpoint.getInOut());
                pstMemberPoint.setInt(COL_TYPE, memberpoint.getType());
                pstMemberPoint.setDouble(COL_POINT_UNIT_VALUE, memberpoint.getPointUnitValue());
                pstMemberPoint.setLong(COL_SALES_ID, memberpoint.getSalesId());
                pstMemberPoint.setInt(COL_GROUP_TYPE, memberpoint.getGroupType());
                pstMemberPoint.setLong(COL_ITEM_GROUP_ID, memberpoint.getItemGroupId());
                pstMemberPoint.setInt(COL_POSTED_STATUS, memberpoint.getPostedStatus());
                pstMemberPoint.setLong(COL_POSTED_BY_ID, memberpoint.getPostedById());
                pstMemberPoint.setDate(COL_POSTED_DATE, memberpoint.getPostedDate());
                pstMemberPoint.setLong(COL_LOCATION_ID, memberpoint.getLocationId());

                pstMemberPoint.update();
                return memberpoint.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemberPoint(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbMemberPoint pstMemberPoint = new DbMemberPoint(oid);
            pstMemberPoint.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemberPoint(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_MEMBER_POINT;
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
                MemberPoint memberpoint = new MemberPoint();
                resultToObject(rs, memberpoint);
                lists.add(memberpoint);
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

    private static void resultToObject(ResultSet rs, MemberPoint memberpoint) {
        try {
            memberpoint.setOID(rs.getLong(DbMemberPoint.colNames[DbMemberPoint.COL_MEMBER_POINT_ID]));
            memberpoint.setCustomerId(rs.getLong(DbMemberPoint.colNames[DbMemberPoint.COL_CUSTOMER_ID]));
            Date tm = CONHandler.convertDate(rs.getDate(DbMemberPoint.colNames[DbMemberPoint.COL_DATE]), rs.getTime(DbMemberPoint.colNames[DbMemberPoint.COL_DATE]));
            memberpoint.setDate(tm);
            memberpoint.setPoint(rs.getDouble(DbMemberPoint.colNames[DbMemberPoint.COL_POINT]));
            memberpoint.setInOut(rs.getInt(DbMemberPoint.colNames[DbMemberPoint.COL_IN_OUT]));
            memberpoint.setType(rs.getInt(DbMemberPoint.colNames[DbMemberPoint.COL_TYPE]));
            memberpoint.setPointUnitValue(rs.getDouble(DbMemberPoint.colNames[DbMemberPoint.COL_POINT_UNIT_VALUE]));
            memberpoint.setSalesId(rs.getLong(DbMemberPoint.colNames[DbMemberPoint.COL_SALES_ID]));
            memberpoint.setgroupType(rs.getInt(DbMemberPoint.colNames[DbMemberPoint.COL_GROUP_TYPE]));
            memberpoint.setItemGroupId(rs.getLong(DbMemberPoint.colNames[DbMemberPoint.COL_ITEM_GROUP_ID]));
            memberpoint.setPostedStatus(rs.getInt(DbMemberPoint.colNames[DbMemberPoint.COL_POSTED_STATUS]));
            memberpoint.setPostedById(rs.getLong(DbMemberPoint.colNames[DbMemberPoint.COL_POSTED_BY_ID]));
            memberpoint.setPostedDate(rs.getDate(DbMemberPoint.colNames[DbMemberPoint.COL_POSTED_DATE]));
            memberpoint.setLocationId(rs.getLong(DbMemberPoint.colNames[DbMemberPoint.COL_LOCATION_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long memberPointId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_MEMBER_POINT + " WHERE " +
                    DbMemberPoint.colNames[DbMemberPoint.COL_MEMBER_POINT_ID] + " = " + memberPointId;

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
            String sql = "SELECT COUNT(" + DbMemberPoint.colNames[DbMemberPoint.COL_MEMBER_POINT_ID] + ") FROM " + DB_POS_MEMBER_POINT;
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
                    MemberPoint memberpoint = (MemberPoint) list.get(ls);
                    if (oid == memberpoint.getOID()) {
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

    public static long postJournal(MemberPoint mp, long userId, long coaDebet, long coaCredit, Company company){

        try {
            mp = DbMemberPoint.fetchExc(mp.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        if (mp.getLocationId() == 0 || mp.getPostedStatus() == 1) { // pengecekan jika sudah status posting, tidak akan di posting lagi
            return 0;
        }

        long segment1_id = 0;
        if (mp.getLocationId() != 0) {
            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + mp.getLocationId();
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

        Periode periode = new Periode();
        periode = DbPeriode.getPeriodByTransDate(mp.getDate());

        boolean coaALL = true;

        if (periode.getOID() == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
            coaALL = false;
        }

        if (coaDebet == 0 || coaCredit == 0) {
            coaALL = false;
        }

        if (coaALL == false || mp.getPostedStatus() == 1) {
            return 0;
        }

        Date dt = new Date();
        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e) {
        }

        if (periodeTaken == 0) {
            dt = periode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = periode.getEndDate();  // untuk mendapatkan periode yang aktif}
        }

        String formatDocCode = DbSystemDocNumber.getNumberPrefix(periode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_CASH_BACK);
        int counter = DbSystemDocNumber.getNextCounter(periode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_CASH_BACK);

        // proses untuk object ke general penanpungan code
        SystemDocNumber systemDocNumber = new SystemDocNumber();
        systemDocNumber.setCounter(counter);
        systemDocNumber.setDate(new Date());
        systemDocNumber.setPrefixNumber(formatDocCode);
        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_CASH_BACK]);
        systemDocNumber.setYear(dt.getYear() + 1900);

        String journalNumber = DbSystemDocNumber.getNextNumber(counter, periode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_CASH_BACK);
        systemDocNumber.setDocNumber(journalNumber);

        long oidRp = 0;
        try {
            oidRp = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
        } catch (Exception e) {
        }

        long oidDoc = 0;
        try {
            oidDoc = DbSystemDocNumber.insertExc(systemDocNumber);
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        }

        if (oidDoc != 0) {

            Customer c = new Customer();
            try {
                c = DbCustomer.fetchExc(mp.getCustomerId());
            } catch (Exception e) {
            }
            String note = "Pengambilan cash back langsung ";

            if (c.getOID() != 0) {
                note = note + " oleh " + c.getName();
            }

            if (mp.getLocationId() != 0) {
                try {
                    Location l = DbLocation.fetchExc(mp.getLocationId());
                    if (l.getOID() != 0) {
                        note = note + " lokasi :" + l.getName();
                    }
                } catch (Exception e) {
                }
            }

            note = note + " tanggal " + JSPFormater.formatDate(mp.getDate(), "dd MMM yyyy");

            long oid = DbGl.postJournalMain(periode.getTableName(), oidRp, mp.getDate(), counter, journalNumber, formatDocCode, I_Project.JOURNAL_TYPE_CASH_BACK,
                    note, userId, "", mp.getOID(), "", mp.getDate(), periode.getOID());

            if (oid != 0) {

                ExchangeRate er = DbExchangeRate.getStandardRate();

                DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), coaDebet, 0, mp.getPoint(),
                        mp.getPoint(), company.getBookingCurrencyId(), oid, note, 0,
                        segment1_id, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0);

                DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), coaCredit, mp.getPoint(), 0,
                        mp.getPoint(), company.getBookingCurrencyId(), oid, note, 0,
                        segment1_id, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0);
                
                
                 updateStatus(mp,userId);
            }

            return oid;
        }
        return 0;

    }
    
    
    public static void updateStatus(MemberPoint mp,long userId){
        
        CONResultSet dbrs = null;
        try{
            if(mp.getOID() != 0){
                String sql = "update "+DbMemberPoint.DB_POS_MEMBER_POINT+" set "+DbMemberPoint.colNames[DbMemberPoint.COL_POSTED_BY_ID]+" = "+userId+","+
                    DbMemberPoint.colNames[DbMemberPoint.COL_POSTED_STATUS]+" = 1, "+
                    DbMemberPoint.colNames[DbMemberPoint.COL_POSTED_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss")+"' where "+
                    DbMemberPoint.colNames[DbMemberPoint.COL_MEMBER_POINT_ID]+" = "+mp.getOID();
            
                CONHandler.execUpdate(sql);
            }
        }catch(Exception e){
        }finally {
            CONResultSet.close(dbrs);
        }
    }
}
