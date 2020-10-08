
package com.project.ccs.postransaction.repack; 

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbStockMin;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.postransaction.order.Order;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;
import com.project.ccs.postransaction.stock.*;
import com.project.general.DbHistoryUser;
import com.project.general.DbLocation;
import com.project.general.HistoryUser;
import com.project.general.Location;

public class DbRepackItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 
	public static final  String DB_POS_REPACK_ITEM = "pos_repack_item";

	public static final  int COL_REPACK_ITEM_ID = 0;
	public static final  int COL_REPACK_ID = 1;
	public static final  int COL_ITEM_MASTER_ID = 2;
	public static final  int COL_QTY = 3;
	public static final  int COL_TYPE = 4;
        public static final  int COL_COGS = 5;  
        public static final  int COL_QTY_STOCK = 6;
        public static final  int COL_PERCENT_COGS = 7;
        
	public static final  String[] colNames = {
		"repack_item_id",
		"repack_id",
		"item_master_id",
		"qty",
		"type",
                "cogs",
                "qty_stock",
                "percent_cogs"
	 }; 
        
	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT
	}; 
        
        public static final int TYPE_INPUT=0;
        public static final int TYPE_OUTPUT=1;
        
	public DbRepackItem(){
	}

	public DbRepackItem(int i) throws CONException { 
		super(new DbRepackItem()); 
	}

	public DbRepackItem(String sOid) throws CONException { 
		super(new DbRepackItem(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbRepackItem(long lOid) throws CONException { 
		super(new DbRepackItem(0)); 
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
		return DB_POS_REPACK_ITEM;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbRepackItem().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		RepackItem repackItem = fetchExc(ent.getOID()); 
		ent = (Entity)repackItem; 
		return repackItem.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((RepackItem) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((RepackItem) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static RepackItem fetchExc(long oid) throws CONException{ 
		try{ 
			RepackItem repackItem = new RepackItem();
			DbRepackItem pstRepackItem = new DbRepackItem(oid); 
			repackItem.setOID(oid);

			repackItem.setRepackId(pstRepackItem.getlong(COL_REPACK_ID));
			repackItem.setItemMasterId(pstRepackItem.getlong(COL_ITEM_MASTER_ID));
			repackItem.setQty(pstRepackItem.getdouble(COL_QTY));
			repackItem.setType(pstRepackItem.getInt(COL_TYPE));
			repackItem.setCogs(pstRepackItem.getdouble(COL_COGS));
                        repackItem.setQtyStock(pstRepackItem.getdouble(COL_QTY_STOCK));
                        repackItem.setPercentCogs(pstRepackItem.getdouble(COL_PERCENT_COGS));

			return repackItem; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRepackItem(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(RepackItem repackItem) throws CONException{ 
		try{ 
			DbRepackItem pstRepackItem = new DbRepackItem(0);

			pstRepackItem.setLong(COL_REPACK_ID, repackItem.getRepackId());
			pstRepackItem.setLong(COL_ITEM_MASTER_ID, repackItem.getItemMasterId());
			pstRepackItem.setDouble(COL_QTY, repackItem.getQty());
			pstRepackItem.setInt(COL_TYPE, repackItem.getType());
			pstRepackItem.setDouble(COL_COGS, repackItem.getCogs());
                        pstRepackItem.setDouble(COL_QTY_STOCK, repackItem.getQtyStock());
                        pstRepackItem.setDouble(COL_PERCENT_COGS, repackItem.getPercentCogs());

			pstRepackItem.insert(); 
			repackItem.setOID(pstRepackItem.getlong(COL_REPACK_ITEM_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRepackItem(0),CONException.UNKNOWN); 
		}
		return repackItem.getOID();
	}

	public static long updateExc(RepackItem repackItem) throws CONException{ 
		try{ 
			if(repackItem.getOID() != 0){ 
				DbRepackItem pstRepackItem = new DbRepackItem(repackItem.getOID());

				pstRepackItem.setLong(COL_REPACK_ID, repackItem.getRepackId());
				pstRepackItem.setLong(COL_ITEM_MASTER_ID, repackItem.getItemMasterId());
				pstRepackItem.setDouble(COL_QTY, repackItem.getQty());
				pstRepackItem.setInt(COL_TYPE, repackItem.getType());
				pstRepackItem.setDouble(COL_COGS, repackItem.getCogs());
                                pstRepackItem.setDouble(COL_QTY_STOCK, repackItem.getQtyStock());
                                pstRepackItem.setDouble(COL_PERCENT_COGS, repackItem.getPercentCogs());

				pstRepackItem.update(); 
				return repackItem.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRepackItem(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbRepackItem pstCostingItem = new DbRepackItem(oid);
			pstCostingItem.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRepackItem(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_POS_REPACK_ITEM; 
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
				RepackItem repackItem = new RepackItem();
				resultToObject(rs, repackItem);
				lists.add(repackItem);
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

	private static void resultToObject(ResultSet rs, RepackItem repackItem){
		try{
			repackItem.setOID(rs.getLong(DbRepackItem.colNames[DbRepackItem.COL_REPACK_ITEM_ID]));
			repackItem.setRepackId(rs.getLong(DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID]));
			repackItem.setItemMasterId(rs.getLong(DbRepackItem.colNames[DbRepackItem.COL_ITEM_MASTER_ID]));
			repackItem.setQty(rs.getDouble(DbRepackItem.colNames[DbRepackItem.COL_QTY]));
			repackItem.setType(rs.getInt(DbRepackItem.colNames[DbRepackItem.COL_TYPE]));
			repackItem.setCogs(rs.getDouble(DbRepackItem.colNames[DbRepackItem.COL_COGS]));
                        repackItem.setQtyStock(rs.getDouble(DbRepackItem.colNames[DbRepackItem.COL_QTY_STOCK]));
                        repackItem.setPercentCogs(rs.getDouble(DbRepackItem.colNames[DbRepackItem.COL_PERCENT_COGS]));
		}catch(Exception e){ }
	}

	public static boolean checkOID(long repackItemId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_POS_REPACK_ITEM + " WHERE " + 
						DbRepackItem.colNames[DbRepackItem.COL_REPACK_ITEM_ID] + " = " + repackItemId;

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
			String sql = "SELECT COUNT("+ DbRepackItem.colNames[DbRepackItem.COL_REPACK_ITEM_ID] + ") FROM " + DB_POS_REPACK_ITEM;
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
        public static void proceedStock(Repack repack){
            Vector temp = DbRepackItem.list(0,0, colNames[COL_REPACK_ID]+"="+repack.getOID(), "");
            if(temp!=null && temp.size()>0){
                for(int i=0; i<temp.size(); i++){
                    RepackItem ri = (RepackItem)temp.get(i);                
                    insertRepackGoods(repack, ri);
                }            
            }

        }
        
        public static void updateItemOutputCogs(Repack repack){
            Vector temp = list(0,1, "repack_id="+repack.getOID()+" and type=1", "");
            if(temp!=null && temp.size()>0){                
                for(int i= 0 ; i< temp.size() ; i++){
                    RepackItem ri = (RepackItem)temp.get(0);
                
                    try{
                        ItemMaster im = DbItemMaster.fetchExc(ri.getItemMasterId());
                        //ItemMaster imold = DbItemMaster.fetchExc(ri.getItemMasterId());
                    
                        im.setCogs(ri.getCogs());                        
                        long oid = DbItemMaster.updateExc(im);
                    
                        if(oid!=0){                        
                            //insert history perubahan cogs khusus untuk produk output/ yang dihasilkan
                            String memo = "Perubahan cogs by repack : "+repack.getNumber()+",Qty : "+JSPFormater.formatNumber(ri.getQty(),"###,###.##")+", cogs :"+JSPFormater.formatNumber(ri.getCogs(),"###,###.##");
                            HistoryUser hisUser = new HistoryUser();
                            hisUser.setUserId(0);
                            hisUser.setEmployeeId(0);
                            hisUser.setRefId(im.getOID());
                            hisUser.setDescription(memo);
                            hisUser.setType(DbHistoryUser.TYPE_COGS_MASTER);
                            hisUser.setDate(new Date());
                            try {
                                DbHistoryUser.insertExc(hisUser);
                            } catch (Exception e) {}
                            //User u = DbUser.fetch(repack.getUserId());
                            //DbItemMaster.insertOperationLog(ri.getItemMasterId(), repack.getUserId(), u.getFullName()+"-Repack Approved", imold, im);
                        }
                    }catch(Exception e){}
                }
            }    
        }
                
        
        public static void insertRepackGoods(Repack re, RepackItem ri){
            
            ItemMaster im = new ItemMaster();            
            //---- keluarkan stock karena pemakaian internal--------            
            try{
                im = DbItemMaster.fetchExc(ri.getItemMasterId());
                Stock stock = new Stock();
                stock.setRepackId(re.getOID());
                stock.setRepackItemId(ri.getOID());
                if(ri.getType()==DbRepackItem.TYPE_INPUT){
                    stock.setInOut(DbStock.STOCK_OUT);
                }else if(ri.getType()==DbRepackItem.TYPE_OUTPUT){
                    stock.setInOut(DbStock.STOCK_IN);
                }
                
                stock.setItemBarcode(im.getBarcode());
                stock.setItemCode(im.getCode());
                stock.setItemMasterId(im.getOID());
                stock.setItemName(im.getName());
                stock.setLocationId(re.getLocationId());
                stock.setDate(re.getEffectiveDate());                
                
                //harga ambil harga average terakhir
                stock.setPrice(im.getCogs());
                stock.setTotal(im.getCogs()*ri.getQty());
                
                stock.setQty(ri.getQty());
                stock.setType(DbStock.TYPE_REPACK);
                stock.setUnitId(im.getUomStockId());                
                stock.setUserId(re.getUserId());                
                stock.setRepackId(re.getOID());
                stock.setRepackItemId(ri.getOID());
                stock.setStatus(re.getStatus());
                DbStock.insertExc(stock);
                if(re.getStatus().equals("APPROVED") && stock.getInOut()==DbStock.STOCK_OUT){
                    //checkRequestTransfer(im, re.getLocationId());
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            
        }
        
        
       public static void checkRequestTransfer(ItemMaster im, long locationId){
              
           /*   long itemMasterId = im.getOID();            
              try{
                 DbOrder.deleteOrder(itemMasterId, locationId);
              }catch(Exception ex){}  
              
              if(im.getIsAutoOrder()==1){
                  
                 Location loc = new Location()   ;
                 try{
                     loc = DbLocation.fetchExc(locationId); 
                 }catch(Exception ex){
                 }

                 if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){
                    
                    double minStock = DbStockMin.getStockMinValue(locationId, itemMasterId);
                    
                    if(minStock > 0){

                        double totalStock = DbStock.getItemTotalStock(locationId, itemMasterId);
                        if(totalStock < 0){
                            totalStock = 0;
                        }

                        double totalPoPrev = DbStock.getTotalPo(locationId, itemMasterId);// mencari total po yg masih outstanding
                        double totalRequest = DbOrder.getTotalOrder(locationId, itemMasterId); // qty yg sudah pernah di order dengan status draft   
                        double totalTransferDraft = DbStock.getTotalTransfer(locationId, itemMasterId);//mencari transfer ke lokasi ini yang masih out standing

                        if((totalStock + totalRequest + totalTransferDraft)<=(minStock - im.getDeliveryUnit())){

                            double qtyRequest = 0;
                            if(im.getDeliveryUnit()>0){
                                qtyRequest=(((minStock-(totalRequest+totalStock + totalTransferDraft)))/im.getDeliveryUnit());
                            }
                            qtyRequest=Math.floor(qtyRequest)* im.getDeliveryUnit();

                            if(totalRequest > 0){//jika sebelumnya sudah ada order maka update qtynya dengan sejumlah order yg baru + qty order sebelumna
                                Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + itemMasterId + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + locationId + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                                if(vOrder != null && vOrder.size()>0){
                                    Order odrPrev = (Order)vOrder.get(0);
                                    try{
                                        odrPrev.setQtyOrder(qtyRequest);
                                        odrPrev.setQtyStock((totalStock ));
                                        DbOrder.updateExc(odrPrev);
                                    }catch(Exception ex) {

                                    }
                                }
                            }else{
                            //otomatis buatkan order;
                                try{

                                     int nextCounter;
                                     nextCounter=DbOrder.getNextCounter();

                                     Order order = new Order();
                                     order.setCounter(nextCounter);
                                     order.setPrefixNumber(DbOrder.getNumberPrefix());
                                     order.setNumber(DbOrder.getNextNumber(nextCounter));
                                     order.setQtyOrder(qtyRequest);
                                     order.setDate(new Date());
                                     order.setQtyStock((totalStock + totalRequest));
                                     order.setQtyPoPrev(totalPoPrev);
                                     order.setQtyStandar(minStock);
                                     order.setLocationId(locationId);
                                     order.setItemMasterId(itemMasterId);
                                     order.setStatus("DRAFT");
                                     //order.setDate_proces(new Date()) ;

                                     DbOrder.insertExc(order);

                                 }catch(Exception ex){

                                 }
                            }


                    }else{
                        if((totalStock + totalTransferDraft) >= (minStock - im.getDeliveryUnit())){
                        Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + itemMasterId + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + locationId + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                                if(vOrder != null && vOrder.size()>0){
                                    Order odrPrev = (Order)vOrder.get(0);
                                    try{
                                        odrPrev.setStatus("APPROVED");
                                        DbOrder.updateExc(odrPrev);
                                    }catch(Exception ex) {

                                    }
                                }
                        }else{


                            if(totalRequest!=0){
                                Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + itemMasterId + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + locationId + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                                if(vOrder != null && vOrder.size()>0){
                                    Order odrPrev = (Order)vOrder.get(0);
                                    try{
                                        //jika terjadi perubahan poprev dan standar stock maka update order yg masih draft
                                        if((odrPrev.getQtyPoPrev()!=totalPoPrev) || (odrPrev.getQtyStandar()!=minStock)){

                                            double qtyRequest;

                                            qtyRequest=(((minStock-(totalRequest+totalStock+totalTransferDraft)))/im.getDeliveryUnit());
                                            qtyRequest=Math.floor(qtyRequest)* im.getDeliveryUnit();
                                            if(qtyRequest>0){
                                                odrPrev.setQtyPoPrev(totalPoPrev);
                                                odrPrev.setQtyOrder(qtyRequest);
                                                odrPrev.setQtyStock((totalStock ));
                                                odrPrev.setQtyStandar(minStock);

                                                odrPrev.setDate(new Date());
                                                DbOrder.updateExc(odrPrev);
                                            }
                                        }


                                    }catch(Exception ex) {

                                    }
                                }

                            }

                        }
                    }

                 }//min stock>0

              }//if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){

           }//if(im.getIsAutoOrder()==1){*/
        
        }
        

        public static int deleteAllItem(long oidRepack){        
            int result = 0;
            String sql = "delete from "+DB_POS_REPACK_ITEM+" where "+colNames[COL_REPACK_ID]+" = "+ oidRepack;
            try{
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
                result = -1;
            }

            return result;
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
			  	   RepackItem repackItem = (RepackItem)list.get(ls);
				   if(oid == repackItem.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static double getTotalQty(long repackId, String colNames) {
            CONResultSet dbrs = null;
            double totalQty = 0.0;
            try {
                String sql = "SELECT SUM(" + colNames + ") as TOTALQTY FROM " + DB_POS_REPACK_ITEM + " WHERE " +
                    DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + " = " + repackId;

                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();

                while (rs.next()) {
                    totalQty = rs.getDouble("TOTALQTY");
                }
                rs.close();
            } catch (Exception e) {
                System.out.println("err : " + e.toString());
            } finally {
                CONResultSet.close(dbrs);
                return totalQty;
            }
        }  
}
