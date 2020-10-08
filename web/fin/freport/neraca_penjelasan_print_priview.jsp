
<%-- 
    Document   : neraca_penjelasan_print_priview
    Created on : Aug 22, 2011, 10:58:40 AM
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
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");
            String whereMd = JSPRequestValue.requestString(request, "whereMd");

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

//last year
            Date dt = period.getStartDate();
            Date startDate = (Date) dt.clone();
            startDate.setYear(startDate.getYear() - 1);
            startDate.setDate(startDate.getDate() + 10);

            Periode lastPeriod = DbPeriode.getPeriodByTransDate(startDate);

//if periode 13 then get prev period 13
            if (period.getType() == DbPeriode.TYPE_PERIOD13) {
                System.out.println("----- periode 13 : yes");
                lastPeriod = DbPeriode.getLastYearPeriod13(period);
            }

            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

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
        <td colspan="4" class id = "head-company"><%=company.getName().toUpperCase()%></td>
    </tr> 
    <tr>
        <td colspan="4" class id = "head-title">PENJELASAN NERACA</td>
    </tr> 
    <tr>
        <td colspan="4" class id = "head-title">PER <%=JSPFormater.formatDate(dtx, "dd MMMM yyyy")%> DAN <%=JSPFormater.formatDate(reportDate, "dd MMMM yyyy")%></td>
    </tr> 
    <tr>
        <td height="30px" colspan="4">&nbsp;</td>
    </tr>
    <tr>
        <td width="5%" class id = "title-colom-left">NO</td>
        <td width="45%" class id = "title-colom-left">URAIAN</td>
        <td width="25%" class id = "title-colom-left">REALISASI<br>PER<br><%=JSPFormater.formatDate(dtx, "dd MMMM yyyy")%></td>
        <td width="25%" class id = "title-colom-right">REALISASI<br>PER<br><%=JSPFormater.formatDate(reportDate, "dd MMMM yyyy")%></td>
    </tr>    
    <tr>
        <td class id = "data-left">&nbsp;</td>
        <td class id = "data-left"><B>AKTIVA</B></td>
        <td class id = "data-left">&nbsp;</td>
        <td class id = "data-right">&nbsp;</td>
    </tr>    
    <%
                double totalAmountLY = 0; double totalAmountTY = 0; int seq = 0;                
                for (int x = 0; x < I_Project.accGroup.length; x++){

                    Vector tempCoas = new Vector();
                    if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LIQUID_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_FIXED_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)) {
                        tempCoas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
                    }

                    if (tempCoas != null && tempCoas.size() > 0) {
                        for (int i = 0; i < tempCoas.size(); i++){

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

                            double amountLY = 0; double amountTY = 0;
                            
                            if (lastPeriod.getOID() != 0){                            
                                amountLY = DbGlDetail.getOpeningBalancePrevious(lastPeriod, coa.getOID(), whereMd);
                                amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getOID(), whereMd);
                            }
                            
                            //this year                        
                            amountTY = DbGlDetail.getOpeningBalancePrevious(period, coa.getOID(), whereMd);
                            amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getOID(), whereMd);

                            //total
                            if (!isBold) {
                                totalAmountLY = totalAmountLY + amountLY;
                                totalAmountTY = totalAmountTY + amountTY;
                            }

                            boolean isOpen = false;
                            if (previewType == 0) {
                                isOpen = true;
                            } else if (amountLY != 0 || amountTY != 0) {
                                isOpen = true;
                            }

                            if (isOpen){
                                seq = seq + 1;
    %>
    <tr> 
        <td class id = "data-left"  align="center"><%=seq%></td>
        <td class id = "data-left"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
        <td class id = "data-left"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(amountLY, isBold)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
        <td class id = "data-right"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(amountTY, isBold)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
    </tr>
    <%}
                        }
                    }
                }%>
    <tr> 
        <td height="22" class id = "data-left">&nbsp;</td>
        <td height="22" class id = "data-left"><b>TOTAL AKTIVA</b></td>
        <td height="22" class id = "data-left"> 
            <div align="right"><b><%=getFormated(totalAmountLY, false)%></b></div>
        </td>
        <td height="22" class id = "data-right"> 
            <div align="right"><b><%=getFormated(totalAmountTY, false)%></b></div>
        </td>
    </tr>
    <tr> 
        <td height="22" class id = "data-left">&nbsp;</td>
        <td height="22" class id = "data-left"><b>PASIVA</b></td>
        <td height="22" class id = "data-left">&nbsp;</td>
        <td height="22" class id = "data-right">&nbsp;</td>
    </tr>
    <%

                totalAmountLY = 0;
                totalAmountTY = 0;
                seq = 0;

                for (int x = 0; x < I_Project.accGroup.length; x++) {

                    Vector tempCoas = new Vector();

                    if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EQUITY)) {
                        tempCoas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
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

                            double amountLY = 0; double amountTY = 0;

                            String indukLaba1 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_1");
                            String indukLaba2 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_2");
                            String indukLaba3 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_3");
                            String indukLaba4 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_4");

                            //jika laba tahun berjalan, hitungnya beda
                            if (coaLabaBerjalan.getCode().equals(coa.getCode())) {
                                
                                amountLY = DbGlDetail.getOpeningBalancePrevious(lastPeriod, coa.getOID(),whereMd);
                                amountLY = amountLY + DbGlDetail.getTotalIncomeInPeriod(lastPeriod.getOID(),whereMd) - DbGlDetail.getTotalExpenseInPeriod(lastPeriod.getOID(),whereMd);
                                
                                amountTY = DbGlDetail.getOpeningBalancePrevious(period, coa.getOID(),whereMd);
                                amountTY = amountTY + DbGlDetail.getTotalIncomeInPeriod(period.getOID(),whereMd) - DbGlDetail.getTotalExpenseInPeriod(period.getOID(),whereMd);
                            
                            } else {
                                
                                amountLY = DbGlDetail.getOpeningBalancePrevious(lastPeriod, coa.getOID(),whereMd);
                                amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getOID(),whereMd);
                                
                                amountTY = DbGlDetail.getOpeningBalancePrevious(period, coa.getOID(),whereMd);
                                amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getOID(),whereMd);
                            
                            }

                            if (!isBold) {
                                totalAmountLY = totalAmountLY + amountLY;                                
                                totalAmountTY = totalAmountTY + amountTY;
                            }

                            boolean isOpen = false;
                            if (previewType == 0) {
                                isOpen = true;
                            } else {
                                if (amountLY != 0 || amountTY != 0) {
                                    isOpen = true;
                                } else {
                                    if (coa.getCode().equals(indukLaba1) || coa.getCode().equals(indukLaba2) || coa.getCode().equals(indukLaba3) || coa.getCode().equals(indukLaba4)) {
                                        isOpen = true;
                                    }
                                }
                            }

                            if (isOpen) {
                                seq = seq + 1;
    %>
    <tr> 
        <td class id = "data-left"><%=seq%></td>
        <td class id = "data-left"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
        <td class id = "data-left"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(amountLY, isBold)%></div><%=((isBold) ? "</B>" : "")%>
        </td>
        <td class id = "data-right"> 
            <%=((isBold) ? "<B>" : "")%><div align="right"><%=getFormated(amountTY, isBold)%></div><%=((isBold) ? "</B>" : "")%>
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
            <div align="right"><b><%=getFormated(totalAmountLY, false)%></b>
        </td>
        <td height="22" class id = "data-right-last"> 
            <div align="right"><b><%=getFormated(totalAmountTY, false)%></b></div>
        </td>
    </tr>
    <tr> 
        <td >&nbsp;</td>
        <td >&nbsp;</td>
        <td >&nbsp;</td>
        <td >&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="4" align="center">            
            <%
    out.print("<a href=\"../freport/neraca_penjelasan_print.jsp?rpt_format_id=" + oidRptFormat + "&period_id="+periodId+"&preview_type="+previewType+"&whereMd=" + whereMd +"\" target='_blank'><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
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
   