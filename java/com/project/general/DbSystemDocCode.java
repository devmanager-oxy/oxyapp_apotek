package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

public class DbSystemDocCode extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SYSTEM_DOC_CODE = "system_doc_code";
    public static final int COL_SYSTEM_DOC_CODE_ID = 0;
    public static final int COL_CODE = 1;
    public static final int COL_TYPE = 2;
    public static final int COL_CODE_FORMAT = 3;
    public static final int COL_SEPARATOR = 4;
    public static final int COL_DIGIT_COUNTER = 5;
    public static final int COL_POSISI_AFTER_CODE = 6;
    public static final int COL_YEAR_DIGIT = 7;
    public static final int COL_MONTH_DIGIT = 8;
    public static final int COL_MONTH_TYPE = 9;
    
    public static final String[] colNames = {
        "system_doc_code_id",
        "code",
        "type",
        "code_format",
        "doc_separator",
        "digit_counter",
        "posisi_after_code",
        "year_digit",
        "month_digit",
        "month_type"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };

    // TYPE DOKUMENT
    public static final int TYPE_DOCUMENT_BKM = 0;
    public static final int TYPE_DOCUMENT_INV = 1;
    public static final int TYPE_DOCUMENT_FP = 2;
    public static final int TYPE_DOCUMENT_PO = 3;
    public static final int TYPE_DOCUMENT_PR = 4;
    public static final int TYPE_DOCUMENT_LIMBAH = 5;
    public static final int TYPE_DOCUMENT_IRIGASI = 6;
    public static final int TYPE_DOCUMENT_KOMIN = 7;
    public static final int TYPE_DOCUMENT_KOMPER = 8;
    public static final int TYPE_DOCUMENT_ASSESSMENT = 9;
    public static final int TYPE_DOCUMENT_BKK = 10;
    public static final int TYPE_DOCUMENT_GL = 11;
    public static final int TYPE_DOCUMENT_RENTAL = 12;
    public static final int TYPE_DOCUMENT_SALES_PROPERTY = 13;    
    public static final int TYPE_DOCUMENT_AP_MEMO = 14;   
    public static final int TYPE_DOCUMENT_AR_MEMO = 15;   
    public static final int TYPE_DOCUMENT_TT = 16;   
    public static final int TYPE_DOCUMENT_KASBON = 17;       
    public static final int TYPE_DOCUMENT_BBM = 18; 
    public static final int TYPE_DOCUMENT_BBK = 19; 
    public static final int TYPE_DOCUMENT_SALES = 20; 
    public static final int TYPE_DOCUMENT_CUSTOMER = 21;
    public static final int TYPE_DOCUMENT_SETORAN_KASIR = 22;
    public static final int TYPE_DOCUMENT_RECONCILE_CARD = 23;
    public static final int TYPE_DOCUMENT_CASH_BACK = 24;
    public static final int TYPE_DOCUMENT_TT_CHECK = 25;
    public static final int TYPE_DOCUMENT_TT_GROUP = 26;
    public static final int TYPE_DOCUMENT_BUDGET = 27;
    public static final int TYPE_DOCUMENT_AR_INVOICE = 28;
    
    // ini type dokumen yang ada
    public static final String[] typeDocument = {
        "Bukti Kas Masuk",
        "Invoice",
        "Faktur Pajak",
        "Purchase Order",
        "Purchase Request",
        "Limbah",
        "Irigasi",
        "Komin",
        "Komper",
        "Assessment",
        "Bukti Kas Keluar",
        "General Ledger",
        "Rental",
        "Sales Property",
        "AP Memo",
        "AR Memo",
        "TT",
        "Kasbon",
        "Bukti Bank Masuk",
        "Bukti Bank Keluar",
        "Sales",
        "Customer",
        "setoran Kasir",
        "Reconcile Card",
        "Cash Back",
        "TT Check",
        "TT_GROUP",
        "Budget"
    };
    
    public static final int TYPE_POSITION_FRONT = 0;
    public static final int TYPE_POSITION_BACK  = 1;
    
    public static final String[] statusPositionInd = {
        "Depan",
        "Belakang"
    };
    
    public static final String[] statusPositionEng = {
        "Front",
        "Back"
    };
    
    public static final int MONTH_TYPE_NUMBER = 0;
    public static final int MONTH_TYPE_ROMAWI = 1;
    
    public static final String[] monthType = {
        "Number",
        "Romawi"
    };

    public DbSystemDocCode() {
    }

    public DbSystemDocCode(int i) throws CONException {
        super(new DbSystemDocCode());
    }

    public DbSystemDocCode(String sOid) throws CONException {
        super(new DbSystemDocCode(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSystemDocCode(long lOid) throws CONException {
        super(new DbSystemDocCode(0));
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
        return DB_SYSTEM_DOC_CODE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSystemDocCode().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SystemDocCode systemdoccode = fetchExc(ent.getOID());
        ent = (Entity) systemdoccode;
        return systemdoccode.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SystemDocCode) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SystemDocCode) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SystemDocCode fetchExc(long oid) throws CONException {
        try {
            SystemDocCode systemdoccode = new SystemDocCode();
            DbSystemDocCode pstSystemDocCode = new DbSystemDocCode(oid);
            systemdoccode.setOID(oid);

            systemdoccode.setCode(pstSystemDocCode.getString(COL_CODE));
            systemdoccode.setType(pstSystemDocCode.getString(COL_TYPE));
            systemdoccode.setCodeFormat(pstSystemDocCode.getString(COL_CODE_FORMAT));
            systemdoccode.setSeparator(pstSystemDocCode.getString(COL_SEPARATOR));

            systemdoccode.setDigitCounter(pstSystemDocCode.getInt(COL_DIGIT_COUNTER));
            systemdoccode.setPosisiAfterCode(pstSystemDocCode.getInt(COL_POSISI_AFTER_CODE));
            systemdoccode.setYearDigit(pstSystemDocCode.getInt(COL_YEAR_DIGIT));
            systemdoccode.setMonthDigit(pstSystemDocCode.getInt(COL_MONTH_DIGIT));
            systemdoccode.setMonthType(pstSystemDocCode.getInt(COL_MONTH_TYPE));

            return systemdoccode;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSystemDocCode(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SystemDocCode systemdoccode) throws CONException {
        try {
            DbSystemDocCode pstSystemDocCode = new DbSystemDocCode(0);

            pstSystemDocCode.setString(COL_CODE, systemdoccode.getCode());
            pstSystemDocCode.setString(COL_TYPE, systemdoccode.getType());
            pstSystemDocCode.setString(COL_CODE_FORMAT, systemdoccode.getCodeFormat());
            pstSystemDocCode.setString(COL_SEPARATOR, systemdoccode.getSeparator());

            pstSystemDocCode.setInt(COL_DIGIT_COUNTER, systemdoccode.getDigitCounter());
            pstSystemDocCode.setInt(COL_POSISI_AFTER_CODE, systemdoccode.getPosisiAfterCode());
            pstSystemDocCode.setInt(COL_YEAR_DIGIT, systemdoccode.getYearDigit());
            pstSystemDocCode.setInt(COL_MONTH_DIGIT, systemdoccode.getMonthDigit());
            pstSystemDocCode.setInt(COL_MONTH_TYPE, systemdoccode.getMonthType());

            pstSystemDocCode.insert();
            systemdoccode.setOID(pstSystemDocCode.getlong(COL_SYSTEM_DOC_CODE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSystemDocCode(0), CONException.UNKNOWN);
        }
        return systemdoccode.getOID();
    }

    public static long updateExc(SystemDocCode systemdoccode) throws CONException {
        try {
            if (systemdoccode.getOID() != 0) {
                DbSystemDocCode pstSystemDocCode = new DbSystemDocCode(systemdoccode.getOID());

                pstSystemDocCode.setString(COL_CODE, systemdoccode.getCode());
                pstSystemDocCode.setString(COL_TYPE, systemdoccode.getType());
                pstSystemDocCode.setString(COL_CODE_FORMAT, systemdoccode.getCodeFormat());
                pstSystemDocCode.setString(COL_SEPARATOR, systemdoccode.getSeparator());
                pstSystemDocCode.setInt(COL_DIGIT_COUNTER, systemdoccode.getDigitCounter());
                pstSystemDocCode.setInt(COL_POSISI_AFTER_CODE, systemdoccode.getPosisiAfterCode());
                pstSystemDocCode.setInt(COL_YEAR_DIGIT, systemdoccode.getYearDigit());
                pstSystemDocCode.setInt(COL_MONTH_DIGIT, systemdoccode.getMonthDigit());
                pstSystemDocCode.setInt(COL_MONTH_TYPE, systemdoccode.getMonthType());

                pstSystemDocCode.update();
                return systemdoccode.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSystemDocCode(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSystemDocCode pstSystemDocCode = new DbSystemDocCode(oid);
            pstSystemDocCode.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSystemDocCode(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SYSTEM_DOC_CODE;
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
                SystemDocCode systemdoccode = new SystemDocCode();
                resultToObject(rs, systemdoccode);
                lists.add(systemdoccode);
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

    private static void resultToObject(ResultSet rs, SystemDocCode systemdoccode) {
        try {
            systemdoccode.setOID(rs.getLong(DbSystemDocCode.colNames[DbSystemDocCode.COL_SYSTEM_DOC_CODE_ID]));
            systemdoccode.setCode(rs.getString(DbSystemDocCode.colNames[DbSystemDocCode.COL_CODE]));
            systemdoccode.setType(rs.getString(DbSystemDocCode.colNames[DbSystemDocCode.COL_TYPE]));
            systemdoccode.setCodeFormat(rs.getString(DbSystemDocCode.colNames[DbSystemDocCode.COL_CODE_FORMAT]));
            systemdoccode.setSeparator(rs.getString(DbSystemDocCode.colNames[DbSystemDocCode.COL_SEPARATOR]));
            systemdoccode.setDigitCounter(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_DIGIT_COUNTER]));
            systemdoccode.setPosisiAfterCode(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_POSISI_AFTER_CODE]));
            systemdoccode.setYearDigit(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_YEAR_DIGIT]));
            systemdoccode.setMonthDigit(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_MONTH_DIGIT]));
            systemdoccode.setMonthType(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_MONTH_TYPE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long systemDocCodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SYSTEM_DOC_CODE + " WHERE " +
                    DbSystemDocCode.colNames[DbSystemDocCode.COL_SYSTEM_DOC_CODE_ID] + " = " + systemDocCodeId;

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
            String sql = "SELECT COUNT(" + DbSystemDocCode.colNames[DbSystemDocCode.COL_SYSTEM_DOC_CODE_ID] + ") FROM " + DB_SYSTEM_DOC_CODE;
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

    /**
     * proses untuk mencari kode dari dokumen
     **/
    public static SystemDocCode getDocCodeByTypeCode(String typeCode) {
        CONResultSet dbrs = null;
        SystemDocCode systemDocCode = new SystemDocCode();
        try {
            String sql = "SELECT * FROM " + DB_SYSTEM_DOC_CODE + " WHERE " +
                    colNames[COL_TYPE] + " = '" + typeCode + "'";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                systemDocCode.setOID(rs.getLong(colNames[COL_SYSTEM_DOC_CODE_ID]));
                systemDocCode.setType(rs.getString(colNames[COL_TYPE]));
                systemDocCode.setCode(rs.getString(colNames[COL_CODE]));
                systemDocCode.setCodeFormat(rs.getString(colNames[COL_CODE_FORMAT]));
                systemDocCode.setSeparator(rs.getString(colNames[COL_SEPARATOR]));
                
                systemDocCode.setDigitCounter(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_DIGIT_COUNTER]));
                systemDocCode.setPosisiAfterCode(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_POSISI_AFTER_CODE]));
                systemDocCode.setYearDigit(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_YEAR_DIGIT]));
                systemDocCode.setMonthDigit(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_MONTH_DIGIT]));
                systemDocCode.setMonthType(rs.getInt(DbSystemDocCode.colNames[DbSystemDocCode.COL_MONTH_TYPE]));
                
            }
            rs.close();

        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return systemDocCode;
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
                    SystemDocCode systemdoccode = (SystemDocCode) list.get(ls);
                    if (oid == systemdoccode.getOID()) {
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
}
