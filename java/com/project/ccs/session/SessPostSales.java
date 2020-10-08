/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.I_Project;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.posmaster.DbItemGroup;
import java.io.*;
import java.sql.*;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbShift;
import com.project.ccs.posmaster.Shift;
import com.project.ccs.postransaction.sales.CreditPayment;
import com.project.ccs.postransaction.sales.DbCreditPayment;
import com.project.ccs.postransaction.sales.DbPayment;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.sales.Payment;
import com.project.ccs.postransaction.sales.Sales;
import com.project.ccs.postransaction.sales.SalesClosingJournal;
import com.project.fms.ar.ARInvoice;
import com.project.fms.ar.ARInvoiceDetail;
import com.project.fms.ar.DbARInvoice;
import com.project.fms.ar.DbARInvoiceDetail;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.transaction.DbGl;
import com.project.general.Bank;
import com.project.general.Company;
import com.project.general.Currency;
import com.project.general.Customer;
import com.project.general.DbBank;
import com.project.general.DbCustomer;
import com.project.general.DbExchangeRate;
import com.project.general.DbLocation;
import com.project.general.DbMerchant;
import com.project.general.DbSalesHistory;
import com.project.general.DbSalesHistory;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.ExchangeRate;
import com.project.general.Location;
import com.project.general.Merchant;
import com.project.general.SalesHistory;
import com.project.general.SystemDocNumber;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author Roy Andika
 */
public class SessPostSales {

    public static Vector getSalesClosing(Date dateTransaction, long locationId, long cashCashierId, int service) {
        CONResultSet dbrs = null;
        try {
            String sql = "select s." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id ,s." + DbSales.colNames[DbSales.COL_NUMBER] + " as number,s." + DbSales.colNames[DbSales.COL_TYPE] + " as type," +
                    "s." + DbSales.colNames[DbSales.COL_NAME] + " as name, s." + DbSales.colNames[DbSales.COL_DATE] + " as date," +
                    "s." + DbSales.colNames[DbSales.COL_BIAYA_KARTU] + " as biaya_kartu, " +
                    "s." + DbSales.colNames[DbSales.COL_DISKON_KARTU] + " as diskon_kartu, " +                    
                    " sum((sd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + ") - sd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " ) as tot , sum(sd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as discount " +
                    " from " + DbSales.DB_SALES + " s inner join " + DbSalesDetail.DB_SALES_DETAIL + " sd on s." + DbSales.colNames[DbSales.COL_SALES_ID] + " = sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " m on sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") = to_days('" + JSPFormater.formatDate(dateTransaction, "yyyy-MM-dd") + "') and m." + DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE] + " = " + service + " and " +
                    " s." + DbSales.colNames[DbSales.COL_STATUS] + " = 0 ";

            if (locationId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (cashCashierId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }

            sql = sql + " group by s." + DbSales.colNames[DbSales.COL_SALES_ID] + " order by s." + DbSales.colNames[DbSales.COL_NUMBER];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector list = new Vector();
            while (rs.next()) {
                TmpPostSales ps = new TmpPostSales();
                ps.setSalesId(rs.getLong("sales_id"));
                ps.setNumber(rs.getString("number"));
                ps.setDate(rs.getDate("date"));
                ps.setName(rs.getString("name"));
                ps.setType(rs.getInt("type"));
                ps.setTotal(rs.getDouble("tot"));
                ps.setDiscount(rs.getDouble("discount"));
                ps.setBiayaKartu(rs.getDouble("biaya_kartu"));
                ps.setDiskonKartu(rs.getDouble("diskon_kartu"));
                list.add(ps);
            }
            rs.close();
            return list;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return new Vector();
    }

    public static Vector getSalesClosingReport(Date dateTransaction, long locationId, long cashCashierId, int service, long userId, int posted) {
        CONResultSet dbrs = null;
        try {
            String sql = "select s." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id ,s." + DbSales.colNames[DbSales.COL_NUMBER] + " as number,s." + DbSales.colNames[DbSales.COL_TYPE] + " as type," +
                    "s." + DbSales.colNames[DbSales.COL_NAME] + " as name, s." + DbSales.colNames[DbSales.COL_DATE] + " as date," +
                    "s." + DbSales.colNames[DbSales.COL_BIAYA_KARTU] + " as biaya_kartu, " +
                    "s." + DbSales.colNames[DbSales.COL_DISKON_KARTU] + " as diskon_kartu, " +
                    " sum((sd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + ") - sd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " ) as tot , sum(sd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as discount " +
                    " from " + DbSales.DB_SALES + " s inner join " + DbSalesDetail.DB_SALES_DETAIL + " sd on s." + DbSales.colNames[DbSales.COL_SALES_ID] + " = sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " m on sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") = to_days('" + JSPFormater.formatDate(dateTransaction, "yyyy-MM-dd") + "') ";

            if (posted != -1) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_STATUS] + " = " + posted;
            }

            if (service != -1) {
                sql = sql + " and m." + DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE] + " = " + service;
            }

            if (locationId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (cashCashierId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }

            if (userId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_USER_ID] + " = " + userId;
            }

            sql = sql + " group by s." + DbSales.colNames[DbSales.COL_SALES_ID] + " order by s." + DbSales.colNames[DbSales.COL_NUMBER];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector list = new Vector();
            while (rs.next()) {
                TmpPostSales ps = new TmpPostSales();
                ps.setSalesId(rs.getLong("sales_id"));
                ps.setNumber(rs.getString("number"));
                ps.setDate(rs.getDate("date"));
                ps.setName(rs.getString("name"));
                ps.setType(rs.getInt("type"));
                ps.setTotal(rs.getDouble("tot"));
                ps.setDiscount(rs.getDouble("discount"));
                ps.setBiayaKartu(rs.getDouble("biaya_kartu"));
                ps.setDiskonKartu(rs.getDouble("diskon_kartu"));
                list.add(ps);
            }
            rs.close();
            return list;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return new Vector();
    }

    public static String getUserSalesClosingReport(Date dateTransaction, long locationId, long cashCashierId, int service) {
        CONResultSet dbrs = null;
        try {
            String sql = "select s." + DbSales.colNames[DbSales.COL_USER_ID] + " as user_id " +
                    " from " + DbSales.DB_SALES + " s inner join " + DbSalesDetail.DB_SALES_DETAIL + " sd on s." + DbSales.colNames[DbSales.COL_SALES_ID] + " = sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " m on sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") = to_days('" + JSPFormater.formatDate(dateTransaction, "yyyy-MM-dd") + "') ";

            if (service != -1) {
                sql = sql + " and m." + DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE] + " = " + service;
            }

            if (locationId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (cashCashierId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }

            sql = sql + " group by s." + DbSales.colNames[DbSales.COL_SALES_ID] + " limit 1";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long userxId = rs.getLong("user_id");
                User user = new User();
                try {
                    user = DbUser.fetch(userxId);
                } catch (Exception e) {
                }
                if (user.getOID() != 0) {
                    return user.getFullName();
                }
            }
            rs.close();

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return "";
    }

    public static Vector getSalesClosingReport(Date dateTransaction, Date dateTo, long locationId, long cashCashierId, int service, long userId, int posted) {
        CONResultSet dbrs = null;
        try {
            String sql = "select s." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id ,s." + DbSales.colNames[DbSales.COL_NUMBER] + " as number,s." + DbSales.colNames[DbSales.COL_TYPE] + " as type," +
                    "s." + DbSales.colNames[DbSales.COL_NAME] + " as name, s." + DbSales.colNames[DbSales.COL_DATE] + " as date," +
                    "s." + DbSales.colNames[DbSales.COL_BIAYA_KARTU] + " as biaya_kartu, " +
                    "s." + DbSales.colNames[DbSales.COL_DISKON_KARTU] + " as diskon_kartu, " +
                    " sum((sd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + ") - sd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " ) as tot , sum(sd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as discount " +
                    " from " + DbSales.DB_SALES + " s inner join " + DbSalesDetail.DB_SALES_DETAIL + " sd on s." + DbSales.colNames[DbSales.COL_SALES_ID] + " = sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] +
                    " inner join " + DbItemMaster.DB_ITEM_MASTER + " m on sd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                    " where to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(dateTransaction, "yyyy-MM-dd") + "') and to_days(s." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(dateTo, "yyyy-MM-dd") + "')";

            if (posted != -1) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_STATUS] + " = " + posted;
            }

            if (service != -1) {
                sql = sql + " and m." + DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE] + " = " + service;
            }

            if (locationId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (cashCashierId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }

            if (userId != 0) {
                sql = sql + " and s." + DbSales.colNames[DbSales.COL_USER_ID] + " = " + userId;
            }

            sql = sql + " group by s." + DbSales.colNames[DbSales.COL_SALES_ID] + " order by s." + DbSales.colNames[DbSales.COL_NUMBER];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector list = new Vector();
            while (rs.next()) {
                TmpPostSales ps = new TmpPostSales();
                ps.setSalesId(rs.getLong("sales_id"));
                ps.setNumber(rs.getString("number"));
                ps.setDate(rs.getDate("date"));
                ps.setName(rs.getString("name"));
                ps.setType(rs.getInt("type"));
                ps.setTotal(rs.getDouble("tot"));
                ps.setDiscount(rs.getDouble("discount"));
                ps.setBiayaKartu(rs.getDouble("biaya_kartu"));
                ps.setDiskonKartu(rs.getDouble("diskon_kartu"));
                list.add(ps);
            }
            rs.close();
            return list;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return new Vector();
    }

    public static Hashtable getPayment(long salesId) {
        CONResultSet dbrs = null;
        try {

            String sql = "select p." + DbPayment.colNames[DbPayment.COL_PAYMENT_ID] + " as payment_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_CURRENCY_ID] + " as currency_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " as pay_type," +
                    " sum(p." + DbPayment.colNames[DbPayment.COL_AMOUNT] + ") as amount," +
                    "p." + DbPayment.colNames[DbPayment.COL_MERCHANT_ID] + " as merchant_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_BANK_ID] + " as bank_id," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_DESCRIPTION] + " as code_merchant," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_COA_ID] + " as coa_id," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_COA_EXPENSE_ID] + " as coa_expense_id," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_PERSEN_EXPENSE] + " as persen_expense," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_COA_DISKON_ID] + " as coa_diskon_id," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_PERSEN_DISKON] + " as persen_diskon," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_PAYMENT_BY] + " as payment_by," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_TYPE_PAYMENT] + " as type_payment " +
                    " from " + DbPayment.DB_PAYMENT + " p left join " + DbMerchant.DB_MERCHANT + " m on p." + DbPayment.colNames[DbPayment.COL_MERCHANT_ID] + " = m." + DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID] +
                    " where p." + DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesId + " group by p." + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " order by p." + DbPayment.colNames[DbPayment.COL_PAY_TYPE];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Hashtable list = new Hashtable();
            while (rs.next()) {
                TmpPayment tp = new TmpPayment();
                int payType = rs.getInt("pay_type");
                tp.setPaymentId(rs.getLong("payment_id"));
                tp.setCurrencyId(rs.getLong("currency_id"));
                tp.setPayType(payType);
                tp.setAmount(rs.getDouble("amount"));
                tp.setMerchantId(rs.getLong("merchant_id"));
                tp.setBankId(rs.getLong("bank_id"));
                tp.setCodeMerchant(rs.getString("code_merchant"));
                tp.setCoaId(rs.getLong("coa_id"));
                tp.setCoaExpenseId(rs.getLong("coa_expense_id"));
                tp.setPersenExpense(rs.getDouble("persen_expense"));
                tp.setCoaDiskonId(rs.getLong("coa_diskon_id"));
                tp.setPersenDiskon(rs.getDouble("persen_diskon"));
                tp.setPaymentBy(rs.getInt("payment_by"));
                tp.setTypePayment(rs.getInt("type_payment"));
                list.put("" + payType, tp);
            }
            return list;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return new Hashtable();
    }

    public static Vector getListPayment(long salesId) {
        CONResultSet dbrs = null;
        try {

            String sql = "select p." + DbPayment.colNames[DbPayment.COL_PAYMENT_ID] + " as payment_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_CURRENCY_ID] + " as currency_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " as pay_type," +
                    "p." + DbPayment.colNames[DbPayment.COL_AMOUNT] + " as amount," +
                    "p." + DbPayment.colNames[DbPayment.COL_COST_CARD_AMOUNT] + " as cost_card," +
                    "p." + DbPayment.colNames[DbPayment.COL_MERCHANT_ID] + " as merchant_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_BANK_ID] + " as bank_id," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_CODE_MERCHANT] + " as code_merchant," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_COA_ID] + " as coa_id," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_COA_EXPENSE_ID] + " as coa_expense_id," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_PERSEN_EXPENSE] + " as persen_expense," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_COA_DISKON_ID] + " as coa_diskon_id," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_PERSEN_DISKON] + " as persen_diskon," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_PAYMENT_BY] + " as payment_by," +
                    "m." + DbMerchant.colNames[DbMerchant.COL_TYPE_PAYMENT] + " as type_payment, " +
                    "m." + DbMerchant.colNames[DbMerchant.COL_POSTING_EXPENSE] + " as posting_expense, " +
                    "m." + DbMerchant.colNames[DbMerchant.COL_PENDAPATAN_MERCHANT] + " as pendapatan_merchant " +
                    " from " + DbPayment.DB_PAYMENT + " p left join " + DbMerchant.DB_MERCHANT + " m on p." + DbPayment.colNames[DbPayment.COL_MERCHANT_ID] + " = m." + DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID] +
                    " where p." + DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesId + " order by p." + DbPayment.colNames[DbPayment.COL_PAY_TYPE];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector list = new Vector();
            while (rs.next()) {
                TmpPayment tp = new TmpPayment();
                int payType = rs.getInt("pay_type");
                tp.setPaymentId(rs.getLong("payment_id"));
                tp.setCurrencyId(rs.getLong("currency_id"));
                tp.setCostCardAmount(rs.getDouble("cost_card"));
                tp.setPayType(payType);
                tp.setAmount(rs.getDouble("amount"));
                tp.setMerchantId(rs.getLong("merchant_id"));
                tp.setBankId(rs.getLong("bank_id"));
                tp.setCodeMerchant(rs.getString("code_merchant"));
                tp.setCoaId(rs.getLong("coa_id"));
                tp.setCoaExpenseId(rs.getLong("coa_expense_id"));
                tp.setPersenExpense(rs.getDouble("persen_expense"));
                tp.setCoaDiskonId(rs.getLong("coa_diskon_id"));
                tp.setPersenDiskon(rs.getDouble("persen_diskon"));
                tp.setPaymentBy(rs.getInt("payment_by"));
                tp.setTypePayment(rs.getInt("type_payment"));
                tp.setPostingExpense(rs.getInt("posting_expense"));
                tp.setPendapatanMerchant(rs.getLong("pendapatan_merchant"));
                list.add(tp);
            }
            return list;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return new Vector();
    }

    public static Vector getNumberDouble(String number) {
        CONResultSet dbrs = null;
        try {

            String sql = "select * from sales_number_double where jumlah > 1 ";
            if (number.length() > 0) {
                sql = sql + " and number like '%" + number + "%'";
            }

            sql = sql + " order by jumlah desc";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector list = new Vector();
            while (rs.next()) {
                Sales s = new Sales();
                s.setNumber(rs.getString("number"));
                s.setAmount(rs.getDouble("jumlah"));
                list.add(s);
            }
            return list;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return new Vector();
    }

    public static void prosesNumberDoule(String number) {
        CONResultSet dbrs = null;
        try {

            String sql = "select sales_id,number,posted_status from pos_sales where number = '" + number + "' order by posted_status desc";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int numb = 0;
            while (rs.next()) {
                long salesId = rs.getLong("sales_id");
                String salesNumber = rs.getString("number");
                int status = rs.getInt("posted_status");

                if (status == 0) {
                    if (numb == 1) {
                        numb = 2;
                    }
                    String newNumber = "";
                    if (numb == 0) {
                        newNumber = salesNumber + "A";
                    } else {
                        newNumber = salesNumber + "A" + numb;
                    }
                    updateNumber(salesId, newNumber);
                    numb++;

                }
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

    }

    public static long updateNumber(long salesId, String number) {

        CONResultSet dbrs = null;
        long oid = 0;
        try {
            String sql = "update pos_sales set number='" + number + "' where sales_id = " + salesId;
            oid = CONHandler.execUpdate(sql);
        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
        return oid;
    }

    public static double getTotalSales(long salesId) {
        CONResultSet dbrs = null;
        double total = 0;
        try {
            String sql = "select sum((" + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * " + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + ") - " + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as total from " + DbSalesDetail.DB_SALES_DETAIL + " where " +
                    DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = " + salesId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                return rs.getDouble("total");
            }

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }
        return total;
    }

    public static void updatePosting(long userId, long docId, long locationId, Date tanggal, long cashCashierId, long periodId) {

        String wherex = "'" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "' between " +
                DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                DbPeriode.colNames[DbPeriode.COL_END_DATE];

        Vector tempEff = DbPeriode.list(0, 0, wherex, "");
        Date effectiveDate = new Date();

        if (tempEff != null && tempEff.size() > 0) {
            effectiveDate = new Date();
        } else {
            Periode per = new Periode();
            if (periodId != 0) {
                try {
                    per = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                    per = DbPeriode.getOpenPeriod();
                }
            }
            effectiveDate = per.getEndDate();
        }

        CONResultSet crs = null;
        try {

            String sql = "UPDATE " + DbSales.DB_SALES + " SET " + DbSales.colNames[DbSales.COL_STATUS] + " = 1," +
                    DbSales.colNames[DbSales.COL_POSTED_STATUS] + " = 1," + DbSales.colNames[DbSales.COL_POSTED_BY_ID] + " = " + userId + ", " +
                    DbSales.colNames[DbSales.COL_EFFECTIVE_DATE] + " = '" + JSPFormater.formatDate(effectiveDate, "yyyy-MM-dd") + " 00:00:00' " +
                    "," + DbSales.colNames[DbSales.COL_POSTED_DATE] + " = '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "' " +
                    "," + DbSales.colNames[DbSales.COL_SYSTEM_DOC_NUMBER_ID] + " = '" + docId + "' where " +
                    DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId + " and " + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId +
                    " and to_days(" + DbSales.colNames[DbSales.COL_DATE] + ") = to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "')";

            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

    }

    public static long postJournal(Vector list, long userId, long periodIdx, Company comp, long locationId, Vector currencys, Date tanggal, long cashCashierId,int param) {

        ExchangeRate er = DbExchangeRate.getStandardRate();
        
        int intervalDue = 7;// default 7 hari jatuh tempo setelah transaksi
        try {
            intervalDue = Integer.parseInt(DbSystemProperty.getValueByName("INTERVAL_DUE_DATE_CREDIT"));
        } catch (Exception e) {}  

        long deffCurrIDR = 0;
        try {
            deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
        } catch (Exception e) {
        }

        Periode periode = new Periode();
        if (periodIdx != 0) {
            try {
                periode = DbPeriode.fetchExc(periodIdx);
            } catch (Exception e) {
            }
        } else {
            try {
                periode = DbPeriode.getPeriodByTransDate(tanggal);
            } catch (Exception e) {
            }
        }

        long segment1_id = 0;
        if (locationId != 0) {
            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + locationId;
            Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
            if (segmentDt != null && segmentDt.size() > 0) {
                SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                if (sd.getRefSegmentDetailId() != 0) {
                    segment1_id = sd.getRefSegmentDetailId();
                } else {
                    segment1_id = sd.getOID();
                }
            }           
        }

        //jika periode sudah closed, maka tidak bisa di posting
        if (periode.getStatus().compareTo("Closed") == 0) {
            return 0;
        }

        Vector ccCredits = new Vector();
        Vector ccDebits = new Vector();
        Vector cashBacks = new Vector();
        Vector transfers = new Vector();
        long oidBiaya = 0;

        double totalCash[];
        totalCash = new double[currencys.size()];

        double subCash = 0;
        double subCard = 0;
        double subDebit = 0;
        double subTransfer = 0;
        double subBon = 0;
        double subDiscount = 0;
        double subRetur = 0;
        double subAmount = 0;
        double subKwitansi = 0;
        
        String operatorName = "";
        String shiftName = "";
        Location l = new Location();        
        try {
            l = DbLocation.fetchExc(locationId);
        } catch (Exception e) {
        }
        String memoPiutang = "";

        for (int k = 0; k < list.size(); k++) {

            SalesClosingJournal salesClosing = (SalesClosingJournal) list.get(k);

            if (k == 0) {
                try {
                    Sales s = getSales(salesClosing.getSalesId());                    
                    User u = DbUser.fetch(s.getUserId());
                    operatorName = u.getFullName();
                    Shift shift = DbShift.fetchExc(s.getShift_id());
                    shiftName = shift.getName();
                } catch (Exception e) {
                }
            }

            subCash = subCash + salesClosing.getCash();
            subCard = subCard + salesClosing.getCCard();
            subDebit = subDebit + salesClosing.getDCard();
            subTransfer = subTransfer + salesClosing.getTransfer();
            subBon = subBon + salesClosing.getBon();
            subDiscount = subDiscount + salesClosing.getDiscount();
            subRetur = subRetur + salesClosing.getRetur();
            subAmount = subAmount + salesClosing.getAmount();
            subKwitansi = subKwitansi + (salesClosing.getAmount() - salesClosing.getDiscount());
            if(salesClosing.getBon() != 0){
                if(memoPiutang != null && memoPiutang.length() > 0){
                    memoPiutang = memoPiutang+", ";
                }
                memoPiutang = memoPiutang+"("+salesClosing.getMember()+":"+JSPFormater.formatNumber(salesClosing.getBon(), "###,###.##")+")";
            }    

            String strmerchant = salesClosing.getMerchantName();
            if (salesClosing.getMerchant2Name().length() > 0) {
                if (strmerchant.length() > 0) {
                    strmerchant = strmerchant + ", ";
                }
                strmerchant = strmerchant + salesClosing.getMerchant2Name();
            }

            if (salesClosing.getMerchant3Name().length() > 0) {
                if (strmerchant.length() > 0) {
                    strmerchant = strmerchant + ", ";
                }
                strmerchant = strmerchant + salesClosing.getMerchant3Name();
            }

            long currId = 0;
            if (salesClosing.getCash() != 0) {
                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_CASH;
                Vector pays = DbPayment.list(0, 1, wherePay, null);

                for (int p = 0; p < pays.size(); p++) {
                    Payment pay = (Payment) pays.get(p);
                    if (pay.getCurrency_id() == 0) {
                        currId = deffCurrIDR;
                    } else {
                        currId = pay.getCurrency_id();
                    }
                }
            }

            if (salesClosing.getCCard() != 0) {
                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_CREDIT_CARD;
                Vector pays = DbPayment.list(0, 1, wherePay, null);
                if (pays != null && pays.size() > 0) {
                    Payment p = (Payment) pays.get(0);
                    Vector tmpCC = new Vector();
                    tmpCC.add("" + p.getOID());
                    tmpCC.add("" + p.getMerchantId());
                    tmpCC.add("" + salesClosing.getCCard());
                    ccCredits.add(tmpCC);
                }
            }

            if (salesClosing.getDCard() != 0) {
                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_DEBIT_CARD;
                Vector pays = DbPayment.list(0, 1, wherePay, null);
                if (pays != null && pays.size() > 0) {
                    Payment p = (Payment) pays.get(0);
                    Vector tmpCC = new Vector();
                    tmpCC.add("" + p.getOID());
                    tmpCC.add("" + p.getMerchantId());
                    tmpCC.add("" + salesClosing.getDCard());
                    ccDebits.add(tmpCC);
                }
            }

            if (salesClosing.getTransfer() != 0) {
                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_TRANSFER;
                Vector pays = DbPayment.list(0, 1, wherePay, null);
                if (pays != null && pays.size() > 0) {
                    Payment p = (Payment) pays.get(0);
                    Vector tmpTransfer = new Vector();
                    tmpTransfer.add("" + p.getOID());
                    tmpTransfer.add("" + p.getBankId());
                    tmpTransfer.add("" + salesClosing.getTransfer());
                    tmpTransfer.add("Bank Transfer");
                    transfers.add(tmpTransfer);
                }
            }
            
            
            if (salesClosing.getCashBack() != 0) {
                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_CASH_BACK;
                Vector pays = DbPayment.list(0, 1, wherePay, null);
                Sales s = new Sales();
                if (pays != null && pays.size() > 0) {
                    Payment p = (Payment) pays.get(0);
                    try {
                        s = DbSales.fetchExc(p.getSales_id());
                    } catch (Exception e) {
                    }

                    String ket = "";
                    Customer c = new Customer();
                    try {
                        c = DbCustomer.fetchExc(s.getCustomerId());
                        if (c.getOID() != 0) {
                            ket = ", atas customer : " + c.getName();
                        }
                    } catch (Exception e) {
                    }

                    Vector tmpCC = new Vector();
                    tmpCC.add("" + p.getOID());
                    tmpCC.add("" + p.getMerchantId());
                    tmpCC.add("" + salesClosing.getCashBack());
                    tmpCC.add("" + "Pembayaran dengan cash back tanggal " + JSPFormater.formatDate(s.getDate(), "dd/MM/yyyy") + " " + ket + " senilai " + salesClosing.getCashBack());
                    cashBacks.add(tmpCC);
                }
            }

            for (int ir = 0; ir < currencys.size(); ir++) {
                Currency cs = (Currency) currencys.get(ir);
                if (cs.getOID() == currId) {
                    totalCash[ir] = totalCash[ir] + salesClosing.getCash();
                } else {
                    totalCash[ir] = totalCash[ir] + 0;
                }
            }
        }

        Vector mappings = SessPostSales.getMappingCOGS(tanggal, locationId, cashCashierId,param,comp.getUseBkp());
        Date dt = new Date();

        int periodeTaken = 0;
        try {
            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
        } catch (Exception e) {
        }

        if (periodeTaken == 0) {
            dt = periode.getStartDate();  // untuk mendapatkan periode yang aktif
        } else if (periodeTaken == 1) {
            dt = periode.getEndDate();  // untuk mendapatkan periode yang aktif}
        }

        String formatDocCode = DbSystemDocNumber.getNumberPrefix(periode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_SALES);
        int counter = DbSystemDocNumber.getNextCounter(periode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_SALES);

        // proses untuk object ke general penanpungan code
        SystemDocNumber systemDocNumber = new SystemDocNumber();
        systemDocNumber.setCounter(counter);
        systemDocNumber.setDate(new Date());
        systemDocNumber.setPrefixNumber(formatDocCode);
        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES]);
        systemDocNumber.setYear(dt.getYear() + 1900);
        String numberJurnal = DbSystemDocNumber.getNextNumber(counter, periode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_SALES);
        systemDocNumber.setDocNumber(numberJurnal);
        
        long oid = 0;
        String memoGl = "Transaksi Penjualan Tanggal " + JSPFormater.formatDate(tanggal, "dd MMM yyyy") + ", Shift " + shiftName + ", atas cashier " + operatorName + ", lokasi " + l.getName();
                
        try {
            SalesHistory sh = new SalesHistory();
            sh.setCashCashierId(cashCashierId);  
            long oidHistory = 0;
            try{
                oidHistory = DbSalesHistory.insertExc(sh);
            }catch(Exception e){}
            
            if(oidHistory != 0){
                oid = DbGl.postJournalMain(periode.getTableName(),0, new Date(),counter, numberJurnal, formatDocCode,
                            I_Project.JOURNAL_TYPE_SALES,
                            memoGl, userId, "", 0, "", tanggal, periode.getOID());
            }
            double totDebit = 0;
            double totCredit = 0;

            if (oid != 0) {
                
                sh.setDate(new Date());
                sh.setGlId(oid);
                sh.setJournalNumber(numberJurnal);
                try{
                    DbSalesHistory.updateExc(sh);
                }catch(Exception e){}

                long sysDocId = 0;
                try {
                    sysDocId = DbSystemDocNumber.insertExc(systemDocNumber);
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                //Posting Kas multi currency               
                for (int ir = 0; ir < currencys.size(); ir++) {
                    Currency cr = (Currency) currencys.get(ir);
                    double cashx = 0;
                    try {
                        cashx = totalCash[ir];
                    } catch (Exception e) {
                    }

                    if (cashx != 0) {
                        Coa cIr = new Coa();
                        try {
                            cIr = DbCoa.fetchExc(cr.getCoaId());
                        } catch (Exception e) {
                        }

                        if (cashx > 0) {
                            DbGl.postJournalDetail(er.getValueIdr(), cIr.getOID(), 0, cashx,
                                    cashx, comp.getBookingCurrencyId(), oid, "Kas Penjualan", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            totDebit = totDebit + cashx;
                        } else {
                            DbGl.postJournalDetail(er.getValueIdr(), cIr.getOID(), (cashx * -1), 0,
                                    (cashx * -1), comp.getBookingCurrencyId(), oid, "Kas Penjualan", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            totCredit = totCredit + (cashx * -1);
                        }
                    }
                }

                //posting piutang
                if (subBon != 0) {
                    Coa coaPiutang = new Coa();
                    try {
                        coaPiutang = DbCoa.fetchExc(l.getCoaArId());
                    } catch (Exception e) {
                    }
                    DbGl.postJournalDetail(er.getValueIdr(), coaPiutang.getOID(), 0, subBon,
                            subBon, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                            segment1_id, 0, 0, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0,
                            0, 0, 0, 0);
                    totDebit = totDebit + subBon;
                }

                //Posting kartu credit
                if (ccCredits != null && ccCredits.size() > 0) {
                    for (int t = 0; t < ccCredits.size(); t++) {
                        Vector vCredit = (Vector) ccCredits.get(t);
                        long coaId = 0;
                        Coa coa = new Coa();
                        Merchant m = new Merchant();
                        double amountExp = 0;
                        double amount = 0;
                        double amountFinal = amount;
                        try {
                            amount = Double.parseDouble("" + vCredit.get(2));
                        } catch (Exception e) {
                        }

                        String ket = "Pembayaran dengan kartu credit";

                        try {
                            coaId = Long.parseLong("" + vCredit.get(1));
                            if (coaId != 0) {
                                m = DbMerchant.fetchExc(coaId);
                                coa = DbCoa.fetchExc(m.getCoaId());
                                oidBiaya = coa.getOID();
                            }

                            if (m.getOID() != 0) {
                                if (m.getPaymentBy() == DbMerchant.PAYMENT_BY_COMPANY) {
                                    amountExp = (m.getPersenExpense() / 100) * amount;
                                    amountFinal = amount - amountExp;
                                } else {
                                    amountExp = (m.getPersenExpense() / 100) * amount;
                                    amountFinal = amount + amountExp;
                                }
                                if (m.getTypePayment() == DbMerchant.TYPE_CREDIT_CARD) {
                                    ket = "Pembayaran dengan kartu credit card";
                                } else if (m.getTypePayment() == DbMerchant.TYPE_DEBIT_CARD) {
                                    ket = "Pembayaran dengan kartu debit card";
                                }
                            }
                        } catch (Exception e) {
                        }
                        totDebit = totDebit + amountFinal;

                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amountFinal,
                                amountFinal, comp.getBookingCurrencyId(), oid, ket, 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                        if (amountExp != 0) {
                            Coa coaExp = new Coa();
                            try {
                                coaExp = DbCoa.fetchExc(m.getCoaExpenseId());
                            } catch (Exception e) {
                            }

                            DbGl.postJournalDetail(er.getValueIdr(), coaExp.getOID(), 0, amountExp,
                                    amountExp, comp.getBookingCurrencyId(), oid, "Biaya Credit Card", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);

                            totDebit = totDebit + amountExp;
                        }
                    }
                }


                if (ccDebits != null && ccDebits.size() > 0) {
                    for (int t = 0; t < ccDebits.size(); t++) {
                        Vector vDebit = (Vector) ccDebits.get(t);
                        long coaId = 0;
                        Coa coa = new Coa();
                        Merchant m = new Merchant();
                        double amountExp = 0;
                        double amount = 0;
                        double amountFinal = amount;
                        try {
                            amount = Double.parseDouble("" + vDebit.get(2));
                        } catch (Exception e) {
                        }

                        String ket = "Pembayaran dengan kartu credit";

                        try {
                            coaId = Long.parseLong("" + vDebit.get(1));
                            if (coaId != 0) {
                                m = DbMerchant.fetchExc(coaId);
                                coa = DbCoa.fetchExc(m.getCoaId());
                                oidBiaya = coa.getOID();
                            }

                            if (m.getOID() != 0) {
                                if (m.getPaymentBy() == DbMerchant.PAYMENT_BY_COMPANY) {
                                    amountExp = (m.getPersenExpense() / 100) * amount;
                                    amountFinal = amount - amountExp;
                                } else {
                                    amountExp = (m.getPersenExpense() / 100) * amount;
                                    amountFinal = amount + amountExp;
                                }
                                if (m.getTypePayment() == DbMerchant.TYPE_CREDIT_CARD) {
                                    ket = "Pembayaran dengan kartu credit card";
                                } else if (m.getTypePayment() == DbMerchant.TYPE_DEBIT_CARD) {
                                    ket = "Pembayaran dengan kartu debit card";
                                }

                            }
                        } catch (Exception e) {
                        }

                        totDebit = totDebit + amountFinal;

                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amountFinal,
                                amountFinal, comp.getBookingCurrencyId(), oid, ket, 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                        if (amountExp != 0) {
                            Coa coaExp = new Coa();
                            try {
                                coaExp = DbCoa.fetchExc(m.getCoaExpenseId());
                            } catch (Exception e) {
                            }
                            DbGl.postJournalDetail(er.getValueIdr(), coaExp.getOID(), 0, amountExp,
                                    amountExp, comp.getBookingCurrencyId(), oid, "Biaya Pembayaran kartu credit", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);

                            totDebit = totDebit + amountExp;
                        }
                    }
                }

                if (transfers != null && transfers.size() > 0) {
                    for (int t = 0; t < transfers.size(); t++) {
                        Vector vTransfer  = (Vector) transfers.get(t);
                        long bankId = 0;
                        Coa coa = new Coa();
                        Bank bank = new Bank();                                                                                                                                                                
                        double amount = 0;                                                                                                                                                                
                        try {
                            amount = Double.parseDouble("" + vTransfer.get(2));
                        } catch (Exception e) {}
                        
                        try {
                            bankId = Long.parseLong("" + vTransfer.get(1));                                                                                                                                                                    
                            if (bankId != 0) {
                                bank = DbBank.fetchExc(bankId);
                                coa = DbCoa.fetchExc(bank.getCoaARId());
                            }
                            
                        } catch (Exception e) {
                        }

                        String ket = "";
                        try {
                            ket = String.valueOf(vTransfer.get(3));
                        } catch (Exception e) {
                        }

                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amount,
                                amount, comp.getBookingCurrencyId(), oid, ket, 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
                    }
                }    
                
                
                if (cashBacks != null && cashBacks.size() > 0) {
                    for (int t = 0; t < cashBacks.size(); t++) {
                        Vector vCashBack = (Vector) cashBacks.get(t);
                        long coaId = 0;
                        Coa coa = new Coa();
                        Merchant m = new Merchant();
                        double amountExp = 0;
                        double amount = 0;
                        double amountFinal = amount;
                        try {
                            amount = Double.parseDouble("" + vCashBack.get(2));
                        } catch (Exception e) {
                        }
                        try {
                            coaId = Long.parseLong("" + vCashBack.get(1));
                            if (coaId != 0) {
                                m = DbMerchant.fetchExc(coaId);
                                coa = DbCoa.fetchExc(m.getCoaId());
                            }

                            if (m.getOID() != 0) {
                                if (m.getPaymentBy() == DbMerchant.PAYMENT_BY_COMPANY) {
                                    amountExp = (m.getPersenExpense() / 100) * amount;
                                    amountFinal = amount - amountExp;
                                } else {
                                    amountExp = (m.getPersenExpense() / 100) * amount;
                                    amountFinal = amount + amountExp;
                                }
                            }
                        } catch (Exception e) {
                        }

                        String ket = "";
                        try {
                            ket = String.valueOf(vCashBack.get(3));
                        } catch (Exception e) {
                        }

                        totDebit = totDebit + amountFinal;

                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amountFinal,
                                amountFinal, comp.getBookingCurrencyId(), oid, ket, 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                        if (amountExp != 0) {
                            Coa coaExp = new Coa();
                            try {
                                coaExp = DbCoa.fetchExc(m.getCoaExpenseId());
                            } catch (Exception e) {
                            }
                            DbGl.postJournalDetail(er.getValueIdr(), coaExp.getOID(), 0, amountExp,
                                    amountExp, comp.getBookingCurrencyId(), oid, "Biaya Cash Back", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);

                            totDebit = totDebit + amountExp;
                        }
                    }
                }


                if (mappings != null && mappings.size() > 0) {
                    double ppn = 0;
                    String strPpn = "";
                    for (int t = 0; t < mappings.size(); t++) {
                        //Vector mapp = (Vector) mappings.get(t);
                        MappingCogs mapp = (MappingCogs) mappings.get(t);
                        
                        Coa cInv = new Coa();
                        Coa cCogs = new Coa();
                        Coa csales = new Coa();
                        strPpn = mapp.getAccPpn();
                        ppn = ppn + mapp.getAmountPpn();
                        
                        try {                            
                            if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                cInv = DbCoa.getCoaByCode(mapp.getAccGroInv().trim());
                            }else{
                                cInv = DbCoa.getCoaByCode(mapp.getAccInv().trim());
                            }
                        } catch (Exception e) {}

                        
                        try {
                            if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                cCogs = DbCoa.getCoaByCode(mapp.getAccGroCogs().trim());
                            }else{
                                cCogs = DbCoa.getCoaByCode(mapp.getAccCogs().trim());
                            }
                        } catch (Exception e) {
                        }

                        
                        try {
                            if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                csales = DbCoa.getCoaByCode(mapp.getAccGroSales().trim());
                            }else{
                                csales = DbCoa.getCoaByCode(mapp.getAccSales().trim());
                            }
                        } catch (Exception e) {
                        }

                        double amountCogs = mapp.getAmount();
                        double amountRev = mapp.getAmountRev();

                        if (amountRev != 0) {
                            //Penjualan
                            DbGl.postJournalDetail(er.getValueIdr(), csales.getOID(), amountRev, 0,
                                    amountRev, comp.getBookingCurrencyId(), oid, "Pendapatan Penjualan", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                        }


                        if (amountCogs != 0) {
                            //Persediaan
                            DbGl.postJournalDetail(er.getValueIdr(), cInv.getOID(), amountCogs, 0,
                                    amountCogs, comp.getBookingCurrencyId(), oid, "Persediaan Barang", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);


                            //Harga Pokok Penjualan
                            DbGl.postJournalDetail(er.getValueIdr(), cCogs.getOID(), 0, amountCogs,
                                    amountCogs, comp.getBookingCurrencyId(), oid, "Harga Pokok Penjualan", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                        }

                        totDebit = totDebit + amountCogs;
                        totCredit = totCredit + amountRev;
                        totCredit = totCredit + amountCogs;
                    }
                    if(ppn != 0){
                        try{
                            Coa cPpn = DbCoa.getCoaByCode(strPpn);
                            DbGl.postJournalDetail(er.getValueIdr(), cPpn.getOID(), ppn, 0,
                                    ppn, comp.getBookingCurrencyId(), oid, "ppn penjualan", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                        }catch(Exception e){}
                    }
                    
                }

                double balance = totCredit - totDebit;
                String strAmount = JSPFormater.formatNumber(balance, "###,###.##");
                if (strAmount.compareToIgnoreCase("0.00") != 0 && strAmount.compareToIgnoreCase("-0.00") != 0 && oidBiaya != 0 && balance > -1 && balance < 1) {
                    try {
                        Coa penyesuaian = DbCoa.fetchExc(oidBiaya);
                        totDebit = totDebit + balance;
                        DbGl.postJournalDetail(er.getValueIdr(), penyesuaian.getOID(), 0, balance,
                                balance, comp.getBookingCurrencyId(), oid, penyesuaian.getName(), 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                    } catch (Exception e) {
                    }
                }

                updatePosting(userId, sysDocId, locationId, tanggal, cashCashierId, periode.getOID());
                
                for (int k = 0; k < list.size(); k++) {
                    SalesClosingJournal salesClosing = (SalesClosingJournal) list.get(k);
                    
                    if(salesClosing.getType() == DbSales.TYPE_CREDIT || salesClosing.getType() == DbSales.TYPE_RETUR_CREDIT){
                        try{
                            Sales sales = DbSales.fetchExc(salesClosing.getSalesId());
                            if(sales.getOID() != 0){
                                if(salesClosing.getType() == DbSales.TYPE_CREDIT) {
                                    DbSales.postReceivable(sales, intervalDue, salesClosing.getBon());
                                }else if(salesClosing.getType() == DbSales.TYPE_RETUR_CREDIT){
                                    if(sales.getSalesReturId() != 0){                                                                
                                        try{
                                            String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+sales.getOID();
                                            Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                                            if(vCP != null && vCP.size() > 0){
                                                CreditPayment cp = (CreditPayment)vCP.get(0);      
                                                DbCreditPayment.updateStatusPayCredit(cp.getOID(), userId); 
                                            }
                                        }catch(Exception e){}
                                        DbSales.postPaymentReceivable(sales, er, salesClosing.getRetur());
                                 
                                    }else{
                                        try{
                                            String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+sales.getOID();
                                            Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                                            if(vCP != null && vCP.size() > 0){
                                                CreditPayment cp = (CreditPayment)vCP.get(0);      
                                                DbCreditPayment.updateStatusPayCredit(cp.getOID(), userId); 
                                            }
                                        }catch(Exception e){}
                                        double amountPiutang = 0;
                                        if(salesClosing.getRetur() != 0){
                                            amountPiutang = salesClosing.getRetur() * -1;
                                        }
                                        ARInvoice ar = new ARInvoice();                                    
                                        ar.setSalesSource(1);
                                        ar.setDate(sales.getDate());
                                        ar.setProjectId(sales.getOID());
                                        ar.setDueDate(sales.getDate());
                                        ar.setTransDate(sales.getDate());                                    
                                        ar.setCompanyId(sales.getCompanyId());
                                        ar.setOperatorId(sales.getUserId());
                                        ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
                                        ar.setCurrencyId(sales.getCurrencyId());
                                        ar.setCustomerId(sales.getCustomerId());
                                        ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
                                        ar.setDiscount(0);
                                        ar.setDiscountPercent(0);
                                        ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
                                        ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
                                        ar.setProjectTermId(sales.getOID());
                                        ar.setTotal(amountPiutang);
                                        ar.setVat(0);
                                        ar.setVatAmount(0);
                                        ar.setVatPercent(0);
                                        ar.setInvoiceNumber(sales.getNumber());
                                        ar.setTypeAR(DbARInvoice.TYPE_RETUR);                                    
                                        ar.setPostedStatus(1);
                                        ar.setPostedDate(new Date());
                                        ar.setCreateDate(new Date());
                                        ar.setLocationId(sales.getLocation_id());                                    
                                        try{                                        
                                            long oidx = DbARInvoice.insertExc(ar);                                        
                                            if (oidx != 0) {
                                                ARInvoiceDetail ard = new ARInvoiceDetail();
                                                ard.setArInvoiceId(oidx);
                                                ard.setItemName("Credit Sales from sales number - " + sales.getNumber());
                                                ard.setQty(1);
                                                ard.setPrice(amountPiutang);
                                                ard.setDiscount(0);
                                                ard.setTotalAmount(amountPiutang);
                                                ard.setCompanyId(sales.getCompanyId());

                                                try {
                                                    DbARInvoiceDetail.insertExc(ard);
                                                } catch (Exception e) {}
                                            }                                        
                                        }catch(Exception e){}
                                    }
                                }
                            }
                        }catch(Exception e){}
                    }
                    
                }
                
            }
        } catch (Exception e) {
        }
        return oid;
    }

    public static void generatePiutang(Date tanggal, long locationId, long cashCashierId, User user) {
        CONResultSet crs = null;

        int intervalDue = 7;// default 7 hari jatuh tempo setelah transaksi
        try {
            intervalDue = Integer.parseInt(DbSystemProperty.getValueByName("INTERVAL_DUE_DATE_CREDIT"));
        } catch (Exception e) {
        }
        ExchangeRate er = DbExchangeRate.getStandardRate();

        try {
            String sql = "select s." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id," +
                    "s." + DbSales.colNames[DbSales.COL_TYPE] + " as type," +
                    "sum((sd.qty * sd.selling_price )-sd.discount_amount) as xamount" +
                    " from " + DbSales.DB_SALES + " s inner join " + DbSalesDetail.DB_SALES_DETAIL + " sd on " +
                    " s." + DbSales.colNames[DbSales.COL_SALES_ID] + " = sd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID];

            String where = " and s.type in (1,3) and s." + DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 23:59:59'";

            if (locationId != 0) {
                where = where + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }

            if (cashCashierId != 0) {
                where = where + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }

            sql = sql + where + " group by s." + DbSales.colNames[DbSales.COL_SALES_ID];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {

                long salesId = rs.getLong("sales_id");
                int type = rs.getInt("type");
                double amount = rs.getDouble("xamount");
                Sales sales = new Sales();
                try {
                    sales = DbSales.fetchExc(salesId);
                } catch (Exception e) {
                }

                if (type == DbSales.TYPE_CREDIT) {
                    if (sales.getOID() != 0) {
                        DbSales.postReceivable(sales, intervalDue, amount);
                    }
                } else if (type == DbSales.TYPE_RETUR_CREDIT) {
                    if (sales.getSalesReturId() != 0) {
                        try {
                            String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + " = " + sales.getOID();
                            Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                            if (vCP != null && vCP.size() > 0) {
                                CreditPayment cp = (CreditPayment) vCP.get(0);
                                DbCreditPayment.updateStatusPayCredit(cp.getOID(), user.getOID());
                            }
                        } catch (Exception e) {
                        }
                        DbSales.postPaymentReceivable(sales, er, amount);
                    } else {
                        try {
                            String whereCP = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + " = " + sales.getOID();
                            Vector vCP = DbCreditPayment.list(0, 1, whereCP, null);
                            if (vCP != null && vCP.size() > 0) {
                                CreditPayment cp = (CreditPayment) vCP.get(0);
                                DbCreditPayment.updateStatusPayCredit(cp.getOID(), user.getOID());
                            }
                        } catch (Exception e) {
                        }

                        if (amount != 0) {
                            amount = amount * -1;
                        }
                        ARInvoice ar = new ARInvoice();
                        ar.setSalesSource(1);
                        ar.setDate(sales.getDate());
                        ar.setProjectId(sales.getOID());
                        ar.setDueDate(sales.getDate());
                        ar.setTransDate(sales.getDate());
                        ar.setCompanyId(sales.getCompanyId());
                        ar.setOperatorId(sales.getUserId());
                        ar.setMemo(sales.getNumber() + " - " + sales.getDescription());
                        ar.setCurrencyId(sales.getCurrencyId());
                        ar.setCustomerId(sales.getCustomerId());
                        ar.setJournalCounter(DbARInvoice.getNextCounter(sales.getCompanyId()));
                        ar.setDiscount(0);
                        ar.setDiscountPercent(0);
                        ar.setJournalPrefix(DbARInvoice.getNumberPrefix(sales.getCompanyId()));
                        ar.setJournalNumber(DbARInvoice.getNextNumber(ar.getJournalCounter(), ar.getCompanyId()));
                        ar.setProjectTermId(sales.getOID());
                        ar.setTotal(amount);
                        ar.setVat(0);
                        ar.setVatAmount(0);
                        ar.setVatPercent(0);
                        ar.setInvoiceNumber(sales.getNumber());
                        ar.setTypeAR(DbARInvoice.TYPE_RETUR);
                        ar.setPostedStatus(1);
                        ar.setPostedDate(new Date());
                        ar.setCreateDate(new Date());
                        ar.setLocationId(sales.getLocation_id());
                        try {
                            long oidx = DbARInvoice.insertExc(ar);
                            if (oidx != 0) {
                                ARInvoiceDetail ard = new ARInvoiceDetail();
                                ard.setArInvoiceId(oidx);
                                ard.setItemName("Credit Sales from sales module - " + sales.getNumber());
                                ard.setQty(1);
                                ard.setPrice(amount);
                                ard.setDiscount(0);
                                ard.setTotalAmount(amount);
                                ard.setCompanyId(sales.getCompanyId());
                                try {
                                    DbARInvoiceDetail.insertExc(ard);
                                } catch (Exception e) {
                                }
                            }
                        } catch (Exception e) {
                        }
                    }
                }

            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
    }

    public static Vector listSystemDocNumber(long locationId, long cashCashierId, Date tanggal) {
        CONResultSet dbrs = null;
        try {

            String sql = " select " + DbSales.colNames[DbSales.COL_SYSTEM_DOC_NUMBER_ID] + " from " + DbSales.DB_SALES + " where " +
                    DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId + " and " + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId +
                    " and to_days(" + DbSales.colNames[DbSales.COL_DATE] + ") = to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') group by " + DbSales.colNames[DbSales.COL_SYSTEM_DOC_NUMBER_ID];
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector systemDocs = new Vector();

            while (rs.next()) {
                systemDocs.add("" + rs.getLong(DbSales.colNames[DbSales.COL_SYSTEM_DOC_NUMBER_ID]));
            }

            return systemDocs;
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }

    public static Sales getSales(long salesId) {
        CONResultSet dbrs = null;
        Sales s = new Sales();
        try {
            String sql = "select " + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id," +
                    DbSales.colNames[DbSales.COL_USER_ID] + " as user_id," +
                    DbSales.colNames[DbSales.COL_SHIFT_ID] + " as shift_id from " +
                    DbSales.DB_SALES + " where " + DbSales.colNames[DbSales.COL_SALES_ID] + " = " + salesId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                s.setOID(rs.getLong("sales_id"));
                s.setUserId(rs.getLong("user_id"));
                s.setShift_id(rs.getLong("shift_id"));
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return s;
    }
    
    public static Vector getShift(long locationOid, Date tanggal) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            
            String sql = "select c.cash_cashier_id as cash_cashier_id,c.name as name,s.full_name as full_name from ( "+
                    " SELECT cc.cash_cashier_id as cash_cashier_id,s.name as name,cc.user_id as user_id FROM `pos_cash_cashier` as cc "+
                    " inner join pos_cash_master as cm on cc.cash_master_id=cm.cash_master_id "+
                    " inner join pos_shift as s on cc.shift_id=s.shift_id "+
                    " where location_id= " + locationOid + " and "+
                    " date_open between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 00:00:00") + "' " +
                    " and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd 23:59:59") + "' group by cc.cash_cashier_id) as c left join sysuser s on c.user_id = s.user_id ";
            

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Shift shift = new Shift();
                shift.setOID(rs.getLong("cash_cashier_id"));                
                String name = rs.getString("name");
                String fullname = rs.getString("full_name");
                
                if(fullname != null && fullname.length() > 0){
                    name = name +" < "+fullname+" >";
                }
                shift.setName(name);
                list.add(shift);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
    
     public static Vector getMappingCOGS(Date tanggal,long locationId,long cashCashierId,int param, int bkp){        
        
        int STOCKABLE           = 0;
        
        CONResultSet crs = null; 
        try{
            String where = "";
            
            if(cashCashierId != 0){
                where = " and s."+DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]+" = "+cashCashierId;
            }            
            
            String sql = "";
            
            if(param == STOCKABLE){
                
                  sql ="select group_id,sum(amount) as xamount,sum(amount_rev) as xamount_rev,sum(amount_discount) as xamount_discount,acc_sales,acc_inv,acc_cogs,0 as amount_ppn, " +
                    "acc_discount,acc_sales_grosir,acc_inv_grosir,acc_cogs_grosir,acc_discount_grosir,0 as amount_ppn,acc_ppn from ( "+
                    
                    "select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_rev,"+                    
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_discount,"+                       
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +   
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where s."+DbSales.colNames[DbSales.COL_TYPE]+" in (0,1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId +" "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    
                    " union "+
                    "select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") * -1 as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") * -1 as amount_rev,"+
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")*-1 as amount_discount,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +   
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where s."+DbSales.colNames[DbSales.COL_TYPE]+" in (2,3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    
                    " ) as x group by group_id ";
                
            }else{
                
                if(bkp ==1){
                    //stockable                     
                    sql ="select group_id,sum(amount) as xamount,sum(amount_rev) as xamount_rev,sum(amount_discount) as xamount_discount,acc_sales,acc_inv,acc_cogs, sum(ppn) as amount_ppn, " +
                    "acc_discount,acc_sales_grosir,acc_inv_grosir,acc_cogs_grosir,acc_discount_grosir,acc_ppn from ( "+ 
                            
                    "select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as amount ," +
                    " sum((100*((sd.qty * sd.selling_price)-sd.discount_amount))/110) as amount_rev,"+
                    " sum((((sd.qty * sd.selling_price)-sd.discount_amount)-((100*((sd.qty * sd.selling_price)-sd.discount_amount))/110))) as ppn, "+        
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_discount,"+                    
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +        
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+","+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+        
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+"=1 and s."+DbSales.colNames[DbSales.COL_TYPE]+" in (0,1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId +" and ( m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 0 or m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" is null ) "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                    
                    " select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_rev,"+
                    " 0 as ppn, "+        
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_discount,"+                    
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +   
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+","+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+"=0 and s."+DbSales.colNames[DbSales.COL_TYPE]+" in (0,1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId +" and ( m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 0 or m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" is null ) "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                            
                    " select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") * -1 as amount ," +                    
                    " sum((100*((sd.qty * sd.selling_price)-sd.discount_amount))/110)*-1 as amount_rev,"+
                    " sum(((sd.qty * sd.selling_price)-sd.discount_amount)-((100*((sd.qty * sd.selling_price)-sd.discount_amount))/110))*-1 as ppn, "+  
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")*-1 as amount_discount,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +   
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+","+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+        
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+"=1 and s."+DbSales.colNames[DbSales.COL_TYPE]+" in (2,3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" and ( m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 0 or m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" is null ) "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+                            
                            
                    " select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") * -1 as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") * -1 as amount_rev,"+
                    " 0 as ppn, "+  
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")*-1 as amount_discount,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +           
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+","+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+"=0 and s."+DbSales.colNames[DbSales.COL_TYPE]+" in (2,3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" and ( m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 0 or m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" is null ) "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                            
                    //================untuk non stockable=====================================
                    " select 0 as amount ," +
                    " sum((100*((sd.qty * sd.selling_price)-sd.discount_amount))/110) as amount_rev,"+                            
                    " sum(((sd.qty * sd.selling_price)-sd.discount_amount)-((100*((sd.qty * sd.selling_price)-sd.discount_amount))/110)) as ppn, "+          
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_discount,"+  
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +           
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+","+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+"=1 and s."+DbSales.colNames[DbSales.COL_TYPE]+" in (0,1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId +" and m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 1 "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                            
                    " select 0 as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_rev,"+
                    " 0 as ppn, "+     
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_discount,"+                          
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +           
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+","+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+"=0 and s."+DbSales.colNames[DbSales.COL_TYPE]+" in (0,1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId +" and m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 1 "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                    
                    " select 0 as amount ," +                    
                    " sum((100*((sd.qty * sd.selling_price)-sd.discount_amount))/110)*-1 as amount_rev,"+
                    " sum(((sd.qty * sd.selling_price)-sd.discount_amount)-((100*((sd.qty * sd.selling_price)-sd.discount_amount))/110))*-1 as ppn, "+  
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")*-1 as amount_discount,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +           
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+","+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+"=1 and s."+DbSales.colNames[DbSales.COL_TYPE]+" in (2,3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" and m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 1 "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                    " select 0 as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") * -1 as amount_rev,"+
                    " 0 as ppn, "+  
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")*-1 as amount_discount,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +           
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+","+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where m."+DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]+"=0 and s."+DbSales.colNames[DbSales.COL_TYPE]+" in (2,3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" and m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 1 "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+        
                            
                    " ) as x group by group_id ";       
                    
                }else{
                    
                    //stock able
                    sql ="select group_id,sum(amount) as xamount,sum(amount_rev) as xamount_rev,sum(amount_discount) as xamount_discount,acc_sales,acc_inv,acc_cogs, 0 as amount_ppn, " +
                    "acc_discount,acc_sales_grosir,acc_inv_grosir,acc_cogs_grosir,acc_discount_grosir,acc_ppn from ( "+                    
                    "select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_rev,"+
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_discount,"+                    
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +   
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where s."+DbSales.colNames[DbSales.COL_TYPE]+" in (0,1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId +" and ( m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 0 or m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" is null ) "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                    "select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") * -1 as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") * -1 as amount_rev,"+
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")*-1 as amount_discount,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +           
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where s."+DbSales.colNames[DbSales.COL_TYPE]+" in (2,3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" and ( m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 0 or m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" is null ) "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                            
                            
                    //untuk non stockable
                    "select 0 as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_rev,"+
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") as amount_discount,"+                    
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +           
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where s."+DbSales.colNames[DbSales.COL_TYPE]+" in (0,1) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId +" and m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 1 "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    " union "+
                    
                    "select 0 as amount ," +
                    " sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+")- sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+") * -1 as amount_rev,"+
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+")*-1 as amount_discount,"+
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH]+" as acc_sales," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV]+" as acc_inv," +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS]+" as acc_cogs, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_DISCOUNT]+" as acc_discount, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_SALES]+" as acc_sales_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_INVENTORY]+" as acc_inv_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_COGS]+" as acc_cogs_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_GROSIR_DISCOUNT]+" as acc_discount_grosir, " +
                    " g."+DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT]+" as acc_ppn, " +           
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" as need_recipe,"+
                    " s."+DbSales.colNames[DbSales.COL_TYPE]+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+" inner join "+DbItemMaster.DB_ITEM_MASTER+" m on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" inner join "+DbItemGroup.DB_ITEM_GROUP+" g on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+                    
                    " where s."+DbSales.colNames[DbSales.COL_TYPE]+" in (2,3) and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") = to_days('"+JSPFormater.formatDate(tanggal,"yyyy-MM-dd")+"') and s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" and m."+DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]+" = 1 "+where+" group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    
                    " ) as x group by group_id ";
                }
            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Vector result = new Vector();
            while(rs.next()){                                        
                
                double amount = rs.getDouble("xamount");
                double amountRev = rs.getDouble("xamount_rev");
                double amountDisc = rs.getDouble("xamount_discount");
                double ppn = rs.getDouble("amount_ppn");
                
                String accInv = rs.getString("acc_inv");
                String accCogs = rs.getString("acc_cogs");
                String accSales = rs.getString("acc_sales");
                String accDisc = rs.getString("acc_discount");
                
                String accGroInv = rs.getString("acc_inv_grosir");
                String accGroCogs = rs.getString("acc_cogs_grosir");
                String accGroSales = rs.getString("acc_sales_grosir");
                String accGroDisc = rs.getString("acc_discount_grosir");
                String accPpn = rs.getString("acc_ppn");
                
                MappingCogs mapping = new MappingCogs();
                mapping.setAmount(amount);
                mapping.setAmountRev(amountRev);
                mapping.setAmountDisc(amountDisc);
                mapping.setAmountPpn(ppn);
                mapping.setAccInv(accInv);
                mapping.setAccCogs(accCogs);
                mapping.setAccSales(accSales);
                mapping.setAccDisc(accDisc);
                
                mapping.setAccGroInv(accGroInv);
                mapping.setAccGroCogs(accGroCogs);
                mapping.setAccGroSales(accGroSales);
                mapping.setAccGroDisc(accGroDisc);
                mapping.setAccPpn(accPpn);
                                       
                result.add(mapping);
            }            
            return result;
        }catch(Exception e){
            System.out.println(e.toString());
        }finally{
            CONResultSet.close(crs);
        }        
        
        return null;
    }
     
     
     
     public static Vector getDataJournal(Date tanggal, long locationId, long cashCashierId, int isProductService){
        CONResultSet crs = null;
        Vector list = new Vector();
        try {            
            
            String sql = "select p." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id," +
                        " p." + DbSales.colNames[DbSales.COL_TYPE] + " as type, " +
                        " p." + DbSales.colNames[DbSales.COL_SALES_RETUR_ID] + " as sales_retur_id, " +
                        " p." + DbSales.colNames[DbSales.COL_NUMBER] + " as number, " +
                        " p." + DbSales.colNames[DbSales.COL_DATE] + " as date, " +
                        " p." + DbSales.colNames[DbSales.COL_NAME] + " as name, " +
                        " p." + DbSales.colNames[DbSales.COL_POSTED_STATUS] + " as posted_status, " +
                        " sum((pd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * pd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+") - pd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+" ) as tot , sum(pd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as discount_dt " +
                        " from " + DbSales.DB_SALES + " as p inner join " + DbSalesDetail.DB_SALES_DETAIL + " as pd on " +
                        " p." + DbSales.colNames[DbSales.COL_SALES_ID] + " = pd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " as it on pd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + "=it." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                        " where to_days(p." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') and to_days(p." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') ";
            
            if(isProductService != -1){
                sql = sql + " and it." + DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE] + " = " + isProductService;
            }
            
            if (locationId != 0){
                sql = sql + " and p." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }
            
            if (cashCashierId != 0){
                sql = sql + " and p." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }            
            
            sql = sql + " group by p." + DbSales.colNames[DbSales.COL_SALES_ID] + " order by p.number";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            double cash = 0;
            double card = 0;
            double debit = 0;
            double transfer = 0;
            double bon = 0;
            double discount = 0;
            double retur = 0;
            double amount = 0;            
            
            while (rs.next()){
                 
                cash = rs.getDouble("tot");                
                double tot = rs.getDouble("tot");
                long salesId = rs.getLong("sales_id");
                
                card = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_CREDIT_CARD);
                if(card == 0){
                    debit = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_DEBIT_CARD);                    
                    if(debit == 0){
                        transfer = DbSales.getPaymentCash(salesId, DbPayment.PAY_TYPE_TRANSFER);                    
                    }
                }
                
                if (card > 0) {
                    card = cash;
                    debit = 0;
                    cash = 0;
                    transfer = 0;
                } else if (debit > 0){
                    card = 0;
                    debit = cash;
                    cash = 0;
                    transfer = 0;
                } else if (transfer > 0){    
                    card = 0;
                    debit = 0;
                    transfer = cash;                    
                    cash = 0;
                }else{
                    card = 0;
                    debit = 0;
                    transfer = 0;
                }
                               
                discount = rs.getDouble("discount_dt");
                tot = tot + discount;
                amount = tot;
               
                retur = 0;
                bon = 0;
                
                int saleType = rs.getInt("type");
                switch (saleType) {
                    case 1: // credit bon
                        cash = 0;
                        card = 0;
                        debit = 0;
                        transfer = 0;
                        bon = rs.getDouble("tot");
                        amount = bon + discount;
                        break;

                    case 2:
                        cash = cash * -1;
                        card = card * -1;
                        transfer = transfer *-1;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;

                    case 3:
                        cash = 0;
                        bon = rs.getDouble("tot") * -1;
                        card = 0;
                        transfer = 0;
                        retur = rs.getDouble("tot");
                        amount = 0;
                        break;
                }
                
                SalesClosingJournal salesClosingJournal = new SalesClosingJournal();
                salesClosingJournal.setSalesId(salesId);
                salesClosingJournal.setSalesReturId(rs.getLong("sales_retur_id"));
                salesClosingJournal.setType(rs.getInt("type"));
                salesClosingJournal.setInvoiceNumber(rs.getString("number"));
                salesClosingJournal.setTglJam(rs.getDate("date"));
                salesClosingJournal.setMember(rs.getString("name"));
                salesClosingJournal.setPosted(rs.getInt("posted_status"));
                salesClosingJournal.setCash(cash);
               
                salesClosingJournal.setCCard(card);
                salesClosingJournal.setDCard(debit);
                salesClosingJournal.setTransfer(transfer);
                salesClosingJournal.setBon(bon);
                salesClosingJournal.setDiscount(discount);
                salesClosingJournal.setRetur(retur);
                salesClosingJournal.setAmount(amount);
                
                Merchant m = DbSales.getMerchant(salesId);
                salesClosingJournal.setMerchantId(m.getOID());
                salesClosingJournal.setMerchantName(m.getDescription());                
                list.add(salesClosingJournal);
                
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }
}
