/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.GlDetail;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.SystemDocNumber;

import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;


public class SessJournal {

    public static long doReversePostedJournal(long oidGl, Gl newGl, int glType, long userId) {
        try {
            Gl objGl = DbGl.fetchExc(oidGl);
            Gl reverseGl = new Gl();
            Periode p = DbPeriode.getOpenPeriod();
            Date startDate = p.getStartDate();
            startDate.setMonth(startDate.getMonth() + 1);
            startDate.setDate(1);

            //duplicate Posted Journal
            reverseGl.setOID(0);
            reverseGl.setJournalNumber(newGl.getJournalNumber());
            reverseGl.setJournalPrefix(newGl.getJournalPrefix());
            reverseGl.setJournalCounter(newGl.getJournalCounter());
            reverseGl.setJournalType(newGl.getJournalType());
            reverseGl.setRefNumber(newGl.getRefNumber());
            reverseGl.setPeriodId(newGl.getPeriodId());
            reverseGl.setMemo(newGl.getMemo());
            reverseGl.setDate(newGl.getTransDate());
            reverseGl.setTransDate(newGl.getTransDate());
            reverseGl.setEffectiveDate(newGl.getTransDate());
            reverseGl.setOperatorId(userId);
            reverseGl.setCurrencyId(objGl.getCurrencyId());
            reverseGl.setIsReversal(glType);
            if (glType == DbGl.IS_REVERSAL) {
                reverseGl.setPostedStatus(DbGl.POSTED);
            } else {
                reverseGl.setPostedStatus(DbGl.NOT_POSTED);
            }
            reverseGl.setReversalStatus(DbGl.POSTED);
            long oidGlReversal = 0;
            
            try{
                DbGl.insertExc(reverseGl);
            }catch(Exception e){}

            if (oidGlReversal != 0) {
                try {
                    // proses untuk object ke general penanpungan code
                    SystemDocNumber systemDocNumber = new SystemDocNumber();
                    systemDocNumber.setCounter(reverseGl.getJournalCounter());
                    systemDocNumber.setPrefixNumber(reverseGl.getJournalPrefix());
                    systemDocNumber.setDocNumber(reverseGl.getJournalNumber());
                    systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                    systemDocNumber.setDate(new Date());
                    systemDocNumber.setYear(reverseGl.getTransDate().getYear() + 1900);
                    DbSystemDocNumber.insertExc(systemDocNumber);
                } catch (Exception e) {
                    System.out.println("[Exception]" + e.toString());
                }
            }

            //update Posted Journal
            objGl.setReversalStatus(DbGl.POSTED);
            objGl.setReversalDate(new Date());
            try{
                oidGl = DbGl.updateExc(objGl);
            }catch(Exception e){}

            //process Revers Posted Journal Detail
            Vector vGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + oidGl, "");

            for (int n = 0; n < vGlDetail.size(); n++) {
                GlDetail objGlDetail = (GlDetail) vGlDetail.get(n);
                GlDetail objGlDetailReversal = new GlDetail();

                double debet = objGlDetail.getDebet();
                double credit = objGlDetail.getCredit();

                objGlDetailReversal = objGlDetail;
                objGlDetailReversal.setOID(0);
                objGlDetailReversal.setGlId(oidGlReversal);
                objGlDetailReversal.setCredit(debet);
                objGlDetailReversal.setDebet(credit);

                DbGlDetail.insertExc(objGlDetailReversal);
            }
            return oidGlReversal;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
        return 0;
    }
    
    
    public static int CountGlReverse(int IgnoreTransactionDate, Date TransactionDate,
            String JournalNumber, int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber, int glType,
            long periodId, String memo) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT COUNT(gl." + DbGl.colNames[DbGl.COL_GL_ID] + " )" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + glType +
                    " AND gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED +
                    " AND gl." + DbGl.colNames[DbGl.COL_REVERSAL_STATUS] + " = " + DbGl.NOT_POSTED;

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (periodId != 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;
            }

            if (!memo.equals("")) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " LIKE '%" + memo + "%'";
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;

            while (rs.next()) {
                count = rs.getInt(1);
            }

            return count;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }
    
    
    
    
    public static Vector glReverse(int IgnoreTransactionDate, Date TransactionDate, String JournalNumber,
            int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber, int glType,
            long periodId, String memo, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + glType +
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED +
                    " AND gl." + DbGl.colNames[DbGl.COL_REVERSAL_STATUS] + " = " + DbGl.NOT_POSTED;

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " LIKE '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' AND '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " LIKE '%" + srcRefNumber + "%'";
            }

            if (periodId != 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;
            }

            if (!memo.equals("")) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " LIKE '%" + memo + "%'";
            }

            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
}
