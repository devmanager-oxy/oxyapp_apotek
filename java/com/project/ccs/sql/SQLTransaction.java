/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.sql;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author gadnyana
 */
public class SQLTransaction {


    public static Vector checkAndGetItemMaster(String codeSKU, int recordToGet){
        CONResultSet crs = null;
        Vector list = new Vector();
        try{
        	String sql = "select * from "+DbItemMaster.DB_ITEM_MASTER+" where "+
                        " code like '"+codeSKU+"' or barcode like '"+codeSKU+"' limit 0, 20";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	ItemMaster itemMaster = new ItemMaster();
            	itemMaster.setOID(rs.getLong("item_master_id"));
                itemMaster.setName(rs.getString("name"));
                itemMaster.setCode(rs.getString("code"));
                itemMaster.setBarcode(rs.getString("barcode"));
                itemMaster.setSellingPrice(0);

            	list.add(itemMaster);
            }
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }

        return list;
    }
}
