
<%-- 
    Document   : kasopprint
    Created on : Jan 2, 2012, 10:05:59 PM
    Author     : roy andika
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
<%@ page import = "com.project.crm.report.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<html>
    <head>
        <style>
            #title{
                line-height:18px; 
                color: #9A958F;
            }
            
            #title-second{
                font-family:'Courier New', Courier, monospace;
                font-size: 12px;
                line-height:18px; 
                color: #9A958F;
            }
            
            #detail{     
                line-height:18px; 
                color: #9A958F;
            }
            
            #detail2{
                font-family:'Courier New', Courier, monospace;
                font-size: 12px;
                line-height:18px; 
                color: #9A958F;
            }    
        </style>
    </head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Cetak Data</title>
    <script language="Javascript1.2">        
        function printpage(){
            window.print();
        }
    </script>
    <body onload='printpage()'>        
        <%

            String[] langCT = {"Date"};

            String[] langNav = {"TOTAL CASH REGISTER", "KAS OPNAME", "Date", "Check / Bilyet Giro", "Total Check", "Total", "Total", "Diferent"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal"};
                langCT = langID;
                String[] navID = {"TOTAL KAS REGISTER", "KAS OPNAME", "Tanggal", "Check / Bilyet Giro", "Total Check/uang muka", "Saldo Uang dalam kas", "Saldo menurut buku", "Perbedaan"};
                langNav = navID;
            }

            Date dtKas = JSPFormater.formatDate(JSPRequestValue.requestString(request, "DATE_KAS"), "yyyy-MM-dd");
            double tot = JSPRequestValue.requestDouble(request, "tot");

            long oidCurRp = 0;
            long oidCurDollar = 0;

            String currRp = "";
            String currDollar = "";

            try {
                oidCurRp = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                Currency currx = new Currency();
                try {
                    currx = DbCurrency.fetchExc(oidCurRp);
                    currRp = currx.getCurrencyCode();
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                oidCurDollar = Long.parseLong(DbSystemProperty.getValueByName("OID_CURR_DOLLAR"));
                Currency currx = new Currency();
                try {
                    currx = DbCurrency.fetchExc(oidCurDollar);
                    currDollar = currx.getCurrencyCode();
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            String whereClauseRp = DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID] + " = " + oidCurRp + " AND " + DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_NON_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtKas, "yyyy-MM-dd") + "'";
            String whereClauseDollar = DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID] + " = " + oidCurDollar + " AND " + DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_NON_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtKas, "yyyy-MM-dd") + "'";
            String whereClauseCheck = DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtKas, "yyyy-MM-dd") + "'";
            String orderClause = DbKasOpname.colNames[DbKasOpname.COL_AMOUNT] + " DESC ";
            Vector listKasOpnameRupiah = DbKasOpname.list(0, 0, whereClauseRp, orderClause);
            Vector listKasOpnameDollar = DbKasOpname.list(0, 0, whereClauseDollar, orderClause);
            Vector listKasOpnameCheck = DbKasOpname.list(0, 0, whereClauseCheck, orderClause);

            PrintDesign printDesign = new PrintDesign();

            try {
                printDesign = DbPrintDesign.getDesign(DbPrintDesign.colNamesDocument[DbPrintDesign.DOCUMENT_KAS_OPNAME]);
            } catch (Exception e) {
                System.out.println("exception " + e.toString());
            }

        %>
        <table align="center" cellpadding="1" cellspacing="0"  width="<%=printDesign.getWidthPrint()%>" border="0"  >
            <tr>
                <td colspan="11" align="center" class id = 'title'><font size="<%=printDesign.getSizeFontHeader()%>px" face="<%=printDesign.getFontHeader()%>">KAS OPNAME</font></td>
            </tr>
            <tr>
                <td colspan="11" align="center" class id = 'title'><font size="<%=printDesign.getSizeFontHeader()%>px" face="<%=printDesign.getFontHeader()%>"><%=langCT[0]%>&nbsp;:&nbsp;<%=JSPFormater.formatDate(dtKas, "dd MMMM yyyy")%></font></td>
            </tr>
            <tr>
                <td colspan="11" align="center">&nbsp;</td>
            </tr>
            <%
            double jumRp = 0;
            if (listKasOpnameRupiah != null && listKasOpnameRupiah.size() > 0) {

                for (int iRp = 0; iRp < listKasOpnameRupiah.size(); iRp++) {

                    KasOpname kop = (KasOpname) listKasOpnameRupiah.get(iRp);

                    Currency curr = new Currency();

                    try {
                        curr = DbCurrency.fetchExc(kop.getCurrencyId());
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                    double sum = 0;

                    try {
                        sum = kop.getAmount() * kop.getQty();
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                    jumRp = jumRp + sum;

            %>
            <tr>
                <td width="5" align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=iRp + 1%></font></td>
                <td width="5" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=DbKasOpname.satMoney[0]%></font></td>
                <td width="5" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=DbKasOpname.satCurrency[0]%></font></td>
                <td width="5" align="right" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(kop.getAmount(), "#,###")%></font></td>
                <td width="10" align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">sebanyak</font></td>
                <td width="10" align="right" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=kop.getQty()%></font></td>
                <td width="10" align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=DbKasOpname.satQty[0]%></font></td>
                <td width="10" align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=curr.getCurrencyCode()%></font></td>
                <td width="20" align="right" class id ='detail' style = "border-right : solid <%=printDesign.getBorderDataDetail()%>px;border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(sum, "#,###.##")%></font></td>
                <td width="10%"></td>
                <td width="10%"></td>
            </tr>
            <%
                }%>
            <tr>
                <td colspan="9" class id ='detail' style = "border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">&nbsp;</font></td>        
                <td class id ='detail'><%=currRp%></td>
                <td align="right" class id ='detail'><%=JSPFormater.formatNumber(jumRp, "#,###.##")%></td>
            </tr>      
            <tr>        
                <td colspan="11">&nbsp;</td>
            </tr>
            <%
            }
            %>
            <%
            double jumD = 0;
            if (listKasOpnameDollar != null && listKasOpnameDollar.size() > 0) {

                for (int iD = 0; iD < listKasOpnameDollar.size(); iD++) {

                    KasOpname kop = (KasOpname) listKasOpnameDollar.get(iD);

                    Currency curr = new Currency();

                    try {
                        curr = DbCurrency.fetchExc(kop.getCurrencyId());
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                    double sum = 0;

                    try {
                        sum = kop.getAmount() * kop.getQty();
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                    jumD = jumD + sum;

            %>
            <tr>
                <td align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=iD + 1%></font></td>
                <td class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=DbKasOpname.satMoney[1]%></font></td>
                <td class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=DbKasOpname.satCurrency[1]%></font></td>
                <td align="right" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(kop.getAmount(), "#,###")%></font></td>
                <td align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">sebanyak</font></td>
                <td align="right" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=kop.getQty()%></font></td>
                <td align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=DbKasOpname.satQty[1]%></font></td>
                <td align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=curr.getCurrencyCode()%></font></td>
                <td align="right" class id ='detail' style = "border-right : solid <%=printDesign.getBorderDataDetail()%>px;border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(sum, "#,###.##")%></font></td>
                <td></td>
                <td></td>
            </tr>
            <%
                }%>
            <tr>
                <td colspan="9" class id ='detail' style = "border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">&nbsp;</font></td>                
                <td class id ='detail'><%=currRp%></td>
                <td align="right" class id ='detail'><%=JSPFormater.formatNumber(jumD, "#,###.##")%></td>
            </tr>        
            <tr>        
                <td colspan="11">&nbsp;</td>
            </tr>
            <%
            }
            %>
            <%
            double jumCheck = 0;
            if (listKasOpnameCheck != null && listKasOpnameCheck.size() > 0) {
            %>       
            <tr>        
                <td colspan="11" class id ='detail'><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">Check/Bilyet</font></td>
            </tr>
            <%
                for (int iC = 0; iC < listKasOpnameCheck.size(); iC++) {

                    KasOpname kop = (KasOpname) listKasOpnameCheck.get(iC);

                    Currency curr = new Currency();

                    try {
                        curr = DbCurrency.fetchExc(kop.getCurrencyId());
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                    double sum = 0;

                    try {
                        sum = kop.getAmount() * kop.getQty();
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                    jumCheck = jumCheck + sum;

            %>
            <tr>
                <td align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=iC + 1%></font></td>
                <td colspan="6" align="left" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=kop.getMemo()%></font></td>        
                <td align="center" class id ='detail' style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=curr.getCurrencyCode()%></font></td>
                <td align="right" class id ='detail' style = "border-right : solid <%=printDesign.getBorderDataDetail()%>px;border-left : solid <%=printDesign.getBorderDataDetail()%>px;border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(sum, "#,###.##")%></font></td>
                <td></td>
                <td></td>
            </tr>
            <%
                }%>
            <tr>
                <td colspan="4" class id ='detail' style = "border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">&nbsp;</font></td>
                <td colspan="5" align="left" class id ='detail' style = "border-top : solid <%=printDesign.getBorderDataDetail()%>px;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=langNav[4]%></td>  
                <td class id ='detail'><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=currRp%></td>
                <td align="right" class id ='detail'><%=JSPFormater.formatNumber(jumCheck, "#,###.##")%></td>
            </tr>            
            <%
            }
            double totkop = jumRp + jumD + jumCheck;
            %>
            <tr>        
                <td colspan="11">&nbsp;</td>
            </tr>
            <tr>        
                <td colspan="4"></td>
                <td colspan="5" class id ='detail'><%=langNav[5]%></td>        
                <td class id ='detail'><%=currRp%></td>
                <td align="right" class id ='detail'><%=JSPFormater.formatNumber(totkop, "#,###.##")%></td>
            </tr>  
            <tr>        
                <td colspan="4"></td>
                <td colspan="5" class id ='detail'><%=langNav[6]%></td>        
                <td class id ='detail'><%=currRp%></td>
                <td align="right" class id ='detail'><%=JSPFormater.formatNumber(tot, "#,###.##")%></td>
            </tr> 
            <%
            double perbedaan = totkop - tot;
            %>
            <tr>        
                <td colspan="4"></td>
                <td colspan="5" class id ='detail'><%=langNav[7]%></td>        
                <td class id ='detail'><%=currRp%></td>
                <td align="right" class id ='detail'><%=JSPFormater.formatNumber(perbedaan, "#,###.##")%></td>
            </tr>
            <tr>        
                <td colspan="11">&nbsp;</td>
            </tr>
            <%
            String nama_1 = "";
            String nama_2 = "";

            String ket_1 = "&nbsp;";
            String ket_2 = "&nbsp;";

            String ketFoot_1 = "&nbsp;";
            String ketFoot_2 = "&nbsp;";

            try {
                Approval approval_1 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_KAS_OPNAME, DbApproval.URUTAN_1);
                Employee employee = DbEmployee.fetchExc(approval_1.getEmployeeId());
                nama_1 = employee.getName();
                ket_1 = approval_1.getKeterangan();
                ketFoot_1 = approval_1.getKeteranganFooter();
            } catch (Exception E) {
                System.out.println("[exception] " + E.toString());
            }

            try {
                Approval approval_2 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_KAS_OPNAME, DbApproval.URUTAN_2);
                Employee employee = DbEmployee.fetchExc(approval_2.getEmployeeId());
                nama_2 = employee.getName();
                ket_2 = approval_2.getKeterangan();
                ketFoot_2 = approval_2.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }
            %>
            <tr>        
                <td colspan="11" height="25">&nbsp;</td>
            </tr>    
            <tr>        
                <td colspan="11">
                    <table width="100%">
                        <tr>
                            <td width="50%" align="center" class id ='detail'><font size="<%=printDesign.getSizeFontDataFooter()%>px" face="<%=printDesign.getFontDataFooter()%>"><%=ket_1%></font></td>
                            <td width="50%" align="center" class id ='detail'><font size="<%=printDesign.getSizeFontDataFooter()%>px" face="<%=printDesign.getFontDataFooter()%>"><%=ket_2%></font></td>
                        </tr>    
                    </table>    
                </td>
            </tr>
            <tr>        
                <td colspan="11" height="55">&nbsp;</td>
            </tr>    
            <tr>        
                <td colspan="11">
                    <table width="100%">
                        <tr>
                            <td width="50%" align="center" class id ='detail' ><font size="<%=printDesign.getSizeFontDataFooter()%>px" face="<%=printDesign.getFontDataFooter()%>"><%=nama_1%></font></td>
                            <td width="50%" align="center" class id ='detail'><font size="<%=printDesign.getSizeFontDataFooter()%>px" face="<%=printDesign.getFontDataFooter()%>"><%=nama_2%></font></td>
                        </tr>    
                    </table>    
                    
                </td>
            </tr>
            <tr>        
                <td colspan="11" height="40">&nbsp;</td>
            </tr>    
        </table> 
    </body>
</html>
