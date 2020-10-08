package com.project.general;

import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import com.project.util.lang.*;

public class DbSystemDocNumber extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SYSTEM_DOC_NUMBER = "system_doc_number";
    public static final int COL_SYSTEM_DOC_NUMBER_ID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_COUNTER = 2;
    public static final int COL_PREFIX_NUMBER = 3;
    public static final int COL_YEAR = 4;
    public static final int COL_DATE = 5;
    public static final int COL_USER_ID = 6;
    public static final int COL_DOC_NUMBER = 7;
    public static final String[] colNames = {
        "system_doc_number_id",
        "type",
        "counter",
        "prefix_number",
        "year",
        "date",
        "user_id",
        "doc_number"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING
    };
    public static final String[] romawi = {
        "I",
        "II",
        "III",
        "IV",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
        "X",
        "XI",
        "XII"
    };

    public DbSystemDocNumber() {
    }

    public DbSystemDocNumber(int i) throws CONException {
        super(new DbSystemDocNumber());
    }

    public DbSystemDocNumber(String sOid) throws CONException {
        super(new DbSystemDocNumber(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSystemDocNumber(long lOid) throws CONException {
        super(new DbSystemDocNumber(0));
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
        return DB_SYSTEM_DOC_NUMBER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSystemDocNumber().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SystemDocNumber systemdocnumber = fetchExc(ent.getOID());
        ent = (Entity) systemdocnumber;
        return systemdocnumber.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SystemDocNumber) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SystemDocNumber) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SystemDocNumber fetchExc(long oid) throws CONException {
        try {
            SystemDocNumber systemdocnumber = new SystemDocNumber();
            DbSystemDocNumber pstSystemDocNumber = new DbSystemDocNumber(oid);
            systemdocnumber.setOID(oid);

            systemdocnumber.setType(pstSystemDocNumber.getString(COL_TYPE));
            systemdocnumber.setCounter(pstSystemDocNumber.getInt(COL_COUNTER));
            systemdocnumber.setPrefixNumber(pstSystemDocNumber.getString(COL_PREFIX_NUMBER));
            systemdocnumber.setYear(pstSystemDocNumber.getInt(COL_YEAR));
            systemdocnumber.setDate(pstSystemDocNumber.getDate(COL_DATE));
            systemdocnumber.setUserId(pstSystemDocNumber.getlong(COL_USER_ID));
            systemdocnumber.setDocNumber(pstSystemDocNumber.getString(COL_DOC_NUMBER));

            return systemdocnumber;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSystemDocNumber(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SystemDocNumber systemdocnumber) throws CONException {
        try {
            DbSystemDocNumber pstSystemDocNumber = new DbSystemDocNumber(0);

            pstSystemDocNumber.setString(COL_TYPE, systemdocnumber.getType());
            pstSystemDocNumber.setInt(COL_COUNTER, systemdocnumber.getCounter());
            pstSystemDocNumber.setString(COL_PREFIX_NUMBER, systemdocnumber.getPrefixNumber());
            pstSystemDocNumber.setInt(COL_YEAR, systemdocnumber.getYear());
            pstSystemDocNumber.setDate(COL_DATE, systemdocnumber.getDate());
            pstSystemDocNumber.setLong(COL_USER_ID, systemdocnumber.getUserId());
            pstSystemDocNumber.setString(COL_DOC_NUMBER, systemdocnumber.getDocNumber());

            pstSystemDocNumber.insert();
            systemdocnumber.setOID(pstSystemDocNumber.getlong(COL_SYSTEM_DOC_NUMBER_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSystemDocNumber(0), CONException.UNKNOWN);
        }
        return systemdocnumber.getOID();
    }

    public static long updateExc(SystemDocNumber systemdocnumber) throws CONException {
        try {
            if (systemdocnumber.getOID() != 0) {
                DbSystemDocNumber pstSystemDocNumber = new DbSystemDocNumber(systemdocnumber.getOID());

                pstSystemDocNumber.setString(COL_TYPE, systemdocnumber.getType());
                pstSystemDocNumber.setInt(COL_COUNTER, systemdocnumber.getCounter());
                pstSystemDocNumber.setString(COL_PREFIX_NUMBER, systemdocnumber.getPrefixNumber());
                pstSystemDocNumber.setInt(COL_YEAR, systemdocnumber.getYear());
                pstSystemDocNumber.setDate(COL_DATE, systemdocnumber.getDate());
                pstSystemDocNumber.setLong(COL_USER_ID, systemdocnumber.getUserId());
                pstSystemDocNumber.setString(COL_DOC_NUMBER, systemdocnumber.getDocNumber());

                pstSystemDocNumber.update();
                return systemdocnumber.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSystemDocNumber(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSystemDocNumber pstSystemDocNumber = new DbSystemDocNumber(oid);
            pstSystemDocNumber.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSystemDocNumber(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SYSTEM_DOC_NUMBER;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SystemDocNumber systemdocnumber = new SystemDocNumber();
                resultToObject(rs, systemdocnumber);
                lists.add(systemdocnumber);
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

    private static void resultToObject(ResultSet rs, SystemDocNumber systemdocnumber) {
        try {
            systemdocnumber.setOID(rs.getLong(DbSystemDocNumber.colNames[DbSystemDocNumber.COL_SYSTEM_DOC_NUMBER_ID]));
            systemdocnumber.setType(rs.getString(DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE]));
            systemdocnumber.setCounter(rs.getInt(DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER]));
            systemdocnumber.setPrefixNumber(rs.getString(DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER]));
            systemdocnumber.setYear(rs.getInt(DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR]));
            systemdocnumber.setDate(rs.getDate(DbSystemDocNumber.colNames[DbSystemDocNumber.COL_DATE]));
            systemdocnumber.setUserId(rs.getLong(DbSystemDocNumber.colNames[DbSystemDocNumber.COL_USER_ID]));
            systemdocnumber.setDocNumber(rs.getString(DbSystemDocNumber.colNames[DbSystemDocNumber.COL_DOC_NUMBER]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long systemDocNumberId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                    DbSystemDocNumber.colNames[DbSystemDocNumber.COL_SYSTEM_DOC_NUMBER_ID] + " = " + systemDocNumberId;

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
            String sql = "SELECT COUNT(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_SYSTEM_DOC_NUMBER_ID] + ") FROM " + DB_SYSTEM_DOC_NUMBER;
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
                    SystemDocNumber systemdocnumber = (SystemDocNumber) list.get(ls);
                    if (oid == systemdocnumber.getOID()) {
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

    /**
     * proses untuk mencari counter
     **/
    public static synchronized int getDocCodeCounter(String prefixNumber) {

        CONResultSet dbrs = null;
        int result = 0;

        try {

            String sql = "SELECT max(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") as maxCounter FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                    DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + prefixNumber + "'";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt("maxCounter");
            }

            result = result + 1;
            rs.close();

        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    
    
    
    public static synchronized int getDocCodeCounter(String prefixNumber, Periode opnPeriode, String type) {

        CONResultSet dbrs = null;
        int result = 0;

        int cfg = 0;
        int periodeTaken = 0;

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e) {}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e) {}

        Date dt = new Date();
        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int year = dt.getYear() + 1900;

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan
                sql = "SELECT max(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") as maxCounter FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = " + year + " AND " + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + type + "'";
            } else {
                sql = "SELECT max(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") as maxCounter FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + prefixNumber + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt("maxCounter");
            }

            result = result + 1;
            rs.close();

        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }  

    //untuk number prefix GL
    public static String getNumberPrefixGl(){

        //format number prefix gl = 00001/MEM/01/12 = MEM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod();
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){

                code = code + systemDocCode.getSeparator() + romawi[month - 1];

            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }
                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    //untuk number prefix GL
    public static String getNumberPrefixGl(long periodeId){

        //format number prefix gl = 00001/MEM/01/12 = MEM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            //opnPeriode = DbPeriode.getOpenPeriod();
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";
        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {
                
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator();
                    String strmth = "";
                    if (month >= 10){
                        strmth = "" + month;
                    } else {
                        strmth = "0" + month;
                    }

                    int max = systemDocCode.getMonthDigit() - 2;
                    for (int ix = 0; ix < max; ix++) {
                        strmth = "0" + strmth;
                    }
                    code = code + strmth;
                }

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator() + romawi[month - 1];
                }

            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try{

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }
                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    

    //Untuk get next number GL
    public static String getNextNumberGl(int ctr){

        //format number prefix gl = 00001/MEM/01/12 = MEM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixGl();
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    //Untuk get next number GL
    public static String getNextNumberGl(int ctr,long periodeId){

        //format number prefix gl = 00001/MEM/01/12 = MEM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixGl(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }

    public static int getNextCounterGl(long periodeId) {        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixGl(opnPeriode.getOID()) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterGl() {        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod();
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixGl() + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    
    //untuk number prefix GL13
    public static String getNumberPrefixGl13(){

        //format number prefix gl13 = 00001/MEM/01/12 = MEM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod13();
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){

                code = code + systemDocCode.getSeparator() + romawi[month - 1];

            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }

    //Untuk get next number GL13
    public static String getNextNumberGl13(int ctr){

        //format number prefix gl13 = 00001/MEM/01/12 = MEM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixGl13();
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }

    public static int getNextCounterGl13(){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod13();
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixGl13() + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    
    //untuk number prefix BKM
    public static String getNumberPrefixBkm(long periodeId){

        //format number prefix BKM = 00001/BKM/01/12 = BKM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            //opnPeriode = DbPeriode.getOpenPeriod();
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator();                    
                    String strmth = "";
                    
                    if (month >= 10){
                        strmth = "" + month;
                    } else {
                        strmth = "0" + month;
                    }

                    int max = systemDocCode.getMonthDigit() - 2;
                    for (int ix = 0; ix < max; ix++) {
                        strmth = "0" + strmth;
                    }
                    
                    code = code + strmth;
                }

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator() + romawi[month - 1];
                }
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() > 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static String getNumberPrefixBbm(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBM]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {
                
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator();
                    String strmth = "";
                    if (month >= 10){
                        strmth = "" + month;
                    } else {
                        strmth = "0" + month;
                    }

                    int max = systemDocCode.getMonthDigit() - 2;

                    for (int ix = 0; ix < max; ix++) {
                        strmth = "0" + strmth;
                    }

                    code = code + strmth;
                }

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator() + romawi[month - 1];
                }
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static synchronized void getJournalNumber(long oid,String typeDoc,Periode opnPeriode){
        SystemDocCode systemDocCode = new SystemDocCode();        
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(typeDoc);
        
        Date dt = new Date();
        int periodeTaken = 0;
        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;
        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {
                code = code + systemDocCode.getSeparator();
                String strmth = "";
                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }
                int max = systemDocCode.getMonthDigit() - 2;
                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }
                code = code + strmth;
            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }
        
        int counter = getNextCounterApMemo(opnPeriode.getOID());
        String formatDocCode = DbSystemDocNumber.getNextNumberApMemo(counter, opnPeriode.getOID());
        updateJournalNumber(typeDoc,oid,counter,formatDocCode,code,dt);
        
    }
    
    public static void updateJournalNumber(String typeDoc,long oid,int counter,String formatDocCode,String code,Date dt){
        CONResultSet dbrs = null;
        try{
            String sql = "";
            if(typeDoc.equals(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO])){
                sql = "update "+DbReceive.DB_RECEIVE+" set "+
                    DbReceive.colNames[DbReceive.COL_COUNTER]+" = '"+counter+"', "+DbReceive.colNames[DbReceive.COL_NUMBER]+" = '"+formatDocCode+"',"+DbReceive.colNames[DbReceive.COL_PREFIX_NUMBER]+"='"+code+"'"+
                    " where "+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = "+oid;
            }
            
            CONHandler.execUpdate(sql);
            
            SystemDocNumber systemDocNumber = new SystemDocNumber();
            systemDocNumber.setCounter(counter);
            systemDocNumber.setDate(new Date());
            systemDocNumber.setPrefixNumber(formatDocCode);
            systemDocNumber.setType(typeDoc);
            systemDocNumber.setYear(dt.getYear() + 1900);
            systemDocNumber.setDocNumber(formatDocCode);
            try {
                DbSystemDocNumber.insertExc(systemDocNumber);
            } catch (Exception E) { System.out.println("[exception] " + E.toString()); }
            
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static String getNumberPrefixApMemo(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static String getNumberPrefixArMemo(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AR_MEMO]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    
     public static String getNumberPrefixSlProperty(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            //opnPeriode = DbPeriode.getOpenPeriod();
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static String getNumberPrefixInvoice(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            //opnPeriode = DbPeriode.getOpenPeriod();
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    
    public static String getNumberPrefixSlProperty(){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod();            
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    
    public static String getNumberPrefixBkm(){

        //format number prefix BKM = 00001/BKM/01/12 = BKM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod();            
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    //Untuk get next number BKM
    public static String getNextNumberBkm(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixBkm(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static String getNextNumberBbm(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBM]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixBbm(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static String getNextNumberApMemo(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixApMemo(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static String getNextNumberArMemo(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixArMemo(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    
    public static String getNextNumberSlProperty(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixSlProperty(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static String getNextNumberInvoice(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixInvoice(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    
    public static String getNextNumberBkm(int ctr){

        //format number prefix BKM = 00001/BKM/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixBkm();
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }

    public static int getNextCounterBkm(long periodeId){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);            
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixBkm(periodeId) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterBbm(long periodeId){        
        
        int result = 0;
        CONResultSet dbrs = null;
        int cfg = 0;
        int periodeTaken = 0;
        Periode opnPeriode = new Periode();
        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);            
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {
            String sql = "";
            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBM] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixBbm(periodeId) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBM] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterApMemo(long periodeId){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {
            //opnPeriode = DbPeriode.getOpenPeriod();
            opnPeriode = DbPeriode.fetchExc(periodeId);            
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixApMemo(periodeId) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterArMemo(long periodeId){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {
            //opnPeriode = DbPeriode.getOpenPeriod();
            opnPeriode = DbPeriode.fetchExc(periodeId);            
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AR_MEMO] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixArMemo(periodeId) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AR_MEMO] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterSlProperty(long periodeId){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {
            //opnPeriode = DbPeriode.getOpenPeriod();
            opnPeriode = DbPeriode.fetchExc(periodeId);            
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixSlProperty(periodeId) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterInv(long periodeId){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);            
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixInvoice(periodeId) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    
    public static int getNextCounterBkm(){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod();
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixBkm() + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    //untuk number prefix BKK
    public static String getNumberPrefixBkk(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {
                
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator();
                    String strmth = "";
                    if (month >= 10){
                        strmth = "" + month;
                    } else {
                        strmth = "0" + month;
                    }

                    int max = systemDocCode.getMonthDigit() - 2;
                    for (int ix = 0; ix < max; ix++) {
                        strmth = "0" + strmth;
                    }
                    code = code + strmth;
                }

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator() + romawi[month - 1];
                }
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static String getNumberPrefixKasbon(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_KASBON]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator();

                    String strmth = "";

                    if (month >= 10){
                        strmth = "" + month;
                    } else {
                        strmth = "0" + month;
                    }

                    int max = systemDocCode.getMonthDigit() - 2;
                    for (int ix = 0; ix < max; ix++) {
                        strmth = "0" + strmth;
                    }

                    code = code + strmth;
                }

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator() + romawi[month - 1];
                }
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static String getNumberPrefixBbk(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBK]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {
            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {
                
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator();

                    String strmth = "";

                    if (month >= 10){
                        strmth = "" + month;
                    } else {
                        strmth = "0" + month;
                    }

                    int max = systemDocCode.getMonthDigit() - 2;

                    for (int ix = 0; ix < max; ix++) {
                        strmth = "0" + strmth;
                    }

                    code = code + strmth;
                }

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                if(systemDocCode.getMonthDigit() > 0){
                    code = code + systemDocCode.getSeparator() + romawi[month - 1];
                }
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static String getNumberPrefixTT(long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_TT]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    
    
    //untuk number prefix BKK
    public static String getNumberPrefixBkk(){

        //format number prefix BKK = 00001/BKK/01/12 = BKK/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);

        Date dt = new Date();

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod();
        } catch (Exception e){}

        int periodeTaken = 0;

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){ }

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    
    //Untuk get next number BKK
    public static String getNextNumberBkk(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixBkk(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static String getNextNumberKasbon(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_KASBON]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixKasbon(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static String getNextNumberBbk(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBK]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixBbk(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    
    public static String getNextNumberTT(int ctr,long periodeId){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_TT]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixTT(periodeId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    //Untuk get next number BKK
    public static String getNextNumberBkk(int ctr){

        //format number prefix BKK = 00001/BKK/01/12

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixBkk();
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }

    public static int getNextCounterBkk(long periodeId){           
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();
        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixBkk(opnPeriode.getOID()) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterKasbon(long periodeId){           
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();
        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_KASBON] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixKasbon(opnPeriode.getOID()) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_KASBON] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterBbk(long periodeId){           
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();
        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBK] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixBbk(opnPeriode.getOID()) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBK] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    
    public static int getNextCounterTT(long periodeId){           
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {            
            opnPeriode = DbPeriode.fetchExc(periodeId);
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_TT] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixTT(opnPeriode.getOID()) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_TT] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounterBkk(){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;
        int periodeTaken = 0;

        Periode opnPeriode = new Periode();

        try {
            opnPeriode = DbPeriode.getOpenPeriod();            
        } catch (Exception e) {}

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e){}

        Date dt = new Date();

        if (periodeTaken == 0) {
            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
        }

        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixBkk() + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    
    /**
     * Get next document counter based on document type and periode
     * @param periodId OID Periode
     * @param docType DbSystemDocCode
     * @return
     */
    public synchronized static int getNextCounterSynch(long periodId, int docType) {
        int result = 0;
        CONResultSet dbrs = null;

        try {
            int journalNumberCycle = 0;
            int periodeTaken = 0;
            Periode periode = new Periode();
            periode = DbPeriode.fetchExc(periodId);

            try{
                journalNumberCycle = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
            }catch(Exception e){
                journalNumberCycle = 0;
            }
            try{
                periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
            }catch(Exception e){
                periodeTaken = 0;
            }    

            Date date = new Date();

            if (periodeTaken == 0) {
                date = periode.getStartDate(); //untuk mendapatkan periode yang aktif
            } else if (periodeTaken == 1) {
                date = periode.getEndDate(); //untuk mendapatkan periode yang aktif
            }

            String sql = "";

            if (journalNumberCycle == 1) { //jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(date, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[docType] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefix(periode.getOID(), docType) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[docType] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    /**
     * Get next document counter based on document type and periode
     * @param periodId OID Periode
     * @param docType DbSystemDocCode
     * @return
     */
    public static int getNextCounter(long periodId, int docType) {
        int result = 0;
        CONResultSet dbrs = null;

        try {
            int journalNumberCycle = 0;
            int periodeTaken = 0;
            Periode periode = new Periode();
            periode = DbPeriode.fetchExc(periodId);

            try{
                journalNumberCycle = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
            }catch(Exception e){
                journalNumberCycle = 0;
            }
            try{
                periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
            }catch(Exception e){
                periodeTaken = 0;
            }    

            Date date = new Date();

            if (periodeTaken == 0) {
                date = periode.getStartDate(); //untuk mendapatkan periode yang aktif
            } else if (periodeTaken == 1) {
                date = periode.getEndDate(); //untuk mendapatkan periode yang aktif
            }

            String sql = "";

            if (journalNumberCycle == 1) { //jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(date, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[docType] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefix(periode.getOID(), docType) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[docType] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    public static int getNextCounter(Date transDate, int docType) {
        int result = 0;
        CONResultSet dbrs = null;

        try {
            int journalNumberCycle = 0;
            try{
                journalNumberCycle = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
            }catch(Exception e){}

            Date date = new Date();            
            date = transDate;

            String sql = "";

            if (journalNumberCycle == 1) { //jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(date, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[docType] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefix(transDate, docType) + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[docType] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    /**
     * Get prefix from document number based on document type and periode
     * format: docType/month/year
     * example: GL/01/12
     * @param periodId OID Periode
     * @param docType DbSystemDocCode
     * @return
     */
    public static String getNumberPrefix(long periodId, int docType) {
        String code = "";

        try {
            SystemDocCode systemDocCode = new SystemDocCode();
            systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[docType]);
            code = systemDocCode.getCode();

            Date dt = new Date();
            Periode periode = new Periode();
            periode = DbPeriode.fetchExc(periodId);

            int periodeTaken = 0;
            try{
                periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
            }catch(Exception e){}    

            if (periodeTaken == 0) {
                dt = periode.getStartDate(); //untuk mendapatkan periode yang aktif
            } else if (periodeTaken == 1) {
                dt = periode.getEndDate(); //untuk mendapatkan periode yang aktif
            }

            int month = dt.getMonth() + 1;

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {
                code = code + systemDocCode.getSeparator();
                String strmth = "";

                if (month >= 10) {
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            } else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI) {
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {
                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;

                    for (int iY = 0; iY < maxIY; iY++) {
                        year = "0" + year;
                    }
                }
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return code;
    }
    
    
    public static String getNumberPrefix(Date transDate, int docType) {
        String code = "";

        try {
            SystemDocCode systemDocCode = new SystemDocCode();
            systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[docType]);
            code = systemDocCode.getCode();

            Date dt = new Date();
            dt = transDate;

            int month = dt.getMonth() + 1;

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {
                code = code + systemDocCode.getSeparator();
                String strmth = "";

                if (month >= 10) {
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            } else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI) {
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {
                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;

                    for (int iY = 0; iY < maxIY; iY++) {
                        year = "0" + year;
                    }
                }
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return code;
    }

    /**
     * Generate next document number
     * format: counter/docType/month/year
     * example: 00001/GL/01/12
     * @param counter Document counter
     * @param periodId OID Periode
     * @param docType DbSystemDocCode
     * @return
     */
    public static String getNextNumber(int counter, long periodId, int docType) {

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[docType]);

        String number = "";

        if (systemDocCode.getDigitCounter() != 0) {

            String strCounter = String.valueOf(counter);

            if (strCounter.length() == systemDocCode.getDigitCounter()) {
                number = strCounter;
            } else if (strCounter.length() < systemDocCode.getDigitCounter()) {
                int kekurangan = systemDocCode.getDigitCounter() - strCounter.length();
                number = strCounter;
                for (int ic = 0; ic < kekurangan; ic++) {
                    number = "0" + number;
                }
            } else if (strCounter.length() > systemDocCode.getDigitCounter()) {
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = strCounter;
                number = tmpCtr.substring(0, max);
            }
        }

        String code = getNumberPrefix(periodId, docType);

        if (systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT) {
            code = number + systemDocCode.getSeparator() + code;
        } else if (systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK) {
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static String getNextNumber(int counter, Date transDate, int docType) {

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[docType]);

        String number = "";

        if (systemDocCode.getDigitCounter() != 0) {

            String strCounter = String.valueOf(counter);

            if (strCounter.length() == systemDocCode.getDigitCounter()) {
                number = strCounter;
            } else if (strCounter.length() < systemDocCode.getDigitCounter()) {
                int kekurangan = systemDocCode.getDigitCounter() - strCounter.length();
                number = strCounter;
                for (int ic = 0; ic < kekurangan; ic++) {
                    number = "0" + number;
                }
            } else if (strCounter.length() > systemDocCode.getDigitCounter()) {
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = strCounter;
                number = tmpCtr.substring(0, max);
            }
        }

        String code = getNumberPrefix(transDate, docType);

        if (systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT) {
            code = number + systemDocCode.getSeparator() + code;
        } else if (systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK) {
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static int getNextCounterInv(){        
        
        int result = 0;

        CONResultSet dbrs = null;

        int cfg = 0;

        try {
            cfg = Integer.parseInt(DbSystemProperty.getValueByName("JOURNAL_NUMBER_CYCLE"));
        } catch (Exception e){}

        Date dt = new Date();
      
        try {

            String sql = "";

            if (cfg == 1) { // jika yang digunakan adalah journal number tahunan                
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR] + " = '" + JSPFormater.formatDate(dt, "yyyy") + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV] + "'";
            } else {
                sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + getNumberPrefixInvoice() + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV] + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }
    
    
    public static String getNumberPrefixInvoice(){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV]);

        Date dt = new Date();

        int month = dt.getMonth() + 1;

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk bulan
        try {

            if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_NUMBER) {

                code = code + systemDocCode.getSeparator();

                String strmth = "";

                if (month >= 10){
                    strmth = "" + month;
                } else {
                    strmth = "0" + month;
                }

                int max = systemDocCode.getMonthDigit() - 2;

                for (int ix = 0; ix < max; ix++) {
                    strmth = "0" + strmth;
                }

                code = code + strmth;

            }else if (systemDocCode.getMonthType() == DbSystemDocCode.MONTH_TYPE_ROMAWI){
                code = code + systemDocCode.getSeparator() + romawi[month - 1];
            }

        } catch (Exception e) { System.out.println("[exception] " + e.toString());}

        //untuk year
        try {

            String year = "";

            if (systemDocCode.getYearDigit() != 0) {

                if (systemDocCode.getYearDigit() == 1) {
                    year = JSPFormater.formatDate(dt, "y");
                } else if (systemDocCode.getYearDigit() == 2) {
                    year = JSPFormater.formatDate(dt, "yy");
                } else if (systemDocCode.getYearDigit() == 3) {
                    year = JSPFormater.formatDate(dt, "yyy");
                } else if (systemDocCode.getYearDigit() == 4) {
                    year = JSPFormater.formatDate(dt, "yyyy");
                } else {
                    year = JSPFormater.formatDate(dt, "yyyy");
                    int maxIY = systemDocCode.getYearDigit() - 4;
                    for (int iY = 0; iY < maxIY; iY++){
                        year = "0" + year;
                    }
                }                
                code = code + systemDocCode.getSeparator() + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static String getNextNumberInvoice(int ctr){

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_INV]);
        
        String number = "";
        
        if(systemDocCode.getDigitCounter() != 0){
            
            String strCtr = ""+ctr;
            
            if(strCtr.length() == systemDocCode.getDigitCounter()){
                number = ""+ctr;
            }else if(strCtr.length() < systemDocCode.getDigitCounter()){                
                int kekurangan = systemDocCode.getDigitCounter() - strCtr.length();
                number = ""+ctr;
                for(int ic = 0 ; ic < kekurangan ; ic ++){
                    number = "0"+number;
                }                        
            }else if(strCtr.length() > systemDocCode.getDigitCounter()){
                int max = systemDocCode.getDigitCounter() - 1;
                String tmpCtr = ""+ctr;                
                number = tmpCtr.substring(0, max);                
            }
        }
        
        String code = getNumberPrefixInvoice();
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
}
