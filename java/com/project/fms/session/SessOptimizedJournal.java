/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import com.project.fms.transaction.DbGlDetail;
/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
/* package qdep */

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.master.*;
import com.project.*;
import com.project.fms.transaction.DbGlDetail2015;
import com.project.fms.transaction.DbGlDetail2016;
import com.project.fms.transaction.GlDetail;
import com.project.fms.transaction.GlDetail2015;
import com.project.fms.transaction.GlDetail2016;
import com.project.system.DbSystemProperty;
import com.project.util.*;
import com.project.util.lang.*;


/**
 *
 * @author Roy
 */
public class SessOptimizedJournal {

    public static void optimizeJournalGl(Periode periode, long glOID, String noteCredit, String noteDebet, int config) {

        String tblGlDetail = "gl_detail";
        if (periode.getTableName().equals(I_Project.GL)) {
            tblGlDetail = "gl_detail";
        } else if (periode.getTableName().equals(I_Project.GL_2015)) {
            tblGlDetail = "gl_detail_2015";
        } else if (periode.getTableName().equals(I_Project.GL_2016)) {
            tblGlDetail = "gl_detail_2016";
        } else {
            tblGlDetail = "gl_detail";
        }
        
        long oidOffice = 0;
        try {
            oidOffice = Long.parseLong(DbSystemProperty.getValueByName("OID_SEGMENT_OFFICE"));
        } catch (Exception e) {}

        String sql = " select sum(" + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")" +
                ", sum(" + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_AMOUNT] + ")" +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] + // 6
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT8_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT9_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT10_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT12_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT13_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT14_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT15_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIRECTORATE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIVISION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_MODULE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL0_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_JOB_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_STATUS_TRANSACTION] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL1_ID];

        sql = sql + " from " + tblGlDetail;

        sql = sql + " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID +
                " and " + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + " != 0" +
                " group by " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                " , " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] + // 6
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT8_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT9_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT10_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT12_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT13_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT14_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT15_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIRECTORATE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIVISION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_MODULE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL0_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_JOB_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_STATUS_TRANSACTION] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL1_ID];

        CONResultSet crs = null;
        Vector temp = new Vector();

        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {

                if (periode.getTableName().equals(I_Project.GL_2015)) {
                    GlDetail2015 gd = new GlDetail2015();
                    gd.setGlId(glOID);
                    gd.setDebet(rs.getDouble(1));
                    gd.setForeignCurrencyAmount(rs.getDouble(2));
                    gd.setCoaId(rs.getLong(3));
                    gd.setForeignCurrencyId(rs.getLong(4));
                    gd.setBookedRate(rs.getDouble(5));
                    gd.setCredit(0);

                    gd.setSegment1Id(rs.getLong(6));
                    gd.setSegment2Id(rs.getLong(7));
                    gd.setSegment3Id(rs.getLong(8));
                    gd.setSegment4Id(rs.getLong(9));
                    gd.setSegment5Id(rs.getLong(10));
                    gd.setSegment6Id(rs.getLong(11));
                    gd.setSegment7Id(rs.getLong(12));
                    gd.setSegment8Id(rs.getLong(13));
                    gd.setSegment9Id(rs.getLong(14));
                    gd.setSegment10Id(rs.getLong(15));
                    gd.setSegment11Id(rs.getLong(16));
                    gd.setSegment12Id(rs.getLong(17));
                    gd.setSegment13Id(rs.getLong(18));
                    gd.setSegment14Id(rs.getLong(19));
                    gd.setSegment15Id(rs.getLong(20));

                    gd.setCoaLevel1Id(rs.getLong(21));
                    gd.setCoaLevel2Id(rs.getLong(22));
                    gd.setCoaLevel3Id(rs.getLong(23));
                    gd.setCoaLevel4Id(rs.getLong(24));
                    gd.setCoaLevel5Id(rs.getLong(25));
                    gd.setCoaLevel6Id(rs.getLong(26));
                    gd.setCoaLevel7Id(rs.getLong(27));

                    gd.setDirectorateId(rs.getLong(28));
                    gd.setDivisionId(rs.getLong(29));
                    gd.setDepLevel2Id(rs.getLong(30));
                    gd.setDepLevel3Id(rs.getLong(31));
                    gd.setDepLevel4Id(rs.getLong(32));
                    gd.setDepLevel5Id(rs.getLong(33));
                    gd.setModuleId(rs.getLong(34));
                    gd.setDepLevel0Id(rs.getLong(35));

                    gd.setDepartmentId(rs.getLong(36));
                    gd.setSectionId(rs.getLong(37));
                    gd.setSubSectionId(rs.getLong(38));
                    gd.setJobId(rs.getLong(39));
                    gd.setStatusTransaction(rs.getInt(40));
                    gd.setDepLevel1Id(rs.getLong(41));
                    temp.add(gd);

                } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                    GlDetail2016 gd = new GlDetail2016();
                    gd.setGlId(glOID);
                    gd.setDebet(rs.getDouble(1));
                    gd.setForeignCurrencyAmount(rs.getDouble(2));
                    gd.setCoaId(rs.getLong(3));
                    gd.setForeignCurrencyId(rs.getLong(4));
                    gd.setBookedRate(rs.getDouble(5));
                    gd.setCredit(0);

                    gd.setSegment1Id(rs.getLong(6));
                    gd.setSegment2Id(rs.getLong(7));
                    gd.setSegment3Id(rs.getLong(8));
                    gd.setSegment4Id(rs.getLong(9));
                    gd.setSegment5Id(rs.getLong(10));
                    gd.setSegment6Id(rs.getLong(11));
                    gd.setSegment7Id(rs.getLong(12));
                    gd.setSegment8Id(rs.getLong(13));
                    gd.setSegment9Id(rs.getLong(14));
                    gd.setSegment10Id(rs.getLong(15));
                    gd.setSegment11Id(rs.getLong(16));
                    gd.setSegment12Id(rs.getLong(17));
                    gd.setSegment13Id(rs.getLong(18));
                    gd.setSegment14Id(rs.getLong(19));
                    gd.setSegment15Id(rs.getLong(20));

                    gd.setCoaLevel1Id(rs.getLong(21));
                    gd.setCoaLevel2Id(rs.getLong(22));
                    gd.setCoaLevel3Id(rs.getLong(23));
                    gd.setCoaLevel4Id(rs.getLong(24));
                    gd.setCoaLevel5Id(rs.getLong(25));
                    gd.setCoaLevel6Id(rs.getLong(26));
                    gd.setCoaLevel7Id(rs.getLong(27));

                    gd.setDirectorateId(rs.getLong(28));
                    gd.setDivisionId(rs.getLong(29));
                    gd.setDepLevel2Id(rs.getLong(30));
                    gd.setDepLevel3Id(rs.getLong(31));
                    gd.setDepLevel4Id(rs.getLong(32));
                    gd.setDepLevel5Id(rs.getLong(33));
                    gd.setModuleId(rs.getLong(34));
                    gd.setDepLevel0Id(rs.getLong(35));

                    gd.setDepartmentId(rs.getLong(36));
                    gd.setSectionId(rs.getLong(37));
                    gd.setSubSectionId(rs.getLong(38));
                    gd.setJobId(rs.getLong(39));
                    gd.setStatusTransaction(rs.getInt(40));
                    gd.setDepLevel1Id(rs.getLong(41));
                    temp.add(gd);
                } else {
                    GlDetail gd = new GlDetail();
                    gd.setGlId(glOID);
                    gd.setDebet(rs.getDouble(1));
                    gd.setForeignCurrencyAmount(rs.getDouble(2));
                    gd.setCoaId(rs.getLong(3));
                    gd.setForeignCurrencyId(rs.getLong(4));
                    gd.setBookedRate(rs.getDouble(5));
                    gd.setCredit(0);

                    gd.setSegment1Id(rs.getLong(6));
                    gd.setSegment2Id(rs.getLong(7));
                    gd.setSegment3Id(rs.getLong(8));
                    gd.setSegment4Id(rs.getLong(9));
                    gd.setSegment5Id(rs.getLong(10));
                    gd.setSegment6Id(rs.getLong(11));
                    gd.setSegment7Id(rs.getLong(12));
                    gd.setSegment8Id(rs.getLong(13));
                    gd.setSegment9Id(rs.getLong(14));
                    gd.setSegment10Id(rs.getLong(15));
                    gd.setSegment11Id(rs.getLong(16));
                    gd.setSegment12Id(rs.getLong(17));
                    gd.setSegment13Id(rs.getLong(18));
                    gd.setSegment14Id(rs.getLong(19));
                    gd.setSegment15Id(rs.getLong(20));

                    gd.setCoaLevel1Id(rs.getLong(21));
                    gd.setCoaLevel2Id(rs.getLong(22));
                    gd.setCoaLevel3Id(rs.getLong(23));
                    gd.setCoaLevel4Id(rs.getLong(24));
                    gd.setCoaLevel5Id(rs.getLong(25));
                    gd.setCoaLevel6Id(rs.getLong(26));
                    gd.setCoaLevel7Id(rs.getLong(27));

                    gd.setDirectorateId(rs.getLong(28));
                    gd.setDivisionId(rs.getLong(29));
                    gd.setDepLevel2Id(rs.getLong(30));
                    gd.setDepLevel3Id(rs.getLong(31));
                    gd.setDepLevel4Id(rs.getLong(32));
                    gd.setDepLevel5Id(rs.getLong(33));
                    gd.setModuleId(rs.getLong(34));
                    gd.setDepLevel0Id(rs.getLong(35));

                    gd.setDepartmentId(rs.getLong(36));
                    gd.setSectionId(rs.getLong(37));
                    gd.setSubSectionId(rs.getLong(38));
                    gd.setJobId(rs.getLong(39));
                    gd.setStatusTransaction(rs.getInt(40));
                    gd.setDepLevel1Id(rs.getLong(41));
                    temp.add(gd);

                }
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        
        Vector jDetailDebet = new Vector();        
        if (temp != null && temp.size() > 0) {
            for (int x = 0; x < temp.size(); x++) {
                if (periode.getTableName().equals(I_Project.GL_2015)) {
                    GlDetail2015 gdx = (GlDetail2015) temp.get(x);
                    String memo = noteDebet;
                    if (config == 1) {
                        Coa c = new Coa();
                        try {
                            c = DbCoa.fetchExc(gdx.getCoaId());
                            memo = memo + c.getName();
                        } catch (Exception e) {
                        }   
                        String str = getSegment(gdx.getGlId());
                        if(str != null && str.length() > 0){
                            memo = memo + ", Location :"+str;
                        }
                    }
                    gdx.setMemo(memo);
                    jDetailDebet.add(gdx);
                } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                    GlDetail2016 gdx = (GlDetail2016) temp.get(x);
                    String memo = noteDebet;
                    if (config == 1) {
                        Coa c = new Coa();
                        try {
                            c = DbCoa.fetchExc(gdx.getCoaId());
                            memo = memo + c.getName();
                        } catch (Exception e) {
                        }
                        String str = getSegment(gdx.getGlId());
                        if(str != null && str.length() > 0){
                            memo = memo + ", Location :"+str;
                        }
                    }
                    gdx.setMemo(memo);
                    jDetailDebet.add(gdx);
                } else {
                    GlDetail gdx = (GlDetail) temp.get(x);
                    String memo = noteDebet;
                    if (config == 1) {
                        Coa c = new Coa();
                        try {
                            c = DbCoa.fetchExc(gdx.getCoaId());
                            memo = memo + c.getName();
                        } catch (Exception e) {
                        }
                        String str = getSegment(gdx.getGlId());
                        if(str != null && str.length() > 0){
                            memo = memo + ", Location :"+str;
                        }
                    }
                    gdx.setMemo(memo);
                    jDetailDebet.add(gdx);
                }
            }
        }

        //process credit ===========================

        sql = " select sum(" + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                ", sum(" + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_AMOUNT] + ")" +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] +// 6
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT8_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT9_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT10_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT12_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT13_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT14_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT15_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIRECTORATE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIVISION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_MODULE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL0_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_JOB_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_STATUS_TRANSACTION] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL1_ID];

        sql = sql + " from " + tblGlDetail;

        sql = sql + " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID +
                " and " + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + "!= 0" +
                " group by " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                " , " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] +// 6
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT8_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT9_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT10_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT12_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT13_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT14_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT15_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIRECTORATE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIVISION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_MODULE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL0_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_JOB_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_STATUS_TRANSACTION] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL1_ID];

        CONResultSet crsx = null;
        temp = new Vector();
        try {
            crsx = CONHandler.execQueryResult(sql);
            ResultSet rs = crsx.getResultSet();
            while (rs.next()) {

                if (periode.getTableName().equals(I_Project.GL_2015)) {
                    GlDetail2015 gd = new GlDetail2015();
                    gd.setGlId(glOID);
                    gd.setCredit(rs.getDouble(1));
                    gd.setForeignCurrencyAmount(rs.getDouble(2));
                    gd.setCoaId(rs.getLong(3));
                    gd.setForeignCurrencyId(rs.getLong(4));
                    gd.setBookedRate(rs.getDouble(5));
                    gd.setDebet(0);

                    gd.setSegment1Id(rs.getLong(6));
                    gd.setSegment2Id(rs.getLong(7));
                    gd.setSegment3Id(rs.getLong(8));
                    gd.setSegment4Id(rs.getLong(9));
                    gd.setSegment5Id(rs.getLong(10));
                    gd.setSegment6Id(rs.getLong(11));
                    gd.setSegment7Id(rs.getLong(12));
                    gd.setSegment8Id(rs.getLong(13));
                    gd.setSegment9Id(rs.getLong(14));
                    gd.setSegment10Id(rs.getLong(15));
                    gd.setSegment11Id(rs.getLong(16));
                    gd.setSegment12Id(rs.getLong(17));
                    gd.setSegment13Id(rs.getLong(18));
                    gd.setSegment14Id(rs.getLong(19));
                    gd.setSegment15Id(rs.getLong(20));

                    gd.setCoaLevel1Id(rs.getLong(21));
                    gd.setCoaLevel2Id(rs.getLong(22));
                    gd.setCoaLevel3Id(rs.getLong(23));
                    gd.setCoaLevel4Id(rs.getLong(24));
                    gd.setCoaLevel5Id(rs.getLong(25));
                    gd.setCoaLevel6Id(rs.getLong(26));
                    gd.setCoaLevel7Id(rs.getLong(27));

                    gd.setDirectorateId(rs.getLong(28));
                    gd.setDivisionId(rs.getLong(29));
                    gd.setDepLevel2Id(rs.getLong(30));
                    gd.setDepLevel3Id(rs.getLong(31));
                    gd.setDepLevel4Id(rs.getLong(32));
                    gd.setDepLevel5Id(rs.getLong(33));
                    gd.setModuleId(rs.getLong(34));
                    gd.setDepLevel0Id(rs.getLong(35));

                    gd.setDepartmentId(rs.getLong(36));
                    gd.setSectionId(rs.getLong(37));
                    gd.setSubSectionId(rs.getLong(38));
                    gd.setJobId(rs.getLong(39));
                    gd.setStatusTransaction(rs.getInt(40));
                    gd.setDepLevel1Id(rs.getLong(41));
                    temp.add(gd);
                } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                    GlDetail2016 gd = new GlDetail2016();
                    gd.setGlId(glOID);
                    gd.setCredit(rs.getDouble(1));
                    gd.setForeignCurrencyAmount(rs.getDouble(2));
                    gd.setCoaId(rs.getLong(3));
                    gd.setForeignCurrencyId(rs.getLong(4));
                    gd.setBookedRate(rs.getDouble(5));
                    gd.setDebet(0);

                    gd.setSegment1Id(rs.getLong(6));
                    gd.setSegment2Id(rs.getLong(7));
                    gd.setSegment3Id(rs.getLong(8));
                    gd.setSegment4Id(rs.getLong(9));
                    gd.setSegment5Id(rs.getLong(10));
                    gd.setSegment6Id(rs.getLong(11));
                    gd.setSegment7Id(rs.getLong(12));
                    gd.setSegment8Id(rs.getLong(13));
                    gd.setSegment9Id(rs.getLong(14));
                    gd.setSegment10Id(rs.getLong(15));
                    gd.setSegment11Id(rs.getLong(16));
                    gd.setSegment12Id(rs.getLong(17));
                    gd.setSegment13Id(rs.getLong(18));
                    gd.setSegment14Id(rs.getLong(19));
                    gd.setSegment15Id(rs.getLong(20));

                    gd.setCoaLevel1Id(rs.getLong(21));
                    gd.setCoaLevel2Id(rs.getLong(22));
                    gd.setCoaLevel3Id(rs.getLong(23));
                    gd.setCoaLevel4Id(rs.getLong(24));
                    gd.setCoaLevel5Id(rs.getLong(25));
                    gd.setCoaLevel6Id(rs.getLong(26));
                    gd.setCoaLevel7Id(rs.getLong(27));

                    gd.setDirectorateId(rs.getLong(28));
                    gd.setDivisionId(rs.getLong(29));
                    gd.setDepLevel2Id(rs.getLong(30));
                    gd.setDepLevel3Id(rs.getLong(31));
                    gd.setDepLevel4Id(rs.getLong(32));
                    gd.setDepLevel5Id(rs.getLong(33));
                    gd.setModuleId(rs.getLong(34));
                    gd.setDepLevel0Id(rs.getLong(35));

                    gd.setDepartmentId(rs.getLong(36));
                    gd.setSectionId(rs.getLong(37));
                    gd.setSubSectionId(rs.getLong(38));
                    gd.setJobId(rs.getLong(39));
                    gd.setStatusTransaction(rs.getInt(40));
                    gd.setDepLevel1Id(rs.getLong(41));
                    temp.add(gd);
                } else {
                    GlDetail gd = new GlDetail();
                    gd.setGlId(glOID);
                    gd.setCredit(rs.getDouble(1));
                    gd.setForeignCurrencyAmount(rs.getDouble(2));
                    gd.setCoaId(rs.getLong(3));
                    gd.setForeignCurrencyId(rs.getLong(4));
                    gd.setBookedRate(rs.getDouble(5));
                    gd.setDebet(0);

                    gd.setSegment1Id(rs.getLong(6));
                    gd.setSegment2Id(rs.getLong(7));
                    gd.setSegment3Id(rs.getLong(8));
                    gd.setSegment4Id(rs.getLong(9));
                    gd.setSegment5Id(rs.getLong(10));
                    gd.setSegment6Id(rs.getLong(11));
                    gd.setSegment7Id(rs.getLong(12));
                    gd.setSegment8Id(rs.getLong(13));
                    gd.setSegment9Id(rs.getLong(14));
                    gd.setSegment10Id(rs.getLong(15));
                    gd.setSegment11Id(rs.getLong(16));
                    gd.setSegment12Id(rs.getLong(17));
                    gd.setSegment13Id(rs.getLong(18));
                    gd.setSegment14Id(rs.getLong(19));
                    gd.setSegment15Id(rs.getLong(20));

                    gd.setCoaLevel1Id(rs.getLong(21));
                    gd.setCoaLevel2Id(rs.getLong(22));
                    gd.setCoaLevel3Id(rs.getLong(23));
                    gd.setCoaLevel4Id(rs.getLong(24));
                    gd.setCoaLevel5Id(rs.getLong(25));
                    gd.setCoaLevel6Id(rs.getLong(26));
                    gd.setCoaLevel7Id(rs.getLong(27));

                    gd.setDirectorateId(rs.getLong(28));
                    gd.setDivisionId(rs.getLong(29));
                    gd.setDepLevel2Id(rs.getLong(30));
                    gd.setDepLevel3Id(rs.getLong(31));
                    gd.setDepLevel4Id(rs.getLong(32));
                    gd.setDepLevel5Id(rs.getLong(33));
                    gd.setModuleId(rs.getLong(34));
                    gd.setDepLevel0Id(rs.getLong(35));

                    gd.setDepartmentId(rs.getLong(36));
                    gd.setSectionId(rs.getLong(37));
                    gd.setSubSectionId(rs.getLong(38));
                    gd.setJobId(rs.getLong(39));
                    gd.setStatusTransaction(rs.getInt(40));
                    gd.setDepLevel1Id(rs.getLong(41));
                    temp.add(gd);
                }
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crsx);
        }

        Vector jDetailCredit = new Vector();
        if (temp != null && temp.size() > 0) {
            for (int x = 0; x < temp.size(); x++) {
                if (periode.getTableName().equals(I_Project.GL_2015)) {
                    GlDetail2015 gdx = (GlDetail2015) temp.get(x);
                    String memo = noteCredit;
                    if (config == 1) {
                        Coa c = new Coa();
                        try {
                            c = DbCoa.fetchExc(gdx.getCoaId());
                            memo = memo + c.getName();
                        } catch (Exception e) {
                        }
                        if(gdx.getSegment1Id() != oidOffice){
                            SegmentDetail sd = new SegmentDetail();
                            try{
                                sd = DbSegmentDetail.fetchExc(gdx.getSegment1Id());
                                if(sd.getOID() != 0){
                                    memo = memo + ", Location :"+sd.getName();
                                }
                            }catch(Exception e){}
                        }
                    }
                    gdx.setMemo(memo);
                    jDetailCredit.add(gdx);
                } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                    GlDetail2016 gdx = (GlDetail2016) temp.get(x);
                    String memo = noteCredit;
                    if (config == 1) {
                        Coa c = new Coa();
                        try {
                            c = DbCoa.fetchExc(gdx.getCoaId());
                            memo = memo + c.getName();
                        } catch (Exception e) {
                        }
                        if(gdx.getSegment1Id() != oidOffice){
                            SegmentDetail sd = new SegmentDetail();
                            try{
                                sd = DbSegmentDetail.fetchExc(gdx.getSegment1Id());
                                if(sd.getOID() != 0){
                                    memo = memo + ", Location :"+sd.getName();
                                }
                            }catch(Exception e){}
                        }
                    }
                    gdx.setMemo(memo);
                    jDetailCredit.add(gdx);
                } else {
                    GlDetail gdx = (GlDetail) temp.get(x);
                    String memo = noteCredit;
                    if (config == 1) {
                        Coa c = new Coa();
                        try {
                            c = DbCoa.fetchExc(gdx.getCoaId());
                            memo = memo + c.getName();
                        } catch (Exception e) {
                        }
                        if(gdx.getSegment1Id() != oidOffice){
                            SegmentDetail sd = new SegmentDetail();
                            try{
                                sd = DbSegmentDetail.fetchExc(gdx.getSegment1Id());
                                if(sd.getOID() != 0){
                                    memo = memo + ", Location :"+sd.getName();
                                }
                            }catch(Exception e){}
                        }
                    }
                    gdx.setMemo(memo);
                    jDetailCredit.add(gdx);
                }
            }

        }

        //delete journal detail        
        if (periode.getTableName().equals(I_Project.GL_2015)) {
            deleteAllDetailGl2015(glOID);            
        }else if (periode.getTableName().equals(I_Project.GL_2016)) {
            deleteAllDetailGl2016(glOID);            
        }else{
            deleteAllDetailGl(glOID);            
        }
        

        //insert yang baru
        for (int i = 0; i < jDetailDebet.size(); i++) {
            if (periode.getTableName().equals(I_Project.GL_2015)) {
                GlDetail2015 gdx = (GlDetail2015) jDetailDebet.get(i);
                try {
                    DbGlDetail2015.insertExc(gdx);
                } catch (Exception e) {
                }
            }else if (periode.getTableName().equals(I_Project.GL_2016)) {
                GlDetail2016 gdx = (GlDetail2016) jDetailDebet.get(i);
                try {
                    DbGlDetail2016.insertExc(gdx);
                } catch (Exception e) {
                }
            }else{
                GlDetail gdx = (GlDetail) jDetailDebet.get(i);
                try {
                    DbGlDetail.insertExc(gdx);
                } catch (Exception e) {
                }
            }
        }

        for (int i = 0; i < jDetailCredit.size(); i++) {
            if (periode.getTableName().equals(I_Project.GL_2015)) {
                GlDetail2015 gdx = (GlDetail2015) jDetailCredit.get(i);
                try {
                    DbGlDetail2015.insertExc(gdx);
                } catch (Exception e) {
                }
            }else if (periode.getTableName().equals(I_Project.GL_2016)) {
                GlDetail2016 gdx = (GlDetail2016) jDetailCredit.get(i);
                try {
                    DbGlDetail2016.insertExc(gdx);
                } catch (Exception e) {
                }
            }else{
                GlDetail gdx = (GlDetail) jDetailCredit.get(i);
                try {
                    DbGlDetail.insertExc(gdx);
                } catch (Exception e) {
                }
            }
            
        }
    }
    
    public static void deleteAllDetailGl(long glId) {

        if (glId != 0) {
            CONResultSet dbrs = null;

            try {
                String sql = "DELETE FROM " + DbGlDetail.DB_GL_DETAIL + " WHERE " +
                        DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + glId;
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println("[Exception] "+e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }
    
    public static void deleteAllDetailGl2015(long glId) {

        if (glId != 0) {
            CONResultSet dbrs = null;

            try {
                String sql = "DELETE FROM " + DbGlDetail2015.DB_GL_DETAIL2015 + " WHERE " +
                        DbGlDetail2015.colNames[DbGlDetail2015.COL_GL_ID] + " = " + glId;
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println("[Exception] "+e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }
    
    public static void deleteAllDetailGl2016(long glId) {

        if (glId != 0) {
            CONResultSet dbrs = null;

            try {
                String sql = "DELETE FROM " + DbGlDetail2016.DB_GL_DETAIL2016 + " WHERE " +
                        DbGlDetail2016.colNames[DbGlDetail2016.COL_GL_ID] + " = " + glId;
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println("[Exception] "+e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }
    
    public static String getSegment(long glId){
        String result = "";
        CONResultSet crs = null;
        try{
            String sql = " select "+DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]+" from "+DbGlDetail.DB_GL_DETAIL+" where "+
                    DbGlDetail.colNames[DbGlDetail.COL_CREDIT]+" != 0 and "+
                    DbGlDetail.colNames[DbGlDetail.COL_GL_ID]+" = "+glId+" group by "+DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID];
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()){
                long segmentId = rs.getLong(DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID]);
                SegmentDetail sd = new SegmentDetail();
                try{
                    sd = DbSegmentDetail.fetchExc(segmentId);
                    if(result != null && result.length() > 0){ result = result+", "; }
                    result = result + sd.getName();
                }catch(Exception e){}
            }
            
        }catch(Exception e){}
        return result;        
    }
}
