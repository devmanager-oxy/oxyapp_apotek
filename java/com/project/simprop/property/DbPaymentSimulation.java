/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.SystemDocNumber;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class DbPaymentSimulation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_PAYMENT_SIMULATION = "prop_payment_simulation";
    public static final int COL_PAYMENT_SIMULATION_ID = 0;
    public static final int COL_SALES_DATA_ID = 1;
    public static final int COL_TYPE_PAYMENT = 2;
    public static final int COL_NAME = 3;
    public static final int COL_SALDO = 4;
    public static final int COL_BUNGA = 5;
    public static final int COL_AMOUNT = 6;
    public static final int COL_TOTAL_AMOUNT = 7;
    public static final int COL_DUE_DATE = 8;
    public static final int COL_CUSTOMER_ID = 9;
    public static final int COL_STATUS_GEN = 10;
    public static final int COL_STATUS = 11;
    public static final int COL_USER_ID = 12;
    public static final int COL_PAYMENT = 13;
    
    public static final String[] colNames = {
        "payment_simulaton_id",
        "sales_data_id",
        "type_payment",
        "name",
        "saldo",
        "bunga",
        "amount",
        "total_amount",
        "due_date",
        "customer_id",
        "status_gen",
        "status",
        "user_id",
        "payment"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT
    };
    
    public static final int STATUS_BELUM_LUNAS = 0;
    public static final int STATUS_LUNAS = 1;
    public static final int STATUS_BELUM_FULL_PEMBAYARAN = 2;
    
    public static final int PAYMENT_BF = 0;
    public static final int PAYMENT_DP = 1;
    public static final int PAYMENT_PELUNASAN = 2;

    public DbPaymentSimulation() {
    }

    public DbPaymentSimulation(int i) throws CONException {
        super(new DbPaymentSimulation());
    }

    public DbPaymentSimulation(String sOid) throws CONException {
        super(new DbPaymentSimulation(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPaymentSimulation(long lOid) throws CONException {
        super(new DbPaymentSimulation(0));
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
        return DB_PAYMENT_SIMULATION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPaymentSimulation().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PaymentSimulation paymentSimulation = fetchExc(ent.getOID());
        ent = (Entity) paymentSimulation;
        return paymentSimulation.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PaymentSimulation) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PaymentSimulation) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PaymentSimulation fetchExc(long oid) throws CONException {
        try {
            PaymentSimulation paymentSimulation = new PaymentSimulation();
            DbPaymentSimulation pstPaymentSimulation = new DbPaymentSimulation(oid);
            paymentSimulation.setOID(oid);

            paymentSimulation.setSalesDataId(pstPaymentSimulation.getlong(COL_SALES_DATA_ID));
            paymentSimulation.setTypePayment(pstPaymentSimulation.getInt(COL_TYPE_PAYMENT));
            paymentSimulation.setName(pstPaymentSimulation.getString(COL_NAME));
            paymentSimulation.setSaldo(pstPaymentSimulation.getdouble(COL_SALDO));
            paymentSimulation.setBunga(pstPaymentSimulation.getdouble(COL_BUNGA));
            paymentSimulation.setAmount(pstPaymentSimulation.getdouble(COL_AMOUNT));
            paymentSimulation.setTotalAmount(pstPaymentSimulation.getdouble(COL_TOTAL_AMOUNT));
            paymentSimulation.setDueDate(pstPaymentSimulation.getDate(COL_DUE_DATE));
            paymentSimulation.setCustomerId(pstPaymentSimulation.getlong(COL_CUSTOMER_ID));
            paymentSimulation.setStatusGen(pstPaymentSimulation.getInt(COL_STATUS_GEN));
            paymentSimulation.setStatus(pstPaymentSimulation.getInt(COL_STATUS));
            paymentSimulation.setUserId(pstPaymentSimulation.getlong(COL_USER_ID));
            paymentSimulation.setPayment(pstPaymentSimulation.getInt(COL_PAYMENT));

            return paymentSimulation;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPaymentSimulation(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PaymentSimulation paymentSimulation) throws CONException {
        try {
            DbPaymentSimulation pstPaymentSimulation = new DbPaymentSimulation(0);

            pstPaymentSimulation.setLong(COL_SALES_DATA_ID, paymentSimulation.getSalesDataId());
            pstPaymentSimulation.setInt(COL_TYPE_PAYMENT, paymentSimulation.getTypePayment());
            pstPaymentSimulation.setString(COL_NAME, paymentSimulation.getName());
            pstPaymentSimulation.setDouble(COL_SALDO, paymentSimulation.getSaldo());
            pstPaymentSimulation.setDouble(COL_BUNGA, paymentSimulation.getBunga());
            pstPaymentSimulation.setDouble(COL_AMOUNT, paymentSimulation.getAmount());
            pstPaymentSimulation.setDouble(COL_TOTAL_AMOUNT, paymentSimulation.getTotalAmount());
            pstPaymentSimulation.setDate(COL_DUE_DATE, paymentSimulation.getDueDate());
            pstPaymentSimulation.setLong(COL_CUSTOMER_ID, paymentSimulation.getCustomerId());
            pstPaymentSimulation.setInt(COL_STATUS_GEN, paymentSimulation.getStatusGen());
            pstPaymentSimulation.setInt(COL_STATUS, paymentSimulation.getStatus());
            pstPaymentSimulation.setLong(COL_USER_ID, paymentSimulation.getUserId());
            pstPaymentSimulation.setInt(COL_PAYMENT, paymentSimulation.getPayment());

            pstPaymentSimulation.insert();
            paymentSimulation.setOID(pstPaymentSimulation.getlong(COL_PAYMENT_SIMULATION_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPaymentSimulation(0), CONException.UNKNOWN);
        }
        return paymentSimulation.getOID();
    }

    public static long updateExc(PaymentSimulation paymentSimulation) throws CONException {
        try {
            if (paymentSimulation.getOID() != 0) {
                DbPaymentSimulation pstPaymentSimulation = new DbPaymentSimulation(paymentSimulation.getOID());

                pstPaymentSimulation.setLong(COL_SALES_DATA_ID, paymentSimulation.getSalesDataId());
                pstPaymentSimulation.setInt(COL_TYPE_PAYMENT, paymentSimulation.getTypePayment());
                pstPaymentSimulation.setString(COL_NAME, paymentSimulation.getName());
                pstPaymentSimulation.setDouble(COL_SALDO, paymentSimulation.getSaldo());
                pstPaymentSimulation.setDouble(COL_BUNGA, paymentSimulation.getBunga());
                pstPaymentSimulation.setDouble(COL_AMOUNT, paymentSimulation.getAmount());
                pstPaymentSimulation.setDouble(COL_TOTAL_AMOUNT, paymentSimulation.getTotalAmount());
                pstPaymentSimulation.setDate(COL_DUE_DATE, paymentSimulation.getDueDate());
                pstPaymentSimulation.setLong(COL_CUSTOMER_ID, paymentSimulation.getCustomerId());
                pstPaymentSimulation.setInt(COL_STATUS_GEN, paymentSimulation.getStatusGen());
                pstPaymentSimulation.setInt(COL_STATUS, paymentSimulation.getStatus());
                pstPaymentSimulation.setLong(COL_USER_ID, paymentSimulation.getUserId());
                pstPaymentSimulation.setInt(COL_PAYMENT, paymentSimulation.getPayment());

                pstPaymentSimulation.update();
                return paymentSimulation.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPaymentSimulation(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPaymentSimulation pstLotTye = new DbPaymentSimulation(oid);
            pstLotTye.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPaymentSimulation(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PAYMENT_SIMULATION;
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
                PaymentSimulation paymentSimulation = new PaymentSimulation();
                resultToObject(rs, paymentSimulation);
                lists.add(paymentSimulation);
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

    private static void resultToObject(ResultSet rs, PaymentSimulation paymentSimulation) {
        try {

            paymentSimulation.setOID(rs.getLong(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT_SIMULATION_ID]));
            paymentSimulation.setSalesDataId(rs.getLong(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID]));
            paymentSimulation.setName(rs.getString(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_NAME]));
            paymentSimulation.setSaldo(rs.getDouble(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALDO]));
            paymentSimulation.setBunga(rs.getDouble(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_BUNGA]));
            paymentSimulation.setAmount(rs.getDouble(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_AMOUNT]));
            paymentSimulation.setTotalAmount(rs.getDouble(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TOTAL_AMOUNT]));
            paymentSimulation.setDueDate(rs.getDate(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]));
            paymentSimulation.setCustomerId(rs.getLong(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]));
            paymentSimulation.setStatusGen(rs.getInt(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS_GEN]));
            paymentSimulation.setTypePayment(rs.getInt(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]));
            paymentSimulation.setDueDate(rs.getDate(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]));
            paymentSimulation.setStatus(rs.getInt(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS]));
            paymentSimulation.setUserId(rs.getLong(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_USER_ID]));
            paymentSimulation.setPayment(rs.getInt(DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long paymentSimulationId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PAYMENT_SIMULATION + " WHERE " +
                    DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT_SIMULATION_ID] + " = " + paymentSimulationId;

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
            String sql = "SELECT COUNT(" + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT_SIMULATION_ID] + ") FROM " + DB_PAYMENT_SIMULATION;
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
                    PaymentSimulation paymentSimulation = (PaymentSimulation) list.get(ls);
                    if (oid == paymentSimulation.getOID()) {
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

    public static void deleteList(long salesDataId, int paymentType) {
        CONResultSet dbrs = null;
        try {

            String sql = "DELETE FROM " + DB_PAYMENT_SIMULATION + " where " + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID] + " = " + salesDataId + " and " +
                    DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT] + " = " + paymentType;
            int i = CONHandler.execUpdate(sql);

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static void deleteList(long salesDataId) {
        CONResultSet dbrs = null;
        try {

            String sql = "DELETE FROM " + DB_PAYMENT_SIMULATION + " where " + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID] + " = " + salesDataId;
            int i = CONHandler.execUpdate(sql);

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    
    public static void deleteListInv(long salesDataId, int paymentType) {
        CONResultSet dbrs = null;
        try {

            String sql = "DELETE FROM " + DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE  + " where " + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID] + " = " + salesDataId + " and " +
                    DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE] + " = " + paymentType;
            int i = CONHandler.execUpdate(sql);

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static void deleteListInv(long salesDataId) {
        CONResultSet dbrs = null;
        try {

            String sql = "DELETE FROM " + DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE  + " where " + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID] + " = " + salesDataId;
            int i = CONHandler.execUpdate(sql);

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public synchronized static void generateInv(PaymentSimulation ps, Date transDate,long currId) {
        try {

            Date dt = new Date();
            dt = transDate;
            SewaTanahInvoice sti = new SewaTanahInvoice();

            String formatDocCode = DbSystemDocNumber.getNumberPrefix(dt,DbSystemDocCode.TYPE_DOCUMENT_INV);
            int counter = DbSystemDocNumber.getNextCounter(dt,DbSystemDocCode.TYPE_DOCUMENT_INV);
            
            sti.setCounter(counter);
            sti.setPrefixNumber(formatDocCode);

            SystemDocNumber systemDocNumber = new SystemDocNumber();
            systemDocNumber.setCounter(counter);
            systemDocNumber.setDate(new Date());
            systemDocNumber.setPrefixNumber(formatDocCode);
            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV]);
            systemDocNumber.setYear(dt.getYear() + 1900);

            formatDocCode = DbSystemDocNumber.getNextNumber(sti.getCounter(),dt,DbSystemDocCode.TYPE_DOCUMENT_INV);
            systemDocNumber.setDocNumber(formatDocCode);
            sti.setNumber(formatDocCode);

            String memo = ps.getName();
            sti.setInvestorId(0);
            sti.setCurrencyId(currId);
            if(ps.getTypePayment() == DbSalesData.TYPE_KPA){
                sti.setJumlah(ps.getTotalAmount());
            }else{
                sti.setJumlah(ps.getAmount());
            }
            sti.setSaranaId(ps.getCustomerId());
            sti.setKeterangan(memo);
            sti.setTanggalInput(new Date());
            sti.setPaymentType(ps.getTypePayment());
            sti.setSalesDataId(ps.getSalesDataId());
            sti.setTanggal(ps.getDueDate());
            sti.setUserId(ps.getUserId());
            sti.setPaymentSimulationId(ps.getOID());
            sti.setStatus(DbSewaTanahInvoice.STATUS_PROP_DRAFT);
            
            try {
                long oid = DbSewaTanahInvoice.insertExc(sti);
                ps.setStatusGen(1);
                DbPaymentSimulation.updateExc(ps);
                if (oid != 0) {
                    try {
                        DbSystemDocNumber.insertExc(systemDocNumber);
                    } catch (Exception E) {
                        System.out.println("[exception] " + E.toString());
                    }
                }
            } catch (Exception e) {
            }

        } catch (Exception e) {
        }
    }
    
    
    public synchronized static void generateInv(PaymentSimulation ps, Date transDate,long currId, long createId) {
        try {

            Date dt = new Date();
            dt = transDate;
            SewaTanahInvoice sti = new SewaTanahInvoice();

            String formatDocCode = DbSystemDocNumber.getNumberPrefix(dt,DbSystemDocCode.TYPE_DOCUMENT_INV);
            int counter = DbSystemDocNumber.getNextCounter(dt,DbSystemDocCode.TYPE_DOCUMENT_INV);
            
            sti.setCounter(counter);
            sti.setPrefixNumber(formatDocCode);

            SystemDocNumber systemDocNumber = new SystemDocNumber();
            systemDocNumber.setCounter(counter);
            systemDocNumber.setDate(new Date());
            systemDocNumber.setPrefixNumber(formatDocCode);
            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV]);
            systemDocNumber.setYear(dt.getYear() + 1900);

            formatDocCode = DbSystemDocNumber.getNextNumber(sti.getCounter(),dt,DbSystemDocCode.TYPE_DOCUMENT_INV);
            systemDocNumber.setDocNumber(formatDocCode);
            sti.setNumber(formatDocCode);

            String memo = ps.getName();
            sti.setInvestorId(0);
            sti.setCurrencyId(currId);
            sti.setJumlah(ps.getAmount());           
            sti.setSaranaId(ps.getCustomerId());
            sti.setKeterangan(memo);
            sti.setTanggalInput(new Date());
            sti.setPaymentType(ps.getTypePayment());
            sti.setSalesDataId(ps.getSalesDataId());
            sti.setTanggal(ps.getDueDate());
            sti.setUserId(ps.getUserId());
            sti.setPaymentSimulationId(ps.getOID());
            sti.setStatus(DbSewaTanahInvoice.STATUS_PROP_DRAFT);
            sti.setCreateId(createId);
            sti.setCreateDate(new Date());
            
            try {
                long oid = DbSewaTanahInvoice.insertExc(sti);
                ps.setStatusGen(1);
                DbPaymentSimulation.updateExc(ps);
                if (oid != 0) {
                    try {
                        DbSystemDocNumber.insertExc(systemDocNumber);
                    } catch (Exception E) {
                        System.out.println("[exception] " + E.toString());
                    }
                }
            } catch (Exception e) {
            }

        } catch (Exception e) {
        }
    }
}
