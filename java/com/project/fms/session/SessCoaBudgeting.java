
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;
import com.project.fms.master.Budget;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbCoaBudget;
import java.util.Vector;

/**
 *
 * @author Roy A.
 */
public class SessCoaBudgeting {
    
    public static Vector listBudgeting(long depId, int month, int year, String accountGroup){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "SELECT c."+DbCoa.colNames[DbCoa.COL_COA_ID]+" as coaId, "+
                    "c."+DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]+" as accountGroup, "+
                    "c."+DbCoa.colNames[DbCoa.COL_CODE]+" as code, "+
                    "c."+DbCoa.colNames[DbCoa.COL_NAME]+" as name, "+
                    "c."+DbCoa.colNames[DbCoa.COL_LEVEL]+" as level, "+
                    "c."+DbCoa.colNames[DbCoa.COL_STATUS]+" as status, "+
                    "budget."+DbCoaBudget.colNames[DbCoaBudget.CL_COA_BUDGET_ID]+" as coaBudgetId, "+
                    "budget."+DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT]+" as coaAmount, "+                    
                    "budget."+DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID]+" as coaDepartmentId, "+
                    "budget."+DbCoaBudget.colNames[DbCoaBudget.CL_DIVISION_ID]+" as coaDivisionId "+                    
                    " FROM "+DbCoa.DB_COA+" as c LEFT JOIN "+DbCoaBudget.DB_COA_BUDGET+" as budget ON "+
                    " c."+DbCoa.colNames[DbCoa.COL_COA_ID]+" = budget."+DbCoaBudget.colNames[DbCoaBudget.CL_COA_ID];                    
            
            String where = "";
                    
            if(depId != 0){        
               if(where.length() > 0)                   
                   where = where+" AND budget."+DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID]+" = "+depId;
               else
                   where = where+" budget."+DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID]+" = "+depId;    
            }
            
            if(where.length() > 0)                   
                where = where+" AND budget."+DbCoaBudget.colNames[DbCoaBudget.CL_BGT_YEAR]+" = "+year;
            else
                where = where+" budget."+DbCoaBudget.colNames[DbCoaBudget.CL_BGT_YEAR]+" = "+year;
            
            if(where.length() > 0)                   
                where = where+" AND budget."+DbCoaBudget.colNames[DbCoaBudget.CL_BGT_MONTH]+" = "+month;
            else
                where = where+" budget."+DbCoaBudget.colNames[DbCoaBudget.CL_BGT_MONTH]+" = "+month;
            
            if(accountGroup.length() > 0){
                if(where.length() > 0)                   
                    where = where+" AND c."+DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]+" = '"+accountGroup+"'";
                else
                    where = where+" c."+DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]+" = '"+accountGroup+"'";
            }
            
            if(where.length() > 0){
                sql = sql + " WHERE "+where;
            }
            
            Vector result = new Vector();
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()){
                
                Budget budget = new Budget();
                
                budget.setCoaId(rs.getLong("coaId"));
                budget.setAccoutGroup(rs.getString("accountGroup"));
                budget.setCode(rs.getString("code"));
                budget.setName(rs.getString("name"));
                budget.setLevel(rs.getInt("level"));
                budget.setStatus(rs.getString("status"));
                
                budget.setCoaBudgetId(rs.getLong("coaBudgetId"));
                budget.setCoaDepartmentId(rs.getLong("coaDepartmentId"));
                budget.setCoaDivisionId(rs.getLong("coaDivisionId"));
                budget.setAmmount(rs.getDouble("coaAmount"));
             
                result.add(budget);
            }
            
            return result;
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    
    
    public static Vector listBudgeting_2(Vector listCoa, long depId, int month, int year, String accountGroup){
        
        
        if(listCoa != null && listCoa.size() > 0){
            
            for(int i = 0 ; i < listCoa.size() ; i ++){
                
                
                
                
                
                
            }    
            
        }
        
        
        return null;
    }
    
    
    
    
}
