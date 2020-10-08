package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;


public class DbIndukCustomer extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_INDUK_CUSTOMER = "crm_induk_customer";
    
    public static final int COL_INDUK_CUSTOMER_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_ADDRESS = 2;
    public static final int COL_CITY = 3;
    public static final int COL_COUNTRY_ID = 4;
    public static final int COL_POSTAL_CODE = 5;
    public static final int COL_CONTACT_PERSON = 6;
    public static final int COL_POSISI_CONTACT_PERSON = 7;
    public static final int COL_COUNTRY_CODE = 8;
    public static final int COL_AREA_CODE = 9;
    public static final int COL_PHONE = 10;
    public static final int COL_WEBSITE = 11;
    public static final int COL_EMAIL = 12;
    public static final int COL_NPWP = 13;
    public static final int COL_FAX = 14;
    
    public static final String[] colNames = {
        "induk_customer_id",
        "name",
        "address",
        "city",
        "country_id",
        "postal_code",
        "contact_person",
        "posisi_contact_person",
        "country_code",
        "area_code",
        "phone",
        "website",
        "email",
        "npwp",
        "fax"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING, // name
        TYPE_STRING, // addres1        
        TYPE_STRING, // city
        TYPE_LONG, // countryid
        TYPE_STRING, // postal code
        TYPE_STRING, // contact_person        
        TYPE_STRING, // posisi_contact
        TYPE_STRING, // country_code
        TYPE_STRING, // area_code
        TYPE_STRING, // phone
        TYPE_STRING, // website
        TYPE_STRING, // email
        TYPE_STRING, // email
        TYPE_STRING // fax
    };

    public DbIndukCustomer() {
    }

    public DbIndukCustomer(int i) throws CONException {
        super(new DbIndukCustomer());
    }

    public DbIndukCustomer(String sOid) throws CONException {
        super(new DbIndukCustomer(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbIndukCustomer(long lOid) throws CONException {
        super(new DbIndukCustomer(0));
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
        return DB_INDUK_CUSTOMER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbIndukCustomer().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        IndukCustomer indukCustomer = fetch(ent.getOID());
        ent = (Entity) indukCustomer;
        return indukCustomer.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Country) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Country) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return delete(ent.getOID());
    }

    public static IndukCustomer fetch(long oid) throws CONException {
        try {
            IndukCustomer indukCustomer = new IndukCustomer();
            DbIndukCustomer dbIndukCustomer = new DbIndukCustomer(oid);

            indukCustomer.setOID(oid);
            indukCustomer.setName(dbIndukCustomer.getString(COL_NAME));
            indukCustomer.setAddress(dbIndukCustomer.getString(COL_ADDRESS));
            indukCustomer.setCity(dbIndukCustomer.getString(COL_CITY));
            indukCustomer.setCountryId(dbIndukCustomer.getlong(COL_COUNTRY_ID));
            indukCustomer.setPostalCode(dbIndukCustomer.getString(COL_POSTAL_CODE));
            indukCustomer.setContactPerson(dbIndukCustomer.getString(COL_CONTACT_PERSON));
            indukCustomer.setPosisiContactPerson(dbIndukCustomer.getString(COL_POSISI_CONTACT_PERSON));
            indukCustomer.setCountryCode(dbIndukCustomer.getString(COL_COUNTRY_CODE));
            indukCustomer.setAreaCode(dbIndukCustomer.getString(COL_AREA_CODE));
            indukCustomer.setPhone(dbIndukCustomer.getString(COL_PHONE));
            indukCustomer.setWebsite(dbIndukCustomer.getString(COL_WEBSITE));
            indukCustomer.setEmail(dbIndukCustomer.getString(COL_EMAIL));
            indukCustomer.setNpwp(dbIndukCustomer.getString(COL_NPWP));
            indukCustomer.setFax(dbIndukCustomer.getString(COL_FAX));

            return indukCustomer;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCountry(0), CONException.UNKNOWN);
        }
    }

    public static long insert(IndukCustomer indukCustomer) throws CONException {
        try {
            DbIndukCustomer dbIndukCustomer = new DbIndukCustomer(0);

            dbIndukCustomer.setString(COL_NAME, indukCustomer.getName());
            dbIndukCustomer.setString(COL_ADDRESS, indukCustomer.getAddress());
            dbIndukCustomer.setString(COL_CITY, indukCustomer.getCity());
            dbIndukCustomer.setLong(COL_COUNTRY_ID, indukCustomer.getCountryId());
            dbIndukCustomer.setString(COL_POSTAL_CODE, indukCustomer.getPostalCode());
            dbIndukCustomer.setString(COL_CONTACT_PERSON, indukCustomer.getContactPerson());
            dbIndukCustomer.setString(COL_POSISI_CONTACT_PERSON, indukCustomer.getPosisiContactPerson());
            dbIndukCustomer.setString(COL_COUNTRY_CODE, indukCustomer.getCountryCode());
            dbIndukCustomer.setString(COL_AREA_CODE, indukCustomer.getAreaCode());
            dbIndukCustomer.setString(COL_PHONE, indukCustomer.getPhone());
            dbIndukCustomer.setString(COL_WEBSITE, indukCustomer.getWebsite());
            dbIndukCustomer.setString(COL_EMAIL, indukCustomer.getEmail());
            dbIndukCustomer.setString(COL_NPWP, indukCustomer.getNpwp());
            dbIndukCustomer.setString(COL_FAX, indukCustomer.getFax());

            dbIndukCustomer.insert();

            indukCustomer.setOID(dbIndukCustomer.getlong(COL_INDUK_CUSTOMER_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCountry(0), CONException.UNKNOWN);
        }
        return indukCustomer.getOID();
    }

    public static long update(IndukCustomer indukCustomer) throws CONException {
        try {
            if (indukCustomer.getOID() != 0) {

                DbIndukCustomer dbIndukCustomer = new DbIndukCustomer(indukCustomer.getOID());

                dbIndukCustomer.setString(COL_NAME, indukCustomer.getName());
                dbIndukCustomer.setString(COL_ADDRESS, indukCustomer.getAddress());
                dbIndukCustomer.setString(COL_CITY, indukCustomer.getCity());
                dbIndukCustomer.setLong(COL_COUNTRY_ID, indukCustomer.getCountryId());
                dbIndukCustomer.setString(COL_POSTAL_CODE, indukCustomer.getPostalCode());
                dbIndukCustomer.setString(COL_CONTACT_PERSON, indukCustomer.getContactPerson());
                dbIndukCustomer.setString(COL_POSISI_CONTACT_PERSON, indukCustomer.getPosisiContactPerson());
                dbIndukCustomer.setString(COL_COUNTRY_CODE, indukCustomer.getCountryCode());
                dbIndukCustomer.setString(COL_AREA_CODE, indukCustomer.getAreaCode());
                dbIndukCustomer.setString(COL_PHONE, indukCustomer.getPhone());
                dbIndukCustomer.setString(COL_WEBSITE, indukCustomer.getWebsite());
                dbIndukCustomer.setString(COL_EMAIL, indukCustomer.getEmail());
                dbIndukCustomer.setString(COL_NPWP, indukCustomer.getNpwp());
                dbIndukCustomer.setString(COL_FAX, indukCustomer.getFax());

                dbIndukCustomer.update();
                return indukCustomer.getOID();


            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCountry(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long delete(long oid) throws CONException {
        try {
            DbIndukCustomer indukCustomer = new DbIndukCustomer(oid);
            indukCustomer.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCountry(0), CONException.UNKNOWN);
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

            String sql = "SELECT * FROM " + DB_INDUK_CUSTOMER;

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
                IndukCustomer indukCustomer = new IndukCustomer();
                resultToObject(rs, indukCustomer);
                lists.add(indukCustomer);
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

    private static void resultToObject(ResultSet rs, IndukCustomer indukCustomer) {
        try {

            indukCustomer.setOID(rs.getLong(DbIndukCustomer.colNames[DbIndukCustomer.COL_INDUK_CUSTOMER_ID]));
            indukCustomer.setName(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_NAME]));
            indukCustomer.setAddress(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_ADDRESS]));
            indukCustomer.setCity(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_CITY]));
            indukCustomer.setCountryId(rs.getLong(DbIndukCustomer.colNames[DbIndukCustomer.COL_COUNTRY_ID]));
            indukCustomer.setPostalCode(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_POSTAL_CODE]));
            indukCustomer.setContactPerson(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_CONTACT_PERSON]));
            indukCustomer.setPosisiContactPerson(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_POSISI_CONTACT_PERSON]));
            indukCustomer.setCountryCode(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_COUNTRY_CODE]));
            indukCustomer.setAreaCode(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_AREA_CODE]));
            indukCustomer.setPhone(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_PHONE]));
            indukCustomer.setWebsite(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_WEBSITE]));
            indukCustomer.setEmail(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_EMAIL]));
            indukCustomer.setNpwp(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_NPWP]));
            indukCustomer.setFax(rs.getString(DbIndukCustomer.colNames[DbIndukCustomer.COL_FAX]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long countyId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_INDUK_CUSTOMER + " WHERE " +
                    DbCountry.colNames[DbCountry.COL_COUNTY_ID] + " = " + countyId;

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
            String sql = "SELECT COUNT(" + DbIndukCustomer.colNames[DbIndukCustomer.COL_INDUK_CUSTOMER_ID] + ") FROM " + DB_INDUK_CUSTOMER;
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

    public static boolean checkNama(long indukCustomerOID, String name) {
        CONResultSet dbrs = null;
        boolean bool = false;
        try {
            String sql = "SELECT NAME FROM " + DB_INDUK_CUSTOMER + " WHERE NAME ='" + name + "' and induk_customer_id!=" + indukCustomerOID;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                bool = true;
            }

            rs.close();
            return bool;
        } catch (Exception e) {
            return false;
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
                    Country country = (Country) list.get(ls);
                    if (oid == country.getOID()) {
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
}

