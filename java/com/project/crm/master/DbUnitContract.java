/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.master;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.system.*;
import com.project.util.*;
/**
 *
 * @author Tu Roy
 */
public class DbUnitContract extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_UNIT_CONTRACT = "crm_unit_contract";
    
    public static final int COL_UNIT_CONTRACT_ID    = 0;
    public static final int COL_NAMA                = 1;
    public static final int COL_KODE                = 2;
    public static final int COL_JML_BULAN           = 3;
    public static final int COL_STATUS              = 4;
    
    public static final String[] colNames = {
        "unit_contract_id",
        "nama",
        "kode",
        "jml_bulan",
        "status"
    };
    
    public static final  int   [] fieldTypes = {  
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT
    };
    
    public static final int STS_AKTIF      = 0;
    public static final int STS_TDK_AKTIF  = 1;
    
    public static final String[] stsValue = {"0", "1"};
    public static final String[] stsKey = {"A", "TA"};
    
    public DbUnitContract() {
    }

    public DbUnitContract(int i) throws CONException {
        super(new DbUnitContract());
    }

    public DbUnitContract(String sOid) throws CONException {

        super(new DbUnitContract(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbUnitContract(long lOid) throws CONException {
        super(new DbUnitContract(0));
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
        return DB_UNIT_CONTRACT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbUnitContract().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        UnitContract unitContract = fetchExc(ent.getOID());
        ent = (Entity) unitContract;
        return unitContract.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((UnitContract) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((UnitContract) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static UnitContract fetchExc(long oid) throws CONException {
        try {
            
            UnitContract unitContract = new UnitContract();
            DbUnitContract dbUnitContract = new DbUnitContract(oid);

            unitContract.setOID(oid);            
            unitContract.setName(dbUnitContract.getString(COL_NAMA));
            unitContract.setKode(dbUnitContract.getString(COL_KODE));            
            unitContract.setJmlBulan(dbUnitContract.getInt(COL_JML_BULAN));
            unitContract.setStatus(dbUnitContract.getInt(COL_STATUS));
            

            return unitContract;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(UnitContract unitContract) throws CONException {
        try {
            
            DbUnitContract dbUnitContract = new DbUnitContract(0);
            
            dbUnitContract.setString(COL_NAMA, unitContract.getName());
            dbUnitContract.setString(COL_KODE, unitContract.getKode());
            dbUnitContract.setInt(COL_JML_BULAN, unitContract.getJmlBulan());            
            dbUnitContract.setInt(COL_STATUS, unitContract.getStatus());

            dbUnitContract.insert();
            unitContract.setOID(dbUnitContract.getlong(COL_UNIT_CONTRACT_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
        }
        return unitContract.getOID();
    }

    public static long updateExc(UnitContract unitContract) throws CONException {
        try {
            if (unitContract.getOID() != 0) {
                DbUnitContract dbUnitContract = new DbUnitContract(unitContract.getOID());
                dbUnitContract.setString(COL_NAMA, unitContract.getName());                
                dbUnitContract.setString(COL_KODE, unitContract.getKode());
                dbUnitContract.setInt(COL_JML_BULAN, unitContract.getJmlBulan());
                dbUnitContract.setInt(COL_STATUS, unitContract.getStatus());

                dbUnitContract.update();

                return unitContract.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbUnitContract dbUnitContract = new DbUnitContract(oid);
            dbUnitContract.delete();

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
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
			String sql = "SELECT * FROM " + DB_UNIT_CONTRACT;
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
                                UnitContract unitContract = new UnitContract();				
				resultToObject(rs, unitContract);
				lists.add(unitContract);
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
        
        public static void resultToObject(ResultSet rs, UnitContract unitContract){
		try{
                        unitContract.setOID(rs.getLong(DbUnitContract.colNames[DbUnitContract.COL_UNIT_CONTRACT_ID]));
                        unitContract.setName(rs.getString(DbUnitContract.colNames[DbUnitContract.COL_NAMA]));
                        unitContract.setKode(rs.getString(DbUnitContract.colNames[DbUnitContract.COL_KODE]));
                        unitContract.setJmlBulan(rs.getInt(DbUnitContract.colNames[DbUnitContract.COL_JML_BULAN]));                        
                        unitContract.setStatus(rs.getInt(DbUnitContract.colNames[DbUnitContract.COL_STATUS]));

		}catch(Exception e){ }
	}
        
        public static boolean checkOID(long unitContractId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_UNIT_CONTRACT + " WHERE " +
						DbUnitContract.colNames[DbUnitContract.COL_UNIT_CONTRACT_ID] + " = " + unitContractId;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			CONResultSet.close(dbrs);
			return result; 
		}
	}


	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbUnitContract.colNames[DbUnitContract.COL_UNIT_CONTRACT_ID] + ") FROM " + DB_UNIT_CONTRACT;
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
			  	   UnitContract unitContract = (UnitContract)list.get(ls);
				   if(oid == unitContract.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
    
    
    
}
