/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbPriceType;
import com.project.ccs.posmaster.DbVendorItem;
import com.project.ccs.posmaster.VendorItem;
import com.project.ccs.postransaction.promotion.DbPromotion;
import com.project.ccs.postransaction.promotion.DbPromotionItem;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Vendor;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.DateCalc;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

public class SessCogsBySection {
    
    public static Vector getCogsBySectionReport(Date startDate, Date endDate, long locationId, int orderBy){
        
        String sql = ""+
            "(select ig."+DbItemGroup.colNames[DbItemGroup.COL_CODE]+ " as codeGroup " +
            ", ig."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+ " as nameGroup " +
            ", sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
            " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * "+
            " sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+") as selling, "+
            " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as discount, "+
            " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * "+
            " sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as cogs "+
            " , ig."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+ " as groupid " +
            " from "+DbSalesDetail.DB_SALES_DETAIL+" sd "+
            " inner join "+DbSales.DB_SALES+" s on s."+DbSales.colNames[DbSales.COL_SALES_ID]+
            " =sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" im "+
            " on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
            " =im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" ig on "+
            " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " =ig."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+            
            " where to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") between "+
            " to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') "+
            " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') ";
        
            if(locationId!=0){
                sql = sql + " and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+"="+locationId;
            }
            sql = sql + " and (s."+DbSales.colNames[DbSales.COL_TYPE]+"=0 or s."+DbSales.colNames[DbSales.COL_TYPE]+"=1)";
            sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
        
        sql = sql + ") union (";//union
        
        sql = sql + " select ig."+DbItemGroup.colNames[DbItemGroup.COL_CODE]+ " as codeGroup " +
            ", ig."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+ " as nameGroup " +
            ", sum(-1 * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
            " sum(-1 * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * "+
            " sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+") as selling, "+
            " sum(-1 * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as discount, "+
            " sum(-1 * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * "+
            " sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as cogs "+
             " , ig."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+ " as groupid " +
            " from "+DbSalesDetail.DB_SALES_DETAIL+" sd "+
            " inner join "+DbSales.DB_SALES+" s on s."+DbSales.colNames[DbSales.COL_SALES_ID]+
            " =sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" im "+
            " on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
            " =im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" ig on "+
            " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " =ig."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+            
            " where to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") between "+
            " to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') "+
            " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') ";
        
            if(locationId!=0){
                sql = sql + " and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+"="+locationId;
            }
            sql = sql + " and (s."+DbSales.colNames[DbSales.COL_TYPE]+"=2 or s."+DbSales.colNames[DbSales.COL_TYPE]+"=3)";
            sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                  ")";//end union

        //order by code
        if(orderBy==0){
            sql = sql + " order by codeGroup ";
        }
        else{
            sql = sql + " order by nameGroup ";
        }

        String sqlGabung = "select codeGroup, nameGroup, sum(qty) as qt, sum(selling) as sel, sum(discount) as dis, sum(cogs) as cog, groupid from ("+sql+") as tabel group by groupid";
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               Vector temp = new Vector();
               temp.add(rs.getString(1));
               temp.add(rs.getString(2));
               temp.add(""+rs.getDouble(3));
               temp.add(""+rs.getDouble(4));
               temp.add(""+rs.getDouble(5));
               temp.add(""+rs.getDouble(6));
               
               result.add(temp);
            }
           
        }catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static Vector getAvailableGolPrice(){
        String sql = "select distinct "+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+
                " from "+DbLocation.DB_LOCATION+" order by "+DbLocation.colNames[DbLocation.COL_GOL_PRICE];
        
        CONResultSet crs = null;
        Vector result=new Vector();
        
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               result.add(rs.getString(1));               
            }
           
        }catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    public static Vector getSalesByGolPriceReport(int start, int recordToGet, Date startDate, Date endDate, String groupCat, 
            String golPrice, int orderBy, int sortType){
        
        String sql = "(select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as itemid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as itemcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" as barcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as itemname, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as cogs, "+
                " sum(pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                "*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as sales,"+
                " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+" as golprice "+
                " from "+DbItemMaster.DB_ITEM_MASTER+" im"+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where to_days(ps.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"')"+
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
                if(golPrice!=null && golPrice.length()>0){
                    sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }

                }
        
                sql = sql + " and (ps."+DbSales.colNames[DbSales.COL_TYPE]+"=0 or ps."+DbSales.colNames[DbSales.COL_TYPE]+"=1)";

                sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+","+
                        " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE];
        
                sql = sql + ") union ("+  
        
                "select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+"  as itemid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as itemcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" as barcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as itemname, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as cogs, "+
                " sum(-1 * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum(-1 * ((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                "*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")) as sales,"+
                " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+" as golprice "+
                " from "+DbItemMaster.DB_ITEM_MASTER+" im"+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where to_days(ps.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"')"+
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
                if(golPrice!=null && golPrice.length()>0){
                    sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }

                }
        
                sql = sql + " and (ps."+DbSales.colNames[DbSales.COL_TYPE]+"=2 or ps."+DbSales.colNames[DbSales.COL_TYPE]+"=3)";

                sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+","+
                        " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+
                ")";
                        //end union
        
        String sqlGabung = "select itemid, itemcode, barcode, itemname, cogs, sum(qty) as qt, sum(sales) as sel, golprice from ("+sql+") as tabel group by itemid, golprice";
                
        //order by code
        if(orderBy==0){
            sqlGabung = sqlGabung + " order by itemcode";
        }
        //name
        else if(orderBy==1){
            sqlGabung = sqlGabung + " order by itemname";
        }
        //sales qty
        else if(orderBy==2){
            sqlGabung = sqlGabung + " order by qt";//qty";
        }
        //sales amount
        else{
            sqlGabung = sqlGabung + " order by sel";//sales";           
        }
        
        if(sortType==1){
            sqlGabung = sqlGabung + " desc ";
        }
        
        if(recordToGet!=0){
            sqlGabung = sqlGabung + " limit "+start+","+recordToGet;
        }
        
        long dayx = DateCalc.dayDifference(startDate, endDate) + 1;
        double days = Double.parseDouble(""+dayx);
        double monthDays = 30;
        double months = days/monthDays;
        double weeks = days/7;
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               Vector temp = new Vector();
               
               long itemId = rs.getLong(1);
               temp.add(""+itemId);//itemid
               temp.add(rs.getString(2));//code
               temp.add(rs.getString(3));//barcode
               temp.add(rs.getString(4));//name
               double cogs = rs.getDouble(5);
               temp.add(""+cogs);//cogs
               double qty = rs.getDouble(6);
               temp.add(""+qty);//qty
               double sales = rs.getDouble(7);
               temp.add(""+sales);//sales
               temp.add(""+rs.getString(8));//gol_price
               
               Vector tempx = DbVendorItem.list(0,1, DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+"="+itemId, "");
               double lastPrice = 0;
               if(tempx!=null && tempx.size()>0){
                   VendorItem vi = (VendorItem)tempx.get(0);
                   temp.add(""+vi.getLastPrice());//last price//9
                   lastPrice = vi.getLastPrice();
               }
               else{
                   temp.add("0");//last price//9
               }
               
               double price = DbPriceType.getPrice(1, golPrice, itemId);
               temp.add(""+price);//selling price//10
               temp.add(""+((lastPrice>0) ? ((price-lastPrice)/lastPrice)*100 : 0));//margin//11
               //double stock = getLastStock(itemId);
               double stock = DbStock.getCount("item_master_id="+itemId+" and status='Approved'");//getLastStock(itemId);
               temp.add(""+stock);//selling price//12
               temp.add(""+(stock * cogs));//stock amount//13
               temp.add(""+(months>0 ? qty/months : 0));//qty month//14
               temp.add(""+(months>0 ? sales/months : months));//sales month//15
               temp.add(""+(weeks>0 ? qty/weeks : 0));//qty week//16
               temp.add(""+(weeks>0 ? sales/weeks : 0));//qty week//17
               
               result.add(temp);
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    
     public static Vector getSalesByGolPriceReport(int start, int recordToGet, Date startDate, Date endDate, String groupCat, 
            String golPrice, int orderBy, int sortType,String loc){
        
        String sql = "(select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as itemid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as itemcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" as barcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as itemname, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as cogs, "+
                " sum(pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                "*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as sales,"+
                " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+" as golprice "+
                " from "+DbItemMaster.DB_ITEM_MASTER+" im"+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where to_days(ps.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"')"+
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
                if(golPrice!=null && golPrice.length()>0){
                    sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }

                }
        
                sql = sql + " and (ps."+DbSales.colNames[DbSales.COL_TYPE]+"=0 or ps."+DbSales.colNames[DbSales.COL_TYPE]+"=1)";
                
                if(loc != null && loc.length() > 0){
                    sql = sql + " and ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" in ("+loc+")";
                }

                sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+","+
                        " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE];
        
                sql = sql + ") union ("+  
        
                "select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+"  as itemid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as itemcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" as barcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as itemname, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as cogs, "+
                " sum(-1 * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum(-1 * ((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                "*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")) as sales,"+
                " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+" as golprice "+
                " from "+DbItemMaster.DB_ITEM_MASTER+" im"+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where to_days(ps.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"')"+
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
                if(golPrice!=null && golPrice.length()>0){
                    sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }

                }
        
                sql = sql + " and (ps."+DbSales.colNames[DbSales.COL_TYPE]+"=2 or ps."+DbSales.colNames[DbSales.COL_TYPE]+"=3)";
                
                if(loc != null && loc.length() > 0){
                    sql = sql + " and ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" in ("+loc+")";
                }

                sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+","+
                        " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+
                ")";
                        //end union
        
        String sqlGabung = "select itemid, itemcode, barcode, itemname, cogs, sum(qty) as qt, sum(sales) as sel, golprice from ("+sql+") as tabel group by itemid, golprice";
                
        //order by code
        if(orderBy==0){
            sqlGabung = sqlGabung + " order by itemcode";
        }
        //name
        else if(orderBy==1){
            sqlGabung = sqlGabung + " order by itemname";
        }
        //sales qty
        else if(orderBy==2){
            sqlGabung = sqlGabung + " order by qt";//qty";
        }
        //sales amount
        else{
            sqlGabung = sqlGabung + " order by sel";//sales";           
        }
        
        if(sortType==1){
            sqlGabung = sqlGabung + " desc ";
        }
        
        if(recordToGet!=0){
            sqlGabung = sqlGabung + " limit "+start+","+recordToGet;
        }
        
        long dayx = DateCalc.dayDifference(startDate, endDate) + 1;
        double days = Double.parseDouble(""+dayx);
        double monthDays = 30;
        double months = days/monthDays;
        double weeks = days/7;
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               Vector temp = new Vector();
               
               long itemId = rs.getLong(1);
               temp.add(""+itemId);//itemid
               temp.add(rs.getString(2));//code
               temp.add(rs.getString(3));//barcode
               temp.add(rs.getString(4));//name
               double cogs = rs.getDouble(5);
               temp.add(""+cogs);//cogs
               double qty = rs.getDouble(6);
               temp.add(""+qty);//qty
               double sales = rs.getDouble(7);
               temp.add(""+sales);//sales
               temp.add(""+rs.getString(8));//gol_price
               
               Vector tempx = DbVendorItem.list(0,1, DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+"="+itemId, "");
               double lastPrice = 0;
               if(tempx!=null && tempx.size()>0){
                   VendorItem vi = (VendorItem)tempx.get(0);
                   temp.add(""+vi.getLastPrice());//last price//9
                   lastPrice = vi.getLastPrice();
               }
               else{
                   temp.add("0");//last price//9
               }
               
               double price = DbPriceType.getPrice(1, golPrice, itemId);
               temp.add(""+price);//selling price//10
               temp.add(""+((lastPrice>0) ? ((price-lastPrice)/lastPrice)*100 : 0));//margin//11
               //double stock = getLastStock(itemId);
               double stock = DbStock.getCount("item_master_id="+itemId+" and status='Approved'");//getLastStock(itemId);
               temp.add(""+stock);//selling price//12
               temp.add(""+(stock * cogs));//stock amount//13
               temp.add(""+(months>0 ? qty/months : 0));//qty month//14
               temp.add(""+(months>0 ? sales/months : months));//sales month//15
               temp.add(""+(weeks>0 ? qty/weeks : 0));//qty week//16
               temp.add(""+(weeks>0 ? sales/weeks : 0));//qty week//17
               
               result.add(temp);
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    
    public static int getCountSalesByGolPriceReport(Date startDate, Date endDate, String groupCat, String golPrice){
        
        String sql = "select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " from "+DbItemMaster.DB_ITEM_MASTER+" im"+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where to_days(ps.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"')"+
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
        if(golPrice!=null && golPrice.length()>0){
            sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
        }
        
        if(groupCat!=null && groupCat.length()>0){
            StringTokenizer strTok = new StringTokenizer(groupCat, ",");
            Vector temp = new Vector();
            while(strTok.hasMoreElements()){
                temp.add((String)strTok.nextToken());
            }
            String grId = (String)temp.get(0);
            String ctId = (String)temp.get(1);
            
            if(!grId.equals("0")){
                sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
            }
            
            if(!ctId.equals("0")){
                sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
            }
            
        }
        
        sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+","+
                " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE];
        
        CONResultSet crs = null;
        int result = 0;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               result = result + 1;
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
     public static int getCountSalesByGolPriceReport(Date startDate, Date endDate, String groupCat, String golPrice,String loc){
        
        String sql = "select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " from "+DbItemMaster.DB_ITEM_MASTER+" im"+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where to_days(ps.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"')"+
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
        if(golPrice!=null && golPrice.length()>0){
            sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
        }
        
        if(loc != null && loc.length() > 0){
                    sql = sql + " and ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" in ("+loc+")";
                }
        
        if(groupCat!=null && groupCat.length()>0){
            StringTokenizer strTok = new StringTokenizer(groupCat, ",");
            Vector temp = new Vector();
            while(strTok.hasMoreElements()){
                temp.add((String)strTok.nextToken());
            }
            String grId = (String)temp.get(0);
            String ctId = (String)temp.get(1);
            
            if(!grId.equals("0")){
                sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
            }
            
            if(!ctId.equals("0")){
                sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
            }
            
        }
        
        sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+","+
                " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE];
        
        CONResultSet crs = null;
        int result = 0;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               result = result + 1;
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static Vector getSalesPromotionReport(int start, int recordToGet, Date startDate, Date endDate, String groupCat, 
            String golPrice, long locationId, int orderBy, int sortType){
        
        String sql =                 
                "(select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as itemid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as itemcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" as itembarcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as itemname, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as itemcogs, "+
                " sum(pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                " *pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as sales,"+
                " p."+DbPromotion.colNames[DbPromotion.COL_START_DATE]+" as startdate, "+
                " p."+DbPromotion.colNames[DbPromotion.COL_END_DATE]+" as enddate, "+
                " pi."+DbPromotionItem.colNames[DbPromotionItem.COL_DISCOUNT_PERCENT]+ " as discpercent, "+
                " pi."+DbPromotionItem.colNames[DbPromotionItem.COL_DISCOUNT_VALUE]+" as discval, "+
                " sum(pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as hpp, "+
                " p."+DbPromotion.colNames[DbPromotion.COL_PROMOTION_ID]+" as promid "+        
                " FROM "+DbPromotion.DB_POS_PROMOTION+" p "+
                " inner join "+DbPromotionItem.DB_POS_PROMOTION_ITEM+" pi "+
                " on p."+DbPromotion.colNames[DbPromotion.COL_PROMOTION_ID]+
                " =pi."+DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ID]+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" im "+
                " on pi."+DbPromotionItem.colNames[DbPromotionItem.COL_ITEM_MASTER_ID]+
                " =im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where (ps.type=0 or ps.type=1) "+                
                " and (ps.date between p.start_date and p.end_date) "+
                " and ((p.start_date between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"' "+
                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') "+
                " or (p.end_date between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"' "+
                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')) ";
                
                if(locationId!=0){
                    sql = sql + " and loc.location_id="+locationId;
                }
        
                if(golPrice!=null && golPrice.length()>0){
                    sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }

                }
        
                sql = sql + " group by p.promotion_id, pi.item_master_id";
                sql = sql + ") union ("+  
                
                "select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as itemid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as itemcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" as itembarcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as itemname, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as itemcogs, "+
                " sum(-1*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum(-1*((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                " *pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")) as sales,"+
                " p."+DbPromotion.colNames[DbPromotion.COL_START_DATE]+" as startdate, "+
                " p."+DbPromotion.colNames[DbPromotion.COL_END_DATE]+" as enddate, "+
                " pi."+DbPromotionItem.colNames[DbPromotionItem.COL_DISCOUNT_PERCENT]+ " as discpercent, "+
                " pi."+DbPromotionItem.colNames[DbPromotionItem.COL_DISCOUNT_VALUE]+" as discval, "+
                " sum(-1 * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as hpp, "+ 
                " p."+DbPromotion.colNames[DbPromotion.COL_PROMOTION_ID]+" as promid "+                
                " FROM "+DbPromotion.DB_POS_PROMOTION+" p "+
                " inner join "+DbPromotionItem.DB_POS_PROMOTION_ITEM+" pi "+
                " on p."+DbPromotion.colNames[DbPromotion.COL_PROMOTION_ID]+
                " =pi."+DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ID]+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" im "+
                " on pi."+DbPromotionItem.colNames[DbPromotionItem.COL_ITEM_MASTER_ID]+
                " =im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where (ps.type=2 or ps.type=3) "+                
                " and (ps.date between p.start_date and p.end_date) "+
                " and ((p.start_date between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"' "+
                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') "+
                " or (p.end_date between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"' "+
                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')) ";
                
                if(locationId!=0){
                    sql = sql + " and loc.location_id="+locationId;
                }
        
                if(golPrice!=null && golPrice.length()>0){
                    sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }

                }
        
                sql = sql + " group by p.promotion_id, pi.item_master_id"+
                        
                ")";
                
                        //end union
                
        String sqlGabung = "select itemid, itemcode, itembarcode, itemname, itemcogs, sum(qty) as qt, " +
                "sum(sales) as sel, startdate, enddate, discpercent, discval, " +
                "sum(hpp) hp, promid from ("+sql+") as tabel group by promid, itemid";        
        
        //order by code
        if(orderBy==0){
            sqlGabung = sqlGabung + " order by itemcode";//+DbItemMaster.colNames[DbItemMaster.COL_CODE];
        }
        //name
        else if(orderBy==1){
            sqlGabung = sqlGabung + " order by itemname";//+DbItemMaster.colNames[DbItemMaster.COL_NAME];
        }
        //sales qty
        else if(orderBy==2){
            sqlGabung = sqlGabung + " order by qt";
        }
        //sales amount
        else{
            sqlGabung = sqlGabung + " order by sel";
        }
        
        if(sortType==1){
            sqlGabung = sqlGabung + " desc ";
        }
        
        if(recordToGet!=0){
            sqlGabung = sqlGabung + " limit "+start+","+recordToGet;
        }
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               Vector temp = new Vector();
               
               long itemId = rs.getLong(1);
               temp.add(""+itemId);//itemid
               temp.add(rs.getString(2));//code
               temp.add(rs.getString(3));//barcode
               temp.add(rs.getString(4));//name
               double cogs = rs.getDouble(5);
               temp.add(""+cogs);//cogs
               double qty = rs.getDouble(6);
               temp.add(""+qty);//qty
               double sales = rs.getDouble(7);
               temp.add(""+sales);//sales
               temp.add(""+JSPFormater.formatDate(rs.getDate(8),"yyyy-MM-dd"));//start date
               temp.add(""+JSPFormater.formatDate(rs.getDate(9),"yyyy-MM-dd"));//end date
               temp.add(""+rs.getDouble(10));//discon percent
               temp.add(""+rs.getDouble(11));//discon amount
               
               Vector tempx = DbVendorItem.list(0,1, DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+"="+itemId, "");
               double lastPrice = 0;
               if(tempx!=null && tempx.size()>0){
                   VendorItem vi = (VendorItem)tempx.get(0);
                   temp.add(""+vi.getLastPrice());//last price//12
                   lastPrice = vi.getLastPrice();
               }
               else{
                   temp.add("0");//last price//12
               }
               
               double price = DbPriceType.getPrice(1, golPrice, itemId);
               temp.add(""+price);//selling price//13
               temp.add(""+((lastPrice>0) ? ((price-lastPrice)/lastPrice)*100 : 0));//margin//14
               //double stock = getLastStock(itemId);
               double stock = DbStock.getCount("item_master_id="+itemId+" and status='Approved'");//getLastStock(itemId);
               temp.add(""+stock);//selling price//15
               temp.add(""+(stock * cogs));//stock amount//16
               
               double hpp = rs.getDouble(12);
               temp.add(""+hpp);//cogs//17
               
               result.add(temp);
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static int getCountSalesPromotionReport(Date startDate, Date endDate, String groupCat, 
            String golPrice, long locationId){
        
        String sql =                 
                " select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+","+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+", "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+", "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+", "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+", "+
                " sum(pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                " *pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as sales,"+
                " p."+DbPromotion.colNames[DbPromotion.COL_START_DATE]+", "+
                " p."+DbPromotion.colNames[DbPromotion.COL_END_DATE]+", "+
                " pi."+DbPromotionItem.colNames[DbPromotionItem.COL_DISCOUNT_PERCENT]+ ", "+
                " pi."+DbPromotionItem.colNames[DbPromotionItem.COL_DISCOUNT_VALUE]+
                " FROM "+DbPromotion.DB_POS_PROMOTION+" p "+
                " inner join "+DbPromotionItem.DB_POS_PROMOTION_ITEM+" pi "+
                " on p."+DbPromotion.colNames[DbPromotion.COL_PROMOTION_ID]+
                " =pi."+DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ID]+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" im "+
                " on pi."+DbPromotionItem.colNames[DbPromotionItem.COL_ITEM_MASTER_ID]+
                " =im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where (ps.type=0 or ps.type=1) "+                
                " and (ps.date between p.start_date and p.end_date) "+
                " and ((p.start_date between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"' "+
                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') "+
                " or (p.end_date between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"' "+
                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')) ";
                
                if(locationId!=0){
                    sql = sql + " and loc.location_id="+locationId;
                }
        
                if(golPrice!=null && golPrice.length()>0){
                    sql = sql + " and loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+"='"+golPrice+"'";
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }

                }
        
                sql = sql + " group by p.promotion_id, pi.item_master_id";
        
        CONResultSet crs = null;
        int result = 0;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               result = result + 1;
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static double getLastStock(long itemId){
        String sql = "SELECT qty FROM vw_items_stock v where item_master_id="+itemId;
        
        CONResultSet crs = null;
        double result = 0;
        
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               result = rs.getDouble(1);               
            }
           
        }catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static Vector getSalesBySupplierReport(Date startDate, Date endDate, String groupCat, 
            long vendorId, long locationId, int orderBy, int sortType){
        
        String sql = "(select ps.type,im."+DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID]+" as venid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as itemid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as itemcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" as barcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as itemname, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as cogs, "+
                " sum(pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum(pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                "*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as hpp, "+
                " sum((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                "*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as sales,"+
                " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+" as golprice "+
                " from "+DbItemMaster.DB_ITEM_MASTER+" im"+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where to_days(ps.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"')"+
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
                if(vendorId!=0){
                    sql = sql + " and im.default_vendor_id="+vendorId;
                }
                if(locationId!=0){
                    sql = sql + " and ps.location_id="+locationId;
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }
                }
        
                sql = sql + " and (ps."+DbSales.colNames[DbSales.COL_TYPE]+"=0 or ps."+DbSales.colNames[DbSales.COL_TYPE]+"=1)";

                sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];
        
                sql = sql + ") union ("+  
        
                "select ps.type,im."+DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID]+" as venid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+"  as itemid,"+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as itemcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" as barcode, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as itemname, "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as cogs, "+
                " sum(-1 * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as qty, "+
                " sum(-1 * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                "*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as hpp, "+
                " sum(-1 * ((pd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+
                "*pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")"+
                " -pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")) as sales,"+
                " loc."+DbLocation.colNames[DbLocation.COL_GOL_PRICE]+" as golprice "+
                " from "+DbItemMaster.DB_ITEM_MASTER+" im"+
                " inner join "+DbSalesDetail.DB_SALES_DETAIL+" pd on "+
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " = pd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+
                " inner join "+DbSales.DB_SALES+" ps on "+
                " pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                " =ps."+DbSales.colNames[DbSales.COL_SALES_ID]+
                " inner join "+DbLocation.DB_LOCATION+" loc on "+
                " ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+
                " = loc."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+
                " where to_days(ps.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"')"+
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
                if(vendorId!=0){
                    sql = sql + " and im.default_vendor_id="+vendorId;
                }
                if(locationId!=0){
                    sql = sql + " and ps.location_id="+locationId;
                }

                if(groupCat!=null && groupCat.length()>0){
                    StringTokenizer strTok = new StringTokenizer(groupCat, ",");
                    Vector temp = new Vector();
                    while(strTok.hasMoreElements()){
                        temp.add((String)strTok.nextToken());
                    }
                    String grId = (String)temp.get(0);
                    String ctId = (String)temp.get(1);

                    if(!grId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+grId;
                    }

                    if(!ctId.equals("0")){
                        sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+ctId;
                    }

                }
        
                sql = sql + " and (ps."+DbSales.colNames[DbSales.COL_TYPE]+"=2 or ps."+DbSales.colNames[DbSales.COL_TYPE]+"=3)";

                sql = sql + " group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                        
                ")";
                        //end union
        
        String sqlGabung = "select itemid, itemcode, barcode, itemname, cogs, sum(qty) as qt, sum(sales) as sel, venid, sum(hpp) as hp  from ("+sql+") as tabel group by itemid";
                
        //order by code
        if(orderBy==0){
            sqlGabung = sqlGabung + " order by itemcode";//+DbItemMaster.colNames[DbItemMaster.COL_CODE];
        }
        //name
        else if(orderBy==1){
            sqlGabung = sqlGabung + " order by itemname";//+DbItemMaster.colNames[DbItemMaster.COL_NAME];
        }
        //sales qty
        else if(orderBy==2){
            sqlGabung = sqlGabung + " order by qt";//qty";
        }
        //sales amount
        else{
            sqlGabung = sqlGabung + " order by sel";//sales";           
        }
        
        if(sortType==1){
            sqlGabung = sqlGabung + " desc ";
        }
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               Vector temp = new Vector();
               
               long itemId = rs.getLong(1);
               temp.add(""+itemId);//itemid
               temp.add(rs.getString(2));//code
               temp.add(rs.getString(3));//barcode
               temp.add(rs.getString(4));//name
               double cogs = rs.getDouble(5);
               temp.add(""+cogs);//cogs
               double qty = rs.getDouble(6);
               temp.add(""+qty);//qty
               double sales = rs.getDouble(7);
               temp.add(""+sales);//sales
               temp.add(""+rs.getLong(8));//vendor
               double hpp = rs.getDouble(9);
               temp.add(""+hpp);//sales
               
               Vector tempx = DbVendorItem.list(0,1, DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+"="+itemId, "");
               double lastPrice = 0;
               if(tempx!=null && tempx.size()>0){
                   VendorItem vi = (VendorItem)tempx.get(0);
                   temp.add(""+vi.getLastPrice());//last price//10
                   lastPrice = vi.getLastPrice();
               }
               else{
                   temp.add("0");//last price//9
               }
               
               result.add(temp);
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static Vector getTransactionVendor(int start, int recordToGet, Date startDate, Date endDate){
        
        String sql = "select distinct v.* from pos_sales_detail sd " +
                " inner join pos_sales ps on sd.sales_id=ps.sales_id "+
                " inner join pos_item_master im on im.item_master_id=sd.product_master_id "+
                " inner join vendor v on v.vendor_id = im.default_vendor_id "+
                " where to_days(ps.date) "+
                " between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') " +
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')" +
                " order by v.name ";
        
                if(recordToGet!=0){
                    sql = sql + " limit "+start+", "+recordToGet;
                }
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               Vendor v = new Vendor();
               DbVendor.resultToObject(rs, v);
               result.add(v);
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
            
    }
    
    public static int getCountTransactionVendor(Date startDate, Date endDate){
        
        String sql = "select distinct v.vendor_id from pos_sales_detail sd " +
                " inner join pos_sales ps on sd.sales_id=ps.sales_id "+
                " inner join pos_item_master im on im.item_master_id=sd.product_master_id "+
                " inner join vendor v on v.vendor_id = im.default_vendor_id "+
                " where to_days(ps.date) "+
                " between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') " +
                " and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
        
        CONResultSet crs = null;
        int result = 0;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
               result = result + 1;
            }
           
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
            
    }
    
    

}
