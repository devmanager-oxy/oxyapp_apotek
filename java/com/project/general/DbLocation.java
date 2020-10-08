package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;

public class DbLocation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_LOCATION = "pos_location";
    
    public static final int COL_LOCATION_ID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_NAME = 2;
    public static final int COL_ADDRESS_STREET = 3;
    public static final int COL_ADDRESS_COUNTRY = 4;
    public static final int COL_ADDRESS_CITY = 5;
    public static final int COL_TELP = 6;
    public static final int COL_PIC = 7;
    public static final int COL_CODE = 8;
    public static final int COL_DESCRIPTION = 9;
    public static final int COL_COA_AR_ID = 10;
    public static final int COL_COA_AP_ID = 11;
    public static final int COL_COA_PPN_ID = 12;
    public static final int COL_COA_PPH_ID = 13;
    public static final int COL_COA_DISCOUNT_ID = 14;
    public static final int COL_COA_SALES_ID = 15;
    public static final int COL_COA_PROJECT_PPH_PASAL_23_ID = 16;
    public static final int COL_COA_PROJECT_PPH_PASAL_22_ID = 17;
    public static final int COL_LOCATION_ID_REQUEST = 18;
    public static final int COL_GOL_PRICE = 19;
    public static final int COL_NPWP = 20;
    public static final int COL_PREFIX_FAKTUR_PAJAK = 21;
    public static final int COL_PREFIX_FAKTUR_TRANSFER = 22;
    public static final int COL_AKTIF_AUTO_ORDER = 23;    
    public static final int COL_DATE_START = 24;
    public static final int COL_TYPE_GROSIR = 25;
    public static final int COL_TYPE_24HOUR = 26;
    public static final int COL_AMOUNT_TARGET = 27;
    public static final int COL_COA_AP_GROSIR_ID = 28;
    
    public static final String[] colNames = {
        "location_id",
        "type",
        "name",
        "address_street",
        "address_country",
        "address_city",
        "telp",
        "pic",
        "code",
        "description",
        "coa_ar_id",
        "coa_ap_id",
        "coa_ppn_id",
        "coa_pph_id",
        "coa_discount_id",
        "coa_sales_code_id",
        "coa_project_pph_pasal_23_id",
        "coa_project_pph_pasal_22_id",
        "location_request",
        "gol_price",
        "npwp",
        "prefix_faktur_pajak",
        "prefix_faktur_transfer",
        "aktif_auto_order",
        "date_start",
        "type_grosir",
        "type_24hour",
        "amount_target",
        "coa_ap_grosir_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
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
        TYPE_INT,
        TYPE_DATE,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG
    };
    
    public static final String TYPE_OFFICE = "Office";
    public static final String TYPE_WAREHOUSE = "Warehouse";
    public static final String TYPE_STORE_ROOM = "Store Room";
    public static final String TYPE_STORE = "Store";
    public static final String TYPE_STORE_RESTO = "Restaurant";
    public static final String TYPE_DISTRIBUTION_CENTER = "Distrib. Center";
    public static final String TYPE_GENERAL_AFFAIR = "General Affair";
    
    public static String[] strLocTypes = {TYPE_OFFICE, TYPE_WAREHOUSE, TYPE_STORE_ROOM, TYPE_STORE, TYPE_STORE_RESTO, TYPE_DISTRIBUTION_CENTER,TYPE_GENERAL_AFFAIR};    
    
    public static final int TYPE_RETAIL = 0;
    public static final int TYPE_GROSIR = 1;
    
    public static String[] strKeyTypes = {"Retail", "Grosir"};
    public static String[] strValueTypes = {"0", "1"};
    
    public static final int TYPE_24HOUR_YES = 0;
    public static final int TYPE_24HOUR_NO  = 1;
    
    public static String[] strKey24Hour = {"Yes", "No"};
    public static String[] strValue24Hour = {"0", "1"};
    
    public static final String[] golPrice = {
            "gol_1",
            "gol_2",
            "gol_3",
            "gol_4",
            "gol_5",
            "gol_6",
            "gol_7",
            "gol_8",
            "gol_9",
            "gol_10",
            "gol_11"
    };

    public DbLocation() {
    }

    public DbLocation(int i) throws CONException {
        super(new DbLocation());
    }

    public DbLocation(String sOid) throws CONException {
        super(new DbLocation(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLocation(long lOid) throws CONException {
        super(new DbLocation(0));
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
        return DB_LOCATION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLocation().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Location location = fetchExc(ent.getOID());
        ent = (Entity) location;
        return location.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Location) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Location) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Location fetchExc(long oid) throws CONException {
        try {
            Location location = new Location();
            DbLocation pstLocation = new DbLocation(oid);
            location.setOID(oid);
            location.setType(pstLocation.getString(COL_TYPE));
            location.setName(pstLocation.getString(COL_NAME));
            location.setAddressStreet(pstLocation.getString(COL_ADDRESS_STREET));
            location.setAddressCountry(pstLocation.getString(COL_ADDRESS_COUNTRY));
            location.setAddressCity(pstLocation.getString(COL_ADDRESS_CITY));
            location.setTelp(pstLocation.getString(COL_TELP));
            location.setPic(pstLocation.getString(COL_PIC));
            location.setCode(pstLocation.getString(COL_CODE));
            location.setDescription(pstLocation.getString(COL_DESCRIPTION));
            location.setCoaArId(pstLocation.getlong(COL_COA_AR_ID));
            location.setCoaApId(pstLocation.getlong(COL_COA_AP_ID));
            location.setCoaPpnId(pstLocation.getlong(COL_COA_PPN_ID));
            location.setCoaPphId(pstLocation.getlong(COL_COA_PPH_ID));
            location.setCoaDiscountId(pstLocation.getlong(COL_COA_DISCOUNT_ID));
            location.setCoaSalesId(pstLocation.getlong(COL_COA_SALES_ID));
            location.setCoaProjectPPHPasal23Id(pstLocation.getlong(COL_COA_PROJECT_PPH_PASAL_23_ID));
            location.setCoaProjectPPHPasal22Id(pstLocation.getlong(COL_COA_PROJECT_PPH_PASAL_22_ID));
            location.setLocationIdRequest(pstLocation.getlong(COL_LOCATION_ID_REQUEST));
            location.setGol_price(pstLocation.getString(COL_GOL_PRICE));
            location.setNpwp(pstLocation.getString(COL_NPWP));
            location.setPrefixFakturPajak(pstLocation.getString(COL_PREFIX_FAKTUR_PAJAK));
            location.setPrefixFakturTransfer(pstLocation.getString(COL_PREFIX_FAKTUR_TRANSFER));
            location.setAktifAutoOrder(pstLocation.getInt(COL_AKTIF_AUTO_ORDER));            
            location.setDateStart(pstLocation.getDate(COL_DATE_START));
            location.setTypeGrosir(pstLocation.getInt(COL_TYPE_GROSIR));
            location.setType24Hour(pstLocation.getInt(COL_TYPE_24HOUR));
            location.setAmountTarget(pstLocation.getdouble(COL_AMOUNT_TARGET));
            location.setCoaApGrosirId(pstLocation.getlong(COL_COA_AP_GROSIR_ID));
            return location;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLocation(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Location location) throws CONException {
        try {
            DbLocation pstLocation = new DbLocation(0);

            pstLocation.setString(COL_TYPE, location.getType());
            pstLocation.setString(COL_NAME, location.getName());
            pstLocation.setString(COL_ADDRESS_STREET, location.getAddressStreet());
            pstLocation.setString(COL_ADDRESS_COUNTRY, location.getAddressCountry());
            pstLocation.setString(COL_ADDRESS_CITY, location.getAddressCity());
            pstLocation.setString(COL_TELP, location.getTelp());
            pstLocation.setString(COL_PIC, location.getPic());
            pstLocation.setString(COL_CODE, location.getCode());
            pstLocation.setString(COL_DESCRIPTION, location.getDescription());
            pstLocation.setLong(COL_COA_AR_ID, location.getCoaArId());
            pstLocation.setLong(COL_COA_AP_ID, location.getCoaApId());
            pstLocation.setLong(COL_COA_PPN_ID, location.getCoaPpnId());
            pstLocation.setLong(COL_COA_PPH_ID, location.getCoaPphId());
            pstLocation.setLong(COL_COA_DISCOUNT_ID, location.getCoaDiscountId());
            pstLocation.setLong(COL_COA_SALES_ID, location.getCoaSalesId());
            pstLocation.setLong(COL_COA_PROJECT_PPH_PASAL_23_ID, location.getCoaProjectPPHPasal23Id());
            pstLocation.setLong(COL_COA_PROJECT_PPH_PASAL_22_ID, location.getCoaProjectPPHPasal22Id());
            pstLocation.setLong(COL_LOCATION_ID_REQUEST, location.getLocationIdRequest());
            pstLocation.setString(COL_GOL_PRICE, location.getGol_price());
            pstLocation.setString(COL_NPWP, location.getNpwp());
            pstLocation.setString(COL_PREFIX_FAKTUR_PAJAK, location.getPrefixFakturPajak());
            pstLocation.setString(COL_PREFIX_FAKTUR_TRANSFER, location.getPrefixFakturTransfer());
            pstLocation.setInt(COL_AKTIF_AUTO_ORDER, location.getAktifAutoOrder());            
            pstLocation.setDate(COL_DATE_START, location.getDateStart());
            pstLocation.setInt(COL_TYPE_GROSIR, location.getTypeGrosir());
            pstLocation.setInt(COL_TYPE_24HOUR, location.getType24Hour());
            pstLocation.setDouble(COL_AMOUNT_TARGET, location.getAmountTarget());
            pstLocation.setLong(COL_COA_AP_GROSIR_ID, location.getCoaApGrosirId());
            pstLocation.insert();
            location.setOID(pstLocation.getlong(COL_LOCATION_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLocation(0), CONException.UNKNOWN);
        }
        return location.getOID();
    }

    public static long updateExc(Location location) throws CONException {
        try {
            if (location.getOID() != 0) {
                DbLocation pstLocation = new DbLocation(location.getOID());

                pstLocation.setString(COL_TYPE, location.getType());
                pstLocation.setString(COL_NAME, location.getName());
                pstLocation.setString(COL_ADDRESS_STREET, location.getAddressStreet());
                pstLocation.setString(COL_ADDRESS_COUNTRY, location.getAddressCountry());
                pstLocation.setString(COL_ADDRESS_CITY, location.getAddressCity());
                pstLocation.setString(COL_TELP, location.getTelp());
                pstLocation.setString(COL_PIC, location.getPic());
                pstLocation.setString(COL_CODE, location.getCode());
                pstLocation.setString(COL_DESCRIPTION, location.getDescription());
                pstLocation.setLong(COL_COA_AR_ID, location.getCoaArId());
                pstLocation.setLong(COL_COA_AP_ID, location.getCoaApId());
                pstLocation.setLong(COL_COA_PPN_ID, location.getCoaPpnId());
                pstLocation.setLong(COL_COA_PPH_ID, location.getCoaPphId());
                pstLocation.setLong(COL_COA_DISCOUNT_ID, location.getCoaDiscountId());
                pstLocation.setLong(COL_COA_SALES_ID, location.getCoaSalesId());
                pstLocation.setLong(COL_COA_PROJECT_PPH_PASAL_23_ID, location.getCoaProjectPPHPasal23Id());
                pstLocation.setLong(COL_COA_PROJECT_PPH_PASAL_22_ID, location.getCoaProjectPPHPasal22Id());
                pstLocation.setLong(COL_LOCATION_ID_REQUEST, location.getLocationIdRequest());
                pstLocation.setString(COL_GOL_PRICE, location.getGol_price());
                pstLocation.setString(COL_NPWP, location.getNpwp());
                pstLocation.setString(COL_PREFIX_FAKTUR_PAJAK, location.getPrefixFakturPajak());
                pstLocation.setString(COL_PREFIX_FAKTUR_TRANSFER, location.getPrefixFakturTransfer());
                pstLocation.setInt(COL_AKTIF_AUTO_ORDER, location.getAktifAutoOrder());
                pstLocation.setDate(COL_DATE_START, location.getDateStart());
                pstLocation.setInt(COL_TYPE_GROSIR, location.getTypeGrosir());
                pstLocation.setInt(COL_TYPE_24HOUR, location.getType24Hour());
                pstLocation.setDouble(COL_AMOUNT_TARGET, location.getAmountTarget());
                pstLocation.setLong(COL_COA_AP_GROSIR_ID, location.getCoaApGrosirId());
                
                pstLocation.update();
                return location.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLocation(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLocation pstLocation = new DbLocation(oid);
            pstLocation.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLocation(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOCATION;
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
                Location location = new Location();
                resultToObject(rs, location);
                lists.add(location);
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
    
    public static Vector listLocation(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT "+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+","+
                    DbLocation.colNames[DbLocation.COL_NAME]+
                    " FROM " + DB_LOCATION;
            
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
                Location location = new Location();
                location.setOID(rs.getLong(DbLocation.colNames[DbLocation.COL_LOCATION_ID]));
                location.setName(rs.getString(DbLocation.colNames[DbLocation.COL_NAME]));
                lists.add(location);
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

    private static void resultToObject(ResultSet rs, Location location) {
        try {
            location.setOID(rs.getLong(DbLocation.colNames[DbLocation.COL_LOCATION_ID]));
            location.setType(rs.getString(DbLocation.colNames[DbLocation.COL_TYPE]));
            location.setName(rs.getString(DbLocation.colNames[DbLocation.COL_NAME]));
            location.setAddressStreet(rs.getString(DbLocation.colNames[DbLocation.COL_ADDRESS_STREET]));
            location.setAddressCountry(rs.getString(DbLocation.colNames[DbLocation.COL_ADDRESS_COUNTRY]));
            location.setAddressCity(rs.getString(DbLocation.colNames[DbLocation.COL_ADDRESS_CITY]));
            location.setTelp(rs.getString(DbLocation.colNames[DbLocation.COL_TELP]));
            location.setPic(rs.getString(DbLocation.colNames[DbLocation.COL_PIC]));
            location.setCode(rs.getString(DbLocation.colNames[DbLocation.COL_CODE]));
            location.setDescription(rs.getString(DbLocation.colNames[DbLocation.COL_DESCRIPTION]));
            location.setCoaArId(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_AR_ID]));
            location.setCoaApId(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_AP_ID]));
            location.setCoaPpnId(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_PPN_ID]));
            location.setCoaPphId(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_PPH_ID]));
            location.setCoaProjectPPHPasal22Id(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_PROJECT_PPH_PASAL_22_ID]));
            location.setCoaDiscountId(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_DISCOUNT_ID]));
            location.setCoaSalesId(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_SALES_ID]));
            location.setCoaProjectPPHPasal23Id(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_PROJECT_PPH_PASAL_23_ID]));
            location.setLocationIdRequest(rs.getLong(DbLocation.colNames[DbLocation.COL_LOCATION_ID_REQUEST]));
            location.setGol_price(rs.getString(DbLocation.colNames[DbLocation.COL_GOL_PRICE]));
            location.setNpwp(rs.getString(DbLocation.colNames[DbLocation.COL_NPWP]));
            location.setPrefixFakturPajak(rs.getString(DbLocation.colNames[DbLocation.COL_PREFIX_FAKTUR_PAJAK]));
            location.setPrefixFakturTransfer(rs.getString(DbLocation.colNames[DbLocation.COL_PREFIX_FAKTUR_TRANSFER]));
            location.setAktifAutoOrder(rs.getInt(DbLocation.colNames[DbLocation.COL_AKTIF_AUTO_ORDER]));            
            location.setDateStart(rs.getDate(DbLocation.colNames[DbLocation.COL_DATE_START]));
            location.setTypeGrosir(rs.getInt(DbLocation.colNames[DbLocation.COL_TYPE_GROSIR]));
            location.setType24Hour(rs.getInt(DbLocation.colNames[DbLocation.COL_TYPE_24HOUR]));
            location.setAmountTarget(rs.getDouble(DbLocation.colNames[DbLocation.COL_AMOUNT_TARGET]));
            location.setCoaApGrosirId(rs.getLong(DbLocation.colNames[DbLocation.COL_COA_AP_GROSIR_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long locationId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOCATION + " WHERE " +
                    DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + locationId;

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
            String sql = "SELECT COUNT(" + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + ") FROM " + DB_LOCATION;
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
                    Location location = (Location) list.get(ls);
                    if (oid == location.getOID()) {
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

    public static Location getLocationById(long oidLocation) {
        if (oidLocation != 0) {
            try {
                return fetchExc(oidLocation);
            } catch (Exception e) {
            }
        }
        return new Location();
    }
}
