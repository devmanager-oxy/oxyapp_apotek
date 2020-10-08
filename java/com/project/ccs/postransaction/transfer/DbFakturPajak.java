
package com.project.ccs.postransaction.transfer;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;
import com.project.ccs.postransaction.*;
import com.project.general.*;
import com.project.util.*;
import java.util.Date;

public class DbFakturPajak extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_FAKTUR_PAJAK = "faktur_pajak";
    public static final int COL_FAKTUR_PAJAK_ID = 0;
    public static final int COL_NAMA_PKP = 1;
    public static final int COL_NUMBER = 2;
    public static final int COL_COUNTER = 3;
    public static final int COL_TRANSFER_NUMBER = 4;
    public static final int COL_SALES_NUMBER = 5;
    public static final int COL_DATE = 6;    
    public static final int COL_PKP_ADDRESS = 7;
    public static final int COL_NPWP_PKP = 8;
    public static final int COL_CUSTOMER_ID = 9;
    public static final int COL_CUSTOMER_ADDRESS = 10;
    public static final int COL_NPWP_CUSTOMER = 11;
    public static final int COL_SALES_ID = 12;
    public static final int COL_PREFIX_NUMBER = 13;
    public static final int COL_LOCATION_ID = 14;
    public static final int COL_TYPE_FAKTUR = 15;
    public static final int COL_LOCATION_TO_ID = 16;

    public static final String[] colNames = {
        "faktur_pajak_id", 
        "nama_pkp",
        "number",
        "counter",
        "transfer_number",
        "sales_number",
        "date",         
        "pkp_address",
        "npwp_pkp",
        "customer_id",
        "customer_address",
        "npwp_customer",
        "sales_id",
        "prefix_number",
        "location_id",
        "type_faktur",
        "location_to_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,        
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG
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
    
    public static int TYPE_FAKTUR_TRANSFER = 1;
    public static int TYPE_FAKTUR_SALES = 2;
    public static int TYPE_FAKTUR_RETUR = 3;
    
    public DbFakturPajak() {
    }

    public DbFakturPajak(int i) throws CONException {
        super(new DbFakturPajak());
    }

    public DbFakturPajak(String sOid) throws CONException {
        super(new DbFakturPajak(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFakturPajak(long lOid) throws CONException {
        super(new DbFakturPajak(0));
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
        return DB_FAKTUR_PAJAK;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName(){
        return new DbFakturPajak().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        FakturPajak fakturPajak = fetchExc(ent.getOID());
        ent = (Entity) fakturPajak;
        return fakturPajak.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((FakturPajak) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((FakturPajak) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static FakturPajak fetchExc(long oid) throws CONException {
        try {
            FakturPajak fakturPajak = new FakturPajak();
            DbFakturPajak pstFakturPajak = new DbFakturPajak(oid);
            fakturPajak.setOID(oid);            
            fakturPajak.setNama_pkp(pstFakturPajak.getString(COL_NAMA_PKP));
            fakturPajak.setNumber(pstFakturPajak.getString(COL_NUMBER));
            fakturPajak.setCounter(pstFakturPajak.getInt(COL_COUNTER));
            fakturPajak.setTransfer_number(pstFakturPajak.getString(COL_TRANSFER_NUMBER));
            fakturPajak.setSalesNumber(pstFakturPajak.getString(COL_SALES_NUMBER));
            fakturPajak.setDate(pstFakturPajak.getDate(COL_DATE));            
            fakturPajak.setPkpAddress(pstFakturPajak.getString(COL_PKP_ADDRESS));
            fakturPajak.setNpwpPkp(pstFakturPajak.getString(COL_NPWP_PKP));
            fakturPajak.setCustomerId(pstFakturPajak.getlong(COL_CUSTOMER_ID));
            fakturPajak.setCustomerAddress(pstFakturPajak.getString(COL_CUSTOMER_ADDRESS));
            fakturPajak.setNpwpCustomer(pstFakturPajak.getString(COL_NPWP_CUSTOMER));
            fakturPajak.setSalesId(pstFakturPajak.getlong(COL_SALES_ID));
            fakturPajak.setPrefixNumber(pstFakturPajak.getString(COL_PREFIX_NUMBER));
            fakturPajak.setLocationId(pstFakturPajak.getlong(COL_LOCATION_ID));
            fakturPajak.setTypeFaktur(pstFakturPajak.getInt(COL_TYPE_FAKTUR));
            fakturPajak.setLocationToId(pstFakturPajak.getlong(COL_LOCATION_TO_ID));
            
            return fakturPajak;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFakturPajak(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(FakturPajak fakturPajak) throws CONException {
        try {
            DbFakturPajak pstFakturPajak = new DbFakturPajak(0);
            pstFakturPajak.setString(COL_NAMA_PKP, fakturPajak.getNama_pkp());
            pstFakturPajak.setString(COL_NUMBER, fakturPajak.getNumber());
            pstFakturPajak.setInt(COL_COUNTER, fakturPajak.getCounter());
            pstFakturPajak.setString(COL_TRANSFER_NUMBER, fakturPajak.getTransfer_number());
            pstFakturPajak.setString(COL_SALES_NUMBER, fakturPajak.getSalesNumber());
            pstFakturPajak.setDate(COL_DATE, fakturPajak.getDate());            
            pstFakturPajak.setString(COL_PKP_ADDRESS, fakturPajak.getPkpAddress());
            pstFakturPajak.setString(COL_NPWP_PKP, fakturPajak.getNpwpPkp());
            pstFakturPajak.setLong(COL_CUSTOMER_ID, fakturPajak.getCustomerId());            
            pstFakturPajak.setString(COL_CUSTOMER_ADDRESS, fakturPajak.getCustomerAddress());
            pstFakturPajak.setString(COL_NPWP_CUSTOMER, fakturPajak.getNpwpCustomer());
            pstFakturPajak.setLong(COL_SALES_ID, fakturPajak.getSalesId());
            pstFakturPajak.setString(COL_PREFIX_NUMBER, fakturPajak.getPrefixNumber());
            pstFakturPajak.setLong(COL_LOCATION_ID, fakturPajak.getLocationId());            
            pstFakturPajak.setInt(COL_TYPE_FAKTUR, fakturPajak.getTypeFaktur());            
            pstFakturPajak.setLong(COL_LOCATION_TO_ID, fakturPajak.getLocationToId());            
            
            pstFakturPajak.insert();
            fakturPajak.setOID(pstFakturPajak.getlong(COL_FAKTUR_PAJAK_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFakturPajak(0), CONException.UNKNOWN);
        }
        return fakturPajak.getOID();
    }

    public static long updateExc(FakturPajak fakturPajak) throws CONException {
        try {
            if (fakturPajak.getOID() != 0) {
                DbFakturPajak pstFakturPajak = new DbFakturPajak(fakturPajak.getOID());
                
                pstFakturPajak.setString(COL_NAMA_PKP, fakturPajak.getNama_pkp());
                pstFakturPajak.setInt(COL_COUNTER, fakturPajak.getCounter());
                pstFakturPajak.setString(COL_NUMBER, fakturPajak.getNumber());
                pstFakturPajak.setString(COL_TRANSFER_NUMBER, fakturPajak.getTransfer_number());
                pstFakturPajak.setString(COL_SALES_NUMBER, fakturPajak.getSalesNumber());
                pstFakturPajak.setDate(COL_DATE, fakturPajak.getDate());                
                pstFakturPajak.setString(COL_PKP_ADDRESS, fakturPajak.getPkpAddress());
                pstFakturPajak.setString(COL_NPWP_PKP, fakturPajak.getNpwpPkp());
                pstFakturPajak.setLong(COL_CUSTOMER_ID, fakturPajak.getCustomerId());            
                pstFakturPajak.setString(COL_CUSTOMER_ADDRESS, fakturPajak.getCustomerAddress());
                pstFakturPajak.setString(COL_NPWP_CUSTOMER, fakturPajak.getNpwpCustomer());
                pstFakturPajak.setLong(COL_SALES_ID, fakturPajak.getSalesId());
                pstFakturPajak.setString(COL_PREFIX_NUMBER, fakturPajak.getPrefixNumber());
                pstFakturPajak.setLong(COL_LOCATION_ID, fakturPajak.getLocationId());
                pstFakturPajak.setInt(COL_TYPE_FAKTUR, fakturPajak.getTypeFaktur());                            
                pstFakturPajak.setLong(COL_LOCATION_TO_ID, fakturPajak.getLocationToId());       
                
                pstFakturPajak.update();
                return fakturPajak.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFakturPajak(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFakturPajak pstTransfer = new DbFakturPajak(oid);
            pstTransfer.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFakturPajak(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_FAKTUR_PAJAK;
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
                FakturPajak fakturPajak = new FakturPajak();
                resultToObject(rs, fakturPajak);
                lists.add(fakturPajak);
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

    private static void resultToObject(ResultSet rs,  FakturPajak fakturPajak) {
        try {
            fakturPajak.setOID(rs.getLong(DbFakturPajak.colNames[DbFakturPajak.COL_FAKTUR_PAJAK_ID]));
            fakturPajak.setNama_pkp(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_NAMA_PKP]));
            fakturPajak.setNumber(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_NUMBER]));
            fakturPajak.setCounter(rs.getInt(DbFakturPajak.colNames[DbFakturPajak.COL_COUNTER]));
            fakturPajak.setTransfer_number(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_TRANSFER_NUMBER]));
            fakturPajak.setSalesNumber(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_SALES_NUMBER]));
            fakturPajak.setDate(rs.getDate(DbFakturPajak.colNames[DbFakturPajak.COL_DATE]));            
            fakturPajak.setPkpAddress(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_PKP_ADDRESS]));
            fakturPajak.setNpwpPkp(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_NPWP_PKP]));
            fakturPajak.setCustomerId(rs.getLong(DbFakturPajak.colNames[DbFakturPajak.COL_CUSTOMER_ID]));
            fakturPajak.setCustomerAddress(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_CUSTOMER_ADDRESS]));
            fakturPajak.setNpwpCustomer(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_NPWP_CUSTOMER]));
            fakturPajak.setSalesId(rs.getLong(DbFakturPajak.colNames[DbFakturPajak.COL_SALES_ID]));
            fakturPajak.setPrefixNumber(rs.getString(DbFakturPajak.colNames[DbFakturPajak.COL_PREFIX_NUMBER]));
            fakturPajak.setLocationId(rs.getLong(DbFakturPajak.colNames[DbFakturPajak.COL_LOCATION_ID]));
            fakturPajak.setTypeFaktur(rs.getInt(DbFakturPajak.colNames[DbFakturPajak.COL_TYPE_FAKTUR]));
            fakturPajak.setLocationToId(rs.getLong(DbFakturPajak.colNames[DbFakturPajak.COL_LOCATION_TO_ID]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long transferId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FAKTUR_PAJAK + " WHERE " +
                    DbFakturPajak.colNames[DbFakturPajak.COL_FAKTUR_PAJAK_ID] + " = " + transferId;

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
            String sql = "SELECT COUNT(" + DbFakturPajak.colNames[DbFakturPajak.COL_FAKTUR_PAJAK_ID] + ") FROM " + DB_FAKTUR_PAJAK;
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
                    Transfer transfer = (Transfer) list.get(ls);
                    if (oid == transfer.getOID()) {
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

    public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_FAKTUR_PAJAK ;
                    

            System.out.println(sql);

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }

            result = result + 1;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static String getNextNumber(int ctr) {

        String code = "";//getNumberPrefix();

        if (ctr < 10) {
            code = code + "0000000" + ctr;
        } else if (ctr < 100) {
            code = code + "000000" + ctr;
        } else if (ctr < 1000) {
            code = code + "00000" + ctr;
        } else if (ctr < 10000) {
            code = code + "0000" + ctr;    
        } else if (ctr < 100000) {
            code = code + "000" + ctr;        
        } else if (ctr < 1000000) {
            code = code + "00" + ctr;        
        } else if (ctr < 10000000) {
            code = code + "0" + ctr;        
        } else {
            code = code + ctr;
        }

        return code;

    }
    
    public static int getNextCounterFp(long locationId){        
        
        int result = 0;
        CONResultSet dbrs = null;
        try {
            
            int year = new Date().getYear() + 1900;
            String  sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DbSystemDocNumber.DB_SYSTEM_DOC_NUMBER + " WHERE " +                        
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_FP] + "' and "+DbSystemDocNumber.colNames[DbSystemDocNumber.COL_YEAR]+" = "+year;

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
    
    
    public static String getNumberPrefixFp(long locationId){        
        //format faktur pajak 010.000.12-00000015
        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_FP]);

        Date dt = new Date();

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}
        
        Location location = new Location();
        try{
            location = DbLocation.fetchExc(locationId);
        }catch(Exception e){}
        
        String codePrefx = location.getPrefixFakturPajak();
        code = codePrefx + "." + code;

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
                code = code + "." + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    
    public static String getNumberPrefixFpTransfer(long locationId){        
        //format faktur pajak 010.000.12-00000015
        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_FP]);

        Date dt = new Date();

        String code = "";

        //untuk code
        try {
            code = systemDocCode.getCode();
        } catch (Exception e) { System.out.println("[exception] " + e.toString());}
        
        Location location = new Location();
        try{
            location = DbLocation.fetchExc(locationId);
        }catch(Exception e){}
        
        String codePrefx = location.getPrefixFakturTransfer();
        code = codePrefx + "." + code;

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
                code = code + "." + year;
            }

        } catch (Exception e){ System.out.println("[exception] " + e.toString()); }

        return code;
    }
    
    public static String getNextNumberFp(int ctr,long locationId){

        //format faktur pajak 010.000.12-00000015

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_FP]);
        
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
        
        String code = getNumberPrefixFp(locationId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static String getNextNumberFpTransfer(int ctr,long locationId){

        //format faktur pajak 010.000.12-00000015

        SystemDocCode systemDocCode = new SystemDocCode();
        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_FP]);
        
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
        
        String code = getNumberPrefixFpTransfer(locationId);
        
        if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_FRONT){
            code = number + systemDocCode.getSeparator() + code ;            
        }else if(systemDocCode.getPosisiAfterCode() == DbSystemDocCode.TYPE_POSITION_BACK){
            code = code + systemDocCode.getSeparator() + number;
        }

        return code;
    }
    
    public static int getMaxData(long transferId){
        CONResultSet dbrs = null;
        try{
          
            String sql = "select count(pti."+DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID]+") from "+DbTransferItem.DB_POS_TRANSFER_ITEM+" pti inner join "+DbItemMaster.DB_ITEM_MASTER+" pim on pti."+DbTransferItem.colNames[DbTransferItem.COL_ITEM_MASTER_ID]+"= pim."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" where "+
                    " pim."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+" = "+DbItemMaster.BKP+" and pti."+DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ID]+" = "+transferId;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                int x = rs.getInt(1);
                return x;
            }
            
        }catch(Exception e){
            return 0;
        }
        return 0;
    }
    
    public static int updateLocation(long fakturPajakId,long locationFrom,long locationTo){
        
        int result = 0;
        
        String sql = "update "+DB_FAKTUR_PAJAK+" set "+colNames[COL_LOCATION_ID]+" = "+locationFrom+","+colNames[COL_LOCATION_TO_ID]+" = "+locationTo+" where "+colNames[COL_FAKTUR_PAJAK_ID]+" = "+fakturPajakId;
        
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }
    
     public static int updateLocation(long fakturPajakId,long locationTo){
        
        int result = 0;
        
        String sql = "update "+DB_FAKTUR_PAJAK+" set "+colNames[COL_LOCATION_TO_ID]+" = "+locationTo+" where "+colNames[COL_FAKTUR_PAJAK_ID]+" = "+fakturPajakId;
        
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }
    
}
