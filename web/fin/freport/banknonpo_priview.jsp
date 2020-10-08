
<%-- 
    Document   : banknonpo_priview
    Created on : Mar 2, 2012, 4:05:16 PM
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
<%

            long bank_nonpo_payment_id = Long.parseLong(request.getParameter("banknonpopayment_id"));
            
            BanknonpoPayment banknonpoPayment = new BanknonpoPayment();
            try {
                banknonpoPayment = DbBanknonpoPayment.fetchExc(bank_nonpo_payment_id);
            } catch (Exception e) { System.out.println("Exception " + e.toString()); }

            String whereClause = DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_BANKNONPO_PAYMENT_ID] + "=" + banknonpoPayment.getOID();
            Vector tmpBanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(0, 0, whereClause, null);
            Vector vBanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(0, 0, whereClause, null);

            String cst = "";
            int val_periode = banknonpoPayment.getTransDate().getMonth() + 1;
            String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");

            if (banknonpoPayment.getPaymentTo() != null && banknonpoPayment.getPaymentTo().length() > 0) {
                cst = banknonpoPayment.getPaymentTo();
            } else {
                cst = "-";
            }

            String company = "";
            String address = "";
            String Header = "";

            int space_report = 0;

            try {
                space_report = Integer.parseInt(DbSystemProperty.getValueByName("SPACE_REPORT_BKK"));
            } catch (Exception e) { System.out.println("[exc] " + e.toString()); }

            try {
                Vector vCompany = DbCompany.list(0, 0, "", null);
                if (vCompany != null && vCompany.size() > 0) {
                    Company com = (Company) vCompany.get(0);
                    company = com.getName();
                    address = com.getAddress();
                }
            } catch (Exception e) { System.out.println("[exc] " + e.toString()); }

            try {
                Header = DbSystemProperty.getValueByName("HEADER_BKK");
            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }

            PrintDesign printDesign = new PrintDesign();

            try {
                printDesign = DbPrintDesign.getDesign(DbPrintDesign.colNamesDocument[DbPrintDesign.DOCUMENT_BKK]);
            } catch (Exception e) { System.out.println("exception " + e.toString()); }
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
            int max_print = 0;
            
            int useMaxPrint = 0;
            
            try {
                max_limit = Integer.parseInt(DbSystemProperty.getValueByName("MAX_LIMIT_ONE_PAGE_BKK"));
            } catch (Exception E){}
            
            try {
                useMaxPrint = Integer.parseInt(DbSystemProperty.getValueByName("USE_MAX_PRINT_PAGE_BKK"));
            } catch (Exception E){useMaxPrint=0;}
            
            try {
                max_print = Integer.parseInt(DbSystemProperty.getValueByName("MAX_PRINT_PAGE_BKK"));
            } catch (Exception E){}
            

            double payment = 0;
            int no = 0;
            int hal = 1;
            int max_hal = 0;

            try {

                if (vBanknonpoPaymentDetail != null && vBanknonpoPaymentDetail.size() > 0) {

                    int idxCounter = 0;

                    max_hal = vBanknonpoPaymentDetail.size() / max_limit;

                    if (vBanknonpoPaymentDetail.size() % max_limit != 0) {
                        max_hal = max_hal + 1;
                    }

                    idxCounter = 0;
                    int sisa = 0;

                    while (vBanknonpoPaymentDetail != null && vBanknonpoPaymentDetail.size() > 0) {
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
                                            <td width="23%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=banknonpoPayment.getJournalNumber()%></font></td>
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
                                            <td width="23%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=JSPFormater.formatDate(banknonpoPayment.getTransDate(), "dd/MM/yy")%></font></td>
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
                                        String amount = JSPFormater.formatNumber(banknonpoPayment.getAmount(), "#,###.##");
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
                                            <td width="33%" valign="top" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=idr%>&nbsp;<%=JSPFormater.formatNumber(banknonpoPayment.getAmount(), "#,###.##")%></font></td>
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
                <tr height="35">
                    <td class id = 'H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">No</font></td>
                    <td class id = 'H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">PERINCIAN</font></td>
                    <td class id = 'H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">No. Rekening</font></td>
                    <td class id = 'H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">JUMLAH</font></td>
                    <td class id = 'H-COLUMN' style = "border-right : dashed <%=printDesign.getBorderTitleColumn()%>px ;border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">PENJELASAN</font></td>
                </tr> 
                <tr>
                    <td colspan="5" height="2px"></td>
                </tr> 
                <%
                                        if (idxCounter % 2 != 0) {

                                            sisa = 0;

                                            for (int i = 0; i < max_limit; i++) {

                                                if (vBanknonpoPaymentDetail == null || vBanknonpoPaymentDetail.size() <= 0) {
                                                    break;
                                                }

                                                BanknonpoPaymentDetail banknonpoPaymentDetail = (BanknonpoPaymentDetail) vBanknonpoPaymentDetail.get(0);

                                                String noRek = "-";
                                                String nama = "-";
                                                String penjelasan = "&nbsp;";

                                                String strAmount = "";
                                                
                                                payment = payment + banknonpoPaymentDetail.getAmount();

                                                if (banknonpoPaymentDetail.getMemo().length() > 0) {
                                                    penjelasan = banknonpoPaymentDetail.getMemo();
                                                }

                                                Vector result = new Vector();

                                                try {
                                                    if (banknonpoPaymentDetail.getCoaId() != 0) {
                                                        result = DbCoa.getCodeCoa(banknonpoPaymentDetail.getCoaId());
                                                        noRek = "" + result.get(0);
                                                        nama = "" + result.get(1);
                                                    }
                                                } catch (Exception e) {
                                                    System.out.println("[exception] " + e.toString());
                                                }

                                                no = no + 1;

                %>                            
                <%if (i == 0) {%>
                <tr>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %>.</font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=nama.compareTo("") == 0 ? "&nbsp;" : nama %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=noRek.compareTo("") == 0 ? "&nbsp" : noRek %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="right"><font face="<%=printDesign.getFontDataDetail()%>"><%=strAmount%></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=penjelasan%></font></td>
                </tr> 
                <%} else {%>
                <tr>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %>.</font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=nama.compareTo("") == 0 ? "-" : nama %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=noRek.compareTo("") == 0 ? "&nbsp;" : noRek %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="right"><font face="<%=printDesign.getFontDataDetail()%>"><%=strAmount%></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=penjelasan%></font></td>
                </tr> 
                <%}%>
                <%

                        vBanknonpoPaymentDetail.remove(0);
                        sisa++;
                    }

                } else {
                    sisa = 0;
                    for (int i = 0; i < max_limit; i++) {
                %>        
                
                <!-----------------------Lampiran Genap --------------------------------------------->
                
                <%

                                        if (vBanknonpoPaymentDetail == null || vBanknonpoPaymentDetail.size() <= 0) {
                                            break;
                                        }
                                        BanknonpoPaymentDetail banknonpoPaymentDetail = (BanknonpoPaymentDetail) vBanknonpoPaymentDetail.get(0);

                                        String noRek = "-";
                                        String nama = "-";
                                        String penjelasan = "&nbsp;";

                                        if (banknonpoPaymentDetail.getMemo().length() > 0) {
                                            penjelasan = banknonpoPaymentDetail.getMemo();
                                        }

                                        Vector result = new Vector();

                                        String strAmount = "";

                                        payment = payment + banknonpoPaymentDetail.getAmount();

                                        try {
                                            if (banknonpoPaymentDetail.getCoaId() != 0) {
                                                result = DbCoa.getCodeCoa(banknonpoPaymentDetail.getCoaId());
                                                noRek = "" + result.get(0);
                                                nama = "" + result.get(1);
                                            }
                                        } catch (Exception e) {
                                            System.out.println("[exception] " + e.toString());
                                        }

                                        no = no + 1;

                %>
                
                <%if (i == 0) {%>
                <tr>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %>.</font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=nama.compareTo("") == 0 ? "&nbsp;" : nama %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=noRek.compareTo("") == 0 ? "&nbsp" : noRek %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="right"><font face="<%=printDesign.getFontDataDetail()%>"><%=strAmount%></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=penjelasan%></font></td>
                </tr> 
                <%} else {%>
                <tr>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=banknonpoPaymentDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %>.</font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=nama.compareTo("") == 0 ? "-" : nama %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=noRek.compareTo("") == 0 ? "&nbsp;" : noRek %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="right"><font face="<%=printDesign.getFontDataDetail()%>"><%=strAmount%></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=penjelasan%></font></td>
                </tr> 
                <%}%>
                <!-------------------------------------------------End Lampiran genap---------------------------------------------------->                
                <%
                                                vBanknonpoPaymentDetail.remove(0);
                                                sisa++;
                                            }
                                        }

                                        idxCounter++;

                %>
                
                <%
                                        if (vBanknonpoPaymentDetail != null && vBanknonpoPaymentDetail.size() > 0) {

                                            int space_1 = 0;
                                            if (sisa < max_limit) {
                                                space_1 = max_limit - sisa;
                                            }

                                            for (int sm = 0; sm < space_1; sm++) {
                %> 
                <tr height="20px">
                    <td class id='string-space'>&nbsp</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space-last'>&nbsp;</td>
                </tr>              
                <%}
                                            for (int sm = 0; sm < space_report; sm++) {%> 
                <tr height="20px">
                    <td class id='string-space'>&nbsp</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space-last'>&nbsp;</td>
                </tr>
                <%}%>    
                <tr height="20px">
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;border-bottom : dashed <%=printDesign.getBorderDataDetail()%>px ;">&nbsp;</td>
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;border-bottom : dashed <%=printDesign.getBorderDataDetail()%>px ;">&nbsp;</td>
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;border-bottom : dashed <%=printDesign.getBorderDataDetail()%>px ;">&nbsp;</td>
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;border-bottom : dashed <%=printDesign.getBorderDataDetail()%>px ;">&nbsp;</td>
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;border-bottom : dashed <%=printDesign.getBorderDataDetail()%>px ;border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;">&nbsp;</td>
                </tr> 
                <tr>
                    <td colspan="5">
                        <table width=100%>
                            <tr>
                                <td width="50%" class id = 'string-tidak-dashed'>
                                    <font face="<%=printDesign.getFontDataFooter()%>">Dicetak Tanggal <%=JSPFormater.formatDate(new Date(), "dd/MM/yy")%></font>                                            
                                </td>
                                <td width="50%" class id = 'string-tidak-dashed' align="left">
                                    <font face="<%=printDesign.getFontDataFooter()%>">Halaman <%=hal%> dari <%=max_hal%></font>
                                    <%
                                            hal++;
                                    %>
                                </td>
                            </tr>    
                        </table>        
                    </td>    
                </tr>
                <tr height="50px">
                    <td >&nbsp;</td>
                    <td >&nbsp;</td>
                    <td >&nbsp;</td>
                    <td >&nbsp;</td>
                    <td >&nbsp;</td>
                </tr> 
                <tr>
                    <td colspan="5">
                        <table width=100%>
                            <tr>
                                <td style="border-bottom: 1px solid #000;">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr> 
                <%
                                        }
                                    }
                                    int space_1 = 0;
                                    if (sisa < max_limit) {
                                        space_1 = max_limit - sisa;
                                    }
                                    for (int sm = 0; sm < space_1; sm++) {
                %> 
                <tr height="20px">
                    <td class id='string-space'>&nbsp</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space-last'>&nbsp;</td>
                </tr>
                <%}
                                    for (int sm = 0; sm < space_report; sm++) {
                %> 
                <tr height="20px">
                    <td class id='string-space'>&nbsp</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space'>&nbsp;</td>
                    <td class id='string-space-last'>&nbsp;</td>
                </tr>
                <%}%>
                <tr height="20px">
                    <td class id='string-isi-tabel-second-last'>&nbsp;</td>
                    <td class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                    <td class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                    <td class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                    <td class id='string-garis-atas-kiri-kanan-center-top-second-last'>&nbsp;</td>
                </tr> 
                <%
                }
            } catch (Exception E) {
                System.out.println("[exception] " + E.toString());
            }
                %>
                <tr>
                    <td colspan="5" height="2px"></td>
                </tr>
                <tr height="35">
                    <td colspan="3" class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataTotal()%>px ;border-bottom : dashed <%=printDesign.getBorderDataTotal()%>px ;border-top : dashed <%=printDesign.getBorderDataTotal()%>px ;" align="center"><font face="<%=printDesign.getFontDataTotal()%>">T O T A L</font></td>
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataTotal()%>px ;border-bottom : dashed <%=printDesign.getBorderDataTotal()%>px ;border-top : dashed <%=printDesign.getBorderDataTotal()%>px ;" align="right"><font face="<%=printDesign.getFontDataTotal()%>"><%=JSPFormater.formatNumber(payment, "#,###.##")%></font></td>
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataTotal()%>px ;border-bottom : dashed <%=printDesign.getBorderDataTotal()%>px ;border-top : dashed <%=printDesign.getBorderDataTotal()%>px ;border-right : dashed <%=printDesign.getBorderDataTotal()%>px ;">&nbsp;</td>  
                </tr> 
                <tr>
                    <td colspan="5">                        
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <%
            String nama_1 = ""; String nama_2 = ""; String nama_3 = ""; String nama_4 = ""; String nama_5 = ""; String nama_6 = ""; String nama_7 = ""; String nama_8 = "";

            String ket_1 = "&nbsp;";String ket_2 = "&nbsp;";String ket_3 = "&nbsp;";String ket_4 = "&nbsp;"; String ket_5 = "&nbsp;";String ket_6 = "&nbsp;";String ket_7 = "&nbsp;";String ket_8 = "&nbsp;";

            String ketFoot_1 = "&nbsp;"; String ketFoot_2 = "&nbsp;"; String ketFoot_3 = "&nbsp;"; String ketFoot_4 = "&nbsp;"; String ketFoot_5 = "&nbsp;"; String ketFoot_6 = "&nbsp;"; String ketFoot_7 = "&nbsp;";String ketFoot_8 = "&nbsp;";

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
                            <%   
                            int pages = 0;                            
                            int totDatas = tmpBanknonpoPaymentDetail.size();                            
                            pages = totDatas/max_limit;                            
                            int sisa = totDatas % max_limit;                            
                            if(sisa > 0){
                                pages = pages +1;
                            }
                            
                            int maxPage = 0;
                            int sisaMax = 0;
                            maxPage = pages/max_print;
                            sisaMax = pages%max_print;
                            if(sisaMax > 0){
                                maxPage = maxPage+1;
                            }
                            %>
                            <tr>
                                <td colspan="5" align="center">
                                 <%for(int i = 0; i < maxPage ; i++){ %>
                                 
                                 <%
                                 String idx = "";
                                 if(i!=0){
                                 %>
                                  |     
                                 <%}%>
                                 <%
                                 
                                 int last = 0;
                                 if(i == (maxPage-1)){
                                     last=1;
                                 }
                                 int start = i+1;
                                 int end = i+max_print;
                                 idx = ""+start+" - "+end;

                                 out.print("<a href=\"../freport/banknonpo_print.jsp?banknonpoPayment_id=" + banknonpoPayment.getOID() + "&idPage="+i+"&lastPg="+last+"&max="+max_hal+"&payment="+payment+"\" target='_blank'>page "+idx+"</a>");
                                 %>
                                <%}%>   
                                </td>                                            
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