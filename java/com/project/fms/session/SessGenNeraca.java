/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

import com.project.fms.master.Periode;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.*;
import com.project.fms.journal.BalanceNeraca;
import com.project.fms.journal.DbBalanceNeraca;
import com.project.fms.master.Coa;
import com.project.fms.master.CoaOpeningBalanceLocation;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbCoaOpeningBalanceLocation;
import com.project.system.DbSystemProperty;
import com.project.util.*;
/**
 *
 * @author Roy
 */
public class SessGenNeraca { 
    
    public static synchronized Hashtable Neraca(Periode pLast,Periode p,long segmentId){
        
        DbBalanceNeraca.clearGenerate(0,pLast);
        DbBalanceNeraca.clearGenerate(0,p);
        
        if(pLast.getOID() !=0){
            NeracaBalance(pLast,segmentId);
        }
        if(p.getOID() != 0){
            NeracaBalance(p,segmentId);
        }
        
        Hashtable balancePrev = listNeraca(pLast.getOID(),segmentId);
        Hashtable balance = listNeraca(p.getOID(),segmentId);
        Hashtable result = new Hashtable();
        
        CONResultSet dbrs = null;
        try{
            String sql = "select coa_id,code,account_group,name,level,status,name from "+DbCoa.DB_COA+" where ( account_group = '"+I_Project.ACC_GROUP_LIQUID_ASSET+"' or account_group = '"+I_Project.ACC_GROUP_FIXED_ASSET+"' or account_group = '"+I_Project.ACC_GROUP_OTHER_ASSET+"' or account_group = '"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"' or account_group = '"+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES+"' or account_group = '"+I_Project.ACC_GROUP_EQUITY+"') ";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) { 
                SessNeraca sNeraca = new SessNeraca();
                long coaId = rs.getLong("coa_id");                
                int level = rs.getInt("level");
                String status = rs.getString("status");
                
                double balance1 = 0;
                double balance2 = 0;
                
                if(status.equalsIgnoreCase("HEADER")){
                    balance1 = getAmountInPeriod(pLast.getOID(), coaId,level,segmentId);
                    balance2 = getAmountInPeriod(p.getOID(), coaId,level,segmentId);                    
                }else{
                    
                    try{
                        balance1 = Double.parseDouble(String.valueOf(balancePrev.get(""+coaId)));
                    }catch(Exception e){}
                    
                    try{
                        balance2 = Double.parseDouble(String.valueOf(balance.get(""+coaId)));
                    }catch(Exception e){}                    
                }
                sNeraca.setBalancePrevious(balance1);
                sNeraca.setBalance(balance2);
                result.put(""+coaId,sNeraca);
            }
        
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }  
        return result;
    }
    
    public static void NeracaBalance(Periode p,long segment1Id){    
        
        CONResultSet dbrs = null;
        Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
        
        try {
            String sql = "";            
            String grp = " and ( c.account_group = '"+I_Project.ACC_GROUP_LIQUID_ASSET+"' or c.account_group = '"+I_Project.ACC_GROUP_FIXED_ASSET+"' or c.account_group = '"+I_Project.ACC_GROUP_OTHER_ASSET+"' or c.account_group = '"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"' or c.account_group = '"+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES+"' or c.account_group = '"+I_Project.ACC_GROUP_EQUITY+"') ";
            
            if(segment1Id != 0){
                grp = grp + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]+" = "+segment1Id;
            }
            
            if (p.getTableName().equals(I_Project.GL)) {
                sql = "select c.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id "+
                      " from coa c left join (select gd.coa_id as coa_id,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 "+grp+" group by gd.coa_id) gd on c.coa_id = gd.coa_id ";                
            } else if (p.getTableName().equals(I_Project.GL_2015)) {
                sql = "select c.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id "+
                      " from coa c left join (select gd.coa_id as coa_id,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl_2015 g inner join gl_detail_2015 gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 "+grp+" group by gd.coa_id) gd on c.coa_id = gd.coa_id ";                
            } else if (p.getTableName().equals(I_Project.GL_2016)) {
                sql = "select c.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id "+
                      " from coa c left join (select gd.coa_id as coa_id,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl_2016 g inner join gl_detail_2016 gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 "+grp+" group by gd.coa_id) gd on c.coa_id = gd.coa_id "; 
            }            
                  
            sql = sql+ " where c.status='POSTABLE' and ( c.account_group = '"+I_Project.ACC_GROUP_LIQUID_ASSET+"' or c.account_group = '"+I_Project.ACC_GROUP_FIXED_ASSET+"' or c.account_group = '"+I_Project.ACC_GROUP_OTHER_ASSET+"' or c.account_group = '"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"' or c.account_group = '"+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES+"' or c.account_group = '"+I_Project.ACC_GROUP_EQUITY+"') ";
                
            sql = sql + " group by gd.coa_id,gd.segment1_id";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {                

                BalanceNeraca bg = new BalanceNeraca();
                String accGroup = rs.getString("account_group");
                double debet = 0;
                double credit = 0;                
                
                long coaId = rs.getLong("coa_id");                
                int level = rs.getInt("level");
                long refId = rs.getLong("ref_id");
                long segment1 = rs.getLong("segment1_id");
                
                try{
                    debet = rs.getDouble("debet");
                }catch(Exception e){}
                
                try{
                    credit = rs.getDouble("credit");
                }catch(Exception e){}                
                              
                double openingBefore = DbCoaOpeningBalanceLocation.getOpeningBalance(p,coaId,segment1); 

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
                
                double total = 0;

                if(coaId == coaLabaBerjalan.getOID()){
                    //jika laba berjalan
                    total = openingBefore + DbGlDetail.getTotalIncomeInPeriod(p.getOID(), segment1) - DbGlDetail.getTotalExpenseInPeriod(p.getOID(), segment1);                                      
                }else{
                    total = openingBefore + amount; 
                }        
                
                bg.setPeriodId(p.getOID());
                bg.setAmount(total);                
                bg.setCoaId(coaId);
                bg.setSegment1Id(segment1);
                bg.setBalanceType(DbBalanceNeraca.TYPE_NERACA);
                
                /*if (coaLabaLalu.getCode().equals(code) || coaLabaBerjalan.getCode().equals(code)) {

                    bg.setCoaLevel7Id(coaId);
                    bg.setCoaLevel6Id(coaId);
                    bg.setCoaLevel5Id(coaId);
                    bg.setCoaLevel4Id(coaId);
                    bg.setCoaLevel3Id(coaId);
                    bg.setCoaLevel2Id(coaId);
                    bg.setCoaLevel1Id(coaId);

                } else {*/
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
                //}
                
                try{
                    DbBalanceNeraca.insertExc(bg);
                }catch(Exception e){}
            }
            rs.close();
            
            
            String sql2 = DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID]+" = "+p.getOID();
            Vector balances = DbCoaOpeningBalanceLocation.list(0,0,sql2,null);
            if(balances != null && balances.size() > 0){
                for(int i=0 ; i < balances.size(); i++){
                    CoaOpeningBalanceLocation bl = (CoaOpeningBalanceLocation)balances.get(i);
                    String wh = DbBalanceNeraca.colNames[DbBalanceNeraca.CL_PERIOD_ID]+" = "+p.getOID()+" and "+
                            DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_ID]+" = "+bl.getCoaId()+" and "+
                            DbBalanceNeraca.colNames[DbBalanceNeraca.CL_SEGMENT_1_ID]+" = "+bl.getSegment1Id();                 
                    int count = DbBalanceNeraca.getCount(wh);
                    
                    if(count==0){
                        BalanceNeraca bg = new BalanceNeraca();  
                        long coaId = bl.getCoaId();
                        bg.setPeriodId(p.getOID());
                        bg.setAmount(bl.getOpeningBalance());                
                        bg.setCoaId(coaId);
                        bg.setSegment1Id(bl.getSegment1Id());
                        bg.setBalanceType(DbBalanceNeraca.TYPE_NERACA); 
                        Coa coa = new Coa();
                        long refId = 0;
                        try{
                            coa = DbCoa.fetchExc(coaId);
                            refId = coa.getAccRefId();
                        }catch(Exception e){}
                        
                        switch (coa.getLevel()){
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
                        try{
                            if(bg.getAmount() != 0){
                                DbBalanceNeraca.insertExc(bg);
                            }
                        }catch(Exception e){}                        
                    }
                }
            }
            

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }  
    }
    
    public static Hashtable listNeraca(long periodeId,long segment1Id){
        
        CONResultSet dbrs = null;
        
        String strSeg = "";
        if(segment1Id != 0){
            strSeg = " and "+DbBalanceNeraca.colNames[DbBalanceNeraca.CL_SEGMENT_1_ID]+" = "+segment1Id;
        }
        
        Hashtable result = new Hashtable();
        
        try{
            String sql = "select coa_id,code,account_group,name,level,status,sum(amount) as amount from ( "+
                    " select c.coa_id as coa_id,c.code as code,c.account_group as account_group,c.name as name,level,c.status as status,0 as amount from coa c left join balance_neraca b on c.coa_id = b.coa_id where b.balance_neraca_id is null group by c.coa_id union "+
                    " select c.coa_id as coa_id,c.code as code,c.account_group as account_group,c.name as name,level,c.status as status,sum(amount) as amount from coa c inner join balance_neraca b on c.coa_id = b.coa_id where b.period_id = "+periodeId+" "+strSeg+" group by c.coa_id ) as x ";            
            
            sql = sql +" where ( account_group = '"+I_Project.ACC_GROUP_LIQUID_ASSET+"' or account_group = '"+I_Project.ACC_GROUP_FIXED_ASSET+"' or account_group = '"+I_Project.ACC_GROUP_OTHER_ASSET+"' or account_group = '"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"' or account_group = '"+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES+"' or account_group = '"+I_Project.ACC_GROUP_EQUITY+"') ";            
            
            sql = sql + " group by coa_id order by code ";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()){
                long coaId = rs.getLong("coa_id");
                double amount = rs.getDouble("amount");
                result.put(String.valueOf(coaId),String.valueOf(amount));
            }
            
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        } 
        return result;        
    }
    
    public static double getAmountInPeriod(long periodId, long coaId, int level, long segment1ID) {

        double result = 0;
        
        String sql = "select sum(" + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_AMOUNT] + ") from " + DbBalanceNeraca.DB_BALANCE_NERACA+
                " where "+ DbBalanceNeraca.colNames[DbBalanceNeraca.CL_PERIOD_ID] + "=" + periodId;
        
        if(segment1ID != 0){
            sql = sql + " and "+DbBalanceNeraca.colNames[DbBalanceNeraca.CL_SEGMENT_1_ID]+" = "+segment1ID;
        }

        switch (level) {
            case 1:
                sql = sql + " and  " + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " and  " + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " and  " + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " and  " + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " and  " + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " and  " + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " and  " + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_7_ID] + "=" + coaId;
                break;
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
