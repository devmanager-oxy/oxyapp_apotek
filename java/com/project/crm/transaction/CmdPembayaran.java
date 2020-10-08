/* 
 * @author  		:  Eka D
 * @version  		:  1.0
 */
package com.project.crm.transaction;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;
import com.project.crm.sewa.*;
import com.project.*;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.system.DbSystemProperty;

public class CmdPembayaran extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_FORM_PEMBAYARAN_MELEBIHI_INVOICE = 4;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap", "Pembayaran melebihi invoice"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete", "Payment more than invoice"}};
    private int start;
    private String msgString;
    private Pembayaran pembayaran;
    private DbPembayaran pstPembayaran;
    private JspPembayaran jspPembayaran;
    int language = LANGUAGE_DEFAULT;

    public CmdPembayaran(HttpServletRequest request) {
        msgString = "";
        pembayaran = new Pembayaran();
        try {
            pstPembayaran = new DbPembayaran(0);
        } catch (Exception e) {
            ;
        }
        jspPembayaran = new JspPembayaran(request, pembayaran);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return resultText[language][RSLT_EST_CODE_EXIST];
            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return RSLT_EST_CODE_EXIST;
            default:
                return RSLT_UNKNOWN_ERROR;
        }
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public Pembayaran getPembayaran() {
        return pembayaran;
    }

    public JspPembayaran getForm() {
        return jspPembayaran;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPembayaran){
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:

                Date tglPembayaran = new Date();
                String noInvoice = "";

                if (oidPembayaran != 0) {
                    try {
                        pembayaran = DbPembayaran.fetchExc(oidPembayaran);
                        tglPembayaran = pembayaran.getTanggal();
                        noInvoice = pembayaran.getNoInvoice();
                    } catch (Exception exc){ System.out.println("[exception] "+exc.toString()); }
                }

                jspPembayaran.requestEntityObject(pembayaran);
                double totInvoice = 0;
                long transactionId = 0;
                long invoiceCurrency = 0;

                if (jspPembayaran.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if(pembayaran.getIrigasiTransactionId() != 0){   // termasuk pembayaran transaksi Irigasi

                    IrigasiTransaction irigasi = new IrigasiTransaction();
                    try {
                        irigasi = DbIrigasiTransaction.fetchExc(pembayaran.getIrigasiTransactionId());
                    } catch (Exception E) { System.out.println("[exception] " + E.toString()); }

                    transactionId = pembayaran.getIrigasiTransactionId();

                    pembayaran.setNoInvoice(irigasi.getInvoiceNumber());
                    pembayaran.setTanggalInvoice(irigasi.getTransactionDate());
                    pembayaran.setCustomerId(irigasi.getCustumerId());
                    pembayaran.setTransactionSource(DbPembayaran.PAYMENT_SOURCE_IRIGASI);

                    totInvoice = (irigasi.getBulanIni() - irigasi.getBulanLalu()) * irigasi.getHarga();
                    totInvoice = totInvoice + irigasi.getPpn() + irigasi.getPph() + irigasi.getTotalDenda();

                } else if (pembayaran.getLimbahTransactionId() != 0){ // termasuk pembayaran transaksi limbah

                    LimbahTransaction limbah = new LimbahTransaction();
                    try {
                        limbah = DbLimbahTransaction.fetchExc(pembayaran.getLimbahTransactionId());
                    } catch (Exception E) { System.out.println("[exception] " + E.toString()); }

                    transactionId = pembayaran.getLimbahTransactionId();

                    pembayaran.setNoInvoice(limbah.getInvoiceNumber());
                    pembayaran.setTanggalInvoice(limbah.getTransactionDate());
                    pembayaran.setCustomerId(limbah.getCustomerId());
                    pembayaran.setTransactionSource(DbPembayaran.PAYMENT_SOURCE_LIMBAH);

                    totInvoice = (limbah.getBulanIni() - limbah.getBulanLalu()) * limbah.getHarga() * (limbah.getPercentageUsed() / 100);
                    totInvoice = totInvoice + limbah.getTotalDenda() + limbah.getPpn() + limbah.getPph();

                } else if (pembayaran.getSewaTanahInvoiceId() != 0){ // 

                    SewaTanahInvoice sti = new SewaTanahInvoice();
                    try {
                        sti = DbSewaTanahInvoice.fetchExc(pembayaran.getSewaTanahInvoiceId());
                    } catch (Exception E) { System.out.println("[exception] " + E.toString()); }

                    transactionId = pembayaran.getSewaTanahInvoiceId();
                    invoiceCurrency = sti.getCurrencyId();

                    pembayaran.setNoInvoice(sti.getNumber());
                    pembayaran.setTanggalInvoice(sti.getTanggal());
                    pembayaran.setCustomerId(sti.getSaranaId());
                    
                    if (sti.getType() == DbSewaTanahInvoice.TYPE_INV_KOMIN) {
                        pembayaran.setTransactionSource(DbPembayaran.PAYMENT_SOURCE_KOMIN);
                    } else if (sti.getType() == DbSewaTanahInvoice.TYPE_INV_ASSESMENT) {
                        pembayaran.setTransactionSource(DbPembayaran.PAYMENT_SOURCE_ASSESMENT);
                    }

                    totInvoice = sti.getJumlah() + sti.getTotalDenda() + sti.getPpn() + sti.getPph();

                } else if (pembayaran.getSewaTanahBenefitId() != 0){

                    SewaTanahBenefit benef = new SewaTanahBenefit();
                    try {
                        benef = DbSewaTanahBenefit.fetchExc(pembayaran.getSewaTanahBenefitId());
                    } catch (Exception E) { System.out.println("[exception] " + E.toString()); }

                    transactionId = pembayaran.getSewaTanahBenefitId();
                    invoiceCurrency = benef.getCurrencyId();

                    pembayaran.setNoInvoice(benef.getNumber());
                    pembayaran.setTanggalInvoice(benef.getTanggalBenefit());
                    pembayaran.setCustomerId(benef.getSaranaId());
                    pembayaran.setTransactionSource(DbPembayaran.PAYMENT_SOURCE_KOMPER);

                    totInvoice = benef.getTotalKomper() + benef.getTotalDenda() + benef.getPpn() + benef.getPph();//DbSewaTanahBenefitDetail.getTotalInvoice(benef.getOID());                   

                } else if (pembayaran.getDendaId() != 0){
                    Denda denda = new Denda();
                    try {
                        denda = DbDenda.fetchExc(pembayaran.getDendaId());
                    } catch (Exception E) { System.out.println("[exception] " + E.toString()); }

                    transactionId = pembayaran.getDendaId();
                    invoiceCurrency = denda.getCurrencyId();

                    pembayaran.setNoInvoice(denda.getNumber());
                    pembayaran.setTanggalInvoice(denda.getTanggal());
                    pembayaran.setCustomerId(0);
                    pembayaran.setTransactionSource(DbPembayaran.PAYMENT_SOURCE_DENDA);

                    totInvoice = denda.getJumlah();
                }
                
                boolean totInvoiceMore = DbPembayaran.isMoreThanTotInvoice(pembayaran, totInvoice, invoiceCurrency);

                if (totInvoiceMore) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_MORE_INVOICE);
                    return RSLT_FORM_PEMBAYARAN_MELEBIHI_INVOICE;
                }

                if (pembayaran.getOID() == 0){

                    try {
                        
                        Date dt = new Date();
                        /*
                        Periode opnPeriode = new Periode();                        
                        try {                            
                            opnPeriode = DbPeriode.fetchExc(pembayaran.getPeriodId());   
                        } catch (Exception e){}
                        
                        int periodeTaken = 0;
                        
                        try {
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        } catch (Exception e){}
                        
                        if (periodeTaken == 0){
                            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                        } else if (periodeTaken == 1) {
                            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif}
                        }    
                        
                        Date dtx = (Date) dt.clone();
                        dtx.setDate(1);*/
                        
                        String formatDocCode = DbSystemDocNumber.getNumberPrefix(pembayaran.getTanggal(),DbSystemDocCode.TYPE_DOCUMENT_BKM);                          
                        int counter = DbSystemDocNumber.getNextCounter(pembayaran.getTanggal(),DbSystemDocCode.TYPE_DOCUMENT_BKM );      
                        //int counter = DbSystemDocNumber.getNextCounterBkm(opnPeriode.getOID());            
                        //String formatDocCode = DbSystemDocNumber.getNumberPrefixBkm(opnPeriode.getOID());                        
                        
                        pembayaran.setCounter(counter);
                        
                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        
                        formatDocCode = DbSystemDocNumber.getNextNumber(pembayaran.getCounter(), pembayaran.getTanggal(),DbSystemDocCode.TYPE_DOCUMENT_BKM);
                        //formatDocCode = DbSystemDocNumber.getNextNumberBkm(pembayaran.getCounter(), pembayaran.getPeriodId());
                        systemDocNumber.setDocNumber(formatDocCode);
                        pembayaran.setNoBkm(formatDocCode);

                        long oid = DbPembayaran.insertExc(this.pembayaran);
                        
                        if (oid != 0){
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception E) { System.out.println("[exception] " + E.toString()); }
                        }
                        /*
                        if (oid != 0){               	
                        	DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKK, pembayaran.getOID(), pembayaran.getJumlah(), pembayaran.getCreateById());            
                            try {
                                pstPembayaran.updateExchangeRate("update " + DbPembayaran.DB_CRM_PEMBAYARAN + " set " + DbPembayaran.colNames[DbPembayaran.COL_EXCHANGE_RATE] + "=" + pembayaran.getExchangeRate() + " where " + DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID] + "=" + oid);
                            } catch (Exception e){ System.out.println("[exception] " + e.toString()); }
                        }*/

                        /* Insert ke buku pembantu */
                        if (oid != 0 && false) {

                            SewaTanahBp sewaTanahBp = new SewaTanahBp();

                            sewaTanahBp.setMataUangId(this.pembayaran.getMataUangId());
                            sewaTanahBp.setMem("-");
                            sewaTanahBp.setDebet(0);
                            sewaTanahBp.setTanggal(this.pembayaran.getTanggal());
                            sewaTanahBp.setRefnumber(this.pembayaran.getNoInvoice());
                            sewaTanahBp.setKeterangan("-");
                            sewaTanahBp.setCredit(this.pembayaran.getJumlah());
                            sewaTanahBp.setCustomerId(this.pembayaran.getCustomerId());

                            if (pembayaran.getIrigasiTransactionId() != 0) {

                                sewaTanahBp.setIrigasiTransactionId(pembayaran.getIrigasiTransactionId());
                                sewaTanahBp.setLimbahTransactionId(0);
                                sewaTanahBp.setSewaTanahId(0);
                                sewaTanahBp.setSewaTanahInvId(0);

                            } else if (pembayaran.getLimbahTransactionId() != 0) {

                                sewaTanahBp.setIrigasiTransactionId(0);
                                sewaTanahBp.setLimbahTransactionId(pembayaran.getLimbahTransactionId());
                                sewaTanahBp.setSewaTanahId(0);
                                sewaTanahBp.setSewaTanahInvId(0);

                            } else if (pembayaran.getSewaTanahInvoiceId() != 0) {

                                sewaTanahBp.setIrigasiTransactionId(0);
                                sewaTanahBp.setLimbahTransactionId(0);
                                sewaTanahBp.setSewaTanahInvId(pembayaran.getSewaTanahInvoiceId());
                                sewaTanahBp.setSewaTanahId(0);

                                try {
                                    SewaTanahInvoice sti = (SewaTanahInvoice) DbSewaTanahInvoice.fetchExc(pembayaran.getSewaTanahInvoiceId());
                                    sewaTanahBp.setSewaTanahId(sti.getSewaTanahId());
                                } catch (Exception e) {
                                    System.out.println("[exception] fetch sewa tanah invoice : " + e.toString());
                                }

                            } else {

                                sewaTanahBp.setIrigasiTransactionId(0);
                                sewaTanahBp.setLimbahTransactionId(0);
                                sewaTanahBp.setSewaTanahInvId(0);
                                sewaTanahBp.setSewaTanahId(0);

                            }

                            try {
                                long oidSTBP = DbSewaTanahBp.insertExc(sewaTanahBp);
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                        }

                        DbPembayaran.updateStatusInvoice(transactionId, pembayaran.getTransactionSource(), totInvoice, invoiceCurrency);

                    } catch (CONException dbexc) {

                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);

                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                } else {
                    try {

                        long oid = DbPembayaran.updateExc(this.pembayaran);

                        if (oid != 0 && false) {
                        	
                        	DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKK, pembayaran.getOID(), pembayaran.getJumlah(), pembayaran.getCreateById());            
                        		
                            try {
                                pstPembayaran.updateExchangeRate("update " + DbPembayaran.DB_CRM_PEMBAYARAN + " set " + DbPembayaran.colNames[DbPembayaran.COL_EXCHANGE_RATE] + "=" + pembayaran.getExchangeRate() + " where " + DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID] + "=" + oid);
                            } catch (Exception e) {
                            }

                        }
                        if (oid != 0 && false){
                            //update ke buku pembantu pituang
                            String whereBp = DbSewaTanahBp.colNames[DbSewaTanahBp.COL_REFNUMBER] + " = '" + noInvoice + "' AND " +
                                    DbSewaTanahBp.colNames[DbSewaTanahBp.COL_TANGGAL] + " = '" + JSPFormater.formatDate(tglPembayaran, "yyyy-MM-dd") + "'";

                            Vector listBp = DbSewaTanahBp.list(0, 0, whereBp, null);

                            if (listBp != null && listBp.size() > 0){

                                SewaTanahBp sewaTanahBp = (SewaTanahBp) listBp.get(0);

                                sewaTanahBp.setMataUangId(this.pembayaran.getMataUangId());
                                sewaTanahBp.setMem("-");
                                sewaTanahBp.setDebet(0);
                                sewaTanahBp.setTanggal(this.pembayaran.getTanggal());
                                sewaTanahBp.setRefnumber(this.pembayaran.getNoInvoice());
                                sewaTanahBp.setKeterangan("-");
                                sewaTanahBp.setCredit(this.pembayaran.getJumlah());
                                sewaTanahBp.setCustomerId(this.pembayaran.getCustomerId());

                                if (pembayaran.getIrigasiTransactionId() != 0) {

                                    sewaTanahBp.setIrigasiTransactionId(pembayaran.getIrigasiTransactionId());
                                    sewaTanahBp.setLimbahTransactionId(0);
                                    sewaTanahBp.setSewaTanahId(0);
                                    sewaTanahBp.setSewaTanahInvId(0);

                                } else if (pembayaran.getLimbahTransactionId() != 0) {

                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(pembayaran.getLimbahTransactionId());
                                    sewaTanahBp.setSewaTanahId(0);
                                    sewaTanahBp.setSewaTanahInvId(0);


                                } else if (pembayaran.getSewaTanahInvoiceId() != 0) {

                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(0);
                                    sewaTanahBp.setSewaTanahInvId(pembayaran.getSewaTanahInvoiceId());
                                    sewaTanahBp.setSewaTanahId(0);

                                    try {
                                        SewaTanahInvoice sti = (SewaTanahInvoice) DbSewaTanahInvoice.fetchExc(pembayaran.getSewaTanahInvoiceId());
                                        sewaTanahBp.setSewaTanahId(sti.getSewaTanahId());
                                    } catch (Exception e) {
                                        System.out.println("[exception] fetch sewa tanah invoice : " + e.toString());
                                    }

                                } else {

                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(0);
                                    sewaTanahBp.setSewaTanahInvId(0);
                                    sewaTanahBp.setSewaTanahId(0);

                                }

                                try {
                                    long oidSTBP = DbSewaTanahBp.updateExc(sewaTanahBp);
                                } catch (Exception e) {
                                    System.out.println("[exception] " + e.toString());
                                }

                            } else {

                                SewaTanahBp sewaTanahBp = new SewaTanahBp();

                                sewaTanahBp.setMataUangId(this.pembayaran.getMataUangId());
                                sewaTanahBp.setMem("-");
                                sewaTanahBp.setDebet(0);
                                sewaTanahBp.setTanggal(this.pembayaran.getTanggal());
                                sewaTanahBp.setRefnumber(this.pembayaran.getNoInvoice());
                                sewaTanahBp.setKeterangan("-");
                                sewaTanahBp.setCredit(this.pembayaran.getJumlah());
                                sewaTanahBp.setCustomerId(this.pembayaran.getCustomerId());

                                if (pembayaran.getIrigasiTransactionId() != 0) {

                                    sewaTanahBp.setIrigasiTransactionId(pembayaran.getIrigasiTransactionId());
                                    sewaTanahBp.setLimbahTransactionId(0);
                                    sewaTanahBp.setSewaTanahId(0);
                                    sewaTanahBp.setSewaTanahInvId(0);

                                } else if (pembayaran.getLimbahTransactionId() != 0) {

                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(pembayaran.getLimbahTransactionId());
                                    sewaTanahBp.setSewaTanahId(0);
                                    sewaTanahBp.setSewaTanahInvId(0);


                                } else if (pembayaran.getSewaTanahInvoiceId() != 0) {

                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(0);
                                    sewaTanahBp.setSewaTanahInvId(pembayaran.getSewaTanahInvoiceId());
                                    sewaTanahBp.setSewaTanahId(0);

                                    try {
                                        SewaTanahInvoice sti = (SewaTanahInvoice) DbSewaTanahInvoice.fetchExc(pembayaran.getSewaTanahInvoiceId());
                                        sewaTanahBp.setSewaTanahId(sti.getSewaTanahId());
                                    } catch (Exception e) {
                                        System.out.println("[exception] fetch sewa tanah invoice : " + e.toString());
                                    }

                                } else {
                                    sewaTanahBp.setIrigasiTransactionId(0);
                                    sewaTanahBp.setLimbahTransactionId(0);
                                    sewaTanahBp.setSewaTanahInvId(0);
                                    sewaTanahBp.setSewaTanahId(0);

                                }
                                try {
                                    long oidSTBP = DbSewaTanahBp.insertExc(sewaTanahBp);
                                } catch (Exception e) {
                                    System.out.println("[exception] " + e.toString());
                                }
                            }
                        }

                        DbPembayaran.updateStatusInvoice(transactionId, pembayaran.getTransactionSource(), totInvoice, invoiceCurrency);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidPembayaran != 0) {
                    try {
                        pembayaran = DbPembayaran.fetchExc(oidPembayaran);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidPembayaran != 0) {
                    try {
                        pembayaran = DbPembayaran.fetchExc(oidPembayaran);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidPembayaran != 0) {
                    try {
                        long oid = DbPembayaran.deleteExc(oidPembayaran);
                        if (oid != 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            default:

        }
        return rsCode;
    }
}
