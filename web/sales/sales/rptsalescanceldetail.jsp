<%
            Vector list = getSalesAndDetail(salesOid);
            Sales sales = new Sales();
            Vector listitem = new Vector();
            try {
                if (list.size() > 0) {
                    sales = (Sales) list.get(0);
                    listitem = (Vector) list.get(1);
                }
            } catch (Exception e) {
            }
%>
<link href="../css/csssl.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" cellspacing="2" cellpadding="0">
    <tr>
        <td colspan="4" >&nbsp;</td>
    </tr>    
    <tr>
        <td colspan="4" class="fontarial"><i><u><b>Sales Detail</b></u></i></td>
    </tr>
    <%
            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(sales.getCurrencyId());
            } catch (Exception e) {
            }

            Shift shift = new Shift();
            try {
                shift = DbShift.fetchExc(sales.getCategoryId());
            } catch (Exception e) {
            }

            String cashierx = "";
            String approvedx = "";
            try {
                cashierx = getUser(sales.getUserId());
            } catch (Exception e) {
            }
            
            
            try {
                approvedx = getUser(sales.getEmployeeId());
            } catch (Exception e) {
            }

    %>
    <tr>
        <td width="100" class="fontarial"><i>Number</i></td>
        <td width="42%" class="fontarial">: <b><%=sales.getNumber()%></b></td>
        <td width="7%" class="fontarial"><i>Location</i></td>
        <td class="fontarial">: <b><%=loc.getName()%></b></td>
    </tr>
    <tr>
        <td class="fontarial"><i>Date</i></td>
        <td class="fontarial">: <b><%=sales.getDate()%></b></td>
        <td class="fontarial"><i>Cashier</i></td>
        <td class="fontarial">: <b><%=cashierx%></b></td>
    </tr>
    <%
            String cstNamex = "";
            if (sales.getCustomerId() == oidPublic) {
                cstNamex = "Public";
            } else {
                try {
                    cstNamex = getCustomer(sales.getCustomerId());
                } catch (Exception e) {
                }
            }

    %>
    <tr>
        <td class="fontarial"><i>Member</i></td>
        <td class="fontarial">: <b><%=cstNamex%></b></td>
        <td class="fontarial"><i>Shift</i></td>
        <td class="fontarial">: <b><%=shift.getName()%></b></td>
    </tr>
    <tr>
        <td class="fontarial"><i>Approved By</i></td>
        <td class="fontarial">: <b><%=approvedx%></b></td>    
    </tr>
    <tr>
        <td colspan="4">
            <table width="100%" border="0" cellpadding="1" cellspacing="1" class="tabheader">
                <tr>
                    <td width="6%" class="tablearialhdr">No</td>
                    <td width="18%" class="tablearialhdr">SKU/Barcode</td>
                    <td width="33%" class="tablearialhdr">Description</td>
                    <td width="9%" class="tablearialhdr">Qty</td>
                    <td width="13%" class="tablearialhdr">Price</td>
                    <td width="10%" class="tablearialhdr">Discount</td>
                    <td width="11%" class="tablearialhdr">Total</td>
                </tr>
                <%
            double total = 0;
            double totalQty = 0;

            if (listitem.size() > 0) {
                for (int k = 0; k < listitem.size(); k++) {
                    Vector item = (Vector) listitem.get(k);

                    double price = Double.parseDouble((String) item.get(2));
                    double discount = Double.parseDouble((String) item.get(3));
                    double qty = Double.parseDouble((String) item.get(4));

                    if (sales.getType() == 2 || sales.getType() == 3) {
                        if (qty != 0) {
                            qty = qty * -1;
                        }
                        if (discount != 0) {
                            discount = discount * -1;
                        }
                    }


                    totalQty = totalQty + qty;
                    total = total + ((qty * price) - discount);

                %>
                <tr>
                    <td class="tablearialcell" align="center"><%=(k + 1)%></td>
                    <td class="tablearialcell" style="padding:3px;"><%=item.get(0)%></td>
                    <td class="tablearialcell" style="padding:3px;"><%=item.get(1)%></td>
                    <td align="right" class="tablearialcell" style="padding:3px;"><%=JSPFormater.formatNumber(qty, "###,###.##")%></td>
                    <td align="right" class="tablearialcell" style="padding:3px;"><%=JSPFormater.formatNumber(price, "###,###.##")%></td>
                    <td align="right" class="tablearialcell" style="padding:3px;"><%=JSPFormater.formatNumber(discount, "###,###.##")%></td>
                    <td align="right" class="tablearialcell" style="padding:3px;"><%=JSPFormater.formatNumber(((qty * price) - discount), "###,###.##")%></td>
                </tr>
                <%
                }
            }
                %>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td bgcolor="#cccccc" class="fontarial" align="center"><b><i>Total</i></b></td>
                    <td class="tablearialcell" align="right" style="padding:3px;"><b><i><%=JSPFormater.formatNumber(totalQty, "###,###.##")%></i></b></td>
                    <td class="tablearialcell" >&nbsp;</td>                                        
                    <td class="tablearialcell" >&nbsp;</td>                                        
                    <td align="right" class="tablearialcell">&nbsp;<b><i><%=JSPFormater.formatNumber(total, "###,###.##")%></i></b></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
