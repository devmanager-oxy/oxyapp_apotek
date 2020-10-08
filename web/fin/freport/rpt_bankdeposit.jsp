
<%-- 
    Document   : rpt_bankdeposit
    Created on : Jun 21, 2011, 4:33:48 PM
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
<%@ page import = "com.project.crm.transaction.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.crm.session.*" %>
<%@ page import = "com.project.crm.report.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<style>
    #bukti{
        font-family: arial; font-size: 26px; line-height: 18px; color: #1D1C1B; font-weight: bold;
    }
    
    #main{
        font-family: 'Courier New', Courier, monospace; font-size: 22px; line-height: 18px; color: #1D1C1B; padding-top:5px; padding-bottom:5px;
    }
    
    #b-horizontal{
        border-bottom: dashed 1px;  font-family: 'Courier New', Courier, monospace; font-size: 22px; color: #1D1C1B;
    }
    
    #H-COLUMN{ padding-bottom:5px;padding-top:5px; line-height:16px; color: #1D1C1B; vertical-align : middle; font-size: 20px;}
    
    #D-FIRST-LEFT{ padding-right:5px;padding-left:5px;padding-bottom:5px;padding-top:5px; line-height:16px; color: #1D1C1B; vertical-align : top; font-size: 20px;}
    
    #string-space{
        border-left: dashed 1px; color: #1D1C1B; font-family: 'Courier New', Courier, monospace; font-size: 22px;
    }
    
    #string-tidak-dashed{
        line-height:18px;  color: #1D1C1B; font-family: 'Courier New', Courier, monospace; font-size: 22px;
    }
    
    #string-space-last{
        border-left: dashed 1px; border-right: dashed 1px; color: #1D1C1B; font-family: 'Courier New', Courier, monospace; font-size: 18px;
    }
    
    #string-dashed-H-COLUMN{ padding-bottom:3px; line-height:16px; color: #1D1C1B; padding-right:10px; padding-left:10px; vertical-align : middle; font-size: 22px;}
    
    #string-isi-tabel-second-last{
        font-family:'Courier New', Courier, monospace; border-left : dashed 1px; border-bottom : dashed 1px; padding-bottom:3px; padding-top:3px;
        font-size: 14px; line-height:16px; color: #1D1C1B;text-align: center;vertical-align: top;
    }
    
    #string-garis-atas-kiri-padding-left-top-second-last{
        font-family:'Courier New', Courier, monospace; border-left : dashed 1px; border-bottom : dashed 1px; padding-bottom:3px;
        font-size: 14px; line-height:16px; color: #1D1C1B;padding-left:10px; padding-right:10px; vertical-align: top;padding-top:3px;
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
        font-family:'Courier New', Courier, monospace; border-left: dashed 1px; border-right: dashed 1px; padding-bottom:3px; font-size: 14px; line-height:16px;  color: #9A958F;vertical-align: top;
        padding-top:10px; padding-left:10px; padding-right:10px;
    }
    
    
    #string-garis-kiri-kanan-center{
        font-family:'Courier New', Courier, monospace; border-left : dashed 1px; border-right : dashed 1px; border-bottom : dashed 1px; padding-bottom:3px; font-size: 14px; line-height:16px;  color: #9A958F;
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
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif; font-size: 12px; line-height: 18px; font-weight: bold; color: #000; text-align: center;
    }
    #strong{
        font-family: Trebuchet MS, Arial, Tahoma, Verdana, Helvetica, sans-serif; font-size: 12px; line-height: 18px; font-weight: bold; color: #000; text-align: left;
    }
    </style>
<%

            long bankdeposit_id = Long.parseLong(request.getParameter("bankdeposit_id"));

            BankDeposit bankDeposit = new BankDeposit();
            String company = "";
            String address = "";
            String Header = "";

            try {
                bankDeposit = DbBankDeposit.fetchExc(bankdeposit_id);
            } catch (Exception e) {
                System.out.println("Exception " + e.toString());
            }

            String whereClause = DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID] + "=" + bankDeposit.getOID();

            Vector vbankDepositDetail = DbBankDepositDetail.list(0, 0, whereClause, null);
            Vector tmpBankDepositDetail = DbBankDepositDetail.list(0, 0, whereClause, null);

            String cst = "";

            if(bankDeposit.getReceiveFrom().length() > 0){
                cst = bankDeposit.getReceiveFrom();
            }else{            
                try {
                    Customer cust = DbCustomer.fetchExc(bankDeposit.getCustomerId());
                    cst = cust.getName();
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }

            int val_periode = bankDeposit.getTransDate().getMonth() + 1;

            String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");

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

            int space_report = 0;

            try {
                space_report = Integer.parseInt(DbSystemProperty.getValueByName("SPACE_REPORT_BKM"));
            } catch (Exception e) {
                System.out.println("[exc] " + e.toString());
            }

            try {
                Header = DbSystemProperty.getValueByName("HEADER_BKM");
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            PrintDesign printDesign = new PrintDesign();

            try {
                printDesign = DbPrintDesign.getDesign(DbPrintDesign.colNamesDocument[DbPrintDesign.DOCUMENT_BKM]);
            } catch (Exception e) {
                System.out.println("exception " + e.toString());
            }

%>

<table align="center" width="<%=printDesign.getWidthPrint()%>" border="0">
    <tr>
        <td colspan="3" height="5"></td>    
    </tr>
    <tr>
        <td width="100%" colspan="3">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="5" height="2px"></td>
                </tr> 
                <%
            int max_limit = 0;

            int max_print = 0;

            int useMaxPrint = 0;

            try {
                max_limit = Integer.parseInt(DbSystemProperty.getValueByName("MAX_LIMIT_ONE_PAGE_BKM"));
            } catch (Exception E) {
            }

            try {
                useMaxPrint = Integer.parseInt(DbSystemProperty.getValueByName("USE_MAX_PRINT_PAGE_BKK"));
            } catch (Exception E) {
                useMaxPrint = 0;
            }

            try {
                max_print = Integer.parseInt(DbSystemProperty.getValueByName("MAX_PRINT_PAGE_BKK"));
            } catch (Exception E) {
            }

            double payment = 0;
            int no = 0;
            int hal = 1;
            int max_hal = 0;

            if (vbankDepositDetail != null && vbankDepositDetail.size() > 0) {

                int idxCounter = 0;

                max_hal = vbankDepositDetail.size() / max_limit;

                if (vbankDepositDetail.size() % max_limit != 0) {
                    max_hal = max_hal + 1;
                }

                idxCounter = 0;

                int sisa = 0;

                while (vbankDepositDetail != null && vbankDepositDetail.size() > 0) {

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
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class id = 'main' style = "border-bottom : dashed <%=printDesign.getBorderDataDetail()%>px ;">
                                                <font face="<%=printDesign.getFontHeader()%>"><%=company%></font>
                                            </td>  
                                        </tr>      
                                    </table>           
                                </td>
                                <td width="35%" colspan="2" align="center">
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
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >P E N E R I M A A N</font></td>
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
                                            <td width="35%">&nbsp;</td>    
                                            <td width="12%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >No. BKM</font></td>                                                
                                            <td width="2%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="23%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=bankDeposit.getJournalNumber()%></font></td>
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
                                            <td width="26%">&nbsp;</td>
                                            <td width="2%">&nbsp;</td>    
                                            <td width="35%">&nbsp;</td>    
                                            <td width="12%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >Tanggal</font></td>
                                            <td width="2%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="23%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=JSPFormater.formatDate(bankDeposit.getTransDate(), "dd/MM/yy")%></font></td>
                                        </tr>    
                                    </table>
                                </td>
                            </tr>                               
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top" class id='main'><font face="<%=printDesign.getFontDataMain()%>" >Diterima dari</font></td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="35%" valign="top" class id = 'main' ><font face="<%=printDesign.getFontDataMain()%>" ><%=cst%></font></td>
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
                                            <td width="35%">&nbsp;</td>    
                                            <td width="12%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >Periode</font></td>
                                            <td width="2%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="23%" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=val_periode%></font></td>
                                        </tr>    
                                    </table>
                                </td>
                            </tr> 
                            <%
                        NumberSpeller numberSpeller = new NumberSpeller();
                        String amount = JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##");
                            %>   
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top">
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="85" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >Jumlah</font></td>
                                                        <td class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >dgn. angka</font></td>
                                                    </tr>    
                                                </table>
                                            </td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>">:</font></td>
                                            <td width="35%" valign="top" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=idr%>&nbsp;<%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%></font></td>
                                            <td width="12%" >&nbsp;</td> 
                                            <td width="2%" >&nbsp;</td> 
                                            <td width="23%" >&nbsp;</td> 
                                        </tr>    
                                    </table>
                                </td>
                            </tr>                             
                            <tr>                
                                <td colspan="3">&nbsp;</td>
                            </tr>
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td width="85" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >&nbsp;</font></td>
                                                        <td class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >dgn. huruf</font></td>
                                                    </tr>                                                             
                                                </table>
                                            </td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>">:</font></td>
                                            <td colspan="4" width="72" valign="top" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" ><%=numberSpeller.spellNumberToIna(Double.parseDouble(amount.replaceAll(",", ""))) + " Rupiah"%></font></td>                                            
                                        </tr>    
                                    </table>
                                </td>
                            </tr> 
                            <tr>                
                                <td colspan="3">&nbsp;</td>                                
                            </tr>
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top" class id='main'><font face="<%=printDesign.getFontDataMain()%>" >Terima berupa</font></td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >:</font></td>
                                            <td width="35%" valign="top" class id = 'main' ><font face="<%=printDesign.getFontDataMain()%>" >No Cek</font></td>
                                            <td width="12%" >&nbsp;</td> 
                                            <td width="2%" >&nbsp;</td> 
                                            <td width="23%" >&nbsp;</td> 
                                        </tr>    
                                    </table>
                                </td>
                            </tr>                             
                            <tr>                
                                <td colspan="3">&nbsp;</td>                                
                            </tr>
                            <tr>                
                                <td colspan="3">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">  
                                        <tr>
                                            <td width="26%" valign="top" class id='main'><font face="<%=printDesign.getFontDataMain()%>" >&nbsp;</font></td>
                                            <td width="2%" valign="top" align="center" class id = 'main'><font face="<%=printDesign.getFontDataMain()%>" >&nbsp;</font></td>
                                            <td width="35%" valign="top" class id = 'main' ><font face="<%=printDesign.getFontDataMain()%>" >Cash</font></td>
                                            <td width="12%" >&nbsp;</td> 
                                            <td width="2%" >&nbsp;</td> 
                                            <td width="23%" >&nbsp;</td> 
                                        </tr>    
                                    </table>
                                </td>
                            </tr>  
                            <tr height="30" colspan="3">                
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
                    <td class id = 'H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">P E R I N C I A N</font></td>
                    <td class id = 'H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">No. Rekening</font></td>
                    <td class id = 'H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">J U M L A H</font></td>
                    <td class id = 'H-COLUMN' style = "border-right : dashed <%=printDesign.getBorderTitleColumn()%>px ;border-left : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-top : dashed <%=printDesign.getBorderTitleColumn()%>px ; border-bottom : dashed <%=printDesign.getBorderTitleColumn()%>px" align="center"><font face="<%=printDesign.getFontTitleColumn()%>">P E N J E L A S A N</font></td>
                </tr> 
                <tr>
                    <td colspan="5" height="2px"></td>
                </tr> 
                <%
                        if (idxCounter % 2 != 0) {
                            sisa = 0;
                            for (int i = 0; i < max_limit; i++) {

                                if (vbankDepositDetail == null || vbankDepositDetail.size() <= 0) {
                                    break;
                                }

                                BankDepositDetail bankDepositDetail = (BankDepositDetail) vbankDepositDetail.get(0);

                                String noRek = "-";
                                String nama = "-";
                                String penjelasan = "&nbsp";

                                if (bankDepositDetail.getMemo().length() > 0) {
                                    penjelasan = bankDepositDetail.getMemo();
                                }

                                Vector result = new Vector();

                                String strAmount = "";

                                if (bankDepositDetail.getAmount() == 0) {
                                    strAmount = "(" + JSPFormater.formatNumber(bankDepositDetail.getCreditAmount(), "#,###.##") + ")";
                                    payment = payment - bankDepositDetail.getCreditAmount();
                                } else {
                                    strAmount = JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##");
                                    payment = payment + bankDepositDetail.getAmount();
                                }

                                try {
                                    if (bankDepositDetail.getCoaId() != 0) {
                                        result = DbCashReceiveDetail.getCodeCoa(bankDepositDetail.getCoaId());
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
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=bankDepositDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %>.</font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=nama.compareTo("") == 0 ? "&nbsp;" : nama %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=noRek.compareTo("") == 0 ? "&nbsp" : noRek %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="right"><font face="<%=printDesign.getFontDataDetail()%>"><%=strAmount%></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=penjelasan%></font></td>
                </tr> 
                <%} else {%>
                <tr>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=bankDepositDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %>.</font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=nama.compareTo("") == 0 ? "-" : nama %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=noRek.compareTo("") == 0 ? "&nbsp;" : noRek %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="right"><font face="<%=printDesign.getFontDataDetail()%>"><%=strAmount%></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=penjelasan%></font></td>
                </tr> 
                <%}%>
                <%
                        vbankDepositDetail.remove(0);
                        sisa++;
                    }
                } else {
                    sisa = 0;
                    for (int i = 0; i < max_limit; i++) {
                %>        
                <!-----------------------Lampiran Genap --------------------------------------------->
                <%
                if (vbankDepositDetail == null || vbankDepositDetail.size() <= 0) {
                    break;
                }

                BankDepositDetail bankDepositDetail = (BankDepositDetail) vbankDepositDetail.get(0);

                String noRek = "-";
                String nama = "-";
                String penjelasan = "&nbsp;";

                if (bankDepositDetail.getMemo().length() > 0) {
                    penjelasan = bankDepositDetail.getMemo();
                }

                Vector result = new Vector();

                String strAmount = "";

                if (bankDepositDetail.getAmount() == 0) {
                    strAmount = "(" + JSPFormater.formatNumber(bankDepositDetail.getCreditAmount(), "#,###.##") + ")";
                    payment = payment - bankDepositDetail.getCreditAmount();
                } else {
                    strAmount = JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##");
                    payment = payment + bankDepositDetail.getAmount();
                }

                try {
                    if (bankDepositDetail.getCoaId() != 0) {
                        result = DbBankDepositDetail.getCodeCoa(bankDepositDetail.getCoaId());
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
                <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=bankDepositDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %>.</font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=nama.compareTo("") == 0 ? "&nbsp;" : nama %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=noRek.compareTo("") == 0 ? "&nbsp" : noRek %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="right"><font face="<%=printDesign.getFontDataDetail()%>"><%=strAmount%></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "padding-top:15px; border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;border-left : dashed <%=printDesign.getBorderDataDetail()%>px ; border-top : dashed <%=printDesign.getBorderDataDetail()%>px;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=penjelasan%></font></td>
                </tr> 
                <%} else {%>
                <tr>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=bankDepositDetail.getMemo().compareTo("") == 0 && JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##").compareTo("") == 0 ? "&nbsp" : "" + no %>.</font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=nama.compareTo("") == 0 ? "-" : nama %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="center"><font face="<%=printDesign.getFontDataDetail()%>"><%=noRek.compareTo("") == 0 ? "&nbsp;" : noRek %></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="right"><font face="<%=printDesign.getFontDataDetail()%>"><%=strAmount%></font></td>
                    <td class id = 'D-FIRST-LEFT' style = "border-right : dashed <%=printDesign.getBorderDataDetail()%>px ;border-left : dashed <%=printDesign.getBorderDataDetail()%>px ;" align="left"><font face="<%=printDesign.getFontDataDetail()%>"><%=penjelasan%></font></td>
                </tr> 
                <%}%>
                <!-------------------------------------------------End Lampiran genap---------------------------------------------------->
                <%
                                vbankDepositDetail.remove(0);
                                sisa++;
                            }
                        }
                        idxCounter++;
                %>                
                <%
                        if (vbankDepositDetail != null && vbankDepositDetail.size() > 0) {
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
                %>
                <tr>
                    <td colspan="5" height="2px"></td>
                </tr>
                <tr height="35">
                    <td colspan="3" class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataTotal()%>px ;border-bottom : dashed <%=printDesign.getBorderDataTotal()%>px ;border-top : dashed <%=printDesign.getBorderDataTotal()%>px ;" align="center"><font face="<%=printDesign.getFontDataTotal()%>">T O T A L</font></td>
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataTotal()%>px ;border-bottom : dashed <%=printDesign.getBorderDataTotal()%>px ;border-top : dashed <%=printDesign.getBorderDataTotal()%>px ;" align="right"><font face="<%=printDesign.getFontDataTotal()%>"><%=JSPFormater.formatNumber(payment, "#,###.##")%></font></td>
                    <td class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataTotal()%>px ;border-bottom : dashed <%=printDesign.getBorderDataTotal()%>px ;border-top : dashed <%=printDesign.getBorderDataTotal()%>px ;border-right : dashed <%=printDesign.getBorderDataTotal()%>px ;">&nbsp;</td>  
                </tr> 
            </table>       
        </td>
    </tr>     
    <tr>
        <td colspan="3">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="4">
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
                Approval approval_1 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKM, DbApproval.URUTAN_1);
                try {
                    Employee employee = DbEmployee.fetchExc(approval_1.getEmployeeId());
                    nama_1 = employee.getName();
                } catch (Exception e) {
                }
                ket_1 = approval_1.getKeterangan();
                ketFoot_1 = approval_1.getKeteranganFooter();
            } catch (Exception E) {
                System.out.println("[exception] " + E.toString());
            }

            try {
                Approval approval_2 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKM, DbApproval.URUTAN_2);
                try {
                    Employee employee = DbEmployee.fetchExc(approval_2.getEmployeeId());
                    nama_2 = employee.getName();
                } catch (Exception e) {
                }
                ket_2 = approval_2.getKeterangan();
                ketFoot_2 = approval_2.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_3 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKM, DbApproval.URUTAN_3);
                try {
                    Employee employee = DbEmployee.fetchExc(approval_3.getEmployeeId());
                    nama_3 = employee.getName();
                } catch (Exception e) {
                }
                ket_3 = approval_3.getKeterangan();
                ketFoot_3 = approval_3.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_4 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKM, DbApproval.URUTAN_4);
                try {
                    Employee employee = DbEmployee.fetchExc(approval_4.getEmployeeId());
                    nama_4 = employee.getName();
                } catch (Exception e) {
                }
                ket_4 = approval_4.getKeterangan();
                ketFoot_4 = approval_4.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_5 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKM, DbApproval.URUTAN_5);
                try {
                    Employee employee = DbEmployee.fetchExc(approval_5.getEmployeeId());
                    nama_5 = employee.getName();
                } catch (Exception e) {
                }
                ket_5 = approval_5.getKeterangan();
                ketFoot_5 = approval_5.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_6 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKM, DbApproval.URUTAN_6);
                try {
                    Employee employee = DbEmployee.fetchExc(approval_6.getEmployeeId());
                    nama_6 = employee.getName();
                } catch (Exception e) {
                }
                ket_6 = approval_6.getKeterangan();
                ketFoot_6 = approval_6.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_7 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKM, DbApproval.URUTAN_7);
                try {
                    Employee employee = DbEmployee.fetchExc(approval_7.getEmployeeId());
                    nama_7 = employee.getName();
                } catch (Exception e) {
                }
                ket_7 = approval_7.getKeterangan();
                ketFoot_7 = approval_7.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            try {
                Approval approval_8 = DbApproval.getListApproval(I_Project.TYPE_APPROVAL_BKM, DbApproval.URUTAN_8);
                try {
                    Employee employee = DbEmployee.fetchExc(approval_8.getEmployeeId());
                    nama_8 = employee.getName();
                } catch (Exception e) {
                }
                ket_8 = approval_8.getKeterangan();
                ketFoot_8 = approval_8.getKeteranganFooter();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }
                            %>
                            <tr height="120px">
                                <td width="50%" class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataApproval()%>px ;border-bottom : dashed <%=printDesign.getBorderDataApproval()%>px;">
                                    <table align="center">
                                        <tr>
                                            <td class id = 'string-tidak-dashed' align="center"><font face="<%=printDesign.getFontDataApproval()%>"><%=ket_1 == null ? "&nbsp" : ket_1 %>,&nbsp;Tgl &nbsp&nbsp&nbsp&nbsp/&nbsp&nbsp&nbsp&nbsp;/20</font></td>       
                                        </tr>
                                        <tr>
                                            <td height="120">&nbsp;</td>       
                                        </tr>
                                    </table>
                                </td>                                            
                                <td width="50%" class id = 'string-dashed-H-COLUMN' style = "border-left : dashed <%=printDesign.getBorderDataApproval()%>px ;border-bottom : dashed <%=printDesign.getBorderDataApproval()%>px;border-right : dashed <%=printDesign.getBorderDataApproval()%>px;">
                                    <table align="center">
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
                                <td colspan = "2">
                                    <table width=100%>
                                        <tr>
                                            <td width="50%" class id = 'string-tidak-dashed'>
                                                <font size="<%=printDesign.getSizeFontDataFooter()%>" face="<%=printDesign.getFontDataFooter()%>">Dicetak Tanggal <%=JSPFormater.formatDate(new Date(), "dd/MM/yy")%></font>                                            
                                            </td>
                                            <td width="50%" class id = 'string-tidak-dashed' align="left">
                                                <font size="<%=printDesign.getSizeFontDataFooter()%>" face="<%=printDesign.getFontDataFooter()%>">Halaman <%=hal%> dari <%=max_hal%></font>
                                            </td>
                                        </tr>    
                                    </table>  
                                </td>
                            </tr> 
                            
                            <tr>
                                <td height="20px" colspan = "2">&nbsp;</td>
                            </tr>    
                            <%
            int pages = 0;
            int totDatas = tmpBankDepositDetail.size();
            pages = totDatas / max_limit;
            int sisa = totDatas % max_limit;
            if (sisa > 0) {
                pages = pages + 1;
            }

            int maxPage = 0;
            int sisaMax = 0;
            maxPage = pages / max_print;
            sisaMax = pages % max_print;
            if (sisaMax > 0) {
                maxPage = maxPage + 1;
            }
                            %>
                            <tr>
                                <td colspan="5" align="center">
                                    <%for (int i = 0; i < maxPage; i++) {%>
                                    
                                    <%
    String idx = "";
    if (i != 0) {
                                    %>
                                    |     
                                    <%}%>
                                    <%

    int last = 0;
    if (i == (maxPage - 1)) {
        last = 1;
    }
    int start = i + 1;
    int end = i + max_print;
    idx = "" + start + " - " + end;

    out.print("<a href=\"../freport/rpt_bankdeposit_print.jsp?bankdeposit_id=" + bankDeposit.getOID() + "&idPage=" + i + "&lastPg=" + last + "&max=" + max_hal + "&payment=" + payment + "\" target='_blank'>page " + idx + "</a>");
                                    %>
                                    <%}%>   
                                </td>                                            
                            </tr>       
                            <%if (false) {%>
                            <tr>
                                <td colspan="6" align="center">
                                    <%
    out.print("<a href=\"../freport/rpt_bankdeposit_print.jsp?bankdeposit_id=" + bankDeposit.getOID() + "\" target='_blank'><img src=\"../images/print.gif\" name=\"delete\" height=\"22\" border=\"0\"></a></td>");                                   
                                    %>
                                </td>                                            
                            </tr>
                            <%}%>
                        </table>    
                    </td>
                </tr>
            </table>
        </td>    
        <td width="5%">&nbsp;</td>
    </tr>
</table>