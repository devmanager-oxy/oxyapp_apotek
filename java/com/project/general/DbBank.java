package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

public class DbBank extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BANK = "bank";
    public static final int COL_BANK_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_ADRESS = 2;
    public static final int COL_DEFAULT_BUNGA = 3;
    public static final int COL_COA_AR_ID = 4;
    public static final int COL_COA_DEBIT_CARD_ID = 5;
    public static final String[] colNames = {
        "bank_id",
        "name",
        "adress",
        "default_bunga",
        "coa_ar_id",
        "coa_debit_card_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbBank() {
    }

    public DbBank(int i) throws CONException {
        super(new DbBank());
    }

    public DbBank(String sOid) throws CONException {
        super(new DbBank(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBank(long lOid) throws CONException {
        super(new DbBank(0));
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
        return DB_BANK;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBank().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Bank bank = fetchExc(ent.getOID());
        ent = (Entity) bank;
        return bank.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Bank) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Bank) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Bank fetchExc(long oid) throws CONException {
        try {
            Bank bank = new Bank();
            DbBank pstBank = new DbBank(oid);
            bank.setOID(oid);

            bank.setName(pstBank.getString(COL_NAME));
            bank.setAdress(pstBank.getString(COL_ADRESS));
            bank.setDefaultBunga(pstBank.getdouble(COL_DEFAULT_BUNGA));
            bank.setCoaARId(pstBank.getlong(COL_COA_AR_ID));
            bank.setCoaDebitCardId(pstBank.getlong(COL_COA_DEBIT_CARD_ID));

            return bank;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBank(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Bank bank) throws CONException {
        try {
            DbBank pstBank = new DbBank(0);

            pstBank.setString(COL_NAME, bank.getName());
            pstBank.setString(COL_ADRESS, bank.getAdress());
            pstBank.setDouble(COL_DEFAULT_BUNGA, bank.getDefaultBunga());
            pstBank.setLong(COL_COA_AR_ID, bank.getCoaARId());
            pstBank.setLong(COL_COA_DEBIT_CARD_ID, bank.getCoaDebitCardId());

            pstBank.insert();
            bank.setOID(pstBank.getlong(COL_BANK_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBank(0), CONException.UNKNOWN);
        }
        return bank.getOID();
    }

    public static long updateExc(Bank bank) throws CONException {
        try {
            if (bank.getOID() != 0) {
                DbBank pstBank = new DbBank(bank.getOID());

                pstBank.setString(COL_NAME, bank.getName());
                pstBank.setString(COL_ADRESS, bank.getAdress());
                pstBank.setDouble(COL_DEFAULT_BUNGA, bank.getDefaultBunga());
                pstBank.setLong(COL_COA_AR_ID, bank.getCoaARId());
                pstBank.setLong(COL_COA_DEBIT_CARD_ID, bank.getCoaDebitCardId());

                pstBank.update();
                return bank.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBank(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBank pstBank = new DbBank(oid);
            pstBank.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBank(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANK;
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
                Bank bank = new Bank();
                resultToObject(rs, bank);
                lists.add(bank);
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

    private static void resultToObject(ResultSet rs, Bank bank) {
        try {
            bank.setOID(rs.getLong(DbBank.colNames[DbBank.COL_BANK_ID]));
            bank.setName(rs.getString(DbBank.colNames[DbBank.COL_NAME]));
            bank.setAdress(rs.getString(DbBank.colNames[DbBank.COL_ADRESS]));
            bank.setDefaultBunga(rs.getDouble(DbBank.colNames[DbBank.COL_DEFAULT_BUNGA]));
            bank.setCoaARId(rs.getLong(DbBank.colNames[DbBank.COL_COA_AR_ID]));
            bank.setCoaDebitCardId(rs.getLong(DbBank.colNames[DbBank.COL_COA_DEBIT_CARD_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long bankId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANK + " WHERE " +
                    DbBank.colNames[DbBank.COL_BANK_ID] + " = " + bankId;

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
            String sql = "SELECT COUNT(" + DbBank.colNames[DbBank.COL_BANK_ID] + ") FROM " + DB_BANK;
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
                    Bank bank = (Bank) list.get(ls);
                    if (oid == bank.getOID()) {
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
