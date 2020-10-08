/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.session;

import com.project.crm.sewa.DbSewaTanahInvoice;
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
import com.project.simprop.property.DbSalesData;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class SessPayment {

    public static Vector getArchives(long customerId, int type, Date start, Date end, long empId, long propertyId, long buildingId, long floorId, long lotTypeId) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {

            String where = "";

            if (customerId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + " = " + customerId;
            }

            if (empId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " emp." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID] + " = " + empId;
            }

            if (type == 1) {

                Date currDt = new Date();
                Date startDate = currDt;
                Date endDate = currDt;

                if (where.length() > 0) {
                    where = where + " and ";
                }
                
                where = where + " pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " <= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";

            } else if (type == 2) {
                Date currDt = new Date();
                int month = currDt.getMonth() + 1;
                int year = currDt.getYear() + 1900;
               
                if (where.length() > 0) {
                    where = where + " and ";
                }                
                where = where + " month(pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + ") = " + month + " and year(pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + ") = " + year;

            } else if (type == 3) {
               
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " pem."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " >= '" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "' and pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " <= '" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "'";

            }
            
            if(propertyId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID]+" = "+propertyId;
            }
            
            if(buildingId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_BUILDING_ID]+" = "+buildingId;
            }
            
            if(floorId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_FLOOR_ID]+" = "+floorId;
            }
            
            if(lotTypeId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_LOT_TYPE_ID]+" = "+lotTypeId;
            }

            String sql = "select inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID] + " as stiId, " +
                    "inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER] + " as number, " +
                    "inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_KETERANGAN] + " as keterangan, " +
                    "cst." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as nameCst, " +
                    "inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + " as tanggal, " +
                    "inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH] + " as jumlah, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID] + " as pembId, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_NO_BKM] + " as noBkm, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " as pemTanggal, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_JUMLAH] + " as pemJumlah, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_CREATE_BY_ID] + " as createId, " +
                    "emp." + DbEmployee.colNames[DbEmployee.COL_NAME] + " as empName from " +
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE + " inv inner join " + DbPembayaran.DB_CRM_PEMBAYARAN + " pem on inv." +
                    DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID] + " = pem." + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] +
                    " inner join " + DbCustomer.DB_CUSTOMER + " cst on inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + " = cst." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] +
                    " inner join " + DbEmployee.CON_EMPLOYEE + " emp on pem." + DbPembayaran.colNames[DbPembayaran.COL_CREATE_BY_ID] + " = emp." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID]+
                    " inner join " + DbPaymentSimulation.DB_PAYMENT_SIMULATION + " ps on inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_SIMULATION_ID] + " = ps." + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT_SIMULATION_ID]+
                    " inner join " + DbSalesData.DB_SALES_DATA + " sd on ps." + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID] + " = sd." + DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID];                    

            if(where.length() > 0){
                sql = sql +" where "+where;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PaymentArchives paymentArchives = new PaymentArchives();
                paymentArchives.setInvOid(rs.getLong("stiId"));
                paymentArchives.setInvNumber(rs.getString("number"));
                paymentArchives.setInvDescription(rs.getString("keterangan"));
                paymentArchives.setInvCustomer(rs.getString("nameCst"));
                paymentArchives.setInvDueDate(rs.getDate("tanggal"));
                paymentArchives.setInvAmount(rs.getDouble("jumlah"));
                paymentArchives.setPembId(rs.getLong("pembId"));
                paymentArchives.setPemNumber(rs.getString("noBkm"));
                paymentArchives.setPemDate(rs.getDate("pemTanggal"));
                paymentArchives.setPemAmount(rs.getDouble("pemJumlah"));
                paymentArchives.setEmpName(rs.getString("empName"));
                paymentArchives.setUserId(rs.getLong("createId"));

                lists.add(paymentArchives);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    
    public static Vector getArchives(int limitStart, int recordToGet, long customerId, int type, Date start, Date end, long empId, long propertyId, long buildingId, long floorId, long lotTypeId) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {

            String where = "";

            if (customerId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + " = " + customerId;
            }

            if (empId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " emp." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID] + " = " + empId;
            }

            if (type == 1) {

                Date currDt = new Date();
                Date startDate = currDt;
                Date endDate = currDt;

                if (where.length() > 0) {
                    where = where + " and ";
                }
                
                where = where + " pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " <= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";

            } else if (type == 2) {
                Date currDt = new Date();
                int month = currDt.getMonth() + 1;
                int year = currDt.getYear() + 1900;
               
                if (where.length() > 0) {
                    where = where + " and ";
                }                
                where = where + " month(pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + ") = " + month + " and year(pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + ") = " + year;

            } else if (type == 3) {
               
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " pem."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " >= '" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "' and pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " <= '" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "'";

            }
            
            if(propertyId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID]+" = "+propertyId;
            }
            
            if(buildingId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_BUILDING_ID]+" = "+buildingId;
            }
            
            if(floorId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_FLOOR_ID]+" = "+floorId;
            }
            
            if(lotTypeId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_LOT_TYPE_ID]+" = "+lotTypeId;
            }

            String sql = "select inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID] + " as stiId, " +
                    "inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER] + " as number, " +
                    "inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_KETERANGAN] + " as keterangan, " +
                    "cst." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as nameCst, " +
                    "inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + " as tanggal, " +
                    "inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH] + " as jumlah, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID] + " as pembId, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_NO_BKM] + " as noBkm, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " as pemTanggal, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_JUMLAH] + " as pemJumlah, " +
                    "pem." + DbPembayaran.colNames[DbPembayaran.COL_CREATE_BY_ID] + " as createId, " +
                    "emp." + DbEmployee.colNames[DbEmployee.COL_NAME] + " as empName from " +
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE + " inv inner join " + DbPembayaran.DB_CRM_PEMBAYARAN + " pem on inv." +
                    DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID] + " = pem." + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] +
                    " inner join " + DbCustomer.DB_CUSTOMER + " cst on inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + " = cst." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] +
                    " inner join " + DbEmployee.CON_EMPLOYEE + " emp on pem." + DbPembayaran.colNames[DbPembayaran.COL_CREATE_BY_ID] + " = emp." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID]+
                    " inner join " + DbPaymentSimulation.DB_PAYMENT_SIMULATION + " ps on inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_SIMULATION_ID] + " = ps." + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT_SIMULATION_ID]+
                    " inner join " + DbSalesData.DB_SALES_DATA + " sd on ps." + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID] + " = sd." + DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID];                    

            if(where.length() > 0){
                sql = sql +" where "+where;
            }
            
            sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PaymentArchives paymentArchives = new PaymentArchives();
                paymentArchives.setInvOid(rs.getLong("stiId"));
                paymentArchives.setInvNumber(rs.getString("number"));
                paymentArchives.setInvDescription(rs.getString("keterangan"));
                paymentArchives.setInvCustomer(rs.getString("nameCst"));
                paymentArchives.setInvDueDate(rs.getDate("tanggal"));
                paymentArchives.setInvAmount(rs.getDouble("jumlah"));
                paymentArchives.setPembId(rs.getLong("pembId"));
                paymentArchives.setPemNumber(rs.getString("noBkm"));
                paymentArchives.setPemDate(rs.getDate("pemTanggal"));
                paymentArchives.setPemAmount(rs.getDouble("pemJumlah"));
                paymentArchives.setEmpName(rs.getString("empName"));
                paymentArchives.setUserId(rs.getLong("createId"));

                lists.add(paymentArchives);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    
    public static int getCountArchives( long customerId, int type, Date start, Date end, long empId, long propertyId, long buildingId, long floorId, long lotTypeId) {
        
        CONResultSet dbrs = null;
        try {

            String where = "";

            if (customerId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + " = " + customerId;
            }

            if (empId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " emp." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID] + " = " + empId;
            }

            if (type == 1) {

                Date currDt = new Date();
                Date startDate = currDt;
                Date endDate = currDt;

                if (where.length() > 0) {
                    where = where + " and ";
                }
                
                where = where + " pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " <= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";

            } else if (type == 2) {
                Date currDt = new Date();
                int month = currDt.getMonth() + 1;
                int year = currDt.getYear() + 1900;
               
                if (where.length() > 0) {
                    where = where + " and ";
                }                
                where = where + " month(pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + ") = " + month + " and year(pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + ") = " + year;

            } else if (type == 3) {
               
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " pem."+DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " >= '" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "' and pem." + DbPembayaran.colNames[DbPembayaran.COL_TANGGAL] + " <= '" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "'";

            }
            
            if(propertyId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_PROPERTY_ID]+" = "+propertyId;
            }
            
            if(buildingId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_BUILDING_ID]+" = "+buildingId;
            }
            
            if(floorId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_FLOOR_ID]+" = "+floorId;
            }
            
            if(lotTypeId != 0){
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + " sd." + DbSalesData.colNames[DbSalesData.COL_LOT_TYPE_ID]+" = "+lotTypeId;
            }

            String sql = "select count(pem." + DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID] + ") from " +
                    DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE + " inv inner join " + DbPembayaran.DB_CRM_PEMBAYARAN + " pem on inv." +
                    DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID] + " = pem." + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] +
                    " inner join " + DbCustomer.DB_CUSTOMER + " cst on inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + " = cst." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] +
                    " inner join " + DbEmployee.CON_EMPLOYEE + " emp on pem." + DbPembayaran.colNames[DbPembayaran.COL_CREATE_BY_ID] + " = emp." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID]+
                    " inner join " + DbPaymentSimulation.DB_PAYMENT_SIMULATION + " ps on inv." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_SIMULATION_ID] + " = ps." + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_PAYMENT_SIMULATION_ID]+
                    " inner join " + DbSalesData.DB_SALES_DATA + " sd on ps." + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID] + " = sd." + DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID];                    

            if(where.length() > 0){
                sql = sql +" where "+where;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
               int sum = rs.getInt(1);
               return sum;
            }
            rs.close();
            

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }
}
