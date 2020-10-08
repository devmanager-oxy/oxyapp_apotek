/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.util.lang.*;
import com.project.util.*;
import com.project.system.*;
import com.project.fms.master.*;
import com.project.I_Project;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.Periode;
import com.project.fms.transaction.DbCashReceive;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbPettycashPayment;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.util.Vector;

/**
 *
 * @author Roy Andika
 */
public class SessReport {

    public static boolean LoadValue(long coaId, Vector temp, String type) {
        boolean x = false;
        if (temp != null && temp.size() > 0) {
            for (int ix = 0; ix < temp.size(); ix++) {
                Periode per = (Periode) temp.get(ix);
                double xx = 0;
                if (type.equals("CD")) {
                    xx = DbCoa.getCoaBalanceCD(coaId, per);
                } else {
                    xx = DbCoa.getCoaBalance(coaId, per);
                }
                if (xx != 0) {
                    x = true;
                }
            }
        }
        return x;
    }

    public static String switchLevel(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 3:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 4:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 5:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
        }
        return str;
    }

    public static String switchLevel1(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "       ";
                break;
            case 3:
                str = "              ";
                break;
            case 4:
                str = "                     ";
                break;
            case 5:
                str = "                            ";
                break;
        }
        return str;
    }

    public static String strDisplay(double amount, String coaStatus) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###.##");
        } else if (amount == 0) {
            displayStr = "";
        }
        if (coaStatus.equals("HEADER")) {
            displayStr = "";
        }
        return displayStr;
    }

    public static String strDisplay(double amount) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###.##");
        } else if (amount == 0) {
            displayStr = "";
        }
        return displayStr;
    }

    public static double getTotalLiqAssetByPeriod(Vector liqAssetx, Periode periode) {
        double result = 0;
        for (int i = 0; i < liqAssetx.size(); i++) {
            Coa coa = (Coa) liqAssetx.get(i);
            result = result + DbCoa.getCoaBalance(coa.getOID(), periode);
        }

        return result;
    }

    public static double getTotalFixAssetByPeriod(Vector fixAssetx, Periode periode) {
        double result = 0;
        for (int i = 0; i < fixAssetx.size(); i++) {
            Coa coa = (Coa) fixAssetx.get(i);
            result = result + DbCoa.getCoaBalance(coa.getOID(), periode);
        }

        return result;
    }

    public static double getTotalOthAssetByPeriod(Vector othAssetx, Periode periode) {
        double result = 0;
        for (int i = 0; i < othAssetx.size(); i++) {
            Coa coa = (Coa) othAssetx.get(i);
            result = result + DbCoa.getCoaBalance(coa.getOID(), periode);
        }

        return result;
    }

    public static double getTotalCurrLibByPeriod(Vector currLibx, Periode periode) {
        double result = 0;
        for (int i = 0; i < currLibx.size(); i++) {
            Coa coa = (Coa) currLibx.get(i);
            result = result + DbCoa.getCoaBalanceCD(coa.getOID(), periode);
        }

        return result;
    }

    public static double getTotalLongLibByPeriod(Vector longLibx, Periode periode) {
        double result = 0;
        for (int i = 0; i < longLibx.size(); i++) {
            Coa coa = (Coa) longLibx.get(i);
            result = result + DbCoa.getCoaBalanceCD(coa.getOID(), periode);
        }

        return result;
    }

    public static double getTotalEquityByPeriod(Vector equityx, Periode periode) {

        double result = 0;
        Vector listCoa = DbCoa.list(0, 0, "", "");
        double amountX = 0;

        for (int i = 0; i < equityx.size(); i++) {
            Coa coa = (Coa) equityx.get(i);

            System.out.println("\n\n=======***************** ========== coa : " + coa.getCode() + "-" + coa.getName());

            //DbCoa.getCoaBalanceCD(coa.getOID(), periode);

            //ID_RETAINED_EARNINGS => pake 'S' ini adalah current year earning
            //akan mencari P&L yang sekarang
            if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                double totalIncome = 0;
                Coa coax = new Coa();
                for (int zx = 0; zx < listCoa.size(); zx++) {
                    coax = (Coa) listCoa.get(zx);
                    //revenue -> Credit - Debet																			
                    if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                        totalIncome = totalIncome + DbCoa.getCYEarningCoaBalanceCD(coax.getOID(), periode);
                    } //cogs -> Debet - Credit
                    else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                        totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), periode);
                    } //expense - > Debet - Credit
                    else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                        totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), periode);
                    } //other revenue -> Credit - Debet
                    else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                        totalIncome = totalIncome + DbCoa.getCYEarningCoaBalanceCD(coax.getOID(), periode);
                    } //other expe -> Debet -Credit
                    else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                        totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), periode);
                    }
                }
                amountX = amountX + totalIncome;
            } else if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE"))) {
                amountX = amountX + DbCoa.getCoaBalance(coa.getOID(), periode);//getSumOpeningBalance();										
            } else {
                amountX = amountX + DbCoa.getCoaBalanceCD(coa.getOID(), periode);
            }

            System.out.println("amountX : " + amountX);

        }

        return result = amountX;

    }

    public static Vector listOutstanding(int type) {

        String sql = "";

        CONResultSet crs = null;

        try {

            if (type == 0) {

                sql = "SELECT PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + " as pettycashPaymentId," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_AMOUNT] + " as pettycashAmount ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_COA_ID] + " as pettycasCoaId ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER] + " as pettycasJurNum," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_EMPLOYEE_ID] + " as PettycashEmpId ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_MEMO] + " as pettycashMemo," +
                        "CREC." + DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] + " as cashReceiveId," +
                        "CREC." + DbCashReceive.colNames[DbCashReceive.COL_AMOUNT] + " as cashReceiveAmount," +
                        "GL." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId  FROM " +
                        DbPettycashPayment.DB_PETTYCASH_PAYMENT + " PPAY LEFT JOIN " + DbCashReceive.DB_CASH_RECEIVE +
                        " CREC ON PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + "= CREC." +
                        DbCashReceive.colNames[DbCashReceive.COL_REFERENSI_ID] + " LEFT JOIN " + DbGl.DB_GL + " GL " +
                        " ON PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + "= GL." +
                        DbGl.colNames[DbGl.COL_REFERENSI_ID] + " WHERE PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + "=" + DbPettycashPayment.STATUS_TYPE_KASBON;


            } else if (type == 1) {

                sql = "SELECT PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + " as pettycashPaymentId," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_AMOUNT] + " as pettycashAmount ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_COA_ID] + " as pettycasCoaId ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER] + " as pettycasJurNum," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_EMPLOYEE_ID] + " as PettycashEmpId ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_MEMO] + " as pettycashMemo," +
                        "CREC." + DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] + " as cashReceiveId," +
                        "CREC." + DbCashReceive.colNames[DbCashReceive.COL_AMOUNT] + " as cashReceiveAmount," +
                        "GL." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId  FROM " +
                        DbPettycashPayment.DB_PETTYCASH_PAYMENT + " PPAY LEFT JOIN " + DbCashReceive.DB_CASH_RECEIVE +
                        " CREC ON PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + "= CREC." +
                        DbCashReceive.colNames[DbCashReceive.COL_REFERENSI_ID] + " LEFT JOIN " + DbGl.DB_GL + " GL " +
                        " ON PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + "= GL." +
                        DbGl.colNames[DbGl.COL_REFERENSI_ID] + " WHERE PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + "=" + DbPettycashPayment.STATUS_TYPE_KASBON;


            } else if (type == 2) {

                sql = "SELECT PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + " as pettycashPaymentId," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_AMOUNT] + " as pettycashAmount ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_COA_ID] + " as pettycasCoaId ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER] + " as pettycasJurNum," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_EMPLOYEE_ID] + " as PettycashEmpId ," +
                        "PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_MEMO] + " as pettycashMemo," +
                        "CREC." + DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] + " as cashReceiveId," +
                        "CREC." + DbCashReceive.colNames[DbCashReceive.COL_AMOUNT] + " as cashReceiveAmount," +
                        "GL." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId  FROM " +
                        DbPettycashPayment.DB_PETTYCASH_PAYMENT + " PPAY LEFT JOIN " + DbCashReceive.DB_CASH_RECEIVE +
                        " CREC ON PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + "= CREC." +
                        DbCashReceive.colNames[DbCashReceive.COL_REFERENSI_ID] + " LEFT JOIN " + DbGl.DB_GL + " GL " +
                        " ON PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + "= GL." +
                        DbGl.colNames[DbGl.COL_REFERENSI_ID] + " WHERE PPAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + "=" + DbPettycashPayment.STATUS_TYPE_KASBON;


            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector listVector = new Vector();
            
            while(rs.next()){
                
                long pettycashOid = rs.getLong("pettycashPaymentId");
                double pettycashAmout = rs.getDouble("pettycashAmount");
                long pettycashCoaId = rs.getLong("pettycasCoaId");
                String jurNum = rs.getString("pettycasJurNum");
                long pettycashEmpId = rs.getLong("PettycashEmpId");
                String pettycashMemo = rs.getString("pettycashMemo");
                
                long cashReceiveId = rs.getLong("cashReceiveId");
                double cashReceiveAmount = rs.getDouble("cashReceiveAmount");
                
                long glId = rs.getLong("glId");
                
                double glAmount = 0;
                
                if(glId != 0){
                    glAmount = getGlDetail(glId);
                }
                
                double saldo = pettycashAmout - cashReceiveAmount - glAmount; 
                
                
                
                SessOutstandingKasbon sessOutstandingKasbon = new SessOutstandingKasbon();
                
                if(type == 0){
                    
                    sessOutstandingKasbon.setPettycashPaymentId(pettycashOid);
                    sessOutstandingKasbon.setAmount(pettycashAmout);
                    sessOutstandingKasbon.setCoaId(pettycashCoaId);
                    sessOutstandingKasbon.setJournalNumber(jurNum);
                    sessOutstandingKasbon.setEmployeeId(pettycashEmpId);
                    sessOutstandingKasbon.setMemo(pettycashMemo);
                    sessOutstandingKasbon.setCashreceiveId(cashReceiveId);
                    sessOutstandingKasbon.setCashreceiveAmount(cashReceiveAmount);
                    sessOutstandingKasbon.setSaldoSisa(saldo);
                    
                    listVector.add(sessOutstandingKasbon);
                            
                }else if(type == 1) {
                    
                    if(saldo <=0){
                        
                        sessOutstandingKasbon.setPettycashPaymentId(pettycashOid);
                        sessOutstandingKasbon.setAmount(pettycashAmout);
                        sessOutstandingKasbon.setCoaId(pettycashCoaId);
                        sessOutstandingKasbon.setJournalNumber(jurNum);
                        sessOutstandingKasbon.setEmployeeId(pettycashEmpId);
                        sessOutstandingKasbon.setMemo(pettycashMemo);
                        sessOutstandingKasbon.setCashreceiveId(cashReceiveId);
                        sessOutstandingKasbon.setCashreceiveAmount(cashReceiveAmount);
                        sessOutstandingKasbon.setSaldoSisa(saldo);
                    
                        listVector.add(sessOutstandingKasbon);
                        
                    }
                    
                }else if(type == 2){
                    
                    if(saldo > 0){
                        
                        sessOutstandingKasbon.setPettycashPaymentId(pettycashOid);
                        sessOutstandingKasbon.setAmount(pettycashAmout);
                        sessOutstandingKasbon.setCoaId(pettycashCoaId);
                        sessOutstandingKasbon.setJournalNumber(jurNum);
                        sessOutstandingKasbon.setEmployeeId(pettycashEmpId);
                        sessOutstandingKasbon.setMemo(pettycashMemo);
                        sessOutstandingKasbon.setCashreceiveId(cashReceiveId);
                        sessOutstandingKasbon.setCashreceiveAmount(cashReceiveAmount);
                        sessOutstandingKasbon.setSaldoSisa(saldo);
                    
                        listVector.add(sessOutstandingKasbon);
                        
                    }
                }
            }
            
            return listVector;
            
        } catch (Exception E) {
            System.out.println("[exception] "+E.toString());
        }finally{
            CONResultSet.close(crs);
        }

        return null;
    }
    
    
    
    public static double getGlDetail(long glId){
        
        CONResultSet crs = null;
        
        try{
         
            String sql = "SELECT SUM("+DbGlDetail.colNames[DbGlDetail.COL_DEBET]+") FROM "+DbGlDetail.DB_GL_DETAIL+" WHERE "+
                    DbGlDetail.colNames[DbGlDetail.COL_GL_ID]+"="+glId;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                
                double amount = rs.getDouble(1);
                return amount;
                
            }
            
        }catch(Exception E){
            System.out.println("[exception] "+E.toString());
        }finally{
            CONResultSet.close(crs);
        }
        
        return 0;
    }
    
    public static String getPemberiOrPenerima(long glId){
        
        String whereGL = DbGl.colNames[DbGl.COL_GL_ID]+" = "+glId;
        Vector vGl = DbGl.list(0, 0, whereGL, null);
        
        String journal_number = "";
        
        if(vGl != null && vGl.size() > 0){
            
            Gl gl = (Gl)vGl.get(0);
            journal_number = gl.getJournalNumber();
            
        }else{
            return "";
        }    
        
        String name = "-";
        
        try{
            
            //Pencarian di table cash_receive
            String whereCR = DbCashReceive.colNames[DbCashReceive.COL_JOURNAL_NUMBER]+" = '"+journal_number+"'";
            Vector vCashReceive = DbCashReceive.list(0, 0, whereCR, null);
            
            if(vCashReceive != null && vCashReceive.size() > 0){
                CashReceive cashReceive = (CashReceive)vCashReceive.get(0);
                name = cashReceive.getReceiveFromName();
                return name;
            }else{
                
                String wherePP = DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER]+" = '"+journal_number+"'";
                Vector vPettycashPayment = DbPettycashPayment.list(0, 0, wherePP, null);
                
                if(vPettycashPayment != null && vPettycashPayment.size() > 0){                    
                    PettycashPayment pettycashPayment = (PettycashPayment)vPettycashPayment.get(0);                    
                    name = pettycashPayment.getPaymentTo();
                    return name;
                }
                
            }
            
        }catch(Exception e){}
        
        
        return name;
        
    } 
    
    
    
}
