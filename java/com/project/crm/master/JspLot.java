/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.master;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Tu Roy
 */
public class JspLot extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Lot lot;
    
    public static final String JSP_NAME_LOT = "lot";    
    
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
    
    public static final int JSP_LUAS_TANAH = 21;
    public static final int JSP_LUAS_BANGUNAN = 22;
    
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
        "x_lot_value_id",
        "x_rental_rate",
        "x_lot_type_id",
        "x_luas_tanah",
        "x_luas_bangunan"
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
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT
    };
    
    public JspLot() {
    }

    public JspLot(Lot lot) {
        this.lot = lot;
    }

    public JspLot(HttpServletRequest request, Lot lot) {
        super(new JspLot(lot), request);
        this.lot = lot;
    }

    public String getFormName() {
        return JSP_NAME_LOT;
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

    public Lot getEntityObject() {
        return lot;
    }

    public void requestEntityObject(Lot lot){
        try {
            this.requestParam();
            lot.setNama(getString(JSP_NAMA));
            lot.setPanjang(getDouble(JSP_PANJANG));
            lot.setLebar(getDouble(JSP_LEBAR));
            lot.setKeterangan(getString(JSP_KETERANGAN));
            lot.setStatus(getInt(JSP_STATUS));            
            lot.setNo(getInt(JSP_NO));
            lot.setForeignCurrencyId(getLong(JSP_FOREIGN_CURRENCY_ID));
            lot.setForeignAmount(getDouble(JSP_FOREIGN_AMOUNT));
            lot.setBookedRate(getDouble(JSP_BOOKED_RATE));
            lot.setAmount(getDouble(JSP_AMOUNT));
            lot.setNamePic(getString(JSP_NAME_PIC));
            lot.setPropertyId(getLong(JSP_PROPERTY_ID));
            lot.setFloorId(getLong(JSP_FLOOR_ID));
            lot.setBuildingId(getLong(JSP_BUILDING_ID));            
            lot.setCashKeras(getDouble(JSP_CASH_KERAS));
            lot.setCashByTermin(getDouble(JSP_CASH_BY_TERMIN));
            lot.setKpa(getDouble(JSP_KPA));
            lot.setLotValueId(getLong(JSP_LOT_VALUE_ID));
            lot.setRentalRate(getDouble(JSP_RENTAL_RATE));
            lot.setLotTypeId(getLong(JSP_LOT_TYPE_ID));
            
            lot.setLuasTanah(getDouble(JSP_LUAS_TANAH));
            lot.setLuasBangunan(getDouble(JSP_LUAS_BANGUNAN));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
