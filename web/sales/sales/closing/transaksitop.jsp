<link href="../../css/csssl.css" rel="stylesheet" type="text/css">
<style type="text/css">
    <!--
    .style3 {color: #FFFFFF; font-weight: bold; }
    -->
    </style>
<table width="<%=wdth%>" border="0" cellspacing="1" cellpadding="1">
    <tr>
        <td colspan="2"><strong>DATA TOP <%if(all==0){%><%=maxLimit%><%}%> SALES</strong> </td>
    </tr>
    <tr>
        <td colspan="2" height="5"></td>
    </tr>
    <tr>
        <td width="5%" align="center" class="tablehdr">NO</td>
        <%if (locSts == 1) {%>	
        <td width="15%" align="center" class="tablehdr">LOCATION</td>
        <% }
            if (groupSts == 1) {%>	
        <td width="15%" align="center" class="tablehdr">DEPARTMENT/GROUP</td>
        <%}
            if (vendorSts == 1) {
        %>
        <td width="15%" align="center" class="tablehdr">SUPPLIER</td>	
        <%}
            if (itemSts == 1) {
        %>
        <td width="10%" align="center" class="tablehdr">CODE</td>
        <td width="20%" align="center" class="tablehdr">DESCRIPTION</td>
        <%}%>
        <td width="10%" align="center" class="tablehdr">QTY</td>
        <td width="10%" align="center" class="tablehdr">PRICE</td>
        <td width="10%" align="center" class="tablehdr">TOTAL</td>
    </tr>
    <%
            // tootal
            double total = 0;

            Vector list = SQLGeneral.getDataTopSales(tanggal, tanggalEnd, locationId, locSts, groupId, groupSts, vendorId, vendorSts, itemSts, maxLimit,all);
            if (list.size() > 0) {
                for (int k = 0; k < list.size(); k++) {
                    SalesClosing salesClosing = (SalesClosing) list.get(k);
                    total = total + salesClosing.getAmount();
                    totData++;

    %>
    <tr>
        <td align="center" class="tablecell"><%=(k + 1)%></td>
        <%if (locSts == 1) {%>
        <td align="left" class="tablecell"><%=salesClosing.getName3()%></td>
        <%}
            if (groupSts == 1) {%>
        <td align="left" class="tablecell"><%=salesClosing.getName1()%></td>
        <%}
            if (vendorSts == 1) {
        %>
        <td align="left" class="tablecell"><%=salesClosing.getName2()%></td>		
        <%}
            if (itemSts == 1) {
        %>
        <td align="left" class="tablecell"><%=salesClosing.getInvoiceNumber()%></td>	
        <td align="left" class="tablecell"><%=salesClosing.getMember()%></td>
        <%}%>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getJmlQty(), "###,###.##")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCash(), "###,###.##")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getJmlQty() * salesClosing.getCash(), "###,###.##")%></td>
    </tr>
    <%}%>    
    <%} else {%>	
    <tr>        
        <%int colsp = 1;%>
        
        <%if (locSts == 1) {
            colsp = colsp + 1;
        }
        if (groupSts == 1) {
            colsp = colsp + 1;

        }
        if (vendorSts == 1) {
            colsp = colsp + 1;
        }
        if (itemSts == 1) {
            colsp = colsp + 2;
        }
        colsp = colsp + 2;
        %>
        <td colspan = "<%=colsp %>" class="tablecell1" ><i>Data not found</i></td>
        
    </tr>
    <%}%>
</table>
