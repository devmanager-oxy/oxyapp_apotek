
package com.project.ccs.postransaction.memberpoint; 

import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;

public class DbMemberPointSetup extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_POS_MEMBER_POINT_SETUP = "pos_member_point_setup";

	public static final  int COL_MEMBER_POINT_SETUP_ID = 0;
	public static final  int COL_GROUP_TYPE = 1;
	public static final  int COL_AMOUNT = 2;
	public static final  int COL_POINT = 3;
	public static final  int COL_USER_ID = 4;
	public static final  int COL_DATE = 5;
	public static final  int COL_LAST_UPDATE_DATE = 6;
	public static final  int COL_STATUS = 7;
	public static final  int COL_POINT_UNIT_VALUE = 8;
	public static final  int COL_START_DATE = 9;
	public static final  int COL_END_DATE = 10;
	public static final  int COL_AMOUNT_ROUNDING = 11;
	public static final  int COL_MIN_ROUDING = 12;
        public static final  int COL_ITEM_GROUP_ID = 13;

	public static final  String[] colNames = {
            "member_point_setup_id",
            "group_type",
            "amount",
            "point",
            "user_id",
            "date",
            "last_update_date",
            "status",
            "point_unit_value",
            "start_date",
            "end_date",
            "amount_rounding",
            "min_rouding",
            "item_group_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_INT,
		TYPE_FLOAT,                
		TYPE_LONG
	 }; 

	public DbMemberPointSetup(){
	}

	public DbMemberPointSetup(int i) throws CONException { 
		super(new DbMemberPointSetup()); 
	}

	public DbMemberPointSetup(String sOid) throws CONException { 
		super(new DbMemberPointSetup(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbMemberPointSetup(long lOid) throws CONException { 
		super(new DbMemberPointSetup(0)); 
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
		return DB_POS_MEMBER_POINT_SETUP;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbMemberPointSetup().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		MemberPointSetup memberpointsetup = fetchExc(ent.getOID()); 
		ent = (Entity)memberpointsetup; 
		return memberpointsetup.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((MemberPointSetup) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((MemberPointSetup) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static MemberPointSetup fetchExc(long oid) throws CONException{ 
		try{ 
			MemberPointSetup memberpointsetup = new MemberPointSetup();
			DbMemberPointSetup pstMemberPointSetup = new DbMemberPointSetup(oid); 
			memberpointsetup.setOID(oid);

			memberpointsetup.setGroupType(pstMemberPointSetup.getInt(COL_GROUP_TYPE));
			memberpointsetup.setAmount(pstMemberPointSetup.getdouble(COL_AMOUNT));
			memberpointsetup.setPoint(pstMemberPointSetup.getdouble(COL_POINT));
			memberpointsetup.setUserId(pstMemberPointSetup.getlong(COL_USER_ID));
			memberpointsetup.setDate(pstMemberPointSetup.getDate(COL_DATE));
			memberpointsetup.setLastUpdateDate(pstMemberPointSetup.getDate(COL_LAST_UPDATE_DATE));
			memberpointsetup.setStatus(pstMemberPointSetup.getInt(COL_STATUS));
			memberpointsetup.setPointUnitValue(pstMemberPointSetup.getdouble(COL_POINT_UNIT_VALUE));
			memberpointsetup.setStartDate(pstMemberPointSetup.getDate(COL_START_DATE));
			memberpointsetup.setEndDate(pstMemberPointSetup.getDate(COL_END_DATE));
			memberpointsetup.setAmountRounding(pstMemberPointSetup.getInt(COL_AMOUNT_ROUNDING));
			memberpointsetup.setMinRouding(pstMemberPointSetup.getdouble(COL_MIN_ROUDING));
                        memberpointsetup.setItemGroupId(pstMemberPointSetup.getlong(COL_ITEM_GROUP_ID));

			return memberpointsetup; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMemberPointSetup(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(MemberPointSetup memberpointsetup) throws CONException{ 
		try{ 
			DbMemberPointSetup pstMemberPointSetup = new DbMemberPointSetup(0);

			pstMemberPointSetup.setInt(COL_GROUP_TYPE, memberpointsetup.getGroupType());
			pstMemberPointSetup.setDouble(COL_AMOUNT, memberpointsetup.getAmount());
			pstMemberPointSetup.setDouble(COL_POINT, memberpointsetup.getPoint());
			pstMemberPointSetup.setLong(COL_USER_ID, memberpointsetup.getUserId());
			pstMemberPointSetup.setDate(COL_DATE, memberpointsetup.getDate());
			pstMemberPointSetup.setDate(COL_LAST_UPDATE_DATE, memberpointsetup.getLastUpdateDate());
			pstMemberPointSetup.setInt(COL_STATUS, memberpointsetup.getStatus());
			pstMemberPointSetup.setDouble(COL_POINT_UNIT_VALUE, memberpointsetup.getPointUnitValue());
			pstMemberPointSetup.setDate(COL_START_DATE, memberpointsetup.getStartDate());
			pstMemberPointSetup.setDate(COL_END_DATE, memberpointsetup.getEndDate());
			pstMemberPointSetup.setInt(COL_AMOUNT_ROUNDING, memberpointsetup.getAmountRounding());
			pstMemberPointSetup.setDouble(COL_MIN_ROUDING, memberpointsetup.getMinRouding());
                        pstMemberPointSetup.setLong(COL_ITEM_GROUP_ID, memberpointsetup.getItemGroupId());

			pstMemberPointSetup.insert(); 
			memberpointsetup.setOID(pstMemberPointSetup.getlong(COL_MEMBER_POINT_SETUP_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMemberPointSetup(0),CONException.UNKNOWN); 
		}
		return memberpointsetup.getOID();
	}

	public static long updateExc(MemberPointSetup memberpointsetup) throws CONException{ 
		try{ 
			if(memberpointsetup.getOID() != 0){ 
				DbMemberPointSetup pstMemberPointSetup = new DbMemberPointSetup(memberpointsetup.getOID());

				pstMemberPointSetup.setInt(COL_GROUP_TYPE, memberpointsetup.getGroupType());
				pstMemberPointSetup.setDouble(COL_AMOUNT, memberpointsetup.getAmount());
				pstMemberPointSetup.setDouble(COL_POINT, memberpointsetup.getPoint());
				pstMemberPointSetup.setLong(COL_USER_ID, memberpointsetup.getUserId());
				pstMemberPointSetup.setDate(COL_DATE, memberpointsetup.getDate());
				pstMemberPointSetup.setDate(COL_LAST_UPDATE_DATE, memberpointsetup.getLastUpdateDate());
				pstMemberPointSetup.setInt(COL_STATUS, memberpointsetup.getStatus());
				pstMemberPointSetup.setDouble(COL_POINT_UNIT_VALUE, memberpointsetup.getPointUnitValue());
				pstMemberPointSetup.setDate(COL_START_DATE, memberpointsetup.getStartDate());
				pstMemberPointSetup.setDate(COL_END_DATE, memberpointsetup.getEndDate());
				pstMemberPointSetup.setInt(COL_AMOUNT_ROUNDING, memberpointsetup.getAmountRounding());
				pstMemberPointSetup.setDouble(COL_MIN_ROUDING, memberpointsetup.getMinRouding());
                                pstMemberPointSetup.setLong(COL_ITEM_GROUP_ID, memberpointsetup.getItemGroupId());

				pstMemberPointSetup.update(); 
				return memberpointsetup.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMemberPointSetup(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbMemberPointSetup pstMemberPointSetup = new DbMemberPointSetup(oid);
			pstMemberPointSetup.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMemberPointSetup(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_POS_MEMBER_POINT_SETUP; 
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
				MemberPointSetup memberpointsetup = new MemberPointSetup();
				resultToObject(rs, memberpointsetup);
				lists.add(memberpointsetup);
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

	private static void resultToObject(ResultSet rs, MemberPointSetup memberpointsetup){
		try{
			memberpointsetup.setOID(rs.getLong(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_MEMBER_POINT_SETUP_ID]));
			memberpointsetup.setGroupType(rs.getInt(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_GROUP_TYPE]));
			memberpointsetup.setAmount(rs.getDouble(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_AMOUNT]));
			memberpointsetup.setPoint(rs.getDouble(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_POINT]));
			memberpointsetup.setUserId(rs.getLong(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_USER_ID]));
			memberpointsetup.setDate(rs.getDate(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_DATE]));
			memberpointsetup.setLastUpdateDate(rs.getDate(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_LAST_UPDATE_DATE]));
			memberpointsetup.setStatus(rs.getInt(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_STATUS]));
			memberpointsetup.setPointUnitValue(rs.getDouble(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_POINT_UNIT_VALUE]));
			memberpointsetup.setStartDate(rs.getDate(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_START_DATE]));
			memberpointsetup.setEndDate(rs.getDate(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_END_DATE]));
			memberpointsetup.setAmountRounding(rs.getInt(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_AMOUNT_ROUNDING]));
			memberpointsetup.setMinRouding(rs.getDouble(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_MIN_ROUDING]));
                        memberpointsetup.setItemGroupId(rs.getLong(DbMemberPointSetup.colNames[DbMemberPointSetup.COL_ITEM_GROUP_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long memberPointSetupId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_POS_MEMBER_POINT_SETUP + " WHERE " + 
						DbMemberPointSetup.colNames[DbMemberPointSetup.COL_MEMBER_POINT_SETUP_ID] + " = " + memberPointSetupId;

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
			String sql = "SELECT COUNT("+ DbMemberPointSetup.colNames[DbMemberPointSetup.COL_MEMBER_POINT_SETUP_ID] + ") FROM " + DB_POS_MEMBER_POINT_SETUP;
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
			  	   MemberPointSetup memberpointsetup = (MemberPointSetup)list.get(ls);
				   if(oid == memberpointsetup.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
