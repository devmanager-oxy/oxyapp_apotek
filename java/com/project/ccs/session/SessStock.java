// 
// Decompiled by Procyon v0.5.36
// 

package com.project.ccs.session;

import java.sql.ResultSet;
import com.project.main.db.CONResultSet;
import com.project.main.db.CONHandler;
import com.project.ccs.postransaction.stock.DbStock;

public class SessStock
{
    public static double getItemTotalStock(final long itemOID) {
        final String sql = " select sum(" + DbStock.colNames[3] + " * " + DbStock.colNames[12] + ") " + " from " + "pos_stock" + " where " + DbStock.colNames[6] + "= " + itemOID + " and " + DbStock.colNames[23] + "=" + DbStock.TYPE_NON_CONSIGMENT + " and status='APPROVED'";
        double result = 0.0;
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            final ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
        finally {
            CONResultSet.close(crs);
        }
        return result;
    }
}
