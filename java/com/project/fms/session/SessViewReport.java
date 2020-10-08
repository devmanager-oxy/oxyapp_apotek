/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.I_Project;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;


/**
 *
 * @author Roy Andika
 */
public class SessViewReport {
    
    
    public static double getAmountInPeriod(long periodId, long coaId, int level, String accountGroup){

        double result = 0;

        //debet credit position
        boolean isDebet = false;
        if (accountGroup.equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                accountGroup.equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                accountGroup.equals(I_Project.ACC_GROUP_EXPENSE) ||
                accountGroup.equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

            isDebet = true;

        }

        String sql = "";

        if (isDebet) {
            sql = "select amount from fin_gl_detail_debet_coa_level1 where period_id = "+periodId+" and coa_level1_id ="+coaId;
        } else {
            sql = "select amount from fin_gl_detail_debet_coa_level1 where period_id = "+periodId+" and coa_level1_id ="+coaId;
        }
        
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

}
