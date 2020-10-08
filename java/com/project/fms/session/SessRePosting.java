/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import com.project.I_Project;

import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;

import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;

import com.project.ccs.postransaction.costing.Costing;
import com.project.ccs.postransaction.costing.CostingItem;
import com.project.ccs.postransaction.costing.DbCosting;
import com.project.ccs.postransaction.costing.DbCostingItem;
import com.project.ccs.postransaction.ga.DbGeneralAffair;
import com.project.ccs.postransaction.ga.DbGeneralAffairDetail;
import com.project.ccs.postransaction.ga.GeneralAffair;
import com.project.ccs.postransaction.ga.GeneralAffairDetail;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbReceiveItem;
import com.project.ccs.postransaction.receiving.DbRetur;
import com.project.ccs.postransaction.receiving.DbReturItem;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.receiving.ReceiveItem;
import com.project.ccs.postransaction.receiving.Retur;
import com.project.ccs.postransaction.receiving.ReturItem;
import com.project.ccs.postransaction.repack.DbRepack;
import com.project.ccs.postransaction.repack.DbRepackItem;
import com.project.ccs.postransaction.repack.Repack;
import com.project.ccs.postransaction.repack.RepackItem;
import com.project.ccs.postransaction.sales.DbPayment;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.Payment;
import com.project.ccs.postransaction.sales.Sales;
import com.project.ccs.postransaction.sales.SalesClosingJournal;
import com.project.ccs.session.GrpPost;
import com.project.ccs.session.MappingCogs;
import com.project.ccs.session.SessPostSales;
import com.project.fms.master.AccLink;
import com.project.fms.master.Coa;
import com.project.fms.master.DbAccLink;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.transaction.BankDeposit;
import com.project.fms.transaction.BankDepositDetail;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.BankpoPaymentDetail;
import com.project.fms.transaction.DbBankDeposit;
import com.project.fms.transaction.DbBankDepositDetail;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.GlDetail;

import com.project.general.BankPayment;
import com.project.general.BankPaymentHistory;
import com.project.general.Company;
import com.project.general.Currency;
import com.project.general.Customer;
import com.project.general.DbBankPayment;
import com.project.general.DbBankPaymentHistory;
import com.project.general.DbCompany;
import com.project.general.DbCustomer;
import com.project.general.DbExchangeRate;
import com.project.general.DbLocation;
import com.project.general.DbMerchant;
import com.project.general.DbSalesHistory;
import com.project.general.DbSystemDocNumber;
import com.project.general.DbVendor;
import com.project.general.ExchangeRate;
import com.project.general.Location;
import com.project.general.Merchant;
import com.project.general.SalesHistory;
import com.project.general.SystemDocNumber;
import com.project.general.Vendor;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
import java.sql.ResultSet;

/**
 *
 * @author Roy
 */
public class SessRePosting {

    public static Vector getJournal(int journalType, int ignoreTrans, Date transStart, Date transEnd, int ignorePosting, Date postingDate, String number, long periodId) {
        CONResultSet crs = null;
        Vector result = new Vector();
        try {
            String sql = "select gl.journal_type as journal_type,gl.gl_id as gl_id,gl.journal_number as number, gl.trans_date as trans,gl.posted_date as posted_date,gl.posted_by_id as posted_by_id,sum(gd.debet) as Debet, sum(gd.credit) as Kredit, (sum(gd.debet)-sum(gd.credit)) as Selisih from gl inner join gl_detail gd on gl.gl_id=gd.gl_id where " +
                    " gl.period_id='" + periodId + "' ";

            if (ignoreTrans == 0) {
                sql = sql + " and gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(transStart, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(transEnd, "yyyy-MM-dd") + " 23:59:59' ";
            }

            if (ignorePosting == 0) {
                sql = sql + " and gl." + DbGl.colNames[DbGl.COL_POSTED_DATE] + " between '" + JSPFormater.formatDate(postingDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(postingDate, "yyyy-MM-dd") + " 23:59:59' ";
            }

            if (journalType != -1) {
                sql = sql + " and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + journalType;
            }

            if (number != null && number.length() > 0) {
                sql = sql + " and lower(gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + ") like '%" + number.toLowerCase() + "%' ";
            }

            sql = sql + " group by gl.gl_id having sum(gd.debet) <> sum(gd.credit) order by trans_date asc";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Vector tmp = new Vector();
                long glId = rs.getLong("gl_id");
                String numberx = rs.getString("number");
                double debet = rs.getDouble("Debet");
                double credit = rs.getDouble("Kredit");
                Date transDate = rs.getDate("trans");
                Date postedDate = rs.getDate("posted_date");
                long postedId = rs.getLong("posted_by_id");
                int type = rs.getInt("journal_type");

                tmp.add(String.valueOf(glId));
                tmp.add(String.valueOf(numberx));
                tmp.add(String.valueOf(debet));
                tmp.add(String.valueOf(credit));
                tmp.add(JSPFormater.formatDate(transDate, "dd/MM/yyyy"));
                tmp.add(JSPFormater.formatDate(postedDate, "dd/MM/yyyy"));
                tmp.add(String.valueOf(postedId));
                tmp.add(String.valueOf(type));
                result.add(tmp);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static long rePostSales(Gl gl, Vector list, long userId, Company comp, long locationId, Vector currencys, Date tanggal, long cashCashierId, int param) {

        ExchangeRate er = DbExchangeRate.getStandardRate();

        long deffCurrIDR = 0;
        try {
            deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
        } catch (Exception e) {
        }

        Periode periode = new Periode();
        if (gl.getPeriodId() != 0) {
            try {
                periode = DbPeriode.fetchExc(gl.getPeriodId());
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
        if (periode.getOID() == 0 || periode.getStatus().compareTo("Closed") == 0) {
            return 0;
        }

        Vector ccCredits = new Vector();
        Vector ccDebits = new Vector();
        Vector cashBacks = new Vector();
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

        Location l = new Location();
        try {
            l = DbLocation.fetchExc(locationId);
        } catch (Exception e) {
        }

        for (int k = 0; k < list.size(); k++) {
            SalesClosingJournal salesClosing = (SalesClosingJournal) list.get(k);

            subCash = subCash + salesClosing.getCash();
            subCard = subCard + salesClosing.getCCard();
            subDebit = subDebit + salesClosing.getDCard();
            subTransfer = subTransfer + salesClosing.getTransfer();
            subBon = subBon + salesClosing.getBon();
            subDiscount = subDiscount + salesClosing.getDiscount();
            subRetur = subRetur + salesClosing.getRetur();
            subAmount = subAmount + salesClosing.getAmount();
            subKwitansi = subKwitansi + (salesClosing.getAmount() - salesClosing.getDiscount());

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

        Vector mappings = SessPostSales.getMappingCOGS(tanggal, locationId, cashCashierId, param, comp.getUseBkp());

        long oid = gl.getOID();
        try {
            String wherex = DbSalesHistory.colNames[DbSalesHistory.COL_CASH_CASHIER_ID] + " = " + cashCashierId;
            Vector salesHistorys = DbSalesHistory.list(0, 1, wherex, null);
            if (salesHistorys == null || salesHistorys.size() <= 0) {
                SalesHistory sh = new SalesHistory();
                sh.setCashCashierId(cashCashierId);
                sh.setDate(new Date());
                sh.setGlId(gl.getOID());
                sh.setJournalNumber(gl.getJournalNumber());
                try {
                    DbSalesHistory.insertExc(sh);
                } catch (Exception e) {
                }
            }

            double totDebit = 0;
            double totCredit = 0;

            if (oid != 0) {

                //delete journal detail        
                if (periode.getTableName().equals(I_Project.GL_2015)) {
                    SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                    SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                } else {
                    SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
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
                            subBon, comp.getBookingCurrencyId(), oid, "Transaksi Credit", 0,
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
                                oidBiaya = coaExp.getOID();
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
                                oidBiaya = coaExp.getOID();
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
                        MappingCogs mapp = (MappingCogs) mappings.get(t);

                        Coa cInv = new Coa();
                        Coa cCogs = new Coa();
                        Coa csales = new Coa();
                        strPpn = mapp.getAccPpn();
                        ppn = ppn + mapp.getAmountPpn();

                        try {
                            if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                cInv = DbCoa.getCoaByCode(mapp.getAccGroInv().trim());
                            } else {
                                cInv = DbCoa.getCoaByCode(mapp.getAccInv().trim());
                            }
                        } catch (Exception e) {
                        }


                        try {
                            if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                cCogs = DbCoa.getCoaByCode(mapp.getAccGroCogs().trim());
                            } else {
                                cCogs = DbCoa.getCoaByCode(mapp.getAccCogs().trim());
                            }
                        } catch (Exception e) {
                        }


                        try {
                            if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                csales = DbCoa.getCoaByCode(mapp.getAccGroSales().trim());
                            } else {
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
                    if (ppn != 0) {
                        try {
                            Coa cPpn = DbCoa.getCoaByCode(strPpn);
                            DbGl.postJournalDetail(er.getValueIdr(), cPpn.getOID(), ppn, 0,
                                    ppn, comp.getBookingCurrencyId(), oid, "ppn penjualan", 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                        } catch (Exception e) {
                        }
                    }

                }

                GlDetail gdDebet = getDebet(gl.getOID());
                double tDebet = gdDebet.getDebet();
                double tCredit = gdDebet.getCredit();
                double balance = tCredit - tDebet;
                String strAmount = JSPFormater.formatNumber((balance), "###,###.##");

                if (strAmount.compareToIgnoreCase("0.00") != 0 && strAmount.compareToIgnoreCase("-0.00") != 0 && oidBiaya != 0 && balance > -1 && balance < 1) {
                    try {
                        Vector glDet = DbGlDetail.list(0, 1, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + oid + " and " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + oidBiaya + " and " + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + " != 0", null);
                        if (glDet != null && glDet.size() > 0) {
                            GlDetail gdx = (GlDetail) glDet.get(0);
                            double amountx = gdx.getDebet() + balance;
                            gdx.setDebet(amountx);
                            gdx.setForeignCurrencyAmount(amountx);
                            try {
                                DbGlDetail.updateExc(gdx);
                            } catch (Exception e) {
                            }
                        }
                    } catch (Exception e) {
                    }
                }
                Vector sysDoc = DbSystemDocNumber.list(0, 1, DbSystemDocNumber.colNames[DbSystemDocNumber.COL_DOC_NUMBER] + " = '" + gl.getJournalNumber().trim() + "'", null);
                if (sysDoc != null && sysDoc.size() > 0) {
                    try {
                        SystemDocNumber sDoc = (SystemDocNumber) sysDoc.get(0);
                        if (sDoc.getOID() != 0) {
                            SessPostSales.updatePosting(userId, sDoc.getOID(), locationId, tanggal, cashCashierId, periode.getOID());
                        }
                    } catch (Exception e) {
                    }
                }
            }
        } catch (Exception e) {
        }
        return oid;
    }

    public static GlDetail getDebet(long glId) {
        CONResultSet crs = null;
        GlDetail gd = new GlDetail();
        try {
            String sql = "select sum(" + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ") as debet,sum(" + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ") as credit from " +
                    DbGlDetail.DB_GL_DETAIL + " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + glId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                gd.setDebet(rs.getDouble("debet"));
                gd.setCredit(rs.getDouble("credit"));
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return gd;
    }

    public static int rePostRetur(Gl gl) {

        Retur retur = new Retur();

        try {
            Vector returs = DbRetur.list(0, 1, " lower(" + DbRetur.colNames[DbRetur.COL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            retur = (Retur) returs.get(0);
            if (retur.getOID() != 0) {
                Vendor vendor = new Vendor();
                try {
                    vendor = DbVendor.fetchExc(retur.getVendorId());
                } catch (Exception e) {
                }

                ExchangeRate eRate = new ExchangeRate();
                try {
                    eRate = DbExchangeRate.getStandardRate();
                } catch (Exception e) {
                }

                long segment1_id = 0;

                if (retur.getLocationId() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + retur.getLocationId();
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

                //Untuk mengecek setup coa inventory dan coa HPP agar semua ada, jika tidak maka posting di batalkan        
                boolean coaALL = true;
                long periodId = 0;
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(gl.getPeriodId());
                    periodId = periode.getOID();
                } catch (Exception e) {
                }

                if (retur.getLocationId() == 0 || periodId == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                    coaALL = false;
                }

                Location loc = new Location();
                try {
                    loc = DbLocation.fetchExc(retur.getLocationId());
                    if (vendor.getLiabilitiesType() == DbVendor.LIABILITIES_TYPE_GROSIR) {
                        if (loc.getCoaApGrosirId() == 0) {
                            coaALL = false;
                        }
                    } else {
                        if (loc.getCoaApId() == 0) {
                            coaALL = false;
                        }
                    }
                } catch (Exception e) {
                }

                Vector details = DbReturItem.list(0, 0, DbReturItem.colNames[DbReturItem.COL_RETUR_ID] + " = " + retur.getOID(), null);
                for (int j = 0; j < details.size(); j++) {
                    ReturItem returItem = (ReturItem) details.get(j);
                    try {
                        ItemMaster im = new ItemMaster();
                        im = DbItemMaster.fetchExc(returItem.getItemMasterId());

                        if (im.getOID() == 0) {
                            coaALL = false;
                        }

                        try {
                            if (im.getOID() != 0) {
                                ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());

                                if (ig.getAccountInv().length() <= 0) {
                                    Coa c = new Coa();
                                    try {
                                        c = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                                    } catch (Exception e) {
                                    }

                                    if (c.getOID() == 0) {
                                        coaALL = false;
                                    }
                                }
                            }

                        } catch (Exception e) {
                            coaALL = false;
                        }

                    } catch (Exception e) {
                        coaALL = false;
                    }

                    if (coaALL == false) {
                        break;
                    }
                }

                Vector tempx = DbAccLink.list(0, 0, DbAccLink.colNames[DbAccLink.COL_TYPE] + "='" + I_Project.ACC_LINK_GROUP_PURCHASING_TAX + "'", "");
                AccLink alx = new AccLink();
                if (tempx != null && tempx.size() > 0) {
                    alx = (AccLink) tempx.get(0);
                    if (alx.getCoaId() == 0) {
                        coaALL = false;
                    }
                } else {
                    coaALL = false;
                }

                if (alx.getOID() == 0) {
                    coaALL = false;
                }

                if (coaALL == false) {
                    return 0;
                }

                if (retur.getOID() != 0 && details != null && details.size() > 0 && eRate.getOID() != 0 && coaALL == true) {

                    long oid = gl.getOID();

                    //delete journal detail        
                    if (periode.getTableName().equals(I_Project.GL_2015)) {
                        SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                    } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                        SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                    } else {
                        SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                    }

                    double amount = 0;

                    if (oid != 0) {

                        for (int i = 0; i < details.size(); i++) {

                            //journalnya inventory pada HPP                    
                            ReturItem returItem = (ReturItem) details.get(i);
                            ItemMaster im = new ItemMaster();
                            Coa coaInv = new Coa();
                            try {
                                im = DbItemMaster.fetchExc(returItem.getItemMasterId());
                                try {
                                    ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                    try {
                                        if (ig.getAccountInv().length() > 0) {
                                            coaInv = DbCoa.getCoaByCode(ig.getAccountInv().trim());
                                        }
                                    } catch (Exception e) {
                                    }

                                } catch (Exception e) {
                                }
                            } catch (Exception e) {
                            }

                            String notes = "Retur (" + retur.getNumber() + ") Pembelian Barang : " + im.getName();

                            double tmpAmount = returItem.getAmount() * returItem.getQty();

                            if (retur.getDiscountTotal() > 0) {
                                double subTotal = DbRetur.getTotalReturAmount(retur.getOID());
                                tmpAmount = tmpAmount - ((tmpAmount / subTotal) * retur.getDiscountTotal());
                            }

                            DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaInv.getOID(), tmpAmount, 0,
                                    tmpAmount, eRate.getCurrencyIdrId(), oid, notes, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);

                            amount = amount + tmpAmount;

                        }

                        AccLink al = new AccLink();
                        if (retur.getTotalTax() > 0) {

                            Vector temp = DbAccLink.list(0, 0, DbAccLink.colNames[DbAccLink.COL_TYPE] + "='" + I_Project.ACC_LINK_GROUP_PURCHASING_TAX + "'", "");
                            al = new AccLink();
                            if (temp != null && temp.size() > 0) {
                                al = (AccLink) temp.get(0);
                            }

                            String memo = "Pajak Pembelian Retur (" + retur.getNumber() + ")";
                            amount = amount + retur.getTotalTax();

                            DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), al.getCoaId(), retur.getTotalTax(), 0,
                                    retur.getTotalTax(), eRate.getCurrencyIdrId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);

                        }

                        String memo = "Hutang Retur pembelian (" + retur.getNumber() + ")";
                        long coaApId = 0;
                        if (vendor.getLiabilitiesType() == DbVendor.LIABILITIES_TYPE_GROSIR) {
                            coaApId = loc.getCoaApGrosirId();
                        } else {
                            coaApId = loc.getCoaApId();
                        }

                        DbGl.postJournalDetail(periode.getTableName(), eRate.getValueIdr(), coaApId, 0, amount,
                                amount, eRate.getCurrencyIdrId(), oid, memo, 0,
                                segment1_id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);

                        SessOptimizedJournal.optimizeJournalGl(periode, oid, "Retur (" + retur.getNumber() + ") ", "Retur (" + retur.getNumber() + ") ", 1);


                    }
                    return 1;
                } else {
                    return 0;
                }
            }


        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        return 0;
    }

    public static long rePostReceiving(Gl gl) {

        Receive receive = new Receive();

        try {
            Company comp = DbCompany.getCompany();

            ExchangeRate er = new ExchangeRate();
            try {
                er = DbExchangeRate.getStandardRate();
            } catch (Exception e) {
            }

            Vector receives = DbReceive.list(0, 1, " lower(" + DbReceive.colNames[DbReceive.COL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            receive = (Receive) receives.get(0);

            Vector vck = DbReceiveItem.list(0, 0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + receive.getOID(), "");

            long segment1_id = 0;
            boolean coaComplete = true;

            Periode p = new Periode();
            try {
                p = DbPeriode.fetchExc(gl.getPeriodId());
            } catch (Exception e) {
            }

            if (p.getOID() == 0 || p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                coaComplete = false;
                return 0;
            }

            Vendor vendor = new Vendor();
            try {
                vendor = DbVendor.fetchExc(receive.getVendorId());
            } catch (Exception e) {
            }

            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(receive.getLocationId());
                if (vendor.getLiabilitiesType() == DbVendor.LIABILITIES_TYPE_GROSIR) {
                    if (loc.getCoaApGrosirId() == 0) {
                        coaComplete = false;
                    }
                } else {
                    if (loc.getCoaApId() == 0) {
                        coaComplete = false;
                    }
                }
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            if (loc.getOID() != 0) {
                String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + loc.getOID();
                Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                if (segmentDt != null && segmentDt.size() > 0) {
                    SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                    if (sd.getRefSegmentDetailId() != 0) {
                        segment1_id = sd.getRefSegmentDetailId();
                    } else {
                        segment1_id = sd.getOID();
                    }
                } else {
                    coaComplete = false;
                }
            }

            if (coaComplete == false) {
                return 0;
            }

            if (coaComplete && receive.getOID() != 0 && receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                long oid = gl.getOID();

                //delete journal detail        
                if (p.getTableName().equals(I_Project.GL_2015)) {
                    SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                } else if (p.getTableName().equals(I_Project.GL_2016)) {
                    SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                } else {
                    SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                }

                boolean isALLBonus = true;
                long coaAllOtherIncome = 0;
                double totalBonus = 0;
                long oidDebetAdjustment = 0;
                //pengakuan hutang    

                if (oid != 0) {

                    String memo = "";
                    double subTotal = DbReceiveItem.getTotalReceiveAmount(receive.getOID());
                    double credit = 0;
                    long coaApId = loc.getCoaApId();
                    if (vendor.getLiabilitiesType() == DbVendor.LIABILITIES_TYPE_GROSIR) {
                        coaApId = loc.getCoaApGrosirId();
                    } else {
                        coaApId = loc.getCoaApId();
                    }

                    if (vck != null && vck.size() > 0) {

                        for (int i = 0; i < vck.size(); i++) {
                            ReceiveItem ri = (ReceiveItem) vck.get(i);
                            try {
                                ItemMaster im = DbItemMaster.fetchExc(ri.getItemMasterId());
                                ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());

                                Vector invCoa = new Vector();

                                //if it is stock - tambah stock
                                if (im.getNeedRecipe() == 0) {
                                    invCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_CODE] + "='" + ig.getAccountInv() + "'", "");
                                } //kalau bukan stock - lakukan ke biaya
                                else {
                                    //jika belum diisi, larikan ke inventory saja
                                    if (ig.getAccountExpenseJasa() != null && ig.getAccountExpenseJasa().length() > 0) {
                                        invCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_CODE] + "='" + ig.getAccountExpenseJasa() + "'", "");
                                    } else {
                                        invCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_CODE] + "='" + ig.getAccountInv() + "'", "");
                                    }
                                }

                                Coa coa = new Coa();
                                if (invCoa != null && invCoa.size() > 0) {
                                    coa = (Coa) invCoa.get(0);
                                }

                                double amount = 0;
                                if (ri.getIsBonus() == DbReceiveItem.BONUS) {
                                    if (ri.getAmount() != 0) {
                                        amount = ri.getTotalAmount();
                                    } else {
                                        amount = im.getCogs() * ri.getQty();
                                    }
                                } else {
                                    isALLBonus = false;
                                    amount = ri.getTotalAmount();
                                }

                                if (receive.getDiscountTotal() != 0) {
                                    amount = ri.getTotalAmount() - ((ri.getTotalAmount() / subTotal) * receive.getDiscountTotal());
                                }

                                memo = "Purchase : " + ig.getName() + "/" + im.getCode() + "-" + ig.getName();
                                credit = credit + amount;

                                if (amount != 0) {
                                    if (amount > 0) {
                                        DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), coa.getOID(), 0, amount,
                                                amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0); //non departmenttal item, department id = 0   
                                    } else {
                                        DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), coa.getOID(), (amount * -1), 0,
                                                (amount * -1), comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0); //non departmenttal item, department id = 0   
                                    }
                                }


                                if (ri.getIsBonus() == DbReceiveItem.BONUS) {
                                    Vector vOtherIncome = DbCoa.list(0, 1, DbCoa.colNames[DbCoa.COL_CODE] + "='" + ig.getAccountBonusIncome() + "'", "");
                                    Coa coaOtherIncome = new Coa();
                                    if (vOtherIncome != null && vOtherIncome.size() > 0) {
                                        coaOtherIncome = (Coa) vOtherIncome.get(0);
                                    }

                                    memo = "Bonus income : " + ig.getName() + "/" + im.getCode() + "-" + ig.getName();
                                    coaAllOtherIncome = coaOtherIncome.getOID();
                                    totalBonus = totalBonus + amount;
                                    if (amount != 0) {
                                        if (amount > 0) {
                                            DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), coaOtherIncome.getOID(), amount, 0,
                                                    amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0); //non departmenttal item, department id = 0 
                                        } else {
                                            DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), coaOtherIncome.getOID(), 0, (amount * -1),
                                                    (amount * -1), comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0); //non departmenttal item, department id = 0 
                                        }
                                    }
                                }

                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                        }
                    }

                    //jika ada pajak, masukkan ke pajak masukan                        
                    AccLink al = new AccLink();

                    if (receive.getTotalTax() != 0) {

                        Vector temp = DbAccLink.list(0, 0, DbAccLink.colNames[DbAccLink.COL_TYPE] + "='" + I_Project.ACC_LINK_GROUP_PURCHASING_TAX + "'", "");
                        al = new AccLink();
                        if (temp != null && temp.size() > 0) {
                            al = (AccLink) temp.get(0);
                        }

                        //journal debet tax
                        memo = "Pajak pembelian " + receive.getNumber();
                        credit = credit + receive.getTotalTax();

                        if (receive.getTotalTax() > 0) {
                            DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), al.getCoaId(), 0, receive.getTotalTax(),
                                    receive.getTotalTax(), comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0); //non departmenttal item, department id = 0                            
                        } else {
                            DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), al.getCoaId(), (receive.getTotalTax() * -1), 0,
                                    (receive.getTotalTax() * -1), comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0); //non departmenttal item, department id = 0                            
                        }
                        oidDebetAdjustment = al.getCoaId();

                    }

                    if (isALLBonus) {
                        credit = credit - totalBonus;
                        if (credit > 0) {
                            memo = "Bonus Income Pembelian " + receive.getNumber();
                            DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), coaAllOtherIncome, credit, 0,
                                    credit, comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0); //non departmenttal item, department id = 0                                 
                        }
                    } else {
                        credit = credit - totalBonus;
                        if (credit > 0) {
                            memo = "Hutang Pembelian :" + receive.getNumber();
                            DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), coaApId, credit, 0,
                                    credit, comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0); //non departmenttal item, department id = 0  
                        } else {
                            memo = "Hutang Pembelian :" + receive.getNumber();
                            DbGl.postJournalDetail(p.getTableName(), er.getValueIdr(), coaApId, 0, (credit * -1),
                                    (credit * -1), comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0); //non departmenttal item, department id = 0  
                        }
                    }

                    if (isALLBonus) {
                        receive.setPaymentStatus(I_Project.INV_STATUS_FULL_PAID);
                        receive.setPaymentStatusPosted(DbReceive.STATUS_FULL_PAID_POSTED);
                        try {
                            DbReceive.updateExc(receive);
                        } catch (Exception e) {
                        }
                    }
                }

                SessOptimizedJournal.optimizeJournalGl(p, oid, "Purchase (" + receive.getNumber() + ") ", "Purchase (" + receive.getNumber() + ") ", 1);

                try {
                    if (oidDebetAdjustment != 0) {
                        Vector debKred = DbReceive.valueDebetCredit(oid);
                        double debi = Double.parseDouble("" + debKred.get(0));
                        double kred = Double.parseDouble("" + debKred.get(1));

                        if (debi != kred) {
                            double valAdjustment = debi - kred;
                            long oidAdj = DbReceive.oidAdjustmentDebet(oid, oidDebetAdjustment);
                            double val = DbReceive.valueDebet(oidAdj);
                            double finalAmount = val - valAdjustment;
                            DbReceive.adjustmentValue(oidAdj, finalAmount);
                        }
                    }
                } catch (Exception e) {
                }

                return 1;
            }

        } catch (Exception e) {
        }
        return 0;
    }

    public static int rePostRepack(Gl gl) {

        Repack repack = new Repack();

        try {

            ExchangeRate er = new ExchangeRate();
            try {
                er = DbExchangeRate.getStandardRate();
            } catch (Exception e) {
            }

            Vector repacks = DbRepack.list(0, 1, " lower(" + DbRepack.colNames[DbRepack.COL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            repack = (Repack) repacks.get(0);
            if (repack.getOID() != 0) {
                Vector result = DbRepack.groupPosting(repack.getOID());
                int output = DbRepackItem.getCount(DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + " = " + repack.getOID() + " and " + DbRepackItem.colNames[DbRepackItem.COL_TYPE] + " = " + DbRepackItem.TYPE_OUTPUT);
                Vector details = DbRepackItem.list(0, 0, DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + " = " + repack.getOID() + " and " + DbRepackItem.colNames[DbRepackItem.COL_TYPE] + "=" + DbRepackItem.TYPE_OUTPUT, null);

                long periodId = 0;
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(gl.getPeriodId());
                    periodId = periode.getOID();
                } catch (Exception e) {
                }
                long segment1_id = 0;
                if (repack.getLocationId() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + repack.getLocationId();
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

                boolean coaALL = true;

                if (periodId == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                    coaALL = false;
                }

                if (result != null && result.size() > 0) {
                    for (int i = 0; i < result.size(); i++) {
                        GrpPost grpPost = (GrpPost) result.get(i);

                        if (grpPost.getAccInv() == null || grpPost.getAccInv().length() <= 0) {
                            coaALL = false;
                            break;
                        } else {
                            Coa coaInv = new Coa();
                            try {
                                coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                            } catch (Exception e) {
                            }
                            if (coaInv.getOID() == 0) {
                                coaALL = false;
                                break;
                            }
                        }
                    }
                }

                for (int j = 0; j < details.size(); j++) {
                    RepackItem repackItem = (RepackItem) details.get(j);
                    try {

                        ItemMaster im = new ItemMaster();
                        im = DbItemMaster.fetchExc(repackItem.getItemMasterId());

                        if (im.getOID() == 0) {
                            coaALL = false;
                        }

                        try {
                            if (im.getOID() != 0) {
                                ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                if (ig.getAccountInv() == null || ig.getAccountInv().length() <= 0) {
                                    coaALL = false;
                                } else {
                                    Coa coaInv = new Coa();
                                    try {
                                        coaInv = DbCoa.getCoaByCode(ig.getAccountInv());
                                    } catch (Exception e) {
                                    }

                                    if (coaInv.getOID() == 0) {
                                        coaALL = false;
                                        break;
                                    }
                                }
                            }

                        } catch (Exception e) {
                            coaALL = false;
                        }

                    } catch (Exception e) {
                        coaALL = false;
                    }

                    if (coaALL == false) {
                        break;
                    }
                }

                if (coaALL == false) {
                    return 0;
                }

                if (details == null || details.size() <= 0 || result == null || result.size() <= 0) {
                    return 0;
                }

                if (repack.getOID() != 0 && ((details != null && details.size() > 0) || (result != null && result.size() > 0)) && er.getOID() != 0 && coaALL == true) {
                    long oid = gl.getOID();

                    //delete journal detail        
                    if (periode.getTableName().equals(I_Project.GL_2015)) {
                        SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                    } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                        SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                    } else {
                        SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                    }

                    if (oid != 0) {

                        double totalIn = 0;
                        double totalOutput = 0;
                        if (result != null && result.size() > 0) {
                            for (int i = 0; i < result.size(); i++) {
                                GrpPost grpPost = (GrpPost) result.get(i);

                                String notes = repack.getNote();
                                if (notes != null && notes.length() > 0) {
                                    notes = notes + ", ";
                                }
                                notes = "Repack Number (" + repack.getNumber() + ") " + notes + "category barang " + grpPost.getName();
                                Coa coaInv = new Coa();

                                try {
                                    coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                                } catch (Exception e) {
                                }

                                DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), coaInv.getOID(), grpPost.getValue(), 0,
                                        grpPost.getValue(), er.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                totalIn = totalIn + grpPost.getValue();
                            }
                        }

                        for (int j = 0; j < details.size(); j++) {
                            RepackItem repackItem = (RepackItem) details.get(j);
                            ItemMaster im = new ItemMaster();
                            try {
                                im = DbItemMaster.fetchExc(repackItem.getItemMasterId());
                                ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                Coa coaInv = DbCoa.getCoaByCode(ig.getAccountInv());

                                String notes = repack.getNote();
                                if (notes != null && notes.length() > 0) {
                                    notes = notes + ", ";
                                }
                                notes = "Repack Number (" + repack.getNumber() + ") " + notes + "category barang " + ig.getName();

                                double balance = (repackItem.getCogs() * repackItem.getQty());

                                if (j == (output - 1)) {
                                    balance = totalIn - totalOutput;
                                } else {
                                    totalOutput = totalOutput + (repackItem.getCogs() * repackItem.getQty());
                                }

                                if (repackItem.getType() == 0) {
                                    DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), coaInv.getOID(), balance, 0,
                                            balance, er.getCurrencyIdrId(), oid, notes, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                } else {
                                    DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), coaInv.getOID(), 0, balance,
                                            balance, er.getCurrencyIdrId(), oid, notes, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }
                            } catch (Exception e) {
                            }
                        }
                    }

                    SessOptimizedJournal.optimizeJournalGl(periode, oid, "Repack (" + repack.getNumber() + ") ", "Repack (" + repack.getNumber() + ") ", 1);

                    return 1;
                }

            }
        } catch (Exception e) {
        }

        return 0;

    }

    public static void rePostAPMemo(Gl gl) {
        try {
            ExchangeRate er = DbExchangeRate.getStandardRate();
            Receive receive = new Receive();
            Vector receives = DbReceive.list(0, 1, " lower(" + DbReceive.colNames[DbReceive.COL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            receive = (Receive) receives.get(0);

            if (receive.getOID() != 0) {

                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(receive.getPeriodId());
                } catch (Exception e) {
                }

                String where = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + " = " + receive.getLocationId();
                Vector vSd = DbSegmentDetail.list(0, 1, where, null);
                SegmentDetail sd = new SegmentDetail();
                long segment1Id = 0;

                if (vSd != null && vSd.size() > 0) {
                    sd = (SegmentDetail) vSd.get(0);
                    if (sd.getRefSegmentDetailId() != 0) {
                        segment1Id = sd.getRefSegmentDetailId();
                    } else {
                        segment1Id = sd.getOID();
                    }
                }

                if (receive.getOID() != 0 && periode.getOID() != 0 && segment1Id != 0 && periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {
                    String memo = receive.getNote();
                    long oid = gl.getOID();
                    //delete journal detail        
                    if (periode.getTableName().equals(I_Project.GL_2015)) {
                        SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                    } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                        SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                    } else {
                        SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                    }

                    if (oid != 0) {

                        //Hutang pada other income
                        Vector vRi = DbReceiveItem.list(0, 0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + " = " + receive.getOID(), null);

                        double amount = 0;
                        if (vRi != null && vRi.size() > 0) {
                            String memox = "";
                            for (int i = 0; i < vRi.size(); i++) {
                                ReceiveItem ri = (ReceiveItem) vRi.get(i);
                                memo = ri.getMemo();
                                double amountItem = ri.getTotalAmount() * -1;
                                if (i == 0) {
                                    memox = ri.getMemo();
                                } else {
                                    memox = memox + ", " + ri.getMemo();
                                }

                                if (ri.getTotalAmount() <= 0) {
                                    DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), ri.getApCoaId(), amountItem, 0,
                                            amountItem, er.getCurrencyIdrId(), oid, memo, 0,
                                            segment1Id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                } else {
                                    DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), ri.getApCoaId(), 0, ri.getTotalAmount(),
                                            ri.getTotalAmount(), er.getCurrencyIdrId(), oid, memo, 0,
                                            segment1Id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }
                                amount = amount + amountItem;
                            }

                            if (amount <= 0) {
                                DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), receive.getCoaId(), amount * -1, 0,
                                        amount, receive.getCurrencyId(), oid, memox, 0,
                                        segment1Id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            } else {
                                DbGl.postJournalDetail(periode.getTableName(), er.getValueIdr(), receive.getCoaId(), 0, amount,
                                        amount * -1, receive.getCurrencyId(), oid, memox, 0,
                                        segment1Id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }
                        }
                    }
                }
            }

        } catch (Exception e) {
        }
    }

    public static void rePostReconBank(Gl gl,Company sysCompany) {
        try {
            Vector bankHistorys = DbBankPaymentHistory.list(0, 0, " lower(" + DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_JOURNAL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            
            if (bankHistorys != null && bankHistorys.size() > 0) {
                
                ExchangeRate er = DbExchangeRate.getStandardRate();
                Periode p = new Periode();
                try {
                    p = DbPeriode.fetchExc(gl.getPeriodId());
                } catch (Exception e) {
                }
                
                if (p.getOID() != 0 && p.getStatus().compareToIgnoreCase(I_Project.STATUS_PERIOD_CLOSED) != 0) {
                    
                    if (p.getTableName().equals(I_Project.GL_2015)) {
                        SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                    } else if (p.getTableName().equals(I_Project.GL_2016)) {
                        SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                    } else {
                        SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                    }
                    
                    long oidOffice = 0;
                    try {
                        oidOffice = Long.parseLong(DbSystemProperty.getValueByName("OID_SEGMENT_OFFICE"));
                    } catch (Exception ex) {}

                    long oid = gl.getOID();

                    for (int i = 0; i < bankHistorys.size(); i++) {
                        BankPaymentHistory bph = (BankPaymentHistory)bankHistorys.get(i);
                    
                        BankPayment bp = new BankPayment();
                        try{
                            bp = DbBankPayment.fetchExc(bph.getBankPaymentId());
                            if (oid != 0) {
                                if (oidOffice == 0) {
                                    oidOffice = bp.getSegment1Id();
                                }

                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), bp.getCoaPaymentId(), 0, bp.getAmount(),
                                    bp.getAmount(), sysCompany.getBookingCurrencyId(), oid, "Pencairan piutang kartu credit", 0,
                                    oidOffice, bp.getSegment2Id(), bp.getSegment3Id(), bp.getSegment4Id(),
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);

                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), bp.getCoaId(), bp.getAmount(), 0,
                                    bp.getAmount(), sysCompany.getBookingCurrencyId(), oid, "Pencairan piutang kartu credit", 0,
                                    bp.getSegment1Id(), bp.getSegment2Id(), bp.getSegment3Id(), bp.getSegment4Id(),
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            }
                        }catch(Exception e){}                     
                    }                    
                    SessOptimizedJournal.optimizeJournalGl(p, oid, "Pencairan ", "Pencairan ", 1);  
                }
            }

        } catch (Exception exx) {
        }
    }
    
    
    public static int rePostJournalGA(Gl gl){        
        try{
            GeneralAffair ga = new GeneralAffair();
            Vector gas = DbGeneralAffair.list(0, 1, " lower(" + DbGeneralAffair.colNames[DbGeneralAffair.COL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            ga = (GeneralAffair) gas.get(0);
            
            if (ga.getOID() != 0) {

                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(gl.getPeriodId());
                } catch (Exception e) {
                }

                String where = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + " = " + ga.getLocationId();
                Vector vSd = DbSegmentDetail.list(0, 1, where, null);
                SegmentDetail sd = new SegmentDetail();
                long segment1Id = 0;

                if (vSd != null && vSd.size() > 0) {
                    sd = (SegmentDetail) vSd.get(0);
                    if (sd.getRefSegmentDetailId() != 0) {
                        segment1Id = sd.getRefSegmentDetailId();
                    } else {
                        segment1Id = sd.getOID();
                    }
                }
                
                
                String whereExp = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + " = " + ga.getLocationPostId();
                Vector vSdExp = DbSegmentDetail.list(0, 1, whereExp, null);
                SegmentDetail sdExp = new SegmentDetail();
                long segment1ExpId = 0;

                if (vSdExp != null && vSdExp.size() > 0) {
                    sdExp = (SegmentDetail) vSdExp.get(0);
                    segment1ExpId = sdExp.getOID();
                }
                
                //Untuk mengecek setup coa inventory dan coa HPP agar semua ada, jika tidak maka posting di batalkan        
                boolean coaALL = true;

                if (periode.getOID() == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                    coaALL = false;
                }
                
                if(coaALL == false){
                    return 0;
                }
                
                Vector result = DbGeneralAffair.groupPosting(ga.getOID(),null);
                
                if (ga.getOID() != 0 && ((result != null && result.size() > 0)) && coaALL == true){
                    long oid = gl.getOID();
                    ExchangeRate eRate = DbExchangeRate.getStandardRate();
                    if(oid != 0){                        
                        if (periode.getTableName().equals(I_Project.GL_2015)) {
                            SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                        } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                            SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                        } else {
                            SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                        }
                        
                        if(result != null && result.size() > 0){
                            for(int i = 0 ; i < result.size();i++){
                                GrpPost grpPost = (GrpPost)result.get(i);
                        
                                String notes = ga.getNote();
                                if(notes != null && notes.length() > 0){
                                    notes = notes+", ";
                                }
                                notes = "GA Number : ("+ga.getNumber()+") "+notes+" category "+grpPost.getName();
                        
                                Coa coaExp = new Coa();
                                Coa coaInv = new Coa();
                        
                                try{
                                    coaExp = DbCoa.getCoaByCode(grpPost.getAccAdjusment());
                                }catch(Exception e){}
                        
                                try{
                                    coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                                }catch(Exception e){}
                        
                                DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaInv.getOID(), grpPost.getValue(), 0,
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1Id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                    
                                DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaExp.getOID(), 0,grpPost.getValue(),
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1ExpId, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }
                        }                     
                    }
                }
            }
        }catch(Exception e){}
          
        return 1;
    }
    
    
     public static int rePostJournalPembayaran(Gl gl){

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();        
        try{
            Vector bankPayments = DbBankpoPayment.list(0, 1, " lower(" + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            BankpoPayment cr = (BankpoPayment)bankPayments.get(0);
            
            Vector details = DbBankpoPaymentDetail.list(0, 0,DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+"="+cr.getOID(), null);
            
            Periode periode = new Periode();
            try {
                periode = DbPeriode.fetchExc(gl.getPeriodId());
            } catch (Exception e) {}
            
            if (periode.getOID() == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                return 0;
            }            
            
            if(gl.getOID() != 0 && details != null && details.size() > 0){
                long oid = gl.getOID();
                if (oid != 0) {
                    if (periode.getTableName().equals(I_Project.GL_2015)) {
                        SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                    } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                        SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                    } else {
                        SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                    }
                    
                    for (int i = 0; i < details.size(); i++) {

                        BankpoPaymentDetail crd = (BankpoPaymentDetail) details.get(i);
                        //journal debet pada suspense account

                        DbGl.postJournalDetail(er.getValueIdr(), crd.getCoaId(), 0, crd.getPaymentAmount(),
                            0, comp.getBookingCurrencyId(), oid, crd.getMemo(), 0,
                            crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
                            crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
                            crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
                            crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getModuleId());
                    }

                    //journal credit pada kas
                    DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), cr.getAmount(), 0,
                        0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0); // petty cash : non departmental coa
                    
                }
            }
            
            
        }catch(Exception e){}
        
        return 1;
    }
     
     
    public static int rePostJournalBankDeposit(Gl gl){
            
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
                
        try{
            Vector bankDeposits = DbBankDeposit.list(0, 1, " lower(" + DbBankDeposit.colNames[DbBankDeposit.COL_JOURNAL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            BankDeposit cr = (BankDeposit)bankDeposits.get(0);
            Vector details = DbBankDepositDetail.list(0, 0,DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID]+"="+cr.getOID(), null);
            
            Periode periode = new Periode();
            try {
                periode = DbPeriode.fetchExc(gl.getPeriodId());
            } catch (Exception e) {}
            
            if (periode.getOID() == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                return 0;
            } 
            
            if(gl.getOID() != 0 && details != null && details.size() > 0){
                long oid = gl.getOID(); 
                if(oid!=0){
                    if (periode.getTableName().equals(I_Project.GL_2015)) {
                        SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                    } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                        SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                    } else {
                        SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                    }
                    
                    for(int i=0; i<details.size(); i++){
                        BankDepositDetail crd = (BankDepositDetail)details.get(i);
                        if(crd.getAmount()!=0){ 
                                //journal credit pada pendapatan
                                DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), crd.getAmount(), 0,             
                                    crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), 0,
			                        crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
			                        crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
			                        crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
			                        crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getDepartmentId()
                                );
                        }else{
                                DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), 0, crd.getCreditAmount(),             
                                    crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), 0,
			                        crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
			                        crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
			                        crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
			                        crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getDepartmentId()
                                );
                        }                   
                    }
                      
                    //journal debet pada cash
                    DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), 0, cr.getAmount(),             
                                    0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
			                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
			                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
			                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
			                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0
                    );  
                    
                }
            }
                    
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            } 
        
        return 1;
    }
    
    
    public static int rePostJournalCosting(Gl gl){
        
        ExchangeRate eRate = DbExchangeRate.getStandardRate();
        
        try {
            Vector costings = DbCosting.list(0, 1, " lower(" + DbCosting.colNames[DbCosting.COL_NUMBER] + ") = '" + gl.getJournalNumber().toLowerCase() + "'", null);
            Costing cst = (Costing)costings.get(0);
            
            //Vector details = DbCostingItem.list(0, 0,DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID]+"="+cst.getOID(), null);
            Vector result = DbCosting.groupPosting(cst.getOID(),null);
            
            Periode periode = new Periode();
            try {
                periode = DbPeriode.fetchExc(gl.getPeriodId());
            } catch (Exception e) {}
            
            if (periode.getOID() == 0 || periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                return 0;
            } 
            
            if(gl.getOID() != 0 && result != null && result.size() > 0){
                long oid = gl.getOID();
                long segment1_id = 0;        
                long segmentExpenseId = 0;
                
                if (periode.getTableName().equals(I_Project.GL_2015)) {
                    SessOptimizedJournal.deleteAllDetailGl2015(gl.getOID());
                } else if (periode.getTableName().equals(I_Project.GL_2016)) {
                    SessOptimizedJournal.deleteAllDetailGl2016(gl.getOID());
                } else {
                    SessOptimizedJournal.deleteAllDetailGl(gl.getOID());
                }                
        
                if (cst.getLocationId() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + cst.getLocationId();
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
        
                if(cst.getLocationPostId() != 0){
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + cst.getLocationPostId();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);

                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        if(sd.getRefSegmentDetailId() != 0){
                            segmentExpenseId = sd.getRefSegmentDetailId();
                        }else{
                            segmentExpenseId = sd.getOID();
                        }
                    }        
                }else{    
                    segmentExpenseId = segment1_id;
                }
                
                if(result != null && result.size() > 0){
                    for(int i = 0 ; i < result.size();i++){
                        GrpPost grpPost = (GrpPost)result.get(i);
                        
                        String notes = cst.getNote();
                        if(notes != null && notes.length() > 0){
                            notes = notes+", ";
                        }                        
                        notes = "Costing/Spoil Number ("+cst.getNumber()+") "+notes + " category barang "+grpPost.getName();
                        
                        Coa coaExp = new Coa();
                        Coa coaInv = new Coa();
                        
                        try{
                            coaExp = DbCoa.getCoaByCode(grpPost.getAccCosting());
                        }catch(Exception e){}
                        
                        try{
                            coaInv = DbCoa.getCoaByCode(grpPost.getAccInv());
                        }catch(Exception e){}
                        
                        DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaInv.getOID(), grpPost.getValue(), 0,
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                    
                        DbGl.postJournalDetail(periode.getTableName(),eRate.getValueIdr(), coaExp.getOID(), 0, grpPost.getValue(),
                                        grpPost.getValue(), eRate.getCurrencyIdrId(), oid, notes, 0,
                                        segmentExpenseId, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                    }
                }
                
                
            }    
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        return 1;
    }
    
    
}
