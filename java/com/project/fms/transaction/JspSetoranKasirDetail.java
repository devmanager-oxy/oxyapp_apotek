/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.util.*;

/**
 *
 * @author Roy
 */
public class JspSetoranKasirDetail extends JSPHandler implements I_JSPInterface, I_JSPType {
    private SetoranKasirDetail setoranKasirDetail;
    
    public static final String JSP_NAME_SETORANKASIRDETAIL = "JSP_NAME_SETORANKASIRDETAIL";
    
    public static final int JSP_SETORAN_KASIR_DETAIL_ID = 0;
    public static final int JSP_SETORAN_KASIR_ID = 1;    
    public static final int JSP_TANGGAL = 2;    
    public static final int JSP_CASH = 3;
    public static final int JSP_CARD = 4;
    public static final int JSP_CASH_BACK = 5;
    public static final int JSP_SETORAN_TOKO = 6;
    public static final int JSP_SELISIH = 7;    
    public static final int JSP_COA_ID = 8; 
    public static final int JSP_SYSTEM = 9; 
    
    public static String[] colNames = {
        "JSP_SETORAN_KASIR_DETAIL_ID",
        "JSP_SETORAN_KASIR_ID",
        "JSP_TANGGAL",
        "JSP_CASH",
        "JSP_CARD",
        "JSP_CASH_BACK",
        "JSP_SETORAN_TOKO",
        "JSP_SELISIH",
        "JSP_COA_ID",
        "JSP_SYSTEM"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT
    };

    public JspSetoranKasirDetail() {
    }

    public JspSetoranKasirDetail(SetoranKasirDetail setoranKasirDetail) {
        this.setoranKasirDetail = setoranKasirDetail;
    }

    public JspSetoranKasirDetail(HttpServletRequest request, SetoranKasirDetail setoranKasirDetail) {
        super(new JspSetoranKasirDetail(setoranKasirDetail), request);
        this.setoranKasirDetail = setoranKasirDetail;
    }

    public String getFormName() {
        return JSP_NAME_SETORANKASIRDETAIL;
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

    public SetoranKasirDetail getEntityObject() {
        return setoranKasirDetail;
    }

    public void requestEntityObject(SetoranKasirDetail setoranKasirDetail) {
        try {
            this.requestParam();
            setoranKasirDetail.setSetoranKasirId(getLong(JSP_SETORAN_KASIR_ID));
            setoranKasirDetail.setTanggal(getDate(JSP_TANGGAL));
            setoranKasirDetail.setCash(getDouble(JSP_CASH));
            setoranKasirDetail.setCard(getDouble(JSP_CARD));
            setoranKasirDetail.setCashBack(getDouble(JSP_CASH_BACK));
            setoranKasirDetail.setSetoranToko(getDouble(JSP_SETORAN_TOKO));
            setoranKasirDetail.setSelisih(getDouble(JSP_SELISIH));
            setoranKasirDetail.setCoaId(getLong(JSP_COA_ID));
            setoranKasirDetail.setSystem(getDouble(JSP_SYSTEM));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
