
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
import com.project.simprop.*;
import com.project.general.*;
import com.project.util.*;
import com.project.general.Currency;
import com.project.general.DbCurrency;

public class DbSewaTanahBenefitProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PROP_SEWA_TANAH_BENEFIT = "prop_sewa_tanah_benefit";
    
    public static final int COL_SEWA_TANAH_BENEFIT_ID = 0;
    public static final int COL_SEWA_TANAH_ID = 1;
    public static final int COL_TANGGAL = 2;
    public static final int COL_TANGGAL_BENEFIT = 3;
    public static final int COL_INVESTOR_ID = 4;
    public static final int COL_SARANA_ID = 5;
    public static final int COL_COUNTER = 6;
    public static final int COL_PREFIX_NUMBER = 7;
    public static final int COL_NUMBER = 8;
    public static final int COL_KETERANGAN = 9;
    public static final int COL_STATUS = 10;
    public static final int COL_CREATED_BY_ID = 11;
    public static final int COL_APPROVED_BY_ID = 12;
    public static final int COL_APPROVED_BY_DATE = 13;
    public static final int COL_SEWA_TANAH_INVOICE_ID = 14;
    public static final int COL_PPN = 15;
    public static final int COL_PPN_PERCENT = 16;
    public static final int COL_PPH = 17;
    public static final int COL_PPH_PERCENT = 18;
    public static final int COL_TOTAL_DENDA = 19;
    public static final int COL_STATUS_PEMBAYARAN = 20;
    public static final int COL_CURRENCY_ID = 21;
    public static final int COL_TOTAL_KOMPER = 22;
    public static final int COL_JATUH_TEMPO = 23;
    public static final int COL_NO_FP = 24;
    public static final int COL_DENDA_DIAKUI = 25;
    public static final int COL_DENDA_APPROVE_ID = 26;
    public static final int COL_DENDA_APPROVE_DATE = 27;
    public static final int COL_DENDA_KETERANGAN = 28;
    public static final int COL_DENDA_POST_STATUS = 29;
    public static final int COL_DENDA_CLIENT_NAME = 30;
    public static final int COL_DENDA_CLIENT_POSITION = 31;
    
    public static final String[] colNames = {
        "sewa_tanah_benefit_id",//0
        "sewa_tanah_id",//1
        "tanggal",//2
        "tanggal_benefit",//3
        "investor_id",//4
        "sarana_id",//5
        "counter",//6
        "prefix_number",//7
        "number",//8
        "keterangan",//9
        "status",//10
        "created_by_id",//11
        "approved_by_id",//12
        "approved_by_date",//13
        "sewa_tanah_invoice_id",//14
        "ppn",//15
        "ppn_percent",//16
        "pph",//17
        "pph_percent",//18
        "total_denda",//19
        "status_pembayaran",//20
        "currency_id",//21
        "total_komper",//22
        "jatuh_tempo",//23
        "no_fp",//24                
        "denda_diakui",//25
        "denda_approve_id",//26
        "denda_approve_date",//27     
        "denda_keterangan",//28
        "denda_post_status",//29
        "denda_client_name",//30
        "denda_client_position"//31
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,//0
        TYPE_LONG,//1
        TYPE_DATE,//2
        TYPE_DATE,//3
        TYPE_LONG,//4
        TYPE_LONG,//5
        TYPE_INT,//6
        TYPE_STRING,//7
        TYPE_STRING,//8
        TYPE_STRING,//9
        TYPE_INT,//10
        TYPE_LONG,//11
        TYPE_LONG,//12
        TYPE_LONG,//13
        TYPE_LONG,//14
        TYPE_FLOAT,//15
        TYPE_FLOAT,//16
        TYPE_FLOAT,//17
        TYPE_FLOAT,//18
        TYPE_FLOAT,//19
        TYPE_INT,//20
        TYPE_LONG,//21
        TYPE_FLOAT,//22
        TYPE_DATE,//23
        TYPE_STRING,//24                
        TYPE_FLOAT,//25        
        TYPE_LONG,//26                
        TYPE_DATE,//27                
        TYPE_STRING,//28                
        TYPE_INT,//29                
        TYPE_STRING,//30                
        TYPE_STRING,//31                
    };
    
    public static final int STATUS_DENDA_DRAFT = 0;
    public static final int STATUS_DENDA_POSTED = 1;
    
    public static final String[] Posted_sts_denda_key = {"DRAFT", "POSTED"};
    public static final int[] Posted_sts_denda_value = {0, 1};
    
    public DbSewaTanahBenefitProp() {
    }

    public DbSewaTanahBenefitProp(int i) throws CONException {
        super(new DbSewaTanahBenefitProp());
    }

    public DbSewaTanahBenefitProp(String sOid) throws CONException {
        super(new DbSewaTanahBenefitProp(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanahBenefitProp(long lOid) throws CONException {
        super(new DbSewaTanahBenefitProp(0));
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
        return DB_PROP_SEWA_TANAH_BENEFIT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanahBenefitProp().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanahBenefitProp sewatanahbenefit = fetchExc(ent.getOID());
        ent = (Entity) sewatanahbenefit;
        return sewatanahbenefit.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanahBenefitProp) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanahBenefitProp) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanahBenefitProp fetchExc(long oid) throws CONException {
        try {
            SewaTanahBenefitProp sewatanahbenefit = new SewaTanahBenefitProp();
            DbSewaTanahBenefitProp pstSewaTanahBenefit = new DbSewaTanahBenefitProp(oid);
            sewatanahbenefit.setOID(oid);

            sewatanahbenefit.setSewaTanahId(pstSewaTanahBenefit.getlong(COL_SEWA_TANAH_ID));
            sewatanahbenefit.setTanggal(pstSewaTanahBenefit.getDate(COL_TANGGAL));
            sewatanahbenefit.setTanggalBenefit(pstSewaTanahBenefit.getDate(COL_TANGGAL_BENEFIT));
            sewatanahbenefit.setInvestorId(pstSewaTanahBenefit.getlong(COL_INVESTOR_ID));
            sewatanahbenefit.setSaranaId(pstSewaTanahBenefit.getlong(COL_SARANA_ID));
            sewatanahbenefit.setCounter(pstSewaTanahBenefit.getInt(COL_COUNTER));
            sewatanahbenefit.setPrefixNumber(pstSewaTanahBenefit.getString(COL_PREFIX_NUMBER));
            sewatanahbenefit.setNumber(pstSewaTanahBenefit.getString(COL_NUMBER));
            sewatanahbenefit.setKeterangan(pstSewaTanahBenefit.getString(COL_KETERANGAN));
            sewatanahbenefit.setStatus(pstSewaTanahBenefit.getInt(COL_STATUS));
            sewatanahbenefit.setCreatedById(pstSewaTanahBenefit.getlong(COL_CREATED_BY_ID));
            sewatanahbenefit.setApprovedById(pstSewaTanahBenefit.getlong(COL_APPROVED_BY_ID));
            sewatanahbenefit.setApprovedByDate(pstSewaTanahBenefit.getlong(COL_APPROVED_BY_DATE));
            sewatanahbenefit.setSewaTanahInvoiceId(pstSewaTanahBenefit.getlong(COL_SEWA_TANAH_INVOICE_ID));
            sewatanahbenefit.setPpn(pstSewaTanahBenefit.getdouble(COL_PPN));
            sewatanahbenefit.setPpnPercent(pstSewaTanahBenefit.getdouble(COL_PPN_PERCENT));
            sewatanahbenefit.setPph(pstSewaTanahBenefit.getdouble(COL_PPH));
            sewatanahbenefit.setPphPercent(pstSewaTanahBenefit.getdouble(COL_PPH_PERCENT));
            sewatanahbenefit.setTotalDenda(pstSewaTanahBenefit.getdouble(COL_TOTAL_DENDA));
            sewatanahbenefit.setStatusPembayaran(pstSewaTanahBenefit.getInt(COL_STATUS_PEMBAYARAN));
            sewatanahbenefit.setCurrencyId(pstSewaTanahBenefit.getlong(COL_CURRENCY_ID));
            sewatanahbenefit.setTotalKomper(pstSewaTanahBenefit.getdouble(COL_TOTAL_KOMPER));
            sewatanahbenefit.setJatuhTempo(pstSewaTanahBenefit.getDate(COL_JATUH_TEMPO));
            sewatanahbenefit.setNoFp(pstSewaTanahBenefit.getString(COL_NO_FP));
            
            sewatanahbenefit.setDendaDiakui(pstSewaTanahBenefit.getdouble(COL_DENDA_DIAKUI));
            sewatanahbenefit.setDendaApproveId(pstSewaTanahBenefit.getlong(COL_DENDA_APPROVE_ID));
            sewatanahbenefit.setDendaApproveDate(pstSewaTanahBenefit.getDate(COL_DENDA_APPROVE_DATE));            
            sewatanahbenefit.setDendaKeterangan(pstSewaTanahBenefit.getString(COL_DENDA_KETERANGAN));
            sewatanahbenefit.setDendaPostStatus(pstSewaTanahBenefit.getInt(COL_DENDA_POST_STATUS));
            sewatanahbenefit.setDendaClientName(pstSewaTanahBenefit.getString(COL_DENDA_CLIENT_NAME));
            sewatanahbenefit.setDendaClientPosition(pstSewaTanahBenefit.getString(COL_DENDA_CLIENT_POSITION));

            return sewatanahbenefit;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahBenefitProp(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanahBenefitProp sewatanahbenefit) throws CONException {
        try {
            DbSewaTanahBenefitProp pstSewaTanahBenefit = new DbSewaTanahBenefitProp(0);

            pstSewaTanahBenefit.setLong(COL_SEWA_TANAH_ID, sewatanahbenefit.getSewaTanahId());
            pstSewaTanahBenefit.setDate(COL_TANGGAL, sewatanahbenefit.getTanggal());
            pstSewaTanahBenefit.setDate(COL_TANGGAL_BENEFIT, sewatanahbenefit.getTanggalBenefit());
            pstSewaTanahBenefit.setLong(COL_INVESTOR_ID, sewatanahbenefit.getInvestorId());
            pstSewaTanahBenefit.setLong(COL_SARANA_ID, sewatanahbenefit.getSaranaId());
            pstSewaTanahBenefit.setInt(COL_COUNTER, sewatanahbenefit.getCounter());
            pstSewaTanahBenefit.setString(COL_PREFIX_NUMBER, sewatanahbenefit.getPrefixNumber());
            pstSewaTanahBenefit.setString(COL_NUMBER, sewatanahbenefit.getNumber());
            pstSewaTanahBenefit.setString(COL_KETERANGAN, sewatanahbenefit.getKeterangan());
            pstSewaTanahBenefit.setInt(COL_STATUS, sewatanahbenefit.getStatus());
            pstSewaTanahBenefit.setLong(COL_CREATED_BY_ID, sewatanahbenefit.getCreatedById());
            pstSewaTanahBenefit.setLong(COL_APPROVED_BY_ID, sewatanahbenefit.getApprovedById());
            pstSewaTanahBenefit.setLong(COL_APPROVED_BY_DATE, sewatanahbenefit.getApprovedByDate());
            pstSewaTanahBenefit.setLong(COL_SEWA_TANAH_INVOICE_ID, sewatanahbenefit.getSewaTanahInvoiceId());

            pstSewaTanahBenefit.setDouble(COL_PPN, sewatanahbenefit.getPpn());
            pstSewaTanahBenefit.setDouble(COL_PPN_PERCENT, sewatanahbenefit.getPpnPercent());
            pstSewaTanahBenefit.setDouble(COL_PPH, sewatanahbenefit.getPph());
            pstSewaTanahBenefit.setDouble(COL_PPH_PERCENT, sewatanahbenefit.getPphPercent());
            pstSewaTanahBenefit.setDouble(COL_TOTAL_DENDA, sewatanahbenefit.getTotalDenda());
            pstSewaTanahBenefit.setInt(COL_STATUS_PEMBAYARAN, sewatanahbenefit.getStatusPembayaran());
            pstSewaTanahBenefit.setLong(COL_CURRENCY_ID, sewatanahbenefit.getCurrencyId());
            pstSewaTanahBenefit.setDouble(COL_TOTAL_KOMPER, sewatanahbenefit.getTotalKomper());
            pstSewaTanahBenefit.setDate(COL_JATUH_TEMPO, sewatanahbenefit.getJatuhTempo());
            pstSewaTanahBenefit.setString(COL_NO_FP, sewatanahbenefit.getNoFp());
            
            pstSewaTanahBenefit.setDouble(COL_DENDA_DIAKUI, sewatanahbenefit.getDendaDiakui());        
            pstSewaTanahBenefit.setLong(COL_DENDA_APPROVE_ID, sewatanahbenefit.getDendaApproveId());        
            pstSewaTanahBenefit.setDate(COL_DENDA_APPROVE_DATE, sewatanahbenefit.getDendaApproveDate());        
            pstSewaTanahBenefit.setString(COL_DENDA_KETERANGAN, sewatanahbenefit.getDendaKeterangan());        
            pstSewaTanahBenefit.setInt(COL_DENDA_POST_STATUS, sewatanahbenefit.getDendaPostStatus());        
            pstSewaTanahBenefit.setString(COL_DENDA_CLIENT_NAME, sewatanahbenefit.getDendaClientName()); 
            pstSewaTanahBenefit.setString(COL_DENDA_CLIENT_POSITION, sewatanahbenefit.getDendaClientPosition()); 
                    
            pstSewaTanahBenefit.insert();
            sewatanahbenefit.setOID(pstSewaTanahBenefit.getlong(COL_SEWA_TANAH_BENEFIT_ID));
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahBenefitProp(0), CONException.UNKNOWN);
        }
        return sewatanahbenefit.getOID();
    }

    public static long updateExc(SewaTanahBenefitProp sewatanahbenefit) throws CONException {
        try {
            if (sewatanahbenefit.getOID() != 0) {
                DbSewaTanahBenefitProp pstSewaTanahBenefit = new DbSewaTanahBenefitProp(sewatanahbenefit.getOID());

                pstSewaTanahBenefit.setLong(COL_SEWA_TANAH_ID, sewatanahbenefit.getSewaTanahId());
                pstSewaTanahBenefit.setDate(COL_TANGGAL, sewatanahbenefit.getTanggal());
                pstSewaTanahBenefit.setDate(COL_TANGGAL_BENEFIT, sewatanahbenefit.getTanggalBenefit());
                pstSewaTanahBenefit.setLong(COL_INVESTOR_ID, sewatanahbenefit.getInvestorId());
                pstSewaTanahBenefit.setLong(COL_SARANA_ID, sewatanahbenefit.getSaranaId());
                pstSewaTanahBenefit.setInt(COL_COUNTER, sewatanahbenefit.getCounter());
                pstSewaTanahBenefit.setString(COL_PREFIX_NUMBER, sewatanahbenefit.getPrefixNumber());
                pstSewaTanahBenefit.setString(COL_NUMBER, sewatanahbenefit.getNumber());
                pstSewaTanahBenefit.setString(COL_KETERANGAN, sewatanahbenefit.getKeterangan());
                pstSewaTanahBenefit.setInt(COL_STATUS, sewatanahbenefit.getStatus());
                pstSewaTanahBenefit.setLong(COL_CREATED_BY_ID, sewatanahbenefit.getCreatedById());
                pstSewaTanahBenefit.setLong(COL_APPROVED_BY_ID, sewatanahbenefit.getApprovedById());
                pstSewaTanahBenefit.setLong(COL_APPROVED_BY_DATE, sewatanahbenefit.getApprovedByDate());
                pstSewaTanahBenefit.setLong(COL_SEWA_TANAH_INVOICE_ID, sewatanahbenefit.getSewaTanahInvoiceId());

                pstSewaTanahBenefit.setDouble(COL_PPN, sewatanahbenefit.getPpn());
                pstSewaTanahBenefit.setDouble(COL_PPN_PERCENT, sewatanahbenefit.getPpnPercent());
                pstSewaTanahBenefit.setDouble(COL_PPH, sewatanahbenefit.getPph());
                pstSewaTanahBenefit.setDouble(COL_PPH_PERCENT, sewatanahbenefit.getPphPercent());
                pstSewaTanahBenefit.setDouble(COL_TOTAL_DENDA, sewatanahbenefit.getTotalDenda());
                pstSewaTanahBenefit.setInt(COL_STATUS_PEMBAYARAN, sewatanahbenefit.getStatusPembayaran());
                pstSewaTanahBenefit.setLong(COL_CURRENCY_ID, sewatanahbenefit.getCurrencyId());
                pstSewaTanahBenefit.setDouble(COL_TOTAL_KOMPER, sewatanahbenefit.getTotalKomper());
                pstSewaTanahBenefit.setDate(COL_JATUH_TEMPO, sewatanahbenefit.getJatuhTempo());
                pstSewaTanahBenefit.setString(COL_NO_FP, sewatanahbenefit.getNoFp());

                pstSewaTanahBenefit.setDouble(COL_DENDA_DIAKUI, sewatanahbenefit.getDendaDiakui());        
                pstSewaTanahBenefit.setLong(COL_DENDA_APPROVE_ID, sewatanahbenefit.getDendaApproveId());        
                pstSewaTanahBenefit.setDate(COL_DENDA_APPROVE_DATE, sewatanahbenefit.getDendaApproveDate());        
                pstSewaTanahBenefit.setString(COL_DENDA_KETERANGAN, sewatanahbenefit.getDendaKeterangan());        
                pstSewaTanahBenefit.setInt(COL_DENDA_POST_STATUS, sewatanahbenefit.getDendaPostStatus());        
                pstSewaTanahBenefit.setString(COL_DENDA_CLIENT_NAME, sewatanahbenefit.getDendaClientName()); 
                pstSewaTanahBenefit.setString(COL_DENDA_CLIENT_POSITION, sewatanahbenefit.getDendaClientPosition());     

                pstSewaTanahBenefit.update();
                return sewatanahbenefit.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahBenefitProp(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanahBenefitProp pstSewaTanahBenefit = new DbSewaTanahBenefitProp(oid);
            pstSewaTanahBenefit.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahBenefitProp(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_BENEFIT;
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
                SewaTanahBenefitProp sewatanahbenefit = new SewaTanahBenefitProp();
                resultToObject(rs, sewatanahbenefit);
                lists.add(sewatanahbenefit);
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

    private static void resultToObject(ResultSet rs, SewaTanahBenefitProp sewatanahbenefit) {
        try {
            sewatanahbenefit.setOID(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_SEWA_TANAH_BENEFIT_ID]));
            sewatanahbenefit.setSewaTanahId(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_SEWA_TANAH_ID]));
            sewatanahbenefit.setTanggal(rs.getDate(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_TANGGAL]));
            sewatanahbenefit.setTanggalBenefit(rs.getDate(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_TANGGAL_BENEFIT]));
            sewatanahbenefit.setInvestorId(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_INVESTOR_ID]));
            sewatanahbenefit.setSaranaId(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_SARANA_ID]));
            sewatanahbenefit.setCounter(rs.getInt(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_COUNTER]));
            sewatanahbenefit.setPrefixNumber(rs.getString(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_PREFIX_NUMBER]));
            sewatanahbenefit.setNumber(rs.getString(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_NUMBER]));
            sewatanahbenefit.setKeterangan(rs.getString(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_KETERANGAN]));
            sewatanahbenefit.setStatus(rs.getInt(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_STATUS]));
            sewatanahbenefit.setCreatedById(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_CREATED_BY_ID]));
            sewatanahbenefit.setApprovedById(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_APPROVED_BY_ID]));
            sewatanahbenefit.setApprovedByDate(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_APPROVED_BY_DATE]));
            sewatanahbenefit.setSewaTanahInvoiceId(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_SEWA_TANAH_INVOICE_ID]));

            sewatanahbenefit.setPpn(rs.getDouble(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_PPN]));
            sewatanahbenefit.setPpnPercent(rs.getDouble(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_PPN_PERCENT]));
            sewatanahbenefit.setPph(rs.getDouble(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_PPH]));
            sewatanahbenefit.setPphPercent(rs.getDouble(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_PPH_PERCENT]));
            sewatanahbenefit.setTotalDenda(rs.getDouble(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_TOTAL_DENDA]));
            sewatanahbenefit.setStatusPembayaran(rs.getInt(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_STATUS_PEMBAYARAN]));
            sewatanahbenefit.setCurrencyId(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_CURRENCY_ID]));
            sewatanahbenefit.setTotalKomper(rs.getDouble(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_TOTAL_KOMPER]));
            sewatanahbenefit.setJatuhTempo(rs.getDate(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_JATUH_TEMPO]));
            sewatanahbenefit.setNoFp(rs.getString(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_NO_FP]));
            
            sewatanahbenefit.setDendaDiakui(rs.getDouble(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_DENDA_DIAKUI]));
            sewatanahbenefit.setDendaApproveId(rs.getLong(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_DENDA_APPROVE_ID]));
            sewatanahbenefit.setDendaApproveDate(rs.getDate(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_DENDA_APPROVE_DATE]));
            sewatanahbenefit.setDendaKeterangan(rs.getString(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_DENDA_KETERANGAN]));
            sewatanahbenefit.setDendaPostStatus(rs.getInt(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_DENDA_POST_STATUS]));
            sewatanahbenefit.setDendaClientName(rs.getString(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_DENDA_CLIENT_NAME]));
            sewatanahbenefit.setDendaClientPosition(rs.getString(DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_DENDA_CLIENT_POSITION]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahBenefitId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_BENEFIT + " WHERE " +
                    DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_SEWA_TANAH_BENEFIT_ID] + " = " + sewaTanahBenefitId;

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
            String sql = "SELECT COUNT(" + DbSewaTanahBenefitProp.colNames[DbSewaTanahBenefitProp.COL_SEWA_TANAH_BENEFIT_ID] + ") FROM " + DB_PROP_SEWA_TANAH_BENEFIT;
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
                    SewaTanahBenefitProp sewatanahbenefit = (SewaTanahBenefitProp) list.get(ls);
                    if (oid == sewatanahbenefit.getOID()) {
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

    public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_PROP_SEWA_TANAH_BENEFIT + " where " +
                    colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix() + "' ";

            System.out.println(sql);

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static String getNumberPrefix() {

        //Company sysCompany = DbCompany.getCompany();
        //Location sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());

        String code = "INC";//sysLocation.getCode();//DbSystemProperty.getValueByName("LOCATION_CODE");
        //code = code + sysCompany.getGeneralLedgerCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }

    public static String getNextNumber(int ctr) {

        String code = getNumberPrefix();

        if (ctr < 10) {
            code = code + "000" + ctr;
        } else if (ctr < 100) {
            code = code + "00" + ctr;
        } else if (ctr < 1000) {
            code = code + "0" + ctr;
        } else {
            code = code + ctr;
        }

        return code;

    }

    public static SewaTanahBenefitProp getKomperData(long kominId) {
        Vector temp = list(0, 0, colNames[COL_SEWA_TANAH_INVOICE_ID] + "=" + kominId, "");
        if (temp != null && temp.size() > 0) {
            return (SewaTanahBenefitProp) temp.get(0);
        }
        return new SewaTanahBenefitProp();
    }

    //journal income Income 90%, 
    //dimana pph sudah dikurangi dari income
    public static boolean postJournal(SewaTanahBenefitProp sewaTanahBenefitProp) {

        boolean ok = true;

        System.out.println("\n---- bean start posting journal AR Ass ---");

        Company comp = DbCompany.getCompany();

        //IrigasiTransaction limbah = cr;//new IrigasiTransaction();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanahBenefitProp.getSaranaId());
        } catch (Exception e) {
        }
        
        //if (cus.getOID() == 0 || cus.getKompenDebetAccountId() == 0 || cus.getKompenCreditAccountId() == 0 || cus.getKompenPpnAccountId() == 0) {
        //    return false;            
        //}

        //invoice - Invoice komper

        String memo = cus.getName() + " - Tagihan Kompensasi Persentase, invoice : " + sewaTanahBenefitProp.getNumber() +
                ", tanggal : " + JSPFormater.formatDate(sewaTanahBenefitProp.getTanggalBenefit(), "dd/MM/yyyy");

        //jika sarana mamakai 	                           
        if (true) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), sewaTanahBenefitProp.getCounter(), sewaTanahBenefitProp.getNumber(), sewaTanahBenefitProp.getNumber(),
                    I_Project.JOURNAL_TYPE_INVOICE,
                    memo, 0, "", sewaTanahBenefitProp.getOID(), "", sewaTanahBenefitProp.getTanggalBenefit());

            //pengakuan piutang
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double excRate = 0;
                if (sewaTanahBenefitProp.getCurrencyId() == comp.getBookingCurrencyId()) {
                    excRate = 1;
                } else {
                    ExchangeRate erate = DbExchangeRate.getStandardRate();
                    excRate = erate.getValueUsd();
                }

                Currency c = new Currency();
                try {
                    c = DbCurrency.fetchExc(sewaTanahBenefitProp.getCurrencyId());
                } catch (Exception e) {
                }

                //journal debet piutang
                //double harga = sewaTanahBenefitProp.getJumlah()+sewaTanahBenefitProp.getPpn()+sewaTanahBenefitProp.getPph();
                //piutang
                String detailMemo = memo + ", " + c.getCurrencyCode() + " " + JSPFormater.formatNumber(sewaTanahBenefitProp.getTotalKomper(), "#,###.##") +
                        ", ExcRate : " + JSPFormater.formatNumber(excRate, "#,###.##");

                //DbGl.postJournalDetail(excRate, cus.getKompenDebetAccountId(), 0, sewaTanahBenefitProp.getTotalKomper() * excRate,
                //        sewaTanahBenefitProp.getTotalKomper(), sewaTanahBenefitProp.getCurrencyId(), oid, detailMemo, 0);//non departmenttal item, department id = 0

                //pph
                //DbGl.postJournalDetail(excRate, cus.getAssesmentPphAccountId(), 0, sewaTanahBenefitProp.getPph()*-1* excRate,             
                //             sewaTanahBenefitProp.getPph()*-1, sewaTanahBenefitProp.getCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                //jurnal credit income
                detailMemo = memo + ", " + c.getCurrencyCode() + " " + JSPFormater.formatNumber(sewaTanahBenefitProp.getTotalKomper() - sewaTanahBenefitProp.getPpn(), "#,###.##") +
                        ", ExcRate : " + JSPFormater.formatNumber(excRate, "#,###.##");

                /*DbGl.postJournalDetail(excRate, cus.getKompenCreditAccountId(), (sewaTanahBenefitProp.getTotalKomper() - sewaTanahBenefitProp.getPpn()) * excRate, 0,
                        (sewaTanahBenefitProp.getTotalKomper() - sewaTanahBenefitProp.getPpn()), sewaTanahBenefitProp.getCurrencyId(), oid, detailMemo, 0);//non departmenttal item, department id = 0

                //journal credit ppn
                detailMemo = memo + ", " + c.getCurrencyCode() + " " + JSPFormater.formatNumber(sewaTanahBenefitProp.getPpn(), "#,###.##") +
                        ", ExcRate : " + JSPFormater.formatNumber(excRate, "#,###.##");

                DbGl.postJournalDetail(excRate, cus.getKompenPpnAccountId(), sewaTanahBenefitProp.getPpn() * excRate, 0,
                        sewaTanahBenefitProp.getPpn(), sewaTanahBenefitProp.getCurrencyId(), oid, detailMemo, 0);//non departmenttal item, department id = 0*/

                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahBenefitProp.setStatus(I_Prop.JURNAL_STATUS_POSTED);
                    DbSewaTanahBenefitProp.updateExc(sewaTanahBenefitProp);
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
