/*
 * SessItemMaster.java
 *
 * Created on March 24, 2008, 2:11 PM
 */

package com.project.ccs.posmaster;


import java.util.*;
import java.sql.*;
import com.project.util.*;
import com.project.main.db.*;
import java.util.Date;
import com.project.ccs.posmaster.*;

/**
 *
 * @author  Valued Customer
 */
public class SessItemMaster {
    
    /** Creates a new instance of SessItemMaster */
    public SessItemMaster() {
    }
    
    public static Vector getRecipeItems(long itemId, int iJSPCommand){
        
        CONResultSet crs = null;
        Vector result = new Vector(1,1);
        try{
        
            String sql = " SELECT * FROM "+DbItemMaster.DB_ITEM_MASTER+" where "+DbItemMaster.colNames[DbItemMaster.COL_RECIPE_ITEM]+"=1 "+
                " and "+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+"<>"+itemId;
            
            if(iJSPCommand==JSPCommand.ADD){
                sql = sql +  " and "+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                             " not in (select "+DbRecipe.colNames[DbRecipe.COL_ITEM_RECIPE_ID]+
                             " from "+DbRecipe.DB_RECIPE+" where "+DbRecipe.colNames[DbRecipe.COL_ITEM_MASTER_ID]+"="+itemId+")";
            }            
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                ItemMaster im = new ItemMaster();
                DbItemMaster.resultToObject(rs, im); 
                result.add(im);
            }
            
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    
}
