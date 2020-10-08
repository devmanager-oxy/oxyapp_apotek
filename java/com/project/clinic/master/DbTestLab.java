
package com.project.clinic.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*; 

public class DbTestLab extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_TEST_LAB = "CL_TEST_LAB";

	public static final  int COL_TEST_LAB_ID = 0;
	public static final  int COL_TEST_NAME = 1;

	public static final  String[] colNames = {
		"TEST_LAB_ID",
		"TEST_NAME"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbTestLab(){
	}

	public DbTestLab(int i) throws CONException { 
		super(new DbTestLab()); 
	}

	public DbTestLab(String sOid) throws CONException { 
		super(new DbTestLab(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbTestLab(long lOid) throws CONException { 
		super(new DbTestLab(0)); 
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
		return DB_CL_TEST_LAB;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbTestLab().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		TestLab testlab = fetchExc(ent.getOID()); 
		ent = (Entity)testlab; 
		return testlab.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((TestLab) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((TestLab) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static TestLab fetchExc(long oid) throws CONException{ 
		try{ 
			TestLab testlab = new TestLab();
			DbTestLab pstTestLab = new DbTestLab(oid); 
			testlab.setOID(oid);

			testlab.setTestName(pstTestLab.getString(COL_TEST_NAME));

			return testlab; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTestLab(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(TestLab testlab) throws CONException{ 
		try{ 
			DbTestLab pstTestLab = new DbTestLab(0);

			pstTestLab.setString(COL_TEST_NAME, testlab.getTestName());

			pstTestLab.insert(); 
			testlab.setOID(pstTestLab.getlong(COL_TEST_LAB_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTestLab(0),CONException.UNKNOWN); 
		}
		return testlab.getOID();
	}

	public static long updateExc(TestLab testlab) throws CONException{ 
		try{ 
			if(testlab.getOID() != 0){ 
				DbTestLab pstTestLab = new DbTestLab(testlab.getOID());

				pstTestLab.setString(COL_TEST_NAME, testlab.getTestName());

				pstTestLab.update(); 
				return testlab.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTestLab(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbTestLab pstTestLab = new DbTestLab(oid);
			pstTestLab.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTestLab(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_TEST_LAB; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				TestLab testlab = new TestLab();
				resultToObject(rs, testlab);
				lists.add(testlab);
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

	private static void resultToObject(ResultSet rs, TestLab testlab){
		try{
			testlab.setOID(rs.getLong(DbTestLab.colNames[DbTestLab.COL_TEST_LAB_ID]));
			testlab.setTestName(rs.getString(DbTestLab.colNames[DbTestLab.COL_TEST_NAME]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long testLabId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_TEST_LAB + " WHERE " + 
						DbTestLab.colNames[DbTestLab.COL_TEST_LAB_ID] + " = " + testLabId;

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
			String sql = "SELECT COUNT("+ DbTestLab.colNames[DbTestLab.COL_TEST_LAB_ID] + ") FROM " + DB_CL_TEST_LAB;
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
			  	   TestLab testlab = (TestLab)list.get(ls);
				   if(oid == testlab.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
