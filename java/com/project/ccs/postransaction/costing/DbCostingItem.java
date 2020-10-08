package com.project.ccs.postransaction.costing; 

import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbStockMin;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.postransaction.order.Order;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;
import com.project.ccs.postransaction.stock.*;
import com.project.general.DbLocation;
import com.project.general.Location;
import java.util.Date;

public class DbCostingItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 
	public static final  String DB_POS_COSTING_ITEM = "pos_costing_item";

	public static final  int COL_COSTING_ITEM_ID = 0;
	public static final  int COL_COSTING_ID = 1;
	public static final  int COL_ITEM_MASTER_ID = 2;
	public static final  int COL_QTY = 3;
	public static final  int COL_PRICE = 4;
	public static final  int COL_AMOUNT = 5;       
        
	public static final  String[] colNames = {
		"costing_item_id",
		"costing_id",
		"item_master_id",
		"qty",
		"price",
                "amount"
	 }; 
        
	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
                TYPE_FLOAT
	 }; 

	public DbCostingItem(){
	}

	public DbCostingItem(int i) throws CONException { 
		super(new DbCostingItem()); 
	}

	public DbCostingItem(String sOid) throws CONException {             
		super(new DbCostingItem(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCostingItem(long lOid) throws CONException { 
		super(new DbCostingItem(0)); 
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
		return DB_POS_COSTING_ITEM;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCostingItem().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		CostingItem costingitem = fetchExc(ent.getOID()); 
		ent = (Entity)costingitem; 
		return costingitem.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((CostingItem) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((CostingItem) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static CostingItem fetchExc(long oid) throws CONException{ 
		try{ 
			CostingItem costingitem = new CostingItem();
			DbCostingItem pstCostingItem = new DbCostingItem(oid); 
			costingitem.setOID(oid);

			costingitem.setCostingId(pstCostingItem.getlong(COL_COSTING_ID));
			costingitem.setItemMasterId(pstCostingItem.getlong(COL_ITEM_MASTER_ID));
			costingitem.setQty(pstCostingItem.getdouble(COL_QTY));
			costingitem.setPrice(pstCostingItem.getdouble(COL_PRICE));
			costingitem.setAmount(pstCostingItem.getdouble(COL_AMOUNT));

			return costingitem; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCostingItem(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(CostingItem costingitem) throws CONException{ 
		try{ 
			DbCostingItem pstCostingItem = new DbCostingItem(0);

			pstCostingItem.setLong(COL_COSTING_ID, costingitem.getCostingId());
			pstCostingItem.setLong(COL_ITEM_MASTER_ID, costingitem.getItemMasterId());
			pstCostingItem.setDouble(COL_QTY, costingitem.getQty());
			pstCostingItem.setDouble(COL_PRICE, costingitem.getPrice());
			pstCostingItem.setDouble(COL_AMOUNT, costingitem.getAmount());

			pstCostingItem.insert(); 
			costingitem.setOID(pstCostingItem.getlong(COL_COSTING_ITEM_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCostingItem(0),CONException.UNKNOWN); 
		}
		return costingitem.getOID();
	}

	public static long updateExc(CostingItem costingitem) throws CONException{ 
		try{ 
			if(costingitem.getOID() != 0){ 
				DbCostingItem pstCostingItem = new DbCostingItem(costingitem.getOID());

				pstCostingItem.setLong(COL_COSTING_ID, costingitem.getCostingId());
				pstCostingItem.setLong(COL_ITEM_MASTER_ID, costingitem.getItemMasterId());
				pstCostingItem.setDouble(COL_QTY, costingitem.getQty());
				pstCostingItem.setDouble(COL_PRICE, costingitem.getPrice());
				pstCostingItem.setDouble(COL_AMOUNT, costingitem.getAmount());

				pstCostingItem.update(); 
				return costingitem.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCostingItem(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCostingItem pstCostingItem = new DbCostingItem(oid);
			pstCostingItem.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCostingItem(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_POS_COSTING_ITEM; 
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
				CostingItem costingitem = new CostingItem();
				resultToObject(rs, costingitem);
				lists.add(costingitem);
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

	private static void resultToObject(ResultSet rs, CostingItem costingitem){
		try{
			costingitem.setOID(rs.getLong(DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID]));
			costingitem.setCostingId(rs.getLong(DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID]));
			costingitem.setItemMasterId(rs.getLong(DbCostingItem.colNames[DbCostingItem.COL_ITEM_MASTER_ID]));
			costingitem.setQty(rs.getDouble(DbCostingItem.colNames[DbCostingItem.COL_QTY]));
			costingitem.setPrice(rs.getDouble(DbCostingItem.colNames[DbCostingItem.COL_PRICE]));
			costingitem.setAmount(rs.getDouble(DbCostingItem.colNames[DbCostingItem.COL_AMOUNT]));                        
		}catch(Exception e){ }
	}

	public static boolean checkOID(long costingItemId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_POS_COSTING_ITEM + " WHERE " + 
						DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID] + " = " + costingItemId;

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
			String sql = "SELECT COUNT("+ DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID] + ") FROM " + DB_POS_COSTING_ITEM;
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
        public static void proceedStock(Costing costing){
        
            Vector temp = DbCostingItem.list(0,0, colNames[COL_COSTING_ID]+"="+costing.getOID(), "");

            if(temp!=null && temp.size()>0){
                for(int i=0; i<temp.size(); i++){
                    CostingItem ci = (CostingItem)temp.get(i);                
                    insertCostingGoods(costing, ci);                
                } 
                
                //proses transfer
                for(int i=0; i<temp.size(); i++){
                    CostingItem ci = (CostingItem)temp.get(i); 
                    ItemMaster im = new ItemMaster();
                    try{
                        im = DbItemMaster.fetchExc(ci.getOID());
                    }
                    catch(Exception e){
                    }
                    checkRequestTransfer(im, costing.getLocationId());
                }
            }

        }
        
        public static void insertCostingGoods(Costing cos, CostingItem ci){
            
            ItemMaster im = new ItemMaster();
            //Uom uom = new Uom();
            
            //---- keluarkan stock karena pemakaian internal--------
            
            try{
                
                System.out.println("inserting new stock . --- ^_^ --..");
                
                im = DbItemMaster.fetchExc(ci.getItemMasterId());
                //uom = DbUom.fetchExc(im.getUomStockId());
                
                Stock stock = new Stock();
                stock.setCostingId(cos.getOID());
                stock.setCostingItemId(ci.getOID());
                stock.setInOut(DbStock.STOCK_OUT);
                stock.setItemBarcode(im.getBarcode());
                stock.setItemCode(im.getCode());
                stock.setItemMasterId(im.getOID());
                stock.setItemName(im.getName());
                stock.setLocationId(cos.getLocationId());
                //stock.setDate(cos.getDate());
                stock.setDate(cos.getEffectiveDate());
                //stock.setNoFaktur(rec.getNumber());
                
                //harga ambil harga average terakhir
                stock.setPrice(im.getCogs());
                stock.setTotal(im.getCogs()*ci.getQty());
                
                stock.setQty(ci.getQty());
                stock.setType(DbStock.TYPE_COSTING);
                stock.setUnitId(im.getUomStockId());
                //stock.setUnit(uom.getUnit());
                stock.setUserId(cos.getUserId());
                stock.setStatus(cos.getStatus());
                
                long oid = DbStock.insertExc(stock);
                
                if(oid!=0){
                    System.out.println("inserting new stock ... success ------  ");
                }
                else{
                    System.out.println("inserting new stock ... failed ---#$#$#$#$#---  ");
                }
                
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            
        }
                
        public static void checkRequestTransfer(ItemMaster im, long locationId){
              
              System.out.println("checkRequestTransfer for costing ------");
              
              //ItemMaster im = new ItemMaster();
              //try{
              //   im= DbItemMaster.fetchExc(itemMasterId);
              //}catch(Exception ex){

              //}
              
              long itemMasterId = im.getOID();
            
              try{
                 DbOrder.deleteOrder(itemMasterId, locationId);
              }catch(Exception ex){
              }  
              
              if(im.getIsAutoOrder()==1){
                  
                 Location loc = new Location()   ;
                 try{
                     loc = DbLocation.fetchExc(locationId); 
                 }catch(Exception ex){
                 }

                 if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){
                    
                    double minStock = DbStockMin.getStockMinValue(locationId, itemMasterId);
                    
                    //try{
                    //    DbOrder.deleteOrder(itemMasterId, locationId);
                    //}catch(Exception ex){
                    //}   
                    
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
                                     
                                     System.out.println("checkRequestTransfer sucess------");

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

           }//if(im.getIsAutoOrder()==1){
        
           System.out.println("checkRequestTransfer for costing ---finish---");   
              
        }

        public static int deleteAllItem(long oidCosting){
        
            int result = 0;

            String sql = "delete from "+DB_POS_COSTING_ITEM+" where "+colNames[COL_COSTING_ID]+" = "+ oidCosting;
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
			  	   CostingItem costingitem = (CostingItem)list.get(ls);
				   if(oid == costingitem.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static double getTotalQty(long costingId, String colNames) {
            CONResultSet dbrs = null;
            double totalQty = 0.0;
            try {
                String sql = "SELECT SUM(" + colNames + ") as TOTALQTY FROM " + DB_POS_COSTING_ITEM + " WHERE " +
                    DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID] + " = " + costingId;

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
