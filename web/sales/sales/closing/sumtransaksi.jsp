<link href="../../css/csssl.css" rel="stylesheet" type="text/css">
<style type="text/css">
    <!--
    .style3 {color: #FFFFFF; font-weight: bold; }
    -->
    </style>
<table width="1200" border="0" cellspacing="1" cellpadding="1">
    <tr>
        <td colspan="10" class="fontarial">&nbsp;</td>
    </tr>
    <tr height="26">
        <td align="center" class="tablearialhdr">LOCATION</td>
        <td align="center" class="tablearialhdr" width="80">SHIFT</td>
        <td align="center" class="tablearialhdr" width="150">USER</td>
        <td align="center" class="tablearialhdr" width="80">AMOUNT</td>
        <td align="center" class="tablearialhdr" width="80">DISCOUNT</td>
        <td align="center" class="tablearialhdr" width="80">TOTAL</td>        
        <td align="center" class="tablearialhdr" width="80">CASH</td>
        <td align="center" class="tablearialhdr" width="80">CREDIT CARD</td>
        <td align="center" class="tablearialhdr" width="80">DEBIT CARD</td>
        <td align="center" class="tablearialhdr" width="80">TRANSFER</td>
        <td align="center" class="tablearialhdr" width="90">CASH BACK</td>
        <td align="center" class="tablearialhdr" width="80">CREDIT (BON)</td>
        <td align="center" class="tablearialhdr" width="80">RETUR</td>        
    </tr>
    <%
            if (userLocations != null && userLocations.size() > 0 && iJSPCommand == JSPCommand.SUBMIT) {

                // total
                double totSubCash = 0;
                double totSubCard = 0;
                double totSubDebit = 0;
                double totSubTranfer =0;
                double totSubCashBack = 0;
                double totSubBon = 0;
                double totSubDiscount = 0;
                double totSubRetur = 0;
                double totSubAmount = 0;
                double totSubKwitansi = 0;

                Vector locationPrint = new Vector();

                for (int k = 0; k < userLocations.size(); k++) {

                    Location loc = (Location) userLocations.get(k);
                    Vector tmpPrint = new Vector();
                    
                    int typeReport = SessReportClosing.getTypeReport(loc.getOID());

                    if (locationId == 0 || locationId == loc.getOID()) {

                        Vector vshift = SQLGeneral.getShift(loc.getOID(), tanggal);

                        if (vshift != null && vshift.size() > 0) {

                            // sub total
                            double subCash = 0;
                            double subCard = 0;
                            double subDebit = 0;
                            double subCashBack = 0;
                            double subBon = 0;
                            double subDiscount = 0;
                            double subRetur = 0;
                            double subTransfer=0;
                            double subAmount = 0;
                            double subKwitansi = 0;

                            for (int j = 0; j < vshift.size(); j++) {

                                Shift shift = (Shift) vshift.get(j);
                                SalesClosingJournal salesClosing = new SalesClosingJournal();
                                if(typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_JOURNAL || typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_SHIFT){
                                    salesClosing = SessReportClosing.getDataSummaryClosingSinglePayment(tanggal, loc.getOID(), shift.getOID());
                                }else if(typeReport == DbSegmentDetail.TYPE_SALES_MULTY_PAYMENT_POST_ONE_JOURNAL || 
                                        typeReport == DbSegmentDetail.TYPE_SALES_MULTY_PAYMENT_POST_ONE_SHIFT || 
                                        typeReport == DbSegmentDetail.TYPE_SALES_MULTY_PAYMENT_POST_ONE_MONTH){
                                    salesClosing = SessReportClosing.getDataSummaryClosingMultyPayment(tanggal, loc.getOID(), shift.getOID());
                                }
                                //String name = SessClosingSummary.getUserShift(loc.getOID(), tanggal, shift.getOID());
                                String name = SessReportClosing.getUserShift(shift.getOID());

                                String style = "tablearialcell";

                                subCash = subCash + salesClosing.getCash();
                                subCard = subCard + salesClosing.getCCard();
                                subDebit = subDebit + salesClosing.getDCard();
                                subTransfer = subTransfer + salesClosing.getTransfer();
                                subCashBack = subCashBack + salesClosing.getCashBack();
                                subBon = subBon + salesClosing.getBon();
                                subDiscount = subDiscount + salesClosing.getDiscount();
                                subRetur = subRetur + salesClosing.getRetur();
                                subAmount = subAmount + salesClosing.getAmount();
                                subKwitansi = subKwitansi + (salesClosing.getAmount() - salesClosing.getDiscount());

                                totSubCash = totSubCash + salesClosing.getCash();
                                totSubCard = totSubCard + salesClosing.getCCard();
                                totSubDebit = totSubDebit + salesClosing.getDCard();
                                totSubTranfer=totSubTranfer + salesClosing.getTransfer();
                                totSubCashBack = totSubCashBack + salesClosing.getCashBack();
                                totSubBon = totSubBon + salesClosing.getBon();
                                totSubDiscount = totSubDiscount + salesClosing.getDiscount();
                                totSubRetur = totSubRetur + salesClosing.getRetur();
                                totSubAmount = totSubAmount + salesClosing.getAmount();
                                totSubKwitansi = totSubKwitansi + (salesClosing.getAmount() - salesClosing.getDiscount());

                                Vector prints = new Vector();
                                prints.add("" + loc.getName());
                                prints.add("" + shift.getName());
                                prints.add("" + name);
                                prints.add("" + salesClosing.getAmount());
                                prints.add("" + salesClosing.getDiscount());
                                prints.add("" + (salesClosing.getAmount() - salesClosing.getDiscount()));
                                prints.add("" + salesClosing.getCash());
                                prints.add("" + salesClosing.getCCard());
                                prints.add("" + salesClosing.getDCard());
                                prints.add("" + salesClosing.getCashBack());
                                prints.add("" + salesClosing.getBon());
                                prints.add("" + salesClosing.getRetur());
                                tmpPrint.add(prints);
    %>
    <tr height="24">        
        <td align="left" class="<%=style%>" style="padding:3px;"><%if (j == 0) {%><%=loc.getName().toUpperCase()%><%}%></td>
        <td align="left" class="<%=style%>" style="padding:3px;"><%=shift.getName()%></td>
        <td align="left" class="<%=style%>" style="padding:3px;"><%=name%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "###,###.##")%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getDiscount(), "###,###.##")%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber((salesClosing.getAmount() - salesClosing.getDiscount()), "###,###.##")%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getCash(), "###,###.##")%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getCCard(), "###,###.##")%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getDCard(), "###,###.##")%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getTransfer(), "###,###.##")%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getCashBack(), "###,###.##")%></td>
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getBon(), "###,###.##")%></td>        
        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getRetur(), "###,###.##")%></td>
    </tr>
    <%
                    }

                    String style2 = "tablearialcell1";

    %>
    <tr height="24">        
        <td align="center" class="<%=style2%>" colspan="3" style="padding:3px;"><b>S U B &nbsp;&nbsp;&nbsp;    T O T A L</b></td>        
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subAmount, "###,###.##")%></b></td>
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subDiscount, "###,###.##")%></b></td>
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subKwitansi, "###,###.##")%></b></td>
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subCash, "###,###.##")%></b></td>
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subCard, "###,###.##")%></b></td>
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subDebit, "###,###.##")%></b></td>
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subTransfer, "###,###.##")%></b></td>
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subCashBack, "###,###.##")%></b></td>        
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subBon, "###,###.##")%></b></td>        
        <td align="right" class="<%=style2%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(subRetur, "###,###.##")%></b></td>        
    </tr>
    <tr height="3">        
        <td colspan="11" ></td>                
    </tr>
    <%
                    locationPrint.add(tmpPrint);
                }
            }
        }
        String style3 = "tablearialcell1";

    %>
    <tr height="3">        
        <td colspan="11" ></td>                
    </tr>
    <tr height="24">        
        <td align="center" class="<%=style3%>" colspan="3" style="padding:3px;"><b>G R A N D &nbsp;&nbsp;&nbsp;  T O T A L</b></td> 
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubAmount, "###,###.##")%></b></td>
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubDiscount, "###,###.##")%></b></td>
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubKwitansi, "###,###.##")%></b></td>
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubCash, "###,###.##")%></b></td>
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubCard, "###,###.##")%></b></td>        
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubDebit, "###,###.##")%></b></td> 
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubTranfer, "###,###.##")%></b></td>
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubCashBack, "###,###.##")%></b></td>
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubBon, "###,###.##")%></b></td>        
        <td align="right" class="<%=style3%>" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSubRetur, "###,###.##")%></b></td>
    </tr>
    <%
        session.putValue("REPORT_SALES_CLOSING_SUMMARY", locationPrint);
    %>
    <tr > 
        <td colspan="11">
            <a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../../images/printxls2.gif',1)"><img src="../../images/printxls.gif" name="print1" height="22" border="0"></a>
        </td>
    </tr>  
    <% } %>
</table>
