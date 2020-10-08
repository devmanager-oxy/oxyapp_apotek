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
public class DbDocumentSales extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_DOCUMENT_SALES = "prop_document_sales";
    
    public static final int COL_DOCUMENT_SALES_ID = 0;
    public static final int COL_DOCUMENT_ID = 1; 
    public static final int COL_SALES_DATA_ID = 2; 
    public static final int COL_TYPE_KARYAWAN = 3;
    public static final int COL_TYPE_PENGUSAHA = 4;
    public static final int COL_TYPE_PROFESI = 5;
    
    public static final String[] colNames = {
        "document_sales_id",
        "document_id",
        "sales_data_id",
        "type_karyawan",
        "type_pengusaha",
        "type_profesi"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,       
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };
    
    public DbDocumentSales() {
    }

    public DbDocumentSales(int i) throws CONException {
        super(new DbDocumentSales());
    }

    public DbDocumentSales(String sOid) throws CONException {
        super(new DbDocumentSales(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbDocumentSales(long lOid) throws CONException {
        super(new DbDocumentSales(0));
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
        return DB_DOCUMENT_SALES;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbDocumentSales().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DocumentSales documentSales = fetchExc(ent.getOID());
        ent = (Entity) documentSales;
        return documentSales.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DocumentSales) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DocumentSales) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DocumentSales fetchExc(long oid) throws CONException {
        try {
            DocumentSales documentSales = new DocumentSales();
            DbDocumentSales pstDocument = new DbDocumentSales(oid);
            documentSales.setOID(oid);
            
            documentSales.setDocumentId(pstDocument.getlong(COL_DOCUMENT_ID));
            documentSales.setSalesDataId(pstDocument.getlong(COL_SALES_DATA_ID));
            documentSales.setTypeKaryawan(pstDocument.getInt(COL_TYPE_KARYAWAN));
            documentSales.setTypePengusaha(pstDocument.getInt(COL_TYPE_PENGUSAHA));
            documentSales.setTypeProfesi(pstDocument.getInt(COL_TYPE_PROFESI));

            return documentSales;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocumentSales(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(DocumentSales documentSales) throws CONException {
        try {
            DbDocumentSales pstDocument = new DbDocumentSales(0);
            pstDocument.setLong(COL_DOCUMENT_ID, documentSales.getDocumentId());
            pstDocument.setLong(COL_SALES_DATA_ID, documentSales.getSalesDataId());
            pstDocument.setInt(COL_TYPE_KARYAWAN, documentSales.getTypeKaryawan());
            pstDocument.setInt(COL_TYPE_PENGUSAHA, documentSales.getTypePengusaha());
            pstDocument.setInt(COL_TYPE_PROFESI, documentSales.getTypeProfesi());

            pstDocument.insert();
            documentSales.setOID(pstDocument.getlong(COL_DOCUMENT_SALES_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocumentSales(0), CONException.UNKNOWN);
        }
        return documentSales.getOID();
    }

    public static long updateExc(DocumentSales documentSales) throws CONException {
        try {
            if (documentSales.getOID() != 0) {
                DbDocumentSales pstDocument = new DbDocumentSales(documentSales.getOID());
                
                pstDocument.setLong(COL_DOCUMENT_ID, documentSales.getDocumentId());
                pstDocument.setLong(COL_SALES_DATA_ID, documentSales.getSalesDataId());
                pstDocument.setInt(COL_TYPE_KARYAWAN, documentSales.getTypeKaryawan());
                pstDocument.setInt(COL_TYPE_PENGUSAHA, documentSales.getTypePengusaha());
                pstDocument.setInt(COL_TYPE_PROFESI, documentSales.getTypeProfesi());
                
                pstDocument.update();
                return documentSales.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocumentSales(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbDocumentSales pstProperty = new DbDocumentSales(oid);
            pstProperty.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDocumentSales(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_DOCUMENT_SALES;
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
                DocumentSales documentSales = new DocumentSales();
                resultToObject(rs, documentSales);
                lists.add(documentSales);
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

    private static void resultToObject(ResultSet rs, DocumentSales documentSales) {
        try {
            
            documentSales.setOID(rs.getLong(DbDocumentSales.colNames[DbDocumentSales.COL_DOCUMENT_SALES_ID])); 
            documentSales.setDocumentId(rs.getLong(DbDocumentSales.colNames[DbDocumentSales.COL_DOCUMENT_ID]));
            documentSales.setSalesDataId(rs.getLong(DbDocumentSales.colNames[DbDocumentSales.COL_SALES_DATA_ID]));
            documentSales.setTypeKaryawan(rs.getInt(DbDocumentSales.colNames[DbDocumentSales.COL_TYPE_KARYAWAN]));
            documentSales.setTypePengusaha(rs.getInt(DbDocumentSales.colNames[DbDocumentSales.COL_TYPE_PENGUSAHA]));
            documentSales.setTypeProfesi(rs.getInt(DbDocumentSales.colNames[DbDocumentSales.COL_TYPE_PROFESI]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long documentSalesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_DOCUMENT_SALES + " WHERE " +
                    DbDocumentSales.colNames[DbDocumentSales.COL_DOCUMENT_ID] + " = " + documentSalesId;

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
            String sql = "SELECT COUNT(" + DbDocumentSales.colNames[DbDocumentSales.COL_DOCUMENT_SALES_ID] + ") FROM " + DB_DOCUMENT_SALES;
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
                    DocumentSales documentSales = (DocumentSales) list.get(ls);
                    if (oid == documentSales.getOID()) {
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
    
    public static void deleteList(long salesDataId){
        CONResultSet dbrs = null;        
        try {
            
            String sql = "DELETE FROM " + DB_DOCUMENT_SALES+" where "+DbDocumentSales.colNames[DbDocumentSales.COL_SALES_DATA_ID]+" = "+salesDataId;
            int i = CONHandler.execUpdate(sql);            
            
        }catch(Exception e){        
        }finally {
            CONResultSet.close(dbrs);
        }   
    }
}
