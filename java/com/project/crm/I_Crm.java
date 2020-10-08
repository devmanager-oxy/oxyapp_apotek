/*
 * I_Crm.java
 *
 * Created on October 8, 2008, 11:45 PM
 */

package com.project.crm;

/**
 *
 * @author  Valued Customer
 */
public class I_Crm {
          
    public static final int TERM_STATUS_DRAFT           = 0;
    public static final int TERM_STATUS_READY_TO_INV    = 1;
    public static final int TERM_STATUS_INVOICED        = 2;
    public static final int TERM_STATUS_PARTIALY_PAID   = 3;
    public static final int TERM_STATUS_FULL_PAID       = 4;
    
    public static final String[] termStatusStr = {"Draft", "Ready to Invoice", "Invoiced", "Partialy Paid", "Fully Paid"};    
    
    public static final int TYPE_APPROVAL_LIMBAH                        = 0;
    public static final int TYPE_APPROVAL_IRIGASI                       = 1;
    public static final int TYPE_APPROVAL_TRANSAKSI_LIMBAH              = 2;
    public static final int TYPE_APPROVAL_TRANSAKSI_IRIGASI             = 3;
    public static final int TYPE_APPROVAL_PEMBAYARAN_LIMBAH             = 4;
    public static final int TYPE_APPROVAL_PEMBAYARAN_IRIGASI            = 5;
    public static final int TYPE_APPROVAL_INVOICE_LIMBAH_DETAIL         = 6;
    public static final int TYPE_APPROVAL_INVOICE_IRIGASI_DETAIL        = 7;
    public static final int TYPE_APPROVAL_INPUT_UPAL_LIMBAH_BULANAN     = 8;
    public static final int TYPE_APPROVAL_INPUT_UPAL_IRIGASI_BULANAN    = 9;
    public static final int TYPE_APPROVAL_INVOICE_DETAIL_SEWA_KOMIN     = 10;
    public static final int TYPE_APPROVAL_INVOICE_DETAIL_SEWA_KOMPER    = 11;
    public static final int TYPE_APPROVAL_BKK                           = 12;
    public static final int TYPE_APPROVAL_BKM                           = 13;
    public static final int TYPE_APPROVAL_CASH_REGISTER                 = 14;
    public static final int TYPE_APPROVAL_JOURNAL                       = 15;
    public static final int TYPE_APPROVAL_KAS_OPNAME                    = 16;
    public static final int TYPE_APPROVAL_BKM_BANK                      = 17;
    public static final int TYPE_APPROVAL_BKK_BANK                      = 18;
    
    public static final String[] approvalTypeKey = {"0", "1", "2", "3", "4", "5","6","7","8","9","10","11","12","13","14","15","16","17","18"};
    public static final String[] approvalTypeStr = {"Penagihan Limbah", "Penagihan Irigasi", "Invoice Limbah Summary", "Invoice Irigasi Summary","Pembayaran Limbah","Pembayaran Irigasi","Invoice Limbah Detail","Invoice Irigasi Detail",
                                                    "Input UPAL Limbah Bulanan","Input UPAL Irigasi Bulanan","Sewa Tanah Komin","Sewa Tanah Komper","BKK KAS","BKM KAS","Kas Register","Journal","Kas Opname","BKM BANK","BKK BANK"};
    
    // dasar konpenssasi persentase
    // yg di pakai disewa tanah
    public static final int TYPE_KOMPENSASI_PERSENTASE_KAMAR            = 0;
    public static final int TYPE_KOMPENSASI_PERSENTASE_FOOD             = 1;
    public static final int TYPE_KOMPENSASI_PERSENTASE_BEVERAGE         = 2;
    public static final int TYPE_KOMPENSASI_PERSENTASE_FOOD_BEVERAGE    = 3;
    public static final int TYPE_KOMPENSASI_PERSENTASE_TELEPHONE        = 4;
    public static final int TYPE_KOMPENSASI_PERSENTASE_LOUNGE           = 5;
    public static final int TYPE_KOMPENSASI_PERSENTASE_SALES_SERVICES   = 6;
    public static final int TYPE_KOMPENSASI_PERSENTASE_MINOR            = 7;
    public static final int TYPE_KOMPENSASI_PERSENTASE_OTHER            = 8;
    
    public static final String[] kompenPersentase = {
        "Rooms", 
        "Food", 
        "Beverage", 
        "Food & Beverage - Others",
    	"Telephone & Telex", 
        "Lounge", 
        "Sales & Services", 
        "Minor Departments", 
        "Other Revenue"
    };	
    
    public static final int JURNAL_STATUS_NOT_POSTED = 0;
    public static final int JURNAL_STATUS_POSTED     = 1;	
    
    public static final String[] strJurnalStatus = {"Not Posted","Posted"};	
    	
}
