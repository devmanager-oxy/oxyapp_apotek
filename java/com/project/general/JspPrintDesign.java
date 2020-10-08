/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class JspPrintDesign extends JSPHandler implements I_JSPInterface, I_JSPType {

    private PrintDesign printDesign;
    public static final String JSP_PRINT_DESIGN = "JSP_PRINT_DESIGN";
    public static final int JSP_PRINT_DESIGN_ID = 0;
    public static final int JSP_NAME_DOCUMENT = 1;
    public static final int JSP_WIDTH_PRINT = 2;
    public static final int JSP_HEIGHT_PRINT = 3;
    public static final int JSP_FONT_HEADER = 4;
    public static final int JSP_SIZE_FONT_HEADER = 5;
    public static final int JSP_FONT_DATA_MAIN = 6;
    public static final int JSP_SIZE_FONT_DATA_MAIN = 7;
    public static final int JSP_WIDTH_TABLE_DATA_MAIN = 8;
    public static final int JSP_HEIGHT_TABLE_DATA_MAIN = 9;
    public static final int JSP_BORDER_TITLE_COLUMN = 10;
    public static final int JSP_FONT_TITLE_COLUMN = 11;
    public static final int JSP_SIZE_FONT_TITLE_COLUMN = 12;
    public static final int JSP_BORDER_DATA_DETAIL = 13;
    public static final int JSP_FONT_DATA_DETAIL = 14;
    public static final int JSP_SIZE_FONT_DATA_DETAIL = 15;
    public static final int JSP_BORDER_DATA_TOTAL = 16;
    public static final int JSP_FONT_DATA_TOTAL = 17;
    public static final int JSP_SIZE_FONT_DATA_TOTAL = 18;
    public static final int JSP_BORDER_DATA_APPROVAL = 19;
    public static final int JSP_FONT_DATA_APPROVAL = 20;
    public static final int JSP_SIZE_FONT_DATA_APPROVAL = 21;
    public static final int JSP_BORDER_DATA_FOOTER = 22;
    public static final int JSP_FONT_DATA_FOOTER = 23;
    public static final int JSP_SIZE_FONT_DATA_FOOTER = 24;
    public static String[] colNames = {
        "jsp_print_design_id",
        "jsp_name_document",
        "jsp_width_print",
        "jsp_height_print",
        "jsp_font_header",
        "jsp_size_font_header",
        "jsp_font_data_main",
        "jsp_size_font_data_main",
        "jsp_width_table_data_main",
        "jsp_height_table_data_main",
        "jsp_border_title_column",
        "jsp_font_title_column",
        "jsp_size_font_title_column",
        "jsp_border_data_detail",
        "jsp_font_data_detail",
        "jsp_size_font_data_detail",
        "jsp_border_data_total",
        "jsp_font_data_total",
        "jsp_size_font_data_total",
        "jsp_border_data_approval",
        "jsp_font_data_approval",
        "jsp_size_font_data_approval",
        "jsp_border_data_footer",
        "jsp_font_data_footer",
        "jsp_size_font_data_footer"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, //"print_design_id", //0
        TYPE_STRING + ENTRY_REQUIRED, //"name_document",
        TYPE_INT,//"width_print",
        TYPE_INT,//"height_print",     
        TYPE_STRING,//"font_header",
        TYPE_INT,//"size_font_header",                
        TYPE_STRING,//"font_data_main",
        TYPE_INT,//"size_font_data_main",                
        TYPE_INT,//"width_table_data_main",
        TYPE_INT,//"heigt_table_data_main",   
        TYPE_INT,//"border_title_column",
        TYPE_STRING,//"font_title_column",
        TYPE_INT,//"size_font_title_column",                
        TYPE_INT,//"border_data_detail",                
        TYPE_STRING,//"font_data_detail",
        TYPE_INT,//"size_font_data_detail",                
        TYPE_INT,//"border_data_total",
        TYPE_STRING,//"font_data_total",                
        TYPE_INT,//"size_font_data_total",                
        TYPE_INT,//"border_data_approval",
        TYPE_STRING,//"font_data_approval",
        TYPE_INT,//"size_font_data_approval",                
        TYPE_INT,//"border_data_footer",
        TYPE_STRING,//"font_data_footer",
        TYPE_INT//"size_font_data_footer"       
    };

    public JspPrintDesign() {
    }

    public JspPrintDesign(PrintDesign printDesign) {
        this.printDesign = printDesign;
    }

    public JspPrintDesign(HttpServletRequest request, PrintDesign printDesign) {
        super(new JspPrintDesign(printDesign), request);
        this.printDesign = printDesign;
    }

    public String getFormName() {
        return JSP_PRINT_DESIGN;
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

    public PrintDesign getEntityObject() {
        return printDesign;
    }

    public void requestEntityObject(PrintDesign printDesign) {
        try {
            this.requestParam();

            printDesign.setNameDocument(getString(JSP_NAME_DOCUMENT)); //"name_document",
            printDesign.setWidthPrint(getInt(JSP_WIDTH_PRINT)); //"width_print",
            printDesign.setHeightPrint(getInt(JSP_HEIGHT_PRINT)); //"height_print",     
            printDesign.setFontHeader(getString(JSP_FONT_HEADER)); //"font_header",
            printDesign.setSizeFontHeader(getInt(JSP_SIZE_FONT_HEADER)); //"size_font_header",                
            printDesign.setFontDataMain(getString(JSP_FONT_DATA_MAIN));  //"font_data_main",
            printDesign.setSizeFontDataMain(getInt(JSP_SIZE_FONT_DATA_MAIN)); //"size_font_data_main",                
            printDesign.setWidthTableDataMain(getInt(JSP_WIDTH_TABLE_DATA_MAIN)); //"width_table_data_main",
            printDesign.setHeightTableDataMain(getInt(JSP_HEIGHT_TABLE_DATA_MAIN)); //"heigt_table_data_main",   
            printDesign.setBorderTitleColumn(getInt(JSP_BORDER_TITLE_COLUMN)); //"border_title_column",
            printDesign.setFontTitleColumn(getString(JSP_FONT_TITLE_COLUMN)); //"font_title_column",
            printDesign.setSizeFontTitleColumn(getInt(JSP_SIZE_FONT_TITLE_COLUMN)); //"size_font_title_column",                
            printDesign.setBorderDataDetail(getInt(JSP_BORDER_DATA_DETAIL)); //"border_data_detail",                
            printDesign.setFontDataDetail(getString(JSP_FONT_DATA_DETAIL)); //"font_data_detail",
            printDesign.setSizeFontDataDetail(getInt(JSP_SIZE_FONT_DATA_DETAIL)); //"size_font_data_detail",                
            printDesign.setBorderDataTotal(getInt(JSP_BORDER_DATA_TOTAL)); //"border_data_total",
            printDesign.setFontDataTotal(getString(JSP_FONT_DATA_TOTAL)); //"font_data_total",                
            printDesign.setSizeFontDataTotal(getInt(JSP_SIZE_FONT_DATA_TOTAL)); //"size_font_data_total",                
            printDesign.setBorderDataApproval(getInt(JSP_BORDER_DATA_APPROVAL)); //"border_data_approval",
            printDesign.setFontDataApproval(getString(JSP_FONT_DATA_APPROVAL)); //"font_data_approval",
            printDesign.setSizeFontDataApproval(getInt(JSP_SIZE_FONT_DATA_APPROVAL)); //"size_font_data_approval",                
            printDesign.setBorderDataFooter(getInt(JSP_BORDER_DATA_FOOTER)); //"border_data_footer",
            printDesign.setFontDataFooter(getString(JSP_FONT_DATA_FOOTER)); //"font_data_footer",
            printDesign.setSizeFontDataFooter(getInt(JSP_SIZE_FONT_DATA_FOOTER)); //"size_font_data_footer"       

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
