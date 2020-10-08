
<%-- 
    Document   : neracasaldo_priview
    Created on : Nov 18, 2011, 11:38:55 AM
    Author     : Roy Andika
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<style>
    #head-company{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 16px;        
        color: #000;
        text-align: center;
        font-weight:bold;
    }
    
    #head-title{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 13px;        
        color: #000;
        text-align: center;
        font-weight:bold;
    }
    
    #title-colom-left{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;        
        color: #000;
        text-align: center;
        font-weight:bold;
        border-left:#000 1px solid;
        border-top:#000 1px solid;
    }
    
    #title-colom-right{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
        font-size: 12px;        
        color: #000;
        text-align: center;
        font-weight:bold;
        border-top:#000 1px solid;
        border-right:#000 1px solid;
        border-left:#000 1px solid;
    }
    
    #data-left{
        border-left:#000 1px solid;
        border-top:#000 1px solid;
        padding-left:5px;
    }
    
    #data-right{
        border-top:#000 1px solid;
        border-left:#000 1px solid;
        border-right:#000 1px solid;
        padding-left:5px;
    }
    
    #data-left-last{
        border-left:#000 1px solid;
        border-top:#000 1px solid;
        border-bottom:#000 1px solid;
        padding-left:5px;
    }
    
    #data-right-last{
        border-top:#000 1px solid;
        border-left:#000 1px solid;
        border-right:#000 1px solid;
        border-bottom:#000 1px solid;
        padding-left:5px;
    }
    
    #data-left-total{
        border-left:#000 1px solid;
        border-top:#000 3px solid;
        padding-left:4px;
    }
    </style>


<%!
    public String getFormated(double amount, boolean isBold) {

        if (isBold) {
            return "";
        } else {
            if (amount >= 0) {
                return JSPFormater.formatNumber(amount, "#,###.##");
            } else {
                return "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
            }
        }
    }
%>

<%

            long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");
            long periodId = JSPRequestValue.requestLong(request, "periode_id");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");

            int type = JSPRequestValue.requestInt(request, "type");
            String where = JSPRequestValue.requestString(request, "where");
            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

            Company company = DbCompany.getCompany();

            Periode period = DbPeriode.getOpenPeriod();

            if (periodId != 0) {
                try {
                    period = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }
            }

            Date reportDate = new Date();
            Date endPeriod = period.getEndDate();
            if (reportDate.after(endPeriod)) {
                reportDate = endPeriod;
            }

            if (period.getType() == DbPeriode.TYPE_PERIOD13) {
                reportDate = period.getStartDate();
            }

            Date dtx = (Date) reportDate.clone();
            dtx.setYear(dtx.getYear() - 1);

            Date dt = period.getStartDate();
            Date startDate = (Date) dt.clone();
            startDate.setYear(startDate.getYear() - 1);
            startDate.setDate(startDate.getDate() + 10);

            String[] langFR = {"Show List", "Account With Transaction", "All", "BALANCE SHEET", "PERIOD", //0-4
                "Description", "Total"}; //5-6
            String[] langNav = {"Financial Report", "Balance Sheet"};

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "NERACA", "PERIODE", //0-4
                    "Keterangan", "Total"}; //5-6
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Naraca"};
                langNav = navID;
            }

%>

<table width="100%" border="0" cellpadding="1" cellspacing="0">
    <tr>
        <td colspan="6" class id = "head-company"><%=company.getName().toUpperCase()%></td>
    </tr> 
    <tr>
        <td colspan="6" class id = "head-title">NERACA SALDO</td>
    </tr> 
    <tr>
        <td colspan="6" class id = "head-title">PER <%=JSPFormater.formatDate(dtx, "dd MMMM yyyy")%> DAN <%=JSPFormater.formatDate(reportDate, "dd MMMM yyyy")%></td>
    </tr> 
    <tr>
        <td height="30px" colspan="6">&nbsp;</td>
    </tr>
    <%if (type == 1) {%>
    <tr>
        <td width="4%" class id = "title-colom-left">NO</td>
        <td width="36%" class id = "title-colom-left">URAIAN</td>
        <td width="15%" class id = "title-colom-left">SALDO AWAL</td>
        <td width="15%" class id = "title-colom-right">DEBET</td>
        <td width="15%" class id = "title-colom-right">CREDIT</td>
        <td width="15%" class id = "title-colom-right">SALDO</td>
    </tr>    
    <tr>
        <td class id = "data-left">&nbsp;</td>
        <td class id = "data-left"><B>AKTIVA</B></td>
        <td class id = "data-left">&nbsp;</td>
        <td class id = "data-left">&nbsp;</td>
        <td class id = "data-left">&nbsp;</td>
        <td class id = "data-right">&nbsp;</td>
    </tr>    
    <%
    double totalSaldoAwal = 0;
    double totalDebet = 0;
    double totalCredit = 0;
    double totalSaldo = 0;

    int seq = 0;

    for (int x = 0; x < I_Project.accGroup.length; x++) {

        Vector tempCoas = new Vector();

        if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LIQUID_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_FIXED_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)) {

            String whereClause = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'";

            if (where.length() > 0) {
                whereClause = whereClause + " AND ( " + where + " )";
            }

            tempCoas = DbCoa.list(0, 0, whereClause, DbCoa.colNames[DbCoa.COL_CODE]);
        }

        if (tempCoas != null && tempCoas.size() > 0) {

            for (int i = 0; i < tempCoas.size(); i++) {

                Coa coa = (Coa) tempCoas.get(i);

                boolean isBold = (coa.getStatus().equals("HEADER")) ? true : false;

                String level = "";
                if (coa.getLevel() == 1) {
                } else if (coa.getLevel() == 2) {
                    level = "<img src=\"../images/spacer.gif\" width=\"20\" height=\"1\">";
                } else if (coa.getLevel() == 3) {
                    level = "<img src=\"../images/spacer.gif\" width=\"40\" height=\"1\">";
                } else if (coa.getLevel() == 4) {
                    level = "<img src=\"../images/spacer.gif\" width=\"60\" height=\"1\">";
                } else if (coa.getLevel() == 5) {
                    level = "<img src=\"../images/spacer.gif\" width=\"80\" height=\"1\">";
                }

                double saldoAwal = 0;
                double debet = 0;
                double credit = 0;
                double saldo = 0;

                saldoAwal = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                debet = SessNeracaSaldo.getDebet(coa.getOID(), period.getOID());
                credit = SessNeracaSaldo.getCredit(coa.getOID(), period.getOID());
                saldo = saldoAwal + debet - credit;

                if (!isBold) {
                    totalSaldoAwal = totalSaldoAwal + saldoAwal;
                    totalDebet = totalDebet + debet;
                    totalCredit = totalCredit + credit;
                    totalSaldo = totalSaldo + saldo;
                }

                boolean isOpen = false;

                if (previewType == 0) {
                    isOpen = true;
                }

                if (isOpen) {

                    seq = seq + 1;

    %>
    <tr> 
        <td class id = "data-left"  align="center"><%=seq%></td>
        <td class id = "data-left"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
        <td class id = "data-left"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(saldoAwal, false)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
        <td class id = "data-right"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(debet, false)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
        <td class id = "data-right"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(credit, false)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
        <td class id = "data-right"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(saldo, false)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
    </tr>
    <%}
            }
        }
    }%>
    <tr> 
        <td height="22" class id = "data-left-last">&nbsp;</td>
        <td height="22" class id = "data-left-last"><b>TOTAL AKTIVA</b></td>
        <td height="22" class id = "data-left-last"> 
            <div align="right"><b><%=getFormated(totalSaldoAwal, false)%></b></div>
        </td>
        <td height="22" class id = "data-left-last"> 
            <div align="right"><b><%=getFormated(totalDebet, false)%></b></div>
        </td>
        <td height="22" class id = "data-left-last"> 
            <div align="right"><b><%=getFormated(totalCredit, false)%></b></div>
        </td>
        <td height="22" class id = "data-right-last"> 
            <div align="right"><b><%=getFormated(totalSaldo, false)%></b></div>
        </td>
    </tr>
    <%} else if (type == 2) {%>
    <tr>
        <td width="4%" class id = "title-colom-left">NO</td>
        <td width="36%" class id = "title-colom-left">URAIAN</td>
        <td width="15%" class id = "title-colom-left">SALDO AWAL</td>
        <td width="15%" class id = "title-colom-right">DEBET</td>
        <td width="15%" class id = "title-colom-right">CREDIT</td>
        <td width="15%" class id = "title-colom-right">SALDO</td>
    </tr>  
    <tr> 
        <td height="22" class id = "data-left">&nbsp;</td>
        <td height="22" class id = "data-left"><b>PASIVA</b></td>
        <td height="22" class id = "data-left">&nbsp;</td>
        <td height="22" class id = "data-right">&nbsp;</td>
        <td height="22" class id = "data-right">&nbsp;</td>
        <td height="22" class id = "data-right">&nbsp;</td>
    </tr>
    <%

    double totalSaldoAwal = 0;
    double totalDebet = 0;
    double totalCredit = 0;
    double totalSaldo = 0;

    int seq = 0;

    for (int x = 0; x < I_Project.accGroup.length; x++) {

        Vector tempCoas = new Vector();

        if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EQUITY)) {

            String whereClause = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'";

            if (where.length() > 0) {
                whereClause = whereClause + " AND ( " + where + " )";
            }

            tempCoas = DbCoa.list(0, 0, whereClause, DbCoa.colNames[DbCoa.COL_CODE]);
        }

        if (tempCoas != null && tempCoas.size() > 0) {

            for (int i = 0; i < tempCoas.size(); i++) {

                Coa coa = (Coa) tempCoas.get(i);

                boolean isBold = (coa.getStatus().equals("HEADER")) ? true : false;

                String level = "";
                if (coa.getLevel() == 1) {
                //level = "<img src=\"../images/spacer.gif\" width=\"25\" height=\"1\">";
                } else if (coa.getLevel() == 2) {
                    //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    level = "<img src=\"../images/spacer.gif\" width=\"20\" height=\"1\">";
                } else if (coa.getLevel() == 3) {
                    //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    level = "<img src=\"../images/spacer.gif\" width=\"40\" height=\"1\">";
                } else if (coa.getLevel() == 4) {
                    //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    level = "<img src=\"../images/spacer.gif\" width=\"60\" height=\"1\">";
                } else if (coa.getLevel() == 5) {
                    //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    level = "<img src=\"../images/spacer.gif\" width=\"80\" height=\"1\">";
                }

                double saldoAwal = 0;
                double debet = 0;
                double credit = 0;
                double saldo = 0;

                if (coaLabaBerjalan.getCode().equals(coa.getCode())) {                                                                                                
                    saldoAwal = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                    credit = DbGlDetail.getTotalIncomeInPeriod(period.getOID());                                                                                                
                    debet = DbGlDetail.getTotalExpenseInPeriod(period.getOID());
                    saldo = saldoAwal + credit - debet;
                }else{
                    saldoAwal = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                    debet = SessNeracaSaldo.getDebet(coa.getOID(), period.getOID());
                    credit = SessNeracaSaldo.getCredit(coa.getOID(), period.getOID());
                    saldo = saldoAwal + credit - debet;
                }

                if (!isBold) {
                    totalSaldoAwal = totalSaldoAwal + saldoAwal;
                    totalDebet = totalDebet + debet;
                    totalCredit = totalCredit + credit;
                    totalSaldo = totalSaldo + saldo;
                }

                boolean isOpen = false;

                if (previewType == 0) {
                    isOpen = true;
                }

                if (isOpen) {

                    seq = seq + 1;

    %>
    <tr> 
        <td class id = "data-left"><%=seq%></td>
        <td class id = "data-left"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
        <td class id = "data-left"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(saldoAwal, false)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
        <td class id = "data-right"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(debet, false)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
        <td class id = "data-right"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(credit, false)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
        <td class id = "data-right"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(saldo, false)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
    </tr>
    <%}
            }
        }
    }
    %>
    <tr> 
        <td height="22" class id = "data-left-last">&nbsp;</td>
        <td height="22" class id = "data-left-last"><b>TOTAL PASIVA</b></td>
        <td height="22" class id = "data-left-last"> 
            <div align="right"><b><%=getFormated(totalSaldoAwal, false)%></b>
        </td>
        <td height="22" class id = "data-right-last"> 
            <div align="right"><b><%=getFormated(totalDebet, false)%></b></div>
        </td>
        <td height="22" class id = "data-right-last"> 
            <div align="right"><b><%=getFormated(totalCredit, false)%></b></div>
        </td>
        <td height="22" class id = "data-right-last"> 
            <div align="right"><b><%=getFormated(totalSaldo, false)%></b></div>
        </td>
    </tr>
    <%}%>
    <tr> 
        <td >&nbsp;</td>
        <td >&nbsp;</td>
        <td >&nbsp;</td>
        <td >&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="4" align="center">            
            <%
            out.print("<a href=\"../freport/neracasaldo_print.jsp?where='" + where + "'&type=" + type + "&periode_id=" + periodId + "\" target='_blank'><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
            %>
        </td>
    </tr>   
    <tr> 
        <td >&nbsp;</td>
        <td >&nbsp;</td>
        <td >&nbsp;</td>
        <td >&nbsp;</td>
    </tr>
</table> 