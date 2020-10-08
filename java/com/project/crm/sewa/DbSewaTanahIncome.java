
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */
package com.project.crm.sewa;

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

public class DbSewaTanahIncome extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CRM_SEWA_TANAH_INCOME = "crm_sewa_tanah_income";
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

    public DbSewaTanahIncome() {
    }

    public DbSewaTanahIncome(int i) throws CONException {
        super(new DbSewaTanahIncome());
    }

    public DbSewaTanahIncome(String sOid) throws CONException {
        super(new DbSewaTanahIncome(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanahIncome(long lOid) throws CONException {
        super(new DbSewaTanahIncome(0));
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
        return DB_CRM_SEWA_TANAH_INCOME;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanahIncome().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanahIncome sewatanahincome = fetchExc(ent.getOID());
        ent = (Entity) sewatanahincome;
        return sewatanahincome.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanahIncome) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanahIncome) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanahIncome fetchExc(long oid) throws CONException {
        try {
            SewaTanahIncome sewatanahincome = new SewaTanahIncome();
            DbSewaTanahIncome pstSewaTanahIncome = new DbSewaTanahIncome(oid);
            sewatanahincome.setOID(oid);

            sewatanahincome.setSewaTanahInvoiceId(pstSewaTanahIncome.getlong(COL_SEWA_TANAH_INVOICE_ID));
            sewatanahincome.setCurrencyId(pstSewaTanahIncome.getlong(COL_CURRENCY_ID));
            sewatanahincome.setJumlah(pstSewaTanahIncome.getdouble(COL_JUMLAH));
            sewatanahincome.setStatus(pstSewaTanahIncome.getInt(COL_STATUS));
            sewatanahincome.setCreatedById(pstSewaTanahIncome.getString(COL_CREATED_BY_ID));
            sewatanahincome.setPostedDate(pstSewaTanahIncome.getDate(COL_POSTED_DATE));
            sewatanahincome.setTanggal(pstSewaTanahIncome.getDate(COL_TANGGAL));
            sewatanahincome.setCounter(pstSewaTanahIncome.getInt(COL_COUNTER));
            sewatanahincome.setPrefixNumber(pstSewaTanahIncome.getString(COL_PREFIX_NUMBER));
            sewatanahincome.setNumber(pstSewaTanahIncome.getString(COL_NUMBER));
            sewatanahincome.setPostedById(pstSewaTanahIncome.getlong(COL_POSTED_BY_ID));
            sewatanahincome.setKeterangan(pstSewaTanahIncome.getString(COL_KETERANGAN));
            sewatanahincome.setGlId(pstSewaTanahIncome.getlong(COL_GL_ID));
            sewatanahincome.setType(pstSewaTanahIncome.getInt(COL_TYPE));
            sewatanahincome.setTanggalInput(pstSewaTanahIncome.getDate(COL_TANGGAL_INPUT));
            sewatanahincome.setInvestorId(pstSewaTanahIncome.getlong(COL_INVESTOR_ID));
            sewatanahincome.setSaranaId(pstSewaTanahIncome.getlong(COL_SARANA_ID));

            return sewatanahincome;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahIncome(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanahIncome sewatanahincome) throws CONException {
        try {
            DbSewaTanahIncome pstSewaTanahIncome = new DbSewaTanahIncome(0);

            pstSewaTanahIncome.setLong(COL_SEWA_TANAH_INVOICE_ID, sewatanahincome.getSewaTanahInvoiceId());
            pstSewaTanahIncome.setLong(COL_CURRENCY_ID, sewatanahincome.getCurrencyId());
            pstSewaTanahIncome.setDouble(COL_JUMLAH, sewatanahincome.getJumlah());
            pstSewaTanahIncome.setInt(COL_STATUS, sewatanahincome.getStatus());
            pstSewaTanahIncome.setString(COL_CREATED_BY_ID, sewatanahincome.getCreatedById());
            pstSewaTanahIncome.setDate(COL_POSTED_DATE, sewatanahincome.getPostedDate());
            pstSewaTanahIncome.setDate(COL_TANGGAL, sewatanahincome.getTanggal());
            pstSewaTanahIncome.setInt(COL_COUNTER, sewatanahincome.getCounter());
            pstSewaTanahIncome.setString(COL_PREFIX_NUMBER, sewatanahincome.getPrefixNumber());
            pstSewaTanahIncome.setString(COL_NUMBER, sewatanahincome.getNumber());
            pstSewaTanahIncome.setLong(COL_POSTED_BY_ID, sewatanahincome.getPostedById());
            pstSewaTanahIncome.setString(COL_KETERANGAN, sewatanahincome.getKeterangan());
            pstSewaTanahIncome.setLong(COL_GL_ID, sewatanahincome.getGlId());
            pstSewaTanahIncome.setInt(COL_TYPE, sewatanahincome.getType());
            pstSewaTanahIncome.setDate(COL_TANGGAL_INPUT, sewatanahincome.getTanggalInput());
            pstSewaTanahIncome.setLong(COL_INVESTOR_ID, sewatanahincome.getInvestorId());
            pstSewaTanahIncome.setLong(COL_SARANA_ID, sewatanahincome.getSaranaId());

            pstSewaTanahIncome.insert();
            sewatanahincome.setOID(pstSewaTanahIncome.getlong(COL_SEWA_TANAH_INCOME_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahIncome(0), CONException.UNKNOWN);
        }
        return sewatanahincome.getOID();
    }

    public static long updateExc(SewaTanahIncome sewatanahincome) throws CONException {
        try {
            if (sewatanahincome.getOID() != 0) {
                DbSewaTanahIncome pstSewaTanahIncome = new DbSewaTanahIncome(sewatanahincome.getOID());

                pstSewaTanahIncome.setLong(COL_SEWA_TANAH_INVOICE_ID, sewatanahincome.getSewaTanahInvoiceId());
                pstSewaTanahIncome.setLong(COL_CURRENCY_ID, sewatanahincome.getCurrencyId());
                pstSewaTanahIncome.setDouble(COL_JUMLAH, sewatanahincome.getJumlah());
                pstSewaTanahIncome.setInt(COL_STATUS, sewatanahincome.getStatus());
                pstSewaTanahIncome.setString(COL_CREATED_BY_ID, sewatanahincome.getCreatedById());
                pstSewaTanahIncome.setDate(COL_POSTED_DATE, sewatanahincome.getPostedDate());
                pstSewaTanahIncome.setDate(COL_TANGGAL, sewatanahincome.getTanggal());
                pstSewaTanahIncome.setInt(COL_COUNTER, sewatanahincome.getCounter());
                pstSewaTanahIncome.setString(COL_PREFIX_NUMBER, sewatanahincome.getPrefixNumber());
                pstSewaTanahIncome.setString(COL_NUMBER, sewatanahincome.getNumber());
                pstSewaTanahIncome.setLong(COL_POSTED_BY_ID, sewatanahincome.getPostedById());
                pstSewaTanahIncome.setString(COL_KETERANGAN, sewatanahincome.getKeterangan());
                pstSewaTanahIncome.setLong(COL_GL_ID, sewatanahincome.getGlId());
                pstSewaTanahIncome.setInt(COL_TYPE, sewatanahincome.getType());
                pstSewaTanahIncome.setDate(COL_TANGGAL_INPUT, sewatanahincome.getTanggalInput());
                pstSewaTanahIncome.setLong(COL_INVESTOR_ID, sewatanahincome.getInvestorId());
                pstSewaTanahIncome.setLong(COL_SARANA_ID, sewatanahincome.getSaranaId());

                pstSewaTanahIncome.update();
                return sewatanahincome.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahIncome(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanahIncome pstSewaTanahIncome = new DbSewaTanahIncome(oid);
            pstSewaTanahIncome.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahIncome(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_INCOME;
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
                SewaTanahIncome sewatanahincome = new SewaTanahIncome();
                resultToObject(rs, sewatanahincome);
                lists.add(sewatanahincome);
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

    private static void resultToObject(ResultSet rs, SewaTanahIncome sewatanahincome) {
        try {
            sewatanahincome.setOID(rs.getLong(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_SEWA_TANAH_INCOME_ID]));
            sewatanahincome.setSewaTanahInvoiceId(rs.getLong(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_SEWA_TANAH_INVOICE_ID]));
            sewatanahincome.setCurrencyId(rs.getLong(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_CURRENCY_ID]));
            sewatanahincome.setJumlah(rs.getDouble(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_JUMLAH]));
            sewatanahincome.setStatus(rs.getInt(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_STATUS]));
            sewatanahincome.setCreatedById(rs.getString(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_CREATED_BY_ID]));
            sewatanahincome.setPostedDate(rs.getDate(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_POSTED_DATE]));
            sewatanahincome.setTanggal(rs.getDate(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_TANGGAL]));
            sewatanahincome.setCounter(rs.getInt(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_COUNTER]));
            sewatanahincome.setPrefixNumber(rs.getString(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_PREFIX_NUMBER]));
            sewatanahincome.setNumber(rs.getString(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_NUMBER]));
            sewatanahincome.setPostedById(rs.getLong(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_POSTED_BY_ID]));
            sewatanahincome.setKeterangan(rs.getString(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_KETERANGAN]));
            sewatanahincome.setGlId(rs.getLong(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_GL_ID]));
            sewatanahincome.setType(rs.getInt(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_TYPE]));
            sewatanahincome.setTanggalInput(rs.getDate(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_TANGGAL_INPUT]));
            sewatanahincome.setInvestorId(rs.getLong(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_INVESTOR_ID]));
            sewatanahincome.setSaranaId(rs.getLong(DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_SARANA_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahIncomeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_INCOME + " WHERE " +
                    DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_SEWA_TANAH_INCOME_ID] + " = " + sewaTanahIncomeId;

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
            String sql = "SELECT COUNT(" + DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_SEWA_TANAH_INCOME_ID] + ") FROM " + DB_CRM_SEWA_TANAH_INCOME;
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
                    SewaTanahIncome sewatanahincome = (SewaTanahIncome) list.get(ls);
                    if (oid == sewatanahincome.getOID()) {
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

    public static void insertIncome(SewaTanahInvoice sewatanahinvoice) {

        Date dt = sewatanahinvoice.getJatuhTempo();
        int i = dt.getMonth();

        //insert pendapatan bulanan
        for (int x = 0; x < sewatanahinvoice.getJmlBulan(); x++) {

            SewaTanahIncome sewatanahincome = new SewaTanahIncome();

            Date dtx = new Date();
            dtx.setMonth(i + x);

            System.out.println("i = " + x + ", tanggal : " + dtx);

            sewatanahincome.setTanggal(dtx);
            sewatanahincome.setTanggalInput(new Date());
            sewatanahincome.setSewaTanahInvoiceId(sewatanahinvoice.getOID());
            sewatanahincome.setCurrencyId(sewatanahinvoice.getCurrencyId());
            sewatanahincome.setJumlah((sewatanahinvoice.getJumlah() - sewatanahinvoice.getPpn()) / sewatanahinvoice.getJmlBulan());
            sewatanahincome.setStatus(I_Crm.JURNAL_STATUS_NOT_POSTED);
            sewatanahincome.setNumber(sewatanahinvoice.getNumber() + "-INC" + (x + 1));

            Customer sarana = new Customer();
            try {
                sarana = DbCustomer.fetchExc(sewatanahinvoice.getSaranaId());
            } catch (Exception e) {
            }

            String ket = "Income Bulan " + JSPFormater.formatDate(sewatanahincome.getTanggal(), "MMMM yyyy");
            if (sewatanahinvoice.getType() == DbSewaTanahInvoice.TYPE_INV_ASSESMENT) {
                ket = ket + " Assesment, " + sarana.getName();
            } else if (sewatanahinvoice.getType() == DbSewaTanahInvoice.TYPE_INV_KOMIN) {
                ket = ket + " Kompensasi Minimum, " + sarana.getName();
            }

            sewatanahincome.setKeterangan(ket);
            sewatanahincome.setType(sewatanahinvoice.getType());
            sewatanahincome.setInvestorId(sewatanahinvoice.getInvestorId());
            sewatanahincome.setSaranaId(sewatanahinvoice.getSaranaId());

            try {
                DbSewaTanahIncome.insertExc(sewatanahincome);
            } catch (Exception e) {
            }
        }

    }

    public static void insertIncomeKomper(SewaTanahBenefit sewatanahbenefit) {

        SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();
        try {
            sewatanahinvoice = DbSewaTanahInvoice.fetchExc(sewatanahbenefit.getSewaTanahInvoiceId());
        } catch (Exception e) {

        }

        Date dt = sewatanahinvoice.getTanggal();
        int i = dt.getMonth();
        //dt.setMonth(x+1+dt.getMonth());

        //insert pendapatan bulanan
        for (int x = 0; x < sewatanahinvoice.getJmlBulan(); x++) {

            SewaTanahIncome sewatanahincome = new SewaTanahIncome();

            Date dtx = new Date();
            dtx.setMonth(i + x);

            System.out.println("i = " + x + ", tanggal : " + dtx);

            sewatanahincome.setTanggal(dtx);
            sewatanahincome.setTanggalInput(new Date());
            sewatanahincome.setSewaTanahInvoiceId(sewatanahbenefit.getOID());
            sewatanahincome.setCurrencyId(sewatanahinvoice.getCurrencyId());
            sewatanahincome.setJumlah((sewatanahbenefit.getTotalKomper() - sewatanahbenefit.getPpn()) / sewatanahinvoice.getJmlBulan());
            sewatanahincome.setStatus(I_Crm.JURNAL_STATUS_NOT_POSTED);
            //sewatanahincome.setCreatedById(pstSewaTanahIncome.getString(COL_CREATED_BY_ID));
            //sewatanahincome.setPostedDate(pstSewaTanahIncome.getDate(COL_POSTED_DATE));
            //sewatanahincome.setTanggal(pstSewaTanahIncome.getDate(COL_TANGGAL));
            //sewatanahincome.setCounter(pstSewaTanahIncome.getInt(COL_COUNTER));
            //sewatanahincome.setPrefixNumber(pstSewaTanahIncome.getString(COL_PREFIX_NUMBER));
            sewatanahincome.setNumber(sewatanahbenefit.getNumber() + "-INC" + (x + 1));
            //sewatanahincome.setPostedById(pstSewaTanahIncome.getlong(COL_POSTED_BY_ID));

            Customer sarana = new Customer();
            try {
                sarana = DbCustomer.fetchExc(sewatanahinvoice.getSaranaId());
            } catch (Exception e) {
            }

            String ket = "Income Bulan " + JSPFormater.formatDate(sewatanahincome.getTanggal(), "MMMM yyyy");
            ket = ket + " Kompensasi Persentase, " + sarana.getName();

            sewatanahincome.setKeterangan(ket);
            //sewatanahincome.setGlId(pstSewaTanahIncome.getlong(COL_GL_ID));
            sewatanahincome.setType(DbSewaTanahInvoice.TYPE_INV_KOMPER);
            //sewatanahincome.setTanggalInput(pstSewaTanahIncome.getDate(COL_TANGGAL_INPUT));
            sewatanahincome.setInvestorId(sewatanahinvoice.getInvestorId());
            sewatanahincome.setSaranaId(sewatanahinvoice.getSaranaId());

            try {
                DbSewaTanahIncome.insertExc(sewatanahincome);
            } catch (Exception e) {
            }
        }

    }

    public static boolean postJournal(SewaTanahIncome sewaTanahIncome) {

        boolean ok = true;

        if (sewaTanahIncome.getType() == DbSewaTanahInvoice.TYPE_INV_KOMIN) {
            ok = postJournalKomin(sewaTanahIncome);
        } else if (sewaTanahIncome.getType() == DbSewaTanahInvoice.TYPE_INV_ASSESMENT) {
            ok = postJournalAssesment(sewaTanahIncome);
        } else {
            ok = postJournalKomper(sewaTanahIncome);
        }

        return ok;

    }

    //journal balik pendapatan yang diterima dimuka ke pendapatan
    public static boolean postJournalKomin(SewaTanahIncome sewaTanahIncome) {
        
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

             
                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahIncome.setStatus(I_Crm.JURNAL_STATUS_POSTED);
                    DbSewaTanahIncome.updateExc(sewaTanahIncome);
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
    public static boolean postJournalAssesment(SewaTanahIncome sewaTanahIncome) {
        
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

                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahIncome.setStatus(I_Crm.JURNAL_STATUS_POSTED);
                    DbSewaTanahIncome.updateExc(sewaTanahIncome);
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
    public static boolean postJournalKomper(SewaTanahIncome sewaTanahIncome) {
        
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

                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahIncome.setStatus(I_Crm.JURNAL_STATUS_POSTED);
                    DbSewaTanahIncome.updateExc(sewaTanahIncome);
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
