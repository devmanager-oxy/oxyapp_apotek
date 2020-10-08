package com.project.system;


import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.*;

public class DbSystemProperty extends CONHandler implements I_CONInterface, I_CONType, I_Persintent 
{
    
    public static final String DB_SYSPROP = "system_main";
    
    public static final int COL_SYSPROP_ID 	= 0;
    public static final int COL_NAME 	= 1;
    public static final int COL_VALUE 	= 2;
    public static final int COL_VALTYPE = 3; 
    public static final int COL_DISTYPE = 4;
    public static final int COL_GROUP	= 5;
    public static final int COL_NOTE    = 6;
    
    public static final int COL_COMPANY_ID    = 7;
    
    public static String[] fieldNames = {
        "sysmain_id",
        "name", 
        "valueprop", 
        "valtype",
        "distype",
        "groupprop",
        "note",
        "company_id"
    };
    
    public static int[] fieldTypes = {
        TYPE_PK + TYPE_LONG+ TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG
    };
    
    
    //	Other constanta goes here (if any)
    
    public static String[] valueTypes = { "STRING", "TEXT","NUMBER" };    
    public static String[] displayTypes = { "SINGLE TEXT","MULTI TEXT","DROP DOWN" };

    
    
    /**
     *	Contractor
     */
    public DbSystemProperty()    
    {   
    }
    
    
    public DbSystemProperty(int i) throws CONException {
        super(new DbSystemProperty());
    }
    
    
    public DbSystemProperty(String sOid) throws CONException 
    {
        super(new DbSystemProperty(0));
        if(!locate(sOid))
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    
    public DbSystemProperty(long lOid) throws CONException 
    {
        super(new DbSystemProperty(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        }catch(Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        
        if(!locate(sOid))
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        else
            return;
        
    }
    
    
    /**
     *	Implemanting I_Entity interface methods
     */
    public int getFieldSize() {
        return fieldNames.length;
    }
    
    public String getTableName() {
        return DB_SYSPROP;
    }
    
    public String[] getFieldNames() {
        return fieldNames;
    }
    
    public int[] getFieldTypes() {
        return fieldTypes;
    }
    
    public String getPersistentName() {                
        return new DbSystemProperty().getClass().getName();
    }
    
    
    /**
     *	Implemanting I_CONInterface interface methods
     */
    public long fetch(Entity ent) {        
        SystemProperty sysProp = DbSystemProperty.fetch(ent.getOID());
        ent = (Entity)sysProp;
        return sysProp.getOID();         
    }
    

    public long insert(Entity ent) {
        return DbSystemProperty.insert((SystemProperty) ent);
    }
    
    public long update(Entity ent) {
        return update((SystemProperty) ent);
    }
    
    public long delete(Entity ent) {
        return delete((SystemProperty) ent);
    }
    
    
    
    
    public static SystemProperty fetch(long oid) 
    {
        SystemProperty sysProp = new SystemProperty();
        try {
            DbSystemProperty pSystemProperty = new DbSystemProperty(oid);
            sysProp.setOID(oid);
            sysProp.setName(pSystemProperty.getString(COL_NAME));
            sysProp.setValue(pSystemProperty.getString(COL_VALUE));
            sysProp.setValueType(pSystemProperty.getString(COL_VALTYPE));
            sysProp.setDisplayType(pSystemProperty.getString(COL_DISTYPE));
            sysProp.setGroup(pSystemProperty.getString(COL_GROUP));
            sysProp.setNote(pSystemProperty.getString(COL_NOTE));
            sysProp.setCompanyId(pSystemProperty.getlong(COL_COMPANY_ID));
        }
        catch(CONException e) {
            System.out.println(e);
        }
        return sysProp;
    }
    
    
    public static long insert(SystemProperty sysProp)
    {
        try{
            DbSystemProperty pSystemProperty = new DbSystemProperty(0);
            pSystemProperty.setString(COL_NAME, sysProp.getName());
            pSystemProperty.setString(COL_VALUE, sysProp.getValue());
            pSystemProperty.setString(COL_VALTYPE, sysProp.getValueType());
            pSystemProperty.setString(COL_DISTYPE, sysProp.getDisplayType());
            pSystemProperty.setString(COL_GROUP, sysProp.getGroup());
            pSystemProperty.setString(COL_NOTE, sysProp.getNote());          
            pSystemProperty.setLong(COL_COMPANY_ID, sysProp.getCompanyId());
                        
            pSystemProperty.insert();            
            sysProp.setOID(pSystemProperty.getlong(COL_SYSPROP_ID));
            return sysProp.getOID();
        }
        catch(CONException e) {
            System.out.println(e);
        }
        return 0;  
    }
    
    
    public static long update(SystemProperty sysProp)
    {
        if(sysProp.getOID() != 0)
        {
            try {
                DbSystemProperty pSystemProperty = new DbSystemProperty(sysProp.getOID());
                pSystemProperty.setString(COL_NAME, sysProp.getName());
                pSystemProperty.setString(COL_VALUE, sysProp.getValue());
                pSystemProperty.setString(COL_VALTYPE, sysProp.getValueType());
                pSystemProperty.setString(COL_DISTYPE, sysProp.getDisplayType());
                pSystemProperty.setString(COL_GROUP, sysProp.getGroup());
                pSystemProperty.setString(COL_NOTE, sysProp.getNote()); 
                pSystemProperty.setLong(COL_COMPANY_ID, sysProp.getCompanyId());
                
                pSystemProperty.update();     
                return sysProp.getOID();
            }catch(Exception e) {
                System.out.println(e);
            }            
        }
        return 0;
    }
    
    
    public static long delete(long oid)
    {
        try {
            DbSystemProperty pSystemProperty = new DbSystemProperty(oid);
            pSystemProperty.delete();
            return oid;
       }catch(Exception e) {
            System.out.println(e);            
        }
        return 0;
    } 
    

    
    
    public static Vector listAll()
    {
        return list(0, 0, null,null);
    }
    
    public static Vector listByGroup(String gr)
    {
        String whereClause = fieldNames[COL_GROUP] + " = '"+ gr + "'";
        String orderClause = fieldNames[COL_NAME];
        return list(0, 0, whereClause, orderClause);
    }

    
    
    public static Vector listGroups()
    {
        Vector lists = new Vector();
        CONResultSet CONrs = null;
        try {
        
            String sql = "SELECT DISTINCT("+ COL_GROUP +") FROM " + DB_SYSPROP;
            CONrs = CONHandler.execQueryResult(sql);
            ResultSet rs =CONrs.getResultSet();// execQuery(sql);

            while(rs.next()) {                
                lists.add(rs.getString(1));
            }
            rs.close();
            return lists;

       }catch(Exception e) {
            System.out.println(e);            
       }
       finally{
        	CONResultSet.close(CONrs);
       }
       return new Vector();
    }    
    
    
    
    public static Vector list(int limitStart, int recordToGet, String whereClause, String order)
    {
        CONResultSet CONrs = null;
        Vector lists = new Vector();        
        try {
        
            String sql = "SELECT * FROM " + DB_SYSPROP + " ";
            
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
            
            /*if(limitStart == 0 && recordToGet == 0)
                sql = sql + "" ;                //nothing to do
            else
                sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
             */
            
            switch (CONHandler.CONSVR_TYPE) { 
                case CONHandler.CONSVR_MYSQL :
                        if(limitStart == 0 && recordToGet == 0)
                                sql = sql + "";
                        else
                                sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;

                        break;

                 case CONHandler.CONSVR_POSTGRESQL :
                        if(limitStart == 0 && recordToGet == 0)
                                sql = sql + "";
                        else
                                sql = sql + " LIMIT " +recordToGet + " OFFSET "+ limitStart ;

                        break;

                 case CONHandler.CONSVR_SYBASE :
                    	break;

                 case CONHandler.CONSVR_ORACLE :
                    	break;

                 case CONHandler.CONSVR_MSSQL :
                    	break;

                default:
                    ;
            }

            CONrs = CONHandler.execQueryResult(sql);
            ResultSet rs = CONrs.getResultSet();//execQuery(sql);

            while(rs.next()) {
                SystemProperty sysProp = new SystemProperty();
                resultToObject(rs, sysProp);
                lists.add(sysProp);
            }
            rs.close();
            return lists;

       }catch(Exception e) {
            System.out.println(e);            
       }
       finally{
        	CONResultSet.close(CONrs);
       }
       return new Vector();
    }


    public static String getValueByName(String name)
    {
        CONResultSet CONrs = null;
        String val = "Not initialized";
        try {        
            String sql = "SELECT "+ fieldNames[COL_VALUE] +" FROM "+ DB_SYSPROP +" WHERE " + fieldNames[COL_NAME] + "='" + name+"'";
            CONrs = CONHandler.execQueryResult(sql);
            ResultSet rs = CONrs.getResultSet();//execQuery(sql);

            while(rs.next()) {                
                val = rs.getString(1);
                break;
            }
            rs.close();
            return val;

       }catch(Exception e) {
            System.out.println(e);            
       }
       finally{
        	CONResultSet.close(CONrs);
       }
       return val;
    }
    
    
    
    public static int getCount()
    {
        int count = 0;
        CONResultSet CONrs = null;
        try {        
            String sql = "SELECT COUNT("+ fieldNames[COL_SYSPROP_ID] +") FROM " + DB_SYSPROP;
            CONrs = CONHandler.execQueryResult(sql);
            ResultSet rs = CONrs.getResultSet();//execQuery(sql);

            while(rs.next()) {                
                count = rs.getInt(1);
                break;
            }
            rs.close();
            return count;

       }catch(Exception e) {
            System.out.println(e);            
       }
       finally{
        	CONResultSet.close(CONrs);
       }
       return 0;
    }
    
    
    

    private static void resultToObject(ResultSet rs, SystemProperty sysProp) {
        try {
            sysProp.setOID(rs.getLong(COL_SYSPROP_ID + 1));
            sysProp.setName(rs.getString(COL_NAME + 1));
            sysProp.setValue(rs.getString(COL_VALUE + 1));
            sysProp.setValueType(rs.getString(COL_VALTYPE + 1));
            sysProp.setDisplayType(rs.getString(COL_DISTYPE + 1));
            sysProp.setGroup(rs.getString(COL_GROUP + 1));
            sysProp.setNote(rs.getString(COL_NOTE + 1));
            sysProp.setCompanyId(rs.getLong(COL_COMPANY_ID + 1));
            
        }catch(Exception e){
            System.out.println("resultToObject() " + e.toString());
        }
    }
    
    
    public static boolean getModSysPropGereja() {

        String valG = "";

        try {
            valG = DbSystemProperty.getValueByName("COMPANY_TYPE");

            if (valG.compareTo("GEREJA") == 0) {
                return true;
            }
        } catch (Exception e) {
        }

        return false;

    }
    
} // end of DbSystemProperty
