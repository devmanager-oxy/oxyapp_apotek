
<%-- 
    Document   : rpt_bankppayment
    Created on : Dec 30, 2011, 10:12:25 AM
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
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>

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
<%

            
            
            long bankpopayment_id = Long.parseLong(request.getParameter("bankpopayment_id"));
            
            BankpoPayment bankpoPayment = new BankpoPayment();
            
            try{
                bankpoPayment = DbBankpoPayment.fetchExc(bankpopayment_id);
            }catch(Exception e){
                System.out.println("Exception "+e.toString());
            }
            
            String whereClause = DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+"="+bankpoPayment.getOID();
            
            Vector vbankpoPaymentDetail = DbBankpoPaymentDetail.list(0, 0, whereClause, null);
            
            String cst = "";
            
            try{
                Customer cust = DbCustomer.fetchExc(bankpoPayment.getCustomerId());
                cst = cust.getName();
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }
            
            int val_periode = bankpoPayment.getTransDate().getMonth()+1;
            
            String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
          
            String Header = "";

            try {
                Header = DbSystemProperty.getValueByName("HEADER_BKK");
            } catch (Exception e) {
                System.out.println("[exception] "+e.toString());
            }

%>
<table align="center" width="900px" border="0">
    <tr>
        <td width="44%" ><font class id = 'string-putus'><%=Header%></font></td>
        <td width="5%">&nbsp</td>
        <td width="51%">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="25%">&nbsp;</td>
                    <td><font class id = 'string-tidak-putus-2'>No. BKK : <%=bankpoPayment.getJournalNumber()%></font></td>
                </tr>   
            </table> 
        </td>    
    </tr>         
    <tr>                
        <td width="45%">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td width="28%" valign="top"><font class id = 'string-tidak-putus'>Dibayarkan Kepada</font></td>
                <td width="4%" valign="top" align="center"><font class id = 'string-tidak-putus'>:</font></td>
                <td width="68%" valign="top"><font class id = 'string-tidak-putus'><%=cst%></font></td>
            </tr>
        </table>    
        <td width="5%">&nbsp</td>
        <td width="50%">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="25%">&nbsp;</td>
                    <td><font class id = 'string-tidak-putus-2'>Tanggal : <%=JSPFormater.formatDate(bankpoPayment.getTransDate(), "dd/MM/yy")%></font></td>
                </tr>   
            </table> 
        </td>
    </tr>    
    <%
            NumberSpeller numberSpeller = new NumberSpeller();
            String amount = JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##");
    %>            
    <tr>                
        <td width="50%">
            <table width="100%" border ="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="28%" valign="top"><font class id = 'string-tidak-putus'>Jumlah</font></td>
                    <td width="4%" valign="top" align="center"><font class id = 'string-tidak-putus'>:</font></td>
                    <td width="68%" valign="top"><font class id = 'string-tidak-putus'><%=idr%>&nbsp;<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%> (<%=numberSpeller.spellNumberToIna(Double.parseDouble(amount.replaceAll(",", ""))) + " Rupiah"%>)</font></td>
                </tr>
            </table>    
        </td>
        <td width="5%">&nbsp</td>
        <td width="50%" align="left" valign="top">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="25%">&nbsp;</td>
                    <td ><font class id = 'string-tidak-putus-2'>Periode : <%=val_periode%></font></td>
                </tr>   
            </table> 
        </td>
    </tr>
    <tr>
        <td width="100%" colspan="3">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>                          
                    <td width = "100%">
                        <table width = "240px" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                            <td width="129px"><font class id = 'string-tidak-putus-2'>Dibayar dengan</font></td>
                            <td width="1px"><font class id = 'string-tidak-putus-2'>:</font></td>
                            <td ><font class id = 'string-tidak-putus-2'>&nbsp;Cash</font></td>
                            <tr>
                        </table>
                    </td>
                </tr>
            </table>   
        </td>    
    </tr>
    <tr>
        <td width="100%" colspan="3" height="5px"></td>    
    </tr>
    <tr>
        <td width="100%" colspan="3">
            
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="4" class id='string-garis-bawah-putus' height="5px">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4" height="2px"></td>
                </tr> 
            
            <%
            int max_limit = 0;
            try{
                max_limit = Integer.parseInt(DbSystemProperty.getValueByName("MAX_LIMIT_ONE_PAGE_BKK"));
            }catch(Exception E){
                
            }
            double payment = 0;            
            int no = 0;
            int hal = 1;
            int max_hal = 0;
            
            try{
                
            if (vbankpoPaymentDetail != null && vbankpoPaymentDetail.size() > 0){

                int idxCounter = 0;
                
                max_hal = vbankpoPaymentDetail.size()/max_limit;
                
                if(vbankpoPaymentDetail.size() % max_limit != 0){
                    max_hal = max_hal + 1;
                }
                
                idxCounter = 0;
                
                while(vbankpoPaymentDetail != null && vbankpoPaymentDetail.size() > 0){
                    
                    if(idxCounter != 0){

            %>
                <tr height="70px">
                    <td width="10%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                </tr> 
            <% } %>
                <tr>
                    <td width="10%" class id='string-garis-atas-kiri-center'>No</td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left'>P E R I N C I A N</td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left'>No. Rekening</td>
                    <td width="30%" class id='string-garis-atas-kiri-kanan-center'>J U M L A H</td>
                </tr> 
                <tr>
                    <td colspan="4" height="2px"></td>
                </tr> 
                <%

                    if (idxCounter % 2 != 0){

                        for (int i = 0; i < max_limit; i++) {

                            if (vbankpoPaymentDetail == null || vbankpoPaymentDetail.size() <= 0) {
                                break;
                            }

                            BankpoPaymentDetail bankpoPaymentDetail = (BankpoPaymentDetail) vbankpoPaymentDetail.get(0);

                            String noRek = "-";
                            String nama = "-";
                            
                            if(bankpoPaymentDetail.getInvoiceId() != 0){                                
                                try{
                                    
                                    Receive receive = DbReceive.fetchExc(bankpoPaymentDetail.getInvoiceId()); 
                                    
                                    if(receive.getUnitUsahaId() != 0){
                                        
                                        Vendor vendor = new Vendor();

                                        try {
                                                vendor = DbVendor.fetchExc(receive.getVendorId());
                                        } catch (Exception e) {
                                                System.out.println("[exception] " + e.toString());
                                        }
                                        //UnitUsaha unitUsaha = DbUnitUsaha.fetchExc(receive.getUnitUsahaId());
                                        nama = vendor.getName();
                                    }
                                    
                                }catch(Exception E){
                                    System.out.println("[exception] "+E.toString());
                                }                                
                            }
                            
                            
                            /*
                            
                            try {
                                if (pettycashPaymentDetail.getCoaId() != 0) {
                                    result = DbCoa.getCodeCoa(pettycashPaymentDetail.getCoaId());
                                    noRek = "" + result.get(0);
                                    nama = "" + result.get(1);
                                }
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                            */
                            payment = payment + bankpoPaymentDetail.getPaymentAmount();

                            no = no + 1;

                %>                            
                <%if (i == 0) {%>
                <tr>
                    <td width="10%" class id='string-isi-tabel-first'><%=no%></td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-first'><%=nama%></td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-first'><%=noRek%></td>
                    <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-first' ><%=JSPFormater.formatNumber(bankpoPaymentDetail.getPaymentAmount(), "#,###.##")%></td>
                </tr> 
                <%} else {%>
                <tr>
                    <td width="10%" class id='string-isi-tabel-second'><%=no%></td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second'><%=nama%></td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second'><%=noRek%></td>
                    <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-second' ><%=JSPFormater.formatNumber(bankpoPaymentDetail.getPaymentAmount(), "#,###.##")%></td>
                </tr> 
                <%}%>
                <%

                              vbankpoPaymentDetail.remove(0);
                          }
                
                      } else {
                
                          for (int i = 0; i < max_limit; i++) {
                %>        
                
                <!-----------------------Lampiran Genap --------------------------------------------->
                
                <%

                    if (vbankpoPaymentDetail == null || vbankpoPaymentDetail.size() <= 0){
                        break;
                    }

                    BankpoPaymentDetail bankpoPaymentDetail = (BankpoPaymentDetail)vbankpoPaymentDetail.get(0);

                    String noRek = "-";
                    String nama = "-";

                    if(bankpoPaymentDetail.getInvoiceId() != 0){                                
                        try{                                    
                            Receive receive = DbReceive.fetchExc(bankpoPaymentDetail.getInvoiceId()); 
                                    
                            if(receive.getUnitUsahaId() != 0){
                                
                                Vendor vendor = new Vendor();

                                try {
                                    vendor = DbVendor.fetchExc(receive.getVendorId());
                                } catch (Exception e) {
                                    System.out.println("[exception] " + e.toString());
                                }
                                //UnitUsaha unitUsaha = DbUnitUsaha.fetchExc(receive.getUnitUsahaId());
                                nama = vendor.getName();
                            }
                                    
                        }catch(Exception E){
                            System.out.println("[exception] "+E.toString());
                        }
                    }
                    
                    /*
                    try {
                        if (pettycashPaymentDetail.getCoaId() != 0) {
                            result = DbCoa.getCodeCoa(pettycashPaymentDetail.getCoaId());
                            noRek = "" + result.get(0);
                            nama = "" + result.get(1);
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                    */
                    payment = payment + bankpoPaymentDetail.getPaymentAmount();

                    no = no + 1;

                %>
                
                <%if (i == 0){%>
                <tr>
                    <td width="10%" class id='string-isi-tabel-first'><%=no%></td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-first'><%=nama%></td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-first'><%=noRek%></td>
                    <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-first' ><%=JSPFormater.formatNumber(bankpoPaymentDetail.getPaymentAmount(), "#,###.##")%></td>
                </tr> 
                <%} else {%>
                <tr>
                    <td width="10%" class id='string-isi-tabel-second'><%=no%></td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second'><%=nama%></td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second'><%=noRek%></td>
                    <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-second' ><%=JSPFormater.formatNumber(bankpoPaymentDetail.getPaymentAmount(), "#,###.##")%></td>
                </tr>  
                <%}%>
                <!-------------------------------------------------End Lampiran genap---------------------------------------------------->
                
                <%
                            vbankpoPaymentDetail.remove(0);
                        }
                    }
                    
                    idxCounter++;
                
                %>
                
                <% 
                if(vbankpoPaymentDetail != null && vbankpoPaymentDetail.size() > 0 ){
                %>
                <tr height="20px">
                    <td width="10%" class id='string-isi-tabel-second-last'>&nbsp;</td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                    <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-second-last'>&nbsp;</td>
                </tr> 
                <tr>
                    <td colspan="6">
                        <table width=100%>
                            <tr>
                                <td width="50%">
                                    <font class id = 'string-tidak-putus-2'>Dicetak Tanggal <%=JSPFormater.formatDate(new Date(), "dd/MM/yy")%></font>                                            
                                </td>
                                <td width="50%" align="left">
                                    <font class id = 'string-tidak-putus-2'>Halaman <%=hal%> dari <%=max_hal%></font>
                                    <%
                                    hal++;
                                    %>
                                </td>
                            </tr>    
                        </table>        
                    </td>    
                </tr>
                <tr height="50px">
                    <td width="10%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                </tr> 
                <tr>
                    <td colspan="4">
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
                %>    
                <tr height="20px">
                    <td width="10%" class id='string-isi-tabel-second-last'>&nbsp;</td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                    <td width="30%" class id='string-garis-atas-kiri-padding-left-top-second-last'>&nbsp;</td>
                    <td width="30%" class id='string-garis-atas-kiri-kanan-center-top-second-last'>&nbsp;</td>
                </tr> 
                <%
            }
            
            }catch(Exception E){
                System.out.println("[exception] "+E.toString());
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
                                <td width="20%" class id='string-garis-kiri-center'>SETUJU DIBAYAR</td>
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
                            <tr>
                                <td class id='string-garis-kiri-center'><%=ket_1 == null ? "&nbsp" : ket_1 %></td>
                                <td class id='string-garis-kiri-center'><%=ket_2 == null ? "&nbsp" : ket_2 %></td>
                                <td class id='string-garis-kiri-center'><%=ket_3 == null ? "&nbsp" : ket_3 %></td>
                                <td class id='string-garis-kiri-center'><%=ket_4 == null ? "&nbsp" : ket_4 %></td>
                                <td class id='string-garis-kiri-padding-left-paraf'>3.</td>
                                <td class id='string-garis-kiri-kanan-center'>&nbsp;</td>
                            </tr>
                            <tr >
                                <td class id='string-garis-kiri-center'>Tgl &nbsp&nbsp/&nbsp&nbsp&nbsp;/20</td>
                                <td class id='string-garis-kiri-center'>Tgl &nbsp/&nbsp;/20</td>
                                <td class id='string-garis-kiri-center'>Tgl &nbsp/&nbsp;/20</td>                                            
                                <td class id='string-garis-kiri-center'>Tgl &nbsp&nbsp/&nbsp&nbsp&nbsp;/20</td>
                                <td colspan="2" class id='string-garis-kiri-kanan-center'>&nbsp;</td>
                            </tr>
                            <tr height="80px">
                                <td colspan="3" class id='string-garis-kiri-center'>&nbsp;</td>                                            
                                <td colspan="3" class id='string-garis-kiri-kanan-center'>
                                    <table width="480px" align="center">
                                        <tr>
                                            <td align="center"><font class id = 'string-tidak-putus-2'><%=ket_5 == null ? "&nbsp" : ket_5 %>,&nbsp;Tgl &nbsp&nbsp&nbsp&nbsp/&nbsp&nbsp&nbsp&nbsp;/20</font></td>       
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>       
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>       
                                        </tr>
                                        <tr>
                                            <td><font class id = 'string-tidak-putus-2'>Nama jelas : </font></td>       
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <table width=100%>
                            <tr>
                                <td width="50%">
                                    <font class id = 'string-tidak-putus-2'>Dicetak Tanggal <%=JSPFormater.formatDate(new Date(), "dd/MM/yy")%></font>                                            
                                </td>
                                <td width="50%" align="left">
                                    <font class id = 'string-tidak-putus-2'>Halaman <%=hal%> dari <%=max_hal%></font>
                                </td>
                            </tr>    
                            </table>       
                            <tr>
                                <td height="20px" colspan = "6">&nbsp;</td>
                            </tr>    
                            <tr>
                                <td colspan="6" align="center">
                                    <%
            out.print("<a href=\"../freport/rpt_bankpopayment_print.jsp?bankpopayment_id=" + bankpoPayment.getOID() + "\" target='_blank'><img src=\"../images/print.gif\" name=\"delete\" height=\"22\" border=\"0\"></a></td>");
                                    %>
                                </td>                                            
                            </tr>
                        </table>    
                    </td>
                </tr>
            </table>
        </td>    
        <td width="5%">&nbsp;</td>
    </tr>
</table>
