<link href="../../css/csssl.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
    <tr>
        <td colspan="10" class="fontarial"><strong><i>Sales Data</i></strong> </td>
    </tr>
    <tr height="25">
        <td align="center" class="tablearialhdr">NO</td>
        <td align="center" class="tablearialhdr">INVOICE</td>
        <td align="center" class="tablearialhdr">DATE</td>
        <td align="center" class="tablearialhdr">MEMBER</td>
        <td align="center" class="tablearialhdr">CASH</td>
        <td align="center" class="tablearialhdr">CREDIT CARD</td>
        <td align="center" class="tablearialhdr">DEBIT CARD</td>
        <td align="center" class="tablearialhdr">TRANSFER BANK</td>
        <td align="center" class="tablearialhdr">CREDIT(BON)</td>
        <td align="center" class="tablearialhdr">DISCOUNT</td>
        <td align="center" class="tablearialhdr">RETUR</td>
        <td align="center" class="tablearialhdr">AMOUNT</td>
        <td align="center" class="tablearialhdr">MERCHANT</td>
    </tr>
    <%
            // tootal       
            double totSubCash = 0;
            double totSubCard = 0;
            double totSubDebit = 0;
            double totSubTransfer = 0;
            double totSubBon = 0;
            double totSubDiscount = 0;
            double totSubRetur = 0;
            double totSubAmount = 0;

// sub total
            double subCash = 0;
            double subCard = 0;
            double subDebit = 0;
            double subTransfer = 0;
            double subBon = 0;
            double subDiscount = 0;
            double subRetur = 0;
            double subAmount = 0;
            boolean isOk = false;

            //Vector list1 = SQLGeneral.getDataClosing(tanggal, locationId, cashCashierId, 0);
            Vector list1 = DbSales.getDataJournal(tanggal, locationId, cashCashierId, 0);

            session.putValue("REPORT_SALES_CLOSING", list1);

            if (list1 != null && list1.size() > 0) {
                isOK = true;
                for (int k = 0; k < list1.size(); k++) {
                    //SalesClosing salesClosing = (SalesClosing) list1.get(k);

                    alesClosingJournal salesClosing = (SalesClosingJournal) list1.get(k);
                    /*subCash = subCash + salesClosing.getCash();
                    subCard = subCard + salesClosing.getCCard();
                    subBon = subBon + salesClosing.getBon();
                    subDiscount = subDiscount + salesClosing.getDiscount();
                    subRetur = subRetur + salesClosing.getRetur();
                    subAmount = subAmount + salesClosing.getAmount();*/

                    subCash = subCash + salesClosing.getCash();
                    /*subCard = subCard + salesClosing.getCCard();
                    subDebit = subDebit + salesClosing.getDCard();
                    subTransfer = subTransfer + salesClosing.getTransfer();
                    subBon = subBon + salesClosing.getBon();
                    subDiscount = subDiscount + salesClosing.getDiscount();
                    subRetur = subRetur + salesClosing.getRetur();
                    subAmount = subAmount + salesClosing.getAmount();*/


    %>
    <tr>
        <td align="center" class="tablecell"><%=(k + 1)%></td>
        <td align="left" class="tablecell"><%=salesClosing.getInvoiceNumber()%></td>
        <td align="left" class="tablecell"><%=salesClosing.getTglJam()%></td>
        <td align="left" class="tablecell"><%=salesClosing.getMember()%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCash(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCCard(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getBon(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getDiscount(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getRetur(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "#,##0")%></td>
    </tr>
    <%}
            }
            totSubCash = subCash;
            totSubCard = subCard;
            totSubBon = subBon;
            totSubDiscount = subDiscount;
            totSubRetur = subRetur;
            totSubAmount = subAmount;
    %>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell"><b>SUB TOTAL</b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCash, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCard, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subBon, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subDiscount, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subRetur, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subAmount, "#,##0")%></b></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <%
            Vector list2 = SQLGeneral.getDataClosing(tanggal, locationId, cashCashierId, 1);
            session.putValue("REPORT_SALES_CLOSING2", list1);
            if (list2 != null && list2.size() > 0) {
                isOK = true;
    %>
    <tr>
        <td colspan="10"><strong>GROOMING</strong> </td>
    </tr>
    <%
        subCash = 0;
        subCard = 0;
        subBon = 0;
        subDiscount = 0;
        subRetur = 0;
        subAmount = 0;

        if (list2.size() > 0) {
            for (int k = 0; k < list2.size(); k++) {
                SalesClosing salesClosing = (SalesClosing) list2.get(k);
                // simpan total transaksi
                subCash = subCash + salesClosing.getCash();
                subCard = subCard + salesClosing.getCCard();
                subBon = subBon + salesClosing.getBon();
                subDiscount = subDiscount + salesClosing.getDiscount();
                subRetur = subRetur + salesClosing.getRetur();
                subAmount = subAmount + salesClosing.getAmount();
    %>
    <tr>
        <td align="center" class="tablecell"><%=(k + 1)%></td>
        <td align="left" class="tablecell"><%=salesClosing.getInvoiceNumber()%></td>
        <td align="left" class="tablecell"><%=salesClosing.getTglJam()%></td>
        <td align="left" class="tablecell"><%=salesClosing.getMember()%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCash(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCCard(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getBon(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getDiscount(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getRetur(), "#,##0")%></td>
        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "#,##0")%></td>
    </tr>
    <%}
        }

        totSubCash = totSubCash + subCash;
        totSubCard = totSubCard + subCard;
        totSubBon = totSubBon + subBon;
        totSubDiscount = totSubDiscount + subDiscount;
        totSubRetur = totSubRetur + subRetur;
        totSubAmount = totSubAmount + subAmount;

    %>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell"><b>SUB TOTAL</b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCash, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCard, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subBon, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subDiscount, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subRetur, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subAmount, "#,##0")%></b></td>
    </tr>
    <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    
    <%}%>
    <tr>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell">&nbsp;</td>
        <td class="tablecell"><b>TOTAL</b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubCash, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubCard, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubBon, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubDiscount, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubRetur, "#,##0")%></b></td>
        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubAmount, "#,##0")%></b></td>
    </tr>
    <tr height="10">
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <%if (isOK) {%>
    <tr>
        <td colspan="10">
            <%if (privPrint) {%>
            <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../../images/printxls2.gif',1)"><img src="../../images/printxls.gif" name="print1" height="22" border="0"></a>
            <%}%>
        </td>       
    </tr>
    <%}%>
</table>
