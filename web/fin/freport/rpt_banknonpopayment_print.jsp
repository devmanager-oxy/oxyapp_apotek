
<%-- 
    Document   : rpt_banknonpopayment_print
    Created on : Jul 17, 2011, 10:05:54 AM
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
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>

<html>
    <head>
        <style>
            .borderB{
                border-bottom: 1px solid #000;
            }
            
            #stringC{
                font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif;
                font-size: 12px;
                line-height: 18px;
                color: #000;
                text-align: center;
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
                font-family:'Courier New', Courier, monospace;
                font-size: 14px;
                line-height:18px; 
                color: #9A958F;
                text-align: left;
            }
            
            #string-tourism{
                font-family:'Courier New', Courier, monospace;
                font-size: 14px;
                line-height:18px; 
                color: #000000;
                text-align: left;
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
            
            #string-garis-bawah-putus{
                font-family:'Courier New', Courier, monospace;
                border-bottom: dashed 1px;        
                padding-bottom:3px;
                font-size: 12px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
            }
            #string-garis-atas-putus{
                font-family:'Courier New', Courier, monospace;
                border-top: dashed 1px;        
                padding-bottom:3px;
                font-size: 12px;
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
            
            #string-garis-atas-kiri-padding-left{
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
                text-align: left;
                padding-left:20px;
                vertical-align: top;
                padding-top:3px;
            }
            
            #string-garis-atas-kiri-padding-left-top-second-last{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;         
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: left;
                padding-left:20px;
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
                text-align: left;
                padding-left:20px;
                vertical-align: top;
                padding-top:6px;
            }
            
            
            #string-garis-atas-kiri-padding-left-top-2{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;                         
                border-top : dashed 1px;                         
                padding-bottom:3px;
                font-size: 14px;        
                color: #9A958F;
                text-align: left;
                padding-left:20px;
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
            
            #string-isi-tabel-second-last{
                font-family:'Courier New', Courier, monospace;
                border-left : dashed 1px;         
                border-bottom : dashed 1px;         
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
            
            #string-garis-atas-kiri-kanan-center-top-second-last{
                font-family:'Courier New', Courier, monospace;
                border-left: dashed 1px;                
                border-bottom: dashed 1px;
                border-right: dashed 1px;                
                padding-bottom:3px;
                font-size: 14px;
                line-height:16px; 
                color: #9A958F;
                text-align: center;
                vertical-align: top;
                padding-top:3px;
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
            .style1 {
                font-size: 9px;
                font-style: italic;
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

            long banknonpopayment_id = Long.parseLong(request.getParameter("banknonpopayment_id"));

            BanknonpoPayment banknonpoPayment = new BanknonpoPayment();

            try {
                banknonpoPayment = DbBanknonpoPayment.fetchExc(banknonpopayment_id);
            } catch (Exception e) {
                System.out.println("Exception " + e.toString());
            }

            String whereClause = DbBanknonpoPaymentDetail.colNames[DbBanknonpoPayment.COL_BANKNONPO_PAYMENT_ID] + "=" + banknonpoPayment.getOID();

            Vector vbanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(0, 0, whereClause, null);

            String cst = "";

            try {
                Customer cust = DbCustomer.fetchExc(banknonpoPayment.getCustomerId());
                cst = cust.getName();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            int val_periode = banknonpoPayment.getTransDate().getMonth() + 1;

            String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");

        %>
        <table width="100%" border="0">
            <tr>
                <td width="5%">&nbsp</td>
                <td width="45%" ><font class id = 'string-putus'>P.T. (PERSERO) PENGEMBANGAN PARIWISATA BALI</font></td>
                <td width="5%">&nbsp</td>
                <td width="40%" align="center" ><font class id = 'bukti-putus'>BUKTI KAS/<strike>BANK</strike></font></td>
                <td width="5%">&nbsp</td>
            </tr>
            <tr>
                <td width="100%" colspan="5" height="2px"></td>
            </tr>
            <tr>
                <td width="5%">&nbsp</td>
                <td width="40%" ><font class id = 'string-tidak-putus'>P.T. BALI TOURISM DEVELOPMENT CORPORATION</font></td>
                <td width="5%">&nbsp</td>
                <td width="45%" align="center"><font class id = 'string-tidak-putus-2'>P E M B A Y A R A N</font></td>
                <td width="5%">&nbsp</td>
            </tr>
            <tr>
                <td width="5%">&nbsp</td>
                <td width="40%" ><font class id = 'string-tidak-putus'>NUSA DUA - BUALU P.O. BOX 3 NUSA DUA TELP 71010</font></td>
                <td width="5%">&nbsp</td>
                <td width="45%" align="center"><font class id = 'string-tidak-putus-2'></font></td>
                <td width="5%">&nbsp</td>
            </tr>
            <tr>
                <td width="5%">&nbsp</td>
                <td width="40%" >&nbsp;</td>
                <td width="5%">&nbsp</td>
                <td width="45%" align="center"></td>
                <td width="5%">&nbsp</td>
            </tr>
            <tr>
                <td width="100%" colspan="5" height="2px"></td>
            </tr>
            <tr>
                <td width="5%">&nbsp</td>
                <td width="40%" ></td>
                <td width="5%">&nbsp</td>
                <td width="45%">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="25%">&nbsp;</td>
                            <td><font class id = 'string-tidak-putus-2'>No. BKK : <%=banknonpoPayment.getJournalNumber()%></font></td>
                        </tr>   
                    </table>  
                </td>    
                <td width="5%">&nbsp</td>
            </tr>
            <tr>
                <td width="100%" colspan="5" height="2px"></td>
            </tr>
            <tr>
                <td width="5%">&nbsp</td>
                <td width="40%" ></td>
                <td width="5%">&nbsp</td>
                <td width="45%" align="left">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="25%">&nbsp;</td>
                            <td><font class id = 'string-tidak-putus-2'>Tanggal : <%=JSPFormater.formatDate(banknonpoPayment.getTransDate(), "dd/MM/yy")%></font></td>
                        </tr>   
                    </table> 
                </td>
                <td width="5%">&nbsp</td>
            </tr>
            <tr>
                <td width="5%">&nbsp</td>
                <td width="40%" ><font class id = 'string-tidak-putus-2'>Dibayarkan kepada &nbsp;&nbsp;&nbsp;&nbsp;: <%=cst%></font></td>
                <td width="5%">&nbsp</td>
                <td width="45%" ></td>
                <td width="5%">&nbsp</td>
            </tr>
            <tr>
                <td width="5%">&nbsp</td>
                <td width="40%" ></td>
                <td width="5%">&nbsp</td>
                <td width="45%" align="left">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="25%">&nbsp;</td>
                            <td><font class id = 'string-tidak-putus-2'>Periode : <%=val_periode%></font></td>
                        </tr>   
                    </table> 
                </td>
                <td width="5%">&nbsp</td>
            </tr>
            <%
            NumberSpeller numberSpeller = new NumberSpeller();
            %>
            <tr>
                <td width="100%" colspan="5">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="5%">&nbsp</td>
                            <td ><font class id = 'string-tidak-putus-2'>Jumlah dgn. angka  : <%=idr%>&nbsp;<%=JSPFormater.formatNumber(banknonpoPayment.getAmount(), "#,###.##")%></font><td>                
                            <td width="5%">&nbsp</td>
                        </tr>
                    </table>   
                </td>    
            </tr>
            <%
            String amount = JSPFormater.formatNumber(banknonpoPayment.getAmount(), "#,###.##");
            %>
            <tr>
                <td width="100%" colspan="5">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="5%">&nbsp;</td>
                            <td width="57px">&nbsp;</td>
                            <td><font class id = 'string-tidak-putus-2'>dgn. huruf  : <%=numberSpeller.spellNumberToIna(Double.parseDouble(amount.replaceAll(",", ""))) + " Rupiah"%></font><td>
                            <td width="5%">&nbsp;</td>
                        </tr>
                    </table>   
                </td>    
            </tr>
            <tr>
                <td width="100%" colspan="5">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="5%">&nbsp</td>
                            <td width="15%"><font class id = 'string-tidak-putus-2'>Dibayar dengan :</font></td>
                            <td width="15%"><font class id = 'string-tidak-putus-2'>No Cek</font></td>
                            <td>&nbsp;</td>                
                            <td width="5%">&nbsp</td>
                        </tr>
                    </table>   
                </td>    
            </tr>
            <tr>
                <td width="100%" colspan="5" height="5px"></td>    
            </tr>
            <tr>
                <td width="100%" colspan="5">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="5%">&nbsp</td>                    
                            <td width="15%">&nbsp;</td>                
                            <td width="15%"><font class id = 'string-tidak-putus-2'>Cash</font></td>    
                            <td>&nbsp;</td>    
                            <td width="5%">&nbsp</td>
                        </tr>
                    </table>   
                </td>    
            </tr>
            <tr>
                <td width="100%" colspan="5">
                    <table width="100%" border="0px">
                        <tr>
                            <td width="5%">&nbsp</td>
                            <td>
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td colspan="4" class id='string-garis-bawah-putus' height="5px">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height="2px"></td>
                                    </tr>            
                                    <tr>
                                        <td width="10%" class id='string-garis-atas-kiri-center'>No</td>
                                        <td width="30%" class id='string-garis-atas-kiri-padding-left' >P E R I N C I A N</td>
                                        <td width="30%" class id='string-garis-atas-kiri-padding-left' >No. Rekening</td>
                                        <td width="30%" class id='string-garis-atas-kiri-kanan-center' >J U M L A H</td>
                                    </tr> 
                                    <tr>
                                        <td colspan="4" height="2px"></td>
                                    </tr> 
                                    <%

            double payment = 0;

            if (vbanknonpoPaymentDetail != null && vbanknonpoPaymentDetail.size() > 0) {

                for (int i = 0; i < vbanknonpoPaymentDetail.size(); i++) {

                    BanknonpoPaymentDetail banknonpoPaymentDetail = (BanknonpoPaymentDetail) vbanknonpoPaymentDetail.get(i);

                    payment = payment + banknonpoPayment.getAmount();

                    int no = i + 1;

                                    %>
                                    
                                    <%if (i == 0) {%>
                                    <tr>
                                        <td width="10%" class id='string-isi-tabel-first'><%=banknonpoPayment.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %></td>
                                        <td width="30%" class id='string-garis-atas-kiri-padding-left-top-first'><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 ? "-" : banknonpoPaymentDetail.getMemo() %></td>
                                        <td width="30%" class id='string-garis-atas-kiri-padding-left-top-first'><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 ? "&nbsp" : "-" %></td>
                                        <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-first' ><%=JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##")%></td>
                                    </tr> 
                                    <%} else {%>
                                    <tr>
                                        <td width="10%" class id='string-isi-tabel-second'><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %></td>
                                        <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second'><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 ? "-" : banknonpoPaymentDetail.getMemo() %></td>
                                        <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second'><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 ? "&nbsp;" : "-" %></td>
                                        <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-second' ><%=JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##")%></td>
                                    </tr> 
                                    <%}%>
                                    
                                    <%
                                                    }
                                    %>    
                                    <tr height="20px">
                                        <td width="10%" class id='string-isi-tabel-second-last'>&nbsp;</td>
                                        <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                                        <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                                        <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-second-last'>&nbsp;</td>
                                    </tr> 
                                    <%
            }
                                    %>
                                    <tr>
                                        <td colspan="4" height="2px"></td>
                                    </tr>
                                    <tr>
                                        <td width="70%" colspan="3" class id='string-garis-atas-kiri-center'>T O T A L</td>                    
                                        <td width="30%" class id='string-garis-atas-kiri-kanan-center' ><%=JSPFormater.formatNumber(payment, "#,###.##")%></td>
                                    </tr> 
                                    <tr>
                                        <td colspan="4">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="20%" class id='string-garis-kiri-center'>SETUJU DITERIMA</td>
                                                <td width="30%" class id='string-garis-kiri-center' colspan="2">DIPERIKSA OLEH</td>
                                                <td width="20%" class id='string-garis-kiri-center'>DIBAYAR</td>
                                                <td width="30%" class id='string-garis-kiri-kanan-center' colspan="2">TELAH DIBUKUKAN</td>
                                            </tr>
                                            <tr>
                                                <td rowspan="3" class id='string-garis-kiri-center'>&nbsp;</td>
                                                <td rowspan="3" class id='string-garis-kiri-center'>&nbsp;</td>
                                                <td rowspan="3" class id='string-garis-kiri-center'>&nbsp;</td>
                                                <td rowspan="3" class id='string-garis-kiri-center'>&nbsp;</td>
                                                <td class id='string-garis-kiri-center'>Paraf</td>
                                                <td class id='string-garis-kiri-kanan-center'>Tanggal</td>
                                            </tr>
                                            <tr>
                                                <td class id='string-garis-kiri-padding-left-paraf'>1.</td>
                                                <td class id='string-garis-kiri-kanan-center'>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class id='string-garis-kiri-padding-left-paraf'>2.</td>
                                                <td class id='string-garis-kiri-kanan-center'>&nbsp;</td>
                                            </tr>
                                            <%
            String nama_1 = "";
            String nama_2 = "";
            String nama_3 = "";
            String nama_4 = "";
            String nama_5 = "";

            String ket_1 = "&nbsp;";
            String ket_2 = "&nbsp;";
            String ket_3 = "&nbsp;";
            String ket_4 = "&nbsp;";
            String ket_5 = "&nbsp;";

            try {
                Approval approval_1 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_BKK, DbApproval.URUTAN_1);
                Employee employee = DbEmployee.fetchExc(approval_1.getEmployeeId());
                nama_1 = employee.getName();
                ket_1 = approval_1.getKeterangan();

            } catch (Exception E) {
                System.out.println("[exception] " + E.toString());
            }

            try {
                Approval approval_2 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_BKK, DbApproval.URUTAN_2);
                Employee employee = DbEmployee.fetchExc(approval_2.getEmployeeId());
                nama_2 = employee.getName();
                ket_2 = approval_2.getKeterangan();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_3 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_BKK, DbApproval.URUTAN_3);
                Employee employee = DbEmployee.fetchExc(approval_3.getEmployeeId());
                nama_3 = employee.getName();
                ket_3 = approval_3.getKeterangan();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_4 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_BKK, DbApproval.URUTAN_4);
                Employee employee = DbEmployee.fetchExc(approval_4.getEmployeeId());
                nama_4 = employee.getName();
                ket_4 = approval_4.getKeterangan();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_5 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_BKK, DbApproval.URUTAN_5);
                Employee employee = DbEmployee.fetchExc(approval_5.getEmployeeId());
                nama_5 = employee.getName();
                ket_5 = approval_5.getKeterangan();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }
                                            %>
                                            <tr height="80px">
                                                <td width="50%" class id='string-garis-kiri-center'>
                                                    <table width="480px" align="center">
                                                        <tr>
                                                            <td align="center"><font class id = 'string-tidak-putus-2'><%=ket_1 == null ? "&nbsp" : ket_1 %>,&nbsp;Tgl &nbsp&nbsp&nbsp&nbsp/&nbsp&nbsp&nbsp&nbsp;/20</font></td>       
                                                        </tr>
                                                        <tr>
                                                            <td height="80">&nbsp;</td>       
                                                        </tr>
                                                    </table>
                                                </td>                                            
                                                <td width="50%" class id='string-garis-kiri-center'>
                                                    <table width="480px" align="center">
                                                        <tr>
                                                            <td align="center"><font class id = 'string-tidak-putus-2'><%=ket_2 == null ? "&nbsp" : ket_2 %>,&nbsp;Tgl &nbsp&nbsp&nbsp&nbsp/&nbsp&nbsp&nbsp&nbsp;/20</font></td>       
                                                        </tr>
                                                        <tr>
                                                            <td height="80">&nbsp;</td>       
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <table width=100%>
                                                <tr>
                                                    <td colspan="6"><font class id = 'string-tidak-putus-2'>Dicetak Tanggal <%=JSPFormater.formatDate(new Date(), "dd/MM/yy")%></font></td>                                            
                                                </tr>
                                            </table>    
                                        </td>
                                    </tr>
                                </table>
                            </td>    
                            <td width="5%">&nbsp;</td>
                        </tr>
                    </table>
                </td>    
            </tr>
        </table>    
    </body>
</html>
