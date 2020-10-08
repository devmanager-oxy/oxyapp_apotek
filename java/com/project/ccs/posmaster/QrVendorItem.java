/*
 * QrVendorItem.java
 *
 * Created on April 5, 2008, 1:58 PM
 */

package com.project.ccs.posmaster;

import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.general.*;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.purchase.*;
import com.project.ccs.postransaction.receiving.*;
/**
 *
 * @author  Valued Customer
 */
public class QrVendorItem {
    
    /** Creates a new instance of QrVendorItem */
    public QrVendorItem() {
    }
    
    
    public static Vector getVendorItems(long vendorId){
        
        Vector result = new Vector();
        CONResultSet crs = null;
        try{
        
            String sql = "select im.*, ig."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as group_name, "+
                " ig."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, "+
                " ic."+DbItemCategory.colNames[DbItemCategory.COL_ITEM_CATEGORY_ID]+" as cat_id, "+
                " ic."+DbItemCategory.colNames[DbItemCategory.COL_NAME]+" as cat_name, "+
                " vi.*, um.* from "+DbVendorItem.DB_VENDOR_ITEM+" vi "+
                " inner join "+DbVendor.DB_VENDOR+" v on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                " = vi."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" im on im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = vi."+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+
                " inner join "+DbItemGroup.DB_ITEM_GROUP+" ig on ig."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+
                " = im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                " inner join "+DbItemCategory.DB_ITEM_CATEGORY+" ic on ic."+DbItemCategory.colNames[DbItemCategory.COL_ITEM_CATEGORY_ID]+
                " = im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+
                " inner join "+DbUom.DB_UOM+" um on um."+DbUom.colNames[DbUom.COL_UOM_ID]+
                " = im."+DbItemMaster.colNames[DbItemMaster.COL_UOM_PURCHASE_ID]+
                " where v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"="+vendorId;
            
            //System.out.println(sql);
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                Vector temp = new Vector();
                
                ItemMaster ims = new ItemMaster();
                DbItemMaster.resultToObject(rs, ims);
                
                ItemGroup ig = new ItemGroup();
                ig.setOID(rs.getLong("group_id"));
                ig.setName(rs.getString("group_name"));
                
                ItemCategory ic = new ItemCategory();
                ic.setOID(rs.getLong("cat_id"));
                ic.setName(rs.getString("cat_name"));                
                
                Uom uo = new Uom();
                DbUom.resultToObject(rs, uo);
                
                VendorItem vi = new VendorItem();
                DbVendorItem.resultToObject(rs, vi);
                
                temp.add(ims);
                temp.add(ig);
                temp.add(ic);
                temp.add(uo);
                temp.add(vi);
                
                result.add(temp);
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
    
    public static Vector getOutVendorItems(Purchase purchase){
        
        Vector result = new Vector();
        CONResultSet crs = null;
        try{
            String sql = "select * from "+DbPurchaseItem.DB_PURCHASE_ITEM+" pi "+
                    " where pi."+DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+" = "+purchase.getOID()+
                    " and pi."+DbPurchaseItem.colNames[DbPurchaseItem.COL_ITEM_MASTER_ID]+
                    " not in (select "+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+
                    " from "+DbVendorItem.DB_VENDOR_ITEM+" vi "+
                    " where vi."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+" = "+purchase.getVendorId()+")";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                PurchaseItem pi = new PurchaseItem();
                DbPurchaseItem.resultToObject(rs, pi);
                result.add(pi);
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
    
    
    public static Vector getOutVendorItems(Receive receive){
        
        Vector result = new Vector();
        CONResultSet crs = null;
        try{
            String sql = "select * from "+DbPurchaseItem.DB_PURCHASE_ITEM+" pi "+
                    " where pi."+DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+" = "+receive.getOID()+
                    " and pi."+DbPurchaseItem.colNames[DbPurchaseItem.COL_ITEM_MASTER_ID]+
                    " not in (select "+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+
                    " from "+DbVendorItem.DB_VENDOR_ITEM+" vi "+
                    " where vi."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+" = "+receive.getVendorId()+")";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                ReceiveItem pi = new ReceiveItem();
                DbReceiveItem.resultToObject(rs, pi);
                result.add(pi);
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
