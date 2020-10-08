/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.printer;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author gadnyana
 */
public class DbDocPrinter extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_DOC_PRINTER = "doc_printer";
    public static final int COL_DOC_PRINTER_ID = 0;
    public static final int COL_DOC_ID = 1;
    public static final int COL_DOC_CODE = 2;
    public static final int COL_HOST_PRINTER = 3;
    public static final int COL_TIME_PRINTER = 4;
    public static final int COL_USER_ID = 5;

    public static final String[] colNames = {
        "doc_printer_id",
        "doc_id",
        "doc_code",
        "host_printer",
        "time_printer",
        "user_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG
    };

    public DbDocPrinter() {
    }

    public DbDocPrinter(int i) throws CONException {
        super(new DbDocPrinter());
    }

    public DbDocPrinter(String sOid) throws CONException {
        super(new DbDocPrinter(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbDocPrinter(long lOid) throws CONException {
        super(new DbDocPrinter(0));
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
        return DB_DOC_PRINTER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbDocPrinter().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DocPrinter docPrinter = fetchExc(ent.getOID());
        ent = (Entity) docPrinter;
        return docPrinter.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DocPrinter) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DocPrinter) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DocPrinter fetchExc(long oid) throws CONException {
        try {
            DocPrinter docPrinter = new DocPrinter();
            DbDocPrinter pstDocPrinter = new DbDocPrinter(oid);
            docPrinter.setOID(oid);

            docPrinter.setDocId(pstDocPrinter.getlong(COL_DOC_ID));
            docPrinter.setDocCode(pstDocPrinter.getString(COL_DOC_CODE));
            docPrinter.setHostPrinter(pstDocPrinter.getString(COL_HOST_PRINTER));
            docPrinter.setTimePrinter(pstDocPrinter.getDate(COL_TIME_PRINTER));
            docPrinter.setUserId(pstDocPrinter.getlong(COL_USER_ID));

            return docPrinter;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocPrinter(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(DocPrinter docPrinter) throws CONException {
        try {
            DbDocPrinter pstDocPrinter = new DbDocPrinter(0);

            pstDocPrinter.setLong(COL_DOC_ID, docPrinter.getDocId());
            pstDocPrinter.setString(COL_DOC_CODE, docPrinter.getDocCode());
            pstDocPrinter.setString(COL_HOST_PRINTER, docPrinter.getHostPrinter());
            pstDocPrinter.setDate(COL_TIME_PRINTER, docPrinter.getTimePrinter());
            pstDocPrinter.setLong(COL_USER_ID, docPrinter.getUserId());

            pstDocPrinter.insert();
            docPrinter.setOID(pstDocPrinter.getlong(COL_DOC_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocPrinter(0), CONException.UNKNOWN);
        }
        return docPrinter.getOID();
    }

    public static long updateExc(DocPrinter docPrinter) throws CONException {
        try {
            if (docPrinter.getOID() != 0) {
                DbDocPrinter pstDocPrinter = new DbDocPrinter(docPrinter.getOID());

                pstDocPrinter.setLong(COL_DOC_ID, docPrinter.getDocId());
                pstDocPrinter.setString(COL_DOC_CODE, docPrinter.getDocCode());
                pstDocPrinter.setString(COL_HOST_PRINTER, docPrinter.getHostPrinter());
                pstDocPrinter.setDate(COL_TIME_PRINTER, docPrinter.getTimePrinter());
                pstDocPrinter.setLong(COL_USER_ID, docPrinter.getUserId());

                pstDocPrinter.update();
                return docPrinter.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocPrinter(0), CONException.UNKNOWN);
        }
        return 0;
    }

    // proses yg dipanggil di jsp
    public static void insertDocToPrint(String docCode, long docOid, String hostPrinter){
        try{
            DocPrinter docPrinterNew = new DocPrinter();
            docPrinterNew.setDocCode(docCode);
            docPrinterNew.setDocId(docOid);
            docPrinterNew.setHostPrinter(hostPrinter);
            docPrinterNew.setTimePrinter(new Date());            
            
            insertExc(docPrinterNew);

        }catch(Exception e){
            System.out.println("Err >>>> : "+e.toString());
        }
    }
    
    public static void insertDocToPrint(String docCode, long docOid, String hostPrinter,long userId){
        try{
            DocPrinter docPrinterNew = new DocPrinter();
            docPrinterNew.setDocCode(docCode);
            docPrinterNew.setDocId(docOid);
            docPrinterNew.setHostPrinter(hostPrinter);
            docPrinterNew.setTimePrinter(new Date());            
            docPrinterNew.setUserId(userId);  
            
            insertExc(docPrinterNew);

        }catch(Exception e){
            System.out.println("Err >>>> : "+e.toString());
        }
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbDocPrinter pstDocPrinter = new DbDocPrinter(oid);
            pstDocPrinter.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocPrinter(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_DOC_PRINTER;
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
                DocPrinter docPrinter = new DocPrinter();
                resultToObject(rs, docPrinter);
                lists.add(docPrinter);
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

    public static void resultToObject(ResultSet rs, DocPrinter docPrinter) {
        try {

            docPrinter.setOID(rs.getLong(DbDocPrinter.colNames[DbDocPrinter.COL_DOC_PRINTER_ID]));
            docPrinter.setDocId(rs.getLong(DbDocPrinter.colNames[DbDocPrinter.COL_DOC_ID]));
            docPrinter.setDocCode(rs.getString(DbDocPrinter.colNames[DbDocPrinter.COL_DOC_CODE]));
            docPrinter.setHostPrinter(rs.getString(DbDocPrinter.colNames[DbDocPrinter.COL_HOST_PRINTER]));
            docPrinter.setTimePrinter(rs.getDate(DbDocPrinter.colNames[DbDocPrinter.COL_TIME_PRINTER]));
            docPrinter.setUserId(rs.getLong(DbDocPrinter.colNames[DbDocPrinter.COL_USER_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long docPrinterId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_DOC_PRINTER + " WHERE "
                    + DbDocPrinter.colNames[DbDocPrinter.COL_DOC_PRINTER_ID] + " = " + docPrinterId;

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
            String sql = "SELECT COUNT(" + DbDocPrinter.colNames[DbDocPrinter.COL_DOC_PRINTER_ID] + ") FROM " + DB_DOC_PRINTER;
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
                    DocPrinter docPrinter = (DocPrinter) list.get(ls);
                    if (oid == docPrinter.getOID()) {
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
