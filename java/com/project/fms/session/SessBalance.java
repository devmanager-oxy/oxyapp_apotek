/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

import com.project.I_Project;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.fms.I_Fms;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.general.DbHistoryUser;
import com.project.general.HistoryUser;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Roy
 */
public class SessBalance {
    
    public static void processBalance(long periodId,long segmentId,long userId){
        
        Periode p = new Periode();
        User user = new User();
        try{
            user = DbUser.fetch(userId);
        }catch(Exception e){}        
        try{
            p = DbPeriode.fetchExc(periodId);
            if(p.getOID() != 0){
                String tblName = "";
                if(p.getTableName().equals(I_Project.GL)){
                    tblName = I_Fms.tblGlBalance;
                }else if(p.getTableName().equals(I_Project.GL_2015)){
                    tblName = I_Fms.tblGlBalance2015;
                }else if(p.getTableName().equals(I_Project.GL_2016)){
                    tblName = I_Fms.tblGlBalance2016;
                }else if(p.getTableName().equals(I_Project.GL_2017)){
                    tblName = I_Fms.tblGlBalance2017;
                }else if(p.getTableName().equals(I_Project.GL_2018)){
                    tblName = I_Fms.tblGlBalance2018;
                }else if(p.getTableName().equals(I_Project.GL_2019)){
                    tblName = I_Fms.tblGlBalance2019;
                }else if(p.getTableName().equals(I_Project.GL_2020)){
                    tblName = I_Fms.tblGlBalance2020;
                }
            }
            
            
        }catch(Exception e){}
    }
    
    public static void deleteBalance(String tblName,long periodId,String periodName,long segmentId,User user){ 
        CONResultSet dbrs = null;
        try{            
            if(tblName != null && tblName.compareTo("") != 0){
                String sql= "delete from "+tblName+" where balance_type = 1 and period_id = "+periodId;
            
                if(segmentId != 0){
                    sql = sql + " and segment1Id "+segmentId;
                }
                int i = CONHandler.execUpdate(sql);
                if(i != 0){ // insert ke history
                    HistoryUser hisUser = new HistoryUser();
                    hisUser.setUserId(user.getOID());
                    hisUser.setEmployeeId(user.getEmployeeId());
                    hisUser.setRefId(periodId);
                    hisUser.setDescription("Delete Balance Opening "+periodName);
                    hisUser.setType(DbHistoryUser.TYPE_BALANCE_GL);
                    hisUser.setDate(new Date());
                    try {
                        DbHistoryUser.insertExc(hisUser);
                    } catch (Exception e) {
                    }
                }
            }
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static Vector listBalance(Periode p,long segmentId){
        
        Vector result = new Vector();
         if(p.getOID() != 0){
             
            String tblName = "";
            String tblNameDetail = "";
            
            if(p.getTableName().equals(I_Project.GL)){
                tblName = I_Fms.tblGl;
                tblNameDetail = I_Fms.tblGlDetail;
            }else if(p.getTableName().equals(I_Project.GL_2015)){
                tblName = I_Fms.tblGl2015;
                tblNameDetail = I_Fms.tblGlDetail2015;
            }else if(p.getTableName().equals(I_Project.GL_2016)){
                tblName = I_Fms.tblGl2016;
                tblNameDetail = I_Fms.tblGlDetail2016;
            }else if(p.getTableName().equals(I_Project.GL_2017)){
                tblName = I_Fms.tblGl2017;
                tblNameDetail = I_Fms.tblGlDetail2017;
            }else if(p.getTableName().equals(I_Project.GL_2018)){
                tblName = I_Fms.tblGl2018;
                tblNameDetail = I_Fms.tblGlDetail2018;
            }else if(p.getTableName().equals(I_Project.GL_2019)){
                tblName = I_Fms.tblGl2019;
                tblNameDetail = I_Fms.tblGlDetail2019;
            }else if(p.getTableName().equals(I_Project.GL_2020)){
                tblName = I_Fms.tblGl2020;
                tblNameDetail = I_Fms.tblGlDetail2020;
            }
                
            if(tblName != null && tblName.compareTo("") != 0 && tblNameDetail != null && tblNameDetail.compareTo("") != 0){
                    
                String sql = "";
                    
                    
                    
                
            }
            
         }
         return result;
    }
}
