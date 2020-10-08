
package com.project.general; 

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;

public class DbVendor extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_VENDOR = "vendor";

	public static final  int COL_NAME = 0;
	public static final  int COL_VENDOR_ID = 1;
	public static final  int COL_CODE = 2;
	public static final  int COL_ADDRESS = 3;
	public static final  int COL_CITY = 4;
	public static final  int COL_STATE = 5;
	public static final  int COL_PHONE = 6;
	public static final  int COL_HP = 7;
	public static final  int COL_FAX = 8;
	public static final  int COL_DUE_DATE = 9;
	public static final  int COL_CONTACT = 10;
	public static final  int COL_COUNTRY_NAME = 11;
	public static final  int COL_COUNTRY_ID = 12;
	public static final  int COL_TYPE = 13;        
        public static final  int COL_DISCOUNT = 14;
        public static final  int COL_EMAIL = 15;
        public static final  int COL_NPWP = 16;
        public static final  int COL_VENDOR_TYPE = 17;
        public static final  int COL_PREV_LIABILITY = 18;
        public static final  int COL_WEB_PAGE = 19;
        public static final int COL_DIRECT_RECEIVE=20;
        public static final int COL_IS_KONSINYASI=21;
        public static final int COL_IS_PKP=22;
        public static final int COL_INCLUDE_PPN=23;        
        public static final int COL_KOMISI_PERCENT=24;        
        
        public static final int COL_PERCENT_MARGIN=25;
        public static final int COL_PERCENT_PROMOSI=26;
        public static final int COL_PERCENT_BARCODE=27;
        public static final int COL_SYSTEM = 28;
        
        public static final int COL_KOMISI_MARGIN=29;
        public static final int COL_KOMISI_PROMOSI=30;
        public static final int COL_KOMISI_BARCODE=31;
        public static final int COL_IS_KOMISI = 32;
        
        public static final int COL_ODR_SENIN = 33;
        public static final int COL_ODR_SELASA = 34;
        public static final int COL_ODR_RABU = 35;
        public static final int COL_ODR_KAMIS = 36;
        public static final int COL_ODR_JUMAT = 37;
        public static final int COL_ODR_SABTU = 38;
        public static final int COL_ODR_MINGGU = 39;
        public static final int COL_PENDING_ONE_PO = 40;
        public static final int COL_TYPE_LOC_INCOMING = 41;
        
        public static final int COL_NO_REK = 42;
        public static final int COL_BANK_ID = 43;        
        public static final int COL_PAYMENT_TYPE = 44;
        public static final int COL_PIC = 45;
        public static final int COL_LIABILITIES_TYPE = 46;
        
	public static final  String[] colNames = {
		"name",
		"vendor_id",
		"code",
		"address",
		"city",
		"state",
		"phone",
		"hp",
		"fax",
		"due_date",
		"cperson",
		"country_name",
		"country_id",
		"type",                
                "disc",
                "email",
                "npwp",
                "vendor_type",
                "prev_liability",
                "wpage",
                "direct_receive",
                "is_konsinyasi",
                "is_pkp",
                "include_ppn",
                "komisi_percent",
                
                "percent_margin",
                "percent_promosi",
                "percent_barcode",
                "system",
                        
                "komisi_margin",
                "komisi_promosi",
                "komisi_barcode",
                "is_komisi",
                "odr_senin",
                "odr_selasa",
                "odr_rabu",
                "odr_kamis",
                "odr_jumat",
                "odr_sabtu",
                "odr_minggu",
                "pending_one_po",
                "type_loc_incoming",
                "no_rek",
                "bank_id",
                "payment_type",
                "pic",
                "liabilities_type"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_STRING,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_INT,                
                TYPE_FLOAT,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_FLOAT,
                TYPE_STRING,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_FLOAT,                
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_INT,
                TYPE_STRING,
                TYPE_INT,
	 };          
         
         public static int VENDOR_TYPE_SUPPLIER = 0;
         public static int VENDOR_TYPE_PENITIP  = 1;
         public static int VENDOR_TYPE_BYMHD    = 2;
         public static int VENDOR_TYPE_DP       = 3;         
         public static int VENDOR_TYPE_GA       = 4;     
         
         public static final String[] vendorType = {"Supplier", "Penitip","BYMHD","DP","GA"};
         
         public static final int TYPE_SYSTEM_HJ = 1; // konsinyasi harga jual
         public static final int TYPE_SYSTEM_HB = 2; //konsinyasi harga beli
         
         public static final int TYPE_NO_PENDING_PO = 0;
         public static final int TYPE_ONE_PENDING_PO = 1;
         
         
         // Konstanta payment //
         public static int PAYMENT_TYPE_BG          = 0;
         public static int PAYMENT_TYPE_TRANSFER    = 1;
         public static int PAYMENT_TYPE_CASH        = 2;         
         
         public static final String[] valuePayment = {"0","1","2"};
         public static final String[] keyPayment = {"BG", "Transfer","Cash"};
         
         
         public static int LIABILITIES_TYPE_RETAIL      = 0;
         public static int LIABILITIES_TYPE_GROSIR      = 1;
         
         public static final int[] liabilitiesTypeValue = {0,1};
         public static final String[] liabilitiesTypeKey = {"Retail", "Grosir"};

	public DbVendor(){
	}

	public DbVendor(int i) throws CONException { 
		super(new DbVendor()); 
	}

	public DbVendor(String sOid) throws CONException { 
		super(new DbVendor(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbVendor(long lOid) throws CONException { 
		super(new DbVendor(0)); 
		String sOid = "0"; 
		try { 
			sOid = String.valueOf(lOid); 
		}catch(Exception e) { 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	} 

	public int getFieldSize(){ 
		return colNames.length; 
	}

	public String getTableName(){ 
		return DB_VENDOR;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbVendor().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Vendor vendor = fetchExc(ent.getOID()); 
		ent = (Entity)vendor; 
		return vendor.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Vendor) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Vendor) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Vendor fetchExc(long oid) throws CONException{ 
		try{ 
			Vendor vendor = new Vendor();
			DbVendor dbVendor = new DbVendor(oid); 
			vendor.setOID(oid);

			vendor.setName(dbVendor.getString(COL_NAME));
			vendor.setCode(dbVendor.getString(COL_CODE));
			vendor.setAddress(dbVendor.getString(COL_ADDRESS));
			vendor.setCity(dbVendor.getString(COL_CITY));
			vendor.setState(dbVendor.getString(COL_STATE));
			vendor.setPhone(dbVendor.getString(COL_PHONE));
			vendor.setHp(dbVendor.getString(COL_HP));
			vendor.setFax(dbVendor.getString(COL_FAX));
			vendor.setDueDate(dbVendor.getInt(COL_DUE_DATE));
			vendor.setContact(dbVendor.getString(COL_CONTACT));
			vendor.setCountryName(dbVendor.getString(COL_COUNTRY_NAME));
			vendor.setCountryId(dbVendor.getlong(COL_COUNTRY_ID));
			vendor.setType(dbVendor.getInt(COL_TYPE));
                        
                        vendor.setDiscount(dbVendor.getdouble(COL_DISCOUNT));
                        vendor.setEmail(dbVendor.getString(COL_EMAIL));
                        vendor.setNpwp(dbVendor.getString(COL_NPWP));
                        vendor.setVendorType(dbVendor.getString(COL_VENDOR_TYPE));
                        vendor.setPrevLiability(dbVendor.getdouble(COL_PREV_LIABILITY));
                        vendor.setWebPage(dbVendor.getString(COL_WEB_PAGE));
                        vendor.setDirectReceive(dbVendor.getInt(COL_DIRECT_RECEIVE));
                        vendor.setIsKonsinyasi(dbVendor.getInt(COL_IS_KONSINYASI));
                        vendor.setIsPKP(dbVendor.getInt(COL_IS_PKP));
                        vendor.setIncludePPN(dbVendor.getInt(COL_INCLUDE_PPN));
                        vendor.setKomisiPercent(dbVendor.getInt(COL_KOMISI_PERCENT));
                        
                        vendor.setPercentMargin(dbVendor.getdouble(COL_PERCENT_MARGIN));
                        vendor.setPercentPromosi(dbVendor.getdouble(COL_PERCENT_PROMOSI));
                        vendor.setPercentBarcode(dbVendor.getdouble(COL_PERCENT_BARCODE));
                        vendor.setSystem(dbVendor.getInt(COL_SYSTEM));
                        
                        vendor.setKomisiMargin(dbVendor.getdouble(COL_KOMISI_MARGIN));
                        vendor.setKomisiPromosi(dbVendor.getdouble(COL_KOMISI_PROMOSI));
                        vendor.setKomisiBarcode(dbVendor.getdouble(COL_KOMISI_BARCODE));
                        vendor.setIsKomisi(dbVendor.getInt(COL_IS_KOMISI));
                        
                        vendor.setOdrSenin(dbVendor.getInt(COL_ODR_SENIN));
                        vendor.setOdrSelasa(dbVendor.getInt(COL_ODR_SELASA));
                        vendor.setOdrRabu(dbVendor.getInt(COL_ODR_RABU));
                        vendor.setOdrKamis(dbVendor.getInt(COL_ODR_KAMIS));
                        vendor.setOdrJumat(dbVendor.getInt(COL_ODR_JUMAT));
                        vendor.setOdrSabtu(dbVendor.getInt(COL_ODR_SABTU));
                        vendor.setOdrMinggu(dbVendor.getInt(COL_ODR_MINGGU));
                        vendor.setPendingOnePo(dbVendor.getInt(COL_PENDING_ONE_PO));
                        vendor.setTypeLocIncoming(dbVendor.getString(COL_TYPE_LOC_INCOMING));
                        
                        vendor.setNoRek(dbVendor.getString(COL_NO_REK));
                        vendor.setBankId(dbVendor.getlong(COL_BANK_ID));
                        vendor.setPaymentType(dbVendor.getInt(COL_PAYMENT_TYPE));
                        vendor.setPic(dbVendor.getString(COL_PIC));
                        vendor.setLiabilitiesType(dbVendor.getInt(COL_LIABILITIES_TYPE));
                        
			return vendor; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbVendor(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Vendor vendor) throws CONException{ 
		try{ 
			DbVendor dbVendor = new DbVendor(0);

			dbVendor.setString(COL_NAME, vendor.getName());
			dbVendor.setString(COL_CODE, vendor.getCode());
			dbVendor.setString(COL_ADDRESS, vendor.getAddress());
			dbVendor.setString(COL_CITY, vendor.getCity());
			dbVendor.setString(COL_STATE, vendor.getState());
			dbVendor.setString(COL_PHONE, vendor.getPhone());
			dbVendor.setString(COL_HP, vendor.getHp());
			dbVendor.setString(COL_FAX, vendor.getFax());
			dbVendor.setInt(COL_DUE_DATE, vendor.getDueDate());
			dbVendor.setString(COL_CONTACT, vendor.getContact());
			dbVendor.setString(COL_COUNTRY_NAME, vendor.getCountryName());
			dbVendor.setLong(COL_COUNTRY_ID, vendor.getCountryId());
			dbVendor.setInt(COL_TYPE, vendor.getType());
                        
                        dbVendor.setDouble(COL_DISCOUNT, vendor.getDiscount());
                        dbVendor.setString(COL_EMAIL ,vendor.getEmail());
                        dbVendor.setString(COL_NPWP, vendor.getNpwp());
                        dbVendor.setString(COL_VENDOR_TYPE, vendor.getVendorType());
                        dbVendor.setDouble(COL_PREV_LIABILITY, vendor.getPrevLiability());
                        dbVendor.setString(COL_WEB_PAGE, vendor.getWebPage());
                        dbVendor.setInt(COL_DIRECT_RECEIVE, vendor.getDirectReceive());
                        dbVendor.setInt(COL_IS_KONSINYASI, vendor.getIsKonsinyasi());
                        dbVendor.setInt(COL_IS_PKP, vendor.getIsPKP());
                        dbVendor.setInt(COL_INCLUDE_PPN, vendor.getIncludePPN());
                        dbVendor.setDouble(COL_KOMISI_PERCENT, vendor.getKomisiPercent());
                        
                        dbVendor.setDouble(COL_PERCENT_MARGIN, vendor.getPercentMargin());
                        dbVendor.setDouble(COL_PERCENT_PROMOSI, vendor.getPercentPromosi());
                        dbVendor.setDouble(COL_PERCENT_BARCODE, vendor.getPercentBarcode());
                        dbVendor.setInt(COL_SYSTEM, vendor.getSystem());
                        
                        dbVendor.setDouble(COL_KOMISI_MARGIN, vendor.getKomisiMargin());
                        dbVendor.setDouble(COL_KOMISI_PROMOSI, vendor.getKomisiPromosi());
                        dbVendor.setDouble(COL_KOMISI_BARCODE, vendor.getKomisiBarcode());
                        dbVendor.setInt(COL_IS_KOMISI, vendor.getIsKomisi());
                        
                        dbVendor.setInt(COL_ODR_SENIN, vendor.getOdrSenin());
                        dbVendor.setInt(COL_ODR_SELASA, vendor.getOdrSelasa());
                        dbVendor.setInt(COL_ODR_RABU, vendor.getOdrRabu());
                        dbVendor.setInt(COL_ODR_KAMIS, vendor.getOdrKamis());
                        dbVendor.setInt(COL_ODR_JUMAT, vendor.getOdrJumat());
                        dbVendor.setInt(COL_ODR_SABTU, vendor.getOdrSabtu());
                        dbVendor.setInt(COL_ODR_MINGGU, vendor.getOdrMinggu());
                        dbVendor.setInt(COL_PENDING_ONE_PO, vendor.getPendingOnePo());
                        dbVendor.setString(COL_TYPE_LOC_INCOMING, vendor.getTypeLocIncoming());
                        dbVendor.setString(COL_NO_REK, vendor.getNoRek());
                        dbVendor.setLong(COL_BANK_ID, vendor.getBankId());
                        dbVendor.setInt(COL_PAYMENT_TYPE, vendor.getPaymentType());
                        dbVendor.setString(COL_PIC, vendor.getPic());
                        dbVendor.setInt(COL_LIABILITIES_TYPE, vendor.getLiabilitiesType());                        
                        
			dbVendor.insert(); 
			vendor.setOID(dbVendor.getlong(COL_VENDOR_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbVendor(0),CONException.UNKNOWN); 
		}
		return vendor.getOID();
	}

	public static long updateExc(Vendor vendor) throws CONException{ 
		try{ 
			if(vendor.getOID() != 0){ 
				DbVendor dbVendor = new DbVendor(vendor.getOID());

				dbVendor.setString(COL_NAME, vendor.getName());
				dbVendor.setString(COL_CODE, vendor.getCode());
				dbVendor.setString(COL_ADDRESS, vendor.getAddress());
				dbVendor.setString(COL_CITY, vendor.getCity());
				dbVendor.setString(COL_STATE, vendor.getState());
				dbVendor.setString(COL_PHONE, vendor.getPhone());
				dbVendor.setString(COL_HP, vendor.getHp());
				dbVendor.setString(COL_FAX, vendor.getFax());
				dbVendor.setInt(COL_DUE_DATE, vendor.getDueDate());
				dbVendor.setString(COL_CONTACT, vendor.getContact());
				dbVendor.setString(COL_COUNTRY_NAME, vendor.getCountryName());
				dbVendor.setLong(COL_COUNTRY_ID, vendor.getCountryId());
				dbVendor.setInt(COL_TYPE, vendor.getType());
                                
                                dbVendor.setDouble(COL_DISCOUNT, vendor.getDiscount());
                                dbVendor.setString(COL_EMAIL ,vendor.getEmail());
                                dbVendor.setString(COL_NPWP, vendor.getNpwp());
                                dbVendor.setString(COL_VENDOR_TYPE, vendor.getVendorType());
                                dbVendor.setDouble(COL_PREV_LIABILITY, vendor.getPrevLiability());
                                dbVendor.setString(COL_WEB_PAGE, vendor.getWebPage());
                                dbVendor.setInt(COL_DIRECT_RECEIVE, vendor.getDirectReceive());
                                dbVendor.setInt(COL_IS_KONSINYASI, vendor.getIsKonsinyasi());
                                dbVendor.setInt(COL_IS_PKP, vendor.getIsPKP());
                                dbVendor.setInt(COL_INCLUDE_PPN, vendor.getIncludePPN());
                                dbVendor.setDouble(COL_KOMISI_PERCENT, vendor.getKomisiPercent());
                                
                                dbVendor.setDouble(COL_PERCENT_MARGIN, vendor.getPercentMargin());
                                dbVendor.setDouble(COL_PERCENT_PROMOSI, vendor.getPercentPromosi());
                                dbVendor.setDouble(COL_PERCENT_BARCODE, vendor.getPercentBarcode());
                                dbVendor.setInt(COL_SYSTEM, vendor.getSystem());
                                
                                dbVendor.setDouble(COL_KOMISI_MARGIN, vendor.getKomisiMargin());
                                dbVendor.setDouble(COL_KOMISI_PROMOSI, vendor.getKomisiPromosi());
                                dbVendor.setDouble(COL_KOMISI_BARCODE, vendor.getKomisiBarcode());
                                dbVendor.setInt(COL_IS_KOMISI, vendor.getIsKomisi());
                                
                                dbVendor.setInt(COL_ODR_SENIN, vendor.getOdrSenin());
                                dbVendor.setInt(COL_ODR_SELASA, vendor.getOdrSelasa());
                                dbVendor.setInt(COL_ODR_RABU, vendor.getOdrRabu());
                                dbVendor.setInt(COL_ODR_KAMIS, vendor.getOdrKamis());
                                dbVendor.setInt(COL_ODR_JUMAT, vendor.getOdrJumat());
                                dbVendor.setInt(COL_ODR_SABTU, vendor.getOdrSabtu());
                                dbVendor.setInt(COL_ODR_MINGGU, vendor.getOdrMinggu());
                                dbVendor.setInt(COL_PENDING_ONE_PO, vendor.getPendingOnePo());
                                dbVendor.setString(COL_TYPE_LOC_INCOMING, vendor.getTypeLocIncoming());
                                dbVendor.setString(COL_NO_REK, vendor.getNoRek());
                                dbVendor.setLong(COL_BANK_ID, vendor.getBankId());
                                dbVendor.setInt(COL_PAYMENT_TYPE, vendor.getPaymentType());
                                dbVendor.setString(COL_PIC, vendor.getPic());
                                dbVendor.setInt(COL_LIABILITIES_TYPE, vendor.getLiabilitiesType());                        
                                
				dbVendor.update(); 
				return vendor.getOID();
			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbVendor(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbVendor dbVendor = new DbVendor(oid);
			dbVendor.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbVendor(0),CONException.UNKNOWN); 
		}
		return oid;
	}

	public static Vector listAll(){ 
		return list(0, 500, "",""); 
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_VENDOR; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			
                        switch (CONHandler.CONSVR_TYPE) {
                            case CONHandler.CONSVR_MYSQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                                break;

                            case CONHandler.CONSVR_POSTGRESQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;

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
			while(rs.next()) {
				Vendor vendor = new Vendor();
				resultToObject(rs, vendor);
				lists.add(vendor);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}

	public static void resultToObject(ResultSet rs, Vendor vendor){
		try{
			vendor.setOID(rs.getLong(DbVendor.colNames[DbVendor.COL_VENDOR_ID]));
			vendor.setName(rs.getString(DbVendor.colNames[DbVendor.COL_NAME]));
			vendor.setCode(rs.getString(DbVendor.colNames[DbVendor.COL_CODE]));
			vendor.setAddress(rs.getString(DbVendor.colNames[DbVendor.COL_ADDRESS]));
			vendor.setCity(rs.getString(DbVendor.colNames[DbVendor.COL_CITY]));
			vendor.setState(rs.getString(DbVendor.colNames[DbVendor.COL_STATE]));
			vendor.setPhone(rs.getString(DbVendor.colNames[DbVendor.COL_PHONE]));
			vendor.setHp(rs.getString(DbVendor.colNames[DbVendor.COL_HP]));
			vendor.setFax(rs.getString(DbVendor.colNames[DbVendor.COL_FAX]));
			vendor.setDueDate(rs.getInt(DbVendor.colNames[DbVendor.COL_DUE_DATE]));
			vendor.setContact(rs.getString(DbVendor.colNames[DbVendor.COL_CONTACT]));
			vendor.setCountryName(rs.getString(DbVendor.colNames[DbVendor.COL_COUNTRY_NAME]));
			vendor.setCountryId(rs.getLong(DbVendor.colNames[DbVendor.COL_COUNTRY_ID]));
			vendor.setType(rs.getInt(DbVendor.colNames[DbVendor.COL_TYPE]));
                        
                        vendor.setDiscount(rs.getDouble(DbVendor.colNames[DbVendor.COL_DISCOUNT]));
                        vendor.setEmail(rs.getString(DbVendor.colNames[DbVendor.COL_EMAIL]));
                        vendor.setNpwp(rs.getString(DbVendor.colNames[DbVendor.COL_NPWP]));
                        vendor.setVendorType(rs.getString(DbVendor.colNames[DbVendor.COL_VENDOR_TYPE]));
                        vendor.setPrevLiability(rs.getDouble(DbVendor.colNames[DbVendor.COL_PREV_LIABILITY]));
                        vendor.setWebPage(rs.getString(DbVendor.colNames[DbVendor.COL_WEB_PAGE]));
                        vendor.setDirectReceive(rs.getInt(DbVendor.colNames[DbVendor.COL_DIRECT_RECEIVE]));
                        vendor.setIsKonsinyasi(rs.getInt(DbVendor.colNames[DbVendor.COL_IS_KONSINYASI]));
                        vendor.setIsPKP(rs.getInt(DbVendor.colNames[DbVendor.COL_IS_PKP]));
                        vendor.setIncludePPN(rs.getInt(DbVendor.colNames[DbVendor.COL_INCLUDE_PPN]));
                        vendor.setKomisiPercent(rs.getDouble(DbVendor.colNames[DbVendor.COL_KOMISI_PERCENT]));
                        
                        vendor.setPercentMargin(rs.getDouble(DbVendor.colNames[DbVendor.COL_PERCENT_MARGIN]));
                        vendor.setPercentPromosi(rs.getDouble(DbVendor.colNames[DbVendor.COL_PERCENT_PROMOSI]));
                        vendor.setPercentBarcode(rs.getDouble(DbVendor.colNames[DbVendor.COL_PERCENT_BARCODE]));
                        vendor.setSystem(rs.getInt(DbVendor.colNames[DbVendor.COL_SYSTEM]));
                        
                        vendor.setKomisiMargin(rs.getDouble(DbVendor.colNames[DbVendor.COL_KOMISI_MARGIN]));
                        vendor.setKomisiPromosi(rs.getDouble(DbVendor.colNames[DbVendor.COL_KOMISI_PROMOSI]));
                        vendor.setKomisiBarcode(rs.getDouble(DbVendor.colNames[DbVendor.COL_KOMISI_BARCODE]));
                        vendor.setIsKomisi(rs.getInt(DbVendor.colNames[DbVendor.COL_IS_KOMISI]));
                        
                        vendor.setOdrSenin(rs.getInt(DbVendor.colNames[DbVendor.COL_ODR_SENIN]));
                        vendor.setOdrSelasa(rs.getInt(DbVendor.colNames[DbVendor.COL_ODR_SELASA]));
                        vendor.setOdrRabu(rs.getInt(DbVendor.colNames[DbVendor.COL_ODR_RABU]));
                        vendor.setOdrKamis(rs.getInt(DbVendor.colNames[DbVendor.COL_ODR_KAMIS]));
                        vendor.setOdrJumat(rs.getInt(DbVendor.colNames[DbVendor.COL_ODR_JUMAT]));
                        vendor.setOdrSabtu(rs.getInt(DbVendor.colNames[DbVendor.COL_ODR_SABTU]));
                        vendor.setOdrMinggu(rs.getInt(DbVendor.colNames[DbVendor.COL_ODR_MINGGU]));
                        vendor.setPendingOnePo(rs.getInt(DbVendor.colNames[DbVendor.COL_PENDING_ONE_PO]));
                        vendor.setTypeLocIncoming(rs.getString(DbVendor.colNames[DbVendor.COL_TYPE_LOC_INCOMING]));
                        vendor.setNoRek(rs.getString(DbVendor.colNames[DbVendor.COL_NO_REK]));
                        vendor.setBankId(rs.getLong(DbVendor.colNames[DbVendor.COL_BANK_ID]));
                        vendor.setPaymentType(rs.getInt(DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]));
                        vendor.setPic(rs.getString(DbVendor.colNames[DbVendor.COL_PIC]));
                        vendor.setLiabilitiesType(rs.getInt(DbVendor.colNames[DbVendor.COL_LIABILITIES_TYPE]));
		}catch(Exception e){ }
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbVendor.colNames[DbVendor.COL_VENDOR_ID] + ") FROM " + DB_VENDOR;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}


	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause){
		String order = "";
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, order); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   Vendor vendor = (Vendor)list.get(ls);
				   if(oid == vendor.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
