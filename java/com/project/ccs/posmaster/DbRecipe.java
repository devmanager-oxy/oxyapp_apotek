
package com.project.ccs.posmaster; 

import com.project.ccs.session.RecipeParameter;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;

public class DbRecipe extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_RECIPE = "pos_recipe";

	public static final  int COL_RECIPE_ID = 0;
	public static final  int COL_ITEM_MASTER_ID = 1;
	public static final  int COL_ITEM_RECIPE_ID = 2;
	public static final  int COL_QTY = 3;
	public static final  int COL_UOM_ID = 4;
	public static final  int COL_COST = 5;
	public static final  int COL_TYPE = 6;
	public static final  int COL_LAST_UPDATE = 7;        
        public static final  int COL_DESCRIPTION = 8;

	public static final  String[] colNames = {
		"recipe_id",
		"item_master_id",
		"item_recipe_id",
		"qty",
		"uom_id",
		"cost",
		"type",
		"last_update",
                "description"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_DATE,
                TYPE_STRING
	 }; 
         
         
         public static String TYPE_RECIPE = "Recipe";
         public static String TYPE_OVERHEAD = "Overhead";

	public DbRecipe(){
	}

	public DbRecipe(int i) throws CONException { 
		super(new DbRecipe()); 
	}

	public DbRecipe(String sOid) throws CONException { 
		super(new DbRecipe(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbRecipe(long lOid) throws CONException { 
		super(new DbRecipe(0)); 
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
		return DB_RECIPE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbRecipe().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Recipe recipe = fetchExc(ent.getOID()); 
		ent = (Entity)recipe; 
		return recipe.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Recipe) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Recipe) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Recipe fetchExc(long oid) throws CONException{ 
		try{ 
			Recipe recipe = new Recipe();
			DbRecipe pstRecipe = new DbRecipe(oid); 
			recipe.setOID(oid);

			recipe.setItemMasterId(pstRecipe.getlong(COL_ITEM_MASTER_ID));
			recipe.setItemRecipeId(pstRecipe.getlong(COL_ITEM_RECIPE_ID));
			recipe.setQty(pstRecipe.getdouble(COL_QTY));
			recipe.setUomId(pstRecipe.getlong(COL_UOM_ID));
			recipe.setCost(pstRecipe.getdouble(COL_COST));
			recipe.setType(pstRecipe.getString(COL_TYPE));
			recipe.setLastUpdate(pstRecipe.getDate(COL_LAST_UPDATE));
                        recipe.setDescription(pstRecipe.getString(COL_DESCRIPTION));

			return recipe; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRecipe(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Recipe recipe) throws CONException{ 
		try{ 
			DbRecipe pstRecipe = new DbRecipe(0);

			pstRecipe.setLong(COL_ITEM_MASTER_ID, recipe.getItemMasterId());
			pstRecipe.setLong(COL_ITEM_RECIPE_ID, recipe.getItemRecipeId());
			pstRecipe.setDouble(COL_QTY, recipe.getQty());
			pstRecipe.setLong(COL_UOM_ID, recipe.getUomId());
			pstRecipe.setDouble(COL_COST, recipe.getCost());
			pstRecipe.setString(COL_TYPE, recipe.getType());
			pstRecipe.setDate(COL_LAST_UPDATE, recipe.getLastUpdate());
                        pstRecipe.setString(COL_DESCRIPTION, recipe.getDescription());

			pstRecipe.insert(); 
			recipe.setOID(pstRecipe.getlong(COL_RECIPE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRecipe(0),CONException.UNKNOWN); 
		}
		return recipe.getOID();
	}

	public static long updateExc(Recipe recipe) throws CONException{ 
		try{ 
			if(recipe.getOID() != 0){ 
				DbRecipe pstRecipe = new DbRecipe(recipe.getOID());

				pstRecipe.setLong(COL_ITEM_MASTER_ID, recipe.getItemMasterId());
				pstRecipe.setLong(COL_ITEM_RECIPE_ID, recipe.getItemRecipeId());
				pstRecipe.setDouble(COL_QTY, recipe.getQty());
				pstRecipe.setLong(COL_UOM_ID, recipe.getUomId());
				pstRecipe.setDouble(COL_COST, recipe.getCost());
				pstRecipe.setString(COL_TYPE, recipe.getType());
				pstRecipe.setDate(COL_LAST_UPDATE, recipe.getLastUpdate());
                                pstRecipe.setString(COL_DESCRIPTION, recipe.getDescription());

				pstRecipe.update(); 
				return recipe.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRecipe(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbRecipe pstRecipe = new DbRecipe(oid);
			pstRecipe.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRecipe(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_RECIPE; 
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
				Recipe recipe = new Recipe();
				resultToObject(rs, recipe);
				lists.add(recipe);
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

	private static void resultToObject(ResultSet rs, Recipe recipe){
		try{
			recipe.setOID(rs.getLong(DbRecipe.colNames[DbRecipe.COL_RECIPE_ID]));
			recipe.setItemMasterId(rs.getLong(DbRecipe.colNames[DbRecipe.COL_ITEM_MASTER_ID]));
			recipe.setItemRecipeId(rs.getLong(DbRecipe.colNames[DbRecipe.COL_ITEM_RECIPE_ID]));
			recipe.setQty(rs.getDouble(DbRecipe.colNames[DbRecipe.COL_QTY]));
			recipe.setUomId(rs.getLong(DbRecipe.colNames[DbRecipe.COL_UOM_ID]));
			recipe.setCost(rs.getDouble(DbRecipe.colNames[DbRecipe.COL_COST]));
			recipe.setType(rs.getString(DbRecipe.colNames[DbRecipe.COL_TYPE]));
                        recipe.setDescription(rs.getString(DbRecipe.colNames[DbRecipe.COL_DESCRIPTION]));
			recipe.setLastUpdate(rs.getTimestamp(DbRecipe.colNames[DbRecipe.COL_LAST_UPDATE]));
                        
                        System.out.println("recipe.setLastUpdateTs : "+recipe.getLastUpdate());
                        
                        //recipe.setLastUpdate(rs.getDate(DbRecipe.colNames[DbRecipe.COL_LAST_UPDATE]));
                        
		}catch(Exception e){
                    System.out.println(e.toString());
                }
	}

	public static boolean checkOID(long recipeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_RECIPE + " WHERE " + 
						DbRecipe.colNames[DbRecipe.COL_RECIPE_ID] + " = " + recipeId;

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
			String sql = "SELECT COUNT("+ DbRecipe.colNames[DbRecipe.COL_RECIPE_ID] + ") FROM " + DB_RECIPE;
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
			  	   Recipe recipe = (Recipe)list.get(ls);
				   if(oid == recipe.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static double getTotalRecipe(long oidItem){
            CONResultSet crs = null;
            double result = 0;
            try{
                String sql = "select sum("+colNames[COL_COST]+") from "+DB_RECIPE+" where "+colNames[COL_ITEM_MASTER_ID]+" = "+oidItem;
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
        }
        
        public static Vector getRecipe(long itemId){
            CONResultSet crs = null;            
            Vector result = new Vector();
            try{
                String sql = "select "+colNames[COL_ITEM_RECIPE_ID]+"," +
                        colNames[COL_QTY]+"," +
                        colNames[COL_COST]+
                        " from "+DB_RECIPE+" where "+colNames[COL_ITEM_MASTER_ID]+" = "+itemId;
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){                    
                    RecipeParameter rp = new RecipeParameter();
                    rp.setItemId(rs.getLong(colNames[COL_ITEM_RECIPE_ID]));
                    rp.setQty(rs.getDouble(colNames[COL_QTY]));
                    rp.setPrice(rs.getDouble(colNames[COL_COST]));                    
                    result.add(rp);
                }
                return result;
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
        }
        
        
        public static Vector updateCOGS(long itemId,double cogs){
            CONResultSet crs = null;            
            Vector result = new Vector();
            try{
                
                String sql = "update "+DbItemMaster.DB_ITEM_MASTER+" set "+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" = "+cogs+
                        " where "+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = "+itemId;                
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
        }
        
}
