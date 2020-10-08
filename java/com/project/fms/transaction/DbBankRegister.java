package com.project.fms.transaction;

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
 * @author gwawan
 */
public class DbBankRegister extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_BANK_REGISTER = "bank_register";
    public static final int COL_TRANS_ID = 0;
    public static final int COL_USER_ID = 1;
    public static final int COL_DOC_NUMBER = 2;
    public static final int COL_TRANS_DATE = 3;
    public static final int COL_CHECK_BG_NUMBER = 4;
    public static final int COL_NAME = 5;
    public static final int COL_DESCRIPTION = 6;
    public static final int COL_DEBET = 7;
    public static final int COL_CREDIT = 8;
    public static final int COL_STATUS = 9;
    
    public static final String[] fieldNames = {
        "trans_id",
        "user_id",
        "doc_number",
        "trans_date",
        "check_bg_number",
        "name",
        "description",
        "debet",
        "credit",
        "status"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT
    };
    
    public static final int BANK_REGISTER_DRAFT = 0;
    public static final int BANK_REGISTER_POSTED = 1;
    public static final String[] strBankRegisterStatus = {"Draft", "Posted"};
    
    public DbBankRegister() {
    }

    public DbBankRegister(int i) throws CONException {
        super(new DbBankRegister());
    }

    public DbBankRegister(String sOid) throws CONException {
        super(new DbBankRegister(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankRegister(long lOid) throws CONException {
        super(new DbBankRegister(0));
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
        return fieldNames.length;
    }

    public String getTableName() {
        return DB_BANK_REGISTER;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankRegister().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public long updateExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public long deleteExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public long insertExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public static long insertExc(BankRegister bankRegister) throws CONException {
        try {
            DbBankRegister db = new DbBankRegister(0);
            
            db.setLong(COL_TRANS_ID, bankRegister.getOID());
            db.setLong(COL_USER_ID, bankRegister.getUserId());
            db.setString(COL_DOC_NUMBER, bankRegister.getDocNumber());
            db.setDate(COL_TRANS_DATE, bankRegister.getTransDate());
            db.setString(COL_CHECK_BG_NUMBER, bankRegister.getCheckBGNumber());
            db.setString(COL_NAME, bankRegister.getName());
            db.setString(COL_DESCRIPTION, bankRegister.getDescription());
            db.setDouble(COL_DEBET, bankRegister.getDebet());
            db.setDouble(COL_CREDIT, bankRegister.getCredit());
            db.setInt(COL_STATUS, bankRegister.getStatus());
            
            db.insert();
            bankRegister.setOID(db.getlong(COL_TRANS_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankRegister(0), CONException.UNKNOWN);
        }
        return bankRegister.getOID();
    }
    
    private static void resultToObject(ResultSet rs, BankRegister obj) {
        try {
            obj.setOID(rs.getLong(fieldNames[COL_TRANS_ID]));
            obj.setUserId(rs.getLong(fieldNames[COL_USER_ID]));
            obj.setDocNumber(rs.getString(fieldNames[COL_DOC_NUMBER]));
            obj.setTransDate(rs.getDate(fieldNames[COL_TRANS_DATE]));
            obj.setCheckBGNumber(rs.getString(fieldNames[COL_CHECK_BG_NUMBER]));
            obj.setName(rs.getString(fieldNames[COL_NAME]));
            obj.setDescription(rs.getString(fieldNames[COL_DESCRIPTION]));
            obj.setDebet(rs.getDouble(fieldNames[COL_DEBET]));
            obj.setCredit(rs.getDouble(fieldNames[COL_CREDIT]));
            obj.setStatus(rs.getInt(fieldNames[COL_STATUS]));
        } catch(Exception e) {
            System.out.println("[Exception] while resultToObject BankRegister "+e.toString());
        }
    }
    
    public static Vector list(long userId, long coaId, Date date) {
        Vector list = new Vector();
        CONResultSet crs = null;
        
        try {
            //1) delete list
            String sqlDel = "DELETE FROM "+DB_BANK_REGISTER+" WHERE "+fieldNames[COL_USER_ID]+"='"+userId+"'";
            CONHandler.execUpdate(sqlDel);
            
            //2) generate list from GL and insert into BankRegister
            Vector vGl = DbGlDetail.getBankRegister(userId, coaId, date);
            if(vGl != null && vGl.size() > 0) {
                for(int i=0; i<vGl.size(); i++) {
                    BankRegister bankRegister = (BankRegister)vGl.get(i);
                    long idx = insertExc(bankRegister);
                }
            }
            
            //3) generate list from BankReceive and insert into BankRegister
            Vector vCr = DbBankDeposit.getBankRegister(userId, coaId, date);
            if(vCr != null && vCr.size() > 0) {
                for(int i=0; i<vCr.size(); i++) {
                    BankRegister bankRegister = (BankRegister)vCr.get(i);
                    long idx = insertExc(bankRegister);
                }
            }
            
            //) generate list from BankRegister
            String sql = "SELECT * FROM "+DB_BANK_REGISTER+" WHERE "+fieldNames[COL_USER_ID]+"='"+userId+"' " +
                    " ORDER BY "+fieldNames[COL_TRANS_DATE]+" ASC,"+fieldNames[COL_DOC_NUMBER]+" ASC";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()) {
                BankRegister bankRegister = new BankRegister();
                resultToObject(rs, bankRegister);
                list.add(bankRegister);
            }
        } catch(Exception e) {
            System.out.println("[Exception] while list BankRegister "+e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return list;
    }

}
