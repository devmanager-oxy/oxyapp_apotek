/*
 * I_Fms.java
 *
 * Created on January 28, 2007, 3:04 PM
 */

package com.project;

/**
 *
 * @author  TOSHIBA
 */
public interface I_Project {
    
    public static String PAYMENT_PURPOSE_ROOM  = "Room";
    public static String PAYMENT_PURPOSE_BILLING  = "Billing";    
    public static String PAYMENT_PURPOSE_TELP  = "Telp";
    public static String PAYMENT_PURPOSE_DEPOSIT  = "Deposit";
    public static String PAYMENT_PURPOSE_DEPOSIT_PAYMENT  = "Deposit Payment";
    public static String PAYMENT_PURPOSE_DEPOSIT_REFUND  = "Deposit Refund";
    public static String PAYMENT_PURPOSE_COSTING  = "Costing";    
    
    public static String[] payPurposeArray = {
        PAYMENT_PURPOSE_ROOM, PAYMENT_PURPOSE_BILLING, PAYMENT_PURPOSE_TELP,
        PAYMENT_PURPOSE_DEPOSIT, PAYMENT_PURPOSE_DEPOSIT_PAYMENT, PAYMENT_PURPOSE_DEPOSIT_REFUND,
        PAYMENT_PURPOSE_COSTING
    };
    
    
    public static String NA_NOT_POSTED_STATUS  = "Not Posted";
    public static String NA_PRINTED     =   "Printed";
    public static String NA_POSTED_STATUS  = "Posted";
    
    public static String[] naStatusArray = {
        NA_NOT_POSTED_STATUS, NA_POSTED_STATUS
    };
    
    public static String RESERVATION_STATUS_NEW  = "New";
    public static String RESERVATION_STATUS_GUARANTED  = "Guaranteed";
    public static String RESERVATION_STATUS_GUARANTED_DEPOSIT  = "Guaranteed By Deposit";
    public static String RESERVATION_IN_HOUSE  = "In House";
    public static String RESERVATION_CHECK_OUT  = "Check Out";
    public static String RESERVATION_CANCELED  = "Canceled";
    public static String RESERVATION_TRANSFERED  = "Transfered";
    
    public static String[] rsvStatusArray = {
        RESERVATION_STATUS_NEW, RESERVATION_STATUS_GUARANTED, RESERVATION_STATUS_GUARANTED_DEPOSIT, 
        RESERVATION_IN_HOUSE, RESERVATION_CHECK_OUT,RESERVATION_CANCELED,
        RESERVATION_TRANSFERED
    };
    
    public static String RESERVATION_STATUS_NEW_CODE  = "R";
    public static String RESERVATION_STATUS_GUARANTED_CODE  = "G";
    public static String RESERVATION_STATUS_GUARANTED_DEPOSIT_CODE  = "$";
    public static String RESERVATION_IN_HOUSE_CODE  = "I";
    public static String RESERVATION_CHECK_OUT_CODE  = "O";
    public static String RESERVATION_CANCELED_CODE  = "C";
    public static String RESERVATION_TRANSFERED_CODE  = "T";
    
    public static String[] rsvStatusCodeArray = {
        RESERVATION_STATUS_NEW_CODE, RESERVATION_STATUS_GUARANTED_CODE, RESERVATION_STATUS_GUARANTED_DEPOSIT_CODE, 
        RESERVATION_IN_HOUSE_CODE, RESERVATION_CHECK_OUT_CODE, RESERVATION_CANCELED_CODE,
        RESERVATION_TRANSFERED_CODE
    };  
    
    public static String SOURCE_OF_BOOK_WALKIN  = "Walk In";
    public static String SOURCE_OF_BOOK_TRAVEL_AGENT  = "Travel Agent";
    public static String SOURCE_OF_BOOK_COMPANY  = "Company";
    public static String SOURCE_OF_BOOK_PEMDA  = "Pemda";
    public static String SOURCE_OF_BOOK_OTHER  = "Other";
    
    public static String[] sobArray = {SOURCE_OF_BOOK_WALKIN, SOURCE_OF_BOOK_TRAVEL_AGENT, SOURCE_OF_BOOK_COMPANY, SOURCE_OF_BOOK_PEMDA, SOURCE_OF_BOOK_OTHER};
    
    public static String SALUTATION_NONE  = "";
    public static String SALUTATION_MR  = "Mr.";
    public static String SALUTATION_MRS = "Mrs.";
    public static String SALUTATION_MISS = "Miss";
    public static String SALUTATION_COMP_CV = "CV.";
    public static String SALUTATION_COMP_PT = "PT.";
    public static String SALUTATION_COMP_UD = "UD";
    
    public static String[] salutationArray = {
        SALUTATION_NONE, SALUTATION_MR, SALUTATION_MRS, 
        SALUTATION_MISS, SALUTATION_COMP_CV, SALUTATION_COMP_PT,
        SALUTATION_COMP_UD
    };
    
    public static String STATUS_ACTIVE  = "Active";
    public static String STATUS_HISTORY = "History";
    
    public static String[] statusArray1 = {STATUS_ACTIVE, STATUS_HISTORY};
    
    public static String ID_TYPE_PASSPORT  = "Passport";
    public static String ID_TYPE_KTP = "KTP";
    public static String ID_TYPE_SIM = "SIM";
    public static String ID_TYPE_KTM = "KTM";
    public static String ID_TYPE_KITAS = "KITAS";
    
    public static String[] idTypeArray = {ID_TYPE_PASSPORT, ID_TYPE_KTP, ID_TYPE_SIM, ID_TYPE_KTM, ID_TYPE_KITAS};
    
    public static String PAYMENT_TYPE_CASH  = "Cash";
    public static String PAYMENT_TYPE_BANK_TRANSFER = "Bank Transfer";
    public static String PAYMENT_TYPE_CC = "Credit Card";
    public static String PAYMENT_TYPE_CREDIT = "Credit";
    
    public static String[] paymentTypeArray = {PAYMENT_TYPE_CASH, PAYMENT_TYPE_BANK_TRANSFER, PAYMENT_TYPE_CC, PAYMENT_TYPE_CREDIT};    
    
    public static String[] strPaymentType = {PAYMENT_TYPE_CASH, PAYMENT_TYPE_CREDIT};

    public static String CONTRACT_TYPE_CONTRACT  = "Contract";
    public static String CONTRACR_TYPE_PACKAGE = "Package";
    
    public static String[] contractTypeArray = {CONTRACT_TYPE_CONTRACT, CONTRACR_TYPE_PACKAGE};
    
    public static String SURCHARGE_TYPE_SURCHARGE  = "Surcharge";
    public static String CURCHARGE_TYPE_COMPULSORY = "Compulsory";
    
    public static String[] surchargeTypeArray = {SURCHARGE_TYPE_SURCHARGE, CURCHARGE_TYPE_COMPULSORY};
    
    public static String CONTACT_TYPE_TRAVEL_AGENT = "Travel Agent";
    public static String CONTACT_TYPE_COMPANY = "Company";
    public static String CONTACT_TYPE_GUIDE = "Guide";
    public static String CONTACT_TYPE_PEMDA = "Government";
    
    public static String[] contactTypeArray = {CONTACT_TYPE_TRAVEL_AGENT, CONTACT_TYPE_COMPANY,CONTACT_TYPE_GUIDE,CONTACT_TYPE_PEMDA};
    
    public static String TELP_TYPE_LOCAL = "Local";
    public static String TELP_TYPE_INTERLOCAL = "Interlocal";
    public static String TELP_TYPE_INTERNATIONAL = "International";
    
    public static String[] telpTypeArray = {TELP_TYPE_LOCAL, TELP_TYPE_INTERLOCAL,TELP_TYPE_INTERNATIONAL};
    
    public static String PACKAGE_BILLTYPE_FREE = "Free";
    public static String PACKAGE_BILLTYPE_COMPLIMENT = "Complement";
    public static String PACKAGE_BILLTYPE_PAY = "Pay";
    
    public static String[] packageTypeArray = {PACKAGE_BILLTYPE_FREE, PACKAGE_BILLTYPE_COMPLIMENT,PACKAGE_BILLTYPE_PAY};
    
    
    // -------------htl---------------------
    
    public static final String STATUS_NOT_POSTED   = "Not Posted";
    public static final String STATUS_POSTED   = "Posted";
    
    public static final String[] strStatus  = {STATUS_NOT_POSTED, STATUS_POSTED};
    
    public static final String STATUS_PERIOD_OPEN   = "Open";
    public static final String STATUS_PERIOD_PREPARED_OPEN   = "Prepared Open";
    public static final String STATUS_PERIOD_CLOSED   = "Closed";
    public static final String STATUS_PERIOD_PRE_CLOSED   = "Pre Closed";
    
    public static final String[] strPeriod  = {STATUS_PERIOD_OPEN, STATUS_PERIOD_PREPARED_OPEN, STATUS_PERIOD_CLOSED};
    
    public static final String ACTIVITY_CODE_M   = "M";
    public static final String ACTIVITY_CODE_S   = "S";
    public static final String ACTIVITY_CODE_H   = "H";
    public static final String ACTIVITY_CODE_A   = "A";
    public static final String ACTIVITY_CODE_SA   = "SA";
    public static final String ACTIVITY_CODE_SSA   = "SSA";
    
    public static final String[] strActivities  = {ACTIVITY_CODE_M, ACTIVITY_CODE_S, ACTIVITY_CODE_H, ACTIVITY_CODE_A, ACTIVITY_CODE_SA, ACTIVITY_CODE_SSA};
    
    public static final String CURRENCY_IDR     = "IDR";
    public static final String CURRENCY_USD     = "USD";
    public static final String CURRENCY_EUR     = "EUR";
    
    public static final String[] strCurrency  = {CURRENCY_IDR, CURRENCY_USD, CURRENCY_EUR};
    
    public static final String PAYMENT_METHOD_CASH     = "Cash";
    public static final String PAYMENT_METHOD_BANK_TRANSFER     = "Bank Transfer";
    public static final String PAYMENT_METHOD_CEK     = "Cheque";
    public static final String PAYMENT_METHOD_GIRO     = "Giro";
    public static final String PAYMENT_METHOD_CC     = "Credit Card";
    
    public static final String[] strPayMethod  = {PAYMENT_METHOD_CASH, PAYMENT_METHOD_BANK_TRANSFER, PAYMENT_METHOD_CEK, PAYMENT_METHOD_GIRO, PAYMENT_METHOD_CC};
    
    public static final String ACTIVITY_TYPE_PROGRAMATIC = "PROGRAMATIC";
    public static final String ACTIVITY_TYPE_SUPPORT    = "SUPPORT";
    
    public static final String[] actTypes = {ACTIVITY_TYPE_PROGRAMATIC, ACTIVITY_TYPE_SUPPORT};
    
    public static final String ACCOUNT_LEVEL_HEADER = "HEADER";
    public static final String ACCOUNT_LEVEL_POSTABLE = "POSTABLE";
    
    public static final String[] accLevel = {ACCOUNT_LEVEL_HEADER, ACCOUNT_LEVEL_POSTABLE};
    
    public static final String ACCOUNT_SALDONORMAL_DEBET = "DEBET";
    public static final String ACCOUNT_SALDONORMAL_CREDIT = "CREDIT";
    
    public static final String[] accSaldoNormal = {ACCOUNT_SALDONORMAL_DEBET, ACCOUNT_SALDONORMAL_CREDIT};
    
    
    public static final String ACC_GROUP_LIQUID_ASSET   = "Liquid Assets";
    public static final String ACC_GROUP_FIXED_ASSET    = "Fixed Assets";
    public static final String ACC_GROUP_OTHER_ASSET    = "Other Assets";
    public static final String ACC_GROUP_CURRENT_LIABILITIES        = "Current Liabilities";
    public static final String ACC_GROUP_LONG_TERM_LIABILITIES      = "Long Term Liabilities";
    public static final String ACC_GROUP_EQUITY         = "Equity";
    public static final String ACC_GROUP_REVENUE        = "Revenue";
    public static final String ACC_GROUP_COST_OF_SALES      = "Cost Of Sales";
    public static final String ACC_GROUP_EXPENSE            = "Expense";
    public static final String ACC_GROUP_OTHER_REVENUE   = "Other Revenue";
    public static final String ACC_GROUP_OTHER_EXPENSE   = "Other Expense";
    
    public static final String ACC_GROUP_LIQUID_ASSET_BHS   = "Aset Lancar";
    public static final String ACC_GROUP_FIXED_ASSET_BHS    = "Aset Tetap";
    public static final String ACC_GROUP_OTHER_ASSET_BHS    = "Aset Lainnya";
    public static final String ACC_GROUP_CURRENT_LIABILITIES_BHS        = "Hutang Jangka Pendek";
    public static final String ACC_GROUP_LONG_TERM_LIABILITIES_BHS      = "Hutang Jangka Panjang";
    public static final String ACC_GROUP_EQUITY_BHS         = "Ekuitas";
    public static final String ACC_GROUP_REVENUE_BHS        = "Pendapatan";
    public static final String ACC_GROUP_COST_OF_SALES_BHS      = "Harga Pokok Penjualan";
    public static final String ACC_GROUP_EXPENSE_BHS            = "Biaya";
    public static final String ACC_GROUP_OTHER_REVENUE_BHS   = "Pendapatan Lain-lain";
    public static final String ACC_GROUP_OTHER_EXPENSE_BHS   = "Biaya Lain-lain";
    
    public static final String[] accGroup = {
        ACC_GROUP_LIQUID_ASSET, ACC_GROUP_FIXED_ASSET,
        ACC_GROUP_OTHER_ASSET, ACC_GROUP_CURRENT_LIABILITIES,
        ACC_GROUP_LONG_TERM_LIABILITIES, ACC_GROUP_EQUITY,
        ACC_GROUP_REVENUE, ACC_GROUP_COST_OF_SALES,
        ACC_GROUP_EXPENSE, ACC_GROUP_OTHER_REVENUE,
        ACC_GROUP_OTHER_EXPENSE
    };
    
    public static final String[][] accGroupLang = {
	    {    },
	    {
	        ACC_GROUP_LIQUID_ASSET, ACC_GROUP_FIXED_ASSET,
	        ACC_GROUP_OTHER_ASSET, ACC_GROUP_CURRENT_LIABILITIES,
	        ACC_GROUP_LONG_TERM_LIABILITIES, ACC_GROUP_EQUITY,
	        ACC_GROUP_REVENUE, ACC_GROUP_COST_OF_SALES,
	        ACC_GROUP_EXPENSE, ACC_GROUP_OTHER_REVENUE,
	        ACC_GROUP_OTHER_EXPENSE
	    },
	    {
	        ACC_GROUP_LIQUID_ASSET_BHS, ACC_GROUP_FIXED_ASSET_BHS,
	        ACC_GROUP_OTHER_ASSET_BHS, ACC_GROUP_CURRENT_LIABILITIES_BHS,
	        ACC_GROUP_LONG_TERM_LIABILITIES_BHS, ACC_GROUP_EQUITY_BHS,
	        ACC_GROUP_REVENUE_BHS, ACC_GROUP_COST_OF_SALES_BHS,
	        ACC_GROUP_EXPENSE_BHS, ACC_GROUP_OTHER_REVENUE_BHS,
	        ACC_GROUP_OTHER_EXPENSE_BHS
	    }    
    };
    
    public static final String ACC_LINK_GROUP_CASH                    = "Cash Receive Debet";
    public static final String ACC_LINK_GROUP_CASH_SALES              = "Cash Sales";
    public static final String ACC_LINK_GROUP_PETTY_CASH              = "Petty Cash Payment Debet";
    public static final String ACC_LINK_GROUP_BANK                    = "Bank";
    public static final String ACC_LINK_GROUP_CURRENT_LIABILITIES     = "Current Liabilities";
    public static final String ACC_LINK_GROUP_FUND                    = "Fund";
    public static final String ACC_LINK_GROUP_REVENUE                 = "Revenue";
    public static final String ACC_LINK_GROUP_PERIOD_EARNING          = "Period Earning";
    public static final String ACC_LINK_GROUP_YEARLY_EARNING          = "Yearly Earning";
    public static final String ACC_LINK_GROUP_RETAINED_EARNING        = "Retained Earning";
    
    public static final String ACC_LINK_GROUP_PURCHASING_DISCOUNT     = "Purchasing Discount";
    public static final String ACC_LINK_GROUP_PURCHASING_TAX          = "Purchasing Tax";    
    
    public static final String ACC_LINK_GROUP_INVENTORY               = "Inventory";
    public static final String ACC_LINK_GROUP_NON_INVENTORY           = "Non Inventory";
    public static final String ACC_LINK_GROUP_OTHER_REVENUE           = "Other Revenue";
    public static final String ACC_LINK_GROUP_OTHER_REVENUE_AP        = "Other Revenue AP";
    public static final String ACC_LINK_GROUP_EXPENSE                 = "Expense";
    
    public static final String ACC_LINK_GROUP_EMPLOYEE_ADVANCE        = "Advance";
    public static final String ACC_LINK_GROUP_SUSPENSE_ACCOUNT        = "Suspense Account";
    //baru
    public static final String ACC_LINK_GROUP_CASH_CREDIT                               = "Cash Receive Credit";
    public static final String ACC_LINK_GROUP_PETTY_CASH_CREDIT                         = "Petty Cash Payment Credit";
    public static final String ACC_LINK_GROUP_PETTY_CASH_PAYMENT_SUSPENSE_ACCOUNT       = "Petty Cash Payment Suspense Account";
    public static final String ACC_LINK_GROUP_PETTY_CASH_PAYMENT_KASBON                 = "Petty Cash Payment Kasbon"; 
    
    public static final String ACC_LINK_GROUP_BANK_DEPOSIT_DEBET             = "Bank Deposit Debet";
    public static final String ACC_LINK_GROUP_BANK_DEPOSIT_CREDIT            = "Bank Deposit Credit";    
    public static final String ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT         = "Bank PO Credit";
    public static final String ACC_LINK_GROUP_BANK_NOPO_PAYMENT_DEBET        = "Bank NONPO Debet";
    public static final String ACC_LINK_GROUP_BANK_NOPO_PAYMENT_CREDIT       = "Bank NONPO Credit";    
    public static final String ACC_LINK_GROUP_BANK_PAYMENT_SUSPENSE_ACCOUNT       = "Bank Payment Suspense Account";
    public static final String ACC_LINK_ACCOUNT_BUDGET_EXPENSE                      = "Account Budget Expense";
    public static final String ACC_LINK_ACCOUNT_REKENING_BG                      = "Account Rekening BG";
    public static final String ACC_LINK_ACCOUNT_BANK                      = "Account Bank";
    
    public static final String ALL_LINK_ACCOUNT_RECEIVABLE                          = "Account Receivable";
    public static final String ALL_LINK_ACCOUNT_RECEIVABLE_PAY_RECEIVER             = "Account Receivable Payment Receiver";
    public static final String ALL_LINK_ACCOUNT_GIRO                                = "Account Giro";
    
    public static final String ACC_LINK_PINJAMAN_ADM_DEBET = "Administrasi Pinjaman Debet";
    public static final String ACC_LINK_PINJAMAN_ADM_CREDIT = "Administrasi Pinjaman Credit";
    public static final String ACC_LINK_PINJAMAN_DEBET = "Pinjaman Debet";
    public static final String ACC_LINK_PINJAMAN_CREDIT = "Pinjaman Credit";
    public static final String ACC_LINK_PINJAMAN_BUNGA_DEBET = "Bunga Pinjaman Debet";
    public static final String ACC_LINK_PINJAMAN_BUNGA_CREDIT = "Bunga Pinjaman Credit";
    public static final String ACC_LINK_PINJAMAN_DENDA_DEBET = "Denda Pinjaman Debet";
    public static final String ACC_LINK_PINJAMAN_DENDA_CREDIT = "Denda Pinjaman Credit";    
    public static final String ACC_LINK_PINJAMAN_BANK_DEBET = "Hutang Bank Debet";    
    public static final String ACC_LINK_PINJAMAN_BANK_CREDIT = "Hutang Bank Credit";    
    public static final String ACC_LINK_PINJAMAN_PINALTI_DEBET = "Pinalti Debet";    
    public static final String ACC_LINK_PINJAMAN_PINALTI_CREDIT = "Pinalti Credit";    
    
    public static final String ACC_LINK_CASH_BACK_DEBET = "Cash Back Debet";    
    public static final String ACC_LINK_CASH_BACK_CREDIT = "Cash Back Credit";    
    
    
    public static String[] arAccLink = {
        ALL_LINK_ACCOUNT_RECEIVABLE, ALL_LINK_ACCOUNT_RECEIVABLE_PAY_RECEIVER,ALL_LINK_ACCOUNT_GIRO
    };
    
    public static String[] cashAccLinks = {
        ACC_LINK_GROUP_CASH, ACC_LINK_GROUP_CASH_CREDIT, ACC_LINK_GROUP_PETTY_CASH, ACC_LINK_GROUP_PETTY_CASH_CREDIT,
        ACC_LINK_GROUP_PETTY_CASH_PAYMENT_SUSPENSE_ACCOUNT,ACC_LINK_GROUP_PETTY_CASH_PAYMENT_KASBON,ACC_LINK_GROUP_CASH_SALES,
        ACC_LINK_CASH_BACK_DEBET,ACC_LINK_CASH_BACK_CREDIT
    }; 
    
    public static String[] bankAccLinks = {
        ACC_LINK_GROUP_BANK_DEPOSIT_DEBET, ACC_LINK_GROUP_BANK_DEPOSIT_CREDIT, ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT, 
        ACC_LINK_GROUP_BANK_NOPO_PAYMENT_DEBET, ACC_LINK_GROUP_BANK_NOPO_PAYMENT_CREDIT, ACC_LINK_GROUP_EMPLOYEE_ADVANCE,ACC_LINK_GROUP_BANK_PAYMENT_SUSPENSE_ACCOUNT,
        ACC_LINK_ACCOUNT_REKENING_BG,ACC_LINK_ACCOUNT_BANK
    }; 
    
    public static String[] budgetAccLinks = {
        ACC_LINK_ACCOUNT_BUDGET_EXPENSE         
    }; 
    
    public static String[] pinjamanAccLink = {
        ACC_LINK_PINJAMAN_ADM_DEBET, ACC_LINK_PINJAMAN_ADM_CREDIT, ACC_LINK_PINJAMAN_DEBET, 
        ACC_LINK_PINJAMAN_CREDIT, ACC_LINK_PINJAMAN_BUNGA_DEBET, ACC_LINK_PINJAMAN_BUNGA_CREDIT, 
        ACC_LINK_PINJAMAN_DENDA_DEBET, ACC_LINK_PINJAMAN_DENDA_CREDIT, ACC_LINK_PINJAMAN_BANK_DEBET,
        ACC_LINK_PINJAMAN_BANK_CREDIT, ACC_LINK_PINJAMAN_PINALTI_DEBET,
        ACC_LINK_PINJAMAN_PINALTI_CREDIT
    };
    
    
    public static final String[] accLinkGroup = {
        ACC_LINK_GROUP_CASH, ACC_LINK_GROUP_PETTY_CASH,
        ACC_LINK_GROUP_BANK, ACC_LINK_GROUP_CURRENT_LIABILITIES,
        ACC_LINK_GROUP_FUND, ACC_LINK_GROUP_REVENUE,
        ACC_LINK_GROUP_PERIOD_EARNING, ACC_LINK_GROUP_YEARLY_EARNING,
        ACC_LINK_GROUP_RETAINED_EARNING, ACC_LINK_GROUP_EMPLOYEE_ADVANCE
    };
    
    public static final String[] accLinkGroup1 = {
        ACC_LINK_GROUP_SUSPENSE_ACCOUNT, ACC_LINK_GROUP_PURCHASING_DISCOUNT,
        ACC_LINK_GROUP_PURCHASING_TAX, ACC_LINK_GROUP_INVENTORY, ACC_LINK_GROUP_NON_INVENTORY,ACC_LINK_GROUP_OTHER_REVENUE,ACC_LINK_GROUP_OTHER_REVENUE_AP,ACC_LINK_GROUP_EXPENSE
    };
    
    //--------------- HRD -------------
    
    public static final String MARITAL_S     = "S";
    public static final String MARITAL_M     = "M";
    public static final String MARITAL_M1     = "M1";
    public static final String MARITAL_M2     = "M2";
    public static final String MARITAL_M3     = "M3";
    public static final String MARITAL_D     = "D";
    
    public static final String[] strMarital  = {MARITAL_S, MARITAL_M, MARITAL_M1, MARITAL_M2, MARITAL_M3, MARITAL_D};
    
    public static final String ID_KTP     = "KTP";
    public static final String ID_PASSPORT     = "PASSPORT";
    public static final String ID_KITAS     = "KITAS";
    public static final String ID_OTHER     = "Other";
    
    public static final String[] strId  = {ID_KTP, ID_PASSPORT, ID_KITAS, ID_OTHER};
    
    public static String STATUS_RESIGNED  = "Resigned";
    
    public static String[] statusArray2 = {STATUS_ACTIVE, STATUS_RESIGNED};
    
    
    public static final String EMP_TYPE_CONTRACTUAL = "Contractual";
    public static final String EMP_TYPE_PERMANENT = "Permanent";    
    public static final String EMP_TYPE_TRAINEE = "Trainee";
    public static final String EMP_TYPE_DW = "DW";
    
    public static final String[] empType = {EMP_TYPE_CONTRACTUAL, EMP_TYPE_DW, EMP_TYPE_PERMANENT, EMP_TYPE_TRAINEE};    
    
    public static final String EMP_RESIGN_RESON_RESIGN = "Resign";
    public static final String EMP_RESIGN_RESON_FIRED = "Fired";    
    public static final String EMP_RESIGN_RESON_END_CONTRACT = "End Contract";
    public static final String EMP_RESIGN_RESON_OTHER = "Other";
    
    public static final String[] empResignReason = {EMP_RESIGN_RESON_RESIGN, EMP_RESIGN_RESON_FIRED, EMP_RESIGN_RESON_END_CONTRACT, EMP_RESIGN_RESON_OTHER};
    
    //-----------
    public static final String ACCOUNTING_PERIOD_STATUS_OPEN = "OPEN";
    public static final String ACCOUNTING_PERIOD_STATUS_CLOSED = "CLOSED";
    
    public static final String[] accPeriodStatus = {ACCOUNTING_PERIOD_STATUS_OPEN, ACCOUNTING_PERIOD_STATUS_CLOSED};
    
    public static int MONTH_JAN = 0;
    public static int MONTH_FEB = 1;
    public static int MONTH_MAR = 2;
    public static int MONTH_APR = 3;
    public static int MONTH_MAY = 4;
    public static int MONTH_JUN = 5;
    public static int MONTH_JUL = 6;
    public static int MONTH_AUG = 7;
    public static int MONTH_SEP = 8;
    public static int MONTH_OCT = 9;
    public static int MONTH_NOV = 10;
    public static int MONTH_DEC = 11;
    
    public static final String[] shortMonths = {
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    };
    
    public static final String[] longMonths = {
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    };    
    
    public static String GL                     = "gl";
    public static String GL_2015                = "gl_2015";
    public static String GL_2016                = "gl_2016";
    public static String GL_2017                = "gl_2017";
    public static String GL_2018                = "gl_2018";
    public static String GL_2019                = "gl_2019";
    public static String GL_2020                = "gl_2020";  
    
    
    public static int JOURNAL_TYPE_CASH_RECEIVE                     = 0;
    public static int JOURNAL_TYPE_PETTYCASH_PAYMENT                = 1;
    public static int JOURNAL_TYPE_PETTYCASH_REPLENISHMENT          = 2;
    public static int JOURNAL_TYPE_BANK_DEPOSIT                     = 3;
    public static int JOURNAL_TYPE_BANKPAYMENT_PO                   = 4;
    public static int JOURNAL_TYPE_BANKPAYMENT_NONPO                = 5;
    public static int JOURNAL_TYPE_PURCHASE_ORDER                   = 6;
    public static int JOURNAL_TYPE_GENERAL_LEDGER                   = 7;
    public static int JOURNAL_TYPE_INVOICE                          = 8;    
    public static int JOURNAL_TYPE_SALES                            = 9;
    public static int JOURNAL_TYPE_AKRUAL                           = 10;
    public static int JOURNAL_TYPE_PINJAMAN_KOPERASI                = 11;
    public static int JOURNAL_TYPE_PINJAMAN_BANK                    = 12;
    public static int JOURNAL_TYPE_PEMBAYARAN_PINJAMAN_KOPERASI     = 13;
    public static int JOURNAL_TYPE_PEMBAYARAN_PINJAMAN_BANK         = 14;
    public static int JOURNAL_TYPE_PELUNASAN_TUNAI                  = 15;
    public static int JOURNAL_TYPE_KASBON                           = 16;    
    public static int JOURNAL_TYPE_AUTO_REVERSE_BY_EXCHANGERATE     = 17;
    public static int JOURNAL_TYPE_BACKDATED_GL     		    = 18;
    public static int JOURNAL_TYPE_ADJUSMENT     		    = 19;
    public static int JOURNAL_TYPE_COSTING         		    = 20; 
    public static int JOURNAL_TYPE_AP_MEMO         		    = 21; 
    public static int JOURNAL_TYPE_BANK_PAYMENT                     = 22;
    public static int JOURNAL_TYPE_RETUR                            = 23;
    public static int JOURNAL_TYPE_CREDIT_PAYMENT                   = 24;
    public static int JOURNAL_TYPE_AR_MEMO                          = 25;
    public static int JOURNAL_TYPE_REVERSE                          = 26;
    public static int JOURNAL_TYPE_COPY                             = 27;
    public static int JOURNAL_TYPE_PEMAKAIAN_KASBON                 = 28; 
    public static int JOURNAL_TYPE_REPACK                           = 29; 
    public static int JOURNAL_TYPE_GIRO_MASUK                       = 30; 
    public static int JOURNAL_TYPE_GIRO_KELUAR                      = 31; 
    public static int JOURNAL_TYPE_PIUTANG_CARD                     = 32; 
    public static int JOURNAL_TYPE_SELISIH_KASIR                    = 33;
    public static int JOURNAL_TYPE_GENERAL_AFFAIR                   = 34;
    public static int JOURNAL_TYPE_CASH_BACK                        = 35;
    public static int JOURNAL_TYPE_BANK_PAYMENT_GROUP               = 36;
    public static int JOURNAL_TYPE_AP_CLEREANCE                     = 37;
    public static final int JOURNAL_TYPE_ADVANCE_REVERSE            = 38;
    public static final int JOURNAL_TYPE_NON_TRADE                  = 39;
    public static final int JOURNAL_TYPE_NON_TRADE_CLEARANCE        = 40;    
    
    
    public static String PURCHASE_STATUS_OPEN                   = "OPEN";
    public static String PURCHASE_STATUS_CLOSED                 = "CLOSED";
    
    public static String[] purchStatusString = {PURCHASE_STATUS_OPEN, PURCHASE_STATUS_CLOSED};  
    
    public static int TYPE_INT_PAYMENT = 0;
    public static int TYPE_INT_EMPLOYEE_ADVANCE = 1;
    
    public static String TYPE_PAYMENT = "Payment";
    public static String TYPE_EMPLOYEE_ADVANCE = "Advance";
    
    public static final String[] nonpoTypeGroup = {
        TYPE_PAYMENT, TYPE_EMPLOYEE_ADVANCE
    };
    
    public static final int INV_STATUS_DRAFT = 0;
    public static final int INV_STATUS_PARTIALY_PAID = 1;
    public static final int INV_STATUS_FULL_PAID = 2;    
    
    public static final String[] invStatusStr = {"Draft", "Partialy Paid", "Fully Paid"};
    
    public static final int AGE_DUE_DATE = 0;
    public static final int AGE_INVOICE_DATE = 1;
    public static final String[] ageDateStr = {"Due Date", "Invoice Date"};
    
    public static final int AGE_RANGE_CURRENT = 0;
    public static final int AGE_RANGE_OVER_30 = 1;
    public static final int AGE_RANGE_OVER_60 = 2;
    public static final int AGE_RANGE_OVER_90 = 3;
    public static final int AGE_RANGE_OVER_120 = 4;
    public static final String[] ageRangeStr = {"Current", "Over 30", "Over 60", "Over 90", "Over 120"};
    
    
     // --------------------- crm -------------------
    
    public static String STATUS_DRAFT = "Draft";
    public static String STATUS_PROCEED = "Proceed";
    public static String STATUS_APPROVED = "Approved";
    public static String STATUS_CANCELED = "Canceled";
    public static String STATUS_CHECKED = "Checked";
    public static String STATUS_CLOSED = "Closed";
    public static String STATUS_TO_BE_APPROVED = "To Be Approved";
    public static String STATUS_REVISED = "Revised";
    public static String STATUS_AMENDED = "Amended";
    
    public static String[] statusList_1 = {STATUS_DRAFT, STATUS_PROCEED};
    
    public static final int TYPE_APPROVAL_LIMBAH                        = 0;
    public static final int TYPE_APPROVAL_IRIGASI                       = 1;
    public static final int TYPE_APPROVAL_ASSESMENT                     = 2;
    public static final int TYPE_APPROVAL_KOMIN                         = 3;
    public static final int TYPE_APPROVAL_KOMPER                        = 4;
    public static final int TYPE_FAKTUR_PAJAK                           = 5;
    public static final int TYPE_BUDGET_SUPLIER                         = 6;
    public static final int TYPE_APPROVAL_KASBON                        = 7;
    public static final int TYPE_APPROVAL_GL                            = 8;
    public static final int TYPE_APPROVAL_GL_REVERSE                    = 9;
    public static final int TYPE_APPROVAL_GL_COPY                       = 10;
    //public static final int = 11;
    public static final int TYPE_APPROVAL_BKK                           = 12;
    public static final int TYPE_APPROVAL_BKM                           = 13;
    public static final int TYPE_APPROVAL_CASH_REGISTER                 = 14;
    public static final int TYPE_APPROVAL_JOURNAL                       = 15;
    public static final int TYPE_APPROVAL_KAS_OPNAME                    = 16;
    public static final int TYPE_APPROVAL_BKM_BANK                      = 17;
    public static final int TYPE_APPROVAL_BKK_BANK                      = 18;
    public static final int TYPE_APPROVAL_SALES_GA                      = 19;
    public static final int TYPE_APPROVAL_ADJUSMENT_GA                  = 20;
    public static final int TYPE_APPROVAL_TT_CEK                        = 21;
    public static final int TYPE_APPROVAL_NON_TRADE                     = 22;
    
    public static final String[] approvalTypeKey = {
        "0", "1", "2", "3", "4",
        "5","6","7","8","9","10","11", //SLOT KOSONG
        "12", "13","14","15","16","17","18","19","20","21","22"
    };
    
    public static final String[] approvalTypeStr = {
        "Pendapatan Limbah","Pendapatan Irigasi","Assesment","Kompensasi Minimum","Kompensasi Persentase", //0-4
        "Faktur Pajak", "Report Budget Suplier", "Kasbon", "Journal Umum", "Journal Reverse", "Journal Copy", "11", //5-11 SLOT KOSONG
        "Bkk Kas","Bkm Kas","Cash Register","Journal","Cash Opname","Bkm Bank","Bkk Bank","Sales GA","Adjusment GA" //12-20
        ,"TT_CEK", "Non Trade"        
    };
    
    // ----------------------- ccs ----------------------
    
    public static final String DO_CODE = "DO";
    public static final String PO_CODE = "PO";
    public static final String REC_CODE = "RC";    
    public static final String ADJ_CODE = "AD"; 
    public static final String TR_CODE = "TR"; 
    
    
    public static final String STATUS_DOC_DRAFT             = "Draft";     
    public static final String STATUS_DOC_TO_BE_APPROVED    = "To Be Approved";     
    public static final String STATUS_DOC_APPROVED          = "Approved";     
    public static final String STATUS_DOC_PROCEED           = "Proceed";        
    public static final String STATUS_DOC_CLOSED            = "Closed";     
    public static final String STATUS_DOC_POSTED            = "Posted";   
    
    public static final String[] userUniqueID = {
        "345265326871278247370419", 
        "365467343578853338936075",
        "456376434911291459370411",
        "415972392835181247269303",
        "395770372893099582158292",
        "456376434911291459370411",
        "516982497137321594481521",
        "436174419434746550825969",
        "405871387876185960269307",
        "345265326871299582150411",
        "456373928351819434746137",
        "376413878361742159448434",
        "491129387712969307345265",
        "441943713732448434532683",
        "138783617138712939283582"
    };        
    
    public static final String[] userLevel = {
        "9160411815592634",//admin
        "3578853338936075",//manager
        "7137321594481521",//supervisor
        "2835181247269303",//user                
        "9093306947481528",                
        "9434746550825969",
        "0752070837158293",
        "4911291459370411",
        "2893099582158292",
        "6554767425825960",
        "9434746583715947",
        "7083709958069474",
        "1812471594489360",
        "5508259347465500",
        "3732159145993704"
    };
    
    public static final String[] userLevelString = {
        "Admin",
        "Manager", 
        "Supervisor", 
        "User 1", 
        "User 2", 
        "User 3",
        "User 4",
        "User 5",
        "User 6",
        "User 7",
        "User 8",
        "User 9",
        "User 10",
        "User 11",
        "User 12"
    };
    
    
    public static final int USER_NUMBER_1   = 1;
    public static final int USER_NUMBER_5   = 5;
    public static final int USER_NUMBER_10  = 10;
    public static final int USER_NUMBER_15  = 15;
    
    public static final int SYSTEM_USER_SCOPE = USER_NUMBER_10;
    
    public static final String LOCATION_TYPE_COOLER    = "With Cooler";
    public static final String LOCATION_TYPE_DRY       = "Dry";
    
    public static final String[] locTypeStr = {LOCATION_TYPE_COOLER, LOCATION_TYPE_DRY};
    
    public static final String ITEM_TYPE_INVENTORY = "Inventory";
    public static final String ITEM_TYPE_SERVICE = "Service";
    public static final String ITEM_TYPE_LABOR = "Labor";
    public static final String ITEM_TYPE_OVERHEAD = "Overhead";
    public static final String ITEM_TYPE_NON_INVENTORY = "Non-Inventory";
    public static final String ITEM_TYPE_INTERNAL_USED = "Internal Used";
    public static final String ITEM_TYPE_CAPITAL_EQUIPEMENT = "Capital Equipement";
    public static final String ITEM_TYPE_SHIPPING = "Shipping";
    
    public static final String[] strItemType = {
        ITEM_TYPE_INVENTORY, ITEM_TYPE_SERVICE, ITEM_TYPE_LABOR, ITEM_TYPE_OVERHEAD,
        ITEM_TYPE_NON_INVENTORY, ITEM_TYPE_INTERNAL_USED, ITEM_TYPE_CAPITAL_EQUIPEMENT, ITEM_TYPE_SHIPPING
    };
    
    // ======== additional from pos ============
    
    public static String DOC_STATUS_DRAFT = "DRAFT";
    public static String DOC_STATUS_APPROVED = "APPROVED";
    public static String DOC_STATUS_CHECKED = "CHECKED";
    public static String DOC_STATUS_CLOSE = "CLOSED";
    public static String DOC_STATUS_POSTED = "POSTED";
    public static String DOC_STATUS_EXPIRED = "EXPIRED";
    public static String DOC_STATUS_CANCELED = "CANCELED";

    
    public static int NOT_POSTED = 0;
    public static int POSTED = 1;
    
    public static String[] strStatusDocument = {DOC_STATUS_DRAFT , DOC_STATUS_APPROVED, DOC_STATUS_CHECKED, DOC_STATUS_CLOSE,DOC_STATUS_EXPIRED};    
    
    public static int BUSINESS_TYPE_COMMON = 0;
    public static int BUSINESS_TYPE_RETAIL = 1;
    public static int BUSINESS_TYPE_NGO = 2;    
    public static int BUSINESS_TYPE_PROPERTY = 3;

}