/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.postransaction.receiving.*;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
/**
 *
 * @author Roy Andika
 */
public class SessItemMaster {
    public static boolean checkBarcode(String barcode, long oidItemMaster) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DbItemMaster.DB_ITEM_MASTER + " WHERE "
                    + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " = '" + barcode + "'"
                    + " and item_master_id!=" + oidItemMaster;

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

}
