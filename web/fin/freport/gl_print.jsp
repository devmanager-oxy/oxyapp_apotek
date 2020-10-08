
<%-- 
    Document   : gl_print
    Created on : Dec 14, 2011, 11:32:15 AM
    Author     : Ror Andika
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
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<html>
    <head>
        <style>
            #string-HEAD-TEXT{
                line-height:25px; 
                color: #9A958F;
                vertical-align : top; 
            }
            
            #string-TEXT{
                padding-right:5px;
                padding-left:5px;
                padding-top:5px;
                padding-bottom:5px;
                line-height:16px; 
                color: #9A958F;
                vertical-align : middle; 
            }
            
            #string-DETAIL{
                padding-right:5px;
                padding-left:5px;
                padding-top:5px;
                padding-bottom:5px;        
                line-height:16px; 
                color: #9A958F;
                vertical-align : top; 
            }
            
            #string-putus{
                font-family:'Courier New', Courier, monospace;
                border-bottom: dashed 1px;        
                padding-bottom:3px;
                font-size: 12px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
            }
            
            #string-putus-2{
                font-family:'Courier New', Courier, monospace;
                border-bottom: dashed 1px;        
                padding-bottom:3px;
                font-size: 16px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
            }
            
            #string{
                font-family:'Courier New', Courier, monospace;               
                padding-bottom:3px;
                font-size: 12px;
                line-height:16px; 
                color: #9A958F;
            }
            
            #head-company{
                font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
                font-size: 16px;        
                color: #000;
                text-align: left;
                font-weight:bold;
            }
            
            #head{
                font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
                font-size: 12px;        
                color: #000;
                text-align: left;
            }
            
            #head-title{
                font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
                font-size: 13px;        
                color: #000;
                text-align: center;
                font-weight:bold;
            }
            
            #title-colom-left{
                font-family:'Courier New', Courier, monospace;
                border-left : 1px solid; 
                border-top : 1px solid;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
            }
            
            #title-colom-right{
                font-family:'Courier New', Courier, monospace;
                border-left : 1px solid; 
                border-top : 1px solid;
                border-right : 1px solid;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
            }
            
            #data-left{
                font-family:'Courier New', Courier, monospace;
                border-left : 1px solid; 
                border-top : 1px solid;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                padding-left:5px;
            }
            
            #data-right{
                font-family:'Courier New', Courier, monospace;
                border-left : 1px solid; 
                border-top : 1px solid;
                border-right : 1px solid;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                padding-left:5px;
            }
            
            #data-right-last{        
                font-family:'Courier New', Courier, monospace;
                border-left : 1px solid; 
                border-top : 1px solid;
                border-right : 1px solid;
                border-bottom : 1px solid; 
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                padding-left:5px;
            }
            
            #data-left-total{
                border-left:#000 1px solid;
                border-top:#000 3px solid;
                padding-left:4px;
            }
        </style>    
    </head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Cetak Data</title>    
    <script language="Javascript1.2">        
        function printpage() {
            window.print();
        }        
    </script>
    <body onload='printpage()'>
        <%!
    public String getFormated(double amount, boolean isBold){

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
            long glId = JSPRequestValue.requestLong(request, "gl_id");
            Gl gl = new Gl();
            Vector listGlDetail = new Vector();
            try {
                gl = DbGl.fetchExc(glId);
            } catch (Exception e) {
            }

            if (gl.getOID() != 0) {
                String where = DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = " + gl.getOID();
                try {
                    listGlDetail = DbGlDetail.list(0, 0, where, null);
                } catch (Exception e) {
                }
            }

            boolean diffCoaClass = false;

            String[] langGL = {"Journal Number", "Transaction Date", "Reference Number", "Journal Detail", //0-3
                "Account - Description", "Department", "Currency", "Code", "Amount", "Booked Rate", "Debet", "Credit", "Description", //4-12
                "Error, can't posting journal when details mixed between SP and NSP", "Journal has been saved successfully.", "Search Journal Number", "Journal is ready to be saved", "Memo", "JOURNAL UMUM"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Detail Jurnal", //0-3
                    "Perkiraan", "Departemen", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Debet", "Credit", "Keterangan", //4-12
                    "Error, tidak bisa posting journal dengan detail gabungan SP dan NSP.", "Jurnal sukses disimpan.", "Cari Nomor Jurnal", "Jurnal siap untuk disimpan", "Memo", "JURNAL UMUM"};

                langGL = langID;
            }

            String name_company = "";
            String alamat = "";
            try {
                Vector listComp = new Vector();
                listComp = DbCompany.list(0, 1, "", null);
                Company company = new Company();
                company = (Company) listComp.get(0);
                name_company = company.getName();
                alamat = company.getAddress();
            } catch (Exception e) {
            }

            String Header = "";
            try {
                Header = DbSystemProperty.getValueByName("HEADER_JOURNAL");

                if ((Header.compareTo("Not initialized") == 0) || (Header.compareTo("-") == 0) || (Header.compareTo("") == 0)) {
                    Header = "";
                }
            } catch (Exception e) {
                Header = "";
                System.out.println("[exception] " + e.toString());
            }

            PrintDesign printDesign = new PrintDesign();

            try {
                printDesign = DbPrintDesign.getDesign(DbPrintDesign.colNamesDocument[DbPrintDesign.DOCUMENT_GL]);
            } catch (Exception e) {
                System.out.println("exception " + e.toString());
            }
        %>
        <table align="center" width="<%=printDesign.getWidthPrint()%>" border="0">
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>    
            <tr>
                <td colspan="6" class id = "head-company">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td colspan="3" width="100%" >
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class id = "string-HEAD-TEXT" style = "border-bottom : dashed 1px ;"><font size="<%=printDesign.getSizeFontHeader()%>px" face="<%=printDesign.getFontHeader()%>"><%=name_company%></font></td>
                                                </tr>    
                                            </table>    
                                        </td>
                                        <td width="20%">&nbsp</td>
                                        <td width="30%" align="center">&nbsp;</td>
                                    </tr>    
                                </table>
                            </td>
                        </tr> 
                        
                        <%
            if (Header.compareTo("") != 0) {
                        %>
                        <tr>
                            <td colspan="3" width="100%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontHeader()%>px" face="<%=printDesign.getFontHeader()%>"><%=Header%></font></td>
                                                </tr>    
                                            </table>    
                                        </td>
                                        <td width="20%">&nbsp</td>
                                        <td width="30%">&nbsp;</td>
                                    </tr>    
                                </table>
                            </td>
                        </tr> 
                        <%}%>
                        <tr>
                            <td colspan="3" width="100%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontHeader()%>px" face="<%=printDesign.getFontHeader()%>"><%=alamat%></font></td>
                                                </tr>    
                                            </table>    
                                        </td>
                                        <td width="20%">&nbsp</td>
                                        <td width="30%">&nbsp;</td>
                                    </tr>    
                                </table>
                            </td>
                        </tr> 
                        <tr>
                            <td colspan="3">&nbsp;</td>
                        </tr>    
                        <tr>
                            <td width="100%" colspan="3">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="130" class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>"><%=langGL[0]%></font></td>
                                                    <td class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>">:</td>
                                                    <td class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>">&nbsp;<%= gl.getJournalNumber()%></font></td>
                                                </tr>
                                            </table>    
                                        </td>
                                        <td width="10%">&nbsp;</td>
                                        <td width="25%" class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>"><%=langGL[1]%></font></td>
                                        <td width="2%" class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>">:</font></td>
                                        <td width="13%" class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>"><%=JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy")%></font></td>
                                    </tr>    
                                </table>
                            </td>
                        </tr> 
                        <tr>
                            <td width="100%" colspan="3">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="130" class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>"><%=langGL[2]%></font></td>
                                                    <td class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>">:</font></td>
                                                    <td class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>">&nbsp;<%=gl.getRefNumber()%></font></td>
                                                </tr>
                                            </table>    
                                        </td>
                                        <td width="10%">&nbsp;</td>
                                        <td width="25%">&nbsp;</td>
                                        <td width="2%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>    
                                </table>
                            </td>
                        </tr> 
                        <tr>
                            <td width="100%" colspan="3">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="50%">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="130" class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>"><%=langGL[17]%></font></td>
                                                    <td class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>">:</font></td>
                                                    <td class id = "string-HEAD-TEXT"><font size="<%=printDesign.getSizeFontDataMain()%>px" face="<%=printDesign.getFontDataMain()%>">&nbsp;<%= gl.getMemo()%></font></td>
                                                </tr>
                                            </table>    
                                        </td>
                                        <td width="10%">&nbsp;</td>
                                        <td width="25%">&nbsp;</td>
                                        <td width="2%">&nbsp;</td>
                                        <td width="13%">&nbsp;</td>
                                    </tr>    
                                </table>
                            </td>
                        </tr> 
                    </table>   
                </td>
            </tr> 
            <tr>
                <td>&nbsp;</td>
            </tr>    
            <%
            if (listGlDetail != null && listGlDetail.size() > 0) {
                double debet = 0;
                double credit = 0;
                int ct = 0;
            %>
            <tr>
                <td>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td rowspan="2" align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Perkiraan</font></td>
                            <td rowspan="2" align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Departemen</font></td>
                            <td rowspan="2" align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">&nbsp;</font></td>
                            <td colspan="2" align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Mata Uang</font></td>
                            <td rowspan="2" align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Kurs Transaksi</font></td>
                            <td rowspan="2" align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Debet Rp.</font></td>
                            <td rowspan="2" align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Credit Rp.</font></td>
                            <td rowspan="2" align="center" class id = "string-TEXT" style = "border-right : solid <%=printDesign.getBorderTitleColumn()%>px ;border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Keterangan</font></td>
                        </tr>
                        <tr>
                            <td align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Kode</font></td>
                            <td align="center" class id = "string-TEXT" style = "border-left : solid <%=printDesign.getBorderTitleColumn()%>px ;border-top : solid <%=printDesign.getBorderTitleColumn()%>px ;"><font size="<%=printDesign.getSizeFontTitleColumn()%>px" face="<%=printDesign.getFontTitleColumn()%>">Jumlah</font></td>
                        </tr> 
                        <%
                for (int i = 0; i < listGlDetail.size(); i++) {

                    GlDetail glDetail = (GlDetail) listGlDetail.get(i);

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(glDetail.getCoaId());
                        if (i == 0) {
                            ct = c.getAccountClass();
                        } else {
                            if (!diffCoaClass && ct != c.getAccountClass()) {
                                if (ct == 2) {
                                    if (c.getAccountClass() != 2) {
                                        diffCoaClass = true;
                                    }
                                } else {
                                    if (c.getAccountClass() == 2) {
                                        diffCoaClass = true;
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                    debet = debet + glDetail.getDebet();
                    credit = credit + glDetail.getCredit();
                        %>
                        <tr>
                            <td align="left" class id = "string-DETAIL" style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=c.getCode() + " - " + c.getName()%></font></td>
                            <td align="left" class id = "string-DETAIL" style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">
                                    <%
                            try {
                                if (glDetail.getDepartmentId() != 0) {
                                    Department dept = DbDepartment.fetchExc(glDetail.getDepartmentId());
                                    out.println(dept.getName());
                                } else {
                                    out.println("-");
                                }
                            } catch (Exception xcc) {
                            }
                                    %>
                            </font></td>
                            <td align="left" class id = "string-DETAIL" style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">
                                    <%
                            if (c.getAccountClass() == DbCoa.ACCOUNT_CLASS_SP) {
                                out.println("SP");
                            } else {
                                out.println("NSP");
                            }
                                    %>
                            </font></td>
                            <td align="left" class id = "string-DETAIL" style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>">
                                    <%
                            Currency xc = new Currency();
                            try {
                                xc = DbCurrency.fetchExc(glDetail.getForeignCurrencyId());
                            } catch (Exception e){}

                            String memo = "&nbsp;";
                            if (glDetail.getMemo().length() > 0) {
                                memo = glDetail.getMemo();
                            }
                                    %>
                                    <%=xc.getCurrencyCode()%>
                            </font></td>
                            <td align="right" class id = "string-DETAIL" style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(glDetail.getForeignCurrencyAmount(), "#,###.##")%></font></td>
                            <td align="right" class id = "string-DETAIL" style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(glDetail.getBookedRate(), "#,###.##")%></font></td>
                            <td align="right" class id = "string-DETAIL" style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(glDetail.getDebet(), "#,###.##")%></font></td>
                            <td align="right" class id = "string-DETAIL" style = "border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=JSPFormater.formatNumber(glDetail.getCredit(), "#,###.##")%></font></td>
                            <td class id = "string-DETAIL" style = "border-right : solid <%=printDesign.getBorderDataDetail()%>px ;border-left : solid <%=printDesign.getBorderDataDetail()%>px ;border-top : solid <%=printDesign.getBorderDataDetail()%>px ;"><font size="<%=printDesign.getSizeFontDataDetail()%>px" face="<%=printDesign.getFontDataDetail()%>"><%=memo%></font></td>
                        </tr>
                        <%}%>
                        <tr>
                            <td colspan="6" align="right" class id = "string-DETAIL" style = "border-bottom : solid <%=printDesign.getBorderDataTotal()%>px ;border-top : solid <%=printDesign.getBorderDataTotal()%>px ;border-left : solid <%=printDesign.getBorderDataTotal()%>px ;border-top : solid <%=printDesign.getBorderDataTotal()%>px ;"><font size="<%=printDesign.getSizeFontDataTotal()%>px" face="<%=printDesign.getFontDataTotal()%>">TOTAL&nbsp;</font></td>
                            <td align="right" class id = "string-DETAIL" style = "border-bottom : solid <%=printDesign.getBorderDataTotal()%>px ;border-top : solid <%=printDesign.getBorderDataTotal()%>px ;border-left : solid <%=printDesign.getBorderDataTotal()%>px ;border-top : solid <%=printDesign.getBorderDataTotal()%>px ;"><font size="<%=printDesign.getSizeFontDataTotal()%>px" face="<%=printDesign.getFontDataTotal()%>"><%=JSPFormater.formatNumber(debet, "#,###.##")%></font></td>
                            <td align="right" class id = "string-DETAIL" style = "border-bottom : solid <%=printDesign.getBorderDataTotal()%>px ;border-top : solid <%=printDesign.getBorderDataTotal()%>px ;border-left : solid <%=printDesign.getBorderDataTotal()%>px ;border-top : solid <%=printDesign.getBorderDataTotal()%>px ;"><font size="<%=printDesign.getSizeFontDataTotal()%>px" face="<%=printDesign.getFontDataTotal()%>"><%=JSPFormater.formatNumber(credit, "#,###.##")%></font></td>
                            <td class id = "string-DETAIL" style = "border-bottom : solid <%=printDesign.getBorderDataTotal()%>px ;border-right : solid <%=printDesign.getBorderDataTotal()%>px ;border-top : solid <%=printDesign.getBorderDataTotal()%>px ;border-left : solid <%=printDesign.getBorderDataTotal()%>px ;border-top : solid <%=printDesign.getBorderDataTotal()%>px ;"><font size="<%=printDesign.getSizeFontDataTotal()%>px" face="<%=printDesign.getFontDataTotal()%>">&nbsp;</font></td>
                        </tr>
                        <tr>
                            <td colspan="9" align="center" height="20">&nbsp;</td>
                        </tr>   
                        <tr>
                            <td colspan="9" align="center" height="20">&nbsp;</td>
                        </tr>  
                        <%

                Vector result = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_JOURNAL);
                if (result != null && result.size() > 0) {

                        %>
                        <tr>
                            <td colspan="9" align="center">
                                <table width="100%" border="0">
                                    <%int colspan = 0;%>
                                    <tr>
                                        <%
                                    int urutan = 0;
                                    for (int iHead = 0; iHead < result.size(); iHead++) {

                                        String header = "";
                                        Approval ap = (Approval) result.get(iHead);
                                        try {
                                            header = ap.getKeterangan();
                                        } catch (Exception e) {}

                                        if (urutan != ap.getUrutan()) {
                                            colspan++;
                                        %>       
                                        <td class id = "string" align="center"><%=header%></td>
                                        <%
                                        }
                                        urutan = ap.getUrutan();
                                    }
                                        %>
                                    </tr>                            
                                    <tr height="50" >
                                        <td class id = "string" colspan="<%=colspan%>">&nbsp;</td>
                                    </tr> 
                                    <tr>
                                        <%
                                    int urutanFot = 0;
                                    for (int iFooter = 0; iFooter < result.size(); iFooter++) {

                                        String Footer = "";
                                        Approval ap = (Approval) result.get(iFooter);
                                        try {
                                            Footer = ap.getKeteranganFooter();
                                        } catch (Exception e) {}

                                        if (urutanFot != ap.getUrutan()) {
                                        %>       
                                        <td class id = "string" align="center"><%=Footer%></td>
                                        <%
                                        }
                                        urutanFot = ap.getUrutan();
                                    }
                                        %>
                                    </tr>     
                                </table>    
                            </td>
                        </tr>
                        <%
                }
                        %>
                    </table>
                </td>
            </tr>    
            <tr>
                <td colspan="6" height="15"></td>
            </tr>    
            <%}%>
        </table> 
    </body>
</html>