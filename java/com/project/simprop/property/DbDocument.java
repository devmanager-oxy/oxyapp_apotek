/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class DbDocument extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{

    public static final String DB_DOCUMENT = "prop_document";
    
    public static final int COL_DOCUMENT_ID = 0;
    public static final int COL_NAME_DOCUMENT = 1;
    public static final int COL_TYPE_KARYAWAN = 2;
    public static final int COL_TYPE_PENGUSAHA = 3;
    public static final int COL_TYPE_PROFESI = 4;
    
    public static final String[] colNames = {
        "document_id",
        "name_document",
        "type_karyawan",
        "type_pengusaha",
        "type_profesi"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,       
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };
    
    public DbDocument() {
    }

    public DbDocument(int i) throws CONException {
        super(new DbDocument());
    }

    public DbDocument(String sOid) throws CONException {
        super(new DbDocument(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbDocument(long lOid) throws CONException {
        super(new DbDocument(0));
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
        return DB_DOCUMENT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbDocument().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Document document = fetchExc(ent.getOID());
        ent = (Entity) document;
        return document.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Document) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Document) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Document fetchExc(long oid) throws CONException {
        try {
            Document document = new Document();
            DbDocument pstDocument = new DbDocument(oid);
            document.setOID(oid);
            
            document.setNameDocument(pstDocument.getString(COL_NAME_DOCUMENT));
            document.setTypeKaryawan(pstDocument.getInt(COL_TYPE_KARYAWAN));
            document.setTypePengusaha(pstDocument.getInt(COL_TYPE_PENGUSAHA));
            document.setTypeProfesi(pstDocument.getInt(COL_TYPE_PROFESI));

            return document;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocument(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Document document) throws CONException {
        try {
            DbDocument pstDocument = new DbDocument(0);
            pstDocument.setString(COL_NAME_DOCUMENT, document.getNameDocument());
            pstDocument.setInt(COL_TYPE_KARYAWAN, document.getTypeKaryawan());
            pstDocument.setInt(COL_TYPE_PENGUSAHA, document.getTypePengusaha());
            pstDocument.setInt(COL_TYPE_PROFESI, document.getTypeProfesi());

            pstDocument.insert();
            document.setOID(pstDocument.getlong(COL_DOCUMENT_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocument(0), CONException.UNKNOWN);
        }
        return document.getOID();
    }

    public static long updateExc(Document document) throws CONException {
        try {
            if (document.getOID() != 0) {
                DbDocument pstDocument = new DbDocument(document.getOID());
                pstDocument.setString(COL_NAME_DOCUMENT, document.getNameDocument());
                pstDocument.setInt(COL_TYPE_KARYAWAN, document.getTypeKaryawan());
                pstDocument.setInt(COL_TYPE_PENGUSAHA, document.getTypePengusaha());
                pstDocument.setInt(COL_TYPE_PROFESI, document.getTypeProfesi());
                pstDocument.update();
                return document.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocument(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbDocument pstProperty = new DbDocument(oid);
            pstProperty.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocument(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_DOCUMENT;
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
                Document document = new Document();
                resultToObject(rs, document);
                lists.add(document);
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

    private static void resultToObject(ResultSet rs, Document document) {
        try {
            
            document.setOID(rs.getLong(DbDocument.colNames[DbDocument.COL_DOCUMENT_ID])); 
            document.setNameDocument(rs.getString(DbDocument.colNames[DbDocument.COL_NAME_DOCUMENT]));
            document.setTypeKaryawan(rs.getInt(DbDocument.colNames[DbDocument.COL_TYPE_KARYAWAN]));
            document.setTypePengusaha(rs.getInt(DbDocument.colNames[DbDocument.COL_TYPE_PENGUSAHA]));
            document.setTypeProfesi(rs.getInt(DbDocument.colNames[DbDocument.COL_TYPE_PROFESI]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long documentId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_DOCUMENT + " WHERE " +
                    DbDocument.colNames[DbDocument.COL_DOCUMENT_ID] + " = " + documentId;

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
            String sql = "SELECT COUNT(" + DbDocument.colNames[DbDocument.COL_DOCUMENT_ID] + ") FROM " + DB_DOCUMENT;
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
                    Document document = (Document) list.get(ls);
                    if (oid == document.getOID()) {
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
