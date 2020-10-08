
package com.project.ccs.postransaction.sales;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;
import com.project.util.lang.I_Language;
import com.project.*;
import com.project.admin.DbUser;
import com.project.system.*;
import com.project.general.Currency;
import com.project.ccs.posmaster.*;
import com.project.fms.transaction.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.general.DbCompany;
import com.project.general.Company;
import com.project.ccs.postransaction.stock.*;
import com.project.ccs.session.CoaSalesDetail;
import com.project.ccs.session.MasterGroup;
import com.project.ccs.session.MasterOid;
import com.project.ccs.session.MerchantAmount;
import com.project.ccs.session.RecipeParameter;
import com.project.ccs.session.SessClosingSummary;
import com.project.ccs.session.SessCreditPayment;

public class DbSales extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SALES = "pos_sales";
    public static final int COL_SALES_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_NUMBER = 2;
    public static final int COL_NUMBER_PREFIX = 3;
    public static final int COL_COUNTER = 4;
    public static final int COL_NAME = 5;
    public static final int COL_CUSTOMER_ID = 6;
    public static final int COL_CUSTOMER_PIC = 7;
    public static final int COL_CUSTOMER_PIC_PHONE = 8;
    public static final int COL_CUSTOMER_ADDRESS = 9;
    public static final int COL_START_DATE = 10;
    public static final int COL_END_DATE = 11;
    public static final int COL_CUSTOMER_PIC_POSITION = 12;
    public static final int COL_EMPLOYEE_ID = 13;
    public static final int COL_USER_ID = 14;
    public static final int COL_EMPLOYEE_HP = 15;
    public static final int COL_DESCRIPTION = 16;
    public static final int COL_STATUS = 17;
    public static final int COL_AMOUNT = 18;
    public static final int COL_CURRENCY_ID = 19;
    public static final int COL_COMPANY_ID = 20;
    public static final int COL_CATEGORY_ID = 21;
    public static final int COL_DISCOUNT_PERCENT = 22;
    public static final int COL_DISCOUNT_AMOUNT = 23;
    public static final int COL_VAT = 24;
    public static final int COL_DISCOUNT = 25;
    public static final int COL_WARRANTY_STATUS = 26;
    public static final int COL_WARRANTY_DATE = 27;
    public static final int COL_WARRANTY_RECEIVE = 28;
    public static final int COL_MANUAL_STATUS = 29;
    public static final int COL_MANUAL_DATE = 30;
    public static final int COL_MANUAL_RECEIVE = 31;
    public static final int COL_NOTE_CLOSING = 32;
    public static final int COL_BOOKING_RATE = 33;
    public static final int COL_EXCHANGE_AMOUNT = 34;
    public static final int COL_PROPOSAL_ID = 35;
    public static final int COL_UNIT_USAHA_ID = 36;
    public static final int COL_VAT_PERCENT = 37;
    public static final int COL_VAT_AMOUNT = 38;
    public static final int COL_TYPE = 39;
    public static final int COL_PPH_PERCENT = 40;
    public static final int COL_PPH_AMOUNT = 41;
    public static final int COL_PPH_TYPE = 42;
    public static final int COL_SALES_TYPE = 43;
    public static final int COL_MARKETING_ID = 44;
    public static final int COL_LOCATION_ID = 45;
    public static final int COL_PAYMENT_STATUS = 46;
    public static final int COL_CASH_CASHIER_ID = 47;
    public static final int COL_SHIFT_ID = 48;
    public static final int COL_CASH_MASTER_ID = 49;
    public static final int COL_POSTED_STATUS = 50;
    public static final int COL_POSTED_BY_ID = 51;
    public static final int COL_POSTED_DATE = 52;
    public static final int COL_EFFECTIVE_DATE = 53;
    public static final int COL_STATUS_STOCK = 54;
    public static final int COL_SALES_RETUR_ID = 55;
    public static final int COL_SERVICE_PERCENT = 56;
    public static final int COL_SERVICE_AMOUNT = 57;    
    public static final int COL_SPG_ID = 58; 
    public static final int COL_GLOBAL_DISKON = 59; 
    public static final int COL_GLOBAL_DISKON_PERCENT = 60; 
    public static final int COL_SOPIR_ID =  61;
    public static final int COL_HELPER_ID =  62;
    public static final int COL_DISKON_KARTU = 63; 
    public static final int COL_TABLE_ID =  64;
    public static final int COL_WAITRESS_ID =  65;    
    public static final int COL_JUMLAH_ORANG =  66;
    public static final int COL_BIAYA_KARTU =  67;
    public static final int COL_SYSTEM_DOC_NUMBER_ID =  68;
      
    public static final String[] colNames = {
        "sales_id",
        "date",
        "number",
        "number_prefix",
        "counter",
        "name",
        "customer_id",
        "customer_pic",
        "customer_pic_phone",
        "customer_address",
        "start_date",
        "end_date",
        "customer_pic_position",
        "employee_id",
        "user_id",
        "employee_hp",
        "description",
        "status",
        "amount",
        "currency_id",
        "company_id",
        "category_id",
        "discount_percent",
        "discount_amount",
        "vat",
        "discount",
        "warranty_status",
        "warranty_date",
        "warranty_receive",
        "manual_status",
        "manual_date",
        "manual_receive",
        "note_closing",
        "booking_rate",
        "exchange_amount",
        "proposal_id",
        "unit_usaha_id",
        "vat_percent",
        "vat_amount",
        "type",
        "pph_percent",
        "pph_amount",
        "pph_type",
        "sales_type",
        "marketing_id",
        "location_id",
        "payment_status",
        "cash_cashier_id",
        "shift_id",
        "cash_master_id",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date",
        "status_stock",
        "sales_retur_id",        
        "service_percent",
        "service_amount",        
        "spg_id",
        "global_diskon",
        "global_diskon_percent",
        "sopir_id",
        "helper_id",
        "diskon_kartu",
        "table_id",
        "waitress_id",        
        "jumlah_orang",
        "biaya_kartu",
        "system_doc_number_id"       
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_INT,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,        
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,        
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG
    };
    
    public static final int TYPE_JASA = 0;
    public static final int TYPE_MATERIAL = 1;
    public static final int TYPE_BELUM_LUNAS = 1;
    public static final int TYPE_LUNAS = 0;
    
    //untuk kolom sales_type
    public static int TYPE_NON_CONSIGMENT = 0;
    public static int TYPE_CONSIGMENT = 1;
    public static final int TYPE_CASH = 0;
    public static final int TYPE_CREDIT = 1;
    public static final int TYPE_RETUR_CASH = 2;
    public static final int TYPE_RETUR_CREDIT = 3;
    
    public static final String[] typeStr = {"CASH", "CREDIT", "TYPE_RETUR_CASH", "TYPE_RETUR_CREDIT"};

    public DbSales() {
    }

    public DbSales(int i) throws CONException {
        super(new DbSales());
    }

    public DbSales(String sOid) throws CONException {
        super(new DbSales(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSales(long lOid) throws CONException {
        super(new DbSales(0));
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
        return DB_SALES;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSales().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Sales sales = fetchExc(ent.getOID());
        ent = (Entity) sales;
        return sales.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Sales) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Sales) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Sales fetchExc(long oid) throws CONException {
        try {
            Sales sales = new Sales();
            DbSales dbSales = new DbSales(oid);
            sales.setOID(oid);

            sales.setDate(dbSales.getDate(COL_DATE));
            sales.setNumber(dbSales.getString(COL_NUMBER));
            sales.setNumberPrefix(dbSales.getString(COL_NUMBER_PREFIX));
            sales.setCounter(dbSales.getInt(COL_COUNTER));
            sales.setName(dbSales.getString(COL_NAME));
            sales.setCustomerId(dbSales.getlong(COL_CUSTOMER_ID));
            sales.setCustomerPic(dbSales.getString(COL_CUSTOMER_PIC));
            sales.setCustomerPicPhone(dbSales.getString(COL_CUSTOMER_PIC_PHONE));
            sales.setCustomerAddress(dbSales.getString(COL_CUSTOMER_ADDRESS));
            sales.setCustomerPicPosition(dbSales.getString(COL_CUSTOMER_PIC_POSITION));
            sales.setEmployeeId(dbSales.getlong(COL_EMPLOYEE_ID));
            sales.setUserId(dbSales.getlong(COL_USER_ID));
            sales.setEmployeeHp(dbSales.getString(COL_EMPLOYEE_HP));
            sales.setDescription(dbSales.getString(COL_DESCRIPTION));
            sales.setStatus(dbSales.getInt(COL_STATUS));
            sales.setAmount(dbSales.getdouble(COL_AMOUNT));
            sales.setCurrencyId(dbSales.getlong(COL_CURRENCY_ID));
            sales.setCompanyId(dbSales.getlong(COL_COMPANY_ID));
            sales.setCategoryId(dbSales.getlong(COL_CATEGORY_ID));
            sales.setDiscountPercent(dbSales.getdouble(COL_DISCOUNT_PERCENT));
            sales.setDiscountAmount(dbSales.getdouble(COL_DISCOUNT_AMOUNT));
            sales.setVat(dbSales.getInt(COL_VAT));
            sales.setVatPercent(dbSales.getdouble(COL_VAT_PERCENT));
            sales.setVatAmount(dbSales.getdouble(COL_VAT_AMOUNT));
            sales.setDiscount(dbSales.getInt(COL_DISCOUNT));
            sales.setWarrantyStatus(dbSales.getInt(COL_WARRANTY_STATUS));
            sales.setWarrantyDate(dbSales.getDate(COL_WARRANTY_DATE));
            sales.setWarrantyReceive(dbSales.getString(COL_WARRANTY_RECEIVE));
            sales.setManualStatus(dbSales.getInt(COL_MANUAL_STATUS));
            sales.setManualDate(dbSales.getDate(COL_MANUAL_DATE));
            sales.setManualReceive(dbSales.getString(COL_MANUAL_RECEIVE));
            sales.setNoteClosing(dbSales.getString(COL_NOTE_CLOSING));
            sales.setBookingRate(dbSales.getdouble(COL_BOOKING_RATE));
            sales.setExchangeAmount(dbSales.getdouble(COL_EXCHANGE_AMOUNT));
            sales.setProposalId(dbSales.getlong(COL_PROPOSAL_ID));
            sales.setUnitUsahaId(dbSales.getlong(COL_UNIT_USAHA_ID));
            sales.setType(dbSales.getInt(COL_TYPE));
            sales.setPphType(dbSales.getInt(COL_TYPE));
            sales.setPphPercent(dbSales.getdouble(COL_PPH_PERCENT));
            sales.setPphAmount(dbSales.getdouble(COL_PPH_AMOUNT));
            sales.setSalesType(dbSales.getInt(COL_SALES_TYPE));
            sales.setMarketingId(dbSales.getlong(COL_MARKETING_ID));
            sales.setLocation_id(dbSales.getlong(COL_LOCATION_ID));
            sales.setPaymentStatus(dbSales.getInt(COL_PAYMENT_STATUS));
            sales.setCashCashierId(dbSales.getlong(COL_CASH_CASHIER_ID));
            sales.setShift_id(dbSales.getlong(COL_SHIFT_ID));
            sales.setCash_master_id(dbSales.getlong(COL_CASH_MASTER_ID));
            sales.setPostedStatus(dbSales.getInt(COL_POSTED_STATUS));
            sales.setPostedById(dbSales.getlong(COL_POSTED_BY_ID));
            sales.setPostedDate(dbSales.getDate(COL_POSTED_DATE));
            sales.setEffectiveDate(dbSales.getDate(COL_EFFECTIVE_DATE));
            sales.setStatus_stock(dbSales.getInt(COL_STATUS_STOCK));
            sales.setSalesReturId(dbSales.getlong(COL_SALES_RETUR_ID));
            sales.setServicePercent(dbSales.getdouble(COL_SERVICE_PERCENT));
            sales.setServiceAmount(dbSales.getdouble(COL_SERVICE_AMOUNT));            
            sales.setSpgId(dbSales.getlong(COL_SPG_ID));
            sales.setGlobalDiskon(dbSales.getdouble(COL_GLOBAL_DISKON));
            sales.setGlobalDiskonPercent(dbSales.getdouble(COL_GLOBAL_DISKON_PERCENT));
            sales.setSopirId(dbSales.getlong(COL_SOPIR_ID));
            sales.setHelperId(dbSales.getlong(COL_HELPER_ID));
            sales.setDiskonKartu(dbSales.getdouble(COL_DISKON_KARTU));
            sales.setTableId(dbSales.getlong(COL_TABLE_ID));
            sales.setWaitressId(dbSales.getlong(COL_WAITRESS_ID));            
            sales.setJumlahOrang(dbSales.getInt(COL_JUMLAH_ORANG));
            sales.setBiayaKartu(dbSales.getdouble(COL_BIAYA_KARTU));
            sales.setSystemDocNumberId(dbSales.getlong(COL_SYSTEM_DOC_NUMBER_ID));
            
            return sales;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSales(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Sales sales) throws CONException {
        try {
            DbSales dbSales = new DbSales(0);

            dbSales.setDate(COL_DATE, sales.getDate());
            dbSales.setString(COL_NUMBER, sales.getNumber());
            dbSales.setString(COL_NUMBER_PREFIX, sales.getNumberPrefix());
            dbSales.setInt(COL_COUNTER, sales.getCounter());
            dbSales.setString(COL_NAME, sales.getName());
            dbSales.setLong(COL_CUSTOMER_ID, sales.getCustomerId());
            dbSales.setString(COL_CUSTOMER_PIC, sales.getCustomerPic());
            dbSales.setString(COL_CUSTOMER_PIC_PHONE, sales.getCustomerPicPhone());
            dbSales.setString(COL_CUSTOMER_ADDRESS, sales.getCustomerAddress());
            dbSales.setDate(COL_START_DATE, sales.getStartDate());
            dbSales.setDate(COL_END_DATE, sales.getEndDate());
            dbSales.setString(COL_CUSTOMER_PIC_POSITION, sales.getCustomerPicPosition());
            dbSales.setLong(COL_EMPLOYEE_ID, sales.getEmployeeId());
            dbSales.setLong(COL_USER_ID, sales.getUserId());
            dbSales.setString(COL_EMPLOYEE_HP, sales.getEmployeeHp());
            dbSales.setString(COL_DESCRIPTION, sales.getDescription());
            dbSales.setInt(COL_STATUS, sales.getStatus());
            dbSales.setDouble(COL_AMOUNT, sales.getAmount());
            dbSales.setLong(COL_CURRENCY_ID, sales.getCurrencyId());
            dbSales.setLong(COL_COMPANY_ID, sales.getCompanyId());
            dbSales.setLong(COL_CATEGORY_ID, sales.getCategoryId());
            dbSales.setDouble(COL_DISCOUNT_PERCENT, sales.getDiscountPercent());
            dbSales.setDouble(COL_DISCOUNT_AMOUNT, sales.getDiscountAmount());
            dbSales.setInt(COL_VAT, sales.getVat());
            dbSales.setDouble(COL_VAT_PERCENT, sales.getVatPercent());
            dbSales.setDouble(COL_VAT_AMOUNT, sales.getVatAmount());
            dbSales.setInt(COL_DISCOUNT, sales.getDiscount());
            dbSales.setInt(COL_WARRANTY_STATUS, sales.getWarrantyStatus());
            dbSales.setDate(COL_WARRANTY_DATE, sales.getWarrantyDate());
            dbSales.setString(COL_WARRANTY_RECEIVE, sales.getWarrantyReceive());
            dbSales.setInt(COL_MANUAL_STATUS, sales.getManualStatus());
            dbSales.setDate(COL_MANUAL_DATE, sales.getManualDate());
            dbSales.setString(COL_MANUAL_RECEIVE, sales.getManualReceive());
            dbSales.setString(COL_NOTE_CLOSING, sales.getNoteClosing());
            dbSales.setDouble(COL_BOOKING_RATE, sales.getBookingRate());
            dbSales.setDouble(COL_EXCHANGE_AMOUNT, sales.getExchangeAmount());
            dbSales.setLong(COL_PROPOSAL_ID, sales.getProposalId());
            dbSales.setLong(COL_UNIT_USAHA_ID, sales.getUnitUsahaId());
            dbSales.setInt(COL_TYPE, sales.getType());
            dbSales.setInt(COL_PPH_TYPE, sales.getPphType());
            dbSales.setDouble(COL_PPH_PERCENT, sales.getPphPercent());
            dbSales.setDouble(COL_PPH_AMOUNT, sales.getPphAmount());
            dbSales.setInt(COL_SALES_TYPE, sales.getSalesType());
            dbSales.setLong(COL_MARKETING_ID, sales.getMarketingId());
            dbSales.setLong(COL_LOCATION_ID, sales.getLocation_id());
            dbSales.setInt(COL_PAYMENT_STATUS, sales.getPaymentStatus());
            dbSales.setLong(COL_CASH_CASHIER_ID, sales.getCashCashierId());
            dbSales.setLong(COL_SHIFT_ID, sales.getShift_id());
            dbSales.setLong(COL_CASH_MASTER_ID, sales.getCash_master_id());
            dbSales.setInt(COL_POSTED_STATUS, sales.getPostedStatus());
            dbSales.setLong(COL_POSTED_BY_ID, sales.getPostedById());
            dbSales.setDate(COL_POSTED_DATE, sales.getPostedDate());
            dbSales.setDate(COL_EFFECTIVE_DATE, sales.getEffectiveDate());
            dbSales.setInt(COL_STATUS_STOCK, sales.getStatus_stock());
            dbSales.setLong(COL_SALES_RETUR_ID, sales.getSalesReturId());
            dbSales.setDouble(COL_SERVICE_AMOUNT, sales.getServiceAmount());
            dbSales.setDouble(COL_SERVICE_PERCENT, sales.getServicePercent());            
            dbSales.setLong(COL_SPG_ID, sales.getSpgId());
            dbSales.setDouble(COL_GLOBAL_DISKON, sales.getGlobalDiskon());
            dbSales.setDouble(COL_GLOBAL_DISKON_PERCENT, sales.getGlobalDiskonPercent());
            dbSales.setLong(COL_SOPIR_ID, sales.getSopirId());
            dbSales.setLong(COL_HELPER_ID, sales.getHelperId());
            dbSales.setDouble(COL_DISKON_KARTU, sales.getDiskonKartu());
            dbSales.setLong(COL_TABLE_ID, sales.getTableId());
            dbSales.setLong(COL_WAITRESS_ID, sales.getWaitressId());            
            dbSales.setInt(COL_JUMLAH_ORANG, sales.getJumlahOrang());
            dbSales.setDouble(COL_BIAYA_KARTU, sales.getBiayaKartu());
            dbSales.setLong(COL_SYSTEM_DOC_NUMBER_ID, sales.getSystemDocNumberId() );

            dbSales.insert();
            sales.setOID(dbSales.getlong(COL_SALES_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSales(0), CONException.UNKNOWN);
        }
        return sales.getOID();
    }

    public static long updateExc(Sales sales) throws CONException {
        try {
            if (sales.getOID() != 0) {
                DbSales dbSales = new DbSales(sales.getOID());

                dbSales.setDate(COL_DATE, sales.getDate());
                dbSales.setString(COL_NUMBER, sales.getNumber());
                dbSales.setString(COL_NUMBER_PREFIX, sales.getNumberPrefix());
                dbSales.setInt(COL_COUNTER, sales.getCounter());
                dbSales.setString(COL_NAME, sales.getName());
                dbSales.setLong(COL_CUSTOMER_ID, sales.getCustomerId());
                dbSales.setString(COL_CUSTOMER_PIC, sales.getCustomerPic());
                dbSales.setString(COL_CUSTOMER_PIC_PHONE, sales.getCustomerPicPhone());
                dbSales.setString(COL_CUSTOMER_ADDRESS, sales.getCustomerAddress());
                dbSales.setDate(COL_START_DATE, sales.getStartDate());
                dbSales.setDate(COL_END_DATE, sales.getEndDate());
                dbSales.setString(COL_CUSTOMER_PIC_POSITION, sales.getCustomerPicPosition());
                dbSales.setLong(COL_EMPLOYEE_ID, sales.getEmployeeId());
                dbSales.setLong(COL_USER_ID, sales.getUserId());
                dbSales.setString(COL_EMPLOYEE_HP, sales.getEmployeeHp());
                dbSales.setString(COL_DESCRIPTION, sales.getDescription());
                dbSales.setInt(COL_STATUS, sales.getStatus());
                dbSales.setDouble(COL_AMOUNT, sales.getAmount());
                dbSales.setLong(COL_CURRENCY_ID, sales.getCurrencyId());
                dbSales.setLong(COL_COMPANY_ID, sales.getCompanyId());
                dbSales.setLong(COL_CATEGORY_ID, sales.getCategoryId());
                dbSales.setDouble(COL_DISCOUNT_PERCENT, sales.getDiscountPercent());
                dbSales.setDouble(COL_DISCOUNT_AMOUNT, sales.getDiscountAmount());
                dbSales.setInt(COL_VAT, sales.getVat());
                dbSales.setDouble(COL_VAT_PERCENT, sales.getVatPercent());
                dbSales.setDouble(COL_VAT_AMOUNT, sales.getVatAmount());
                dbSales.setInt(COL_DISCOUNT, sales.getDiscount());
                dbSales.setInt(COL_WARRANTY_STATUS, sales.getWarrantyStatus());
                dbSales.setDate(COL_WARRANTY_DATE, sales.getWarrantyDate());
                dbSales.setString(COL_WARRANTY_RECEIVE, sales.getWarrantyReceive());
                dbSales.setInt(COL_MANUAL_STATUS, sales.getManualStatus());
                dbSales.setDate(COL_MANUAL_DATE, sales.getManualDate());
                dbSales.setString(COL_MANUAL_RECEIVE, sales.getManualReceive());
                dbSales.setString(COL_NOTE_CLOSING, sales.getNoteClosing());
                dbSales.setDouble(COL_BOOKING_RATE, sales.getBookingRate());
                dbSales.setDouble(COL_EXCHANGE_AMOUNT, sales.getExchangeAmount());
                dbSales.setLong(COL_PROPOSAL_ID, sales.getProposalId());
                dbSales.setLong(COL_UNIT_USAHA_ID, sales.getUnitUsahaId());
                dbSales.setInt(COL_TYPE, sales.getType());
                dbSales.setInt(COL_PPH_TYPE, sales.getPphType());
                dbSales.setDouble(COL_PPH_PERCENT, sales.getPphPercent());
                dbSales.setDouble(COL_PPH_AMOUNT, sales.getPphAmount());
                dbSales.setInt(COL_SALES_TYPE, sales.getSalesType());
                dbSales.setLong(COL_MARKETING_ID, sales.getMarketingId());
                dbSales.setLong(COL_LOCATION_ID, sales.getLocation_id());
                dbSales.setInt(COL_PAYMENT_STATUS, sales.getPaymentStatus());
                dbSales.setLong(COL_CASH_CASHIER_ID, sales.getCashCashierId());
                dbSales.setLong(COL_SHIFT_ID, sales.getShift_id());
                dbSales.setLong(COL_CASH_MASTER_ID, sales.getCash_master_id());
                dbSales.setInt(COL_POSTED_STATUS, sales.getPostedStatus());
                dbSales.setLong(COL_POSTED_BY_ID, sales.getPostedById());
                dbSales.setDate(COL_POSTED_DATE, sales.getPostedDate());
                dbSales.setDate(COL_EFFECTIVE_DATE, sales.getEffectiveDate());
                dbSales.setInt(COL_STATUS_STOCK, sales.getStatus_stock());
                dbSales.setLong(COL_SALES_RETUR_ID, sales.getSalesReturId());
                dbSales.setDouble(COL_SERVICE_AMOUNT, sales.getServiceAmount());
                dbSales.setDouble(COL_SERVICE_PERCENT, sales.getServicePercent());
                
                dbSales.setLong(COL_SPG_ID, sales.getSpgId());
                dbSales.setDouble(COL_GLOBAL_DISKON, sales.getGlobalDiskon());
                dbSales.setDouble(COL_GLOBAL_DISKON_PERCENT, sales.getGlobalDiskonPercent());
                dbSales.setLong(COL_SOPIR_ID, sales.getSopirId());
                dbSales.setLong(COL_HELPER_ID, sales.getHelperId());
                dbSales.setDouble(COL_DISKON_KARTU, sales.getDiskonKartu());
                dbSales.setLong(COL_TABLE_ID, sales.getTableId());
                dbSales.setLong(COL_WAITRESS_ID, sales.getWaitressId());                
                dbSales.setInt(COL_JUMLAH_ORANG, sales.getJumlahOrang());
                dbSales.setDouble(COL_BIAYA_KARTU, sales.getBiayaKartu());
                dbSales.setLong(COL_SYSTEM_DOC_NUMBER_ID, sales.getSystemDocNumberId() );

                dbSales.update();
                return sales.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSales(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSales dbSales = new DbSales(oid);
            dbSales.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSales(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SALES;
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
                Sales sales = new Sales();
                resultToObject(rs, sales);
                lists.add(sales);
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

    public static void resultToObject(ResultSet rs, Sales sales) {
        try {
            sales.setOID(rs.getLong(DbSales.colNames[DbSales.COL_SALES_ID]));
            Date tm = CONHandler.convertDate(rs.getDate(DbSales.colNames[DbSales.COL_DATE]), rs.getTime(DbSales.colNames[DbSales.COL_DATE]));            
            sales.setDate(tm);
            sales.setNumber(rs.getString(DbSales.colNames[DbSales.COL_NUMBER]));
            sales.setNumberPrefix(rs.getString(DbSales.colNames[DbSales.COL_NUMBER_PREFIX]));
            sales.setCounter(rs.getInt(DbSales.colNames[DbSales.COL_COUNTER]));
            sales.setName(rs.getString(DbSales.colNames[DbSales.COL_NAME]));
            sales.setCustomerId(rs.getLong(DbSales.colNames[DbSales.COL_CUSTOMER_ID]));
            sales.setCustomerPic(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC]));
            sales.setCustomerPicPhone(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC_PHONE]));
            sales.setCustomerAddress(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_ADDRESS]));
            sales.setStartDate(rs.getDate(DbSales.colNames[DbSales.COL_START_DATE]));
            sales.setEndDate(rs.getDate(DbSales.colNames[DbSales.COL_END_DATE]));
            sales.setCustomerPicPosition(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC_POSITION]));
            sales.setEmployeeId(rs.getLong(DbSales.colNames[DbSales.COL_EMPLOYEE_ID]));
            sales.setUserId(rs.getLong(DbSales.colNames[DbSales.COL_USER_ID]));
            sales.setEmployeeHp(rs.getString(DbSales.colNames[DbSales.COL_EMPLOYEE_HP]));
            sales.setDescription(rs.getString(DbSales.colNames[DbSales.COL_DESCRIPTION]));
            sales.setStatus(rs.getInt(DbSales.colNames[DbSales.COL_STATUS]));
            sales.setAmount(rs.getDouble(DbSales.colNames[DbSales.COL_AMOUNT]));
            sales.setCurrencyId(rs.getLong(DbSales.colNames[DbSales.COL_CURRENCY_ID]));
            sales.setCompanyId(rs.getLong(DbSales.colNames[DbSales.COL_COMPANY_ID]));
            sales.setCategoryId(rs.getLong(DbSales.colNames[DbSales.COL_CATEGORY_ID]));
            sales.setDiscountPercent(rs.getDouble(DbSales.colNames[DbSales.COL_DISCOUNT_PERCENT]));
            sales.setDiscountAmount(rs.getDouble(DbSales.colNames[DbSales.COL_DISCOUNT_AMOUNT]));
            sales.setVat(rs.getInt(DbSales.colNames[DbSales.COL_VAT]));
            sales.setVatPercent(rs.getDouble(DbSales.colNames[DbSales.COL_VAT_PERCENT]));
            sales.setVatAmount(rs.getDouble(DbSales.colNames[DbSales.COL_VAT_AMOUNT]));
            sales.setDiscount(rs.getInt(DbSales.colNames[DbSales.COL_DISCOUNT]));
            sales.setWarrantyStatus(rs.getInt(DbSales.colNames[DbSales.COL_WARRANTY_STATUS]));
            sales.setWarrantyDate(rs.getDate(DbSales.colNames[DbSales.COL_WARRANTY_DATE]));
            sales.setWarrantyReceive(rs.getString(DbSales.colNames[DbSales.COL_WARRANTY_RECEIVE]));
            sales.setManualStatus(rs.getInt(DbSales.colNames[DbSales.COL_MANUAL_STATUS]));
            sales.setManualDate(rs.getDate(DbSales.colNames[DbSales.COL_MANUAL_DATE]));
            sales.setManualReceive(rs.getString(DbSales.colNames[DbSales.COL_MANUAL_RECEIVE]));
            sales.setNoteClosing(rs.getString(DbSales.colNames[DbSales.COL_NOTE_CLOSING]));
            sales.setBookingRate(rs.getDouble(DbSales.colNames[DbSales.COL_BOOKING_RATE]));
            sales.setExchangeAmount(rs.getDouble(DbSales.colNames[DbSales.COL_EXCHANGE_AMOUNT]));
            sales.setProposalId(rs.getLong(DbSales.colNames[DbSales.COL_PROPOSAL_ID]));
            sales.setUnitUsahaId(rs.getLong(DbSales.colNames[DbSales.COL_UNIT_USAHA_ID]));
            sales.setType(rs.getInt(DbSales.colNames[DbSales.COL_TYPE]));
            sales.setPphType(rs.getInt(DbSales.colNames[DbSales.COL_PPH_TYPE]));
            sales.setPphPercent(rs.getDouble(DbSales.colNames[DbSales.COL_PPH_PERCENT]));
            sales.setPphAmount(rs.getDouble(DbSales.colNames[DbSales.COL_PPH_AMOUNT]));
            sales.setSalesType(rs.getInt(DbSales.colNames[DbSales.COL_SALES_TYPE]));
            sales.setMarketingId(rs.getLong(DbSales.colNames[DbSales.COL_MARKETING_ID]));
            sales.setLocation_id(rs.getLong(DbSales.colNames[DbSales.COL_LOCATION_ID]));
            sales.setPaymentStatus(rs.getInt(DbSales.colNames[DbSales.COL_PAYMENT_STATUS]));
            sales.setCashCashierId(rs.getLong(DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]));
            sales.setShift_id(rs.getLong(DbSales.colNames[DbSales.COL_SHIFT_ID]));
            sales.setCash_master_id(rs.getLong(DbSales.colNames[DbSales.COL_CASH_MASTER_ID]));
            sales.setPostedStatus(rs.getInt(DbSales.colNames[DbSales.COL_POSTED_STATUS]));
            sales.setPostedById(rs.getLong(DbSales.colNames[DbSales.COL_POSTED_BY_ID]));
            sales.setPostedDate(rs.getDate(DbSales.colNames[DbSales.COL_POSTED_DATE]));
            sales.setEffectiveDate(rs.getDate(DbSales.colNames[DbSales.COL_EFFECTIVE_DATE]));
            sales.setStatus_stock(rs.getInt(DbSales.colNames[DbSales.COL_STATUS_STOCK]));
            sales.setSalesReturId(rs.getLong(DbSales.colNames[DbSales.COL_SALES_RETUR_ID]));
            sales.setServiceAmount(rs.getDouble(DbSales.colNames[DbSales.COL_SERVICE_AMOUNT]));
            sales.setServicePercent(rs.getDouble(DbSales.colNames[DbSales.COL_SERVICE_PERCENT]));            
            sales.setSpgId(rs.getLong(DbSales.colNames[DbSales.COL_SPG_ID]));
            sales.setGlobalDiskon(rs.getDouble(DbSales.colNames[DbSales.COL_GLOBAL_DISKON]));
            sales.setGlobalDiskonPercent(rs.getDouble(DbSales.colNames[DbSales.COL_GLOBAL_DISKON_PERCENT]));
            sales.setSopirId(rs.getLong(DbSales.colNames[DbSales.COL_SOPIR_ID]));
            sales.setHelperId(rs.getLong(DbSales.colNames[DbSales.COL_HELPER_ID]));
            sales.setDiskonKartu(rs.getDouble(DbSales.colNames[DbSales.COL_DISKON_KARTU]));
            sales.setTableId(rs.getLong(DbSales.colNames[DbSales.COL_TABLE_ID]));
            sales.setWaitressId(rs.getLong(DbSales.colNames[DbSales.COL_WAITRESS_ID]));                        
            sales.setJumlahOrang(rs.getInt(DbSales.colNames[DbSales.COL_JUMLAH_ORANG]));
            sales.setBiayaKartu(rs.getDouble(DbSales.colNames[DbSales.COL_BIAYA_KARTU]));       
            sales.setSystemDocNumberId(rs.getLong(DbSales.colNames[DbSales.COL_SYSTEM_DOC_NUMBER_ID]));       

        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static boolean checkOID(long salesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SALES + " WHERE " +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = " + salesId;
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

    public static double getTotalAmount(long salesId) {

        CONResultSet dbrs = null;
        try {

            String sql = "SELECT SUM(" + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") FROM " + DbSalesDetail.DB_SALES_DETAIL + " WHERE " +
                    DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = " + salesId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double amount = 0;
            while (rs.next()) {
                amount = rs.getDouble(1);
            }

            rs.close();
            return amount;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static double getTotAmount(long salesId) {

        CONResultSet dbrs = null;
        try {

            String sql = "SELECT " + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + "," + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + "," + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " FROM " + DbSalesDetail.DB_SALES_DETAIL + " WHERE " +
                    DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = " + salesId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double amount = 0;
            while (rs.next()) {
                double price = rs.getDouble(DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]);
                int qty = rs.getInt(DbSalesDetail.colNames[DbSalesDetail.COL_QTY]);
                double discount = rs.getInt(DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]);
                double tmpAmount = (price * qty) - discount;
                amount = amount + tmpAmount;
            }

            rs.close();
            return amount;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static double getTotalAmountPayment(long salesId) {

        CONResultSet dbrs = null;
        try {

            String sql = "SELECT SUM(" + DbCreditPayment.colNames[DbCreditPayment.COL_AMOUNT] + ") FROM " + DbCreditPayment.DB_CREDIT_PAYMENT + " WHERE " +
                    DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + " = " + salesId + " and " + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + " = 1";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double amount = 0;
            while (rs.next()) {
                amount = rs.getDouble(1);
            }

            rs.close();
            return amount;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static double getTotalDiscount(long salesId) {

        CONResultSet dbrs = null;
        try {

            String sql = "SELECT SUM(" + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") FROM " + DbSalesDetail.DB_SALES_DETAIL + " WHERE " +
                    DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = " + salesId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double amount = 0;
            while (rs.next()) {
                amount = rs.getDouble(1);
            }

            rs.close();
            return amount;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbSales.colNames[DbSales.COL_SALES_ID] + ") FROM " + DB_SALES;
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
                    Sales sales = (Sales) list.get(ls);
                    if (oid == sales.getOID()) {
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

    public static int getNextCounter(long systemCompanyId) {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(counter) from " + DB_SALES + " where " +
                    " number_prefix='" + getNumberPrefix(systemCompanyId) + "' ";

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
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static String getNumberPrefix(long systemCompanyId) {

        Company sysCompany = new Company();
        try {
            sysCompany = DbCompany.fetchExc(systemCompanyId);
        } catch (Exception e) {
            System.out.println(e);
        }
        String code = DbSystemProperty.getValueByName("SALES_CODE");
        Date dt = new Date();
        code = code + "/" + JSPFormater.formatDate(new Date(), "yyyy");
        return code;
    }

    public static String getNextNumber(int ctr, long systemCompanyId) {

        String code = getNumberPrefix(systemCompanyId);

        if (ctr < 10) {
            code = "000" + ctr + "/" + code;
        } else if (ctr < 100) {
            code = "00" + ctr + "/" + code;
        } else if (ctr < 1000) {
            code = "0" + ctr + "/" + code;
        } else {
            code = ctr + "/" + code;
        }
        return code;
    }

    public static void updateSalesAmount(long salesId, Sales sales) {

        int vatCheck = sales.getVat();
        int discCheck = sales.getDiscount();
        double discountPercent = sales.getDiscountPercent();

        double subtotal = DbSalesDetail.getSubTotalSalesAmount(salesId);
        double vat = 0;
        double discount = 0;

        if (discCheck == 1 && discountPercent != 0) {
            discount = subtotal * (discountPercent / 100);
        }

        if (vatCheck == 1) {
            Company c = new Company();
            try {
                c = DbCompany.fetchExc(sales.getCompanyId());
            } catch (Exception e) {
            }
            vat = (subtotal - discount) * (sales.getVatPercent() / 100);
        }

        try {
            sales.setDiscount(discCheck);
            sales.setVat(vatCheck);
            sales.setVatAmount(vat);
            sales.setDiscountPercent(discountPercent);
            sales.setDiscountAmount(discount);

            sales.setAmount(subtotal);// - discount + vat);

            System.out.println("sales currency : " + sales.getCurrencyId());
            Currency c = new Currency();
            try {
                c = DbCurrency.fetchExc(sales.getCurrencyId());
            } catch (Exception e) {
            }
            ExchangeRate er = DbExchangeRate.getStandardRate();

            if (c.getCurrencyCode().equalsIgnoreCase(DbSystemProperty.getValueByName("CURRENCY_CODE_IDR"))) {
                sales.setBookingRate(er.getValueIdr());
                sales.setExchangeAmount(sales.getAmount() - discount + vat);
            } else if (c.getCurrencyCode().equalsIgnoreCase(DbSystemProperty.getValueByName("CURRENCY_CODE_USD"))) {
                sales.setBookingRate(er.getValueUsd());
                sales.setExchangeAmount((sales.getAmount() - discount + vat) * er.getValueUsd());
            } else {
                sales.setBookingRate(er.getValueEuro());
                sales.setExchangeAmount((sales.getAmount() - discount + vat) * er.getValueEuro());
            }

            DbSales.updateExc(sales);
        } catch (Exception e) {
        }


    }

    public static Vector getListSales(int start, int recordToGet, long customerId, String salesName, String number, Date startDate, Date endDate, int ignoreDate, int status) {

        String sql = " select * from " + DB_SALES;

        String where = "";
        if (customerId != 0) {
            where = DbSales.colNames[DbSales.COL_CUSTOMER_ID] + " = " + customerId;
        }

        if (salesName != null && salesName.length() > 0){
            if (where.length() > 0) {
                where = where + " and " + DbSales.colNames[DbSales.COL_NAME] + " like '%" + salesName + "%'";
            } else {
                where = DbSales.colNames[DbSales.COL_NAME] + " like '%" + salesName + "%'";
            }
        }

        if (number != null && number.length() > 0) {
            if (where.length() > 0) {
                where = where + " and " + DbSales.colNames[DbSales.COL_NUMBER] + " like '%" + number + "%'";
            } else {
                where = DbSales.colNames[DbSales.COL_NUMBER] + " like '%" + number + "%'";
            }
        }

        if (status != -1) {
            if (where.length() > 0) {
                where = where + " and " + DbSales.colNames[DbSales.COL_STATUS] + "  = " + status;
            } else {
                where = DbSales.colNames[DbSales.COL_STATUS] + "  = " + status;
            }
        }

        if (ignoreDate == 0) {
            if (where != null && where.length() > 0) {
                where = where + " and (" + DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                        " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            } else {
                where = where + "(" + DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                        " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            }
        }

        if (where.length() > 0) {
            sql = sql + " where " + where;
        }

        if (recordToGet > 0) {
            sql = sql + " limit " + start + "," + recordToGet;
        }

        CONResultSet crs = null;
        Vector result = new Vector();
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Sales p = new Sales();
                DbSales.resultToObject(rs, p);
                result.add(p);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static int getCountSales(long customerId, String salesName, String number, Date startDate, Date endDate, int ignoreDate, int status) {

        String sql = " select count(" + DbSales.colNames[DbSales.COL_SALES_ID] + ") from " + DB_SALES;

        String where = "";
        if (customerId != 0) {
            //sql = sql + " and p."+colNames[COL_CUSTOMER_ID]+" = "+customerId;
            where = DbSales.colNames[DbSales.COL_CUSTOMER_ID] + " = " + customerId;
        }

        if (salesName != null && salesName.length() > 0) {
            if (where.length() > 0) {
                //sql = sql + " and p."+DbSales.colNames[DbSales.COL_NAME]+" like '%"+salesName+"%'";
                where = where + " and " + DbSales.colNames[DbSales.COL_NAME] + " like '%" + salesName + "%'";
            } else {
                where = DbSales.colNames[DbSales.COL_NAME] + " like '%" + salesName + "%'";
            }
        }

        if (number != null && number.length() > 0) {
            if (where.length() > 0) {
                //sql = sql + " and p."+DbSales.colNames[DbSales.COL_NUMBER]+" like '%"+number+"%'";
                where = where + " and " + DbSales.colNames[DbSales.COL_NUMBER] + " like '%" + number + "%'";
            } else {
                where = DbSales.colNames[DbSales.COL_NUMBER] + " like '%" + number + "%'";
            }
        }

        if (status != -1) {
            if (where.length() > 0) {
                //sql = sql + " and p."+DbSales.colNames[DbSales.COL_STATUS]+"  = "+status;
                where = where + " and " + DbSales.colNames[DbSales.COL_STATUS] + "  = " + status;
            } else {
                where = DbSales.colNames[DbSales.COL_STATUS] + "  = " + status;
            }
        }

        if (ignoreDate == 0) {
            if (where != null && where.length() > 0) {
                //sql = sql + " and (p."+DbSales.colNames[DbSales.COL_DATE]+" between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
                //  " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                where = where + " and (" + DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                        " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            } else {
                where = where + " (" + DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                        " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            }
        }

        if (where.length() > 0) {
            sql = sql + " where " + where;
        }

        CONResultSet crs = null;
        int result = 0;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {

                result = rs.getInt(1);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static Vector getCustomerBySales(long customerId, long unitUsahaId) {

        String sql = "select distinct c.* from " + DB_SALES + " p " +
                "inner join " + DbCustomer.DB_CUSTOMER + " c " +
                "on c." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = p." + colNames[COL_CUSTOMER_ID];

        String where = "";
        if (customerId != 0) {
            where = "p." + colNames[COL_CUSTOMER_ID] + "=" + customerId;
        }

        if (unitUsahaId != 0) {
            if (where != null && where.length() > 0) {
                where = where + " and ";
            }

            where = where + colNames[COL_UNIT_USAHA_ID] + "=" + unitUsahaId;
        }

        if (where != null && where.length() > 0) {
            sql = sql + " where " + where;
        }

        Vector result = new Vector();

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Customer c = new Customer();
                resultToObject(rs, c);
                result.add(c);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public static Vector getSalesReport(Date startDate, Date endDate, long unitUsahaId) {

        String sql = " select psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] +
                ", sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ")" +
                ", sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ")" +
                ", sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * ps." + colNames[COL_DISCOUNT_PERCENT] + "/100)" +
                ", sum((psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " - (psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * ps." + colNames[COL_DISCOUNT_PERCENT] + "/100))" +
                " * ps." + colNames[COL_VAT_PERCENT] + "/100) " +
                " from " + DbSalesDetail.DB_SALES_DETAIL + " psd " +
                " inner join " + DB_SALES + " ps on " +
                " ps." + colNames[COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                " where ps." + colNames[COL_DATE] + " between " +
                " '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";

        if (unitUsahaId != 0) {
            sql = sql + " and ps." + colNames[COL_UNIT_USAHA_ID] + "=" + unitUsahaId;
        }

        sql = sql + " group by psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                RptSales rpt = new RptSales();
                rpt.setItemMasterId(rs.getLong(1));
                rpt.setQty(rs.getDouble(2));
                rpt.setAmount(rs.getDouble(3));
                rpt.setDiscount(rs.getDouble(4));
                rpt.setVat(rs.getDouble(5));

                ItemMaster imx = new ItemMaster();
                try {
                    imx = DbItemMaster.fetchExc(rpt.getItemMasterId());
                    rpt.setItemName(imx.getCode() + " - " + imx.getName());
                    ItemGroup ig = DbItemGroup.fetchExc(imx.getItemGroupId());
                    rpt.setItemGroupName(ig.getName());
                } catch (Exception ex) {
                }

                result.add(rpt);

            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static Vector getSalesReport(Date startDate, Date endDate, long unitUsahaId, int salesType) {

        String sql = " select psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] +
                ", sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ")" +
                ", sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ")" +
                ", sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * ps." + colNames[COL_DISCOUNT_PERCENT] + "/100)" +
                ", sum((psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " - (psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * ps." + colNames[COL_DISCOUNT_PERCENT] + "/100))" +
                " * ps." + colNames[COL_VAT_PERCENT] + "/100) " +
                " from " + DbSalesDetail.DB_SALES_DETAIL + " psd " +
                " inner join " + DB_SALES + " ps on " +
                " ps." + colNames[COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                " where ps." + colNames[COL_DATE] + " between " +
                " '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";

        if (unitUsahaId != 0) {
            sql = sql + " and ps." + colNames[COL_UNIT_USAHA_ID] + "=" + unitUsahaId;
        }

        sql = sql + " group by psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID];

        Vector result = new Vector();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                RptSales rpt = new RptSales();
                rpt.setItemMasterId(rs.getLong(1));
                rpt.setQty(rs.getDouble(2));
                rpt.setAmount(rs.getDouble(3));
                rpt.setDiscount(rs.getDouble(4));
                rpt.setVat(rs.getDouble(5));

                ItemMaster imx = new ItemMaster();
                try {
                    imx = DbItemMaster.fetchExc(rpt.getItemMasterId());
                    rpt.setItemName(imx.getCode() + " - " + imx.getName());
                    ItemGroup ig = DbItemGroup.fetchExc(imx.getItemGroupId());
                    rpt.setItemGroupName(ig.getName());
                } catch (Exception ex) {
                }

                result.add(rpt);

            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static void postJournal(long unitID) {

        Company comp = DbCompany.getCompany();

        ExchangeRate er = DbExchangeRate.getStandardRate();

        Vector v = list(0, 0, colNames[COL_UNIT_USAHA_ID] + "=" + unitID + " and " + colNames[COL_STATUS] + "=0", "");

        if (v != null && v.size() > 0) {

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                UnitUsaha us = new UnitUsaha();

                try {
                    us = DbUnitUsaha.fetchExc(sales.getUnitUsahaId());
                } catch (Exception ex) {
                }

                Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");

                //jurnal main
                String memo = "Cash sales, " + us.getName() + ", " + JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") + ", nomor : " + sales.getNumber();

                long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), sales.getNumber(), sales.getNumberPrefix(),
                        I_Project.JOURNAL_TYPE_GENERAL_LEDGER,
                        memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate());

                //jurnal debet
                memo = "Cash";
                String salesCode = DbSystemProperty.getValueByName("SALES_ACC_CODE").trim();
                Coa coa = DbCoa.getCoaByCode(salesCode);

                double amount = sales.getAmount() - sales.getDiscountAmount() + sales.getVatAmount();

                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amount,
                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0);

                //jurnal credit vat
                if (sales.getVatPercent() > 0) {
                    memo = "ppn";
                    DbGl.postJournalDetail(er.getValueIdr(), us.getCoaPpnId(), sales.getVatAmount(), 0,
                            sales.getVatAmount(), comp.getBookingCurrencyId(), oid, memo, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0);
                }

                for (int x = 0; x < dtls.size(); x++) {

                    SalesDetail sd = (SalesDetail) dtls.get(x);

                    ItemMaster im = new ItemMaster();
                    ItemGroup ig = new ItemGroup();
                    try {
                        im = DbItemMaster.fetchExc(sd.getProductMasterId());
                        ig = DbItemGroup.fetchExc(im.getItemGroupId());
                    } catch (Exception e) {
                    }

                    String igs = ig.getAccountSalesCash();
                    Coa coaSales = DbCoa.getCoaByCode(ig.getAccountSalesCash().trim());
                    Coa coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                    Coa coaCogs = DbCoa.getCoaByCode(ig.getAccountCogs().trim());

                    //jurnal credit sales
                    if (sales.getDiscountPercent() == 0) {
                        memo = "sales item " + im.getName();
                        DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), sd.getTotal(), 0,
                                sd.getTotal(), comp.getBookingCurrencyId(), oid, memo, 0);
                    } else {
                        amount = sd.getTotal() - (sd.getTotal() * sales.getDiscountPercent() / 100);
                        memo = "sales item " + im.getName();
                        DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), amount, 0,
                                amount, comp.getBookingCurrencyId(), oid, memo, 0);
                    }

                    //hpp & inventory - and stockable only
                    if (sd.getCogs() > 0 && im.getNeedRecipe() == 0) {
                        //journal inventory credit
                        memo = "inventory : " + im.getName();
                        DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOID(), sd.getCogs() * sd.getQty(), 0,
                                im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0);

                        //journal hpp
                        memo = "hpp : " + im.getName();
                        DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOID(), 0, sd.getCogs() * sd.getQty(),
                                im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0);

                    }
                    //proses stock
                    DbStock.insertSalesItem(sales, sd);
                }

                DbGl.optimizeJournal(oid);

                sales.setStatus(1);
                try {
                    DbSales.updateExc(sales);
                } catch (Exception e) {
                }
            }
        }
    }

    public static void postJournalRetur(Vector temp, long userId, long periodId) {

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;

        if (v != null && v.size() > 0) {

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                long segment1_id = 0;

                //untuk pengecekan ke segment
                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();

                try {

                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {
                        }

                        if (payment.getCurrency_id() == 0) {
                            try {
                                long currIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {
                            }

                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                            } catch (Exception e) {
                            }
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }

                        if (comp.getMultiBank() == DbCompany.MULTI_BANK) { // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }
                    }

                    if (sales.getNumber().length() <= 0) {
                        coaLocationTrue = false;
                    }

                    if (sales.getLocation_id() != 0) {
                        location = DbLocation.fetchExc(sales.getLocation_id());
                    }
                } catch (Exception e) {
                }

                if (sales.getType() == DbSales.TYPE_RETUR_CASH) {

                    Coa co = new Coa();
                    if (location.getCoaSalesId() == 0) {
                        coaLocationTrue = false;
                    } else {
                        try {
                            co = DbCoa.fetchExc(location.getCoaSalesId());
                            if (co.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }
                    }

                    Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");

                    for (int ix = 0; ix < dtls.size(); ix++) {

                        SalesDetail sdCk = (SalesDetail) dtls.get(ix);

                        ItemMaster im = new ItemMaster();
                        ItemGroup ig = new ItemGroup();
                        try {
                            im = DbItemMaster.fetchExc(sdCk.getProductMasterId());
                            ig = DbItemGroup.fetchExc(im.getItemGroupId());
                        } catch (Exception e) {
                        }

                        Coa coaInv = new Coa();
                        try {
                            coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                        } catch (Exception e) {
                        }

                        if (coaInv.getOID() == 0) {
                            coaLocationTrue = false;
                        }

                        Coa coaSlCash = new Coa();
                        try {
                            coaSlCash = DbCoa.getCoaByCode(ig.getAccountSalesCash().trim());
                        } catch (Exception e) {
                        }

                        if (coaSlCash.getOID() == 0) {
                            coaLocationTrue = false;
                        }
                    }

                    if (coaLocationTrue) {

                        String noTransaksi = "";

                        try {
                            noTransaksi = sales.getNumber();
                        } catch (Exception e) {
                        }

                        Customer cust = new Customer();
                        try {
                            cust = DbCustomer.fetchExc(sales.getCustomerId());
                        } catch (Exception ex) {
                        }

                        //jurnal main
                        String memo = "Retur cash sales " + location.getName() + " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());

                        if (noTransaksi.length() > 0) {
                            memo = memo + " no transaksi " + noTransaksi;
                        }

                        //cek nomor, jika sama cari nomor lain
                        int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                        String number = sales.getNumber();
                        if (count > 0) {
                            number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                        }

                        //post jurnal
                        long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                I_Project.JOURNAL_TYPE_SALES,
                                memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                        if (oid != 0) {

                            double amount = 0;
                            for (int id = 0; id < dtls.size(); id++) {

                                SalesDetail sd = (SalesDetail) dtls.get(id); //pengambilan object sales detail

                                String notes = "Retur transaksi cash ";

                                if (noTransaksi.length() > 0) {
                                    notes = notes + " no transaksi " + noTransaksi;
                                }

                                ItemMaster im = new ItemMaster();
                                ItemGroup ig = new ItemGroup();
                                try {
                                    im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                    ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                } catch (Exception e) {
                                }

                                Coa coaSales = new Coa();
                                Coa coaInv = new Coa();
                                Coa coaCogs = new Coa();

                                try {
                                    coaSales = DbCoa.getCoaByCode(ig.getAccountSalesCash());
                                } catch (Exception e) {
                                }
                                try {
                                    coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                                } catch (Exception e) {
                                }
                                try {
                                    coaCogs = DbCoa.getCoaByCode(ig.getAccountCogs().trim());
                                } catch (Exception e) {
                                }

                                if (comp.getUseBkp() == DbCompany.USE_BKP && im.getIs_bkp() == DbItemMaster.BKP) {

                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();

                                    double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                    double amountPpn = amountTransaction - price;
                                    memo = "sales item " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), 0, price,
                                            price, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    Coa coaPpn = new Coa();
                                    try {
                                        coaPpn = DbCoa.getCoaByCode(ig.getAccountVat().trim());
                                    } catch (Exception e) {
                                    }

                                    memo = "ppn " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaPpn.getOID(), 0, amountPpn,
                                            amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    amount = amount + (price + amountPpn);

                                } else {

                                    memo = "sales item " + im.getName();
                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), 0, amountTransaction,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    amount = amount + amountTransaction;
                                }

                                //journal inventory credit only for stockable item
                                if (sd.getCogs() > 0 && im.getNeedRecipe() == 0) {

                                    memo = "inventory : " + im.getName();
                                    DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOID(), 0, sd.getCogs() * sd.getQty(),
                                            im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    //journal hpp
                                    memo = "hpp : " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOID(), sd.getCogs() * sd.getQty(), 0,
                                            im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }

                                Coa coa = new Coa();
                                Coa coaExpense = new Coa();
                                double amountExpense = 0;

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {
                                        }

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {
                                            }
                                        } else {
                                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                memo = "Piutang Credit Card";
                                            } else {
                                                memo = "Piutang Debit Card";
                                            }
                                            try {
                                                try {
                                                    merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                } catch (Exception e) {
                                                }
                                                try {
                                                    coa = DbCoa.fetchExc(merchant.getCoaId());
                                                } catch (Exception e) {
                                                }
                                                try {
                                                    coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                } catch (Exception e) {
                                                }

                                                if (merchant.getPersenExpense() > 0) {
                                                    amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                }
                                            } catch (Exception e) {
                                            }
                                        }
                                    }
                                } else {
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {
                                    }
                                }


                                if (amountExpense > 0) {
                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                        memo = "Biaya Komisi Credit Card";
                                    } else {
                                        memo = "Biaya Komisi Debit Card";
                                    }
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                            amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    double piutangCC = amount - amountExpense;

                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                } else {

                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                            amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }

                            }

                            updateStatus(sales.getOID(), userId); // update status menjadi posted                            
                        }
                    }

                } else if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {

                    Coa co = new Coa();
                    if (location.getCoaSalesId() == 0) {
                        coaLocationTrue = false;
                    } else {
                        try {
                            co = DbCoa.fetchExc(location.getCoaSalesId());
                            if (co.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }
                    }

                    Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");

                    for (int ix = 0; ix < dtls.size(); ix++) {

                        SalesDetail sdCk = (SalesDetail) dtls.get(ix);

                        ItemMaster im = new ItemMaster();
                        ItemGroup ig = new ItemGroup();
                        try {
                            im = DbItemMaster.fetchExc(sdCk.getProductMasterId());
                            ig = DbItemGroup.fetchExc(im.getItemGroupId());
                        } catch (Exception e) {
                        }

                        Coa coaInv = new Coa();
                        try {
                            coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                        } catch (Exception e) {
                        }

                        if (coaInv.getOID() == 0) {
                            coaLocationTrue = false;
                        }

                        Coa coaSlCredit = new Coa();
                        try {
                            coaSlCredit = DbCoa.getCoaByCode(ig.getAccountCreditIncome().trim());
                        } catch (Exception e) {
                        }

                        if (coaSlCredit.getOID() == 0) {
                            coaLocationTrue = false;
                        }
                    }

                    if (coaLocationTrue) {

                        String noTransaksi = "";

                        try {
                            noTransaksi = sales.getNumber();
                        } catch (Exception e) {
                        }

                        Customer cust = new Customer();
                        try {
                            cust = DbCustomer.fetchExc(sales.getCustomerId());
                        } catch (Exception ex) {
                        }

                        //jurnal main
                        String memo = "Retur credit " + location.getName() + " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());
                        if (noTransaksi.length() > 0) {
                            memo = memo + " no transaksi " + noTransaksi;
                        }

                        //cek nomor, jika sama cari nomor lain
                        int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                        String number = sales.getNumber();
                        if (count > 0) {
                            number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                        }

                        //post jurnal
                        long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                I_Project.JOURNAL_TYPE_SALES,
                                memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                        if (oid != 0) {

                            double amount = 0;

                            for (int id = 0; id < dtls.size(); id++) {

                                SalesDetail sd = (SalesDetail) dtls.get(id); //pengambilan object sales detail

                                String notes = "Retur transaksi credit ";

                                if (noTransaksi.length() > 0) {
                                    notes = notes + " no transaksi " + noTransaksi;
                                }

                                ItemMaster im = new ItemMaster();
                                ItemGroup ig = new ItemGroup();
                                try {
                                    im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                    ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                } catch (Exception e) {
                                }

                                Coa coaSales = new Coa();
                                try {
                                    coaSales = DbCoa.getCoaByCode(ig.getAccountSalesCash().trim());
                                } catch (Exception e) {
                                }

                                Coa coaInv = new Coa();
                                try {
                                    coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                                } catch (Exception e) {
                                }

                                Coa coaCogs = new Coa();
                                try {
                                    coaCogs = DbCoa.getCoaByCode(ig.getAccountCogs().trim());
                                } catch (Exception e) {
                                }

                                if (comp.getUseBkp() == DbCompany.USE_BKP && im.getIs_bkp() == DbItemMaster.BKP) {

                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();

                                    double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                    double amountPpn = amountTransaction - price;
                                    memo = "sales item " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), 0, price,
                                            price, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    Coa coaPpn = new Coa();
                                    try {
                                        coaPpn = DbCoa.getCoaByCode(ig.getAccountVat().trim());
                                    } catch (Exception e) {
                                    }

                                    memo = "ppn " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaPpn.getOID(), 0, amountPpn,
                                            amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    amount = amount + (price + amountPpn);

                                } else {

                                    memo = "sales item " + im.getName();
                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), 0, amountTransaction,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    amount = amount + amountTransaction;
                                }

                                if (sd.getCogs() > 0 && im.getNeedRecipe() == 0) {

                                    memo = "inventory : " + im.getName();
                                    DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOID(), 0, sd.getCogs() * sd.getQty(),
                                            im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    //journal hpp
                                    memo = "hpp : " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOID(), sd.getCogs() * sd.getQty(), 0,
                                            im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }


                                Coa coa = new Coa();
                                Coa coaExpense = new Coa();
                                double amountExpense = 0;

                                try {
                                    coa = DbCoa.fetchExc(location.getCoaArId());
                                } catch (Exception e) {
                                }

                                memo = "Credit Sales";


                                if (amountExpense > 0) {
                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                        memo = "Biaya Komisi Credit Card";
                                    } else {
                                        memo = "Biaya Komisi Debit Card";
                                    }
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                            amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    double piutangCC = amount - amountExpense;

                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                } else {

                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                            amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }
                            
                            }

                            updateStatus(sales.getOID(), userId); // update status menjadi posted

                            //insert ke piutang                            
                            if (sales.getType() != DbSales.TYPE_RETUR_CREDIT) {
                                postReceivable(sales, dtls);
                            }
                        }
                    }
                }
            }
        }
    }

    public static void postReceivable(Sales sales) {

        if (sales.getOID() != 0) {

            ARInvoice ar = new ARInvoice();
            ar.setSalesSource(1);
            ar.setDate(sales.getDate());
            ar.setProjectId(sales.getOID());
            ar.setDueDate(sales.getDate());
            ar.setTransDate(sales.getDate());
            ar.setCompanyId(sales.getCompanyId());
            ar.setOperatorId(sales.getUserId());
            ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
            ar.setCurrencyId(sales.getCurrencyId());
            ar.setCustomerId(sales.getCustomerId());
            ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
            ar.setDiscount(sales.getDiscount());
            ar.setDiscountPercent(sales.getDiscountPercent());
            ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
            ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
            ar.setProjectTermId(sales.getOID());
            ar.setTotal(sales.getAmount());
            ar.setVat(sales.getVat());
            ar.setVatAmount(sales.getVatAmount());
            ar.setVatPercent(sales.getVatPercent());
            ar.setInvoiceNumber(sales.getNumber());

            try {

                long oid = DbARInvoice.insertExc(ar);

                if (oid != 0) {
                    ARInvoiceDetail ard = new ARInvoiceDetail();

                    ard.setArInvoiceId(oid);
                    ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                    ard.setQty(1);
                    ard.setPrice(sales.getAmount() - sales.getDiscountAmount() + sales.getVatAmount());
                    ard.setTotalAmount(sales.getAmount() - sales.getDiscountAmount() + sales.getVatAmount());
                    ard.setCompanyId(sales.getCompanyId());

                    try {
                        DbARInvoiceDetail.insertExc(ard);
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e) {
            }
        }
    }

       public static void postJourRetur(Vector temp, long userId, long periodId){

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;
        
        String activeMerchant = "YES";                        
        Date activeDate = null;
        
        try{
            activeMerchant = DbSystemProperty.getValueByName("ACTIVE_MERCHANT");                           
            activeDate = new Date();                              
            activeDate = JSPFormater.formatDate(activeMerchant, "dd/MM/yyyy");  
        }catch(Exception e){
            System.out.println("[Exception] "+e.toString());
        }
        

        if (v != null && v.size() > 0){

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                long segment1_id = 0;                
                
                boolean merchantAktif = true;
                try{
                    if(activeMerchant.compareTo("YES") != 0 ){
                        if(sales.getDate().after(activeDate)){
                            merchantAktif = true;
                        }else{
                            merchantAktif = false;
                        }
                    }                    
                }catch(Exception e){}

                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();

                if (sales.getSalesReturId() != 0) {
                    
                    if (sales.getSalesReturId() == 0){
                        coaLocationTrue = false;
                    }

                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {}

                        if (payment.getCurrency_id() == 0) {
                            try {
                                long currIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {}

                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                            } catch (Exception e) {}
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }

                        if (comp.getMultiBank() == DbCompany.MULTI_BANK && merchantAktif) { // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }
                    }

                    try {
                        if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            Sales slRet = new Sales();
                            try {
                                slRet = DbSales.fetchExc(sales.getSalesReturId());
                            } catch (Exception e) {
                            }
                            if (slRet.getStatus() == 0) {
                                coaLocationTrue = false;
                            }
                        }
                    } catch (Exception e) {
                        coaLocationTrue = false;
                    }

                    try {
                        if (sales.getLocation_id() != 0) {
                            location = DbLocation.fetchExc(sales.getLocation_id());
                            Coa co = new Coa();
                            if (location.getCoaSalesId() == 0) {
                                coaLocationTrue = false;
                            } else {
                                try {
                                    co = DbCoa.fetchExc(location.getCoaSalesId());
                                    if (co.getOID() == 0) {
                                        coaLocationTrue = false;
                                    }
                                } catch (Exception e) {
                                    coaLocationTrue = false;
                                }
                            }

                            Coa co2 = new Coa();
                            if (location.getCoaProjectPPHPasal22Id() == 0) {
                                coaLocationTrue = false;
                            } else {
                                try {
                                    co2 = DbCoa.fetchExc(location.getCoaProjectPPHPasal22Id());
                                    if (co2.getOID() == 0) {
                                        coaLocationTrue = false;
                                    }
                                } catch (Exception e) {
                                    coaLocationTrue = false;
                                }
                            }

                            Coa co3 = new Coa();
                            if (location.getCoaProjectPPHPasal23Id() == 0) {
                                coaLocationTrue = false;
                            } else {
                                try {
                                    co3 = DbCoa.fetchExc(location.getCoaProjectPPHPasal23Id());
                                    if (co3.getOID() == 0) {
                                        coaLocationTrue = false;
                                    }
                                } catch (Exception e) {
                                    coaLocationTrue = false;
                                }
                            }
                        } else {
                            coaLocationTrue = false;
                        }
                    } catch (Exception e) {
                    }

                    Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");

                    for (int ix = 0; ix < dtls.size(); ix++) {

                        SalesDetail sdCk = (SalesDetail) dtls.get(ix);

                        ItemMaster im = new ItemMaster();
                        ItemGroup ig = new ItemGroup();
                        try {
                            im = DbItemMaster.fetchExc(sdCk.getProductMasterId());
                            ig = DbItemGroup.fetchExc(im.getItemGroupId());
                        } catch (Exception e) {
                        }

                        Coa coaSalesCredit = new Coa();
                        try {
                            coaSalesCredit = DbCoa.getCoaByCode(ig.getAccountSales().trim());
                        } catch (Exception e) {}
                        
                        if (coaSalesCredit.getOID() == 0) {
                            coaLocationTrue = false;
                        }
                        
                        if (sdCk.getCogs() > 0 && im.getNeedRecipe() == 0) {
                            
                            Coa coaInv = new Coa();
                            try {
                                coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                            } catch (Exception e) {}
                        
                            if (coaInv.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                            
                            Coa coaCogs = new Coa();
                            try {
                                coaCogs = DbCoa.getCoaByCode(ig.getAccountCogs().trim());
                            } catch (Exception e) {
                            }
                            
                            if (coaCogs.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        }

                        Coa coaSl = new Coa();
                        try {
                            coaSl = DbCoa.getCoaByCode(ig.getAccountSalesCash().trim());
                        } catch (Exception e) {
                        }

                        if (coaSl.getOID() == 0) {
                            coaLocationTrue = false;
                        }

                        Coa coaSales = new Coa();
                        try {
                            coaSales = DbCoa.getCoaByCode(ig.getAccountCreditIncome().trim());
                        } catch (Exception e) {
                        }

                        if (coaSales.getOID() == 0) {
                            coaLocationTrue = false;
                        }
                    }

                    if (coaLocationTrue) { // jika kondisi setup coa untuk sales tidak kosong

                        Customer cust = new Customer();
                        if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            try {
                                cust = DbCustomer.fetchExc(sales.getCustomerId());
                            } catch (Exception ex) {}
                        }

                        //jurnal main
                        String memo = "";
                        if (sales.getType() == DbSales.TYPE_RETUR_CASH) {
                            memo = "Retur Cash sales, " + location.getName();
                        } else {
                            memo = "Retur Credit sales, " + location.getName() +
                                    " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());
                        }

                        //cek nomor, jika sama cari nomor lain
                        int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                        String number = sales.getNumber();
                        if (count > 0) {
                            number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                        }

                        //post jurnal
                        long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                I_Project.JOURNAL_TYPE_RETUR,
                                memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                        //jika sukses input gl
                        if (oid != 0) {
                            //jurnal debet
                            double amount = 0;

                            for (int x = 0; x < dtls.size(); x++) {

                                SalesDetail sd = (SalesDetail) dtls.get(x);

                                ItemMaster im = new ItemMaster();
                                ItemGroup ig = new ItemGroup();
                                try {
                                    im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                    ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                } catch (Exception e) {}
                                
                                Coa coaSales = new Coa();
                                try {
                                    coaSales = DbCoa.getCoaByCode(ig.getAccountSalesCash().trim());
                                } catch (Exception e) {}

                                Coa coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                                Coa coaCogs = DbCoa.getCoaByCode(ig.getAccountCogs().trim());

                                if (comp.getUseBkp() == DbCompany.USE_BKP && im.getIs_bkp() == DbItemMaster.BKP) {

                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();
                                    double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                    double amountPpn = amountTransaction - price;

                                    memo = "Retur sales item " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), 0, price,
                                            price, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    Coa coaPpn = new Coa();
                                    try {
                                        coaPpn = DbCoa.getCoaByCode(ig.getAccountVat().trim());
                                    } catch (Exception e) {}

                                    memo = "ppn " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaPpn.getOID(), 0, amountPpn,
                                            amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    amount = amount + (price + amountPpn);

                                } else {

                                    memo = "Retur sales item " + im.getName();
                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), 0, amountTransaction,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    amount = amount + amountTransaction;
                                }

                                //journal inventory credit only for stockable item
                                if (sd.getCogs() > 0 && im.getNeedRecipe() == 0) {

                                    memo = "inventory : " + im.getName();
                                    DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOID(), 0, sd.getCogs() * sd.getQty(),
                                            im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    //journal hpp
                                    memo = "hpp : " + im.getName();

                                    DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOID(), sd.getCogs() * sd.getQty(), 0,
                                            im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }
                            }

                            Coa coa = new Coa();
                            Coa coaExpense = new Coa();
                            double amountExpense = 0;

                            if (sales.getType() == DbSales.TYPE_RETUR_CASH){

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}

                                        } else {
                                            
                                            if(merchantAktif){

                                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                    memo = "Piutang Credit Card";
                                                } else {
                                                    memo = "Piutang Debit Card";
                                                }

                                                try {
                                                    try {
                                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                    } catch (Exception e) {}
                                                    
                                                    try {
                                                        coa = DbCoa.fetchExc(merchant.getCoaId());
                                                    } catch (Exception e) {}
                                                    
                                                    try {
                                                        coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                    } catch (Exception e) {}

                                                    if (merchant.getPersenExpense() > 0) {
                                                        amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                    }

                                                } catch (Exception e) {}
                                            }else{                                                
                                                memo = "Cash";
                                                try {
                                                    coa = DbCoa.fetchExc(curr.getCoaId());
                                                } catch (Exception e) {}
                                            }
                                        }

                                    }
                                } else {
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {}
                                }

                            } else {
                                try {
                                    coa = DbCoa.fetchExc(location.getCoaArId());
                                } catch (Exception e) {
                                }
                                memo = "Credit Sales";
                            }

                            double amountPiutang = 0;

                            if (amountExpense > 0) {
                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                    memo = "Biaya Komisi Credit Card";
                                } else {
                                    memo = "Biaya Komisi Debit Card";
                                }
                                DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                double piutangCC = amount - amountExpense;
                                amountPiutang = piutangCC;
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                        piutangCC, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                            } else {
                                amountPiutang = amount;
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }

                            Date dt = new Date();

                            String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                    DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                    DbPeriode.colNames[DbPeriode.COL_END_DATE];

                            Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                            Date effectiveDate = new Date();

                            if (tempEff != null && tempEff.size() > 0) {
                                effectiveDate = new Date();
                            } else {
                                Periode per = new Periode();
                                if (periodId != 0) {
                                    try {
                                        per = DbPeriode.fetchExc(periodId);
                                    } catch (Exception e) {
                                        per = DbPeriode.getOpenPeriod();
                                    }
                                }
                                effectiveDate = per.getEndDate();
                            }

                            updateStatus(sales.getOID(), userId, effectiveDate);

                            if (sales.getType() == DbSales.TYPE_RETUR_CREDIT){                                
                                try{
                                    String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+sales.getOID();
                                    Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                                    if(vCP != null && vCP.size() > 0){
                                        CreditPayment cp = (CreditPayment)vCP.get(0);      
                                        DbCreditPayment.updateStatusPayCredit(cp.getOID(), userId); 
                                    }
                                }catch(Exception e){}
                                postPaymentReceivable(sales, er, amountPiutang);
                            }
                        }
                    }                
                }else{ //kalau kasirnya tidak menginputkan no transaksi yang di retur
                         
                        if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                            try {
                                Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                                if (vPayment != null && vPayment.size() > 0) {
                                    payment = (Payment) vPayment.get(0);
                                }
                            } catch (Exception e) {}

                            if (payment.getCurrency_id() == 0) {
                                try {
                                    long currIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                    curr = DbCurrency.fetchExc(currIDR);
                                } catch (Exception e) {}

                            } else {
                                try {
                                    curr = DbCurrency.fetchExc(payment.getCurrency_id());
                                } catch (Exception e) {}
                            }

                            try {
                                Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                                if (coaCurr.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }

                            if (comp.getMultiBank() == DbCompany.MULTI_BANK && merchantAktif){ // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                    if (payment.getMerchantId() == 0) {
                                        coaLocationTrue = false;
                                    } else {
                                        try {
                                            merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                            Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                            if (coaM.getOID() == 0) {
                                                coaLocationTrue = false;
                                            }
                                        } catch (Exception E) {
                                            coaLocationTrue = false;
                                        }
                                    }
                                }
                            }
                        }

                        try {
                            if (sales.getLocation_id() != 0) {
                                location = DbLocation.fetchExc(sales.getLocation_id());
                                Coa co = new Coa();
                                if (location.getCoaSalesId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co = DbCoa.fetchExc(location.getCoaSalesId());
                                        if (co.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }

                                Coa co2 = new Coa();
                                if (location.getCoaProjectPPHPasal22Id() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co2 = DbCoa.fetchExc(location.getCoaProjectPPHPasal22Id());
                                        if (co2.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }

                                Coa co3 = new Coa();
                                if (location.getCoaProjectPPHPasal23Id() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co3 = DbCoa.fetchExc(location.getCoaProjectPPHPasal23Id());
                                        if (co3.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }
                            } else {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {}
                        
                        
                        Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");

                        for (int ix = 0; ix < dtls.size(); ix++) {

                            SalesDetail sdCk = (SalesDetail) dtls.get(ix);

                            ItemMaster im = new ItemMaster();
                            ItemGroup ig = new ItemGroup();
                            try {
                                im = DbItemMaster.fetchExc(sdCk.getProductMasterId());
                                ig = DbItemGroup.fetchExc(im.getItemGroupId());
                            } catch (Exception e) {}

                            Coa coaSalesCredit = new Coa();
                            try {
                                coaSalesCredit = DbCoa.getCoaByCode(ig.getAccountSales().trim());
                            } catch (Exception e) {}
                        
                            if (coaSalesCredit.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        
                            if (sdCk.getCogs() > 0 && im.getNeedRecipe() == 0) {
                            
                                Coa coaInv = new Coa();
                                try {
                                    coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                                } catch (Exception e) {}
                        
                                if (coaInv.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            
                                Coa coaCogs = new Coa();
                                try {
                                    coaCogs = DbCoa.getCoaByCode(ig.getAccountCogs().trim());
                                } catch (Exception e) {
                                }
                            
                                if (coaCogs.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            }

                            Coa coaSl = new Coa();
                            try {
                                coaSl = DbCoa.getCoaByCode(ig.getAccountSalesCash().trim());
                            } catch (Exception e) {
                            }

                            if (coaSl.getOID() == 0) {
                                coaLocationTrue = false;
                            }

                            Coa coaSales = new Coa();
                            try {
                                coaSales = DbCoa.getCoaByCode(ig.getAccountCreditIncome().trim());
                            } catch (Exception e) {
                            }

                            if (coaSales.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        }

                         if (coaLocationTrue){ // jika kondisi setup coa untuk sales tidak kosong
                       
                            String memo = "Retur Cash sales, " + location.getName();

                            //cek nomor, jika sama cari nomor lain
                            int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                            String number = sales.getNumber();
                            if (count > 0) {
                                number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                            }

                            //post jurnal
                            long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                    I_Project.JOURNAL_TYPE_RETUR,
                                    memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                            //jika sukses input gl
                            if (oid != 0) {
                                //jurnal debet
                                double amount = 0;
                                
                                for (int x = 0; x < dtls.size(); x++) {

                                    SalesDetail sd = (SalesDetail) dtls.get(x);

                                    ItemMaster im = new ItemMaster();
                                    ItemGroup ig = new ItemGroup();
                                    try {
                                        im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                        ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                    } catch (Exception e) {}
                                
                                    Coa coaSales = new Coa();
                                    try {
                                        coaSales = DbCoa.getCoaByCode(ig.getAccountSalesCash().trim());
                                    } catch (Exception e) {}

                                    Coa coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                                    Coa coaCogs = DbCoa.getCoaByCode(ig.getAccountCogs().trim());

                                    if (comp.getUseBkp() == DbCompany.USE_BKP && im.getIs_bkp() == DbItemMaster.BKP){

                                        double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();
                                        double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                        double amountPpn = amountTransaction - price;

                                        memo = "Retur sales item " + im.getName();

                                        DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), 0, price,
                                            price, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        Coa coaPpn = new Coa();
                                        try {
                                            coaPpn = DbCoa.getCoaByCode(ig.getAccountVat().trim());
                                        } catch (Exception e) {}

                                        memo = "ppn " + im.getName();

                                        DbGl.postJournalDetail(er.getValueIdr(), coaPpn.getOID(), 0, amountPpn,
                                            amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        amount = amount + (price + amountPpn);

                                    } else {

                                        memo = "Retur sales item " + im.getName();
                                        double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();

                                        DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), 0, amountTransaction,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        amount = amount + amountTransaction;
                                    }

                                    //journal inventory credit only for stockable item
                                    if (sd.getCogs() > 0 && im.getNeedRecipe() == 0) {

                                        memo = "inventory : " + im.getName();
                                        DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOID(), 0, sd.getCogs() * sd.getQty(),
                                            im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        //journal hpp
                                        memo = "hpp : " + im.getName();

                                        DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOID(), sd.getCogs() * sd.getQty(), 0,
                                            im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                }

                                Coa coa = new Coa();
                                Coa coaExpense = new Coa();
                                double amountExpense = 0;

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}

                                        } else {

                                            if(merchantAktif){
                                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                    memo = "Piutang Credit Card";
                                                } else {
                                                    memo = "Piutang Debit Card";
                                                }

                                                try {
                                                    try {
                                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                    } catch (Exception e) {}
                                                
                                                    try {
                                                        coa = DbCoa.fetchExc(merchant.getCoaId());
                                                    } catch (Exception e) {}
                                                    
                                                    try {
                                                        coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                    } catch (Exception e) {}

                                                    if (merchant.getPersenExpense() > 0) {
                                                        amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                    }

                                                } catch (Exception e) {}
                                            }else{
                                                memo = "Cash";
                                                try {
                                                    coa = DbCoa.fetchExc(curr.getCoaId());
                                                } catch (Exception e) {}
                                            }
                                        }
                                    }
                                } else {
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {}
                                }

                                double amountPiutang = 0;
                                if (amountExpense > 0) {
                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD){
                                        memo = "Biaya Komisi Credit Card";
                                    } else {
                                        memo = "Biaya Komisi Debit Card";
                                    }
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                    double piutangCC = amount - amountExpense;                                
                                    amountPiutang = piutangCC;
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                        piutangCC, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                } else {                      
                                    amountPiutang = amount;
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }

                                Date dt = new Date();

                                String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                    DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                    DbPeriode.colNames[DbPeriode.COL_END_DATE];

                                Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                                Date effectiveDate = new Date();

                                if (tempEff != null && tempEff.size() > 0) {
                                    effectiveDate = new Date();
                                } else {
                                    Periode per = new Periode();
                                    if (periodId != 0) {
                                        try {
                                            per = DbPeriode.fetchExc(periodId);
                                        } catch (Exception e) {
                                            per = DbPeriode.getOpenPeriod();
                                        }
                                    }
                                    effectiveDate = per.getEndDate();
                                }

                                updateStatus(sales.getOID(), userId, effectiveDate);
                                
                                if(sales.getType() == DbSales.TYPE_RETUR_CREDIT){
                                    
                                    try{
                                        String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+sales.getOID();
                                        Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                                        if(vCP != null && vCP.size() > 0){
                                            CreditPayment cp = (CreditPayment)vCP.get(0);      
                                            DbCreditPayment.updateStatusPayCredit(cp.getOID(), userId); 
                                        }
                                    }catch(Exception e){}
                                    
                                    if(amountPiutang != 0){
                                        amountPiutang = amountPiutang * -1;
                                    }
                                    ARInvoice ar = new ARInvoice();
                                    
                                    ar.setSalesSource(1);
                                    ar.setDate(sales.getDate());
                                    ar.setProjectId(sales.getOID());
                                    ar.setDueDate(sales.getDate());
                                    ar.setTransDate(sales.getDate());                                    
                                    ar.setCompanyId(sales.getCompanyId());
                                    ar.setOperatorId(sales.getUserId());
                                    ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
                                    ar.setCurrencyId(sales.getCurrencyId());
                                    ar.setCustomerId(sales.getCustomerId());
                                    ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
                                    ar.setDiscount(0);
                                    ar.setDiscountPercent(0);
                                    ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
                                    ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
                                    ar.setProjectTermId(sales.getOID());
                                    ar.setTotal(amountPiutang);
                                    ar.setVat(0);
                                    ar.setVatAmount(0);
                                    ar.setVatPercent(0);
                                    ar.setInvoiceNumber(sales.getNumber());
                                    ar.setTypeAR(DbARInvoice.TYPE_RETUR);                                    
                                    ar.setPostedStatus(1);
                                    ar.setPostedDate(new Date());
                                    ar.setCreateDate(new Date());
                                    ar.setLocationId(sales.getLocation_id());                                    
                                    try{                                        
                                        long oidx = DbARInvoice.insertExc(ar);                                        
                                        if (oidx != 0) {

                                            ARInvoiceDetail ard = new ARInvoiceDetail();
                                            ard.setArInvoiceId(oidx);
                                            ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                                            ard.setQty(1);
                                            ard.setPrice(amountPiutang);
                                            ard.setDiscount(0);
                                            ard.setTotalAmount(amountPiutang);
                                            ard.setCompanyId(sales.getCompanyId());

                                            try {
                                            DbARInvoiceDetail.insertExc(ard);
                                            } catch (Exception e) {}
                                        }
                                        
                                    }catch(Exception e){}
                                }
                            }
                        }                          
                }
            }
        }
    }
    
    public static void postJournalReturNew(Vector temp, long userId, long periodIdx,Company comp){
        
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;
        
        String activeMerchant = "YES";                        
        Date activeDate = null;
        
        try{
            activeMerchant = DbSystemProperty.getValueByName("ACTIVE_MERCHANT");                           
            activeDate = new Date();                              
            activeDate = JSPFormater.formatDate(activeMerchant, "dd/MM/yyyy");  
        }catch(Exception e){
            System.out.println("[Exception] "+e.toString());
        }

        long deffCurrIDR = 0;
        try {
            deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));            
        } catch (Exception e) {}
        
        Periode p = new Periode();
        if(periodIdx != 0){
            try{
                p = DbPeriode.fetchExc(periodIdx);
            }catch(Exception e){}
        }        
        
        if (v != null && v.size() > 0){

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                long segment1_id = 0;                
                
                boolean merchantAktif = true;
                try{
                    if(activeMerchant.compareTo("YES") != 0 ){
                        if(sales.getDate().after(activeDate)){
                            merchantAktif = true;
                        }else{
                            merchantAktif = false;
                        }
                    }                    
                }catch(Exception e){}

                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();
                long periodId = periodIdx;
                Periode periode = new Periode();               
                
                //Parameter Multy Bank
                
                Hashtable hAccSalesDetail = new Hashtable();               
                
                if(periodId == 0){    
                    try {
                        periode = DbPeriode.getPeriodByTransDate(sales.getDate());
                        periodId = periode.getOID();
                    } catch (Exception e) {
                    }                    
                }else{
                    periode = p;
                }
                
                if (periode.getStatus().compareTo("Closed") == 0) {
                    coaLocationTrue = false;
                }                

                if (sales.getSalesReturId() != 0) { 

                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {}

                        if (payment.getCurrency_id() == 0) {
                            try {
                                long currIDR = deffCurrIDR;
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {}
                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                            } catch (Exception e) {}
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());                           
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }

                        if (comp.getMultiBank() == DbCompany.MULTI_BANK && merchantAktif) { // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }
                    }

                    try {
                        if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            Sales slRet = new Sales();
                            try {
                                slRet = DbSales.fetchExc(sales.getSalesReturId());
                            } catch (Exception e) {
                            }
                            if (slRet.getStatus() == 0) {
                                coaLocationTrue = false;
                            }
                        }
                    } catch (Exception e) {
                        coaLocationTrue = false;
                    }

                    try {
                        if (sales.getLocation_id() != 0) {
                            location = DbLocation.fetchExc(sales.getLocation_id());
                            Coa co = new Coa();
                            if (location.getCoaSalesId() == 0) {
                                coaLocationTrue = false;
                            } else {
                                try {
                                    co = DbCoa.fetchExc(location.getCoaSalesId());
                                    if (co.getOID() == 0) {
                                        coaLocationTrue = false;
                                    }
                                } catch (Exception e) {
                                    coaLocationTrue = false;
                                }
                            }
                           
                        } else {
                            coaLocationTrue = false;
                        }
                    } catch (Exception e) {
                    }

                    Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");
                    for (int ix = 0; ix < dtls.size(); ix++) {

                        SalesDetail sdCk = (SalesDetail) dtls.get(ix);
                        CoaSalesDetail csd = new CoaSalesDetail();
                        csd.setSalesDetailId(sdCk.getOID());
                        csd.setProductMasterId(sdCk.getProductMasterId()); 
                        
                        MasterGroup mg = new MasterGroup();
                        try {                        
                            mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                                                
                        } catch (Exception e) {}
                    
                        csd.setItemName(mg.getName());
                        csd.setIsBkp(mg.getIsBkp());                    
                    
                        // =========== OID PENJUALAN CASH==============
                        MasterOid coaSales = new MasterOid();
                        try {
                            coaSales = DbItemMaster.getOidByCode(mg.getAccSales().trim());                        
                        } catch (Exception e) {}

                        if (coaSales.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }                    
                        csd.setAccSales(coaSales.getOidMaster());                    
                        //============== END ===========================
                    
                        if (comp.getUseBkp() == DbCompany.USE_BKP && mg.getIsBkp() == DbItemMaster.BKP) { // jika menggunakan ppn
                            // =========== OID PPN ==============
                            MasterOid coaPpn = new MasterOid();
                            try {
                                coaPpn = DbItemMaster.getOidByCode(mg.getAccVat().trim());
                            } catch (Exception e) {}
                        
                            if (coaPpn.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }                    
                            csd.setAccPpn(coaPpn.getOidMaster());                    
                            //============== END ===========================
                        }
                        csd.setService(mg.getService());

                        if (sdCk.getCogs() > 0 && mg.getService() == 0){  // Jika bukan service && cogs tidak sama dengan 0                      
                            
                            // =========== OID INVENTORY==============
                            MasterOid coaInv = new MasterOid();
                            try {
                                coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());   
                            } catch (Exception e) {}
                            
                            if (coaInv.getOidMaster() == 0) {
                                coaLocationTrue = false;                            
                            }                                                    
                            csd.setAccInv(coaInv.getOidMaster());  
                            //============== END ===========================
                        
                            // =========== OID COGS==============
                            MasterOid coaCogs = new MasterOid();
                            try {
                                coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                            } catch (Exception e) {}
                            
                            if (coaCogs.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }
                            csd.setAccCogs(coaCogs.getOidMaster());  
                            //============== END ===========================
                        }
                    
                        hAccSalesDetail.put(""+sdCk.getOID(), csd); // di save di hashtable untuk memudahkan pengambilan berikutnya
                    }

                    if (coaLocationTrue) { // jika kondisi setup coa untuk sales tidak kosong

                        Customer cust = new Customer();
                        if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            try {
                                cust = DbCustomer.fetchExc(sales.getCustomerId());
                            } catch (Exception ex) {}
                        }

                        //jurnal main
                        String memo = "";
                        if (sales.getType() == DbSales.TYPE_RETUR_CASH) {
                            memo = "Retur Cash sales, " + location.getName();
                        } else {
                            memo = "Retur Credit sales, " + location.getName() +
                                    " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());
                        }

                        //cek nomor, jika sama cari nomor lain
                        int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                        String number = sales.getNumber();
                        if (count > 0) {
                            number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                        }

                        //post jurnal
                        long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                I_Project.JOURNAL_TYPE_RETUR,
                                memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                        //jika sukses input gl
                        if (oid != 0) {
                            //jurnal debet
                            double amount = 0;
                            for (int x = 0; x < dtls.size(); x++) {

                                SalesDetail sd = (SalesDetail) dtls.get(x);
                                
                                CoaSalesDetail csd = new CoaSalesDetail();                            
                                try{
                                    csd = (CoaSalesDetail)hAccSalesDetail.get(""+sd.getOID());
                                }catch(Exception e){}  
                                
                                if (comp.getUseBkp() == DbCompany.USE_BKP && csd.getIsBkp() == DbItemMaster.BKP) {

                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();
                                    double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                    double amountPpn = amountTransaction - price;

                                    memo = "Retur sales item " + csd.getItemName();

                                    if(price != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, price,
                                            price, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }                            

                                    memo = "ppn " + csd.getItemName();
                                    if(amountPpn != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountPpn,
                                            amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }        
                                    amount = amount + (price + amountPpn);

                                } else {

                                    memo = "Retur sales item " + csd.getItemName();
                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();
                                    if(amountTransaction != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }        
                                    amount = amount + amountTransaction;
                                }
                                     
                                 if (sd.getCogs() > 0 && csd.getService() == 0){                                       
                                    
                                        //jurnal inventory
                                        memo = "inventory : " + csd.getItemName();
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccInv(), 0 , sd.getCogs() * sd.getQty(),
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        //journal hpp
                                        memo = "hpp : " + csd.getItemName();
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccCogs(), sd.getCogs() * sd.getQty(), 0,
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }      
                            }

                            Coa coa = new Coa();
                            Coa coaExpense = new Coa();
                            double amountExpense = 0;

                            if (sales.getType() == DbSales.TYPE_RETUR_CASH){

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD){

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}

                                        } else {
                                            
                                            if(merchantAktif){

                                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                    memo = "Piutang Credit Card";
                                                } else {
                                                    memo = "Piutang Debit Card";
                                                }

                                                try {
                                                    try {
                                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                    } catch (Exception e) {}
                                                    
                                                    try {
                                                        coa = DbCoa.fetchExc(merchant.getCoaId());
                                                    } catch (Exception e) {}
                                                    
                                                    try {
                                                        coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                    } catch (Exception e) {}

                                                    if (merchant.getPersenExpense() > 0) {
                                                        amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                    }

                                                } catch (Exception e) {}
                                            }else{                                                
                                                memo = "Cash";
                                                try {
                                                    coa = DbCoa.fetchExc(curr.getCoaId());
                                                } catch (Exception e) {}
                                            }
                                        }

                                    }else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER) {
                                        memo = "Transfer Bank";
                                        Bank bank = new Bank();
                                        try{
                                            bank = DbBank.fetchExc(payment.getBankId());
                                        }catch(Exception e){}
                                        
                                        try{
                                            coa = DbCoa.fetchExc(bank.getCoaARId());
                                        }catch(Exception e){}
                                        
                                    }
                                } else {
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {}
                                }

                            } else {
                                try {
                                    coa = DbCoa.fetchExc(location.getCoaArId());
                                } catch (Exception e) {
                                }
                                memo = "Credit Sales";
                            }

                            double amountPiutang = 0;

                            if (amountExpense > 0) {
                                String memoPiutang = "";
                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                    memo = "Biaya Komisi Credit Card";
                                    memoPiutang = "Credit Card";
                                } else {
                                    memo = "Biaya Komisi Debit Card";
                                    memoPiutang = "Debit Card";
                                }
                                DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                double piutangCC = amount - amountExpense;
                                amountPiutang = piutangCC;
                                if(piutangCC != 0){
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                        piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }        
                            } else {
                                                 
                                amountPiutang = amount;
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }

                            Date dt = new Date();

                            String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                    DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                    DbPeriode.colNames[DbPeriode.COL_END_DATE];

                            Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                            Date effectiveDate = new Date();

                            if (tempEff != null && tempEff.size() > 0) {
                                effectiveDate = new Date();
                            } else {
                                Periode per = new Periode();
                                if (periodId != 0) {
                                    try {
                                        per = DbPeriode.fetchExc(periodId);
                                    } catch (Exception e) {
                                        per = DbPeriode.getOpenPeriod();
                                    }
                                }
                                effectiveDate = per.getEndDate();
                            }

                            updateStatus(sales.getOID(), userId, effectiveDate);

                            if (sales.getType() == DbSales.TYPE_RETUR_CREDIT){                                
                                try{
                                    String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+sales.getOID();
                                    Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                                    if(vCP != null && vCP.size() > 0){
                                        CreditPayment cp = (CreditPayment)vCP.get(0);      
                                        DbCreditPayment.updateStatusPayCredit(cp.getOID(), userId); 
                                    }
                                }catch(Exception e){}
                                postPaymentReceivable(sales, er, amountPiutang);
                            }
                        }
                    }                
                }else{ //kalau kasirnya tidak menginputkan no transaksi yang di retur
                         
                        if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                            try {
                                Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                                if (vPayment != null && vPayment.size() > 0) {
                                    payment = (Payment) vPayment.get(0);
                                }
                            } catch (Exception e) {}

                            if (payment.getCurrency_id() == 0) {
                                try {
                                    long currIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                    curr = DbCurrency.fetchExc(currIDR);
                                } catch (Exception e) {}

                            } else {
                                try {
                                    curr = DbCurrency.fetchExc(payment.getCurrency_id());
                                } catch (Exception e) {}
                            }

                            try {
                                Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                                if (coaCurr.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }

                            if (comp.getMultiBank() == DbCompany.MULTI_BANK && merchantAktif){ // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                    if (payment.getMerchantId() == 0) {
                                        coaLocationTrue = false;
                                    } else {
                                        try {
                                            merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                            Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                            if (coaM.getOID() == 0) {
                                                coaLocationTrue = false;
                                            }
                                        } catch (Exception E) {
                                            coaLocationTrue = false;
                                        }
                                    }
                                }
                            }
                        }

                        try {
                            if (sales.getLocation_id() != 0) {
                                location = DbLocation.fetchExc(sales.getLocation_id());
                                Coa co = new Coa();
                                if (location.getCoaSalesId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co = DbCoa.fetchExc(location.getCoaSalesId());
                                        if (co.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }

                                Coa co2 = new Coa();
                                if (location.getCoaProjectPPHPasal22Id() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co2 = DbCoa.fetchExc(location.getCoaProjectPPHPasal22Id());
                                        if (co2.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }

                                Coa co3 = new Coa();
                                if (location.getCoaProjectPPHPasal23Id() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co3 = DbCoa.fetchExc(location.getCoaProjectPPHPasal23Id());
                                        if (co3.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }
                            } else {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {}                        
                        
                        Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");
                        for (int ix = 0; ix < dtls.size(); ix++) {

                            SalesDetail sdCk = (SalesDetail) dtls.get(ix);                            
                            MasterGroup mg = new MasterGroup();
                            try {                        
                                mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                                                
                            } catch (Exception e) {}                            

                            MasterOid coaSalesCredit = new MasterOid();
                            try {
                                coaSalesCredit = DbItemMaster.getOidByCode(mg.getAccCreditIncome().trim());                        
                            } catch (Exception e) {}
                        
                            if (coaSalesCredit.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }

                            if (sdCk.getCogs() > 0 && mg.getService() == 0){                        
                            
                                    MasterOid coaInv = new MasterOid();
                                    try {
                                        coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());   
                                    } catch (Exception e) {}
                            
                                    if (coaInv.getOidMaster() == 0) {
                                        coaLocationTrue = false;                            
                                    }                        
                            
                                    MasterOid coaCogs = new MasterOid();
                                    try {
                                        coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                                    } catch (Exception e) {}
                            
                                    if (coaCogs.getOidMaster() == 0) {
                                        coaLocationTrue = false;
                                    }
                            }

                            MasterOid coaSl = new MasterOid();
                            try {
                                coaSl = DbItemMaster.getOidByCode(mg.getAccSalesCash().trim());                        
                            } catch (Exception e) {}

                            if (coaSl.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }
                            
                            MasterOid coaSales = new MasterOid();
                            try {
                                coaSales = DbItemMaster.getOidByCode(mg.getAccCreditIncome().trim());                        
                            } catch (Exception e) {}

                            if (coaSales.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }
                        }

                         if (coaLocationTrue){ // jika kondisi setup coa untuk sales tidak kosong
                       
                            String memo = "Retur Cash sales, " + location.getName();

                            //cek nomor, jika sama cari nomor lain
                            int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                            String number = sales.getNumber();
                            if (count > 0) {
                                number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                            }

                            //post jurnal
                            long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                    I_Project.JOURNAL_TYPE_RETUR,
                                    memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                            //jika sukses input gl
                            if (oid != 0) {
                                //jurnal debet
                                double amount = 0;
                                
                                for (int x = 0; x < dtls.size(); x++) {

                                    SalesDetail sd = (SalesDetail) dtls.get(x);

                                    MasterGroup mg = new MasterGroup();
                                    try {                        
                                        mg = DbItemMaster.getItemGroup(sd.getProductMasterId());                                                
                                    } catch (Exception e) {}
                                
                                    MasterOid coaSales = new MasterOid();
                                    try {
                                        coaSales = DbItemMaster.getOidByCode(mg.getAccSalesCash().trim());                        
                                    } catch (Exception e) {}

                                    if (comp.getUseBkp() == DbCompany.USE_BKP && mg.getIsBkp() == DbItemMaster.BKP){

                                        double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();
                                        double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                        double amountPpn = amountTransaction - price;

                                        memo = "Retur sales item " + mg.getName();
                                        if(price != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOidMaster(), 0, price,
                                                price, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }    
                                        
                                        Coa coaPpn = new Coa();
                                        try {
                                            coaPpn = DbCoa.getCoaByCode(mg.getAccVat().trim());
                                        } catch (Exception e) {}

                                        memo = "ppn " + mg.getName();
                                        if(amountPpn !=0 ){
                                            DbGl.postJournalDetail(er.getValueIdr(), coaPpn.getOID(), 0, amountPpn,
                                                amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }    
                                        amount = amount + (price + amountPpn);

                                    } else {

                                        memo = "Retur sales item " + mg.getName();
                                        double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();
                                        if(amountTransaction != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOidMaster(), 0, amountTransaction,
                                                amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }    
                                        amount = amount + amountTransaction;
                                    }
                                
                                     
                                    if (sd.getCogs() > 0 && mg.getService() == 0){
                                        MasterOid coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());
                                        MasterOid coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                                    
                                        //jurnal inventory
                                        memo = "inventory : " + mg.getName();
                                        DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOidMaster(), 0, sd.getCogs() * sd.getQty(),
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        //journal hpp
                                        memo = "hpp : " + mg.getName();
                                        DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOidMaster(), sd.getCogs() * sd.getQty(), 0,
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }               
                                }

                                Coa coa = new Coa();
                                Coa coaExpense = new Coa();
                                double amountExpense = 0;

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}

                                        } else {

                                            if(merchantAktif){
                                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                    memo = "Piutang Credit Card";
                                                } else {
                                                    memo = "Piutang Debit Card";
                                                }

                                                try {
                                                    try {
                                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                    } catch (Exception e) {}
                                                
                                                    try {
                                                        coa = DbCoa.fetchExc(merchant.getCoaId());
                                                    } catch (Exception e) {}
                                                    
                                                    try {
                                                        coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                    } catch (Exception e) {}

                                                    if (merchant.getPersenExpense() > 0) {
                                                        amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                    }

                                                } catch (Exception e) {}
                                            }else{
                                                memo = "Cash";
                                                try {
                                                    coa = DbCoa.fetchExc(curr.getCoaId());
                                                } catch (Exception e) {}
                                            }
                                        }
                                    }else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER) {
                                        memo = "Transfer Bank";
                                        Bank bank = new Bank();
                                        try{
                                            bank = DbBank.fetchExc(payment.getBankId());
                                        }catch(Exception e){}
                                        
                                        try{
                                            coa = DbCoa.fetchExc(bank.getCoaARId());
                                        }catch(Exception e){}
                                        
                                    }
                                    
                                    
                                } else {
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {}
                                }

                                double amountPiutang = 0;
                                if (amountExpense > 0) {
                                    String memoPiutang = "";
                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD){
                                        memo = "Biaya Komisi Credit Card";
                                        memoPiutang = "Credit Card";
                                    } else {
                                        memo = "Biaya Komisi Debit Card";
                                        memoPiutang = "Debit Card";
                                    }
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                    double piutangCC = amount - amountExpense;                                
                                    amountPiutang = piutangCC;
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                        piutangCC, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                } else {               
                                    
                                    amountPiutang = amount;
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }

                                Date dt = new Date();

                                String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                    DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                    DbPeriode.colNames[DbPeriode.COL_END_DATE];

                                Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                                Date effectiveDate = new Date();

                                if (tempEff != null && tempEff.size() > 0) {
                                    effectiveDate = new Date();
                                } else {
                                    Periode per = new Periode();
                                    if (periodId != 0) {
                                        try {
                                            per = DbPeriode.fetchExc(periodId);
                                        } catch (Exception e) {
                                            per = DbPeriode.getOpenPeriod();
                                        }
                                    }
                                    effectiveDate = per.getEndDate();
                                }

                                updateStatus(sales.getOID(), userId, effectiveDate);
                                
                                if(sales.getType() == DbSales.TYPE_RETUR_CREDIT){
                                    
                                    try{
                                        String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+sales.getOID();
                                        Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                                        if(vCP != null && vCP.size() > 0){
                                            CreditPayment cp = (CreditPayment)vCP.get(0);      
                                            DbCreditPayment.updateStatusPayCredit(cp.getOID(), userId); 
                                        }
                                    }catch(Exception e){}
                                    
                                    if(amountPiutang != 0){
                                        amountPiutang = amountPiutang * -1;
                                    }
                                    ARInvoice ar = new ARInvoice();
                                    
                                    ar.setSalesSource(1);
                                    ar.setDate(sales.getDate());
                                    ar.setProjectId(sales.getOID());
                                    ar.setDueDate(sales.getDate());
                                    ar.setTransDate(sales.getDate());                                    
                                    ar.setCompanyId(sales.getCompanyId());
                                    ar.setOperatorId(sales.getUserId());
                                    ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
                                    ar.setCurrencyId(sales.getCurrencyId());
                                    ar.setCustomerId(sales.getCustomerId());
                                    ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
                                    ar.setDiscount(0);
                                    ar.setDiscountPercent(0);
                                    ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
                                    ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
                                    ar.setProjectTermId(sales.getOID());
                                    ar.setTotal(amountPiutang);
                                    ar.setVat(0);
                                    ar.setVatAmount(0);
                                    ar.setVatPercent(0);
                                    ar.setInvoiceNumber(sales.getNumber());
                                    ar.setTypeAR(DbARInvoice.TYPE_RETUR);                                    
                                    ar.setPostedStatus(1);
                                    ar.setPostedDate(new Date());
                                    ar.setCreateDate(new Date());
                                    ar.setLocationId(sales.getLocation_id());                                    
                                    try{                                        
                                        long oidx = DbARInvoice.insertExc(ar);                                        
                                        if (oidx != 0) {

                                            ARInvoiceDetail ard = new ARInvoiceDetail();
                                            ard.setArInvoiceId(oidx);
                                            ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                                            ard.setQty(1);
                                            ard.setPrice(amountPiutang);
                                            ard.setDiscount(0);
                                            ard.setTotalAmount(amountPiutang);
                                            ard.setCompanyId(sales.getCompanyId());

                                            try {
                                            DbARInvoiceDetail.insertExc(ard);
                                            } catch (Exception e) {}
                                        }                                        
                                    }catch(Exception e){}
                                }
                            }
                        }                          
                }
            }
        }
    }
    
    public static void postJournalRetur(Vector temp, long userId, long periodIdx,Company comp){
        
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;
        long deffCurrIDR = 0;
        try {
            deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));            
        } catch (Exception e) {}
        
        Periode p = new Periode();
        if(periodIdx != 0){
            try{
                p = DbPeriode.fetchExc(periodIdx);
            }catch(Exception e){}
        }        
        
        if (v != null && v.size() > 0){

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                long segment1_id = 0;                

                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();
                long periodId = periodIdx;
                Periode periode = new Periode();               
                
                //Parameter Multy Bank                
                Hashtable hAccSalesDetail = new Hashtable();               
                
                if(periodId == 0){    
                    try {
                        periode = DbPeriode.getPeriodByTransDate(sales.getDate());
                        periodId = periode.getOID();
                    } catch (Exception e) {}                    
                }else{
                    periode = p;
                }
                
                if (periode.getStatus().compareTo("Closed") == 0) {
                    coaLocationTrue = false;
                }                

                if (sales.getSalesReturId() != 0) { 

                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {}

                        if (payment.getCurrency_id() == 0) {
                            try {
                                long currIDR = deffCurrIDR;
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {}
                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                            } catch (Exception e) {}
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());                           
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }

                        if (comp.getMultiBank() == DbCompany.MULTI_BANK) { // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }
                    }

                    try {
                        if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            Sales slRet = new Sales();
                            try {
                                slRet = DbSales.fetchExc(sales.getSalesReturId());
                            } catch (Exception e) {
                            }
                            if (slRet.getStatus() == 0) {
                                coaLocationTrue = false;
                            }
                        }
                    } catch (Exception e) {
                        coaLocationTrue = false;
                    }

                    try {
                        if (sales.getLocation_id() != 0) {
                            location = DbLocation.fetchExc(sales.getLocation_id());
                            Coa co = new Coa();
                            if (location.getCoaSalesId() == 0) {
                                coaLocationTrue = false;
                            } else {
                                try {
                                    co = DbCoa.fetchExc(location.getCoaSalesId());
                                    if (co.getOID() == 0) {
                                        coaLocationTrue = false;
                                    }
                                } catch (Exception e) {
                                    coaLocationTrue = false;
                                }
                            }
                           
                        } else {
                            coaLocationTrue = false;
                        }
                    } catch (Exception e) {
                    }

                    Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");
                    
                    for (int ix = 0; ix < dtls.size(); ix++) {

                        SalesDetail sdCk = (SalesDetail) dtls.get(ix);
                        CoaSalesDetail csd = new CoaSalesDetail();
                        csd.setSalesDetailId(sdCk.getOID());
                        csd.setProductMasterId(sdCk.getProductMasterId()); 
                        
                        MasterGroup mg = new MasterGroup();
                        try {                        
                            mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                                                
                        } catch (Exception e) {}
                    
                        csd.setItemName(mg.getName());
                        csd.setIsBkp(mg.getIsBkp());     
                        csd.setNeedBom(mg.getNeedBom());
                    
                        // =========== OID PENJUALAN CASH==============
                        MasterOid coaSales = new MasterOid();
                        try {
                            coaSales = DbItemMaster.getOidByCode(mg.getAccSales().trim());                        
                        } catch (Exception e) {}

                        if (coaSales.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }                    
                        csd.setAccSales(coaSales.getOidMaster());                    
                        //============== END ===========================
                        
                        //==========Pendapatan Service=================
                        if(sales.getServicePercent() != 0){
                        
                            MasterOid coaService = new MasterOid();
                            try {
                                coaService = DbItemMaster.getOidByCode(mg.getAccOtherIncome().trim());                        
                            } catch (Exception e) {}

                            if (coaService.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }       
                            csd.setAccOtherIncome(coaService.getOidMaster());
                        }
                        //============== END ====================  
                    
                        
                        // =========== OID PPN ==============
                        MasterOid coaPpn = new MasterOid();
                        try {
                            coaPpn = DbItemMaster.getOidByCode(mg.getAccVat().trim());
                        } catch (Exception e) {}
                        
                        if (coaPpn.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }                    
                        csd.setAccPpn(coaPpn.getOidMaster());                    
                        //============== END ===========================
                        
                        csd.setService(mg.getService());
                        
                        if(mg.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                            Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sdCk.getOID(), null);
                        
                            if(vStock != null && vStock.size() > 0){
                                for(int d = 0; d < vStock.size() ; d++){                            
                                
                                    Stock stock = (Stock)vStock.get(d);
                                    MasterGroup mgx = new MasterGroup();
                                    try {                        
                                        mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                    } catch (Exception e) {}
                                
                                    // =========== OID INVENTORY==============
                                    MasterOid coaInv = new MasterOid();
                                    try {
                                        coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                    } catch (Exception e) {}
                            
                                    if (coaInv.getOidMaster() == 0) {
                                        coaLocationTrue = false;                            
                                    }     
                                
                                    // =========== OID COGS==============
                                    MasterOid coaCogs = new MasterOid();
                                    try {
                                        coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                    } catch (Exception e) {}
                            
                                    if (coaCogs.getOidMaster() == 0) {
                                        coaLocationTrue = false;
                                    }                                
                                    //============== END ===========================
                                }
                            }
                        
                        }else{
                             if (sdCk.getCogs() > 0 && mg.getService() == 0){  // Jika bukan service && cogs tidak sama dengan 0                      
                            
                                // =========== OID INVENTORY==============
                                MasterOid coaInv = new MasterOid();
                                try {
                                    coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());   
                                } catch (Exception e) {}
                            
                                if (coaInv.getOidMaster() == 0) {
                                    coaLocationTrue = false;                            
                                }                                                    
                                csd.setAccInv(coaInv.getOidMaster());  
                                //============== END ===========================
                        
                                // =========== OID COGS==============
                                MasterOid coaCogs = new MasterOid();
                                try {
                                    coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                                } catch (Exception e) {}
                            
                                if (coaCogs.getOidMaster() == 0) {
                                    coaLocationTrue = false;
                                }
                                csd.setAccCogs(coaCogs.getOidMaster());  
                                //============== END ===========================
                            }
                        }
                    
                        hAccSalesDetail.put(""+sdCk.getOID(), csd); // di save di hashtable untuk memudahkan pengambilan berikutnya                        
                    }

                    if (coaLocationTrue) { // jika kondisi setup coa untuk sales tidak kosong

                        Customer cust = new Customer();
                        if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            try {
                                cust = DbCustomer.fetchExc(sales.getCustomerId());
                            } catch (Exception ex) {}
                        }

                        //jurnal main
                        String memo = "";
                        if (sales.getType() == DbSales.TYPE_RETUR_CASH) {
                            memo = "Retur Cash sales, " + location.getName();
                        } else {
                            memo = "Retur Credit sales, " + location.getName() +
                                    " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());
                        }

                        //cek nomor, jika sama cari nomor lain
                        int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                        String number = sales.getNumber();
                        if (count > 0) {
                            number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                        }

                        //post jurnal
                        long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                I_Project.JOURNAL_TYPE_RETUR,
                                memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                        //jika sukses input gl
                        if (oid != 0) {
                            //jurnal debet
                            double amount = 0;
                            double amountTotal = 0;
                            double dicGlobal = 0;
                        
                            for (int x = 0; x < dtls.size(); x++) {
                                SalesDetail sd = (SalesDetail) dtls.get(x);                            
                                amountTotal =  amountTotal + ((sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount());                              
                            }    
                        
                            dicGlobal = (sales.getGlobalDiskon() * 100)/amountTotal;
                            int isFeePaidByComp = SessCreditPayment.isFeeByCompany(sales.getOID());  
                        
                            for (int x = 0; x < dtls.size(); x++) {

                                SalesDetail sd = (SalesDetail) dtls.get(x);
                                
                                CoaSalesDetail csd = new CoaSalesDetail();                            
                                try{
                                    csd = (CoaSalesDetail)hAccSalesDetail.get(""+sd.getOID());
                                }catch(Exception e){} 
                                
                                double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();                              
                            
                                //pemrosesan diskon global
                                double diskonGlobal = 0;
                            
                                if(sales.getGlobalDiskon() != 0){
                                    diskonGlobal = amountTransaction * (dicGlobal/100);
                                    amountTransaction = amountTransaction - diskonGlobal;
                                }
                            
                                double amountService = 0;
                                if(sales.getServicePercent() != 0){
                                    amountService = amountTransaction * (sales.getServicePercent()/100);                                  
                                }                     
                                
                                
                                if(sales.getVatPercent() != 0 || sales.getServicePercent() != 0){
                                
                                    double amountVat = 0;
                                    if(sales.getVatPercent() != 0){
                                        amountVat = (amountTransaction + amountService) * (sales.getVatPercent()/100);
                                    }
                                
                                    memo = "sales item " + csd.getItemName();                                                               
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                        amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);                                    
                                
                                    memo = "ppn " + csd.getItemName();                                
                                    if(amountVat != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountVat,
                                            amountVat, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }        
                                
                                    memo = "Pendapatan Service "+csd.getItemName();                                
                                    if(amountService != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccOtherIncome(), 0, amountService,
                                            amountService, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                
                                    amount = amount + (amountTransaction + amountVat + amountService);
                            
                                }else{
                                    
                                     if (comp.getUseBkp() == DbCompany.USE_BKP && csd.getIsBkp() == DbItemMaster.BKP) {
                                        
                                        double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                        double amountPpn = amountTransaction - price;

                                        memo = "Retur sales item " + csd.getItemName();

                                        if(price != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, price,
                                                price, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }                            

                                        memo = "ppn " + csd.getItemName();
                                        if(amountPpn != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountPpn,
                                                amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }        
                                        amount = amount + (price + amountPpn);

                                    } else {

                                        memo = "Retur sales item " + csd.getItemName();                                        
                                        if(amountTransaction != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                                amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }        
                                        amount = amount + amountTransaction;
                                    }
                                }
                                 
                                
                                if(csd.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                                    Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sd.getOID(), null);
                        
                                    if(vStock != null && vStock.size() > 0){
                                    
                                        for(int d = 0; d < vStock.size() ; d++){                            
                                
                                            Stock stock = (Stock)vStock.get(d);
                                            double hpp = stock.getQty() * stock.getPrice();
                                        
                                            if(hpp != 0){
                                            
                                                String itemName = "";                                            
                                                try{
                                                    itemName = getItemName(stock.getItemMasterId());
                                                }catch(Exception e){}
                                        
                                                MasterGroup mgx = new MasterGroup();
                                                try {                        
                                                    mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                                } catch (Exception e) {}
                                
                                                // =========== OID INVENTORY==============
                                                MasterOid coaInv = new MasterOid();
                                                try {
                                                    coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                                } catch (Exception e) {}
                                
                                                // =========== OID COGS==============
                                                MasterOid coaCogs = new MasterOid();
                                                try {
                                                    coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                                } catch (Exception e) {}
                                            
                                                memo = "inventory : " + itemName;
                                                DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOidMaster(), 0, hpp,
                                                    hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                                //journal hpp
                                            
                                                memo = "hpp : " + itemName;
                                                DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOidMaster(), hpp, 0,
                                                    hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                                //============== END ===========================
                                            }
                                        }
                                    }                        
                                }else{
                                    
                                    if (sd.getCogs() > 0 && csd.getService() == 0){                                       
                                    
                                        //jurnal inventory
                                        memo = "inventory : " + csd.getItemName();
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccInv(), 0 , sd.getCogs() * sd.getQty(),
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        //journal hpp
                                        memo = "hpp : " + csd.getItemName();
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccCogs(), sd.getCogs() * sd.getQty(), 0,
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }     
                                } 
                            }

                            Coa coa = new Coa();
                            Coa coaExpense = new Coa();
                            Coa coaPendapatan = new Coa();
                            double amountExpense = 0;

                            if (sales.getType() == DbSales.TYPE_RETUR_CASH){

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD){

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}

                                        } else {

                                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                memo = "Piutang Credit Card";
                                            } else {
                                                memo = "Piutang Debit Card";
                                            }

                                            try {
                                                try {
                                                    merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                } catch (Exception e) {}
                                                    
                                                try {
                                                    coa = DbCoa.fetchExc(merchant.getCoaId());
                                                } catch (Exception e) {}
                                                    
                                                try {
                                                    coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                } catch (Exception e) {}

                                                if (merchant.getPersenExpense() > 0) {
                                                    amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                }

                                            } catch (Exception e) {}
                                           
                                        }

                                    }else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER) {
                                        memo = "Transfer Bank";
                                        Bank bank = new Bank();
                                        try{
                                            bank = DbBank.fetchExc(payment.getBankId());
                                        }catch(Exception e){}
                                        
                                        try{
                                            coa = DbCoa.fetchExc(bank.getCoaARId());
                                        }catch(Exception e){}
                                        
                                    }
                                } else {                                    
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {}
                                }

                            } else {
                                try {
                                    coa = DbCoa.fetchExc(location.getCoaArId());
                                } catch (Exception e) {
                                }
                                memo = "Credit Sales";
                            }

                            double amountPiutang = 0;

                            if (amountExpense > 0) {
                                String memoPiutang = "";
                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                    memo = "Biaya Komisi Credit Card";
                                    memoPiutang = "Credit Card";
                                } else {
                                    memo = "Biaya Komisi Debit Card";
                                    memoPiutang = "Debit Card";
                                }
                                
                                if(isFeePaidByComp != 0){ // jika biaya kartu di bayar pembeli
                                
                                    if (amountExpense != 0) {
                                        DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                            amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    
                                        try {
                                            coaPendapatan = DbCoa.fetchExc(merchant.getPendapatanMerchant());
                                        } catch (Exception e) {}                                    
                                    
                                        DbGl.postJournalDetail(er.getValueIdr(), coaPendapatan.getOID(), amountExpense, 0,
                                            amountExpense, comp.getBookingCurrencyId(), oid, "Pendapatan Merchant", 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);                                    
                                    }
                                
                                    double piutangCC = amount;
                                    amountPiutang = piutangCC;
                                
                                    if(piutangCC != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                
                                }else{
                                    
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                    double piutangCC = amount - amountExpense;
                                    amountPiutang = piutangCC;
                                    if(piutangCC != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }  
                                }
                                
                            } else {
                                                 
                                amountPiutang = amount;
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }

                            Date dt = new Date();

                            String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                    DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                    DbPeriode.colNames[DbPeriode.COL_END_DATE];

                            Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                            Date effectiveDate = new Date();

                            if (tempEff != null && tempEff.size() > 0) {
                                effectiveDate = new Date();
                            } else {
                                Periode per = new Periode();
                                if (periodId != 0) {
                                    try {
                                        per = DbPeriode.fetchExc(periodId);
                                    } catch (Exception e) {
                                        per = DbPeriode.getOpenPeriod();
                                    }
                                }
                                effectiveDate = per.getEndDate();
                            }

                            updateStatus(sales.getOID(), userId, effectiveDate);

                            if (sales.getType() == DbSales.TYPE_RETUR_CREDIT){                                
                                try{
                                    String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+sales.getOID();
                                    Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                                    if(vCP != null && vCP.size() > 0){
                                        CreditPayment cp = (CreditPayment)vCP.get(0);      
                                        DbCreditPayment.updateStatusPayCredit(cp.getOID(), userId); 
                                    }
                                }catch(Exception e){}
                                postPaymentReceivable(sales, er, amountPiutang);
                            }                            
                            DbGl.optimizedJournal(oid);
                        }
                    }                
                }else{ //kalau kasirnya tidak menginputkan no transaksi yang di retur
                         
                        if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                            try {
                                Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                                if (vPayment != null && vPayment.size() > 0) {
                                    payment = (Payment) vPayment.get(0);
                                }
                            } catch (Exception e) {}

                            if (payment.getCurrency_id() == 0) {
                                try {
                                    long currIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                    curr = DbCurrency.fetchExc(currIDR);
                                } catch (Exception e) {}

                            } else {
                                try {
                                    curr = DbCurrency.fetchExc(payment.getCurrency_id());
                                } catch (Exception e) {}
                            }

                            try {
                                Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                                if (coaCurr.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }

                            if (comp.getMultiBank() == DbCompany.MULTI_BANK){ // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                    if (payment.getMerchantId() == 0) {
                                        coaLocationTrue = false;
                                    } else {
                                        try {
                                            merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                            Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                            if (coaM.getOID() == 0) {
                                                coaLocationTrue = false;
                                            }
                                        } catch (Exception E) {
                                            coaLocationTrue = false;
                                        }
                                    }
                                }
                            }
                        }

                        try {
                            if (sales.getLocation_id() != 0) {
                                location = DbLocation.fetchExc(sales.getLocation_id());
                                Coa co = new Coa();
                                if (location.getCoaSalesId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co = DbCoa.fetchExc(location.getCoaSalesId());
                                        if (co.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }

                                Coa co2 = new Coa();
                                if (location.getCoaProjectPPHPasal22Id() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co2 = DbCoa.fetchExc(location.getCoaProjectPPHPasal22Id());
                                        if (co2.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }

                                Coa co3 = new Coa();
                                if (location.getCoaProjectPPHPasal23Id() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co3 = DbCoa.fetchExc(location.getCoaProjectPPHPasal23Id());
                                        if (co3.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }
                            } else {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {}                        
                        
                        Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");
                        
                        for (int ix = 0; ix < dtls.size(); ix++) {

                            SalesDetail sdCk = (SalesDetail) dtls.get(ix); 
                            
                            CoaSalesDetail csd = new CoaSalesDetail();                    
                            csd.setSalesDetailId(sdCk.getOID());
                            csd.setProductMasterId(sdCk.getProductMasterId()); 
                            
                            MasterGroup mg = new MasterGroup();
                            try {                        
                                mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                                                
                            } catch (Exception e) {}  
                            
                            csd.setItemName(mg.getName());
                            csd.setIsBkp(mg.getIsBkp());                    
                            csd.setNeedBom(mg.getNeedBom());     
                            
                            // =========== OID PENJUALAN CASH==============
                            MasterOid coaSales = new MasterOid();
                            try {
                                coaSales = DbItemMaster.getOidByCode(mg.getAccSales().trim());                        
                            } catch (Exception e) {}

                            if (coaSales.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }                    
                            csd.setAccSales(coaSales.getOidMaster());     
                            
                            //==========Pendapatan Service=================
                            if(sales.getServicePercent() != 0){
                        
                                MasterOid coaService = new MasterOid();
                                try {
                                    coaService = DbItemMaster.getOidByCode(mg.getAccOtherIncome().trim());                        
                                } catch (Exception e) {}

                                if (coaService.getOidMaster() == 0) {
                                    coaLocationTrue = false;
                                }       
                                csd.setAccOtherIncome(coaService.getOidMaster());
                            }
                            //============== END ====================    
                            
                            // =========== OID PPN ==============
                            MasterOid coaPpn = new MasterOid();
                            try {
                                coaPpn = DbItemMaster.getOidByCode(mg.getAccVat().trim());
                            } catch (Exception e) {}
                        
                            if (coaPpn.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }                    
                            csd.setAccPpn(coaPpn.getOidMaster());                    
                            //============== END ===========================
                            
                            csd.setService(mg.getService());
                            
                            if(mg.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                                Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sdCk.getOID(), null);
                        
                                if(vStock != null && vStock.size() > 0){
                                    for(int d = 0; d < vStock.size() ; d++){                            
                                
                                        Stock stock = (Stock)vStock.get(d);
                                        MasterGroup mgx = new MasterGroup();
                                        try {                        
                                            mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                        } catch (Exception e) {}
                                
                                        // =========== OID INVENTORY==============
                                        MasterOid coaInv = new MasterOid();
                                        try {
                                            coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                        } catch (Exception e) {}
                            
                                        if (coaInv.getOidMaster() == 0) {
                                            coaLocationTrue = false;                            
                                        }     
                                
                                        // =========== OID COGS==============
                                        MasterOid coaCogs = new MasterOid();
                                        try {
                                            coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                        } catch (Exception e) {}
                            
                                        if (coaCogs.getOidMaster() == 0) {
                                            coaLocationTrue = false;
                                        }                                
                                        //============== END ===========================
                                    }
                                }
                        
                            }else{
                                
                                if (sdCk.getCogs() > 0 && mg.getService() == 0){                        
                            
                                    MasterOid coaInv = new MasterOid();
                                    try {
                                        coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());   
                                    } catch (Exception e) {}
                            
                                    csd.setAccInv(coaInv.getOidMaster());
                                    if (coaInv.getOidMaster() == 0) {
                                        coaLocationTrue = false;                            
                                    }                        
                            
                                    MasterOid coaCogs = new MasterOid();
                                    try {
                                        coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                                    } catch (Exception e) {}
                            
                                    if (coaCogs.getOidMaster() == 0) {
                                        coaLocationTrue = false;
                                    }
                                    csd.setAccCogs(coaCogs.getOidMaster());
                                }
                            }
                            
                            hAccSalesDetail.put(""+sdCk.getOID(), csd); // di save di hashtable untuk memudahkan pengambilan berikutnya                                               
                        }

                         if (coaLocationTrue){ // jika kondisi setup coa untuk sales tidak kosong
                             
                            String memo = "Retur Cash sales, " + location.getName();

                            //cek nomor, jika sama cari nomor lain
                            int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                            String number = sales.getNumber();
                            if (count > 0) {
                                number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                            }

                            //post jurnal
                            long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                    I_Project.JOURNAL_TYPE_RETUR,
                                    memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                            //jika sukses input gl
                            if (oid != 0) {
                                //jurnal debet
                                double amount = 0;
                                double amountTotal = 0;
                                double dicGlobal = 0;
                        
                                for (int x = 0; x < dtls.size(); x++) {
                                    SalesDetail sd = (SalesDetail) dtls.get(x);                            
                                    amountTotal =  amountTotal + ((sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount());                              
                                }    
                        
                                dicGlobal = (sales.getGlobalDiskon() * 100)/amountTotal;
                                int isFeePaidByComp = SessCreditPayment.isFeeByCompany(sales.getOID());   
                                
                                for (int x = 0; x < dtls.size(); x++) {

                                    SalesDetail sd = (SalesDetail) dtls.get(x);
                                    
                                    CoaSalesDetail csd = new CoaSalesDetail();                            
                                    try{
                                        csd = (CoaSalesDetail)hAccSalesDetail.get(""+sd.getOID());
                                    }catch(Exception e){}                     

                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();                              
                            
                                    //pemrosesan diskon global
                                    double diskonGlobal = 0;
                            
                                    if(sales.getGlobalDiskon() != 0){
                                        diskonGlobal = amountTransaction * (dicGlobal/100);
                                        amountTransaction = amountTransaction - diskonGlobal;
                                    }
                            
                                    double amountService = 0;
                                    if(sales.getServicePercent() != 0){
                                        amountService = amountTransaction * (sales.getServicePercent()/100);                                  
                                    }       
                                    
                                    if(sales.getVatPercent() != 0 || sales.getServicePercent() != 0){
                                
                                        double amountVat = 0;
                                        if(sales.getVatPercent() != 0){
                                            amountVat = (amountTransaction + amountService) * (sales.getVatPercent()/100);
                                        }
                                
                                        memo = "sales item " + csd.getItemName();                                                               
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);                                    
                                
                                        memo = "ppn " + csd.getItemName();                                
                                        if(amountVat != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountVat,
                                            amountVat, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                        }        
                                
                                        memo = "Pendapatan Service "+csd.getItemName();                                
                                        if(amountService != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccOtherIncome(), 0, amountService,
                                            amountService, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                        }
                                
                                        amount = amount + (amountTransaction + amountVat + amountService);
                            
                                    }else{
                                        
                                        if (comp.getUseBkp() == DbCompany.USE_BKP && csd.getIsBkp() == DbItemMaster.BKP){

                                            
                                            double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                            double amountPpn = amountTransaction - price;

                                            memo = "Retur sales item " + csd.getItemName();
                                            if(price != 0){
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, price,
                                                    price, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }    

                                            memo = "ppn " + csd.getItemName();
                                            if(amountPpn !=0 ){
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountPpn,
                                                    amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }    
                                            amount = amount + (price + amountPpn);

                                        } else {

                                            memo = "Retur sales item " + csd.getItemName();                                        
                                            if(amountTransaction != 0){
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                                    amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }    
                                            amount = amount + amountTransaction;
                                        }
                                    }
                                    
                                    if(csd.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                                        Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sd.getOID(), null);
                        
                                            if(vStock != null && vStock.size() > 0){
                                    
                                                for(int d = 0; d < vStock.size() ; d++){                            
                                
                                                    Stock stock = (Stock)vStock.get(d);
                                                    double hpp = stock.getQty() * stock.getPrice();
                                        
                                                    if(hpp != 0){
                                            
                                                        String itemName = "";                                            
                                                        try{
                                                            itemName = getItemName(stock.getItemMasterId());
                                                        }catch(Exception e){}
                                        
                                                        MasterGroup mgx = new MasterGroup();
                                                        try {                        
                                                            mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                                        } catch (Exception e) {}
                                
                                                        // =========== OID INVENTORY==============
                                                        MasterOid coaInv = new MasterOid();
                                                        try {
                                                            coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                                        } catch (Exception e) {}
                                
                                                        // =========== OID COGS==============
                                                        MasterOid coaCogs = new MasterOid();
                                                        try {
                                                            coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                                        } catch (Exception e) {}
                                            
                                            
                                                        memo = "inventory : " + itemName;
                                                        DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOidMaster(), 0, hpp,
                                                        hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                        segment1_id, 0, 0, 0,
                                                            0, 0, 0, 0,
                                                            0, 0, 0, 0,
                                                            0, 0, 0, 0);
                                                        //journal hpp
                                            
                                                        memo = "hpp : " + itemName;
                                                        DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOidMaster(), hpp, 0,
                                                            hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                            segment1_id, 0, 0, 0,
                                                            0, 0, 0, 0,
                                                            0, 0, 0, 0,
                                                            0, 0, 0, 0);
                                                        //============== END ===========================
                                                    }
                                            }
                                        }                        
                                    }else{
                                        
                                        if (sd.getCogs() > 0 && csd.getService() == 0){
                                            double hpp = sd.getCogs() * sd.getQty();
                                
                                            if(hpp != 0){
                                    
                                                //jurnal inventory
                                                memo = "inventory : " + csd.getItemName();
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccInv(), 0, sd.getCogs() * sd.getQty(),
                                                    sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);

                                                //journal hpp
                                                memo = "hpp : " + csd.getItemName();
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccCogs(), sd.getCogs() * sd.getQty(), 0,
                                                    sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }
                                        }   
                                    }           
                                }

                                Coa coa = new Coa();
                                Coa coaExpense = new Coa();
                                Coa coaPendapatan = new Coa();
                                double amountExpense = 0; 

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}

                                        } else {
                                            
                                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                memo = "Piutang Credit Card";
                                            } else {
                                                memo = "Piutang Debit Card";
                                            }

                                            try {
                                                try {
                                                    merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                } catch (Exception e) {}
                                                
                                                try {
                                                    coa = DbCoa.fetchExc(merchant.getCoaId());
                                                } catch (Exception e) {}
                                                    
                                                try {
                                                    coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                } catch (Exception e) {}

                                                if (merchant.getPersenExpense() > 0) {
                                                    amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                }

                                            } catch (Exception e) {}
                                            
                                        }
                                    }else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER) {
                                        memo = "Transfer Bank";
                                        Bank bank = new Bank();
                                        try{
                                            bank = DbBank.fetchExc(payment.getBankId());
                                        }catch(Exception e){}
                                        
                                        try{
                                            coa = DbCoa.fetchExc(bank.getCoaARId());
                                        }catch(Exception e){}
                                    }
                                    
                                } else {
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {}
                                }

                                double amountPiutang = 0;
                                if (amountExpense > 0) {
                                    String memoPiutang = "";
                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD){
                                        memo = "Biaya Komisi Credit Card";
                                        memoPiutang = "Credit Card";
                                    } else {
                                        memo = "Biaya Komisi Debit Card";
                                        memoPiutang = "Debit Card";
                                    }
                                    
                                    if(isFeePaidByComp != 0){ // jika biaya kartu di bayar pembeli
                                        
                                        if (amountExpense != 0) {
                                            DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                                amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                    
                                            try {
                                                coaPendapatan = DbCoa.fetchExc(merchant.getPendapatanMerchant());
                                            } catch (Exception e) {}                                    
                                    
                                            DbGl.postJournalDetail(er.getValueIdr(), coaPendapatan.getOID(), amountExpense, 0,
                                                amountExpense, comp.getBookingCurrencyId(), oid, "Pendapatan Merchant", 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);                                    
                                        }
                                
                                        double piutangCC = amount;
                                        amountPiutang = piutangCC;
                                
                                        if(piutangCC != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                                piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }
                                        
                                    }else{
                                        
                                        DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                            amountExpense, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        double piutangCC = amount - amountExpense;                                
                                        amountPiutang = piutangCC;
                                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                    

                                } else {               
                                    
                                    amountPiutang = amount;
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }

                                Date dt = new Date();

                                String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                    DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                    DbPeriode.colNames[DbPeriode.COL_END_DATE];

                                Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                                Date effectiveDate = new Date();

                                if (tempEff != null && tempEff.size() > 0) {
                                    effectiveDate = new Date();
                                } else {
                                    Periode per = new Periode();
                                    if (periodId != 0) {
                                        try {
                                            per = DbPeriode.fetchExc(periodId);
                                        } catch (Exception e) {
                                            per = DbPeriode.getOpenPeriod();
                                        }
                                    }
                                    effectiveDate = per.getEndDate();
                                }

                                updateStatus(sales.getOID(), userId, effectiveDate);
                                
                                if(sales.getType() == DbSales.TYPE_RETUR_CREDIT){
                                    
                                    try{
                                        String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+sales.getOID();
                                        Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                                        if(vCP != null && vCP.size() > 0){
                                            CreditPayment cp = (CreditPayment)vCP.get(0);      
                                            DbCreditPayment.updateStatusPayCredit(cp.getOID(), userId); 
                                        }
                                    }catch(Exception e){}
                                    
                                    if(amountPiutang != 0){
                                        amountPiutang = amountPiutang * -1;
                                    }
                                    ARInvoice ar = new ARInvoice();                                    
                                    ar.setSalesSource(1);
                                    ar.setDate(sales.getDate());
                                    ar.setProjectId(sales.getOID());
                                    ar.setDueDate(sales.getDate());
                                    ar.setTransDate(sales.getDate());                                    
                                    ar.setCompanyId(sales.getCompanyId());
                                    ar.setOperatorId(sales.getUserId());
                                    ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
                                    ar.setCurrencyId(sales.getCurrencyId());
                                    ar.setCustomerId(sales.getCustomerId());
                                    ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
                                    ar.setDiscount(0);
                                    ar.setDiscountPercent(0);
                                    ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
                                    ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
                                    ar.setProjectTermId(sales.getOID());
                                    ar.setTotal(amountPiutang);
                                    ar.setVat(0);
                                    ar.setVatAmount(0);
                                    ar.setVatPercent(0);
                                    ar.setInvoiceNumber(sales.getNumber());
                                    ar.setTypeAR(DbARInvoice.TYPE_RETUR);                                    
                                    ar.setPostedStatus(1);
                                    ar.setPostedDate(new Date());
                                    ar.setCreateDate(new Date());
                                    ar.setLocationId(sales.getLocation_id());                                    
                                    try{                                        
                                        long oidx = DbARInvoice.insertExc(ar);                                        
                                        if (oidx != 0) {
                                            ARInvoiceDetail ard = new ARInvoiceDetail();
                                            ard.setArInvoiceId(oidx);
                                            ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                                            ard.setQty(1);
                                            ard.setPrice(amountPiutang);
                                            ard.setDiscount(0);
                                            ard.setTotalAmount(amountPiutang);
                                            ard.setCompanyId(sales.getCompanyId());

                                            try {
                                            DbARInvoiceDetail.insertExc(ard);
                                            } catch (Exception e) {}
                                        }                                        
                                    }catch(Exception e){}
                                }
                                DbGl.optimizedJournal(oid);
                            }
                        }                          
                }
            }
        }
    }

    public static void postPaymentCredit(Vector temp, long userId, long periodId){

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;

        if (v != null && v.size() > 0) {

            for (int i = 0; i < v.size(); i++) {

                SalesPaymentCredit sPC = (SalesPaymentCredit) v.get(i);
                Sales sales = new Sales();
                if (sPC.getSalesId() != 0) {
                    try {
                        sales = DbSales.fetchExc(sPC.getSalesId());
                    } catch (Exception e) {
                    }
                }

                long segment1_id = 0;

                if (sPC.getLocationId() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sPC.getLocationId();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;

                try {
                    if (sPC.getLocationId() != 0) {
                        location = DbLocation.fetchExc(sPC.getLocationId());
                        Coa co = new Coa();

                        if (location.getCoaSalesId() == 0) {
                            coaLocationTrue = false;
                        } else {
                            try {
                                co = DbCoa.fetchExc(location.getCoaSalesId());
                                if (co.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }
                        }

                        if (location.getCoaArId() == 0) {
                            coaLocationTrue = false;
                        } else {
                            try {
                                co = DbCoa.fetchExc(location.getCoaArId());
                                if (co.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }
                        }

                    } else {
                        coaLocationTrue = false;
                    }
                } catch (Exception e) {
                }

                if (coaLocationTrue) {

                    //cek nomor, jika sama cari nomor lain
                    String where = DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID] + " = " + sPC.getSalesId();
                    Vector vARInvoice = DbARInvoice.list(0, 1, where, null);
                    ARInvoice arInvoicex = (ARInvoice) vARInvoice.get(0);

                    int countPay = DbArPayment.getCountData(arInvoicex.getOID());

                    int next = countPay + 1;
                    String numb = sPC.getNumber() + "P" + next;
                    int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + numb + "'");
                    String number = numb;
                    if (count > 0) {
                        number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                    }

                    //post jurnal
                    long oid = DbGl.postJournalMain(0, sPC.getDate(), sPC.getCounter(), number, sPC.getNumberPrefix(),
                            I_Project.JOURNAL_TYPE_GENERAL_LEDGER,
                            "Payment Credit", sPC.getUserId(), "", sPC.getSalesId(), "", sPC.getDate(), periodId);

                    if (oid != 0) {

                        Coa coa = new Coa();
                        try {
                            coa = DbCoa.fetchExc(location.getCoaSalesId());
                        } catch (Exception e) {
                        }

                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, sPC.getAmountCredit(),
                                sPC.getAmountCredit(), comp.getBookingCurrencyId(), oid, "Kas", 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                        Coa coaAR = new Coa();
                        try {
                            coaAR = DbCoa.fetchExc(location.getCoaArId());
                        } catch (Exception e) {
                        }

                        DbGl.postJournalDetail(er.getValueIdr(), coaAR.getOID(), sPC.getAmountCredit(), 0,
                                sPC.getAmountCredit(), comp.getBookingCurrencyId(), oid, "Piutang", 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                        if (vARInvoice != null && vARInvoice.size() > 0) {

                            ARInvoice arInvoice = (ARInvoice) vARInvoice.get(0);
                            ArPayment arPayment = new ArPayment();

                            arPayment.setArInvoiceId(arInvoice.getOID());
                            arPayment.setExchangeRate(er.getValueIdr());
                            arPayment.setCurrencyId(comp.getBookingCurrencyId());
                            arPayment.setAmount(arInvoice.getTotal());
                            arPayment.setCustomerId(arInvoice.getCustomerId());
                            arPayment.setDate(new Date());
                            arPayment.setProjectTermId(arInvoice.getProjectTermId());
                            arPayment.setCompanyId(arInvoice.getCompanyId());
                            arPayment.setCounter(DbArPayment.getNextCounter(sales.getCompanyId()));
                            arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(sales.getCompanyId()));
                            arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), arPayment.getCompanyId()));
                            arPayment.setProjectId(arInvoice.getProjectId());
                            arPayment.setArCurrencyAmount(arInvoice.getTotal());
                            arPayment.setTransactionDate(new Date());
                            arPayment.setNotes("Payment Credit invoice : " + sales.getNumber());

                            try {
                                long oidAr = DbArPayment.insertExc(arPayment);
                                if (oidAr != 0) {

                                    CreditPayment cp = new CreditPayment();
                                    try {
                                        cp = DbCreditPayment.fetchExc(sPC.getCreditPaymentId());
                                        cp.setEffectiveDate(new Date());
                                        cp.setPostedStatus(1);

                                        updateStatusPayCredit(sPC.getCreditPaymentId(), userId);
                                        boolean stPayment = statusPayment(sPC.getSalesId());
                                        if (stPayment == true) {
                                            arInvoice.setStatus(I_Project.INV_STATUS_FULL_PAID);
                                        } else {
                                            arInvoice.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                                        }
                                        DbARInvoice.updateExc(arInvoice);

                                    } catch (Exception e) {
                                        System.out.println("[exception] " + e.toString());
                                    }
                                }
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                        }
                    }
                }
            }
        }
    }

    public static boolean statusPayment(long salesId) {
        try {
            double amount = getTotalAmount(salesId);
            double payment = getTotalAmountPayment(salesId);
            if (payment >= amount) {
                return true;
            }
        } catch (Exception e) {
        }
        return false;
    }

    public static void postPayCredit(Vector temp, long userId, long periodId) {

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;

        if (v != null && v.size() > 0) {

            for (int i = 0; i < v.size(); i++) {

                SalesPaymentCredit sPC = (SalesPaymentCredit) v.get(0);
                long segment1_id = 0;

                if (sPC.getLocationId() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sPC.getLocationId();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;

                try {
                    if (sPC.getLocationId() != 0) {
                        location = DbLocation.fetchExc(sPC.getLocationId());
                        Coa co = new Coa();

                        if (location.getCoaSalesId() == 0) {
                            coaLocationTrue = false;
                        } else {
                            try {
                                co = DbCoa.fetchExc(location.getCoaSalesId());
                                if (co.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }
                        }

                        if (location.getCoaArId() == 0) {
                            coaLocationTrue = false;
                        } else {
                            try {
                                co = DbCoa.fetchExc(location.getCoaArId());
                                if (co.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }
                        }
                    } else {
                        coaLocationTrue = false;
                    }
                } catch (Exception e) {
                }

                if (coaLocationTrue) {

                    //cek nomor, jika sama cari nomor lain
                    int countPay = DbCreditPayment.getCount(DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + "= " + sPC.getSalesId());
                    int next = countPay + 1;
                    String numb = sPC.getNumber() + "P" + next;
                    int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + numb + "'");
                    String number = numb;
                    if (count > 0) {
                        number = number + " - " + DbGl.getNextNumber(DbGl.getNextCounter());
                    }
                    //post jurnal
                    long oid = DbGl.postJournalMain(0, sPC.getDate(), sPC.getCounter(), number, sPC.getNumberPrefix(),
                            I_Project.JOURNAL_TYPE_GENERAL_LEDGER,
                            "Payment Credit", sPC.getUserId(), "", sPC.getSalesId(), "", sPC.getDate(), periodId);

                    if (oid != 0) {
                        Coa coa = new Coa();
                        try {
                            coa = DbCoa.fetchExc(location.getCoaSalesId());
                        } catch (Exception e) {
                        }

                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, sPC.getAmountCredit(),
                                sPC.getAmountCredit(), comp.getBookingCurrencyId(), oid, "Kas", 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                        Coa coaAR = new Coa();
                        try {
                            coaAR = DbCoa.fetchExc(location.getCoaArId());
                        } catch (Exception e) {
                        }

                        DbGl.postJournalDetail(er.getValueIdr(), coaAR.getOID(), sPC.getAmountCredit(), 0,
                                sPC.getAmountCredit(), comp.getBookingCurrencyId(), oid, "Piutang", 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                        String where = DbARInvoice.colNames[DbARInvoice.COL_JOURNAL_NUMBER] + " = '" + sPC.getNumber() + "' and " + DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID] + " = " + sPC.getCustomerId();

                        Vector vARInvoice = DbARInvoice.list(0, 1, where, null);

                        if (vARInvoice != null && vARInvoice.size() > 0) {

                            ARInvoice arInvoice = (ARInvoice) vARInvoice.get(0);
                            int counter = DbArPayment.getNextCounter(comp.getOID());

                            ArPayment arPayment = new ArPayment();                            
                            arPayment.setArInvoiceId(arInvoice.getOID());
                            arPayment.setCurrencyId(comp.getBookingCurrencyId());
                            arPayment.setExchangeRate(er.getValueIdr());
                            arPayment.setCounter(counter);
                            arPayment.setJournalNumber(DbArPayment.getNextNumber(counter, comp.getOID()));
                            arPayment.setCompanyId(comp.getOID());

                        //arPayment.set
                        }
                    }
                }
            }
        }
    }

    public static void postJournal(Vector temp, long userId, long periodId){

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;
        
        String activeMerchant = "YES";                        
        Date activeDate = null;
        
        try{
            activeMerchant = DbSystemProperty.getValueByName("ACTIVE_MERCHANT");                           
            activeDate = new Date();                              
            activeDate = JSPFormater.formatDate(activeMerchant, "dd/MM/yyyy");  
        }catch(Exception e){
            System.out.println("[Exception] "+e.toString());
        }

        if (v != null && v.size() > 0){

            int intervalDue = 7; // default 7 hari jatuh tempo setelah transaksi
            try {
                intervalDue = Integer.parseInt(DbSystemProperty.getValueByName("INTERVAL_DUE_DATE_CREDIT"));
            } catch (Exception e) {}

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                long segment1_id = 0;
                
                boolean merchantAktif = true;
                try{
                    if(activeMerchant.compareTo("YES") != 0 ){
                        if(sales.getDate().after(activeDate)){
                            merchantAktif = true;
                        }else{
                            merchantAktif = false;
                        }
                    }                    
                }catch(Exception e){}                
                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();

                try {

                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {
                        
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {}

                        if (payment.getCurrency_id() == 0){
                            try {
                                long currIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {}

                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                                } catch (Exception e) {
                            }
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }
                        
                            
                        if (comp.getMultiBank() == DbCompany.MULTI_BANK && merchantAktif){ // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }                        
                    }

                    if (sales.getNumber().length() <= 0) {
                        coaLocationTrue = false;
                    }

                    if (sales.getLocation_id() != 0) {

                        location = DbLocation.fetchExc(sales.getLocation_id());
                        Coa co = new Coa();
                        if (location.getCoaSalesId() == 0) {
                            coaLocationTrue = false;
                        } else {
                            try {
                                co = DbCoa.fetchExc(location.getCoaSalesId());
                                if (co.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }
                        }

                    } else {
                        coaLocationTrue = false;
                    }
                } catch (Exception e) {
                }

                Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");
                for (int ix = 0; ix < dtls.size(); ix++){

                    SalesDetail sdCk = (SalesDetail) dtls.get(ix);
                    //ItemMaster im = new ItemMaster();
                    //ItemGroup ig = new ItemGroup();                    
                    MasterGroup mg = new MasterGroup();
                    try {
                        //im = DbItemMaster.fetchExc(sdCk.getProductMasterId());                        
                        mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                        
                        //ig = DbItemGroup.fetchExc(im.getItemGroupId());                        
                    } catch (Exception e) {
                    }

                    Coa coaSalesCredit = new Coa();
                    try {
                        coaSalesCredit = DbCoa.getCoaByCode(mg.getAccSalesCash().trim());
                    } catch (Exception e) {}

                    if (coaSalesCredit.getOID() == 0) {
                        coaLocationTrue = false;
                    }

                    if(mg.getNeedBom() == DbItemMaster.NON_BOM){
                    
                        Coa coaInv = new Coa();
                        try {
                            coaInv = DbCoa.getCoaByCode(mg.getAccInv().trim());
                        } catch (Exception e) {}

                        if (sdCk.getCogs() > 0 && mg.getService() == 0){                        
                            if (coaInv.getOID() == 0) {
                                coaLocationTrue = false;                            
                            }                        
                        }
                    
                        Coa coaCogs = new Coa();
                        try {
                            coaCogs = DbCoa.getCoaByCode(mg.getAccCogs().trim());
                        } catch (Exception e) {}

                        if (sdCk.getCogs() > 0 && mg.getService() == 0) {
                            if (coaCogs.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        }
                        
                    }else{
                        Vector vRecipe = DbRecipe.getRecipe(mg.getItemMasterId());                        
                        if(vRecipe != null && vRecipe.size() > 0){
                            for(int j = 0 ; j < vRecipe.size(); j++){
                                RecipeParameter rp = (RecipeParameter)vRecipe.get(j);                                                                
                                MasterGroup masterGroup = new MasterGroup();
                                try{
                                    masterGroup = DbItemMaster.getItemGroup(rp.getItemId());
                                }catch(Exception e){}                                                                            
                                MasterOid mInv = DbItemMaster.getOidByCode(masterGroup.getAccInv());
                                if(mInv.getOidMaster() == 0){
                                    coaLocationTrue = false;
                                }                                        
                                MasterOid mCogs = DbItemMaster.getOidByCode(masterGroup.getAccCogs());
                                if(mCogs.getOidMaster() == 0){
                                    coaLocationTrue = false;
                                }
                            }
                        }
                    }
                    
                    Coa coaSl = new Coa();
                    try {
                        coaSl = DbCoa.getCoaByCode(mg.getAccSalesCash().trim());
                    } catch (Exception e) {}

                    if (coaSl.getOID() == 0) {
                        coaLocationTrue = false;
                    }
                }

                //cek nomor, jika sama cari nomor lain                    
                int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                if (count > 0) {
                    coaLocationTrue = false;
                }

                if (coaLocationTrue) { // jika kondisi setup coa untuk sales tidak kosong

                    Customer cust = new Customer();
                    if (sales.getType() == DbSales.TYPE_CREDIT){
                        try {
                            cust = DbCustomer.fetchExc(sales.getCustomerId());
                        } catch (Exception ex) {
                            System.out.println("[exception] " + ex.toString());
                        }
                    }

                    //jurnal main
                    String memo = "";
                    if (sales.getType() == DbSales.TYPE_CASH) {
                        memo = "Cash sales, " + location.getName();
                    } else {
                        memo = "Credit sales, " + location.getName() +
                                " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());
                    }
                    
                    String number = sales.getNumber();

                    //post jurnal
                    long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                            I_Project.JOURNAL_TYPE_SALES,
                            memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                    //jika sukses input gl
                    if (oid != 0) {
                        //jurnal debet   
                        double amount = 0;

                        for (int x = 0; x < dtls.size(); x++) {

                            SalesDetail sd = (SalesDetail) dtls.get(x);

                            ItemMaster im = new ItemMaster();
                            ItemGroup ig = new ItemGroup();
                            try {
                                im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                ig = DbItemGroup.fetchExc(im.getItemGroupId());
                            } catch (Exception e) {
                            }

                            Coa coaSales = new Coa();
                            try {
                                coaSales = DbCoa.getCoaByCode(ig.getAccountSalesCash().trim());
                            } catch (Exception e) {
                            }

                            Coa coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                            Coa coaCogs = DbCoa.getCoaByCode(ig.getAccountCogs().trim());

                            if (comp.getUseBkp() == DbCompany.USE_BKP && im.getIs_bkp() == DbItemMaster.BKP) {

                                double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();
                                double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                double amountPpn = amountTransaction - price;
                                memo = "sales item " + im.getName();

                                DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), price, 0,
                                        price, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                Coa coaPpn = new Coa();
                                try {
                                    coaPpn = DbCoa.getCoaByCode(ig.getAccountVat().trim());
                                } catch (Exception e) {}

                                memo = "ppn " + im.getName();

                                DbGl.postJournalDetail(er.getValueIdr(), coaPpn.getOID(), amountPpn, 0,
                                        amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                amount = amount + (price + amountPpn);

                            } else {

                                memo = "sales item " + im.getName();
                                double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();

                                DbGl.postJournalDetail(er.getValueIdr(), coaSales.getOID(), amountTransaction, 0,
                                        amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                amount = amount + amountTransaction;
                            }

                            //journal inventory credit only for stockable item
                            if (sd.getCogs() > 0 && im.getNeedRecipe() == 0){

                                memo = "inventory : " + im.getName();
                                DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOID(), sd.getCogs() * sd.getQty(), 0,
                                        im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                //journal hpp
                                memo = "hpp : " + im.getName();

                                DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOID(), 0, sd.getCogs() * sd.getQty(),
                                        im.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }
                        }

                        Coa coa = new Coa();
                        Coa coaExpense = new Coa();
                        double amountExpense = 0;

                        if (sales.getType() == DbSales.TYPE_CASH) {

                            if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){

                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH){
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(curr.getCoaId());
                                    } catch (Exception e) {}

                                } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                    if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK ) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {
                                        }

                                    } else {
                                        
                                        if(merchantAktif){

                                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                memo = "Credit Card";
                                            } else {
                                                memo = "Debit Card";
                                            }

                                            try {
                                                try {
                                                    merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                } catch (Exception e) {}
                                                
                                                try {
                                                    coa = DbCoa.fetchExc(merchant.getCoaId());
                                                } catch (Exception e) {
                                                }
                                                try {
                                                    coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                } catch (Exception e) {}

                                                if (merchant.getPersenExpense() > 0) {
                                                    amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                }

                                            } catch (Exception e) {}
                                            
                                        }else{                                            
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}
                                        }
                                    }
                                }
                            } else {
                                memo = "Cash";
                                try {
                                    coa = DbCoa.fetchExc(location.getCoaSalesId());
                                } catch (Exception e) {
                                }
                            }

                        } else {
                            try {
                                coa = DbCoa.fetchExc(location.getCoaArId());
                            } catch (Exception e) {
                            }
                            memo = "Credit Sales";
                        }


                        double amountPiutang = 0;

                        if (amountExpense > 0) {
                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                memo = "Biaya Komisi Credit Card";
                            } else {
                                memo = "Biaya Komisi Debit Card";
                            }
                            if (amountExpense != 0) {
                                DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), 0, amountExpense,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }
                            
                            double piutangCC = amount - amountExpense;
                            amountPiutang = piutangCC;
                            DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, piutangCC,
                                    piutangCC, comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);

                        } else {
                            amountPiutang = amount;
                            DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amount,
                                    amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                        }

                        Date dt = new Date();

                        String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                DbPeriode.colNames[DbPeriode.COL_END_DATE];

                        Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                        Date effectiveDate = new Date();

                        if (tempEff != null && tempEff.size() > 0) {
                            effectiveDate = new Date();
                        } else {
                            Periode per = new Periode();
                            if (periodId != 0) {
                                try {
                                    per = DbPeriode.fetchExc(periodId);
                                } catch (Exception e) {
                                    per = DbPeriode.getOpenPeriod();
                                }
                            }
                            effectiveDate = per.getEndDate();
                        }
                        updateStatus(sales.getOID(), userId, effectiveDate);
                        if (sales.getType() == DbSales.TYPE_CREDIT) {
                            postReceivable(sales, intervalDue, amountPiutang);
                        }
                    }
                }
            }
        }
    }
    
    
    public static void postJournalNew(Vector temp, long userId, long periodIdx,Company comp){
        
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;        
        String activeMerchant = "YES";                        
        Date activeDate = null;        
        try{
            activeMerchant = DbSystemProperty.getValueByName("ACTIVE_MERCHANT");                           
            activeDate = new Date();                              
            activeDate = JSPFormater.formatDate(activeMerchant, "dd/MM/yyyy");  
        }catch(Exception e){}
        
        int intervalDue = 7; // default 7 hari jatuh tempo setelah transaksi
        try {
            intervalDue = Integer.parseInt(DbSystemProperty.getValueByName("INTERVAL_DUE_DATE_CREDIT"));
        } catch (Exception e) {}   
        
        long deffCurrIDR = 0;
        try {
            deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));        
        } catch (Exception e) {}

        Periode p = new Periode();
        if(periodIdx != 0){
            try{
                p = DbPeriode.fetchExc(periodIdx);
            }catch(Exception e){}
        }
        
        if (v != null && v.size() > 0){

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                
                long segment1_id = 0;                
                boolean merchantAktif = true;
                try{
                    if(activeMerchant.compareTo("YES") != 0 ){
                        if(sales.getDate().after(activeDate)){
                            merchantAktif = true;
                        }else{
                            merchantAktif = false;
                        }
                    }                    
                }catch(Exception e){}    
                
                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();                
                long periodId = periodIdx;
                Periode periode = new Periode();               
                
                //Parameter Multy Bank                
                Hashtable hAccSalesDetail = new Hashtable();               
                
                if(periodId == 0){    
                    try {
                        periode = DbPeriode.getPeriodByTransDate(sales.getDate());
                        periodId = periode.getOID();
                    } catch (Exception e) {
                    }                    
                }else{
                    periode = p;
                }
                
                if (periode.getStatus().compareTo("Closed") == 0) {
                    coaLocationTrue = false;
                }

                try {
                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {}

                        if (payment.getCurrency_id() == 0){
                            try {
                                long currIDR = deffCurrIDR;
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {}

                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                                } catch (Exception e) {
                            }
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }
                        
                            
                        if (comp.getMultiBank() == DbCompany.MULTI_BANK && merchantAktif){ // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }                        
                    }

                    if (sales.getNumber().length() <= 0){
                        coaLocationTrue = false;
                    }

                    if (sales.getLocation_id() != 0) {
                        location = DbLocation.fetchExc(sales.getLocation_id());
                        Coa co = new Coa();
                        if (location.getCoaSalesId() == 0) {
                            coaLocationTrue = false;
                        } else {
                            try {
                                co = DbCoa.fetchExc(location.getCoaSalesId());
                                if (co.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }
                        }

                    } else {
                        coaLocationTrue = false;
                    }
                } catch (Exception e) {
                }

                Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), ""); 
                
                for (int ix = 0; ix < dtls.size(); ix++){

                    SalesDetail sdCk = (SalesDetail) dtls.get(ix);                    
                    CoaSalesDetail csd = new CoaSalesDetail();
                    
                    csd.setSalesDetailId(sdCk.getOID());
                    csd.setProductMasterId(sdCk.getProductMasterId()); 
                    
                    MasterGroup mg = new MasterGroup();
                    try {                        
                        mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                                                
                    } catch (Exception e) {}
                    
                    csd.setItemName(mg.getName());
                    csd.setIsBkp(mg.getIsBkp());                    
                    
                    // =========== OID PENJUALAN CASH==============
                    MasterOid coaSales = new MasterOid();
                    try {
                        coaSales = DbItemMaster.getOidByCode(mg.getAccSales().trim());                        
                    } catch (Exception e) {}

                    if (coaSales.getOidMaster() == 0) {
                        coaLocationTrue = false;
                    }                    
                    csd.setAccSales(coaSales.getOidMaster());                    
                    //============== END ===========================
                    
                    if (comp.getUseBkp() == DbCompany.USE_BKP && mg.getIsBkp() == DbItemMaster.BKP) { // jika menggunakan ppn
                        // =========== OID PPN ==============
                        MasterOid coaPpn = new MasterOid();
                        try {
                            coaPpn = DbItemMaster.getOidByCode(mg.getAccVat().trim());
                        } catch (Exception e) {}
                        
                        if (coaPpn.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }                    
                        csd.setAccPpn(coaPpn.getOidMaster());                    
                        //============== END ===========================
                    }
                    csd.setService(mg.getService());

                    if (sdCk.getCogs() > 0 && mg.getService() == 0){  // Jika bukan service && cogs tidak sama dengan 0                      
                            
                        // =========== OID INVENTORY==============
                        MasterOid coaInv = new MasterOid();
                        try {
                            coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());   
                        } catch (Exception e) {}
                            
                        if (coaInv.getOidMaster() == 0) {
                            coaLocationTrue = false;                            
                        }                                                    
                        csd.setAccInv(coaInv.getOidMaster());  
                        //============== END ===========================
                        
                         // =========== OID COGS==============
                        MasterOid coaCogs = new MasterOid();
                        try {
                            coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                        } catch (Exception e) {}
                            
                        if (coaCogs.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }
                        csd.setAccCogs(coaCogs.getOidMaster());  
                        //============== END ===========================
                    }
                    
                    hAccSalesDetail.put(""+sdCk.getOID(), csd); // di save di hashtable untuk memudahkan pengambilan berikutnya
                    
                }

                //cek nomor, jika sama cari nomor lain                    
                int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                if (count > 0) {
                    coaLocationTrue = false;
                }

                if (coaLocationTrue) { // jika kondisi setup coa untuk sales tidak kosong
                    Customer cust = new Customer();
                    if (sales.getType() == DbSales.TYPE_CREDIT){
                        try {
                            cust = DbCustomer.fetchExc(sales.getCustomerId());
                        } catch (Exception ex) {
                            System.out.println("[exception] " + ex.toString());
                        }
                    }

                    //jurnal main
                    String memo = "";
                    if (sales.getType() == DbSales.TYPE_CASH) {
                        if(payment.getPay_type() == DbPayment.PAY_TYPE_CASH){                        
                            memo = "Cash sales, " + location.getName();                                 
                        }else if(payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD){
                            memo = "Credit Card Payment sales, " + location.getName();                                 
                        }else if(payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD){
                            memo = "Debit Card Payment sales, " + location.getName();                    
                        }else if(payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER){
                            memo = "Transfer Payment sales, " + location.getName();
                        }
                    }else{
                        memo = "Credit sales, " + location.getName() +
                                " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());                        
                    }    
                    
                    String number = sales.getNumber();
                    //post jurnal
                    long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                            I_Project.JOURNAL_TYPE_SALES,
                            memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                    //jika sukses input gl
                    if (oid != 0) {
                        //jurnal debet   
                        double amount = 0;

                        for (int x = 0; x < dtls.size(); x++) {

                            SalesDetail sd = (SalesDetail) dtls.get(x);
                            
                            CoaSalesDetail csd = new CoaSalesDetail();                            
                            try{
                                csd = (CoaSalesDetail)hAccSalesDetail.get(""+sd.getOID());
                            }catch(Exception e){}                            

                            double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();                            
                            if (comp.getUseBkp() == DbCompany.USE_BKP && csd.getIsBkp() == DbItemMaster.BKP) {
                                
                                double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                double amountPpn = amountTransaction - price;
                                
                                memo = "sales item " + csd.getItemName();
                                
                                if(price != 0){                                
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), price, 0,
                                        price, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }    
                                
                                memo = "ppn " + csd.getItemName();
                                
                                if(amountPpn != 0){
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), amountPpn, 0,
                                        amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }        
                                amount = amount + (price + amountPpn);

                            } else {
                                memo = "sales item " + csd.getItemName();
                                if(amountTransaction != 0){
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), amountTransaction, 0,
                                        amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }
                                amount = amount + amountTransaction;
                            }

                            if (sd.getCogs() > 0 && csd.getService() == 0){
                                double hpp = sd.getCogs() * sd.getQty();
                                
                                if(hpp != 0){
                                    
                                    memo = "inventory : " + csd.getItemName();
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccInv(), sd.getCogs() * sd.getQty(), 0,
                                        sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                    //journal hpp
                                    memo = "hpp : " + csd.getItemName();
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccCogs(), 0, sd.getCogs() * sd.getQty(),
                                        sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }
                            }                                                            
                        }

                        Coa coa = new Coa();
                        Coa coaExpense = new Coa();
                        double amountExpense = 0;

                        if (sales.getType() == DbSales.TYPE_CASH) {
                            if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH){
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(curr.getCoaId());
                                    } catch (Exception e) {}

                                } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                    if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK ) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else {
                                        
                                        if(merchantAktif){
                                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                memo = "Credit Card";
                                            } else {
                                                memo = "Debit Card";
                                            }

                                            try {
                                                try {
                                                    merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                } catch (Exception e) {}
                                                
                                                try {
                                                    coa = DbCoa.fetchExc(merchant.getCoaId());
                                                } catch (Exception e) {}
                                                
                                                try {
                                                    coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                } catch (Exception e) {}

                                                if (merchant.getPersenExpense() > 0) {
                                                    amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                }

                                            } catch (Exception e) {}
                                            
                                        }else{                                            
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}
                                        }
                                    }
                                }else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER){
                                    memo = "Transfer Bank";
                                    Bank bank = new Bank();
                                    
                                    try{
                                        bank = DbBank.fetchExc(payment.getBankId());
                                    }catch(Exception e){}
                                    
                                    try{
                                        coa = DbCoa.fetchExc(bank.getCoaARId());
                                    }catch(Exception e){}                                    
                                }
                                
                            } else {
                                memo = "Cash";
                                try {
                                    coa = DbCoa.fetchExc(location.getCoaSalesId());
                                } catch (Exception e) {
                                }
                            }

                        } else {
                            try {
                                coa = DbCoa.fetchExc(location.getCoaArId());
                            } catch (Exception e) {}
                            memo = "Credit Sales";
                        }

                        double amountPiutang = 0;
                        if (amountExpense > 0) {
                            String memoPiutang = "";
                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                memo = "Biaya Komisi Credit Card";
                                memoPiutang = "Credit Card";
                            } else {
                                memo = "Biaya Komisi Debit Card";
                                memoPiutang = "Debit Card";
                            }
                            
                            if (amountExpense != 0) {
                                DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), 0, amountExpense,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }
                            
                            double piutangCC = amount - amountExpense;
                            amountPiutang = piutangCC;
                            
                            if(piutangCC != 0){
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, piutangCC,
                                    piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            }

                        } else {
                            
                            amountPiutang = amount;
                            if(amount != 0){
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amount,
                                    amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            }
                        }

                        Date dt = new Date();
                        String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                DbPeriode.colNames[DbPeriode.COL_END_DATE];

                        Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                        Date effectiveDate = new Date();

                        if (tempEff != null && tempEff.size() > 0) {
                            effectiveDate = new Date();
                        } else {
                            Periode per = new Periode();
                            if (periodId != 0) {
                                try {
                                    per = DbPeriode.fetchExc(periodId);
                                } catch (Exception e) {
                                    per = DbPeriode.getOpenPeriod();
                                }
                            }
                            effectiveDate = per.getEndDate();
                        }
                        updateStatus(sales.getOID(), userId, effectiveDate);
                        if (sales.getType() == DbSales.TYPE_CREDIT) {
                            postReceivable(sales, intervalDue, amountPiutang);
                        }
                    }
                }
            }
        }
    }
    
    public static Vector getMappingCOGS(Date tanggal,long locationId,long cashCashierId){
        CONResultSet crs = null; 
        try{
            String where = "";
            
            if(cashCashierId != 0){
                where = " and s."+DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]+" = "+cashCashierId;
            }            
            
            String sql = "select group_id,sum(amount) as xamount,sum(amount_rev) as xamount_rev,acc_sales,acc_inv,acc_cogs from ( "+
                    "select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_rev,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id " +
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where s."+DbSales.colNames[DbSales.COL_TYPE]+" in (0,1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId +" "+ where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                    "select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") * -1 as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") * -1 as amount_rev,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id " +
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where s."+DbSales.colNames[DbSales.COL_TYPE]+" in (2,3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" ) as x group by group_id ";
            
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while(rs.next()){                                        
                Vector tmp = new Vector();
                double amount = rs.getDouble("xamount");
                double amountRev = rs.getDouble("xamount_rev");
                String accInv = rs.getString("acc_inv");
                String accCogs = rs.getString("acc_cogs");
                String accSales = rs.getString("acc_sales");
                tmp.add(""+accInv);
                tmp.add(""+accCogs);
                tmp.add(""+accSales);
                tmp.add(""+amount);                        
                tmp.add(""+amountRev);                        
                result.add(tmp);
            }            
            return result;
        }catch(Exception e){
            System.out.println(e.toString());
        }finally{
            CONResultSet.close(crs);
        }        
        
        return null;
    }
    
    public static void postJournal(Vector temp, long userId, long periodIdx,Company comp){
        
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;                
        
        int intervalDue = 7;// default 7 hari jatuh tempo setelah transaksi
        try {
            intervalDue = Integer.parseInt(DbSystemProperty.getValueByName("INTERVAL_DUE_DATE_CREDIT"));
        } catch (Exception e) {}   
        
        long deffCurrIDR = 0;
        try {
            deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));        
        } catch (Exception e) {}

        Periode p = new Periode();
        if(periodIdx != 0){
            try{
                p = DbPeriode.fetchExc(periodIdx);
            }catch(Exception e){}
        }
        
        if (v != null && v.size() > 0){

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);                
                long segment1_id = 0;          
                
                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();                
                long periodId = periodIdx;
                Periode periode = new Periode();               
                
                //Parameter Multy Bank                
                Hashtable hAccSalesDetail = new Hashtable();               
                
                if(periodId == 0){    
                    try {
                        periode = DbPeriode.getPeriodByTransDate(sales.getDate());
                        periodId = periode.getOID();
                    } catch (Exception e) {
                    }                    
                }else{
                    periode = p;
                }
                
                if (periode.getStatus().compareTo("Closed") == 0) {
                    coaLocationTrue = false;
                }

                try {
                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {}

                        if (payment.getCurrency_id() == 0){
                            try {
                                long currIDR = deffCurrIDR;
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {}

                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                                } catch (Exception e) {
                            }
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }
                        
                            
                        if (comp.getMultiBank() == DbCompany.MULTI_BANK){ // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }                        
                    }

                    if (sales.getNumber().length() <= 0){
                        coaLocationTrue = false;
                    }

                    if (sales.getLocation_id() != 0) {
                        location = DbLocation.fetchExc(sales.getLocation_id());
                        Coa co = new Coa();
                        if (location.getCoaSalesId() == 0) {
                            coaLocationTrue = false;
                        } else {
                            try {
                                co = DbCoa.fetchExc(location.getCoaSalesId());
                                if (co.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }
                        }

                    } else {
                        coaLocationTrue = false;
                    }
                } catch (Exception e) {
                }

                Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), ""); 
                
                for (int ix = 0; ix < dtls.size(); ix++){

                    SalesDetail sdCk = (SalesDetail) dtls.get(ix);                    
                    CoaSalesDetail csd = new CoaSalesDetail();
                    
                    csd.setSalesDetailId(sdCk.getOID());
                    csd.setProductMasterId(sdCk.getProductMasterId()); 
                    
                    MasterGroup mg = new MasterGroup();
                    try {                        
                        mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                                                
                    } catch (Exception e) {}
                    
                    csd.setItemName(mg.getName());
                    csd.setIsBkp(mg.getIsBkp());                    
                    csd.setNeedBom(mg.getNeedBom());
                    
                    // =========== OID PENJUALAN CASH==============
                    MasterOid coaSales = new MasterOid();
                    try {
                        coaSales = DbItemMaster.getOidByCode(mg.getAccSales().trim());                        
                    } catch (Exception e) {}

                    if (coaSales.getOidMaster() == 0) {
                        coaLocationTrue = false;
                    }                    
                    csd.setAccSales(coaSales.getOidMaster());                    
                    
                    //==========Pendapatan Service=================
                    if(sales.getServicePercent() != 0){
                        
                        MasterOid coaService = new MasterOid();
                        try {
                            coaService = DbItemMaster.getOidByCode(mg.getAccOtherIncome().trim());                        
                        } catch (Exception e) {}

                        if (coaService.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }       
                        csd.setAccOtherIncome(coaService.getOidMaster());
                    }
                    //============== END ====================                    
                    
                    // =========== OID PPN ==============
                    MasterOid coaPpn = new MasterOid();
                    try {
                        coaPpn = DbItemMaster.getOidByCode(mg.getAccVat().trim());
                    } catch (Exception e) {}
                        
                    if (coaPpn.getOidMaster() == 0) {
                        coaLocationTrue = false;
                    }                    
                    csd.setAccPpn(coaPpn.getOidMaster());                    
                    //============== END ===========================
                    
                    csd.setService(mg.getService());
                    
                    if(mg.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                        Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sdCk.getOID(), null);
                        
                        if(vStock != null && vStock.size() > 0){
                            for(int d = 0; d < vStock.size() ; d++){                            
                                
                                Stock stock = (Stock)vStock.get(d);
                                MasterGroup mgx = new MasterGroup();
                                try {                        
                                    mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                } catch (Exception e) {}
                                
                                // =========== OID INVENTORY==============
                                MasterOid coaInv = new MasterOid();
                                try {
                                    coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                } catch (Exception e) {}
                            
                                if (coaInv.getOidMaster() == 0) {
                                    coaLocationTrue = false;                            
                                }     
                                
                                 // =========== OID COGS==============
                                MasterOid coaCogs = new MasterOid();
                                try {
                                    coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                } catch (Exception e) {}
                            
                                if (coaCogs.getOidMaster() == 0) {
                                    coaLocationTrue = false;
                                }                                
                                //============== END ===========================
                            }
                        }
                        
                    }else{

                        if (sdCk.getCogs() > 0 && mg.getService() == 0){  // Jika bukan service && cogs tidak sama dengan 0                      
                            
                            // =========== OID INVENTORY==============
                            MasterOid coaInv = new MasterOid();
                            try {
                                coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());   
                            } catch (Exception e) {}
                            
                            if (coaInv.getOidMaster() == 0) {
                                coaLocationTrue = false;                            
                            }                                                    
                            csd.setAccInv(coaInv.getOidMaster());  
                            //============== END ===========================
                        
                            // =========== OID COGS==============
                            MasterOid coaCogs = new MasterOid();
                            try {
                                coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                            } catch (Exception e) {}
                            
                            if (coaCogs.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }
                            csd.setAccCogs(coaCogs.getOidMaster());  
                            //============== END ===========================
                        }
                    }
                    
                    hAccSalesDetail.put(""+sdCk.getOID(), csd); // di save di hashtable untuk memudahkan pengambilan berikutnya                    
                }

                //cek nomor, jika sama cari nomor lain                    
                int count = DbGl.getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + "='" + sales.getNumber() + "'");
                if (count > 0) {
                    coaLocationTrue = false;
                }

                if (coaLocationTrue) { // jika kondisi setup coa untuk sales tidak kosong
                    Customer cust = new Customer();
                    if (sales.getType() == DbSales.TYPE_CREDIT){
                        try {
                            cust = DbCustomer.fetchExc(sales.getCustomerId());
                        } catch (Exception ex) {
                            System.out.println("[exception] " + ex.toString());
                        }
                    }

                    //jurnal main
                    String memo = "";
                    if (sales.getType() == DbSales.TYPE_CASH) {
                        if(payment.getPay_type() == DbPayment.PAY_TYPE_CASH){                        
                            memo = "Cash sales, " + location.getName();                                 
                        }else if(payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD){
                            memo = "Credit Card Payment sales, " + location.getName();                                 
                        }else if(payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD){
                            memo = "Debit Card Payment sales, " + location.getName();                    
                        }else if(payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER){
                            memo = "Transfer Payment sales, " + location.getName();
                        }
                    }else{
                        memo = "Credit sales, " + location.getName() +
                                " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());                        
                    }    
                    
                    String number = sales.getNumber();
                    //post jurnal
                    long oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                            I_Project.JOURNAL_TYPE_SALES,
                            memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);

                    //jika sukses input gl
                    if (oid != 0) {
                        //jurnal debet   
                        double amount = 0;
                        
                        double amountTotal = 0;
                        double dicGlobal = 0;
                        
                        for (int x = 0; x < dtls.size(); x++) {
                            SalesDetail sd = (SalesDetail) dtls.get(x);                            
                            amountTotal =  amountTotal + ((sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount());                              
                        }    
                        
                        dicGlobal = (sales.getGlobalDiskon() * 100)/amountTotal;
                        int isFeePaidByComp = SessCreditPayment.isFeeByCompany(sales.getOID());     
                        
                        for (int x = 0; x < dtls.size(); x++) {

                            SalesDetail sd = (SalesDetail) dtls.get(x);
                            
                            CoaSalesDetail csd = new CoaSalesDetail();                            
                            try{
                                csd = (CoaSalesDetail)hAccSalesDetail.get(""+sd.getOID());
                            }catch(Exception e){}                     

                            double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();                              
                            
                            //pemrosesan diskon global
                            double diskonGlobal = 0;
                            
                            if(sales.getGlobalDiskon() != 0){
                                diskonGlobal = amountTransaction * (dicGlobal/100);
                                amountTransaction = amountTransaction - diskonGlobal;
                            }
                            
                            double amountService = 0;
                            if(sales.getServicePercent() != 0){
                                amountService = amountTransaction * (sales.getServicePercent()/100);                                  
                            }                                                                         
                            
                            if(sales.getVatPercent() != 0 || sales.getServicePercent() != 0){
                                
                                double amountVat = 0;
                                if(sales.getVatPercent() != 0){
                                    amountVat = (amountTransaction + amountService) * (sales.getVatPercent()/100);
                                }
                                
                                memo = "sales item " + csd.getItemName();                                                               
                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), amountTransaction, 0,
                                        amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);                                    
                                
                                memo = "ppn " + csd.getItemName();                                
                                if(amountVat != 0){
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), amountVat, 0,
                                        amountVat, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }        
                                
                                memo = "Pendapatan Service "+csd.getItemName();                                
                                if(amountService != 0){
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccOtherIncome(), amountService, 0,
                                        amountService, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }
                                
                                amount = amount + (amountTransaction + amountVat + amountService);
                            
                            }else{
                            
                                if (comp.getUseBkp() == DbCompany.USE_BKP && csd.getIsBkp() == DbItemMaster.BKP ){
                                
                                    double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                    double amountPpn = amountTransaction - price;
                                
                                    memo = "sales item " + csd.getItemName();
                                
                                    if(price != 0){                                
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), price, 0,
                                            price, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }    
                                
                                    memo = "ppn " + csd.getItemName();
                                
                                    if(amountPpn != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), amountPpn, 0,
                                            amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                    
                                    amount = amount + (price + amountPpn);

                                } else {
                                    memo = "sales item " + csd.getItemName();
                                    if(amountTransaction != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), amountTransaction, 0,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                    amount = amount + amountTransaction;
                                }
                            }
                            
                            if(csd.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                                Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sd.getOID(), null);
                        
                                if(vStock != null && vStock.size() > 0){
                                    
                                    for(int d = 0; d < vStock.size() ; d++){                            
                                
                                        Stock stock = (Stock)vStock.get(d);
                                        double hpp = stock.getQty() * stock.getPrice();
                                        
                                        if(hpp != 0){
                                            
                                            String itemName = "";                                            
                                            try{
                                                itemName = getItemName(stock.getItemMasterId());
                                            }catch(Exception e){}
                                        
                                            MasterGroup mgx = new MasterGroup();
                                            try {                        
                                                mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                            } catch (Exception e) {}
                                
                                            // =========== OID INVENTORY==============
                                            MasterOid coaInv = new MasterOid();
                                            try {
                                                coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                            } catch (Exception e) {}
                                
                                            // =========== OID COGS==============
                                            MasterOid coaCogs = new MasterOid();
                                            try {
                                                coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                            } catch (Exception e) {}
                                            
                                            
                                            memo = "inventory : " + itemName;
                                            DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOidMaster(), hpp, 0,
                                                hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                            //journal hpp
                                            
                                            memo = "hpp : " + itemName;
                                            DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOidMaster(), 0, hpp,
                                                hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                            //============== END ===========================
                                        }
                                    }
                                }                        
                            }else{
                            
                            
                                if (sd.getCogs() > 0 && csd.getService() == 0){
                                    double hpp = sd.getCogs() * sd.getQty();
                                
                                    if(hpp != 0){
                                    
                                        memo = "inventory : " + csd.getItemName();
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccInv(), sd.getCogs() * sd.getQty(), 0,
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        //journal hpp
                                        memo = "hpp : " + csd.getItemName();
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccCogs(), 0, sd.getCogs() * sd.getQty(),
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                }
                            }
                        }

                        Coa coa = new Coa();
                        Coa coaExpense = new Coa();
                        Coa coaPendapatan = new Coa();
                        double amountExpense = 0;                        

                        if (sales.getType() == DbSales.TYPE_CASH) {
                            if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH){
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(curr.getCoaId());
                                    } catch (Exception e) {}

                                } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                    if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK ) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else {                                        
                                        
                                        if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                            memo = "Credit Card";
                                        } else {
                                            memo = "Debit Card";
                                        }

                                        try {
                                            try {
                                                merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                            } catch (Exception e) {}
                                                
                                            try {
                                                coa = DbCoa.fetchExc(merchant.getCoaId());
                                            } catch (Exception e) {}
                                                
                                            try {
                                                coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                            } catch (Exception e) {}

                                            if (merchant.getPersenExpense() > 0) {
                                                amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                            }
                                            
                                        } catch (Exception e) {}
                                    }
                                }else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER){
                                    memo = "Transfer Bank";
                                    Bank bank = new Bank();
                                    
                                    try{
                                        bank = DbBank.fetchExc(payment.getBankId());
                                    }catch(Exception e){}
                                    
                                    try{
                                        coa = DbCoa.fetchExc(bank.getCoaARId());
                                    }catch(Exception e){}                                    
                                }
                                
                            } else {
                                memo = "Cash";
                                try {
                                    coa = DbCoa.fetchExc(location.getCoaSalesId());
                                } catch (Exception e) {
                                }
                            }

                        } else {
                            try {
                                coa = DbCoa.fetchExc(location.getCoaArId());
                            } catch (Exception e) {}
                            memo = "Credit Sales";
                        }

                        double amountPiutang = 0;
                        if (amountExpense > 0) {
                            String memoPiutang = "";                            
                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                memo = "Biaya Komisi Credit Card";
                                memoPiutang = "Credit Card";
                            } else {
                                memo = "Biaya Komisi Debit Card";
                                memoPiutang = "Debit Card";
                            }
                            
                            if(isFeePaidByComp != 0){ // jika biaya kartu di bayar pembeli
                                
                                if (amountExpense != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), 0, amountExpense,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                    
                                    try {
                                        coaPendapatan = DbCoa.fetchExc(merchant.getPendapatanMerchant());
                                    } catch (Exception e) {}                                    
                                    
                                    DbGl.postJournalDetail(er.getValueIdr(), coaPendapatan.getOID(), 0, amountExpense,
                                        amountExpense, comp.getBookingCurrencyId(), oid, "Pendapatan Merchant", 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);                                    
                                }
                                
                                double piutangCC = amount;
                                amountPiutang = piutangCC;
                                
                                if(piutangCC != 0){
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, piutangCC,
                                        piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }
                                
                            }else{
                                
                                if (amountExpense != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), 0, amountExpense,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }
                                
                                double piutangCC = amount - amountExpense;
                                amountPiutang = piutangCC;
                            
                                if(piutangCC != 0){
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, piutangCC,
                                        piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }
                            }
                            
                        } else {
                            
                            amountPiutang = amount;
                            if(amount != 0){
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amount,
                                    amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            }
                        }

                        Date dt = new Date();
                        String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                                DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                                DbPeriode.colNames[DbPeriode.COL_END_DATE];

                        Vector tempEff = DbPeriode.list(0, 0, wherex, "");
                        Date effectiveDate = new Date();

                        if (tempEff != null && tempEff.size() > 0) {                            
                            effectiveDate = new Date();
                        } else {
                            Periode per = new Periode();
                            if (periodId != 0) {
                                try {
                                    per = DbPeriode.fetchExc(periodId);
                                } catch (Exception e) {
                                    per = DbPeriode.getOpenPeriod();
                                }
                            }
                            effectiveDate = per.getEndDate();
                        }
                        updateStatus(sales.getOID(), userId, effectiveDate);
                        if (sales.getType() == DbSales.TYPE_CREDIT) {
                            postReceivable(sales, intervalDue, amountPiutang);
                        }                        
                        DbGl.optimizedJournal(oid);
                    }
                }
            }
        }
    }
    
    public static String getItemName(long itemId){
        
        CONResultSet crs = null;
        try {

            String sql = "select "+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" from "+DbItemMaster.DB_ITEM_MASTER+" where "+
                    DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = "+itemId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                return rs.getString(DbItemMaster.colNames[DbItemMaster.COL_NAME]);                
            }
            rs.close();

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(crs);
        }
        
        return "";
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

    public static void updateStatus(long salesId, long userId) {

        CONResultSet crs = null;
        try {

            String sql = "UPDATE " + DbSales.DB_SALES + " SET " + DbSales.colNames[DbSales.COL_STATUS] + " = 1," +
                    DbSales.colNames[DbSales.COL_POSTED_STATUS] + " = 1," + DbSales.colNames[DbSales.COL_POSTED_BY_ID] + " = " + userId + ", " +
                    DbSales.colNames[DbSales.COL_EFFECTIVE_DATE] + " = '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + " 00:00:00' " +
                    "," + DbSales.colNames[DbSales.COL_POSTED_DATE] + " = '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "' where " +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = " + salesId;

            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }
    }

    public static void updateStatus(long salesId, long userId, Date effectiveDate) {

        CONResultSet crs = null;
        try {

            String sql = "UPDATE " + DbSales.DB_SALES + " SET " + DbSales.colNames[DbSales.COL_STATUS] + " = 1," +
                    DbSales.colNames[DbSales.COL_POSTED_STATUS] + " = 1," + DbSales.colNames[DbSales.COL_POSTED_BY_ID] + " = " + userId + ", " +
                    DbSales.colNames[DbSales.COL_EFFECTIVE_DATE] + " = '" + JSPFormater.formatDate(effectiveDate, "yyyy-MM-dd") + " 00:00:00' " +
                    "," + DbSales.colNames[DbSales.COL_POSTED_DATE] + " = '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "' where " +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = " + salesId;

            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }
    }

    //add by Roy Andika
    public static void postPaymentReceivable(Sales sales, ExchangeRate eRate, double amount) {

        if (sales.getOID() != 0) {

            Sales sl = new Sales();
            try {
                sl = DbSales.fetchExc(sales.getSalesReturId());
            } catch (Exception e) {
            }

            if (sl.getOID() != 0) {

                String where = "" + DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID] + " = " + sl.getOID();
                Vector vARInvoice = DbARInvoice.list(0, 1, where, null);

                if (vARInvoice != null && vARInvoice.size() > 0) {

                    ARInvoice ar = (ARInvoice) vARInvoice.get(0);
                    ArPayment arPayment = new ArPayment();
                    arPayment.setArInvoiceId(ar.getOID());
                    arPayment.setExchangeRate(eRate.getValueIdr());
                    arPayment.setCurrencyId(eRate.getCurrencyIdrId());
                    arPayment.setAmount(amount);
                    arPayment.setCustomerId(ar.getCustomerId());
                    arPayment.setDate(new Date());
                    arPayment.setProjectTermId(ar.getProjectTermId());
                    arPayment.setCompanyId(sales.getCompanyId());
                    arPayment.setCounter(DbArPayment.getNextCounter(sales.getCompanyId()));
                    arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(sales.getCompanyId()));
                    arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), arPayment.getCompanyId()));
                    arPayment.setProjectId(ar.getProjectId());
                    arPayment.setArCurrencyAmount(amount);
                    arPayment.setTransactionDate(new Date());
                    arPayment.setNotes("Retur sales number : " + sl.getNumber());

                    try {
                        long oid = DbArPayment.insertExc(arPayment);

                        if (oid != 0) {

                            double amountTot = getAmountPayment(ar.getOID());
                            if (amountTot >= ar.getTotal()) {
                                ar.setStatus(I_Project.INV_STATUS_FULL_PAID);
                            } else {
                                ar.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                            }

                            DbARInvoice.updateExc(ar);
                        }
                    } catch (Exception e) {
                    }
                }
            }
        }
    }
    
    
    public static void postARMemo(Sales sales, int day, double amount) {

        if (sales.getOID() != 0) {
            
            Date dueDate = (Date) sales.getDate().clone();

            int date = dueDate.getDate() + day;
            dueDate.setDate(date);
            
            amount = amount * -1;
            ARInvoice ar = new ARInvoice();
            ar.setSalesSource(1);
            ar.setDate(sales.getDate());
            ar.setProjectId(sales.getOID());
            ar.setDueDate(dueDate);
            ar.setTransDate(sales.getDate());
            ar.setCompanyId(sales.getCompanyId());
            ar.setOperatorId(sales.getUserId());
            ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
            ar.setCurrencyId(sales.getCurrencyId());
            ar.setCustomerId(sales.getCustomerId());
            ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
            ar.setDiscount(0);
            ar.setDiscountPercent(sales.getDiscountPercent());
            ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
            ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
            ar.setProjectTermId(sales.getOID());
            ar.setTotal(amount);
            ar.setVat(0);
            ar.setVatAmount(0);
            ar.setVatPercent(0);
            ar.setInvoiceNumber(sales.getNumber());
            ar.setTypeAR(DbARInvoice.TYPE_AR_MEMO);

            try {

                long oid = DbARInvoice.insertExc(ar);

                if (oid != 0) {

                    ARInvoiceDetail ard = new ARInvoiceDetail();

                    ard.setArInvoiceId(oid);
                    ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                    ard.setQty(1);
                    ard.setPrice(amount);
                    ard.setDiscount(0);
                    ard.setTotalAmount(amount);
                    ard.setCompanyId(sales.getCompanyId());

                    try {
                        DbARInvoiceDetail.insertExc(ard);
                    } catch (Exception e) {
                    }

                }
            } catch (Exception e) {
            }
        }
    }

    public static double getAmountPayment(long arInvoiceId) {

        CONResultSet dbrs = null;
        try {

            String sql = "select sum(" + DbArPayment.colNames[DbArPayment.COL_AMOUNT] + ") from " + DbArPayment.DB_AR_PAYMENT +
                    " where " + DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID] + " = " + arInvoiceId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double amount = 0;
            while (rs.next()) {
                amount = rs.getDouble(1);
            }
            rs.close();
            return amount;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }

    public static void insertAp() {

        Vector result = new Vector();
        try {
            result = DbSales.list(0, 0, DbSales.colNames[DbSales.COL_TYPE] + " = 1 and " + DbSales.colNames[DbSales.COL_STATUS] + " = 1", null);

            if (result != null && result.size() > 0) {
                for (int i = 0; i < result.size(); i++) {
                    Sales sales = (Sales) result.get(i);

                    String where = DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID] + " = " + sales.getOID();
                    Vector listAR = DbARInvoice.list(0, 0, where, null);

                    if (listAR == null || listAR.size() <= 0) {
                        System.out.println("Process nomor jurnal : " + sales.getNumber());
                        postReceivable(sales, 7);
                    }
                }

            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }

    public static void updateDueDate() {

        Vector result = new Vector();
        try {

            result = DbARInvoice.listAll();
            if (result != null && result.size() > 0) {
                for (int i = 0; i < result.size(); i++) {

                    ARInvoice arInvoice = (ARInvoice) result.get(i);
                    Date dueDate = (Date) arInvoice.getDate().clone();
                    int date = dueDate.getDate() + 7;
                    dueDate.setDate(date);
                    arInvoice.setDueDate(dueDate);
                    try {
                        DbARInvoice.updateExc(arInvoice);
                    } catch (Exception e) {
                    }
                }

            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }
    
    public static int getJatuhTempo(long customerId) {
        CONResultSet dbrs = null;
        int jatuhTempo = 0;
        try{
            String sql = "select jatuh_tempo from customer where customer_id = "+customerId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();            
            while (rs.next()) {
                jatuhTempo = rs.getInt("jatuh_tempo");
            }
            rs.close();
            
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        
        return jatuhTempo;
    }
    

    public static void postReceivable(Sales sales, int days, double amount) {

        if (sales.getOID() != 0) {
            
            Date dueDate = (Date) sales.getDate().clone();
            int JatuhTempo = getJatuhTempo(sales.getCustomerId());
            int date = dueDate.getDate() + JatuhTempo;
            dueDate.setDate(date);

            ARInvoice ar = new ARInvoice();
            ar.setSalesSource(1);
            ar.setDate(sales.getDate());
            ar.setProjectId(sales.getOID());
            ar.setDueDate(dueDate);
            ar.setTransDate(sales.getDate());
            ar.setCompanyId(sales.getCompanyId());
            ar.setOperatorId(sales.getUserId());
            ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
            ar.setCurrencyId(sales.getCurrencyId());
            ar.setCustomerId(sales.getCustomerId());
            ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
            ar.setDiscount(0);
            ar.setDiscountPercent(sales.getDiscountPercent());
            ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
            ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
            ar.setProjectTermId(sales.getOID());
            ar.setTotal(amount);
            ar.setVat(sales.getVat());
            ar.setVatAmount(sales.getVatAmount());
            ar.setVatPercent(sales.getVatPercent());
            ar.setInvoiceNumber(sales.getNumber());

            try {

                long oid = DbARInvoice.insertExc(ar);
                if (oid != 0) {
                    ARInvoiceDetail ard = new ARInvoiceDetail();
                    ard.setArInvoiceId(oid);
                    ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                    ard.setQty(1);
                    ard.setPrice(amount);
                    ard.setDiscount(0);
                    ard.setTotalAmount(amount);
                    ard.setCompanyId(sales.getCompanyId());

                    try {
                        DbARInvoiceDetail.insertExc(ard);
                    } catch (Exception e) {}
                }
            } catch (Exception e) {
            }
        }
    }

    public static void postReceivable(Sales sales, int day) {

        if (sales.getOID() != 0) {

            double amount = getTotalAmount(sales.getOID());
            double discountAmount = getTotalDiscount(sales.getOID());

            Date dueDate = (Date) sales.getDate().clone();

            int date = dueDate.getDate() + day;
            dueDate.setDate(date);

            ARInvoice ar = new ARInvoice();
            ar.setSalesSource(1);
            ar.setDate(sales.getDate());
            ar.setProjectId(sales.getOID());
            ar.setDueDate(dueDate);
            ar.setTransDate(sales.getDate());
            ar.setCompanyId(sales.getCompanyId());
            ar.setOperatorId(sales.getUserId());
            ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
            ar.setCurrencyId(sales.getCurrencyId());
            ar.setCustomerId(sales.getCustomerId());
            ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
            ar.setDiscount(discountAmount);
            ar.setDiscountPercent(sales.getDiscountPercent());
            ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
            ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
            ar.setProjectTermId(sales.getOID());
            ar.setTotal(amount);
            ar.setVat(sales.getVat());
            ar.setVatAmount(sales.getVatAmount());
            ar.setVatPercent(sales.getVatPercent());
            ar.setInvoiceNumber(sales.getNumber());

            try {

                long oid = DbARInvoice.insertExc(ar);

                if (oid != 0) {
                    ARInvoiceDetail ard = new ARInvoiceDetail();

                    ard.setArInvoiceId(oid);
                    ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                    ard.setQty(1);
                    ard.setPrice(amount + discountAmount);
                    ard.setDiscount(discountAmount);
                    ard.setTotalAmount(amount);
                    ard.setCompanyId(sales.getCompanyId());

                    try {
                        DbARInvoiceDetail.insertExc(ard);
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e) {
            }
        }
    }

    public static void postReceivable(Sales sales, Vector dtls) {

        if (sales.getOID() != 0) {

            double amount = getTotalAmount(sales.getOID());
            double discountAmount = getTotalDiscount(sales.getOID());

            Date dueDate = sales.getDate();
            int date = dueDate.getDate() + 7;
            dueDate.setDate(date);

            ARInvoice ar = new ARInvoice();
            ar.setSalesSource(1);
            ar.setDate(sales.getDate());
            ar.setProjectId(sales.getOID());
            ar.setDueDate(dueDate);
            ar.setTransDate(sales.getDate());
            ar.setCompanyId(sales.getCompanyId());
            ar.setOperatorId(sales.getUserId());
            ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
            ar.setCurrencyId(sales.getCurrencyId());
            ar.setCustomerId(sales.getCustomerId());
            ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
            ar.setDiscount(discountAmount);
            ar.setDiscountPercent(sales.getDiscountPercent());
            ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
            ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
            ar.setProjectTermId(sales.getOID());
            ar.setTotal(amount);
            ar.setVat(sales.getVat());
            ar.setVatAmount(sales.getVatAmount());
            ar.setVatPercent(sales.getVatPercent());
            ar.setInvoiceNumber(sales.getNumber());

            try {

                long oid = DbARInvoice.insertExc(ar);

                if (oid != 0) {
                    ARInvoiceDetail ard = new ARInvoiceDetail();

                    ard.setArInvoiceId(oid);
                    ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                    ard.setQty(1);
                    ard.setPrice(amount + discountAmount);
                    ard.setDiscount(discountAmount);
                    ard.setTotalAmount(amount);
                    ard.setCompanyId(sales.getCompanyId());

                    try {
                        DbARInvoiceDetail.insertExc(ard);
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e) {
            }
        }
    }

    public static Vector getCustomerBySalesCredit(long customerId, long unitUsahaId) {

        String sql = "select distinct c.* from " + DB_SALES + " p " +
                "inner join " + DbCustomer.DB_CUSTOMER + " c " +
                "on c." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = p." + colNames[COL_CUSTOMER_ID];

        String where = "";

        where = " p." + DbSales.colNames[DbSales.COL_TYPE] + "=" + DbSales.TYPE_CREDIT;

        if (customerId != 0) {
            where = " and p." + colNames[COL_CUSTOMER_ID] + "=" + customerId;
        }

        if (unitUsahaId != 0) {
            if (where != null && where.length() > 0) {
                where = where + " and ";
            }

            where = where + " p." + colNames[COL_UNIT_USAHA_ID] + "=" + unitUsahaId;
        }

        if (where != null && where.length() > 0) {
            sql = sql + " where " + where;
        }

        sql = sql + " order by c." + colNames[COL_NAME];


        Vector result = new Vector();

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Customer c = new Customer();
                resultToObject(rs, c);
                result.add(c);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    private static void resultToObject(ResultSet rs, Customer customer) {
        try {

            customer.setOID(rs.getLong(DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]));
            customer.setName(rs.getString(DbCustomer.colNames[DbCustomer.COL_NAME]));
            customer.setType(rs.getInt(DbCustomer.colNames[DbCustomer.COL_TYPE]));
            customer.setAddress1(rs.getString(DbCustomer.colNames[DbCustomer.COL_ADDRESS_1]));
            customer.setAddress2(rs.getString(DbCustomer.colNames[DbCustomer.COL_ADDRESS_2]));
            customer.setCity(rs.getString(DbCustomer.colNames[DbCustomer.COL_CITY]));
            customer.setCountryId(rs.getLong(DbCustomer.colNames[DbCustomer.COL_COUNTRY_ID]));            
            customer.setContactPerson(rs.getString(DbCustomer.colNames[DbCustomer.COL_CONTACT_PERSON]));
            customer.setPosisiContactPerson(rs.getString(DbCustomer.colNames[DbCustomer.COL_POSISI_CONTACT_PERSON]));
            customer.setCountryCode(rs.getString(DbCustomer.colNames[DbCustomer.COL_COUNTRY_CODE]));            
            customer.setAreaCode(rs.getString(DbCustomer.colNames[DbCustomer.COL_AREA_CODE]));
            customer.setPhone(rs.getString(DbCustomer.colNames[DbCustomer.COL_PHONE]));
            customer.setWebsite(rs.getString(DbCustomer.colNames[DbCustomer.COL_WEBSITE]));
            customer.setEmail(rs.getString(DbCustomer.colNames[DbCustomer.COL_EMAIL]));
            customer.setStatus(rs.getString(DbCustomer.colNames[DbCustomer.COL_STATUS]));
            customer.setIndukCustomerId(rs.getLong(DbCustomer.colNames[DbCustomer.COL_INDUK_CUSTOMER_ID]));
            customer.setFax(rs.getString(DbCustomer.colNames[DbCustomer.COL_FAX]));
            customer.setNationalityId(rs.getLong(DbCustomer.colNames[DbCustomer.COL_NATIONALITY_ID]));
            customer.setState(rs.getString(DbCustomer.colNames[DbCustomer.COL_STATE]));
            customer.setCountryName(rs.getString(DbCustomer.colNames[DbCustomer.COL_COUNTRY_NAME]));
            customer.setNationalityName(rs.getString(DbCustomer.colNames[DbCustomer.COL_NATIONALITY_NAME]));            
            customer.setIdType(rs.getString(DbCustomer.colNames[DbCustomer.COL_ID_TYPE]));
            customer.setIdNumber(rs.getString(DbCustomer.colNames[DbCustomer.COL_ID_NUMBER]));                                   
            customer.setDob(rs.getDate(DbCustomer.colNames[DbCustomer.COL_DOB]));
            customer.setInterest(rs.getString(DbCustomer.colNames[DbCustomer.COL_INTEREST]));
            customer.setSalutation(rs.getString(DbCustomer.colNames[DbCustomer.COL_SALUTATION]));
            customer.setDobIgnore(rs.getInt(DbCustomer.colNames[DbCustomer.COL_DOB_IGNORE]));
            customer.setCode(rs.getString(DbCustomer.colNames[DbCustomer.COL_CODE]));
            customer.setPhoneArea(rs.getString(DbCustomer.colNames[DbCustomer.COL_PHONE_AREA]));
            customer.setFaxArea(rs.getString(DbCustomer.colNames[DbCustomer.COL_FAX_AREA]));
            customer.setMiddleName(rs.getString(DbCustomer.colNames[DbCustomer.COL_MIDDLE_NAME]));
            customer.setLastName(rs.getString(DbCustomer.colNames[DbCustomer.COL_LAST_NAME]));
            customer.setContactMiddleName(rs.getString(DbCustomer.colNames[DbCustomer.COL_CONTACT_MIDDLE_NAME]));
            customer.setContactLastName(rs.getString(DbCustomer.colNames[DbCustomer.COL_CONTACT_LAST_NAME]));
            customer.setHp(rs.getString(DbCustomer.colNames[DbCustomer.COL_HP]));
            customer.setZipCode(rs.getString(DbCustomer.colNames[DbCustomer.COL_ZIP_CODE]));            
            customer.setContactPhone(rs.getString(DbCustomer.colNames[DbCustomer.COL_CONTACT_PHONE]));
            customer.setContactPosition(rs.getString(DbCustomer.colNames[DbCustomer.COL_CONTACT_POSITION]));
            customer.setContactEmail(rs.getString(DbCustomer.colNames[DbCustomer.COL_CONTACT_EMAIL]));
            customer.setCompanyId(rs.getLong(DbCustomer.colNames[DbCustomer.COL_COMPANY_ID]));
            customer.setGolPrice(rs.getString(DbCustomer.colNames[DbCustomer.COL_GOL_PRICE]));

        } catch (Exception e) {
        }
    }

    public static Vector getListCreditPayment(String where) {

        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {

            String sql = "select sl." + DbSales.colNames[DbSales.COL_SALES_ID] + " as salesId " +
                    ",sl." + DbSales.colNames[DbSales.COL_DATE] + " as salesDate " +
                    ",sl." + DbSales.colNames[DbSales.COL_NUMBER] + " as salesNumber " +
                    ",sl." + DbSales.colNames[DbSales.COL_NAME] + " as salesName " +
                    ",sl." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " as salesLocation " +
                    ",sl." + DbSales.colNames[DbSales.COL_AMOUNT] + " as salesAmount " +
                    ",sl." + DbSales.colNames[DbSales.COL_USER_ID] + " as userId " +
                    ",sl." + DbSales.colNames[DbSales.COL_COUNTER] + " as counter " +
                    ",sl." + DbSales.colNames[DbSales.COL_CUSTOMER_ID] + " as customerId " +
                    ",sl." + DbSales.colNames[DbSales.COL_NUMBER_PREFIX] + " as prefixNumber " +
                    ",sl." + DbSales.colNames[DbSales.COL_STATUS] + " as status " +
                    ",cr." + DbCreditPayment.colNames[DbCreditPayment.COL_CREDIT_PAYMENT_ID] + " as creditId " +
                    ",cr." + DbCreditPayment.colNames[DbCreditPayment.COL_PAY_DATETIME] + " as paydatetime " +
                    ",cr." + DbCreditPayment.colNames[DbCreditPayment.COL_AMOUNT] + " as creditamount " +
                    " from " + DbSales.DB_SALES + " sl inner join " + DbCreditPayment.DB_CREDIT_PAYMENT + "  cr on sl." + DbSales.colNames[DbSales.COL_SALES_ID] + " = cr." + DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID];

            sql = sql + " where " + where;

            sql = sql + " order by sl." + DbSales.colNames[DbSales.COL_NUMBER] + ",sl." + DbSales.colNames[DbSales.COL_SALES_ID];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {

                SalesPaymentCredit salesPaymentCredit = new SalesPaymentCredit();

                salesPaymentCredit.setSalesId(rs.getLong("salesId"));
                salesPaymentCredit.setNumber(rs.getString("salesNumber"));
                salesPaymentCredit.setDate(rs.getDate("salesDate"));
                salesPaymentCredit.setName(rs.getString("salesName"));
                salesPaymentCredit.setLocationId(rs.getLong("salesLocation"));
                salesPaymentCredit.setAmount(rs.getDouble("salesAmount"));
                salesPaymentCredit.setCreditPaymentId(rs.getLong("creditId"));
                salesPaymentCredit.setPaymentDateTime(rs.getDate("paydatetime"));
                salesPaymentCredit.setAmountCredit(rs.getDouble("creditamount"));
                salesPaymentCredit.setCounter(rs.getInt("counter"));
                salesPaymentCredit.setNumberPrefix(rs.getString("prefixNumber"));
                salesPaymentCredit.setCustomerId(rs.getLong("customerId"));
                salesPaymentCredit.setStatus(rs.getInt("status"));
                lists.add(salesPaymentCredit);

            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static Vector getLocationJournal() {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT pl.* FROM pos_cash_master as cm " +
                    "inner join pos_location as pl on cm.location_id=pl.location_id group by location_id";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Location location = new Location();
                location.setOID(rs.getLong("location_id"));
                location.setName(rs.getString("name"));

                list.add(location);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static Vector getShift(long locationOid, Date tanggal) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT s.*,cc.* FROM `pos_cash_cashier` as cc " +
                    " inner join pos_cash_master as cm on cc.cash_master_id=cm.cash_master_id " +
                    " inner join pos_shift as s on cc.shift_id=s.shift_id " +
                    " where location_id=" + locationOid + " and " +
                    " date_open between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:00") + "' " +
                    " and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' group by cc.cash_cashier_id";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Shift shift = new Shift();
                shift.setOID(rs.getLong("cash_cashier_id"));
                shift.setName(rs.getString("name"));

                list.add(shift);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    
    public static Vector getShift(long locationOid, Date tanggal,int withUser) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT s.*,cc.* FROM `pos_cash_cashier` as cc " +
                    " inner join pos_cash_master as cm on cc.cash_master_id=cm.cash_master_id " +
                    " inner join pos_shift as s on cc.shift_id=s.shift_id " +
                    " where location_id=" + locationOid + " and " +
                    " date_open between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:00") + "' " +
                    " and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' group by cc.cash_cashier_id";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Shift shift = new Shift();
                shift.setOID(rs.getLong("cash_cashier_id"));
                String tmpName = rs.getString("name");
                
                if(withUser == 1){
                    String name = getUserShift(locationOid,tanggal,shift.getOID());
                    if(name != null && name.length() > 0){
                        name = tmpName+" ( "+name+" ) ";
                    }
                    shift.setName(name);
                }else{
                    shift.setName(tmpName);
                }

                list.add(shift);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    
    public static String getUserShift(long locationOid, Date tanggal,long cashCashierId){
        CONResultSet crs = null;
        try{            
            String sql = "select s."+DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]+" as cash_cashier_id,u."+DbUser.colNames[DbUser.COL_FULL_NAME]+" as full_name from "+DbSales.DB_SALES+" s inner join "+DbUser.DB_APP_USER +" u on s."+DbSales.colNames[DbSales.COL_USER_ID]+" = u."+DbUser.colNames[DbUser.COL_USER_ID]+
                    " where s."+DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]+" = "+cashCashierId+" and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal, "yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationOid+" limit 1 ";
             
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                return rs.getString("full_name");                
            }
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return "";
        
    }

    public static double getPaymentCash(long salesOid, int typeP) {
        CONResultSet crs = null;
        double total = 0;
        try {
            String sql = "select sum(amount) as pay from pos_payment where pay_type=" + typeP + " and sales_id=" + salesOid;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble("pay");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return total;
    }
    
    public static MerchantAmount getPayment(long salesOid, int typeP) {
        CONResultSet crs = null;        
        MerchantAmount merchantAmount = new MerchantAmount();
        try {
            String sql = "select "+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" as merchant,sum("+DbPayment.colNames[DbPayment.COL_AMOUNT]+") as pay from pos_payment where pay_type=" + typeP + " and sales_id=" + salesOid;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {                
                merchantAmount.setMerchantId(rs.getLong("merchant"));                
                return merchantAmount;
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return merchantAmount;
    }
    
    
    public static long getMerchant(long salesOid, int typeP) {
        CONResultSet crs = null;                
        try {
            String sql = "select "+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" as merchant from pos_payment where pay_type=" + typeP + " and sales_id=" + salesOid;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {                
                return rs.getLong("merchant");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return 0;
    }

    public static Vector getDataClosingJournal(Date tanggal, long locationId, long cashCashierId, int isProductService) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select p.*, sum(pd.total) as tot , sum(pd.discount_amount) as discount_dt from pos_sales as p " + " inner join pos_sales_detail as pd on p.sales_id=pd.sales_id" + " inner join pos_item_master as it on pd.product_master_id=it.item_master_id " + " where p.date between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:01") + "' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' " + " and it.is_service=" + isProductService + " and p." + DbSales.colNames[DbSales.COL_STATUS] + " = 0 ";

            if (locationId != 0) {
                sql = sql + " and p.location_id=" + locationId;
            }

            if (cashCashierId != 0) {
                sql = sql + " and p.cash_cashier_id=" + cashCashierId;
            }
            sql = sql + " group by p.sales_id order by p.number";

            System.out.println("SQL closing jurnal >> : " + sql);
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;

            SalesClosingJournal salesClosingJournal = new SalesClosingJournal();
            while (rs.next()) {

                cash = rs.getDouble("tot");

                card = getPaymentCash(rs.getLong("sales_id"), DbPayment.PAY_TYPE_CREDIT_CARD);                
                if (card > 0) {
                    card = cash;
                    cash = 0;
                } else {
                    card = 0;
                }
                discount = rs.getDouble("discount_dt");

                if (cash > 0) {
                    amount = cash + discount;
                } else {
                    amount = card + discount;
                }

                retur = 0;
                bon = 0;
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        cash = 0;
                        card = 0;
                        bon = rs.getDouble("tot");
                        amount = bon + discount;
                        break;

                    case 2:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;

                    case 3:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;

                }

                salesClosingJournal = new SalesClosingJournal();
                salesClosingJournal.setSalesId(rs.getLong("sales_id"));
                salesClosingJournal.setSalesReturId(rs.getLong("sales_retur_id"));
                salesClosingJournal.setType(rs.getInt("type"));
                salesClosingJournal.setInvoiceNumber(rs.getString("number"));
                salesClosingJournal.setTglJam(rs.getDate("date"));
                salesClosingJournal.setMember(rs.getString("name"));
                salesClosingJournal.setCash(cash);
                salesClosingJournal.setCCard(card);
                salesClosingJournal.setBon(bon);
                salesClosingJournal.setDiscount(discount);
                salesClosingJournal.setRetur(retur);
                salesClosingJournal.setAmount(amount);

                list.add(salesClosingJournal);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    public static Vector getDataJournal(Date tanggal, long locationId, long cashCashierId, int isProductService){
        CONResultSet crs = null;
        Vector list = new Vector();
        try {            
            String sql = "select p." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id," +
                        " p." + DbSales.colNames[DbSales.COL_TYPE] + " as type, " +
                        " p." + DbSales.colNames[DbSales.COL_SALES_RETUR_ID] + " as sales_retur_id, " +
                        " p." + DbSales.colNames[DbSales.COL_NUMBER] + " as number, " +
                        " p." + DbSales.colNames[DbSales.COL_DATE] + " as date, " +
                        " p." + DbSales.colNames[DbSales.COL_NAME] + " as name, " +
                        
                        " p." + DbSales.colNames[DbSales.COL_GLOBAL_DISKON] + " as g_diskon, " +
                        " p." + DbSales.colNames[DbSales.COL_SERVICE_PERCENT] + " as service, " +
                        " p." + DbSales.colNames[DbSales.COL_VAT_PERCENT] + " as vat, " +
                        " p." + DbSales.colNames[DbSales.COL_BIAYA_KARTU] + " as biaya_kartu, " +
                        " p." + DbSales.colNames[DbSales.COL_DISKON_KARTU] + " as diskon_kartu, " +
                        
                        " sum((pd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+") - pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+" ) as tot , sum(pd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as discount_dt " +
                        " from " + DbSales.DB_SALES + " as p inner join " + DbSalesDetail.DB_SALES_DETAIL + " as pd on " +
                        " p." + DbSales.colNames[DbSales.COL_SALES_ID] + " = pd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " as it on pd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + "=it." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                        " where to_days(p." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') and to_days(p." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') " + " and it." + DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE] + " = " + isProductService + " and p." + DbSales.colNames[DbSales.COL_STATUS] + " = 0 ";

            if (locationId != 0){
                sql = sql + " and p." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }
            
            if (cashCashierId != 0){
                sql = sql + " and p." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }            
            
            sql = sql + " group by p." + DbSales.colNames[DbSales.COL_SALES_ID] + " order by p.number";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double debit = 0;
            double transfer = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;

            SalesClosingJournal salesClosingJournal = new SalesClosingJournal();
            
            while (rs.next()){
                
                cash = rs.getDouble("tot");
                double kwitansi = rs.getDouble("tot");
                double tot = rs.getDouble("tot");
                
                double service = rs.getDouble("service");
                double vat = rs.getDouble("vat");
                double gDiskon = rs.getDouble("g_diskon");                
                long salesId = rs.getLong("sales_id");                
                double biayaKartu = rs.getDouble("biaya_kartu");      
                double diskonKartu = rs.getDouble("diskon_kartu");      
                
                int isFeePaidByComp = SessCreditPayment.isFeeByCompany(salesId);    
                kwitansi = kwitansi - gDiskon;                
                double amountService = 0;     
                
                if(service != 0){
                    amountService = kwitansi * (service/100);                                       
                    kwitansi = kwitansi + amountService;
                }
                
                double amountVAT = 0;
                if(vat != 0){
                    amountVAT = kwitansi * (vat/100);
                    kwitansi = kwitansi + amountVAT;                    
                }
                
                if(isFeePaidByComp != 0){                                        
                    kwitansi = kwitansi + biayaKartu;                                        
                }   
                
                kwitansi = kwitansi - diskonKartu;
                cash = kwitansi;
                card = getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);
                if(card == 0){
                    debit = getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                    
                    if(debit == 0){
                        transfer = getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);                    
                    }
                }
                
                if (card > 0) {
                    card = kwitansi;
                    debit = 0;
                    cash = 0;
                    transfer = 0;
                } else if (debit > 0){
                    card = 0;
                    debit = kwitansi;
                    cash = 0;
                    transfer = 0;
                } else if (transfer > 0){    
                    card = 0;
                    debit = 0;
                    transfer = kwitansi;                    
                    cash = 0;
                }else{
                    card = 0;
                    debit = 0;
                    transfer = 0;
                }
                
                discount = rs.getDouble("discount_dt");
                tot = tot + discount;
                amount = tot;
                
                /*if (cash > 0) {
                    amount = kwitansi + discount;
                } else {
                    if(card > 0){
                        amount = card + discount;
                    }else if(debit > 0){
                        amount = debit + discount;
                    }else if(transfer > 0){
                        amount = transfer + discount;
                    }
                }*/

                retur = 0;
                bon = 0;
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;                        
                        bon = kwitansi;
                        amount = tot;
                        break;

                    case 2:                        
                        cash = kwitansi * -1;
                        card = 0;
                        transfer = 0;
                        retur = tot;
                        amount = 0;
                        break;

                    case 3:
                        cash = kwitansi * -1;
                        card = 0;
                        transfer = 0;
                        retur = tot;
                        amount = 0;
                        break;
                }

                salesClosingJournal = new SalesClosingJournal();
                salesClosingJournal.setSalesId(salesId);
                salesClosingJournal.setSalesReturId(rs.getLong("sales_retur_id"));
                salesClosingJournal.setType(rs.getInt("type"));
                salesClosingJournal.setInvoiceNumber(rs.getString("number"));
                salesClosingJournal.setTglJam(rs.getDate("date"));
                salesClosingJournal.setMember(rs.getString("name"));
                if(card != 0 || debit != 0 || transfer != 0){
                    salesClosingJournal.setCash(0);
                }else{
                    salesClosingJournal.setCash(cash);
                }
                salesClosingJournal.setCCard(card);
                salesClosingJournal.setDCard(debit);
                salesClosingJournal.setTransfer(transfer);
                salesClosingJournal.setBon(bon);
                salesClosingJournal.setDiscount(discount);
                salesClosingJournal.setDiscGlobal(gDiskon);
                salesClosingJournal.setRetur(retur);
                salesClosingJournal.setAmount(amount);
                salesClosingJournal.setVat(amountVAT);
                salesClosingJournal.setService(amountService);
                salesClosingJournal.setCcFee(biayaKartu);
                salesClosingJournal.setDiskonFee(diskonKartu);
                
                Merchant m = getMerchant(salesId);
                salesClosingJournal.setMerchantId(m.getOID());
                salesClosingJournal.setMerchantName(m.getDescription());
                list.add(salesClosingJournal);
                
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    public static Vector getDataClosingV2(Date tanggal, long locationId, long cashCashierId, int isProductService){
        CONResultSet crs = null;
        Vector list = new Vector();
        try {            
            String sql = "select p." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id," +
                        " p." + DbSales.colNames[DbSales.COL_POSTED_STATUS] + " as posted, " +
                        " p." + DbSales.colNames[DbSales.COL_TYPE] + " as type, " +
                        " p." + DbSales.colNames[DbSales.COL_SALES_RETUR_ID] + " as sales_retur_id, " +
                        " p." + DbSales.colNames[DbSales.COL_NUMBER] + " as number, " +
                        " p." + DbSales.colNames[DbSales.COL_DATE] + " as date, " +
                        " p." + DbSales.colNames[DbSales.COL_NAME] + " as name, " +
                        " sum((pd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+") - pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+" ) as tot , sum(pd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as discount_dt " +
                        " from " + DbSales.DB_SALES + " as p inner join " + DbSalesDetail.DB_SALES_DETAIL + " as pd on " +
                        " p." + DbSales.colNames[DbSales.COL_SALES_ID] + " = pd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " as it on pd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + "=it." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                        " where to_days(p." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') and to_days(p." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') ";

            if(isProductService != -1){
                sql = sql + " and it." + DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE] + " = " + isProductService;
            }
            
            if (locationId != 0){
                sql = sql + " and p." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }
            
            if (cashCashierId != 0){
                sql = sql + " and p." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }            
            
            sql = sql + " group by p." + DbSales.colNames[DbSales.COL_SALES_ID] + " order by p.number";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double debit = 0;
            double transfer = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;
            double amountRetur = 0;

            SalesClosingJournal salesClosingJournal = new SalesClosingJournal();
            while (rs.next()){

                cash = rs.getDouble("tot");
                long salesId = rs.getLong("sales_id");
               
                double kembalian = 0;
                try{
                    if(salesId != 0){
                        kembalian = SessClosingSummary.getTotalReturn(salesId);
                    }
                }catch(Exception e){}
                
                cash = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian; 
                card = getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);                
                debit = getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                                    
                transfer = getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);   
                               
                discount = rs.getDouble("discount_dt");
                amount = cash + card + debit + transfer + discount;
                amountRetur = cash + card + debit + transfer + discount;
               
                retur = 0;
                bon = 0;
                
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        bon = rs.getDouble("tot");
                        amount = bon + discount;
                        break;

                    case 2:
                        cash = cash * -1;
                        card = card * -1;
                        transfer = transfer *-1;
                        retur = amountRetur;
                        amount = 0;
                        break;

                    case 3:
                        cash = rs.getDouble("tot") * -1;
                        card = 0;
                        transfer = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;
                }

                salesClosingJournal = new SalesClosingJournal();
                salesClosingJournal.setSalesId(salesId);
                salesClosingJournal.setSalesReturId(rs.getLong("sales_retur_id"));
                salesClosingJournal.setType(rs.getInt("type"));
                salesClosingJournal.setInvoiceNumber(rs.getString("number"));
                salesClosingJournal.setTglJam(rs.getDate("date"));
                salesClosingJournal.setMember(rs.getString("name"));
                salesClosingJournal.setPosted(rs.getInt("posted"));
                salesClosingJournal.setCash(cash);
                salesClosingJournal.setCCard(card);
                salesClosingJournal.setDCard(debit);
                salesClosingJournal.setTransfer(transfer);
                salesClosingJournal.setBon(bon);
                salesClosingJournal.setDiscount(discount);
                salesClosingJournal.setRetur(retur);
                salesClosingJournal.setAmount(amount);
                Merchant m = getMerchant(salesId);
                salesClosingJournal.setMerchantId(m.getOID());
                salesClosingJournal.setMerchantName(m.getDescription());
                list.add(salesClosingJournal);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    
    public static Vector getDataClosing(Date tanggal, long locationId, long cashCashierId){
        CONResultSet crs = null;
        Vector list = new Vector();
        try {           
            
            String where = " to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") = to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') ";           
                       
            if (locationId != 0){
                where = where + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }
            
            if (cashCashierId != 0){
                where = where + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }  
            
            String sql =" select sales_id,number,name,date,amount,discount,location_id,type,sales_retur_id,posted_status,payment_id,currency_id,pay_type,pay_date,pamount,rate,cost_card_amount,cost_card_percent,cc_id,bank_id,merchant_id,type_data from ( "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,1 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s inner join pos_payment p on s.sales_id = p.sales_id group by s.sales_id having count(p.payment_id)=1 "+
                        " union "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,0 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s left join pos_payment p on s.sales_id = p.sales_id where p.sales_id is null group by s.sales_id "+
                        " union "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,2 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s inner join pos_payment p on s.sales_id = p.sales_id group by s.sales_id having count(p.payment_id)>1 "+
                        " ) as x group by sales_id order by number ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double debit = 0;
            double transfer = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;    
            double cashBack = 0;

            SalesClosingJournal salesClosingJournal = new SalesClosingJournal();
            
            while (rs.next()){

                cash = 0;
                card = 0;
                debit = 0;
                transfer = 0;
                bon = 0;
                discount = 0;
                retur = 0;
                amount = 0;
                cashBack = 0;
                
                double tmpcash = rs.getDouble("amount");
                int typeData = rs.getInt("type_data");
                int saleType = rs.getInt("type");
                long salesId = rs.getLong("sales_id");      
                discount = rs.getDouble("discount");
                int payType = rs.getInt("pay_type");
                
                if(typeData == 0){
                    if(saleType == 0){ //cash                        
                        cash = tmpcash;                        
                        amount = cash + discount;                        
                    }else if(saleType == 1){ // credit                     
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        bon = tmpcash;
                        amount = bon + discount;
                        
                    }else if(saleType == 2){ //retur cash
                        
                        Vector amountRetur = getRetur(salesId);
                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}
                        
                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}
                        
                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}
                        
                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}
                        
                        double selisih = xbuy + xretur;
                        
                        cash = selisih;                        
                        if(xretur != 0){
                            retur = xretur*-1;
                        }  
                        discount = xdiscount;
                        amount = amountx;
                        
                    }else if(saleType == 3){ //retur credit
                        bon = tmpcash*-1;
                        cash = 0;  //old
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        amount = (tmpcash + discount)*-1;  
                    }else if(saleType == 9){ //cash                        
                        cashBack = tmpcash;                        
                        amount = cash + discount;                        
                    }
                    
                }else if(typeData == 1){
                    
                    if(saleType == 0){ //cash
                        if(payType == DbPayment.PAY_TYPE_CASH){
                            cash = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                            card = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                            debit = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                            transfer = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CASH_BACK){
                            cashBack = tmpcash;
                        }       
                        amount = (cash + card + debit + transfer + cashBack)+ discount;
                        
                    }else if(saleType == 1){ // credit                     
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        cashBack = 0;
                        bon = tmpcash;
                        amount = bon + discount;
                        
                    }else if(saleType == 2){ //retur cash
                        
                        Vector amountRetur = getRetur(salesId);
                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}
                        
                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}
                        
                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}
                        
                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}
                        
                        double selisih = xbuy + xretur;
                        
                        if(selisih != 0){
                            if(payType == DbPayment.PAY_TYPE_CASH){
                                cash = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                                card = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                                debit = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                                transfer = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_CASH_BACK){
                                cashBack = selisih;
                            }
                        }else{
                            cash = 0;
                            card = 0;
                            debit = 0;
                            transfer = 0;
                            cashBack = 0;
                        }
                        
                        if(xretur != 0){
                            retur = xretur*-1;
                        }     
                        
                        discount = xdiscount;                                                
                        amount = amountx;
                        
                    }else if(saleType == 3){ //retur credit
                        bon = tmpcash*-1;
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        amount = (tmpcash + discount)*-1; 
                    }else if(saleType == 9){ //cash back
                        if(payType == DbPayment.PAY_TYPE_CASH){
                            cash = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                            card = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                            debit = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                            transfer = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CASH_BACK ){
                            cashBack = tmpcash;
                        }    
                        amount = (cash + card + debit + transfer + cashBack)+ discount;                        
                    }
                    
                }else if(typeData == 2){
                    
                    if(saleType == 0){ //cash   
                        
                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}
                
                        cash = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);                
                        debit = getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                                    
                        transfer = getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);  
                        cashBack = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);  
                        
                        amount = tmpcash + discount;
                        
                    }else if(saleType == 1){ // credit                     
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        cashBack = 0;
                        bon = tmpcash;
                        amount = bon + discount;
                        
                    }else if(saleType == 2){ //retur cash
                        
                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}
                        
                        Vector amountRetur = getRetur(salesId);
                        
                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}
                        
                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}
                        
                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}
                        
                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}
                        
                
                        cash = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);                
                        debit = getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                                    
                        transfer = getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);                          
                        cashBack = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);                          
                        
                        retur = xretur;
                        discount = xdiscount;
                        amount = amountx;
                        
                    }else if(saleType == 3){ //retur credit
                        cash = tmpcash*-1;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        cashBack = 0;
                        amount = (tmpcash + discount)*-1; 
                        
                    }else if(saleType == 9){ //cash back
                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}
                
                        cash = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);                
                        debit = getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                                    
                        transfer = getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);  
                        cashBack = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);  
                        
                        amount = tmpcash + discount;                   
                    }
                }

                salesClosingJournal = new SalesClosingJournal();
                salesClosingJournal.setSalesId(salesId);
                salesClosingJournal.setSalesReturId(rs.getLong("sales_retur_id"));
                salesClosingJournal.setType(rs.getInt("type"));
                salesClosingJournal.setInvoiceNumber(rs.getString("number"));
                salesClosingJournal.setTglJam(rs.getDate("date"));
                salesClosingJournal.setMember(rs.getString("name"));
                salesClosingJournal.setPosted(rs.getInt("posted_status"));
                salesClosingJournal.setCash(cash);
                salesClosingJournal.setCCard(card);
                salesClosingJournal.setDCard(debit);
                salesClosingJournal.setTransfer(transfer);
                salesClosingJournal.setBon(bon);
                salesClosingJournal.setDiscount(discount);
                salesClosingJournal.setRetur(retur);
                salesClosingJournal.setAmount(amount);
                salesClosingJournal.setCashBack(cashBack);
                Vector m = getListMerchant(salesId);
                if(m!= null && m.size() > 0){
                    for(int mi = 0; mi < m.size() ; mi++){
                        Merchant merchant = (Merchant)m.get(mi);
                        if(mi == 0){
                            salesClosingJournal.setMerchantId(merchant.getOID());
                            salesClosingJournal.setMerchantName(merchant.getDescription());
                        }else if(mi == 1){
                            salesClosingJournal.setMerchant2Id(merchant.getOID());
                            salesClosingJournal.setMerchant2Name(merchant.getDescription());
                        }else if(mi == 2){
                            salesClosingJournal.setMerchant3Id(merchant.getOID());
                            salesClosingJournal.setMerchant3Name(merchant.getDescription());
                        }                        
                    }
                }
                
                list.add(salesClosingJournal);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    public static Vector getDataDmTransaction(Date tanggal, long locationId, long cashCashierId,long marketingId){
        CONResultSet crs = null;
        Vector list = new Vector();
        try {

            String where = " to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") = to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') ";

            if (marketingId != 0){
                where = where + " and s." + DbSales.colNames[DbSales.COL_MARKETING_ID] + " in (" + marketingId + ") ";
            }

            if (locationId != 0){
                where = where + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }

            if (cashCashierId != 0){
                where = where + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }

            String sql =" select sales_id,number,name,date,amount,discount,location_id,type,sales_retur_id,posted_status,payment_id,currency_id,pay_type,pay_date,pamount,rate,cost_card_amount,cost_card_percent,cc_id,bank_id,merchant_id,type_data from ( "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,1 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s inner join pos_payment p on s.sales_id = p.sales_id group by s.sales_id having count(p.payment_id)=1 "+
                        " union "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,0 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s left join pos_payment p on s.sales_id = p.sales_id where p.sales_id is null group by s.sales_id "+
                        " union "+
                        " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,2 as type_data,p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id "+
                        " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                        " where "+where+" group by s.sales_id) s inner join pos_payment p on s.sales_id = p.sales_id group by s.sales_id having count(p.payment_id)>1 "+
                        " ) as x group by sales_id order by number ";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double debit = 0;
            double transfer = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;
            double cashBack = 0;

            SalesClosingJournal salesClosingJournal = new SalesClosingJournal();

            while (rs.next()){

                cash = 0;
                card = 0;
                debit = 0;
                transfer = 0;
                bon = 0;
                discount = 0;
                retur = 0;
                amount = 0;
                cashBack = 0;

                double tmpcash = rs.getDouble("amount");
                int typeData = rs.getInt("type_data");
                int saleType = rs.getInt("type");
                long salesId = rs.getLong("sales_id");
                discount = rs.getDouble("discount");
                int payType = rs.getInt("pay_type");

                if(typeData == 0){
                    if(saleType == 0){ //cash
                        cash = tmpcash;
                        amount = cash + discount;
                    }else if(saleType == 1){ // credit
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        bon = tmpcash;
                        amount = bon + discount;

                    }else if(saleType == 2){ //retur cash

                        Vector amountRetur = getRetur(salesId);
                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}

                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}

                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}

                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}

                        double selisih = xbuy + xretur;

                        cash = selisih;
                        if(xretur != 0){
                            retur = xretur*-1;
                        }
                        discount = xdiscount;
                        amount = amountx;

                    }else if(saleType == 3){ //retur credit
                        bon = tmpcash*-1;
                        cash = 0;  //old
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        amount = (tmpcash + discount)*-1;
                    }else if(saleType == 9){ //cash
                        cashBack = tmpcash;
                        amount = cash + discount;
                    }

                }else if(typeData == 1){

                    if(saleType == 0){ //cash
                        if(payType == DbPayment.PAY_TYPE_CASH){
                            cash = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                            card = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                            debit = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                            transfer = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CASH_BACK){
                            cashBack = tmpcash;
                        }
                        amount = (cash + card + debit + transfer + cashBack)+ discount;

                    }else if(saleType == 1){ // credit
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        cashBack = 0;
                        bon = tmpcash;
                        amount = bon + discount;

                    }else if(saleType == 2){ //retur cash

                        Vector amountRetur = getRetur(salesId);
                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}

                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}

                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}

                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}

                        double selisih = xbuy + xretur;

                        if(selisih != 0){
                            if(payType == DbPayment.PAY_TYPE_CASH){
                                cash = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                                card = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                                debit = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                                transfer = selisih;
                            }else if(payType == DbPayment.PAY_TYPE_CASH_BACK){
                                cashBack = selisih;
                            }
                        }else{
                            cash = 0;
                            card = 0;
                            debit = 0;
                            transfer = 0;
                            cashBack = 0;
                        }

                        if(xretur != 0){
                            retur = xretur*-1;
                        }

                        discount = xdiscount;
                        amount = amountx;

                    }else if(saleType == 3){ //retur credit
                        bon = tmpcash*-1;
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        amount = (tmpcash + discount)*-1;
                    }else if(saleType == 9){ //cash back
                        if(payType == DbPayment.PAY_TYPE_CASH){
                            cash = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CREDIT_CARD){
                            card = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_DEBIT_CARD){
                            debit = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_TRANSFER){
                            transfer = tmpcash;
                        }else if(payType == DbPayment.PAY_TYPE_CASH_BACK ){
                            cashBack = tmpcash;
                        }
                        amount = (cash + card + debit + transfer + cashBack)+ discount;
                    }

                }else if(typeData == 2){

                    if(saleType == 0){ //cash

                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}

                        cash = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);
                        debit = getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);
                        transfer = getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);
                        cashBack = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);

                        amount = tmpcash + discount;

                    }else if(saleType == 1){ // credit
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        cashBack = 0;
                        bon = tmpcash;
                        amount = bon + discount;

                    }else if(saleType == 2){ //retur cash

                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}

                        Vector amountRetur = getRetur(salesId);

                        double xbuy = 0;
                        double xretur = 0;
                        double xdiscount = 0;
                        double amountx = 0;
                        try{
                            xbuy = Double.parseDouble(""+amountRetur.get(1));
                        }catch(Exception e){}

                        try{
                            xretur = Double.parseDouble(""+amountRetur.get(2));
                        }catch(Exception e){}

                        try{
                            xdiscount = Double.parseDouble(""+amountRetur.get(3));
                        }catch(Exception e){}

                        try{
                            amountx = Double.parseDouble(""+amountRetur.get(4));
                        }catch(Exception e){}


                        cash = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);
                        debit = getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);
                        transfer = getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);
                        cashBack = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);

                        retur = xretur;
                        discount = xdiscount;
                        amount = amountx;

                    }else if(saleType == 3){ //retur credit
                        cash = tmpcash*-1;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        retur = tmpcash;
                        cashBack = 0;
                        amount = (tmpcash + discount)*-1;

                    }else if(saleType == 9){ //cash back
                        double kembalian = 0;
                        try{
                            if(salesId != 0){
                                kembalian = SessClosingSummary.getTotalReturn(salesId);
                            }
                        }catch(Exception e){}

                        cash = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH) - kembalian;
                        card = getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);
                        debit = getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);
                        transfer = getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);
                        cashBack = getPaymentCash(salesId, DbPayment.PAY_TYPE_CASH_BACK);

                        amount = tmpcash + discount;
                    }
                }

                salesClosingJournal = new SalesClosingJournal();
                salesClosingJournal.setSalesId(salesId);
                salesClosingJournal.setSalesReturId(rs.getLong("sales_retur_id"));
                salesClosingJournal.setType(rs.getInt("type"));
                salesClosingJournal.setInvoiceNumber(rs.getString("number"));
                salesClosingJournal.setTglJam(rs.getDate("date"));
                salesClosingJournal.setMember(rs.getString("name"));
                salesClosingJournal.setPosted(rs.getInt("posted_status"));
                salesClosingJournal.setCash(cash);
                salesClosingJournal.setCCard(card);
                salesClosingJournal.setDCard(debit);
                salesClosingJournal.setTransfer(transfer);
                salesClosingJournal.setBon(bon);
                salesClosingJournal.setDiscount(discount);
                salesClosingJournal.setRetur(retur);
                salesClosingJournal.setAmount(amount);
                salesClosingJournal.setCashBack(cashBack);
                Vector m = getListMerchant(salesId);
                if(m!= null && m.size() > 0){
                    for(int mi = 0; mi < m.size() ; mi++){
                        Merchant merchant = (Merchant)m.get(mi);
                        if(mi == 0){
                            salesClosingJournal.setMerchantId(merchant.getOID());
                            salesClosingJournal.setMerchantName(merchant.getDescription());
                        }else if(mi == 1){
                            salesClosingJournal.setMerchant2Id(merchant.getOID());
                            salesClosingJournal.setMerchant2Name(merchant.getDescription());
                        }else if(mi == 2){
                            salesClosingJournal.setMerchant3Id(merchant.getOID());
                            salesClosingJournal.setMerchant3Name(merchant.getDescription());
                        }
                    }
                }

                list.add(salesClosingJournal);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
    public static Vector getRetur(long salesId){
        CONResultSet crs = null;
        try{
            String sql = " select sales_id,sum(amount) as x_amount,sum(buy) as x_buy,sum(retur) as x_retur,sum(discount_amount) as discount_amount from " +
                    "(select s.sales_id as sales_id,sum(sd.qty * sd.selling_price)*-1 as amount,0 as buy,sum((sd.qty * sd.selling_price)-sd.discount_amount)*-1 as retur,sum(sd.discount_amount)*-1 as discount_amount from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_id = "+salesId+" and sd.qty > 0 group by s.sales_id " +
                    " union "+
                    " select s.sales_id as sales_id,sum(sd.qty * sd.selling_price)*-1 as amount,sum((sd.qty * sd.selling_price)-sd.discount_amount)*-1 as buy,0 as retur,sum(sd.discount_amount)*-1 as discount_amount from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id where s.sales_id = "+salesId+" and sd.qty < 0 group by s.sales_id )as x group by sales_id ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()){
                Vector result = new Vector();
                long salesOid = 0;
                double buy = 0;
                double retur = 0;
                double discount = 0;
                double amount = 0;
                try{
                    salesOid = rs.getLong("sales_id");
                    buy = rs.getDouble("x_buy");
                    retur = rs.getDouble("x_retur");                    
                    discount = rs.getDouble("discount_amount");                    
                    amount = rs.getDouble("x_amount");                    
                }catch(Exception e){}
                
                result.add(""+salesOid);
                result.add(""+buy);
                result.add(""+retur);                
                result.add(""+discount);  
                result.add(""+amount);  
                
                return result;
            }            
                         
        }catch(Exception e){}
        finally {
            CONResultSet.close(crs);
        }
        
        return null;
    }
    
    public static Merchant getMerchant(long salesId){
        CONResultSet crs = null;
        Merchant m = new Merchant();
        try{
            String sql = "select m."+DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID]+" as merchant_id,m."+DbMerchant.colNames[DbMerchant.COL_DESCRIPTION]+" as name from "+DbPayment.DB_PAYMENT+" pp inner join "+DbMerchant.DB_MERCHANT+" m on pp."+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" = m."+DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID]+" where pp."+DbPayment.colNames[DbPayment.COL_SALES_ID]+"="+salesId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()){
                m.setOID(rs.getLong("merchant_id"));
                m.setDescription(rs.getString("name"));
                return m;
            }
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return m;
    }
    
    public static Vector getListMerchant(long salesId){
        CONResultSet crs = null;
        
        try{
            String sql = "select m."+DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID]+" as merchant_id,m."+DbMerchant.colNames[DbMerchant.COL_DESCRIPTION]+" as name from "+DbPayment.DB_PAYMENT+" pp inner join "+DbMerchant.DB_MERCHANT+" m on pp."+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" = m."+DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID]+" where pp."+DbPayment.colNames[DbPayment.COL_SALES_ID]+"="+salesId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while (rs.next()){
                Merchant m = new Merchant();
                m.setOID(rs.getLong("merchant_id"));
                m.setDescription(rs.getString("name"));
                result.add(m);
            }
            return result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return null;
    }

    public static void insertPaymentCrd(long userId) {
        try {

            String where = DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_RETUR_CREDIT + " and " + DbSales.colNames[DbSales.COL_STATUS] + " = 1 and " + DbSales.colNames[DbSales.COL_SALES_RETUR_ID] + " != 0 ";
            Vector result = DbSales.list(0, 0, where, null);
            Company comp = DbCompany.getCompany();
            ExchangeRate er = DbExchangeRate.getStandardRate();

            if (result != null && result.size() > 0) {

                for (int i = 0; i < result.size(); i++) {

                    Sales sales = (Sales) result.get(i);

                    String wARInv = DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID] + " = " + sales.getSalesReturId();

                    Sales salesInduk = DbSales.fetchExc(sales.getSalesReturId());

                    try {
                        Vector vAR = DbARInvoice.list(0, 0, wARInv, null);

                        if (vAR != null && vAR.size() > 0) {

                            ARInvoice arInvoice = (ARInvoice) vAR.get(0);

                            ArPayment arPayment = new ArPayment();

                            String whereCp = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + " = " + sales.getOID();
                            Vector vCrdPayment = new Vector();
                            vCrdPayment = DbCreditPayment.list(0, 0, whereCp, null);
                            double totPayment = 0;

                            if (vCrdPayment != null && vCrdPayment.size() > 0) {

                                for (int iCrd = 0; iCrd < vCrdPayment.size(); iCrd++) {

                                    CreditPayment crdP = (CreditPayment) vCrdPayment.get(iCrd);
                                    totPayment = totPayment + crdP.getAmount();
                                    arPayment.setArInvoiceId(arInvoice.getOID());
                                    arPayment.setExchangeRate(er.getValueIdr());
                                    arPayment.setCurrencyId(comp.getBookingCurrencyId());
                                    arPayment.setAmount(crdP.getAmount());
                                    arPayment.setArCurrencyAmount(crdP.getAmount());
                                    arPayment.setCustomerId(arInvoice.getCustomerId());
                                    arPayment.setDate(new Date());
                                    arPayment.setProjectTermId(arInvoice.getProjectTermId());
                                    arPayment.setCompanyId(arInvoice.getCompanyId());
                                    arPayment.setCounter(DbArPayment.getNextCounter(sales.getCompanyId()));
                                    arPayment.setJournalNumberPrefix(DbArPayment.getNumberPrefix(sales.getCompanyId()));
                                    arPayment.setJournalNumber(DbArPayment.getNextNumber(arPayment.getCounter(), arPayment.getCompanyId()));
                                    arPayment.setProjectId(arInvoice.getProjectId());
                                    arPayment.setTransactionDate(sales.getDate());
                                    arPayment.setNotes("Payment Credit invoice : " + salesInduk.getNumber());

                                    long oidAr = DbArPayment.insertExc(arPayment);

                                    if (oidAr != 0) {
                                        updateStatusPayCredit(crdP.getOID(), userId);
                                    }

                                    if (totPayment >= arInvoice.getTotal()) {
                                        arInvoice.setStatus(I_Project.INV_STATUS_FULL_PAID);
                                    } else {
                                        arInvoice.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                                    }
                                    DbARInvoice.updateExc(arInvoice);
                                }
                            }
                        }
                    } catch (Exception e) {
                    }
                }
            }
        } catch (Exception e) {
        }
    }

    public static Vector listNeedPosting(long locationId) {
        CONResultSet crs = null;
        Vector result = new Vector();
        Location location = new Location();
        try {
            location = DbLocation.fetchExc(locationId);
        } catch (Exception e) {
        }

        try {

            String sql = "select " + DbSales.colNames[DbSales.COL_DATE] + " as dtTrans, count(" + DbSales.COL_SALES_ID + ") as mak from " + DbSales.DB_SALES + " where " + DbSales.colNames[DbSales.COL_STATUS] + " = 0 and " + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId + " group by to_days(" + DbSales.colNames[DbSales.COL_DATE] + ") order by " + DbSales.colNames[DbSales.COL_DATE];
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                NeedPosting nc = new NeedPosting();
                nc.setCountData(rs.getInt("mak"));
                nc.setLocationName(location.getName());
                nc.setDateTransaction(rs.getDate("dtTrans"));
                result.add(nc);
            }
            return result;
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return null;
    }
    
    public static double getLastPrice(long locationId,long itemMasterId,Date endDate){
        
        CONResultSet crs = null;
        
        try{
            
            String sql = "select sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+" from "+DbSalesDetail.DB_SALES_DETAIL+" sd inner join "+
                    DbSales.DB_SALES+" s on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" = s."+DbSales.colNames[DbSales.COL_SALES_ID];
            
            String where = " to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") <= to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') ";
            
            if(locationId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where + " s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId;
            }
            
            if(itemMasterId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where + " sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = "+itemMasterId;
            }
            
            sql = sql +" where "+where+" order by s."+DbSales.colNames[DbSales.COL_DATE]+" desc limit 0,1";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                double salesPrice = rs.getDouble(1);
                return salesPrice;
                
            }            
            return 0;
        }catch(Exception e){}
        finally{
            CONResultSet.close(crs);
        }
        return 0;
    }
    
    public static double getLastCOGS(long locationId,long itemMasterId,Date endDate){
        
        CONResultSet crs = null;
        
        try{
            
            String sql = "select sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+" from "+DbSalesDetail.DB_SALES_DETAIL+" sd inner join "+
                    DbSales.DB_SALES+" s on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" = s."+DbSales.colNames[DbSales.COL_SALES_ID];
            
            String where = " to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") <= to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') ";
            
            if(locationId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where + " s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId;
            }
            
            if(itemMasterId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where + " sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = "+itemMasterId;
            }
            
            sql = sql +" where "+where+" order by s."+DbSales.colNames[DbSales.COL_DATE]+" desc limit 0,1";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                double cogs = rs.getDouble(1);
                return cogs;
            }
            
        }catch(Exception e){}
        finally{
            CONResultSet.close(crs);
        }
        return 0;
    }

    public static Vector getDataClosingVoucher(Date tanggal, long locationId, long cashCashierId) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String where = " to_days(s." + colNames[1] + ") = to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') ";

            if (locationId != 0) {
                where = where + " and s." + colNames[45] + " =" + locationId;
            }

            if (cashCashierId != 0) {
                where = where + " and s." + colNames[47] + " = " + cashCashierId;
            }

            String sql = " select sales_id,number,name,date,amount,discount,location_id,type,sales_retur_id,posted_status,payment_id,currency_id,pay_type,pay_date,pamount,rate,cost_card_amount,cost_card_percent,cc_id,bank_id,merchant_id,type_data from " +
                    "(  select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,1 as type_data," +
                    "p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id," +
                    "p.merchant_id as merchant_id  from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id," +
                    "s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id  where " + where + " group by s.sales_id) s inner join pos_payment p on s.sales_id = p.sales_id group by s.sales_id having count(p.payment_id)=1 " +
                    " union all " +
                    " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,0 as type_data," +
                    "p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id," +
                    "p.merchant_id as merchant_id " + " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id," +
                    "s.posted_status as posted_status from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " + " where " + where + " group by s.sales_id) s left join pos_payment p on s.sales_id = p.sales_id where p.sales_id is null group by s.sales_id " +
                    " union all " +
                    " select s.sales_id as sales_id,s.number as number,s.name as name,s.date as date,s.amount as amount,s.discount as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status,2 as type_data," +
                    "p.payment_id as payment_id,p.currency_id as currency_id,p.pay_type as pay_type,p.pay_date as pay_date,sum(p.amount) as pamount,p.rate as rate,p.cost_card_amount as cost_card_amount,p.cost_card_percent as cost_card_percent,p.cc_id as cc_id,p.bank_id as bank_id,p.merchant_id as merchant_id " +
                    " from (select s.sales_id,s.number,s.name,s.date as date,sum((sd.qty * sd.selling_price)-sd.discount_amount) as amount,sum(sd.discount_amount) as discount,s.location_id as location_id,s.type as type,s.sales_retur_id as sales_retur_id,s.posted_status as posted_status from pos_sales s " +
                    "inner join pos_sales_detail sd on s.sales_id = sd.sales_id " + " where " + where + " group by s.sales_id) s inner join pos_payment p on s.sales_id = p.sales_id group by s.sales_id having count(p.payment_id)>1 " +
                    " ) as x group by sales_id order by number ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0.0;
            double card = 0.0;
            double debit = 0.0;
            double transfer = 0.0;
            double bon = 0.0;
            double discount = 0.0;
            double retur = 0.0;
            double amount = 0.0;
            double cashBack = 0.0;
            double voucher = 0.0;
            double difference = 0.0;

            SalesClosingJournal salesClosingJournal = new SalesClosingJournal();

            while (rs.next()) {
                cash = 0.0D;
                card = 0.0D;
                debit = 0.0D;
                transfer = 0.0D;
                bon = 0.0D;
                discount = 0.0D;
                retur = 0.0D;
                amount = 0.0D;
                cashBack = 0.0D;
                voucher = 0.0D;
                difference = 0.0D;

                double tmpcash = rs.getDouble("amount");
                int typeData = 2;
                int saleType = rs.getInt("type");
                long salesId = rs.getLong("sales_id");
                discount = rs.getDouble("discount");
                int payType = rs.getInt("pay_type");

                if (typeData == 0) {
                    if (saleType == 0) {
                        cash = tmpcash;
                        amount = cash + discount;
                    } else if (saleType == 1) {
                        cash = 0.0D;
                        card = 0.0D;
                        debit = 0.0D;
                        transfer = 0.0D;
                        voucher = 0.0D;
                        difference = 0.0D;
                        bon = tmpcash;
                        amount = bon + discount;
                    } else if (saleType == 2) {
                        Vector amountRetur = getRetur(salesId);
                        double xbuy = 0.0D;
                        double xretur = 0.0D;
                        double xdiscount = 0.0D;
                        double amountx = 0.0D;
                        try {
                            xbuy = Double.parseDouble("" + amountRetur.get(1));
                        } catch (Exception e) {
                        }
                        try {
                            xretur = Double.parseDouble("" + amountRetur.get(2));
                        } catch (Exception e) {
                        }
                        try {
                            xdiscount = Double.parseDouble("" + amountRetur.get(3));
                        } catch (Exception e) {
                        }
                        try {
                            amountx = Double.parseDouble("" + amountRetur.get(4));
                        } catch (Exception e) {
                        }
                        double selisih = xbuy + xretur;

                        cash = selisih;
                        if (xretur != 0.0D) {
                            retur = xretur * -1.0D;
                        }
                        discount = xdiscount;
                        amount = amountx;
                    } else if (saleType == 3) {
                        bon = tmpcash * -1.0D;
                        cash = 0.0D;
                        card = 0.0D;
                        debit = 0.0D;
                        transfer = 0.0D;
                        voucher = 0.0D;
                        difference = 0.0D;
                        retur = tmpcash;
                        amount = (tmpcash + discount) * -1.0D;
                    } else if (saleType == 9) {
                        cashBack = tmpcash;
                        amount = cash + discount;
                    }
                } else if (typeData == 1) {
                    if (saleType == 0) {
                        if (payType == 0) {
                            cash = tmpcash;
                        } else if (payType == 1) {
                            card = tmpcash;
                        } else if (payType == 2) {
                            debit = tmpcash;
                        } else if (payType == 3) {
                            transfer = tmpcash;
                        } else if (payType == 9) {
                            cashBack = tmpcash;
                        } else if (payType == 4) {
                            voucher = tmpcash;
                        }
                        amount = cash + card + debit + transfer + cashBack + voucher + discount;
                    } else if (saleType == 1) {
                        cash = 0.0D;
                        card = 0.0D;
                        debit = 0.0D;
                        transfer = 0.0D;
                        cashBack = 0.0D;
                        voucher = 0.0D;
                        difference = 0.0D;
                        bon = tmpcash;
                        amount = bon + discount;
                    } else if (saleType == 2) {
                        Vector amountRetur = getRetur(salesId);
                        double xbuy = 0.0D;
                        double xretur = 0.0D;
                        double xdiscount = 0.0D;
                        double amountx = 0.0D;
                        try {
                            xbuy = Double.parseDouble("" + amountRetur.get(1));
                        } catch (Exception e) {
                        }
                        try {
                            xretur = Double.parseDouble("" + amountRetur.get(2));
                        } catch (Exception e) {
                        }
                        try {
                            xdiscount = Double.parseDouble("" + amountRetur.get(3));
                        } catch (Exception e) {
                        }
                        try {
                            amountx = Double.parseDouble("" + amountRetur.get(4));
                        } catch (Exception e) {
                        }
                        double selisih = xbuy + xretur;

                        if (selisih != 0.0D) {
                            if (payType == 0) {
                                cash = selisih;
                            } else if (payType == 1) {
                                card = selisih;
                            } else if (payType == 2) {
                                debit = selisih;
                            } else if (payType == 3) {
                                transfer = selisih;
                            } else if (payType == 9) {
                                cashBack = selisih;
                            } else if (payType == 4) {
                                voucher = selisih;
                            }
                        } else {
                            cash = 0.0D;
                            card = 0.0D;
                            debit = 0.0D;
                            transfer = 0.0D;
                            cashBack = 0.0D;
                            voucher = 0.0D;
                            difference = 0.0D;
                        }

                        if (xretur != 0.0D) {
                            retur = xretur * -1.0D;
                        }

                        discount = xdiscount;
                        amount = amountx;
                    } else if (saleType == 3) {
                        bon = tmpcash * -1.0D;
                        cash = 0.0D;
                        card = 0.0D;
                        debit = 0.0D;
                        transfer = 0.0D;
                        voucher = 0.0D;
                        difference = 0.0D;
                        retur = tmpcash;
                        amount = (tmpcash + discount) * -1.0D;
                    } else if (saleType == 9) {
                        if (payType == 0) {
                            cash = tmpcash;
                        } else if (payType == 1) {
                            card = tmpcash;
                        } else if (payType == 2) {
                            debit = tmpcash;
                        } else if (payType == 3) {
                            transfer = tmpcash;
                        } else if (payType == 9) {
                            cashBack = tmpcash;
                        } else if (payType == 4) {
                            voucher = tmpcash;
                        }
                        amount = cash + card + debit + transfer + cashBack + voucher + discount;
                    }
                } else if (typeData == 2) {
                    if (saleType == 0) {
                        double kembalian = 0.0D;
                        int typeRet = 0;
                        try {
                            if (salesId != 0L) {
                                kembalian = com.project.ccs.session.SessClosingSummary.getTotalReturn(salesId);
                                Vector listRet = new Vector();
                                listRet = DbReturnPayment.list(0, 0, " sales_id=" + salesId, "");
                                ReturnPayment rt = (ReturnPayment) listRet.get(0);





                                cash = getPaymentCash(salesId, 0) - kembalian;
                                difference = 0.0D;
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }


                        card = getPaymentCash(salesId, 1);
                        debit = getPaymentCash(salesId, 2);
                        transfer = getPaymentCash(salesId, 3);
                        cashBack = getPaymentCash(salesId, 9);
                        voucher = getPaymentCash(salesId, 4);


                        amount = tmpcash + discount;
                    } else if (saleType == 1) {
                        cash = 0.0D;
                        card = 0.0D;
                        debit = 0.0D;
                        transfer = 0.0D;
                        cashBack = 0.0D;
                        voucher = 0.0D;
                        difference = 0.0D;
                        bon = tmpcash;
                        amount = bon + discount;
                    } else if (saleType == 2) {
                        double kembalian = 0.0D;
                        int typeRet = 0;
                        try {
                            if (salesId != 0L) {
                                kembalian = com.project.ccs.session.SessClosingSummary.getTotalReturn(salesId);
                                Vector listRet = new Vector();
                                listRet = DbReturnPayment.list(0, 0, " sales_id=" + salesId, "");
                                ReturnPayment rt = (ReturnPayment) listRet.get(0);





                                cash = getPaymentCash(salesId, 0) - kembalian;
                                difference = 0.0D;
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        Vector amountRetur = getRetur(salesId);

                        double xbuy = 0.0D;
                        double xretur = 0.0D;
                        double xdiscount = 0.0D;
                        double amountx = 0.0D;
                        try {
                            xbuy = Double.parseDouble("" + amountRetur.get(1));
                        } catch (Exception e) {
                        }
                        try {
                            xretur = Double.parseDouble("" + amountRetur.get(2));
                        } catch (Exception e) {
                        }
                        try {
                            xdiscount = Double.parseDouble("" + amountRetur.get(3));
                        } catch (Exception e) {
                        }
                        try {
                            amountx = Double.parseDouble("" + amountRetur.get(4));
                        } catch (Exception e) {
                        }


                        card = getPaymentCash(salesId, 1);
                        debit = getPaymentCash(salesId, 2);
                        transfer = getPaymentCash(salesId, 3);
                        cashBack = getPaymentCash(salesId, 9);
                        voucher = getPaymentCash(salesId, 4);


                        retur = xretur;
                        discount = xdiscount;
                        amount = amountx;
                    } else if (saleType == 3) {
                        cash = tmpcash * -1.0D;
                        card = 0.0D;
                        debit = 0.0D;
                        transfer = 0.0D;
                        voucher = 0.0D;
                        difference = 0.0D;
                        retur = tmpcash;
                        cashBack = 0.0D;
                        amount = (tmpcash + discount) * -1.0D;
                    } else if (saleType == 9) {
                        double kembalian = 0.0D;
                        int typeRet = 0;
                        try {
                            if (salesId != 0L) {
                                kembalian = com.project.ccs.session.SessClosingSummary.getTotalReturn(salesId);
                                Vector listRet = new Vector();
                                listRet = DbReturnPayment.list(0, 0, " sales_id=" + salesId, "");
                                ReturnPayment rt = (ReturnPayment) listRet.get(0);





                                cash = getPaymentCash(salesId, 0) - kembalian;
                                difference = 0.0D;
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }


                        card = getPaymentCash(salesId, 1);
                        debit = getPaymentCash(salesId, 2);
                        transfer = getPaymentCash(salesId, 3);
                        cashBack = getPaymentCash(salesId, 9);
                        voucher = getPaymentCash(salesId, 4);


                        amount = tmpcash + discount;
                    }
                }

                salesClosingJournal = new SalesClosingJournal();
                salesClosingJournal.setSalesId(salesId);
                salesClosingJournal.setSalesReturId(rs.getLong("sales_retur_id"));
                salesClosingJournal.setType(rs.getInt("type"));
                salesClosingJournal.setInvoiceNumber(rs.getString("number"));
                salesClosingJournal.setTglJam(rs.getDate("date"));
                salesClosingJournal.setMember(rs.getString("name"));
                salesClosingJournal.setPosted(rs.getInt("posted_status"));
                salesClosingJournal.setCash(cash);
                salesClosingJournal.setCCard(card);
                salesClosingJournal.setDCard(debit);
                salesClosingJournal.setVoucher(voucher);
                salesClosingJournal.setDifference(difference); 
                salesClosingJournal.setTransfer(transfer);
                salesClosingJournal.setBon(bon);
                salesClosingJournal.setDiscount(discount);
                salesClosingJournal.setRetur(retur);
                salesClosingJournal.setAmount(amount);
                salesClosingJournal.setCashBack(cashBack);
                Vector m = getListMerchant(salesId);
                if ((m != null) && (m.size() > 0)) {
                    for (int mi = 0; mi < m.size(); mi++) {
                        Merchant merchant = (Merchant) m.get(mi);
                        if (mi == 0) {
                            salesClosingJournal.setMerchantId(merchant.getOID());
                            salesClosingJournal.setMerchantName(merchant.getDescription());
                        } else if (mi == 1) {
                            salesClosingJournal.setMerchant2Id(merchant.getOID());
                            salesClosingJournal.setMerchant2Name(merchant.getDescription());
                        } else if (mi == 2) {
                            salesClosingJournal.setMerchant3Id(merchant.getOID());
                            salesClosingJournal.setMerchant3Name(merchant.getDescription());
                        }
                    }
                }

                list.add(salesClosingJournal);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
}
