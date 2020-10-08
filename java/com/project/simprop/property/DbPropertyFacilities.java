/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class DbPropertyFacilities extends CONHandler{
    
    public static final String DB_PROPERTY_FACILITIES = "prop_property_facilities";
    
    public static final int COL_PROPERTY_ID = 0;
    public static final int COL_FACILITIES_ID = 1;
    
    public static final String[] colNames = {
        "property_id",
        "facilities_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT + TYPE_PK + TYPE_ID
    };
    
    public static Vector getListFacilities(long propertyId){
        
        CONResultSet dbrs = null;
        try {
            
            String sql = "SELECT * FROM " + DB_PROPERTY_FACILITIES+" WHERE "+DbPropertyFacilities.colNames[DbPropertyFacilities.COL_PROPERTY_ID]+ " = "+propertyId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();
            
            while (rs.next()) { 
                PropertyFacilities pF = new PropertyFacilities();
                pF.setPropertyId(rs.getLong(DbPropertyFacilities.colNames[DbPropertyFacilities.COL_PROPERTY_ID]));
                pF.setFacilitiesId(rs.getLong(DbPropertyFacilities.colNames[DbPropertyFacilities.COL_FACILITIES_ID]));
                
                result.add(pF);
            }

            rs.close();
            return result;
            
        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    public static void deleteFacilities(long propertyId){        
        CONResultSet dbrs = null;
        try {            
            String sql = "DELETE FROM " + DB_PROPERTY_FACILITIES+" WHERE "+DbPropertyFacilities.colNames[DbPropertyFacilities.COL_PROPERTY_ID]+ " = "+propertyId;
            int i = CONHandler.execUpdate(sql);
            
        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static void insert(long propertyId,long facilitiesId){        
        CONResultSet dbrs = null;
        try {            
            String sql = "INSERT INTO " + DB_PROPERTY_FACILITIES+" VALUES ("+propertyId+","+facilitiesId+")";
            int i = CONHandler.execUpdate(sql);
            
        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }

}
