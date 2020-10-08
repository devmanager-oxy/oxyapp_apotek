/*
 * AppMenu.java
 *
 * Created on March 28, 2008, 3:41 PM
 */

package com.project.admin;

/**
 *
 * @author  Valued Customer
 */
public class AppMenuOld {
    
    
    public static int PRIV_VIEW         = 0;
    public static int PRIV_ADD          = 1;
    public static int PRIV_UPDATE       = 2;
    public static int PRIV_DELETE       = 3;
    
    
    /** Creates a new instance of AppMenu */
    public AppMenuOld() {
    }
    
    public static final int M1_MENU_HOMEPAGE             = -1;
    
    public static final int M1_MENU_CASH             = 0;
    /***/public static final int M2_MENU_CASH_RECERIVE                  = 0;
    /***/public static final int M2_MENU_CASH_PETTYCASH_PAYMENT         = 1;
    /***/public static final int M2_MENU_CASH_PETTYCASH_REPLENISHMENT   = 2;
    /***/public static final int M2_MENU_CASH_ACCLINK                   = 3;        
    /***/public static final int M2_MENU_CASH_ARCHIVES                  = 4;        
        
    public static final int M1_MENU_BANK             = 1;
    /***/public static final int M2_MENU_BANK_DEPOSIT                   = 0;
    /***/public static final int M2_MENU_BANK_PAYMENT_ON_PO             = 1;
    /***/public static final int M2_MENU_BANK_PAYMENT_NON_PO            = 2;
    /***/public static final int M2_MENU_BANK_ACCLINK                   = 3;        
    /***/public static final int M2_MENU_BANK_ARCHIVES                  = 4;        
    
    public static final int M1_MENU_ACCPAYABLE       = 2;
    /***/public static final int M2_MENU_ACCPAYABLE_INVOICE            = 0;
    /***/public static final int M2_MENU_ACCPAYABLE_ARCHIVES           = 1;
        
    public static final int M1_MENU_PURCHASE         = 3;
    /***/public static final int M2_MENU_PURCHASE_NEWORDER          = 0;
    /***/public static final int M2_MENU_PURCHASE_VENDOR            = 1;
    /***/public static final int M2_MENU_PURCHASE_ACCLINK           = 2;
    /***/public static final int M2_MENU_PURCHASE_ARCHIVES          = 3;
    
    public static final int M1_MENU_GENERALLEDGER    = 4;
    /***/public static final int M2_MENU_GENERALLEDGER_NEWGL          = 0;
    /***/public static final int M2_MENU_GENERALLEDGER_ARCHIVES       = 1;
    
    public static final int M1_MENU_FINANCEREPROT    = 5;
    /***/public static final int M2_MENU_FINANCEREPROT         = 0;
    
    public static final int M1_MENU_DONORREPORT      = 6;
    /***/public static final int M2_MENU_DONORREPORT         = 0;
    
    public static final int M1_MENU_DATASYNC         = 7;
    /***/public static final int M2_MENU_DATASYNC         = 0;
    
    public static final int M1_MENU_ADMINISTRATOR    = 8;
    /***/public static final int M2_MENU_ADMINISTRATOR         = 0;

    public static final int M1_MENU_MASTER           = 9;
    /***/public static final int M2_MENU_CONFIGURATION              = 0;
    /***/public static final int M2_MENU_ACC_COA                    = 1;
    /***/public static final int M2_MENU_ACC_COA_CATEGORY           = 2;
    /***/public static final int M2_MENU_ACC_COA_GROUP_ALIAS        = 3;
    /***/public static final int M2_MENU_ACC_BOOKEEPING_RATE        = 4;
    /***/public static final int M2_MENU_ACC_PERIOD                 = 5;
    /***/public static final int M2_MENU_WORKPLAN_DATA                      = 6;
    /***/public static final int M2_MENU_WORKPLAN_EXPENSE_ALLOCATION        = 7;
    /***/public static final int M2_MENU_WORKPLAN_DONOR_LIST                = 8;
    /***/public static final int M2_MENU_WORKPLAN_PERIOD                    = 9;
    /***/public static final int M2_MENU_HRD_EMPLOYEE                       = 10;
    /***/public static final int M2_MENU_HRD_DEPARTMENT                     = 11;
    /***/public static final int M2_MENU_GENERAL_COUNTRY                    = 12;
    /***/public static final int M2_MENU_GENERAL_CURRENCY                   = 13;
    /***/public static final int M2_MENU_GENERAL_TERMOFPAYMENT              = 14;
    /***/public static final int M2_MENU_GENERAL_SHIPPING_ADDRESS           = 15;
    /***/public static final int M2_MENU_GENERAL_PAYMENT_METHOD             = 16;
    /***/public static final int M2_MENU_GENERAL_LOCATION                   = 17;
    
    public static final int M1_MENU_CLOSING                 = 10;
    /***/public static final int M2_MENU_CLOSING_ACCOUNT_PERIOD             = 0;
    /***/public static final int M2_MENU_CLOSING_YEARLY                     = 1;
    /***/public static final int M2_MENU_CLOSING_ACTIVITY_PERIOD            = 2;
    
    public static final int M1_MENU_ACCRECEIVABLE           = 11;
    /***/public static final int M2_MENU_NEW_ACCRECEIVABLE            = 0;
    /***/public static final int M2_MENU_ACCRECEIVABLE_CUSTOMER            = 1;
    /***/public static final int M2_MENU_ACCRECEIVABLE_ARCHIVES           = 2;
    
    public static final String[] strMenu1 = {
        "Menu Cash", "Menu Bank", 
        "Menu Account Payable", "Menu Purchase",
        "Menu General Ledger", "Menu Financial Report", 
        "Menu Donor Report", "Menu Data Synchronization",
        "Menu Administrator", "Menu Master",
        "Closing Period", "Menu Account Receivable"
        
    };
    
    public static final String[][] strMenu2 = {
        //Menu Cash
        {"Cash Receipt", "Petty Cash Payment", "Petty Cash Replenishment", 
         "Cash AccLink", "Cash Archives"},
        
         //Menu Bank
        {"Bank Deposit", "Bank Payment On PO", "Bank Payment Non PO", "Bank AccLink", 
         "Bank Archives"},
        
         //Menu AccPayable
        {"AP - Invoice", "AP - Archives"},
        
        //Menu Purchase
        {"PO - New Order", "PO - Vendor", "PO - AccLink", "PO - Archives"},
        
        //Menu GenLedger
        {"GL - New GL", "GL - Archives"},
        
        //Menu FinReport
        {"Financial Report"},
        
        //Menu DnrReport
        {"Donor Report"},
        
        //Menu DataSync
        {"Data Synchronization"},
        
        //Menu Administrator
        {"Menu Administrator"},
        
        //master
        {"Configuration", "Acc Coa", "Acc Category",
         "Acc Group Alias", "Acc Bookeeping Rate", "Acc Period",
         "Workplan Data", "Workplan Expense Alloc", "Workplan Donor",
         "Workplan Period", "HRD Employee", "HRD Department",
         "General Country", "General Currency", "General Term Of Payment",
         "General Shipping Addr", "General Pay Method", "General Location"},
         
        //closing
        {"Account Period", "Yearly Period", "Activity Period"},
        
        //AR
        {"Create New Sales", "Customer", "View AR - Archives"}
        
    };
    
    
    
    public static void main(String[] args){
        System.out.println(strMenu2[0]);
    }

    
}
