package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class DbBankAccount extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String TBL_BANK_ACCOUNT = "bank_account";
    public static final int COL_BANK_ACCOUNT_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_TYPE = 2;
    public static final int COL_ACC_NUMBER = 3;
    public static final int COL_BANK_NAME = 4;
    public static final int COL_STATUS = 5;
    public static final int COL_ACCOUNT_CODE = 6;
    public static final int COL_COA_ID = 7;
    public static final int COL_COMPANY_ID = 8;
    public static final int COL_CURRENCY_ID = 9;
    public static final String[] colNames = {
        "bank_account_id",
        "name",
        "type",
        "acc_number",
        "bank_name",
        "status",
        "account_code",
        "coa_id",
        "company_id",
        "currency_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbBankAccount() {
    }

    public DbBankAccount(int i) throws CONException {
        super(new DbBankAccount());
    }

    public DbBankAccount(String sOid) throws CONException {
        super(new DbBankAccount(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankAccount(long lOid) throws CONException {
        super(new DbBankAccount(0));
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
        return TBL_BANK_ACCOUNT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankAccount().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BankAccount bankaccount = fetchExc(ent.getOID());
        ent = (Entity) bankaccount;
        return bankaccount.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BankAccount) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BankAccount) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BankAccount fetchExc(long oid) throws CONException {
        try {
            BankAccount bankaccount = new BankAccount();
            DbBankAccount pstBankAccount = new DbBankAccount(oid);
            bankaccount.setOID(oid);

            bankaccount.setName(pstBankAccount.getString(COL_NAME));
            bankaccount.setType(pstBankAccount.getInt(COL_TYPE));
            bankaccount.setAccNumber(pstBankAccount.getString(COL_ACC_NUMBER));
            bankaccount.setBankName(pstBankAccount.getString(COL_BANK_NAME));
            bankaccount.setStatus(pstBankAccount.getInt(COL_STATUS));
            bankaccount.setAccountCode(pstBankAccount.getString(COL_ACCOUNT_CODE));
            bankaccount.setCoaId(pstBankAccount.getlong(COL_COA_ID));
            bankaccount.setCompanyId(pstBankAccount.getlong(COL_COMPANY_ID));
            bankaccount.setCurrencyId(pstBankAccount.getlong(COL_CURRENCY_ID));

            return bankaccount;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankAccount(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BankAccount bankaccount) throws CONException {
        try {
            DbBankAccount pstBankAccount = new DbBankAccount(0);

            pstBankAccount.setString(COL_NAME, bankaccount.getName());
            pstBankAccount.setInt(COL_TYPE, bankaccount.getType());
            pstBankAccount.setString(COL_ACC_NUMBER, bankaccount.getAccNumber());
            pstBankAccount.setString(COL_BANK_NAME, bankaccount.getBankName());
            pstBankAccount.setInt(COL_STATUS, bankaccount.getStatus());
            pstBankAccount.setString(COL_ACCOUNT_CODE, bankaccount.getAccountCode());
            pstBankAccount.setLong(COL_COA_ID, bankaccount.getCoaId());
            pstBankAccount.setLong(COL_COMPANY_ID, bankaccount.getCompanyId());
            pstBankAccount.setLong(COL_CURRENCY_ID, bankaccount.getCurrencyId());

            pstBankAccount.insert();
            bankaccount.setOID(pstBankAccount.getlong(COL_BANK_ACCOUNT_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankAccount(0), CONException.UNKNOWN);
        }
        return bankaccount.getOID();
    }

    public static long updateExc(BankAccount bankaccount) throws CONException {
        try {
            if (bankaccount.getOID() != 0) {
                DbBankAccount pstBankAccount = new DbBankAccount(bankaccount.getOID());

                pstBankAccount.setString(COL_NAME, bankaccount.getName());
                pstBankAccount.setInt(COL_TYPE, bankaccount.getType());
                pstBankAccount.setString(COL_ACC_NUMBER, bankaccount.getAccNumber());
                pstBankAccount.setString(COL_BANK_NAME, bankaccount.getBankName());
                pstBankAccount.setInt(COL_STATUS, bankaccount.getStatus());
                pstBankAccount.setString(COL_ACCOUNT_CODE, bankaccount.getAccountCode());
                pstBankAccount.setLong(COL_COA_ID, bankaccount.getCoaId());
                pstBankAccount.setLong(COL_COMPANY_ID, bankaccount.getCompanyId());
                pstBankAccount.setLong(COL_CURRENCY_ID, bankaccount.getCurrencyId());

                pstBankAccount.update();
                return bankaccount.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankAccount(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBankAccount pstBankAccount = new DbBankAccount(oid);
            pstBankAccount.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankAccount(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_BANK_ACCOUNT;
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
                BankAccount bankaccount = new BankAccount();
                resultToObject(rs, bankaccount);
                lists.add(bankaccount);
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

    public static void resultToObject(ResultSet rs, BankAccount bankaccount) {
        try {
            bankaccount.setOID(rs.getLong(DbBankAccount.colNames[DbBankAccount.COL_BANK_ACCOUNT_ID]));
            bankaccount.setName(rs.getString(DbBankAccount.colNames[DbBankAccount.COL_NAME]));
            bankaccount.setType(rs.getInt(DbBankAccount.colNames[DbBankAccount.COL_TYPE]));
            bankaccount.setAccNumber(rs.getString(DbBankAccount.colNames[DbBankAccount.COL_ACC_NUMBER]));
            bankaccount.setBankName(rs.getString(DbBankAccount.colNames[DbBankAccount.COL_BANK_NAME]));
            bankaccount.setStatus(rs.getInt(DbBankAccount.colNames[DbBankAccount.COL_STATUS]));
            bankaccount.setAccountCode(rs.getString(DbBankAccount.colNames[DbBankAccount.COL_ACCOUNT_CODE]));
            bankaccount.setCoaId(rs.getLong(DbBankAccount.colNames[DbBankAccount.COL_COA_ID]));
            bankaccount.setCompanyId(rs.getLong(DbBankAccount.colNames[DbBankAccount.COL_COMPANY_ID]));
            bankaccount.setCurrencyId(rs.getLong(DbBankAccount.colNames[DbBankAccount.COL_CURRENCY_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long bankAccountId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_BANK_ACCOUNT + " WHERE " +
                    DbBankAccount.colNames[DbBankAccount.COL_BANK_ACCOUNT_ID] + " = " + bankAccountId;

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
            String sql = "SELECT COUNT(" + DbBankAccount.colNames[DbBankAccount.COL_BANK_ACCOUNT_ID] + ") FROM " + TBL_BANK_ACCOUNT;
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
                    BankAccount bankaccount = (BankAccount) list.get(ls);
                    if (oid == bankaccount.getOID()) {
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
