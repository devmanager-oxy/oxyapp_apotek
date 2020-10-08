package com.project.fms.master;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.*;
import com.project.util.lang.*;

public class DbPaymentMethod extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PAYMENT_METHOD = "payment_method";
    public static final int COL_PAYMENT_METHOD_ID = 0;
    public static final int COL_DESCRIPTION = 1;
    public static final int COL_POS_CODE = 2;
    public static final int COL_STATUS = 3;
    public static final int COL_ORDER = 4;
    public static final int COL_MERCHANT_PAYMENT = 5;
    public static final int COL_MERCHANT_TYPE = 6;
    public static final int COL_AP_STATUS = 7;
    public static final int COL_SEGMENT1_ID = 8;
    public static final String[] colNames = {
        "payment_method_id",
        "description",
        "pos_code",
        "status",
        "sort_order",
        "merchant_payment",
        "merchant_type",
        "ap_status",
        "segment1_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG
    };
    public static final int STATUS_AKTIF = 0;
    public static final int STATUS_NON_AKTIF = 1;

    public DbPaymentMethod() {
    }

    public DbPaymentMethod(int i) throws CONException {
        super(new DbPaymentMethod());
    }

    public DbPaymentMethod(String sOid) throws CONException {
        super(new DbPaymentMethod(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPaymentMethod(long lOid) throws CONException {
        super(new DbPaymentMethod(0));
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
        return DB_PAYMENT_METHOD;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPaymentMethod().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PaymentMethod paymentmethod = fetchExc(ent.getOID());
        ent = (Entity) paymentmethod;
        return paymentmethod.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PaymentMethod) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PaymentMethod) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PaymentMethod fetchExc(long oid) throws CONException {
        try {
            PaymentMethod paymentmethod = new PaymentMethod();
            DbPaymentMethod pstPaymentMethod = new DbPaymentMethod(oid);
            paymentmethod.setOID(oid);

            paymentmethod.setDescription(pstPaymentMethod.getString(COL_DESCRIPTION));

            paymentmethod.setPosCode(pstPaymentMethod.getInt(COL_POS_CODE));
            paymentmethod.setStatus(pstPaymentMethod.getInt(COL_STATUS));
            paymentmethod.setOrder(pstPaymentMethod.getInt(COL_ORDER));
            paymentmethod.setMerchantPayment(pstPaymentMethod.getInt(COL_MERCHANT_PAYMENT));
            paymentmethod.setMerchantType(pstPaymentMethod.getInt(COL_MERCHANT_TYPE));
            paymentmethod.setApStatus(pstPaymentMethod.getInt(COL_AP_STATUS));
            paymentmethod.setSegment1Id(pstPaymentMethod.getlong(COL_SEGMENT1_ID));

            return paymentmethod;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPaymentMethod(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PaymentMethod paymentmethod) throws CONException {
        try {
            DbPaymentMethod pstPaymentMethod = new DbPaymentMethod(0);

            pstPaymentMethod.setString(COL_DESCRIPTION, paymentmethod.getDescription());
            pstPaymentMethod.setInt(COL_POS_CODE, paymentmethod.getPosCode());
            pstPaymentMethod.setInt(COL_STATUS, paymentmethod.getStatus());
            pstPaymentMethod.setInt(COL_ORDER, paymentmethod.getOrder());
            pstPaymentMethod.setInt(COL_MERCHANT_PAYMENT, paymentmethod.getMerchantPayment());
            pstPaymentMethod.setInt(COL_MERCHANT_TYPE, paymentmethod.getMerchantType());
            pstPaymentMethod.setInt(COL_AP_STATUS, paymentmethod.getApStatus());
            pstPaymentMethod.setLong(COL_SEGMENT1_ID, paymentmethod.getSegment1Id());

            pstPaymentMethod.insert();
            paymentmethod.setOID(pstPaymentMethod.getlong(COL_PAYMENT_METHOD_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPaymentMethod(0), CONException.UNKNOWN);
        }
        return paymentmethod.getOID();
    }

    public static long updateExc(PaymentMethod paymentmethod) throws CONException {
        try {
            if (paymentmethod.getOID() != 0) {
                DbPaymentMethod pstPaymentMethod = new DbPaymentMethod(paymentmethod.getOID());

                pstPaymentMethod.setString(COL_DESCRIPTION, paymentmethod.getDescription());
                pstPaymentMethod.setInt(COL_POS_CODE, paymentmethod.getPosCode());
                pstPaymentMethod.setInt(COL_STATUS, paymentmethod.getStatus());
                pstPaymentMethod.setInt(COL_ORDER, paymentmethod.getOrder());
                pstPaymentMethod.setInt(COL_MERCHANT_PAYMENT, paymentmethod.getMerchantPayment());
                pstPaymentMethod.setInt(COL_MERCHANT_TYPE, paymentmethod.getMerchantType());
                pstPaymentMethod.setInt(COL_AP_STATUS, paymentmethod.getApStatus());
                pstPaymentMethod.setLong(COL_SEGMENT1_ID, paymentmethod.getSegment1Id());

                pstPaymentMethod.update();
                return paymentmethod.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPaymentMethod(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPaymentMethod pstPaymentMethod = new DbPaymentMethod(oid);
            pstPaymentMethod.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPaymentMethod(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PAYMENT_METHOD;
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
                PaymentMethod paymentmethod = new PaymentMethod();
                resultToObject(rs, paymentmethod);
                lists.add(paymentmethod);
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

    private static void resultToObject(ResultSet rs, PaymentMethod paymentmethod) {
        try {
            paymentmethod.setOID(rs.getLong(DbPaymentMethod.colNames[DbPaymentMethod.COL_PAYMENT_METHOD_ID]));
            paymentmethod.setDescription(rs.getString(DbPaymentMethod.colNames[DbPaymentMethod.COL_DESCRIPTION]));

            paymentmethod.setPosCode(rs.getInt(DbPaymentMethod.colNames[DbPaymentMethod.COL_POS_CODE]));
            paymentmethod.setStatus(rs.getInt(DbPaymentMethod.colNames[DbPaymentMethod.COL_STATUS]));
            paymentmethod.setOrder(rs.getInt(DbPaymentMethod.colNames[DbPaymentMethod.COL_ORDER]));
            paymentmethod.setMerchantPayment(rs.getInt(DbPaymentMethod.colNames[DbPaymentMethod.COL_MERCHANT_PAYMENT]));
            paymentmethod.setMerchantType(rs.getInt(DbPaymentMethod.colNames[DbPaymentMethod.COL_MERCHANT_TYPE]));
            paymentmethod.setApStatus(rs.getInt(DbPaymentMethod.colNames[DbPaymentMethod.COL_AP_STATUS]));
            paymentmethod.setSegment1Id(rs.getLong(DbPaymentMethod.colNames[DbPaymentMethod.COL_SEGMENT1_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long paymentMethodId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PAYMENT_METHOD + " WHERE " +
                    DbPaymentMethod.colNames[DbPaymentMethod.COL_PAYMENT_METHOD_ID] + " = " + paymentMethodId;

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
            String sql = "SELECT COUNT(" + DbPaymentMethod.colNames[DbPaymentMethod.COL_PAYMENT_METHOD_ID] + ") FROM " + DB_PAYMENT_METHOD;
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
                    PaymentMethod paymentmethod = (PaymentMethod) list.get(ls);
                    if (oid == paymentmethod.getOID()) {
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
