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

/**
 *
 * @author Roy Andika
 */
public class DbPriceType extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language{
    
    public static final String DB_PRICE_TYPE = "pos_price_type";
    
    public static final int COL_PRICE_TYPE_ID   = 0;
    public static final int COL_ITEM_MASTER_ID  = 1;
    public static final int COL_QTY_FROM        = 2;
    public static final int COL_QTY_TO          = 3;
    public static final int COL_GOL_1           = 4;
    public static final int COL_GOL_2           = 5;
    public static final int COL_GOL_3           = 6;
    public static final int COL_GOL_4           = 7;
    public static final int COL_GOL_5           = 8;    
    public static final int COL_GOL1_MARGIN     = 9;
    public static final int COL_GOL2_MARGIN     = 10;
    public static final int COL_GOL3_MARGIN     = 11;
    public static final int COL_GOL4_MARGIN     = 12;
    public static final int COL_GOL5_MARGIN     = 13;
    public static final int COL_CHANGE_DATE     = 14;
    public static final int COL_GOL_6           = 15;
    public static final int COL_GOL_7           = 16;
    public static final int COL_GOL_8           = 17;
    public static final int COL_GOL_9           = 18;
    public static final int COL_GOL_10          = 19;
    public static final int COL_GOL6_MARGIN     = 20;
    public static final int COL_GOL7_MARGIN     = 21;
    public static final int COL_GOL8_MARGIN     = 22;
    public static final int COL_GOL9_MARGIN     = 23;
    public static final int COL_GOL10_MARGIN    = 24;    
    public static final int COL_GOL_11          = 25;    
    public static final int COL_GOL11_MARGIN    = 26;    
    
    public static final String[] colNames = {
        "price_type_id",
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
        "gol_11",        
        "gol11_margin"
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
        TYPE_FLOAT,
        TYPE_FLOAT
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
    public static final String gol_11="gol_11"; 
    
    public DbPriceType() {
    }

    public DbPriceType(int i) throws CONException {
        super(new DbPriceType());
    }

    public DbPriceType(String sOid) throws CONException {
        super(new DbPriceType(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPriceType(long lOid) throws CONException {
        super(new DbPriceType(0));
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
        return DB_PRICE_TYPE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPriceType().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PriceType priceType = fetchExc(ent.getOID());
        ent = (Entity) priceType;
        return priceType.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PriceType) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PriceType) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PriceType fetchExc(long oid) throws CONException {        
        try {
            
            PriceType priceType = new PriceType();            
            DbPriceType pstPriceType = new DbPriceType(oid);            
            priceType.setOID(oid);
            priceType.setItemMasterId(pstPriceType.getlong(COL_ITEM_MASTER_ID));            
            priceType.setQtyFrom(pstPriceType.getInt(COL_QTY_FROM));
            priceType.setQtyTo(pstPriceType.getInt(COL_QTY_TO));
            
            priceType.setGol1(pstPriceType.getdouble(COL_GOL_1));
            priceType.setGol2(pstPriceType.getdouble(COL_GOL_2));
            priceType.setGol3(pstPriceType.getdouble(COL_GOL_3));
            priceType.setGol4(pstPriceType.getdouble(COL_GOL_4));
            priceType.setGol5(pstPriceType.getdouble(COL_GOL_5));
            
            priceType.setGol1_margin(pstPriceType.getdouble(COL_GOL1_MARGIN));
            priceType.setGol2_margin(pstPriceType.getdouble(COL_GOL2_MARGIN));
            priceType.setGol3_margin(pstPriceType.getdouble(COL_GOL3_MARGIN));
            priceType.setGol4_margin(pstPriceType.getdouble(COL_GOL4_MARGIN));
            priceType.setGol5_margin(pstPriceType.getdouble(COL_GOL5_MARGIN));
            priceType.setChangeDate(pstPriceType.getDate(COL_CHANGE_DATE));
            
            priceType.setGol6(pstPriceType.getdouble(COL_GOL_6));
            priceType.setGol7(pstPriceType.getdouble(COL_GOL_7));
            priceType.setGol8(pstPriceType.getdouble(COL_GOL_8));
            priceType.setGol9(pstPriceType.getdouble(COL_GOL_9));
            priceType.setGol10(pstPriceType.getdouble(COL_GOL_10));
            priceType.setGol6_margin(pstPriceType.getdouble(COL_GOL6_MARGIN));
            priceType.setGol7_margin(pstPriceType.getdouble(COL_GOL7_MARGIN));
            priceType.setGol8_margin(pstPriceType.getdouble(COL_GOL8_MARGIN));
            priceType.setGol9_margin(pstPriceType.getdouble(COL_GOL9_MARGIN));
            priceType.setGol10_margin(pstPriceType.getdouble(COL_GOL10_MARGIN));
            priceType.setGol11(pstPriceType.getdouble(COL_GOL_11));
            priceType.setGol11_margin(pstPriceType.getdouble(COL_GOL11_MARGIN));
            
            return priceType;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPriceType(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PriceType priceType) throws CONException {
        
        try {

            DbPriceType pstPriceType = new DbPriceType(0);
            
            pstPriceType.setLong(COL_ITEM_MASTER_ID, priceType.getItemMasterId());
            pstPriceType.setInt(COL_QTY_FROM, priceType.getQtyFrom());
            pstPriceType.setInt(COL_QTY_TO, priceType.getQtyTo());
            pstPriceType.setDouble(COL_GOL_1, priceType.getGol1());
            pstPriceType.setDouble(COL_GOL_2, priceType.getGol2());
            pstPriceType.setDouble(COL_GOL_3, priceType.getGol3());
            pstPriceType.setDouble(COL_GOL_4, priceType.getGol4());
            pstPriceType.setDouble(COL_GOL_5, priceType.getGol5());
            
            pstPriceType.setDouble(COL_GOL1_MARGIN, priceType.getGol1_margin());
            pstPriceType.setDouble(COL_GOL2_MARGIN, priceType.getGol2_margin());
            pstPriceType.setDouble(COL_GOL3_MARGIN, priceType.getGol3_margin());
            pstPriceType.setDouble(COL_GOL4_MARGIN, priceType.getGol4_margin());
            pstPriceType.setDouble(COL_GOL5_MARGIN, priceType.getGol5_margin());            
            pstPriceType.setDate(COL_CHANGE_DATE, priceType.getChangeDate());            
            pstPriceType.setDouble(COL_GOL_6, priceType.getGol6());
            pstPriceType.setDouble(COL_GOL_7, priceType.getGol7());
            pstPriceType.setDouble(COL_GOL_8, priceType.getGol8());
            pstPriceType.setDouble(COL_GOL_9, priceType.getGol9());
            pstPriceType.setDouble(COL_GOL_10, priceType.getGol10());
            pstPriceType.setDouble(COL_GOL6_MARGIN, priceType.getGol6_margin());
            pstPriceType.setDouble(COL_GOL7_MARGIN, priceType.getGol7_margin());
            pstPriceType.setDouble(COL_GOL8_MARGIN, priceType.getGol8_margin());
            pstPriceType.setDouble(COL_GOL9_MARGIN, priceType.getGol9_margin());
            pstPriceType.setDouble(COL_GOL10_MARGIN, priceType.getGol10_margin());
            pstPriceType.setDouble(COL_GOL_11, priceType.getGol11());
            pstPriceType.setDouble(COL_GOL11_MARGIN, priceType.getGol11_margin());
            
            pstPriceType.insert();
            priceType.setOID(pstPriceType.getlong(COL_PRICE_TYPE_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPriceType(0), CONException.UNKNOWN);
        }
        return priceType.getOID();
    }

    public static long updateExc(PriceType priceType) throws CONException {
        try {
            
            if (priceType.getOID() != 0) {

                DbPriceType pstPriceType = new DbPriceType(priceType.getOID());
                
                pstPriceType.setLong(COL_ITEM_MASTER_ID, priceType.getItemMasterId());
                pstPriceType.setInt(COL_QTY_FROM, priceType.getQtyFrom());
                pstPriceType.setInt(COL_QTY_TO, priceType.getQtyTo());
                pstPriceType.setDouble(COL_GOL_1, priceType.getGol1());
                pstPriceType.setDouble(COL_GOL_2, priceType.getGol2());
                pstPriceType.setDouble(COL_GOL_3, priceType.getGol3());
                pstPriceType.setDouble(COL_GOL_4, priceType.getGol4());
                pstPriceType.setDouble(COL_GOL_5, priceType.getGol5());
                pstPriceType.setDouble(COL_GOL1_MARGIN, priceType.getGol1_margin());
                pstPriceType.setDouble(COL_GOL2_MARGIN, priceType.getGol2_margin());
                pstPriceType.setDouble(COL_GOL3_MARGIN, priceType.getGol3_margin());
                pstPriceType.setDouble(COL_GOL4_MARGIN, priceType.getGol4_margin());
                pstPriceType.setDouble(COL_GOL5_MARGIN, priceType.getGol5_margin());
                pstPriceType.setDate(COL_CHANGE_DATE, priceType.getChangeDate());
                
                pstPriceType.setDouble(COL_GOL_6, priceType.getGol6());
                pstPriceType.setDouble(COL_GOL_7, priceType.getGol7());
                pstPriceType.setDouble(COL_GOL_8, priceType.getGol8());
                pstPriceType.setDouble(COL_GOL_9, priceType.getGol9());
                pstPriceType.setDouble(COL_GOL_10, priceType.getGol10());
                pstPriceType.setDouble(COL_GOL6_MARGIN, priceType.getGol6_margin());
                pstPriceType.setDouble(COL_GOL7_MARGIN, priceType.getGol7_margin());
                pstPriceType.setDouble(COL_GOL8_MARGIN, priceType.getGol8_margin());
                pstPriceType.setDouble(COL_GOL9_MARGIN, priceType.getGol9_margin());
                pstPriceType.setDouble(COL_GOL10_MARGIN, priceType.getGol10_margin());
                pstPriceType.setDouble(COL_GOL_11, priceType.getGol11());
                pstPriceType.setDouble(COL_GOL11_MARGIN, priceType.getGol11_margin());
                
                pstPriceType.update();
                return priceType.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPriceType(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPriceType pstItemMaster = new DbPriceType(oid);
            pstItemMaster.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPriceType(0), CONException.UNKNOWN);
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
                    sql = "SELECT " + gol_1 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_2)){
                    sql = "SELECT " + gol_2 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_3)){
                    sql = "SELECT " + gol_3 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_4)){
                    sql = "SELECT " + gol_4 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_5)){
                    sql = "SELECT " + gol_5 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
                }else if(gol.equalsIgnoreCase(gol_6)){
                    sql = "SELECT " + gol_6 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;    
                }else if(gol.equalsIgnoreCase(gol_7)){
                    sql = "SELECT " + gol_7 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;    
                }else if(gol.equalsIgnoreCase(gol_8)){
                    sql = "SELECT " + gol_8 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;        
                }else if(gol.equalsIgnoreCase(gol_9)){
                    sql = "SELECT " + gol_9 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;    
                }else if(gol.equalsIgnoreCase(gol_10)){
                    sql = "SELECT " + gol_10 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;    
                }else if(gol.equalsIgnoreCase(gol_11)){
                    sql = "SELECT " + gol_11 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;        
                }else{
                    sql = "SELECT " + gol_1 + " FROM " + DB_PRICE_TYPE + " where " + qty + " >= qty_from and  " + qty + " <= qty_to" + " and item_master_id=" + oidItemMaster ;
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
    
     public static PriceType getPriceType(long oidItemMaster){
         CONResultSet dbrs = null;
         PriceType pt = new PriceType();
         
         try{
             String sql="";
                    sql = "SELECT * FROM " + DB_PRICE_TYPE + " where " + DbPriceType.colNames[COL_ITEM_MASTER_ID]+"=" + oidItemMaster;
             
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
            String sql = "SELECT * FROM " + DB_PRICE_TYPE;
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
                PriceType priceType = new PriceType();
                resultToObject(rs, priceType);
                lists.add(priceType);
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
            Vector vPricelist = DbPriceType.list(0,0, " item_master_id=" + itemMasterId, "");
            if(vPricelist.size()>0){
                for(int i=0;i<vPricelist.size();i++){
                   PriceType pt = (PriceType) vPricelist.get(i) ;
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
                   pt.setGol11((im.getCogs()+ppn)*(100/(100-pt.getGol11_margin()))); 
                   //pt.setGol1(((pt.getGol1_margin()*im.getCogs())/100) + im.getCogs());
                   //pt.setGol2(((pt.getGol2_margin()*im.getCogs())/100) + im.getCogs());
                   //pt.setGol3(((pt.getGol3_margin()*im.getCogs())/100) + im.getCogs());
                   //pt.setGol4(((pt.getGol4_margin()*im.getCogs())/100) + im.getCogs());
                   //pt.setGol5(((pt.getGol5_margin()*im.getCogs())/100) + im.getCogs());
                   
                   DbPriceType.updateExc(pt);
                }
            }
        }catch(Exception ex){
            
        }
    }
    public static void resultToObject(ResultSet rs, PriceType priceType) {
        try {
            priceType.setOID(rs.getLong(DbPriceType.colNames[DbPriceType.COL_PRICE_TYPE_ID]));            
            priceType.setItemMasterId(rs.getLong(DbPriceType.colNames[DbPriceType.COL_ITEM_MASTER_ID]));            
            priceType.setQtyFrom(rs.getInt(DbPriceType.colNames[DbPriceType.COL_QTY_FROM]));
            priceType.setQtyTo(rs.getInt(DbPriceType.colNames[DbPriceType.COL_QTY_TO]));            
            priceType.setGol1(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_1]));
            priceType.setGol2(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_2]));
            priceType.setGol3(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_3]));
            priceType.setGol4(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_4]));
            priceType.setGol5(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_5]));
            priceType.setGol1_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL1_MARGIN]));
            priceType.setGol2_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL2_MARGIN]));
            priceType.setGol3_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL3_MARGIN]));
            priceType.setGol4_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL4_MARGIN]));
            priceType.setGol5_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL5_MARGIN]));
            priceType.setGol6(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_6]));
            priceType.setGol7(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_7]));
            priceType.setGol8(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_8]));
            priceType.setGol9(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_9]));
            priceType.setGol10(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_10]));
            priceType.setGol6_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL6_MARGIN]));
            priceType.setGol7_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL7_MARGIN]));
            priceType.setGol8_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL8_MARGIN]));
            priceType.setGol9_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL9_MARGIN]));
            priceType.setGol10_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL10_MARGIN]));
            priceType.setChangeDate(rs.getDate(DbPriceType.colNames[DbPriceType.COL_CHANGE_DATE]));            
            priceType.setGol11(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL_11]));
            priceType.setGol11_margin(rs.getDouble(DbPriceType.colNames[DbPriceType.COL_GOL11_MARGIN]));
        } catch (Exception e) {}
    }

    public static boolean checkOID(long stockCodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PRICE_TYPE + " WHERE " +
                    DbPriceType.colNames[DbPriceType.COL_PRICE_TYPE_ID] + " = " + stockCodeId;

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
            String sql = "SELECT COUNT(" + DbPriceType.colNames[DbPriceType.COL_PRICE_TYPE_ID] + ") FROM " + DB_PRICE_TYPE;
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
                    PriceType priceType = (PriceType) list.get(ls);
                    if (oid == priceType.getOID()) {
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
    public static void insertOperationLog(long oid, long userId, String userName, PriceType priceType){

        LogOperation lo = new LogOperation();
        lo.setDate(new java.util.Date());
        lo.setOwnerId(priceType.getItemMasterId());
        lo.setUserId(userId);
        lo.setUserName(userName);
        lo.setLogDesc("Insert new price type qty from : "+priceType.getQtyFrom()+" to "+priceType.getQtyTo());

        try{
            DbLogOperation.insertExc(lo);
        }
        catch(Exception e){

        }
    }
                
    //insert logs for update item
    public static void insertOperationLog(long oid, long userId, String userName, PriceType oldPriceType, PriceType priceType){

        String logDesc = getLogDesc(oldPriceType, priceType);

        if(logDesc.length()>0){
            
            LogOperation lo = new LogOperation();
            lo.setDate(new java.util.Date());
            lo.setOwnerId(priceType.getItemMasterId());
            lo.setUserId(userId);
            lo.setUserName(userName);
            lo.setLogDesc(logDesc);
            try{
                DbLogOperation.insertExc(lo);
            }catch(Exception e){}
        }
    }
        
    public static String getLogDesc(PriceType oldPriceType, PriceType priceType){
        
        String logDesc = "";
        
        if(oldPriceType.getQtyFrom()!=priceType.getQtyFrom()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"qty from : "+oldPriceType.getQtyFrom()+" > "+priceType.getQtyFrom();                
        }
        
        if(oldPriceType.getQtyTo()!=priceType.getQtyTo()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"qty to : "+oldPriceType.getQtyTo()+" > "+priceType.getQtyTo();                
        }
        
        if(oldPriceType.getGol1()!=priceType.getGol1()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol1 to : "+oldPriceType.getGol1()+" > "+priceType.getGol1();                
        }
        
        if(oldPriceType.getGol2()!=priceType.getGol2()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol2 to : "+oldPriceType.getGol2()+" > "+priceType.getGol2();                
        }
        
        if(oldPriceType.getGol3()!=priceType.getGol3()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol3 to : "+oldPriceType.getGol3()+" > "+priceType.getGol3();                
        }
        
        if(oldPriceType.getGol4()!=priceType.getGol4()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol4 to : "+oldPriceType.getGol4()+" > "+priceType.getGol4();                
        }
        
        if(oldPriceType.getGol5()!=priceType.getGol5()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol5 to : "+oldPriceType.getGol5()+" > "+priceType.getGol5();                
        }
        
        if(oldPriceType.getGol6()!=priceType.getGol6()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol6 to : "+oldPriceType.getGol6()+" > "+priceType.getGol6();                
        }
        
        if(oldPriceType.getGol7()!=priceType.getGol7()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol7 to : "+oldPriceType.getGol7()+" > "+priceType.getGol7();                
        }
        
        if(oldPriceType.getGol8()!=priceType.getGol8()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol8 to : "+oldPriceType.getGol8()+" > "+priceType.getGol8();                
        }
        
        if(oldPriceType.getGol9()!=priceType.getGol9()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol9 to : "+oldPriceType.getGol9()+" > "+priceType.getGol9();                
        }
        
        if(oldPriceType.getGol10()!=priceType.getGol10()){
            logDesc = ((logDesc.length()>0) ? ", " : "" )+"price gol10 to : "+oldPriceType.getGol10()+" > "+priceType.getGol10();                
        }
        
        if(logDesc.length()>0){
            logDesc = "Update data >> "+logDesc;
        }

        return logDesc;
    }

    
}
