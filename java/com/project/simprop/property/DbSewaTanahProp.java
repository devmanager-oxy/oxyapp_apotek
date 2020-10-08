/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*;
/**
 *
 * @author Roy Andika
 */
public class DbSewaTanahProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_POP_SEWA_TANAH = "prop_sewa_tanah";
    
    public static final int COL_SEWA_TANAH_ID = 0;
    public static final int COL_NOMOR_KONTRAK = 1;
    public static final int COL_INVESTOR_ID = 2;
    public static final int COL_CUSTOMER_ID = 3;
    public static final int COL_JENIS_BANGUNAN = 4;
    public static final int COL_LOT_ID = 5;
    public static final int COL_LUAS = 6;
    public static final int COL_JML_KAMAR = 7;
    public static final int COL_DASAR_KOMIN = 8;
    public static final int COL_TANGGAL_MULAI = 9;
    public static final int COL_TANGGAL_SELESAI = 10;
    public static final int COL_STATUS = 11;
    public static final int COL_TANGGAL_INPUT = 12;
    public static final int COL_RATE = 13;
    public static final int COL_PENAMBAHAN_KONTRAK = 14;
    public static final int COL_REF_ID = 15;
    public static final int COL_CURRENCY_ID = 16;
    public static final int COL_ASSESMENT_STATUS = 17;
    public static final int COL_TGL_MULAI_KOMIN = 18;
    public static final int COL_TGL_MULAI_KOMPER = 19;
    public static final int COL_TGL_MULAI_ASSESMENT = 20;
    public static final int COL_KETERANGAN_AMANDEMEN = 21;
    public static final int COL_TGL_INVOICE_KOMIN = 22;
    public static final int COL_TGL_INVOICE_ASSESMENT = 23;
    
    public static final String[] colNames = {
        "sewa_tanah_id",
        "nomor_kontrak",
        "investor_id",
        "customer_id",
        "jenis_bangunan",
        "lot_id",
        "luas",
        "jml_kamar",
        "dasar_komin",
        "tanggal_mulai",
        "tanggal_selesai",
        "status",
        "tanggal_input",
        "rate",
        "penambahan_kontrak",
        "ref_id",
        "currency_id",
        "assesment_status",
        "tgl_mulai_komin",
        "tgl_mulai_komper",
        "tgl_mulai_assesment",
        "keterangan_amandemen",
        "tgl_invoice_komin",
        "tgl_invoice_assesment"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE
    };
    
    public static final int TYPE_HOTEL = 0;
    public static final int TYPE_RESTAURANT = 1;
    public static final int TYPE_LOUNGE = 2;
    public static final String[] typeBangunan_Value = {"0", "1", "2", "3", "4"};
    public static final String[] typeBangunan_Key = {"Hotel", "Restaurant", "Lounge", "Spa", "Golf"};
    
    // ini di pakai untuk dasar perhitungan
    public static final int TYPE_DASAR_PERHITUNGAN_MINIM_KOM_LAHAN = 0;
    public static final int TYPE_DASAR_PERHITUNGAN_MINIM_KOM_KAMAR = 1;
    public static final int TYPE_DASAR_PERHITUNGAN_TOTAL = 2;
    public static final String[] dasarMinimumKompensasi = {"Jml Luasan", "Jml Kamar", "Total"};

    // ini di pakai untuk aktif dan tidak aktif
    public static final int STATUS_AKTIF = 0;
    public static final int STATUS_TIDAK_AKTIF = 1;
    public static final String[] status = {"Aktif", "Tidak Aktif"};

    public DbSewaTanahProp() {
    }

    public DbSewaTanahProp(int i) throws CONException {
        super(new DbSewaTanahProp());
    }

    public DbSewaTanahProp(String sOid) throws CONException {
        super(new DbSewaTanahProp(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanahProp(long lOid) throws CONException {
        super(new DbSewaTanahProp(0));
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
        return DB_POP_SEWA_TANAH;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanahProp().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanahProp sewaTanahProp = fetchExc(ent.getOID());
        ent = (Entity) sewaTanahProp;
        return sewaTanahProp.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanahProp) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanahProp) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanahProp fetchExc(long oid) throws CONException {
        try {
            SewaTanahProp sewaTanahProp = new SewaTanahProp();
            DbSewaTanahProp pstSewaTanah = new DbSewaTanahProp(oid);
            
            sewaTanahProp.setOID(oid);
            sewaTanahProp.setNomorKontrak(pstSewaTanah.getString(COL_NOMOR_KONTRAK));
            sewaTanahProp.setInvestorId(pstSewaTanah.getlong(COL_INVESTOR_ID));
            sewaTanahProp.setCustomerId(pstSewaTanah.getlong(COL_CUSTOMER_ID));
            sewaTanahProp.setJenisBangunan(pstSewaTanah.getInt(COL_JENIS_BANGUNAN));
            sewaTanahProp.setLotId(pstSewaTanah.getlong(COL_LOT_ID));
            sewaTanahProp.setLuas(pstSewaTanah.getdouble(COL_LUAS));
            sewaTanahProp.setJmlKamar(pstSewaTanah.getInt(COL_JML_KAMAR));
            sewaTanahProp.setDasarKomin(pstSewaTanah.getInt(COL_DASAR_KOMIN));
            sewaTanahProp.setTanggalMulai(pstSewaTanah.getDate(COL_TANGGAL_MULAI));
            sewaTanahProp.setTanggalSelesai(pstSewaTanah.getDate(COL_TANGGAL_SELESAI));
            sewaTanahProp.setStatus(pstSewaTanah.getInt(COL_STATUS));
            sewaTanahProp.setTanggalInput(pstSewaTanah.getDate(COL_TANGGAL_INPUT));
            sewaTanahProp.setRate(pstSewaTanah.getdouble(COL_RATE));
            sewaTanahProp.setPenambahanKontrak(pstSewaTanah.getInt(COL_PENAMBAHAN_KONTRAK));
            sewaTanahProp.setRefId(pstSewaTanah.getlong(COL_REF_ID));
            sewaTanahProp.setCurrencyId(pstSewaTanah.getlong(COL_CURRENCY_ID));
            sewaTanahProp.setAssesmentStatus(pstSewaTanah.getInt(COL_ASSESMENT_STATUS));
            sewaTanahProp.setTglMulaiKomin(pstSewaTanah.getDate(COL_TGL_MULAI_KOMIN));
            sewaTanahProp.setTglMulaiKomper(pstSewaTanah.getDate(COL_TGL_MULAI_KOMPER));
            sewaTanahProp.setTglMulaiAssesment(pstSewaTanah.getDate(COL_TGL_MULAI_ASSESMENT));
            sewaTanahProp.setKeteranganAmandemen(pstSewaTanah.getString(COL_KETERANGAN_AMANDEMEN));
            sewaTanahProp.setTglInvoiceKomin(pstSewaTanah.getDate(COL_TGL_INVOICE_KOMIN));
            sewaTanahProp.setTglInvoiceAssesment(pstSewaTanah.getDate(COL_TGL_INVOICE_ASSESMENT));

            return sewaTanahProp;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahProp(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanahProp sewaTanahProp) throws CONException {
        try {
            DbSewaTanahProp pstSewaTanah = new DbSewaTanahProp(0);

            pstSewaTanah.setString(COL_NOMOR_KONTRAK, sewaTanahProp.getNomorKontrak());
            pstSewaTanah.setLong(COL_INVESTOR_ID, sewaTanahProp.getInvestorId());
            pstSewaTanah.setLong(COL_CUSTOMER_ID, sewaTanahProp.getCustomerId());
            pstSewaTanah.setInt(COL_JENIS_BANGUNAN, sewaTanahProp.getJenisBangunan());
            pstSewaTanah.setLong(COL_LOT_ID, sewaTanahProp.getLotId());
            pstSewaTanah.setDouble(COL_LUAS, sewaTanahProp.getLuas());
            pstSewaTanah.setInt(COL_JML_KAMAR, sewaTanahProp.getJmlKamar());
            pstSewaTanah.setInt(COL_DASAR_KOMIN, sewaTanahProp.getDasarKomin());
            pstSewaTanah.setDate(COL_TANGGAL_MULAI, sewaTanahProp.getTanggalMulai());
            pstSewaTanah.setDate(COL_TANGGAL_SELESAI, sewaTanahProp.getTanggalSelesai());
            pstSewaTanah.setInt(COL_STATUS, sewaTanahProp.getStatus());
            pstSewaTanah.setDate(COL_TANGGAL_INPUT, sewaTanahProp.getTanggalInput());
            pstSewaTanah.setDouble(COL_RATE, sewaTanahProp.getRate());
            pstSewaTanah.setInt(COL_PENAMBAHAN_KONTRAK, sewaTanahProp.getPenambahanKontrak());
            pstSewaTanah.setLong(COL_REF_ID, sewaTanahProp.getRefId());
            pstSewaTanah.setLong(COL_CURRENCY_ID, sewaTanahProp.getCurrencyId());
            pstSewaTanah.setInt(COL_ASSESMENT_STATUS, sewaTanahProp.getAssesmentStatus());
            pstSewaTanah.setDate(COL_TGL_MULAI_KOMIN, sewaTanahProp.getTglMulaiKomin());
            pstSewaTanah.setDate(COL_TGL_MULAI_KOMPER, sewaTanahProp.getTglMulaiKomper());
            pstSewaTanah.setDate(COL_TGL_MULAI_ASSESMENT, sewaTanahProp.getTglMulaiAssesment());
            pstSewaTanah.setString(COL_KETERANGAN_AMANDEMEN, sewaTanahProp.getKeteranganAmandemen());
            pstSewaTanah.setDate(COL_TGL_INVOICE_KOMIN, sewaTanahProp.getTglInvoiceKomin());
            pstSewaTanah.setDate(COL_TGL_INVOICE_ASSESMENT, sewaTanahProp.getTglInvoiceAssesment());

            pstSewaTanah.insert();
            sewaTanahProp.setOID(pstSewaTanah.getlong(COL_SEWA_TANAH_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahProp(0), CONException.UNKNOWN);
        }
        return sewaTanahProp.getOID();
    }

    public static long updateExc(SewaTanahProp sewaTanahProp) throws CONException {
        try {
            if (sewaTanahProp.getOID() != 0) {
                DbSewaTanahProp pstSewaTanah = new DbSewaTanahProp(sewaTanahProp.getOID());

                pstSewaTanah.setString(COL_NOMOR_KONTRAK, sewaTanahProp.getNomorKontrak());
                pstSewaTanah.setLong(COL_INVESTOR_ID, sewaTanahProp.getInvestorId());
                pstSewaTanah.setLong(COL_CUSTOMER_ID, sewaTanahProp.getCustomerId());
                pstSewaTanah.setInt(COL_JENIS_BANGUNAN, sewaTanahProp.getJenisBangunan());
                pstSewaTanah.setLong(COL_LOT_ID, sewaTanahProp.getLotId());
                pstSewaTanah.setDouble(COL_LUAS, sewaTanahProp.getLuas());
                pstSewaTanah.setInt(COL_JML_KAMAR, sewaTanahProp.getJmlKamar());
                pstSewaTanah.setInt(COL_DASAR_KOMIN, sewaTanahProp.getDasarKomin());
                pstSewaTanah.setDate(COL_TANGGAL_MULAI, sewaTanahProp.getTanggalMulai());
                pstSewaTanah.setDate(COL_TANGGAL_SELESAI, sewaTanahProp.getTanggalSelesai());
                pstSewaTanah.setInt(COL_STATUS, sewaTanahProp.getStatus());
                pstSewaTanah.setDate(COL_TANGGAL_INPUT, sewaTanahProp.getTanggalInput());
                pstSewaTanah.setDouble(COL_RATE, sewaTanahProp.getRate());
                pstSewaTanah.setInt(COL_PENAMBAHAN_KONTRAK, sewaTanahProp.getPenambahanKontrak());
                pstSewaTanah.setLong(COL_REF_ID, sewaTanahProp.getRefId());
                pstSewaTanah.setLong(COL_CURRENCY_ID, sewaTanahProp.getCurrencyId());
                pstSewaTanah.setInt(COL_ASSESMENT_STATUS, sewaTanahProp.getAssesmentStatus());
                pstSewaTanah.setDate(COL_TGL_MULAI_KOMIN, sewaTanahProp.getTglMulaiKomin());
                pstSewaTanah.setDate(COL_TGL_MULAI_KOMPER, sewaTanahProp.getTglMulaiKomper());
                pstSewaTanah.setDate(COL_TGL_MULAI_ASSESMENT, sewaTanahProp.getTglMulaiAssesment());
                pstSewaTanah.setString(COL_KETERANGAN_AMANDEMEN, sewaTanahProp.getKeteranganAmandemen());
                pstSewaTanah.setDate(COL_TGL_INVOICE_KOMIN, sewaTanahProp.getTglInvoiceKomin());
                pstSewaTanah.setDate(COL_TGL_INVOICE_ASSESMENT, sewaTanahProp.getTglInvoiceAssesment());

                pstSewaTanah.update();
                return sewaTanahProp.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahProp(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanahProp pstSewaTanah = new DbSewaTanahProp(oid);
            pstSewaTanah.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahProp(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POP_SEWA_TANAH;
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
                SewaTanahProp sewaTanahProp = new SewaTanahProp();
                resultToObject(rs, sewaTanahProp);
                lists.add(sewaTanahProp);
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

    private static void resultToObject(ResultSet rs, SewaTanahProp sewaTanahProp) {
        try {
            sewaTanahProp.setOID(rs.getLong(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_SEWA_TANAH_ID]));
            sewaTanahProp.setNomorKontrak(rs.getString(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_NOMOR_KONTRAK]));
            sewaTanahProp.setInvestorId(rs.getLong(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_INVESTOR_ID]));
            sewaTanahProp.setCustomerId(rs.getLong(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_CUSTOMER_ID]));
            sewaTanahProp.setJenisBangunan(rs.getInt(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_JENIS_BANGUNAN]));
            sewaTanahProp.setLotId(rs.getLong(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_LOT_ID]));
            sewaTanahProp.setLuas(rs.getDouble(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_LUAS]));
            sewaTanahProp.setJmlKamar(rs.getInt(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_JML_KAMAR]));
            sewaTanahProp.setDasarKomin(rs.getInt(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_DASAR_KOMIN]));
            sewaTanahProp.setTanggalMulai(rs.getDate(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_TANGGAL_MULAI]));
            sewaTanahProp.setTanggalSelesai(rs.getDate(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_TANGGAL_SELESAI]));
            sewaTanahProp.setStatus(rs.getInt(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_STATUS]));
            sewaTanahProp.setTanggalInput(rs.getDate(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_TANGGAL_INPUT]));
            sewaTanahProp.setRate(rs.getDouble(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_RATE]));
            sewaTanahProp.setPenambahanKontrak(rs.getInt(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_PENAMBAHAN_KONTRAK]));
            sewaTanahProp.setRefId(rs.getLong(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_REF_ID]));
            sewaTanahProp.setCurrencyId(rs.getLong(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_CURRENCY_ID]));
            sewaTanahProp.setAssesmentStatus(rs.getInt(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_ASSESMENT_STATUS]));
            sewaTanahProp.setTglMulaiKomin(rs.getDate(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_TGL_MULAI_KOMIN]));
            sewaTanahProp.setTglMulaiKomper(rs.getDate(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_TGL_MULAI_KOMPER]));
            sewaTanahProp.setTglMulaiAssesment(rs.getDate(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_TGL_MULAI_ASSESMENT]));
            sewaTanahProp.setKeteranganAmandemen(rs.getString(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_KETERANGAN_AMANDEMEN]));
            sewaTanahProp.setTglInvoiceKomin(rs.getDate(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_TGL_INVOICE_KOMIN]));
            sewaTanahProp.setTglInvoiceAssesment(rs.getDate(DbSewaTanahProp.colNames[DbSewaTanahProp.COL_TGL_INVOICE_ASSESMENT]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POP_SEWA_TANAH + " WHERE " +
                    DbSewaTanahProp.colNames[DbSewaTanahProp.COL_SEWA_TANAH_ID] + " = " + sewaTanahId;

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
            String sql = "SELECT COUNT(" + DbSewaTanahProp.colNames[DbSewaTanahProp.COL_SEWA_TANAH_ID] + ") FROM " + DB_POP_SEWA_TANAH;
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
                    SewaTanahProp sewaTanahProp = (SewaTanahProp) list.get(ls);
                    if (oid == sewaTanahProp.getOID()) {
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

    public static SewaTanahProp getActiveSewaTanah(long oidInvestor, long oidSarana) {

        if (oidInvestor != 0 && oidSarana != 0) {
            Vector temp = list(0, 1, colNames[COL_STATUS] + "=" + STATUS_AKTIF + " and " + colNames[COL_INVESTOR_ID] + "=" + oidInvestor + " and " + colNames[COL_CUSTOMER_ID] + "=" + oidSarana, "");
            if (temp != null && temp.size() > 0) {
                return (SewaTanahProp) temp.get(0);
            }
        }

        return new SewaTanahProp();

    }

    /**
     * Method to check if any contract contains same data
     * by gwawan 20110704
     * @param objSewaTanah
     * @return
     */
    public static boolean isContractExist(SewaTanahProp objSewaTanah) {
        CONResultSet dbrs = null;

        try {
            if (objSewaTanah.getCustomerId() != 0) {
                String sql = "SELECT * FROM " + DB_POP_SEWA_TANAH + " WHERE " + colNames[COL_CUSTOMER_ID] + " = " + objSewaTanah.getCustomerId();
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();

                /**
                 * check if existing contract, contain same Sarana in the same Lot
                 */
                while (rs.next()) {
                    SewaTanahProp rsSewaTanah = new SewaTanahProp();
                    resultToObject(rs, rsSewaTanah);
                    if (rsSewaTanah.getLotId() == objSewaTanah.getLotId()) {
                        return true;
                    }
                }
                rs.close();
            }
        } catch (Exception e) {
            System.out.println("isContractExist error: " + e.toString());
        }
        return false;
    }

    /**
     * Fungsi untuk mendapatkan daftar kontrak yang belum memiliki rincian piutang
     * gwawan 20110719 
     * @param year
     * @return
     */
    public static Vector getSewaTanahList(int year) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT * FROM crm_sewa_tanah WHERE ('" + year + "' BETWEEN YEAR(tanggal_mulai) " +
                    "AND YEAR(tanggal_selesai)) AND sewa_tanah_id NOT IN(SELECT sewa_tanah_id " +
                    "FROM crm_sewa_tanah_rincian_piutang WHERE periode_tahun = '" + year + "') " +
                    "AND " + DbSewaTanahProp.colNames[DbSewaTanahProp.COL_STATUS] + "=" + DbSewaTanahProp.STATUS_AKTIF;
            System.out.println("getSewaTanahList: "+sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SewaTanahProp objSewaTanah = new SewaTanahProp();
                resultToObject(rs, objSewaTanah);
                list.add(objSewaTanah);
            }
            return list;
        } catch (Exception e) {
            System.out.println("Error while DbSewatanah.getSewaTanahList(year): " + e.toString());
        }
        return new Vector();
    }


}
