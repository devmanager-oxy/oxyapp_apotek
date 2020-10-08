
<%-- 
    Document   : insertbank
    Created on : Mar 8, 2015, 7:28:37 PM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.fms.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%
            Vector banks = DbBankPayment.list(0, 0, DbBankPayment.colNames[DbBankPayment.COL_TYPE] + " in (" + DbBankPayment.TYPE_CARD_CREDIT + "," + DbBankPayment.TYPE_CARD_DEBIT + ") ", null);
            
            if (banks != null && banks.size() > 0) {
                for (int i = 0; i < banks.size(); i++) {
                    BankPayment bp = (BankPayment) banks.get(i);

                    out.println("===" + bp.getJournalNumber() + "=========<BR>");

                    Payment p = new Payment();
                    try {
                        p = DbPayment.fetchExc(bp.getReferensiId());
                        if (p.getMerchantId() != 0) {
                            Merchant m = DbMerchant.fetchExc(p.getMerchantId());
                            bp.setBankId(m.getBankId());
                            DbBankPayment.updateExc(bp);
                        }
                    } catch (Exception e) {
                    }
                }
            }
%>
