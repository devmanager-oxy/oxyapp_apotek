<link href="../../css/csssl.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style3 {color: #FFFFFF; font-weight: bold; }
-->
</style>
<table width="60%" border="0" cellspacing="1" cellpadding="1">
  <tr>
      <td colspan="3"><font face="arial"><strong>SUMMARY SALES</strong> </font></td>
  </tr>
  <tr>
    <td width="10%" align="center" class="tablehdr">NO</td>
    <td width="30%" align="center" class="tablehdr">LOCATION</td>
    <td width="20%" align="center" class="tablehdr">TOTAL</td>
  </tr>
  <%	
	// total
  double total = 0;  
  Vector list = SQLGeneral.getDataSummarySales(tanggal, tanggalTo);
  if(list.size()>0){
  	for(int k=0;k<list.size();k++){
		SalesClosing salesClosing = (SalesClosing)list.get(k);
    		total = total + salesClosing.getAmount();
		
  %>
  <tr>
    <td align="center" class="tablecell"><%=(k+1)%></td>
    <td align="left" class="tablecell"><%=salesClosing.getMember()%></td>
    <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getAmount(),"#,##0")%></td>
  </tr>
  <%}%>
  <tr>
    <td></td>
    <td></td>
    <td></td>
  </tr>  
  <tr>
    <td class="tablecell" colspan=2 ><b>TOTAL</b></td>	
    <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(total,"#,##0")%></b></td>
  </tr>
  <tr>
    <td colspan="3" height="10"></td>    
  </tr>
  <%if(list != null && list.size() > 0 ){%>
  <tr>
    <td colspan="3">
        <%if (privPrint) {%>
        <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../../images/printxls2.gif',1)"><img src="../../images/printxls.gif" name="print1" height="22" border="0"></a>
        <%}%>
    </td>    
  </tr>
  <%}%>
  <%}%>	
</table>
