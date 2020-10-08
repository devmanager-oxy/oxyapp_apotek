/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.general.*;
import com.project.util.JSPFormater;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class DbPriceTypeChange extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language{
    
    
    public static final String DB_PRICE_TYPE_CHANGE = "pos_price_type_change";
    
    public static final int COL_PRICE_TYPE_CHANGE_ID    = 0;
    public static final int COL_ITEM_MASTER_ID          = 1;
    public static final int COL_QTY_FROM                = 2;
    public static final int COL_QTY_TO                  = 3;
    public static final int COL_GOL_1                   = 4;
    public static final int COL_GOL_2                   = 5;
    public static final int COL_GOL_3                   = 6;
    public static final int COL_GOL_4                   = 7;
    public static final int COL_GOL_5                   = 8;
    public static final int COL_GOL1_MARGIN             = 9;
    public static final int COL_GOL2_MARGIN             = 10;
    public static final int COL_GOL3_MARGIN             = 11;
    public static final int COL_GOL4_MARGIN             = 12;
    public static final int COL_GOL5_MARGIN             = 13;
    public static final int COL_CHANGE_DATE             = 14;
    public static final int COL_GOL_6                   = 15;
    public static final int COL_GOL_7                   = 16;
    public static final int COL_GOL_8                   = 17;
    public static final int COL_GOL_9                   = 18;
    public static final int COL_GOL_10                  = 19;
    public static final int COL_GOL6_MARGIN             = 20;
    public static final int COL_GOL7_MARGIN             = 21;
    public static final int COL_GOL8_MARGIN             = 22;
    public static final int COL_GOL9_MARGIN             = 23;
    public static final int COL_GOL10_MARGIN            = 24;    
    public static final int COL_USER_ID                 = 25;
    public static final int COL_DATE                    = 26;
    public static final int COL_ACTIVE_DATE             = 27;
    public static final int COL_STATUS                  = 28;
    public static final int COL_PRICE_TYPE_ID           = 29;    
    public static final int COL_GOL_1_ORI           = 30;
    public static final int COL_GOL_2_ORI           = 31;
    public static final int COL_GOL_3_ORI           = 32;
    public static final int COL_GOL_4_ORI           = 33;
    public static final int COL_GOL_5_ORI           = 34;
    public static final int COL_GOL_6_ORI           = 35;
    public static final int COL_GOL_7_ORI           = 36;
    public static final int COL_GOL_8_ORI           = 37;
    public static final int COL_GOL_9_ORI           = 38;
    public static final int COL_GOL_10_ORI          = 39;
    public static final int COL_REF_NUMBER          = 40;    
    public static final int COL_VENDOR_ID           = 41;
    public static final int COL_TYPE                = 42;    
    public static final int COL_GOL1_MARGIN_ORI           = 43;
    public static final int COL_GOL2_MARGIN_ORI           = 44;
    public static final int COL_GOL3_MARGIN_ORI           = 45;
    public static final int COL_GOL4_MARGIN_ORI           = 46;
    public static final int COL_GOL5_MARGIN_ORI           = 47;
    public static final int COL_GOL6_MARGIN_ORI           = 48;
    public static final int COL_GOL7_MARGIN_ORI           = 49;
    public static final int COL_GOL8_MARGIN_ORI           = 50;
    public static final int COL_GOL9_MARGIN_ORI           = 51;
    public static final int COL_GOL10_MARGIN_ORI          = 52;
    public static final int COL_PREFIX_NUMBER          = 53;
    public static final int COL_COUNTER          = 54;
    
    public static final String[] colNames = {
        "price_type_change_id",
        "item_master_id",
        "qty_from",
        "qty_to",
        "gol_1",
        "gol_2",
        "gol_3",
        "gol_4",
        "gol_5",
        "gol1_margin",
        "gol2_margin",
        "gol3_margin",
        "gol4_margin",
        "gol5_margin",
        "change_date",
        "gol_6",
        "gol_7",
        "gol_8",
        "gol_9",
        "gol_10",
        "gol6_margin",
        "gol7_margin",
        "gol8_margin",
        "gol9_margin",
        "gol10_margin",        
        "user_id",
        "date",
        "active_date",
        "status",
        "price_type_id",        
        "gol_1_ori",
        "gol_2_ori",
        "gol_3_ori",
        "gol_4_ori",
        "gol_5_ori",
        "gol_6_ori",
        "gol_7_ori",
        "gol_8_ori",
        "gol_9_ori",
        "gol_10_ori",
        "ref_number",
        "vendor_id",
        "type",        
        "gol1_margin_ori",
        "gol2_margin_ori",
        "gol3_margin_ori",
        "gol4_margin_ori",
        "gol5_margin_ori",
        "gol6_margin_ori",
        "gol7_margin_ori",
        "gol8_margin_ori",
        "gol9_margin_ori",
        "gol10_margin_ori",
        "prefix_number",
        "counter"
        
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
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
        TYPE_DATE,
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
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,        
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
        TYPE_STRING,
        TYPE_LONG, 
        TYPE_INT,        
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
        TYPE_STRING,
        TYPE_INT
        
    };    
    
    public static final String gol_1="gol_1";
    public static final String gol_2="gol_2";
    public static final String gol_3="gol_3";
    public static final String gol_4="gol_4";
    public static final String gol_5="gol_5";
    public static final String gol_6="gol_6";
    public static final String gol_7="gol_7";
    public static final String gol_8="gol_8";
    public static final String gol_9="gol_9";
    public static final String gol_10="gol_10";
    
    public DbPriceTypeChange() {
    }

    public DbPriceTypeChange(int i) throws CONException {
        super(new DbPriceTypeChange());
    }

    public DbPriceTypeChange(String sOid) throws CONException {
        super(new DbPriceTypeChange(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPriceTypeChange(long lOid) throws CONException {
        super(new DbPriceTypeChange(0));
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
        return DB_PRICE_TYPE_CHANGE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPriceTypeChange().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PriceTypeChange priceTypeChange = fetchExc(ent.getOID());
        ent = (Entity) priceTypeChange;
        return priceTypeChange.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PriceTypeChange) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PriceTypeChange) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PriceTypeChange fetchExc(long oid) throws CONException {
        
        try {
            
            PriceTypeChange priceTypeChange = new PriceTypeChange();
            
            DbPriceTypeChange pstPriceTypeChange = new DbPriceTypeChange(oid);
            
            priceTypeChange.setOID(oid);
            priceTypeChange.setItemMasterId(pstPriceTypeChange.getlong(COL_ITEM_MASTER_ID));            
            priceTypeChange.setQtyFrom(pstPriceTypeChange.getInt(COL_QTY_FROM));
            priceTypeChange.setQtyTo(pstPriceTypeChange.getInt(COL_QTY_TO));
            priceTypeChange.setGol1(pstPriceTypeChange.getdouble(COL_GOL_1));
            priceTypeChange.setGol2(pstPriceTypeChange.getdouble(COL_GOL_2));
            priceTypeChange.setGol3(pstPriceTypeChange.getdouble(COL_GOL_3));
            priceTypeChange.setGol4(pstPriceTypeChange.getdouble(COL_GOL_4));
            priceTypeChange.setGol5(pstPriceTypeChange.getdouble(COL_GOL_5));
            priceTypeChange.setGol1_margin(pstPriceTypeChange.getdouble(COL_GOL1_MARGIN));
            priceTypeChange.setGol2_margin(pstPriceTypeChange.getdouble(COL_GOL2_MARGIN));
            priceTypeChange.setGol3_margin(pstPriceTypeChange.getdouble(COL_GOL3_MARGIN));
            priceTypeChange.setGol4_margin(pstPriceTypeChange.getdouble(COL_GOL4_MARGIN));
            priceTypeChange.setGol5_margin(pstPriceTypeChange.getdouble(COL_GOL5_MARGIN));
            priceTypeChange.setChangeDate(pstPriceTypeChange.getDate(COL_CHANGE_DATE));
            priceTypeChange.setGol6(pstPriceTypeChange.getdouble(COL_GOL_6));
            priceTypeChange.setGol7(pstPriceTypeChange.getdouble(COL_GOL_7));
            priceTypeChange.setGol8(pstPriceTypeChange.getdouble(COL_GOL_8));
            priceTypeChange.setGol9(pstPriceTypeChange.getdouble(COL_GOL_9));
            priceTypeChange.setGol10(pstPriceTypeChange.getdouble(COL_GOL_10));
            priceTypeChange.setGol6_margin(pstPriceTypeChange.getdouble(COL_GOL6_MARGIN));
            priceTypeChange.setGol7_margin(pstPriceTypeChange.getdouble(COL_GOL7_MARGIN));
            priceTypeChange.setGol8_margin(pstPriceTypeChange.getdouble(COL_GOL8_MARGIN));
            priceTypeChange.setGol9_margin(pstPriceTypeChange.getdouble(COL_GOL9_MARGIN));
            priceTypeChange.setGol10_margin(pstPriceTypeChange.getdouble(COL_GOL10_MARGIN));            
            priceTypeChange.setUserId(pstPriceTypeChange.getlong(COL_USER_ID));
            priceTypeChange.setDate(pstPriceTypeChange.getDate(COL_DATE));
            priceTypeChange.setActiveDate(pstPriceTypeChange.getDate(COL_ACTIVE_DATE));
            priceTypeChange.setStatus(pstPriceTypeChange.getInt(COL_STATUS));
            priceTypeChange.setPriceTypeId(pstPriceTypeChange.getlong(COL_PRICE_TYPE_ID));            
            priceTypeChange.setGol1ori(pstPriceTypeChange.getdouble(COL_GOL_1_ORI));
            priceTypeChange.setGol2ori(pstPriceTypeChange.getdouble(COL_GOL_2_ORI));
            priceTypeChange.setGol3ori(pstPriceTypeChange.getdouble(COL_GOL_3_ORI));
            priceTypeChange.setGol4ori(pstPriceTypeChange.getdouble(COL_GOL_4_ORI));
            priceTypeChange.setGol5ori(pstPriceTypeChange.getdouble(COL_GOL_5_ORI));
            priceTypeChange.setGol6ori(pstPriceTypeChange.getdouble(COL_GOL_6_ORI));
            priceTypeChange.setGol7ori(pstPriceTypeChange.getdouble(COL_GOL_7_ORI));
            priceTypeChange.setGol8ori(pstPriceTypeChange.getdouble(COL_GOL_8_ORI));
            priceTypeChange.setGol9ori(pstPriceTypeChange.getdouble(COL_GOL_9_ORI));
            priceTypeChange.setGol10ori(pstPriceTypeChange.getdouble(COL_GOL_10_ORI));
            priceTypeChange.setRefNumber(pstPriceTypeChange.getString(COL_REF_NUMBER));
            priceTypeChange.setVendorId(pstPriceTypeChange.getLong(COL_VENDOR_ID));
            priceTypeChange.setType(pstPriceTypeChange.getInt(COL_TYPE));            
            priceTypeChange.setGol1_marginOri(pstPriceTypeChange.getdouble(COL_GOL1_MARGIN_ORI));
            priceTypeChange.setGol2_marginOri(pstPriceTypeChange.getdouble(COL_GOL2_MARGIN_ORI));
            priceTypeChange.setGol3_marginOri(pstPriceTypeChange.getdouble(COL_GOL3_MARGIN_ORI));
            priceTypeChange.setGol4_marginOri(pstPriceTypeChange.getdouble(COL_GOL4_MARGIN_ORI));
            priceTypeChange.setGol5_marginOri(pstPriceTypeChange.getdouble(COL_GOL5_MARGIN_ORI));
            priceTypeChange.setGol6_marginOri(pstPriceTypeChange.getdouble(COL_GOL6_MARGIN_ORI));
            priceTypeChange.setGol7_marginOri(pstPriceTypeChange.getdouble(COL_GOL7_MARGIN_ORI));
            priceTypeChange.setGol8_marginOri(pstPriceTypeChange.getdouble(COL_GOL8_MARGIN_ORI));
            priceTypeChange.setGol9_marginOri(pstPriceTypeChange.getdouble(COL_GOL9_MARGIN_ORI));
            priceTypeChange.setGol10_marginOri(pstPriceTypeChange.getdouble(COL_GOL10_MARGIN_ORI));
            priceTypeChange.setPrefixNumber(pstPriceTypeChange.getString(COL_PREFIX_NUMBER));
            priceTypeChange.setCounter(pstPriceTypeChange.getInt(COL_COUNTER));
            
            return priceTypeChange;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPriceTypeChange(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PriceTypeChange priceTypeChange) throws CONException {
        
        try {

            DbPriceTypeChange pstPriceTypeChange = new DbPriceTypeChange(0);
            
            pstPriceTypeChange.setLong(COL_ITEM_MASTER_ID, priceTypeChange.getItemMasterId());
            pstPriceTypeChange.setInt(COL_QTY_FROM, priceTypeChange.getQtyFrom());
            pstPriceTypeChange.setInt(COL_QTY_TO, priceTypeChange.getQtyTo());
            pstPriceTypeChange.setDouble(COL_GOL_1, priceTypeChange.getGol1());
            pstPriceTypeChange.setDouble(COL_GOL_2, priceTypeChange.getGol2());
            pstPriceTypeChange.setDouble(COL_GOL_3, priceTypeChange.getGol3());
            pstPriceTypeChange.setDouble(COL_GOL_4, priceTypeChange.getGol4());
            pstPriceTypeChange.setDouble(COL_GOL_5, priceTypeChange.getGol5());
            pstPriceTypeChange.setDouble(COL_GOL1_MARGIN, priceTypeChange.getGol1_margin());
            pstPriceTypeChange.setDouble(COL_GOL2_MARGIN, priceTypeChange.getGol2_margin());
            pstPriceTypeChange.setDouble(COL_GOL3_MARGIN, priceTypeChange.getGol3_margin());
            pstPriceTypeChange.setDouble(COL_GOL4_MARGIN, priceTypeChange.getGol4_margin());
            pstPriceTypeChange.setDouble(COL_GOL5_MARGIN, priceTypeChange.getGol5_margin());
            pstPriceTypeChange.setDate(COL_CHANGE_DATE, priceTypeChange.getChangeDate());
            pstPriceTypeChange.setDouble(COL_GOL_6, priceTypeChange.getGol6());
            pstPriceTypeChange.setDouble(COL_GOL_7, priceTypeChange.getGol7());
            pstPriceTypeChange.setDouble(COL_GOL_8, priceTypeChange.getGol8());
            pstPriceTypeChange.setDouble(COL_GOL_9, priceTypeChange.getGol9());
            pstPriceTypeChange.setDouble(COL_GOL_10, priceTypeChange.getGol10());
            pstPriceTypeChange.setDouble(COL_GOL6_MARGIN, priceTypeChange.getGol6_margin());
            pstPriceTypeChange.setDouble(COL_GOL7_MARGIN, priceTypeChange.getGol7_margin());
            pstPriceTypeChange.setDouble(COL_GOL8_MARGIN, priceTypeChange.getGol8_margin());
            pstPriceTypeChange.setDouble(COL_GOL9_MARGIN, priceTypeChange.getGol9_margin());
            pstPriceTypeChange.setDouble(COL_GOL10_MARGIN, priceTypeChange.getGol10_margin());
            
            pstPriceTypeChange.setLong(COL_USER_ID, priceTypeChange.getUserId());
            pstPriceTypeChange.setDate(COL_DATE, priceTypeChange.getDate());
            pstPriceTypeChange.setDate(COL_ACTIVE_DATE, priceTypeChange.getActiveDate());
            pstPriceTypeChange.setInt(COL_STATUS, priceTypeChange.getStatus());
            pstPriceTypeChange.setLong(COL_PRICE_TYPE_ID, priceTypeChange.getPriceTypeId());            
            
            pstPriceTypeChange.setDouble(COL_GOL_1_ORI, priceTypeChange.getGol1ori());
            pstPriceTypeChange.setDouble(COL_GOL_2_ORI, priceTypeChange.getGol2ori());
            pstPriceTypeChange.setDouble(COL_GOL_3_ORI, priceTypeChange.getGol3ori());
            pstPriceTypeChange.setDouble(COL_GOL_4_ORI, priceTypeChange.getGol4ori());
            pstPriceTypeChange.setDouble(COL_GOL_5_ORI, priceTypeChange.getGol5ori());
            pstPriceTypeChange.setDouble(COL_GOL_6_ORI, priceTypeChange.getGol6ori());
            pstPriceTypeChange.setDouble(COL_GOL_7_ORI, priceTypeChange.getGol7ori());
            pstPriceTypeChange.setDouble(COL_GOL_8_ORI, priceTypeChange.getGol8ori());
            pstPriceTypeChange.setDouble(COL_GOL_9_ORI, priceTypeChange.getGol9ori());
            pstPriceTypeChange.setDouble(COL_GOL_10_ORI, priceTypeChange.getGol10ori());
            pstPriceTypeChange.setString(COL_REF_NUMBER, priceTypeChange.getRefNumber());
            pstPriceTypeChange.setLong(COL_VENDOR_ID, priceTypeChange.getVendorId());
            pstPriceTypeChange.setInt(COL_TYPE, priceTypeChange.getType());
            
            pstPriceTypeChange.setDouble(COL_GOL1_MARGIN_ORI, priceTypeChange.getGol1_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL2_MARGIN_ORI, priceTypeChange.getGol2_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL3_MARGIN_ORI, priceTypeChange.getGol3_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL4_MARGIN_ORI, priceTypeChange.getGol4_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL5_MARGIN_ORI, priceTypeChange.getGol5_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL6_MARGIN_ORI, priceTypeChange.getGol6_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL7_MARGIN_ORI, priceTypeChange.getGol7_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL8_MARGIN_ORI, priceTypeChange.getGol8_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL9_MARGIN_ORI, priceTypeChange.getGol9_marginOri());
            pstPriceTypeChange.setDouble(COL_GOL10_MARGIN_ORI, priceTypeChange.getGol10_marginOri());
            pstPriceTypeChange.setString(COL_PREFIX_NUMBER, priceTypeChange.getPrefixNumber());
            pstPriceTypeChange.setInt(COL_COUNTER, priceTypeChange.getCounter());
            pstPriceTypeChange.insert();
            
            priceTypeChange.setOID(pstPriceTypeChange.getlong(COL_PRICE_TYPE_CHANGE_ID));


        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPriceTypeChange(0), CONException.UNKNOWN);
        }
        return priceTypeChange.getOID();
    }

    public static long updateExc(PriceTypeChange priceTypeChange) throws CONException {
        try {
            
            if (priceTypeChange.getOID() != 0) {

                DbPriceTypeChange pstPriceTypeChange = new DbPriceTypeChange(priceTypeChange.getOID());
                
                pstPriceTypeChange.setLong(COL_ITEM_MASTER_ID, priceTypeChange.getItemMasterId());
                pstPriceTypeChange.setInt(COL_QTY_FROM, priceTypeChange.getQtyFrom());
                pstPriceTypeChange.setInt(COL_QTY_TO, priceTypeChange.getQtyTo());
                pstPriceTypeChange.setDouble(COL_GOL_1, priceTypeChange.getGol1());
                pstPriceTypeChange.setDouble(COL_GOL_2, priceTypeChange.getGol2());
                pstPriceTypeChange.setDouble(COL_GOL_3, priceTypeChange.getGol3());
                pstPriceTypeChange.setDouble(COL_GOL_4, priceTypeChange.getGol4());
                pstPriceTypeChange.setDouble(COL_GOL_5, priceTypeChange.getGol5());
                pstPriceTypeChange.setDouble(COL_GOL1_MARGIN, priceTypeChange.getGol1_margin());
                pstPriceTypeChange.setDouble(COL_GOL2_MARGIN, priceTypeChange.getGol2_margin());
                pstPriceTypeChange.setDouble(COL_GOL3_MARGIN, priceTypeChange.getGol3_margin());
                pstPriceTypeChange.setDouble(COL_GOL4_MARGIN, priceTypeChange.getGol4_margin());
                pstPriceTypeChange.setDouble(COL_GOL5_MARGIN, priceTypeChange.getGol5_margin());
                pstPriceTypeChange.setDate(COL_CHANGE_DATE, priceTypeChange.getChangeDate());
                pstPriceTypeChange.setDouble(COL_GOL_6, priceTypeChange.getGol6());
                pstPriceTypeChange.setDouble(COL_GOL_7, priceTypeChange.getGol7());
                pstPriceTypeChange.setDouble(COL_GOL_8, priceTypeChange.getGol8());
                pstPriceTypeChange.setDouble(COL_GOL_9, priceTypeChange.getGol9());
                pstPriceTypeChange.setDouble(COL_GOL_10, priceTypeChange.getGol10());
                pstPriceTypeChange.setDouble(COL_GOL6_MARGIN, priceTypeChange.getGol6_margin());
                pstPriceTypeChange.setDouble(COL_GOL7_MARGIN, priceTypeChange.getGol7_margin());
                pstPriceTypeChange.setDouble(COL_GOL8_MARGIN, priceTypeChange.getGol8_margin());
                pstPriceTypeChange.setDouble(COL_GOL9_MARGIN, priceTypeChange.getGol9_margin());
                pstPriceTypeChange.setDouble(COL_GOL10_MARGIN, priceTypeChange.getGol10_margin());
                
                pstPriceTypeChange.setLong(COL_USER_ID, priceTypeChange.getUserId());
                pstPriceTypeChange.setDate(COL_DATE, priceTypeChange.getDate());
                pstPriceTypeChange.setDate(COL_ACTIVE_DATE, priceTypeChange.getActiveDate());
                pstPriceTypeChange.setInt(COL_STATUS, priceTypeChange.getStatus());
                pstPriceTypeChange.setLong(COL_PRICE_TYPE_ID, priceTypeChange.getPriceTypeId());  
                
                pstPriceTypeChange.setDouble(COL_GOL_1_ORI, priceTypeChange.getGol1ori());
                pstPriceTypeChange.setDouble(COL_GOL_2_ORI, priceTypeChange.getGol2ori());
                pstPriceTypeChange.setDouble(COL_GOL_3_ORI, priceTypeChange.getGol3ori());
                pstPriceTypeChange.setDouble(COL_GOL_4_ORI, priceTypeChange.getGol4ori());
                pstPriceTypeChange.setDouble(COL_GOL_5_ORI, priceTypeChange.getGol5ori());
                pstPriceTypeChange.setDouble(COL_GOL_6_ORI, priceTypeChange.getGol6ori());
                pstPriceTypeChange.setDouble(COL_GOL_7_ORI, priceTypeChange.getGol7ori());
                pstPriceTypeChange.setDouble(COL_GOL_8_ORI, priceTypeChange.getGol8ori());
                pstPriceTypeChange.setDouble(COL_GOL_9_ORI, priceTypeChange.getGol9ori());
                pstPriceTypeChange.setDouble(COL_GOL_10_ORI, priceTypeChange.getGol10ori());
                pstPriceTypeChange.setString(COL_REF_NUMBER, priceTypeChange.getRefNumber());
                pstPriceTypeChange.setLong(COL_VENDOR_ID, priceTypeChange.getVendorId());
                pstPriceTypeChange.setInt(COL_TYPE, priceTypeChange.getType());
                
                pstPriceTypeChange.setDouble(COL_GOL1_MARGIN_ORI, priceTypeChange.getGol1_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL2_MARGIN_ORI, priceTypeChange.getGol2_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL3_MARGIN_ORI, priceTypeChange.getGol3_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL4_MARGIN_ORI, priceTypeChange.getGol4_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL5_MARGIN_ORI, priceTypeChange.getGol5_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL6_MARGIN_ORI, priceTypeChange.getGol6_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL7_MARGIN_ORI, priceTypeChange.getGol7_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL8_MARGIN_ORI, priceTypeChange.getGol8_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL9_MARGIN_ORI, priceTypeChange.getGol9_marginOri());
                pstPriceTypeChange.setDouble(COL_GOL10_MARGIN_ORI, priceTypeChange.getGol10_marginOri());
                pstPriceTypeChange.setString(COL_PREFIX_NUMBER, priceTypeChange.getPrefixNumber());
                pstPriceTypeChange.setInt(COL_COUNTER, priceTypeChange.getCounter());
                pstPriceTypeChange.update();
                return priceTypeChange.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPriceTypeChange(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPriceTypeChange pstItemMaster = new DbPriceTypeChange(oid);
            pstItemMaster.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPriceTypeChange(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static double getPrice(double qty, String gol, long oidItemMaster){
         CONResultSet dbrs = null;
         double price=0;
         try{
             if(qty==0){
                 qty=1;
             }
             if(gol.equalsIgnoreCase("")){
                 gol= gol_1;
             }
             String sql ="";
              if(gol.equalsIgnoreCase(gol_1)){
                    sql = "SELECT " + gol_1 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_2)){
                    sql = "SELECT " + gol_2 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_3)){
                    sql = "SELECT " + gol_3 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_4)){
                    sql = "SELECT " + gol_4 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_5)){
                    sql = "SELECT " + gol_5 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_6)){
                    sql = "SELECT " + gol_6 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;    
                }else if(gol.equalsIgnoreCase(gol_7)){
                    sql = "SELECT " + gol_7 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;    
                }else if(gol.equalsIgnoreCase(gol_8)){
                    sql = "SELECT " + gol_8 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;        
                }else if(gol.equalsIgnoreCase(gol_9)){
                    sql = "SELECT " + gol_9 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;    
                }else if(gol.equalsIgnoreCase(gol_10)){
                    sql = "SELECT " + gol_10 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;    
                }else{
                    sql = "SELECT " + gol_1 + " FROM " + DB_PRICE_TYPE_CHANGE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }
             
             dbrs = CONHandler.execQueryResult(sql);
             ResultSet rs = dbrs.getResultSet();
             
             while (rs.next()) {
                price = rs.getDouble(1);
            }
            rs.close();
         }catch(Exception e){
             
         }
         return price;
    }
    
     public static PriceTypeChange getPriceTypeChange(long oidItemMaster){
         CONResultSet dbrs = null;
         PriceTypeChange pt = new PriceTypeChange();
         
         try{
             String sql="";
                    sql = "SELECT * FROM " + DB_PRICE_TYPE_CHANGE + " where " + DbPriceTypeChange.colNames[COL_ITEM_MASTER_ID]+"=" + oidItemMaster;
            
             
             dbrs = CONHandler.execQueryResult(sql);
             ResultSet rs = dbrs.getResultSet();
             
             while (rs.next()) {
                resultToObject(rs, pt);
            }
            rs.close();
         }catch(Exception e){
             
         }
         return pt;
    }
    
    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_PRICE_TYPE_CHANGE;
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
                PriceTypeChange priceTypeChange = new PriceTypeChange();
                resultToObject(rs, priceTypeChange);
                lists.add(priceTypeChange);
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
    public static void updateSellPrice(long itemMasterId){
        try{
            ItemMaster im = DbItemMaster.fetchExc(itemMasterId);
            Company comp= new Company();
            Vector vcom = DbCompany.listAll();
            comp=(Company)vcom.get(0);
            double ppn=0;
            Vector vPricelist = DbPriceTypeChange.list(0,0, " item_master_id=" + itemMasterId, "");
            if(vPricelist.size()>0){
                for(int i=0;i<vPricelist.size();i++){
                   PriceTypeChange pt = (PriceTypeChange) vPricelist.get(i) ;
                   if(im.getIs_bkp()==1){
                        ppn=(comp.getTaxAmount()*im.getCogs())/100; 
                   }
                   
                   pt.setGol1((im.getCogs()+ppn)*(100/(100-pt.getGol1_margin())));
                   pt.setGol2((im.getCogs()+ppn)*(100/(100-pt.getGol2_margin())));
                   pt.setGol3((im.getCogs()+ppn)*(100/(100-pt.getGol3_margin())));
                   pt.setGol4((im.getCogs()+ppn)*(100/(100-pt.getGol4_margin())));
                   pt.setGol5((im.getCogs()+ppn)*(100/(100-pt.getGol5_margin())));
                   pt.setGol6((im.getCogs()+ppn)*(100/(100-pt.getGol6_margin())));
                   pt.setGol7((im.getCogs()+ppn)*(100/(100-pt.getGol7_margin())));
                   pt.setGol8((im.getCogs()+ppn)*(100/(100-pt.getGol8_margin())));
                   pt.setGol9((im.getCogs()+ppn)*(100/(100-pt.getGol9_margin())));
                   pt.setGol10((im.getCogs()+ppn)*(100/(100-pt.getGol10_margin())));
                   //pt.setGol1(((pt.getGol1_margin()*im.getCogs())/100) + im.getCogs());
                   //pt.setGol2(((pt.getGol2_margin()*im.getCogs())/100) + im.getCogs());
                   //pt.setGol3(((pt.getGol3_margin()*im.getCogs())/100) + im.getCogs());
                   //pt.setGol4(((pt.getGol4_margin()*im.getCogs())/100) + im.getCogs());
                   //pt.setGol5(((pt.getGol5_margin()*im.getCogs())/100) + im.getCogs());
                   
                   DbPriceTypeChange.updateExc(pt);
                }
            }
        }catch(Exception ex){
            
        }
    }
    public static void resultToObject(ResultSet rs, PriceTypeChange priceTypeChange) {
        try {

            priceTypeChange.setOID(rs.getLong(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_PRICE_TYPE_CHANGE_ID]));            
            priceTypeChange.setItemMasterId(rs.getLong(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_ITEM_MASTER_ID]));            
            priceTypeChange.setQtyFrom(rs.getInt(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_QTY_FROM]));
            priceTypeChange.setQtyTo(rs.getInt(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_QTY_TO]));            
            priceTypeChange.setGol1(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_1]));
            priceTypeChange.setGol2(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_2]));
            priceTypeChange.setGol3(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_3]));
            priceTypeChange.setGol4(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_4]));
            priceTypeChange.setGol5(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_5]));
            priceTypeChange.setGol1_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL1_MARGIN]));
            priceTypeChange.setGol2_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL2_MARGIN]));
            priceTypeChange.setGol3_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL3_MARGIN]));
            priceTypeChange.setGol4_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL4_MARGIN]));
            priceTypeChange.setGol5_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL5_MARGIN]));
            priceTypeChange.setGol6(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_6]));
            priceTypeChange.setGol7(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_7]));
            priceTypeChange.setGol8(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_8]));
            priceTypeChange.setGol9(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_9]));
            priceTypeChange.setGol10(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_10]));
            priceTypeChange.setGol6_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL6_MARGIN]));
            priceTypeChange.setGol7_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL7_MARGIN]));
            priceTypeChange.setGol8_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL8_MARGIN]));
            priceTypeChange.setGol9_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL9_MARGIN]));
            priceTypeChange.setGol10_margin(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL10_MARGIN]));
            priceTypeChange.setChangeDate(rs.getDate(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_CHANGE_DATE]));
            
            priceTypeChange.setUserId(rs.getLong(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_USER_ID]));
            priceTypeChange.setDate(rs.getDate(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_DATE]));
            priceTypeChange.setActiveDate(rs.getDate(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_ACTIVE_DATE]));
            priceTypeChange.setStatus(rs.getInt(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_STATUS]));
            priceTypeChange.setPriceTypeId(rs.getLong(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_PRICE_TYPE_ID]));
                        
            priceTypeChange.setGol1ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_1_ORI]));
            priceTypeChange.setGol2ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_2_ORI]));
            priceTypeChange.setGol3ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_3_ORI]));
            priceTypeChange.setGol4ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_4_ORI]));
            priceTypeChange.setGol5ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_5_ORI]));
            priceTypeChange.setGol6ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_6_ORI]));
            priceTypeChange.setGol7ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_7_ORI]));
            priceTypeChange.setGol8ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_8_ORI]));
            priceTypeChange.setGol9ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_9_ORI]));
            priceTypeChange.setGol10ori(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL_10_ORI]));
            priceTypeChange.setRefNumber(rs.getString(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_REF_NUMBER]));
            
            priceTypeChange.setVendorId(rs.getLong(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_VENDOR_ID]));
            priceTypeChange.setType(rs.getInt(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_TYPE]));
            
            priceTypeChange.setGol1_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL1_MARGIN_ORI]));
            priceTypeChange.setGol2_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL2_MARGIN_ORI]));
            priceTypeChange.setGol3_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL3_MARGIN_ORI]));
            priceTypeChange.setGol4_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL4_MARGIN_ORI]));
            priceTypeChange.setGol5_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL5_MARGIN_ORI]));
            priceTypeChange.setGol6_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL6_MARGIN_ORI]));
            priceTypeChange.setGol7_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL7_MARGIN_ORI]));
            priceTypeChange.setGol8_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL8_MARGIN_ORI]));
            priceTypeChange.setGol9_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL9_MARGIN_ORI]));
            priceTypeChange.setGol10_marginOri(rs.getDouble(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_GOL10_MARGIN_ORI]));
            priceTypeChange.setPrefixNumber(rs.getString(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_PREFIX_NUMBER]));
            priceTypeChange.setCounter(rs.getInt(DbPriceTypeChange.colNames[DbPriceTypeChange.COL_COUNTER]));
            
        } catch (Exception e){}
    }

    public static boolean checkOID(long stockCodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PRICE_TYPE_CHANGE + " WHERE " +
                    DbPriceTypeChange.colNames[DbPriceTypeChange.COL_PRICE_TYPE_CHANGE_ID] + " = " + stockCodeId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbPriceTypeChange.colNames[DbPriceTypeChange.COL_PRICE_TYPE_CHANGE_ID] + ") FROM " + DB_PRICE_TYPE_CHANGE;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e){
            return 0;
        } finally{
            CONResultSet.close(dbrs);
        }
    }

    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    PriceTypeChange priceTypeChange = (PriceTypeChange) list.get(ls);
                    if (oid == priceTypeChange.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }

        return start;
    }
    
    //Eka Ds
    //========================== operation log management ==============================================
    //insert logs for new price
    public static void insertOperationLog(long oid, long userId, String userName, PriceTypeChange priceTypeChange){

        LogOperation lo = new LogOperation();
        lo.setDate(new java.util.Date());
        lo.setOwnerId(priceTypeChange.getItemMasterId());
        lo.setUserId(userId);
        lo.setUserName(userName);
        lo.setLogDesc("Insert new price type qty from : "+priceTypeChange.getQtyFrom()+" to "+priceTypeChange.getQtyTo());

        try{
            DbLogOperation.insertExc(lo);
        }
        catch(Exception e){

        }
    }
                
    //insert logs for update item
    public static void insertOperationLog(long oid, long userId, String userName, PriceTypeChange oldPriceTypeChange, PriceTypeChange priceTypeChange){

        String logDesc = getLogDesc(oldPriceTypeChange, priceTypeChange);

        if(logDesc.length()>0){
            
            LogOperation lo = new LogOperation();
            lo.setDate(new java.util.Date());
            lo.setOwnerId(priceTypeChange.getItemMasterId());
            lo.setUserId(userId);
            lo.setUserName(userName);
            lo.setLogDesc(logDesc);

            try{
                DbLogOperation.insertExc(lo);
            }
            catch(Exception e){

            }
        }
    }
        
    public static String getLogDesc(PriceTypeChange oldPriceTypeChange, PriceTypeChange priceTypeChange){
        
        String logDesc = "";
        
        if(oldPriceTypeChange.getQtyFrom()!=priceTypeChange.getQtyFrom()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"qty from : "+oldPriceTypeChange.getQtyFrom()+" > "+priceTypeChange.getQtyFrom();                
        }
        
        if(oldPriceTypeChange.getQtyTo()!=priceTypeChange.getQtyTo()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"qty to : "+oldPriceTypeChange.getQtyTo()+" > "+priceTypeChange.getQtyTo();                
        }
        
        if(oldPriceTypeChange.getGol1()!=priceTypeChange.getGol1()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol1 to : "+oldPriceTypeChange.getGol1()+" > "+priceTypeChange.getGol1();                
        }
        
        if(oldPriceTypeChange.getGol2()!=priceTypeChange.getGol2()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol2 to : "+oldPriceTypeChange.getGol2()+" > "+priceTypeChange.getGol2();                
        }
        
        if(oldPriceTypeChange.getGol3()!=priceTypeChange.getGol3()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol3 to : "+oldPriceTypeChange.getGol3()+" > "+priceTypeChange.getGol3();                
        }
        
        if(oldPriceTypeChange.getGol4()!=priceTypeChange.getGol4()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol4 to : "+oldPriceTypeChange.getGol4()+" > "+priceTypeChange.getGol4();                
        }
        
        if(oldPriceTypeChange.getGol5()!=priceTypeChange.getGol5()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol5 to : "+oldPriceTypeChange.getGol5()+" > "+priceTypeChange.getGol5();                
        }
        
        if(oldPriceTypeChange.getGol6()!=priceTypeChange.getGol6()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol6 to : "+oldPriceTypeChange.getGol6()+" > "+priceTypeChange.getGol6();                
        }
        
        if(oldPriceTypeChange.getGol7()!=priceTypeChange.getGol7()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol7 to : "+oldPriceTypeChange.getGol7()+" > "+priceTypeChange.getGol7();                
        }
        
        if(oldPriceTypeChange.getGol8()!=priceTypeChange.getGol8()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol8 to : "+oldPriceTypeChange.getGol8()+" > "+priceTypeChange.getGol8();                
        }
        
        if(oldPriceTypeChange.getGol9()!=priceTypeChange.getGol9()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol9 to : "+oldPriceTypeChange.getGol9()+" > "+priceTypeChange.getGol9();                
        }
        
        if(oldPriceTypeChange.getGol10()!=priceTypeChange.getGol10()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol10 to : "+oldPriceTypeChange.getGol10()+" > "+priceTypeChange.getGol10();                
        }
        
        if(logDesc.length()>0){
            logDesc = "Update data >> "+logDesc;
        }

        return logDesc;
    }
    
    public static int getCountByRefCost(String refNumber){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT(*) as tot FROM pos_vendor_item_change where ref_number='"+refNumber+"' "  ;
			
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt("tot"); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
    }
    
    public static Vector listByRefCost(int limitStart,int recordToGet, String refNumber, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM pos_item_master im inner join pos_vendor_item_change vi on im.item_master_id=vi.item_master_id where vi.ref_number='" + refNumber +"' " ; 
					
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				ItemMaster itemmaster = new ItemMaster();
				resultToObjectByRef(rs, itemmaster);
				lists.add(itemmaster);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}

    public static void resultToObjectByRef(ResultSet rs, ItemMaster itemmaster){
		try{
			itemmaster.setOID(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]));
			itemmaster.setItemGroupId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]));
			itemmaster.setItemCategoryId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]));
			itemmaster.setUomPurchaseId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_PURCHASE_ID]));
			itemmaster.setUomRecipeId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_RECIPE_ID]));
			itemmaster.setUomStockId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_ID]));
			itemmaster.setUomSalesId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES_ID]));
			itemmaster.setCode(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_CODE]));
			itemmaster.setBarcode(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_BARCODE]));
			itemmaster.setName(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_NAME]));
			itemmaster.setUomPurchaseStockQty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_PURCHASE_STOCK_QTY]));
			itemmaster.setUomStockRecipeQty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_RECIPE_QTY]));
			itemmaster.setUomStockSalesQty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES_QTY]));
			itemmaster.setForSale(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_FOR_SALE]));
			itemmaster.setForBuy(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_FOR_BUY]));
			itemmaster.setIsActive(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_ACTIVE]));
			itemmaster.setSellingPrice(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE]));
			itemmaster.setCogs(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_COGS]));
			itemmaster.setRecipeItem(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_RECIPE_ITEM]));
                        itemmaster.setNeedRecipe(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]));
                        
                        itemmaster.setDefaultVendorId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID]));
                        itemmaster.setMinStock(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_MIN_STOCK]));
                        itemmaster.setType(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_TYPE]));
                        itemmaster.setApplyStockCode(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_APPLY_STOCK_CODE]));
                        itemmaster.setIs_service(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE]));
                        itemmaster.setCogs_consigment(rs.getFloat(DbItemMaster.colNames[DbItemMaster.COL_COGS_CONSIGMENT]));
                        itemmaster.setApplyStockCodeSales(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_APPLY_STOCK_CODE_SALES]));
                        itemmaster.setUseExpiredDate(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_USE_EXPIRED_DATE]));
                        itemmaster.setMerk_id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_MERK_ID]));
                        itemmaster.setNew_cogs(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_NEW_COGS]));
                        itemmaster.setActive_date(rs.getDate(DbItemMaster.colNames[DbItemMaster.COL_ACTIVE_DATE]));
                        itemmaster.setIs_bkp(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]));
                        itemmaster.setIsKomisi(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_KOMISI]));
                        itemmaster.setBarcode2(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2]));
                        itemmaster.setBarcode3(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3]));
                        itemmaster.setCounterSku(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_COUNTER_SKU]));
                        itemmaster.setRegisterDate(rs.getDate(DbItemMaster.colNames[DbItemMaster.COL_REGISTER_DATE]));
                        itemmaster.setTypeItem(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM]));
                        
                        itemmaster.setUomStockSales1Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES1_QTY]));                        
                        itemmaster.setUomSales2Id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES2_ID]));                        
                        itemmaster.setUomStockSales2Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES2_QTY]));
                        itemmaster.setUomSales3Id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES3_ID]));
                        itemmaster.setUomStockSales3Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES3_QTY]));
                        itemmaster.setUomSales4Id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES4_ID]));
                        itemmaster.setUomStockSales4Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES4_QTY]));
                        itemmaster.setUomSales5Id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES5_ID]));
                        itemmaster.setUomStockSales5Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES5_QTY]));
                        itemmaster.setDeliveryUnit(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_DELIVERY_UNIT]));
                        itemmaster.setLocationOrder(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_LOCATION_ORDER]));
                        itemmaster.setIsAutoOrder(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_AUTO_ORDER]));
                        itemmaster.setNeedBom(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_NEED_BOM]));
                        itemmaster.setStatus(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_STATUS]));
                        itemmaster.setApprovedDate(rs.getDate(DbItemMaster.colNames[DbItemMaster.COL_APPROVED_DATE]));
                        itemmaster.setUserIdAproved(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_USER_ID_APPROVED]));
		}catch(Exception e){ }
	}
    
 public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_PRICE_TYPE_CHANGE + " where " +
                    colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix() + "' ";

            System.out.println(sql);

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }

            result = result + 1;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static String getNumberPrefix() {
        String code = "";
        code = "PC";

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }

    public static String getNextNumber(int ctr) {

        String code = getNumberPrefix();

        if (ctr < 10) {
            code = code + "000" + ctr;
        } else if (ctr < 100) {
            code = code + "00" + ctr;
        } else if (ctr < 1000) {
            code = code + "0" + ctr;
        } else {
            code = code + ctr;
        }
        return code;
    }  
   public static int getCountByRefPriceChange(String refNumber){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT(*) as tot FROM pos_price_type_change where ref_number='"+refNumber+"' "  ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt("tot"); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
    } 
    
    public static Vector listByRefPriceChange(int limitStart,int recordToGet, String refNumber, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM pos_item_master im inner join pos_price_type_change vi on im.item_master_id=vi.item_master_id where vi.ref_number='" + refNumber +"' " ; 
					
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				ItemMaster itemmaster = new ItemMaster();
				resultToObjectByRef(rs, itemmaster);
				lists.add(itemmaster);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}
    
}
