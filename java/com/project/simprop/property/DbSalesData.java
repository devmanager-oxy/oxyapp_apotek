/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.crm.transaction.DbPembayaran;
import com.project.general.DbCustomer;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.SystemDocCode;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.payroll.DbEmployee;
import com.project.simprop.session.PlafonBank;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class DbSalesData extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_SALES_DATA = "prop_sales_data";
    
    public static final int COL_SALES_DATA_ID = 0;
    public static final int COL_PROPERTY_ID = 1;
    public static final int COL_BUILDING_ID = 2;
    public static final int COL_FLOOR_ID = 3;
    public static final int COL_LOT_ID = 4;
    public static final int COL_LOT_TYPE_ID = 5;
    public static final int COL_USER_ID = 6;
    public static final int COL_SALES_NUMBER = 7;
    public static final int COL_DATE_TRANSACTION = 8;
    public static final int COL_PAYMENT_TYPE = 9;
    public static final int COL_SALES_PRICE = 10;
    public static final int COL_DISCOUNT = 11;
    public static final int COL_PRICE_AFTER_DISCOUNT = 12;
    public static final int COL_PPN = 13;
    public static final int COL_FINAL_PRICE = 14;
    public static final int COL_BF_AMOUNT = 15;
    public static final int COL_BF_DUE_DATE = 16;
    public static final int COL_DP_AMOUNT = 17;
    public static final int COL_DP_DUE_DATE = 18;
    public static final int COL_AMOUNT_PELUNASAN = 19;
    public static final int COL_PELUNASAN_DUE_DATE = 20;
    public static final int COL_NAME = 21;
    public static final int COL_ADDRESS = 22;
    public static final int COL_ADDRESS2 = 23;
    public static final int COL_ID_NUMBER = 24;
    public static final int COL_PH = 25;
    public static final int COL_TELEPHONE = 26;
    public static final int COL_EMAIL = 27;
    public static final int COL_SPECIAL_REQUIREMENT = 28;
    public static final int COL_USER_NAME = 29;
    public static final int COL_JOURNAL_COUNTER = 30;
    public static final int COL_JOURNAL_PREFIX = 31;
    public static final int COL_CUSTOMER_ID = 32;    
    public static final int COL_PERSEN_DP = 33;
    public static final int COL_PERSEN_PELUNASAN = 34;
    public static final int COL_PERIODE = 35;
    public static final int COL_ANGSURAN = 36;
    public static final int COL_PERSEN_ANGSURAN = 37;
    public static final int COL_DUE_DATE_ANGSURAN = 38;
    public static final int COL_PERSEN_BUNGA = 39;
    public static final int COL_PERIODE_DP = 40;
    public static final int COL_STATUS = 41;
    public static final int COL_BIAYA_KPA = 42;
    
    public static final int COL_BANK_ID = 43;
    public static final int COL_COVER_AMOUNT = 44;
    public static final int COL_CREATE_ID = 45;
    public static final int COL_NPWP = 46;
    
    public static final String[] colNames = {
        "sales_data_id", // 0
        "property_id",
        "building_id",
        "floor_id",
        "lot_id",
        "lot_type_id",
        "user_id",
        "sales_number",
        "date_transaction",
        "payment_type",
        "sales_price",
        "discount",
        "price_after_discount",
        "ppn",
        "final_price",
        "bf_amount", // 15
        "bf_due_date",
        "dp_amount",
        "dp_due_date",
        "amount_pelunasan",
        "pelunasan_due_date",
        "name",
        "address",
        "address2",
        "id_number",
        "ph", // 25
        "telephone",
        "email",
        "special_requirement",
        "user_name",
        "journal_counter",
        "journal_prefix",
        "customer_id",        
        "persen_dp",
        "persen_pelunasan",
        "periode",
        "angsuran", //36
        "persen_angsuran",
        "due_date_angsuran",
        "persen_bunga",
        "periode_dp",
        "status",
        "biaya_kpa",
        "bank_id",
        "cover_amount",
        "create_id",
        "npwp"
    };
    
    public static final int[] fieldTypes = {        
        TYPE_LONG + TYPE_PK + TYPE_ID, //sales_data_id
        TYPE_LONG, //property_id
        TYPE_LONG, //building_id
        TYPE_LONG, //floor_id
        TYPE_LONG, //lot_id
        TYPE_LONG, //lot_type_id
        TYPE_LONG, //user_id
        TYPE_STRING, //sales_number
        TYPE_DATE, //date_transaction
        TYPE_INT, //payment_type
        TYPE_FLOAT, //sales_price
        TYPE_FLOAT, //discount
        TYPE_FLOAT, //price_after_discount
        TYPE_FLOAT, //ppn
        TYPE_FLOAT, //final_price 
        TYPE_FLOAT, //bf_amount
        TYPE_DATE, //bf_due_date
        TYPE_FLOAT, //dp_amount
        TYPE_DATE, //dp_due_date
        TYPE_FLOAT, //amount_pelunasan
        TYPE_DATE, //pelunasan_due_date
        TYPE_STRING, //name
        TYPE_STRING, //address
        TYPE_STRING, //address2
        TYPE_STRING, //id_number
        TYPE_STRING, //ph 
        TYPE_STRING, //telephone
        TYPE_STRING, //email
        TYPE_STRING, //special_requirement
        TYPE_STRING, //user_name
        TYPE_INT, //journal_counter
        TYPE_STRING, //journal_prefix
        TYPE_LONG, //customer_id        
        TYPE_FLOAT, //persen_dp
        TYPE_FLOAT, //persen_pelunasan        
        TYPE_INT, //periode
        TYPE_FLOAT, //angsuran
        TYPE_FLOAT, //persen_angsuran
        TYPE_DATE, //due_date_angsuran
        TYPE_FLOAT, //persen_bunga
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING
    };
    
    public static final String[] romawi = {
        "I",
        "II",
        "III",
        "IV",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
        "X",
        "XI",
        "XII"
    };
    
    public static final int TYPE_HARD_CASH = 0;
    public static final int TYPE_CASH_BERJANGKA = 1;
    public static final int TYPE_KPA = 2;
    
    public static final int[] paymentTypeValue = {0, 1 , 2};
    public static final String[] paymentTypeKey = {"Hard Cash", "Cash Berjangka" , "KPA"};
    
    public static final int TERMIN_12 = 0;
    public static final int TERMIN_18 = 1;
    public static final int TERMIN_24 = 2;
    public static final int TERMIN_27 = 3;
    public static final int TERMIN_30 = 4;
    public static final int TERMIN_36 = 5;
    public static final int TERMIN_42 = 6;
    public static final int TERMIN_48 = 7;
    public static final int TERMIN_54 = 8;
    public static final int TERMIN_60 = 9;
    
    public static final int[] terminValue = {12, 18 , 24, 27, 30, 36, 42, 48, 54, 60};
    public static final String[] terminKey = {"12", "18" , "24", "27", "30","36","42","48","54","60"};    
    
    public static final int KPA_5  = 0;
    public static final int KPA_10 = 1;
    public static final int KPA_15 = 2;
    public static final int KPA_20 = 3;
    public static final int KPA_25 = 4;
    public static final int KPA_30 = 5;
    
    public static final int[] kpaValue = {5, 10 , 15, 20, 25, 30};
    public static final String[] kpaKey = {"5", "10" , "15", "20", "25", "30"};
    
    public static final int STATUS_RESERVATION  = 0;
    public static final int STATUS_BOOKED  = 1;
    public static final int STATUS_SOLD  = 2;
    public static final int STATUS_CANCEL  = 3;
    
    public static final int[] statusValue = {0, 1 , 2, 3};
    public static final String[] statusKey = {"Reservation", "Booked" , "Sold", "Cancel"};
    

    public DbSalesData() {
    }

    public DbSalesData(int i) throws CONException {
        super(new DbSalesData());
    }

    public DbSalesData(String sOid) throws CONException {
        super(new DbSalesData(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSalesData(long lOid) throws CONException {
        super(new DbSalesData(0));
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
        return DB_SALES_DATA;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSalesData().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SalesData salesData = fetchExc(ent.getOID());
        ent = (Entity) salesData;
        return salesData.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SalesData) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SalesData) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SalesData fetchExc(long oid) throws CONException {
        try {
            SalesData salesData = new SalesData();
            DbSalesData pstSalesData = new DbSalesData(oid);
            salesData.setOID(oid);

            salesData.setPropertyId(pstSalesData.getlong(COL_PROPERTY_ID));
            salesData.setBuildingId(pstSalesData.getlong(COL_BUILDING_ID));
            salesData.setFloorId(pstSalesData.getlong(COL_FLOOR_ID));
            salesData.setLotId(pstSalesData.getlong(COL_LOT_ID));
            salesData.setLotTypeId(pstSalesData.getlong(COL_LOT_TYPE_ID));
            salesData.setUserId(pstSalesData.getlong(COL_USER_ID));
            salesData.setSalesNumber(pstSalesData.getString(COL_SALES_NUMBER));
            salesData.setDateTransaction(pstSalesData.getDate(COL_DATE_TRANSACTION));
            salesData.setPaymentType(pstSalesData.getInt(COL_PAYMENT_TYPE));
            salesData.setSalesPrice(pstSalesData.getdouble(COL_SALES_PRICE));
            salesData.setDiscount(pstSalesData.getdouble(COL_DISCOUNT));
            salesData.setPriceAfterDiscount(pstSalesData.getdouble(COL_PRICE_AFTER_DISCOUNT));
            salesData.setPpn(pstSalesData.getdouble(COL_PPN));
            salesData.setFinalPrice(pstSalesData.getdouble(COL_FINAL_PRICE));
            salesData.setBfAmount(pstSalesData.getdouble(COL_BF_AMOUNT));
            salesData.setBfDueDate(pstSalesData.getDate(COL_BF_DUE_DATE));
            salesData.setDpAmount(pstSalesData.getdouble(COL_DP_AMOUNT));
            salesData.setDpDueDate(pstSalesData.getDate(COL_DP_DUE_DATE));
            salesData.setAmountPelunasan(pstSalesData.getdouble(COL_AMOUNT_PELUNASAN));
            salesData.setPelunasanDueDate(pstSalesData.getDate(COL_PELUNASAN_DUE_DATE));
            salesData.setName(pstSalesData.getString(COL_NAME));
            salesData.setAddress(pstSalesData.getString(COL_ADDRESS));
            salesData.setAddress2(pstSalesData.getString(COL_ADDRESS2));
            salesData.setIdNumber(pstSalesData.getString(COL_ID_NUMBER));
            salesData.setPh(pstSalesData.getString(COL_PH));
            salesData.setTelephone(pstSalesData.getString(COL_TELEPHONE));
            salesData.setEmail(pstSalesData.getString(COL_EMAIL));
            salesData.setSpecialRequirement(pstSalesData.getString(COL_SPECIAL_REQUIREMENT));
            salesData.setUserName(pstSalesData.getString(COL_USER_NAME));
            salesData.setJournalCounter(pstSalesData.getInt(COL_JOURNAL_COUNTER));
            salesData.setJournalPrefix(pstSalesData.getString(COL_JOURNAL_PREFIX));
            salesData.setCustomerId(pstSalesData.getlong(COL_CUSTOMER_ID));            
            salesData.setPersenDp(pstSalesData.getdouble(COL_PERSEN_DP));
            salesData.setPersenPelunasan(pstSalesData.getdouble(COL_PERSEN_PELUNASAN));
            salesData.setPeriode(pstSalesData.getInt(COL_PERIODE));
            salesData.setAngsuran(pstSalesData.getdouble(COL_ANGSURAN));
            salesData.setPersenAngsuran(pstSalesData.getdouble(COL_PERSEN_ANGSURAN));
            salesData.setDueDateAngsuran(pstSalesData.getDate(COL_DUE_DATE_ANGSURAN));
            salesData.setPersenBunga(pstSalesData.getdouble(COL_PERSEN_BUNGA));
            salesData.setPeriodeDp(pstSalesData.getInt(COL_PERIODE_DP));
            salesData.setStatus(pstSalesData.getInt(COL_STATUS));
            salesData.setBiayaKpa(pstSalesData.getdouble(COL_BIAYA_KPA));            
            salesData.setBankId(pstSalesData.getlong(COL_BANK_ID));
            salesData.setCoverAmount(pstSalesData.getdouble(COL_COVER_AMOUNT));
            salesData.setCreateId(pstSalesData.getlong(COL_CREATE_ID));
            salesData.setNpwp(pstSalesData.getString(COL_NPWP));

            return salesData;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesData(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SalesData salesData) throws CONException {
        try {
            DbSalesData pstSalesData = new DbSalesData(0);

            pstSalesData.setLong(COL_PROPERTY_ID, salesData.getPropertyId());
            pstSalesData.setLong(COL_BUILDING_ID, salesData.getBuildingId());
            pstSalesData.setLong(COL_FLOOR_ID, salesData.getFloorId());
            pstSalesData.setLong(COL_LOT_ID, salesData.getLotId());
            pstSalesData.setLong(COL_LOT_TYPE_ID, salesData.getLotTypeId());
            pstSalesData.setLong(COL_USER_ID, salesData.getUserId());
            pstSalesData.setString(COL_SALES_NUMBER, salesData.getSalesNumber());
            pstSalesData.setDate(COL_DATE_TRANSACTION, salesData.getDateTransaction());
            pstSalesData.setInt(COL_PAYMENT_TYPE, salesData.getPaymentType());
            pstSalesData.setDouble(COL_SALES_PRICE, salesData.getSalesPrice());
            pstSalesData.setDouble(COL_DISCOUNT, salesData.getDiscount());
            pstSalesData.setDouble(COL_PRICE_AFTER_DISCOUNT, salesData.getPriceAfterDiscount());
            pstSalesData.setDouble(COL_PPN, salesData.getPpn());
            pstSalesData.setDouble(COL_FINAL_PRICE, salesData.getFinalPrice());
            pstSalesData.setDouble(COL_BF_AMOUNT, salesData.getBfAmount());
            pstSalesData.setDate(COL_BF_DUE_DATE, salesData.getBfDueDate());
            pstSalesData.setDouble(COL_DP_AMOUNT, salesData.getDpAmount());
            pstSalesData.setDate(COL_DP_DUE_DATE, salesData.getDpDueDate());
            pstSalesData.setDouble(COL_AMOUNT_PELUNASAN, salesData.getAmountPelunasan());
            pstSalesData.setString(COL_NAME, salesData.getName());
            pstSalesData.setString(COL_ADDRESS, salesData.getAddress());
            pstSalesData.setString(COL_ADDRESS2, salesData.getAddress2());
            pstSalesData.setString(COL_ID_NUMBER, salesData.getIdNumber());
            pstSalesData.setString(COL_PH, salesData.getPh());
            pstSalesData.setString(COL_TELEPHONE, salesData.getTelephone());
            pstSalesData.setString(COL_EMAIL, salesData.getEmail());
            pstSalesData.setString(COL_SPECIAL_REQUIREMENT, salesData.getSpecialRequirement());
            pstSalesData.setString(COL_USER_NAME, salesData.getUserName());
            pstSalesData.setInt(COL_JOURNAL_COUNTER, salesData.getJournalCounter());
            pstSalesData.setString(COL_JOURNAL_PREFIX, salesData.getJournalPrefix());
            pstSalesData.setLong(COL_CUSTOMER_ID, salesData.getCustomerId());            
            pstSalesData.setDouble(COL_PERSEN_DP, salesData.getPersenDp());
            pstSalesData.setDouble(COL_PERSEN_PELUNASAN, salesData.getPersenPelunasan());
            pstSalesData.setInt(COL_PERIODE, salesData.getPeriode());
            pstSalesData.setDouble(COL_ANGSURAN, salesData.getAngsuran());
            pstSalesData.setDouble(COL_PERSEN_ANGSURAN, salesData.getPersenAngsuran());
            pstSalesData.setDate(COL_DUE_DATE_ANGSURAN, salesData.getDueDateAngsuran());
            pstSalesData.setDouble(COL_PERSEN_BUNGA, salesData.getPersenBunga());
            pstSalesData.setInt(COL_PERIODE_DP, salesData.getPeriodeDp());
            pstSalesData.setInt(COL_STATUS, salesData.getStatus());
            pstSalesData.setDate(COL_PELUNASAN_DUE_DATE, salesData.getPelunasanDueDate());
            pstSalesData.setDouble(COL_BIAYA_KPA, salesData.getBiayaKpa());            
            pstSalesData.setLong(COL_BANK_ID, salesData.getBankId());
            pstSalesData.setDouble(COL_COVER_AMOUNT, salesData.getCoverAmount());
            pstSalesData.setLong(COL_CREATE_ID, salesData.getCreateId());
            pstSalesData.setString(COL_NPWP, salesData.getNpwp());

            pstSalesData.insert();
            salesData.setOID(pstSalesData.getlong(COL_SALES_DATA_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesData(0), CONException.UNKNOWN);
        }
        return salesData.getOID();
    }

    public static long updateExc(SalesData salesData) throws CONException {
        try {
            if (salesData.getOID() != 0) {
                DbSalesData pstSalesData = new DbSalesData(salesData.getOID());

                pstSalesData.setLong(COL_PROPERTY_ID, salesData.getPropertyId());
                pstSalesData.setLong(COL_BUILDING_ID, salesData.getBuildingId());
                pstSalesData.setLong(COL_FLOOR_ID, salesData.getFloorId());
                pstSalesData.setLong(COL_LOT_ID, salesData.getLotId());
                pstSalesData.setLong(COL_LOT_TYPE_ID, salesData.getLotTypeId());
                pstSalesData.setLong(COL_USER_ID, salesData.getUserId());
                pstSalesData.setString(COL_SALES_NUMBER, salesData.getSalesNumber());
                pstSalesData.setDate(COL_DATE_TRANSACTION, salesData.getDateTransaction());
                pstSalesData.setInt(COL_PAYMENT_TYPE, salesData.getPaymentType());
                pstSalesData.setDouble(COL_SALES_PRICE, salesData.getSalesPrice());
                pstSalesData.setDouble(COL_DISCOUNT, salesData.getDiscount());
                pstSalesData.setDouble(COL_PRICE_AFTER_DISCOUNT, salesData.getPriceAfterDiscount());
                pstSalesData.setDouble(COL_PPN, salesData.getPpn());
                pstSalesData.setDouble(COL_FINAL_PRICE, salesData.getFinalPrice());
                pstSalesData.setDouble(COL_BF_AMOUNT, salesData.getBfAmount());
                pstSalesData.setDate(COL_BF_DUE_DATE, salesData.getBfDueDate());
                pstSalesData.setDouble(COL_DP_AMOUNT, salesData.getDpAmount());
                pstSalesData.setDate(COL_DP_DUE_DATE, salesData.getDpDueDate());
                pstSalesData.setDouble(COL_AMOUNT_PELUNASAN, salesData.getAmountPelunasan());
                pstSalesData.setString(COL_NAME, salesData.getName());
                pstSalesData.setString(COL_ADDRESS, salesData.getAddress());
                pstSalesData.setString(COL_ADDRESS2, salesData.getAddress2());
                pstSalesData.setString(COL_ID_NUMBER, salesData.getIdNumber());
                pstSalesData.setString(COL_PH, salesData.getPh());
                pstSalesData.setString(COL_TELEPHONE, salesData.getTelephone());
                pstSalesData.setString(COL_EMAIL, salesData.getEmail());
                pstSalesData.setString(COL_SPECIAL_REQUIREMENT, salesData.getSpecialRequirement());
                pstSalesData.setString(COL_USER_NAME, salesData.getUserName());
                pstSalesData.setInt(COL_JOURNAL_COUNTER, salesData.getJournalCounter());
                pstSalesData.setString(COL_JOURNAL_PREFIX, salesData.getJournalPrefix());
                pstSalesData.setLong(COL_CUSTOMER_ID, salesData.getCustomerId());                
                pstSalesData.setDouble(COL_PERSEN_DP, salesData.getPersenDp());
                pstSalesData.setDouble(COL_PERSEN_PELUNASAN, salesData.getPersenPelunasan());
                pstSalesData.setInt(COL_PERIODE, salesData.getPeriode());
                pstSalesData.setDouble(COL_ANGSURAN, salesData.getAngsuran());
                pstSalesData.setDouble(COL_PERSEN_ANGSURAN, salesData.getPersenAngsuran());
                pstSalesData.setDate(COL_DUE_DATE_ANGSURAN, salesData.getDueDateAngsuran());
                pstSalesData.setDouble(COL_PERSEN_BUNGA, salesData.getPersenBunga());                
                pstSalesData.setInt(COL_PERIODE_DP, salesData.getPeriodeDp());
                pstSalesData.setInt(COL_STATUS, salesData.getStatus());
                pstSalesData.setDate(COL_PELUNASAN_DUE_DATE, salesData.getPelunasanDueDate());
                pstSalesData.setDouble(COL_BIAYA_KPA, salesData.getBiayaKpa());
                pstSalesData.setLong(COL_BANK_ID, salesData.getBankId());
                pstSalesData.setDouble(COL_COVER_AMOUNT, salesData.getCoverAmount());
                pstSalesData.setLong(COL_CREATE_ID, salesData.getCreateId());
                pstSalesData.setString(COL_NPWP, salesData.getNpwp());

                pstSalesData.update();
                return salesData.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesData(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSalesData pstSalesData = new DbSalesData(oid);
            pstSalesData.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesData(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SALES_DATA;
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
                SalesData salesData = new SalesData();
                resultToObject(rs, salesData);
                lists.add(salesData);
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

    private static void resultToObject(ResultSet rs, SalesData salesData) {
        try {

            salesData.setOID(rs.getLong(DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]));
            salesData.setPropertyId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID]));
            salesData.setBuildingId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_BUILDING_ID]));
            salesData.setFloorId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_FLOOR_ID]));
            salesData.setLotId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_LOT_ID]));
            salesData.setLotTypeId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_LOT_TYPE_ID]));
            salesData.setUserId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_USER_ID]));
            salesData.setSalesNumber(rs.getString(DbSalesData.colNames[DbSalesData.COL_SALES_NUMBER]));
            salesData.setDateTransaction(rs.getDate(DbSalesData.colNames[DbSalesData.COL_DATE_TRANSACTION]));
            salesData.setPaymentType(rs.getInt(DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]));
            salesData.setSalesPrice(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_SALES_PRICE]));
            salesData.setDiscount(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_DISCOUNT]));
            salesData.setPriceAfterDiscount(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_PRICE_AFTER_DISCOUNT]));
            salesData.setPpn(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_PPN]));
            salesData.setFinalPrice(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_FINAL_PRICE]));
            salesData.setBfAmount(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_BF_AMOUNT]));
            salesData.setBfDueDate(rs.getDate(DbSalesData.colNames[DbSalesData.COL_BF_DUE_DATE]));
            salesData.setBfDueDate(rs.getDate(DbSalesData.colNames[DbSalesData.COL_BF_DUE_DATE]));
            salesData.setDpAmount(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_DP_AMOUNT]));
            salesData.setDpDueDate(rs.getDate(DbSalesData.colNames[DbSalesData.COL_DP_DUE_DATE]));
            salesData.setAmountPelunasan(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_AMOUNT_PELUNASAN]));
            salesData.setName(rs.getString(DbSalesData.colNames[DbSalesData.COL_NAME]));
            salesData.setAddress(rs.getString(DbSalesData.colNames[DbSalesData.COL_ADDRESS]));
            salesData.setAddress2(rs.getString(DbSalesData.colNames[DbSalesData.COL_ADDRESS2]));
            salesData.setIdNumber(rs.getString(DbSalesData.colNames[DbSalesData.COL_ID_NUMBER]));
            salesData.setPh(rs.getString(DbSalesData.colNames[DbSalesData.COL_PH]));
            salesData.setTelephone(rs.getString(DbSalesData.colNames[DbSalesData.COL_TELEPHONE]));
            salesData.setEmail(rs.getString(DbSalesData.colNames[DbSalesData.COL_EMAIL]));
            salesData.setSpecialRequirement(rs.getString(DbSalesData.colNames[DbSalesData.COL_SPECIAL_REQUIREMENT]));            
            salesData.setUserName(rs.getString(DbSalesData.colNames[DbSalesData.COL_USER_NAME]));
            salesData.setJournalCounter(rs.getInt(DbSalesData.colNames[DbSalesData.COL_JOURNAL_COUNTER]));
            salesData.setJournalPrefix(rs.getString(DbSalesData.colNames[DbSalesData.COL_JOURNAL_PREFIX]));
            salesData.setCustomerId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]));            
            salesData.setPersenDp(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_PERSEN_DP]));
            salesData.setPersenPelunasan(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_PERSEN_PELUNASAN]));
            salesData.setPeriode(rs.getInt(DbSalesData.colNames[DbSalesData.COL_PERIODE]));
            salesData.setAngsuran(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_ANGSURAN]));
            salesData.setDueDateAngsuran(rs.getDate(DbSalesData.colNames[DbSalesData.COL_DUE_DATE_ANGSURAN]));
            salesData.setPersenBunga(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_PERSEN_BUNGA]));
            salesData.setPeriodeDp(rs.getInt(DbSalesData.colNames[DbSalesData.COL_PERIODE_DP]));
            salesData.setStatus(rs.getInt(DbSalesData.colNames[DbSalesData.COL_STATUS]));
            salesData.setPelunasanDueDate(rs.getDate(DbSalesData.colNames[DbSalesData.COL_PELUNASAN_DUE_DATE]));
            salesData.setBiayaKpa(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_BIAYA_KPA]));            
            salesData.setBankId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_BANK_ID]));
            salesData.setCoverAmount(rs.getDouble(DbSalesData.colNames[DbSalesData.COL_COVER_AMOUNT]));
            salesData.setCreateId(rs.getLong(DbSalesData.colNames[DbSalesData.COL_CREATE_ID]));
            salesData.setNpwp(rs.getString(DbSalesData.colNames[DbSalesData.COL_NPWP]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long salesDataId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SALES_DATA + " WHERE " +
                    DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID] + " = " + salesDataId;

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
            String sql = "SELECT COUNT(" + DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID] + ") FROM " + DB_SALES_DATA;
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
                    SalesData property = (SalesData) list.get(ls);
                    if (oid == property.getOID()) {
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
    
    
    public static Vector listInvoice(long customerId, int type, Date start, Date end){
        
        try{
            
            String where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+"<>0";
            
            //today
            if(type == 1){
                
                Date currDt = new Date();
                //Date startDate = currDt;
                //Date endDate = currDt;
                
                //long longstartDate = currDt.getTime() - (15 * 24 * 60 * 60 * 1000);
                //long longendDate = currDt.getTime() + (15 * 24 * 60 * 60 * 1000);
                
                //startDate = new Date(longstartDate);
                //endDate = new Date(longendDate);
                
                //String where = "";
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                    //where = DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }        
                
                //where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+" >= '"+JSPFormater.formatDate(startDate,"yyyy-MM-dd")+"' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+" <= '"+JSPFormater.formatDate(endDate,"yyyy-MM-dd")+"' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS_GEN]+" = 0 ";
                where = where + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+"='"+JSPFormater.formatDate(currDt,"yyyy-MM-dd")+"'"+
                            " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS_GEN]+" = 0 ";
                
                //Vector list = DbPaymentSimulation.list(0, 0, where, null);
                
                //return list;
                
                System.out.println("get todays due term = where -> "+where);
                
                return DbPaymentSimulation.list(0, 0, where, DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]);
                
            }
            //get this month
            else if(type == 2){
                
                Date currDt = new Date();
                int month = currDt.getMonth()+1;
                int year= currDt.getYear()+1900;
                
                //String where = "";
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                    //where = DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                } 
                                
                where = where+" month("+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+") = "+month+" and year("+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+") = "+year+" and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS_GEN]+" = 0 ";
                
                //Vector list = DbPaymentSimulation.list(0, 0, where, null);
                
                //return list;
                
                System.out.println("get this month due term = where -> "+where);
                
                return DbPaymentSimulation.list(0, 0, where, DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]);
                
            }
            //in range period
            else{
                //String where = "";
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                    //where = DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                } 
                
                where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+" <= '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS_GEN]+" = 0 ";
                
                //Vector list = DbPaymentSimulation.list(0, 0, where, null);
                //return list;
                
                System.out.println("get during period due term = where -> "+where);
                
                return DbPaymentSimulation.list(0, 0, where, DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]);
            }
            
        }catch(Exception e){
        
        }
        
        return null;
    }
    
     public static Vector listPrintInvoice(long customerId, int type, Date start, Date end){
        
        try{
            
            String where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+"<>0";
            
            //todays
            if(type == 1){
                
                Date currDt = new Date();
                //Date startDate = currDt;
                //Date endDate = currDt;
                
                //long longstartDate = currDt.getTime() - (15 * 24 * 60 * 60 * 1000);
                //long longendDate = currDt.getTime() + (15 * 24 * 60 * 60 * 1000);
                
                //startDate = new Date(longstartDate);
                //endDate = new Date(longendDate);
                
                
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                    //where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }        
                
                //where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" > '"+JSPFormater.formatDate(startDate,"yyyy-MM-dd")+"' and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(endDate,"yyyy-MM-dd")+"'";
                where = where + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" = '"+JSPFormater.formatDate(currDt,"yyyy-MM-dd")+"'";
                
                //Vector list = DbSewaTanahInvoice.list(0, 0, where, null);
                //return list;
                
                return DbSewaTanahInvoice.list(0, 0, where, null);
                
            }
            //this month
            else if(type == 2){
                
                Date currDt = new Date();
                int month = currDt.getMonth()+1;
                int year= currDt.getYear()+1900;
                
                //String where = "";
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                    //where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }
                
                where = where+" month("+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+month+" and year("+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+year;
                
                //Vector list = DbSewaTanahInvoice.list(0, 0, where, null);
                //return list;
                
                return DbSewaTanahInvoice.list(0, 0, where, null);
                
            }else{
                //String where = "";
                
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                
                where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"'";
                
                //Vector list = DbSewaTanahInvoice.list(0, 0, where, null);
                //return list;
                
                return DbSewaTanahInvoice.list(0, 0, where, null);
                
            }
            
        }catch(Exception e){
            
        }
        
        return null;
    }
     
     public static Vector listRiviewInvoice(long salesId, long customerId, int type, Date start, Date end,int status, int salesType){
        
        try{
            
            String where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+"<>0";
            
            if(type == 1){
                
                Date currDt = new Date();
                Date startDate = currDt;
                Date endDate = currDt;
                
                long longstartDate = currDt.getTime() - (15 * 24 * 60 * 60 * 1000);
                long longendDate = currDt.getTime() + (15 * 24 * 60 * 60 * 1000);
                
                startDate = new Date(longstartDate);
                endDate = new Date(longendDate);
                
                where = where + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+DbPembayaran.STATUS_BAYAR_OPEN;
                
                if(salesType == 1){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_HARD_CASH;
                }else if(salesType == 2){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_CASH_BERJANGKA;
                }else if(salesType == 3){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_KPA;
                }
                
                if(salesId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_USER_ID]+" = "+salesId;
                }
                
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }        
                
                where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(startDate,"yyyy-MM-dd")+"' and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(endDate,"yyyy-MM-dd")+"'";
                
                Vector list = DbSewaTanahInvoice.list(0, 0, where, null);
                
                Vector result = new Vector();
                if(list != null && list.size() > 0){
                    for(int i = 0 ; i < list.size() ; i++){
                       SewaTanahInvoice ps = (SewaTanahInvoice)list.get(i);
                       int x = DbSewaTanahInvoice.dateDiff(new Date(), ps.getTanggal());
                       
                       if(status == 1){
                           if(x > 0){
                               result.add(ps);
                           }
                       }else{
                           result.add(ps);
                       }
                       
                    }
                }
                
                return result;
                
            }else if(type == 2){
                Date currDt = new Date();
                int month = currDt.getMonth()+1;
                int year= currDt.getYear()+1900;
                
                where = where + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+DbPembayaran.STATUS_BAYAR_OPEN;
                
                if(salesType == 1){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_HARD_CASH;
                }else if(salesType == 2){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_CASH_BERJANGKA;
                }else if(salesType == 3){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_KPA;
                }
                
                if(salesId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_USER_ID]+" = "+salesId;
                }
                
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where+" month("+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+month+" and year("+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+year;
                Vector list = DbSewaTanahInvoice.list(0, 0, where, null);
                Vector result = new Vector();
                if(list != null && list.size() > 0){
                    for(int i = 0 ; i < list.size() ; i++){
                       SewaTanahInvoice ps = (SewaTanahInvoice)list.get(i);
                       int x = DbSewaTanahInvoice.dateDiff(new Date(), ps.getTanggal());
                       
                       if(status == 1){
                           if(x > 0){
                               result.add(ps);
                           }
                       }else{
                           result.add(ps);
                       }
                       
                    }
                }
                
                return result;
            }else{
                
                where = where + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+DbPembayaran.STATUS_BAYAR_OPEN;
                
                if(salesType == 1){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_HARD_CASH;
                }else if(salesType == 2){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_CASH_BERJANGKA;
                }else if(salesType == 3){
                    where = where + " and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_KPA;
                }
                
                if(salesId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_USER_ID]+" = "+salesId;
                }
                
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"'";
                
                Vector list = DbSewaTanahInvoice.list(0, 0, where, null);
                Vector result = new Vector();
                if(list != null && list.size() > 0){
                    for(int i = 0 ; i < list.size() ; i++){
                       SewaTanahInvoice ps = (SewaTanahInvoice)list.get(i);
                       int x = DbSewaTanahInvoice.dateDiff(new Date(), ps.getTanggal());
                       
                       if(status == 1){
                           if(x > 0){
                               result.add(ps);
                           }
                       }else{
                           result.add(ps);
                       }
                       
                    }
                }
                
                return result;
            }
            
        }catch(Exception e){}
        return null;
    }
     
     public static Vector listPrintInvoice(long salesId, long customerId, int type, Date start, Date end, int status, int salesType){
        
        try{
            
            if(type == 1){
                
                Date currDt = new Date();
                Date startDate = currDt;
                Date endDate = currDt;
                
                long longstartDate = currDt.getTime() - (15 * 24 * 60 * 60 * 1000);
                long longendDate = currDt.getTime() + (15 * 24 * 60 * 60 * 1000);
                
                startDate = new Date(longstartDate);
                endDate = new Date(longendDate);
                
                String where = ""+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_NAME]+" = 'Booking Fee (BF)' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS]+" = "+DbPaymentSimulation.STATUS_BELUM_LUNAS;
                
                if(salesType == 1){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_HARD_CASH;
                }else if(salesType == 2){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_CASH_BERJANGKA;
                }else if(salesType == 3){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_KPA;
                }
                
                if(salesId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_USER_ID]+" = "+salesId;
                }
                
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }        
                
                where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+" >= '"+JSPFormater.formatDate(startDate,"yyyy-MM-dd")+"' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+" <= '"+JSPFormater.formatDate(endDate,"yyyy-MM-dd")+"'";
                
                Vector list = DbPaymentSimulation.list(0, 0, where, null);
                Vector result = new Vector();
                if(list != null && list.size() > 0){
                    for(int i = 0 ; i < list.size() ; i++){
                       PaymentSimulation ps = (PaymentSimulation)list.get(i);
                       int x = DbSewaTanahInvoice.dateDiff(new Date(), ps.getDueDate());
                       SalesData sd = DbSalesData.fetchExc(ps.getSalesDataId());
                       if(sd.getStatus() != DbSalesData.STATUS_CANCEL){
                       if(status == 1){
                           if(x > 0){
                               result.add(ps);
                           }
                       }else{
                           result.add(ps);
                       }
                       }
                    }
                }
                
                return result;
                
            }else if(type == 2){
                Date currDt = new Date();
                int month = currDt.getMonth()+1;
                int year= currDt.getYear()+1900;
                String where = ""+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_NAME]+" = 'Booking Fee (BF)' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS]+" = "+DbPaymentSimulation.STATUS_BELUM_LUNAS+" and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+type;
                
                if(salesType == 1){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_HARD_CASH;
                }else if(salesType == 2){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_CASH_BERJANGKA;
                }else if(salesType == 3){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_KPA;
                }
                
                if(salesId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_USER_ID]+" = "+salesId;
                }
                
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where+" month("+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+") = "+month+" and year("+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+") = "+year;
                Vector list = DbPaymentSimulation.list(0, 0, where, null);
                Vector result = new Vector();
                if(list != null && list.size() > 0){
                    for(int i = 0 ; i < list.size() ; i++){
                       PaymentSimulation ps = (PaymentSimulation)list.get(i);
                       int x = DbSewaTanahInvoice.dateDiff(new Date(), ps.getDueDate());
                       SalesData sd = DbSalesData.fetchExc(ps.getSalesDataId());
                       if(sd.getStatus() != DbSalesData.STATUS_CANCEL){
                       if(status == 1){
                           if(x > 0){
                               result.add(ps);
                           }
                       }else{
                           result.add(ps);
                       }
                       }
                    }
                }
                
                return result;
            }else{
                String where = ""+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_NAME]+" = 'Booking Fee (BF)' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS]+" = "+DbPaymentSimulation.STATUS_BELUM_LUNAS+" and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+type;
                if(salesType == 1){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_HARD_CASH;
                }else if(salesType == 2){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_CASH_BERJANGKA;
                }else if(salesType == 3){
                    where = where + " and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_TYPE_PAYMENT]+" = "+DbSalesData.TYPE_KPA;
                }
                if(salesId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_USER_ID]+" = "+salesId;
                }
                
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_CUSTOMER_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and "+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_DUE_DATE]+" <= '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"'";
                
                Vector list = DbPaymentSimulation.list(0, 0, where, null);
                Vector result = new Vector();
                if(list != null && list.size() > 0){
                    for(int i = 0 ; i < list.size() ; i++){
                       PaymentSimulation ps = (PaymentSimulation)list.get(i);
                       int x = DbSewaTanahInvoice.dateDiff(new Date(), ps.getDueDate());
                       SalesData sd = DbSalesData.fetchExc(ps.getSalesDataId());
                       if(sd.getStatus() != DbSalesData.STATUS_CANCEL){
                       if(status == 1){
                           if(x > 0){
                               result.add(ps);
                           }
                       }else{
                           result.add(ps);
                       }
                       }
                    }
                }
                
                return result;
            }
            
        }catch(Exception e){}
        return null;
    }
     
     public static int getNextCounter(Date transDate){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        Date dt = new Date();
      
        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DbSystemDocNumber.DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DbSystemDocNumber.DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefix(transDate) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY] + "'";
            }

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
     
     public static String getNumberPrefix(Date transDate){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY]);

        Date dt = new Date();        
        dt = transDate;

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
     
     public static int getSalesNextCounter(Date transDate){
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        Date dt = new Date();
      
        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DbSystemDocNumber.DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DbSystemDocNumber.DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefix(transDate) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY] + "'";
            }

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
     
     
     public static String getNextNumber(int ctr,Date transDate){
         
        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefix(transDate);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
     
     public static Vector getListPlafon(String journalNumber,String marketing,String customer, Date transactionDate,int ignore){
         
         CONResultSet dbrs = null;
         
         try{
            String sql = "select ps."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+" as sales_data_id,"+
                    " ps."+DbSalesData.colNames[DbSalesData.COL_SALES_NUMBER]+" as sales_number, "+
                    " c."+DbCustomer.colNames[DbCustomer.COL_NAME]+" as name,"+
                    " ps."+DbSalesData.colNames[DbSalesData.COL_DATE_TRANSACTION]+" as date_transaction, "+
                    " ps."+DbSalesData.colNames[DbSalesData.COL_FINAL_PRICE]+" as final_price from "+
                    DbSalesData.DB_SALES_DATA+" ps inner join "+DbCustomer.DB_CUSTOMER+" c on ps."+DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]+" = c."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" inner join "+DbEmployee.CON_EMPLOYEE+" e on ps."+DbSalesData.colNames[DbSalesData.COL_USER_ID]+" = e."+DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID];
           
            String where = " ps."+DbSalesData.colNames[DbSalesData.COL_BANK_ID]+" = 0 and "+DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]+" = "+DbSalesData.TYPE_KPA;
            
            if(journalNumber != null && journalNumber.length() > 0){                
                where = where +" and "+" ps."+DbSalesData.colNames[DbSalesData.COL_SALES_NUMBER]+" like '%"+journalNumber+"%' ";
            }
            
            if(marketing != null && marketing.length() > 0){                
                where = where +" and "+" e."+DbEmployee.colNames[DbEmployee.COL_NAME]+" like '%"+marketing+"%' ";
            }
            
            if(customer != null && customer.length() > 0){                
                where = where +" and "+" c."+DbCustomer.colNames[DbCustomer.COL_NAME]+" like '%"+customer+"%' ";
            }
            
            if(ignore == 0){
                where = where +" and ps."+DbSalesData.colNames[DbSalesData.COL_DATE_TRANSACTION]+" = '"+JSPFormater.formatDate(transactionDate,"yyyy-MM-dd")+"' ";
            }
            
            sql = sql + " where "+where;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector lists = new Vector();
            while (rs.next()) {
                PlafonBank pb = new PlafonBank();
                pb.setSalesDataId(rs.getLong("sales_data_id"));
                pb.setSalesNumber(rs.getString("sales_number"));
                pb.setName(rs.getString("name"));                
                pb.setDateTransaction(rs.getDate("date_transaction"));    
                pb.setFinalPrice(rs.getDouble("final_price"));
                lists.add(pb);
            }
            
            rs.close();
            return lists;
            
         }catch(Exception e){}
         finally{
             CONResultSet.close(dbrs);
         }
         
         return null;
     }
     
     public static int totalDate(int month, int year){
         switch (month){
            case 1:
                return 31;
            case 3:
                return 31;
            case 5:
                return 31;
            case 7:
                return 31;
            case 8:
                return 31;
            case 10:
                return 31;
            case 12:
                return 31;                
            case 4:
                return 30;                
            case 6:
                return 30;
            case 9:
                return 30;
            case 11:
                return 30;
            case 2:
                if ((year % 4 == 0) && !(year % 100 == 0)){
                    return 29;
                }else{
                    return 28;
                }    
                
        }
         return 0;
     }
}
