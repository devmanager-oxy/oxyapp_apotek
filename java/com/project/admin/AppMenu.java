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
public class AppMenu {    
    
    public static int PRIV_VIEW         = 0;
    public static int PRIV_ADD          = 1;
    public static int PRIV_UPDATE       = 2;
    public static int PRIV_DELETE       = 3;
    public static int PRIV_PRINT       	= 4;
    public static int PRIV_POSTING      = 5;
    
    //finance system only - open if finance system operated
    public static int MENU_CONTSTAN_START = 0;
    public static int MENU_CONTSTAN_END = 399;
    
    //retail system only - open if retail system operated
    public static int MENU_CONTSTAN_RETAIL_START = 100;
    public static int MENU_CONTSTAN_RETAIL_END = 199;
    
    //crm system only - open if crm system operated
    public static int MENU_CONTSTAN_CRM_START = 200;
    public static int MENU_CONTSTAN_CRM_END = 299;
    
    //sales system only - open if sales system operated
    public static int MENU_CONTSTAN_SALES_START = 300;
    public static int MENU_CONTSTAN_SALES_END = 399;
    
    public static int MENU_CONTSTAN_PROPERTY_START = 400;
    public static int MENU_CONTSTAN_PROPERTY_END = 405;
    
    
    /** Creates a new instance of AppMenu */
    public AppMenu() {
    }
    
    public static final int M1_MENU_HOMEPAGE                = -1;
    
    public static final int MENU_FINANCE_CONSTANT = 0;
    
    /******************************************** Begin Finance ********************************************/
    
    public static final int M1_MN_CASH                     = 0;
    /***/public static final int M2_MN_CR                               = 0;    //CASH_RECERIVE
    /***/public static final int M2_MN_CRA                              = 1;    //CASH_RECEIVE_ADVANCE //Penerimaan Kasbon
    /***/public static final int M2_MN_CPP                              = 2;    //CASH_PETTYCASH_PAYMENT  
    /***/public static final int M2_MN_CP                               = 3;    //CASH_PAYMENT//Pembayaran Tunai
    /***/public static final int M2_MN_CPPA                             = 4;    //CASH_PETTYCASH_PAYMENT_ADVANCE//Kasbon
    /***/public static final int M2_MN_CPR                              = 5;    //CASH_PETTYCASH_REPLENISHMENT
    /***/public static final int M2_MN_CRP                              = 6;    //CASH_RECEIVE_POST
    /***/public static final int M2_MN_CAR                              = 7;    //CASH_ARCHIVES
    /***/public static final int M2_MN_CA                               = 8;    //CASH_ACCLINK    
    /***/public static final int M2_MN_REPORT_CASH_REGISTER             = 9;    //KAS REGISTER
    /***/public static final int M2_MN_CASH_OPNAME                      = 10;   //KAS OPNAME 
    /***/public static final int M2_MN_APPROVE_BKK             		= 11;   //APPROVE BKK
    /***/public static final int M2_MN_APPROVE_BKM             		= 12;   //APPROVE BKM 
    /***/public static final int M2_MN_BKK_ANGGARAN            		= 13;   //BKK ANGGARAN 
    /***/public static final int M2_MN_ADVANCE_REIMBURSEMENT   		= 14;   
    /***/public static final int M2_MN_SETORAN_KASIR   		        = 15;  
        
    public static final int M1_MN_B                         = 1;                //M1_MENU_BANK
    /***/public static final int M2_MN_BD                               = 0;    //M2_MENU_BANK_DEPOSIT
    /***/public static final int M2_MN_BPO                              = 1;    //M2_MENU_BANK_PAYMENT_ON_PO
    /***/public static final int M2_MN_BC                               = 2;    //M2_MENU_BANK_CASH_PAYMENT
    /***/public static final int M2_MN_BPN                              = 3;    //M2_MENU_BANK_PAYMENT_NON_PO    
    /***/public static final int M2_MN_BP                               = 4;    //M2_MENU_BANK_POST      
    /***/public static final int M2_MN_BA                               = 5;    //M2_MENU_BANK_ARCHIVES     
    /***/public static final int M2_MN_BL                               = 6;    //M2_MENU_BANK_ACCLINK  
    /***/public static final int M2_MN_RECON_CREDIT_CARD                = 7;    //M2_RECON_CREDIT CARD
    /***/public static final int M2_MN_GENERATE_BG                      = 8;       
    /***/public static final int M2_MN_BANK_BG_OUTSTANDING              = 9;    
    /***/public static final int M2_MN_BANK_REPORT                      = 10;    
    
    public static final int M1_MENU_AP                      = 2;                //M1_MENU_ACCRECEIVEABLE
    /***/public static final int M2_MENU_AA                             = 0;    //M2_MENU_AGING_ANALYSIS
    /***/public static final int M2_MENU_ARL                            = 1;    //M2_MENU_AR_ACC_LIST    
    
    public static final int M1_MENU_APAY                    = 3;                //M1_MENU_ACCOUNT_PAYBLE
    /***/public static final int M2_MENU_IGL                            = 0;    //M2_MENU_INCOMING_GOOD_LIST
    /***/public static final int M2_MENU_ILI                            = 1;    //M2_MENU_INVOICE_LIST
    /***/public static final int M2_MENU_AAN                            = 2;    //M2_MENU_AGING_ANALYSIS
    /***/public static final int M2_MENU_PAL                            = 3;    //M2_MENU_PURCHASE_ACC_LIST    
    /***/public static final int M2_MENU_SELEKSI_INVOICE                = 4;    
    /***/public static final int M2_MENU_SELEKSI_POST                   = 5;    
    /***/public static final int M2_MENU_INVOICE_PAYMENT                = 6;        
    /***/public static final int M2_MENU_AP_MEMORIAL                    = 7;
    /***/public static final int M2_MENU_AP_MEMORIAL_POST               = 8;
    /***/public static final int M2_MENU_BUDGET_REPORT                  = 9;
    /***/public static final int M2_MENU_BG_OUTSTANDING                 = 10;
    /***/public static final int M2_MENU_ARSIP_BG                       = 11;
    /***/public static final int M2_MENU_RELEASE_INVOICE                = 12;
    /***/public static final int M2_MENU_BUDGET_REPORT_GA               = 13;
    /***/public static final int M2_MENU_BUDGET_REPORT_SUMMARY          = 14;
    
    public static final int M1_MN_GL                        = 4;
    /***/public static final int M2_MN_GL                               = 0;
    /***/public static final int M2_MN_POST_GL                          = 1;
    /***/public static final int M2_MN_GL_ARCHIVES                      = 2;
    /***/public static final int M2_MN_GL13                             = 3;
    /***/public static final int M2_MN_POST_GL13                        = 4;
    /***/public static final int M2_MN_GL13_ARCHIVES                    = 5;
    /***/public static final int M2_MN_GL_BACKDATED                     = 6;
    /***/public static final int M2_MN_POST_GL_BACKDATED                = 7;
    /***/public static final int M2_MN_GL_COPY                          = 8;
    /***/public static final int M2_MN_GL_AKRUAL_SETUP                  = 9;
    /***/public static final int M2_MN_GL_AKRUAL_PROSES                 = 10;
    /***/public static final int M2_MN_GL_AKRUAL_ARCHIVES               = 11;    
    /***/public static final int M2_MN_JOURNAL_ADJUSMENT_POST           = 12;
    /***/public static final int M2_MN_JOURNAL_ADJUSMENT_ARCHIVES       = 13;    
    /***/public static final int M2_MN_JOURNAL_COSTING_POST             = 14;
    /***/public static final int M2_MN_JOURNAL_COSTING_ARCHIVES         = 15;
    /***/public static final int M2_MN_JOURNAL_RETUR_POST               = 16;
    /***/public static final int M2_MN_JOURNAL_RETUR_ARCHIVES           = 17;
    /***/public static final int M2_MN_JOURNAL_REPACK_POST              = 18;
    /***/public static final int M2_MN_JOURNAL_REPACK_ARCHIVES          = 19;
    /***/public static final int M2_MN_GA_POST                          = 20;
    /***/public static final int M2_MN_GA_ARCHIVES                      = 21;
    /***/public static final int M2_MN_CASH_BACK_POST                   = 22;
    /***/public static final int M2_MN_CASH_BACK_ARCHIVES               = 23;
    
    
    public static final int M1_MN_FIN_REP                   = 5;
    /***/public static final int M2_MN_SETUP_REPORT                     = 0;    //SETUP REPORT
    /***/public static final int M2_MN_REPORT                           = 1;    //REPORT
    /***/public static final int M2_MN_REP_GL                           = 2;    //GL
    /***/public static final int M2_MN_REP_NERACA                       = 3;    //NERACA 
    /***/public static final int M2_MN_GL_DETAIL                        = 4;    //GL Detail 
    /***/public static final int M2_MN_PROFIT_LOSS                      = 5;    //P & L 
    /***/public static final int M2_MN_REPORT_BUDGET                    = 6;    
    
    public static final int M1_MENU_DONORREPORT             = 6;
    /***/public static final int M2_MENU_DONORREPORT                    = 0;
    /***/public static final int M2_MENU_APPROVAL_ACTIVITY              = 1;
    /***/public static final int M2_MENU_ACTIVITY                       = 2;    
    
    public static final int M1_MENU_ADMINISTRATOR           = 7;
    /***/public static final int M2_MENU_ADMINISTRATOR                  = 0;
    /***/public static final int M2_MENU_SQL_EXECUTE                    = 1;
    /***/public static final int M2_MENU_JOURNAL_EDITOR                 = 2;
    /***/public static final int M2_MENU_SALES_EDITOR                   = 3;
    
    public static final int M1_MENU_MASTER                  = 8;    
    /***/public static final int M2_MENU_CONFIGURATION                  = 0;
    /***/public static final int M2_MENU_ACCOUNTING                     = 1;
    /***/public static final int M2_MENU_WORKPLAN                       = 2;
    /***/public static final int M2_MENU_COMPANY                        = 3;
    /***/public static final int M2_MENU_GENERAL                        = 4;
    /***/public static final int M2_MENU_BUDGET                        	= 5;
    /***/public static final int M2_MENU_SEGMENT                       	= 6;
    /***/public static final int M2_MENU_VENDOR                       	= 7;
    /***/public static final int M2_MENU_CURRENCY                     	= 8;
    
    public static final int M1_MENU_CLOSING                 = 9;
    /***/public static final int M2_MENU_CLOSING_PERIOD                 = 0;
    
    public static final int M1_MENU_BUDGET                 = 10;
    /***/public static final int M2_MENU_BUDGET_REQUEST                 = 0;
    /***/public static final int M2_MENU_BUDGET_ARCHIVE                 = 1;
    /***/public static final int M2_MENU_BUDGET_APPROVAL                = 2;
    /***/public static final int M2_MENU_BUDGET_ACC_LINK                = 3;
    /***/public static final int M2_MENU_BUDGET_CHECKED                 = 4;
    /***/public static final int M2_MENU_BUDGET_POSTED                  = 5;
    
    public static final String[] strMenu1 = {
        "Menu Cash Transaction", 
        "Menu Bank Transaction", 
        "Menu Account Receivable",
        "Menu Account Payble",        
        "Menu Journal",         
        "Menu Financial Report",
        "Menu Activity",                 
        "Menu Administrator",
        "Menu Master Data",
        "Menu Close Period",
        "Menu Budget"
    };
    
    public static final String[][] strMenu2 = {
    
        //Menu Cash // 0
        {"Cash Receive", "Cash Receive Advance","Petty Cash - Disbushment", "Petty Cash - Cash Payment","Petty Cash - Advance",
         "Petty Cash - Replenishment","Post Journal","Archives","Cash Account Link","Cash Register","Cash Opname", "Cash Payment Approval", "Cash Receive Approval", "Budgeting","Advance Reimbursement","Setoran Kasir"},
        
        //Menu Bank // 1
        {"Bank Deposit", "Bank Payment On PO", "Bank Cash Payment", "Bank Payment Non PO","Bank Posting",
         "Bank Archives","Bank AccLink","Recon Credit Card","Generate Bg/Check Number","Bank - BG Outstanding","Bank Report"},
        
        //Menu Acc Receiveable // 2
        {"Acc Receiveable - Aging Analysis", "Acc Receiveable - List"},        
       
        //Menu Account Payable // 3
        {"Acc payable - Incoming Good List","Acc payable - Invoice List","Acc payable - Aging Analysis","Acc payable - Purchase Acc List",
        "Acc payable - Seleksi Invoice","Acc payable - Post Invoice","Acc payable - Invoice Payment",
        "Ap Memorial","Post Ap Memorial","Budget Report","Bg Outstanding","Arsip BG","Release Invoice","Budget Report GA","Budget Report Summary"},  
        
        //Menu Gen Ledger // 4
        {"Journal","Post Journal","Journal Archives","Journal 13","Post Journal 13","Journal 13 Archives", "Backdated Journal", "Post Backdated Journal",
        "Copy Journal","Akrual Setup","Akrual Proses","Akrual Archives","Post Adjusment","Adjusment Archives","Post Costing","Costing Archives","Post Retur","Retur Archives",
        "Post Repack","Repack Archives","Post GA","GA Archives","Cash Back Post","Cash Back Archives"},
        
        //Menu FinReport // 5
        {"Report Setup","Report","General Ledger","Neraca Report","GL Detail","Profit & Loss","Report Anggaran"},  
        
        //Menu DnrReport // 6
        {"Donor Report","Approval Activity","Activity"},
        
        //Menu Administrator // 7
        {"Administrator","Sql Execute","Journal Editor","Sales Editor"},
        
        //master // 8
        {"System Configuration","Accounting","Work Plan","Company","General", "Budgeting","Segment","Vendor/Suplier","Currency"},     
         
        //closing // 9
        {"Close Period"},
        
        //Budget //10
        {"Budget Request","Budget Archive","Budget Approval","Budget Acc. Link","Budget Checked","Budget Posted"}
        
    };
    
    /******************************************** End Finance ********************************************/
    
    
    /******************************************** Begin Retail ********************************************/
    
    public static final int MENU_RETAIL_CONSTANT = 100;
    
    public static final int M1_PURCHASING               = 100;
    /***/public static final int M2_PURCHASE_REQUEST                        = 0;
    /***/public static final int M2_LIST_PENDING_PR                         = 1;
    /***/public static final int M2_PR_ARCHIVES                             = 2;
    /***/public static final int M2_EXPORT_PR_TO_PO                         = 3;
    /***/public static final int M2_DIRECT_PO                               = 4;
    /***/public static final int M2_PO_ARCHIVES                             = 5;
    /***/public static final int M2_PO_ANALISIS                             = 6;
    /***/public static final int M2_PO_APPROVED                             = 7;
    /***/public static final int M2_PO_CHECKED                              = 8;
    /***/public static final int M2_PO_REVIEW                               = 9;
    
    public static final int M1_INCOMING                 = 101;
    /***/public static final int M2_INCOMING_FROM_PO                        = 0;
    /***/public static final int M2_DIRECT_INCOMING                         = 1;
    /***/public static final int M2_INCOMING_ARCHIVES                       = 2;  
    /***/public static final int M2_INCOMING_IMPORT                         = 3;  
    /***/public static final int M2_EDIT_INCOMING                           = 4;  
    /***/public static final int M2_INCOMING_APPROVED                       = 5;  
    /***/public static final int M2_INCOMING_KOMISI                         = 6;  
    /***/public static final int M2_RECEIVING_ADJUSMENT                     = 7;  
    /***/public static final int M2_INCOMING_KONSINYASI                     = 8;  
    
    
    public static final int M1_PRODUCTION               = 102;
    /***/public static final int M2_NEW_PROJECT                             = 0;
    /***/public static final int M2_NEW_STOCK                               = 1;
    /***/public static final int M2_MASTER_PRODUCT_CATEGORY                 = 2;
    /***/public static final int M2_MASTER_PRODUCT_SUB_CATEGORY             = 3;
    /***/public static final int M2_MASTER_PRODUCT_LIST                     = 4;
    /***/public static final int M2_MASTER_PRODUCT_WORK_CENTER              = 5;
    /***/public static final int M2_SHOP_FLOR_MANAGEMENT                    = 6;
    /***/public static final int M2_FINISH_GOODS                            = 7;
    /***/public static final int M2_DELIVERY                                = 8;
    /***/public static final int M2_INSTALATION_EXPENSE                     = 9;   
    
    public static final int M1_STOCK_MANAGEMENT        = 103;
    /***/public static final int M2_TRANSFER                                = 0;
    /***/public static final int M2_TRANSFER_REQUEST                        = 1;
    /***/public static final int M2_PURCHASE_RETUR                          = 2;
    /***/public static final int M2_NEW_RETUR                               = 3;
    /***/public static final int M2_RETUR_ARCHIVES                          = 4;
    /***/public static final int M2_ADJUSMENT                               = 5;
    /***/public static final int M2_OPNAME                                  = 6;
    /***/public static final int M2_COSTING                                 = 7;    
    /***/public static final int M2_REPACK                                  = 8;  
    /***/public static final int M2_DIRECT_RETUR                            = 9;
    /***/public static final int M2_EDIT_TRANSFER                           = 10;
    /***/public static final int M2_TRANSFER_ANALISIS                       = 11;
    /***/public static final int M2_TRANSFER_APPROVED                       = 12;
    /***/public static final int M2_TRANSFER_CHECKED                        = 13;
    /***/public static final int M2_RETUR_APPROVED                          = 14;
    /***/public static final int M2_COSTING_APPROVED                        = 15;
    /***/public static final int M2_REPACK_APPROVED                         = 16;
    /***/public static final int M2_ADJUSMENT_APPROVED                      = 17;
    /***/public static final int M2_OPNAME_APPROVED                         = 18;
    /***/public static final int M2_GA                                      = 19;
    /***/public static final int M2_GA_APPROVED                             = 20;
    
    public static final int M1_DATA_SYNCHRONIZATION   = 104;
    /***/public static final int M2_DATA_SYNCHRONIZATION                    = 0;
    
    public static final int M1_RETAIL_REPORT          = 105;
    /***/public static final int M2_PO_REPORT                               = 0;
    /***/public static final int M2_INCOMING_REPORT                         = 1;
    /***/public static final int M2_PO_RETUR                                = 2;
    /***/public static final int M2_ITEM_TRANSFER                           = 3;
    /***/public static final int M2_STOCK_REPORT                            = 4;
    /***/public static final int M2_STOCK_CARD                              = 5;    
    /***/public static final int M2_COSTING_REPORT                          = 6;    
    /***/public static final int M2_REPACK_REPORT                           = 7;    
    /***/public static final int M2_FAKTUR_PAJAK                            = 8;  
    /***/public static final int M2_FAKTUR_PAJAK_SALES                      = 9;  
    /***/public static final int M2_AJUSTMENT_GA                            = 10;  
    /***/public static final int M2_INVENTORY_REPORT                        = 11;  
    /***/public static final int M2_SERVICE_LEVEL                           = 12;  
    /***/public static final int M2_STOCK_VSSALES                           = 13;  
    /***/public static final int M2_SYNC_STATISTIC                          = 14;  
    /***/public static final int M2_CASH_BACK_TRANSACTION                   = 15;      
    /***/public static final int M2_HISTORY_MEMBER                          = 16;  
    
    public static final int M1_MASTER_MAINTENANCE     = 106;
    /***/public static final int M2_MASTER_CONFIGURATION                    = 0;
    /***/public static final int M2_MASTER_ACCOUNTING                       = 1;
    /***/public static final int M2_MASTER_MATERIAL                         = 2;
    /***/public static final int M2_MASTER_PRODUCT                          = 3;
    /***/public static final int M2_MASTER_ASSET                            = 4;
    /***/public static final int M2_MASTER_MERK                             = 5;
    /***/public static final int M2_MASTER_COMPANY                          = 6;
    /***/public static final int M2_MASTER_GENERAL                          = 7;
    /***/public static final int M2_MASTER_MEMBER                           = 8;
    /***/public static final int M2_MASTER_CASHIER                          = 9;
    /***/public static final int M2_MASTER_BACKUP_DATA                      = 10;
    /***/public static final int M2_MASTER_MENU                             = 11;
    /***/public static final int M2_MASTER_RESTO                            = 12;
    /***/public static final int M2_MASTER_CATEGORY                         = 13;
    /***/public static final int M2_MASTER_SUB_CATEGORY                     = 14;
    /***/public static final int M2_MASTER_PRICE_CHANGE                     = 15;
    /***/public static final int M2_MASTER_STANDAR_STOCK                    = 16;
    /***/public static final int M2_MASTER_PROMOTION                        = 17;
    /***/public static final int M2_APPROVE_MATERIAL                        = 18;
    /***/public static final int M2_VIEW_COGS                               = 19;
    /***/public static final int M2_GROUP_MEMBER                            = 20;
    /***/public static final int M2_MEMBER_NON_REGULER                      = 21;    
    /***/public static final int M2_MEMBER_CHECK_POINT                      = 22;  
    /***/public static final int M2_MASTER_COST_CHANGE                      = 23;  
    
    public static final int M1_ADMINISTRATOR          = 107;
    /***/public static final int M2_SYSTEM_CONFIG                           = 0; 
    /***/public static final int M2_ADMINISTRATOR                           = 1; 
    /***/public static final int M2_GEN_USER                                = 2; 
    
    public static final String[] strInv1 = {
        "Purchasing", 
        "Incoming Goods", 
        "Production",
        "Stock Management",
        "Data Synchronization",
        "Reports",
        "Master Maintenance", 
        "Administrator"
    };
        
    public static final String[][] strInv2 = {
        // Purchasing         
        {"Purchase Request", "List Pending PO","PR Archives","Export PR to PO","Direct PO","PO Archives","PO Analisis","PO Approved","PO Checked","PO Review"},    
        
        //Incoming        
        {"Incoming From PO", "Direct Incoming","Incoming Archives","Incoming Import","Edit Incoming","Incoming Approved","Incoming Komisi","Receiving Adjusment",
        "Incoming Konsinyasi"},    

        //Production
        {"New Project","New Stock","Master Product Category", "Master Product Sub Category",
         "Master Product List", "Master Product Work Center","Shop Flor Management", "Finish Goods",
         "Delivery", "Instalation Expense"},    
        
        //Stock Management
        {"Transfer","Transfer Request", "Purchase Retur", "New Retur", "Retur Archives", "Adjustment","Opname","Costing","Repack","Direct Retur","Edit Transfer","Transfer Analisis","Tranfer Approved","Transfer Checked","Retur Approved","Costing Approved","Repack Approved","Adjusment Approved","Opname Approved","GA","GA Approved"},   
        
        //Data Synchronization 
        {"Data Synchronization"},   
                
        //Retail Report
        {"PO Report", "Incoming Report",
         "PO Retur", "Item Transfer",
         "Stock Report", "Stock Card", "Costing Report", "Repack Report", "Faktur Pajak","Faktur Pajak Sales","Ajustment GA","Inventory Report","Service Level","stock vs sales","Data Sync Statistic","Cash Back Transaction","History Member"
         },             
         
        //Menu menu Master
        {"Master Configuration","Master Accounting","Master Material", 
          "Master Product","Master Asset","Master Merk", "Master Company","Master General",
         "Master Member", "Master Cashier", "Master Backup Data","Master Menu","Master Resto","Master Category",
         "Master Sub Category", "Master Price Change","Master Stock Standar","Master Promotion","Approve Material",
         "View Cogs","Group Member","Member Non Reguler","Member Check Point","Master Cost Change"
        },
         
        //Menu Administrator
        {"System Config","Administrator","Generate User"},
    };
    
    /******************************************** End Operation ********************************************/  
    
    
    /******************************************** Begin CRM ********************************************/
    
    public static final int MENU_CRM_CONSTANT = 200;
    
    public static final int M1_CRM_LOGIN    = 200;    
    /**/public static final int M2_CRM_LOGIN_LOGIN                           = 0;
    /**/public static final int M2_CRM_LOGIN_LOGOUT                          = 1;  
    
    /* KONTAK SEWA LAHAN (KSL) */
    public static final int M1_CRM_KSL      = 201;    
    /**/public static final int M2_CRM_KSL_DATA_KONTRAK                      = 0;
    /**/public static final int M2_CRM_KSL_PERUBAHAN_KONTRAK                 = 1;   
    /**/public static final int M2_CRM_KSL_RINCIAN_PIUTANG_BUAT_BARU         = 2;   
    /**/public static final int M2_CRM_KSL_RINCIAN_PIUTANG_DAFTAR_RINCIAN    = 3;   
    /**/public static final int M2_CRM_KSL_BUKU_PEMBANTU_PIUTANG             = 4;  
    
    /* INPUT DATA UPAL */
    public static final int M1_CRM_INPUT_UPAL   = 202;
    /**/public static final int M2_CRM_INPUT_UPAL_AIR_LIMBAH_BULANAN         = 0;
    /**/public static final int M2_CRM_INPUT_UPAL_AIR_IRIGASI_BULANAN        = 1;  
    
    /* INPUT DATA INVOICE */
    public static final int M1_CRM_INVOICE      = 203;
    /**/public static final int M2_CRM_INVOICE_KOMIN_INVOICE_BARU            = 0;
    /**/public static final int M2_CRM_INVOICE_KOMIN_DAFTAR_INVOICE          = 1;  
    /**/public static final int M2_CRM_INVOICE_KOMPER_PERHITUNGAN_KOMPER     = 2;
    /**/public static final int M2_CRM_INVOICE_ASSESSMENT_INVOICE_BARU       = 3;
    /**/public static final int M2_CRM_INVOICE_ASSESSMENT_DAFTAR_INVOICE     = 4;    
    /**/public static final int M2_CRM_INVOICE_UPAL_AIR_LIMBAH               = 5;
    /**/public static final int M2_CRM_INVOICE_UPAL_AIR_IRIGASI              = 6;
    /**/public static final int M2_CRM_CUSTOM_INVOICE                        = 7;
    /**/public static final int M2_CRM_CUSTOM_FAKTUR                         = 8;
    
    /* PENERIMAAN */
    public static final int M1_CRM_PENERIMAAN       = 204;    
    /**/public static final int M2_CRM_PENERIMAAN_KOMIN                      = 0;
    /**/public static final int M2_CRM_PENERIMAAN_KOMPER                     = 1;
    /**/public static final int M2_CRM_PENERIMAAN_ASSESSMENT                 = 2;
    /**/public static final int M2_CRM_PENERIMAAN_AIR_LIMBAH                 = 3;
    /**/public static final int M2_CRM_PENERIMAAN_AIR_IRIGASI                = 4;   
    /**/public static final int M2_CRM_PENERIMAAN_ARSIP                      = 5;
    
    /* MANAGEMENT DENDA */
    public static final int M1_CRM_MANAGEMENT_DENDA       = 205;    
    /**/public static final int M2_CRM_MANAGEMENT_DENDA_HITUNG_DENDA         = 0;
    /**/public static final int M2_CRM_MANAGEMENT_DENDA_DAFTAR_DENDA         = 1;
    /**/public static final int M2_CRM_MANAGEMENT_DENDA_REKAP_DENDA          = 2;    
    /**/public static final int M2_CRM_MANAGEMENT_DENDA_KEBIJAKAN_KOMIN      = 3;
    /**/public static final int M2_CRM_MANAGEMENT_DENDA_KEBIJAKAN_KOMPER     = 4;
    /**/public static final int M2_CRM_MANAGEMENT_DENDA_KEBIJAKAN_ASSESSMENT = 5;
    /**/public static final int M2_CRM_MANAGEMENT_DENDA_KEBIJAKAN_LIMBAH     = 6;
    /**/public static final int M2_CRM_MANAGEMENT_DENDA_KEBIJAKAN_IRIGASI    = 7;    
    
    /* ACCOUNTING */
    public static final int M1_CRM_ACCOUNTING       = 206;    
    /**/public static final int M2_CRM_ACCOUNTING_KOMIN_POSTING_PIUTANG          = 0;
    /**/public static final int M2_CRM_ACCOUNTING_KOMIN_POSTING_PENDAPATAN       = 1;    
    /**/public static final int M2_CRM_ACCOUNTING_KOMPER_POSTING_JURNAL          = 2;
    /**/public static final int M2_CRM_ACCOUNTING_KOMPER_POSTING_PENDAPATAN      = 3;    
    /**/public static final int M2_CRM_ACCOUNTING_ASSESSMENT_POSTING_PIUTANG     = 4;
    /**/public static final int M2_CRM_ACCOUNTING_ASSESSMENT_POSTING_PENDAPATAN  = 5;    
    /**/public static final int M2_CRM_ACCOUNTING_UP_LIMBAH_POSTING_PIUTANG      = 6;
    /**/public static final int M2_CRM_ACCOUNTING_UP_LIMBAH_POSTING_BKM          = 7;   
    
    
     /* UBAH NOMOR FAKTUR */
    public static final int M1_CRM_UBAH_NOMOR_FAKTUR       = 207;    
    /**/public static final int M2_CRM_UBAH_NOMOR_FAKTUR                         = 0;  
    
    
    /* DATA MASTER */
    public static final int M1_CRM_DATA_MASTER       = 208;    
    /**/public static final int M2_CRM_DATA_MASTER_SEWA_LAHAN_INVESTOR           = 0;
    /**/public static final int M2_CRM_DATA_MASTER_SEWA_LAHAN_SARANA             = 1;
    /**/public static final int M2_CRM_DATA_MASTER_SEWA_LAHAN_LOT                = 2;
    /**/public static final int M2_CRM_DATA_MASTER_SEWA_LAHAN_KONTRAK            = 3;    
    /**/public static final int M2_CRM_DATA_MASTER_LIMBAH_IRIGASI_HRG_LIMBAH     = 4;
    /**/public static final int M2_CRM_DATA_MASTER_LIMBAH_IRIGASI_HRG_IRIGASI    = 5;
    /**/public static final int M2_CRM_DATA_MASTER_UMUM_NEGARA                   = 6;
    /**/public static final int M2_CRM_DATA_MASTER_UMUM_MATA_UANG                = 7;
    /**/public static final int M2_CRM_DATA_MASTER_UMUM_SATUAN                   = 8;
    /**/public static final int M2_CRM_DATA_MASTER_UMUM_PERIODE                  = 9;    
    /**/public static final int M2_CRM_DATA_MASTER_SYSTEM_APPROVAL               = 10;
    /**/public static final int M2_CRM_DATA_MASTER_SYSTEM_KODE_DOKUMEN           = 11;
    
    public static final String[] strCRM1 = {
        /* CRM LOGIN */ "Login ",        
        /* CRM KSL */ "Kontrak Sewa Lahan",
        /* CRM INPUT UPAL */ "Input UPAL",
        /* CRM INVOICE*/ "Data Invoice",
        /* PENERIMAAN */ "Penerimaan",
        /* MANAGEMENT DENDA */ "Management Denda",
        /* ACCOUNTING */ "Accounting",
        /* UBAH NOMOR FAKTUR */ "Ubah Nomor Faktur",        
        /* DATA MASTER */"Data Master"
    };
    
    
    public static final String[][] strCrm2 = {
         /* CRM LOGIN */
        {"Login","Logout"},
        
        /* CRM KSL */
        {"Data Kontrak","Perubahan Kontrak",
        "Rincian Piutang Buat baru","Rincian Piutang Daftar Rincian",
        "Buku Pembantu Piutang"},
        
        /* CRM INPUT UPAL */
        {"Air Limbah Bulanan","Air Irigasi Bulanan"},
        
        /* CRM INVOICE*/
        {"Invoice Komin Baru","Invoice Komin Daftar Invoice",
            "Invoice Komper Perhitungan",
            "Invoice Assessment Baru","CRM Invoice Assessment Daftar Invoice",
            "Invoice UPAL Limbah","CRM Invoice UPAL Irigasi","Custom Invoice", "Custom Faktur"},
        
        /* PENERIMAAN */
        {"Penerimaan Komin","Penerimaan Komper","Penerimaan Assessment","Penerimaan Limbah","Penerimaan Irigasi","Penerimaan Arsip"},
        
        /* MANAGEMENT DENDA */
        {"Hitung Denda","Daftar Denda","Rekap Denda","Kebijakan Komin","Kebijakan Komper",
                 "Kebijakan Tagihan Assessment","Kebijakan Tagihan Limbah","Kebijakan Tagihan Irigasi"},
                 
        /* ACCOUNTING */         
        {"Komin Posting Piutang","Komin Posting Pendapatan",
            "Komper Posting Jurnal","CRM Komper Posting Pendapatan",
            "Accounting Assessment Posting Piutang","Accounting Assessment Posting Pendapatan",      
            "Accounting UP Limbah Posting Piutang","Accounting UP Limbah Posting Pendapatan"},   
        
        /* UBAH NOMOR FAKTUR */        
        {"Ubah Nomor Faktur Pajak"},      
            
        //DATA MASTER
        {"Master Investor","Master Sarana","Master Lot","Master Kontrak",
            "Master Harga Limbah","Master Harga Irigasi",
            "Master Negara","Mater Mata Uang","Master Satuan","Master Periode",        
            "Master Approval","Mater Kode Dokumen"}  
        
    };
    
    /******************************************** End CRM ********************************************/
    
    /* Begin Sales */
    
    public static final int MENU_SALES_CONSTANT = 300;
    
    public static final int M1_SALES               = 300;
    /***/public static final int M2_SAL_UPLOAD_SALES                        = 0;
    /***/public static final int M2_SAL_OPENING                             = 1;
    /***/public static final int M2_SAL_NEW_SALES                           = 2;
    /***/public static final int M2_SAL_ARCHIVES                            = 3;
    /***/public static final int M2_SAL_CREDIT_PAYMENT                      = 4;
    /***/public static final int M2_SAL_CLOSING                             = 5;
    
    public static final int M1_SALES_REPORT        = 301;
    /***/public static final int M2_SAL_REPORT                              = 0;
    /***/public static final int M2_SAL_REPORT_BY_LOCATION                  = 1; //Report By Location 
    /***/public static final int M2_SAL_REPORT_CASHIER                      = 2; //Report Cashier 
    /***/public static final int M2_SAL_REPORT_BY_MEMBER                    = 3; //Report By Member
    /***/public static final int M2_SAL_CREDIT_PAYMENT_REPORT               = 4;
    /***/public static final int M2_SAL_REPORT_SALES_CANCELED               = 5; //Sales Canceled
    /***/public static final int M2_SAL_REPORT_SALES_CLOSING                = 6; //Closing Sales Report
    /***/public static final int M2_SAL_REPORT_SALES_RETUR                  = 7; //Retur Sales
    /***/public static final int M2_SAL_REPORT_BY_CATEGORY                  = 8; //Report By Category
    /***/public static final int M2_SAL_REPORT_KONSINYASI_BELI              = 9; //Consigned By Cost
    /***/public static final int M2_SAL_REPORT_KONSINYASI_JUAL              = 10; //Consigned By Price
    /***/public static final int M2_SAL_REPORT_POSTING                      = 11; //Posting Report
    /***/public static final int M2_SAL_REPORT_SALES_MONTHLY                = 12;
    
    /***/public static final int M2_SAL_REPORT_BY_ITEM                      = 13; //Report By Item
    /***/public static final int M2_SAL_REPORT_BELI_PUTUS                   = 14; //Report Beli Putus
    /***/public static final int M2_SAL_REPORT_SALES_MARGIN                 = 15; //Report Sales Margin
    /***/public static final int M2_SAL_REPORT_COGS_BY_SECTION              = 16; //Report Cogs by section
    /***/public static final int M2_SAL_REPORT_SALES_BY_GOL_PRICE           = 17; //Report Sales By Gol Price
    /***/public static final int M2_SAL_REPORT_SALES_PROMOTION              = 18; //Report Sales Promotion
    /***/public static final int M2_SAL_REPORT_SALES_BY_SUPLIER             = 19; //Report Sales By Supplier
    /***/public static final int M2_SAL_REPORT_SLOW_FAST_MOVING             = 20; //Report Slow/Fast Moving
    
    /***/public static final int M2_SAL_REPORT_KOMISI                       = 21; //Report Komisi
    /***/public static final int M2_SAL_REPORT_GA                           = 22; //Report GA
    /***/public static final int M2_SAL_REPORT_SETORAN                      = 23; //Report Setoran
    /***/public static final int M2_SAL_REPORT_CREDIT_CARD                  = 24;
    /***/public static final int M2_SAL_REPORT_TOP_SALES                    = 25;
    /***/public static final int M2_SAL_REPORT_BY_START_DATE                = 26;
    /***/public static final int M2_SAL_VOID_REPORT                         = 27;
    /***/public static final int M2_SAL_BONUS                               = 28;
    /***/public static final int M2_SAL_REPORT_REWARD                               = 29;
    
    public static final int M1_SALES_ACCOUNTING     = 302;
    /***/public static final int M2_SAL_PROCESS_JOURNAL                     = 0;
    /***/public static final int M2_SAL_PROCESS_JOURNAL_RETUR               = 1;
    /***/public static final int M2_SAL_EDITOR_CC                           = 2;
    /***/public static final int M2_SAL_JOURNAL_CASH_BACK                   = 3;
    
    public static final int M1_SALES_MASTER         = 303;
    /***/public static final int M2_SAL_SALES_ITEM                          = 0;
    
    public static final String[] strSales1 = {
        "Sales",        
        "Report",
        "Accounting",
        "Master Data"
    };
    
    public static final String[][] strSales2 = {        
        {"Upload Sales","Opening","New Sales","Archives","Credit Payment","Closing"},
        {"Sales Report","Sales Report By Location","Sales Report By Cashier","Sales Report By Member","Credit Payment Report","Sales Canceled Report","Report Sales Closing","Report Sales Retur","Report Sales By Category","Report Konsinyasi Beli","Report Konsinyasi Jual","Sales Report Posting","Monthly Sales Reports",
        "Report By Item","Report Beli Putus","Report Sales Margin","Report Cogs by section","Report Sales By Gol Price","Report Sales Promotion","Report Sales By Supplier","Report Slow/Fast Moving","Report Komisi","Report GA","Report Setoran","Report Credit Card","Top Sales","Report Sales By Start Date","Void Sales Report","Sales Bonus","Report Sales Reward"},
        {"Process Journal","Process Jurnal Retur","Sales Editor CC","Journal Cash Back"},
        {"Sales Item"}
    };
    
    /* Begin Property */
    
    public static final int MENU_PROPERTY_CONSTANT = 400;
    
    public static final int M1_PROPERTY               = 400;
    /***/public static final int M2_NEW_PROPERTY                        = 0;
    /***/public static final int M2_DETAIL_PROPERTY                     = 1;
    /***/public static final int M2_PETA_LOKASI                         = 2;
    /***/public static final int M2_GAMBAR                              = 3;
    /***/public static final int M2_GEDUNG                              = 4;
    /***/public static final int M2_LANTAI                              = 5;
    /***/public static final int M2_LOT                                 = 6;
    /***/public static final int M2_LIST_PROPERTY                       = 7;
    /***/public static final int M2_UPDATE_STATUS                       = 8;  
    /***/public static final int M2_TYPE_LOT_MASTER                     = 9; 
    
    public static final int M1_PENJUALAN_PROPERTY     = 401;
    /***/public static final int M2_DOWNLOAD_SURAT                      = 0;
    /***/public static final int M2_PENJUALAN_BARU                      = 1;
    /***/public static final int M2_BUAT_INVOICE                        = 2;
    /***/public static final int M2_CETAK_INVOICE                       = 3;
    /***/public static final int M2_EVA_RESERVASI                       = 4;
    /***/public static final int M2_EVA_INVOICE                         = 5;
    /***/public static final int M2_ARSIP_PENJUALAN                     = 6;
    /***/public static final int M2_PRINT_SALES                         = 7;
    /***/public static final int M2_PRINT_KWITANSI                      = 8;
    /***/public static final int M2_APPROVE                             = 9;
    /***/public static final int M2_PLAFON                              = 10;

    public static final int M1_PENERIMAAN_PEMBAYARAN  = 402;
    /***/public static final int M2_PEMBAYARAN                      = 0;
    /***/public static final int M2_ARSIP_PEMB                      = 1;    
    
    public static final int M1_PROP_REPORT  = 403;
    /***/public static final int M2_RPT_KONSUMEN                      = 0;
    /***/public static final int M2_RPT_PENJUALAN                     = 1;
    /***/public static final int M2_RPT_DET_PENJUALAN                 = 2;
    /***/public static final int M2_RPT_PENERIMAAN_PEMBAYARAN         = 3;
    /***/public static final int M2_RPT_SALDO_PIUTANG                 = 4;
    /***/public static final int M2_RPT_UMUR_PIUTANG                  = 5; 
    /***/public static final int M2_RPT_AVAILABLE_LOT                 = 6; 
    
    public static final int M1_MASTER_DATA  = 404;
    /***/public static final int M2_DAFTAR_LOKASI                      = 0;
    /***/public static final int M2_FAS_PROPERTY                       = 1;
    /***/public static final int M2_FAS_TOWER                          = 2;
    /***/public static final int M2_FAS_LANTAI                         = 3;
    /***/public static final int M2_FAS_LOT                            = 4;
    /***/public static final int M2_CUSTOMER                           = 5;
    /***/public static final int M2_EMPLOYEE                           = 6;
    /***/public static final int M2_BANK                               = 7;
    /***/public static final int M2_DEPARTMENT                         = 8;
    
    public static final int M1_PROP_ADMINISTRATOR  = 405;
    /***/public static final int M2_SYSTEM_PROPERTY                    = 0;
    /***/public static final int M2_DAFTAR_PENGGUNA                    = 1;    
    
    public static final String[] strProperty1 = {
        "Property",        
        "Penjualan Property",
        "Penerimaan Pembayaran",
        "Laporan Property",
        "Master Data",
        "Administrator"
    };
    
    public static final String[][] strProperty2 = {        
        {"New Property","Detail Property","Peta Lokasi","Gambar","Gedung","Lantai","Lot","List Property","Update Status","Type Lot Master"},
        {"Download Surat Pesanan","Penjualan Baru","Buat Invoice","Cetak Invoice","Evaluasi Reservasi","Evaluasi Invoice","Arsip Penjualan","Print Sales","Print Kwitansi","Approve","Flafon"},
        {"Pembayaran","Arsip Pembayaran"},
        {"Laporan Konsumen","Laporan Penjualan","Laporan Detail Penjualan","Laporan Penerimaan Pembayaran","Laporan Saldo Piutang","Laporan Umur Piutang","Laporan Available Lot"},
        {"Daftar Lokasi","Fasilitas Property","Fasilitas Tower","Fasilitas Lantai","Fasilitas Lot","Customer","Employee","Bank","Department"},
        {"System Property","Daftar Pengguna"}
    };    
    
    /* end property */
    
    
    public static void main(String[] args){
        System.out.println(strMenu2[0]);
    }
    
}

