/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.session;
import com.project.crm.master.*;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.crm.transaction.DbPembayaran;
import com.project.general.DbCustomer;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.payroll.DbEmployee;
import com.project.simprop.property.DbPaymentSimulation;
import com.project.simprop.property.*;
import com.project.simprop.property.DbSalesData;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class SessReport {

    public static Vector getReportCustomer(long salesId, long customerId, long projectId, long buildingId, long floorId, long lotId, int paymentType){
        
        Vector list = new Vector();
        CONResultSet dbrs = null;
        
        try{
            String sql = "select cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" custId,"+
                    "emp."+DbEmployee.colNames[DbEmployee.COL_NAME]+" empName,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_NAME]+" name,"+                    
                    "cst."+DbCustomer.colNames[DbCustomer.COL_ADDRESS_1]+" address,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_ID_NUMBER]+" idNumber,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_PHONE]+" phone,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_HP]+" hp,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_EMAIL]+" email,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_REG_DATE]+" regDate,"+
                    "prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]+" propId,"+
                    "prop."+DbProperty.colNames[DbProperty.COL_BUILDING_NAME]+" propName,"+
                    "bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_NAME]+" buildingName,"+
                    "fl."+DbFloor.colNames[DbFloor.COL_NAME]+" floorName,"+
                    "lot."+DbLot.colNames[DbLot.COL_NAMA]+" lotName,"+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]+" paymentType, "+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" status "+
                    " from "+DbCustomer.DB_CUSTOMER+" cst inner join "+DbSalesData.DB_SALES_DATA+" sd on cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = sd."+DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]+
                    " inner join "+DbProperty.DB_PROPERTY+" prop on sd."+DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID]+" = prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]
                    +" inner join "+DbBuilding.DB_BUILDING+" bu on sd."+DbSalesData.colNames[DbSalesData.COL_BUILDING_ID]+" = bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_ID]+
                    " inner join "+DbFloor.DB_FLOOR+" fl on sd."+DbSalesData.colNames[DbSalesData.COL_FLOOR_ID]+" = fl."+DbFloor.colNames[DbFloor.COL_FLOOR_ID]+" inner join "+DbLot.DB_LOT+" lot on sd."+DbSalesData.colNames[DbSalesData.COL_LOT_ID]+" = lot."+DbLot.colNames[DbLot.COL_LOT_ID]+
                    " inner join "+DbEmployee.CON_EMPLOYEE+" emp on sd."+DbSalesData.colNames[DbSalesData.COL_USER_ID]+" = emp."+DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID];
                    
            String where = "";
            
            if(salesId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_USER_ID]+" = "+salesId;
            }
            
            if(customerId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]+" = "+customerId;
            }
            
            if(projectId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]+" = "+projectId;
            }
            
            if(buildingId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_ID]+" = "+buildingId;
            }
            
            if(floorId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" fl."+DbFloor.colNames[DbFloor.COL_FLOOR_ID]+" = "+floorId;
            }
            
            if(lotId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" lot."+DbLot.colNames[DbLot.COL_LOT_ID]+" = "+lotId;
            }
            
            if(paymentType != -1){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]+" = "+paymentType;
            }
            
            if(where.length() > 0){
                sql = sql +" where "+where;
            }        
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                RptCustomer rpt = new RptCustomer();
                rpt.setCustomerId(rs.getLong("custId"));
                rpt.setSalesPerson(rs.getString("empName"));
                rpt.setRegDate(rs.getDate("regDate"));
                rpt.setCustomerName(rs.getString("name"));
                rpt.setAlamat(rs.getString("address"));
                rpt.setIdNumber(rs.getString("idNumber"));
                rpt.setPhNumber(rs.getString("phone"));
                rpt.setHp(rs.getString("hp"));                
                rpt.setEmail(rs.getString("email"));
                rpt.setProjectId(rs.getLong("propId"));
                rpt.setProject(rs.getString("propName"));
                rpt.setTower(rs.getString("buildingName"));                
                rpt.setFloor(rs.getString("floorName"));
                rpt.setLot(rs.getString("lotName"));
                rpt.setPaymentType(rs.getInt("paymentType")); 
                rpt.setDataStatus(rs.getInt("status")); 
                
                list.add(rpt);
            }
            
            return list;
            
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    
    public static Vector getReportSales(long salesId, long customerId, long projectId, long buildingId, long floorId, long lotId, int paymentType, int type){
        
        Vector list = new Vector();
        CONResultSet dbrs = null;
        
        try{
            String sql = "select cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" custId,"+                    
                    "emp."+DbEmployee.colNames[DbEmployee.COL_NAME]+" empName,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_NAME]+" name,"+                    
                    "cst."+DbCustomer.colNames[DbCustomer.COL_ADDRESS_1]+" address,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_ID_NUMBER]+" idNumber,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_PHONE]+" phone,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_HP]+" hp,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_EMAIL]+" email,"+                    
                    "prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]+" propId,"+
                    "prop."+DbProperty.colNames[DbProperty.COL_BUILDING_NAME]+" propName,"+
                    "bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_NAME]+" buildingName,"+
                    "fl."+DbFloor.colNames[DbFloor.COL_NAME]+" floorName,"+
                    "lot."+DbLot.colNames[DbLot.COL_NAMA]+" lotName,"+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]+" paymentType, "+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_SALES_PRICE]+" amount, "+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_DISCOUNT]+" discount, "+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_PPN]+" vat, "+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_DATE_TRANSACTION]+" regDate, "+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_FINAL_PRICE]+" finalPrice,"+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" status "+    
                    " from "+DbCustomer.DB_CUSTOMER+" cst inner join "+DbSalesData.DB_SALES_DATA+" sd on cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = sd."+DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]+
                    " inner join "+DbProperty.DB_PROPERTY+" prop on sd."+DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID]+" = prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]
                    +" inner join "+DbBuilding.DB_BUILDING+" bu on sd."+DbSalesData.colNames[DbSalesData.COL_BUILDING_ID]+" = bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_ID]+
                    " inner join "+DbFloor.DB_FLOOR+" fl on sd."+DbSalesData.colNames[DbSalesData.COL_FLOOR_ID]+" = fl."+DbFloor.colNames[DbFloor.COL_FLOOR_ID]+" inner join "+DbLot.DB_LOT+" lot on sd."+DbSalesData.colNames[DbSalesData.COL_LOT_ID]+" = lot."+DbLot.colNames[DbLot.COL_LOT_ID]+
                    " inner join "+DbEmployee.CON_EMPLOYEE+" emp on sd."+DbSalesData.colNames[DbSalesData.COL_USER_ID]+" = emp."+DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID]+
                    " inner join "+DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" inv on sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+" = inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID];
                    
            String where = "";
            
            if(salesId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_USER_ID]+" = "+salesId;
            }
            
            if(customerId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]+" = "+customerId;
            }
            
            if(projectId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]+" = "+projectId;
            }
            
            if(buildingId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_ID]+" = "+buildingId;
            }
            
            if(floorId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" fl."+DbFloor.colNames[DbFloor.COL_FLOOR_ID]+" = "+floorId;
            }
            
            if(lotId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" lot."+DbLot.colNames[DbLot.COL_LOT_ID]+" = "+lotId;
            }
            
            if(paymentType != -1){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]+" = "+paymentType;
            }
            
            if(type == 1){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" < '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd")+"' ";
            }
            
            if(where.length() > 0){
                sql = sql +" where "+where;
            }        
            
            sql = sql + " group by sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID];            
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()){
                
                RptCustomer rpt = new RptCustomer();
                rpt.setCustomerId(rs.getLong("custId"));
                rpt.setSalesPerson(rs.getString("empName"));
                rpt.setRegDate(rs.getDate("regDate"));
                rpt.setCustomerName(rs.getString("name"));
                rpt.setAlamat(rs.getString("address"));
                rpt.setIdNumber(rs.getString("idNumber"));
                rpt.setPhNumber(rs.getString("phone"));
                rpt.setHp(rs.getString("hp"));                
                rpt.setEmail(rs.getString("email"));
                rpt.setProjectId(rs.getLong("propId"));
                rpt.setProject(rs.getString("propName"));
                rpt.setTower(rs.getString("buildingName"));                
                rpt.setFloor(rs.getString("floorName"));
                rpt.setLot(rs.getString("lotName"));
                rpt.setPaymentType(rs.getInt("paymentType")); 
                rpt.setDataStatus(rs.getInt("status"));                 
                rpt.setAmount(rs.getDouble("amount"));
                rpt.setDiscount(rs.getDouble("discount"));
                rpt.setVat(rs.getDouble("vat"));
                rpt.setFinalPrice(rs.getDouble("finalPrice"));
                
                list.add(rpt);
            }
            
            return list;
            
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    
    public static Vector getReportPayment(long salesId, long customerId, long projectId, long buildingId, long floorId, long lotId, int paymentType, int ignore, Date startDate, Date endDate,int type){
        
        Vector list = new Vector();
        CONResultSet dbrs = null;
        
        try{
            String sql = "select cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" custId,"+
                    "emp."+DbEmployee.colNames[DbEmployee.COL_NAME]+" empName,"+
                    "cst."+DbCustomer.colNames[DbCustomer.COL_NAME]+" name,"+                                        
                    "prop."+DbProperty.colNames[DbProperty.COL_BUILDING_NAME]+" propName,"+
                    "bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_NAME]+" buildingName,"+
                    "fl."+DbFloor.colNames[DbFloor.COL_NAME]+" floorName,"+
                    "lot."+DbLot.colNames[DbLot.COL_NAMA]+" lotName,"+                       
                    "sd."+DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]+" paymentType, "+
                    "sd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" status, "+
                    "inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]+" stiOid, "+
                    "inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" invTanggal, "+
                    "inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER]+" invNomor, "+
                    "inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_KETERANGAN]+" invKet, "+
                    "inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]+" invJum, "+
                    "pemb."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" pembTanggal, "+
                    "pemb."+DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]+" pembNo, "+
                    "pemb."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+" pembAmount "+
                    " from "+DbCustomer.DB_CUSTOMER+" cst inner join "+DbSalesData.DB_SALES_DATA+" sd on cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = sd."+DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]+
                    " inner join "+DbProperty.DB_PROPERTY+" prop on sd."+DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID]+" = prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]+
                    " inner join "+DbBuilding.DB_BUILDING+" bu on sd."+DbSalesData.colNames[DbSalesData.COL_BUILDING_ID]+" = bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_ID]+
                    " inner join "+DbFloor.DB_FLOOR+" fl on sd."+DbSalesData.colNames[DbSalesData.COL_FLOOR_ID]+" = fl."+DbFloor.colNames[DbFloor.COL_FLOOR_ID]+" inner join "+DbLot.DB_LOT+" lot on sd."+DbSalesData.colNames[DbSalesData.COL_LOT_ID]+" = lot."+DbLot.colNames[DbLot.COL_LOT_ID]+
                    " inner join "+DbEmployee.CON_EMPLOYEE+" emp on sd."+DbSalesData.colNames[DbSalesData.COL_USER_ID]+" = emp."+DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID]+
                    " inner join "+DbPaymentSimulation.DB_PAYMENT_SIMULATION+" pay on sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+" = pay."+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID]+
                    " inner join "+DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+ " inv on pay."+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT_SIMULATION_ID]+" = inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_SIMULATION_ID]+
                    " inner join "+DbPembayaran.DB_CRM_PEMBAYARAN+" pemb on inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]+" = pemb."+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID];
                    
            String where = "";
            
            if(salesId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_USER_ID]+" = "+salesId;
            }
            
            if(customerId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]+" = "+customerId;
            }
            
            if(projectId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]+" = "+projectId;
            }
            
            if(buildingId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" bu."+DbBuilding.colNames[DbBuilding.COL_BUILDING_ID]+" = "+buildingId;
            }
            
            if(floorId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" fl."+DbFloor.colNames[DbFloor.COL_FLOOR_ID]+" = "+floorId;
            }
            
            if(lotId != 0){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" lot."+DbFloor.colNames[DbLot.COL_LOT_ID]+" = "+lotId;
            }
            
            if(paymentType != -1){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" sd."+DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]+" = "+paymentType;
            }
            
            if(ignore != 1){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" pemb."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(startDate,"yyyy-MM-dd")+"' and pemb."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(endDate,"yyyy-MM-dd")+"' ";
            }
            
            if(type == 1){
                if(where.length() > 0){
                    where = where +" and ";
                }
                where = where +" inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" < '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd")+"' ";
            }
            
            if(where.length() > 0){
                sql = sql +" where "+where;
            }        
            
            sql = sql + " order by inv."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID];
            
            System.out.println("RPT Payment : "+sql);
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                
                RptPayment rpt = new RptPayment();
                
                rpt.setSalesPerson(rs.getString("empName"));                
                rpt.setCustomer(rs.getString("name"));
                rpt.setProperty(rs.getString("propName"));
                rpt.setTower(rs.getString("buildingName"));
                rpt.setFloor(rs.getString("floorName"));
                rpt.setLot(rs.getString("lotName"));
                rpt.setInvoiceId(rs.getLong("stiOid"));
                rpt.setInvDate(rs.getDate("invTanggal"));
                rpt.setInvNo(rs.getString("invNomor"));
                rpt.setInvDesc(rs.getString("invKet"));
                rpt.setInvAmount(rs.getDouble("invJum"));
                rpt.setPaymentDate(rs.getDate("pembTanggal"));                
                rpt.setPaymentNo(rs.getString("pembNo"));
                rpt.setPaymentAmount(rs.getDouble("pembAmount"));
                
                list.add(rpt);
            }
            
            return list;
            
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    
    public static Vector getReportSaldoPiutang(){
        
        Vector list = new Vector();
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "select cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" cstId ,cst."+DbCustomer.colNames[DbCustomer.COL_NAME]+" name"+
                    ",sum(st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]+") tot "+ 
                    " from "+                    
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" st inner join "+DbCustomer.DB_CUSTOMER+" cst on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                    " inner join " +
                    DbSalesData.DB_SALES_DATA+" psd on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+" = psd."+
                    DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+" where psd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" != "+DbSalesData.STATUS_CANCEL+
                    " group by cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];
            
            System.out.println("RPT Saldo Piutang : "+sql);
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                
                RptPiutang rpt = new RptPiutang();
                rpt.setCustomerId(rs.getLong("cstId"));
                rpt.setName(rs.getString("name"));                
                rpt.setInvoice(rs.getDouble("tot"));
                
                double payment = getReportPayment(rpt.getCustomerId());
                rpt.setPayment(payment);
                
                
                list.add(rpt);
            }
            
            return list;
            
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    public static RptPiutang getReportSaldoPiutangCurrent(long customerId,Date start){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "select cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" cstId ,cst."+DbCustomer.colNames[DbCustomer.COL_NAME]+" name"+
                    ",sum(st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]+") tot from "+
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" st inner join "+DbCustomer.DB_CUSTOMER+" cst on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                    " where st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = 0 and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId+" group by cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                
                RptPiutang rpt = new RptPiutang();
                rpt.setCustomerId(rs.getLong("cstId"));
                rpt.setName(rs.getString("name"));                
                rpt.setInvoice(rs.getDouble("tot"));                
                double payment = getReportPayment(rpt.getCustomerId(),start);
                rpt.setPayment(payment);
                return rpt;
                
            }
            
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return new RptPiutang();
    }
    
    
    public static RptPiutang getReportSaldoPiutangMore(long customerId,Date start){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "select cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" cstId ,cst."+DbCustomer.colNames[DbCustomer.COL_NAME]+" name"+
                    ",sum(st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]+") tot from "+
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" st inner join "+DbCustomer.DB_CUSTOMER+" cst on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                    " where st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = 0 and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId+" group by cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                
                RptPiutang rpt = new RptPiutang();
                rpt.setCustomerId(rs.getLong("cstId"));
                rpt.setName(rs.getString("name"));                
                rpt.setInvoice(rs.getDouble("tot"));                
                double payment = getReportPaymentMore(rpt.getCustomerId(),start);
                rpt.setPayment(payment);
                return rpt;
                
            }
            
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return new RptPiutang();
    }
    
    
    
    public static RptPiutang getReportSaldoPiutangCurrent(long customerId,Date start,Date end){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "select cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" cstId ,cst."+DbCustomer.colNames[DbCustomer.COL_NAME]+" name"+
                    ",sum(st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]+") tot from "+
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" st inner join "+DbCustomer.DB_CUSTOMER+" cst on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                    " where st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = 0 and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" between '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"' and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId+" group by cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                
                RptPiutang rpt = new RptPiutang();
                rpt.setCustomerId(rs.getLong("cstId"));
                rpt.setName(rs.getString("name"));                
                rpt.setInvoice(rs.getDouble("tot"));                
                double payment = getReportPayment(rpt.getCustomerId(),start,end);
                rpt.setPayment(payment);
                return rpt;
                
            }
            
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return new RptPiutang();
    }
    
    public static double getReportPayment(long customerId,Date start,Date end){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "select sum(pem."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+") tot from "+
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" st inner join "+DbCustomer.DB_CUSTOMER+" cst on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                    " left join "+DbPembayaran.DB_CRM_PEMBAYARAN+" pem on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]+" = pem."+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+
                    " where st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = 0 and cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = "+customerId+" and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" between '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"' group by cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {                
                double payment = rs.getDouble("tot");
                return payment;
            }
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return 0;
    }
    
    public static double getReportPayment(long customerId,Date start){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "select sum(pem."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+") tot from "+
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" st inner join "+DbCustomer.DB_CUSTOMER+" cst on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                    " left join "+DbPembayaran.DB_CRM_PEMBAYARAN+" pem on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]+" = pem."+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+
                    " where st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = 0 and cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = "+customerId+" and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' group by cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {                
                double payment = rs.getDouble("tot");
                return payment;
            }
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return 0;
    }
    
    public static double getReportPaymentMore(long customerId,Date start){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "select sum(pem."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+") tot from "+
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" st inner join "+DbCustomer.DB_CUSTOMER+" cst on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                    " left join "+DbPembayaran.DB_CRM_PEMBAYARAN+" pem on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]+" = pem."+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+
                    " where st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = 0 and cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = "+customerId+" and st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' group by cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {                
                double payment = rs.getDouble("tot");
                return payment;
            }
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return 0;
    }
    
    public static double getReportPayment(long customerId){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "select sum(pem."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+") tot from "+
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" st inner join "+DbCustomer.DB_CUSTOMER+" cst on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+
                    " left join "+DbPembayaran.DB_CRM_PEMBAYARAN+" pem on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]+" = pem."+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+
                    " inner join " +
                    DbSalesData.DB_SALES_DATA+" psd on st."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+" = psd."+
                    DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+
                    " where psd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" != "+DbSalesData.STATUS_CANCEL+ " and cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]+" = "+customerId+" group by cst."+DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {                
                double payment = rs.getDouble("tot");
                return payment;
            }
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return 0;
    }
    
    
    public static Vector getAging(){
        
        try{
            
            Vector vInvoice = DbSewaTanahInvoice.list(0, 0, DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = 0 group by "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID], null );
            
            if(vInvoice != null && vInvoice.size() > 0){
                
                Date dtNowA = new Date();
                
                Date dtNowB = (Date)dtNowA.clone();
                dtNowB.setDate(dtNowB.getDate()-30);
                
                Date dtNow30A = (Date)dtNowA.clone();
                dtNow30A.setDate(dtNow30A.getDate()+1);
                Date dtNow30B = (Date)dtNowA.clone();
                dtNow30B.setDate(dtNow30B.getDate()+30);
                
                Date dtNow60A = (Date)dtNowA.clone();
                dtNow60A.setDate(dtNow60A.getDate()+31);
                Date dtNow60B = (Date)dtNowA.clone();
                dtNow60B.setDate(dtNow60B.getDate()+60);

                //Over 90 =>  '61-90'
                Date dtNow90A = (Date)dtNowA.clone();
                dtNow90A.setDate(dtNow90A.getDate()+61);
                Date dtNow90B = (Date)dtNowA.clone();
                dtNow90B.setDate(dtNow90B.getDate()+90);
        
                //Over 120 =>  '90+'
                Date dtNow120A = (Date)dtNowA.clone();
                dtNow120A.setDate(dtNow120A.getDate()+91);
                
                Vector result = new Vector();
                
                for(int i = 0 ; i < vInvoice.size() ; i++){                
                    
                    SewaTanahInvoice inv = (SewaTanahInvoice)vInvoice.get(i);                    
                    RptPiutang rpt = getReportSaldoPiutangCurrent(inv.getSaranaId(),dtNowA);
                    
                    RptAging rptAging  = new RptAging();
                    rptAging.setCustomerId(inv.getSaranaId());
                    double amountCurr = rpt.getInvoice() - rpt.getPayment();
                    rptAging.setAmountCurrentDay(amountCurr);   
                    
                    RptPiutang rpt30 = getReportSaldoPiutangCurrent(inv.getSaranaId(),dtNow30A,dtNow30B);
                    double amount30 = rpt30.getInvoice() - rpt30.getPayment();
                    rptAging.setAmountOv1(amount30);
                    
                    RptPiutang rpt60 = getReportSaldoPiutangCurrent(inv.getSaranaId(),dtNow60A,dtNow60B);
                    double amount60 = rpt60.getInvoice() - rpt60.getPayment();
                    rptAging.setAmountOv2(amount60);
                    
                    RptPiutang rpt90 = getReportSaldoPiutangCurrent(inv.getSaranaId(),dtNow90A,dtNow90B);
                    double amount90 = rpt90.getInvoice() - rpt90.getPayment();
                    rptAging.setAmountOv3(amount90);
                    
                    RptPiutang rpt120 = getReportSaldoPiutangMore(inv.getSaranaId(),dtNow120A);
                    double amount120 = rpt120.getInvoice() - rpt120.getPayment();
                    rptAging.setAmountOv4(amount120);
                    
                    result.add(rptAging);
                 
                }
                
                return result;
            }
            
        }catch(Exception e){}
        
        return null;
    }
    
    public static int countMax(int type,long customerId){
        
        CONResultSet dbrs = null;
        
        try{
            String sql = "select sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+" salesId,count(ps."+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID]+") tot from "+DbSalesData.DB_SALES_DATA+" sd inner join "+DbPaymentSimulation.DB_PAYMENT_SIMULATION+" ps on sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+" = ps."+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID]+" where sd."+DbSalesData.colNames[DbSalesData.COL_PAYMENT_TYPE]+" = "+type+" and ps."+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT]+"="+DbPaymentSimulation.PAYMENT_DP+" and ps."+DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS]+"="+DbPaymentSimulation.STATUS_LUNAS;
                    
            if(customerId != 0){
                sql = sql + " and sd."+DbSalesData.colNames[DbSalesData.COL_CUSTOMER_ID]+" = "+customerId;
            }
                    
            sql = sql +" group by sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+" order by tot desc";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {                
                int payment = rs.getInt("tot");
                return payment;
            }
         } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return 0;
        
    }
    
    public static double amountPayment(long psId){
        CONResultSet dbrs = null;
        try{
            String sql = "select pemb."+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+" from "+DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" sti inner join "+DbPembayaran.DB_CRM_PEMBAYARAN+" pemb on sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]+" = pemb."+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+" where sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_SIMULATION_ID]+" = "+psId;
            
            double tmp = 0;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {                
                tmp = tmp + rs.getInt(1);
                
            }
            return tmp;
        }catch(Exception e){}         
        return 0;
    }
    
}
