
<%-- 
    Document   : income_penjelasan_print_priview
    Created on : Aug 23, 2011, 9:38:48 AM
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
    
    public String getIndoDate(Date dt){
        
        String dateFrmt = "";
        
        if(dt.getMonth() == 0)
            dateFrmt = dateFrmt+dt.getDate()+" JANUARI";
        if(dt.getMonth() == 1)
            dateFrmt = dateFrmt+dt.getDate()+" FEBRUARI";
        if(dt.getMonth() == 2)
            dateFrmt = dateFrmt+dt.getDate()+" MARET";
        if(dt.getMonth() == 3)
            dateFrmt = dateFrmt+dt.getDate()+" APRIL";
        if(dt.getMonth() == 4)
            dateFrmt = dateFrmt+dt.getDate()+" MEI";
        if(dt.getMonth() == 5)
            dateFrmt = dateFrmt+dt.getDate()+" JUNI";
        if(dt.getMonth() == 6)
            dateFrmt = dateFrmt+dt.getDate()+" JULI";
        if(dt.getMonth() == 7)
            dateFrmt = dateFrmt+dt.getDate()+" AGUSTUS";
        if(dt.getMonth() == 8)
            dateFrmt = dateFrmt+dt.getDate()+" SEPTEMBER";
        if(dt.getMonth() == 9)
            dateFrmt = dateFrmt+dt.getDate()+" OKTOBER";
        if(dt.getMonth() == 10)
            dateFrmt = dateFrmt+dt.getDate()+" NOVEMBER";
        if(dt.getMonth() == 11)
            dateFrmt = dateFrmt+dt.getDate()+" DESEMBER";
        
        int yr = dt.getYear()+1900;
        
        dateFrmt = dateFrmt+" "+yr;
        
        return dateFrmt;
                
    }
    
%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");
            int reportRange = JSPRequestValue.requestInt(request, "report_range");
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");

            String title = "";
            
            try{
                title = DbSystemProperty.getValueByName("TITLE_REPORT_LABA_RUGI");
            }catch(Exception E){
                title = "";
            }

            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            Vector rptDetails = DbRptFormatDetail.list(0, 0, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + oidRptFormat, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

            Company company = DbCompany.getCompany();

            Periode period = DbPeriode.getOpenPeriod();

            if (periodId != 0) {
                try {
                    period = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
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
            Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            String indukLaba1 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_1");
            String indukLaba2 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_2");
            String indukLaba3 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_3");
            String indukLaba4 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_4");

            Date reportDate = new Date();
            Date endPeriod = period.getEndDate();
            if (reportDate.after(endPeriod)) {
                reportDate = endPeriod;
            }

            Date dtx = (Date) reportDate.clone();
            dtx.setYear(dtx.getYear() - 1);
         
%>
<table border="0" cellpadding="1" cellspacing="0">
    <tr>
        <td colspan="4">&nbsp;</td>
    </tr>     
    <tr>
        <td colspan="4" class id = "head-company"><%=company.getName().toUpperCase()%></td>
    </tr> 
    <tr>
        <td colspan="4" class id = "head-title"><%=title%></td>
    </tr> 
    <tr>
        <td colspan="4" class id = "head-title"><b>PERIODE <%=lastPeriod.getName().toUpperCase()%> DAN <%=period.getName().toUpperCase()%></b></td>
    </tr> 
    <tr>
        <td height="30px">&nbsp;</td>
    </tr>    
    <tr>
        <td class id = "title-colom-left">NO</td>
        <td class id = "title-colom-left">URAIAN</td>
        <td class id = "title-colom-left">REALISASI<br>PER<br><%=getIndoDate(dtx)%></td>
        <td class id = "title-colom-right">REALISASI<br>PER<br><%=getIndoDate(reportDate)%></td>
    </tr> 
    <tr>
        <td class id = "data-left">&nbsp;</td>
        <td class id = "data-left"><B>PENDAPATAN</B></td>
        <td class id = "data-left">&nbsp;</td>
        <td class id = "data-right">&nbsp;</td>
    </tr> 
    <%

            double totalAmountLY = 0;
            double totalBudgetTY = 0;
            double totalAmountTY = 0;
            int seq = 0;

            for (int x = 0; x < I_Project.accGroup.length; x++) {

                Vector tempCoas = new Vector();

                if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_REVENUE) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_REVENUE) //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EQUITY)
                        ) {
                    tempCoas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
                }

                System.out.println("LANG_ID : " + LANG_ID);
                System.out.println("x : " + x);

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

                        double amountLY = 0;
                        double budgetTY = 0;
                        double amountTY = 0;

                        amountLY = DbCoaOpeningBalance.getOpeningBalance(lastPeriod, coa.getOID());
                        amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getOID());

                        //this year
                        amountTY = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                        amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getOID());

                        //total
                        if (!isBold) {
                            totalAmountLY = totalAmountLY + amountLY;
                            totalBudgetTY = totalBudgetTY + budgetTY;
                            totalAmountTY = totalAmountTY + amountTY;
                        }

                        boolean isOpen = false;
                        if (previewType == 0) {
                            isOpen = true;
                        } else if (amountLY != 0 || amountTY != 0) {
                            isOpen = true;
                        }

                        if(isOpen){

                            seq = seq + 1;

    %>
    <tr> 
        <td width="2%" align="center" class id = "data-left"><%=seq%></td>
        <td width="33%" class id = "data-left"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
        <td width="15%" class id = "data-left"><div align="right"><%=getFormated(amountLY, isBold)%></div></td>
        <td width="17%" class id = "data-right"><div align="right"><%=getFormated(amountTY, isBold)%></div></td>
    </tr>
    <%}
                    }
                }
            }%>
    <tr> 
        <td width="2%" height="22" class id = "data-left-last">&nbsp;</td>
        <td width="33%" height="22" class id = "data-left-last"><b>TOTAL PENDAPATAN</b></td>
        <td width="15%" height="22" class id = "data-left-last"><div align="right"><b><%=getFormated(totalAmountLY, false)%></b></div></td>
        <td width="17%" height="22" class id = "data-right-last"><div align="right"><b><%=getFormated(totalAmountTY, false)%></b></div>
        </td>
    </tr>
    <tr> 
        <td width="2%" height="22">&nbsp;</td>
        <td width="33%" height="22">&nbsp;</td>
        <td width="15%" height="22">&nbsp;</td>
        <td width="17%" height="22">&nbsp;</td>
    </tr>
    <tr> 
        <td width="2%" height="22" class id = "data-left">&nbsp;</td>
        <td width="33%" height="22" class id = "data-left"><b>BIAYA</b></td>
        <td width="15%" height="22" class id = "data-left">&nbsp;</td>
        <td width="17%" height="22" class id = "data-right">&nbsp;</td>
    </tr>
    <%

            double totalAmountLYEx = 0;
            //totalBudgetTY = 0;
            double totalAmountTYEx = 0;
            seq = 0;

            for (int x = 0; x < I_Project.accGroup.length; x++) {

                Vector tempCoas = new Vector();

                if (//I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LIQUID_ASSET)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_FIXED_ASSET)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)
                        I_Project.accGroup[x].equals(I_Project.ACC_GROUP_COST_OF_SALES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EXPENSE) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                    tempCoas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
                }

                System.out.println("LANG_ID : " + LANG_ID);
                System.out.println("x : " + x);

                if (tempCoas != null && tempCoas.size() > 0) {

                    for (int i = 0; i < tempCoas.size(); i++) {

                        Coa coa = (Coa) tempCoas.get(i);

                        boolean isBold = (coa.getStatus().equals("HEADER")) ? true : false;

                        //int count = DbRptFormatDetail.getCount(DbRptFormatDetail.colNames[DbRptFormatDetail.COL_REF_ID]+"="+rpd.getOID());
                        //int countCoas = DbRptFormatDetailCoa.getCount(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID]+"="+rpd.getOID());

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

                        double amountLY = 0;
                        double budgetTY = 0;
                        double amountTY = 0;

                        //jika laba tahun berjalan, hitungnya beda
                        if (coaLabaBerjalan.getCode().equals(coa.getCode())) {
                            amountLY = DbCoaOpeningBalance.getOpeningBalance(lastPeriod, coa.getOID());
                            amountLY = amountTY + DbGlDetail.getTotalIncomeInPeriod(lastPeriod.getOID()) - DbGlDetail.getTotalExpenseInPeriod(lastPeriod.getOID());
                            //amountLY = DbGlDetail.getRealisasiLastYear(coa.getOID(), period);	

                            //this year
                            //amountTY = DbGlDetail.getRealisasiCurrentYear(coa.getOID(), period);	
                            amountTY = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                            amountTY = amountTY + DbGlDetail.getTotalIncomeInPeriod(period.getOID()) - DbGlDetail.getTotalExpenseInPeriod(period.getOID());
                        //}
                        } else {
                            amountLY = DbCoaOpeningBalance.getOpeningBalance(lastPeriod, coa.getOID());
                            amountLY = amountTY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getOID());
                            //amountLY = DbGlDetail.getRealisasiLastYear(coa.getOID(), period);	

                            //this year
                            //amountTY = DbGlDetail.getRealisasiCurrentYear(coa.getOID(), period);	
                            amountTY = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                            amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getOID());
                        //}	
                        }

                        if (!isBold) {
                            totalAmountLYEx = totalAmountLYEx + amountLY;
                            // totalBudgetTY = totalBudgetTY + budgetTY;
                            totalAmountTYEx = totalAmountTYEx + amountTY;
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
        <td width="2%" class id = "data-left" align="center"><%=seq%></td>
        <td width="33%" class id = "data-left"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
        <td width="15%" class id = "data-left"><div align="right"><%=getFormated(amountLY, isBold)%></div></td>
        <td width="17%" class id = "data-right"><div align="right"><%=getFormated(amountTY, isBold)%></div></td>
    </tr>
    <%}
                    }
                }
            }%>
    <tr> 
        <td width="2%" height="22" class id = "data-left">&nbsp;</td>
        <td width="33%" height="22" class id = "data-left"><b>TOTAL BIAYA</b></td>
        <td width="15%" height="22" class id = "data-left"><div align="right"><b><%=getFormated(totalAmountLYEx, false)%></b></div></td>
        <td width="17%" height="22" class id = "data-right"><div align="right"><b><%=getFormated(totalAmountTYEx, false)%></b></div></td>
    </tr>
    <tr> 
        <td width="2%" class id = "data-left-last">&nbsp;</td>
        <td width="33%" class id = "data-left-last"><b>LABA</b></td>
        <td width="15%" class id = "data-left-last"><div align="right"><b><%=getFormated(totalAmountLY - totalAmountLYEx, false)%></b></div></td>
        <td width="17%" class id = "data-right-last"><div align="right"><b><%=getFormated(totalAmountTY - totalAmountTYEx, false)%></b></div></td>
    </tr>
    <tr>
        <td colspan=4>&nbsp;</td>
    </tr>
    <tr>
        <td colspan=4 align="center">
            <%
    out.print("<a href=\"../freport/income_penjelasan_print.jsp?rpt_format_id=" + oidRptFormat + "&period_id="+periodId+"&preview_type="+previewType+"\" target='_blank'><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
            %>
        </td>
    </tr>
</table>    