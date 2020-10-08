package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import java.util.Hashtable;
import java.util.Vector;

public class DbCustomer extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_CUSTOMER = "customer";
    
    public static final int COL_CUSTOMER_ID             = 0;    
    public static final int COL_NAME                    = 1;
    public static final int COL_TYPE                    = 2;
    public static final int COL_ADDRESS_1               = 3;    
    public static final int COL_ADDRESS_2               = 4; 
    public static final int COL_CITY                    = 5;    
    public static final int COL_COUNTRY_ID              = 6;    
    public static final int COL_POSTAL_CODE             = 7;
    public static final int COL_CONTACT_PERSON          = 8;
    public static final int COL_POSISI_CONTACT_PERSON   = 9;  
    public static final int COL_COUNTRY_CODE            = 10;
    
    public static final int COL_AREA_CODE               = 11;    
    public static final int COL_PHONE                   = 12;
    public static final int COL_NATIONALITY_ID          = 13;
    public static final int COL_STATE                   = 14;
    public static final int COL_COUNTRY_NAME            = 15;
    public static final int COL_NATIONALITY_NAME        = 16;
    public static final int COL_ID_TYPE                 = 17;
    public static final int COL_WEBSITE                 = 18;
    public static final int COL_EMAIL                   = 19;
    public static final int COL_STATUS                  = 20;
    
    public static final int COL_INDUK_CUSTOMER_ID       = 21;
    public static final int COL_FAX                     = 22;          
    public static final int COL_ID_NUMBER               = 23;   
    public static final int COL_DOB                     = 24;
    public static final int COL_INTEREST                = 25;
    public static final int COL_SALUTATION              = 26;  
    public static final int COL_DOB_IGNORE              = 27;
    public static final int COL_CODE                    = 28;    
    public static final int COL_PHONE_AREA              = 29;
    public static final int COL_FAX_AREA                = 30;
    
    public static final int COL_MIDDLE_NAME             = 31;
    public static final int COL_LAST_NAME               = 32;
    public static final int COL_CONTACT_MIDDLE_NAME     = 33;
    public static final int COL_CONTACT_LAST_NAME       = 34;
    public static final int COL_HP                      = 35;
    public static final int COL_ZIP_CODE                = 36;    
    public static final int COL_CONTACT_PHONE           = 37;    
    public static final int COL_CONTACT_POSITION        = 38;
    public static final int COL_CONTACT_EMAIL           = 39;    
    public static final int COL_GOL_PRICE               = 40;
    
    public static final int COL_COMPANY_ID              = 41;
    public static final int COL_PERSONAL_DISCOUNT       = 42;
    public static final int COL_EXPIRED_DATE            = 43;
    public static final int COL_ANIMAL_NAME             = 44;
    public static final int COL_CREDIT_LIMIT            = 45;
    public static final int COL_REG_DATE                = 46;
    public static final int COL_NPWP                    = 47;    
    public static final int COL_PROPINSI_ID             = 48;
    public static final int COL_KABUPATEN_ID            = 49;
    public static final int COL_KECAMATAN_ID            = 50;
    
    public static final int COL_IS_PKP                  = 51;
    public static final int COL_PKP_COMPANY             = 52;
    public static final int COL_PKP_ADDRESS             = 53;
    public static final int COL_PKP_NPPKP               = 54;
    public static final int COL_SCH_SENIN               = 55;
    public static final int COL_SCH_SELASA              = 56;
    public static final int COL_SCH_RABU                = 57;
    public static final int COL_SCH_KAMIS               = 58;
    public static final int COL_SCH_JUMAT               = 59;
    public static final int COL_SCH_SABTU               = 60;
    
    public static final int COL_SCH_MINGGU              = 61;    
    public static final int COL_IGNORE_LOC_CREDIT_LIMIT = 62;
    public static final int COL_DUE_DATE                = 63;
    public static final int COL_MAX_PENDING_ORDER       = 64;    
    public static final int COL_DEF_DUE_DATE_DAY        = 65;
    
    public static final int COL_JATUH_TEMPO             = 66;
    
    public static final String[] colNames = {
        "customer_id",
        "name",
        "type",
        "address",
        "address_2",
        "city",
        "company_country_id",
        "postal_code", 
        "contact_person",
        "posisi_contact_person", 
        "country_code",
        
        "area_code",
        "phone", 
        "nationality_id",
        "state",
        "country_name",
        "nationality_name",
        "id_type",        
        "website", 
        "email", 
        "status",
        
        "induk_customer_id",
        "fax",       
        "id_number",
        "dob", 
        "interest",
        "salutation",
        "dob_ignore",
        "code", 
        "phone_area",
        "fax_area",        
        
        "middle_name",
        "last_name",
        "contact_middle_name",
        "contact_last_name",
        "hp", 
        "zip_code",
        "contact_phone", 
        "contact_position",
        "contact_email", 
        "gol_price", 
        
        "company_id",
        "personal_discount",
        "expired_date",
        "animal_name", 
        "credit_limit",
        "reg_date", 
        "npwp", 
        "propinsi_id",
        "kabupaten_id",
        "kecamatan_id",        
        
        "is_pkp",
        "pkp_company",
        "pkp_address",
        "pkp_nppkp",
        "sch_senin",
        "sch_selasa",
        "sch_rabu",
        "sch_kamis",
        "sch_jumat",
        "sch_sabtu",        
        
        "sch_minggu",
        "ignore_loc_credit_limit",
        "due_date",
        "max_pending_order",
        "def_due_date_day",
        "jatuh_tempo"
                
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID, //customer_id
        TYPE_STRING, // name
        TYPE_INT, // type
        TYPE_STRING, // address
        TYPE_STRING, // address_2
        TYPE_STRING, // city
        TYPE_LONG, // company_country_id
        TYPE_STRING, // postal code
        TYPE_STRING, // contact_person        
        TYPE_STRING, // posisi_contact_person
        TYPE_STRING, // country_code
        
        TYPE_STRING, // area_code
        TYPE_STRING, // phone
        TYPE_LONG, //nationality_id
        TYPE_STRING, //state
        TYPE_STRING, //country_name
        TYPE_STRING, //nationality_name
        TYPE_STRING, //id_type
        TYPE_STRING, // web site        
        TYPE_STRING, // email
        TYPE_STRING, // status
        
        TYPE_LONG, // induck customer id
        TYPE_STRING, // fax
        TYPE_STRING, //id_number
        TYPE_DATE, //dob
        TYPE_STRING, //interest
        TYPE_STRING, //salutation
        TYPE_INT, //dob_ignore
        TYPE_STRING, //code
        TYPE_STRING, //phone_area
        TYPE_STRING, //fax_area
        
        TYPE_STRING, //middle_name
        TYPE_STRING, //last_name
        TYPE_STRING, //contact_middle_name
        TYPE_STRING,//contact_last_name
        TYPE_STRING, //hp
        TYPE_STRING,//zip_code
        TYPE_STRING, //contact_phone
        TYPE_STRING,//contact_position
        TYPE_STRING, //contact_email
        TYPE_STRING, //gol_price
        
        TYPE_LONG, //"company_id",
        TYPE_FLOAT, //"personal_discount",
        TYPE_DATE, //"expired_date",
        TYPE_STRING, //"animal_name", 
        TYPE_FLOAT, //"credit_limit",
        TYPE_DATE, //"reg_date", 
        TYPE_STRING, //"npwp", 
        TYPE_LONG, //"propinsi_id",
        TYPE_LONG, //"kabupaten_id",
        TYPE_LONG, //"kecamatan_id",        
        
        TYPE_INT, //"is_pkp",
        TYPE_STRING, //"pkp_company",
        TYPE_STRING, //"pkp_address",
        TYPE_STRING, //"pkp_nppkp",
        TYPE_INT, //"sch_senin",
        TYPE_INT, //"sch_selasa",
        TYPE_INT, //"sch_rabu",
        TYPE_INT, //"sch_kamis",
        TYPE_INT, //"sch_jumat",
        TYPE_INT, //"sch_sabtu",     
        
        TYPE_INT, //"sch_minggu",
        TYPE_INT, //""ignore_loc_credit_limit",
        TYPE_INT, //""due_date",
        TYPE_INT, //""max_pending_order"
        TYPE_INT, //"def_due_date_day"
        TYPE_INT        
    };
    
    // type customer
    public static final int CUSTOMER_TYPE_REGULAR     = 0;
    public static final int CUSTOMER_TYPE_COMMON_AREA = 1;
    public static final int CUSTOMER_TYPE_COMPANY     = 2;
    
    public static final String[] customerType = {"Regular", "Common Area","Company / CV."};
    
    public static final String[] customerGroup = {"Regular", "Company / CV.","Non Reguler"};
    
    public static final int[] postValue = {0, 1};
    
    // status customer
    public static final int POSTED_STATUS_ACTIVE = 0;
    public static final int POSTED_STATUS_UNACTIVE = 1;
    public static final String[] statusKey = {"Active", "InActive"};
    
    public static final int[] statusValue = {0, 1};
    //limbah/irigasi flag
    public static final int FLAG_ACTIVE = 1;
    public static final int FLAG_NONACTIVE = 0;
    
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
   
    
    public static String[] customerSalutation = {
        "",        
        "PT.",
        "CV.",
        "UD."
    };
    
    
    public DbCustomer() {
    }

    public DbCustomer(int i) throws CONException {
        super(new DbCustomer());
    }

    public DbCustomer(String sOid) throws CONException {
        super(new DbCustomer(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCustomer(long lOid) throws CONException {
        super(new DbCustomer(0));
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
        return DB_CUSTOMER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCustomer().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Customer customer = fetchExc(ent.getOID());
        ent = (Entity) customer;
        return customer.getOID();
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

    public static Customer fetchExc(long oid) throws CONException {
        try {
            Customer customer = new Customer();
            DbCustomer dbCustomer = new DbCustomer(oid);

            customer.setOID(oid);
            customer.setName(dbCustomer.getString(COL_NAME));
            customer.setType(dbCustomer.getInt(COL_TYPE));
            customer.setAddress1(dbCustomer.getString(COL_ADDRESS_1));                        
            customer.setPostalCode(dbCustomer.getString(COL_POSTAL_CODE));            
            customer.setPhone(dbCustomer.getString(COL_PHONE));            
            customer.setWebsite(dbCustomer.getString(COL_WEBSITE));
            customer.setEmail(dbCustomer.getString(COL_EMAIL));
            customer.setStatus(dbCustomer.getString(COL_STATUS));            
            customer.setIndukCustomerId(dbCustomer.getlong(COL_INDUK_CUSTOMER_ID));
            customer.setFax(dbCustomer.getString(COL_FAX));            
            customer.setIdNumber(dbCustomer.getString(COL_ID_NUMBER));
            customer.setDob(dbCustomer.getDate(COL_DOB));            
            customer.setSalutation(dbCustomer.getString(COL_SALUTATION));
            customer.setDobIgnore(dbCustomer.getInt(COL_DOB_IGNORE));
            customer.setCode(dbCustomer.getString(COL_CODE));            
            customer.setHp(dbCustomer.getString(COL_HP));                   
            customer.setGolPrice(dbCustomer.getString(COL_GOL_PRICE));
            customer.setPersonalDiscount(dbCustomer.getdouble(COL_PERSONAL_DISCOUNT));
            customer.setExpiredDate(dbCustomer.getDate(COL_EXPIRED_DATE));            
            customer.setAnimalName(dbCustomer.getString(COL_ANIMAL_NAME));
            customer.setCreditLimit(dbCustomer.getdouble(COL_CREDIT_LIMIT));
            customer.setRegDate(dbCustomer.getDate(COL_REG_DATE));
            customer.setNpwp(dbCustomer.getString(COL_NPWP));                        
            customer.setIsPkp(dbCustomer.getInt(COL_IS_PKP));
            customer.setPkpCompany(dbCustomer.getString(COL_PKP_COMPANY));
            customer.setPkpAddress(dbCustomer.getString(COL_PKP_ADDRESS));
            customer.setPkpNppkp(dbCustomer.getString(COL_PKP_NPPKP));
            customer.setSchSenin(dbCustomer.getInt(COL_SCH_SENIN));
            customer.setSchSelasa(dbCustomer.getInt(COL_SCH_SELASA));
            customer.setSchRabu(dbCustomer.getInt(COL_SCH_RABU));
            customer.setSchKamis(dbCustomer.getInt(COL_SCH_KAMIS));
            customer.setSchJumat(dbCustomer.getInt(COL_SCH_JUMAT));
            customer.setSchSabtu(dbCustomer.getInt(COL_SCH_SABTU));
            customer.setSchMinggu(dbCustomer.getInt(COL_SCH_MINGGU));
            customer.setIgnoreLocCreditLimit(dbCustomer.getInt(COL_IGNORE_LOC_CREDIT_LIMIT));
            customer.setDueDate(dbCustomer.getInt(COL_DUE_DATE));
            customer.setMaxPendingOrder(dbCustomer.getInt(COL_MAX_PENDING_ORDER));
            customer.setDefDueDateDay(dbCustomer.getInt(COL_DEF_DUE_DATE_DAY));
            customer.setKecamatanId(dbCustomer.getlong(COL_KECAMATAN_ID));        
            customer.setIdType(dbCustomer.getString(COL_ID_TYPE));        
            customer.setJatuhTempo(dbCustomer.getInt(COL_JATUH_TEMPO));   
            
            return customer;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            System.out.println("[Exception] on fetch Customer : " + e.toString());
            throw new CONException(new DbCountry(0), CONException.UNKNOWN);
        }
    }

    public static long insert(Customer customer) throws CONException {
        try {
            DbCustomer dbCustomer = new DbCustomer(0);
            
            dbCustomer.setString(COL_NAME, customer.getName());
            dbCustomer.setInt(COL_TYPE, customer.getType());
            dbCustomer.setString(COL_ADDRESS_1, customer.getAddress1());            
            dbCustomer.setString(COL_POSTAL_CODE, customer.getPostalCode());
            dbCustomer.setString(COL_PHONE, customer.getPhone());
            dbCustomer.setString(COL_WEBSITE, customer.getWebsite());
            dbCustomer.setString(COL_EMAIL, customer.getEmail());
            dbCustomer.setString(COL_STATUS, customer.getStatus());
            dbCustomer.setLong(COL_INDUK_CUSTOMER_ID, customer.getIndukCustomerId());
            dbCustomer.setString(COL_FAX, customer.getFax());
            dbCustomer.setString(COL_ID_NUMBER, customer.getIdNumber());
            dbCustomer.setDate(COL_DOB, customer.getDob());
            dbCustomer.setString(COL_SALUTATION, customer.getSalutation());
            dbCustomer.setInt(COL_DOB_IGNORE, customer.getDobIgnore());
            dbCustomer.setString(COL_CODE, customer.getCode());
            dbCustomer.setString(COL_HP, customer.getHp());
            dbCustomer.setString(COL_GOL_PRICE, customer.getGolPrice());
            dbCustomer.setDouble(COL_PERSONAL_DISCOUNT, customer.getPersonalDiscount());
            dbCustomer.setDate(COL_EXPIRED_DATE, customer.getExpiredDate());
            dbCustomer.setString(COL_ANIMAL_NAME, customer.getAnimalName());
            dbCustomer.setDouble(COL_CREDIT_LIMIT, customer.getCreditLimit());
            dbCustomer.setDate(COL_REG_DATE, customer.getRegDate());
            dbCustomer.setString(COL_NPWP, customer.getNpwp());
            dbCustomer.setInt(COL_IS_PKP, customer.getIsPkp());
            dbCustomer.setString(COL_PKP_COMPANY, customer.getPkpCompany());
            dbCustomer.setString(COL_PKP_ADDRESS, customer.getPkpAddress());
            dbCustomer.setString(COL_PKP_NPPKP, customer.getPkpNppkp());
            dbCustomer.setInt(COL_SCH_SENIN, customer.getSchSenin());
            dbCustomer.setInt(COL_SCH_SELASA, customer.getSchSelasa());
            dbCustomer.setInt(COL_SCH_RABU, customer.getSchRabu());
            dbCustomer.setInt(COL_SCH_KAMIS, customer.getSchKamis());
            dbCustomer.setInt(COL_SCH_JUMAT, customer.getSchJumat());
            dbCustomer.setInt(COL_SCH_SABTU, customer.getSchSabtu());
            dbCustomer.setInt(COL_SCH_MINGGU, customer.getSchMinggu());
            dbCustomer.setInt(COL_IGNORE_LOC_CREDIT_LIMIT, customer.getIgnoreLocCreditLimit());
            dbCustomer.setInt(COL_DUE_DATE, customer.getDueDate());
            dbCustomer.setInt(COL_MAX_PENDING_ORDER, customer.getMaxPendingOrder()); 
            dbCustomer.setInt(COL_DEF_DUE_DATE_DAY, customer.getDefDueDateDay()); 
            dbCustomer.setLong(COL_KECAMATAN_ID, customer.getKecamatanId()); 
            dbCustomer.setString(COL_ID_TYPE, customer.getIdType());             
            dbCustomer.setInt(COL_JATUH_TEMPO, customer.getJatuhTempo());      
            
            dbCustomer.insert();
            customer.setOID(dbCustomer.getlong(COL_CUSTOMER_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCountry(0), CONException.UNKNOWN);
        }
        return customer.getOID();
    }

    public static long update(Customer customer) throws CONException {
        try {
            if (customer.getOID() != 0) {

                DbCustomer dbCustomer = new DbCustomer(customer.getOID());

                dbCustomer.setString(COL_NAME, customer.getName());
                dbCustomer.setInt(COL_TYPE, customer.getType());
                dbCustomer.setString(COL_ADDRESS_1, customer.getAddress1());            
                dbCustomer.setString(COL_POSTAL_CODE, customer.getPostalCode());
                dbCustomer.setString(COL_PHONE, customer.getPhone());
                dbCustomer.setString(COL_WEBSITE, customer.getWebsite());
                dbCustomer.setString(COL_EMAIL, customer.getEmail());
                dbCustomer.setString(COL_STATUS, customer.getStatus());
                dbCustomer.setLong(COL_INDUK_CUSTOMER_ID, customer.getIndukCustomerId());
                dbCustomer.setString(COL_FAX, customer.getFax());
                dbCustomer.setString(COL_ID_NUMBER, customer.getIdNumber());
                dbCustomer.setDate(COL_DOB, customer.getDob());
                dbCustomer.setString(COL_SALUTATION, customer.getSalutation());
                dbCustomer.setInt(COL_DOB_IGNORE, customer.getDobIgnore());
                dbCustomer.setString(COL_CODE, customer.getCode());
                dbCustomer.setString(COL_HP, customer.getHp());
                dbCustomer.setString(COL_GOL_PRICE, customer.getGolPrice());
                dbCustomer.setDouble(COL_PERSONAL_DISCOUNT, customer.getPersonalDiscount());
                dbCustomer.setDate(COL_EXPIRED_DATE, customer.getExpiredDate());
                dbCustomer.setString(COL_ANIMAL_NAME, customer.getAnimalName());
                dbCustomer.setDouble(COL_CREDIT_LIMIT, customer.getCreditLimit());
                dbCustomer.setDate(COL_REG_DATE, customer.getRegDate());
                dbCustomer.setString(COL_NPWP, customer.getNpwp());
                dbCustomer.setInt(COL_IS_PKP, customer.getIsPkp());
                dbCustomer.setString(COL_PKP_COMPANY, customer.getPkpCompany());
                dbCustomer.setString(COL_PKP_ADDRESS, customer.getPkpAddress());
                dbCustomer.setString(COL_PKP_NPPKP, customer.getPkpNppkp());
                dbCustomer.setInt(COL_SCH_SENIN, customer.getSchSenin());
                dbCustomer.setInt(COL_SCH_SELASA, customer.getSchSelasa());
                dbCustomer.setInt(COL_SCH_RABU, customer.getSchRabu());
                dbCustomer.setInt(COL_SCH_KAMIS, customer.getSchKamis());
                dbCustomer.setInt(COL_SCH_JUMAT, customer.getSchJumat());
                dbCustomer.setInt(COL_SCH_SABTU, customer.getSchSabtu());
                dbCustomer.setInt(COL_SCH_MINGGU, customer.getSchMinggu());
                dbCustomer.setInt(COL_IGNORE_LOC_CREDIT_LIMIT, customer.getIgnoreLocCreditLimit());
                dbCustomer.setInt(COL_DUE_DATE, customer.getDueDate());
                dbCustomer.setInt(COL_MAX_PENDING_ORDER, customer.getMaxPendingOrder()); 
                dbCustomer.setInt(COL_DEF_DUE_DATE_DAY, customer.getDefDueDateDay()); 
                dbCustomer.setLong(COL_KECAMATAN_ID, customer.getKecamatanId()); 
                dbCustomer.setString(COL_ID_TYPE, customer.getIdType()); 
                dbCustomer.setInt(COL_JATUH_TEMPO, customer.getJatuhTempo());   
                
                dbCustomer.update();
                return customer.getOID();

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
            DbCustomer customer = new DbCustomer(oid);
            customer.delete();
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

            String sql = "SELECT * FROM " + DB_CUSTOMER;

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
                Customer customer = new Customer();
                resultToObject(rs, customer);
                lists.add(customer);
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

    private static void resultToObject(ResultSet rs, Customer customer) {
        try {

            customer.setOID(rs.getLong(DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]));
            customer.setName(rs.getString(DbCustomer.colNames[DbCustomer.COL_NAME]));
            customer.setType(rs.getInt(DbCustomer.colNames[DbCustomer.COL_TYPE]));
            customer.setAddress1(rs.getString(DbCustomer.colNames[DbCustomer.COL_ADDRESS_1]));
            customer.setPostalCode(rs.getString(DbCustomer.colNames[DbCustomer.COL_POSTAL_CODE]));
            customer.setPhone(rs.getString(DbCustomer.colNames[DbCustomer.COL_PHONE]));
            customer.setWebsite(rs.getString(DbCustomer.colNames[DbCustomer.COL_WEBSITE]));
            customer.setEmail(rs.getString(DbCustomer.colNames[DbCustomer.COL_EMAIL]));
            customer.setStatus(rs.getString(DbCustomer.colNames[DbCustomer.COL_STATUS]));
            customer.setIndukCustomerId(rs.getLong(DbCustomer.colNames[DbCustomer.COL_INDUK_CUSTOMER_ID]));
            customer.setFax(rs.getString(DbCustomer.colNames[DbCustomer.COL_FAX]));                                 
            customer.setIdNumber(rs.getString(DbCustomer.colNames[DbCustomer.COL_ID_NUMBER]));
            customer.setDob(rs.getDate(DbCustomer.colNames[DbCustomer.COL_DOB]));
            customer.setSalutation(rs.getString(DbCustomer.colNames[DbCustomer.COL_SALUTATION]));
            customer.setDobIgnore(rs.getInt(DbCustomer.colNames[DbCustomer.COL_DOB_IGNORE]));
            customer.setCode(rs.getString(DbCustomer.colNames[DbCustomer.COL_CODE]));
            customer.setHp(rs.getString(DbCustomer.colNames[DbCustomer.COL_HP]));
            customer.setGolPrice(rs.getString(DbCustomer.colNames[DbCustomer.COL_GOL_PRICE]));
            customer.setPersonalDiscount(rs.getDouble(DbCustomer.colNames[DbCustomer.COL_PERSONAL_DISCOUNT]));
            customer.setExpiredDate(rs.getDate(DbCustomer.colNames[DbCustomer.COL_EXPIRED_DATE]));
            customer.setAnimalName(rs.getString(DbCustomer.colNames[DbCustomer.COL_ANIMAL_NAME]));
            customer.setCreditLimit(rs.getDouble(DbCustomer.colNames[DbCustomer.COL_CREDIT_LIMIT]));
            customer.setRegDate(rs.getDate(DbCustomer.colNames[DbCustomer.COL_REG_DATE]));
            customer.setNpwp(rs.getString(DbCustomer.colNames[DbCustomer.COL_NPWP]));            
            customer.setIsPkp(rs.getInt(DbCustomer.colNames[DbCustomer.COL_IS_PKP]));
            customer.setPkpCompany(rs.getString(DbCustomer.colNames[DbCustomer.COL_PKP_COMPANY]));
            customer.setPkpAddress(rs.getString(DbCustomer.colNames[DbCustomer.COL_PKP_ADDRESS]));
            customer.setPkpNppkp(rs.getString(DbCustomer.colNames[DbCustomer.COL_PKP_NPPKP]));
            customer.setSchSenin(rs.getInt(DbCustomer.colNames[DbCustomer.COL_SCH_SENIN]));
            customer.setSchSelasa(rs.getInt(DbCustomer.colNames[DbCustomer.COL_SCH_SELASA]));
            customer.setSchRabu(rs.getInt(DbCustomer.colNames[DbCustomer.COL_SCH_RABU]));
            customer.setSchKamis(rs.getInt(DbCustomer.colNames[DbCustomer.COL_SCH_KAMIS]));
            customer.setSchJumat(rs.getInt(DbCustomer.colNames[DbCustomer.COL_SCH_JUMAT]));
            customer.setSchSabtu(rs.getInt(DbCustomer.colNames[DbCustomer.COL_SCH_SABTU]));
            customer.setSchMinggu(rs.getInt(DbCustomer.colNames[DbCustomer.COL_SCH_MINGGU]));
            customer.setIgnoreLocCreditLimit(rs.getInt(DbCustomer.colNames[DbCustomer.COL_IGNORE_LOC_CREDIT_LIMIT]));
            customer.setDueDate(rs.getInt(DbCustomer.colNames[DbCustomer.COL_DUE_DATE]));
            customer.setMaxPendingOrder(rs.getInt(DbCustomer.colNames[DbCustomer.COL_MAX_PENDING_ORDER]));            
            customer.setDefDueDateDay(rs.getInt(DbCustomer.colNames[DbCustomer.COL_DEF_DUE_DATE_DAY]));
            customer.setKecamatanId(rs.getLong(DbCustomer.colNames[DbCustomer.COL_KECAMATAN_ID]));
            customer.setIdType(rs.getString(DbCustomer.colNames[DbCustomer.COL_ID_TYPE]));
            customer.setJatuhTempo(rs.getInt(DbCustomer.colNames[DbCustomer.COL_JATUH_TEMPO]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long countyId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CUSTOMER + " WHERE " +
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
            String sql = "SELECT COUNT(" + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + ") FROM " + DB_CUSTOMER;
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
    public static long getOidByMemberCode(String code){
        CONResultSet dbrs = null;
        long oidMember =0;
        try {
            String sql = "SELECT CUSTOMER_ID FROM " + DB_CUSTOMER + " WHERE CODE ='" + code + "'" ;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
              oidMember =rs.getLong(DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]);
            }

            rs.close();
            return oidMember;
        } catch (Exception e) {
            return oidMember;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static boolean checkNama(long customerOID, String name) {
        CONResultSet dbrs = null;
        boolean bool = false;
        try {
            String sql = "SELECT NAME FROM " + DB_CUSTOMER + " WHERE NAME ='" + name + "' and customer_id!=" + customerOID;
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
    public static boolean checkNama(long customerOID, String name, String code){
        CONResultSet dbrs = null;
        boolean bool = false;
        try {
            String sql = "SELECT NAME FROM " + DB_CUSTOMER + " WHERE NAME ='" + name + "' and customer_id!=" + customerOID + " and code='" + code+ "'";
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

    public static String getNamaCustomer(long customerId) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT " + DbCustomer.colNames[DbCustomer.COL_NAME] + " FROM " + DbCustomer.DB_CUSTOMER + " WHERE " +
                    DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + customerId;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                return rs.getString(DbCustomer.colNames[DbCustomer.COL_NAME]);
            }

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return "";
    }
    
    
    public static String getPrefix(Date regDate){        
        String month = ""+regDate.getMonth();
        if(month.length()==1){
            month="0"+month;
        }
        String year = ""+(regDate.getYear()+1900);
        return (year+""+month);
        
    }
    
    public static String getNumber(String prefix,int ctr){
        
        String strCtr = ""+ctr;
        String tempNumber = "";        
        if(strCtr.length() < 5){                
            int kekurangan = 5 - strCtr.length();
            tempNumber = ""+ctr;
            for(int ic = 0 ; ic < kekurangan ; ic ++){
                tempNumber = "0"+tempNumber;
            }                        
        }else{
            tempNumber = ""+ctr;
        }
        
        return (prefix +"-"+tempNumber);        
    }
    
    public static int getNextCounter(String code){       
        
        int result = 0;
        CONResultSet dbrs = null;
        
        try {

            String sql = "SELECT MAX(" + DbSystemDocNumber.colNames[DbSystemDocNumber.COL_COUNTER] + ") FROM " + DbSystemDocNumber.DB_SYSTEM_DOC_NUMBER + " WHERE " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_PREFIX_NUMBER] + " = '" + code + "' AND " +
                        DbSystemDocNumber.colNames[DbSystemDocNumber.COL_TYPE] + " = '" + DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_CUSTOMER] + "'";            

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
    
    
    public static Hashtable getTotal(String whereClause, String order) {

        Hashtable lists = new Hashtable();
        CONResultSet dbrs = null;
        try {

            String sql = "SELECT "+DbCustomer.colNames[DbCustomer.COL_REG_DATE]+",count("+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+") as tot FROM " + DB_CUSTOMER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            
            sql = sql +" group by year("+DbCustomer.colNames[DbCustomer.COL_REG_DATE]+"),month("+DbCustomer.colNames[DbCustomer.COL_REG_DATE]+") ";
            
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            
            dbrs = CONHandler.execQueryResult(sql);            
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {                
                Date regDate = rs.getDate(DbCustomer.colNames[DbCustomer.COL_REG_DATE]);
                String str = JSPFormater.formatDate(regDate,"MM-yyyy");
                int total = rs.getInt("tot");
                lists.put(str,String.valueOf(total));
            }
            rs.close();

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return lists;
    }
    
}

