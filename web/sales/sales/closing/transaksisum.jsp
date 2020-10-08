<link href="../../css/csssl.css" rel="stylesheet" type="text/css">
<style type="text/css">
    <!--
    .style3 {color: #FFFFFF; font-weight: bold; }
    -->
    </style>
<table width="60%" border="0" cellspacing="1" cellpadding="1">
    <tr>
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
        <td width="10%" align="center" class="tablearialhdr">NO</td>
        <td width="30%" align="center" class="tablearialhdr">LOCATION</td>
        <td width="20%" align="center" class="tablearialhdr">TOTAL</td>
    </tr>
    <%
            // total
            double total = 0;
            Vector list = SQLGeneral.getDataSummarySales(tanggal, tanggalTo, userLocations);
            if (list.size() > 0) {
                for (int k = 0; k < list.size(); k++) {
                    SalesClosing salesClosing = (SalesClosing) list.get(k);
                    total = total + salesClosing.getAmount();

    %>
    <tr height="24">
        <td align="center" class="tablearialcell"><%=(k + 1)%></td>
        <td align="left" class="tablearialcell"><%=salesClosing.getMember()%></td>
        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "#,###.##")%></td>
    </tr>
    <%}%>
    <tr>
        <td></td>
        <td></td>
        <td></td>
    </tr>  
    <tr height="24">
        <td class="tablearialcell" colspan="2" align="center"><b>TOTAL</b></td>	
        <td align="right" class="tablearialcell"><b><%=JSPFormater.formatNumber(total, "#,###.##")%></b></td>
    </tr>
    <tr>
        <td colspan="3" height="10"></td>    
    </tr>
    <%if (list != null && list.size() > 0) {%>
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
