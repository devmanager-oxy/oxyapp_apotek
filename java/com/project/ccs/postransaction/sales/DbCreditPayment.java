/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.sales;

/**
 *
 * @author Administrator
 */
import com.project.I_Project;
import com.project.ccs.session.ReportCreditPayment;
import com.project.fms.ar.ARInvoice;
import com.project.fms.ar.ArPayment;
import com.project.fms.ar.DbARInvoice;
import com.project.fms.ar.DbArPayment;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.transaction.DbGl;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;

public class DbCreditPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CREDIT_PAYMENT = "pos_credit_payment";    
    public static final int COL_CREDIT_PAYMENT_ID = 0;
    public static final int COL_SALES_ID = 1;
    public static final int COL_CURRENCY_ID = 2;
    public static final int COL_PAY_DATETIME = 3;
    public static final int COL_AMOUNT = 4;
    public static final int COL_RATE = 5;
    public static final int COL_CASH_CASHIER_ID = 6;
    public static final int COL_POSTED_STATUS = 7;
    public static final int COL_POSTED_DATE = 8;
    public static final int COL_EFFECTIVE_DATE = 9;
    public static final int COL_POSTED_BY_ID = 10;
    public static final int COL_TYPE = 11;
    public static final int COL_BANK_ID = 12;
    public static final int COL_CUSTOMER_ID = 13;
    public static final int COL_MERCHANT_ID = 14;    
    public static final int COL_GIRO_ID = 15;
    public static final int COL_EXPIRED_DATE = 16;  
    
    public static final String[] colNames = {
        "credit_payment_id",
        "sales_id",
        "currency_id",
        "pay_datetime",
        "amount",
        "rate",
        "cash_cashier_id",
        "posted_status",
        "posted_date",
        "effective_date",
        "posted_by_id",
        "type",
        "bank_id",
        "customer_id",
        "merchant_id",
        "giro_id",
        "expired_date"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,        
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,        
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE
    };
    
    public static int TYPE_NOT_POSTED = 0;
    public static int TYPE_POSTED = 1;
    
    public static final int PAY_TYPE_CASH = 0;
    public static final int PAY_TYPE_CREDIT_CARD = 1;
    public static final int PAY_TYPE_DEBIT_CARD = 2;
    public static final int PAY_TYPE_TRANSFER = 3;    
    public static final int PAY_TYPE_GIRO = 4;

    public DbCreditPayment() {
    }

    public DbCreditPayment(int i) throws CONException {
        super(new DbCreditPayment());
    }

    public DbCreditPayment(String sOid) throws CONException {
        super(new DbSalesDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCreditPayment(long lOid) throws CONException {
        super(new DbCreditPayment(0));
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
        return DB_CREDIT_PAYMENT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCreditPayment().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CreditPayment creditPayment = fetchExc(ent.getOID());
        ent = (Entity) creditPayment;
        return creditPayment.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CreditPayment) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CreditPayment) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CreditPayment fetchExc(long oid) throws CONException {
        try {
            CreditPayment creditPayment = new CreditPayment();
            DbCreditPayment dbCreditPayment = new DbCreditPayment(oid);
            creditPayment.setOID(oid);

            creditPayment.setSales_id(dbCreditPayment.getlong(COL_SALES_ID));
            creditPayment.setCurrency_id(dbCreditPayment.getlong(COL_CURRENCY_ID));
            creditPayment.setPay_datetime(dbCreditPayment.getDate(COL_PAY_DATETIME));
            creditPayment.setAmount(dbCreditPayment.getdouble(COL_AMOUNT));
            creditPayment.setRate(dbCreditPayment.getdouble(COL_RATE));
            creditPayment.setCash_cashier_id(dbCreditPayment.getlong(COL_CASH_CASHIER_ID));
            creditPayment.setPostedStatus(dbCreditPayment.getInt(COL_POSTED_STATUS));
            creditPayment.setPostedDate(dbCreditPayment.getDate(COL_POSTED_DATE));
            creditPayment.setEffectiveDate(dbCreditPayment.getDate(COL_EFFECTIVE_DATE));
            creditPayment.setPostedById(dbCreditPayment.getlong(COL_POSTED_BY_ID));
            creditPayment.setType(dbCreditPayment.getInt(COL_TYPE));
            creditPayment.setBankId(dbCreditPayment.getlong(COL_BANK_ID));
            creditPayment.setCustomerId(dbCreditPayment.getlong(COL_CUSTOMER_ID));
            creditPayment.setMerchantId(dbCreditPayment.getlong(COL_MERCHANT_ID));
            
            creditPayment.setGiroId(dbCreditPayment.getlong(COL_GIRO_ID));
            creditPayment.setExpiredDate(dbCreditPayment.getDate(COL_EXPIRED_DATE));

            return creditPayment;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CreditPayment creditPayment) throws CONException {
        try {
            DbCreditPayment dbCreditPayment = new DbCreditPayment(0);

            dbCreditPayment.setLong(COL_SALES_ID, creditPayment.getSales_id());
            dbCreditPayment.setLong(COL_CURRENCY_ID, creditPayment.getCurrency_id());
            dbCreditPayment.setDate(COL_PAY_DATETIME, creditPayment.getPay_datetime());
            dbCreditPayment.setDouble(COL_AMOUNT, creditPayment.getAmount());
            dbCreditPayment.setDouble(COL_RATE, creditPayment.getRate());
            dbCreditPayment.setLong(COL_CASH_CASHIER_ID, creditPayment.getCash_cashier_id());
            dbCreditPayment.setInt(COL_POSTED_STATUS, creditPayment.getPostedStatus());
            dbCreditPayment.setDate(COL_POSTED_DATE, creditPayment.getPostedDate());
            dbCreditPayment.setDate(COL_EFFECTIVE_DATE, creditPayment.getEffectiveDate());
            dbCreditPayment.setLong(COL_POSTED_BY_ID, creditPayment.getPostedById());
            
            dbCreditPayment.setInt(COL_TYPE, creditPayment.getType());
            dbCreditPayment.setLong(COL_BANK_ID, creditPayment.getBankId());
            dbCreditPayment.setLong(COL_CUSTOMER_ID, creditPayment.getCustomerId());
            dbCreditPayment.setLong(COL_MERCHANT_ID, creditPayment.getMerchantId());            
            dbCreditPayment.setLong(COL_GIRO_ID, creditPayment.getGiroId());
            dbCreditPayment.setDate(COL_EXPIRED_DATE, creditPayment.getExpiredDate());

            dbCreditPayment.insert();
            creditPayment.setOID(dbCreditPayment.getlong(COL_CREDIT_PAYMENT_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesDetail(0), CONException.UNKNOWN);
        }
        return creditPayment.getOID();
    }

    public static long updateExc(CreditPayment creditPayment) throws CONException {
        try {
            if (creditPayment.getOID() != 0) {
                DbCreditPayment dbCreditPayment = new DbCreditPayment(creditPayment.getOID());

                dbCreditPayment.setLong(COL_SALES_ID, creditPayment.getSales_id());
                dbCreditPayment.setLong(COL_CURRENCY_ID, creditPayment.getCurrency_id());
                dbCreditPayment.setDate(COL_PAY_DATETIME, creditPayment.getPay_datetime());
                dbCreditPayment.setDouble(COL_AMOUNT, creditPayment.getAmount());
                dbCreditPayment.setDouble(COL_RATE, creditPayment.getRate());
                dbCreditPayment.setLong(COL_CASH_CASHIER_ID, creditPayment.getCash_cashier_id());
                dbCreditPayment.setInt(COL_POSTED_STATUS, creditPayment.getPostedStatus());
                dbCreditPayment.setDate(COL_POSTED_DATE, creditPayment.getPostedDate());
                dbCreditPayment.setDate(COL_EFFECTIVE_DATE, creditPayment.getEffectiveDate());
                dbCreditPayment.setLong(COL_POSTED_BY_ID, creditPayment.getPostedById());                
                dbCreditPayment.setInt(COL_TYPE, creditPayment.getType());
                dbCreditPayment.setLong(COL_BANK_ID, creditPayment.getBankId());
                dbCreditPayment.setLong(COL_CUSTOMER_ID, creditPayment.getCustomerId());
                dbCreditPayment.setLong(COL_MERCHANT_ID, creditPayment.getMerchantId());                
                dbCreditPayment.setLong(COL_GIRO_ID, creditPayment.getGiroId());
                dbCreditPayment.setDate(COL_EXPIRED_DATE, creditPayment.getExpiredDate());

                dbCreditPayment.update();
                return creditPayment.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCreditPayment(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCreditPayment dbCreditPayment = new DbCreditPayment(oid);
            dbCreditPayment.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCreditPayment(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CREDIT_PAYMENT;
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
                CreditPayment creditPayment = new CreditPayment();
                resultToObject(rs, creditPayment);
                lists.add(creditPayment);
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

    private static void resultToObject(ResultSet rs, CreditPayment creditPayment) {
        try {
            creditPayment.setOID(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_CREDIT_PAYMENT_ID]));
            creditPayment.setSales_id(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]));
            creditPayment.setCurrency_id(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_CURRENCY_ID]));
            creditPayment.setPay_datetime(rs.getDate(DbCreditPayment.colNames[DbCreditPayment.COL_PAY_DATETIME]));
            creditPayment.setAmount(rs.getDouble(DbCreditPayment.colNames[DbCreditPayment.COL_AMOUNT]));
            creditPayment.setRate(rs.getDouble(DbCreditPayment.colNames[DbCreditPayment.COL_RATE]));
            creditPayment.setCash_cashier_id(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_CASH_CASHIER_ID]));
            creditPayment.setPostedStatus(rs.getInt(DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS]));
            creditPayment.setPostedDate(rs.getDate(DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_DATE]));
            creditPayment.setEffectiveDate(rs.getDate(DbCreditPayment.colNames[DbCreditPayment.COL_EFFECTIVE_DATE]));
            creditPayment.setPostedById(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_BY_ID]));            
            creditPayment.setType(rs.getInt(DbCreditPayment.colNames[DbCreditPayment.COL_TYPE]));
            creditPayment.setBankId(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_BANK_ID]));
            creditPayment.setCustomerId(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_CUSTOMER_ID]));
            creditPayment.setMerchantId(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_MERCHANT_ID]));            
            creditPayment.setGiroId(rs.getLong(DbCreditPayment.colNames[DbCreditPayment.COL_GIRO_ID]));
            creditPayment.setExpiredDate(rs.getDate(DbCreditPayment.colNames[DbCreditPayment.COL_EXPIRED_DATE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long creditPaymentId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CREDIT_PAYMENT + " WHERE " +
                    DbCreditPayment.colNames[DbCreditPayment.COL_CREDIT_PAYMENT_ID] + " = " + creditPaymentId;
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
            String sql = "SELECT COUNT(" + DbCreditPayment.colNames[DbCreditPayment.COL_CREDIT_PAYMENT_ID] + ") FROM " + DB_CREDIT_PAYMENT;
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

    public static double getTotalPayment(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(" + DbCreditPayment.colNames[DbCreditPayment.COL_AMOUNT] + "*" + DbCreditPayment.colNames[DbCreditPayment.COL_RATE] + ") FROM " + DB_CREDIT_PAYMENT;
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
                    SalesDetail salesDetail = (SalesDetail) list.get(ls);
                    if (oid == salesDetail.getOID()) {
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

    public static void postJournal(Vector listPaymentCredit,long userId) {

        try {

            Company comp = DbCompany.getCompany();
            ExchangeRate er = DbExchangeRate.getStandardRate();

            if (listPaymentCredit != null && listPaymentCredit.size() > 0) {

                for (int iP = 0; iP < listPaymentCredit.size(); iP++) {

                    ReportCreditPayment rCP = (ReportCreditPayment) listPaymentCredit.get(iP);
                    CreditPayment cp = new CreditPayment();
                    try {

                        cp = DbCreditPayment.fetchExc(rCP.getCpId());

                        if (cp.getOID() != 0 && cp.getAmount() > 0) {

                            Sales sales = new Sales();
                            try {
                                sales = DbSales.fetchExc(cp.getSales_id());
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }

                            long segment1_id = 0;

                            if (sales.getLocation_id() != 0) {
                                String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                                Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                                if (segmentDt != null && segmentDt.size() > 0) {
                                    SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                                    segment1_id = sd.getOID();
                                }
                            }

                            Periode periode = new Periode();

                            try {
                                periode = DbPeriode.getPeriodByTransDate(cp.getPay_datetime());
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }

                            boolean coaLocationTrue = true;

                            ARInvoice ai = new ARInvoice();
                            Vector aiList = new Vector();
                            String whAR = DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID] + " = " + sales.getOID();
                            aiList = DbARInvoice.list(0, 0, whAR, null);

                            if (aiList != null && aiList.size() > 0) {
                                ai = (ARInvoice) aiList.get(0);
                                if (ai.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } else {
                                coaLocationTrue = false;
                            }

                            if (periode.getOID() == 0 && periode.getStatus().compareTo("Open") != 0) {
                                coaLocationTrue = false;
                            }

                            Location location = new Location();

                            try {
                                location = DbLocation.fetchExc(sales.getLocation_id());
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }

                            Coa co = new Coa();
                            if (location.getCoaApId() == 0) {
                                coaLocationTrue = false;
                            } else {
                                try {
                                    co = DbCoa.fetchExc(location.getCoaApId());
                                    if (co.getOID() == 0) {
                                        coaLocationTrue = false;
                                    }
                                } catch (Exception e) {
                                    coaLocationTrue = false;
                                }
                            }

                            if (coaLocationTrue) {

                                boolean numberOk = false;
                                int i = 0;
                                String number = "";
                                while (numberOk == false || i >= 50) {
                                    String numberJournal = "";
                                    if (i == 0) {
                                        numberJournal = sales.getNumber() + "P";
                                    } else {
                                        numberJournal = sales.getNumber() + "P" + i;
                                    }

                                    int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + numberJournal + "'");
                                    if (count == 0) {
                                        number = numberJournal;
                                        numberOk = true;
                                    }
                                    i++;
                                }

                                String memo = "Credit Payment Sales Number " + sales.getNumber();
                                long oid = DbGl.postJournalMain(0, cp.getPay_datetime(), sales.getCounter(), number, sales.getNumberPrefix(),
                                        I_Project.JOURNAL_TYPE_CREDIT_PAYMENT,
                                        memo, sales.getUserId(), "", sales.getOID(), "", cp.getPay_datetime(), periode.getOID());

                                if (oid != 0) {

                                    //jurnal debet
                                    memo = "Kas";

                                    DbGl.postJournalDetail(er.getValueIdr(), location.getCoaSalesId(), 0, cp.getAmount(),
                                            cp.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    //jurnal credit
                                    memo = "Piutang Credit Payment";
                                    DbGl.postJournalDetail(er.getValueIdr(), location.getCoaArId(), cp.getAmount(), 0,
                                            cp.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    //insert payment
                                    ArPayment arPayment = new ArPayment();
                                    arPayment.setArInvoiceId(ai.getOID());
                                    arPayment.setExchangeRate(er.getValueIdr());
                                    arPayment.setCurrencyId(er.getCurrencyIdrId());
                                    arPayment.setAmount(cp.getAmount());
                                    arPayment.setCustomerId(ai.getCustomerId());
                                    arPayment.setDate(new Date());
                                    arPayment.setProjectTermId(ai.getProjectTermId());
                                    arPayment.setCompanyId(sales.getCompanyId());
                                    arPayment.setCounter(DbArPayment.getNextCounter(sales.getCompanyId()));
                                    arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(sales.getCompanyId()));
                                    arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), arPayment.getCompanyId()));
                                    arPayment.setProjectId(ai.getProjectId());
                                    arPayment.setArCurrencyAmount(cp.getAmount());
                                    arPayment.setTransactionDate(new Date());
                                    arPayment.setNotes("Payment credit transaction sales number : " + sales.getNumber());

                                    try {
                                        long oidP = DbArPayment.insertExc(arPayment);
                                        
                                        updatePostedStatus(cp.getOID(),userId);

                                        if (oidP != 0) {

                                            double amountTot = DbSales.getAmountPayment(ai.getOID());
                                            if (amountTot >= ai.getTotal()) {
                                                ai.setStatus(I_Project.INV_STATUS_FULL_PAID);
                                            } else {
                                                ai.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                                            }

                                            DbARInvoice.updateExc(ai);
                                        }
                                    } catch (Exception e) {
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }
    
    public static void updatePostedStatus(long creditPaymentId,long userId){
        CONResultSet crs = null;
        try{
            String sql = "UPDATE "+DbCreditPayment.DB_CREDIT_PAYMENT+" set "+DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS]+" = 1,"
                    +DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd") +" 00:00:00',"
                    +DbCreditPayment.colNames[DbCreditPayment.COL_EFFECTIVE_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd") +" 00:00:00',"
                    +DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_BY_ID]+" = "+userId+" where "+
                    DbCreditPayment.colNames[DbCreditPayment.COL_CREDIT_PAYMENT_ID]+" = "+creditPaymentId;
                    
            
        CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }        
    }
    
    public static void creditPayment(CreditPayment creditPayment,long userId,long arInvoiceId){
        
        try{
            //jurnalnya kas pada piutang
            if(creditPayment.getOID() != 0){
                
                Company comp = DbCompany.getCompany();
                ExchangeRate er = DbExchangeRate.getStandardRate();
                boolean isOK = true;                
                Periode periode = new Periode();
                Sales sales = new Sales();
                Location location = new Location();
                Coa coaAR = new Coa();
                Coa coaKas = new Coa();
                Customer customer = new Customer();
                long segment1_id = 0;
                
                ARInvoice arInvoice = new ARInvoice();
                try{
                    arInvoice = DbARInvoice.fetchExc(arInvoiceId);
                }catch(Exception e){}
                
                try{
                    periode = DbPeriode.getPeriodByTransDate(creditPayment.getPay_datetime());
                }catch(Exception e){}
                
                if(periode.getStatus().compareTo("Closed") == 0){
                    isOK = false;
                }
                
                try{
                    sales = DbSales.fetchExc(creditPayment.getSales_id());
                }catch(Exception e){}            
                
                if(sales.getOID() == 0){
                    isOK = false;
                }
                
                try{
                    location = DbLocation.fetchExc(sales.getLocation_id());
                }catch(Exception e){}
                
                if(location.getCoaArId() != 0){
                    try{
                        coaAR = DbCoa.fetchExc(location.getCoaArId());
                        if(coaAR.getOID() == 0){
                            isOK = false;
                        }
                    }catch(Exception e){}
                }

                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }
                
                try{
                    customer = DbCustomer.fetchExc(sales.getCustomerId());
                }catch(Exception e){}
                
                if(isOK == true){
                    
                    String memo = "Credit payment suplier : "+customer.getName();
                    
                    boolean numberOk = false;
                    int i = 0;
                    String number = "";
                    while (numberOk == false || i >= 50) {
                        String numberJournal = "";
                        if (i == 0) {
                            numberJournal = sales.getNumber() + "P";
                        } else {
                            numberJournal = sales.getNumber() + "P" + i;
                        }

                        int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + numberJournal + "'");
                        if (count == 0) {
                            number = numberJournal;
                            numberOk = true;
                        }
                        i++;
                    }
                    
                    long oid = DbGl.postJournalMain(0, creditPayment.getPay_datetime(), sales.getCounter(), number, sales.getNumberPrefix(),
                            I_Project.JOURNAL_TYPE_CREDIT_PAYMENT,
                            memo, userId, "", creditPayment.getOID(), "", creditPayment.getPay_datetime(), periode.getOID());
                    
                    if(oid!= 0){
                        
                        if(creditPayment.getType() == DbCreditPayment.PAY_TYPE_CASH){
                            memo ="Payment kas";                        
                            if(location.getCoaSalesId() != 0){
                                try{
                                    coaKas = DbCoa.fetchExc(location.getCoaSalesId());
                                    if(coaKas.getOID() == 0){
                                        isOK = false;
                                    }
                                }catch(Exception e){}
                            }                         
                            
                            DbGl.postJournalDetail(er.getValueIdr(), coaKas.getOID(), 0, creditPayment.getAmount(),
                                        creditPayment.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                            
                        }else if(creditPayment.getType() == DbCreditPayment.PAY_TYPE_CREDIT_CARD || creditPayment.getType() == DbCreditPayment.PAY_TYPE_DEBIT_CARD){
                            if(creditPayment.getType() == DbCreditPayment.PAY_TYPE_CREDIT_CARD){
                                memo = "Payment Credit Card";
                            }else{
                                memo = "Payment Debit Card";
                            }
                            
                            Merchant merchant = new Merchant();
                            if(creditPayment.getMerchantId() != 0){
                                try{
                                    merchant = DbMerchant.fetchExc(creditPayment.getMerchantId());
                                }catch(Exception e){}        
                            }
                            
                            Coa coaCard = new Coa();
                            Coa coaExpense = new Coa();
                            
                            try {
                                coaCard = DbCoa.fetchExc(merchant.getCoaId());
                            } catch (Exception e) {}
                            
                            try {
                                coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                            } catch (Exception e) {}
                            
                            double amountExpense = 0;                                    
                            if (merchant.getPersenExpense() > 0) {
                                amountExpense = (merchant.getPersenExpense() / 100) * creditPayment.getAmount();
                            }
                            
                            double paymentAmount = creditPayment.getAmount() - amountExpense;
                            
                            DbGl.postJournalDetail(er.getValueIdr(), coaCard.getOID(), 0, paymentAmount,
                                        paymentAmount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                            
                            if(paymentAmount !=0){
                                if(creditPayment.getType() == DbCreditPayment.PAY_TYPE_CREDIT_CARD){
                                    memo = "Biaya credit card";
                                }else{
                                    memo = "Biaya debit card";
                                }
                                
                                DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), 0, amountExpense,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                            }
                            
                        }else if(creditPayment.getType() == DbCreditPayment.PAY_TYPE_TRANSFER){
                            
                            Bank bank = new Bank();
                            try{
                                bank = DbBank.fetchExc(creditPayment.getBankId());
                            }catch(Exception e){}
                            
                            memo = "Payment Transfer Bank : "+bank.getName(); 
                            Coa coaBank = new Coa();
                            try{
                                coaBank = DbCoa.fetchExc(bank.getCoaARId());
                            }catch(Exception e){}
                            
                            DbGl.postJournalDetail(er.getValueIdr(), coaBank.getOID(), 0, creditPayment.getAmount(),
                                        creditPayment.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                        }
                        
                        memo ="Piutang suplier : "+customer.getName();       
                        DbGl.postJournalDetail(er.getValueIdr(), coaAR.getOID(), creditPayment.getAmount(), 0,
                                        creditPayment.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                        
                        try{
                            updateStatusPayCredit(creditPayment.getOID(),userId);
                        }catch(Exception e){}
                        
                        ArPayment arPayment = new ArPayment();
                        arPayment.setArInvoiceId(arInvoiceId);
                        arPayment.setExchangeRate(er.getValueIdr());
                        arPayment.setCurrencyId(er.getCurrencyIdrId());
                        arPayment.setAmount(creditPayment.getAmount());
                        arPayment.setCustomerId(sales.getCustomerId());
                        arPayment.setDate(creditPayment.getPay_datetime());
                        arPayment.setProjectTermId(sales.getOID());
                        arPayment.setCompanyId(sales.getCompanyId());
                        arPayment.setCounter(DbArPayment.getNextCounter(sales.getCompanyId()));
                        arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(sales.getCompanyId()));
                        arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), arPayment.getCompanyId()));
                        arPayment.setProjectId(sales.getOID());
                        arPayment.setArCurrencyAmount(creditPayment.getAmount());
                        arPayment.setTransactionDate(new Date());
                        arPayment.setNotes("Payment credit transaction sales number : " + sales.getNumber());
                        arPayment.setCreditPaymentId(creditPayment.getOID());
                        
                        try {
                            long oidP = DbArPayment.insertExc(arPayment);
                            if (oidP != 0) {
                                double amountTot = DbSales.getAmountPayment(arInvoice.getOID());
                                if (amountTot >= arInvoice.getTotal()){
                                    arInvoice.setStatus(I_Project.INV_STATUS_FULL_PAID);
                                } else {
                                    arInvoice.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                                }
                                DbARInvoice.updateExc(arInvoice);
                            }
                       } catch (Exception e) {}
                    }
                }
            }
            
        }catch(Exception e){System.out.println("[exception] "+e.toString());}
    }
    
    public static void creditPayment(Company comp , CreditPayment creditPayment,long userId,long arInvoiceId, String customerName, String formNumbComp){
        
        try{
            
            if(creditPayment.getOID() != 0){
                
                ExchangeRate er = DbExchangeRate.getStandardRate();
                boolean isOK = true;                
                Periode periode = new Periode();
                Sales sales = new Sales();
                Location location = new Location();
                Coa coaAR = new Coa();
                Coa coaKas = new Coa();                
                long segment1_id = 0;
                
                //untuk keperluan merchant
                Merchant merchant = new Merchant();
                Coa coaCard = new Coa();
                Coa coaExpense = new Coa();
                
                //Jika Pembayaran Melalui Transfer BANK
                Bank bank = new Bank();
                Coa coaBank = new Coa();                
                Giro g = new Giro();
                Coa coaGiro = new Coa();  
                
                ARInvoice arInvoice = new ARInvoice();
                try{
                    arInvoice = DbARInvoice.fetchExc(arInvoiceId);
                }catch(Exception e){}
                
                try{
                    periode = DbPeriode.getPeriodByTransDate(creditPayment.getPay_datetime());
                }catch(Exception e){}
                
                if(periode.getStatus().compareTo("Closed") == 0){
                    isOK = false;
                }
                
                try{
                    sales = DbSales.fetchExc(creditPayment.getSales_id());
                }catch(Exception e){}            
                
                if(sales.getOID() == 0){
                    isOK = false;
                }
                
                try{
                    location = DbLocation.fetchExc(sales.getLocation_id());
                }catch(Exception e){}
                
                if(location.getCoaArId() != 0){
                    try{
                        coaAR = DbCoa.fetchExc(location.getCoaArId());
                        if(coaAR.getOID() == 0){
                            isOK = false;
                        }
                    }catch(Exception e){}
                }
                
                //pengecekan coa merchant
                if(creditPayment.getType() == DbPayment.PAY_TYPE_CREDIT_CARD || creditPayment.getType() == DbPayment.PAY_TYPE_DEBIT_CARD){                    
                    if(creditPayment.getMerchantId() != 0){
                        try{
                            merchant = DbMerchant.fetchExc(creditPayment.getMerchantId());
                        }catch(Exception e){}      
                            
                        try {
                            coaCard = DbCoa.fetchExc(merchant.getCoaId());
                        } catch (Exception e) {}
                        
                        if(coaCard.getOID() == 0){
                            isOK = false;
                        }
                            
                        if(merchant.getPersenExpense() != 0){                        
                            try {
                                coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                            } catch (Exception e) {}
                            
                            if(coaExpense.getOID() == 0){
                                isOK = false;
                            }
                        }
                        
                    }else{//jika kondisi pembayaran dengan cc, maka merchant harus ada
                        isOK = false;
                    }
                }else if(creditPayment.getType() == DbPayment.PAY_TYPE_TRANSFER){
                            
                    try{
                        bank = DbBank.fetchExc(creditPayment.getBankId());
                    }catch(Exception e){}
                            
                    try{
                        coaBank = DbCoa.fetchExc(bank.getCoaARId());
                    }catch(Exception e){}
                    
                    if(coaBank.getOID() == 0){
                        isOK = false;
                    }                    
                }else if(creditPayment.getType() == DbPayment.PAY_TYPE_GIRO){                                        
                    
                    try{ 
                        if(creditPayment.getGiroId() != 0){
                            g = DbGiro.fetchExc(creditPayment.getGiroId());
                            try{
                                coaGiro = DbCoa.fetchExc(g.getCoaId());
                            }catch(Exception e){}
                            
                            if(coaGiro.getOID() == 0){
                                isOK = false;
                            }
                        }else{
                            isOK = false;
                        }
                    }catch(Exception e){
                        isOK = false;
                    }
                }

                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        if(sd.getRefSegmentDetailId() != 0){
                            segment1_id = sd.getRefSegmentDetailId();
                        }else{
                            segment1_id = sd.getOID();
                        }                        
                    }
                }
                
                if(isOK == true){
                    
                    String memo = "Credit payment customer : "+customerName;
                    
                    boolean numberOk = false;
                    int i = 0;
                    String number = "";
                    while (numberOk == false || i >= 50) {
                        String numberJournal = "";
                        if (i == 0) {
                            numberJournal = sales.getNumber() + "P";
                        } else {
                            numberJournal = sales.getNumber() + "P" + i;
                        }

                        int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + numberJournal + "'");
                        if (count == 0) {
                            number = numberJournal;
                            numberOk = true;
                        }
                        i++;
                    }
                    
                    long oid = DbGl.postJournalMain(0, creditPayment.getPay_datetime(), sales.getCounter(), number, sales.getNumberPrefix(),
                            I_Project.JOURNAL_TYPE_CREDIT_PAYMENT,
                            memo, userId, "", creditPayment.getOID(), "", creditPayment.getPay_datetime(), periode.getOID());
                    
                    if(oid!= 0){
                        
                        if(creditPayment.getType() == DbPayment.PAY_TYPE_CASH){
                            memo ="Payment kas";                        
                            if(location.getCoaSalesId() != 0){
                                try{
                                    coaKas = DbCoa.fetchExc(location.getCoaSalesId());
                                    if(coaKas.getOID() == 0){
                                        isOK = false;
                                    }
                                }catch(Exception e){}
                            }                         
                            
                            DbGl.postJournalDetail(er.getValueIdr(), coaKas.getOID(), 0, creditPayment.getAmount(),
                                        creditPayment.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                            
                        }else if(creditPayment.getType() == DbPayment.PAY_TYPE_CREDIT_CARD || creditPayment.getType() == DbPayment.PAY_TYPE_DEBIT_CARD){
                            
                            if(creditPayment.getType() == DbPayment.PAY_TYPE_CREDIT_CARD){
                                memo = "Payment Credit Card";
                            }else{
                                memo = "Payment Debit Card";
                            }
                            
                            double amountExpense = 0;                                    
                            if (merchant.getPersenExpense() > 0) {
                                amountExpense = (merchant.getPersenExpense() / 100) * creditPayment.getAmount();
                            }
                            
                            double paymentAmount = creditPayment.getAmount() - amountExpense;
                            
                            DbGl.postJournalDetail(er.getValueIdr(), coaCard.getOID(), 0, paymentAmount,
                                        paymentAmount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                            
                            if(amountExpense !=0){
                                if(creditPayment.getType() == DbPayment.PAY_TYPE_CREDIT_CARD){
                                    memo = "Biaya credit card";
                                }else{
                                    memo = "Biaya debit card";
                                }
                                
                                DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), 0, amountExpense,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                            }
                            
                        }else if(creditPayment.getType() == DbPayment.PAY_TYPE_TRANSFER){
                            
                            memo = "Payment Transfer Bank : "+bank.getName(); 
                            
                            DbGl.postJournalDetail(er.getValueIdr(), coaBank.getOID(), 0, creditPayment.getAmount(),
                                        creditPayment.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                        }else if(creditPayment.getType() == DbPayment.PAY_TYPE_GIRO){
                            
                            memo = "Payment Giro : "+g.getName(); 
                            
                            DbGl.postJournalDetail(er.getValueIdr(), coaGiro.getOID(), 0, creditPayment.getAmount(),
                                        creditPayment.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); 
                        }
                        
                        memo ="Piutang customer : "+customerName;       
                        DbGl.postJournalDetail(er.getValueIdr(), coaAR.getOID(), creditPayment.getAmount(), 0,
                                        creditPayment.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                        
                        try{
                            updateStatusPayCredit(creditPayment.getOID(),userId);
                        }catch(Exception e){}
                        
                        ArPayment arPayment = new ArPayment();
                        arPayment.setArInvoiceId(arInvoiceId);
                        arPayment.setExchangeRate(er.getValueIdr());
                        arPayment.setCurrencyId(er.getCurrencyIdrId());
                        arPayment.setAmount(creditPayment.getAmount());
                        arPayment.setCustomerId(sales.getCustomerId());
                        arPayment.setDate(creditPayment.getPay_datetime());
                        arPayment.setProjectTermId(sales.getOID());
                        arPayment.setCompanyId(sales.getCompanyId());
                        arPayment.setCounter(DbArPayment.getNextCounter(sales.getCompanyId()));
                        arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(sales.getCompanyId()));
                        arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), arPayment.getCompanyId()));
                        arPayment.setProjectId(sales.getOID());
                        arPayment.setArCurrencyAmount(creditPayment.getAmount());
                        arPayment.setTransactionDate(new Date());
                        arPayment.setNotes("Payment credit transaction sales number : " + sales.getNumber());
                        arPayment.setCreditPaymentId(creditPayment.getOID());
                        
                        try {
                            long oidP = DbArPayment.insertExc(arPayment);
                            if (oidP != 0) {
                                double amountTot = DbSales.getAmountPayment(arInvoice.getOID());
                                
                                double totalAp = 0;
                                if (formNumbComp.equals("#,##0")) {
                                    totalAp = Math.round(arInvoice.getTotal());
                                } else {
                                    totalAp = arInvoice.getTotal();
                                }
                                if (amountTot >= totalAp){
                                    arInvoice.setStatus(I_Project.INV_STATUS_FULL_PAID);
                                } else {
                                    arInvoice.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                                }
                                DbARInvoice.updateExc(arInvoice);
                            }
                            
                            if(creditPayment.getType() == DbPayment.PAY_TYPE_GIRO){
                                try{    
                                    GiroTransaction gt = new GiroTransaction();
                                    gt.setTransactionType(DbGiroTransaction.TYPE_CREDIT_PAYMENT);
                                    gt.setSourceId(creditPayment.getOID());
                                    gt.setGiroId(creditPayment.getGiroId());
                                    gt.setDateTransaction(creditPayment.getPay_datetime());
                                    gt.setDueDate(creditPayment.getExpiredDate());
                                    gt.setCoaId(coaGiro.getOID());
                                    gt.setStatus(DbGiroTransaction.STATUS_NOT_PAID);
                                    gt.setAmount(creditPayment.getAmount());
                                    gt.setCustomerId(creditPayment.getCustomerId());
                                    gt.setNumber(sales.getNumber());
                                    gt.setSegmentId(segment1_id);
                                    gt.setNumberPrefix(sales.getNumberPrefix());
                                    gt.setCounter(sales.getCounter());
                                    
                                    DbGiroTransaction.insertExc(gt);
                                }catch(Exception e){}    
                            }
                            
                       } catch (Exception e) {}
                    }
                }
            }
            
        }catch(Exception e){System.out.println("[exception] "+e.toString());}
    }
    
    public static void arMemoPayment(ARInvoice ar,long arInvoiceId,double amount){
        
        try{            
            if(ar.getOID() != 0){
                
                Company comp = DbCompany.getCompany();
                ExchangeRate er = DbExchangeRate.getStandardRate();
                ARInvoice arInvoice = new ARInvoice();
                try{
                    arInvoice = DbARInvoice.fetchExc(arInvoiceId);
                }catch(Exception e){}
                
                ArPayment arPayment = new ArPayment();
                arPayment.setArInvoiceId(arInvoiceId);
                arPayment.setExchangeRate(er.getValueIdr());
                arPayment.setCurrencyId(er.getCurrencyIdrId());
                arPayment.setAmount(amount);
                arPayment.setCustomerId(arInvoice.getCustomerId());
                arPayment.setDate(ar.getDate());
                arPayment.setProjectTermId(arInvoice.getProjectTermId());
                arPayment.setCompanyId(arInvoice.getCompanyId());
                arPayment.setCounter(DbArPayment.getNextCounter(comp.getOID()));
                arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(comp.getOID()));
                arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), comp.getOID()));
                arPayment.setProjectId(arInvoice.getProjectId());
                arPayment.setArCurrencyAmount(amount);
                arPayment.setTransactionDate(new Date());
                arPayment.setNotes("Payment credit with AR memo");
                arPayment.setRefId(ar.getOID());
                        
                try {
                    long oidP = DbArPayment.insertExc(arPayment);
                    if (oidP != 0) {
                        double amountTot = DbSales.getAmountPayment(arInvoice.getOID());
                        if (amountTot >= arInvoice.getTotal()){
                            arInvoice.setStatus(I_Project.INV_STATUS_FULL_PAID);
                        } else {
                            arInvoice.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                        }
                        DbARInvoice.updateExc(arInvoice);
                    }
                    
                    if(amount != 0){
                        amount = amount * -1;
                    }
                    ArPayment arPayment2 = new ArPayment();
                    arPayment2.setArInvoiceId(ar.getOID());
                    arPayment2.setExchangeRate(er.getValueIdr());
                    arPayment2.setCurrencyId(er.getCurrencyIdrId());
                    arPayment2.setAmount(amount);
                    arPayment2.setCustomerId(ar.getCustomerId());
                    arPayment2.setDate(ar.getDate());
                    arPayment2.setProjectTermId(ar.getProjectTermId());
                    arPayment2.setCompanyId(arInvoice.getCompanyId());
                    arPayment2.setCounter(DbArPayment.getNextCounter(comp.getOID()));
                    arPayment2.setJournalNumberPrefix(DbArPayment.getNumberPrefix(comp.getOID()));
                    arPayment2.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), comp.getOID()));
                    arPayment2.setProjectId(ar.getProjectId());
                    arPayment2.setArCurrencyAmount(amount);
                    arPayment2.setTransactionDate(new Date());
                    arPayment2.setNotes("Payment credit with AR memo");
                    
                    long oidP2 = DbArPayment.insertExc(arPayment2);
                    
                    if (oidP2 != 0) {
                        double amountTot = DbSales.getAmountPayment(ar.getOID());
                        if (amountTot <= ar.getTotal()){
                            ar.setStatus(I_Project.INV_STATUS_FULL_PAID);
                        } else {
                            ar.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                        }
                        DbARInvoice.updateExc(ar);
                    }
                    
                 } catch (Exception e) {}
            }
        }catch(Exception e){System.out.println("[exception] "+e.toString());}
    }
    
    
    public static void arMemoPayment(Company comp , ARInvoice ar,long arInvoiceId,double amount){
        
        try{            
            if(ar.getOID() != 0){
                ExchangeRate er = DbExchangeRate.getStandardRate();
                ARInvoice arInvoice = new ARInvoice();
                try{
                    arInvoice = DbARInvoice.fetchExc(arInvoiceId);
                }catch(Exception e){}
                
                ArPayment arPayment = new ArPayment();
                arPayment.setArInvoiceId(arInvoiceId);
                arPayment.setExchangeRate(er.getValueIdr());
                arPayment.setCurrencyId(er.getCurrencyIdrId());
                arPayment.setAmount(amount);
                arPayment.setCustomerId(arInvoice.getCustomerId());
                arPayment.setDate(ar.getDate());
                arPayment.setProjectTermId(arInvoice.getProjectTermId());
                arPayment.setCompanyId(arInvoice.getCompanyId());
                arPayment.setCounter(DbArPayment.getNextCounter(comp.getOID()));
                arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(comp.getOID()));
                arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), comp.getOID()));
                arPayment.setProjectId(arInvoice.getProjectId());
                arPayment.setArCurrencyAmount(amount);
                arPayment.setTransactionDate(new Date());
                arPayment.setNotes("Payment credit with AR memo");
                arPayment.setRefId(ar.getOID());
                        
                try {
                    long oidP = DbArPayment.insertExc(arPayment);
                    if (oidP != 0) {
                        double amountTot = DbSales.getAmountPayment(arInvoice.getOID());
                        if (amountTot >= arInvoice.getTotal()){
                            arInvoice.setStatus(I_Project.INV_STATUS_FULL_PAID);
                        } else {
                            arInvoice.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                        }
                        DbARInvoice.updateExc(arInvoice);
                    }
                    
                    if(amount != 0){
                        amount = amount * -1;
                    }
                    ArPayment arPayment2 = new ArPayment();
                    arPayment2.setArInvoiceId(ar.getOID());
                    arPayment2.setExchangeRate(er.getValueIdr());
                    arPayment2.setCurrencyId(er.getCurrencyIdrId());
                    arPayment2.setAmount(amount);
                    arPayment2.setCustomerId(ar.getCustomerId());
                    arPayment2.setDate(ar.getDate());
                    arPayment2.setProjectTermId(ar.getProjectTermId());
                    arPayment2.setCompanyId(arInvoice.getCompanyId());
                    arPayment2.setCounter(DbArPayment.getNextCounter(comp.getOID()));
                    arPayment2.setJournalNumberPrefix(DbArPayment.getNumberPrefix(comp.getOID()));
                    arPayment2.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), comp.getOID()));
                    arPayment2.setProjectId(ar.getProjectId());
                    arPayment2.setArCurrencyAmount(amount);
                    arPayment2.setTransactionDate(new Date());
                    arPayment2.setNotes("Payment credit with AR memo");
                    
                    long oidP2 = DbArPayment.insertExc(arPayment2);
                    
                    if (oidP2 != 0) {
                        double amountTot = DbSales.getAmountPayment(ar.getOID());
                        if (amountTot <= ar.getTotal()){
                            ar.setStatus(I_Project.INV_STATUS_FULL_PAID);
                        } else {
                            ar.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                        }
                        DbARInvoice.updateExc(ar);
                    }
                    
                 } catch (Exception e) {}
            }
        }catch(Exception e){System.out.println("[exception] "+e.toString());}
    }
    
    
    public static void arMemoPayment(Company comp , ARInvoice ar,long arInvoiceId,double amount,String formNumbComp){
        
        try{            
            if(ar.getOID() != 0){
                ExchangeRate er = DbExchangeRate.getStandardRate();
                ARInvoice arInvoice = new ARInvoice();
                try{
                    arInvoice = DbARInvoice.fetchExc(arInvoiceId);
                }catch(Exception e){}
                
                ArPayment arPayment = new ArPayment();
                arPayment.setArInvoiceId(arInvoiceId);
                arPayment.setExchangeRate(er.getValueIdr());
                arPayment.setCurrencyId(er.getCurrencyIdrId());
                arPayment.setAmount(amount);
                arPayment.setCustomerId(arInvoice.getCustomerId());
                arPayment.setDate(ar.getDate());
                arPayment.setProjectTermId(arInvoice.getProjectTermId());
                arPayment.setCompanyId(arInvoice.getCompanyId());
                arPayment.setCounter(DbArPayment.getNextCounter(comp.getOID()));
                arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(comp.getOID()));
                arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), comp.getOID()));
                arPayment.setProjectId(arInvoice.getProjectId());
                arPayment.setArCurrencyAmount(amount);
                arPayment.setTransactionDate(new Date());
                arPayment.setNotes("Payment credit");
                arPayment.setRefId(ar.getOID());
                        
                try {
                    long oidP = DbArPayment.insertExc(arPayment);
                    if (oidP != 0) {
                        double amountTot = DbSales.getAmountPayment(arInvoice.getOID());                        
                        double totalAp = 0;
                        if (formNumbComp.equals("#,##0")) {
                            totalAp = Math.round(arInvoice.getTotal());
                        } else {
                            totalAp = arInvoice.getTotal();
                        }
                        if (amountTot >= totalAp){
                            arInvoice.setStatus(I_Project.INV_STATUS_FULL_PAID);
                        } else {
                            arInvoice.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                        }
                        DbARInvoice.updateExc(arInvoice);
                    }
                    
                    if(amount != 0){
                        amount = amount * -1;
                    }
                    ArPayment arPayment2 = new ArPayment();
                    arPayment2.setArInvoiceId(ar.getOID());
                    arPayment2.setExchangeRate(er.getValueIdr());
                    arPayment2.setCurrencyId(er.getCurrencyIdrId());
                    arPayment2.setAmount(amount);
                    arPayment2.setCustomerId(ar.getCustomerId());
                    arPayment2.setDate(ar.getDate());
                    arPayment2.setProjectTermId(ar.getProjectTermId());
                    arPayment2.setCompanyId(arInvoice.getCompanyId());
                    arPayment2.setCounter(DbArPayment.getNextCounter(comp.getOID()));
                    arPayment2.setJournalNumberPrefix(DbArPayment.getNumberPrefix(comp.getOID()));
                    arPayment2.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), comp.getOID()));
                    arPayment2.setProjectId(ar.getProjectId());
                    arPayment2.setArCurrencyAmount(amount);
                    arPayment2.setTransactionDate(new Date());
                    arPayment2.setNotes("Payment credit");
                    
                    long oidP2 = DbArPayment.insertExc(arPayment2);
                    
                    if (oidP2 != 0) {
                        double amountTot = DbSales.getAmountPayment(ar.getOID());
                        double totalAp = 0;
                        if (formNumbComp.equals("#,##0")) {
                            totalAp = Math.round( ar.getTotal());
                        } else {
                            totalAp =  ar.getTotal();
                        }
                        if (amountTot <= totalAp){
                            ar.setStatus(I_Project.INV_STATUS_FULL_PAID);
                        } else {
                            ar.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                        }
                        DbARInvoice.updateExc(ar);
                    }
                    
                 } catch (Exception e) {}
            }
        }catch(Exception e){System.out.println("[exception] "+e.toString());}
    }
    
    
    public static void updateStatusPayCredit(long creditPaymentId, long userId) {

        CONResultSet crs = null;
        try {

            String sql = "UPDATE " + DbCreditPayment.DB_CREDIT_PAYMENT + " SET " +
                    DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + " = 1," + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_BY_ID] + " = " + userId + ", " +
                    DbCreditPayment.colNames[DbCreditPayment.COL_EFFECTIVE_DATE] + " = '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + " 00:00:00' " +
                    "," + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_DATE] + " = '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "' where " +
                    DbCreditPayment.colNames[DbCreditPayment.COL_CREDIT_PAYMENT_ID] + " = " + creditPaymentId;

            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }
    }
}
