/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.transaction;

import com.project.I_Project;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.fms.session.SessOptimizedJournal;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbExchangeRate;
import com.project.general.ExchangeRate;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy
 */
public class DbBankpoGroup extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BANK_PO_GROUP = "bankpo_group";
    
    public static final int COL_BANKPO_GROUP_ID = 0;
    public static final int COL_COA_ID = 1;
    public static final int COL_JOURNAL_NUMBER = 2;
    public static final int COL_JOURNAL_COUNTER = 3;
    public static final int COL_JOURNAL_PREFIX = 4;
    public static final int COL_DATE = 5;
    public static final int COL_TRANS_DATE = 6;
    public static final int COL_OPERATOR_ID = 7;
    public static final int COL_AMOUNT = 8;
    public static final int COL_PAYMENT_METHOD_ID = 9;
    public static final int COL_PERIOD_ID = 10;
    public static final int COL_SEGMENT_1_ID = 11;
    public static final int COL_SEGMENT_2_ID = 12;
    public static final int COL_UNIQ_KEY_ID = 13;
    public static final int COL_MEMO = 14;
    
    public static final String[] colNames = {
        "bankpo_group_id",
        "coa_id",
        "journal_number",
        "journal_counter",
        "journal_prefix",
        "date",
        "trans_date",
        "operator_id",
        "amount",
        "payment_method_id",
        "periode_id",
        "segment1_id",
        "segment2_id",
        "uniq_key_id",
        "memo"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING
    };

    public DbBankpoGroup() {
    }

    public DbBankpoGroup(int i) throws CONException {
        super(new DbBankpoGroup());
    }

    public DbBankpoGroup(String sOid) throws CONException {
        super(new DbBankpoGroup(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankpoGroup(long lOid) throws CONException {
        super(new DbBankpoGroup(0));
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
        return DB_BANK_PO_GROUP;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankpoGroup().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BankpoGroup bankpoGroup = fetchExc(ent.getOID());
        ent = (Entity) bankpoGroup;
        return bankpoGroup.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BankpoGroup) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BankpoGroup) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BankpoGroup fetchExc(long oid) throws CONException {
        try {
            BankpoGroup bankpoGroup = new BankpoGroup();
            DbBankpoGroup pstBankpoGroup = new DbBankpoGroup(oid);
            bankpoGroup.setOID(oid);
            bankpoGroup.setCoaId(pstBankpoGroup.getlong(COL_COA_ID));
            bankpoGroup.setJournalNumber(pstBankpoGroup.getString(COL_JOURNAL_NUMBER));
            bankpoGroup.setJournalCounter(pstBankpoGroup.getInt(COL_JOURNAL_COUNTER));
            bankpoGroup.setJournalPrefix(pstBankpoGroup.getString(COL_JOURNAL_PREFIX));
            bankpoGroup.setDate(pstBankpoGroup.getDate(COL_DATE));
            bankpoGroup.setTransDate(pstBankpoGroup.getDate(COL_TRANS_DATE));
            bankpoGroup.setOperatorId(pstBankpoGroup.getlong(COL_OPERATOR_ID));
            bankpoGroup.setAmount(pstBankpoGroup.getdouble(COL_AMOUNT));
            bankpoGroup.setPaymentMethodId(pstBankpoGroup.getlong(COL_PAYMENT_METHOD_ID));
            bankpoGroup.setPeriodeId(pstBankpoGroup.getlong(COL_PERIOD_ID));
            bankpoGroup.setSegment1Id(pstBankpoGroup.getlong(COL_SEGMENT_1_ID));
            bankpoGroup.setSegment2Id(pstBankpoGroup.getlong(COL_SEGMENT_2_ID));
            bankpoGroup.setUniqKeyId(pstBankpoGroup.getlong(COL_UNIQ_KEY_ID));
            bankpoGroup.setMemo(pstBankpoGroup.getString(COL_MEMO));
            return bankpoGroup;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoGroup(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BankpoGroup bankpoGroup) throws CONException {
        try {
            DbBankpoGroup pstBankpoGroup = new DbBankpoGroup(0);

            pstBankpoGroup.setLong(COL_COA_ID, bankpoGroup.getCoaId());
            pstBankpoGroup.setString(COL_JOURNAL_NUMBER, bankpoGroup.getJournalNumber());
            pstBankpoGroup.setInt(COL_JOURNAL_COUNTER, bankpoGroup.getJournalCounter());
            pstBankpoGroup.setString(COL_JOURNAL_PREFIX, bankpoGroup.getJournalPrefix());
            pstBankpoGroup.setDate(COL_DATE, bankpoGroup.getDate());
            pstBankpoGroup.setDate(COL_TRANS_DATE, bankpoGroup.getTransDate());
            pstBankpoGroup.setLong(COL_OPERATOR_ID, bankpoGroup.getOperatorId());
            pstBankpoGroup.setDouble(COL_AMOUNT, bankpoGroup.getAmount());
            pstBankpoGroup.setLong(COL_PAYMENT_METHOD_ID, bankpoGroup.getPaymentMethodId());
            pstBankpoGroup.setLong(COL_PERIOD_ID, bankpoGroup.getPeriodeId());
            pstBankpoGroup.setLong(COL_SEGMENT_1_ID, bankpoGroup.getSegment1Id());
            pstBankpoGroup.setLong(COL_SEGMENT_2_ID, bankpoGroup.getSegment2Id());
            pstBankpoGroup.setLong(COL_UNIQ_KEY_ID, bankpoGroup.getUniqKeyId());
            pstBankpoGroup.setString(COL_MEMO, bankpoGroup.getMemo());
            pstBankpoGroup.insert();
            bankpoGroup.setOID(pstBankpoGroup.getlong(COL_BANKPO_GROUP_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoGroup(0), CONException.UNKNOWN);
        }
        return bankpoGroup.getOID();
    }

    public static long updateExc(BankpoGroup bankpoGroup) throws CONException {
        try {
            if (bankpoGroup.getOID() != 0) {
                DbBankpoGroup pstBankpoGroup = new DbBankpoGroup(bankpoGroup.getOID());

                pstBankpoGroup.setLong(COL_COA_ID, bankpoGroup.getCoaId());
                pstBankpoGroup.setString(COL_JOURNAL_NUMBER, bankpoGroup.getJournalNumber());
                pstBankpoGroup.setInt(COL_JOURNAL_COUNTER, bankpoGroup.getJournalCounter());
                pstBankpoGroup.setString(COL_JOURNAL_PREFIX, bankpoGroup.getJournalPrefix());
                pstBankpoGroup.setDate(COL_DATE, bankpoGroup.getDate());
                pstBankpoGroup.setDate(COL_TRANS_DATE, bankpoGroup.getTransDate());
                pstBankpoGroup.setLong(COL_OPERATOR_ID, bankpoGroup.getOperatorId());
                pstBankpoGroup.setDouble(COL_AMOUNT, bankpoGroup.getAmount());
                pstBankpoGroup.setLong(COL_PAYMENT_METHOD_ID, bankpoGroup.getPaymentMethodId());
                pstBankpoGroup.setLong(COL_PERIOD_ID, bankpoGroup.getPeriodeId());
                pstBankpoGroup.setLong(COL_SEGMENT_1_ID, bankpoGroup.getSegment1Id());
                pstBankpoGroup.setLong(COL_SEGMENT_2_ID, bankpoGroup.getSegment2Id());
                pstBankpoGroup.setLong(COL_UNIQ_KEY_ID, bankpoGroup.getUniqKeyId());
                pstBankpoGroup.setString(COL_MEMO, bankpoGroup.getMemo());
                pstBankpoGroup.update();
                return bankpoGroup.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoGroup(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBankpoGroup pstBankpoGroup = new DbBankpoGroup(oid);
            pstBankpoGroup.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoGroup(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANK_PO_GROUP;
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
                BankpoGroup bankpoGroup = new BankpoGroup();
                resultToObject(rs, bankpoGroup);
                lists.add(bankpoGroup);
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

    private static void resultToObject(ResultSet rs, BankpoGroup bankpoGroup) {
        try {
            bankpoGroup.setOID(rs.getLong(DbBankpoGroup.colNames[DbBankpoGroup.COL_BANKPO_GROUP_ID]));
            bankpoGroup.setCoaId(rs.getLong(DbBankpoGroup.colNames[DbBankpoGroup.COL_COA_ID]));
            bankpoGroup.setJournalNumber(rs.getString(DbBankpoGroup.colNames[DbBankpoGroup.COL_JOURNAL_NUMBER]));
            bankpoGroup.setJournalCounter(rs.getInt(DbBankpoGroup.colNames[DbBankpoGroup.COL_JOURNAL_COUNTER]));
            bankpoGroup.setJournalPrefix(rs.getString(DbBankpoGroup.colNames[DbBankpoGroup.COL_JOURNAL_PREFIX]));
            bankpoGroup.setDate(rs.getDate(DbBankpoGroup.colNames[DbBankpoGroup.COL_DATE]));
            bankpoGroup.setTransDate(rs.getDate(DbBankpoGroup.colNames[DbBankpoGroup.COL_TRANS_DATE]));
            bankpoGroup.setOperatorId(rs.getLong(DbBankpoGroup.colNames[DbBankpoGroup.COL_OPERATOR_ID]));
            bankpoGroup.setAmount(rs.getDouble(DbBankpoGroup.colNames[DbBankpoGroup.COL_AMOUNT]));
            bankpoGroup.setPaymentMethodId(rs.getLong(DbBankpoGroup.colNames[DbBankpoGroup.COL_PAYMENT_METHOD_ID]));
            bankpoGroup.setPeriodeId(rs.getLong(DbBankpoGroup.colNames[DbBankpoGroup.COL_PERIOD_ID]));
            bankpoGroup.setSegment1Id(rs.getLong(DbBankpoGroup.colNames[DbBankpoGroup.COL_SEGMENT_1_ID]));
            bankpoGroup.setSegment2Id(rs.getLong(DbBankpoGroup.colNames[DbBankpoGroup.COL_SEGMENT_2_ID]));
            bankpoGroup.setUniqKeyId(rs.getLong(DbBankpoGroup.colNames[DbBankpoGroup.COL_UNIQ_KEY_ID]));
            bankpoGroup.setMemo(rs.getString(DbBankpoGroup.colNames[DbBankpoGroup.COL_MEMO]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long bankpoGroupId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANK_PO_GROUP + " WHERE " +
                    DbBankpoGroup.colNames[DbBankpoGroup.COL_BANKPO_GROUP_ID] + " = " + bankpoGroupId;

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
            String sql = "SELECT COUNT(" + DbBankpoGroup.colNames[DbBankpoGroup.COL_BANKPO_GROUP_ID] + ") FROM " + DB_BANK_PO_GROUP;
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
                    BankpoGroup bankpoGroup = (BankpoGroup) list.get(ls);
                    if (oid == bankpoGroup.getOID()) {
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
    
    
    public static long postJournal(BankpoGroup bankpoGroup,long userId,long coaDebetId, String ketMaterai){
        try{
            Company comp = DbCompany.getCompany();
            ExchangeRate er = DbExchangeRate.getStandardRate();

            try {
                bankpoGroup = DbBankpoGroup.fetchExc(bankpoGroup.getOID());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }
        
            Periode periode = new Periode();
            try {
                periode = DbPeriode.fetchExc(bankpoGroup.getPeriodeId());
            } catch (Exception e) {} 
            
            Vector details = DbBankpoGroupDetail.list(0, 0,DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_BANKPO_GROUP_ID]+" = "+bankpoGroup.getOID(), null);
            
            if (periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0 && bankpoGroup.getOID() != 0 && details != null && details.size() > 0) {
                
                long oid = DbGl.postJournalMain(0, bankpoGroup.getDate(), bankpoGroup.getJournalCounter(), bankpoGroup.getJournalNumber(), bankpoGroup.getJournalPrefix(), I_Project.JOURNAL_TYPE_BANK_PAYMENT_GROUP,
                    bankpoGroup.getMemo(), userId, "", bankpoGroup.getOID(), "", bankpoGroup.getTransDate(), bankpoGroup.getPeriodeId());
                
                if(oid != 0){                    
                    for (int i = 0; i < details.size(); i++) {
                        BankpoGroupDetail bgd = (BankpoGroupDetail) details.get(i);
                        BankpoPayment bp = new BankpoPayment();
                        try{
                            bp = DbBankpoPayment.fetchExc(bgd.getRefId());
                        }catch(Exception e){}
                        
                        if(bgd.getType() == DbBankpoGroupDetail.TYPE_BANK_PO){
                            Vector bpds = DbBankpoPaymentDetail.list(0, 1, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = "+bgd.getRefId(), null);
                            if(bpds != null && bpds.size() > 0){
                                BankpoPaymentDetail bpd = (BankpoPaymentDetail)bpds.get(0);
                                
                                DbGl.postJournalDetail(er.getValueIdr(), bpd.getCoaId(), 0, bpd.getPaymentAmount(),
                                    0, comp.getBookingCurrencyId(), oid, bpd.getMemo(), 0,
                                    bpd.getSegment1Id(), bpd.getSegment2Id(), bpd.getSegment3Id(), bpd.getSegment4Id(),
                                    bpd.getSegment5Id(), bpd.getSegment6Id(), bpd.getSegment7Id(), bpd.getSegment8Id(),
                                    bpd.getSegment9Id(), bpd.getSegment10Id(), bpd.getSegment11Id(), bpd.getSegment12Id(),
                                    bpd.getSegment13Id(), bpd.getSegment14Id(), bpd.getSegment15Id(), bpd.getModuleId());
                            }
                            
                            //journal credit pada kas
                            DbGl.postJournalDetail(er.getValueIdr(), bp.getCoaId(), bp.getAmount(), 0,
                                0, comp.getBookingCurrencyId(), oid, bp.getMemo(), 0,
                                bp.getSegment1Id(), bp.getSegment2Id(), bp.getSegment3Id(), bp.getSegment4Id(),
                                bp.getSegment5Id(), bp.getSegment6Id(), bp.getSegment7Id(), bp.getSegment8Id(),
                                bp.getSegment9Id(), bp.getSegment10Id(), bp.getSegment11Id(), bp.getSegment12Id(),
                                bp.getSegment13Id(), bp.getSegment14Id(), bp.getSegment15Id(), 0); // petty cash : non departmental coa
                            
                            
                            try {
                                bp.setPostedStatus(1);
                                bp.setPostedById(userId);
                                bp.setPostedDate(new Date());
                                bp.setStatus(DbBankpoPayment.STATUS_PAID);

                                Date dt = new Date();
                                String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                    DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                    DbPeriode.colNames[DbPeriode.COL_END_DATE];

                                Vector temp = DbPeriode.list(0, 0, where, "");

                                if (temp != null && temp.size() > 0) {
                                    bp.setEffectiveDate(new Date());
                                } else {
                                    Periode per = DbPeriode.getOpenPeriod();
                                    if (bp.getPeriodeId() != 0) {
                                        try {
                                            per = DbPeriode.fetchExc(bp.getPeriodeId());
                                        } catch (Exception e) {
                                        }
                                    }
                                    bp.setEffectiveDate(per.getEndDate());
                                }

                                DbBankpoPayment.updateExc(bp);

                            } catch (Exception e) {
                                System.out.println("[exception]" + e.toString());
                            }
                            
                        }else if(bgd.getType() == DbBankpoGroupDetail.TYPE_GENERAL_LEDGER){
                            DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), bgd.getCoaId(),bgd.getAmount(), 0,
                                bgd.getAmount(), er.getCurrencyIdrId(), oid, ketMaterai, 0,
                                bgd.getSegment1Id(), 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
                            
                            DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), coaDebetId, 0, bgd.getAmount(),
                                bgd.getAmount(), er.getCurrencyIdrId(), oid, ketMaterai, 0,
                                bgd.getSegment1Id(), 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
                        }
                    }
                    
                    SessOptimizedJournal.optimizeJournalGl(periode, oid,"Pembayaran Hutang Suplier, ", "Pembayaran Hutang Suplier, ", 1); 
                    
                }
            }
        }catch(Exception e){}
        
        return 0;        
    }
    
    
    public static long getReceiveId(long bankpoPaymentId){
        CONResultSet dbrs = null;
        long oid = 0;
        try{
            String sql = "select invoice_id from bankpo_payment_detail where bankpo_payment_id = "+bankpoPaymentId+" limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                oid = rs.getLong("invoice_id");
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);            
        }
        return oid;
        
    }
    
    public static String getVendor(long bankpoPaymentId){
        long receiveId = getReceiveId(bankpoPaymentId);
        CONResultSet dbrs = null;
        String name = "";
        try{
            String sql = "select v.name as name from pos_receive r inner join vendor v on r.vendor_id = v.vendor_id where r.receive_id = "+receiveId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                name = rs.getString("name");
            }
            rs.close();
            
        }catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);            
        }
        return name;
    }
    
    
}
