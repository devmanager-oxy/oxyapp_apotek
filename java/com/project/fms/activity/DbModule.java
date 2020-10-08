package com.project.fms.activity;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;

public class DbModule extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_MODULE = "module";
    public static final int COL_MODULE_ID = 0;
    public static final int COL_PARENT_ID = 1;
    public static final int COL_CODE = 2;
    public static final int COL_LEVEL = 3;
    public static final int COL_DESCRIPTION = 4;
    public static final int COL_OUTPUT_DELIVER = 5;
    public static final int COL_PERFORM_INDICATOR = 6;
    public static final int COL_ASSUM_RISK = 7;
    public static final int COL_STATUS = 8;
    public static final int COL_TYPE = 9;
    public static final int COL_COST_IMPLICATION = 10;
    public static final int COL_INITIAL = 11;
    public static final int COL_EXPIRED_DATE = 12;
    public static final int COL_POSITION_LEVEL = 13;
    public static final int COL_ACTIVITY_PERIOD_ID = 14;
    public static final int COL_SEGMENT1_ID = 15;
    public static final int COL_SEGMENT2_ID = 16;
    public static final int COL_SEGMENT3_ID = 17;
    public static final int COL_SEGMENT4_ID = 18;
    public static final int COL_SEGMENT5_ID = 19;
    public static final int COL_SEGMENT6_ID = 20;
    public static final int COL_SEGMENT7_ID = 21;
    public static final int COL_SEGMENT8_ID = 22;
    public static final int COL_SEGMENT9_ID = 23;
    public static final int COL_SEGMENT10_ID = 24;
    public static final int COL_SEGMENT11_ID = 25;
    public static final int COL_SEGMENT12_ID = 26;
    public static final int COL_SEGMENT13_ID = 27;
    public static final int COL_SEGMENT14_ID = 28;
    public static final int COL_SEGMENT15_ID = 29;
    public static final int COL_ACT_DAY = 30;
    public static final int COL_ACT_TIME = 31;
    public static final int COL_ACT_DATE = 32;
    public static final int COL_NOTE = 33;
    public static final int COL_TOTAL_BUDGET = 34;
    public static final int COL_TOTAL_BUDGET_USED = 35;
    public static final int COL_MODULE_LEVEL = 36;    
    public static final int COL_DOC_STATUS = 37;
    public static final int COL_CREATE_ID = 38;
    public static final int COL_CREATE_DATE = 39;    
    public static final int COL_APPROVAL1_ID = 40;
    public static final int COL_APPROVAL1_DATE = 41;
    
    public static final String[] colNames = {
        "module_id",
        "parent_id",
        "code",
        "level",
        "description",
        "output_deliver",
        "perform_indicator",
        "assum_risk",
        "status",
        "type",
        "cost_implication",
        "initial",
        "expired_date",
        "position_level",
        "activity_period_id",
        "segment1_id",
        "segment2_id",
        "segment3_id",
        "segment4_id",
        "segment5_id",
        "segment6_id",
        "segment7_id",
        "segment8_id",
        "segment9_id",
        "segment10_id",
        "segment11_id",
        "segment12_id",
        "segment13_id",
        "segment14_id",
        "segment15_id",
        "act_day",
        "act_time",
        "act_date",
        "note",
        "total_budget",
        "total_budget_used",
        "module_level",
        "doc_status",
        "create_id",
        "create_date",
        "approval1_id",
        "approval1_date"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        //segment
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,         
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE
    };
    
    public static final int DOC_STATUS_DRAFT     = 0;
    public static final int DOC_STATUS_APPROVE   = 1;

    public DbModule() {
    }

    public DbModule(int i) throws CONException {
        super(new DbModule());
    }

    public DbModule(String sOid) throws CONException {
        super(new DbModule(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbModule(long lOid) throws CONException {
        super(new DbModule(0));
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
        return DB_MODULE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbModule().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Module module = fetchExc(ent.getOID());
        ent = (Entity) module;
        return module.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Module) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Module) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Module fetchExc(long oid) throws CONException {
        try {
            Module module = new Module();
            DbModule dbModule = new DbModule(oid);
            module.setOID(oid);

            module.setParentId(dbModule.getlong(COL_PARENT_ID));
            module.setCode(dbModule.getString(COL_CODE));
            module.setLevel(dbModule.getString(COL_LEVEL));
            module.setDescription(dbModule.getString(COL_DESCRIPTION));
            module.setOutputDeliver(dbModule.getString(COL_OUTPUT_DELIVER));
            module.setPerformIndicator(dbModule.getString(COL_PERFORM_INDICATOR));
            module.setAssumRisk(dbModule.getString(COL_ASSUM_RISK));
            module.setStatus(dbModule.getString(COL_STATUS));
            module.setType(dbModule.getString(COL_TYPE));
            module.setCostImplication(dbModule.getString(COL_COST_IMPLICATION));

            module.setInitial(dbModule.getString(COL_INITIAL));
            module.setExpiredDate(dbModule.getDate(COL_EXPIRED_DATE));
            module.setPositionLevel(dbModule.getString(COL_POSITION_LEVEL));
            module.setActivityPeriodId(dbModule.getlong(COL_ACTIVITY_PERIOD_ID));

            module.setSegment1Id(dbModule.getlong(COL_SEGMENT1_ID));
            module.setSegment2Id(dbModule.getlong(COL_SEGMENT2_ID));
            module.setSegment3Id(dbModule.getlong(COL_SEGMENT3_ID));
            module.setSegment4Id(dbModule.getlong(COL_SEGMENT4_ID));
            module.setSegment5Id(dbModule.getlong(COL_SEGMENT5_ID));
            module.setSegment6Id(dbModule.getlong(COL_SEGMENT6_ID));
            module.setSegment7Id(dbModule.getlong(COL_SEGMENT7_ID));
            module.setSegment8Id(dbModule.getlong(COL_SEGMENT8_ID));
            module.setSegment9Id(dbModule.getlong(COL_SEGMENT9_ID));
            module.setSegment10Id(dbModule.getlong(COL_SEGMENT10_ID));
            module.setSegment11Id(dbModule.getlong(COL_SEGMENT11_ID));
            module.setSegment12Id(dbModule.getlong(COL_SEGMENT12_ID));
            module.setSegment13Id(dbModule.getlong(COL_SEGMENT13_ID));
            module.setSegment14Id(dbModule.getlong(COL_SEGMENT14_ID));
            module.setSegment15Id(dbModule.getlong(COL_SEGMENT15_ID));

            module.setActDay(dbModule.getString(COL_ACT_DAY));
            module.setActTime(dbModule.getString(COL_ACT_TIME));
            module.setActDate(dbModule.getString(COL_ACT_DATE));

            module.setNote(dbModule.getString(COL_NOTE));
            module.setTotalBudget(dbModule.getdouble(COL_TOTAL_BUDGET));
            module.setTotalBudgetUsed(dbModule.getdouble(COL_TOTAL_BUDGET_USED));
            module.setModuleLevel(dbModule.getInt(COL_MODULE_LEVEL));
            
            module.setDocStatus(dbModule.getInt(COL_DOC_STATUS));            
            module.setCreateId(dbModule.getlong(COL_CREATE_ID));
            module.setCreateDate(dbModule.getDate(COL_CREATE_DATE));            
            module.setApproval1Id(dbModule.getlong(COL_APPROVAL1_ID));
            module.setApproval1Date(dbModule.getDate(COL_APPROVAL1_DATE));

            return module;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbModule(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Module module) throws CONException {
        try {
            DbModule dbModule = new DbModule(0);

            dbModule.setLong(COL_PARENT_ID, module.getParentId());
            dbModule.setString(COL_CODE, module.getCode());
            dbModule.setString(COL_LEVEL, module.getLevel());
            dbModule.setString(COL_DESCRIPTION, module.getDescription());
            dbModule.setString(COL_OUTPUT_DELIVER, module.getOutputDeliver());
            dbModule.setString(COL_PERFORM_INDICATOR, module.getPerformIndicator());
            dbModule.setString(COL_ASSUM_RISK, module.getAssumRisk());
            dbModule.setString(COL_STATUS, module.getStatus());
            dbModule.setString(COL_TYPE, module.getType());
            dbModule.setString(COL_COST_IMPLICATION, module.getCostImplication());

            dbModule.setString(COL_INITIAL, module.getInitial());
            dbModule.setDate(COL_EXPIRED_DATE, module.getExpiredDate());
            dbModule.setString(COL_POSITION_LEVEL, module.getPositionLevel());
            dbModule.setLong(COL_ACTIVITY_PERIOD_ID, module.getActivityPeriodId());

            dbModule.setLong(COL_SEGMENT1_ID, module.getSegment1Id());
            dbModule.setLong(COL_SEGMENT2_ID, module.getSegment2Id());
            dbModule.setLong(COL_SEGMENT3_ID, module.getSegment3Id());
            dbModule.setLong(COL_SEGMENT4_ID, module.getSegment4Id());
            dbModule.setLong(COL_SEGMENT5_ID, module.getSegment5Id());
            dbModule.setLong(COL_SEGMENT6_ID, module.getSegment6Id());
            dbModule.setLong(COL_SEGMENT7_ID, module.getSegment7Id());
            dbModule.setLong(COL_SEGMENT8_ID, module.getSegment8Id());
            dbModule.setLong(COL_SEGMENT9_ID, module.getSegment9Id());
            dbModule.setLong(COL_SEGMENT10_ID, module.getSegment10Id());
            dbModule.setLong(COL_SEGMENT11_ID, module.getSegment11Id());
            dbModule.setLong(COL_SEGMENT12_ID, module.getSegment12Id());
            dbModule.setLong(COL_SEGMENT13_ID, module.getSegment13Id());
            dbModule.setLong(COL_SEGMENT14_ID, module.getSegment14Id());
            dbModule.setLong(COL_SEGMENT15_ID, module.getSegment15Id());

            dbModule.setString(COL_ACT_DAY, module.getActDay());
            dbModule.setString(COL_ACT_TIME, module.getActTime());
            dbModule.setString(COL_ACT_DATE, module.getActDate());

            dbModule.setString(COL_NOTE, module.getNote());
            dbModule.setDouble(COL_TOTAL_BUDGET, module.getTotalBudget());
            dbModule.setDouble(COL_TOTAL_BUDGET_USED, module.getTotalBudgetUsed());
            dbModule.setInt(COL_MODULE_LEVEL, module.getModuleLevel());
            
            dbModule.setInt(COL_DOC_STATUS, module.getDocStatus());
            dbModule.setLong(COL_CREATE_ID, module.getCreateId());
            dbModule.setDate(COL_CREATE_DATE, module.getCreateDate());
            
            dbModule.setLong(COL_APPROVAL1_ID, module.getApproval1Id());
            dbModule.setDate(COL_APPROVAL1_DATE, module.getApproval1Date());

            dbModule.insert();
            module.setOID(dbModule.getlong(COL_MODULE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbModule(0), CONException.UNKNOWN);
        }
        return module.getOID();
    }

    public static long updateExc(Module module) throws CONException {
        try {
            if (module.getOID() != 0) {
                DbModule dbModule = new DbModule(module.getOID());

                dbModule.setLong(COL_PARENT_ID, module.getParentId());
                dbModule.setString(COL_CODE, module.getCode());
                dbModule.setString(COL_LEVEL, module.getLevel());
                dbModule.setString(COL_DESCRIPTION, module.getDescription());
                dbModule.setString(COL_OUTPUT_DELIVER, module.getOutputDeliver());
                dbModule.setString(COL_PERFORM_INDICATOR, module.getPerformIndicator());
                dbModule.setString(COL_ASSUM_RISK, module.getAssumRisk());
                dbModule.setString(COL_STATUS, module.getStatus());
                dbModule.setString(COL_TYPE, module.getType());
                dbModule.setString(COL_COST_IMPLICATION, module.getCostImplication());

                dbModule.setString(COL_INITIAL, module.getInitial());
                dbModule.setDate(COL_EXPIRED_DATE, module.getExpiredDate());
                dbModule.setString(COL_POSITION_LEVEL, module.getPositionLevel());
                dbModule.setLong(COL_ACTIVITY_PERIOD_ID, module.getActivityPeriodId());

                dbModule.setLong(COL_SEGMENT1_ID, module.getSegment1Id());
                dbModule.setLong(COL_SEGMENT2_ID, module.getSegment2Id());
                dbModule.setLong(COL_SEGMENT3_ID, module.getSegment3Id());
                dbModule.setLong(COL_SEGMENT4_ID, module.getSegment4Id());
                dbModule.setLong(COL_SEGMENT5_ID, module.getSegment5Id());
                dbModule.setLong(COL_SEGMENT6_ID, module.getSegment6Id());
                dbModule.setLong(COL_SEGMENT7_ID, module.getSegment7Id());
                dbModule.setLong(COL_SEGMENT8_ID, module.getSegment8Id());
                dbModule.setLong(COL_SEGMENT9_ID, module.getSegment9Id());
                dbModule.setLong(COL_SEGMENT10_ID, module.getSegment10Id());
                dbModule.setLong(COL_SEGMENT11_ID, module.getSegment11Id());
                dbModule.setLong(COL_SEGMENT12_ID, module.getSegment12Id());
                dbModule.setLong(COL_SEGMENT13_ID, module.getSegment13Id());
                dbModule.setLong(COL_SEGMENT14_ID, module.getSegment14Id());
                dbModule.setLong(COL_SEGMENT15_ID, module.getSegment15Id());

                dbModule.setString(COL_ACT_DAY, module.getActDay());
                dbModule.setString(COL_ACT_TIME, module.getActTime());
                dbModule.setString(COL_ACT_DATE, module.getActDate());

                dbModule.setString(COL_NOTE, module.getNote());
                dbModule.setDouble(COL_TOTAL_BUDGET, module.getTotalBudget());
                dbModule.setDouble(COL_TOTAL_BUDGET_USED, module.getTotalBudgetUsed());
                dbModule.setInt(COL_MODULE_LEVEL, module.getModuleLevel());
                
                dbModule.setInt(COL_DOC_STATUS, module.getDocStatus());
                dbModule.setLong(COL_CREATE_ID, module.getCreateId());
                dbModule.setDate(COL_CREATE_DATE, module.getCreateDate());
            
                dbModule.setLong(COL_APPROVAL1_ID, module.getApproval1Id());
                dbModule.setDate(COL_APPROVAL1_DATE, module.getApproval1Date());

                dbModule.update();
                return module.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbModule(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbModule dbModule = new DbModule(oid);
            dbModule.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbModule(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_MODULE;
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
                Module module = new Module();
                resultToObject(rs, module);
                lists.add(module);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, Module module) {
        try {
            module.setOID(rs.getLong(DbModule.colNames[DbModule.COL_MODULE_ID]));
            module.setParentId(rs.getLong(DbModule.colNames[DbModule.COL_PARENT_ID]));
            module.setCode(rs.getString(DbModule.colNames[DbModule.COL_CODE]));
            module.setLevel(rs.getString(DbModule.colNames[DbModule.COL_LEVEL]));
            module.setDescription(rs.getString(DbModule.colNames[DbModule.COL_DESCRIPTION]));
            module.setOutputDeliver(rs.getString(DbModule.colNames[DbModule.COL_OUTPUT_DELIVER]));
            module.setPerformIndicator(rs.getString(DbModule.colNames[DbModule.COL_PERFORM_INDICATOR]));
            module.setAssumRisk(rs.getString(DbModule.colNames[DbModule.COL_ASSUM_RISK]));
            module.setStatus(rs.getString(DbModule.colNames[DbModule.COL_STATUS]));
            module.setType(rs.getString(DbModule.colNames[DbModule.COL_TYPE]));
            module.setCostImplication(rs.getString(DbModule.colNames[DbModule.COL_COST_IMPLICATION]));

            module.setInitial(rs.getString(DbModule.colNames[DbModule.COL_INITIAL]));
            module.setExpiredDate(rs.getDate(DbModule.colNames[DbModule.COL_EXPIRED_DATE]));
            module.setPositionLevel(rs.getString(DbModule.colNames[DbModule.COL_POSITION_LEVEL]));
            module.setActivityPeriodId(rs.getLong(DbModule.colNames[DbModule.COL_ACTIVITY_PERIOD_ID]));

            module.setSegment1Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT1_ID]));
            module.setSegment2Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT2_ID]));
            module.setSegment3Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT3_ID]));
            module.setSegment4Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT4_ID]));
            module.setSegment5Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT5_ID]));
            module.setSegment6Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT6_ID]));
            module.setSegment7Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT7_ID]));
            module.setSegment8Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT8_ID]));
            module.setSegment9Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT9_ID]));
            module.setSegment10Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT10_ID]));
            module.setSegment11Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT11_ID]));
            module.setSegment12Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT12_ID]));
            module.setSegment13Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT13_ID]));
            module.setSegment14Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT14_ID]));
            module.setSegment15Id(rs.getLong(DbModule.colNames[DbModule.COL_SEGMENT15_ID]));

            module.setActDay(rs.getString(DbModule.colNames[DbModule.COL_ACT_DAY]));
            module.setActTime(rs.getString(DbModule.colNames[DbModule.COL_ACT_TIME]));
            module.setActDate(rs.getString(DbModule.colNames[DbModule.COL_ACT_DATE]));

            module.setNote(rs.getString(DbModule.colNames[DbModule.COL_NOTE]));
            module.setTotalBudget(rs.getLong(DbModule.colNames[DbModule.COL_TOTAL_BUDGET]));
            module.setTotalBudgetUsed(rs.getLong(DbModule.colNames[DbModule.COL_TOTAL_BUDGET_USED]));
            module.setModuleLevel(rs.getInt(DbModule.colNames[DbModule.COL_MODULE_LEVEL]));
            
            module.setDocStatus(rs.getInt(DbModule.colNames[DbModule.COL_DOC_STATUS]));
            module.setCreateId(rs.getLong(DbModule.colNames[DbModule.COL_CREATE_ID]));
            module.setCreateDate(rs.getDate(DbModule.colNames[DbModule.COL_CREATE_DATE]));
            
            module.setApproval1Id(rs.getLong(DbModule.colNames[DbModule.COL_APPROVAL1_ID]));
            module.setApproval1Date(rs.getDate(DbModule.colNames[DbModule.COL_APPROVAL1_DATE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long moduleId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_MODULE + " WHERE " +
                    DbModule.colNames[DbModule.COL_MODULE_ID] + " = " + moduleId;

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

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbModule.colNames[DbModule.COL_MODULE_ID] + ") FROM " + DB_MODULE;
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
                    Module module = (Module) list.get(ls);
                    if (oid == module.getOID()) {
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

    public static Vector getActivities(long parentId) {

        Vector result = new Vector();

        Vector v = DbModule.list(0, 0, "parent_id=" + parentId, "code");

        if (v != null && v.size() > 0) {
            for (int i = 0; i < v.size(); i++) {
                Module m = (Module) v.get(i);
                result.add(m);
                Vector vx = DbModule.list(0, 0, "parent_id=" + m.getOID(), "code");
                if (vx != null && vx.size() > 0) {
                    for (int x = 0; x < vx.size(); x++) {
                        Module mx = (Module) vx.get(x);
                        result.add(mx);
                        if (mx.getLevel().equals(I_Project.ACTIVITY_CODE_A)) {
                            Vector vxx = DbModule.list(0, 0, "parent_id=" + mx.getOID(), "code");
                            if (vxx != null && vxx.size() > 0) {
                                result.addAll(vxx);
                            }
                        }
                    }

                }
            }
        }

        return result;
    }

    public static void updateBudgetRecursif(long moduleId, double amount) {

        try {
            Module module = fetchExc(moduleId);
            module.setTotalBudget(module.getTotalBudget() + amount);
            updateExc(module);
            if (module.getParentId() != 0) {
                updateBudgetRecursif(module.getParentId(), amount);
            }
        } catch (Exception e) {

        }

    }

    public static void updateBudgetUsedRecursif(long moduleId, double amount) {

        try {
            Module module = fetchExc(moduleId);
            module.setTotalBudgetUsed(module.getTotalBudgetUsed() + amount);
            updateExc(module);
            if (module.getParentId() != 0) {
                updateBudgetUsedRecursif(module.getParentId(), amount);
            }
        } catch (Exception e) {

        }

    }

    public static void updatePostedStatus(long parentId) {
        if (parentId != 0) {
            try {
                Vector vModules = DbModule.list(0, 1, DbModule.colNames[DbModule.COL_PARENT_ID] + "=" + parentId, null);

                if (vModules != null && vModules.size() > 0) {

                    Module module = DbModule.fetchExc(parentId);
                    module.setPositionLevel(I_Project.ACCOUNT_LEVEL_HEADER);

                    try {
                        updateExc(module);
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e) {
            }
        }
    }
    
    public static void deleteBudget(long moduleId){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "DELETE FROM "+DbModuleBudget.DB_MODULE_BUDGET+" WHERE "+DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID]+" = "+moduleId;

            CONHandler.execUpdate(sql);
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
    }
}
