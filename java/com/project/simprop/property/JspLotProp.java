/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Tu Roy
 */
public class JspLotProp extends JSPHandler implements I_JSPInterface, I_JSPType {

    private LotProp lotProp;
    
    public static final String JSP_NAME_LOTPROP = "JSP_NAME_LOTPROP";    
    
    public static final int JSP_NAMA        = 0;
    public static final int JSP_PANJANG     = 1;
    public static final int JSP_LEBAR       = 2;
    public static final int JSP_LUAS        = 3;
    public static final int JSP_KETERANGAN  = 4;
    public static final int JSP_STATUS      = 5;    
    public static final int JSP_NO          = 6;
    public static final int JSP_FOREIGN_CURRENCY_ID = 7;
    public static final int JSP_FOREIGN_AMOUNT = 8;
    public static final int JSP_BOOKED_RATE = 9;
    public static final int JSP_AMOUNT = 10;
    public static final int JSP_NAME_PIC = 11;
    public static final int JSP_PROPERTY_ID = 12;
    public static final int JSP_FLOOR_ID = 13;
    public static final int JSP_BUILDING_ID = 14;    
    public static final int JSP_CASH_KERAS = 15;
    public static final int JSP_CASH_BY_TERMIN = 16;
    public static final int JSP_KPA = 17;
    public static final int JSP_LOT_VALUE_ID = 18;
    public static final int JSP_RENTAL_RATE = 19;
    public static final int JSP_LOT_TYPE_ID = 20;
    
    public static String[] colNames = {
        "x_nama",
        "x_panjang",
        "x_lebar",
        "x_luas",
        "x_keterangan",
        "x_status",        
        "x_no",
        "x_foreign_currency_id",
        "x_foreign_amount",
        "x_booked_rate",
        "x_amount",
        "x_name_pic",
        "x_property_id",
        "x_floor_id",
        "x_building_id",
        "x_cash_keras",
        "x_cash_by_termin",
        "x_kpa",
        "x_lotProp_value_id",
        "x_rental_rate",
        "x_lotProp_type_id"
    };
    
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_FLOAT  ,
        TYPE_FLOAT  ,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_INT,        
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG
    };
    
    public JspLotProp() {
    }

    public JspLotProp(LotProp lotProp) {
        this.lotProp = lotProp;
    }

    public JspLotProp(HttpServletRequest request, LotProp lotProp) {
        super(new JspLotProp(lotProp), request);
        this.lotProp = lotProp;
    }

    public String getFormName() {
        return JSP_NAME_LOTPROP;
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

    public LotProp getEntityObject() {
        return lotProp;
    }

    public void requestEntityObject(LotProp lotProp){
        try {
            this.requestParam();
            lotProp.setNama(getString(JSP_NAMA));
            lotProp.setPanjang(getDouble(JSP_PANJANG));
            lotProp.setLebar(getDouble(JSP_LEBAR));
            lotProp.setKeterangan(getString(JSP_KETERANGAN));
            lotProp.setStatus(getInt(JSP_STATUS));            
            lotProp.setNo(getInt(JSP_NO));
            lotProp.setForeignCurrencyId(getLong(JSP_FOREIGN_CURRENCY_ID));
            lotProp.setForeignAmount(getDouble(JSP_FOREIGN_AMOUNT));
            lotProp.setBookedRate(getDouble(JSP_BOOKED_RATE));
            lotProp.setAmount(getDouble(JSP_AMOUNT));
            lotProp.setNamePic(getString(JSP_NAME_PIC));
            lotProp.setPropertyId(getLong(JSP_PROPERTY_ID));
            lotProp.setFloorId(getLong(JSP_FLOOR_ID));
            lotProp.setBuildingId(getLong(JSP_BUILDING_ID));            
            lotProp.setCashKeras(getDouble(JSP_CASH_KERAS));
            lotProp.setCashByTermin(getDouble(JSP_CASH_BY_TERMIN));
            lotProp.setKpa(getDouble(JSP_KPA));
            lotProp.setLotValueId(getLong(JSP_LOT_VALUE_ID));
            lotProp.setRentalRate(getDouble(JSP_RENTAL_RATE));
            lotProp.setLotTypeId(getLong(JSP_LOT_TYPE_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
