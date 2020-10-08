
<%-- 
    Document   : print_neraca_rpt_priview
    Created on : Aug 19, 2011, 3:55:25 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.crm.session.*" %>
<%@ page import = "com.project.crm.master.*" %>
<%@ page import = "com.project.crm.report.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>

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
    public String getFormated(double amount, boolean isBold,String CURRFORMAT) {
        
        if (amount >= 0) {
            return (isBold) ? "<b>" + JSPFormater.formatNumber(amount, CURRFORMAT) + "</b>" : JSPFormater.formatNumber(amount, CURRFORMAT);
        } else {
            return (isBold) ? "<b>(" + JSPFormater.formatNumber(amount * -1, CURRFORMAT) + ")</b>" : "(" + JSPFormater.formatNumber(amount * -1, CURRFORMAT) + ")";
        }
    }
%>
<%
            long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            String whereMd = JSPRequestValue.requestString(request, "whereMd");
            boolean isGereja = DbSystemProperty.getModSysPropGereja();
            RptFormat rptFormat = new RptFormat();
            String title = "";

            try {
                rptFormat = DbRptFormat.fetchExc(oidRptFormat);
                title = rptFormat.getReportTitle();
            } catch (Exception e) {
            }

            Vector lstResult = new Vector();

            if (session.getValue("NERACA_RPT") != null) {
                lstResult = (Vector) session.getValue("NERACA_RPT");
            }

            Vector periods = (Vector) lstResult.get(0);
            Vector rptDetails = (Vector) lstResult.get(1);

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

//jika periode adalah peride 13 lawannya period 13 tahun lalu
            if (period.getType() == DbPeriode.TYPE_PERIOD13) {
                reportDate = period.getStartDate();
            }


            Date dtx = (Date) reportDate.clone();
            dtx.setYear(dtx.getYear() - 1);

            /*** LANG ***/
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
        <td colspan="7">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="7" class id = 'head-company'><%=company.getName().toUpperCase()%></td>
    </tr>
    <tr>
        <td colspan="7" class id = 'head-title'><%=title.toUpperCase()%></td>
    </tr>
    <tr>
        <td colspan="7" class id = 'head-title'>PER <%=(JSPFormater.formatDate(dtx, "dd MMM yyyy")).toUpperCase()%> DAN <%=(JSPFormater.formatDate(reportDate, "dd MMM yyyy")).toUpperCase()%></td>
    </tr>  
    <tr>
        <td colspan="7" height="30px">&nbsp;</td>
    </tr>
    <tr>
        <td width="4%"  rowspan="2" class id = 'title-colom-left'>NO</td>
        <td width="31%" rowspan="2" class id = 'title-colom-left'>URAIAN</td>
        <td width="15%" rowspan="2" class id = 'title-colom-left'>REALISASI<br>PER<br><%=JSPFormater.formatDate(dtx, "dd MMM yyyy")%></td>
        <td width="15%" rowspan="2" class id = 'title-colom-left'>ANGGARAN<br>PER<br><%=JSPFormater.formatDate(reportDate, "dd MMM yyyy")%></td>
        <td width="15%" rowspan="2" class id = 'title-colom-left'>REALISASI<br>PER<br><%=JSPFormater.formatDate(reportDate, "dd MMM yyyy")%></td>
        <td width="20%" colspan="2" class id = 'title-colom-right'>TERHADAP</td>    
    </tr>
    <tr>
        <td width="10%" class id = 'title-colom-left'><%=JSPFormater.formatDate(dtx, "yyyy")%></td>
        <td width="10%" class id = 'title-colom-right'>ANGG</td>
    </tr>
    <tr>
        <td class id = 'title-colom-left'>1</td>
        <td class id = 'title-colom-left'>2</td>
        <td class id = 'title-colom-left'>3</td>
        <td class id = 'title-colom-left'>4</td>
        <td class id = 'title-colom-left'>5</td>
        <td class id = 'title-colom-left'>5:3</td>
        <td class id = 'title-colom-right'>5:4</td>
    </tr>
    <%if (rptDetails != null && rptDetails.size() > 0) {

                int seq = 0;

                double totalAmountLY = 0;
                double totalBudgetTY = 0;
                double totalAmountTY = 0;
                
                int totData = rptDetails.size() - 1;

                for (int i = 0; i < rptDetails.size(); i++) {

                    boolean isBold = false;

                    seq = seq + 1;

                    RptFormatDetail rpd = (RptFormatDetail) rptDetails.get(i);

                    int count = DbRptFormatDetail.getCount(DbRptFormatDetail.colNames[DbRptFormatDetail.COL_REF_ID] + "=" + rpd.getOID());
                    int countCoas = DbRptFormatDetailCoa.getCount(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rpd.getOID());

                    String level = "";
                    if (rpd.getLevel() == 1) {
                        level = "<img src=\"../images/spacer.gif\" width=\"20\" height=\"1\">";
                    } else if (rpd.getLevel() == 2) {
                        //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        level = "<img src=\"../images/spacer.gif\" width=\"30\" height=\"1\">";
                    } else if (rpd.getLevel() == 3) {
                        //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        level = "<img src=\"../images/spacer.gif\" width=\"40\" height=\"1\">";
                    } else if (rpd.getLevel() == 4) {
                        //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        level = "<img src=\"../images/spacer.gif\" width=\"50\" height=\"1\">";
                    }

                    double amountLY = 0;
                    double budgetTY = 0;
                    double amountTY = 0;

             
                    if(isGereja){
                        amountLY = DbGlDetail.getRealisasiLastYear(rpd.getOID(), period,whereMd);
                        budgetTY = DbCoaBudget.getRealisasiCurrentYear(rpd.getOID(), period);
                        amountTY = DbGlDetail.getRealisasiCurrentYear(rpd.getOID(), period,whereMd);
                    }else{
                        amountLY = DbGlDetail.getRealisasiLastYear(rpd.getOID(), period);
                        budgetTY = 0;
                        amountTY = DbGlDetail.getRealisasiCurrentYear(rpd.getOID(), period);
                    }

                

                    if (rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) {
                        isBold = true;
                    }

                    if (rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) {

                        seq = seq - 1;
    %>                                                        
    
    <%}%>
    <tr> 
        <td <%=(i == totData) ?  "class id = 'data-left-last' " : "class id = 'data-left'"%> > 
            <%
                        if (rpd.getType() != DbRptFormatDetail.RPT_TYPE_TOTAL) {
            %>
            <div align="center"><%=seq%></div>
            <%}else{%>
               &nbsp;
            <%}%>
        </td>
        <td <%=(i == totData) ?  "class id = 'data-left-last' " : "class id = 'data-left'"%>><%=((rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) ? "<div align=\"center\"><b>" + rpd.getDescription() + "</b></div>" : (level + ((count > 0) ? "<b>" + rpd.getDescription() + "</b>" : rpd.getDescription())))%></td>
        <td <%=(i == totData) ?  "class id = 'data-left-last' " : "class id = 'data-left'"%>> 
            <div align="right"><%=(countCoas > 0) ? getFormated(amountLY, isBold,CURRFORMAT) : ""%></div>
        </td>
        <td <%=(i == totData) ?  "class id = 'data-left-last' " : "class id = 'data-left'"%>> 
            <div align="right"><%=(countCoas > 0) ? getFormated(budgetTY, isBold,CURRFORMAT) : ""%></div>
        </td>
        <td <%=(i == totData) ?  "class id = 'data-left-last' " : "class id = 'data-left'"%>> 
            <div align="right"><%=(countCoas > 0) ? getFormated(amountTY, isBold,CURRFORMAT) : ""%></div>
        </td>
        <td <%=(i == totData) ?  "class id = 'data-left-last' " : "class id = 'data-left'"%>> 
            <div align="center"><%=(countCoas > 0) ? getFormated((amountTY / amountLY) * 100, isBold,CURRFORMAT) : ""%></div>
        </td>
        <td <%=(i == totData) ?  "class id = 'data-right-last' " : "class id = 'data-right'"%>> 
            <div align="center"><%=(countCoas > 0) ? getFormated((amountTY / budgetTY) * 100, isBold,CURRFORMAT) : ""%></div>
        </td>
    </tr>
    
    <%
                        if (rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL){
                            
                            //reset total setelah ditampilkan                            
                            totalAmountLY = 0;
                            totalBudgetTY = 0;
                            totalAmountTY = 0;
                            
                            if(i != totData){

    %>
    <tr> 
        <td class id = 'data-left'>&nbsp;</td>
        <td class id = 'data-left'>&nbsp;</td>
        <td class id = 'data-left'>&nbsp;</td>
        <td class id = 'data-left'>&nbsp;</td>
        <td class id = 'data-left'>&nbsp;</td>
        <td class id = 'data-left'>&nbsp;</td>
        <td class id = 'data-right'>&nbsp;</td>
    </tr>
    <%
                            }
                    }
                }
    %>            
    <tr>
        <td>&nbsp;</td>
    </tr>    
    <tr> 
        <td colspan = "7" align="center">
             <%
                out.print("<a href=\"../freport/print_neraca_rpt.jsp?whereMd='"+whereMd+"'&rpt_format_id=" + oidRptFormat + "&period_id="+periodId+"\"  target='_blank'><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
             %>
        </td>
    </tr>       
            <%}%>

</table>