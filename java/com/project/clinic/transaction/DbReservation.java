
package com.project.clinic.transaction; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*;

public class DbReservation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_RESERVATION = "CL_RESERVATION";

	public static final  int COL_RESERVATION_ID = 0;
	public static final  int COL_REG_DATE = 1;
	public static final  int COL_PATIENT_ID = 2;
	public static final  int COL_QUEUE_NUMBER = 3;
	public static final  int COL_DOCTOR_ID = 4;
	public static final  int COL_QUEUE_TIME = 5;
	public static final  int COL_STATUS = 6;
	public static final  int COL_DESCRIPTION = 7;
	public static final  int COL_ADMIN_ID = 8;

	public static final  String[] colNames = {
		"RESERVATION_ID",
		"REG_DATE",
		"PATIENT_ID",
		"QUEUE_NUMBER",
		"DOCTOR_ID",
		"QUEUE_TIME",
		"STATUS",
		"DESCRIPTION",
		"ADMIN_ID"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_INT,
		TYPE_STRING,
		TYPE_LONG
	 }; 

	public DbReservation(){
	}

	public DbReservation(int i) throws CONException { 
		super(new DbReservation()); 
	}

	public DbReservation(String sOid) throws CONException { 
		super(new DbReservation(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbReservation(long lOid) throws CONException { 
		super(new DbReservation(0)); 
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
		return DB_CL_RESERVATION;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbReservation().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Reservation reservation = fetchExc(ent.getOID()); 
		ent = (Entity)reservation; 
		return reservation.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Reservation) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Reservation) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Reservation fetchExc(long oid) throws CONException{ 
		try{ 
			Reservation reservation = new Reservation();
			DbReservation pstReservation = new DbReservation(oid); 
			reservation.setOID(oid);

			reservation.setRegDate(pstReservation.getDate(COL_REG_DATE));
			reservation.setPatientId(pstReservation.getlong(COL_PATIENT_ID));
			reservation.setQueueNumber(pstReservation.getInt(COL_QUEUE_NUMBER));
			reservation.setDoctorId(pstReservation.getlong(COL_DOCTOR_ID));
			reservation.setQueueTime(pstReservation.getDate(COL_QUEUE_TIME));
			reservation.setStatus(pstReservation.getInt(COL_STATUS));
			reservation.setDescription(pstReservation.getString(COL_DESCRIPTION));
			reservation.setAdminId(pstReservation.getlong(COL_ADMIN_ID));

			return reservation; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbReservation(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Reservation reservation) throws CONException{ 
		try{ 
			DbReservation pstReservation = new DbReservation(0);

			pstReservation.setDate(COL_REG_DATE, reservation.getRegDate());
			pstReservation.setLong(COL_PATIENT_ID, reservation.getPatientId());
			pstReservation.setInt(COL_QUEUE_NUMBER, reservation.getQueueNumber());
			pstReservation.setLong(COL_DOCTOR_ID, reservation.getDoctorId());
			pstReservation.setDate(COL_QUEUE_TIME, reservation.getQueueTime());
			pstReservation.setInt(COL_STATUS, reservation.getStatus());
			pstReservation.setString(COL_DESCRIPTION, reservation.getDescription());
			pstReservation.setLong(COL_ADMIN_ID, reservation.getAdminId());

			pstReservation.insert(); 
			reservation.setOID(pstReservation.getlong(COL_RESERVATION_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbReservation(0),CONException.UNKNOWN); 
		}
		return reservation.getOID();
	}

	public static long updateExc(Reservation reservation) throws CONException{ 
		try{ 
			if(reservation.getOID() != 0){ 
				DbReservation pstReservation = new DbReservation(reservation.getOID());

				pstReservation.setDate(COL_REG_DATE, reservation.getRegDate());
				pstReservation.setLong(COL_PATIENT_ID, reservation.getPatientId());
				pstReservation.setInt(COL_QUEUE_NUMBER, reservation.getQueueNumber());
				pstReservation.setLong(COL_DOCTOR_ID, reservation.getDoctorId());
				pstReservation.setDate(COL_QUEUE_TIME, reservation.getQueueTime());
				pstReservation.setInt(COL_STATUS, reservation.getStatus());
				pstReservation.setString(COL_DESCRIPTION, reservation.getDescription());
				pstReservation.setLong(COL_ADMIN_ID, reservation.getAdminId());

				pstReservation.update(); 
				return reservation.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbReservation(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbReservation pstReservation = new DbReservation(oid);
			pstReservation.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbReservation(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_RESERVATION; 
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
				Reservation reservation = new Reservation();
				resultToObject(rs, reservation);
				lists.add(reservation);
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

	private static void resultToObject(ResultSet rs, Reservation reservation){
		try{
			reservation.setOID(rs.getLong(DbReservation.colNames[DbReservation.COL_RESERVATION_ID]));
			reservation.setRegDate(rs.getDate(DbReservation.colNames[DbReservation.COL_REG_DATE]));
			reservation.setPatientId(rs.getLong(DbReservation.colNames[DbReservation.COL_PATIENT_ID]));
			reservation.setQueueNumber(rs.getInt(DbReservation.colNames[DbReservation.COL_QUEUE_NUMBER]));
			reservation.setDoctorId(rs.getLong(DbReservation.colNames[DbReservation.COL_DOCTOR_ID]));
                        
                        Date dt = rs.getDate(DbReservation.colNames[DbReservation.COL_QUEUE_TIME]);
                        Date tm = rs.getTime(DbReservation.colNames[DbReservation.COL_QUEUE_TIME]);
                        Date newDt = new Date();
                        newDt.setDate(dt.getDate());
                        newDt.setMonth(dt.getMonth());
                        newDt.setYear(dt.getYear());
                        newDt.setHours(tm.getHours());
                        newDt.setMinutes(tm.getMinutes());
                        
			reservation.setQueueTime(newDt);
			reservation.setStatus(rs.getInt(DbReservation.colNames[DbReservation.COL_STATUS]));
			reservation.setDescription(rs.getString(DbReservation.colNames[DbReservation.COL_DESCRIPTION]));
			reservation.setAdminId(rs.getLong(DbReservation.colNames[DbReservation.COL_ADMIN_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long reservationId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_RESERVATION + " WHERE " + 
						DbReservation.colNames[DbReservation.COL_RESERVATION_ID] + " = " + reservationId;

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
			String sql = "SELECT COUNT("+ DbReservation.colNames[DbReservation.COL_RESERVATION_ID] + ") FROM " + DB_CL_RESERVATION;
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
			  	   Reservation reservation = (Reservation)list.get(ls);
				   if(oid == reservation.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
