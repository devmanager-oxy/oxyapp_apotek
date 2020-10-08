/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy
 */

public class JspCustomerOpr extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Customer customer;
    
    public static final String JSP_NAME_CUSTOMER = "JSP_NAME_CUSTOMER";
    public static final int JSP_NAME = 0;
    public static final int JSP_TYPE = 1;
    public static final int JSP_ADDRESS_1 = 2;    
    public static final int JSP_CITY = 3;
    public static final int JSP_COUNTRY_ID = 4;
    public static final int JSP_POSTAL_CODE = 5;
    public static final int JSP_CONTACT_PERSON = 6;
    public static final int JSP_POSISI_CONTACT_PERSON = 7;
    public static final int JSP_COUNTRY_CODE = 8;
    public static final int JSP_AREA_CODE = 9;
    public static final int JSP_PHONE = 10;
    public static final int JSP_NATIONALITY_ID = 11;
    public static final int JSP_STATE = 12;
    public static final int JSP_HOTEL_NOTE = 13;
    public static final int JSP_ID_TYPE = 14;
    public static final int JSP_ID_NUMBER = 15;
    public static final int JSP_OCCUPATION = 16;
    public static final int JSP_DOB = 17;    
    public static final int JSP_SALUTATION = 18;
    public static final int JSP_DOB_IGNORE = 19;
    public static final int JSP_CODE = 20;
    public static final int JSP_PHONE_AREA = 21;
    public static final int JSP_FAX_AREA = 22;
    public static final int JSP_MIDDLE_NAME = 23;
    public static final int JSP_LAST_NAME = 24;    
    public static final int JSP_HP = 25;
    public static final int JSP_ZIP_CODE = 26;
    public static final int JSP_CONTACT_PHONE_AREA = 27;
    public static final int JSP_CONTACT_PHONE = 28;
    public static final int JSP_CONTACT_POSITION = 29;
    public static final int JSP_CONTACT_EMAIL = 30;    
    public static final int JSP_GOL_PRICE = 31;
    public static final int JSP_PERSONAL_DISCOUNT =32;
    public static final int JSP_EXPIRED_DATE =33;
    public static final int JSP_ANIMAL_NAME =34;
    public static final int JSP_CREDIT_LIMIT =35;
    public static final int JSP_REG_DATE =36;
    public static final int JSP_NPWP =37;
    public static final int JSP_EMAIL =38;
    public static final int JSP_WEBSITE =39;
    public static final int JSP_FAX =40;
    
    public static final int JSP_PROPINSI_ID     =41;
    public static final int JSP_KABUPATEN_ID    =42;
    public static final int JSP_KECAMATAN_ID    =43;
    public static final int JSP_IS_PKP          =44;
    public static final int JSP_PKP_COMPANY     =45;
    public static final int JSP_PKP_ADDRESS     =46;
    public static final int JSP_PKP_NPPKP       =47;
    public static final int JSP_SCH_SENIN       =48;
    public static final int JSP_SCH_SELASA      =49;
    public static final int JSP_SCH_RABU        =50;
    public static final int JSP_SCH_KAMIS       =51;
    public static final int JSP_SCH_JUMAT       =52;
    public static final int JSP_SCH_SABTU       =53;
    public static final int JSP_SCH_MINGGU      =54;
    public static final int JSP_IGNORE_LOC_CREDIT_LIMIT      =55;
    public static final int JSP_DUE_DATE        =56;
    public static final int JSP_MAX_PENDING_ORDER        =57;
    public static final int JSP_STATUS        =58;
    public static final int JSP_DEF_DUE_DATE_DAY        = 59;
    public static final int JSP_INDUK_CUSTOMER_ID        = 60;
    
    public static String[] colNames = {
        "JSP_NAME",
        "JSP_TYPE",
        "JSP_ADDRESS_1",        
        "JSP_CITY",
        "JSP_COUNTRY_ID",
        "JSP_POSTAL_CODE",
        "JSP_CONTACT_PERSON",
        "JSP_POSISI_CONTACT_PERSON",
        "JSP_COUNTRY_CODE",
        "JSP_AREA_CODE",
        "JSP_PHONE",
        "JSP_NATIONALITY_ID",
        "JSP_STATE",        
        "JSP_HOTEL_NOTE",
        "JSP_ID_TYPE",
        "JSP_ID_NUMBER",
        "JSP_OCCUPATION",
        "JSP_DOB",        
        "JSP_SALUTATION",
        "JSP_DOB_IGNORE",
        "JSP_CODE",
        "JSP_PHONE_AREA",
        "JSP_FAX_AREA",
        "JSP_MIDDLE_NAME",
        "JSP_LAST_NAME",        
        "JSP_HP",
        "JSP_ZIP_CODE",
        "JSP_CONTACT_PHONE_AREA",
        "JSP_CONTACT_PHONE",
        "JSP_CONTACT_POSITION",
        "JSP_CONTACT_EMAIL",        
        "JSP_GOL_PRICE",
        "JSP_PERSONAL_DISCOUNT",
        "JSP_EXPIRED_DATE",
        "JSP_ANIMAL_NAME",
        "JSP_CREDIT_LIMIT",
        "JSP_REG_DATE",
        "JSP_NPWP",
        "JSP_EMAIL",
        "JSP_WEBSITE",
        "JSP_FAX",                
        "JSP_PROPINSI_ID",
        "JSP_KABUPATEN_ID",
        "JSP_KECAMATAN_ID",
        "JSP_IS_PKP",
        "JSP_PKP_COMPANY",
        "JSP_PKP_ADDRESS",
        "JSP_PKP_NPPKP",
        "JSP_SCH_SENIN",
        "JSP_SCH_SELASA",
        "JSP_SCH_RABU",
        "JSP_SCH_KAMIS",
        "JSP_SCH_JUMAT",
        "JSP_SCH_SABTU",
        "JSP_SCH_MINGGU",
        "JSP_IGNORE_LOC_CREDIT_LIMIT",
        "JSP_DUE_DATE",
        "JSP_MAX_PENDING_ORDER",
        "JSP_STATUS",
        "JSP_DEF_DUE_DATE_DAY",
        "JSP_INDUK_CUSTOMER_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED, //"JSP_NAME",
        TYPE_INT,
        TYPE_STRING, 
        TYPE_STRING, 
        TYPE_LONG, 
        TYPE_STRING,
        TYPE_STRING, 
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING, //"JSP_PHONE",
        TYPE_LONG,
        TYPE_STRING,        
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING ,
        TYPE_STRING,
        TYPE_STRING,//20        
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,        
        TYPE_STRING , // JSP_HP
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,//35
        TYPE_STRING,        
        TYPE_STRING,
        TYPE_FLOAT,        
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,//JSP_EMAIL
        TYPE_STRING,
        TYPE_STRING,
        
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG
    };

    public JspCustomerOpr() {
    }

    public JspCustomerOpr(Customer customer) {
        this.customer = customer;
    }

    public JspCustomerOpr(HttpServletRequest request) {
        super(new JspCustomerOpr(), request);
    }

    public JspCustomerOpr(HttpServletRequest request, Customer customer) {
        super(new JspCustomerOpr(customer), request);
        this.customer = customer;
    }

    public String getFormName() {
        return JSP_NAME_CUSTOMER;
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

    public Customer getEntityObject() {
        return customer;
    }

    public void requestEntityObject(Customer customer) {
        try {

            this.requestParam();
            customer.setType(getInt(JSP_TYPE));
            customer.setName(getString(JSP_NAME));
            customer.setAddress1(getString(JSP_ADDRESS_1));            
            customer.setCity(getString(JSP_CITY));
            customer.setCountryId(getLong(JSP_COUNTRY_ID));
            customer.setPostalCode(getString(JSP_POSTAL_CODE));
            customer.setContactPerson(getString(JSP_CONTACT_PERSON));            
            customer.setCountryCode(getString(JSP_COUNTRY_CODE));
            customer.setAreaCode(getString(JSP_AREA_CODE));
            customer.setPhone(getString(JSP_PHONE));
            customer.setNationalityId(getLong(JSP_NATIONALITY_ID));                        
            customer.setIdType(getString(JSP_ID_TYPE));
            customer.setIdNumber(getString(JSP_ID_NUMBER));
            customer.setOccupation(getString(JSP_OCCUPATION));
            customer.setDob(JSPFormater.formatDate(getString(JSP_DOB), "dd/MM/yyyy"));              
            customer.setSalutation(getString(JSP_SALUTATION));            
            customer.setDobIgnore(getInt(JSP_DOB_IGNORE));            
            customer.setCode(getString(JSP_CODE));
            customer.setPhoneArea(getString(JSP_PHONE_AREA));
            customer.setFaxArea(getString(JSP_FAX_AREA));
            customer.setMiddleName(getString(JSP_MIDDLE_NAME));
            customer.setLastName(getString(JSP_LAST_NAME));            
            customer.setHp(getString(JSP_HP));
            customer.setZipCode(getString(JSP_ZIP_CODE));
            customer.setContactPhoneArea(getString(JSP_CONTACT_PHONE_AREA));
            customer.setContactPhone(getString(JSP_CONTACT_PHONE));
            customer.setContactPosition(getString(JSP_CONTACT_POSITION));
            customer.setContactEmail(getString(JSP_CONTACT_EMAIL));            
            customer.setGolPrice(getString(JSP_GOL_PRICE));
            customer.setPersonalDiscount(getDouble(JSP_PERSONAL_DISCOUNT));
            customer.setExpiredDate(getDate(JSP_EXPIRED_DATE));
            customer.setAnimalName(getString(JSP_ANIMAL_NAME));
            customer.setCreditLimit(getDouble(JSP_CREDIT_LIMIT));            
            customer.setNpwp(getString(JSP_NPWP));
            customer.setEmail(getString(JSP_EMAIL));
            customer.setPropinsiId(getLong(JSP_PROPINSI_ID));
            customer.setKabupatenId(getLong(JSP_KABUPATEN_ID));
            customer.setKecamatanId(getLong(JSP_KECAMATAN_ID));
            customer.setIsPkp(getInt(JSP_IS_PKP));
            customer.setPkpCompany(getString(JSP_PKP_COMPANY));
            customer.setPkpAddress(getString(JSP_PKP_ADDRESS));
            customer.setPkpNppkp(getString(JSP_PKP_NPPKP));
            customer.setSchSenin(getInt(JSP_SCH_SENIN));
            customer.setSchSelasa(getInt(JSP_SCH_SELASA));
            customer.setSchRabu(getInt(JSP_SCH_RABU));
            customer.setSchKamis(getInt(JSP_SCH_KAMIS));
            customer.setSchJumat(getInt(JSP_SCH_JUMAT));
            customer.setSchSabtu(getInt(JSP_SCH_SABTU));
            customer.setSchMinggu(getInt(JSP_SCH_MINGGU));
            customer.setIgnoreLocCreditLimit(getInt(JSP_IGNORE_LOC_CREDIT_LIMIT));
            customer.setDueDate(getInt(JSP_DUE_DATE));
            customer.setMaxPendingOrder(getInt(JSP_MAX_PENDING_ORDER));
            customer.setStatus(getString(JSP_STATUS));
            customer.setDefDueDateDay(getInt(JSP_DEF_DUE_DATE_DAY));
            customer.setIndukCustomerId(getLong(JSP_INDUK_CUSTOMER_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
