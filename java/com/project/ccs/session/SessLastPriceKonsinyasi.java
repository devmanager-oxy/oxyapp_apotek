/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;
import com.project.*;
import com.project.system.*;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.fms.transaction.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.ccs.postransaction.stock.*;

/**
 *
 * @author Roy
 */
public class SessLastPriceKonsinyasi {
    
    
     public static double getLastPrice(long locationId,long itemMasterId,Date endDate){
        
        CONResultSet crs = null;
        
        try{
            
            String sql = "select sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+" from "+DbSalesDetail.DB_SALES_DETAIL+" sd inner join "+
                    DbSales.DB_SALES+" s on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" = s."+DbSales.colNames[DbSales.COL_SALES_ID];
            
            String where = " to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") <= to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') ";
            
            if(locationId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where + " s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId;
            }
            
            if(itemMasterId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where + " sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = "+itemMasterId;
            }
            
            sql = sql +" where "+where+" order by s."+DbSales.colNames[DbSales.COL_DATE]+" desc,sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_DETAIL_ID]+" desc limit 0,1";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                double salesPrice = rs.getDouble(1);
                return salesPrice;
                
            }            
            return 0;
        }catch(Exception e){}
        finally{
            CONResultSet.close(crs);
        }
        return 0;
    }

}
