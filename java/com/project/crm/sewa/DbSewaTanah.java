/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */
package com.project.crm.sewa;

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

public class DbSewaTanah extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CRM_SEWA_TANAH = "crm_sewa_tanah";
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

    public DbSewaTanah() {
    }

    public DbSewaTanah(int i) throws CONException {
        super(new DbSewaTanah());
    }

    public DbSewaTanah(String sOid) throws CONException {
        super(new DbSewaTanah(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanah(long lOid) throws CONException {
        super(new DbSewaTanah(0));
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
        return DB_CRM_SEWA_TANAH;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanah().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanah sewatanah = fetchExc(ent.getOID());
        ent = (Entity) sewatanah;
        return sewatanah.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanah) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanah) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanah fetchExc(long oid) throws CONException {
        try {
            SewaTanah sewatanah = new SewaTanah();
            DbSewaTanah pstSewaTanah = new DbSewaTanah(oid);
            sewatanah.setOID(oid);

            sewatanah.setNomorKontrak(pstSewaTanah.getString(COL_NOMOR_KONTRAK));
            sewatanah.setInvestorId(pstSewaTanah.getlong(COL_INVESTOR_ID));
            sewatanah.setCustomerId(pstSewaTanah.getlong(COL_CUSTOMER_ID));
            sewatanah.setJenisBangunan(pstSewaTanah.getInt(COL_JENIS_BANGUNAN));
            sewatanah.setLotId(pstSewaTanah.getlong(COL_LOT_ID));
            sewatanah.setLuas(pstSewaTanah.getdouble(COL_LUAS));
            sewatanah.setJmlKamar(pstSewaTanah.getInt(COL_JML_KAMAR));
            sewatanah.setDasarKomin(pstSewaTanah.getInt(COL_DASAR_KOMIN));
            sewatanah.setTanggalMulai(pstSewaTanah.getDate(COL_TANGGAL_MULAI));
            sewatanah.setTanggalSelesai(pstSewaTanah.getDate(COL_TANGGAL_SELESAI));
            sewatanah.setStatus(pstSewaTanah.getInt(COL_STATUS));
            sewatanah.setTanggalInput(pstSewaTanah.getDate(COL_TANGGAL_INPUT));
            sewatanah.setRate(pstSewaTanah.getdouble(COL_RATE));
            sewatanah.setPenambahanKontrak(pstSewaTanah.getInt(COL_PENAMBAHAN_KONTRAK));
            sewatanah.setRefId(pstSewaTanah.getlong(COL_REF_ID));
            sewatanah.setCurrencyId(pstSewaTanah.getlong(COL_CURRENCY_ID));
            sewatanah.setAssesmentStatus(pstSewaTanah.getInt(COL_ASSESMENT_STATUS));
            sewatanah.setTglMulaiKomin(pstSewaTanah.getDate(COL_TGL_MULAI_KOMIN));
            sewatanah.setTglMulaiKomper(pstSewaTanah.getDate(COL_TGL_MULAI_KOMPER));
            sewatanah.setTglMulaiAssesment(pstSewaTanah.getDate(COL_TGL_MULAI_ASSESMENT));
            sewatanah.setKeteranganAmandemen(pstSewaTanah.getString(COL_KETERANGAN_AMANDEMEN));
            sewatanah.setTglInvoiceKomin(pstSewaTanah.getDate(COL_TGL_INVOICE_KOMIN));
            sewatanah.setTglInvoiceAssesment(pstSewaTanah.getDate(COL_TGL_INVOICE_ASSESMENT));

            return sewatanah;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanah(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanah sewatanah) throws CONException {
        try {
            DbSewaTanah pstSewaTanah = new DbSewaTanah(0);

            pstSewaTanah.setString(COL_NOMOR_KONTRAK, sewatanah.getNomorKontrak());
            pstSewaTanah.setLong(COL_INVESTOR_ID, sewatanah.getInvestorId());
            pstSewaTanah.setLong(COL_CUSTOMER_ID, sewatanah.getCustomerId());
            pstSewaTanah.setInt(COL_JENIS_BANGUNAN, sewatanah.getJenisBangunan());
            pstSewaTanah.setLong(COL_LOT_ID, sewatanah.getLotId());
            pstSewaTanah.setDouble(COL_LUAS, sewatanah.getLuas());
            pstSewaTanah.setInt(COL_JML_KAMAR, sewatanah.getJmlKamar());
            pstSewaTanah.setInt(COL_DASAR_KOMIN, sewatanah.getDasarKomin());
            pstSewaTanah.setDate(COL_TANGGAL_MULAI, sewatanah.getTanggalMulai());
            pstSewaTanah.setDate(COL_TANGGAL_SELESAI, sewatanah.getTanggalSelesai());
            pstSewaTanah.setInt(COL_STATUS, sewatanah.getStatus());
            pstSewaTanah.setDate(COL_TANGGAL_INPUT, sewatanah.getTanggalInput());
            pstSewaTanah.setDouble(COL_RATE, sewatanah.getRate());
            pstSewaTanah.setInt(COL_PENAMBAHAN_KONTRAK, sewatanah.getPenambahanKontrak());
            pstSewaTanah.setLong(COL_REF_ID, sewatanah.getRefId());
            pstSewaTanah.setLong(COL_CURRENCY_ID, sewatanah.getCurrencyId());
            pstSewaTanah.setInt(COL_ASSESMENT_STATUS, sewatanah.getAssesmentStatus());
            pstSewaTanah.setDate(COL_TGL_MULAI_KOMIN, sewatanah.getTglMulaiKomin());
            pstSewaTanah.setDate(COL_TGL_MULAI_KOMPER, sewatanah.getTglMulaiKomper());
            pstSewaTanah.setDate(COL_TGL_MULAI_ASSESMENT, sewatanah.getTglMulaiAssesment());
            pstSewaTanah.setString(COL_KETERANGAN_AMANDEMEN, sewatanah.getKeteranganAmandemen());
            pstSewaTanah.setDate(COL_TGL_INVOICE_KOMIN, sewatanah.getTglInvoiceKomin());
            pstSewaTanah.setDate(COL_TGL_INVOICE_ASSESMENT, sewatanah.getTglInvoiceAssesment());

            pstSewaTanah.insert();
            sewatanah.setOID(pstSewaTanah.getlong(COL_SEWA_TANAH_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanah(0), CONException.UNKNOWN);
        }
        return sewatanah.getOID();
    }

    public static long updateExc(SewaTanah sewatanah) throws CONException {
        try {
            if (sewatanah.getOID() != 0) {
                DbSewaTanah pstSewaTanah = new DbSewaTanah(sewatanah.getOID());

                pstSewaTanah.setString(COL_NOMOR_KONTRAK, sewatanah.getNomorKontrak());
                pstSewaTanah.setLong(COL_INVESTOR_ID, sewatanah.getInvestorId());
                pstSewaTanah.setLong(COL_CUSTOMER_ID, sewatanah.getCustomerId());
                pstSewaTanah.setInt(COL_JENIS_BANGUNAN, sewatanah.getJenisBangunan());
                pstSewaTanah.setLong(COL_LOT_ID, sewatanah.getLotId());
                pstSewaTanah.setDouble(COL_LUAS, sewatanah.getLuas());
                pstSewaTanah.setInt(COL_JML_KAMAR, sewatanah.getJmlKamar());
                pstSewaTanah.setInt(COL_DASAR_KOMIN, sewatanah.getDasarKomin());
                pstSewaTanah.setDate(COL_TANGGAL_MULAI, sewatanah.getTanggalMulai());
                pstSewaTanah.setDate(COL_TANGGAL_SELESAI, sewatanah.getTanggalSelesai());
                pstSewaTanah.setInt(COL_STATUS, sewatanah.getStatus());
                pstSewaTanah.setDate(COL_TANGGAL_INPUT, sewatanah.getTanggalInput());
                pstSewaTanah.setDouble(COL_RATE, sewatanah.getRate());
                pstSewaTanah.setInt(COL_PENAMBAHAN_KONTRAK, sewatanah.getPenambahanKontrak());
                pstSewaTanah.setLong(COL_REF_ID, sewatanah.getRefId());
                pstSewaTanah.setLong(COL_CURRENCY_ID, sewatanah.getCurrencyId());
                pstSewaTanah.setInt(COL_ASSESMENT_STATUS, sewatanah.getAssesmentStatus());
                pstSewaTanah.setDate(COL_TGL_MULAI_KOMIN, sewatanah.getTglMulaiKomin());
                pstSewaTanah.setDate(COL_TGL_MULAI_KOMPER, sewatanah.getTglMulaiKomper());
                pstSewaTanah.setDate(COL_TGL_MULAI_ASSESMENT, sewatanah.getTglMulaiAssesment());
                pstSewaTanah.setString(COL_KETERANGAN_AMANDEMEN, sewatanah.getKeteranganAmandemen());
                pstSewaTanah.setDate(COL_TGL_INVOICE_KOMIN, sewatanah.getTglInvoiceKomin());
                pstSewaTanah.setDate(COL_TGL_INVOICE_ASSESMENT, sewatanah.getTglInvoiceAssesment());

                pstSewaTanah.update();
                return sewatanah.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanah(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanah pstSewaTanah = new DbSewaTanah(oid);
            pstSewaTanah.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanah(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH;
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
                SewaTanah sewatanah = new SewaTanah();
                resultToObject(rs, sewatanah);
                lists.add(sewatanah);
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

    private static void resultToObject(ResultSet rs, SewaTanah sewatanah) {
        try {
            sewatanah.setOID(rs.getLong(DbSewaTanah.colNames[DbSewaTanah.COL_SEWA_TANAH_ID]));
            sewatanah.setNomorKontrak(rs.getString(DbSewaTanah.colNames[DbSewaTanah.COL_NOMOR_KONTRAK]));
            sewatanah.setInvestorId(rs.getLong(DbSewaTanah.colNames[DbSewaTanah.COL_INVESTOR_ID]));
            sewatanah.setCustomerId(rs.getLong(DbSewaTanah.colNames[DbSewaTanah.COL_CUSTOMER_ID]));
            sewatanah.setJenisBangunan(rs.getInt(DbSewaTanah.colNames[DbSewaTanah.COL_JENIS_BANGUNAN]));
            sewatanah.setLotId(rs.getLong(DbSewaTanah.colNames[DbSewaTanah.COL_LOT_ID]));
            sewatanah.setLuas(rs.getDouble(DbSewaTanah.colNames[DbSewaTanah.COL_LUAS]));
            sewatanah.setJmlKamar(rs.getInt(DbSewaTanah.colNames[DbSewaTanah.COL_JML_KAMAR]));
            sewatanah.setDasarKomin(rs.getInt(DbSewaTanah.colNames[DbSewaTanah.COL_DASAR_KOMIN]));
            sewatanah.setTanggalMulai(rs.getDate(DbSewaTanah.colNames[DbSewaTanah.COL_TANGGAL_MULAI]));
            sewatanah.setTanggalSelesai(rs.getDate(DbSewaTanah.colNames[DbSewaTanah.COL_TANGGAL_SELESAI]));
            sewatanah.setStatus(rs.getInt(DbSewaTanah.colNames[DbSewaTanah.COL_STATUS]));
            sewatanah.setTanggalInput(rs.getDate(DbSewaTanah.colNames[DbSewaTanah.COL_TANGGAL_INPUT]));
            sewatanah.setRate(rs.getDouble(DbSewaTanah.colNames[DbSewaTanah.COL_RATE]));
            sewatanah.setPenambahanKontrak(rs.getInt(DbSewaTanah.colNames[DbSewaTanah.COL_PENAMBAHAN_KONTRAK]));
            sewatanah.setRefId(rs.getLong(DbSewaTanah.colNames[DbSewaTanah.COL_REF_ID]));
            sewatanah.setCurrencyId(rs.getLong(DbSewaTanah.colNames[DbSewaTanah.COL_CURRENCY_ID]));
            sewatanah.setAssesmentStatus(rs.getInt(DbSewaTanah.colNames[DbSewaTanah.COL_ASSESMENT_STATUS]));
            sewatanah.setTglMulaiKomin(rs.getDate(DbSewaTanah.colNames[DbSewaTanah.COL_TGL_MULAI_KOMIN]));
            sewatanah.setTglMulaiKomper(rs.getDate(DbSewaTanah.colNames[DbSewaTanah.COL_TGL_MULAI_KOMPER]));
            sewatanah.setTglMulaiAssesment(rs.getDate(DbSewaTanah.colNames[DbSewaTanah.COL_TGL_MULAI_ASSESMENT]));
            sewatanah.setKeteranganAmandemen(rs.getString(DbSewaTanah.colNames[DbSewaTanah.COL_KETERANGAN_AMANDEMEN]));
            sewatanah.setTglInvoiceKomin(rs.getDate(DbSewaTanah.colNames[DbSewaTanah.COL_TGL_INVOICE_KOMIN]));
            sewatanah.setTglInvoiceAssesment(rs.getDate(DbSewaTanah.colNames[DbSewaTanah.COL_TGL_INVOICE_ASSESMENT]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH + " WHERE " +
                    DbSewaTanah.colNames[DbSewaTanah.COL_SEWA_TANAH_ID] + " = " + sewaTanahId;

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
            String sql = "SELECT COUNT(" + DbSewaTanah.colNames[DbSewaTanah.COL_SEWA_TANAH_ID] + ") FROM " + DB_CRM_SEWA_TANAH;
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
                    SewaTanah sewatanah = (SewaTanah) list.get(ls);
                    if (oid == sewatanah.getOID()) {
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

    public static SewaTanah getActiveSewaTanah(long oidInvestor, long oidSarana) {

        if (oidInvestor != 0 && oidSarana != 0) {
            Vector temp = list(0, 1, colNames[COL_STATUS] + "=" + STATUS_AKTIF + " and " + colNames[COL_INVESTOR_ID] + "=" + oidInvestor + " and " + colNames[COL_CUSTOMER_ID] + "=" + oidSarana, "");
            if (temp != null && temp.size() > 0) {
                return (SewaTanah) temp.get(0);
            }
        }

        return new SewaTanah();

    }

    /**
     * Method to check if any contract contains same data
     * by gwawan 20110704
     * @param objSewaTanah
     * @return
     */
    public static boolean isContractExist(SewaTanah objSewaTanah) {
        CONResultSet dbrs = null;

        try {
            if (objSewaTanah.getCustomerId() != 0) {
                String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH + " WHERE " + colNames[COL_CUSTOMER_ID] + " = " + objSewaTanah.getCustomerId();
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();

                /**
                 * check if existing contract, contain same Sarana in the same Lot
                 */
                while (rs.next()) {
                    SewaTanah rsSewaTanah = new SewaTanah();
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
                    "AND " + DbSewaTanah.colNames[DbSewaTanah.COL_STATUS] + "=" + DbSewaTanah.STATUS_AKTIF;
            System.out.println("getSewaTanahList: "+sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SewaTanah objSewaTanah = new SewaTanah();
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
