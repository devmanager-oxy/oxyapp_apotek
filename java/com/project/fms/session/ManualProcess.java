/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

import com.project.I_Project;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.sales.CreditPayment;
import com.project.ccs.postransaction.sales.DbCreditPayment;
import com.project.ccs.postransaction.sales.DbPayment;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.sales.Payment;
import com.project.ccs.postransaction.sales.Sales;
import com.project.ccs.postransaction.sales.SalesDetail;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.ccs.postransaction.stock.Stock;
import com.project.ccs.session.CoaSalesDetail;
import com.project.ccs.session.MasterGroup;
import com.project.ccs.session.MasterOid;
import com.project.ccs.session.SessCreditPayment;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.BankpoPaymentDetail;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.GlDetail;
import java.io.*;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.system.DbSystemProperty;
import com.project.util.*;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author Roy Andika
 */
public class ManualProcess {

    public static Vector getRec() {

        CONResultSet dbrs = null;
        try {

            String sql = "select rec_id,number,vendor from coco_receive";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector list = new Vector();

            while (rs.next()) {
                Rec rec = new Rec();
                rec.setRecId(rs.getLong("rec_id"));
                rec.setNumber(rs.getString("number"));
                rec.setVendor(rs.getString("vendor"));
                list.add(rec);
            }
            return list;
        } catch (Exception e) {
        }

        return null;
    }

    public static void cekVendor(String vendor) {

        CONResultSet dbrs = null;
        try {

            String sql = "select vendor_id,name,is_konsinyasi, system from vendor where name='" + vendor + "'";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long vendorId = rs.getLong("vendor_id");
                String name = rs.getString("name");
                int kons = rs.getInt("is_konsinyasi");
                int sys = rs.getInt("system");

                System.out.println(" vendor_id = " + vendorId + ", name =" + name + ", kons =" + kons + ", system = " + sys);
            }

        } catch (Exception e) {
        }

    }

    public static void cekTT(long recId) {

        CONResultSet dbrs = null;
        try {

            String sql = "select bankpo_payment_id,bankpo_payment_detail_id,invoice_id from bankpo_payment_detail where invoice_id='" + recId + "'";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long bankpoId = rs.getLong("bankpo_payment_id");
                //System.out.println(bankpoId);
                Vector vBd = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " = " + bankpoId, null);
                if (vBd != null && vBd.size() > 0) {
                    for (int i = 0; i < vBd.size(); i++) {
                        BankpoPaymentDetail bpd = (BankpoPaymentDetail) vBd.get(i);
                        long invoiceId = bpd.getInvoiceId();
                        //System.out.println(bpd.getInvoiceId());
                        //prosesJournal(bpd.get);
                        Receive r = new Receive();
                        try {
                            r = DbReceive.fetchExc(invoiceId);
                        //System.out.println("receive number = "+r.getNumber()+",type = "+r.getType());
                        //prosesJournal(r.getNumber());
                        } catch (Exception e) {
                        }
                    }
                } else {
                    System.out.println(">>> null bankpo_id = " + bankpoId + ", invoice_id = ");
                }

                BankpoPayment bp = new BankpoPayment();
                try {
                    bp = DbBankpoPayment.fetchExc(bankpoId);
                } catch (Exception e) {
                }

                if (bp.getOID() != 0) {
                    prosesJournal(bp.getJournalNumber());
                } else {
                //System.out.println(">>> null ");
                }
            }

        } catch (Exception e) {
        }

    }

    public static void prosesJournal(String journal) {
        CONResultSet dbrs = null;
        try {
            String sql = "select gl_id,journal_number,journal_type from gl where journal_number = '" + journal + "'";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long glId = rs.getLong("gl_id");
                Vector gld = new Vector();
                gld = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + glId, null);
                if (gld != null && gld.size() > 0) {
                    for (int i = 0; i < gld.size(); i++) {
                        GlDetail gd = (GlDetail) gld.get(i);
                        System.out.println(gd.getOID());
                    }
                }

            //String number = rs.getString("journal_number");
            //int journal_type = rs.getInt("journal_type");
            //System.out.println(glId);
            }
        } catch (Exception e) {
        }
    }

    public static void prosesKonsinyasi() {
        Vector result = getRec();
        for (int i = 0; i < result.size(); i++) {
            Rec rec = (Rec) result.get(i);
            prosesJournal(rec.getNumber());
        //System.out.println(rec.getRecId());
        //cekVendor(rec.getVendor());
        //cekTT(rec.getRecId());
        }
    }

    public static long deleteGlDetail(long glId) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from gl_detail where gl_id = " + glId;
            long oid = CONHandler.execUpdate(sql);
            return oid;
        } catch (Exception e) {
            System.out.println("[exception]");
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;

    }
    
    public static long deleteGl(long glId) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from gl where gl_id = " + glId;
            long oid = CONHandler.execUpdate(sql);
            return oid;
        } catch (Exception e) {
            System.out.println("[exception]");
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }
    
    public static long deleteBankpo(long bankId) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" where "+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = " + bankId;
            long oid = CONHandler.execUpdate(sql);
            return oid;
        } catch (Exception e) {
            System.out.println("[exception]");
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }
    
    public static long deleteBankpoDetail(long bankId) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" where "+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = " + bankId;
            long oid = CONHandler.execUpdate(sql);
            return oid;
        } catch (Exception e) {
            System.out.println("[exception]");
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }

    public static Vector listSales(long locationId, Date start, Date end, String number) {

        CONResultSet dbrs = null;

        try {

            String sql = "select s.sales_id as sales_id,s.date as date,s.number as number,sum((sd.qty * sd.selling_price) - sd.discount_amount ) as total, " +
                    " s.posted_status as posted_status, s.type as type, s.name as cst_name " +
                    " from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id ";

            sql = sql + "where to_days(s.date) >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(s.date) <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";

            if (locationId != 0) {
                sql = sql + " and s.location_id = " + locationId;
            }

            if (number != null && number.length() > 0) {
                sql = sql + " and s.number like '%" + number + "%'";
            }

            sql = sql + " group by s.sales_id order by year(s.date),month(s.date),date(s.date),s.number";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                Sales s = new Sales();
                s.setOID(rs.getLong("sales_id"));
                s.setDate(rs.getDate("date"));
                s.setNumber(rs.getString("number"));
                s.setAmount(rs.getDouble("total"));
                s.setType(rs.getInt("type"));
                s.setName(rs.getString("cst_name"));
                s.setPostedStatus(rs.getInt("posted_status"));
                result.add(s);

            }
            return result;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;

    }

    public static long getGlId(String number) {

        CONResultSet dbrs = null;
        long oid = 0;
        try {

            String sql = "select " + DbGl.colNames[DbGl.COL_GL_ID] + " from " + DbGl.DB_GL + " where " + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + number + "'";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                oid = rs.getLong(DbGl.colNames[DbGl.COL_GL_ID]);
            }

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return oid;

    }

    public static Vector getRepostingSales(long locationId, Date start, Date end, String number, int posted, int bkp,int stockAble) {
        CONResultSet dbrs = null;
        Vector result = new Vector();
        try {
            String sql = "select distinct s.* from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master im on sd.product_master_id = im.item_master_id where to_days(s.date) >= to_days('" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "') and to_days(s.date) <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";

            if (bkp != -1) {
                sql = sql + " and im.is_bkp = " + bkp;
            }
            
            if(stockAble != -1){
                sql = sql + " and im.need_recipe = " + stockAble;
            }

            if (locationId != 0) {
                sql = sql + " and s.location_id=" + locationId;
            }

            if (number != null && number.length() > 0) {
                sql = sql + " and s.number like '%" + number + "%'";
            }

            if (posted != -1) {
                sql = sql + " and s.status = " + posted;
            }


            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Sales sales = new Sales();
                sales.setOID(rs.getLong(DbSales.colNames[DbSales.COL_SALES_ID]));
                sales.setDate(rs.getDate(DbSales.colNames[DbSales.COL_DATE]));
                sales.setNumber(rs.getString(DbSales.colNames[DbSales.COL_NUMBER]));
                sales.setNumberPrefix(rs.getString(DbSales.colNames[DbSales.COL_NUMBER_PREFIX]));
                sales.setCounter(rs.getInt(DbSales.colNames[DbSales.COL_COUNTER]));
                sales.setName(rs.getString(DbSales.colNames[DbSales.COL_NAME]));
                sales.setCustomerId(rs.getLong(DbSales.colNames[DbSales.COL_CUSTOMER_ID]));
                sales.setCustomerPic(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC]));
                sales.setCustomerPicPhone(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC_PHONE]));
                sales.setCustomerAddress(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_ADDRESS]));
                sales.setStartDate(rs.getDate(DbSales.colNames[DbSales.COL_START_DATE]));
                sales.setEndDate(rs.getDate(DbSales.colNames[DbSales.COL_END_DATE]));
                sales.setCustomerPicPosition(rs.getString(DbSales.colNames[DbSales.COL_CUSTOMER_PIC_POSITION]));
                sales.setEmployeeId(rs.getLong(DbSales.colNames[DbSales.COL_EMPLOYEE_ID]));
                sales.setUserId(rs.getLong(DbSales.colNames[DbSales.COL_USER_ID]));
                sales.setEmployeeHp(rs.getString(DbSales.colNames[DbSales.COL_EMPLOYEE_HP]));
                sales.setDescription(rs.getString(DbSales.colNames[DbSales.COL_DESCRIPTION]));
                sales.setStatus(rs.getInt(DbSales.colNames[DbSales.COL_STATUS]));
                sales.setAmount(rs.getDouble(DbSales.colNames[DbSales.COL_AMOUNT]));
                sales.setCurrencyId(rs.getLong(DbSales.colNames[DbSales.COL_CURRENCY_ID]));
                sales.setCompanyId(rs.getLong(DbSales.colNames[DbSales.COL_COMPANY_ID]));
                sales.setCategoryId(rs.getLong(DbSales.colNames[DbSales.COL_CATEGORY_ID]));
                sales.setDiscountPercent(rs.getDouble(DbSales.colNames[DbSales.COL_DISCOUNT_PERCENT]));
                sales.setDiscountAmount(rs.getDouble(DbSales.colNames[DbSales.COL_DISCOUNT_AMOUNT]));
                sales.setVat(rs.getInt(DbSales.colNames[DbSales.COL_VAT]));
                sales.setVatPercent(rs.getDouble(DbSales.colNames[DbSales.COL_VAT_PERCENT]));
                sales.setVatAmount(rs.getDouble(DbSales.colNames[DbSales.COL_VAT_AMOUNT]));
                sales.setDiscount(rs.getInt(DbSales.colNames[DbSales.COL_DISCOUNT]));
                sales.setWarrantyStatus(rs.getInt(DbSales.colNames[DbSales.COL_WARRANTY_STATUS]));
                sales.setWarrantyDate(rs.getDate(DbSales.colNames[DbSales.COL_WARRANTY_DATE]));
                sales.setWarrantyReceive(rs.getString(DbSales.colNames[DbSales.COL_WARRANTY_RECEIVE]));
                sales.setManualStatus(rs.getInt(DbSales.colNames[DbSales.COL_MANUAL_STATUS]));
                sales.setManualDate(rs.getDate(DbSales.colNames[DbSales.COL_MANUAL_DATE]));
                sales.setManualReceive(rs.getString(DbSales.colNames[DbSales.COL_MANUAL_RECEIVE]));
                sales.setNoteClosing(rs.getString(DbSales.colNames[DbSales.COL_NOTE_CLOSING]));
                sales.setBookingRate(rs.getDouble(DbSales.colNames[DbSales.COL_BOOKING_RATE]));
                sales.setExchangeAmount(rs.getDouble(DbSales.colNames[DbSales.COL_EXCHANGE_AMOUNT]));
                sales.setProposalId(rs.getLong(DbSales.colNames[DbSales.COL_PROPOSAL_ID]));
                sales.setUnitUsahaId(rs.getLong(DbSales.colNames[DbSales.COL_UNIT_USAHA_ID]));
                sales.setType(rs.getInt(DbSales.colNames[DbSales.COL_TYPE]));
                sales.setPphType(rs.getInt(DbSales.colNames[DbSales.COL_PPH_TYPE]));
                sales.setPphPercent(rs.getDouble(DbSales.colNames[DbSales.COL_PPH_PERCENT]));
                sales.setPphAmount(rs.getDouble(DbSales.colNames[DbSales.COL_PPH_AMOUNT]));
                sales.setSalesType(rs.getInt(DbSales.colNames[DbSales.COL_SALES_TYPE]));
                sales.setMarketingId(rs.getLong(DbSales.colNames[DbSales.COL_MARKETING_ID]));
                sales.setLocation_id(rs.getLong(DbSales.colNames[DbSales.COL_LOCATION_ID]));
                sales.setPaymentStatus(rs.getInt(DbSales.colNames[DbSales.COL_PAYMENT_STATUS]));
                sales.setCashCashierId(rs.getLong(DbSales.colNames[DbSales.COL_CASH_CASHIER_ID]));
                sales.setShift_id(rs.getLong(DbSales.colNames[DbSales.COL_SHIFT_ID]));
                sales.setCash_master_id(rs.getLong(DbSales.colNames[DbSales.COL_CASH_MASTER_ID]));
                sales.setPostedStatus(rs.getInt(DbSales.colNames[DbSales.COL_POSTED_STATUS]));
                sales.setPostedById(rs.getLong(DbSales.colNames[DbSales.COL_POSTED_BY_ID]));
                sales.setPostedDate(rs.getDate(DbSales.colNames[DbSales.COL_POSTED_DATE]));
                sales.setEffectiveDate(rs.getDate(DbSales.colNames[DbSales.COL_EFFECTIVE_DATE]));
                sales.setStatus_stock(rs.getInt(DbSales.colNames[DbSales.COL_STATUS_STOCK]));
                sales.setSalesReturId(rs.getLong(DbSales.colNames[DbSales.COL_SALES_RETUR_ID]));

                result.add(sales);
            }
            return result;

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static void rePostJournalRetur(Vector temp, long userId, long periodIdx,Company comp){
        
        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;
        long deffCurrIDR = 0;
        try {
            deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));            
        } catch (Exception e) {}
        
        Periode p = new Periode();
        if(periodIdx != 0){
            try{
                p = DbPeriode.fetchExc(periodIdx);
            }catch(Exception e){}
        }        
        
        if (v != null && v.size() > 0){

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                long segment1_id = 0;                

                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();
                long periodId = periodIdx;
                Periode periode = new Periode();               
                
                //Parameter Multy Bank                
                Hashtable hAccSalesDetail = new Hashtable();               
                
                if(periodId == 0){    
                    try {
                        periode = DbPeriode.getPeriodByTransDate(sales.getDate());
                        periodId = periode.getOID();
                    } catch (Exception e) {}                    
                }else{
                    periode = p;
                }
                
                if (periode.getStatus().compareTo("Closed") == 0) {
                    coaLocationTrue = false;
                }                

                if (sales.getSalesReturId() != 0) { 

                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {}

                        if (payment.getCurrency_id() == 0) {
                            try {
                                long currIDR = deffCurrIDR;
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {}
                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                            } catch (Exception e) {}
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());                           
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }

                        if (comp.getMultiBank() == DbCompany.MULTI_BANK) { // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }
                    }

                    try {
                        if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            Sales slRet = new Sales();
                            try {
                                slRet = DbSales.fetchExc(sales.getSalesReturId());
                            } catch (Exception e) {
                            }
                            if (slRet.getStatus() == 0) {
                                coaLocationTrue = false;
                            }
                        }
                    } catch (Exception e) {
                        coaLocationTrue = false;
                    }

                    try {
                        if (sales.getLocation_id() != 0) {
                            location = DbLocation.fetchExc(sales.getLocation_id());
                            Coa co = new Coa();
                            if (location.getCoaSalesId() == 0) {
                                coaLocationTrue = false;
                            } else {
                                try {
                                    co = DbCoa.fetchExc(location.getCoaSalesId());
                                    if (co.getOID() == 0) {
                                        coaLocationTrue = false;
                                    }
                                } catch (Exception e) {
                                    coaLocationTrue = false;
                                }
                            }
                           
                        } else {
                            coaLocationTrue = false;
                        }
                    } catch (Exception e) {
                    }

                    Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");
                    
                    for (int ix = 0; ix < dtls.size(); ix++) {

                        SalesDetail sdCk = (SalesDetail) dtls.get(ix);
                        CoaSalesDetail csd = new CoaSalesDetail();
                        csd.setSalesDetailId(sdCk.getOID());
                        csd.setProductMasterId(sdCk.getProductMasterId()); 
                        
                        MasterGroup mg = new MasterGroup();
                        try {                        
                            mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                                                
                        } catch (Exception e) {}
                    
                        csd.setItemName(mg.getName());
                        csd.setIsBkp(mg.getIsBkp());     
                        csd.setNeedBom(mg.getNeedBom());
                    
                        // =========== OID PENJUALAN CASH==============
                        MasterOid coaSales = new MasterOid();
                        try {
                            coaSales = DbItemMaster.getOidByCode(mg.getAccSales().trim());                        
                        } catch (Exception e) {}

                        if (coaSales.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }                    
                        csd.setAccSales(coaSales.getOidMaster());                    
                        //============== END ===========================
                        
                        //==========Pendapatan Service=================
                        if(sales.getServicePercent() != 0){
                        
                            MasterOid coaService = new MasterOid();
                            try {
                                coaService = DbItemMaster.getOidByCode(mg.getAccOtherIncome().trim());                        
                            } catch (Exception e) {}

                            if (coaService.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }       
                            csd.setAccOtherIncome(coaService.getOidMaster());
                        }
                        //============== END ====================  
                    
                        
                        // =========== OID PPN ==============
                        MasterOid coaPpn = new MasterOid();
                        try {
                            coaPpn = DbItemMaster.getOidByCode(mg.getAccVat().trim());
                        } catch (Exception e) {}
                        
                        if (coaPpn.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }                    
                        csd.setAccPpn(coaPpn.getOidMaster());                    
                        //============== END ===========================
                        
                        csd.setService(mg.getService());
                        
                        if(mg.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                            Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sdCk.getOID(), null);
                        
                            if(vStock != null && vStock.size() > 0){
                                for(int d = 0; d < vStock.size() ; d++){                            
                                
                                    Stock stock = (Stock)vStock.get(d);
                                    MasterGroup mgx = new MasterGroup();
                                    try {                        
                                        mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                    } catch (Exception e) {}
                                
                                    // =========== OID INVENTORY==============
                                    MasterOid coaInv = new MasterOid();
                                    try {
                                        coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                    } catch (Exception e) {}
                            
                                    if (coaInv.getOidMaster() == 0) {
                                        coaLocationTrue = false;                            
                                    }     
                                
                                    // =========== OID COGS==============
                                    MasterOid coaCogs = new MasterOid();
                                    try {
                                        coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                    } catch (Exception e) {}
                            
                                    if (coaCogs.getOidMaster() == 0) {
                                        coaLocationTrue = false;
                                    }                                
                                    //============== END ===========================
                                }
                            }
                        
                        }else{
                             if (sdCk.getCogs() > 0 && mg.getService() == 0){  // Jika bukan service && cogs tidak sama dengan 0                      
                            
                                // =========== OID INVENTORY==============
                                MasterOid coaInv = new MasterOid();
                                try {
                                    coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());   
                                } catch (Exception e) {}
                            
                                if (coaInv.getOidMaster() == 0) {
                                    coaLocationTrue = false;                            
                                }                                                    
                                csd.setAccInv(coaInv.getOidMaster());  
                                //============== END ===========================
                        
                                // =========== OID COGS==============
                                MasterOid coaCogs = new MasterOid();
                                try {
                                    coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                                } catch (Exception e) {}
                            
                                if (coaCogs.getOidMaster() == 0) {
                                    coaLocationTrue = false;
                                }
                                csd.setAccCogs(coaCogs.getOidMaster());  
                                //============== END ===========================
                            }
                        }
                    
                        hAccSalesDetail.put(""+sdCk.getOID(), csd); // di save di hashtable untuk memudahkan pengambilan berikutnya                        
                    }

                    if (coaLocationTrue) { // jika kondisi setup coa untuk sales tidak kosong

                        Customer cust = new Customer();
                        if (sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            try {
                                cust = DbCustomer.fetchExc(sales.getCustomerId());
                            } catch (Exception ex) {}
                        }

                        //jurnal main
                        String memo = "";
                        if (sales.getType() == DbSales.TYPE_RETUR_CASH) {
                            memo = "Retur Cash sales, " + location.getName();
                        } else {
                            memo = "Retur Credit sales, " + location.getName() +
                                    " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());
                        }

                        String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + sales.getNumber() + "'";
                        Gl gx = new Gl();                        
                        long oid = gx.getOID();
                        Vector listGl = DbGl.list(0, 1, whereGl, null);
                        String number = sales.getNumber();
                        
                        if (listGl != null && listGl.size() > 0) {
                            gx = (Gl) listGl.get(0);
                            oid = gx.getOID();
                            ManualProcess.deleteGlDetail(oid); // delete gl detail                        
                        } else {
                            //post jurnal
                            oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                I_Project.JOURNAL_TYPE_RETUR,
                                memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);
                        }

                        //jika sukses input gl
                        if (oid != 0) {
                            //jurnal debet
                            double amount = 0;
                            double amountTotal = 0;
                            double dicGlobal = 0;
                        
                            for (int x = 0; x < dtls.size(); x++) {
                                SalesDetail sd = (SalesDetail) dtls.get(x);                            
                                amountTotal =  amountTotal + ((sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount());                              
                            }    
                        
                            dicGlobal = (sales.getGlobalDiskon() * 100)/amountTotal;
                            int isFeePaidByComp = SessCreditPayment.isFeeByCompany(sales.getOID());  
                        
                            for (int x = 0; x < dtls.size(); x++) {

                                SalesDetail sd = (SalesDetail) dtls.get(x);
                                
                                CoaSalesDetail csd = new CoaSalesDetail();                            
                                try{
                                    csd = (CoaSalesDetail)hAccSalesDetail.get(""+sd.getOID());
                                }catch(Exception e){} 
                                
                                double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();                              
                            
                                //pemrosesan diskon global
                                double diskonGlobal = 0;
                            
                                if(sales.getGlobalDiskon() != 0){
                                    diskonGlobal = amountTransaction * (dicGlobal/100);
                                    amountTransaction = amountTransaction - diskonGlobal;
                                }
                            
                                double amountService = 0;
                                if(sales.getServicePercent() != 0){
                                    amountService = amountTransaction * (sales.getServicePercent()/100);                                  
                                }                     
                                
                                
                                if(sales.getVatPercent() != 0 || sales.getServicePercent() != 0){
                                
                                    double amountVat = 0;
                                    if(sales.getVatPercent() != 0){
                                        amountVat = (amountTransaction + amountService) * (sales.getVatPercent()/100);
                                    }
                                
                                    memo = "sales item " + csd.getItemName();                                                               
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                        amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);                                    
                                
                                    memo = "ppn " + csd.getItemName();                                
                                    if(amountVat != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountVat,
                                            amountVat, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }        
                                
                                    memo = "Pendapatan Service "+csd.getItemName();                                
                                    if(amountService != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccOtherIncome(), 0, amountService,
                                            amountService, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                
                                    amount = amount + (amountTransaction + amountVat + amountService);
                            
                                }else{
                                    
                                     if (comp.getUseBkp() == DbCompany.USE_BKP && csd.getIsBkp() == DbItemMaster.BKP) {
                                        
                                        double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                        double amountPpn = amountTransaction - price;

                                        memo = "Retur sales item " + csd.getItemName();

                                        if(price != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, price,
                                                price, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }                            

                                        memo = "ppn " + csd.getItemName();
                                        if(amountPpn != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountPpn,
                                                amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }        
                                        amount = amount + (price + amountPpn);

                                    } else {

                                        memo = "Retur sales item " + csd.getItemName();                                        
                                        if(amountTransaction != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                                amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }        
                                        amount = amount + amountTransaction;
                                    }
                                }
                                 
                                
                                if(csd.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                                    Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sd.getOID(), null);
                        
                                    if(vStock != null && vStock.size() > 0){
                                    
                                        for(int d = 0; d < vStock.size() ; d++){                            
                                
                                            Stock stock = (Stock)vStock.get(d);
                                            double hpp = stock.getQty() * stock.getPrice();
                                        
                                            if(hpp != 0){
                                            
                                                String itemName = "";                                            
                                                try{
                                                    itemName = getItemName(stock.getItemMasterId());
                                                }catch(Exception e){}
                                        
                                                MasterGroup mgx = new MasterGroup();
                                                try {                        
                                                    mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                                } catch (Exception e) {}
                                
                                                // =========== OID INVENTORY==============
                                                MasterOid coaInv = new MasterOid();
                                                try {
                                                    coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                                } catch (Exception e) {}
                                
                                                // =========== OID COGS==============
                                                MasterOid coaCogs = new MasterOid();
                                                try {
                                                    coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                                } catch (Exception e) {}
                                            
                                                memo = "inventory : " + itemName;
                                                DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOidMaster(), 0, hpp,
                                                    hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                                //journal hpp
                                            
                                                memo = "hpp : " + itemName;
                                                DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOidMaster(), hpp, 0,
                                                    hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                                //============== END ===========================
                                            }
                                        }
                                    }                        
                                }else{
                                    
                                    if (sd.getCogs() > 0 && csd.getService() == 0){                                       
                                    
                                        //jurnal inventory
                                        memo = "inventory : " + csd.getItemName();
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccInv(), 0 , sd.getCogs() * sd.getQty(),
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        //journal hpp
                                        memo = "hpp : " + csd.getItemName();
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccCogs(), sd.getCogs() * sd.getQty(), 0,
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }     
                                } 
                            }

                            Coa coa = new Coa();
                            Coa coaExpense = new Coa();
                            Coa coaPendapatan = new Coa();
                            double amountExpense = 0;

                            if (sales.getType() == DbSales.TYPE_RETUR_CASH){

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD){

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}

                                        } else {

                                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                memo = "Piutang Credit Card";
                                            } else {
                                                memo = "Piutang Debit Card";
                                            }

                                            try {
                                                try {
                                                    merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                } catch (Exception e) {}
                                                    
                                                try {
                                                    coa = DbCoa.fetchExc(merchant.getCoaId());
                                                } catch (Exception e) {}
                                                    
                                                try {
                                                    coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                } catch (Exception e) {}

                                                if (merchant.getPersenExpense() > 0) {
                                                    amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                }

                                            } catch (Exception e) {}
                                           
                                        }

                                    }else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER) {
                                        memo = "Transfer Bank";
                                        Bank bank = new Bank();
                                        try{
                                            bank = DbBank.fetchExc(payment.getBankId());
                                        }catch(Exception e){}
                                        
                                        try{
                                            coa = DbCoa.fetchExc(bank.getCoaARId());
                                        }catch(Exception e){}
                                        
                                    }
                                } else {                                    
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {}
                                }

                            } else {
                                try {
                                    coa = DbCoa.fetchExc(location.getCoaArId());
                                } catch (Exception e) {
                                }
                                memo = "Credit Sales";
                            }

                            double amountPiutang = 0;

                            if (amountExpense > 0) {
                                String memoPiutang = "";
                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                    memo = "Biaya Komisi Credit Card";
                                    memoPiutang = "Credit Card";
                                } else {
                                    memo = "Biaya Komisi Debit Card";
                                    memoPiutang = "Debit Card";
                                }
                                
                                if(isFeePaidByComp != 0){ // jika biaya kartu di bayar pembeli
                                
                                    if (amountExpense != 0) {
                                        DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                            amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    
                                        try {
                                            coaPendapatan = DbCoa.fetchExc(merchant.getPendapatanMerchant());
                                        } catch (Exception e) {}                                    
                                    
                                        DbGl.postJournalDetail(er.getValueIdr(), coaPendapatan.getOID(), amountExpense, 0,
                                            amountExpense, comp.getBookingCurrencyId(), oid, "Pendapatan Merchant", 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);                                    
                                    }
                                
                                    double piutangCC = amount;
                                    amountPiutang = piutangCC;
                                
                                    if(piutangCC != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                
                                }else{
                                    
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                        amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);

                                    double piutangCC = amount - amountExpense;
                                    amountPiutang = piutangCC;
                                    if(piutangCC != 0){
                                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }  
                                }
                                
                            } else {
                                                 
                                amountPiutang = amount;
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }

                            Date dt = new Date();

                            String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
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

                            updateStatus(sales.getOID(), userId, effectiveDate);
                                                    
                            DbGl.optimizedJournal(oid);
                        }
                    }                
                }else{ //kalau kasirnya tidak menginputkan no transaksi yang di retur
                         
                        if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY){
                            try {
                                Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                                if (vPayment != null && vPayment.size() > 0) {
                                    payment = (Payment) vPayment.get(0);
                                }
                            } catch (Exception e) {}

                            if (payment.getCurrency_id() == 0) {
                                try {
                                    long currIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                    curr = DbCurrency.fetchExc(currIDR);
                                } catch (Exception e) {}

                            } else {
                                try {
                                    curr = DbCurrency.fetchExc(payment.getCurrency_id());
                                } catch (Exception e) {}
                            }

                            try {
                                Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                                if (coaCurr.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }

                            if (comp.getMultiBank() == DbCompany.MULTI_BANK){ // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                    if (payment.getMerchantId() == 0) {
                                        coaLocationTrue = false;
                                    } else {
                                        try {
                                            merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                            Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                            if (coaM.getOID() == 0) {
                                                coaLocationTrue = false;
                                            }
                                        } catch (Exception E) {
                                            coaLocationTrue = false;
                                        }
                                    }
                                }
                            }
                        }

                        try {
                            if (sales.getLocation_id() != 0) {
                                location = DbLocation.fetchExc(sales.getLocation_id());
                                Coa co = new Coa();
                                if (location.getCoaSalesId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co = DbCoa.fetchExc(location.getCoaSalesId());
                                        if (co.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }

                                Coa co2 = new Coa();
                                if (location.getCoaProjectPPHPasal22Id() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co2 = DbCoa.fetchExc(location.getCoaProjectPPHPasal22Id());
                                        if (co2.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }

                                Coa co3 = new Coa();
                                if (location.getCoaProjectPPHPasal23Id() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        co3 = DbCoa.fetchExc(location.getCoaProjectPPHPasal23Id());
                                        if (co3.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception e) {
                                        coaLocationTrue = false;
                                    }
                                }
                            } else {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {}                        
                        
                        Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");
                        
                        for (int ix = 0; ix < dtls.size(); ix++) {

                            SalesDetail sdCk = (SalesDetail) dtls.get(ix); 
                            
                            CoaSalesDetail csd = new CoaSalesDetail();                    
                            csd.setSalesDetailId(sdCk.getOID());
                            csd.setProductMasterId(sdCk.getProductMasterId()); 
                            
                            MasterGroup mg = new MasterGroup();
                            try {                        
                                mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());                                                
                            } catch (Exception e) {}  
                            
                            csd.setItemName(mg.getName());
                            csd.setIsBkp(mg.getIsBkp());                    
                            csd.setNeedBom(mg.getNeedBom());     
                            
                            // =========== OID PENJUALAN CASH==============
                            MasterOid coaSales = new MasterOid();
                            try {
                                coaSales = DbItemMaster.getOidByCode(mg.getAccSales().trim());                        
                            } catch (Exception e) {}

                            if (coaSales.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }                    
                            csd.setAccSales(coaSales.getOidMaster());     
                            
                            //==========Pendapatan Service=================
                            if(sales.getServicePercent() != 0){
                        
                                MasterOid coaService = new MasterOid();
                                try {
                                    coaService = DbItemMaster.getOidByCode(mg.getAccOtherIncome().trim());                        
                                } catch (Exception e) {}

                                if (coaService.getOidMaster() == 0) {
                                    coaLocationTrue = false;
                                }       
                                csd.setAccOtherIncome(coaService.getOidMaster());
                            }
                            //============== END ====================    
                            
                            // =========== OID PPN ==============
                            MasterOid coaPpn = new MasterOid();
                            try {
                                coaPpn = DbItemMaster.getOidByCode(mg.getAccVat().trim());
                            } catch (Exception e) {}
                        
                            if (coaPpn.getOidMaster() == 0) {
                                coaLocationTrue = false;
                            }                    
                            csd.setAccPpn(coaPpn.getOidMaster());                    
                            //============== END ===========================
                            
                            csd.setService(mg.getService());
                            
                            if(mg.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                                Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sdCk.getOID(), null);
                        
                                if(vStock != null && vStock.size() > 0){
                                    for(int d = 0; d < vStock.size() ; d++){                            
                                
                                        Stock stock = (Stock)vStock.get(d);
                                        MasterGroup mgx = new MasterGroup();
                                        try {                        
                                            mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                        } catch (Exception e) {}
                                
                                        // =========== OID INVENTORY==============
                                        MasterOid coaInv = new MasterOid();
                                        try {
                                            coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                        } catch (Exception e) {}
                            
                                        if (coaInv.getOidMaster() == 0) {
                                            coaLocationTrue = false;                            
                                        }     
                                
                                        // =========== OID COGS==============
                                        MasterOid coaCogs = new MasterOid();
                                        try {
                                            coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                        } catch (Exception e) {}
                            
                                        if (coaCogs.getOidMaster() == 0) {
                                            coaLocationTrue = false;
                                        }                                
                                        //============== END ===========================
                                    }
                                }
                        
                            }else{
                                
                                if (sdCk.getCogs() > 0 && mg.getService() == 0){                        
                            
                                    MasterOid coaInv = new MasterOid();
                                    try {
                                        coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());   
                                    } catch (Exception e) {}
                            
                                    csd.setAccInv(coaInv.getOidMaster());
                                    if (coaInv.getOidMaster() == 0) {
                                        coaLocationTrue = false;                            
                                    }                        
                            
                                    MasterOid coaCogs = new MasterOid();
                                    try {
                                        coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                                    } catch (Exception e) {}
                            
                                    if (coaCogs.getOidMaster() == 0) {
                                        coaLocationTrue = false;
                                    }
                                    csd.setAccCogs(coaCogs.getOidMaster());
                                }
                            }
                            
                            hAccSalesDetail.put(""+sdCk.getOID(), csd); // di save di hashtable untuk memudahkan pengambilan berikutnya                                               
                        }

                         if (coaLocationTrue){ // jika kondisi setup coa untuk sales tidak kosong
                             
                            String memo = "Retur Cash sales, " + location.getName();

                            //cek nomor, jika sama cari nomor lain                            
                            String number = sales.getNumber();
                            Gl gx = new Gl(); 
                            long oid = gx.getOID();
                            String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + sales.getNumber() + "'";
                            Vector listGl = DbGl.list(0, 1, whereGl, null);
                            
                            if (listGl != null && listGl.size() > 0) {
                                gx = (Gl) listGl.get(0);
                                oid = gx.getOID();
                                ManualProcess.deleteGlDetail(oid); // delete gl detail                        
                            } else {
                                //post jurnal                                
                                oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                    I_Project.JOURNAL_TYPE_RETUR,
                                    memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);
                            }

                            //jika sukses input gl
                            if (oid != 0) {
                                //jurnal debet
                                double amount = 0;
                                double amountTotal = 0;
                                double dicGlobal = 0;
                        
                                for (int x = 0; x < dtls.size(); x++) {
                                    SalesDetail sd = (SalesDetail) dtls.get(x);                            
                                    amountTotal =  amountTotal + ((sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount());                              
                                }    
                        
                                dicGlobal = (sales.getGlobalDiskon() * 100)/amountTotal;
                                int isFeePaidByComp = SessCreditPayment.isFeeByCompany(sales.getOID());   
                                
                                for (int x = 0; x < dtls.size(); x++) {

                                    SalesDetail sd = (SalesDetail) dtls.get(x);
                                    
                                    CoaSalesDetail csd = new CoaSalesDetail();                            
                                    try{
                                        csd = (CoaSalesDetail)hAccSalesDetail.get(""+sd.getOID());
                                    }catch(Exception e){}                     

                                    double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();                              
                            
                                    //pemrosesan diskon global
                                    double diskonGlobal = 0;
                            
                                    if(sales.getGlobalDiskon() != 0){
                                        diskonGlobal = amountTransaction * (dicGlobal/100);
                                        amountTransaction = amountTransaction - diskonGlobal;
                                    }
                            
                                    double amountService = 0;
                                    if(sales.getServicePercent() != 0){
                                        amountService = amountTransaction * (sales.getServicePercent()/100);                                  
                                    }       
                                    
                                    if(sales.getVatPercent() != 0 || sales.getServicePercent() != 0){
                                
                                        double amountVat = 0;
                                        if(sales.getVatPercent() != 0){
                                            amountVat = (amountTransaction + amountService) * (sales.getVatPercent()/100);
                                        }
                                
                                        memo = "sales item " + csd.getItemName();                                                               
                                        DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);                                    
                                
                                        memo = "ppn " + csd.getItemName();                                
                                        if(amountVat != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountVat,
                                            amountVat, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                        }        
                                
                                        memo = "Pendapatan Service "+csd.getItemName();                                
                                        if(amountService != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), csd.getAccOtherIncome(), 0, amountService,
                                            amountService, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                        }
                                
                                        amount = amount + (amountTransaction + amountVat + amountService);
                            
                                    }else{
                                        
                                        if (comp.getUseBkp() == DbCompany.USE_BKP && csd.getIsBkp() == DbItemMaster.BKP){

                                            
                                            double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                            double amountPpn = amountTransaction - price;

                                            memo = "Retur sales item " + csd.getItemName();
                                            if(price != 0){
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, price,
                                                    price, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }    

                                            memo = "ppn " + csd.getItemName();
                                            if(amountPpn !=0 ){
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), 0, amountPpn,
                                                    amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }    
                                            amount = amount + (price + amountPpn);

                                        } else {

                                            memo = "Retur sales item " + csd.getItemName();                                        
                                            if(amountTransaction != 0){
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), 0, amountTransaction,
                                                    amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }    
                                            amount = amount + amountTransaction;
                                        }
                                    }
                                    
                                    if(csd.getNeedBom() == DbItemMaster.BOM){ // jika merupakan item bom
                         
                                        Vector vStock = DbStock.list(0, 0, DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]+" = "+sd.getOID(), null);
                        
                                            if(vStock != null && vStock.size() > 0){
                                    
                                                for(int d = 0; d < vStock.size() ; d++){                            
                                
                                                    Stock stock = (Stock)vStock.get(d);
                                                    double hpp = stock.getQty() * stock.getPrice();
                                        
                                                    if(hpp != 0){
                                            
                                                        String itemName = "";                                            
                                                        try{
                                                            itemName = getItemName(stock.getItemMasterId());
                                                        }catch(Exception e){}
                                        
                                                        MasterGroup mgx = new MasterGroup();
                                                        try {                        
                                                            mgx = DbItemMaster.getItemGroup(stock.getItemMasterId());                                                
                                                        } catch (Exception e) {}
                                
                                                        // =========== OID INVENTORY==============
                                                        MasterOid coaInv = new MasterOid();
                                                        try {
                                                            coaInv = DbItemMaster.getOidByCode(mgx.getAccInv().trim());   
                                                        } catch (Exception e) {}
                                
                                                        // =========== OID COGS==============
                                                        MasterOid coaCogs = new MasterOid();
                                                        try {
                                                            coaCogs = DbItemMaster.getOidByCode(mgx.getAccCogs().trim());
                                                        } catch (Exception e) {}
                                            
                                            
                                                        memo = "inventory : " + itemName;
                                                        DbGl.postJournalDetail(er.getValueIdr(), coaInv.getOidMaster(), 0, hpp,
                                                        hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                        segment1_id, 0, 0, 0,
                                                            0, 0, 0, 0,
                                                            0, 0, 0, 0,
                                                            0, 0, 0, 0);
                                                        //journal hpp
                                            
                                                        memo = "hpp : " + itemName;
                                                        DbGl.postJournalDetail(er.getValueIdr(), coaCogs.getOidMaster(), hpp, 0,
                                                            hpp, comp.getBookingCurrencyId(), oid, memo, 0,
                                                            segment1_id, 0, 0, 0,
                                                            0, 0, 0, 0,
                                                            0, 0, 0, 0,
                                                            0, 0, 0, 0);
                                                        //============== END ===========================
                                                    }
                                            }
                                        }                        
                                    }else{
                                        
                                        if (sd.getCogs() > 0 && csd.getService() == 0){
                                            double hpp = sd.getCogs() * sd.getQty();
                                
                                            if(hpp != 0){
                                    
                                                //jurnal inventory
                                                memo = "inventory : " + csd.getItemName();
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccInv(), 0, sd.getCogs() * sd.getQty(),
                                                    sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);

                                                //journal hpp
                                                memo = "hpp : " + csd.getItemName();
                                                DbGl.postJournalDetail(er.getValueIdr(), csd.getAccCogs(), sd.getCogs() * sd.getQty(), 0,
                                                    sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }
                                        }   
                                    }           
                                }

                                Coa coa = new Coa();
                                Coa coaExpense = new Coa();
                                Coa coaPendapatan = new Coa();
                                double amountExpense = 0; 

                                if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {

                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {}

                                    } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                        if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                            memo = "Cash";
                                            try {
                                                coa = DbCoa.fetchExc(curr.getCoaId());
                                            } catch (Exception e) {}

                                        } else {
                                            
                                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                                memo = "Piutang Credit Card";
                                            } else {
                                                memo = "Piutang Debit Card";
                                            }

                                            try {
                                                try {
                                                    merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                                } catch (Exception e) {}
                                                
                                                try {
                                                    coa = DbCoa.fetchExc(merchant.getCoaId());
                                                } catch (Exception e) {}
                                                    
                                                try {
                                                    coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                                } catch (Exception e) {}

                                                if (merchant.getPersenExpense() > 0) {
                                                    amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                                }

                                            } catch (Exception e) {}
                                            
                                        }
                                    }else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER) {
                                        memo = "Transfer Bank";
                                        Bank bank = new Bank();
                                        try{
                                            bank = DbBank.fetchExc(payment.getBankId());
                                        }catch(Exception e){}
                                        
                                        try{
                                            coa = DbCoa.fetchExc(bank.getCoaARId());
                                        }catch(Exception e){}
                                    }
                                    
                                } else {
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(location.getCoaSalesId());
                                    } catch (Exception e) {}
                                }

                                double amountPiutang = 0;
                                if (amountExpense > 0) {
                                    String memoPiutang = "";
                                    if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD){
                                        memo = "Biaya Komisi Credit Card";
                                        memoPiutang = "Credit Card";
                                    } else {
                                        memo = "Biaya Komisi Debit Card";
                                        memoPiutang = "Debit Card";
                                    }
                                    
                                    if(isFeePaidByComp != 0){ // jika biaya kartu di bayar pembeli
                                        
                                        if (amountExpense != 0) {
                                            DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                                amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                    
                                            try {
                                                coaPendapatan = DbCoa.fetchExc(merchant.getPendapatanMerchant());
                                            } catch (Exception e) {}                                    
                                    
                                            DbGl.postJournalDetail(er.getValueIdr(), coaPendapatan.getOID(), amountExpense, 0,
                                                amountExpense, comp.getBookingCurrencyId(), oid, "Pendapatan Merchant", 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);                                    
                                        }
                                
                                        double piutangCC = amount;
                                        amountPiutang = piutangCC;
                                
                                        if(piutangCC != 0){
                                            DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                                piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0);
                                        }
                                        
                                    }else{
                                        
                                        DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), amountExpense, 0,
                                            amountExpense, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                        double piutangCC = amount - amountExpense;                                
                                        amountPiutang = piutangCC;
                                        DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), piutangCC, 0,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                    }
                                    

                                } else {               
                                    
                                    amountPiutang = amount;
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), amount, 0,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                                }

                                Date dt = new Date();

                                String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
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

                                updateStatus(sales.getOID(), userId, effectiveDate);
                                
                                DbGl.optimizedJournal(oid);
                            }
                        }                          
                }
            }
        }
    }

    public static void rePostJournal(Vector temp, long userId, long periodIdx, Company comp) {

        ExchangeRate er = DbExchangeRate.getStandardRate();
        Vector v = temp;

        int intervalDue = 7; // default 7 hari jatuh tempo setelah transaksi
        try {
            intervalDue = Integer.parseInt(DbSystemProperty.getValueByName("INTERVAL_DUE_DATE_CREDIT"));
        } catch (Exception e) {
        }

        long deffCurrIDR = 0;
        try {
            deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
        } catch (Exception e) {
        }

        Periode p = new Periode();

        if (v != null && v.size() > 0) {

            for (int i = 0; i < v.size(); i++) {

                Sales sales = (Sales) v.get(i);
                long segment1_id = 0;

                if (sales.getLocation_id() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + sales.getLocation_id();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                    }
                }

                Location location = new Location();
                boolean coaLocationTrue = true;
                Payment payment = new Payment();
                Currency curr = new Currency();
                Merchant merchant = new Merchant();
                long periodId = periodIdx;
                Periode periode = new Periode();

                //Parameter Multy Bank                
                Hashtable hAccSalesDetail = new Hashtable();

                if (periodId == 0) {
                    try {
                        periode = DbPeriode.getPeriodByTransDate(sales.getDate());
                        periodId = periode.getOID();
                    } catch (Exception e) {
                    }
                } else {
                    periode = p;
                }

                if (periode.getStatus().compareTo("Closed") == 0) {
                    coaLocationTrue = false;
                }

                try {
                    if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {
                        try {
                            Vector vPayment = DbPayment.list(0, 1, DbPayment.colNames[DbPayment.COL_SALES_ID] + "=" + sales.getOID(), null);
                            if (vPayment != null && vPayment.size() > 0) {
                                payment = (Payment) vPayment.get(0);
                            }
                        } catch (Exception e) {
                        }

                        if (payment.getCurrency_id() == 0) {
                            try {
                                long currIDR = deffCurrIDR;
                                curr = DbCurrency.fetchExc(currIDR);
                            } catch (Exception e) {
                            }

                        } else {
                            try {
                                curr = DbCurrency.fetchExc(payment.getCurrency_id());
                            } catch (Exception e) {
                            }
                        }

                        try {
                            Coa coaCurr = DbCoa.fetchExc(curr.getCoaId());
                            if (coaCurr.getOID() == 0) {
                                coaLocationTrue = false;
                            }
                        } catch (Exception e) {
                            coaLocationTrue = false;
                        }


                        if (comp.getMultiBank() == DbCompany.MULTI_BANK) { // jika mengunakan konsep pembayaran cc/debit pada banyak merchant

                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                if (payment.getMerchantId() == 0) {
                                    coaLocationTrue = false;
                                } else {
                                    try {
                                        merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                        Coa coaM = DbCoa.fetchExc(merchant.getCoaId());
                                        if (coaM.getOID() == 0) {
                                            coaLocationTrue = false;
                                        }
                                    } catch (Exception E) {
                                        coaLocationTrue = false;
                                    }
                                }
                            }
                        }
                    }

                    if (sales.getNumber().length() <= 0) {
                        coaLocationTrue = false;
                    }

                    if (sales.getLocation_id() != 0) {
                        location = DbLocation.fetchExc(sales.getLocation_id());
                        Coa co = new Coa();
                        if (location.getCoaSalesId() == 0) {
                            coaLocationTrue = false;
                        } else {
                            try {
                                co = DbCoa.fetchExc(location.getCoaSalesId());
                                if (co.getOID() == 0) {
                                    coaLocationTrue = false;
                                }
                            } catch (Exception e) {
                                coaLocationTrue = false;
                            }
                        }

                    } else {
                        coaLocationTrue = false;
                    }
                } catch (Exception e) {
                }

                Vector dtls = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales.getOID(), "");

                for (int ix = 0; ix < dtls.size(); ix++) {

                    SalesDetail sdCk = (SalesDetail) dtls.get(ix);
                    CoaSalesDetail csd = new CoaSalesDetail();

                    csd.setSalesDetailId(sdCk.getOID());
                    csd.setProductMasterId(sdCk.getProductMasterId());

                    MasterGroup mg = new MasterGroup();
                    try {
                        mg = DbItemMaster.getItemGroup(sdCk.getProductMasterId());
                    } catch (Exception e) {
                    }

                    csd.setItemName(mg.getName());
                    csd.setIsBkp(mg.getIsBkp());
                    csd.setNeedBom(mg.getNeedBom());

                    // =========== OID PENJUALAN CASH==============
                    MasterOid coaSales = new MasterOid();
                    try {
                        coaSales = DbItemMaster.getOidByCode(mg.getAccSales().trim());
                    } catch (Exception e) {
                    }

                    if (coaSales.getOidMaster() == 0) {
                        coaLocationTrue = false;
                    }
                    csd.setAccSales(coaSales.getOidMaster());

                    // =========== OID PPN ==============
                    MasterOid coaPpn = new MasterOid();
                    try {
                        coaPpn = DbItemMaster.getOidByCode(mg.getAccVat().trim());
                    } catch (Exception e) {
                    }

                    if (coaPpn.getOidMaster() == 0) {
                        coaLocationTrue = false;
                    }
                    csd.setAccPpn(coaPpn.getOidMaster());
                    //============== END ===========================

                    csd.setService(mg.getService());

                    if (sdCk.getCogs() > 0) {  // Jika bukan service && cogs tidak sama dengan 0                      

                        // =========== OID INVENTORY==============
                        MasterOid coaInv = new MasterOid();
                        try {
                            coaInv = DbItemMaster.getOidByCode(mg.getAccInv().trim());
                        } catch (Exception e) {
                        }

                        if (coaInv.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }
                        csd.setAccInv(coaInv.getOidMaster());
                        //============== END ===========================

                        // =========== OID COGS==============
                        MasterOid coaCogs = new MasterOid();
                        try {
                            coaCogs = DbItemMaster.getOidByCode(mg.getAccCogs().trim());
                        } catch (Exception e) {
                        }

                        if (coaCogs.getOidMaster() == 0) {
                            coaLocationTrue = false;
                        }
                        csd.setAccCogs(coaCogs.getOidMaster());
                    //============== END ===========================
                    }

                    hAccSalesDetail.put("" + sdCk.getOID(), csd); // di save di hashtable untuk memudahkan pengambilan berikutnya                    
                }

                if (coaLocationTrue) { // jika kondisi setup coa untuk sales tidak kosong

                    String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + sales.getNumber() + "'";
                    Gl gx = new Gl();
                    String memo = "Sales transaction number : " + sales.getNumber();
                    long oid = gx.getOID();
                    Vector listGl = DbGl.list(0, 1, whereGl, null);
                    String number = sales.getNumber();

                    if (listGl != null && listGl.size() > 0) {
                        gx = (Gl) listGl.get(0);
                        oid = gx.getOID();
                        ManualProcess.deleteGlDetail(oid); // delete gl detail                        
                    } else {
                        Customer cust = new Customer();
                        if (sales.getType() == DbSales.TYPE_CREDIT) {
                            try {
                                cust = DbCustomer.fetchExc(sales.getCustomerId());
                            } catch (Exception ex) {
                                System.out.println("[exception] " + ex.toString());
                            }
                        }

                        if (sales.getType() == DbSales.TYPE_CASH) {
                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                memo = "Cash sales, " + location.getName();
                            } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                memo = "Credit Card Payment sales, " + location.getName();
                            } else if (payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                                memo = "Debit Card Payment sales, " + location.getName();
                            } else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER) {
                                memo = "Transfer Payment sales, " + location.getName();
                            }
                        } else {
                            memo = "Credit sales, " + location.getName() +
                                    " : " + ((cust.getCode() != null && cust.getCode().length() > 0) ? cust.getCode() + "/" + cust.getName() : cust.getName());
                        }

                        oid = DbGl.postJournalMain(0, sales.getDate(), sales.getCounter(), number, sales.getNumberPrefix(),
                                I_Project.JOURNAL_TYPE_SALES,
                                memo, sales.getUserId(), "", sales.getOID(), "", sales.getDate(), periodId);
                    }


                    //jika sukses input gl
                    if (oid != 0) {
                        //jurnal debet   
                        double amount = 0;

                        double amountTotal = 0;
                       // double dicGlobal = 0;

                        for (int x = 0; x < dtls.size(); x++) {
                            SalesDetail sd = (SalesDetail) dtls.get(x);
                            amountTotal = amountTotal + ((sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount());
                        }

                        //dicGlobal = (sales.getGlobalDiskon() * 100) / amountTotal;
                        int isFeePaidByComp = SessCreditPayment.isFeeByCompany(sales.getOID());

                        for (int x = 0; x < dtls.size(); x++) {

                            SalesDetail sd = (SalesDetail) dtls.get(x);

                            CoaSalesDetail csd = new CoaSalesDetail();
                            try {
                                csd = (CoaSalesDetail) hAccSalesDetail.get("" + sd.getOID());
                            } catch (Exception e) {
                            }

                            double amountTransaction = (sd.getSellingPrice() * sd.getQty()) - sd.getDiscountAmount();

                            //pemrosesan diskon global
                            //double diskonGlobal = 0;

                            //if (sales.getGlobalDiskon() != 0) {
                            //    diskonGlobal = amountTransaction * (dicGlobal / 100);
                            //    amountTransaction = amountTransaction - diskonGlobal;
                            //}

                            if (comp.getUseBkp() == DbCompany.USE_BKP && csd.getIsBkp() == DbItemMaster.BKP) {

                                double price = (((100 * sd.getSellingPrice()) / 110) * sd.getQty()) - sd.getDiscountAmount();
                                double amountPpn = amountTransaction - price;

                                memo = "sales item " + csd.getItemName();

                                if (price != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), price, 0,
                                            price, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }

                                memo = "ppn " + csd.getItemName();

                                if (amountPpn != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccPpn(), amountPpn, 0,
                                            amountPpn, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }

                                amount = amount + (price + amountPpn);

                            } else {
                                memo = "sales item " + csd.getItemName();
                                if (amountTransaction != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccSales(), amountTransaction, 0,
                                            amountTransaction, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }
                                amount = amount + amountTransaction;
                            }


                            if (sd.getCogs() > 0) {
                                double hpp = sd.getCogs() * sd.getQty();

                                if (hpp != 0) {

                                    memo = "inventory : " + csd.getItemName();
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccInv(), sd.getCogs() * sd.getQty(), 0,
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    //journal hpp
                                    memo = "hpp : " + csd.getItemName();
                                    DbGl.postJournalDetail(er.getValueIdr(), csd.getAccCogs(), 0, sd.getCogs() * sd.getQty(),
                                            sd.getCogs() * sd.getQty(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }
                            }

                        }

                        Coa coa = new Coa();
                        Coa coaExpense = new Coa();
                        Coa coaPendapatan = new Coa();
                        double amountExpense = 0;

                        if (sales.getType() == DbSales.TYPE_CASH) {
                            if (comp.getMultiCurrency() == DbCompany.MULTI_CURRENCY) {
                                if (payment.getPay_type() == DbPayment.PAY_TYPE_CASH) {
                                    memo = "Cash";
                                    try {
                                        coa = DbCoa.fetchExc(curr.getCoaId());
                                    } catch (Exception e) {
                                    }

                                } else if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD || payment.getPay_type() == DbPayment.PAY_TYPE_DEBIT_CARD) {

                                    if (comp.getMultiBank() == DbCompany.NON_MULTI_BANK) {
                                        memo = "Cash";
                                        try {
                                            coa = DbCoa.fetchExc(curr.getCoaId());
                                        } catch (Exception e) {
                                        }

                                    } else {

                                        if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                            memo = "Credit Card";
                                        } else {
                                            memo = "Debit Card";
                                        }

                                        try {
                                            try {
                                                merchant = DbMerchant.fetchExc(payment.getMerchantId());
                                            } catch (Exception e) {
                                            }

                                            try {
                                                coa = DbCoa.fetchExc(merchant.getCoaId());
                                            } catch (Exception e) {
                                            }

                                            try {
                                                coaExpense = DbCoa.fetchExc(merchant.getCoaExpenseId());
                                            } catch (Exception e) {
                                            }

                                            if (merchant.getPersenExpense() > 0) {
                                                amountExpense = (merchant.getPersenExpense() / 100) * amount;
                                            }

                                        } catch (Exception e) {
                                        }
                                    }
                                } else if (payment.getPay_type() == DbPayment.PAY_TYPE_TRANSFER) {
                                    memo = "Transfer Bank";
                                    Bank bank = new Bank();

                                    try {
                                        bank = DbBank.fetchExc(payment.getBankId());
                                    } catch (Exception e) {
                                    }

                                    try {
                                        coa = DbCoa.fetchExc(bank.getCoaARId());
                                    } catch (Exception e) {
                                    }
                                }

                            } else {
                                memo = "Cash";
                                try {
                                    coa = DbCoa.fetchExc(location.getCoaSalesId());
                                } catch (Exception e) {
                                }
                            }

                        } else {
                            try {
                                coa = DbCoa.fetchExc(location.getCoaArId());
                            } catch (Exception e) {
                            }
                            memo = "Credit Sales";
                        }

                        double amountPiutang = 0;
                        if (amountExpense > 0) {
                            String memoPiutang = "";
                            if (payment.getPay_type() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                                memo = "Biaya Komisi Credit Card";
                                memoPiutang = "Credit Card";
                            } else {
                                memo = "Biaya Komisi Debit Card";
                                memoPiutang = "Debit Card";
                            }

                            if (isFeePaidByComp > 0) { // jika biaya kartu di company
                                
                                if (amountExpense != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), 0, amountExpense,
                                            amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }

                                double piutangCC = amount - amountExpense;
                                amountPiutang = piutangCC;

                                if (piutangCC != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, piutangCC,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }
                                
                            } else {
                                
                                if (amountExpense != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), coaExpense.getOID(), 0, amountExpense,
                                            amountExpense, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);

                                    try {
                                        coaPendapatan = DbCoa.fetchExc(merchant.getPendapatanMerchant());
                                    } catch (Exception e) {
                                    }

                                    DbGl.postJournalDetail(er.getValueIdr(), coaPendapatan.getOID(), 0, amountExpense,
                                            amountExpense, comp.getBookingCurrencyId(), oid, "Pendapatan Merchant", 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }

                                double piutangCC = amount;
                                amountPiutang = piutangCC;

                                if (piutangCC != 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, piutangCC,
                                            piutangCC, comp.getBookingCurrencyId(), oid, memoPiutang, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0);
                                }
                            }

                        } else {

                            amountPiutang = amount;
                            if (amount != 0) {
                                DbGl.postJournalDetail(er.getValueIdr(), coa.getOID(), 0, amount,
                                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0);
                            }
                        }

                        Date dt = new Date();
                        String wherex = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
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
                        updateStatus(sales.getOID(), userId, effectiveDate);
                        if (sales.getType() == DbSales.TYPE_CREDIT) {
                            DbSales.postReceivable(sales, intervalDue, amountPiutang);
                        }
                        DbGl.optimizedJournal(oid);
                    }
                }
            }
        }
    }

    public static String getItemName(long itemId) {

        CONResultSet crs = null;
        try {
            String sql = "select " + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " from " + DbItemMaster.DB_ITEM_MASTER + " where " +
                    DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " = " + itemId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                return rs.getString(DbItemMaster.colNames[DbItemMaster.COL_NAME]);
            }
            rs.close();

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(crs);
        }

        return "";
    }

    public static void updateStatus(long salesId, long userId, Date effectiveDate) {

        CONResultSet crs = null;
        try {

            String sql = "UPDATE " + DbSales.DB_SALES + " SET " + DbSales.colNames[DbSales.COL_STATUS] + " = 1," +
                    DbSales.colNames[DbSales.COL_POSTED_STATUS] + " = 1," + DbSales.colNames[DbSales.COL_POSTED_BY_ID] + " = " + userId + ", " +
                    DbSales.colNames[DbSales.COL_EFFECTIVE_DATE] + " = '" + JSPFormater.formatDate(effectiveDate, "yyyy-MM-dd") + " 00:00:00' " +
                    "," + DbSales.colNames[DbSales.COL_POSTED_DATE] + " = '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "' where " +
                    DbSales.colNames[DbSales.COL_SALES_ID] + " = " + salesId;

            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }
    }
    
    
    public static void releaseHutang(long bankpoId, String journalNumber) {
        
        String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + journalNumber + "'";
        Gl gx = new Gl();
        Vector listGl = DbGl.list(0, 1, whereGl, null);
        
        if (listGl != null && listGl.size() > 0) {
            gx = (Gl) listGl.get(0);
            long oid = gx.getOID();            
            if(oid!= 0){
                deleteGl(oid);
                deleteGlDetail(oid);
            }
        }
        
        String whereRef = DbBankpoPayment.colNames[DbBankpoPayment.COL_REF_ID] + " = '" + bankpoId + "'";
        Vector listPoPayment = DbBankpoPayment.list(0, 1, whereRef, null);
        if (listPoPayment != null && listPoPayment.size() > 0) {
            BankpoPayment bp = (BankpoPayment)listPoPayment.get(0);
            long oidx = bp.getOID();            
            if(oidx!= 0){
                deleteBankpo(oidx);
                deleteBankpoDetail(oidx);
                
                String whereGlx = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + bp.getJournalNumber() + "'";
                Gl gx1 = new Gl();
                Vector listGlx = DbGl.list(0, 1, whereGlx, null);
                if (listGlx != null && listGlx.size() > 0) {
                    gx1 = (Gl) listGlx.get(0);
                    long oid2 = gx1.getOID();            
                    if(oid2!= 0){
                        deleteGl(oid2);
                        deleteGlDetail(oid2);
                    }
                }
                
            }
        }

        CONResultSet crs = null;
        try {
            String sql = "update "+DbBankpoPayment.DB_BANKPO_PAYMENT+" set "+
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS]+" = 'Not Posted',"+
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]+" = 0,"+
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_BY_ID]+" = 0,"+
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_DATE]+" = '',"+
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_EFFECTIVE_DATE]+" = '' "+
                    " where "+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = "+bankpoId;
            
            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }
    }
    
    public static void updateGol(long priceId,double gol,double cogs){        
        
        double mar= 0;
        if(cogs != 0){
            mar = ((((gol/cogs)*100)-100)/((gol/cogs)*100)) * 100;
        }
        try{
            String sql = "update pos_price_type set gol_10 = "+gol+",gol10_margin="+mar+" where price_type_id = "+priceId;
            CONHandler.execUpdate(sql);
            
        }catch(Exception e){}
        
    }
    
}
