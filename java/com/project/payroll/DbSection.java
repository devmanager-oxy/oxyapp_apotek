

package com.project.payroll; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.db.*;
import com.project.main.entity.*;

import com.project.payroll.*; 

public class DbSection extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_SECTION = "section";

	public static final  int COL_SECTION_ID = 0;
	public static final  int COL_DEPARTMENT_ID = 1;
	public static final  int COL_NAME = 2;
	public static final  int COL_DESCRIPTION = 3;

	public static final  String[] colNames = {
		"section_id",
		"department_id",
		"name",
		"description"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbSection(){
	}

	public DbSection(int i) throws CONException { 
		super(new DbSection()); 
	}

	public DbSection(String sOid) throws CONException { 
		super(new DbSection(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSection(long lOid) throws CONException { 
		super(new DbSection(0)); 
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
		return DB_SECTION;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSection().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Section section = fetchExc(ent.getOID()); 
		ent = (Entity)section; 
		return section.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Section) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Section) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Section fetchExc(long oid) throws CONException{ 
		try{ 
			Section section = new Section();
			DbSection pstSection = new DbSection(oid); 
			section.setOID(oid);

			section.setDepartmentId(pstSection.getlong(COL_DEPARTMENT_ID));
			section.setName(pstSection.getString(COL_NAME));
			section.setDescription(pstSection.getString(COL_DESCRIPTION));

			return section; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSection(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Section section) throws CONException{ 
		try{ 
			DbSection pstSection = new DbSection(0);

			pstSection.setLong(COL_DEPARTMENT_ID, section.getDepartmentId());
			pstSection.setString(COL_NAME, section.getName());
			pstSection.setString(COL_DESCRIPTION, section.getDescription());

			pstSection.insert(); 
			section.setOID(pstSection.getlong(COL_SECTION_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSection(0),CONException.UNKNOWN); 
		}
		return section.getOID();
	}

	public static long updateExc(Section section) throws CONException{ 
		try{ 
			if(section.getOID() != 0){ 
				DbSection pstSection = new DbSection(section.getOID());

				pstSection.setLong(COL_DEPARTMENT_ID, section.getDepartmentId());
				pstSection.setString(COL_NAME, section.getName());
				pstSection.setString(COL_DESCRIPTION, section.getDescription());

				pstSection.update(); 
				return section.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSection(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSection pstSection = new DbSection(oid);
			pstSection.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSection(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SECTION; 
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
				Section section = new Section();
				resultToObject(rs, section);
				lists.add(section);
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

	private static void resultToObject(ResultSet rs, Section section){
		try{
			section.setOID(rs.getLong(DbSection.colNames[DbSection.COL_SECTION_ID]));
			section.setDepartmentId(rs.getLong(DbSection.colNames[DbSection.COL_DEPARTMENT_ID]));
			section.setName(rs.getString(DbSection.colNames[DbSection.COL_NAME]));
			section.setDescription(rs.getString(DbSection.colNames[DbSection.COL_DESCRIPTION]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long sectionId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SECTION + " WHERE " + 
						DbSection.colNames[DbSection.COL_SECTION_ID] + " = " + sectionId;

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
			String sql = "SELECT COUNT("+ DbSection.colNames[DbSection.COL_SECTION_ID] + ") FROM " + DB_SECTION;
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
			  	   Section section = (Section)list.get(ls);
				   if(oid == section.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
