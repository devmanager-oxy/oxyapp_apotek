/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;
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
public class DbApproval extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_APPROVAL = "approval";
    
    public static final int COL_APPROVAL_ID     = 0;
    public static final int COL_TYPE            = 1;
    public static final int COL_URUTAN          = 2;
    public static final int COL_KETERANGAN      = 3;
    public static final int COL_EMPLOYEE_ID     = 4; 
    public static final int COL_JUMLAH_DARI     = 5; 
    public static final int COL_JUMLAH_SAMPAI     = 6;
    public static final int COL_URUTAN_APPROVAL     = 7;
    public static final int COL_KETERANGAN_FOOTER     = 8;
    
    public static final  String[] colNames = {
                "approval_id",
		"type",
		"urutan",
		"keterangan",
		"employee_id",
		"jumlah_dari",
		"jumlah_sampai",
		"urutan_approval",
		"keterangan_footer"
    };
    
    
    public static final  int[] fieldTypes = {  
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_INT,
		TYPE_INT,
		TYPE_STRING,	
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_STRING
    };
    
    
    public static final int URUTAN_0    = 0;    
    public static final int URUTAN_1    = 1;
    public static final int URUTAN_2    = 2;
    public static final int URUTAN_3    = 3;
    public static final int URUTAN_4    = 4;
    public static final int URUTAN_5    = 5;
    public static final int URUTAN_6    = 6;
    public static final int URUTAN_7    = 7;
    public static final int URUTAN_8    = 8;
    public static final int URUTAN_9    = 9;        
    
    public static final String[] approvalUrutanKey = {"0", "1","2","3","4","5","6","7","8","9"};
    public static final String[] approvalUrutanStr = {"0", "1","2","3","4","5","6","7","8","9"};
    
    public DbApproval(){
    }

	public DbApproval(int i) throws CONException {
		super(new DbApproval());
	}

	public DbApproval(String sOid) throws CONException {
            
            super(new DbApproval(0));
            if(!locate(sOid))
		throw new CONException(this,CONException.RECORD_NOT_FOUND);
            else
		return;
	}

	public DbApproval(long lOid) throws CONException {
		super(new DbApproval(0));
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
		return DB_APPROVAL;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbApproval().getClass().getName();
	}
        
        public long fetchExc(Entity ent) throws Exception{
		Approval approval = fetchExc(ent.getOID());
		ent = (Entity)approval;
		return approval.getOID();
	}

	public long insertExc(Entity ent) throws Exception{
		return insertExc((Approval) ent);
	}

	public long updateExc(Entity ent) throws Exception{
		return updateExc((Approval) ent);
	}

	public long deleteExc(Entity ent) throws Exception{
            if(ent==null){
                throw new CONException(this,CONException.RECORD_NOT_FOUND);
            }
            return deleteExc(ent.getOID());
	}
        
        public static Approval fetchExc(long oid) throws CONException{
		try{
			Approval approval = new Approval();
			
			DbApproval dbApproval = new DbApproval(oid);
			
			approval.setOID(oid);			
			approval.setType(dbApproval.getInt(COL_TYPE));
            approval.setUrutan(dbApproval.getInt(COL_URUTAN));
            approval.setKeterangan(dbApproval.getString(COL_KETERANGAN));
            approval.setEmployeeId(dbApproval.getlong(COL_EMPLOYEE_ID));
            
            approval.setJumlahDari(dbApproval.getdouble(COL_JUMLAH_DARI));
            approval.setJumlahSampai(dbApproval.getdouble(COL_JUMLAH_SAMPAI));
            approval.setUrutanApproval(dbApproval.getInt(COL_URUTAN_APPROVAL));
            approval.setKeteranganFooter(dbApproval.getString(COL_KETERANGAN_FOOTER));
			
			return approval;
                        
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbApproval(0),CONException.UNKNOWN);
		}
	}

        public static long insertExc(Approval approval) throws CONException{
		try{
			DbApproval dbApproval = new DbApproval(0);

			dbApproval.setInt(COL_TYPE, approval.getType());
            dbApproval.setInt(COL_URUTAN, approval.getUrutan());
            dbApproval.setString(COL_KETERANGAN, approval.getKeterangan());
            dbApproval.setLong(COL_EMPLOYEE_ID, approval.getEmployeeId());
            
            dbApproval.setDouble(COL_JUMLAH_DARI, approval.getJumlahDari());
            dbApproval.setDouble(COL_JUMLAH_SAMPAI, approval.getJumlahSampai());
            dbApproval.setInt(COL_URUTAN_APPROVAL, approval.getUrutanApproval());
            dbApproval.setString(COL_KETERANGAN_FOOTER, approval.getKeteranganFooter());
                        
			dbApproval.insert();
			approval.setOID(dbApproval.getlong(COL_APPROVAL_ID));
			
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbApproval(0),CONException.UNKNOWN);
		}
		return approval.getOID();
	}

	public static long updateExc(Approval approval) throws CONException{
		try{
                    if(approval.getOID() != 0){
                        DbApproval dbApproval = new DbApproval(approval.getOID());

						dbApproval.setInt(COL_TYPE, approval.getType());
                        dbApproval.setInt(COL_URUTAN, approval.getUrutan());
                        dbApproval.setString(COL_KETERANGAN, approval.getKeterangan());
                        dbApproval.setLong(COL_EMPLOYEE_ID, approval.getEmployeeId());
                        
                        dbApproval.setDouble(COL_JUMLAH_DARI, approval.getJumlahDari());
            			dbApproval.setDouble(COL_JUMLAH_SAMPAI, approval.getJumlahSampai());
            			dbApproval.setInt(COL_URUTAN_APPROVAL, approval.getUrutanApproval());
            			dbApproval.setString(COL_KETERANGAN_FOOTER, approval.getKeteranganFooter());
                        
                        dbApproval.update();
				
			return approval.getOID();
                    }
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbApproval(0),CONException.UNKNOWN);
		}
		return 0;
	}
    
        public static long deleteExc(long oid) throws CONException{
		try{
			DbApproval dbApproval = new DbApproval(oid);
			dbApproval.delete();
                        
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbApproval(0),CONException.UNKNOWN);
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
			String sql = "SELECT * FROM " + DB_APPROVAL;
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
				Approval approval = new Approval();
				resultToObject(rs, approval);
				lists.add(approval);
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

	public static void resultToObject(ResultSet rs, Approval approval){
		try{
			approval.setOID(rs.getLong(DbApproval.colNames[DbApproval.COL_APPROVAL_ID]));
            approval.setType(rs.getInt(DbApproval.colNames[DbApproval.COL_TYPE]));
            approval.setUrutan(rs.getInt(DbApproval.colNames[DbApproval.COL_URUTAN]));
            approval.setKeterangan(rs.getString(DbApproval.colNames[DbApproval.COL_KETERANGAN]));
            approval.setEmployeeId(rs.getLong(DbApproval.colNames[DbApproval.COL_EMPLOYEE_ID]));
            
            approval.setJumlahDari(rs.getDouble(DbApproval.colNames[DbApproval.COL_JUMLAH_DARI]));
            approval.setJumlahSampai(rs.getDouble(DbApproval.colNames[DbApproval.COL_JUMLAH_SAMPAI]));
            approval.setUrutanApproval(rs.getInt(DbApproval.colNames[DbApproval.COL_URUTAN_APPROVAL]));
            approval.setKeteranganFooter(rs.getString(DbApproval.colNames[DbApproval.COL_KETERANGAN_FOOTER]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long approvalId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_APPROVAL + " WHERE " +
						DbApproval.colNames[DbApproval.COL_APPROVAL_ID] + " = " + approvalId;

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
			String sql = "SELECT COUNT("+ DbApproval.colNames[DbApproval.COL_APPROVAL_ID] + ") FROM " + DB_APPROVAL;
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
			  	   Approval approval = (Approval)list.get(ls);
				   if(oid == approval.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}

        
        /**
         * @Author  Roy Andika
         * @param empId
         * @param type
         * @Description Untuk mengecek agar tidak ada type dan employee yang sama pada 1 form
         * @return
         */
	public static boolean getTypeApprovalExist(long empId,int type,long appId){
            
            CONResultSet dbrs = null;
            
            try{
                String sql = "SELECT "+DbApproval.colNames[DbApproval.COL_APPROVAL_ID]+" FROM "+
                        DbApproval.DB_APPROVAL+" WHERE "+DbApproval.colNames[DbApproval.COL_TYPE]+" = "+type+" AND "+
                        DbApproval.colNames[DbApproval.COL_EMPLOYEE_ID]+" = "+empId+" AND "+
                        DbApproval.colNames[DbApproval.COL_APPROVAL_ID]+" != "+appId;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
                while(rs.next()){
                    return true;                    
                }
                
            }catch(Exception E){
                System.out.println("Exception "+E.toString());
            }finally{
                CONResultSet.close(dbrs);
            }
            
            return false;
        }
    
        public static Approval getListApproval(int type, int urutan){
            
            CONResultSet dbrs = null;
            
            try{
                String sql = "SELECT * FROM " + DB_APPROVAL+ " WHERE "+
                        DbApproval.colNames[DbApproval.COL_TYPE]+" = "+type+" AND "+
                        DbApproval.colNames[DbApproval.COL_URUTAN]+" = "+urutan;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
                while(rs.next()){
                    Approval approval = new Approval();
                    resultToObject(rs, approval);
                    
                    return approval;
                }
                
            }catch(Exception E){
                System.out.println("Exception "+E.toString());
            }finally{
                CONResultSet.close(dbrs);
            }
            
            return null;
        }
        
        public static Vector getListApproval(int type){
            
            CONResultSet dbrs = null;
            
            try{
                String sql = "SELECT * FROM " + DB_APPROVAL+ " WHERE "+
                        DbApproval.colNames[DbApproval.COL_TYPE]+" = "+type+" AND "+DbApproval.colNames[DbApproval.COL_URUTAN]+" > 0 ORDER BY "+DbApproval.colNames[DbApproval.COL_URUTAN];
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
                Vector result = new Vector();
                
                while(rs.next()){
                    Approval approval = new Approval();
                    resultToObject(rs, approval);                    
                    result.add(approval);
                }
                
                return result;
                
            }catch(Exception E){
                System.out.println("Exception "+E.toString());
            }finally{
                CONResultSet.close(dbrs);
            }
            
            return null;
        }
}