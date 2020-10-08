/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class JspSalesData extends JSPHandler implements I_JSPInterface, I_JSPType{
    
    private SalesData salesData;
    public static final String JSP_SALES_DATA = "JSP_SALES_DATA";
    
    public static final int JSP_SALES_DATA_ID = 0;
    public static final int JSP_PROPERTY_ID = 1;
    public static final int JSP_BUILDING_ID = 2;
    public static final int JSP_FLOOR_ID = 3;
    public static final int JSP_LOT_ID = 4;
    public static final int JSP_LOT_TYPE_ID = 5;
    public static final int JSP_USER_ID = 6;    
    public static final int JSP_SALES_NUMBER = 7;
    public static final int JSP_DATE_TRANSACTION = 8;
    public static final int JSP_PAYMENT_TYPE = 9;
    public static final int JSP_SALES_PRICE = 10;
    public static final int JSP_DISCOUNT = 11;
    public static final int JSP_PRICE_AFTER_DISCOUNT = 12;
    public static final int JSP_PPN = 13;
    public static final int JSP_FINAL_PRICE = 14;    
    public static final int JSP_BF_AMOUNT = 15;
    public static final int JSP_BF_DUE_DATE = 16;
    public static final int JSP_DP_AMOUNT = 17;
    public static final int JSP_DP_DUE_DATE = 18;
    public static final int JSP_AMOUNT_PELUNASAN = 19;
    public static final int JSP_PELUNASAN_DUE_DATE = 20;    
    public static final int JSP_NAME = 21;
    public static final int JSP_ADDRESS = 22;
    public static final int JSP_ADDRESS2 = 23;
    public static final int JSP_ID_NUMBER = 24;
    public static final int JSP_PH = 25;
    public static final int JSP_TELEPHONE = 26;
    public static final int JSP_EMAIL = 27;
    public static final int JSP_SPECIAL_REQUIREMENT = 28;
    public static final int JSP_USER_NAME = 29;
    public static final int JSP_JOURNAL_COUNTER = 30;
    public static final int JSP_JOURNAL_PREFIX = 31;
    public static final int JSP_CUSTOMER_ID = 32;    
    public static final int JSP_PERSEN_DP = 33;
    public static final int JSP_PERSEN_PELUNASAN = 34;
    public static final int JSP_PERIODE = 35;
    public static final int JSP_ANGSURAN = 36;
    public static final int JSP_PERSEN_ANGSURAN = 37;
    public static final int JSP_DUE_DATE_ANGSURAN = 38;
    public static final int JSP_PERSEN_BUNGA = 39;
    public static final int JSP_PERIODE_DP = 40;
    public static final int JSP_STATUS = 41;
    public static final int JSP_BIAYA_KPA = 42;    
    public static final int JSP_BANK_ID = 43;
    public static final int JSP_COVER_AMOUNT = 44;
    public static final int JSP_CREATE_ID = 45;
    public static final int JSP_NPWP = 46;
    
    public static final String[] colNames = {
        "jsp_sales_data_id",
        "jsp_property_id",
        "jsp_building_id",
        "jsp_floor_id",
        "jsp_lot_id",
        "jsp_lot_type_id",
        "jsp_user_id",
        "jsp_sales_number",
        "jsp_date_transaction",
        "jsp_payment_type",
        "jsp_sales_price",
        "jsp_discount",
        "jsp_price_after_discount",
        "jsp_ppn",
        "jsp_final_price",
        "jsp_bf_amount",
        "jsp_bf_due_date",
        "jsp_dp_amount",
        "jsp_dp_due_date",
        "jsp_amount_pelunasan",
        "jsp_pelunasan_due_date",
        "jsp_name",
        "jsp_address",
        "jsp_address2",
        "jsp_id_number",
        "jsp_ph",
        "jsp_telephone",
        "jsp_email",
        "jsp_special_requirement",        
        "jsp_user_name",
        "jsp_journal_counter",
        "jsp_journal_prefix",
        "jsp_customer_id",
        "jsp_persen_dp",
        "jsp_persen_pelunasan",
        "jsp_periode",
        "jsp_angsuran",
        "jsp_persen_angsuran",
        "jsp_due_date_angsuran",
        "jsp_persen_bunga",
        "jsp_periode_dp",
        "jsp_status",
        "jsp_biaya_kpa",
        "jsp_bank_id",
        "jsp_cover_amount",
        "jsp_create_id",
        "jsp_npwp"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,        
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_INT,
        TYPE_FLOAT,        
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,        
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING,        
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED,                
        TYPE_STRING + ENTRY_REQUIRED,                        
        TYPE_STRING,        
        TYPE_STRING,
        TYPE_STRING,         
        TYPE_STRING,        
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG ,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING
    };
    
    public JspSalesData() {
    }

    public JspSalesData(SalesData salesData) {
        this.salesData = salesData;
    }

    public JspSalesData(HttpServletRequest request, SalesData salesData) {
        super(new JspSalesData(salesData), request);
        this.salesData = salesData;
    }

    public String getFormName() {
        return JSP_SALES_DATA;
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

    public SalesData getEntityObject() {
        return salesData;
    }
    
    public void requestEntityObject(SalesData salesData) {
        try {
            this.requestParam();
            
            salesData.setPropertyId(getLong(JSP_PROPERTY_ID));
            salesData.setBuildingId(getLong(JSP_BUILDING_ID));
            salesData.setFloorId(getLong(JSP_FLOOR_ID));
            salesData.setLotId(getLong(JSP_LOT_ID));
            salesData.setLotTypeId(getLong(JSP_LOT_TYPE_ID));
            salesData.setUserId(getLong(JSP_USER_ID));            
            salesData.setDateTransaction(JSPFormater.formatDate(getString(JSP_DATE_TRANSACTION), "dd/MM/yyyy"));            
            salesData.setPaymentType(getInt(JSP_PAYMENT_TYPE));
            salesData.setSalesPrice(getDouble(JSP_SALES_PRICE));            
            salesData.setDiscount(getDouble(JSP_DISCOUNT));
            salesData.setPriceAfterDiscount(getDouble(JSP_PRICE_AFTER_DISCOUNT));
            salesData.setPpn(getDouble(JSP_PPN));
            salesData.setFinalPrice(getDouble(JSP_FINAL_PRICE));
            salesData.setBfAmount(getDouble(JSP_BF_AMOUNT));
            salesData.setBfDueDate(JSPFormater.formatDate(getString(JSP_BF_DUE_DATE), "dd/MM/yyyy"));            
            salesData.setDpAmount(getDouble(JSP_DP_AMOUNT));
            salesData.setDpDueDate(JSPFormater.formatDate(getString(JSP_DP_DUE_DATE), "dd/MM/yyyy"));            
            salesData.setAmountPelunasan(getDouble(JSP_AMOUNT_PELUNASAN));
            salesData.setPelunasanDueDate(JSPFormater.formatDate(getString(JSP_PELUNASAN_DUE_DATE), "dd/MM/yyyy"));            
            salesData.setName(getString(JSP_NAME));
            salesData.setAddress(getString(JSP_ADDRESS));
            salesData.setAddress2(getString(JSP_ADDRESS2));  
            salesData.setIdNumber(getString(JSP_ID_NUMBER));
            salesData.setPh(getString(JSP_PH));
            salesData.setTelephone(getString(JSP_TELEPHONE));
            salesData.setEmail(getString(JSP_EMAIL));
            salesData.setSpecialRequirement(getString(JSP_SPECIAL_REQUIREMENT));            
            salesData.setUserName(getString(JSP_USER_NAME));
            salesData.setCustomerId(getLong(JSP_CUSTOMER_ID));         
            salesData.setPersenDp(getDouble(JSP_PERSEN_DP));
            salesData.setPersenPelunasan(getDouble(JSP_PERSEN_PELUNASAN));
            salesData.setPeriode(getInt(JSP_PERIODE));
            salesData.setAngsuran(getDouble(JSP_ANGSURAN));            
            salesData.setPersenAngsuran(getDouble(JSP_PERSEN_ANGSURAN));   
            salesData.setDueDateAngsuran(JSPFormater.formatDate(getString(JSP_DUE_DATE_ANGSURAN), "dd/MM/yyyy"));
            salesData.setPersenBunga(getDouble(JSP_PERSEN_BUNGA));            
            salesData.setPeriodeDp(getInt(JSP_PERIODE_DP));
            salesData.setStatus(getInt(JSP_STATUS));
            salesData.setBiayaKpa(getDouble(JSP_BIAYA_KPA));
            salesData.setBankId(getLong(JSP_BANK_ID));
            salesData.setCoverAmount(getDouble(JSP_COVER_AMOUNT));
            salesData.setCreateId(getLong(JSP_CREATE_ID));
            salesData.setNpwp(getString(JSP_NPWP));
            int valInpJournalNum = 0;
            try{
                valInpJournalNum = Integer.parseInt(DbSystemProperty.getValueByName("PROP_INPUT_JOURNAL_NUMBER"));
            }catch(Exception e){
                valInpJournalNum = 0;
            }
            if(valInpJournalNum == 1){
                salesData.setSalesNumber(getString(JSP_SALES_NUMBER));
            }
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

