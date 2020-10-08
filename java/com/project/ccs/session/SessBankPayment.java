/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.admin.User;
import com.project.ccs.postransaction.sales.DbPayment;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.general.BankPayment;
import com.project.general.DbBankPayment;
import com.project.general.DbMerchant;
import com.project.general.Merchant;
import com.project.main.db.CONHandler;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.SegmentDetail;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Roy
 */
public class SessBankPayment {

    public static void prosesReconCard(Date tanggal, long locationId, long cashCashierId, User user) {
        CONResultSet crs = null;
        try {
            String sql = "select s." + DbSales.colNames[DbSales.COL_SALES_ID] + " as sales_id," +
                    "s." + DbSales.colNames[DbSales.COL_NUMBER] + " as number," +
                    "s." + DbSales.colNames[DbSales.COL_NUMBER_PREFIX] + " as number_prefix," +
                    "s." + DbSales.colNames[DbSales.COL_COUNTER] + " as counter," +
                    "s." + DbSales.colNames[DbSales.COL_DATE] + " as date," +
                    "s.system_doc_number_id as system_doc_number," +
                    "p." + DbPayment.colNames[DbPayment.COL_PAYMENT_ID] + " as payment_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_CURRENCY_ID] + " as currency_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_BANK_ID] + " as bank_id," +
                    "p." + DbPayment.colNames[DbPayment.COL_AMOUNT] + " as amount," +
                    "p." + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " as pay_type," +
                    "p." + DbPayment.colNames[DbPayment.COL_MERCHANT_ID] + " as merchant_id " +
                    " from " + DbSales.DB_SALES + " s inner join " + DbPayment.DB_PAYMENT + " p " +
                    " on s." + DbSales.colNames[DbSales.COL_SALES_ID] + " = p." + DbPayment.colNames[DbPayment.COL_SALES_ID] +
                    " where s." + DbSales.colNames[DbSales.COL_STATUS] + " = 1 and p." + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " in (1,2) ";

            String where = " and s." + DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 23:59:59'";

            if (locationId != 0) {
                where = where + " and s." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " =" + locationId;
            }

            if (cashCashierId != 0) {
                where = where + " and s." + DbSales.colNames[DbSales.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            }

            sql = sql + where;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                long paymentId = rs.getLong("payment_id");
                double amount = rs.getLong("amount");
                long currencyId = rs.getLong("currency_id");
                int payType = rs.getInt("pay_type");
                long merchantId = rs.getLong("merchant_id");
                long bankId = rs.getLong("bank_id");
                Date dt = rs.getDate("date");
                String number = rs.getString("number");
                int c = rs.getInt("counter");
                String prefix = rs.getString("number_prefix");

                int checkRecon = checkRecon(paymentId);

                if (checkRecon == 0) {
                    Merchant merchant = new Merchant();
                    try {
                        merchant = DbMerchant.fetchExc(merchantId);
                    } catch (Exception e) {
                    }

                    double amountExp = 0;
                    double amountPiutang = amount;
                    if (merchant.getPersenExpense() != 0) {
                        amountExp = (merchant.getPersenExpense() / 100) * amount;
                        amountPiutang = amount - amountExp;
                    }

                    BankPayment bp = new BankPayment();
                    bp.setReferensiId(paymentId);
                    bp.setAmount(amountPiutang);
                    if (payType == DbPayment.PAY_TYPE_CREDIT_CARD) {
                        bp.setType(DbBankPayment.TYPE_CARD_CREDIT);
                    } else {
                        bp.setType(DbBankPayment.TYPE_CARD_DEBIT);
                    }

                    long segment1_id = 0;

                    if (locationId != 0) {
                        String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + locationId;
                        Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                        if (segmentDt != null && segmentDt.size() > 0) {
                            SegmentDetail sd = (SegmentDetail) segmentDt.get(0);                            
                            if(sd.getRefSegmentDetailId() != 0){
                                segment1_id = sd.getRefSegmentDetailId();
                            }else{
                                segment1_id = sd.getOID();
                            }                              
                        }
                    }

                    String journalNumber = number + "-CARD";
                    int x = countNumber(number);
                    if (x > 0) {
                        journalNumber = journalNumber + "" + (x + 1) + "-CARD";
                    }

                    int cek = countNumber(journalNumber);

                    if (cek == 0) {
                        bp.setNumber("");
                        bp.setCreateDate(new Date());
                        bp.setCoaId(merchant.getCoaId());
                        bp.setCurrencyId(currencyId);
                        bp.setDueDate(dt);
                        bp.setStatus(DbBankPayment.STATUS_NOT_PAID);
                        bp.setCreateId(user.getOID());
                        bp.setAmount(amountPiutang);
                        bp.setSegment1Id(segment1_id);
                        bp.setBankId(merchant.getBankId());
                        bp.setSegment2Id(0);
                        bp.setSegment3Id(0);
                        bp.setSegment4Id(0);
                        bp.setSegment5Id(0);
                        bp.setSegment6Id(0);
                        bp.setSegment7Id(0);
                        bp.setSegment8Id(0);
                        bp.setSegment9Id(0);
                        bp.setSegment10Id(0);
                        bp.setSegment11Id(0);
                        bp.setSegment12Id(0);
                        bp.setSegment13Id(0);
                        bp.setSegment14Id(0);
                        bp.setSegment15Id(0);
                        bp.setTransactionDate(dt);
                        bp.setVendorId(0);
                        bp.setJournalCounter(c);
                        bp.setJournalPrefix(prefix);
                        bp.setJournalNumber(journalNumber);
                        try {
                            DbBankPayment.insertExc(bp);
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

    public static double getAmountCard(long locationId, Date date, long merchantId) {
        CONResultSet crs = null;
        double total = 0;
        try {
            String sql = "select sum(total) as tot from ( " +
                    " select sum(p.amount) as total from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id inner join merchant m on p.merchant_id = m.merchant_id where s.type in (0,1) and s.location_id = " + locationId + " and s.date >= '" + JSPFormater.formatDate(date, "yyyy-MM-dd") + " 00:00:00' and s.date <= '" + JSPFormater.formatDate(date, "yyyy-MM-dd") + " 23:59:59' and m.merchant_id = " + merchantId + " union " +
                    " select sum(p.amount)*-1 as total from pos_sales s inner join pos_payment p on s.sales_id = p.sales_id inner join merchant m on p.merchant_id = m.merchant_id where s.type in (2,3) and s.location_id = " + locationId + " and s.date >= '" + JSPFormater.formatDate(date, "yyyy-MM-dd") + " 00:00:00' and s.date <= '" + JSPFormater.formatDate(date, "yyyy-MM-dd") + " 23:59:59' and m.merchant_id = " + merchantId + " ) as x ";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble("tot");
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return total;
    }

    public static int countNumber(String number) {
        CONResultSet crs = null;
        int total = 0;
        try {
            String sql = "select count(*) as tot from bank_payment where journal_number = '" + number + "'";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                total = rs.getInt("tot");
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return total;
    }

    public static int checkRecon(long paymentId) {
        CONResultSet crs = null;
        int total = 0;
        try {
            String sql = "select count(*) as tot from bank_payment where " + DbBankPayment.colNames[DbBankPayment.COL_REFERENSI_ID] + " = " + paymentId + " and " +
                    DbBankPayment.colNames[DbBankPayment.COL_TYPE] + " in (" + DbBankPayment.TYPE_CARD_CREDIT + "," + DbBankPayment.TYPE_CARD_DEBIT + ")";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                total = rs.getInt("tot");
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return total;
    }
}
