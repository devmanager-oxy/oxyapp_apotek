package com.project.fms.master; 

import com.project.admin.DbUser;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.*;

public class DbSegmentDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_SEGMENT_DETAIL = "segment_detail";

	public static final  int COL_SEGMENT_DETAIL_ID = 0;
	public static final  int COL_SEGMENT_ID = 1;
	public static final  int COL_NAME = 2;
	public static final  int COL_REF_ID = 3;
	public static final  int COL_CODE = 4;
	public static final  int COL_LEVEL = 5;
	public static final  int COL_TYPE = 6;
        public static final  int COL_LOCATION_ID = 7;
        public static final  int COL_TYPE_SALES_REPORT = 8;
        public static final  int COL_REF_SEGMENT_DETAIL_ID = 9;
        public static final  int COL_STATUS = 10;

	public static final  String[] colNames = {            
		"segment_detail_id",
		"segment_id",
		"name",
		"ref_id",
		"code",
		"level",
		"type",
                "location_id",
                "type_sales_report",
                "ref_segment_detail_id",
                "status"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_INT,
		TYPE_STRING,
                TYPE_LONG,
                TYPE_INT,
                TYPE_LONG,
                TYPE_INT
	 }; 
        
        public static final int TYPE_SALES_SINGLE_PAYMENT_POST_ONE_JOURNAL  = 0;
        public static final int TYPE_SALES_SINGLE_PAYMENT_POST_ONE_SHIFT    = 1;
        public static final int TYPE_SALES_MULTY_PAYMENT_POST_ONE_JOURNAL   = 2;
        public static final int TYPE_SALES_MULTY_PAYMENT_POST_ONE_SHIFT     = 3;
        public static final int TYPE_SALES_MULTY_PAYMENT_POST_ONE_MONTH     = 4;
        
        public static final String[] typeSaleStr = {"Single Payment Post One Journal", "Single Payment Post One Shift", "Multi Payment Post Onne Journal","Multi Payment Post One Shift","Multi Payment Post One Month"};
        
        public static final int STATUS_AKTIF = 0;
        public static final int STATUS_NOT_AKTIF  = 1;
    
        public static String[] strKeyStatus = {"Aktif", "Not Aktif"};
        public static String[] strValueStatus = {"0", "1"};
        

	public DbSegmentDetail(){
	}

	public DbSegmentDetail(int i) throws CONException { 
		super(new DbSegmentDetail()); 
	}

	public DbSegmentDetail(String sOid) throws CONException { 
		super(new DbSegmentDetail(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSegmentDetail(long lOid) throws CONException { 
		super(new DbSegmentDetail(0)); 
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
		return DB_SEGMENT_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSegmentDetail().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SegmentDetail segmentdetail = fetchExc(ent.getOID()); 
		ent = (Entity)segmentdetail; 
		return segmentdetail.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SegmentDetail) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SegmentDetail) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SegmentDetail fetchExc(long oid) throws CONException{ 
		try{ 
			SegmentDetail segmentdetail = new SegmentDetail();
			DbSegmentDetail DbSegmentDetail = new DbSegmentDetail(oid); 
			segmentdetail.setOID(oid);

			segmentdetail.setSegmentId(DbSegmentDetail.getlong(COL_SEGMENT_ID));
			segmentdetail.setName(DbSegmentDetail.getString(COL_NAME));
			segmentdetail.setRefId(DbSegmentDetail.getlong(COL_REF_ID));
			segmentdetail.setCode(DbSegmentDetail.getString(COL_CODE));
			segmentdetail.setLevel(DbSegmentDetail.getInt(COL_LEVEL));
			segmentdetail.setType(DbSegmentDetail.getString(COL_TYPE));
                        segmentdetail.setLocationId(DbSegmentDetail.getlong(COL_LOCATION_ID));
                        segmentdetail.setTypeSalesReport(DbSegmentDetail.getInt(COL_TYPE_SALES_REPORT));
                        segmentdetail.setRefSegmentDetailId(DbSegmentDetail.getlong(COL_REF_SEGMENT_DETAIL_ID));
                        segmentdetail.setStatus(DbSegmentDetail.getInt(COL_STATUS));

			return segmentdetail; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSegmentDetail(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SegmentDetail segmentdetail) throws CONException{ 
		try{ 
			DbSegmentDetail DbSegmentDetail = new DbSegmentDetail(0);

			DbSegmentDetail.setLong(COL_SEGMENT_ID, segmentdetail.getSegmentId());
			DbSegmentDetail.setString(COL_NAME, segmentdetail.getName());
			DbSegmentDetail.setLong(COL_REF_ID, segmentdetail.getRefId());
			DbSegmentDetail.setString(COL_CODE, segmentdetail.getCode());
			DbSegmentDetail.setInt(COL_LEVEL, segmentdetail.getLevel());
			DbSegmentDetail.setString(COL_TYPE, segmentdetail.getType());
                        DbSegmentDetail.setLong(COL_LOCATION_ID, segmentdetail.getLocationId());                        
                        DbSegmentDetail.setInt(COL_TYPE_SALES_REPORT, segmentdetail.getTypeSalesReport());                        
                        DbSegmentDetail.setLong(COL_REF_SEGMENT_DETAIL_ID, segmentdetail.getRefSegmentDetailId());                        
                        DbSegmentDetail.setInt(COL_STATUS, segmentdetail.getStatus()); 
                        
			DbSegmentDetail.insert(); 
			segmentdetail.setOID(DbSegmentDetail.getlong(COL_SEGMENT_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSegmentDetail(0),CONException.UNKNOWN); 
		}
		return segmentdetail.getOID();
	}

	public static long updateExc(SegmentDetail segmentdetail) throws CONException{ 
		try{ 
			if(segmentdetail.getOID() != 0){ 
				DbSegmentDetail DbSegmentDetail = new DbSegmentDetail(segmentdetail.getOID());

				DbSegmentDetail.setLong(COL_SEGMENT_ID, segmentdetail.getSegmentId());
				DbSegmentDetail.setString(COL_NAME, segmentdetail.getName());
				DbSegmentDetail.setLong(COL_REF_ID, segmentdetail.getRefId());
				DbSegmentDetail.setString(COL_CODE, segmentdetail.getCode());
				DbSegmentDetail.setInt(COL_LEVEL, segmentdetail.getLevel());
				DbSegmentDetail.setString(COL_TYPE, segmentdetail.getType());
                                DbSegmentDetail.setLong(COL_LOCATION_ID, segmentdetail.getLocationId());
                                DbSegmentDetail.setInt(COL_TYPE_SALES_REPORT, segmentdetail.getTypeSalesReport());            
                                DbSegmentDetail.setLong(COL_REF_SEGMENT_DETAIL_ID, segmentdetail.getRefSegmentDetailId());
                                DbSegmentDetail.setInt(COL_STATUS, segmentdetail.getStatus()); 

				DbSegmentDetail.update(); 
				return segmentdetail.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSegmentDetail(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSegmentDetail DbSegmentDetail = new DbSegmentDetail(oid);
			DbSegmentDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSegmentDetail(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SEGMENT_DETAIL; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
                        
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
			while(rs.next()) {
				SegmentDetail segmentdetail = new SegmentDetail();
				resultToObject(rs, segmentdetail);
				lists.add(segmentdetail);
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

	private static void resultToObject(ResultSet rs, SegmentDetail segmentdetail){
		try{
			segmentdetail.setOID(rs.getLong(DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID]));
			segmentdetail.setSegmentId(rs.getLong(DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID]));
			segmentdetail.setName(rs.getString(DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]));
			segmentdetail.setRefId(rs.getLong(DbSegmentDetail.colNames[DbSegmentDetail.COL_REF_ID]));
			segmentdetail.setCode(rs.getString(DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]));
			segmentdetail.setLevel(rs.getInt(DbSegmentDetail.colNames[DbSegmentDetail.COL_LEVEL]));
			segmentdetail.setType(rs.getString(DbSegmentDetail.colNames[DbSegmentDetail.COL_TYPE]));
                        segmentdetail.setLocationId(rs.getLong(DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID]));                        
                        segmentdetail.setTypeSalesReport(rs.getInt(DbSegmentDetail.colNames[DbSegmentDetail.COL_TYPE_SALES_REPORT]));                        
                        segmentdetail.setRefSegmentDetailId(rs.getLong(DbSegmentDetail.colNames[DbSegmentDetail.COL_REF_SEGMENT_DETAIL_ID]));     
                        segmentdetail.setStatus(rs.getInt(DbSegmentDetail.colNames[DbSegmentDetail.COL_STATUS])); 

		}catch(Exception e){ }
	}

	public static boolean checkOID(long segmentDetailId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SEGMENT_DETAIL + " WHERE " + 
						DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + segmentDetailId;

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
			String sql = "SELECT COUNT("+ DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + ") FROM " + DB_SEGMENT_DETAIL;
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
			  	   SegmentDetail segmentdetail = (SegmentDetail)list.get(ls);
				   if(oid == segmentdetail.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	public static boolean isExist(long segmentDetId, String code, long segmentId){
		String where = colNames[COL_SEGMENT_ID]+"="+segmentId+" and "+colNames[COL_SEGMENT_DETAIL_ID]+"<>"+segmentDetId+" and "+colNames[COL_CODE]+"='"+code+"'";
		if(getCount(where)>0){
			return true;
		}
		return false;
	}
        
        public static Vector listLocation(long userId){
            
            CONResultSet dbrs = null;
            try{
                String sql = "select "+DbUser.colNames[DbUser.COL_SEGMENT1_ID]+" ,"+DbUser.colNames[DbUser.COL_SEGMENT2_ID]+                         
                        " from "+DbUser.DB_APP_USER+" where "+DbUser.colNames[DbUser.COL_USER_ID]+" = "+userId;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while(rs.next()){
                    long segment1Id = rs.getLong(DbUser.colNames[DbUser.COL_SEGMENT1_ID]);
                    long segment2Id = rs.getLong(DbUser.colNames[DbUser.COL_SEGMENT2_ID]);
                    if(segment2Id != 0){
                        return listSegmentByLocation(2,segment1Id,segment2Id);
                    }else{
                        if(segment1Id != 0){
                            return listSegmentByLocation(1,segment1Id,segment2Id);
                        }else{
                            return DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
                        }
                    }
                }
                
            }catch(Exception e){}
           
            return null;
        }       
        
        
        public static Vector listSegmentByLocation(int segment,long segment1Id,long segment2Id){
            Vector result = new Vector();
            CONResultSet dbrs = null;
            try{
                String sql = "";
                if(segment == 1){ //jika kondisi segment 1
                    sql = "select l.* from pos_location l inner join segment_detail sd on l.location_id = sd.location_id where sd.ref_id="+segment1Id+" order by l.name";                                        
                } else if(segment == 2){                   
                    sql = "select l.* from pos_location l inner join segment_detail sd on l.location_id = sd.location_id where sd.segment_detail_id="+segment2Id+" order by l.name";                    
                }
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while(rs.next()) {
                    Location location = new Location();
                    location.setOID(rs.getLong(DbLocation.colNames[DbLocation.COL_LOCATION_ID]));			
                    location.setName(rs.getString(DbLocation.colNames[DbLocation.COL_NAME]));
                    result.add(location);
                }
                
            }catch(Exception e) {
                
            }finally {
                CONResultSet.close(dbrs);
            }
            return result;
            
        }
        
        
        public static boolean isParent(){
            Vector listSegment = DbSegment.list(0, 0, DbSegment.colNames[DbSegment.COL_COUNT]+" = 2", null);
            if(listSegment != null && listSegment.size() > 0){
                try{
                    Segment s = (Segment)listSegment.get(0);
                    Vector listSegmentDetail = DbSegmentDetail.list(0, 0, DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID]+" = "+s.getOID() , null);
                    if(listSegmentDetail != null && listSegmentDetail.size() > 0){
                        for(int i = 0 ; i < listSegmentDetail.size() ; i++){
                            SegmentDetail sd = (SegmentDetail)listSegmentDetail.get(i);
                            if(sd.getRefId() == 0){
                                return false;
                            }
                        }
                        return true;
                    }
                }catch(Exception e){}
            }
            return false;
        }
}

