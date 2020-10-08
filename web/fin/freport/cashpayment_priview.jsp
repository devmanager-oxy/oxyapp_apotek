
<%-- 
    Document   : cashpayment_priview
    Created on : Jan 6, 2012, 10:03:03 AM
    Author     : Roy Andika
--%>
<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.fms.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<style>
    
    #title{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 14px;
        color: #9A958F;
    }
    
    #head-left{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        color: #9A958F;
        border-left : solid 1px;
        border-top : solid 1px;
    }
    
    #head-right{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        color: #9A958F;
        border-left : solid 1px;
        border-top : solid 1px;
        border-right : solid 1px;        
    }
    
    #data-left{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        color: #9A958F;
        border-left : solid 1px;
        border-top : solid 1px;
        padding-left : 4px;
        padding-right : 4px;
    }
    
    #data-right{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        color: #9A958F;
        border-left : solid 1px;
        border-top : solid 1px;
        border-right : solid 1px;
        padding-left : 4px;
        padding-right : 4px;
    }
    
    #footer-left{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        color: #9A958F;
        border-left : solid 1px;
        border-top : solid 1px;
        border-bottom : solid 1px;
        padding-left : 4px;
        padding-right : 4px;
    }
    
    #footer-right{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;
        color: #9A958F;
        border-left : solid 1px;
        border-top : solid 1px;
        border-right : solid 1px;
        border-bottom : solid 1px;
        padding-left : 4px;
        padding-right : 4px;
    }
    </style>    

<%!
    public String getSubstring1(String s) {
        if (s.length() > 60) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 55) + "...</font></a>";
        }
        return s;
    }

    public String getSubstring(String s) {
        if (s.length() > 105) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 100) + "...</font></a>";
        }
        return s;
    }
%>

<%

            Vector listCashArchive = new Vector();

            if (session.getValue("CASH_PAYMENT") != null) {
                listCashArchive = (Vector) session.getValue("CASH_PAYMENT");
            }

            String[] langCT = {"Journal Number", "Payment from Account", "Amount IDR", "Date Transaction", "Note"};

            String[] langNav = {"OUTSTANDING PAYMENT"};

            if (lang == LANG_ID) {

                String[] langID = {"No. Journal", "Pelunasan Dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan"};

                langCT = langID;

                String[] navID = {"DAFTAR TAGIHAN"};
                langNav = navID;
            }

            session.putValue("CASH_PAYMENT", listCashArchive);
            double total = 0;

%>

<table align="center" width="900px" border="0" cellpadding="0" cellspacing="0">
    <%
            if (listCashArchive != null && listCashArchive.size() > 0) {
    %>      
    <tr>
        <td colspan="6" >&nbsp;</td>
    </tr>   
    <tr height="25">
        <td colspan="6" class id = 'title' align="center"><%=langNav[0]%></td>
    </tr>   
    <tr>
        <td colspan="6" >&nbsp;</td>
    </tr>   
    <tr height="25">
        <td width="5%" class id = 'head-left' align="center">No</td>
        <td width="10%" class id = 'head-left' align="center"><%=langCT[0]%></td>
        <td width="30%" class id = 'head-left' align="center"><%=langCT[1]%></td>
        <td width="15%" class id = 'head-left' align="center"><%=langCT[2]%></td>    
        <td width="15%" class id = 'head-left' align="center"><%=langCT[3]%></td>
        <td width="25%" class id = 'head-right' align="center"><%=langCT[4]%></td>    
    </tr>    
    <%
        for (int i = 0; i < listCashArchive.size(); i++) {

            PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(pp.getCoaId());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            total = total + pp.getAmount();
    %>
    <tr height="25">
        <td class id = 'data-left' align="center"><%=i + 1%></td>
        <td class id = 'data-left'><%=pp.getJournalNumber()%></td>
        <td class id = 'data-left'><%=coa.getCode() + " - " + coa.getName()%></td>
        <td class id = 'data-left'><div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div></td>
        <td class id = 'data-left'><div align="center"><%=JSPFormater.formatDate(pp.getTransDate())%></td>    
        <td class id = 'data-right'><%=getSubstring(pp.getMemo())%></td>         
    </tr>    
    <%
        }
    %>
    
    <tr height="25">
        <td align="center" colspan ="3" class id = 'footer-left'>T O T A L</td>
        <td class id = 'footer-left'><div align="right" ><%=JSPFormater.formatNumber(total, "#,###.##")%></div></td>
        <td colspan="2" class id = 'footer-right'>&nbsp;</td>         
    </tr> 
    <tr>
        <td colspan="6" >&nbsp;</td>
    </tr> 
    <tr>
        <td colspan="6" align="center"> 
        <%
        out.print("<a href=\"../freport/cashpayment_print.jsp\" target='_blank'><img src=\"../images/print.gif\" name=\"delete\" height=\"22\" border=\"0\"></a></td>");
        %>
        </td>
    </tr> 
    <tr>
        <td colspan="6" >&nbsp;</td>
    </tr> 
    <%
            }
    %>
</table>


