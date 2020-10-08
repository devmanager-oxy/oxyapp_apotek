
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
import java.io.*;
import java.sql.*;
import java.util.*;

/* package qdep */
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.transaction.*;
import com.project.fms.activity.*;
import com.project.fms.master.BudgetRequest;
import com.project.fms.master.BudgetRequestDetail;
import com.project.fms.master.DbBudgetRequest;
import com.project.system.DbSystemProperty;

public class DbBanknonpoPaymentDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BANKNONPO_PAYMENT_DETAIL = "banknonpo_payment_detail";
    public static final int COL_BANKNONPO_PAYMENT_ID = 0;
    public static final int COL_BANKNONPO_PAYMENT_DETAIL_ID = 1;
    public static final int COL_COA_ID = 2;
    public static final int COL_AMOUNT = 3;
    public static final int COL_MEMO = 4;
    public static final int COL_FOREIGN_CURRENCY_ID = 5;
    public static final int COL_FOREIGN_AMOUNT = 6;
    public static final int COL_BOOKED_RATE = 7;
    public static final int COL_DEPARTMENT_ID = 8;
    //eka    	
    public static final int COL_SEGMENT1_ID = 9;
    public static final int COL_SEGMENT2_ID = 10;
    public static final int COL_SEGMENT3_ID = 11;
    public static final int COL_SEGMENT4_ID = 12;
    public static final int COL_SEGMENT5_ID = 13;
    public static final int COL_SEGMENT6_ID = 14;
    public static final int COL_SEGMENT7_ID = 15;
    public static final int COL_SEGMENT8_ID = 16;
    public static final int COL_SEGMENT9_ID = 17;
    public static final int COL_SEGMENT10_ID = 18;
    public static final int COL_SEGMENT11_ID = 19;
    public static final int COL_SEGMENT12_ID = 20;
    public static final int COL_SEGMENT13_ID = 21;
    public static final int COL_SEGMENT14_ID = 22;
    public static final int COL_SEGMENT15_ID = 23;
    public static final int COL_MODULE_ID = 24;
    
    public static final String[] colNames = {
        "banknonpo_payment_id",
        "banknonpo_payment_detail_id",
        "coa_id",
        "amount",
        "memo",
        "foreign_currency_id",
        "foreign_amount",
        "booked_rate",
        "department_id",
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
        "module_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
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
        TYPE_LONG
    };

    public DbBanknonpoPaymentDetail() {
    }

    public DbBanknonpoPaymentDetail(int i) throws CONException {
        super(new DbBanknonpoPaymentDetail());
    }

    public DbBanknonpoPaymentDetail(String sOid) throws CONException {
        super(new DbBanknonpoPaymentDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBanknonpoPaymentDetail(long lOid) throws CONException {
        super(new DbBanknonpoPaymentDetail(0));
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
        return DB_BANKNONPO_PAYMENT_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBanknonpoPaymentDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BanknonpoPaymentDetail banknonpopaymentdetail = fetchExc(ent.getOID());
        ent = (Entity) banknonpopaymentdetail;
        return banknonpopaymentdetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BanknonpoPaymentDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BanknonpoPaymentDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BanknonpoPaymentDetail fetchExc(long oid) throws CONException {
        try {
            BanknonpoPaymentDetail banknonpopaymentdetail = new BanknonpoPaymentDetail();
            DbBanknonpoPaymentDetail dbBanknonpoPaymentDetail = new DbBanknonpoPaymentDetail(oid);
            banknonpopaymentdetail.setOID(oid);

            banknonpopaymentdetail.setBanknonpoPaymentId(dbBanknonpoPaymentDetail.getlong(COL_BANKNONPO_PAYMENT_ID));
            banknonpopaymentdetail.setCoaId(dbBanknonpoPaymentDetail.getlong(COL_COA_ID));
            banknonpopaymentdetail.setAmount(dbBanknonpoPaymentDetail.getdouble(COL_AMOUNT));
            banknonpopaymentdetail.setMemo(dbBanknonpoPaymentDetail.getString(COL_MEMO));

            banknonpopaymentdetail.setForeignCurrencyId(dbBanknonpoPaymentDetail.getlong(COL_FOREIGN_CURRENCY_ID));
            banknonpopaymentdetail.setForeignAmount(dbBanknonpoPaymentDetail.getdouble(COL_FOREIGN_AMOUNT));
            banknonpopaymentdetail.setBookedRate(dbBanknonpoPaymentDetail.getdouble(COL_BOOKED_RATE));

            banknonpopaymentdetail.setDepartmentId(dbBanknonpoPaymentDetail.getlong(COL_DEPARTMENT_ID));

            banknonpopaymentdetail.setSegment1Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT1_ID));
            banknonpopaymentdetail.setSegment2Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT2_ID));
            banknonpopaymentdetail.setSegment3Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT3_ID));
            banknonpopaymentdetail.setSegment4Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT4_ID));
            banknonpopaymentdetail.setSegment5Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT5_ID));
            banknonpopaymentdetail.setSegment6Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT6_ID));
            banknonpopaymentdetail.setSegment7Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT7_ID));
            banknonpopaymentdetail.setSegment8Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT8_ID));
            banknonpopaymentdetail.setSegment9Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT9_ID));
            banknonpopaymentdetail.setSegment10Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT10_ID));
            banknonpopaymentdetail.setSegment11Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT11_ID));
            banknonpopaymentdetail.setSegment12Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT12_ID));
            banknonpopaymentdetail.setSegment13Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT13_ID));
            banknonpopaymentdetail.setSegment14Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT14_ID));
            banknonpopaymentdetail.setSegment15Id(dbBanknonpoPaymentDetail.getlong(COL_SEGMENT15_ID));

            banknonpopaymentdetail.setModuleId(dbBanknonpoPaymentDetail.getlong(COL_MODULE_ID));

            return banknonpopaymentdetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBanknonpoPaymentDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BanknonpoPaymentDetail banknonpopaymentdetail) throws CONException {
        try {
            DbBanknonpoPaymentDetail dbBanknonpoPaymentDetail = new DbBanknonpoPaymentDetail(0);

            dbBanknonpoPaymentDetail.setLong(COL_BANKNONPO_PAYMENT_ID, banknonpopaymentdetail.getBanknonpoPaymentId());
            dbBanknonpoPaymentDetail.setLong(COL_COA_ID, banknonpopaymentdetail.getCoaId());
            dbBanknonpoPaymentDetail.setDouble(COL_AMOUNT, banknonpopaymentdetail.getAmount());
            dbBanknonpoPaymentDetail.setString(COL_MEMO, banknonpopaymentdetail.getMemo());

            dbBanknonpoPaymentDetail.setLong(COL_FOREIGN_CURRENCY_ID, banknonpopaymentdetail.getForeignCurrencyId());
            dbBanknonpoPaymentDetail.setDouble(COL_FOREIGN_AMOUNT, banknonpopaymentdetail.getForeignAmount());
            dbBanknonpoPaymentDetail.setDouble(COL_BOOKED_RATE, banknonpopaymentdetail.getBookedRate());

            dbBanknonpoPaymentDetail.setLong(COL_DEPARTMENT_ID, banknonpopaymentdetail.getDepartmentId());

            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT1_ID, banknonpopaymentdetail.getSegment1Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT2_ID, banknonpopaymentdetail.getSegment2Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT3_ID, banknonpopaymentdetail.getSegment3Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT4_ID, banknonpopaymentdetail.getSegment4Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT5_ID, banknonpopaymentdetail.getSegment5Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT6_ID, banknonpopaymentdetail.getSegment6Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT7_ID, banknonpopaymentdetail.getSegment7Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT8_ID, banknonpopaymentdetail.getSegment8Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT9_ID, banknonpopaymentdetail.getSegment9Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT10_ID, banknonpopaymentdetail.getSegment10Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT11_ID, banknonpopaymentdetail.getSegment11Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT12_ID, banknonpopaymentdetail.getSegment12Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT13_ID, banknonpopaymentdetail.getSegment13Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT14_ID, banknonpopaymentdetail.getSegment14Id());
            dbBanknonpoPaymentDetail.setLong(COL_SEGMENT15_ID, banknonpopaymentdetail.getSegment15Id());
            dbBanknonpoPaymentDetail.setLong(COL_MODULE_ID, banknonpopaymentdetail.getModuleId());


            dbBanknonpoPaymentDetail.insert();
            banknonpopaymentdetail.setOID(dbBanknonpoPaymentDetail.getlong(COL_BANKNONPO_PAYMENT_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBanknonpoPaymentDetail(0), CONException.UNKNOWN);
        }
        return banknonpopaymentdetail.getOID();
    }

    public static long updateExc(BanknonpoPaymentDetail banknonpopaymentdetail) throws CONException {
        try {
            if (banknonpopaymentdetail.getOID() != 0) {
                DbBanknonpoPaymentDetail dbBanknonpoPaymentDetail = new DbBanknonpoPaymentDetail(banknonpopaymentdetail.getOID());

                dbBanknonpoPaymentDetail.setLong(COL_BANKNONPO_PAYMENT_ID, banknonpopaymentdetail.getBanknonpoPaymentId());
                dbBanknonpoPaymentDetail.setLong(COL_COA_ID, banknonpopaymentdetail.getCoaId());
                dbBanknonpoPaymentDetail.setDouble(COL_AMOUNT, banknonpopaymentdetail.getAmount());
                dbBanknonpoPaymentDetail.setString(COL_MEMO, banknonpopaymentdetail.getMemo());

                dbBanknonpoPaymentDetail.setLong(COL_FOREIGN_CURRENCY_ID, banknonpopaymentdetail.getForeignCurrencyId());
                dbBanknonpoPaymentDetail.setDouble(COL_FOREIGN_AMOUNT, banknonpopaymentdetail.getForeignAmount());
                dbBanknonpoPaymentDetail.setDouble(COL_BOOKED_RATE, banknonpopaymentdetail.getBookedRate());

                dbBanknonpoPaymentDetail.setLong(COL_DEPARTMENT_ID, banknonpopaymentdetail.getDepartmentId());

                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT1_ID, banknonpopaymentdetail.getSegment1Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT2_ID, banknonpopaymentdetail.getSegment2Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT3_ID, banknonpopaymentdetail.getSegment3Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT4_ID, banknonpopaymentdetail.getSegment4Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT5_ID, banknonpopaymentdetail.getSegment5Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT6_ID, banknonpopaymentdetail.getSegment6Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT7_ID, banknonpopaymentdetail.getSegment7Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT8_ID, banknonpopaymentdetail.getSegment8Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT9_ID, banknonpopaymentdetail.getSegment9Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT10_ID, banknonpopaymentdetail.getSegment10Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT11_ID, banknonpopaymentdetail.getSegment11Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT12_ID, banknonpopaymentdetail.getSegment12Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT13_ID, banknonpopaymentdetail.getSegment13Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT14_ID, banknonpopaymentdetail.getSegment14Id());
                dbBanknonpoPaymentDetail.setLong(COL_SEGMENT15_ID, banknonpopaymentdetail.getSegment15Id());
                dbBanknonpoPaymentDetail.setLong(COL_MODULE_ID, banknonpopaymentdetail.getModuleId());

                dbBanknonpoPaymentDetail.update();
                return banknonpopaymentdetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBanknonpoPaymentDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBanknonpoPaymentDetail dbBanknonpoPaymentDetail = new DbBanknonpoPaymentDetail(oid);
            dbBanknonpoPaymentDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBanknonpoPaymentDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANKNONPO_PAYMENT_DETAIL;
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
                BanknonpoPaymentDetail banknonpopaymentdetail = new BanknonpoPaymentDetail();
                resultToObject(rs, banknonpopaymentdetail);
                lists.add(banknonpopaymentdetail);
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

    private static void resultToObject(ResultSet rs, BanknonpoPaymentDetail banknonpopaymentdetail) {
        try {
            banknonpopaymentdetail.setOID(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_DETAIL_ID]));
            banknonpopaymentdetail.setBanknonpoPaymentId(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_ID]));
            banknonpopaymentdetail.setCoaId(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_COA_ID]));
            banknonpopaymentdetail.setAmount(rs.getDouble(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_AMOUNT]));
            banknonpopaymentdetail.setMemo(rs.getString(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_MEMO]));

            banknonpopaymentdetail.setForeignCurrencyId(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_FOREIGN_CURRENCY_ID]));
            banknonpopaymentdetail.setForeignAmount(rs.getDouble(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_FOREIGN_AMOUNT]));
            banknonpopaymentdetail.setBookedRate(rs.getDouble(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BOOKED_RATE]));

            banknonpopaymentdetail.setDepartmentId(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_DEPARTMENT_ID]));

            banknonpopaymentdetail.setSegment1Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT1_ID]));
            banknonpopaymentdetail.setSegment2Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT2_ID]));
            banknonpopaymentdetail.setSegment3Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT3_ID]));
            banknonpopaymentdetail.setSegment4Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT4_ID]));
            banknonpopaymentdetail.setSegment5Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT5_ID]));
            banknonpopaymentdetail.setSegment6Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT6_ID]));
            banknonpopaymentdetail.setSegment7Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT7_ID]));
            banknonpopaymentdetail.setSegment8Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT8_ID]));
            banknonpopaymentdetail.setSegment9Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT9_ID]));
            banknonpopaymentdetail.setSegment10Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT10_ID]));
            banknonpopaymentdetail.setSegment11Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT11_ID]));
            banknonpopaymentdetail.setSegment12Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT12_ID]));
            banknonpopaymentdetail.setSegment13Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT13_ID]));
            banknonpopaymentdetail.setSegment14Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT14_ID]));
            banknonpopaymentdetail.setSegment15Id(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT15_ID]));
            banknonpopaymentdetail.setModuleId(rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_MODULE_ID]));


        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long banknonpoPaymentDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANKNONPO_PAYMENT_DETAIL + " WHERE " +
                    DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_ID] + " = " + banknonpoPaymentDetailId;

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
            String sql = "SELECT COUNT(" + DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_DETAIL_ID] + ") FROM " + DB_BANKNONPO_PAYMENT_DETAIL;
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
                    BanknonpoPaymentDetail banknonpopaymentdetail = (BanknonpoPaymentDetail) list.get(ls);
                    if (oid == banknonpopaymentdetail.getOID()) {
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

    public static void saveAllDetail(BanknonpoPayment banknonpoPayment, Vector listBanknonpoPaymentDetail) {

        double amount = 0;

        if (listBanknonpoPaymentDetail != null && listBanknonpoPaymentDetail.size() > 0) {
            for (int i = 0; i < listBanknonpoPaymentDetail.size(); i++) {
                
                BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail) listBanknonpoPaymentDetail.get(i);
                amount = amount + crd.getAmount();

                crd.setBanknonpoPaymentId(banknonpoPayment.getOID());
               
                try {
                    if (crd.getOID() == 0) {
                        DbBanknonpoPaymentDetail.insertExc(crd);
                    } else {
                        DbBanknonpoPaymentDetail.updateExc(crd);
                    }
                } catch (Exception e) {
                    System.out.println(e.toString());
                }
            }

            try {
                banknonpoPayment.setAmount(amount);
                DbBanknonpoPayment.updateExc(banknonpoPayment);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
            
            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKK_BANK, banknonpoPayment.getOID(), banknonpoPayment.getAmount(), banknonpoPayment.getOperatorId());            

        }

    //DbBanknonpoPaymentDetail.updateAmount(banknonpoPayment); 
    }

    public static Vector getActivityPredefined(long paymentOID) {
        Vector result = new Vector();
        ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
        CONResultSet crs = null;
        try {
            String sql = "SELECT c.*, pd.* FROM coa_activity_budget c inner join banknonpo_payment_detail pd on pd.coa_id=c.coa_id " +
                    " where pd.banknonpo_payment_id=" + paymentOID + " and c.activity_period_id = " + ap.getOID();

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                CoaActivityBudget cab = new CoaActivityBudget();
                BanknonpoPaymentDetail ppd = new BanknonpoPaymentDetail();
                DbCoaActivityBudget.resultToObject(rs, cab);
                DbBanknonpoPaymentDetail.resultToObject(rs, ppd);
                Vector v = new Vector();
                v.add(cab);
                v.add(ppd);
                result.add(v);
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    /**
     * Delete all detail by main doc id
     * by gwawan 2012
     * @param oid
     */
    public static void deleteAllDetail(long oid) {
        if (oid != 0) {
            CONResultSet dbrs = null;

            try {
                String sql = "DELETE FROM " + DB_BANKNONPO_PAYMENT_DETAIL + " WHERE " +
                        colNames[COL_BANKNONPO_PAYMENT_ID] + " = " + oid;
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }
    
    public static void saveAllDetailBudget(BudgetRequest budgetRequest,BanknonpoPayment banknonpoPayment, Vector listBudgetRequestDetail,long userId) {
        double total = 0;
        if (listBudgetRequestDetail != null && listBudgetRequestDetail.size() > 0) {
            long oidIDR = 0;
            try{
                oidIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
            }catch(Exception e){}
            for (int i = 0; i < listBudgetRequestDetail.size(); i++) {
                BudgetRequestDetail brd = (BudgetRequestDetail)listBudgetRequestDetail.get(i);
                total = total + brd.getRequest();
                BanknonpoPaymentDetail crd = new BanknonpoPaymentDetail();                
                crd.setBanknonpoPaymentId(banknonpoPayment.getOID());
                crd.setCoaId(brd.getCoaId());
                crd.setAmount(brd.getRequest());
                crd.setForeignAmount(brd.getRequest());
                crd.setForeignCurrencyId(oidIDR);
                crd.setBookedRate(1);
                crd.setMemo(brd.getMemo());
                crd.setSegment1Id(budgetRequest.getSegment1Id());

                try {
                    boolean insert = getUniqDetail(crd);
                    if(insert){
                        DbBanknonpoPaymentDetail.insertExc(crd);                    
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
        }
        updateTotalAmount(banknonpoPayment.getOID(),total);
        DbBudgetRequest.updatePosted(userId,budgetRequest.getOID(),DbBudgetRequest.PAYMENT_TYPE_BANK,banknonpoPayment.getOID());
        Vector banknonpoDetail = DbBanknonpoPaymentDetail.list(0, 0, "" + DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_ID] + "=" + banknonpoPayment.getOID(), null);
        DbBanknonpoPayment.postJournal(banknonpoPayment, banknonpoDetail, userId);
    }
    
    public static void updateTotalAmount(long oid,double total) {
        if (oid != 0) {
            CONResultSet dbrs = null;

            try {
                String sql = "update " + DbBanknonpoPayment.DB_BANKNONPO_PAYMENT + " set "+DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_AMOUNT]+" = "+total+
                        " where " +DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_BANKNONPO_PAYMENT_ID] + " = " + oid;
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }
    
    public static boolean getUniqDetail(BanknonpoPaymentDetail crd){
        CONResultSet crs = null;
        try{
            String sql = "select "+DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_DETAIL_ID]+" from "+DbBanknonpoPaymentDetail.DB_BANKNONPO_PAYMENT_DETAIL+" where "+
                    DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_ID]+" = "+crd.getBanknonpoPaymentId()+" and "+
                    DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_COA_ID]+" = "+crd.getCoaId()+" and "+
                    DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_AMOUNT]+" = "+crd.getAmount()+" and "+
                    DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_MEMO]+" = '"+crd.getMemo()+"' and "+
                    DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_SEGMENT1_ID]+" = "+crd.getSegment1Id();
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            long oid = 0;
            while(rs.next()){
                oid = rs.getLong(DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_DETAIL_ID]);
            }
            if(oid == 0){
                return true;
            }
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        
        return false;
    }
    
    
}
