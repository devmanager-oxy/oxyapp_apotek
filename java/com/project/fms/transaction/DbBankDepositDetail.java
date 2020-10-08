
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */
/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/
package com.project.fms.transaction;

/* package java */
import com.project.I_Project;
import com.project.fms.master.DbCoa;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.transaction.*;

public class DbBankDepositDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BANK_DEPOSIT_DETAIL = "bank_deposit_detail";
    public static final int COL_BANK_DEPOSIT_DETAIL_ID = 0;
    public static final int COL_BANK_DEPOSIT_ID = 1;
    public static final int COL_COA_ID = 2;
    public static final int COL_FOREIGN_CURRENCY_ID = 3;
    public static final int COL_FOREIGN_AMOUNT = 4;
    public static final int COL_BOOKED_RATE = 5;
    public static final int COL_MEMO = 6;
    public static final int COL_AMOUNT = 7;
    //eka    	
    public static final int COL_SEGMENT1_ID = 8;
    public static final int COL_SEGMENT2_ID = 9;
    public static final int COL_SEGMENT3_ID = 10;
    public static final int COL_SEGMENT4_ID = 11;
    public static final int COL_SEGMENT5_ID = 12;
    public static final int COL_SEGMENT6_ID = 13;
    public static final int COL_SEGMENT7_ID = 14;
    public static final int COL_SEGMENT8_ID = 15;
    public static final int COL_SEGMENT9_ID = 16;
    public static final int COL_SEGMENT10_ID = 17;
    public static final int COL_SEGMENT11_ID = 18;
    public static final int COL_SEGMENT12_ID = 19;
    public static final int COL_SEGMENT13_ID = 20;
    public static final int COL_SEGMENT14_ID = 21;
    public static final int COL_SEGMENT15_ID = 22;
    public static final int COL_DEPARTMENT_ID = 23;
    public static final int COL_FOREIGN_CREDIT_AMOUNT = 24;
    public static final int COL_CREDIT_AMOUNT = 25;
    
    
    public static final String[] colNames = {
        "bank_deposit_detail_id",
        "bank_deposit_id",
        "coa_id",
        "foreign_currency_id",
        "foreign_amount",
        "booked_rate",
        "memo",
        "amount",
        "segment1_id",
        "segment2_id",
        "segment3_id",
        "segment4_id",
        "segment5_id",
        "segment6_id",
        "segment7_id",
        "segment8_id",
        "segment9_id",
        "segment10_id",
        "segment11_id",
        "segment12_id",
        "segment13_id",
        "segment14_id",
        "segment15_id",
        "department_id",
        "foreign_credit_amount",
        "credit_amount"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_FLOAT,
        //segment
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public DbBankDepositDetail() {
    }

    public DbBankDepositDetail(int i) throws CONException {
        super(new DbBankDepositDetail());
    }

    public DbBankDepositDetail(String sOid) throws CONException {
        super(new DbBankDepositDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankDepositDetail(long lOid) throws CONException {
        super(new DbBankDepositDetail(0));
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
        return DB_BANK_DEPOSIT_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankDepositDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BankDepositDetail bankdepositdetail = fetchExc(ent.getOID());
        ent = (Entity) bankdepositdetail;
        return bankdepositdetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BankDepositDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BankDepositDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BankDepositDetail fetchExc(long oid) throws CONException {
        try {
            BankDepositDetail bankdepositdetail = new BankDepositDetail();
            DbBankDepositDetail pstBankDepositDetail = new DbBankDepositDetail(oid);
            bankdepositdetail.setOID(oid);

            bankdepositdetail.setBankDepositId(pstBankDepositDetail.getlong(COL_BANK_DEPOSIT_ID));
            bankdepositdetail.setCoaId(pstBankDepositDetail.getlong(COL_COA_ID));
            bankdepositdetail.setForeignCurrencyId(pstBankDepositDetail.getlong(COL_FOREIGN_CURRENCY_ID));
            bankdepositdetail.setForeignAmount(pstBankDepositDetail.getdouble(COL_FOREIGN_AMOUNT));
            bankdepositdetail.setBookedRate(pstBankDepositDetail.getdouble(COL_BOOKED_RATE));
            bankdepositdetail.setMemo(pstBankDepositDetail.getString(COL_MEMO));
            bankdepositdetail.setAmount(pstBankDepositDetail.getdouble(COL_AMOUNT));

            bankdepositdetail.setSegment1Id(pstBankDepositDetail.getlong(COL_SEGMENT1_ID));
            bankdepositdetail.setSegment2Id(pstBankDepositDetail.getlong(COL_SEGMENT2_ID));
            bankdepositdetail.setSegment3Id(pstBankDepositDetail.getlong(COL_SEGMENT3_ID));
            bankdepositdetail.setSegment4Id(pstBankDepositDetail.getlong(COL_SEGMENT4_ID));
            bankdepositdetail.setSegment5Id(pstBankDepositDetail.getlong(COL_SEGMENT5_ID));
            bankdepositdetail.setSegment6Id(pstBankDepositDetail.getlong(COL_SEGMENT6_ID));
            bankdepositdetail.setSegment7Id(pstBankDepositDetail.getlong(COL_SEGMENT7_ID));
            bankdepositdetail.setSegment8Id(pstBankDepositDetail.getlong(COL_SEGMENT8_ID));
            bankdepositdetail.setSegment9Id(pstBankDepositDetail.getlong(COL_SEGMENT9_ID));
            bankdepositdetail.setSegment10Id(pstBankDepositDetail.getlong(COL_SEGMENT10_ID));
            bankdepositdetail.setSegment11Id(pstBankDepositDetail.getlong(COL_SEGMENT11_ID));
            bankdepositdetail.setSegment12Id(pstBankDepositDetail.getlong(COL_SEGMENT12_ID));
            bankdepositdetail.setSegment13Id(pstBankDepositDetail.getlong(COL_SEGMENT13_ID));
            bankdepositdetail.setSegment14Id(pstBankDepositDetail.getlong(COL_SEGMENT14_ID));
            bankdepositdetail.setSegment15Id(pstBankDepositDetail.getlong(COL_SEGMENT15_ID));
            bankdepositdetail.setDepartmentId(pstBankDepositDetail.getlong(COL_DEPARTMENT_ID));
            
            bankdepositdetail.setForeignCreditAmount(pstBankDepositDetail.getdouble(COL_FOREIGN_CREDIT_AMOUNT));
            bankdepositdetail.setCreditAmount(pstBankDepositDetail.getdouble(COL_CREDIT_AMOUNT));

            return bankdepositdetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankDepositDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BankDepositDetail bankdepositdetail) throws CONException {
        try {
            DbBankDepositDetail pstBankDepositDetail = new DbBankDepositDetail(0);

            pstBankDepositDetail.setLong(COL_BANK_DEPOSIT_ID, bankdepositdetail.getBankDepositId());
            pstBankDepositDetail.setLong(COL_COA_ID, bankdepositdetail.getCoaId());
            pstBankDepositDetail.setLong(COL_FOREIGN_CURRENCY_ID, bankdepositdetail.getForeignCurrencyId());
            pstBankDepositDetail.setDouble(COL_FOREIGN_AMOUNT, bankdepositdetail.getForeignAmount());
            pstBankDepositDetail.setDouble(COL_BOOKED_RATE, bankdepositdetail.getBookedRate());
            pstBankDepositDetail.setString(COL_MEMO, bankdepositdetail.getMemo());
            pstBankDepositDetail.setDouble(COL_AMOUNT, bankdepositdetail.getAmount());

            pstBankDepositDetail.setLong(COL_SEGMENT1_ID, bankdepositdetail.getSegment1Id());
            pstBankDepositDetail.setLong(COL_SEGMENT2_ID, bankdepositdetail.getSegment2Id());
            pstBankDepositDetail.setLong(COL_SEGMENT3_ID, bankdepositdetail.getSegment3Id());
            pstBankDepositDetail.setLong(COL_SEGMENT4_ID, bankdepositdetail.getSegment4Id());
            pstBankDepositDetail.setLong(COL_SEGMENT5_ID, bankdepositdetail.getSegment5Id());
            pstBankDepositDetail.setLong(COL_SEGMENT6_ID, bankdepositdetail.getSegment6Id());
            pstBankDepositDetail.setLong(COL_SEGMENT7_ID, bankdepositdetail.getSegment7Id());
            pstBankDepositDetail.setLong(COL_SEGMENT8_ID, bankdepositdetail.getSegment8Id());
            pstBankDepositDetail.setLong(COL_SEGMENT9_ID, bankdepositdetail.getSegment9Id());
            pstBankDepositDetail.setLong(COL_SEGMENT10_ID, bankdepositdetail.getSegment10Id());
            pstBankDepositDetail.setLong(COL_SEGMENT11_ID, bankdepositdetail.getSegment11Id());
            pstBankDepositDetail.setLong(COL_SEGMENT12_ID, bankdepositdetail.getSegment12Id());
            pstBankDepositDetail.setLong(COL_SEGMENT13_ID, bankdepositdetail.getSegment13Id());
            pstBankDepositDetail.setLong(COL_SEGMENT14_ID, bankdepositdetail.getSegment14Id());
            pstBankDepositDetail.setLong(COL_SEGMENT15_ID, bankdepositdetail.getSegment15Id());
            pstBankDepositDetail.setLong(COL_DEPARTMENT_ID, bankdepositdetail.getDepartmentId());
            pstBankDepositDetail.setDouble(COL_FOREIGN_CREDIT_AMOUNT, bankdepositdetail.getForeignCreditAmount());
            pstBankDepositDetail.setDouble(COL_CREDIT_AMOUNT, bankdepositdetail.getCreditAmount());

            pstBankDepositDetail.insert();
            bankdepositdetail.setOID(pstBankDepositDetail.getlong(COL_BANK_DEPOSIT_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankDepositDetail(0), CONException.UNKNOWN);
        }
        return bankdepositdetail.getOID();
    }

    public static long updateExc(BankDepositDetail bankdepositdetail) throws CONException {
        try {
            if (bankdepositdetail.getOID() != 0) {
                DbBankDepositDetail pstBankDepositDetail = new DbBankDepositDetail(bankdepositdetail.getOID());

                pstBankDepositDetail.setLong(COL_BANK_DEPOSIT_ID, bankdepositdetail.getBankDepositId());
                pstBankDepositDetail.setLong(COL_COA_ID, bankdepositdetail.getCoaId());
                pstBankDepositDetail.setLong(COL_FOREIGN_CURRENCY_ID, bankdepositdetail.getForeignCurrencyId());
                pstBankDepositDetail.setDouble(COL_FOREIGN_AMOUNT, bankdepositdetail.getForeignAmount());
                pstBankDepositDetail.setDouble(COL_BOOKED_RATE, bankdepositdetail.getBookedRate());
                pstBankDepositDetail.setString(COL_MEMO, bankdepositdetail.getMemo());
                pstBankDepositDetail.setDouble(COL_AMOUNT, bankdepositdetail.getAmount());

                pstBankDepositDetail.setLong(COL_SEGMENT1_ID, bankdepositdetail.getSegment1Id());
                pstBankDepositDetail.setLong(COL_SEGMENT2_ID, bankdepositdetail.getSegment2Id());
                pstBankDepositDetail.setLong(COL_SEGMENT3_ID, bankdepositdetail.getSegment3Id());
                pstBankDepositDetail.setLong(COL_SEGMENT4_ID, bankdepositdetail.getSegment4Id());
                pstBankDepositDetail.setLong(COL_SEGMENT5_ID, bankdepositdetail.getSegment5Id());
                pstBankDepositDetail.setLong(COL_SEGMENT6_ID, bankdepositdetail.getSegment6Id());
                pstBankDepositDetail.setLong(COL_SEGMENT7_ID, bankdepositdetail.getSegment7Id());
                pstBankDepositDetail.setLong(COL_SEGMENT8_ID, bankdepositdetail.getSegment8Id());
                pstBankDepositDetail.setLong(COL_SEGMENT9_ID, bankdepositdetail.getSegment9Id());
                pstBankDepositDetail.setLong(COL_SEGMENT10_ID, bankdepositdetail.getSegment10Id());
                pstBankDepositDetail.setLong(COL_SEGMENT11_ID, bankdepositdetail.getSegment11Id());
                pstBankDepositDetail.setLong(COL_SEGMENT12_ID, bankdepositdetail.getSegment12Id());
                pstBankDepositDetail.setLong(COL_SEGMENT13_ID, bankdepositdetail.getSegment13Id());
                pstBankDepositDetail.setLong(COL_SEGMENT14_ID, bankdepositdetail.getSegment14Id());
                pstBankDepositDetail.setLong(COL_SEGMENT15_ID, bankdepositdetail.getSegment15Id());
                pstBankDepositDetail.setLong(COL_DEPARTMENT_ID, bankdepositdetail.getDepartmentId());                
                pstBankDepositDetail.setDouble(COL_FOREIGN_CREDIT_AMOUNT, bankdepositdetail.getForeignCreditAmount());
                pstBankDepositDetail.setDouble(COL_CREDIT_AMOUNT, bankdepositdetail.getCreditAmount());

                pstBankDepositDetail.update();
                return bankdepositdetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankDepositDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBankDepositDetail pstBankDepositDetail = new DbBankDepositDetail(oid);
            pstBankDepositDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankDepositDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANK_DEPOSIT_DETAIL;
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
                BankDepositDetail bankdepositdetail = new BankDepositDetail();
                resultToObject(rs, bankdepositdetail);
                lists.add(bankdepositdetail);
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

    private static void resultToObject(ResultSet rs, BankDepositDetail bankdepositdetail) {
        try {
            bankdepositdetail.setOID(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_DETAIL_ID]));
            bankdepositdetail.setBankDepositId(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID]));
            bankdepositdetail.setCoaId(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_COA_ID]));
            bankdepositdetail.setForeignCurrencyId(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_FOREIGN_CURRENCY_ID]));
            bankdepositdetail.setForeignAmount(rs.getDouble(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_FOREIGN_AMOUNT]));
            bankdepositdetail.setBookedRate(rs.getDouble(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BOOKED_RATE]));
            bankdepositdetail.setMemo(rs.getString(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_MEMO]));
            bankdepositdetail.setAmount(rs.getDouble(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_AMOUNT]));

            bankdepositdetail.setSegment1Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT1_ID]));
            bankdepositdetail.setSegment2Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT2_ID]));
            bankdepositdetail.setSegment3Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT3_ID]));
            bankdepositdetail.setSegment4Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT4_ID]));
            bankdepositdetail.setSegment5Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT5_ID]));
            bankdepositdetail.setSegment6Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT6_ID]));
            bankdepositdetail.setSegment7Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT7_ID]));
            bankdepositdetail.setSegment8Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT8_ID]));
            bankdepositdetail.setSegment9Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT9_ID]));
            bankdepositdetail.setSegment10Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT10_ID]));
            bankdepositdetail.setSegment11Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT11_ID]));
            bankdepositdetail.setSegment12Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT12_ID]));
            bankdepositdetail.setSegment13Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT13_ID]));
            bankdepositdetail.setSegment14Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT14_ID]));
            bankdepositdetail.setSegment15Id(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_SEGMENT15_ID]));
            bankdepositdetail.setDepartmentId(rs.getLong(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_DEPARTMENT_ID]));            
            bankdepositdetail.setForeignCreditAmount(rs.getDouble(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_FOREIGN_CREDIT_AMOUNT]));
            bankdepositdetail.setCreditAmount(rs.getDouble(DbBankDepositDetail.colNames[DbBankDepositDetail.COL_CREDIT_AMOUNT]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long bankDepositDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANK_DEPOSIT_DETAIL + " WHERE " +
                    DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_DETAIL_ID] + " = " + bankDepositDetailId;

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
            String sql = "SELECT COUNT(" + DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_DETAIL_ID] + ") FROM " + DB_BANK_DEPOSIT_DETAIL;
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
                    BankDepositDetail bankdepositdetail = (BankDepositDetail) list.get(ls);
                    if (oid == bankdepositdetail.getOID()) {
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

    public static void saveAllDetail(BankDeposit bankDeposit, Vector listBankDepositDetail) {
        if (listBankDepositDetail != null && listBankDepositDetail.size() > 0) {

            double amountDebet = 0;
            double amountCredit = 0;

            for (int i = 0; i < listBankDepositDetail.size(); i++) {
                
                BankDepositDetail crd = (BankDepositDetail) listBankDepositDetail.get(i);
                crd.setBankDepositId(bankDeposit.getOID());

                amountDebet = amountDebet + crd.getAmount();
                amountCredit = amountCredit + crd.getCreditAmount();

                try {
                    if (crd.getOID() == 0) {
                        DbBankDepositDetail.insertExc(crd);
                    } else {
                        DbBankDepositDetail.updateExc(crd);
                    }
                } catch (Exception e) { System.out.println("[exception] " + e.toString()); }
            }

            try {                
                double tot = 0;
                try{
                    tot = amountDebet-amountCredit;
                }catch(Exception e){}
                
                bankDeposit.setAmount(tot);
                DbBankDeposit.updateExc(bankDeposit);
                
            }catch(Exception e){}
            
            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM_BANK, bankDeposit.getOID(), bankDeposit.getAmount(), bankDeposit.getOperatorId());            
            
        }
    }

    public static void deleteAllDetail(long bankDepositId) {

        if (bankDepositId != 0) {

            CONResultSet dbrs = null;

            try {

                String sql = "DELETE FROM " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL + " WHERE " +
                        DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID] + " = " + bankDepositId;

                CONHandler.execUpdate(sql);

            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }
    
    public static Vector getCodeCoa(long coaId) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT " + DbCoa.colNames[DbCoa.COL_CODE] + "," + DbCoa.colNames[DbCoa.COL_NAME] + " FROM " + DbCoa.DB_COA + " WHERE " +
                    DbCoa.colNames[DbCoa.COL_COA_ID] + "=" + coaId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Vector result = new Vector();
                String code = rs.getString(DbCoa.colNames[DbCoa.COL_CODE]);
                String name = rs.getString(DbCoa.colNames[DbCoa.COL_NAME]);

                result.add("" + code);
                result.add("" + name);

                return result;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;

    }
    
}
