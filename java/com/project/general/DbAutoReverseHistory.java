/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class DbAutoReverseHistory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_AUTO_REVERSE_HISTORY = "auto_reverse_history";
    public static final int COL_AUTO_REVERSE_HISTORY_ID = 0;
    public static final int COL_GL_ID = 1;
    public static final int COL_GL_DATE = 2;
    public static final int COL_EXCHANGERATE_ID = 3;
    public static final int COL_COA_ID = 4;
    
    public static final String[] fieldNames = {
        "auto_reverse_history_id",
        "gl_id",
        "gl_date",
        "exchangerate_id",
        "coa_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG
    };
    
    public DbAutoReverseHistory() {
        
    }

    public DbAutoReverseHistory(long oid) throws CONException {
        super(new DbAutoReverseHistory(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(oid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbAutoReverseHistory(int i) throws CONException {
        super(new DbAutoReverseHistory());
    }
    
    public DbAutoReverseHistory(String oid) throws CONException {
        super(new DbAutoReverseHistory(0));
        if (!locate(oid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return DB_AUTO_REVERSE_HISTORY;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return DbAutoReverseHistory.class.getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        AutoReverseHistory arh = fetchExc(ent.getOID());
        ent = (Entity) arh;
        return arh.getOID();
    }
    
    public long insertExc(Entity ent) throws Exception {
        return insertExc((AutoReverseHistory)ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((AutoReverseHistory)ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static AutoReverseHistory fetchExc(long oid) throws CONException {
        try {
            AutoReverseHistory obj = new AutoReverseHistory();
            DbAutoReverseHistory pst = new DbAutoReverseHistory(oid);
            
            obj.setOID(oid);
            obj.setGlId(pst.getlong(COL_GL_ID));
            obj.setGlDate(pst.getDate(COL_GL_DATE));
            obj.setExchangeRateId(pst.getlong(COL_EXCHANGERATE_ID));
            obj.setCoaId(pst.getlong(COL_COA_ID));
            
            return obj;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAutoReverseHistory(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(AutoReverseHistory obj) throws CONException {
        try {
            DbAutoReverseHistory pst = new DbAutoReverseHistory(0);
            
            pst.setLong(COL_GL_ID, obj.getGlId());
            pst.setDate(COL_GL_DATE, obj.getGlDate());
            pst.setLong(COL_EXCHANGERATE_ID, obj.getExchangeRateId());
            pst.setLong(COL_COA_ID, obj.getCoaId());
            
            pst.insert();
            obj.setOID(pst.getlong(COL_AUTO_REVERSE_HISTORY_ID));
        } catch(CONException dbe) {
            throw dbe;
        } catch(Exception e) {
            throw new CONException(new DbAutoReverseHistory(0), CONException.UNKNOWN);
        }
        return obj.getOID();
    }

    public static long updateExc(AutoReverseHistory obj) throws CONException {
        try {
            if(obj.getOID() != 0) {
                DbAutoReverseHistory pst = new DbAutoReverseHistory(obj.getOID());
                
                pst.setLong(COL_GL_ID, obj.getGlId());
                pst.setDate(COL_GL_DATE, obj.getGlDate());
                pst.setLong(COL_EXCHANGERATE_ID, obj.getExchangeRateId());
                pst.setLong(COL_COA_ID, obj.getCoaId());
                
                pst.update();
                return obj.getOID();
            }
        } catch(CONException dbe) {
            throw dbe;
        } catch(Exception e) {
            throw new CONException(new DbAutoReverseHistory(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbAutoReverseHistory pst = new DbAutoReverseHistory(oid);
            pst.delete();
        } catch(CONException dbe) {
            throw dbe;
        } catch(Exception e) {
            throw new CONException(new DbAutoReverseHistory(0), CONException.UNKNOWN);
        }
        return oid;
    }
    
    public static void resultToObject(ResultSet rs, AutoReverseHistory obj) {
        try {
            obj.setOID(rs.getLong(fieldNames[COL_AUTO_REVERSE_HISTORY_ID]));
            obj.setGlId(rs.getLong(fieldNames[COL_GL_ID]));
            obj.setGlDate(rs.getDate(fieldNames[COL_GL_DATE]));
            obj.setExchangeRateId(rs.getLong(fieldNames[COL_EXCHANGERATE_ID]));
            obj.setCoaId(rs.getLong(fieldNames[COL_COA_ID]));
        } catch(Exception e) {
            System.out.println("Exception: " + e.toString());
        }
    }
    
    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_AUTO_REVERSE_HISTORY;
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
                AutoReverseHistory obj = new AutoReverseHistory();
                resultToObject(rs, obj);
                lists.add(obj);
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
    
    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        int count = 0;
        
        try {
            String sql = "SELECT COUNT(" + fieldNames[COL_AUTO_REVERSE_HISTORY_ID] + ") FROM " + DB_AUTO_REVERSE_HISTORY;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            
        } catch (Exception e) {
            System.out.println("Exception on getCount : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return count;
    }
    
    public static AutoReverseHistory getLatsHistory(long idCoa) {
        CONResultSet dbrs = null;
        AutoReverseHistory obj = new AutoReverseHistory();
        
        try {
            String sql = "SELECT arh.* FROM " + DB_AUTO_REVERSE_HISTORY + " arh " +
                    " INNER JOIN gl ON arh.gl_id = gl.gl_id " +
                    " WHERE arh.coa_id = " + idCoa +
                    " ORDER BY gl_date, gl.journal_counter DESC LIMIT 1";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                resultToObject(rs, obj);
            }

            rs.close();
            
        } catch(Exception e) {
            System.out.println("Exception on getLatsHistory : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return obj;
    }

}
