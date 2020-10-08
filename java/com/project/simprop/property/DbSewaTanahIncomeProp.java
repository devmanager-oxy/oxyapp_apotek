
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */
package com.project.simprop.property;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*;
import com.project.crm.*;
import com.project.general.Currency;
import com.project.general.DbCurrency;
import com.project.payroll.DbDepartment;
import com.project.payroll.Department;
import com.project.system.DbSystemProperty;

public class DbSewaTanahIncomeProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PROP_SEWA_TANAH_INCOME = "prop_sewa_tanah_income";
    public static final int COL_SEWA_TANAH_INCOME_ID = 0;
    public static final int COL_SEWA_TANAH_INVOICE_ID = 1;
    public static final int COL_CURRENCY_ID = 2;
    public static final int COL_JUMLAH = 3;
    public static final int COL_STATUS = 4;
    public static final int COL_CREATED_BY_ID = 5;
    public static final int COL_POSTED_DATE = 6;
    public static final int COL_TANGGAL = 7;
    public static final int COL_COUNTER = 8;
    public static final int COL_PREFIX_NUMBER = 9;
    public static final int COL_NUMBER = 10;
    public static final int COL_POSTED_BY_ID = 11;
    public static final int COL_KETERANGAN = 12;
    public static final int COL_GL_ID = 13;
    public static final int COL_TYPE = 14;
    public static final int COL_TANGGAL_INPUT = 15;
    public static final int COL_INVESTOR_ID = 16;
    public static final int COL_SARANA_ID = 17;
    public static final String[] colNames = {
        "sewa_tanah_income_id",
        "sewa_tanah_invoice_id",
        "currency_id",
        "jumlah",
        "status",
        "created_by_id",
        "posted_date",
        "tanggal",
        "counter",
        "prefix_number",
        "number",
        "posted_by_id",
        "keterangan",
        "gl_id",
        "type",
        "tanggal_input",
        "investor_id",
        "sarana_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbSewaTanahIncomeProp() {
    }

    public DbSewaTanahIncomeProp(int i) throws CONException {
        super(new DbSewaTanahIncomeProp());
    }

    public DbSewaTanahIncomeProp(String sOid) throws CONException {
        super(new DbSewaTanahIncomeProp(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanahIncomeProp(long lOid) throws CONException {
        super(new DbSewaTanahIncomeProp(0));
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
        return DB_PROP_SEWA_TANAH_INCOME;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanahIncomeProp().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanahIncomeProp sewaTanahIncomeProp = fetchExc(ent.getOID());
        ent = (Entity) sewaTanahIncomeProp;
        return sewaTanahIncomeProp.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanahIncomeProp) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanahIncomeProp) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanahIncomeProp fetchExc(long oid) throws CONException {
        try {
            SewaTanahIncomeProp sewaTanahIncomeProp = new SewaTanahIncomeProp();
            DbSewaTanahIncomeProp pstSewaTanahIncome = new DbSewaTanahIncomeProp(oid);
            sewaTanahIncomeProp.setOID(oid);

            sewaTanahIncomeProp.setSewaTanahInvoiceId(pstSewaTanahIncome.getlong(COL_SEWA_TANAH_INVOICE_ID));
            sewaTanahIncomeProp.setCurrencyId(pstSewaTanahIncome.getlong(COL_CURRENCY_ID));
            sewaTanahIncomeProp.setJumlah(pstSewaTanahIncome.getdouble(COL_JUMLAH));
            sewaTanahIncomeProp.setStatus(pstSewaTanahIncome.getInt(COL_STATUS));
            sewaTanahIncomeProp.setCreatedById(pstSewaTanahIncome.getString(COL_CREATED_BY_ID));
            sewaTanahIncomeProp.setPostedDate(pstSewaTanahIncome.getDate(COL_POSTED_DATE));
            sewaTanahIncomeProp.setTanggal(pstSewaTanahIncome.getDate(COL_TANGGAL));
            sewaTanahIncomeProp.setCounter(pstSewaTanahIncome.getInt(COL_COUNTER));
            sewaTanahIncomeProp.setPrefixNumber(pstSewaTanahIncome.getString(COL_PREFIX_NUMBER));
            sewaTanahIncomeProp.setNumber(pstSewaTanahIncome.getString(COL_NUMBER));
            sewaTanahIncomeProp.setPostedById(pstSewaTanahIncome.getlong(COL_POSTED_BY_ID));
            sewaTanahIncomeProp.setKeterangan(pstSewaTanahIncome.getString(COL_KETERANGAN));
            sewaTanahIncomeProp.setGlId(pstSewaTanahIncome.getlong(COL_GL_ID));
            sewaTanahIncomeProp.setType(pstSewaTanahIncome.getInt(COL_TYPE));
            sewaTanahIncomeProp.setTanggalInput(pstSewaTanahIncome.getDate(COL_TANGGAL_INPUT));
            sewaTanahIncomeProp.setInvestorId(pstSewaTanahIncome.getlong(COL_INVESTOR_ID));
            sewaTanahIncomeProp.setSaranaId(pstSewaTanahIncome.getlong(COL_SARANA_ID));

            return sewaTanahIncomeProp;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahIncomeProp(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanahIncomeProp sewaTanahIncomeProp) throws CONException {
        try {
            DbSewaTanahIncomeProp pstSewaTanahIncome = new DbSewaTanahIncomeProp(0);

            pstSewaTanahIncome.setLong(COL_SEWA_TANAH_INVOICE_ID, sewaTanahIncomeProp.getSewaTanahInvoiceId());
            pstSewaTanahIncome.setLong(COL_CURRENCY_ID, sewaTanahIncomeProp.getCurrencyId());
            pstSewaTanahIncome.setDouble(COL_JUMLAH, sewaTanahIncomeProp.getJumlah());
            pstSewaTanahIncome.setInt(COL_STATUS, sewaTanahIncomeProp.getStatus());
            pstSewaTanahIncome.setString(COL_CREATED_BY_ID, sewaTanahIncomeProp.getCreatedById());
            pstSewaTanahIncome.setDate(COL_POSTED_DATE, sewaTanahIncomeProp.getPostedDate());
            pstSewaTanahIncome.setDate(COL_TANGGAL, sewaTanahIncomeProp.getTanggal());
            pstSewaTanahIncome.setInt(COL_COUNTER, sewaTanahIncomeProp.getCounter());
            pstSewaTanahIncome.setString(COL_PREFIX_NUMBER, sewaTanahIncomeProp.getPrefixNumber());
            pstSewaTanahIncome.setString(COL_NUMBER, sewaTanahIncomeProp.getNumber());
            pstSewaTanahIncome.setLong(COL_POSTED_BY_ID, sewaTanahIncomeProp.getPostedById());
            pstSewaTanahIncome.setString(COL_KETERANGAN, sewaTanahIncomeProp.getKeterangan());
            pstSewaTanahIncome.setLong(COL_GL_ID, sewaTanahIncomeProp.getGlId());
            pstSewaTanahIncome.setInt(COL_TYPE, sewaTanahIncomeProp.getType());
            pstSewaTanahIncome.setDate(COL_TANGGAL_INPUT, sewaTanahIncomeProp.getTanggalInput());
            pstSewaTanahIncome.setLong(COL_INVESTOR_ID, sewaTanahIncomeProp.getInvestorId());
            pstSewaTanahIncome.setLong(COL_SARANA_ID, sewaTanahIncomeProp.getSaranaId());

            pstSewaTanahIncome.insert();
            sewaTanahIncomeProp.setOID(pstSewaTanahIncome.getlong(COL_SEWA_TANAH_INCOME_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahIncomeProp(0), CONException.UNKNOWN);
        }
        return sewaTanahIncomeProp.getOID();
    }

    public static long updateExc(SewaTanahIncomeProp sewaTanahIncomeProp) throws CONException {
        try {
            if (sewaTanahIncomeProp.getOID() != 0) {
                DbSewaTanahIncomeProp pstSewaTanahIncome = new DbSewaTanahIncomeProp(sewaTanahIncomeProp.getOID());

                pstSewaTanahIncome.setLong(COL_SEWA_TANAH_INVOICE_ID, sewaTanahIncomeProp.getSewaTanahInvoiceId());
                pstSewaTanahIncome.setLong(COL_CURRENCY_ID, sewaTanahIncomeProp.getCurrencyId());
                pstSewaTanahIncome.setDouble(COL_JUMLAH, sewaTanahIncomeProp.getJumlah());
                pstSewaTanahIncome.setInt(COL_STATUS, sewaTanahIncomeProp.getStatus());
                pstSewaTanahIncome.setString(COL_CREATED_BY_ID, sewaTanahIncomeProp.getCreatedById());
                pstSewaTanahIncome.setDate(COL_POSTED_DATE, sewaTanahIncomeProp.getPostedDate());
                pstSewaTanahIncome.setDate(COL_TANGGAL, sewaTanahIncomeProp.getTanggal());
                pstSewaTanahIncome.setInt(COL_COUNTER, sewaTanahIncomeProp.getCounter());
                pstSewaTanahIncome.setString(COL_PREFIX_NUMBER, sewaTanahIncomeProp.getPrefixNumber());
                pstSewaTanahIncome.setString(COL_NUMBER, sewaTanahIncomeProp.getNumber());
                pstSewaTanahIncome.setLong(COL_POSTED_BY_ID, sewaTanahIncomeProp.getPostedById());
                pstSewaTanahIncome.setString(COL_KETERANGAN, sewaTanahIncomeProp.getKeterangan());
                pstSewaTanahIncome.setLong(COL_GL_ID, sewaTanahIncomeProp.getGlId());
                pstSewaTanahIncome.setInt(COL_TYPE, sewaTanahIncomeProp.getType());
                pstSewaTanahIncome.setDate(COL_TANGGAL_INPUT, sewaTanahIncomeProp.getTanggalInput());
                pstSewaTanahIncome.setLong(COL_INVESTOR_ID, sewaTanahIncomeProp.getInvestorId());
                pstSewaTanahIncome.setLong(COL_SARANA_ID, sewaTanahIncomeProp.getSaranaId());

                pstSewaTanahIncome.update();
                return sewaTanahIncomeProp.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahIncomeProp(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanahIncomeProp pstSewaTanahIncome = new DbSewaTanahIncomeProp(oid);
            pstSewaTanahIncome.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahIncomeProp(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_INCOME;
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
                SewaTanahIncomeProp sewaTanahIncomeProp = new SewaTanahIncomeProp();
                resultToObject(rs, sewaTanahIncomeProp);
                lists.add(sewaTanahIncomeProp);
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

    private static void resultToObject(ResultSet rs, SewaTanahIncomeProp sewaTanahIncomeProp) {
        try {
            sewaTanahIncomeProp.setOID(rs.getLong(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_SEWA_TANAH_INCOME_ID]));
            sewaTanahIncomeProp.setSewaTanahInvoiceId(rs.getLong(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_SEWA_TANAH_INVOICE_ID]));
            sewaTanahIncomeProp.setCurrencyId(rs.getLong(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_CURRENCY_ID]));
            sewaTanahIncomeProp.setJumlah(rs.getDouble(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_JUMLAH]));
            sewaTanahIncomeProp.setStatus(rs.getInt(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_STATUS]));
            sewaTanahIncomeProp.setCreatedById(rs.getString(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_CREATED_BY_ID]));
            sewaTanahIncomeProp.setPostedDate(rs.getDate(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_POSTED_DATE]));
            sewaTanahIncomeProp.setTanggal(rs.getDate(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_TANGGAL]));
            sewaTanahIncomeProp.setCounter(rs.getInt(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_COUNTER]));
            sewaTanahIncomeProp.setPrefixNumber(rs.getString(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_PREFIX_NUMBER]));
            sewaTanahIncomeProp.setNumber(rs.getString(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_NUMBER]));
            sewaTanahIncomeProp.setPostedById(rs.getLong(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_POSTED_BY_ID]));
            sewaTanahIncomeProp.setKeterangan(rs.getString(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_KETERANGAN]));
            sewaTanahIncomeProp.setGlId(rs.getLong(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_GL_ID]));
            sewaTanahIncomeProp.setType(rs.getInt(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_TYPE]));
            sewaTanahIncomeProp.setTanggalInput(rs.getDate(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_TANGGAL_INPUT]));
            sewaTanahIncomeProp.setInvestorId(rs.getLong(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_INVESTOR_ID]));
            sewaTanahIncomeProp.setSaranaId(rs.getLong(DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_SARANA_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahIncomeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_INCOME + " WHERE " +
                    DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_SEWA_TANAH_INCOME_ID] + " = " + sewaTanahIncomeId;

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
            String sql = "SELECT COUNT(" + DbSewaTanahIncomeProp.colNames[DbSewaTanahIncomeProp.COL_SEWA_TANAH_INCOME_ID] + ") FROM " + DB_PROP_SEWA_TANAH_INCOME;
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
                    SewaTanahIncomeProp sewaTanahIncomeProp = (SewaTanahIncomeProp) list.get(ls);
                    if (oid == sewaTanahIncomeProp.getOID()) {
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

    public static void insertIncome(SewaTanahInvoiceProp sewatanahinvoiceprop) {

        Date dt = sewatanahinvoiceprop.getJatuhTempo();
        int i = dt.getMonth();

        //insert pendapatan bulanan
        for (int x = 0; x < sewatanahinvoiceprop.getJmlBulan(); x++) {

            SewaTanahIncomeProp sewaTanahIncomeProp = new SewaTanahIncomeProp();

            Date dtx = new Date();
            dtx.setMonth(i + x);

            System.out.println("i = " + x + ", tanggal : " + dtx);

            sewaTanahIncomeProp.setTanggal(dtx);
            sewaTanahIncomeProp.setTanggalInput(new Date());
            sewaTanahIncomeProp.setSewaTanahInvoiceId(sewatanahinvoiceprop.getOID());
            sewaTanahIncomeProp.setCurrencyId(sewatanahinvoiceprop.getCurrencyId());
            sewaTanahIncomeProp.setJumlah((sewatanahinvoiceprop.getJumlah() - sewatanahinvoiceprop.getPpn()) / sewatanahinvoiceprop.getJmlBulan());
            sewaTanahIncomeProp.setStatus(I_Crm.JURNAL_STATUS_NOT_POSTED);
            sewaTanahIncomeProp.setNumber(sewatanahinvoiceprop.getNumber() + "-INC" + (x + 1));

            Customer sarana = new Customer();
            try {
                sarana = DbCustomer.fetchExc(sewatanahinvoiceprop.getSaranaId());
            } catch (Exception e) {
            }

            String ket = "Income Bulan " + JSPFormater.formatDate(sewaTanahIncomeProp.getTanggal(), "MMMM yyyy");
            if (sewatanahinvoiceprop.getType() == DbSewaTanahInvoiceProp.TYPE_INV_ASSESMENT) {
                ket = ket + " Assesment, " + sarana.getName();
            } else if (sewatanahinvoiceprop.getType() == DbSewaTanahInvoiceProp.TYPE_INV_KOMIN) {
                ket = ket + " Kompensasi Minimum, " + sarana.getName();
            }

            sewaTanahIncomeProp.setKeterangan(ket);
            sewaTanahIncomeProp.setType(sewatanahinvoiceprop.getType());
            sewaTanahIncomeProp.setInvestorId(sewatanahinvoiceprop.getInvestorId());
            sewaTanahIncomeProp.setSaranaId(sewatanahinvoiceprop.getSaranaId());

            try {
                DbSewaTanahIncomeProp.insertExc(sewaTanahIncomeProp);
            } catch (Exception e) {
            }
        }

    }

    public static void insertIncomeKomper(SewaTanahBenefitProp sewatanahbenefitProp) {

        SewaTanahInvoiceProp sewatanahinvoiceprop = new SewaTanahInvoiceProp();
        try {
            sewatanahinvoiceprop = DbSewaTanahInvoiceProp.fetchExc(sewatanahbenefitProp.getSewaTanahInvoiceId());
        } catch (Exception e) {

        }

        Date dt = sewatanahinvoiceprop.getTanggal();
        int i = dt.getMonth();
        //dt.setMonth(x+1+dt.getMonth());

        //insert pendapatan bulanan
        for (int x = 0; x < sewatanahinvoiceprop.getJmlBulan(); x++) {

            SewaTanahIncomeProp sewaTanahIncomeProp = new SewaTanahIncomeProp();

            Date dtx = new Date();
            dtx.setMonth(i + x);

            System.out.println("i = " + x + ", tanggal : " + dtx);

            sewaTanahIncomeProp.setTanggal(dtx);
            sewaTanahIncomeProp.setTanggalInput(new Date());
            sewaTanahIncomeProp.setSewaTanahInvoiceId(sewatanahbenefitProp.getOID());
            sewaTanahIncomeProp.setCurrencyId(sewatanahinvoiceprop.getCurrencyId());
            sewaTanahIncomeProp.setJumlah((sewatanahbenefitProp.getTotalKomper() - sewatanahbenefitProp.getPpn()) / sewatanahinvoiceprop.getJmlBulan());
            sewaTanahIncomeProp.setStatus(I_Crm.JURNAL_STATUS_NOT_POSTED);          
            sewaTanahIncomeProp.setNumber(sewatanahbenefitProp.getNumber() + "-INC" + (x + 1));

            Customer sarana = new Customer();
            try {
                sarana = DbCustomer.fetchExc(sewatanahinvoiceprop.getSaranaId());
            } catch (Exception e) {
            }

            String ket = "Income Bulan " + JSPFormater.formatDate(sewaTanahIncomeProp.getTanggal(), "MMMM yyyy");
            ket = ket + " Kompensasi Persentase, " + sarana.getName();

            sewaTanahIncomeProp.setKeterangan(ket);            
            sewaTanahIncomeProp.setType(DbSewaTanahInvoiceProp.TYPE_INV_KOMPER);            
            sewaTanahIncomeProp.setInvestorId(sewatanahinvoiceprop.getInvestorId());
            sewaTanahIncomeProp.setSaranaId(sewatanahinvoiceprop.getSaranaId());

            try {
                DbSewaTanahIncomeProp.insertExc(sewaTanahIncomeProp);
            } catch (Exception e) {
            }
        }

    }

    public static boolean postJournal(SewaTanahIncomeProp sewaTanahIncome) {

        boolean ok = true;

        if (sewaTanahIncome.getType() == DbSewaTanahInvoiceProp.TYPE_INV_KOMIN) {
            ok = postJournalKomin(sewaTanahIncome);
        } else if (sewaTanahIncome.getType() == DbSewaTanahInvoiceProp.TYPE_INV_ASSESMENT) {
            ok = postJournalAssesment(sewaTanahIncome);
        } else {
            ok = postJournalKomper(sewaTanahIncome);
        }

        return ok;

    }

    //journal balik pendapatan yang diterima dimuka ke pendapatan
    public static boolean postJournalKomin(SewaTanahIncomeProp sewaTanahIncome) {
        
        //Set Department ID
        long departmentId = 0;
        try {
            String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
            if(ID_DEPARTMENT.equals("Not initialized")) {
                return false;
            } else {
                departmentId = Long.parseLong(ID_DEPARTMENT);
                Department d = DbDepartment.fetchExc(departmentId);
                if(d.getOID() == 0) return false;
            }
        } catch(Exception e) {
            System.out.println(e.toString());
            return false;
        }

        boolean ok = true;

        System.out.println("\n---- bean start posting journal balik income ---");

        Company comp = DbCompany.getCompany();

        //IrigasiTransaction limbah = cr;//new IrigasiTransaction();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanahIncome.getSaranaId());
        } catch (Exception e) {
        }

        //if (cus.getOID() == 0 || cus.getKominCreditAccountId() == 0 || cus.getKominCreditIncomeAccountId() == 0) {

        //    return false;            

        //}

        String memo = sewaTanahIncome.getKeterangan();

        //jika sarana mamakai limbahgasi	                           
        if (true) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), 0, sewaTanahIncome.getNumber(), sewaTanahIncome.getNumber(),
                    I_Project.JOURNAL_TYPE_SALES,
                    memo, 0, "", sewaTanahIncome.getOID(), "", sewaTanahIncome.getTanggal());

            //pengakuan piutang
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double excRate = 0;
                if (sewaTanahIncome.getCurrencyId() == comp.getBookingCurrencyId()) {
                    excRate = 1;
                } else {
                    ExchangeRate erate = DbExchangeRate.getStandardRate();
                    excRate = erate.getValueUsd();
                }

                //journal debet piutang
                //double harga = sewaTanahIncome.getJumlah()+sewaTanahIncome.getPpn()+sewaTanahIncome.getPph();
                //piutang

                Currency c = new Currency();
                try {
                    c = DbCurrency.fetchExc(sewaTanahIncome.getCurrencyId());
                } catch (Exception e) {
                }

                String detailMemo = memo + ", " + c.getCurrencyCode() + " " + JSPFormater.formatNumber(sewaTanahIncome.getJumlah(), "#,###.##") +
                        ", ExcRate : " + JSPFormater.formatNumber(excRate, "#,###.##");

                /*DbGl.postJournalDetail(excRate, cus.getKominCreditAccountId(), 0, sewaTanahIncome.getJumlah() * excRate,
                        sewaTanahIncome.getJumlah(), sewaTanahIncome.getCurrencyId(), oid, detailMemo, departmentId);//non departmenttal item, department id = 0

                DbGl.postJournalDetail(excRate, cus.getKominCreditIncomeAccountId(), sewaTanahIncome.getJumlah() * excRate, 0,
                        sewaTanahIncome.getJumlah(), sewaTanahIncome.getCurrencyId(), oid, detailMemo, departmentId);//non departmenttal item, department id = 0
                */        
                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahIncome.setStatus(I_Crm.JURNAL_STATUS_POSTED);
                    DbSewaTanahIncomeProp.updateExc(sewaTanahIncome);
                } catch (Exception e) {
                    
                }


            } else {
                ok = false;
            }

        } else {
            ok = false;
        }

        return ok;

    }

    //journal balik pendapatan yang diterima dimuka ke pendapatan
    public static boolean postJournalAssesment(SewaTanahIncomeProp sewaTanahIncome) {
        
        //Set Department ID
        long departmentId = 0;
        try {
            String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
            if(ID_DEPARTMENT.equals("Not initialized")) {
                return false;
            } else {
                departmentId = Long.parseLong(ID_DEPARTMENT);
                Department d = DbDepartment.fetchExc(departmentId);
                if(d.getOID() == 0) return false;
            }
        } catch(Exception e) {
            System.out.println(e.toString());
            return false;
        }

        boolean ok = true;

        System.out.println("\n---- bean start posting journal balik income ---");

        Company comp = DbCompany.getCompany();

        //IrigasiTransaction limbah = cr;//new IrigasiTransaction();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanahIncome.getSaranaId());
        } catch (Exception e) {
        }

        

        String memo = sewaTanahIncome.getKeterangan();

        //jika sarana mamakai limbahgasi	                           
        if (true) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), 0, sewaTanahIncome.getNumber(), sewaTanahIncome.getNumber(),
                    I_Project.JOURNAL_TYPE_SALES,
                    memo, 0, "", sewaTanahIncome.getOID(), "", sewaTanahIncome.getTanggal());

            //pengakuan piutang
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double excRate = 0;
                if (sewaTanahIncome.getCurrencyId() == comp.getBookingCurrencyId()) {
                    excRate = 1;
                } else {
                    ExchangeRate erate = DbExchangeRate.getStandardRate();
                    excRate = erate.getValueUsd();
                }

                //journal debet piutang
                //double harga = sewaTanahIncome.getJumlah()+sewaTanahIncome.getPpn()+sewaTanahIncome.getPph();
                //piutang

                Currency c = new Currency();
                try {
                    c = DbCurrency.fetchExc(sewaTanahIncome.getCurrencyId());
                } catch (Exception e) {
                }

                String detailMemo = memo + ", " + c.getCurrencyCode() + " " + JSPFormater.formatNumber(sewaTanahIncome.getJumlah(), "#,###.##") +
                        ", ExcRate : " + JSPFormater.formatNumber(excRate, "#,###.##");

                /*DbGl.postJournalDetail(excRate, cus.getAssesmentCreditAccountId(), 0, sewaTanahIncome.getJumlah() * excRate,
                        sewaTanahIncome.getJumlah(), sewaTanahIncome.getCurrencyId(), oid, detailMemo, departmentId);//non departmenttal item, department id = 0

                DbGl.postJournalDetail(excRate, cus.getAssesmentCreditIncomeAccountId(), sewaTanahIncome.getJumlah() * excRate, 0,
                        sewaTanahIncome.getJumlah(), sewaTanahIncome.getCurrencyId(), oid, detailMemo, departmentId);//non departmenttal item, department id = 0
                */        
                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahIncome.setStatus(I_Crm.JURNAL_STATUS_POSTED);
                    DbSewaTanahIncomeProp.updateExc(sewaTanahIncome);
                } catch (Exception e) {

                }


            } else {
                ok = false;
            }

        } else {
            ok = false;
        }

        return ok;

    }

    //journal balik pendapatan yang diterima dimuka ke pendapatan
    public static boolean postJournalKomper(SewaTanahIncomeProp sewaTanahIncome) {
        
        //Set Department ID
        long departmentId = 0;
        try {
            String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
            if(ID_DEPARTMENT.equals("Not initialized")) {
                return false;
            } else {
                departmentId = Long.parseLong(ID_DEPARTMENT);
                Department d = DbDepartment.fetchExc(departmentId);
                if(d.getOID() == 0) return false;
            }
        } catch(Exception e) {
            System.out.println(e.toString());
            return false;
        }

        boolean ok = true;

        System.out.println("\n---- bean start posting journal balik income ---");

        Company comp = DbCompany.getCompany();

        //IrigasiTransaction limbah = cr;//new IrigasiTransaction();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanahIncome.getSaranaId());
        } catch (Exception e) {
        }

      

        String memo = sewaTanahIncome.getKeterangan();

        //jika sarana mamakai limbahgasi	                           
        if (true) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), 0, sewaTanahIncome.getNumber(), sewaTanahIncome.getNumber(),
                    I_Project.JOURNAL_TYPE_SALES,
                    memo, 0, "", sewaTanahIncome.getOID(), "", sewaTanahIncome.getTanggal());

            //pengakuan piutang
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double excRate = 0;
                if (sewaTanahIncome.getCurrencyId() == comp.getBookingCurrencyId()) {
                    excRate = 1;
                } else {
                    ExchangeRate erate = DbExchangeRate.getStandardRate();
                    excRate = erate.getValueUsd();
                }

                //journal debet piutang
                //double harga = sewaTanahIncome.getJumlah()+sewaTanahIncome.getPpn()+sewaTanahIncome.getPph();
                //piutang

                Currency c = new Currency();
                try {
                    c = DbCurrency.fetchExc(sewaTanahIncome.getCurrencyId());
                } catch (Exception e) {
                }

                String detailMemo = memo + ", " + c.getCurrencyCode() + " " + JSPFormater.formatNumber(sewaTanahIncome.getJumlah(), "#,###.##") +
                        ", ExcRate : " + JSPFormater.formatNumber(excRate, "#,###.##");

                /*DbGl.postJournalDetail(excRate, cus.getKompenCreditAccountId(), 0, sewaTanahIncome.getJumlah() * excRate,
                        sewaTanahIncome.getJumlah(), sewaTanahIncome.getCurrencyId(), oid, detailMemo, departmentId);//non departmenttal item, department id = 0

                DbGl.postJournalDetail(excRate, cus.getKompenCreditIncomeAccountId(), sewaTanahIncome.getJumlah() * excRate, 0,
                        sewaTanahIncome.getJumlah(), sewaTanahIncome.getCurrencyId(), oid, detailMemo, departmentId);//non departmenttal item, department id = 0
                        */
                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahIncome.setStatus(I_Crm.JURNAL_STATUS_POSTED);
                    DbSewaTanahIncomeProp.updateExc(sewaTanahIncome);
                } catch (Exception e) {

                }


            } else {
                ok = false;
            }

        } else {
            ok = false;
        }

        return ok;

    }
}
