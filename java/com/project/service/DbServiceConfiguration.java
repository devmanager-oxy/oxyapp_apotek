
package com.project.service;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class DbServiceConfiguration extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{

    public static final  String DB_SERVICE_CONF = "service_conf";

    public static final  int COL_SERVICE_ID = 0;
    public static final  int COL_SERVICE_TYPE = 1;
    public static final  int COL_START_TIME = 2;
    public static final  int COL_PERIODE = 3;

    public static final  String[] fieldNames = {
            "service_id",
            "service_type",
            "start_time",
            "periode"
     }; 

    public static final  int[] fieldTypes = {
            TYPE_LONG + TYPE_PK + TYPE_ID,
            TYPE_INT,
            TYPE_DATE,
            TYPE_INT
     }; 

    public static int SERVICE_TYPE_RELOAD = 0;  
    
    public static String[][] resultText = {
        {"Reload"}
    };
     
    public DbServiceConfiguration(){
    }

    public DbServiceConfiguration(int i) throws CONException { 
            super(new DbServiceConfiguration()); 
    }

    public DbServiceConfiguration(String sOid) throws CONException { 
            super(new DbServiceConfiguration(0)); 
            if(!locate(sOid)) 
                    throw new CONException(this,CONException.RECORD_NOT_FOUND); 
            else 
                    return; 
    }

    public DbServiceConfiguration(long lOid) throws CONException { 
            super(new DbServiceConfiguration(0)); 
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
            return fieldNames.length; 
    }

    public String getTableName(){ 
            return DB_SERVICE_CONF;
    }

    public String[] getFieldNames(){ 
            return fieldNames; 
    }

    public int[] getFieldTypes(){ 
            return fieldTypes; 
    }

    public String getPersistentName(){ 
            return new DbServiceConfiguration().getClass().getName(); 
    }

    public long fetchExc(Entity ent) throws Exception{ 
            ServiceConfiguration serviceConfiguration = fetchExc(ent.getOID()); 
            ent = (Entity)serviceConfiguration; 
            return serviceConfiguration.getOID(); 
    }

    public long insertExc(Entity ent) throws Exception{ 
            return insertExc((ServiceConfiguration) ent); 
    }

    public long updateExc(Entity ent) throws Exception{ 
            return updateExc((ServiceConfiguration) ent); 
    }

    public long deleteExc(Entity ent) throws Exception{ 
            if(ent==null){ 
                    throw new CONException(this,CONException.RECORD_NOT_FOUND); 
            } 
            return deleteExc(ent.getOID()); 
    }

    public static ServiceConfiguration fetchExc(long oid) throws CONException{ 
            try{ 
                    ServiceConfiguration serviceConfiguration = new ServiceConfiguration();
                    DbServiceConfiguration pstServiceConfiguration = new DbServiceConfiguration(oid); 
                    serviceConfiguration.setOID(oid);

                    serviceConfiguration.setServiceType(pstServiceConfiguration.getInt(COL_SERVICE_TYPE));
                    serviceConfiguration.setStartTime(pstServiceConfiguration.getDate(COL_START_TIME));
                    serviceConfiguration.setPeriode(pstServiceConfiguration.getInt(COL_PERIODE));

                    return serviceConfiguration; 
                    
            }catch(CONException dbe){ 
                    throw dbe; 
            }catch(Exception e){ 
                    throw new CONException(new DbServiceConfiguration(0),CONException.UNKNOWN); 
            } 
    }

    public static long insertExc(ServiceConfiguration serviceConfiguration) throws CONException{ 
            try{ 
                    DbServiceConfiguration pstServiceConfiguration = new DbServiceConfiguration(0);

                    pstServiceConfiguration.setInt(COL_SERVICE_TYPE, serviceConfiguration.getServiceType());
                    pstServiceConfiguration.setDate(COL_START_TIME, serviceConfiguration.getStartTime());
                    pstServiceConfiguration.setInt(COL_PERIODE, serviceConfiguration.getPeriode());                    

                    pstServiceConfiguration.insert(); 
                    serviceConfiguration.setOID(pstServiceConfiguration.getlong(COL_SERVICE_ID));
            }catch(CONException dbe){ 
                    throw dbe; 
            }catch(Exception e){ 
                    throw new CONException(new DbServiceConfiguration(0),CONException.UNKNOWN); 
            }
            return serviceConfiguration.getOID();
    }

    public static long updateExc(ServiceConfiguration serviceConfiguration) throws CONException{ 
            try{ 
                    if(serviceConfiguration.getOID() != 0){ 
                            DbServiceConfiguration pstServiceConfiguration = new DbServiceConfiguration(serviceConfiguration.getOID());

                            pstServiceConfiguration.setInt(COL_SERVICE_TYPE, serviceConfiguration.getServiceType());
                            pstServiceConfiguration.setDate(COL_START_TIME, serviceConfiguration.getStartTime());
                            pstServiceConfiguration.setInt(COL_PERIODE, serviceConfiguration.getPeriode());                            

                            pstServiceConfiguration.update(); 
                            return serviceConfiguration.getOID();

                    }
            }catch(CONException dbe){ 
                    throw dbe; 
            }catch(Exception e){ 
                    throw new CONException(new DbServiceConfiguration(0),CONException.UNKNOWN); 
            }
            return 0;
    }

    public static long deleteExc(long oid) throws CONException{ 
            try{ 
                    DbServiceConfiguration pstServiceConfiguration = new DbServiceConfiguration(oid);
                    pstServiceConfiguration.delete();
            }catch(CONException dbe){ 
                    throw dbe; 
            }catch(Exception e){ 
                    throw new CONException(new DbServiceConfiguration(0),CONException.UNKNOWN); 
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
                    String sql = "SELECT * FROM " + DB_SERVICE_CONF; 
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
                            ServiceConfiguration serviceConfiguration = new ServiceConfiguration();
                            resultToObject(rs, serviceConfiguration);
                            lists.add(serviceConfiguration);
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

    public static void resultToObject(ResultSet rs, ServiceConfiguration serviceConfiguration){
            try{
                    serviceConfiguration.setOID(rs.getLong(DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_SERVICE_ID]));
                    serviceConfiguration.setServiceType(rs.getInt(DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_SERVICE_TYPE]));
                    serviceConfiguration.setStartTime(CONHandler.convertDate(rs.getDate(DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_START_TIME]), rs.getTime(DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_START_TIME])));
                    serviceConfiguration.setPeriode(rs.getInt(DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_PERIODE]));                    

            }catch(Exception e){
                System.out.println("resultToObject exc : " + e.toString());
            }
    }

    public static int getCount(String whereClause){
            CONResultSet dbrs = null;
            try {
                    String sql = "SELECT COUNT("+ DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_SERVICE_ID] + ") FROM " + DB_SERVICE_CONF;
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
    
    
    public static ServiceConfiguration getSvcConfigurationByType(int svcType)
    {
            ServiceConfiguration result = new ServiceConfiguration();
            try 
            {
                    String whereClause = DbServiceConfiguration.fieldNames[DbServiceConfiguration.COL_SERVICE_TYPE] + "=" + svcType;
                    Vector vectResult = list(0, 0, whereClause, "");
                    if(vectResult!=null && vectResult.size()>0)
                    {
                        result = (ServiceConfiguration)vectResult.get(0);
                    }
                    return result;   

            }
            catch(Exception e) 
            {
                    System.out.println(e);
            }
            return result;
    }
    
}
