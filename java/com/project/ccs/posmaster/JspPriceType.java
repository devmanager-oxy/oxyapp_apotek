/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;
import com.project.system.DbSystemProperty;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class JspPriceType extends JSPHandler implements I_JSPInterface, I_JSPType{
    
    private PriceType priceType;
    
    public static final String JSP_NAME_PRICE_TYPE = "JSP_PRICE_TYPE";        
    
    public static final int JSP_PRICE_TYPE_ID   = 0;
    public static final int JSP_ITEM_MASTER_ID  = 1;
    public static final int JSP_QTY_FROM        = 2;
    public static final int JSP_QTY_TO          = 3;
    public static final int JSP_GOL_1           = 4;
    public static final int JSP_GOL_2           = 5;
    public static final int JSP_GOL_3           = 6;
    public static final int JSP_GOL_4           = 7;
    public static final int JSP_GOL_5           = 8;
    public static final int JSP_GOL1_MARGIN     = 9;
    public static final int JSP_GOL2_MARGIN     = 10;
    public static final int JSP_GOL3_MARGIN     = 11;
    public static final int JSP_GOL4_MARGIN     = 12;
    public static final int JSP_GOL5_MARGIN     = 13;   
    
    public static final int JSP_GOL_6           = 14;
    public static final int JSP_GOL_7           = 15;
    public static final int JSP_GOL_8           = 16;
    public static final int JSP_GOL_9           = 17;
    public static final int JSP_GOL_10          = 18;
    public static final int JSP_GOL6_MARGIN     = 19;
    public static final int JSP_GOL7_MARGIN     = 20;
    public static final int JSP_GOL8_MARGIN     = 21;
    public static final int JSP_GOL9_MARGIN     = 22;
    public static final int JSP_GOL10_MARGIN    = 23;
    public static final int JSP_GOL_11          = 24;
    public static final int JSP_GOL11_MARGIN    = 25;
    
    public static String[] colNames = {
        "JSP_PRICE_TYPE_ID", 
        "JSP_ITEM_MASTER_ID",
        "JSP_QTY_FROM",
        "JSP_QTY_TO",
        "JSP_GOL_1",
        "JSP_GOL_2",
        "JSP_GOL_3",
        "JSP_GOL_4",
        "JSP_GOL_5",
        "JSP_GOL1_MARGIN",
        "JSP_GOL2_MARGIN",
        "JSP_GOL3_MARGIN",
        "JSP_GOL4_MARGIN",
        "JSP_GOL5_MARGIN",
        
        "JSP_GOL_6",
        "JSP_GOL_7",
        "JSP_GOL_8",
        "JSP_GOL_9",
        "JSP_GOL_10",
        "JSP_GOL6_MARGIN",
        "JSP_GOL7_MARGIN",
        "JSP_GOL8_MARGIN",
        "JSP_GOL9_MARGIN",
        "JSP_GOL10_MARGIN",
        "JSP_GOL_11",
        "JSP_GOL11_MARGIN"
    };
    
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_INT + ENTRY_REQUIRED,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT        
    };
    
    
    public JspPriceType() {
    }

    public JspPriceType(PriceType priceType) {
        this.priceType = priceType;
    }

    public JspPriceType(HttpServletRequest request, PriceType priceType) {
        super(new JspPriceType(priceType), request);
        this.priceType = priceType;
    }

    public String getFormName() {
        return JSP_NAME_PRICE_TYPE;
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

    public PriceType getEntityObject() {
        return priceType;
    }

    public void requestEntityObject(PriceType priceType) {
        try {
            this.requestParam();
            int jum =1;
            jum = Integer.parseInt(DbSystemProperty.getValueByName("jum_gol"));
            priceType.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            priceType.setQtyFrom(getInt(JSP_QTY_FROM));        
            priceType.setQtyTo(getInt(JSP_QTY_TO));        
            if(jum>=1){
            priceType.setGol1(getDouble(JSP_GOL_1));        
            priceType.setGol1_margin(getDouble(JSP_GOL1_MARGIN));
            }
            if(jum>=2){
            priceType.setGol2(getDouble(JSP_GOL_2));
            priceType.setGol2_margin(getDouble(JSP_GOL2_MARGIN));        
            }
            if(jum>=3){
            priceType.setGol3(getDouble(JSP_GOL_3));        
            priceType.setGol3_margin(getDouble(JSP_GOL3_MARGIN));        
            }
            if(jum>=4){
            priceType.setGol4(getDouble(JSP_GOL_4));        
            priceType.setGol4_margin(getDouble(JSP_GOL4_MARGIN)); 
            }
            if(jum>=5){
            priceType.setGol5(getDouble(JSP_GOL_5));
            priceType.setGol5_margin(getDouble(JSP_GOL5_MARGIN));
            }
            if(jum>=6){           
            priceType.setGol6(getDouble(JSP_GOL_6));        
            priceType.setGol6_margin(getDouble(JSP_GOL6_MARGIN));        
            }
            if(jum>=7){
            priceType.setGol7(getDouble(JSP_GOL_7));        
            priceType.setGol7_margin(getDouble(JSP_GOL7_MARGIN));        
            }
            if(jum>=8){
            priceType.setGol8(getDouble(JSP_GOL_8));        
            priceType.setGol8_margin(getDouble(JSP_GOL8_MARGIN));        
            }
            if(jum>=9){
            priceType.setGol9(getDouble(JSP_GOL_9));        
            priceType.setGol9_margin(getDouble(JSP_GOL9_MARGIN));        
            }
            if(jum>=10){
            priceType.setGol10(getDouble(JSP_GOL_10));
            priceType.setGol10_margin(getDouble(JSP_GOL10_MARGIN));
            }
            
            if(jum>=11){
            priceType.setGol11(getDouble(JSP_GOL_11));
            priceType.setGol11_margin(getDouble(JSP_GOL11_MARGIN));
            }
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
