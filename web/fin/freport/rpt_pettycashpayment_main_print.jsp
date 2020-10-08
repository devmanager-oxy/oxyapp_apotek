
<%-- 
    Document   : rpt_pettycashpayment_main_print
    Created on : Jan 24, 2012, 9:37:33 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<html>
    <head>
        <style>
            #bukti{
                font-family: arial;
                font-size: 26px;
                line-height: 18px;
                color: #1D1C1B;
                font-weight: bold;
            }
            
            #main{
                font-family: 'Courier New', Courier, monospace;
                font-size: 22px;
                line-height: 18px;
                color: #1D1C1B;
                padding-top:5px;
                padding-bottom:5px;
            }
            
            #b-horizontal{
                border-bottom: dashed 1px; 
                font-family: 'Courier New', Courier, monospace;
                font-size: 22px;
                color: #1D1C1B;
            }
            
            #H-COLUMN{ padding-bottom:5px;padding-top:5px; line-height:16px; color: #1D1C1B; vertical-align : middle; font-size: 20px;}
            
            #D-FIRST-LEFT{ padding-right:5px;padding-left:5px;padding-bottom:5px;padding-top:5px; line-height:16px; color: #1D1C1B; vertical-align : top; font-size: 20px;}
            
            #string-space{
                border-left: dashed 1px;                
                color: #1D1C1B;
                font-family: 'Courier New', Courier, monospace;
                font-size: 22px;
            }
            
            #string-tidak-dashed{
                line-height:18px;  color: #1D1C1B;
                font-family: 'Courier New', Courier, monospace;
                font-size: 22px;
            }
            
            #string-space-last{
                border-left: dashed 1px;                
                border-right: dashed 1px;      
                color: #1D1C1B;
                font-family: 'Courier New', Courier, monospace;
                font-size: 18px;
            }
            
            #string-dashed-H-COLUMN{ padding-bottom:3px; line-height:16px; color: #1D1C1B; padding-right:10px; padding-left:10px; vertical-align : middle; font-size: 22px;}
            
            #string-isi-tabel-second-last{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;         
                padding-bottom:3px;
                padding-top:3px;
                font-size: 14px;
                line-height:16px; 
                color: #1D1C1B;
                text-align: center;        
                vertical-align: top;
            }
            
            #string-garis-atas-kiri-padding-left-top-second-last{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;         
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #1D1C1B;        
                padding-left:10px;
                padding-right:10px;
                vertical-align: top;
                padding-top:3px;
            }
            
            #string-garis-atas-kiri-kanan-center-top-second-last{
                font-family:'Courier New', Courier, monospace;
                border-left: dashed 1px;                
                border-bottom: dashed 1px;
                border-right: dashed 1px;                
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #1D1C1B;     
                text-align: center;
                vertical-align: top;
                padding-top:3px;
            }
            
            #string-tidak-dashed{
                line-height:18px;  color: #1D1C1B;
                font-size: 18px;
            }
            
            #string{
                font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
                font-size: 12px;
                line-height: 18px;
                color: #000;
                text-align: left;
            }
            
            #string-tidak-putus{
                font-family:'Courier New', Courier, monospace;
                font-size: 12px;
                line-height:18px; 
                color: #9A958F;
                text-align: left;
            }
            
            #string-tidak-putus-2{
                font-family:'Courier New', Courier, monospace; font-size: 14px; line-height:18px;  color: #9A958F; text-align: left;
            }
            
            
            
            #string-tourism{
                font-family:'Courier New', Courier, monospace;
                font-size: 14px;
                line-height:18px; 
                color: #000000;
                text-align: left;
            }
            
            #string-dashed{
                border-bottom: dashed 1px;        
                padding-bottom:3px;
                line-height:16px; 
                color: #9A958F;
            }
            
            
            #string-putus{
                font-family:'Courier New', Courier, monospace;
                border-bottom: dashed 1px;        
                padding-bottom:3px;
                font-size: 15px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
            }
            
            #string-garis-bawah-putus{
                font-family:'Courier New', Courier, monospace;
                border-bottom: dashed 1px;        
                padding-bottom:3px;
                font-size: 13px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
            }
            #string-garis-atas-putus{
                font-family:'Courier New', Courier, monospace;
                border-top: dashed 1px;        
                padding-bottom:3px;
                font-size: 13px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
            }
            #string-garis-atas-kiri-center{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px; 
                border-top : dashed 1px;
                border-bottom : dashed 1px;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;        
                padding-right:10px;
                padding-left:10px;
            }
            
            
            
            #string-garis-atas-kanan-center{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px; 
                border-top : dashed 1px;
                border-bottom : dashed 1px;
                border-right : dashed 1px;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
            }
            
            #string-keterangan{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px; 
                border-top : dashed 1px;
                border-bottom : dashed 1px;
                padding-bottom: 3px;
                font-size: 14px;
                vertical-align : top;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
            }
            
            
            #string-garis-kiri-center{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
            }
            
            #string-garis-kanan-center{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;
                border-right : dashed 1px;
                padding-bottom:3px;
                padding-right:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
            }
            
            #string-garis-atas-kiri-padding-left{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;
                border-top : dashed 1px;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;        
                padding-left:10px;
                padding-left:10px;
            }
            
            #string-garis-atas-kiri-padding-left-top{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;
                border-top : dashed 1px;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
                padding-left:20px;
                vertical-align: top;
                padding-top:6px;
            }
            
            #string-garis-atas-kiri-padding-left-top-second{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;        
                padding-left:10px;
                padding-right:10px;
                vertical-align: top;
                padding-top:3px;
            }
            
            #string-garis-atas-kiri-padding-left-top-first{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-top : dashed 1px;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                padding-left:10px;
                padding-right:10px;
                vertical-align: top;
                padding-top:6px;
            }
            
            
            #string-isi-tabel{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;
                border-top : dashed 1px;
                padding-bottom:3px;
                padding-top:6px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;        
                vertical-align: top;
            }
            
            #string-isi-tabel-first{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-top : dashed 1px;
                padding-bottom:3px;
                padding-top:6px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;        
                vertical-align: top;
            }
            
            #string-isi-tabel-second{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                padding-bottom:3px;
                padding-top:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;        
                vertical-align: top;
            }
            
            
            
            #string-garis-kiri-padding-left{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
                padding-left:20px;
            }
            
            #string-garis-kiri-padding-left-paraf{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
                padding-left:5px;
                height : 20px;
            }
            
            #string-garis-atas-kiri-kanan-center{
                font-family:'Courier New', Courier, monospace;
                border: dashed 1px;                
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
            }
            
            #string-garis-atas-kiri-kanan-center-top{
                font-family:'Courier New', Courier, monospace;
                border: dashed 1px;                
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
                vertical-align: top;
                padding-top:6px;
            }
            
            
            #string-garis-atas-kiri-kanan-center-top-first{
                font-family:'Courier New', Courier, monospace;
                border-right: dashed 1px;                
                border-top: dashed 1px;                
                border-left: dashed 1px;                
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
                vertical-align: top;
                padding-top:6px;
            }
            
            #string-garis-atas-kiri-kanan-left-top-first{
                font-family:'Courier New', Courier, monospace;
                border-right: dashed 1px;                
                border-top: dashed 1px;                
                border-left: dashed 1px;                
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
                vertical-align: top;
                padding-left:10px;
                padding-top:6px;
            }
            
            
            #string-garis-atas-kiri-kanan-center-top-second{
                font-family:'Courier New', Courier, monospace;
                border-left: dashed 1px;                
                border-right: dashed 1px;                
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
                vertical-align: top;
                padding-top:3px;
            }
            
            #string-garis-atas-kiri-kanan-left-top-second{
                font-family:'Courier New', Courier, monospace;
                border-left: dashed 1px;                        
                border-right: dashed 1px;                
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;        
                vertical-align: top;
                padding-top:10px;
                padding-left:10px;
                padding-right:10px;
            }
            
            
            #string-garis-kiri-kanan-center{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-right : dashed 1px;        
                border-bottom : dashed 1px;        
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
            }
            
            #bukti-putus{
                font-family:'Courier New', Courier, monospace;
                border-bottom: dashed 2px;
                letter-spacing:3px;
                padding-bottom:3px;
                font-size: 22px;
                font-weight:bolder; 
                color: #9A958F;
                text-align: center;
            }
            
            #strongC{
                font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
                font-size: 12px;
                line-height: 18px;
                font-weight: bold;
                color: #000;
                text-align: center;
            }
            #strong{
                font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
                font-size: 12px;
                line-height: 18px;
                font-weight: bold;
                color: #000;
                text-align: left;
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
            long pettycash_payment_id = Long.parseLong(request.getParameter("pettycashPayment_id"));
            PettycashPayment pettycashPayment = new PettycashPayment();
            try {
                pettycashPayment = DbPettycashPayment.fetchExc(pettycash_payment_id);
            } catch (Exception e) {
                System.out.println("Exception " + e.toString());
            }

            String whereClause = DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + pettycashPayment.getOID();            
            Vector vPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, whereClause, null);

            String cst = "";
            int val_periode = pettycashPayment.getTransDate().getMonth() + 1;
            String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");

            if (pettycashPayment.getPaymentTo() != null && pettycashPayment.getPaymentTo().length() > 0) {
                cst = pettycashPayment.getPaymentTo();
            } else if (pettycashPayment.getEmployeeId() != 0) {
                try {
                    Employee employe = DbEmployee.fetchExc(pettycashPayment.getEmployeeId());
                    cst = employe.getName();
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            } else if (pettycashPayment.getCustomerId() != 0) {
                try {
                    Customer cust = DbCustomer.fetchExc(pettycashPayment.getCustomerId());
                    cst = cust.getName();
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            } else {
                cst = "-";
            }

            String company = "";
            String address = "";
            String Header = "";

            int space_report = 0;

            try {
                space_report = Integer.parseInt(DbSystemProperty.getValueByName("SPACE_REPORT_BKK"));
            } catch (Exception e) {
                System.out.println("[exc] " + e.toString());
            }

            try {
                Vector vCompany = DbCompany.list(0, 0, "", null);
                if (vCompany != null && vCompany.size() > 0) {
                    Company com = (Company) vCompany.get(0);
                    company = com.getName();
                    address = com.getAddress();
                }
            } catch (Exception e) {
                System.out.println("[exc] " + e.toString());
            }

            try {
                Header = DbSystemProperty.getValueByName("HEADER_BKK");
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            PrintDesign printDesign = new PrintDesign();

            try {
                printDesign = DbPrintDesign.getDesign(DbPrintDesign.colNamesDocument[DbPrintDesign.DOCUMENT_BKK]);
            } catch (Exception e) {
                System.out.println("exception " + e.toString());
            }
        %>        
        <table align="center" width="<%=printDesign.getWidthPrint()%>" border="0">    
    <tr>
        <td colspan="3" height="5px">&nbsp;</td>    
    </tr>
    <tr>
        <td colspan="3">            
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="5" height="2px"></td>
                </tr> 
                <%

            int max_limit = 0;

            try {
                max_limit = Integer.parseInt(DbSystemProperty.getValueByName("MAX_LIMIT_ONE_PAGE_BKK"));
            } catch (Exception E) {
            }

            int no = 0;
            int hal = 1;
            int max_hal = 0;

            int idxCounter = 0;

            max_hal = vPettycashPaymentDetail.size() / max_limit;

            if (vPettycashPaymentDetail.size() % max_limit != 0) {
                max_hal = max_hal + 1;
            }

            idxCounter = 0;

            if (idxCounter != 0) {

                %>
                <tr height="40px">
                    <td width="9%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="15%">&nbsp;</td>
                    <td width="22%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                </tr>  
                <%}%>
                <tr>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="65%">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td class id = 'main' style = "border-bottom : dashed <%=printDesign.getBorderDataDetail()%>px;">
                                                <font face="<%=printDesign.getFontHeader()%>"><%=company%></font>
                                            </td>  
                                        </tr>      
                                    </table>           
                                </td>                                
                                <td width="35%" align="center" colspan="2">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>                                            
                                            <td class id = 'bukti' align="center">BUKTI KAS/BANK</td>
                                        </tr>   
                                    </table> 
                                </td>    
                            </tr> 
                            <tr>
                                <td width="65%" class id = 'main'><font face="<%=printDesign.getFontHeader()%>"><%=Header%></font></td>                                                                
                                <td width="35%" colspan="2" align="center">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >P E M B A Y A R A N</font></td>
                                        </tr>   
                                    </table> 
                                </td>    
                            </tr> 
                            <tr>
                                <td width="65%" class id = 'main'><font face="<%=printDesign.getFontHeader()%>"><%=address%></font></td>
                                <td width="5%">&nbsp;</td>
                                <td width="30%">&nbsp;</td>    
                            </tr> 
                            <tr>
                                <td height="50">&nbsp;</td>    
                            </tr> 
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%">&nbsp;</td>
                                            <td width="2%">&nbsp;</td>    
                                            <td width="33%">&nbsp;</td>    
                                            <td width="12%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >No. BKK</font></td>                                                
                                            <td width="2%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="23%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=pettycashPayment.getJournalNumber()%></font></td>
                                        </tr>    
                                    </table>
                                </td>
                            </tr> 
                            <tr>                
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td >&nbsp;</td>
                            </tr>
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%">&nbsp;</td>
                                            <td width="2%">&nbsp;</td>    
                                            <td width="33%">&nbsp;</td>    
                                            <td width="12%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >Tanggal</font></td>
                                            <td width="2%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="23%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=JSPFormater.formatDate(pettycashPayment.getTransDate(), "dd/MM/yy")%></font></td>
                                        </tr>    
                                    </table>
                                </td>
                            </tr>                               
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top" class id='main'><font face="<%=printDesign.getFontDataMain()%>" >Dibayarkan Kepada</font></td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="33%" valign="top" class id = 'main' ><font face="<%=printDesign.getFontDataMain()%>" ><%=cst%></font></td>
                                            <td width="12%" >&nbsp;</td> 
                                            <td width="2%" >&nbsp;</td> 
                                            <td width="23%" >&nbsp;</td> 
                                        </tr>    
                                    </table>
                                </td>
                            </tr> 
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%">&nbsp;</td>
                                            <td width="2%">&nbsp;</td>    
                                            <td width="33%">&nbsp;</td>    
                                            <td width="12%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >Periode</font></td>
                                            <td width="2%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="23%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=val_periode%></font></td>
                                        </tr>    
                                    </table>
                                </td>
                            </tr> 
                            
                            <%
            NumberSpeller numberSpeller = new NumberSpeller();
            String amount = JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##");
                            %>   
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top" class id='string-tidak-dashed'>
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="85" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >Jumlah</font></td>
                                                        <td class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >dgn. angka</font></td>
                                                    </tr>    
                                                </table>
                                            </td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>">:</font></td>
                                            <td width="33%" valign="top" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=idr%>&nbsp;<%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%></font></td>
                                            <td width="12%" >&nbsp;</td> 
                                            <td width="2%" >&nbsp;</td> 
                                            <td width="23%" >&nbsp;</td> 
                                        </tr>    
                                    </table>
                                </td>
                            </tr> 
                            <tr>                
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top" class id='string-tidak-dashed'>
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="85" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >&nbsp;</font></td>
                                                        <td class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >dgn. huruf</font></td>
                                                    </tr>                                                             
                                                </table>
                                            </td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>">:</font></td>
                                            <td colspan="4" valign="top" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=numberSpeller.spellNumberToIna(Double.parseDouble(amount.replaceAll(",", ""))) + " Rupiah"%></font></td>                                            
                                        </tr>    
                                    </table>
                                </td>
                            </tr> 
                            <tr>                
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td >&nbsp;</td>
                            </tr>
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top" class id='main'><font face="<%=printDesign.getFontDataMain()%>" >Dibayar dengan</font></td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="33%" valign="top" class id = 'main' ><font face="<%=printDesign.getFontDataMain()%>" >No Cek</font></td>
                                            <td width="12%" >&nbsp;</td> 
                                            <td width="2%" >&nbsp;</td> 
                                            <td width="23%" >&nbsp;</td> 
                                        </tr>    
                                    </table>
                                </td>
                            </tr>                             
                            <tr>                
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td >&nbsp;</td>
                            </tr>
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top" class id='main'><font face="<%=printDesign.getFontDataMain()%>" >&nbsp;</font></td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >&nbsp;</font></td>
                                            <td width="33%" valign="top" class id = 'main' ><font face="<%=printDesign.getFontDataMain()%>" >Cash</font></td>
                                            <td width="12%" >&nbsp;</td> 
                                            <td width="2%" >&nbsp;</td> 
                                            <td width="23%" >&nbsp;</td> 
                                        </tr>    
                                    </table>
                                </td>
                            </tr>  
                            <tr height="30">                
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>  
                
                <tr>
                    <td colspan="5" height="5px" class id ='b-horizontal'>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="5" height="2px"></td>
                </tr> 
                <tr>
                    <td colspan="5">                        
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <%
            String nama_1 = "";
            String nama_2 = "";
            String nama_3 = "";
            String nama_4 = "";
            String nama_5 = "";
            String nama_6 = "";
            String nama_7 = "";
            String nama_8 = "";

            String ket_1 = "&nbsp;";
            String ket_2 = "&nbsp;";
            String ket_3 = "&nbsp;";
            String ket_4 = "&nbsp;";
            String ket_5 = "&nbsp;";
            String ket_6 = "&nbsp;";
            String ket_7 = "&nbsp;";
            String ket_8 = "&nbsp;";

            String ketFoot_1 = "&nbsp;";
            String ketFoot_2 = "&nbsp;";
            String ketFoot_3 = "&nbsp;";
            String ketFoot_4 = "&nbsp;";
            String ketFoot_5 = "&nbsp;";
            String ketFoot_6 = "&nbsp;";
            String ketFoot_7 = "&nbsp;";
            String ketFoot_8 = "&nbsp;";

            try {
                Approval approval_1 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKK, DbApproval.URUTAN_1);
                Employee employee = DbEmployee.fetchExc(approval_1.getEmployeeId());
                nama_1 = employee.getName();
                ket_1 = approval_1.getKeterangan();
                ketFoot_1 = approval_1.getKeteranganFooter();
            } catch (Exception E) {
                System.out.println("[exception] " + E.toString());
            }

            try {
                Approval approval_2 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKK, DbApproval.URUTAN_2);
                Employee employee = DbEmployee.fetchExc(approval_2.getEmployeeId());
                nama_2 = employee.getName();
                ket_2 = approval_2.getKeterangan();
                ketFoot_2 = approval_2.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_3 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKK, DbApproval.URUTAN_3);
                Employee employee = DbEmployee.fetchExc(approval_3.getEmployeeId());
                nama_3 = employee.getName();
                ket_3 = approval_3.getKeterangan();
                ketFoot_3 = approval_3.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_4 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKK, DbApproval.URUTAN_4);
                Employee employee = DbEmployee.fetchExc(approval_4.getEmployeeId());
                nama_4 = employee.getName();
                ket_4 = approval_4.getKeterangan();
                ketFoot_4 = approval_4.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_5 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKK, DbApproval.URUTAN_5);
                Employee employee = DbEmployee.fetchExc(approval_5.getEmployeeId());
                nama_5 = employee.getName();
                ket_5 = approval_5.getKeterangan();
                ketFoot_5 = approval_5.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_6 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKK, DbApproval.URUTAN_6);
                Employee employee = DbEmployee.fetchExc(approval_6.getEmployeeId());
                nama_6 = employee.getName();
                ket_6 = approval_6.getKeterangan();
                ketFoot_6 = approval_6.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_7 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKK, DbApproval.URUTAN_7);
                Employee employee = DbEmployee.fetchExc(approval_7.getEmployeeId());
                nama_7 = employee.getName();
                ket_7 = approval_7.getKeterangan();
                ketFoot_7 = approval_7.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_8 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKK, DbApproval.URUTAN_8);
                Employee employee = DbEmployee.fetchExc(approval_8.getEmployeeId());
                nama_8 = employee.getName();
                ket_8 = approval_8.getKeterangan();
                ketFoot_8 = approval_8.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }
                            %>
                            <tr height="120px">
                                <td width="40%" class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataApproval()%>px ;border-bottom : dashed <%=printDesign.getBorderDataApproval()%>px;">
                                    <table width="100%" align="center" border="0">
                                        <tr>
                                            <td class id = 'string-tidak-dashed' align="center"><font face="<%=printDesign.getFontDataApproval()%>"><%=ket_1 == null ? "&nbsp" : ket_1 %>,&nbsp;Tgl &nbsp&nbsp&nbsp&nbsp/&nbsp&nbsp&nbsp&nbsp;/20</font></td>       
                                        </tr>
                                        <tr>
                                            <td height="120">&nbsp;</td>       
                                        </tr>
                                    </table>
                                </td>                              
                                <td width="60%" class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataApproval()%>px ;border-bottom : dashed <%=printDesign.getBorderDataApproval()%>px;border-right : dashed <%=printDesign.getBorderDataApproval()%>px;">
                                    <table width="100%" align="center" border="0">
                                        <tr>
                                            <td class id = 'string-tidak-dashed' align="center"><font face="<%=printDesign.getFontDataApproval()%>"><%=ket_2 == null ? "&nbsp" : ket_2 %>,&nbsp;Tgl &nbsp&nbsp&nbsp&nbsp/&nbsp&nbsp&nbsp&nbsp;/20</font></td>       
                                        </tr>
                                        <tr>
                                            <td height="120">&nbsp;</td>       
                                        </tr>
                                    </table>
                                </td>
                            </tr>                            
                            <tr>
                                <td width="50%" class id = 'string-tidak-dashed'>
                                    <font face="<%=printDesign.getFontDataFooter()%>">Dicetak Tanggal <%=JSPFormater.formatDate(new Date(), "dd/MM/yy")%></font>                                            
                                </td>                                
                                <td width="50%" class id = 'string-tidak-dashed' align="left">
                                    <font face="<%=printDesign.getFontDataFooter()%>">Halaman <%=hal%> dari <%=max_hal%></font>
                                </td>
                            </tr> 
                            <tr>
                                <td height="20px" colspan = "2">&nbsp;</td>
                            </tr>    
                            <tr>
                                <td colspan="2" align="center">&nbsp;</td>                                            
                            </tr>
                        </table>    
                    </td>
                </tr>
            </table>
        </td>    
        <td width="5%">&nbsp;</td>
    </tr>
</table>
    </body>
</html>
