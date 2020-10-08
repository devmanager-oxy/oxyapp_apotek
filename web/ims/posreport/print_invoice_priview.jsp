<%-- 
    Document   : print_Invoice_Priview
    Created on : Dec 28, 2011, 2:01:43 PM
    Author     : Ngurah Wirata
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>


<style type="text/css">
    #font-tittle{
        font-family:Arial, Helvetica, sans-serif;
        font-size:12px;
        font-weight:bold;
        padding-left:5px;
        padding-right:5px;
        text-align:center;
    }  
    
    #font-header{
        font-family:Arial, Helvetica, sans-serif;
        font-size:11px;
        font-weight:bold;
        padding-left:5px;
        padding-right:5px;
        text-align:center;
		vertical-align:middle;
        
    }    
    
    #font-text{
        font-family:Arial, Helvetica, sans-serif;
        font-size:12px;
        padding-left:5px;
        padding-right:5px;
		vertical-align:top;
		padding-top:3px;
    }
    
    </style>    

<%
            
            
       String[] monthList = {"Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"};

        // Load User Login
        
        //System.out.println("UserId : " + loginId);
        long sales_id = JSPRequestValue.requestLong(request, "sales_id");
        long sales_detail_id = JSPRequestValue.requestLong(request, "sales_detail_id");

        long return_payment_id = JSPRequestValue.requestLong(request, "return_payment_id");
        long payment_id = JSPRequestValue.requestLong(request, "payment_id");
        
        int typeInvoice = JSPRequestValue.requestInt(request, "status");

        IndukCustomer ic = new IndukCustomer();
        
        Currency curr = new Currency();
        
        Sales sales = new Sales();
        Payment payment = new Payment();
        ReturnPayment returnPayment = new ReturnPayment();
        
        try{
           sales = DbSales.fetchExc(sales_id);
           payment = DbPayment.fetchExc(payment_id);
           returnPayment = DbReturnPayment.fetchExc(return_payment_id);
           
        }catch(Exception e){
            
        }
        
        

        Customer cus = new Customer();
        
        //try {
        //    ic = DbIndukCustomer.fetch(st.getInvestorId());
        ///} catch (Exception e) {
        //}


        ///try {
        //    curr = DbCurrency.fetchExc(sewaTanahInvoice.getCurrencyId());
        //} catch (Exception e) {
        //}

        //Vector tempx = DbSewaTanahBenefit.list(0,1, "sewa_tanah_invoice_id="+invoice_oid, "");
        
        //long oidSewaTanahBenefit = 0;
        
	//if(tempx!=null && tempx.size()>0){
	//	SewaTanahBenefit stb = (SewaTanahBenefit)tempx.get(0);
	//	oidSewaTanahBenefit = stb.getOID();
	//}
        
        // Load Company
        //Company company = DbCompany.getCompany();
        //long oidCompany = company.getOID();
        //System.out.println("oidCompany : " + oidCompany);

        //Count total Column
        int colSpan = 0;
        System.out.println(colSpan);

        boolean gzip = false;

        

      
        //int year = sewaTanahInvoice.getTanggal().getYear() + 1900;
        //SewaTanahRincianPiutang sewaTanahRincianPiutang = new SewaTanahRincianPiutang();
        //String wherePiutang = DbSewaTanahRincianPiutang.colNames[DbSewaTanahRincianPiutang.COL_SEWA_TANAH_ID] + "=" + st.getOID() + " AND " +
          //      DbSewaTanahRincianPiutang.colNames[DbSewaTanahRincianPiutang.COL_PERIODE_TAHUN] + "=" + year;

        //Vector rincian = DbSewaTanahRincianPiutang.list(0, 0, wherePiutang, "");

        //if (rincian != null && rincian.size() > 0) {
          //  sewaTanahRincianPiutang = (SewaTanahRincianPiutang) rincian.get(0);
        //}
        //int curent_year = new Date().getYear() + 1900;
      //String header_company = DbCompany.getCompany().getName();
      //String header_inv = DbSystemProperty.getValueByName("HEADER_INVOICE");
%>
<table width="100%">
<tr>
<td width="5%">&nbsp;</td>
<td >
<table width="100%" border="0">
  <tr> 
    <td colspan="6"  align="center" style="font-weight:bold; size:17px; font-style:italic"><i>INVOICE</i></td>
  </tr>
  <tr>
      <td colspan="6">&nbsp;</td>
  </tr>
  
  <tr> 
    <td class id="font-title" width="9%">Company</td>
    <td width="2%">:</td>
    <td width="35%">&nbsp;</td>
    <td class id="font-title" width="12%">Date</td>
    <td width="2%">:</td>
    <td width="39%"><%=sales.getDate()%></td>
  </tr>
  <tr> 
    <td class id="font-title" width="9%">Number</td>
    <td width="2%">:</td>
    <td width="35%"><%=sales.getNumber()%></td>
    <td class id="font-title" width="12%">Note</td>
    <td width="2%">:</td>
    <td width="39%">&nbsp;</td>
  </tr>
  <tr> 
    <td class id="font-title" width="12% width="9%">Sales Type</td>
    <td width="2%">:</td>
    <%if(sales.getType()==DbSales.TYPE_CASH){%>
        <td width="35%">Cash</td>
    <%}else{%>
        <td width="35%">Credit</td>
    <%}%>
    <td class id="font-title" width="12% width="12%">Customer</td>
    <td width="2%">:</td>
    <%
        try{
            cus = DbCustomer.fetchExc(sales.getCustomerId());
        }catch(Exception ex){
            
        }    
    
    %>
    <%if(cus.getOID()!=0){%>
        <td width="39%"><%=cus.getName()%></td>
    <%}else{%>    
        <td width="39%">-</td>
    <%}%>    
  </tr>
  <tr> 
    <td width="9%">&nbsp;</td>
    <td width="2%">&nbsp;</td>
    <td width="35%">&nbsp;</td>
    <td width="12%">&nbsp;</td>
    <td width="2%">&nbsp;</td>
    <td width="39%">&nbsp;</td>
  </tr>
</table>
<table width="100%" cellpadding="0" cellspacing="0" border="0" >
  <tr> 
    <td class id="font-header" style="border-left:#000000 1px solid;border-top:#000000 1px solid;border-bottom:#000000 1px solid"  width="4%"> 
      <div align="center">NO</div>
    </td>
    <td class id="font-header" style="border-left:#000000 1px solid;border-top:#000000 1px solid;border-bottom:#000000 1px solid" width="32%"> 
      <div align="center">PRODUCT</div>
    </td>
    <td class id="font-header" style="border-left:#000000 1px solid;border-top:#000000 1px solid;border-bottom:#000000 1px solid" width="6%"> 
      <div align="center">QTY</div>
    </td>
    <td class id="font-header" style="border-left:#000000 1px solid;border-top:#000000 1px solid;border-bottom:#000000 1px solid" width="8%"> 
      <div align="center">UOM</div>
    </td>
    <td class id="font-header" style="border-left:#000000 1px solid;border-top:#000000 1px solid;border-bottom:#000000 1px solid" width="16%"> 
      <div align="center">SELLING PRICE</div>
    </td>
    <td class id="font-header" style="border-left:#000000 1px solid;border-top:#000000 1px solid;border-bottom:#000000 1px solid" width="14%"> 
      <div align="center">DISCOUNT</div>
    </td>
    <td class id="font-header" style="border-right:#000000 1px solid;border-left:#000000 1px solid;border-top:#000000 1px solid;border-bottom:#000000 1px solid" width="20%"> 
      <div align="center">TOTAL SALES</div>
    </td>
  </tr>
  <%
    Vector VsalesDetail = new Vector();
    VsalesDetail = DbSalesDetail.list(0, 0, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + "=" + sales_id, DbSalesDetail.colNames[DbSalesDetail.COL_SALES_DETAIL_ID]);
    if(VsalesDetail.size()>0){
        for(int i=0;i<VsalesDetail.size();i++){
        SalesDetail salesDetail = (SalesDetail)VsalesDetail.get(i);
        ItemMaster itemMaster = DbItemMaster.fetchExc(salesDetail.getProductMasterId());
        Uom uom = DbUom.fetchExc(itemMaster.getUomSalesId());
        
        
  %> 
      <tr> 
        <td class id="font-text" style="border-left:#000000 1px solid" width="4%"><%=i+1%></td>
        <td class id="font-text" style="border-left:#000000 1px solid" width="32%"><%=itemMaster.getName()%></td>
        <td class id="font-text" style="border-left:#000000 1px solid" width="6%"><%=JSPFormater.formatNumber(salesDetail.getQty(), "#,###.##")%></td>
        <td class id="font-text" style="border-left:#000000 1px solid" width="8%"><%=uom.getUnit()%></td>
        <td class id="font-text" style="border-left:#000000 1px solid" width="16%"><%=JSPFormater.formatNumber(salesDetail.getSellingPrice(),"#,###.##")%></td>
        <td class id="font-text" style="border-left:#000000 1px solid" width="14%"><%=JSPFormater.formatNumber(salesDetail.getDiscountAmount(),"#,###.##")%></td>
        <td class id="font-text" style="border-right:#000000 1px solid;border-left:#000000 1px solid" width="20%"><%=JSPFormater.formatNumber(salesDetail.getTotal(),"#,###.##")%></td>
      </tr>
       
     
  <%}%>
  <tr> 
        <td class id="font-text" style="border-top:#000000 1px solid" width="4%">&nbsp;</td>
        <td class id="font-text" style="border-top:#000000 1px solid" width="32%">&nbsp;</td>
        <td class id="font-text" style="border-top:#000000 1px solid" width="6%">&nbsp;</td>
        <td class id="font-text" style="border-top:#000000 1px solid" width="8%">&nbsp;</td>
        <td class id="font-text" style="border-top:#000000 1px solid" width="16%">&nbsp;</td>
        <td class id="font-text" style="border-top:#000000 1px solid" width="14%">&nbsp;</td>
        <td class id="font-text" style="border-top:#000000 1px solid" width="20%">&nbsp;</td>
  </tr> 
  <%}%> 
<tr> 
        <td class id="font-text" width="4%">&nbsp;</td>
        <td class id="font-text" width="32%">&nbsp;</td>
        <td class id="font-text" width="6%">&nbsp;</td>
        <td class id="font-text" width="8%">&nbsp;</td>
        <td class id="font-text" width="8%">&nbsp;</td>
        <td colspan="2">
           <table width="100%" cellpadding="0" cellspacing="0" border="0" >
                <tr>
                    <td class id="font-text" width="45%">SUB TOTAL</td>
                    <td class id="font-text" width="2%">:</td>
                    <td class id="font-text" align="right" width="66%"><%=JSPFormater.formatNumber(sales.getAmount(),"#,###.##")%></td>
            
                </tr>
                 <%if(sales.getDiscountPercent()!=0){%>
                <tr>
                    <td class id="font-text" width="45%">DISCOUNT (<%=sales.getDiscountPercent()%>%)</td>
                    <td class id="font-text" width="2%">:</td>
                    <td class id="font-text" align="right" width="66%"><%=JSPFormater.formatNumber(sales.getDiscountAmount(),"#,###.##")%></td>
            
                </tr>
                <%}%>
                 <%if(sales.getVatPercent()!=0){%>
                <tr>
                    <td class id="font-text" width="45%">VAT ( <%=sales.getVatPercent()%>%) </td>
                    <td class id="font-text" width="2%">:</td>
                    <td class id="font-text" align="right" width="66%"><%=JSPFormater.formatNumber(sales.getVatAmount(),"#,###.##")%></td>
            
                </tr>
                <%}%>
                <%if(payment.getCost_card_percent()!=0){%>
                <tr>
                    <td class id="font-text" width="45%">COST CC ( <%=payment.getCost_card_percent()%>%) </td>
                    <td class id="font-text" width="2%">:</td>
                    <td class id="font-text" align="right" width="66%"><%=JSPFormater.formatNumber(payment.getCost_card_amount(),"#,###.##")%></td>
            
                </tr>
                <%}%>
                <%if(sales.getPphPercent()!=0){%>
                <tr>
                    <td class id="font-text" width="45%">PPH (<%=sales.getPphPercent()%>%) </td>
                    <td class id="font-text" width="2%">:</td>
                    <td class id="font-text" align="right" width="66%"><%=JSPFormater.formatNumber(sales.getPphAmount(),"#,###.##")%></td>
            
                </tr>
                <%}%>
                <tr>
                    <td class id="font-text" width="45%">GRAND TOTAL</td>
                    <td class id="font-text" width="2%">:</td>
                    <td class id="font-text" align="right" width="66%"><%=JSPFormater.formatNumber(sales.getAmount()-sales.getDiscountAmount()+ sales.getVatAmount() + sales.getPphAmount() + payment.getCost_card_amount(),"#,###.##" )%> </td>
            
                </tr>
                
                <tr>
                    <td class id="font-text" width="45%">PAYMENT</td>
                    <td class id="font-text" width="2%">:</td>
                    <td class id="font-text" align="right" width="66%"><%=JSPFormater.formatNumber(payment.getAmount(),"#,###.##")%></td>
            
                </tr>
                <tr>
                    <td class id="font-text" width="45%">CHANGE</td>
                    <td class id="font-text" width="2%">:</td>
                    <td class id="font-text" align="right" width="66%"><%=JSPFormater.formatNumber(returnPayment.getAmount(),"#,###.##")%></td>
            
                </tr>
           </table>
            
        </td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  <tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  <tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  <tr>
    <td colspan="7" align="center"><a href="../posreport/print_invoice.jsp?sales_id=<%=sales_id%>&payment_id=<%=payment_id%>&sales_detail_id=<%=sales_detail_id%>&return_payment_id=<%=return_payment_id%>" target='_blank'><img src="../images/print.gif" name="delete" height="22" border="0"></a></td>
  </tr>
 </table>

</td>
<td width="5%">&nbsp;</td>
</tr>
</table>




  
 
  
 
  


