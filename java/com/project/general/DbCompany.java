package com.project.general;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class DbCompany extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_COMPANY = "company";
    public static final int COL_COMPANY_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_SERIAL_NUMBER = 2;
    public static final int COL_ADDRESS = 3;
    public static final int COL_FISCAL_YEAR = 4;
    public static final int COL_END_FISCAL_MONTH = 5;
    public static final int COL_ENTRY_START_MONTH = 6;
    public static final int COL_NUMBER_OF_PERIOD = 7;
    public static final int COL_CASH_RECEIVE_CODE = 8;
    public static final int COL_PETTYCASH_PAYMENT_CODE = 9;
    public static final int COL_PETTYCASH_REPLACE_CODE = 10;
    public static final int COL_BANK_DEPOSIT_CODE = 11;
    public static final int COL_BANK_PAYMENT_PO_CODE = 12;
    public static final int COL_BANK_PAYMENT_NONPO_CODE = 13;
    public static final int COL_PURCHASE_ORDER_CODE = 14;
    public static final int COL_GENERAL_LEDGER_CODE = 15;
    public static final int COL_MAX_PETTYCASH_REPLENIS = 16;
    public static final int COL_MAX_PETTYCASH_TRANSACTION = 17;
    public static final int COL_BOOKING_CURRENCY_CODE = 18;
    public static final int COL_BOOKING_CURRENCY_ID = 19;
    public static final int COL_SYSTEM_LOCATION = 20;
    public static final int COL_ACTIVATION_CODE = 21;
    public static final int COL_SYSTEM_LOCATION_CODE = 22;
    public static final int COL_CONTACT = 23;
    public static final int COL_ADDRESS2 = 24;
    public static final int COL_INVOICE_CODE = 25;
    public static final int COL_GOVERNMENT_VAT = 26;
    public static final int COL_DEPARTMENT_LEVEL = 27;
    public static final int COL_LAST_UPDATE = 28;
    public static final int COL_PROJECT_CODE = 29;
    public static final int COL_PAYMENT_CODE = 30;
    public static final int COL_INSTALL_BUDGET_CODE = 31;
    public static final int COL_INSTALL_TRAVEL_CODE = 32;
    public static final int COL_INSTALL_SETTLEMENT_CODE = 33;
    public static final int COL_CATEGORY_LEVEL = 34;
    public static final int COL_CUSTOMER_REQUEST_CODE = 35;
    public static final int COL_INTRO_LETTER_CODE = 36;
    public static final int COL_PROPOSAL_CODE = 37;
    public static final int COL_PHONE = 38;
    public static final int COL_FAX = 39;
    public static final int COL_EMAIL = 40;
    public static final int COL_WEBSITE = 41;
    public static final int COL_PURCHASE_REQUEST_CODE = 42;
    public static final int COL_RETURN_GOODS_CODE = 43;
    public static final int COL_TRANSFER_GOODS_CODE = 44;
    public static final int COL_COSTING_GOODS_CODE = 45;
    public static final int COL_ADJUSTMENT_CODE = 46;
    public static final int COL_OPNAME_CODE = 47;
    public static final int COL_INTEGRATED_HOTEL_SYSTEM = 48;
    public static final int COL_INTEGRATED_FINANCE_SYSTEM = 49;
    public static final int COL_DEFAULT_SALES_MARGIN = 50;
    public static final int COL_SHOP_ORDER_CODE = 51;
    public static final int COL_PINJAMAN_KOPERASI_CODE = 52;
    public static final int COL_PINJAMAN_BANK_CODE = 53;
    public static final int COL_BAYAR_ANGSURAN_CODE = 54;
    public static final int COL_BAYAR_ANGSURAN_BANK_CODE = 55;
    public static final int COL_BUSINESS_NAME = 56;
    public static final int COL_TAX_NUMBER = 57;
    public static final int COL_USE_BKP = 58;
    public static final int COL_TAX_AMOUNT = 59;
    public static final int COL_MULTI_CURRENCY = 60;
    public static final int COL_MULTI_BANK = 61;
    public static final int COL_BUSINESS_TYPE = 62;
    public static final String[] colNames = {
        "company_id",
        "name",
        "serial_number",
        "address",
        "fiscal_year",
        "end_fiscal_month",
        "entry_start_month",
        "number_of_period",
        "cash_receive_code",
        "pettycash_payment_code",
        "pettycash_replace_code",
        "bank_deposit_code",
        "bank_payment_po_code",
        "bank_payment_nonpo_code",
        "purchase_order_code",
        "general_ledger_code",
        "max_pettycash_replenis",
        "max_pettycash_transaction",
        "booking_currency_code",
        "booking_currency_id",
        "system_location",
        "activation_code",
        "system_location_code",
        "contact",
        "address2",
        "invoice_code",
        "government_vat",
        "department_level",
        "last_update",
        "project_code",
        "payment_code",
        "install_budget_code",
        "install_travel_code",
        "install_settlement_code",
        "category_level",
        "customer_request_code",
        "intro_letter_code",
        "proposal_code",
        "phone",
        "fax",
        "email",
        "website",
        "purchase_request_code",
        "return_goods_code",
        "transfer_goods_code",
        "costing_goods_code",
        "adjustment_code",
        "opname_code",
        "integrated_hotel_system",
        "integrated_finance_system",
        "default_sales_margin",
        "shop_order_code",
        "pinjaman_koperasi_code",
        "pinjaman_bank_code",
        "bayar_angsuran_code",
        "bayar_angsuran_bank_code",
        "business_name",
        "tax_number",
        "use_bkp",
        "tax_amount",
        "multi_currency",
        "multi_bank",
        "business_type"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };
    public static final int NOT_USE_BKP = 0;
    public static final int USE_BKP = 1;
    public static final int NON_MULTI_CURRENCY = 0;
    public static final int MULTI_CURRENCY = 1;
    public static final int NON_MULTI_BANK = 0;
    public static final int MULTI_BANK = 1;

    public DbCompany() {
    }

    public DbCompany(int i) throws CONException {
        super(new DbCompany());
    }

    public DbCompany(String sOid) throws CONException {
        super(new DbCompany(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCompany(long lOid) throws CONException {
        super(new DbCompany(0));
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
        return DB_COMPANY;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCompany().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Company company = fetchExc(ent.getOID());
        ent = (Entity) company;
        return company.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Company) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Company) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Company fetchExc(long oid) throws CONException {
        try {
            Company company = new Company();
            DbCompany pstCompany = new DbCompany(oid);
            company.setOID(oid);

            company.setName(pstCompany.getString(COL_NAME));
            company.setBusinessName(pstCompany.getString(COL_BUSINESS_NAME));
            company.setTaxNumber(pstCompany.getString(COL_TAX_NUMBER));
            company.setSerialNumber(pstCompany.getString(COL_SERIAL_NUMBER));
            company.setAddress(pstCompany.getString(COL_ADDRESS));
            company.setFiscalYear(pstCompany.getInt(COL_FISCAL_YEAR));
            company.setEndFiscalMonth(pstCompany.getInt(COL_END_FISCAL_MONTH));
            company.setEntryStartMonth(pstCompany.getInt(COL_ENTRY_START_MONTH));
            company.setNumberOfPeriod(pstCompany.getInt(COL_NUMBER_OF_PERIOD));
            company.setCashReceiveCode(pstCompany.getString(COL_CASH_RECEIVE_CODE));
            company.setPettycashPaymentCode(pstCompany.getString(COL_PETTYCASH_PAYMENT_CODE));
            company.setPettycashReplaceCode(pstCompany.getString(COL_PETTYCASH_REPLACE_CODE));
            company.setBankDepositCode(pstCompany.getString(COL_BANK_DEPOSIT_CODE));
            company.setBankPaymentPoCode(pstCompany.getString(COL_BANK_PAYMENT_PO_CODE));
            company.setBankPaymentNonpoCode(pstCompany.getString(COL_BANK_PAYMENT_NONPO_CODE));
            company.setPurchaseOrderCode(pstCompany.getString(COL_PURCHASE_ORDER_CODE));
            company.setGeneralLedgerCode(pstCompany.getString(COL_GENERAL_LEDGER_CODE));
            company.setMaxPettycashReplenis(pstCompany.getdouble(COL_MAX_PETTYCASH_REPLENIS));
            company.setMaxPettycashTransaction(pstCompany.getdouble(COL_MAX_PETTYCASH_TRANSACTION));
            company.setBookingCurrencyCode(pstCompany.getString(COL_BOOKING_CURRENCY_CODE));
            company.setBookingCurrencyId(pstCompany.getlong(COL_BOOKING_CURRENCY_ID));
            company.setSystemLocation(pstCompany.getlong(COL_SYSTEM_LOCATION));
            company.setActivationCode(pstCompany.getString(COL_ACTIVATION_CODE));
            company.setSystemLocationCode(pstCompany.getString(COL_SYSTEM_LOCATION_CODE));
            company.setContact(pstCompany.getString(COL_CONTACT));
            company.setAddress2(pstCompany.getString(COL_ADDRESS2));
            company.setInvoiceCode(pstCompany.getString(COL_INVOICE_CODE));
            company.setGovernmentVat(pstCompany.getdouble(COL_GOVERNMENT_VAT));
            company.setDepartmentLevel(pstCompany.getInt(COL_DEPARTMENT_LEVEL));
            company.setLastUpdate(pstCompany.getDate(COL_LAST_UPDATE));
            company.setProjectCode(pstCompany.getString(COL_PROJECT_CODE));
            company.setPaymentCode(pstCompany.getString(COL_PAYMENT_CODE));
            company.setInstallBudgetCode(pstCompany.getString(COL_INSTALL_BUDGET_CODE));
            company.setInstallTravelCode(pstCompany.getString(COL_INSTALL_TRAVEL_CODE));
            company.setInstallSettlementCode(pstCompany.getString(COL_INSTALL_SETTLEMENT_CODE));
            company.setCategoryLevel(pstCompany.getInt(COL_CATEGORY_LEVEL));
            company.setCustomerRequestCode(pstCompany.getString(COL_CUSTOMER_REQUEST_CODE));
            company.setIntroLetterCode(pstCompany.getString(COL_INTRO_LETTER_CODE));
            company.setProposalCode(pstCompany.getString(COL_PROPOSAL_CODE));
            company.setPhone(pstCompany.getString(COL_PHONE));
            company.setFax(pstCompany.getString(COL_FAX));
            company.setEmail(pstCompany.getString(COL_EMAIL));
            company.setWebsite(pstCompany.getString(COL_WEBSITE));
            company.setDefaultSalesMargin(pstCompany.getdouble(COL_DEFAULT_SALES_MARGIN));
            company.setPurchaseRequestCode(pstCompany.getString(COL_PURCHASE_REQUEST_CODE));
            company.setReturnGoodsCode(pstCompany.getString(COL_RETURN_GOODS_CODE));
            company.setTransferGoodsCode(pstCompany.getString(COL_TRANSFER_GOODS_CODE));
            company.setCostingGoodsCode(pstCompany.getString(COL_COSTING_GOODS_CODE));
            company.setAdjustmentCode(pstCompany.getString(COL_ADJUSTMENT_CODE));
            company.setOpnameCode(pstCompany.getString(COL_OPNAME_CODE));
            company.setIntegratedHotelSystem(pstCompany.getInt(COL_INTEGRATED_HOTEL_SYSTEM));
            company.setIntegratedFinanceSystem(pstCompany.getInt(COL_INTEGRATED_FINANCE_SYSTEM));
            company.setShopOrderCode(pstCompany.getString(COL_SHOP_ORDER_CODE));
            company.setPinjamanKoperasiCode(pstCompany.getString(COL_PINJAMAN_KOPERASI_CODE));
            company.setPinjamanBankCode(pstCompany.getString(COL_PINJAMAN_BANK_CODE));
            company.setBayarAngsuranCode(pstCompany.getString(COL_BAYAR_ANGSURAN_CODE));
            company.setBayarAngsuranBankCode(pstCompany.getString(COL_BAYAR_ANGSURAN_BANK_CODE));
            company.setUseBkp(pstCompany.getInt(COL_USE_BKP));
            company.setTaxAmount(pstCompany.getdouble(COL_TAX_AMOUNT));
            company.setMultiCurrency(pstCompany.getInt(COL_MULTI_CURRENCY));
            company.setMultiBank(pstCompany.getInt(COL_MULTI_BANK));
            company.setBusinessType(pstCompany.getInt(COL_BUSINESS_TYPE));

            return company;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCompany(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Company company) throws CONException {
        try {
            DbCompany pstCompany = new DbCompany(0);

            pstCompany.setString(COL_NAME, company.getName());
            pstCompany.setString(COL_BUSINESS_NAME, company.getBusinessName());
            pstCompany.setString(COL_TAX_NUMBER, company.getTaxNumber());
            pstCompany.setString(COL_SERIAL_NUMBER, company.getSerialNumber());
            pstCompany.setString(COL_ADDRESS, company.getAddress());
            pstCompany.setInt(COL_FISCAL_YEAR, company.getFiscalYear());
            pstCompany.setInt(COL_END_FISCAL_MONTH, company.getEndFiscalMonth());
            pstCompany.setInt(COL_ENTRY_START_MONTH, company.getEntryStartMonth());
            pstCompany.setInt(COL_NUMBER_OF_PERIOD, company.getNumberOfPeriod());
            pstCompany.setString(COL_CASH_RECEIVE_CODE, company.getCashReceiveCode());
            pstCompany.setString(COL_PETTYCASH_PAYMENT_CODE, company.getPettycashPaymentCode());
            pstCompany.setString(COL_PETTYCASH_REPLACE_CODE, company.getPettycashReplaceCode());
            pstCompany.setString(COL_BANK_DEPOSIT_CODE, company.getBankDepositCode());
            pstCompany.setString(COL_BANK_PAYMENT_PO_CODE, company.getBankPaymentPoCode());
            pstCompany.setString(COL_BANK_PAYMENT_NONPO_CODE, company.getBankPaymentNonpoCode());
            pstCompany.setString(COL_PURCHASE_ORDER_CODE, company.getPurchaseOrderCode());
            pstCompany.setString(COL_GENERAL_LEDGER_CODE, company.getGeneralLedgerCode());
            pstCompany.setDouble(COL_MAX_PETTYCASH_REPLENIS, company.getMaxPettycashReplenis());
            pstCompany.setDouble(COL_MAX_PETTYCASH_TRANSACTION, company.getMaxPettycashTransaction());
            pstCompany.setString(COL_BOOKING_CURRENCY_CODE, company.getBookingCurrencyCode());
            pstCompany.setLong(COL_BOOKING_CURRENCY_ID, company.getBookingCurrencyId());
            pstCompany.setLong(COL_SYSTEM_LOCATION, company.getSystemLocation());
            pstCompany.setString(COL_ACTIVATION_CODE, company.getActivationCode());
            pstCompany.setString(COL_SYSTEM_LOCATION_CODE, company.getSystemLocationCode());
            pstCompany.setString(COL_CONTACT, company.getContact());
            pstCompany.setString(COL_ADDRESS2, company.getAddress2());
            pstCompany.setString(COL_INVOICE_CODE, company.getInvoiceCode());
            pstCompany.setDouble(COL_GOVERNMENT_VAT, company.getGovernmentVat());
            pstCompany.setInt(COL_DEPARTMENT_LEVEL, company.getDepartmentLevel());
            pstCompany.setDate(COL_LAST_UPDATE, company.getLastUpdate());
            pstCompany.setString(COL_PROJECT_CODE, company.getProjectCode());
            pstCompany.setString(COL_PAYMENT_CODE, company.getPaymentCode());
            pstCompany.setString(COL_INSTALL_BUDGET_CODE, company.getInstallBudgetCode());
            pstCompany.setString(COL_INSTALL_TRAVEL_CODE, company.getInstallTravelCode());
            pstCompany.setString(COL_INSTALL_SETTLEMENT_CODE, company.getInstallSettlementCode());
            pstCompany.setInt(COL_CATEGORY_LEVEL, company.getCategoryLevel());
            pstCompany.setString(COL_CUSTOMER_REQUEST_CODE, company.getCustomerRequestCode());
            pstCompany.setString(COL_INTRO_LETTER_CODE, company.getIntroLetterCode());
            pstCompany.setString(COL_PROPOSAL_CODE, company.getProposalCode());
            pstCompany.setString(COL_PHONE, company.getPhone());
            pstCompany.setString(COL_FAX, company.getFax());
            pstCompany.setString(COL_EMAIL, company.getEmail());
            pstCompany.setString(COL_WEBSITE, company.getWebsite());
            pstCompany.setDouble(COL_DEFAULT_SALES_MARGIN, company.getDefaultSalesMargin());
            pstCompany.setString(COL_PURCHASE_REQUEST_CODE, company.getPurchaseRequestCode());
            pstCompany.setString(COL_RETURN_GOODS_CODE, company.getReturnGoodsCode());
            pstCompany.setString(COL_TRANSFER_GOODS_CODE, company.getTransferGoodsCode());
            pstCompany.setString(COL_COSTING_GOODS_CODE, company.getCostingGoodsCode());
            pstCompany.setString(COL_ADJUSTMENT_CODE, company.getAdjustmentCode());
            pstCompany.setString(COL_OPNAME_CODE, company.getOpnameCode());
            pstCompany.setInt(COL_INTEGRATED_HOTEL_SYSTEM, company.getIntegratedHotelSystem());
            pstCompany.setInt(COL_INTEGRATED_FINANCE_SYSTEM, company.getIntegratedFinanceSystem());
            pstCompany.setString(COL_SHOP_ORDER_CODE, company.getShopOrderCode());
            pstCompany.setString(COL_PINJAMAN_KOPERASI_CODE, company.getPinjamanKoperasiCode());
            pstCompany.setString(COL_PINJAMAN_BANK_CODE, company.getPinjamanBankCode());
            pstCompany.setString(COL_BAYAR_ANGSURAN_CODE, company.getBayarAngsuranCode());
            pstCompany.setString(COL_BAYAR_ANGSURAN_BANK_CODE, company.getBayarAngsuranBankCode());
            pstCompany.setInt(COL_USE_BKP, company.getUseBkp());
            pstCompany.setDouble(COL_TAX_AMOUNT, company.getTaxAmount());
            pstCompany.setInt(COL_MULTI_CURRENCY, company.getMultiCurrency());
            pstCompany.setInt(COL_MULTI_BANK, company.getMultiBank());
            pstCompany.setInt(COL_BUSINESS_TYPE, company.getBusinessType());

            pstCompany.insert();
            company.setOID(pstCompany.getlong(COL_COMPANY_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCompany(0), CONException.UNKNOWN);
        }
        return company.getOID();
    }

    public static long updateExc(Company company) throws CONException {
        try {
            if (company.getOID() != 0) {
                DbCompany pstCompany = new DbCompany(company.getOID());

                pstCompany.setString(COL_NAME, company.getName());
                pstCompany.setString(COL_BUSINESS_NAME, company.getBusinessName());
                pstCompany.setString(COL_TAX_NUMBER, company.getTaxNumber());
                pstCompany.setString(COL_SERIAL_NUMBER, company.getSerialNumber());
                pstCompany.setString(COL_ADDRESS, company.getAddress());
                pstCompany.setInt(COL_FISCAL_YEAR, company.getFiscalYear());
                pstCompany.setInt(COL_END_FISCAL_MONTH, company.getEndFiscalMonth());
                pstCompany.setInt(COL_ENTRY_START_MONTH, company.getEntryStartMonth());
                pstCompany.setInt(COL_NUMBER_OF_PERIOD, company.getNumberOfPeriod());
                pstCompany.setString(COL_CASH_RECEIVE_CODE, company.getCashReceiveCode());
                pstCompany.setString(COL_PETTYCASH_PAYMENT_CODE, company.getPettycashPaymentCode());
                pstCompany.setString(COL_PETTYCASH_REPLACE_CODE, company.getPettycashReplaceCode());
                pstCompany.setString(COL_BANK_DEPOSIT_CODE, company.getBankDepositCode());
                pstCompany.setString(COL_BANK_PAYMENT_PO_CODE, company.getBankPaymentPoCode());
                pstCompany.setString(COL_BANK_PAYMENT_NONPO_CODE, company.getBankPaymentNonpoCode());
                pstCompany.setString(COL_PURCHASE_ORDER_CODE, company.getPurchaseOrderCode());
                pstCompany.setString(COL_GENERAL_LEDGER_CODE, company.getGeneralLedgerCode());
                pstCompany.setDouble(COL_MAX_PETTYCASH_REPLENIS, company.getMaxPettycashReplenis());
                pstCompany.setDouble(COL_MAX_PETTYCASH_TRANSACTION, company.getMaxPettycashTransaction());
                pstCompany.setString(COL_BOOKING_CURRENCY_CODE, company.getBookingCurrencyCode());
                pstCompany.setLong(COL_BOOKING_CURRENCY_ID, company.getBookingCurrencyId());
                pstCompany.setLong(COL_SYSTEM_LOCATION, company.getSystemLocation());
                pstCompany.setString(COL_ACTIVATION_CODE, company.getActivationCode());
                pstCompany.setString(COL_SYSTEM_LOCATION_CODE, company.getSystemLocationCode());
                pstCompany.setString(COL_CONTACT, company.getContact());
                pstCompany.setString(COL_ADDRESS2, company.getAddress2());
                pstCompany.setString(COL_INVOICE_CODE, company.getInvoiceCode());
                pstCompany.setDouble(COL_GOVERNMENT_VAT, company.getGovernmentVat());
                pstCompany.setInt(COL_DEPARTMENT_LEVEL, company.getDepartmentLevel());
                pstCompany.setDate(COL_LAST_UPDATE, company.getLastUpdate());
                pstCompany.setString(COL_PROJECT_CODE, company.getProjectCode());
                pstCompany.setString(COL_PAYMENT_CODE, company.getPaymentCode());
                pstCompany.setString(COL_INSTALL_BUDGET_CODE, company.getInstallBudgetCode());
                pstCompany.setString(COL_INSTALL_TRAVEL_CODE, company.getInstallTravelCode());
                pstCompany.setString(COL_INSTALL_SETTLEMENT_CODE, company.getInstallSettlementCode());
                pstCompany.setInt(COL_CATEGORY_LEVEL, company.getCategoryLevel());
                pstCompany.setString(COL_CUSTOMER_REQUEST_CODE, company.getCustomerRequestCode());
                pstCompany.setString(COL_INTRO_LETTER_CODE, company.getIntroLetterCode());
                pstCompany.setString(COL_PROPOSAL_CODE, company.getProposalCode());
                pstCompany.setString(COL_PHONE, company.getPhone());
                pstCompany.setString(COL_FAX, company.getFax());
                pstCompany.setString(COL_EMAIL, company.getEmail());
                pstCompany.setString(COL_WEBSITE, company.getWebsite());
                pstCompany.setDouble(COL_DEFAULT_SALES_MARGIN, company.getDefaultSalesMargin());
                pstCompany.setString(COL_PURCHASE_REQUEST_CODE, company.getPurchaseRequestCode());
                pstCompany.setString(COL_RETURN_GOODS_CODE, company.getReturnGoodsCode());
                pstCompany.setString(COL_TRANSFER_GOODS_CODE, company.getTransferGoodsCode());
                pstCompany.setString(COL_COSTING_GOODS_CODE, company.getCostingGoodsCode());
                pstCompany.setString(COL_ADJUSTMENT_CODE, company.getAdjustmentCode());
                pstCompany.setString(COL_OPNAME_CODE, company.getOpnameCode());
                pstCompany.setInt(COL_INTEGRATED_HOTEL_SYSTEM, company.getIntegratedHotelSystem());
                pstCompany.setInt(COL_INTEGRATED_FINANCE_SYSTEM, company.getIntegratedFinanceSystem());
                pstCompany.setString(COL_SHOP_ORDER_CODE, company.getShopOrderCode());
                pstCompany.setString(COL_PINJAMAN_KOPERASI_CODE, company.getPinjamanKoperasiCode());
                pstCompany.setString(COL_PINJAMAN_BANK_CODE, company.getPinjamanBankCode());
                pstCompany.setString(COL_BAYAR_ANGSURAN_CODE, company.getBayarAngsuranCode());
                pstCompany.setString(COL_BAYAR_ANGSURAN_BANK_CODE, company.getBayarAngsuranBankCode());
                pstCompany.setInt(COL_USE_BKP, company.getUseBkp());
                pstCompany.setDouble(COL_TAX_AMOUNT, company.getTaxAmount());
                pstCompany.setInt(COL_MULTI_CURRENCY, company.getMultiCurrency());
                pstCompany.setInt(COL_MULTI_BANK, company.getMultiBank());
                pstCompany.setInt(COL_BUSINESS_TYPE, company.getBusinessType());

                pstCompany.update();
                return company.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCompany(0), CONException.UNKNOWN);
        }
        return company.getOID();
    //return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCompany pstCompany = new DbCompany(oid);
            pstCompany.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCompany(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_COMPANY;
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
                Company company = new Company();
                resultToObject(rs, company);
                lists.add(company);
            }

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return lists;

    }

    private static void resultToObject(ResultSet rs, Company company) {
        try {
            company.setOID(rs.getLong(DbCompany.colNames[DbCompany.COL_COMPANY_ID]));
            company.setName(rs.getString(DbCompany.colNames[DbCompany.COL_NAME]));
            company.setBusinessName(rs.getString(DbCompany.colNames[DbCompany.COL_BUSINESS_NAME]));
            company.setTaxNumber(rs.getString(DbCompany.colNames[DbCompany.COL_TAX_NUMBER]));
            company.setSerialNumber(rs.getString(DbCompany.colNames[DbCompany.COL_SERIAL_NUMBER]));
            company.setAddress(rs.getString(DbCompany.colNames[DbCompany.COL_ADDRESS]));
            company.setFiscalYear(rs.getInt(DbCompany.colNames[DbCompany.COL_FISCAL_YEAR]));
            company.setEndFiscalMonth(rs.getInt(DbCompany.colNames[DbCompany.COL_END_FISCAL_MONTH]));
            company.setEntryStartMonth(rs.getInt(DbCompany.colNames[DbCompany.COL_ENTRY_START_MONTH]));
            company.setNumberOfPeriod(rs.getInt(DbCompany.colNames[DbCompany.COL_NUMBER_OF_PERIOD]));
            company.setCashReceiveCode(rs.getString(DbCompany.colNames[DbCompany.COL_CASH_RECEIVE_CODE]));
            company.setPettycashPaymentCode(rs.getString(DbCompany.colNames[DbCompany.COL_PETTYCASH_PAYMENT_CODE]));
            company.setPettycashReplaceCode(rs.getString(DbCompany.colNames[DbCompany.COL_PETTYCASH_REPLACE_CODE]));
            company.setBankDepositCode(rs.getString(DbCompany.colNames[DbCompany.COL_BANK_DEPOSIT_CODE]));
            company.setBankPaymentPoCode(rs.getString(DbCompany.colNames[DbCompany.COL_BANK_PAYMENT_PO_CODE]));
            company.setBankPaymentNonpoCode(rs.getString(DbCompany.colNames[DbCompany.COL_BANK_PAYMENT_NONPO_CODE]));
            company.setPurchaseOrderCode(rs.getString(DbCompany.colNames[DbCompany.COL_PURCHASE_ORDER_CODE]));
            company.setGeneralLedgerCode(rs.getString(DbCompany.colNames[DbCompany.COL_GENERAL_LEDGER_CODE]));
            company.setMaxPettycashReplenis(rs.getDouble(DbCompany.colNames[DbCompany.COL_MAX_PETTYCASH_REPLENIS]));
            company.setMaxPettycashTransaction(rs.getDouble(DbCompany.colNames[DbCompany.COL_MAX_PETTYCASH_TRANSACTION]));
            company.setBookingCurrencyCode(rs.getString(DbCompany.colNames[DbCompany.COL_BOOKING_CURRENCY_CODE]));
            company.setBookingCurrencyId(rs.getLong(DbCompany.colNames[DbCompany.COL_BOOKING_CURRENCY_ID]));
            company.setSystemLocation(rs.getLong(DbCompany.colNames[DbCompany.COL_SYSTEM_LOCATION]));
            company.setActivationCode(rs.getString(DbCompany.colNames[DbCompany.COL_ACTIVATION_CODE]));
            company.setSystemLocationCode(rs.getString(DbCompany.colNames[DbCompany.COL_SYSTEM_LOCATION_CODE]));
            company.setContact(rs.getString(DbCompany.colNames[DbCompany.COL_CONTACT]));
            company.setAddress2(rs.getString(DbCompany.colNames[DbCompany.COL_ADDRESS2]));
            company.setInvoiceCode(rs.getString(DbCompany.colNames[DbCompany.COL_INVOICE_CODE]));
            company.setGovernmentVat(rs.getDouble(DbCompany.colNames[DbCompany.COL_GOVERNMENT_VAT]));
            company.setDepartmentLevel(rs.getInt(DbCompany.colNames[DbCompany.COL_DEPARTMENT_LEVEL]));
            //company.setLastUpdate(rs.getDate(DbCompany.colNames[DbCompany.COL_LAST_UPDATE]));
            company.setProjectCode(rs.getString(DbCompany.colNames[DbCompany.COL_PROJECT_CODE]));
            company.setPaymentCode(rs.getString(DbCompany.colNames[DbCompany.COL_PAYMENT_CODE]));
            company.setInstallBudgetCode(rs.getString(DbCompany.colNames[DbCompany.COL_INSTALL_BUDGET_CODE]));
            company.setInstallTravelCode(rs.getString(DbCompany.colNames[DbCompany.COL_INSTALL_TRAVEL_CODE]));
            company.setInstallSettlementCode(rs.getString(DbCompany.colNames[DbCompany.COL_INSTALL_SETTLEMENT_CODE]));
            company.setCategoryLevel(rs.getInt(DbCompany.colNames[DbCompany.COL_CATEGORY_LEVEL]));
            company.setCustomerRequestCode(rs.getString(DbCompany.colNames[DbCompany.COL_CUSTOMER_REQUEST_CODE]));
            company.setIntroLetterCode(rs.getString(DbCompany.colNames[DbCompany.COL_INTRO_LETTER_CODE]));
            company.setProposalCode(rs.getString(DbCompany.colNames[DbCompany.COL_PROPOSAL_CODE]));
            company.setPhone(rs.getString(DbCompany.colNames[DbCompany.COL_PHONE]));
            company.setFax(rs.getString(DbCompany.colNames[DbCompany.COL_FAX]));
            company.setEmail(rs.getString(DbCompany.colNames[DbCompany.COL_EMAIL]));
            company.setWebsite(rs.getString(DbCompany.colNames[DbCompany.COL_WEBSITE]));
            company.setDefaultSalesMargin(rs.getDouble(DbCompany.colNames[DbCompany.COL_DEFAULT_SALES_MARGIN]));
            company.setPurchaseRequestCode(rs.getString(DbCompany.colNames[DbCompany.COL_PURCHASE_REQUEST_CODE]));
            company.setReturnGoodsCode(rs.getString(DbCompany.colNames[DbCompany.COL_RETURN_GOODS_CODE]));
            company.setTransferGoodsCode(rs.getString(DbCompany.colNames[DbCompany.COL_TRANSFER_GOODS_CODE]));
            company.setCostingGoodsCode(rs.getString(DbCompany.colNames[DbCompany.COL_COSTING_GOODS_CODE]));
            company.setAdjustmentCode(rs.getString(DbCompany.colNames[DbCompany.COL_ADJUSTMENT_CODE]));
            company.setOpnameCode(rs.getString(DbCompany.colNames[DbCompany.COL_OPNAME_CODE]));
            company.setIntegratedHotelSystem(rs.getInt(DbCompany.colNames[DbCompany.COL_INTEGRATED_HOTEL_SYSTEM]));
            company.setIntegratedFinanceSystem(rs.getInt(DbCompany.colNames[DbCompany.COL_INTEGRATED_FINANCE_SYSTEM]));
            company.setShopOrderCode(rs.getString(DbCompany.colNames[DbCompany.COL_SHOP_ORDER_CODE]));
            company.setPinjamanKoperasiCode(rs.getString(DbCompany.colNames[DbCompany.COL_PINJAMAN_KOPERASI_CODE]));
            company.setPinjamanBankCode(rs.getString(DbCompany.colNames[DbCompany.COL_PINJAMAN_BANK_CODE]));
            company.setBayarAngsuranCode(rs.getString(DbCompany.colNames[DbCompany.COL_BAYAR_ANGSURAN_CODE]));
            company.setBayarAngsuranBankCode(rs.getString(DbCompany.colNames[DbCompany.COL_BAYAR_ANGSURAN_BANK_CODE]));
            company.setUseBkp(rs.getInt(DbCompany.colNames[DbCompany.COL_USE_BKP]));
            company.setTaxAmount(rs.getDouble(DbCompany.colNames[DbCompany.COL_TAX_AMOUNT]));
            company.setMultiCurrency(rs.getInt(DbCompany.colNames[DbCompany.COL_MULTI_CURRENCY]));
            company.setMultiBank(rs.getInt(DbCompany.colNames[DbCompany.COL_MULTI_BANK]));
            company.setBusinessType(rs.getInt(colNames[COL_BUSINESS_TYPE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long companyId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_COMPANY + " WHERE " +
                    DbCompany.colNames[DbCompany.COL_COMPANY_ID] + " = " + companyId;

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
            String sql = "SELECT COUNT(" + DbCompany.colNames[DbCompany.COL_COMPANY_ID] + ") FROM " + DB_COMPANY;
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
                    Company company = (Company) list.get(ls);
                    if (oid == company.getOID()) {
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

    public static Company getCompany() {

        Company c = new Company();

        Vector v = list(0, 0, "", "");
        if (v != null && v.size() > 0) {

            c = (Company) v.get(0);

            try {
                c = DbCompany.fetchExc(c.getOID());
            } catch (Exception e) {
            }

        }
        return c;
    }
}

