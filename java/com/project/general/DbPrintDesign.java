/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;

/**
 *
 * @author Roy Andika
 */
public class DbPrintDesign extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language{

    public static final String DB_PRINT_DESIGN = "print_design";
    public static final int COL_PRINT_DESIGN_ID = 0;
    public static final int COL_NAME_DOCUMENT = 1;
    public static final int COL_WIDTH_PRINT = 2;
    public static final int COL_HEIGHT_PRINT = 3;
    public static final int COL_FONT_HEADER = 4;
    public static final int COL_SIZE_FONT_HEADER = 5;
    public static final int COL_FONT_DATA_MAIN = 6;
    public static final int COL_SIZE_FONT_DATA_MAIN = 7;
    public static final int COL_WIDTH_TABLE_DATA_MAIN = 8;
    public static final int COL_HEIGHT_TABLE_DATA_MAIN = 9;
    public static final int COL_BORDER_TITLE_COLUMN = 10;
    public static final int COL_FONT_TITLE_COLUMN = 11;
    public static final int COL_SIZE_FONT_TITLE_COLUMN = 12;
    public static final int COL_BORDER_DATA_DETAIL = 13;
    public static final int COL_FONT_DATA_DETAIL = 14;
    public static final int COL_SIZE_FONT_DATA_DETAIL = 15;
    public static final int COL_BORDER_DATA_TOTAL = 16;
    public static final int COL_FONT_DATA_TOTAL = 17;
    public static final int COL_SIZE_FONT_DATA_TOTAL = 18;
    public static final int COL_BORDER_DATA_APPROVAL = 19;
    public static final int COL_FONT_DATA_APPROVAL = 20;
    public static final int COL_SIZE_FONT_DATA_APPROVAL = 21;
    public static final int COL_BORDER_DATA_FOOTER = 22;
    public static final int COL_FONT_DATA_FOOTER = 23;
    public static final int COL_SIZE_FONT_DATA_FOOTER = 24;
    public static final String[] colNames = {
        "print_design_id", //0
        "name_document",
        "width_print",
        "height_print",
        "font_header",
        "size_font_header",
        "font_data_main",
        "size_font_data_main",
        "width_table_data_main",
        "height_table_data_main",
        "border_title_column",
        "font_title_column",
        "size_font_title_column",
        "border_data_detail",
        "font_data_detail",
        "size_font_data_detail",
        "border_data_total",
        "font_data_total",
        "size_font_data_total",
        "border_data_approval",
        "font_data_approval",
        "size_font_data_approval",
        "border_data_footer",
        "font_data_footer",
        "size_font_data_footer"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID, //"print_design_id"
        TYPE_STRING, //"name_document",
        TYPE_INT, //"width_print",
        TYPE_INT, //"height_print",     
        TYPE_STRING, //"font_header",
        TYPE_INT, //"size_font_header",                
        TYPE_STRING, //"font_data_main",
        TYPE_INT, //"size_font_data_main",                
        TYPE_INT, //"width_table_data_main",
        TYPE_INT, //"heigt_table_data_main",   
        TYPE_INT, //"border_title_column",
        TYPE_STRING, //"font_title_column",
        TYPE_INT, //"size_font_title_column",                
        TYPE_INT, //"border_data_detail",                
        TYPE_STRING, //"font_data_detail",
        TYPE_INT, //"size_font_data_detail",                
        TYPE_INT, //"border_data_total",
        TYPE_STRING, //"font_data_total",                
        TYPE_INT, //"size_font_data_total",                
        TYPE_INT, //"border_data_approval",
        TYPE_STRING, //"font_data_approval",
        TYPE_INT, //"size_font_data_approval",                
        TYPE_INT, //"border_data_footer",
        TYPE_STRING, //"font_data_footer",
        TYPE_INT //"size_font_data_footer"  
    };
    
    public static final int DOCUMENT_BKK        = 0;
    public static final int DOCUMENT_BKM        = 1;
    public static final int DOCUMENT_GL         = 2;
    public static final int DOCUMENT_INVOICE    = 3;
    public static final int DOCUMENT_KAS_OPNAME = 4;
    
     public static final String[] colNamesDocument = {
         "BKK",
         "BKM",
         "GL",
         "INVOICE",
         "KAS_OPNAME"
     };
     
     public static final String[] colNamesFont = {
        "Arial, Helvetica, sans-serif",
        "Times New Roman, Times, serif",
        "Courier New, Courier, mono",
        "Georgia, Times New Roman, Times, serif",
        "Verdana, Arial, Helvetica, sans-serif",
        "Geneva, Arial, Helvetica, san-serif"
     };
    

    public DbPrintDesign() {
    }

    public DbPrintDesign(int i) throws CONException {
        super(new DbPrintDesign()); 
    }

    public DbPrintDesign(String sOid) throws CONException {
        super(new DbPrintDesign(0)); 
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPrintDesign(long lOid) throws CONException {
        super(new DbPrintDesign(0)); 
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return DB_PRINT_DESIGN;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPrintDesign().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PrintDesign printDesign = fetchExc(ent.getOID());
        ent = (Entity) printDesign;
        return printDesign.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PrintDesign) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PrintDesign) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PrintDesign fetchExc(long oid) throws CONException {
        try {
            PrintDesign printDesign = new PrintDesign();
            DbPrintDesign pstPrintDesign = new DbPrintDesign(oid);

            printDesign.setOID(oid); //print_design_id
            printDesign.setNameDocument(pstPrintDesign.getString(COL_NAME_DOCUMENT)); //name_document                         
            printDesign.setWidthPrint(pstPrintDesign.getInt(COL_WIDTH_PRINT));  //width_print                       
            printDesign.setHeightPrint(pstPrintDesign.getInt(COL_HEIGHT_PRINT)); //height_print
            printDesign.setFontHeader(pstPrintDesign.getString(COL_FONT_HEADER)); //font_header                        
            printDesign.setSizeFontHeader(pstPrintDesign.getInt(COL_SIZE_FONT_HEADER)); //size_font_header
            printDesign.setFontDataMain(pstPrintDesign.getString(COL_FONT_DATA_MAIN)); //font_data_main
            printDesign.setSizeFontDataMain(pstPrintDesign.getInt(COL_SIZE_FONT_DATA_MAIN)); //size_font_data_main                        
            printDesign.setFontDataMain(pstPrintDesign.getString(COL_FONT_DATA_MAIN)); //width_table_data_main
            printDesign.setHeightTableDataMain(pstPrintDesign.getInt(COL_HEIGHT_TABLE_DATA_MAIN)); //heigt_table_data_main                        
            printDesign.setBorderTitleColumn(pstPrintDesign.getInt(COL_BORDER_TITLE_COLUMN)); //border_title_column                        
            printDesign.setFontTitleColumn(pstPrintDesign.getString(COL_FONT_TITLE_COLUMN)); //font_title_column
            printDesign.setSizeFontTitleColumn(pstPrintDesign.getInt(COL_SIZE_FONT_TITLE_COLUMN)); //size_font_title_column                        
            printDesign.setBorderDataDetail(pstPrintDesign.getInt(COL_BORDER_DATA_DETAIL)); //border_data_detail                        
            printDesign.setFontDataDetail(pstPrintDesign.getString(COL_FONT_DATA_DETAIL)); //font_data_detail                           
            printDesign.setSizeFontDataDetail(pstPrintDesign.getInt(COL_SIZE_FONT_DATA_DETAIL)); //size_font_data_detail                        
            printDesign.setBorderDataTotal(pstPrintDesign.getInt(COL_BORDER_DATA_TOTAL)); //border_data_total                        
            printDesign.setFontDataTotal(pstPrintDesign.getString(COL_FONT_DATA_TOTAL)); //font_data_total                          
            printDesign.setSizeFontDataTotal(pstPrintDesign.getInt(COL_SIZE_FONT_DATA_TOTAL)); //size_font_data_total
            printDesign.setBorderDataApproval(pstPrintDesign.getInt(COL_BORDER_DATA_APPROVAL)); //border_data_approval                        
            printDesign.setFontDataApproval(pstPrintDesign.getString(COL_FONT_DATA_APPROVAL)); //font_data_approval                           
            printDesign.setSizeFontDataApproval(pstPrintDesign.getInt(COL_SIZE_FONT_DATA_APPROVAL)); //size_font_data_approval                        
            printDesign.setBorderDataFooter(pstPrintDesign.getInt(COL_BORDER_DATA_FOOTER)); //border_data_footer                        
            printDesign.setFontDataFooter(pstPrintDesign.getString(COL_FONT_DATA_FOOTER)); //font_data_footer                        
            printDesign.setSizeFontDataFooter(pstPrintDesign.getInt(COL_SIZE_FONT_DATA_FOOTER)); //size_font_data_footer                        

            return printDesign;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPrintDesign(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PrintDesign printDesign) throws CONException {
        try {

            DbPrintDesign pstPrintDesign = new DbPrintDesign(0);

            pstPrintDesign.setString(COL_NAME_DOCUMENT, printDesign.getNameDocument());  //"name_document",
            pstPrintDesign.setInt(COL_WIDTH_PRINT, printDesign.getWidthPrint());  //"width_print",
            pstPrintDesign.setInt(COL_HEIGHT_PRINT, printDesign.getHeightPrint());  //"height_print",     
            pstPrintDesign.setString(COL_FONT_HEADER, printDesign.getFontHeader());  //"font_header",
            pstPrintDesign.setInt(COL_SIZE_FONT_HEADER, printDesign.getSizeFontHeader());  //"size_font_header",                
            pstPrintDesign.setString(COL_FONT_DATA_MAIN, printDesign.getFontDataMain());  //"font_data_main",
            pstPrintDesign.setInt(COL_SIZE_FONT_DATA_MAIN, printDesign.getSizeFontDataMain());  //"size_font_data_main",                
            pstPrintDesign.setInt(COL_WIDTH_TABLE_DATA_MAIN, printDesign.getWidthTableDataMain());  //"width_table_data_main",
            pstPrintDesign.setInt(COL_HEIGHT_TABLE_DATA_MAIN, printDesign.getHeightTableDataMain());  // "heigt_table_data_main",   
            pstPrintDesign.setInt(COL_BORDER_TITLE_COLUMN, printDesign.getBorderTitleColumn());  //"border_title_column",
            pstPrintDesign.setString(COL_FONT_TITLE_COLUMN, printDesign.getFontTitleColumn());  //"font_title_column",
            pstPrintDesign.setInt(COL_SIZE_FONT_TITLE_COLUMN, printDesign.getSizeFontTitleColumn());  //"size_font_title_column",                
            pstPrintDesign.setInt(COL_BORDER_DATA_DETAIL, printDesign.getBorderDataDetail());  //"border_data_detail",                
            pstPrintDesign.setString(COL_FONT_DATA_DETAIL, printDesign.getFontDataDetail());  //"font_data_detail",
            pstPrintDesign.setInt(COL_SIZE_FONT_DATA_DETAIL, printDesign.getSizeFontDataDetail());  //"size_font_data_detail",                
            pstPrintDesign.setInt(COL_BORDER_DATA_TOTAL, printDesign.getBorderDataTotal());   //"border_data_total",
            pstPrintDesign.setString(COL_FONT_DATA_TOTAL, printDesign.getFontDataTotal());   //"font_data_total",                
            pstPrintDesign.setInt(COL_SIZE_FONT_DATA_TOTAL, printDesign.getSizeFontDataTotal());   //"size_font_data_total",                
            pstPrintDesign.setInt(COL_BORDER_DATA_APPROVAL, printDesign.getBorderDataApproval());   //"border_data_approval",
            pstPrintDesign.setString(COL_FONT_DATA_APPROVAL, printDesign.getFontDataApproval());   //"font_data_approval",
            pstPrintDesign.setInt(COL_SIZE_FONT_DATA_APPROVAL, printDesign.getSizeFontDataApproval());  //"size_font_data_approval",                
            pstPrintDesign.setInt(COL_BORDER_DATA_FOOTER, printDesign.getBorderDataFooter());   //"border_data_footer",
            pstPrintDesign.setString(COL_FONT_DATA_FOOTER, printDesign.getFontDataFooter());   //"font_data_footer",
            pstPrintDesign.setInt(COL_SIZE_FONT_DATA_FOOTER, printDesign.getSizeFontDataFooter());   //"size_font_data_footer"      

            pstPrintDesign.insert();
            printDesign.setOID(pstPrintDesign.getlong(COL_PRINT_DESIGN_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPrintDesign(0), CONException.UNKNOWN);
        }
        return printDesign.getOID();
    }

    public static long updateExc(PrintDesign printDesign) throws CONException {
        try {
            if (printDesign.getOID() != 0) {

                DbPrintDesign pstPrintDesign = new DbPrintDesign(printDesign.getOID());

                pstPrintDesign.setString(COL_NAME_DOCUMENT, printDesign.getNameDocument());  //"name_document",
                pstPrintDesign.setInt(COL_WIDTH_PRINT, printDesign.getWidthPrint());  //"width_print",
                pstPrintDesign.setInt(COL_HEIGHT_PRINT, printDesign.getHeightPrint());  //"height_print",     
                pstPrintDesign.setString(COL_FONT_HEADER, printDesign.getFontHeader());  //"font_header",
                pstPrintDesign.setInt(COL_SIZE_FONT_HEADER, printDesign.getSizeFontHeader());  //"size_font_header",                
                pstPrintDesign.setString(COL_FONT_DATA_MAIN, printDesign.getFontDataMain());  //"font_data_main",
                pstPrintDesign.setInt(COL_SIZE_FONT_DATA_MAIN, printDesign.getSizeFontDataMain());  //"size_font_data_main",                
                pstPrintDesign.setInt(COL_WIDTH_TABLE_DATA_MAIN, printDesign.getWidthTableDataMain());  //"width_table_data_main",
                pstPrintDesign.setInt(COL_HEIGHT_TABLE_DATA_MAIN, printDesign.getHeightTableDataMain());  // "heigt_table_data_main",   
                pstPrintDesign.setInt(COL_BORDER_TITLE_COLUMN, printDesign.getBorderTitleColumn());  //"border_title_column",
                pstPrintDesign.setString(COL_FONT_TITLE_COLUMN, printDesign.getFontTitleColumn());  //"font_title_column",
                pstPrintDesign.setInt(COL_SIZE_FONT_TITLE_COLUMN, printDesign.getSizeFontTitleColumn());  //"size_font_title_column",                
                pstPrintDesign.setInt(COL_BORDER_DATA_DETAIL, printDesign.getBorderDataDetail());  //"border_data_detail",                
                pstPrintDesign.setString(COL_FONT_DATA_DETAIL, printDesign.getFontDataDetail());  //"font_data_detail",
                pstPrintDesign.setInt(COL_SIZE_FONT_DATA_DETAIL, printDesign.getSizeFontDataDetail());  //"size_font_data_detail",                
                pstPrintDesign.setInt(COL_BORDER_DATA_TOTAL, printDesign.getBorderDataTotal());   //"border_data_total",
                pstPrintDesign.setString(COL_FONT_DATA_TOTAL, printDesign.getFontDataTotal());   //"font_data_total",                
                pstPrintDesign.setInt(COL_SIZE_FONT_DATA_TOTAL, printDesign.getSizeFontDataTotal());   //"size_font_data_total",                
                pstPrintDesign.setInt(COL_BORDER_DATA_APPROVAL, printDesign.getBorderDataApproval());   //"border_data_approval",
                pstPrintDesign.setString(COL_FONT_DATA_APPROVAL, printDesign.getFontDataApproval());   //"font_data_approval",
                pstPrintDesign.setInt(COL_SIZE_FONT_DATA_APPROVAL, printDesign.getSizeFontDataApproval());  //"size_font_data_approval",                
                pstPrintDesign.setInt(COL_BORDER_DATA_FOOTER, printDesign.getBorderDataFooter());   //"border_data_footer",
                pstPrintDesign.setString(COL_FONT_DATA_FOOTER, printDesign.getFontDataFooter());   //"font_data_footer",
                pstPrintDesign.setInt(COL_SIZE_FONT_DATA_FOOTER, printDesign.getSizeFontDataFooter());   //"size_font_data_footer"    

                pstPrintDesign.update();
                return printDesign.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPrintDesign(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPrintDesign DbPrintDesign = new DbPrintDesign(oid);
            DbPrintDesign.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPrintDesign(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_PRINT_DESIGN;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PrintDesign printDesign = new PrintDesign();
                resultToObject(rs, printDesign);
                lists.add(printDesign);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, PrintDesign printDesign) {
        try {

            printDesign.setOID(rs.getLong(DbPrintDesign.colNames[DbPrintDesign.COL_PRINT_DESIGN_ID])); //"print_design_id",
            printDesign.setNameDocument(rs.getString(DbPrintDesign.colNames[DbPrintDesign.COL_NAME_DOCUMENT])); //"name_document",
            printDesign.setWidthPrint(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_WIDTH_PRINT])); //"width_print",
            printDesign.setHeightPrint(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_HEIGHT_PRINT]));  //"height_print",     
            printDesign.setFontHeader(rs.getString(DbPrintDesign.colNames[DbPrintDesign.COL_FONT_HEADER])); //"font_header",
            printDesign.setSizeFontHeader(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_SIZE_FONT_HEADER])); //"size_font_header",                
            printDesign.setFontDataMain(rs.getString(DbPrintDesign.colNames[DbPrintDesign.COL_FONT_DATA_MAIN])); //"font_data_main",
            printDesign.setSizeFontDataMain(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_SIZE_FONT_DATA_MAIN])); //"size_font_data_main",                
            printDesign.setWidthTableDataMain(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_WIDTH_TABLE_DATA_MAIN])); //"width_table_data_main",
            printDesign.setHeightTableDataMain(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_HEIGHT_TABLE_DATA_MAIN])); //"heigt_table_data_main",   
            printDesign.setBorderTitleColumn(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_BORDER_TITLE_COLUMN])); //"border_title_column",
            printDesign.setFontTitleColumn(rs.getString(DbPrintDesign.colNames[DbPrintDesign.COL_FONT_TITLE_COLUMN])); //"font_title_column",
            printDesign.setSizeFontTitleColumn(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_SIZE_FONT_TITLE_COLUMN])); //"size_font_title_column",                
            printDesign.setBorderDataDetail(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_BORDER_DATA_DETAIL])); //"border_data_detail",                
            printDesign.setFontDataDetail(rs.getString(DbPrintDesign.colNames[DbPrintDesign.COL_FONT_DATA_DETAIL])); //"font_data_detail",
            printDesign.setSizeFontDataDetail(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_SIZE_FONT_DATA_DETAIL])); //"size_font_data_detail",                
            printDesign.setBorderDataTotal(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_BORDER_DATA_TOTAL])); //"border_data_total",
            printDesign.setFontDataTotal(rs.getString(DbPrintDesign.colNames[DbPrintDesign.COL_FONT_DATA_TOTAL])); //"font_data_total",                
            printDesign.setSizeFontDataTotal(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_SIZE_FONT_DATA_TOTAL])); //"size_font_data_total",                
            printDesign.setBorderDataApproval(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_BORDER_DATA_APPROVAL])); //"border_data_approval",
            printDesign.setFontDataApproval(rs.getString(DbPrintDesign.colNames[DbPrintDesign.COL_FONT_DATA_APPROVAL])); //"font_data_approval",
            printDesign.setSizeFontDataApproval(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_SIZE_FONT_DATA_APPROVAL])); //"size_font_data_approval",                
            printDesign.setBorderDataFooter(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_BORDER_DATA_FOOTER])); //"border_data_footer",
            printDesign.setFontDataFooter(rs.getString(DbPrintDesign.colNames[DbPrintDesign.COL_FONT_DATA_FOOTER])); //"font_data_footer",
            printDesign.setSizeFontDataFooter(rs.getInt(DbPrintDesign.colNames[DbPrintDesign.COL_SIZE_FONT_DATA_FOOTER]));  //"size_font_data_footer"       

        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long printDesignId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PRINT_DESIGN + " WHERE " + 
						DbPrintDesign.colNames[DbPrintDesign.COL_PRINT_DESIGN_ID] + " = " + printDesignId;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbPrintDesign.colNames[DbPrintDesign.COL_PRINT_DESIGN_ID] + ") FROM " + DB_PRINT_DESIGN;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}


	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause){
		String order = "";
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, order); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   PrintDesign printDesign = (PrintDesign)list.get(ls);
				   if(oid == printDesign.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static PrintDesign getDesign(String typeDesign){
            
            CONResultSet dbrs = null;
            
            try{
                
                String sql = "SELECT * FROM "+DbPrintDesign.DB_PRINT_DESIGN+" WHERE "+DbPrintDesign.colNames[DbPrintDesign.COL_NAME_DOCUMENT]+" = '"+
                        typeDesign+"'";
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
                while (rs.next()) {
                    PrintDesign printDesign = new PrintDesign();
                    resultToObject(rs, printDesign);
                    return printDesign;
                }
                
                rs.close();
                
            } catch (Exception e) {
                System.out.println(e);
            } finally {
                CONResultSet.close(dbrs);
            }
            
            return new PrintDesign();
            
        }
        
        
}
