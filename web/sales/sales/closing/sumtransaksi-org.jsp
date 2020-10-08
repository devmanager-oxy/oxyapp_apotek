<link href="../../css/csssl.css" rel="stylesheet" type="text/css">
<style type="text/css">
    <!--
    .style3 {color: #FFFFFF; font-weight: bold; }
    -->
    </style>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
    <tr>
        <td colspan="10" class="fontarial"><b><i>CLOSING SALES DATA</i></b></td>
    </tr>
    <tr>
        <td align="center" class="tablearialhdr">Location</td>
        <td align="center" class="tablehdr">Shift</td>
        <td align="center" class="tablehdr">User</td>
        <td align="center" class="tablehdr">Cash</td>
        <td align="center" class="tablehdr">Credit Card</td>
        <td align="center" class="tablehdr">Credit (Bon)</td>
        <td align="center" class="tablehdr">Discount</td>
        <td align="center" class="tablehdr">Retur</td>
        <td align="center" class="tablehdr">Amount</td>
    </tr>
    <%
            // tootal
            double totSubCash = 0;
            double totSubCard = 0;
            double totSubBon = 0;
            double totSubDiscount = 0;
            double totSubRetur = 0;
            double totSubAmount = 0;

            // sub total
            double subCash = 0;
            double subCard = 0;
            double subBon = 0;
            double subDiscount = 0;
            double subRetur = 0;
            double subAmount = 0;

            String loc_name = "";
            String nameLocView = "";

            Vector list = SQLGeneral.getDataSummaryClosing(tanggal, ipHost, userLocations);            
            
            if (list.size() > 0) {
                for (int k = 0; k < list.size(); k++) {
                    SalesClosing salesClosing = (SalesClosing) list.get(k);

                    if (k == 0) {                        
                        loc_name = salesClosing.getInvoiceNumber();
                        nameLocView = salesClosing.getInvoiceNumber();
                    }

                    if (loc_name.equals(salesClosing.getInvoiceNumber())) {
                        // simpan total transaksi
                        subCash = subCash + salesClosing.getCash();
                        subCard = subCard + salesClosing.getCCard();
                        subBon = subBon + salesClosing.getBon();
                        subDiscount = subDiscount + salesClosing.getDiscount();
                        subRetur = subRetur + salesClosing.getRetur();
                        subAmount = subAmount + salesClosing.getAmount();
                        if (k != 0) {
                            nameLocView = "";
                        }
                    } else {
    %>
    <tr>
        <td class="tablecell" colspan="2"><b><div align="right">TOTAL</div></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCash, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCard, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subBon, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subDiscount, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subRetur, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subAmount, "#,##0")%></b></td>
    </tr>
    <tr>
        <td class="tablecell" colspan="2"></td>
        <td align="right" class="tablecell"></td>
        <td align="right" class="tablecell"></td>
        <td align="right" class="tablecell"></td>
        <td align="right" class="tablecell"></td>
        <td align="right" class="tablecell"></td>
        <td align="right" class="tablecell"></td>
    </tr>
    <%
            nameLocView = salesClosing.getInvoiceNumber();

            subCash = 0;
            subCard = 0;
            subBon = 0;
            subDiscount = 0;
            subRetur = 0;
            subAmount = 0;

            // simpan total transaksi
            subCash = subCash + salesClosing.getCash();
            subCard = subCard + salesClosing.getCCard();
            subBon = subBon + salesClosing.getBon();
            subDiscount = subDiscount + salesClosing.getDiscount();
            subRetur = subRetur + salesClosing.getRetur();
            subAmount = subAmount + salesClosing.getAmount();

        }

        loc_name = salesClosing.getInvoiceNumber();

    %>
    <tr>
        <td align="left" class="tablecell"><b><%=nameLocView%></b></td>
        <td align="left" class="tablecell"><%=salesClosing.getMember()%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCash(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCCard(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getBon(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getDiscount(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getRetur(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "#,##0")%></td>
    </tr>
    <%}
            }%>
    <tr>
        <td class="tablecell" colspan="2"><b><div align="right">TOTAL</div></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCash, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCard, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subBon, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subDiscount, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subRetur, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subAmount, "#,##0")%></b></td>
    </tr>
</table>
