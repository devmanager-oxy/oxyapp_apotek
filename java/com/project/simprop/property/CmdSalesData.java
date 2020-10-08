/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.DbSystemProperty;
import com.project.util.jsp.*;
import com.project.util.lang.*;
import com.project.crm.master.Lot;
import com.project.crm.master.DbLot;
import com.project.general.Customer;
import com.project.general.DbCustomer;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.SystemDocNumber;

/**
 *
 * @author Roy Andika
 */
public class CmdSalesData extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private SalesData salesData;
    private DbSalesData pstSalesData;
    private JspSalesData jspSalesData;
    int language = LANGUAGE_DEFAULT;

    public CmdSalesData(HttpServletRequest request) {
        msgString = "";
        salesData = new SalesData();
        try {
            pstSalesData = new DbSalesData(0);
        } catch (Exception e) {
        }
        jspSalesData = new JspSalesData(request, salesData);
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

    public SalesData getSalesData() {
        return salesData;
    }

    public JspSalesData getForm() {
        return jspSalesData;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSalesData) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.ASSIGN:
                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (Exception exc) {
                    }
                }

                jspSalesData.requestEntityObject(salesData);

                if (jspSalesData.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (salesData.getOID() == 0) {
                    try {
                        long oid = pstSalesData.insertExc(this.salesData);
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
                        long oid = pstSalesData.updateExc(this.salesData);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;
            case JSPCommand.SUBMIT:
                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (Exception exc) {
                    }
                }

                jspSalesData.requestEntityObject(salesData);

                if (jspSalesData.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (salesData.getOID() == 0) {
                    try {
                        long oid = pstSalesData.insertExc(this.salesData);
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
                        long oid = pstSalesData.updateExc(this.salesData);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SAVE:

                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (Exception exc) {
                    }
                }

                jspSalesData.requestEntityObject(salesData);

                if (jspSalesData.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (salesData.getOID() == 0) {
                    try {

                        Date dt = new Date();

                        int valInpJournalNum = 0;
                        try {
                            valInpJournalNum = Integer.parseInt(DbSystemProperty.getValueByName("PROP_INPUT_JOURNAL_NUMBER"));
                        } catch (Exception e) {
                            valInpJournalNum = 0;
                        }

                        SystemDocNumber systemDocNumber = new SystemDocNumber();

                        if (valInpJournalNum == 0) {

                            String formatDocCode = DbSalesData.getNumberPrefix(salesData.getDateTransaction());
                            int counter = DbSalesData.getSalesNextCounter(salesData.getDateTransaction());

                            salesData.setJournalCounter(counter);
                            salesData.setJournalPrefix(formatDocCode);

                            systemDocNumber.setCounter(counter);
                            systemDocNumber.setDate(new Date());
                            systemDocNumber.setPrefixNumber(formatDocCode);
                            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SALES_PROPERTY]);
                            systemDocNumber.setYear(dt.getYear() + 1900);

                            formatDocCode = DbSalesData.getNextNumber(counter, salesData.getDateTransaction());
                            systemDocNumber.setDocNumber(formatDocCode);

                            salesData.setSalesNumber(formatDocCode);
                        }

                        Customer cst = new Customer();

                        if (salesData.getCustomerId() != 0) {
                            cst = DbCustomer.fetchExc(salesData.getCustomerId());
                        }

                        cst.setName(salesData.getName());
                        cst.setAddress1(salesData.getAddress());
                        cst.setAddress2(salesData.getAddress2());
                        cst.setIdNumber(salesData.getIdNumber());
                        cst.setPhone(salesData.getTelephone());
                        cst.setHp(salesData.getPh());
                        cst.setEmail(salesData.getEmail());
                        cst.setHotelNote(salesData.getSpecialRequirement());
                        cst.setRegDate(new Date());

                        long oid = 0;
                        long oidCst = 0;

                        if (salesData.getCustomerId() == 0) {
                            oidCst = DbCustomer.insert(cst);
                            salesData.setCustomerId(oidCst);
                        } else {
                            oidCst = DbCustomer.update(cst);
                        }

                        if (oidCst != 0) {
                            salesData.setCustomerId(oidCst);
                            salesData.setStatus(DbSalesData.STATUS_RESERVATION);
                            oid = pstSalesData.insertExc(this.salesData);
                        }

                        if (oid != 0) {
                            //update lot status
                            try {
                                Lot lt = DbLot.fetchExc(salesData.getLotId());
                                lt.setStatus(DbLot.LOT_STATUS_RESERVATION);
                                DbLot.updateExc(lt);
                            } catch (Exception e) {
                            }

                            if (valInpJournalNum == 0) {
                                //insert doc number
                                try {
                                    DbSystemDocNumber.insertExc(systemDocNumber);
                                } catch (Exception E) {
                                    System.out.println("[exception] " + E.toString());
                                }
                            }
                        }

                        if (oid != 0) {

                            if (salesData.getPaymentType() == DbSalesData.TYPE_HARD_CASH) {

                                if (salesData.getBfAmount() > 0) {

                                    PaymentSimulation paymentSimulation = new PaymentSimulation();

                                    paymentSimulation.setSalesDataId(oid);
                                    paymentSimulation.setTypePayment(DbSalesData.TYPE_HARD_CASH);
                                    paymentSimulation.setName("Booking Fee (BF)");
                                    paymentSimulation.setSaldo(salesData.getFinalPrice());
                                    paymentSimulation.setAmount(salesData.getBfAmount());                                    
                                    paymentSimulation.setTotalAmount(salesData.getBfAmount());
                                    paymentSimulation.setDueDate(salesData.getBfDueDate());
                                    paymentSimulation.setCustomerId(salesData.getCustomerId());
                                    paymentSimulation.setStatusGen(0);
                                    paymentSimulation.setUserId(salesData.getUserId());
                                    paymentSimulation.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                    paymentSimulation.setPayment(DbPaymentSimulation.PAYMENT_BF);

                                    try {
                                        DbPaymentSimulation.insertExc(paymentSimulation);
                                    } catch (Exception e) {
                                    }
                                }

                                double angsuranDp = 0;
                                double saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                int dtDp = salesData.getDpDueDate().getDate();

                                if (salesData.getDpAmount() > 0) {

                                    int xx = salesData.getPeriodeDp();
                                    angsuranDp = salesData.getDpAmount() / xx;
                                    double angsuranDp1 = 0;
                                    
                                    if(salesData.getAmountPelunasan() > 0){
                                        angsuranDp1 = angsuranDp - salesData.getBfAmount();
                                    }else{
                                        angsuranDp1 = angsuranDp;
                                    }
                                    
                                    Date newDt = salesData.getDpDueDate();

                                    for (int t = 0; t < xx; t++) {
                                        if (t == 0) {
                                            saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                        } else {
                                            if (t == 1) {
                                                saldo = saldo - angsuranDp1;
                                            } else {
                                                saldo = saldo - angsuranDp;
                                            }
                                        }
                                        int counterx = t + 1;
                                        PaymentSimulation paymentSimulation1 = new PaymentSimulation();
                                        paymentSimulation1.setSalesDataId(oid);
                                        paymentSimulation1.setTypePayment(DbSalesData.TYPE_HARD_CASH);
                                        paymentSimulation1.setName("Uang Muka " + counterx);
                                        paymentSimulation1.setSaldo(saldo);

                                        if (t == 0) {
                                            paymentSimulation1.setAmount(angsuranDp1);
                                            paymentSimulation1.setTotalAmount(angsuranDp1);
                                        } else {
                                            paymentSimulation1.setAmount(angsuranDp);
                                            paymentSimulation1.setTotalAmount(angsuranDp);
                                        }

                                        paymentSimulation1.setDueDate(newDt);
                                        paymentSimulation1.setCustomerId(salesData.getCustomerId());
                                        paymentSimulation1.setStatusGen(0);
                                        paymentSimulation1.setUserId(salesData.getUserId());
                                        paymentSimulation1.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                        paymentSimulation1.setPayment(DbPaymentSimulation.PAYMENT_DP);

                                        try {
                                            DbPaymentSimulation.insertExc(paymentSimulation1);
                                        } catch (Exception e) {
                                        }

                                        int tmpMonth = newDt.getMonth();
                                        int month = newDt.getMonth() + 1;
                                        newDt.setMonth(month);
                                        
                                        if(newDt.getMonth() - tmpMonth != -11){
                                            if(newDt.getMonth() - tmpMonth != 1){
                                                newDt.setMonth(tmpMonth);
                                                newDt.setDate(1);
                                                month = newDt.getMonth() + 1;
                                                newDt.setMonth(month);
                                                int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                                newDt.setDate(totDay);
                                            }else{                                        
                                                newDt.setMonth(month);
                                                newDt.setDate(dtDp);
                                            }
                                        }
                                    }
                                }

                                if (salesData.getAmountPelunasan() > 0) {
                                    
                                    PaymentSimulation paymentSimulation2 = new PaymentSimulation();

                                    saldo = saldo - angsuranDp;
                                    paymentSimulation2.setSalesDataId(oid);
                                    paymentSimulation2.setTypePayment(DbSalesData.TYPE_HARD_CASH);
                                    paymentSimulation2.setName("Pelunasan");
                                    paymentSimulation2.setSaldo(saldo);
                                    if (salesData.getDpAmount() > 0) {
                                        paymentSimulation2.setAmount(salesData.getAmountPelunasan() + salesData.getBfAmount());
                                        paymentSimulation2.setTotalAmount(salesData.getAmountPelunasan() + salesData.getBfAmount());
                                    } else {
                                        paymentSimulation2.setAmount(salesData.getAmountPelunasan());
                                        paymentSimulation2.setTotalAmount(salesData.getAmountPelunasan());
                                    }
                                    paymentSimulation2.setDueDate(salesData.getPelunasanDueDate());
                                    paymentSimulation2.setCustomerId(salesData.getCustomerId());
                                    paymentSimulation2.setStatusGen(0);
                                    paymentSimulation2.setUserId(salesData.getUserId());
                                    paymentSimulation2.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                    paymentSimulation2.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);
                                    try {
                                        DbPaymentSimulation.insertExc(paymentSimulation2);
                                    } catch (Exception e) {
                                    }
                                }

                            } else if (salesData.getPaymentType() == DbSalesData.TYPE_CASH_BERJANGKA) {

                                PaymentSimulation paymentSimulation = new PaymentSimulation();

                                paymentSimulation.setSalesDataId(oid);
                                paymentSimulation.setTypePayment(DbSalesData.TYPE_CASH_BERJANGKA);
                                paymentSimulation.setName("Booking Fee (BF)");
                                paymentSimulation.setSaldo(salesData.getFinalPrice());
                                paymentSimulation.setAmount(salesData.getBfAmount());
                                paymentSimulation.setTotalAmount(salesData.getBfAmount());
                                paymentSimulation.setDueDate(salesData.getBfDueDate());
                                paymentSimulation.setCustomerId(salesData.getCustomerId());
                                paymentSimulation.setStatusGen(0);
                                paymentSimulation.setUserId(salesData.getUserId());
                                paymentSimulation.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                paymentSimulation.setPayment(DbPaymentSimulation.PAYMENT_BF);

                                try {
                                    DbPaymentSimulation.insertExc(paymentSimulation);
                                } catch (Exception e) {
                                }

                                double angsuranDp = 0;
                                double saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                int dtDp = salesData.getDpDueDate().getDate();
                                
                                if (salesData.getDpAmount() > 0) {

                                    int xx = salesData.getPeriodeDp();
                                    angsuranDp = salesData.getDpAmount() / xx;
                                    double angsuranDp1 = 0;
                                    if(salesData.getAngsuran() > 0){
                                        angsuranDp1 = angsuranDp - salesData.getBfAmount();
                                    }else{
                                        angsuranDp1 = angsuranDp;
                                    }
                                    Date newDt = salesData.getDpDueDate();
                                    saldo = 0;

                                    for (int t = 0; t < xx; t++) {
                                        if (t == 0) {
                                            saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                        } else {
                                            if (t == 1) {
                                                saldo = saldo - angsuranDp1;
                                            } else {
                                                saldo = saldo - angsuranDp;
                                            }
                                        }
                                        int counterx = t + 1;
                                        PaymentSimulation paymentSimulation1 = new PaymentSimulation();
                                        paymentSimulation1.setSalesDataId(oid);
                                        paymentSimulation1.setTypePayment(DbSalesData.TYPE_CASH_BERJANGKA);
                                        paymentSimulation1.setName("Uang Muka " + counterx);
                                        paymentSimulation1.setSaldo(saldo);

                                        if (t == 0) {
                                            paymentSimulation1.setAmount(angsuranDp1);
                                            paymentSimulation1.setTotalAmount(angsuranDp1);
                                        } else {
                                            paymentSimulation1.setAmount(angsuranDp);
                                            paymentSimulation1.setTotalAmount(angsuranDp);
                                        }

                                        paymentSimulation1.setDueDate(newDt);
                                        paymentSimulation1.setCustomerId(salesData.getCustomerId());
                                        paymentSimulation1.setStatusGen(0);
                                        paymentSimulation1.setUserId(salesData.getUserId());
                                        paymentSimulation1.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                        paymentSimulation1.setPayment(DbPaymentSimulation.PAYMENT_DP);

                                        try {
                                            DbPaymentSimulation.insertExc(paymentSimulation1);
                                        } catch (Exception e) {
                                        }
                                        
                                        int tmpMonth = newDt.getMonth();
                                        int month = newDt.getMonth() + 1;
                                        newDt.setMonth(month);
                                        
                                        if(newDt.getMonth() - tmpMonth != -11){
                                            if(newDt.getMonth() - tmpMonth != 1){
                                                newDt.setMonth(tmpMonth);
                                                newDt.setDate(1);
                                                month = newDt.getMonth() + 1;
                                                newDt.setMonth(month);
                                                int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                                newDt.setDate(totDay);
                                            }else{                                        
                                                newDt.setMonth(month);
                                                newDt.setDate(dtDp);
                                            }
                                        }    
                                    }
                                }

                                if (salesData.getAngsuran() > 0) {

                                    Date newDtx = salesData.getDueDateAngsuran();
                                    int dtAngsuran = salesData.getDueDateAngsuran().getDate();

                                    double angsuran = 0;

                                    if (salesData.getDpAmount() > 0) {
                                        angsuran = (salesData.getAngsuran() + salesData.getBfAmount()) / salesData.getPeriode();
                                    } else {
                                        angsuran = (salesData.getAngsuran()) / salesData.getPeriode();
                                    }

                                    for (int i = 0; i < salesData.getPeriode(); i++) {
                                        int num = i + 1;
                                        PaymentSimulation paymentSimulation2 = new PaymentSimulation();
                                        if (i == 0) {
                                            saldo = saldo - angsuranDp;
                                        } else {
                                            saldo = saldo - angsuran;
                                        }
                                        paymentSimulation2.setSalesDataId(oid);
                                        paymentSimulation2.setTypePayment(DbSalesData.TYPE_CASH_BERJANGKA);
                                        paymentSimulation2.setName("Angsuran " + num);
                                        paymentSimulation2.setSaldo(saldo);
                                        paymentSimulation2.setAmount(angsuran);
                                        paymentSimulation2.setTotalAmount(angsuran);
                                        paymentSimulation2.setCustomerId(salesData.getCustomerId());
                                        paymentSimulation2.setStatusGen(0);
                                        paymentSimulation2.setUserId(salesData.getUserId());
                                        paymentSimulation2.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                        paymentSimulation2.setDueDate(newDtx);
                                        paymentSimulation2.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);
                                        try {
                                            DbPaymentSimulation.insertExc(paymentSimulation2);
                                        } catch (Exception e) {
                                        }
                                        
                                        int tmpMonth = newDtx.getMonth();
                                        int month = newDtx.getMonth() + 1;
                                        newDtx.setMonth(month);
                                        
                                        if(newDtx.getMonth() - tmpMonth != -11){
                                            if(newDtx.getMonth() - tmpMonth != 1){
                                                newDtx.setMonth(tmpMonth);
                                                newDtx.setDate(1);
                                                month = newDtx.getMonth() + 1;
                                                newDtx.setMonth(month);
                                                int totDay = DbSalesData.totalDate(newDtx.getMonth()+1,newDtx.getYear()+1900);
                                                newDtx.setDate(totDay);
                                            }else{                                        
                                                newDtx.setMonth(month);
                                                newDtx.setDate(dtAngsuran);
                                            }
                                        }
                                    }
                                }

                            } else if (salesData.getPaymentType() == DbSalesData.TYPE_KPA) {

                                PaymentSimulation paymentSimulation = new PaymentSimulation();

                                paymentSimulation.setSalesDataId(oid);
                                paymentSimulation.setTypePayment(DbSalesData.TYPE_KPA);
                                paymentSimulation.setName("Booking Fee (BF)");
                                paymentSimulation.setSaldo(salesData.getFinalPrice());
                                paymentSimulation.setAmount(salesData.getBfAmount());
                                paymentSimulation.setTotalAmount(salesData.getBfAmount());
                                paymentSimulation.setDueDate(salesData.getBfDueDate());
                                paymentSimulation.setCustomerId(salesData.getCustomerId());
                                paymentSimulation.setStatusGen(0);
                                paymentSimulation.setUserId(salesData.getUserId());
                                paymentSimulation.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                paymentSimulation.setPayment(DbPaymentSimulation.PAYMENT_BF);

                                try {
                                    DbPaymentSimulation.insertExc(paymentSimulation);
                                } catch (Exception e) {
                                }

                                double angsuranDp = 0;
                                double saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                Date newDt = new Date();
                                int dtDp = salesData.getDpDueDate().getDate();
                                
                                if (salesData.getDpAmount() > 0) {

                                    int xx = salesData.getPeriodeDp();

                                    angsuranDp = salesData.getDpAmount() / xx;
                                    double angsuranDp1 = angsuranDp - salesData.getBfAmount();
                                    newDt = salesData.getDpDueDate();
                                    
                                    for (int t = 0; t < xx; t++) {
                                        if (t == 0) {
                                            saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                        } else {
                                            if (t == 1) {
                                                saldo = saldo - angsuranDp1;
                                            } else {
                                                saldo = saldo - angsuranDp;
                                            }
                                        }
                                        int counterx = t + 1;
                                        PaymentSimulation paymentSimulation1 = new PaymentSimulation();
                                        paymentSimulation1.setSalesDataId(oid);
                                        paymentSimulation1.setTypePayment(DbSalesData.TYPE_KPA);
                                        paymentSimulation1.setName("Uang Muka " + counterx);
                                        paymentSimulation1.setSaldo(saldo);
                                        if (t == 0) {
                                            paymentSimulation1.setAmount(angsuranDp1);
                                            paymentSimulation1.setTotalAmount(angsuranDp1);
                                        } else {
                                            paymentSimulation1.setAmount(angsuranDp);
                                            paymentSimulation1.setTotalAmount(angsuranDp);
                                        }
                                        paymentSimulation1.setDueDate(newDt);
                                        paymentSimulation1.setCustomerId(salesData.getCustomerId());
                                        paymentSimulation1.setStatusGen(0);
                                        paymentSimulation1.setUserId(salesData.getUserId());
                                        paymentSimulation1.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                        paymentSimulation1.setPayment(DbPaymentSimulation.PAYMENT_DP);

                                        try {
                                            DbPaymentSimulation.insertExc(paymentSimulation1);
                                        } catch (Exception e) {
                                        }
                                        
                                        int tmpMonth = newDt.getMonth();
                                        int month = newDt.getMonth() + 1;
                                        newDt.setMonth(month);
                                        
                                        if(newDt.getMonth() - tmpMonth != -11){    
                                            if(newDt.getMonth() - tmpMonth != 1){
                                                newDt.setMonth(tmpMonth);
                                                newDt.setDate(1);
                                                month = newDt.getMonth() + 1;
                                                newDt.setMonth(month);
                                                int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                                newDt.setDate(totDay);
                                            }else{                                        
                                                newDt.setMonth(month);
                                                newDt.setDate(dtDp);
                                            }
                                        }    
                                    }
                                }

                                //50%
                                double amount = salesData.getFinalPrice() - salesData.getDpAmount();
                                PaymentSimulation paymentSimulation2 = new PaymentSimulation();

                                saldo = amount;
                                double totamount = 0.5 * amount;

                                paymentSimulation2.setSalesDataId(oid);
                                paymentSimulation2.setTypePayment(DbSalesData.TYPE_KPA);
                                paymentSimulation2.setName("Angsuran dari Bank  50% ");
                                paymentSimulation2.setSaldo(saldo);
                                paymentSimulation2.setAmount(totamount);
                                paymentSimulation2.setTotalAmount(totamount);
                                paymentSimulation2.setCustomerId(salesData.getCustomerId());
                                paymentSimulation2.setStatusGen(0);
                                paymentSimulation2.setUserId(salesData.getUserId());
                                paymentSimulation2.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                paymentSimulation2.setDueDate(newDt);
                                paymentSimulation2.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);

                                try {
                                    DbPaymentSimulation.insertExc(paymentSimulation2);
                                } catch (Exception e) {
                                }

                                int tmpMonth = newDt.getMonth();
                                int month = newDt.getMonth() + 1;
                                newDt.setMonth(month);
                                        
                                if(newDt.getMonth() - tmpMonth != -11){
                                    if(newDt.getMonth() - tmpMonth != 1){
                                        newDt.setMonth(tmpMonth);
                                        newDt.setDate(1);
                                        month = newDt.getMonth() + 1;
                                        newDt.setMonth(month);
                                        int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                        newDt.setDate(totDay);
                                    }else{                                        
                                        newDt.setMonth(month);
                                        newDt.setDate(dtDp);
                                    }
                                }

                                //40% ============
                                PaymentSimulation paymentSimulation3 = new PaymentSimulation();
                                saldo = amount - totamount;
                                totamount = 0.4 * amount;

                                paymentSimulation3.setSalesDataId(oid);
                                paymentSimulation3.setTypePayment(DbSalesData.TYPE_KPA);
                                paymentSimulation3.setName("Angsuran dari Bank  40% ");
                                paymentSimulation3.setSaldo(saldo);
                                paymentSimulation3.setAmount(totamount);
                                paymentSimulation3.setTotalAmount(totamount);
                                paymentSimulation3.setCustomerId(salesData.getCustomerId());
                                paymentSimulation3.setStatusGen(0);
                                paymentSimulation3.setUserId(salesData.getUserId());
                                paymentSimulation3.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                paymentSimulation3.setDueDate(newDt);
                                paymentSimulation3.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);

                                try {
                                    DbPaymentSimulation.insertExc(paymentSimulation3);
                                } catch (Exception e) {
                                }

                                tmpMonth = newDt.getMonth();
                                month = newDt.getMonth() + 1;
                                newDt.setMonth(month);
                                        
                                if(newDt.getMonth() - tmpMonth != -11){
                                    if(newDt.getMonth() - tmpMonth != 1){
                                        newDt.setMonth(tmpMonth);
                                        newDt.setDate(1);
                                        month = newDt.getMonth() + 1;
                                        newDt.setMonth(month);
                                        int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                        newDt.setDate(totDay);
                                    }else{                                        
                                        newDt.setMonth(month);
                                        newDt.setDate(dtDp);
                                    }
                                }

                                //10% ============
                                PaymentSimulation paymentSimulation4 = new PaymentSimulation();

                                saldo = amount - totamount;
                                totamount = 0.1 * amount;

                                paymentSimulation4.setSalesDataId(oid);
                                paymentSimulation4.setTypePayment(DbSalesData.TYPE_KPA);
                                paymentSimulation4.setName("Angsuran dari Bank  10% ");
                                paymentSimulation4.setSaldo(saldo);
                                paymentSimulation4.setAmount(totamount);
                                paymentSimulation4.setTotalAmount(totamount);
                                paymentSimulation4.setCustomerId(salesData.getCustomerId());
                                paymentSimulation4.setStatusGen(0);
                                paymentSimulation4.setUserId(salesData.getUserId());
                                paymentSimulation4.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                paymentSimulation4.setDueDate(newDt);
                                paymentSimulation4.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);

                                try {
                                    DbPaymentSimulation.insertExc(paymentSimulation4);
                                } catch (Exception e) {
                                }                               
                            }                         
                        }

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }
                //update sales data    
                } else {
                    try {
                        Customer cst = new Customer();

                        cst = DbCustomer.fetchExc(salesData.getCustomerId());

                        cst.setName(salesData.getName());
                        cst.setAddress1(salesData.getAddress());
                        cst.setAddress2(salesData.getAddress2());
                        cst.setIdNumber(salesData.getIdNumber());
                        cst.setPhone(salesData.getTelephone());
                        cst.setHp(salesData.getPh());
                        cst.setEmail(salesData.getEmail());
                        cst.setHotelNote(salesData.getSpecialRequirement());
                        if (cst.getRegDate() == null) {
                            cst.setRegDate(new Date());
                        }

                        DbCustomer.update(cst);
                        long oid = pstSalesData.updateExc(this.salesData);

                        if (oid != 0) {

                            //check dulu sebelum mendelete
                            String wh = DbPaymentSimulation.colNames[DbPaymentSimulation.COL_SALES_DATA_ID] + "=" + salesData.getOID() +
                                    " and " + DbPaymentSimulation.colNames[DbPaymentSimulation.COL_STATUS] + " != " + DbPaymentSimulation.STATUS_BELUM_LUNAS;

                            int count = DbPaymentSimulation.getCount(wh);

                            //jika belum ada yang dibayar
                            if (count == 0) {
                                DbPaymentSimulation.deleteList(salesData.getOID());
                                DbPaymentSimulation.deleteListInv(salesData.getOID());

                                if (salesData.getPaymentType() == DbSalesData.TYPE_HARD_CASH) {

                                    PaymentSimulation paymentSimulation = new PaymentSimulation();

                                    paymentSimulation.setSalesDataId(oid);
                                    paymentSimulation.setTypePayment(DbSalesData.TYPE_HARD_CASH);
                                    paymentSimulation.setName("Booking Fee (BF)");
                                    paymentSimulation.setSaldo(salesData.getFinalPrice());
                                    paymentSimulation.setAmount(salesData.getBfAmount());
                                    paymentSimulation.setTotalAmount(salesData.getBfAmount());
                                    paymentSimulation.setDueDate(salesData.getBfDueDate());
                                    paymentSimulation.setCustomerId(salesData.getCustomerId());
                                    paymentSimulation.setStatusGen(0);
                                    paymentSimulation.setUserId(salesData.getUserId());
                                    paymentSimulation.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                    paymentSimulation.setPayment(DbPaymentSimulation.PAYMENT_BF);

                                    try {
                                        DbPaymentSimulation.insertExc(paymentSimulation);
                                    } catch (Exception e) {
                                    }

                                    double angsuranDp = 0;
                                    double saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                    int dtDp = salesData.getDpDueDate().getDate();
                                    
                                    if (salesData.getDpAmount() > 0) {

                                        int xx = salesData.getPeriodeDp();
                                        angsuranDp = salesData.getDpAmount() / xx;
                                        double angsuranDp1 = 0;
                                        
                                        if (salesData.getAmountPelunasan() > 0) {
                                            angsuranDp1 = angsuranDp - salesData.getBfAmount();
                                        }else{
                                            angsuranDp1 = angsuranDp;;
                                        }
                                        
                                        Date newDt = salesData.getDpDueDate();
                                        saldo = 0;

                                        for (int t = 0; t < xx; t++) {
                                            if (t == 0) {
                                                saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                            } else {
                                                if (t == 1) {
                                                    saldo = saldo - angsuranDp1;
                                                } else {
                                                    saldo = saldo - angsuranDp;
                                                }
                                            }
                                            int counterx = t + 1;
                                            PaymentSimulation paymentSimulation1 = new PaymentSimulation();
                                            paymentSimulation1.setSalesDataId(oid);
                                            paymentSimulation1.setTypePayment(DbSalesData.TYPE_HARD_CASH);
                                            paymentSimulation1.setName("Uang Muka " + counterx);
                                            paymentSimulation1.setSaldo(saldo);
                                            if (t == 0) {
                                                paymentSimulation1.setAmount(angsuranDp1);
                                                paymentSimulation1.setTotalAmount(angsuranDp1);
                                            } else {
                                                paymentSimulation1.setAmount(angsuranDp);
                                                paymentSimulation1.setTotalAmount(angsuranDp);
                                            }
                                            paymentSimulation1.setDueDate(newDt);
                                            paymentSimulation1.setCustomerId(salesData.getCustomerId());
                                            paymentSimulation1.setStatusGen(0);
                                            paymentSimulation1.setUserId(salesData.getUserId());
                                            paymentSimulation1.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                            paymentSimulation1.setPayment(DbPaymentSimulation.PAYMENT_DP);

                                            try {
                                                DbPaymentSimulation.insertExc(paymentSimulation1);
                                            } catch (Exception e) {
                                            }

                                            int tmpMonth = newDt.getMonth();
                                            int month = newDt.getMonth() + 1;
                                            newDt.setMonth(month);
                                        
                                            if(newDt.getMonth() - tmpMonth != -11){
                                                if(newDt.getMonth() - tmpMonth != 1){
                                                    newDt.setMonth(tmpMonth);
                                                    newDt.setDate(1);
                                                    month = newDt.getMonth() + 1;
                                                    newDt.setMonth(month);
                                                    int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                                    newDt.setDate(totDay);
                                                }else{                                        
                                                    newDt.setMonth(month);
                                                    newDt.setDate(dtDp);
                                                }
                                            }
                                        }

                                    }

                                    if (salesData.getAmountPelunasan() > 0) {
                                        PaymentSimulation paymentSimulation2 = new PaymentSimulation();

                                        saldo = saldo - angsuranDp;
                                        paymentSimulation2.setSalesDataId(oid);
                                        paymentSimulation2.setTypePayment(DbSalesData.TYPE_HARD_CASH);
                                        paymentSimulation2.setName("Pelunasan");
                                        paymentSimulation2.setSaldo(saldo);
                                        if (salesData.getDpAmount() > 0) {
                                            paymentSimulation2.setAmount(salesData.getAmountPelunasan() + salesData.getBfAmount());
                                            paymentSimulation2.setTotalAmount(salesData.getAmountPelunasan() + salesData.getBfAmount());
                                        } else {
                                            paymentSimulation2.setAmount(salesData.getAmountPelunasan());
                                            paymentSimulation2.setTotalAmount(salesData.getAmountPelunasan());
                                        }
                                        paymentSimulation2.setDueDate(salesData.getPelunasanDueDate());
                                        paymentSimulation2.setCustomerId(salesData.getCustomerId());
                                        paymentSimulation2.setStatusGen(0);
                                        paymentSimulation2.setUserId(salesData.getUserId());
                                        paymentSimulation2.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                        paymentSimulation2.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);

                                        try {
                                            DbPaymentSimulation.insertExc(paymentSimulation2);
                                        } catch (Exception e) {
                                        }

                                    }

                                } else if (salesData.getPaymentType() == DbSalesData.TYPE_CASH_BERJANGKA) {

                                    PaymentSimulation paymentSimulation = new PaymentSimulation();

                                    paymentSimulation.setSalesDataId(oid);
                                    paymentSimulation.setTypePayment(DbSalesData.TYPE_CASH_BERJANGKA);
                                    paymentSimulation.setName("Booking Fee (BF)");
                                    paymentSimulation.setSaldo(salesData.getFinalPrice());
                                    paymentSimulation.setAmount(salesData.getBfAmount());
                                    paymentSimulation.setTotalAmount(salesData.getBfAmount());
                                    paymentSimulation.setDueDate(salesData.getBfDueDate());
                                    paymentSimulation.setCustomerId(salesData.getCustomerId());
                                    paymentSimulation.setStatusGen(0);
                                    paymentSimulation.setUserId(salesData.getUserId());
                                    paymentSimulation.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                    paymentSimulation.setPayment(DbPaymentSimulation.PAYMENT_BF);

                                    try {
                                        DbPaymentSimulation.insertExc(paymentSimulation);
                                    } catch (Exception e) {
                                    }

                                    double angsuranDp = 0;
                                    double saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                    int dtDp = salesData.getDpDueDate().getDate();
                                    
                                    if (salesData.getDpAmount() > 0) {

                                        int xx = salesData.getPeriodeDp();
                                        angsuranDp = salesData.getDpAmount() / xx;
                                        double angsuranDp1 = 0;
                                        if (salesData.getAngsuran() > 0) {
                                            angsuranDp1 = angsuranDp - salesData.getBfAmount();
                                        }else{
                                            angsuranDp1 = angsuranDp;
                                        }    
                                        
                                        Date newDt = salesData.getDpDueDate();
                                        saldo = 0;

                                        for (int t = 0; t < xx; t++) {
                                            if (t == 0) {
                                                saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                            } else {
                                                if (t == 1) {
                                                    saldo = saldo - angsuranDp1;
                                                } else {
                                                    saldo = saldo - angsuranDp;
                                                }
                                            }
                                            int counterx = t + 1;
                                            PaymentSimulation paymentSimulation1 = new PaymentSimulation();
                                            paymentSimulation1.setSalesDataId(oid);
                                            paymentSimulation1.setTypePayment(DbSalesData.TYPE_CASH_BERJANGKA);
                                            paymentSimulation1.setName("Uang Muka " + counterx);
                                            paymentSimulation1.setSaldo(saldo);

                                            if (t == 0) {
                                                paymentSimulation1.setAmount(angsuranDp1);
                                                paymentSimulation1.setTotalAmount(angsuranDp1);
                                            } else {
                                                paymentSimulation1.setAmount(angsuranDp);
                                                paymentSimulation1.setTotalAmount(angsuranDp);
                                            }

                                            paymentSimulation1.setDueDate(newDt);
                                            paymentSimulation1.setCustomerId(salesData.getCustomerId());
                                            paymentSimulation1.setStatusGen(0);
                                            paymentSimulation1.setUserId(salesData.getUserId());
                                            paymentSimulation1.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                            paymentSimulation1.setPayment(DbPaymentSimulation.PAYMENT_DP);

                                            try {
                                                DbPaymentSimulation.insertExc(paymentSimulation1);
                                            } catch (Exception e) {
                                            }
                                            
                                            int tmpMonth = newDt.getMonth();
                                            int month = newDt.getMonth() + 1;
                                            newDt.setMonth(month);
                                        
                                            if(newDt.getMonth() - tmpMonth != -11){
                                                if(newDt.getMonth() - tmpMonth != 1){
                                                    newDt.setMonth(tmpMonth);
                                                    newDt.setDate(1);
                                                    month = newDt.getMonth() + 1;
                                                    newDt.setMonth(month);
                                                    int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                                    newDt.setDate(totDay);
                                                }else{                                        
                                                    newDt.setMonth(month);
                                                    newDt.setDate(dtDp);
                                                }
                                            }
                                        }
                                    }

                                    if (salesData.getAngsuran() > 0) {

                                        Date newDtx = salesData.getDueDateAngsuran();
                                        int dtAngsuran = salesData.getDueDateAngsuran().getDate();
                                        double angsuran = 0;

                                        if (salesData.getDpAmount() > 0) {
                                            angsuran = (salesData.getAngsuran() + salesData.getBfAmount()) / salesData.getPeriode();
                                        } else {
                                            angsuran = (salesData.getAngsuran()) / salesData.getPeriode();
                                        }

                                        for (int i = 0; i < salesData.getPeriode(); i++) {
                                            int num = i + 1;
                                            PaymentSimulation paymentSimulation2 = new PaymentSimulation();
                                            if (i == 0) {
                                                saldo = saldo - angsuranDp;
                                            } else {
                                                saldo = saldo - angsuran;
                                            }
                                            paymentSimulation2.setSalesDataId(oid);
                                            paymentSimulation2.setTypePayment(DbSalesData.TYPE_CASH_BERJANGKA);
                                            paymentSimulation2.setName("Angsuran " + num);
                                            paymentSimulation2.setSaldo(saldo);
                                            paymentSimulation2.setAmount(angsuran);
                                            paymentSimulation2.setTotalAmount(angsuran);
                                            paymentSimulation2.setCustomerId(salesData.getCustomerId());
                                            paymentSimulation2.setStatusGen(0);
                                            paymentSimulation2.setUserId(salesData.getUserId());
                                            paymentSimulation2.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                            paymentSimulation2.setDueDate(newDtx);
                                            paymentSimulation2.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);
                                            try {
                                                DbPaymentSimulation.insertExc(paymentSimulation2);
                                            } catch (Exception e) {
                                            }
                                            
                                            int tmpMonth = newDtx.getMonth();
                                            int month = newDtx.getMonth() + 1;
                                            newDtx.setMonth(month);
                                            
                                            if(newDtx.getMonth() - tmpMonth != -11){
                                                if(newDtx.getMonth() - tmpMonth != 1){
                                                    newDtx.setMonth(tmpMonth);
                                                    newDtx.setDate(1);
                                                    month = newDtx.getMonth() + 1;
                                                    newDtx.setMonth(month);
                                                    int totDay = DbSalesData.totalDate(newDtx.getMonth()+1,newDtx.getYear()+1900);
                                                    newDtx.setDate(totDay);
                                                }else{                                        
                                                    newDtx.setMonth(month);
                                                    newDtx.setDate(dtAngsuran);
                                                }
                                            }
                                        }
                                    }

                                } else if (salesData.getPaymentType() == DbSalesData.TYPE_KPA) {

                                    PaymentSimulation paymentSimulation = new PaymentSimulation();

                                    paymentSimulation.setSalesDataId(oid);
                                    paymentSimulation.setTypePayment(DbSalesData.TYPE_KPA);
                                    paymentSimulation.setName("Booking Fee (BF)");
                                    paymentSimulation.setSaldo(salesData.getFinalPrice());
                                    paymentSimulation.setAmount(salesData.getBfAmount());
                                    paymentSimulation.setTotalAmount(salesData.getBfAmount());
                                    paymentSimulation.setDueDate(salesData.getBfDueDate());
                                    paymentSimulation.setCustomerId(salesData.getCustomerId());
                                    paymentSimulation.setStatusGen(0);
                                    paymentSimulation.setUserId(salesData.getUserId());
                                    paymentSimulation.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                    paymentSimulation.setPayment(DbPaymentSimulation.PAYMENT_BF);

                                    try {
                                        DbPaymentSimulation.insertExc(paymentSimulation);
                                    } catch (Exception e) {
                                    }

                                    double angsuranDp = 0;
                                    double saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                    Date newDt = new Date();
                                    int dtDp = salesData.getDpDueDate().getDate();
                                    
                                    if (salesData.getDpAmount() > 0) {

                                        int xx = salesData.getPeriodeDp();

                                        angsuranDp = salesData.getDpAmount() / xx;
                                        double angsuranDp1 = angsuranDp - salesData.getBfAmount();
                                        newDt = salesData.getDpDueDate();

                                        for (int t = 0; t < xx; t++) {
                                            if (t == 0) {
                                                saldo = salesData.getFinalPrice() - salesData.getBfAmount();
                                            } else {
                                                if (t == 1) {
                                                    saldo = saldo - angsuranDp1;
                                                } else {
                                                    saldo = saldo - angsuranDp;
                                                }
                                            }
                                            int counterx = t + 1;
                                            PaymentSimulation paymentSimulation1 = new PaymentSimulation();
                                            paymentSimulation1.setSalesDataId(oid);
                                            paymentSimulation1.setTypePayment(DbSalesData.TYPE_KPA);
                                            paymentSimulation1.setName("Uang Muka " + counterx);
                                            paymentSimulation1.setSaldo(saldo);
                                            if (t == 0) {
                                                paymentSimulation1.setAmount(angsuranDp1);
                                                paymentSimulation1.setTotalAmount(angsuranDp1);
                                            } else {
                                                paymentSimulation1.setAmount(angsuranDp);
                                                paymentSimulation1.setTotalAmount(angsuranDp);
                                            }
                                            paymentSimulation1.setDueDate(newDt);
                                            paymentSimulation1.setCustomerId(salesData.getCustomerId());
                                            paymentSimulation1.setStatusGen(0);
                                            paymentSimulation1.setUserId(salesData.getUserId());
                                            paymentSimulation1.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                            paymentSimulation1.setPayment(DbPaymentSimulation.PAYMENT_DP);

                                            try {
                                                DbPaymentSimulation.insertExc(paymentSimulation1);
                                            } catch (Exception e) {
                                            }
                                            
                                            int tmpMonth = newDt.getMonth();
                                            int month = newDt.getMonth() + 1;
                                            newDt.setMonth(month);
                                        
                                            if(newDt.getMonth() - tmpMonth != -11){
                                                if(newDt.getMonth() - tmpMonth != 1){
                                                    newDt.setMonth(tmpMonth);
                                                    newDt.setDate(1);
                                                    month = newDt.getMonth() + 1;
                                                    newDt.setMonth(month);
                                                    int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                                    newDt.setDate(totDay);
                                                }else{                                        
                                                    newDt.setMonth(month);
                                                    newDt.setDate(dtDp);
                                                }
                                            }    
                                        }

                                    }

                                    //50%
                                    double amount = salesData.getFinalPrice() - salesData.getDpAmount();
                                    PaymentSimulation paymentSimulation2 = new PaymentSimulation();

                                    saldo = amount;
                                    double totamount = 0.5 * amount;

                                    paymentSimulation2.setSalesDataId(oid);
                                    paymentSimulation2.setTypePayment(DbSalesData.TYPE_KPA);
                                    paymentSimulation2.setName("Angsuran dari Bank  50% ");
                                    paymentSimulation2.setSaldo(saldo);
                                    paymentSimulation2.setAmount(totamount);
                                    paymentSimulation2.setTotalAmount(totamount);
                                    paymentSimulation2.setCustomerId(salesData.getCustomerId());
                                    paymentSimulation2.setStatusGen(0);
                                    paymentSimulation2.setUserId(salesData.getUserId());
                                    paymentSimulation2.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                    paymentSimulation2.setDueDate(newDt);
                                    paymentSimulation2.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);

                                    try {
                                        DbPaymentSimulation.insertExc(paymentSimulation2);
                                    } catch (Exception e) {
                                    }

                                    int tmpMonth = newDt.getMonth();
                                    int month = newDt.getMonth() + 1;
                                    newDt.setMonth(month);
                                    
                                    if(newDt.getMonth() - tmpMonth != -11){
                                        if(newDt.getMonth() - tmpMonth != 1){
                                            newDt.setMonth(tmpMonth);
                                            newDt.setDate(1);
                                            month = newDt.getMonth() + 1;
                                            newDt.setMonth(month);
                                            int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                            newDt.setDate(totDay);
                                        }else{                                        
                                            newDt.setMonth(month);
                                            newDt.setDate(dtDp);
                                        }
                                    }

                                    //40% ============
                                    PaymentSimulation paymentSimulation3 = new PaymentSimulation();
                                    saldo = amount - totamount;
                                    totamount = 0.4 * amount;

                                    paymentSimulation3.setSalesDataId(oid);
                                    paymentSimulation3.setTypePayment(DbSalesData.TYPE_KPA);
                                    paymentSimulation3.setName("Angsuran dari Bank  40% ");
                                    paymentSimulation3.setSaldo(saldo);
                                    paymentSimulation3.setAmount(totamount);
                                    paymentSimulation3.setTotalAmount(totamount);
                                    paymentSimulation3.setCustomerId(salesData.getCustomerId());
                                    paymentSimulation3.setStatusGen(0);
                                    paymentSimulation3.setUserId(salesData.getUserId());
                                    paymentSimulation3.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                    paymentSimulation3.setDueDate(newDt);
                                    paymentSimulation3.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);

                                    try {
                                        DbPaymentSimulation.insertExc(paymentSimulation3);
                                    } catch (Exception e) {
                                    }

                                    tmpMonth = newDt.getMonth();
                                    month = newDt.getMonth() + 1;
                                    newDt.setMonth(month);
                                        
                                    if(newDt.getMonth() - tmpMonth != -11){
                                        if(newDt.getMonth() - tmpMonth != 1){
                                            newDt.setMonth(tmpMonth);
                                            newDt.setDate(1);
                                            month = newDt.getMonth() + 1;
                                            newDt.setMonth(month);
                                            int totDay = DbSalesData.totalDate(newDt.getMonth()+1,newDt.getYear()+1900);
                                            newDt.setDate(totDay);
                                        }else{                                        
                                            newDt.setMonth(month);
                                            newDt.setDate(dtDp);
                                        }
                                    }

                                    //10% ============
                                    PaymentSimulation paymentSimulation4 = new PaymentSimulation();

                                    saldo = amount - totamount;
                                    totamount = 0.1 * amount;

                                    paymentSimulation4.setSalesDataId(oid);
                                    paymentSimulation4.setTypePayment(DbSalesData.TYPE_KPA);
                                    paymentSimulation4.setName("Angsuran dari Bank  10% ");
                                    paymentSimulation4.setSaldo(saldo);
                                    paymentSimulation4.setAmount(totamount);
                                    paymentSimulation4.setTotalAmount(totamount);
                                    paymentSimulation4.setCustomerId(salesData.getCustomerId());
                                    paymentSimulation4.setStatusGen(0);
                                    paymentSimulation4.setUserId(salesData.getUserId());
                                    paymentSimulation4.setStatus(DbPaymentSimulation.STATUS_BELUM_LUNAS);
                                    paymentSimulation4.setDueDate(newDt);
                                    paymentSimulation4.setPayment(DbPaymentSimulation.PAYMENT_PELUNASAN);

                                    try {
                                        DbPaymentSimulation.insertExc(paymentSimulation4);
                                    } catch (Exception e) {
                                    }
                                }
                            }
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.REFRESH:
                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                jspSalesData.requestEntityObject(salesData);
                break;

            case JSPCommand.EDIT:
                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.CONFIRM:
                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DETAIL:
                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSalesData != 0) {
                    try {
                        long oid = DbSalesData.deleteExc(oidSalesData);
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

            case JSPCommand.RESET:
                if (oidSalesData != 0) {
                    try {
                        salesData = DbSalesData.fetchExc(oidSalesData);
                    } catch (Exception exc) {
                    }
                }
                jspSalesData.requestEntityObject(salesData);

            default:

        }
        return rsCode;
    }
}
