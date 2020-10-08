/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;
/**
 *
 * @author OxysytemBook
 */
public class DbDocumentHistory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{

    
    public static final String DB_DOCUMENT_HISTORY = "document_history";
    public static final int COL_DOCUMENT_HISTORY_ID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_EMPLOYEE_ID = 3;
    public static final int COL_DESCRIPTION = 4;
    public static final int COL_REF_ID = 5;
    public static final int COL_DATE = 6;
    
    public static final String[] colNames = {
        "document_history_id",
        "type",
        "user_id",
        "employee_id",
        "description",
        "ref_id",
        "date"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_DATE
    };
    
    public static final int TYPE_DOC_TRANSFER = 0;

    public DbDocumentHistory() {
    }

    public DbDocumentHistory(int i) throws CONException {
        super(new DbDocumentHistory());
    }

    public DbDocumentHistory(String sOid) throws CONException {
        super(new DbDocumentHistory(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbDocumentHistory(long lOid) throws CONException {
        super(new DbDocumentHistory(0));
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
        return DB_DOCUMENT_HISTORY;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbDocumentHistory().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DocumentHistory documentHistory = fetchExc(ent.getOID());
        ent = (Entity) documentHistory;
        return documentHistory.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DocumentHistory) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DocumentHistory) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DocumentHistory fetchExc(long oid) throws CONException {
        try {
            DocumentHistory documentHistory = new DocumentHistory();
            DbDocumentHistory pstDocumentHistory = new DbDocumentHistory(oid);
            documentHistory.setOID(oid);

            documentHistory.setType(pstDocumentHistory.getInt(COL_TYPE));
            documentHistory.setUserId(pstDocumentHistory.getlong(COL_USER_ID));
            documentHistory.setEmployeeId(pstDocumentHistory.getlong(COL_EMPLOYEE_ID));
            documentHistory.setDescription(pstDocumentHistory.getString(COL_DESCRIPTION));
            documentHistory.setRefId(pstDocumentHistory.getlong(COL_REF_ID));
            documentHistory.setDate(pstDocumentHistory.getDate(COL_DATE));

            return documentHistory;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocumentHistory(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(DocumentHistory documentHistory) throws CONException {
        try {
            DbDocumentHistory pstDocumentHistory = new DbDocumentHistory(0);

            pstDocumentHistory.setInt(COL_TYPE, documentHistory.getType());
            pstDocumentHistory.setLong(COL_USER_ID, documentHistory.getUserId());
            pstDocumentHistory.setLong(COL_EMPLOYEE_ID, documentHistory.getEmployeeId());
            pstDocumentHistory.setString(COL_DESCRIPTION, documentHistory.getDescription());
            pstDocumentHistory.setLong(COL_REF_ID, documentHistory.getRefId());
            pstDocumentHistory.setDate(COL_DATE, documentHistory.getDate());

            pstDocumentHistory.insert();
            documentHistory.setOID(pstDocumentHistory.getlong(COL_DOCUMENT_HISTORY_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocumentHistory(0), CONException.UNKNOWN);
        }
        return documentHistory.getOID();
    }

    public static long updateExc(DocumentHistory documentHistory) throws CONException {
        try {
            if (documentHistory.getOID() != 0) {
                DbDocumentHistory pstDocumentHistory = new DbDocumentHistory(documentHistory.getOID());

                pstDocumentHistory.setInt(COL_TYPE, documentHistory.getType());
                pstDocumentHistory.setLong(COL_USER_ID, documentHistory.getUserId());
                pstDocumentHistory.setLong(COL_EMPLOYEE_ID, documentHistory.getEmployeeId());
                pstDocumentHistory.setString(COL_DESCRIPTION, documentHistory.getDescription());
                pstDocumentHistory.setLong(COL_REF_ID, documentHistory.getRefId());
                pstDocumentHistory.setDate(COL_DATE, documentHistory.getDate());

                pstDocumentHistory.update();
                return documentHistory.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocumentHistory(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbDocumentHistory pstDocumentHistory = new DbDocumentHistory(oid);
            pstDocumentHistory.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocumentHistory(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_DOCUMENT_HISTORY;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                DocumentHistory documentHistory = new DocumentHistory();
                resultToObject(rs, documentHistory);
                lists.add(documentHistory);
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

    private static void resultToObject(ResultSet rs, DocumentHistory documentHistory) {
        try {
            documentHistory.setOID(rs.getLong(DbDocumentHistory.colNames[DbDocumentHistory.COL_DOCUMENT_HISTORY_ID]));
            documentHistory.setType(rs.getInt(DbDocumentHistory.colNames[DbDocumentHistory.COL_TYPE]));
            documentHistory.setUserId(rs.getLong(DbDocumentHistory.colNames[DbDocumentHistory.COL_USER_ID]));
            documentHistory.setEmployeeId(rs.getLong(DbDocumentHistory.colNames[DbDocumentHistory.COL_EMPLOYEE_ID]));
            documentHistory.setDescription(rs.getString(DbDocumentHistory.colNames[DbDocumentHistory.COL_DESCRIPTION]));            
            String str = rs.getString(DbDocumentHistory.colNames[DbDocumentHistory.COL_DATE]);
            documentHistory.setDate(JSPFormater.formatDate(str, "yyyy-MM-dd hh:mm:ss"));
            documentHistory.setRefId(rs.getLong(DbDocumentHistory.colNames[DbDocumentHistory.COL_REF_ID]));            
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static boolean checkOID(long documentHistoryId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_DOCUMENT_HISTORY + " WHERE " +
                    DbHistoryUser.colNames[DbDocumentHistory.COL_DOCUMENT_HISTORY_ID] + " = " + documentHistoryId;

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
            String sql = "SELECT COUNT(" + DbDocumentHistory.colNames[DbDocumentHistory.COL_DOCUMENT_HISTORY_ID] + ") FROM " + DB_DOCUMENT_HISTORY;
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
                    DocumentHistory documentHistory = (DocumentHistory) list.get(ls);
                    if (oid == documentHistory.getOID()) {
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
