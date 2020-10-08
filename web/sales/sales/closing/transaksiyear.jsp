<link href="../../css/csssl.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style3 {color: #FFFFFF; font-weight: bold; }
-->
</style>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
   <%if(yearVal!=0 && iJSPCommand==JSPCommand.SEARCH){%> 
  <tr>
      
    <td width="10%" align="center" class="tablehdr">CODE</td>
    <td width="10%" align="center" class="tablehdr">BARCODE</td>
    <td width="18%" align="center" class="tablehdr">DESCRIPTION</td>	
    <td width="5%" align="center" class="tablehdr">JAN <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">FEB <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">MAR <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">APR <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">MEI <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">JUN <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">JUL <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">AGU <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">SEP <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">OKT <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">NOP <%=yearVal%></td>
    <td width="5%" align="center" class="tablehdr">DES <%=yearVal%></td>
    <td width="7%" align="center" class="tablehdr">TOTAL</td>
  </tr>
  <%}%>
  <%

  if(iJSPCommand==JSPCommand.SEARCH){
  	Vector list = SQLGeneral.listTotalSalesYear(locationId,groupId, vendorId, type, yearVal, customerId, sort);
	if(list.size()>0){
  		for(int k=0;k<list.size();k++){
			Vector listitem = (Vector)list.get(k);
  %>
  <tr>
    <td align="left" class="tablecell"><%=String.valueOf(listitem.get(0))%></td>
    <td align="left" class="tablecell"><%=String.valueOf(listitem.get(1))%></td>
    <td align="left" class="tablecell"><%=String.valueOf(listitem.get(2))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(3))%></td>		
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(4))%></td>	
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(5))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(6))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(7))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(8))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(9))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(10))%></td>		
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(11))%></td>	
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(12))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(13))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(14))%></td>
    <td align="right" class="tablecell"><%=String.valueOf(listitem.get(15))%></td>
  </tr>
  <%
  		}
	}
  }
  %>
</table>
