package com.project.general;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspCompany extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Company company;
    public static final String JSP_NAME_COMPANY = "JSP_NAME_COMPANY";
    public static final int JSP_COMPANY_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_SERIAL_NUMBER = 2;
    public static final int JSP_ADDRESS = 3;
    public static final int JSP_FISCAL_YEAR = 4;
    public static final int JSP_END_FISCAL_MONTH = 5;
    public static final int JSP_ENTRY_START_MONTH = 6;
    public static final int JSP_NUMBER_OF_PERIOD = 7;
    public static final int JSP_CASH_RECEIVE_CODE = 8;
    public static final int JSP_PETTYCASH_PAYMENT_CODE = 9;
    public static final int JSP_PETTYCASH_REPLACE_CODE = 10;
    public static final int JSP_BANK_DEPOSIT_CODE = 11;
    public static final int JSP_BANK_PAYMENT_PO_CODE = 12;
    public static final int JSP_BANK_PAYMENT_NONPO_CODE = 13;
    public static final int JSP_PURCHASE_ORDER_CODE = 14;
    public static final int JSP_GENERAL_LEDGER_CODE = 15;
    public static final int JSP_MAX_PETTYCASH_REPLENIS = 16;
    public static final int JSP_MAX_PETTYCASH_TRANSACTION = 17;
    public static final int JSP_BOOKING_CURRENCY_CODE = 18;
    public static final int JSP_BOOKING_CURRENCY_ID = 19;
    public static final int JSP_SYSTEM_LOCATION = 20;
    public static final int JSP_ACTIVATION_CODE = 21;
    public static final int JSP_SYSTEM_LOCATION_CODE = 22;
    public static final int JSP_CONTACT = 23;
    public static final int JSP_ADDRESS2 = 24;
    public static final int JSP_PROJECT_CODE = 25;
    public static final int JSP_PAYMENT_CODE = 26;
    public static final int JSP_INSTALL_BUDGET_CODE = 31;
    public static final int JSP_INSTALL_TRAVEL_CODE = 32;
    public static final int JSP_INSTALL_SETTLEMENT_CODE = 33;
    public static final int JSP_PHONE = 34;
    public static final int JSP_FAX = 35;
    public static final int JSP_EMAIL = 36;
    public static final int JSP_WEBSITE = 37;
    public static final int JSP_BUSINESS_NAME = 38;
    public static final int JSP_TAX_NUMBER = 39;
    public static final int JSP_USE_BKP = 40;
    public static final int JSP_TAX_AMOUNT = 41;
    public static final int JSP_MULTI_CURRENCY = 42;
    public static final int JSP_MULTI_BANK = 43;
    public static String[] colNames = {
        "JSP_COMPANY_ID", "JSP_NAME",
        "JSP_SERIAL_NUMBER", "JSP_ADDRESS",
        "JSP_FISCAL_YEAR", "JSP_END_FISCAL_MONTH",
        "JSP_ENTRY_START_MONTH", "JSP_NUMBER_OF_PERIOD",
        "JSP_CASH_RECEIVE_CODE", "JSP_PETTYCASH_PAYMENT_CODE",
        "JSP_PETTYCASH_REPLACE_CODE", "JSP_BANK_DEPOSIT_CODE",
        "JSP_BANK_PAYMENT_PO_CODE", "JSP_BANK_PAYMENT_NONPO_CODE",
        "JSP_PURCHASE_ORDER_CODE", "JSP_GENERAL_LEDGER_CODE",
        "JSP_MAX_PETTYCASH_REPLENIS", "JSP_MAX_PETTYCASH_TRANSACTION",
        "JSP_BOOKING_CURRENCY_CODE", "JSP_BOOKING_CURRENCY_ID",
        "JSP_SYSTEM_LOCATION", "JSP_ACTIVATION_CODE",
        "JSP_SYSTEM_LOCATION_CODE", "JSP_CONTACT",
        "JSP_ADDRESS2", "JSP_PROJECT_CODE",
        "JSP_PAYMENT_CODE",
        "JSP_INSTALL_BUDGET_CODE",
        "JSP_INSTALL_TRAVEL_CODE",
        "JSP_INSTALL_SETTLEMENT_CODE",
        "JSP_PHONE", "JSP_FAX",
        "JSP_EMAIL", "JSP_WEBSITE", "JSP_BUSINESS_NAME", "TAX_NUMBER",
        "JSP_USE_BKP", "JSP_TAX_AMOUNT",
        "JSP_MULTI_CURRENCY", "JSP_MULTI_BANK"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_INT, TYPE_INT,
        TYPE_INT, TYPE_INT,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_STRING, TYPE_LONG,
        TYPE_LONG, TYPE_STRING,
        TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_INT, TYPE_FLOAT,
        TYPE_INT, TYPE_INT
    };

    public JspCompany() {
    }

    public JspCompany(Company company) {
        this.company = company;
    }

    public JspCompany(HttpServletRequest request, Company company) {
        super(new JspCompany(company), request);
        this.company = company;
    }

    public String getFormName() {
        return JSP_NAME_COMPANY;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public Company getEntityObject() {
        return company;
    }

    public void requestEntityObject(Company company) {
        try {
            this.requestParam();
            company.setName(getString(JSP_NAME));
            company.setBusinessName(getString(JSP_BUSINESS_NAME));
            company.setTaxNumber(getString(JSP_TAX_NUMBER));
            company.setSerialNumber(getString(JSP_SERIAL_NUMBER));
            company.setAddress(getString(JSP_ADDRESS));
            company.setFiscalYear(getInt(JSP_FISCAL_YEAR));
            company.setEndFiscalMonth(getInt(JSP_END_FISCAL_MONTH));
            company.setEntryStartMonth(getInt(JSP_ENTRY_START_MONTH));
            company.setNumberOfPeriod(getInt(JSP_NUMBER_OF_PERIOD));
            company.setCashReceiveCode(getString(JSP_CASH_RECEIVE_CODE));
            company.setPettycashPaymentCode(getString(JSP_PETTYCASH_PAYMENT_CODE));
            company.setPettycashReplaceCode(getString(JSP_PETTYCASH_REPLACE_CODE));
            company.setBankDepositCode(getString(JSP_BANK_DEPOSIT_CODE));
            company.setBankPaymentPoCode(getString(JSP_BANK_PAYMENT_PO_CODE));
            company.setBankPaymentNonpoCode(getString(JSP_BANK_PAYMENT_NONPO_CODE));
            company.setPurchaseOrderCode(getString(JSP_PURCHASE_ORDER_CODE));
            company.setGeneralLedgerCode(getString(JSP_GENERAL_LEDGER_CODE));
            company.setMaxPettycashReplenis(getDouble(JSP_MAX_PETTYCASH_REPLENIS));
            company.setMaxPettycashTransaction(getDouble(JSP_MAX_PETTYCASH_TRANSACTION));
            company.setBookingCurrencyCode(getString(JSP_BOOKING_CURRENCY_CODE));
            company.setBookingCurrencyId(getLong(JSP_BOOKING_CURRENCY_ID));
            company.setSystemLocation(getLong(JSP_SYSTEM_LOCATION));
            company.setActivationCode(getString(JSP_ACTIVATION_CODE));
            company.setSystemLocationCode(getString(JSP_SYSTEM_LOCATION_CODE));
            company.setContact(getString(JSP_CONTACT));
            company.setAddress2(getString(JSP_ADDRESS2));
            company.setProjectCode(getString(JSP_PROJECT_CODE));
            company.setPaymentCode(getString(JSP_PAYMENT_CODE));
            company.setInstallBudgetCode(getString(JSP_INSTALL_BUDGET_CODE));
            company.setInstallTravelCode(getString(JSP_INSTALL_TRAVEL_CODE));
            company.setInstallSettlementCode(getString(JSP_INSTALL_SETTLEMENT_CODE));
            company.setPhone(getString(JSP_PHONE));
            company.setFax(getString(JSP_FAX));
            company.setEmail(getString(JSP_EMAIL));
            company.setWebsite(getString(JSP_WEBSITE));
            company.setUseBkp(getInt(JSP_USE_BKP));
            company.setTaxAmount(getDouble(JSP_TAX_AMOUNT));
            company.setMultiCurrency(getInt(JSP_MULTI_CURRENCY));
            company.setMultiBank(getInt(JSP_MULTI_BANK));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
