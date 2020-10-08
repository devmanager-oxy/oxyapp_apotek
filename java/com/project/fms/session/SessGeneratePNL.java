/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import com.project.I_Project;
import com.project.fms.I_Fms;
import com.project.fms.journal.BalanceGl;
import com.project.fms.journal.DbBalanceGl;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.fms.transaction.DbGlDetail;
import java.util.Vector;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy
 */
public class SessGeneratePNL {

    public static void genPNL(long segmentId, long periodId) {
        Periode p = new Periode();
        try {
            p = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
        }
        
        if(p.getOID() != 0){ // 
            clearGenerate(segmentId,p);            
            getGenerate(segmentId,p);
        }

    }
    
    public static void genPNL(long segmentId, long periodId,long userId) {
        Periode p = new Periode();
        try {
            p = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
        }
        
        if(p.getOID() != 0){ // 
            clearGenerate(segmentId,p,userId);            
            getGenerate(segmentId,p,userId);
        }

    }
    
    public static void clearGenerate(long segment1Id, Periode p){
        CONResultSet dbrs = null;
        try{
            String sql = "delete from balance_gl where period_id="+p.getOID()+" and "+DbBalanceGl.colNames[DbBalanceGl.CL_BALANCE_TYPE]+" = "+DbBalanceGl.TYPE_PNL;
            
            if(segment1Id != 0){
                sql = sql + " and segment_1_id="+segment1Id;
            }
            CONHandler.execUpdate(sql);
            
        }catch(Exception e){}        
        finally {
            CONResultSet.close(dbrs);
        }
        
    }
    
    public static void clearGenerate(long segment1Id, Periode p,long userId){
        CONResultSet dbrs = null;
        try{
            String sql = "delete from balance_gl where period_id="+p.getOID()+" and "+DbBalanceGl.colNames[DbBalanceGl.CL_BALANCE_TYPE]+" = "+DbBalanceGl.TYPE_PNL+" and user_id = "+userId;
            
            if(segment1Id != 0){
                sql = sql + " and segment_1_id="+segment1Id;
            }
            CONHandler.execUpdate(sql);
            
        }catch(Exception e){}        
        finally {
            CONResultSet.close(dbrs);
        }
        
    }

    public static Vector getGenerate(long segment1Id, Periode p) {
        CONResultSet dbrs = null;
        Vector lists = new Vector();

        Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
        Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

        try {
            String sql = "";
            if (p.getTableName().equals(I_Project.GL)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            } else if (p.getTableName().equals(I_Project.GL_2015)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl_2015 g inner join gl_detail_2015 gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            } else if (p.getTableName().equals(I_Project.GL_2016)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl_2016 g inner join gl_detail_2016 gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            }

            if (segment1Id != 0) {
                sql = sql + " and gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] + " = " + segment1Id;
            }

            sql = sql + " group by gd.segment1_id,gd.coa_id ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                BalanceGl bg = new BalanceGl();

                String accGroup = rs.getString("account_group");
                double debet = rs.getDouble("debet");
                double credit = rs.getDouble("credit");
                long coaId = rs.getLong("coa_id");
                String code = rs.getString("code");
                int level = rs.getInt("level");
                long refId = rs.getLong("ref_id");
                long segment1 = rs.getLong("segment1_id");

                boolean isDebet = false;
                if (accGroup.equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                        accGroup.equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                        accGroup.equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                        accGroup.equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                        accGroup.equals(I_Project.ACC_GROUP_EXPENSE) ||
                        accGroup.equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                    isDebet = true;
                }
                double amount = 0;

                if (isDebet) {
                    amount = debet - credit;
                } else {
                    amount = credit - debet;
                }
                bg.setPeriodId(p.getOID());
                bg.setAmount(amount);                
                bg.setCoaId(coaId);
                bg.setSegment1Id(segment1);
                bg.setBalanceType(DbBalanceGl.TYPE_PNL);

                if (coaLabaLalu.getCode().equals(code) || coaLabaBerjalan.getCode().equals(code)) {

                    bg.setCoaLevel7Id(coaId);
                    bg.setCoaLevel6Id(coaId);
                    bg.setCoaLevel5Id(coaId);
                    bg.setCoaLevel4Id(coaId);
                    bg.setCoaLevel3Id(coaId);
                    bg.setCoaLevel2Id(coaId);
                    bg.setCoaLevel1Id(coaId);

                } else {
                    Coa coa = new Coa();
                    switch (level) {
                        case 1:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(coaId);
                            bg.setCoaLevel3Id(coaId);
                            bg.setCoaLevel2Id(coaId);
                            bg.setCoaLevel1Id(coaId);
                            break;
                        case 2:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(coaId);
                            bg.setCoaLevel3Id(coaId);
                            bg.setCoaLevel2Id(coaId);
                            bg.setCoaLevel1Id(refId);
                            break;
                        case 3:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(coaId);
                            bg.setCoaLevel3Id(coaId);
                            bg.setCoaLevel2Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                        case 4:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(coaId);
                            bg.setCoaLevel3Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel2Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                        case 5:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel3Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel2Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                        case 6:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel4Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel3Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel2Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                        case 7:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel5Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel4Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel3Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel2Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                    }
                }
                
                try{
                    DbBalanceGl.insertExc(bg);
                }catch(Exception e){}
            }
            rs.close();

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return lists;

    }
    
    public static Vector getGenerate(long segment1Id, Periode p,long userId) {
        CONResultSet dbrs = null;
        Vector lists = new Vector();

        Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
        Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

        try {
            String sql = "";
            if (p.getTableName().equals(I_Project.GL)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            } else if (p.getTableName().equals(I_Project.GL_2015)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl_2015 g inner join gl_detail_2015 gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            } else if (p.getTableName().equals(I_Project.GL_2016)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl_2016 g inner join gl_detail_2016 gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            }

            if (segment1Id != 0) {
                sql = sql + " and gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] + " = " + segment1Id;
            }

            sql = sql + " group by gd.segment1_id,gd.coa_id ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                BalanceGl bg = new BalanceGl();

                String accGroup = rs.getString("account_group");
                double debet = rs.getDouble("debet");
                double credit = rs.getDouble("credit");
                long coaId = rs.getLong("coa_id");
                String code = rs.getString("code");
                int level = rs.getInt("level");
                long refId = rs.getLong("ref_id");
                long segment1 = rs.getLong("segment1_id");

                boolean isDebet = false;
                if (accGroup.equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                        accGroup.equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                        accGroup.equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                        accGroup.equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                        accGroup.equals(I_Project.ACC_GROUP_EXPENSE) ||
                        accGroup.equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                    isDebet = true;
                }
                double amount = 0;

                if (isDebet) {
                    amount = debet - credit;
                } else {
                    amount = credit - debet;
                }
                bg.setPeriodId(p.getOID());
                bg.setAmount(amount);
                bg.setCoaId(segment1Id);
                bg.setCoaId(coaId);
                bg.setSegment1Id(segment1);
                bg.setBalanceType(DbBalanceGl.TYPE_PNL);
                bg.setUserId(userId);

                if (coaLabaLalu.getCode().equals(code) || coaLabaBerjalan.getCode().equals(code)) {

                    bg.setCoaLevel7Id(coaId);
                    bg.setCoaLevel6Id(coaId);
                    bg.setCoaLevel5Id(coaId);
                    bg.setCoaLevel4Id(coaId);
                    bg.setCoaLevel3Id(coaId);
                    bg.setCoaLevel2Id(coaId);
                    bg.setCoaLevel1Id(coaId);

                } else {
                    Coa coa = new Coa();
                    switch (level) {
                        case 1:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(coaId);
                            bg.setCoaLevel3Id(coaId);
                            bg.setCoaLevel2Id(coaId);
                            bg.setCoaLevel1Id(coaId);
                            break;
                        case 2:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(coaId);
                            bg.setCoaLevel3Id(coaId);
                            bg.setCoaLevel2Id(coaId);
                            bg.setCoaLevel1Id(refId);
                            break;
                        case 3:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(coaId);
                            bg.setCoaLevel3Id(coaId);
                            bg.setCoaLevel2Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                        case 4:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(coaId);
                            bg.setCoaLevel3Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel2Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                        case 5:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(coaId);
                            bg.setCoaLevel4Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel3Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel2Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                        case 6:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(coaId);
                            bg.setCoaLevel5Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel4Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel3Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel2Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                        case 7:
                            bg.setCoaLevel7Id(coaId);
                            bg.setCoaLevel6Id(refId);
                            try {
                                coa = DbCoa.fetchExc(refId);
                                bg.setCoaLevel5Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel4Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel3Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel2Id(coa.getAccRefId());
                                coa = DbCoa.fetchExc(coa.getAccRefId());
                                bg.setCoaLevel1Id(coa.getAccRefId());
                            } catch (Exception e) {
                            }
                            break;
                    }
                }
                
                try{
                    DbBalanceGl.insertExc(bg);
                }catch(Exception e){}
            }
            rs.close();

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return lists;

    }
    
    
    public static double getCoaBalancePNLMTD(Coa coa, long segment1Id, Periode periode){   
        
        double result = 0;        
        CONResultSet crs = null;
        
        try {
            
            String sql = "select sum("+DbBalanceGl.colNames[DbBalanceGl.CL_AMOUNT]+") from "+DbBalanceGl.DB_BALANCE_GL+" where "+DbBalanceGl.colNames[DbBalanceGl.CL_PERIOD_ID]+" = "+periode.getOID();
            
            if(coa.getLevel() == 1){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_1_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 2){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_2_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 3){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_3_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 4){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_4_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 5){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_5_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 6){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_6_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 7){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_7_ID]+" = "+coa.getOID();
            }
            
            if (segment1Id != 0) {
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_SEGMENT_1_ID]+" = "+segment1Id;
            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    public static double getIsCoaBalance(Vector coas, Vector periods, long segment1Id) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);            
            result = result + getIsCoaBalance(coas, segment1Id, p);                 
            if(result != 0){
                return result;
            }
        }
        return result;
    }
    
    public static double getIsCoaBalance(Vector listCoa,long segment1Id,Periode periode) {
        double result = 0;        
        Coa coa = new Coa();        
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);                               
                result = result + getCoaBalancePNLMTD(coa,segment1Id,periode);            
                if(result != 0){
                    return result;
                }
            }
        }
        return result;
    }
    
 /**
  * @LTB = Laba tahun berjalan
  * @param coa
  * @param segment1Id
  * @param p
  * @return
  */
    
    public static double getAmountLTB(Coa coa,long segment1Id, Periode p){
        CONResultSet crs = null;
        double result = 0;     
        String tbl = I_Fms.tblGlBalance;
        
        if(p.getTableName().equals(I_Project.GL)){
            tbl = I_Fms.tblGlBalance;
        }else if(p.getTableName().equals(I_Project.GL_2015)){
            tbl = I_Fms.tblGlBalance2015;            
        }else if(p.getTableName().equals(I_Project.GL_2016)){
            tbl = I_Fms.tblGlBalance2016;
        }else if(p.getTableName().equals(I_Project.GL_2017)){
            tbl = I_Fms.tblGlBalance2017;
        }else if(p.getTableName().equals(I_Project.GL_2018)){
            tbl = I_Fms.tblGlBalance2018;
        }else if(p.getTableName().equals(I_Project.GL_2019)){
            tbl = I_Fms.tblGlBalance2019;
        }else if(p.getTableName().equals(I_Project.GL_2020)){
            tbl = I_Fms.tblGlBalance2020;
        }else{
            tbl = I_Fms.tblGlBalance;
        }
        
        int year = p.getEndDate().getYear()+1900;
        
        try{            
            String sql = "select sum(b.amount) from "+DbPeriode.DB_PERIODE+" p inner join "+tbl+" b on p.periode_id = b.period_id where end_date >= '"+year+"-01-01 00:00:00' and end_date <= '"+JSPFormater.formatDate(p.getEndDate(),"yyyy-MM-dd")+" 23:59:59' ";
            
             if(coa.getLevel() == 1){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_1_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 2){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_2_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 3){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_3_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 4){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_4_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 5){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_5_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 6){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_6_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 7){
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_7_ID]+" = "+coa.getOID();
            }
            
            if (segment1Id != 0) {
                sql = sql + " and "+DbBalanceGl.colNames[DbBalanceGl.CL_SEGMENT_1_ID]+" = "+segment1Id;
            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    
}
