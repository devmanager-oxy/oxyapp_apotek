package com.project.fms.master;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.*;
import com.project.ccs.postransaction.adjusment.Adjusment;
import com.project.ccs.postransaction.adjusment.DbAdjusment;
import com.project.ccs.postransaction.costing.Costing;
import com.project.ccs.postransaction.costing.DbCosting;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbRetur;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.receiving.Retur;
import com.project.ccs.postransaction.repack.DbRepack;
import com.project.ccs.postransaction.repack.Repack;
import com.project.system.DbSystemProperty;
import com.project.util.*;

public class DbPeriode extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_PERIODE = "periode";
    public static final int COL_PERIODE_ID = 0;    
    public static final int COL_START_DATE = 1;
    public static final int COL_END_DATE = 2;
    public static final int COL_STATUS = 3;
    public static final int COL_NAME = 4;
    public static final int COL_INPUT_TOLERANCE = 5;
    public static final int COL_TYPE = 6;
    public static final int COL_TABLE_NAME = 7;
    
    public static final String[] colNames = {
        "periode_id",
        "start_date",
        "end_date",
        "status",
        "name",
        "input_tolerance",
        "type",
        "table_name"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_INT,
        TYPE_STRING
    };
    
    public static final String[] strKeyPeriods = {
        I_Project.GL,I_Project.GL_2015,I_Project.GL_2016,I_Project.GL_2017,I_Project.GL_2018,I_Project.GL_2019,I_Project.GL_2020
    };
    
    public static final String [] strValuePeriods = {
        I_Project.GL,I_Project.GL_2015,I_Project.GL_2016,I_Project.GL_2017,I_Project.GL_2018,I_Project.GL_2019,I_Project.GL_2020
    };
    
    public static int TYPE_PERIOD_REGULAR = 0;    
    public static int TYPE_PERIOD13 = 1;
    public static int TYPE_PERIOD_PRECLOSED = 2;

    public DbPeriode() {
    }

    public DbPeriode(int i) throws CONException {
        super(new DbPeriode());
    }

    public DbPeriode(String sOid) throws CONException {
        super(new DbPeriode(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPeriode(long lOid) throws CONException {
        super(new DbPeriode(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return DB_PERIODE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPeriode().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Periode periode = fetchExc(ent.getOID());
        ent = (Entity) periode;
        return periode.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Periode) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Periode) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Periode fetchExc(long oid) throws CONException {
        try {
            Periode periode = new Periode();
            DbPeriode dbPeriode = new DbPeriode(oid);
            periode.setOID(oid);

            periode.setStartDate(dbPeriode.getDate(COL_START_DATE));
            periode.setEndDate(dbPeriode.getDate(COL_END_DATE));
            periode.setStatus(dbPeriode.getString(COL_STATUS));
            periode.setName(dbPeriode.getString(COL_NAME));
            periode.setInputTolerance(dbPeriode.getDate(COL_INPUT_TOLERANCE));
            periode.setType(dbPeriode.getInt(COL_TYPE));
            periode.setTableName(dbPeriode.getString(COL_TABLE_NAME));

            return periode;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPeriode(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Periode periode) throws CONException {
        try {
            DbPeriode dbPeriode = new DbPeriode(0);

            dbPeriode.setDate(COL_START_DATE, periode.getStartDate());
            dbPeriode.setDate(COL_END_DATE, periode.getEndDate());
            dbPeriode.setString(COL_STATUS, periode.getStatus());
            dbPeriode.setString(COL_NAME, periode.getName());
            dbPeriode.setDate(COL_INPUT_TOLERANCE, periode.getInputTolerance());
            dbPeriode.setInt(COL_TYPE, periode.getType());
            dbPeriode.setString(COL_TABLE_NAME, periode.getTableName());

            dbPeriode.insert();
            periode.setOID(dbPeriode.getlong(COL_PERIODE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPeriode(0), CONException.UNKNOWN);
        }
        return periode.getOID();
    }

    public static long updateExc(Periode periode) throws CONException {
        try {
            if (periode.getOID() != 0) {
                DbPeriode dbPeriode = new DbPeriode(periode.getOID());

                dbPeriode.setDate(COL_START_DATE, periode.getStartDate());
                dbPeriode.setDate(COL_END_DATE, periode.getEndDate());
                dbPeriode.setString(COL_STATUS, periode.getStatus());
                dbPeriode.setString(COL_NAME, periode.getName());
                dbPeriode.setDate(COL_INPUT_TOLERANCE, periode.getInputTolerance());
                dbPeriode.setInt(COL_TYPE, periode.getType());
                dbPeriode.setString(COL_TABLE_NAME, periode.getTableName());

                dbPeriode.update();
                return periode.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPeriode(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPeriode dbPeriode = new DbPeriode(oid);
            dbPeriode.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPeriode(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_PERIODE;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Periode periode = new Periode();
                resultToObject(rs, periode);
                lists.add(periode);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, Periode periode) {
        try {
            periode.setOID(rs.getLong(DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]));
            periode.setStartDate(rs.getDate(DbPeriode.colNames[DbPeriode.COL_START_DATE]));
            periode.setEndDate(rs.getDate(DbPeriode.colNames[DbPeriode.COL_END_DATE]));
            periode.setStatus(rs.getString(DbPeriode.colNames[DbPeriode.COL_STATUS]));
            periode.setName(rs.getString(DbPeriode.colNames[DbPeriode.COL_NAME]));
            periode.setInputTolerance(rs.getDate(DbPeriode.colNames[DbPeriode.COL_INPUT_TOLERANCE]));
            periode.setType(rs.getInt(DbPeriode.colNames[DbPeriode.COL_TYPE]));
            periode.setTableName(rs.getString(DbPeriode.colNames[DbPeriode.COL_TABLE_NAME]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long periodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PERIODE + " WHERE " +
                    DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodeId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + ") FROM " + DB_PERIODE;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }


    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    Periode periode = (Periode) list.get(ls);
                    if (oid == periode.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }

        return start;
    }

    public static Periode getOpenPeriod() {
        Vector v = list(0, 0, colNames[COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "' and " + colNames[COL_TYPE] + "=" + TYPE_PERIOD_REGULAR, "start_date desc");
        if (v != null && v.size() > 0) {
            return (Periode) v.get(0);
        }
        return new Periode();
    }

    //eka ds
    public static Periode getOpenPeriod13() {
        Vector v = list(0, 0, colNames[COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "' and " + colNames[COL_TYPE] + "=" + TYPE_PERIOD13, "start_date desc");
        if (v != null && v.size() > 0) {
            return (Periode) v.get(0);
        }
        return new Periode();
    }

    public static Periode getLastYearPeriod13(Periode currPeriode) {

        Date startDate = currPeriode.getStartDate();
        Date dt = (Date) startDate.clone();
        dt.setYear(dt.getYear() - 1);

        String where = colNames[COL_TYPE] + "=" + TYPE_PERIOD13 + " and year(" + colNames[COL_START_DATE] + ")=" + JSPFormater.formatDate(dt, "yyyy");

        Vector temp = list(0, 0, where, "");
        if (temp != null && temp.size() > 0) {
            return (Periode) temp.get(0);
        }

        return new Periode();

    }

    public static Date getOpenPeriodLastYear() {

        Periode periode = getOpenPeriod();

        Date opnPeriode = periode.getStartDate();

        int dt = opnPeriode.getDate();
        int mnth = opnPeriode.getMonth() + 1;
        int year = opnPeriode.getYear() + 1900 - 1;

        String date = "" + year + "-" + mnth + "-" + dt;

        Date dt_date = JSPFormater.formatDate(date, "yyyy-MM-dd");

        if (dt_date != null) {
            return dt_date;
        } else {
            return null;
        }
    }

    public static Periode getOpnPeriodLastYear() {

        Periode periode = getOpenPeriod();

        Date opnPeriode = periode.getStartDate();

        int dt = opnPeriode.getDate();
        int mnth = opnPeriode.getMonth() + 1;
        int year = opnPeriode.getYear() + 1900 - 1;

        String date = "" + year + "-" + mnth + "-" + dt;

        String where = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " = '" + date + "'";

        Vector v = DbPeriode.list(0, 0, where, "");

        if (v != null && v.size() > 0) {
            return (Periode) v.get(0);
        }

        return null;

    }

    public static Periode getPeriodByTransDate(Date dt) {
        String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between start_date and end_date ";

        Vector v = DbPeriode.list(0, 0, where, "");

        if (v != null && v.size() > 0) {
            return (Periode) v.get(0);
        }

        return new Periode();
    }

    public static Vector getAllPeriodInYear(Date dt) {

        String where = "year('" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "') = year(" + colNames[COL_START_DATE] + ")";

        return list(0, 0, where, null);

    }

    public static void openNewAccPeriod(Periode newAp) {

        Vector temp = list(0, 0, colNames[COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "' and " + colNames[COL_TYPE] + "<>" + TYPE_PERIOD13, "");

        if (temp != null && temp.size() > 0) {

            Periode per = (Periode) temp.get(0);
            try {
                per.setStatus(I_Project.STATUS_PERIOD_PRE_CLOSED);
                updateExc(per);
            } catch (Exception e) {

            }

        }

        newAp.setStatus(I_Project.STATUS_PERIOD_OPEN);

        String strStartDate = "'" + JSPFormater.formatDate(newAp.getStartDate(), "yyyy-MM-dd") + "'";
        String strEndDate = "'" + JSPFormater.formatDate(newAp.getEndDate(), "yyyy-MM-dd") + "'";

        String where = "((start_date between " + strStartDate + " and " + strEndDate + ")" +
                " or (end_date between " + strStartDate + " and " + strEndDate + "))" +
                " and " + DbPeriode.colNames[DbPeriode.COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_PREPARED_OPEN + "'";

        Vector v = DbPeriode.list(0, 0, where, "");

        long oid = 0;

        //jika tidak ada periode dengan status open, pada tanggal pencarian,
        //buat periode baru
        //khusus untuk konsumen yang tidak menginput semua peridenya dalam 1 th
        //status langsung open 
        if (v == null || v.size() == 0) {
            try {
                oid = DbPeriode.insertExc(newAp);
            } catch (Exception e) {
            }
        } else {
            newAp = (Periode) v.get(0);
            newAp.setStatus(I_Project.STATUS_PERIOD_OPEN);
            try {
                oid = DbPeriode.updateExc(newAp);
            } catch (Exception e) {
            }
        }
    }

    public static boolean isPreClosedPeriodExist() {
        if (getCount(colNames[COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'") > 0) {
            return true;
        }

        return false;
    }

    public static Periode getPreClosedPeriod() {
        Vector temp = list(0, 0, colNames[COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'", DbPeriode.colNames[DbPeriode.COL_START_DATE]);
        if (temp != null && temp.size() > 0) {
            return (Periode) temp.get(0);
        }

        return new Periode();
    }

    
    public static long closePeriod(long periodeId,long openPeriodeId,boolean isYearlyClosing){
        Periode preClosedPeriod = new Periode();
        try{
            preClosedPeriod = DbPeriode.fetchExc(periodeId);
        }catch(Exception e){}
        
        Periode openPeriod = new Periode();
        try{
            openPeriod = DbPeriode.fetchExc(openPeriodeId);
        }catch(Exception e){}
        
        if(preClosedPeriod.getOID() != 0 && openPeriod.getOID() != 0){    
            
            goOpeningBalance(preClosedPeriod,openPeriod,isYearlyClosing);   
            
            int isApplyPeriod13 = openPeriod.getApplyPeriod13();
            
            if (isYearlyClosing && isApplyPeriod13 == 1) {
                String per13Name = openPeriod.getPeriod13Name();
                int year = openPeriod.getStartDate().getYear() - 1;
                Calendar calendar = new GregorianCalendar(1900+year, 11, 30);
                Date startDate = calendar.getTime();
                Date endDate = (Date)startDate.clone();
                endDate.setDate(31);
                        
                Periode periode13 = new Periode();
                periode13.setType(DbPeriode.TYPE_PERIOD13);
                periode13.setName(per13Name);
                periode13.setStartDate(startDate);
                periode13.setEndDate(endDate);
                periode13.setInputTolerance(endDate);
                periode13.setStatus(I_Project.STATUS_PERIOD_OPEN);
                
                try{
                    long idPeriode13 = DbPeriode.insertExc(periode13);
                    periode13 = DbPeriode.fetchExc(idPeriode13);                    
                    goOpeningBalance(preClosedPeriod,periode13,false);                    
                }catch(Exception e){}
            }
            try{
                preClosedPeriod.setStatus(I_Project.STATUS_PERIOD_CLOSED);
                DbPeriode.updateExc(preClosedPeriod);
            }catch(Exception e){}
            
        }
        return 0;
    }
    
    public static void goOpeningBalance(Periode p,Periode open,boolean isYearlyClosing){    
        
        CONResultSet dbrs = null;
        Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
        Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));
        DbCoaOpeningBalance.deleteByPeriod(open.getOID());
        DbCoaOpeningBalanceLocation.deleteByPeriod(open.getOID(),-1);
        
        try {
            String sql = "";            
            
            if (p.getTableName().equals(I_Project.GL)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            } else if (p.getTableName().equals(I_Project.GL_2015)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl_2015 g inner join gl_detail_2015 gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            } else if (p.getTableName().equals(I_Project.GL_2016)) {
                sql = "select gd.coa_id as coa_id,c.code as code,acc_ref_id as ref_id,c.level as level,c.account_group as account_group,sum(debet) as debet,sum(credit) as credit,gd.segment1_id as segment1_id from gl_2016 g inner join gl_detail_2016 gd on g.gl_id = gd.gl_id inner join coa c on gd.coa_id = c.coa_id where g.period_id = " + p.getOID()+" and g.posted_status=1 ";
            }            
            if (isYearlyClosing) {
                sql = sql+ " and c.account_group <> 'Revenue' and c.account_group <> 'Cost Of Sales' and c.account_group <> 'Expense' and c.account_group <> 'Other Expense' and c.account_group <> 'Other Revenue' ";
            }    
            sql = sql + " group by gd.segment1_id,gd.coa_id ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {                
                
                CoaOpeningBalanceLocation bg = new CoaOpeningBalanceLocation();

                String accGroup = rs.getString("account_group");
                double debet = rs.getDouble("debet");
                double credit = rs.getDouble("credit");
                long coaId = rs.getLong("coa_id");
                String code = rs.getString("code");
                int level = rs.getInt("level");
                long refId = rs.getLong("ref_id");
                long segment1 = rs.getLong("segment1_id");
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
                
                amount = amount + openingBefore;
                
                bg.setPeriodeId(open.getOID());                              
                bg.setCoaId(coaId);
                bg.setSegment1Id(segment1);

                if (!(coaLabaLalu.getCode().equals(code) || coaLabaBerjalan.getCode().equals(code))) {
                    
                    bg.setOpeningBalance(amount);  
                   
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
                    DbCoaOpeningBalanceLocation.insertExc(bg);
                }catch(Exception e){}
            }
            rs.close();
            
            Vector vSegment = new Vector();                    
            try{
                String whereSegment = DbSegment.colNames[DbSegment.COL_COUNT]+" = 1"; // default untuk urut 1 adalah lokasi
                vSegment = DbSegment.list(0, 1, whereSegment, null);                        
                Segment segment = new Segment();
        
                if(vSegment != null && vSegment.size() > 0){
                    segment = (Segment)vSegment.get(0);
                    Vector vSegmentDetail = new Vector();
       
                    if(segment.getOID() != 0){
                        String whereSD = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID]+" = "+segment.getOID();
                        vSegmentDetail = DbSegmentDetail.list(0, 0, whereSD, null);                        
                        for(int t = 0 ; t < vSegmentDetail.size() ; t++){
                            SegmentDetail sd = (SegmentDetail)vSegmentDetail.get(t);
                            
                            //======Laba Tahun Lalu===================================
                            double balance = DbGlDetail.getClosingBalance(coaLabaLalu.getOID(), p, sd.getOID());                            
                            if (isYearlyClosing) {                                
                                double labaBerjalan = DbGlDetail.getClosingCurrentEarning(coaLabaBerjalan.getOID(), p, sd.getOID());
                                balance = balance + labaBerjalan;
                            }
                            long coaId = coaLabaLalu.getOID();
                            long refId = coaLabaLalu.getAccRefId();
                            CoaOpeningBalanceLocation bg = new CoaOpeningBalanceLocation();
                            bg.setPeriodeId(open.getOID());                              
                            bg.setCoaId(coaLabaLalu.getOID());
                            bg.setSegment1Id(sd.getOID());
                            bg.setOpeningBalance(balance);
                            Coa coa = new Coa();
                            switch (coaLabaLalu.getLevel()) {
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
                                if(bg.getOpeningBalance() != 0){
                                    DbCoaOpeningBalanceLocation.insertExc(bg);
                                }
                            }catch(Exception e){}
                            //================================================
                            
                            //==========LABA TAHUN BERJALAN
                            if (!isYearlyClosing){
                                coaId = coaLabaBerjalan.getOID();
                                refId = coaLabaBerjalan.getAccRefId();
                                balance = DbGlDetail.getClosingCurrentEarning(coaLabaBerjalan.getOID(), p, sd.getOID());
                                bg = new CoaOpeningBalanceLocation();
                                bg.setPeriodeId(open.getOID());                              
                                bg.setCoaId(coaLabaBerjalan.getOID());
                                bg.setSegment1Id(sd.getOID());
                                bg.setOpeningBalance(balance);                            
                                switch (coaLabaBerjalan.getLevel()) {
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
                                if(bg.getOpeningBalance() != 0){
                                    DbCoaOpeningBalanceLocation.insertExc(bg);
                                }
                            }catch(Exception e){}
                            }
                        }
                    }
                }
            }catch(Exception e){}
            
            String sql2 = DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID]+" = "+p.getOID();
            Vector balances = DbCoaOpeningBalanceLocation.list(0,0,sql2,null);
            if(balances != null && balances.size() > 0){
                for(int i=0 ; i < balances.size(); i++){
                    CoaOpeningBalanceLocation bl = (CoaOpeningBalanceLocation)balances.get(i);
                    String wh = DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID]+" = "+open.getOID()+" and "+
                            DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_ID]+" = "+bl.getCoaId()+" and "+
                            DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_SEGMENT1_ID]+" = "+bl.getSegment1Id();                 
                    int count = DbCoaOpeningBalanceLocation.getCount(wh);
                    
                    boolean ok = true;
                    if(isYearlyClosing && coaLabaBerjalan.getOID()==bl.getCoaId()){
                       ok = false; 
                    }
                    
                    if(count==0 && ok){
                        CoaOpeningBalanceLocation bg = new CoaOpeningBalanceLocation();   
                        long coaId = bl.getCoaId();
                        bg.setPeriodeId(open.getOID());                              
                        bg.setCoaId(coaId);
                        bg.setSegment1Id(bl.getSegment1Id());
                        bg.setOpeningBalance(bl.getOpeningBalance());  
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
                            if(bg.getOpeningBalance() != 0){
                                DbCoaOpeningBalanceLocation.insertExc(bg);
                            }
                        }catch(Exception e){}                        
                    }
                }
            }
            DbCoaOpeningBalanceLocation.deleteByPeriod(open.getOID(),0);

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }        
    }
    /** 
     * close period bisa handle, periode yang di pre-setup (jan-des dibuat dahulu dengan memberi 
     * status STATUS_PERIOD_PREPARED_OPEN, ketika closing periode, system akan mencari periode 
     * dengan STATUS_PERIOD_PREPARED_OPEN untuk diupdate statusnya ke OPEN, dan mengupdate status
     * periode lama ke CLOSED.
     * tetapi apabila customer tidak melakukan pre-setup periode (periode dibuat saat close periode
     * dilakukan, maka system akan membuat periode baru ketika pencarian periode dengan status
     * STATUS_PERIOD_PREPARED_OPEN tidak ditemukan.		 
     **/
    public static String closePeriod(Periode newPeriod, boolean isYearlyClosing) {        
        
        int isApplyPeriod13 = newPeriod.getApplyPeriod13();
        String per13Name = newPeriod.getPeriod13Name();
        Periode preClosedPeriod = getPreClosedPeriod();
        newPeriod = getOpenPeriod();
        long oid = newPeriod.getOID();

        //jika sebelumnya tidak ada periode yang OPEN
        if (newPeriod.getOID() == 0) {

            newPeriod.setStatus(I_Project.STATUS_PERIOD_OPEN);

            String strStartDate = "'" + JSPFormater.formatDate(newPeriod.getStartDate(), "yyyy-MM-dd") + "'";
            String strEndDate = "'" + JSPFormater.formatDate(newPeriod.getEndDate(), "yyyy-MM-dd") + "'";

            String where = "(start_date between " + strStartDate + " and " + strEndDate + ")" +
                    " or (end_date between " + strStartDate + " and " + strEndDate + ")" +
                    " and " + DbPeriode.colNames[DbPeriode.COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_PREPARED_OPEN + "'";

            Vector v = DbPeriode.list(0, 0, where, "");

            //jika tidak ada yang prepared open, buat langsung periode baru
            if (v == null || v.size() == 0) {
                try {
                    oid = DbPeriode.insertExc(newPeriod);
                } catch (Exception e) {
                }
            } else {
                newPeriod = (Periode) v.get(0);
                newPeriod.setStatus(I_Project.STATUS_PERIOD_OPEN);
                try {
                    oid = DbPeriode.updateExc(newPeriod);
                } catch (Exception e) {}
            }
        }

        try {
            if (preClosedPeriod.getOID() != 0){
                if (oid != 0) {
                    //update status old period
                    preClosedPeriod.setStatus(I_Project.STATUS_PERIOD_CLOSED);
                    long oidClosed = DbPeriode.updateExc(preClosedPeriod);

                    //generate opening balance for new period                    
                    DbCoa.getOpeningBalanceClosing(preClosedPeriod, isYearlyClosing);
                    
                    //jika menggunakan segment
                    Vector vSegment = new Vector();                    
                    try{
                        String whereSegment = DbSegment.colNames[DbSegment.COL_COUNT]+" = 1"; // default untuk urut 1 adalah lokasi
                        vSegment = DbSegment.list(0, 1, whereSegment, null);                        
                        Segment segment = new Segment();
        
                        if(vSegment != null && vSegment.size() > 0){
                            segment = (Segment)vSegment.get(0);
                            DbCoa.getOpeningBalanceClosingBySegment(preClosedPeriod, isYearlyClosing, segment.getOID());
                        }
                    }catch(Exception e){}

                    /**
                     * jika yearly closing, lakukan open period 13
                     * eka ds
                     * update by gwawan, june 2012
                     */
                    if (isYearlyClosing && isApplyPeriod13 == 1) {
                        int year = newPeriod.getStartDate().getYear() - 1;
                        Calendar calendar = new GregorianCalendar(1900+year, 11, 30);
                        Date startDate = calendar.getTime();
                        Date endDate = (Date)startDate.clone();
                        endDate.setDate(31);
                        
                        Periode periode13 = new Periode();
                        periode13.setType(DbPeriode.TYPE_PERIOD13);
                        periode13.setName(per13Name);
                        periode13.setStartDate(startDate);
                        periode13.setEndDate(endDate);
                        periode13.setInputTolerance(endDate);
                        periode13.setStatus(I_Project.STATUS_PERIOD_OPEN);

                        long idPeriode13 = DbPeriode.insertExc(periode13);
                        periode13 = DbPeriode.fetchExc(idPeriode13);
                        
                        DbCoa.getOpeningBalanceClosingFor13(preClosedPeriod, periode13, false);                        
                        
                        try{
                            if(vSegment != null && vSegment.size() > 0){
                                Segment segment = (Segment)vSegment.get(0);
                                DbCoa.getOpeningBalanceClosingFor13BySegment(preClosedPeriod, periode13, false, segment.getOID()); 
                            }
                        }catch(Exception e){}
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return "";
    }

    /* close period bisa handle, periode yang di pre-setup (jan-des dibuat dahulu dengan memberi 
     * status STATUS_PERIOD_PREPARED_OPEN, ketika closing periode, system akan mencari periode 
     * dengan STATUS_PERIOD_PREPARED_OPEN untuk diupdate statusnya ke OPEN, dan mengupdate status
     * periode lama ke CLOSED.
     * tetapi apabila customer tidak melakukan pre-setup periode (periode dibuat saat close periode
     * dilakukan, maka system akan membuat periode baru ketika pencarian periode dengan status
     * STATUS_PERIOD_PREPARED_OPEN tidak ditemukan.		 
     **/
    
    public static String closePeriodYearly(Periode newPeriod, boolean isYearlyClosing) {

        int isApplyPeriod13 = newPeriod.getApplyPeriod13();
        String per13Name = newPeriod.getPeriod13Name();
        Periode preClosedPeriod = getPreClosedPeriod();
        newPeriod = getOpenPeriod();
        long oid = newPeriod.getOID();
        
        /*int isApplyPeriod13 = newPeriod.getApplyPeriod13();
        String per13Name = newPeriod.getPeriod13Name();
        Periode preClosedPeriod = getOpenPeriod();
        long oid = 0;*/

        newPeriod.setStatus(I_Project.STATUS_PERIOD_OPEN);
        String strStartDate = "'" + JSPFormater.formatDate(newPeriod.getStartDate(), "yyyy-MM-dd") + "'";
        String strEndDate = "'" + JSPFormater.formatDate(newPeriod.getEndDate(), "yyyy-MM-dd") + "'";

        String where = "(start_date between " + strStartDate + " and " + strEndDate + ")" +
                " or (end_date between " + strStartDate + " and " + strEndDate + ")" +
                " and " + DbPeriode.colNames[DbPeriode.COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_PREPARED_OPEN + "'";

        Vector v = DbPeriode.list(0, 0, where, "");

        //jika tidak ada periode dengan status open, pada tanggal pencarian, buat periode baru
        //khusus untuk konsumen yang tidak menginput semua periodenya dalam 1 tahun status langsung open
        if (v == null || v.size() == 0) {
            try {
                oid = DbPeriode.insertExc(newPeriod);
            } catch (Exception e) {
            }
        } else {
            newPeriod = (Periode) v.get(0);
            newPeriod.setStatus(I_Project.STATUS_PERIOD_OPEN);
            try {
                oid = DbPeriode.updateExc(newPeriod);
            } catch (Exception e) {
            }
        }

        try {
            if (preClosedPeriod.getOID() != 0) {
                if (oid != 0) {
                    //update status old period
                    preClosedPeriod.setStatus(I_Project.STATUS_PERIOD_CLOSED);
                    long oidClosed = DbPeriode.updateExc(preClosedPeriod);

                    //generate opening balance for new open period
                    DbCoa.getOpeningBalanceClosing(preClosedPeriod, isYearlyClosing);
                    //jika menggunakan segment
                    Vector vSegment = new Vector();
                    
                    try{
                        String whereSegment = DbSegment.colNames[DbSegment.COL_COUNT]+" = 1";
                        vSegment = DbSegment.list(0, 1, whereSegment, null);
                        
                        Segment segment = new Segment();
        
                        if(vSegment != null && vSegment.size() > 0){
                            segment = (Segment)vSegment.get(0);
                            DbCoa.getOpeningBalanceClosingBySegment(preClosedPeriod, isYearlyClosing, segment.getOID());
                        }
                    }catch(Exception e){}                    

                    /**
                     * jika yearly closing, lakukan open period 13
                     * eka ds
                     * update by gwawan, june 2012
                     */
                    if (isYearlyClosing && isApplyPeriod13 == 1) {
                        int year = newPeriod.getStartDate().getYear() - 1;
                        Calendar calendar = new GregorianCalendar(1900+year, 11, 30);
                        Date startDate = calendar.getTime();
                        Date endDate = (Date)startDate.clone();
                        endDate.setDate(31);
                        
                        Periode periode13 = new Periode();
                        periode13.setType(DbPeriode.TYPE_PERIOD13);
                        periode13.setName(per13Name);
                        periode13.setStartDate(startDate);
                        periode13.setEndDate(endDate);
                        periode13.setInputTolerance(endDate);
                        periode13.setStatus(I_Project.STATUS_PERIOD_OPEN);

                        long idPeriode13 = DbPeriode.insertExc(periode13);
                        periode13 = DbPeriode.fetchExc(idPeriode13);

                        DbCoa.getOpeningBalanceClosingFor13(preClosedPeriod, periode13, false);
                        
                        try{
                            if(vSegment != null && vSegment.size() > 0){
                                Segment segment = (Segment)vSegment.get(0);
                                DbCoa.getOpeningBalanceClosingFor13BySegment(preClosedPeriod, periode13, false, segment.getOID()); 
                            }
                        }catch(Exception e){}
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return "";
    }
    
    /**
     * Method for closing Period 13th
     * Condition: Period I (January) for next year have been setup and still OPEN
     * by gwawan, june 2012
     * 
     * @param newPeriod
     * @param isYearlyClosing
     * @return
     */
    public static boolean closePeriod13(Periode periode13) {
        
        /**
         * Get Period I (January) must be OPEN
         */
        Periode periode1 = new Periode();
        int nextYear = periode13.getStartDate().getYear() + 1 + 1900;
        String where = colNames[COL_START_DATE] + " LIKE '" + nextYear +"-01-01' AND " + 
                colNames[COL_STATUS] + " LIKE '" + I_Project.STATUS_PERIOD_OPEN + "'";
        Vector vPeriode = DbPeriode.list(0, 0, where, "");
        
        if(vPeriode != null && vPeriode.size() > 0) {
            for(int i=0; i<vPeriode.size(); i++) {
                periode1 = (Periode) vPeriode.get(i);
            }
        }
        
        /**
         * Return false if Period I not found
         */
        if(periode1.getOID() == 0) return false;
        
        /**
         * Update opening balance Period I
         */
        DbCoa.updateOpeningBalanceFromPeriode13(periode13, periode1);
        
        /**
         * Update status Periode 13th to Closed
         */
        periode13.setStatus(I_Project.STATUS_PERIOD_CLOSED);
        try {
            DbPeriode.updateExc(periode13);
            return true;
        } catch(Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        return false;
    }

    public static Periode getPrevPeriode(Periode periode) {

        Date startDate = periode.getStartDate();
        Date xDate = (Date) startDate.clone();
        xDate.setDate(xDate.getDate() - 10);

        String where = "('" + JSPFormater.formatDate(xDate, "yyyy-MM-dd") + "' between " +
                colNames[COL_START_DATE] + " and " + colNames[COL_END_DATE];

        Vector v = DbPeriode.list(0, 0, where, "");
        if (v != null && v.size() > 0) {
            return (Periode) v.get(0);
        }

        return new Periode();

    }

    public static Periode getNextPeriode(Periode openPeriod) {
        Date endDate = openPeriod.getEndDate();
        Date xDate = (Date) endDate.clone();
        xDate.setDate(xDate.getDate() + 10);

        String where = "('" + JSPFormater.formatDate(xDate, "yyyy-MM-dd") + "' BETWEEN " + colNames[COL_START_DATE] + " AND " + colNames[COL_END_DATE] + ")" +
                " AND " + colNames[COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_PREPARED_OPEN + "'";
        
        Vector v = DbPeriode.list(0, 0, where, "");
        if (v != null && v.size() > 0) {
            return (Periode) v.get(0);
        }

        return new Periode();

    }

    /**
     * @Author  Roy Andika
     * @param   periode
     * @return
     */
    public static Periode getLastYearOpenPeriod(Periode periode) {

        int date = periode.getStartDate().getDate() + 1;
        int month = periode.getStartDate().getMonth() + 1;
        int year = periode.getStartDate().getYear() + 1900 - 1;

        try {
            String str_previous_periode = "" + year + "-" + month + "-" + date;
            String where = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " = '" + str_previous_periode + "'";
            Vector list_period_lastYear = DbPeriode.list(0, 1, where, null);

            if (list_period_lastYear != null && list_period_lastYear.size() > 0) {
                Periode objPeriode = (Periode) list_period_lastYear.get(0);
                return objPeriode;
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return null;
    }
    
    /**
     * Fungsi untuk memvalidasi sebuah tanggal terhadap rentang waktu sebuah periode
     * create by gwawan 201209
     * @param periodId
     * @param date
     * @return
     */
    public static boolean isValidDate(long periodId, Date date) {
        try {
            String where = "'" + JSPFormater.formatDate(date, "yyyy-MM-dd") + "' BETWEEN start_date AND end_date " +
                    " AND " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId;
            Vector v = DbPeriode.list(0, 0, where, "");
            if(v != null && v.size() > 0) return true;
        } catch(Exception e) {
            System.out.println("[Exception] "+e.toString());
        }
        return false;
    }
    
    /**
     * Fungsi untuk melakukan pengecekkan dokumen sebelum proses tutup periode
     * by gwawan 201209
     * @param periodeId
     * @return
     */
    public static Vector preClosingPeriod(long periodeId){
        Vector vList = new Vector();
        
        try {
            //pettycash payment (pembayaran tunai)
            String where = DbPettycashPayment.colNames[DbPettycashPayment.COL_PERIODE_ID]+"="+periodeId+
                    " AND "+DbPettycashPayment.colNames[DbPettycashPayment.COL_POSTED_STATUS]+"="+DbGl.NOT_POSTED;
            Vector vCashPayment = DbPettycashPayment.list(0, 0, where, "");
            if(vCashPayment != null && vCashPayment.size() > 0) {
                for(int i=0; i<vCashPayment.size(); i++) {
                    PettycashPayment pp = (PettycashPayment)vCashPayment.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(pp.getOID());
                    obj.setNumber(pp.getJournalNumber());
                    obj.setMemo(pp.getMemo());
                    vList.add(obj);
                }
            }
            
            //cash receive (penerimaan tunai)
            where = DbCashReceive.colNames[DbCashReceive.COL_PERIODE_ID]+"="+periodeId+
                    " AND "+DbCashReceive.colNames[DbCashReceive.COL_POSTED_STATUS]+"="+DbGl.NOT_POSTED;
            Vector vCashReceive = DbCashReceive.list(0, 0, where, "");
            if(vCashReceive != null && vCashReceive.size() > 0) {
                for(int i=0; i<vCashReceive.size(); i++) {
                    CashReceive cr = (CashReceive)vCashReceive.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(cr.getOID());
                    obj.setNumber(cr.getJournalNumber());
                    obj.setMemo(cr.getMemo());
                    vList.add(obj);
                }
            }
            
            //bank deposit (setoran bank)
            where = DbBankDeposit.colNames[DbBankDeposit.COL_PERIODE_ID]+"="+periodeId+
                    " AND "+DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS]+"="+DbGl.NOT_POSTED;
            Vector vBankDeposit = DbBankDeposit.list(0, 0, where, "");
            if(vBankDeposit != null && vBankDeposit.size() > 0) {
                for(int i=0; i<vBankDeposit.size(); i++) {
                    BankDeposit bd = (BankDeposit)vBankDeposit.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(bd.getOID());
                    obj.setNumber(bd.getJournalNumber());
                    obj.setMemo(bd.getMemo());
                    vList.add(obj);
                }
            }
            
            //bank po payment (pembayaran bank dng PO)
            where = DbBankpoPayment.colNames[DbBankpoPayment.COL_PERIODE_ID]+"="+periodeId+
                    " AND "+DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+"="+DbGl.NOT_POSTED;
            Vector vBankPoPayment = DbBankpoPayment.list(0, 0, where, "");
            if(vBankPoPayment != null && vBankPoPayment.size() > 0) {
                for(int i=0; i<vBankPoPayment.size(); i++) {
                    BankpoPayment bankPo = (BankpoPayment)vBankPoPayment.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(bankPo.getOID());
                    obj.setNumber(bankPo.getJournalNumber());
                    obj.setMemo(bankPo.getMemo());
                    vList.add(obj);
                }
            }
            
            //bank non po payment (pembayaran bank tanpa PO)
            where = DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_PERIODE_ID]+"="+periodeId+
                    " AND "+DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_POSTED_STATUS]+"="+DbGl.NOT_POSTED;
            Vector vBankNonPoPayment = DbBanknonpoPayment.list(0, 0, where, "");
            if(vBankNonPoPayment != null && vBankNonPoPayment.size() > 0) {
                for(int i=0; i<vBankNonPoPayment.size(); i++) {
                    BanknonpoPayment bankNonPo = (BanknonpoPayment)vBankNonPoPayment.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(bankNonPo.getOID());
                    obj.setNumber(bankNonPo.getJournalNumber());
                    obj.setMemo(bankNonPo.getMemo());
                    vList.add(obj);
                }
            }
            
            //general ledger (jurnal umum)
            where = DbGl.colNames[DbGl.COL_PERIOD_ID]+"="+periodeId+
                    " AND "+DbGl.colNames[DbGl.COL_POSTED_STATUS]+"="+DbGl.NOT_POSTED;
            Vector vGl = DbGl.list(0, 0, where, "");
            if(vGl != null && vGl.size() > 0) {
                for(int i=0; i<vGl.size(); i++) {
                    Gl gl = (Gl)vGl.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(gl.getOID());
                    obj.setNumber(gl.getJournalNumber());
                    obj.setMemo(gl.getMemo());
                    vList.add(obj);
                }
            }
            
            //Receiving
            Periode periode = new Periode();
            try{
                periode = DbPeriode.fetchExc(periodeId);
            }catch(Exception e){}
            
            where = DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" >= '"+JSPFormater.formatDate(periode.getStartDate(),"yyyy-MM-dd")+" 00:00:00' and "+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" <= '"+JSPFormater.formatDate(periode.getEndDate(),"yyyy-MM-dd")+" 23:59:59' "+
                    " AND "+DbReceive.colNames[DbReceive.COL_STATUS]+" = '"+I_Project.DOC_STATUS_APPROVED+"' and "+DbReceive.colNames[DbReceive.COL_TYPE_AP]+" in ("+DbReceive.TYPE_AP_NO+","+DbReceive.TYPE_AP_YES+","+DbReceive.TYPE_AP_REC_ADJ_BY_QTY+","+DbReceive.TYPE_AP_REC_ADJ_BY_PRICE+" )";
            Vector vRc = DbReceive.list(0, 0, where, null);
            
            if(vRc != null && vRc.size() > 0) {
                for(int i=0; i<vRc.size(); i++) {                    
                    Receive r = (Receive)vRc.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(r.getOID());
                    obj.setNumber(r.getNumber());
                    obj.setMemo(r.getNote());
                    vList.add(obj);                    
                }
            }
            
            where = DbRetur.colNames[DbRetur.COL_APPROVAL_1_DATE]+" >= '"+JSPFormater.formatDate(periode.getStartDate(),"yyyy-MM-dd")+" 00:00:00' and "+DbRetur.colNames[DbRetur.COL_APPROVAL_1_DATE]+" <= '"+JSPFormater.formatDate(periode.getEndDate(),"yyyy-MM-dd")+" 23:59:59' "+
                    " AND "+DbRetur.colNames[DbRetur.COL_STATUS]+" = '"+I_Project.DOC_STATUS_APPROVED+"' ";
            Vector vRetur = DbRetur.list(0, 0, where, null);
            
            if(vRetur != null && vRetur.size() > 0) {
                for(int i=0; i<vRetur.size(); i++) {                    
                    Retur r = (Retur)vRetur.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(r.getOID());
                    obj.setNumber(r.getNumber());
                    obj.setMemo(r.getNote());
                    vList.add(obj);                    
                }
            }
            
            where = DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_1_DATE]+" >= '"+JSPFormater.formatDate(periode.getStartDate(),"yyyy-MM-dd")+" 00:00:00' and "+DbAdjusment.colNames[DbAdjusment.COL_APPROVAL_1_DATE]+" <= '"+JSPFormater.formatDate(periode.getEndDate(),"yyyy-MM-dd")+" 23:59:59' "+
                    " AND "+DbRetur.colNames[DbRetur.COL_STATUS]+" = '"+I_Project.DOC_STATUS_APPROVED+"' ";
            Vector vAdj = DbAdjusment.list(0, 0, where, null);
            
            if(vAdj != null && vAdj.size() > 0) {
                for(int i=0; i<vAdj.size(); i++) {                    
                    Adjusment r = (Adjusment)vAdj.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(r.getOID());
                    obj.setNumber(r.getNumber());
                    obj.setMemo(r.getNote());
                    vList.add(obj);                    
                }
            }
            
            where = DbCosting.colNames[DbCosting.COL_DATE]+" >= '"+JSPFormater.formatDate(periode.getStartDate(),"yyyy-MM-dd")+" 00:00:00' and "+DbCosting.colNames[DbCosting.COL_DATE]+" <= '"+JSPFormater.formatDate(periode.getEndDate(),"yyyy-MM-dd")+" 23:59:59' "+
                    " AND "+DbCosting.colNames[DbCosting.COL_STATUS]+" = '"+I_Project.DOC_STATUS_APPROVED+"' ";
            Vector vCosting = DbCosting.list(0, 0, where, null);
            
            if(vCosting != null && vCosting.size() > 0) {
                for(int i=0; i<vCosting.size(); i++) {                    
                    Costing r = (Costing)vCosting.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(r.getOID());
                    obj.setNumber(r.getNumber());
                    obj.setMemo(r.getNote());
                    vList.add(obj);                    
                }
            }
            
            where = DbRepack.colNames[DbRepack.COL_DATE]+" >= '"+JSPFormater.formatDate(periode.getStartDate(),"yyyy-MM-dd")+" 00:00:00' and "+DbRepack.colNames[DbRepack.COL_DATE]+" <= '"+JSPFormater.formatDate(periode.getEndDate(),"yyyy-MM-dd")+" 23:59:59' "+
                    " AND "+DbRepack.colNames[DbRepack.COL_STATUS]+" = '"+I_Project.DOC_STATUS_APPROVED+"' ";
            Vector vRepack = DbRepack.list(0, 0, where, null);
            
            if(vRepack != null && vRepack.size() > 0) {
                for(int i=0; i<vRepack.size(); i++) {                    
                    Repack r = (Repack)vRepack.get(i);
                    CommonObj obj = new CommonObj();
                    obj.setId(r.getOID());
                    obj.setNumber(r.getNumber());
                    obj.setMemo(r.getNote());
                    vList.add(obj);                    
                }
            }
            
            
        } catch(Exception e) {}
        
        return vList;
    }
    
    
    
}
