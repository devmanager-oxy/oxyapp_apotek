<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan="2" height="5"></td>
    </tr>
    <tr> 
        <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
    </tr>
    <tr> 
        <td colspan="2" height="5"></td>
    </tr>
    <tr> 
        <td width="38%" valign="middle"> 
        </td>
        <td width="55%"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="62%" class="fontarial"> 
                        <div align="right"><b>Sub Total</b></div>                        
                    </td>
                    <td width="15%"> 
                        <input type="hidden" name="sub_tot" value="<%=recTotal.getTotalAmount()%>">
                    </td>
                    <td width="23%" class="fontarial"> 
                        <div align="right">
                            <%=JSPFormater.formatNumber(recTotal.getTotalAmount(), "#,###.##")%>
                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(recTotal.getTotalAmount(), "#,###.##")%>" style="text-align:right">
                        </div>
                        <%ig.setSubTotal(recTotal.getTotalAmount());%>
                    </td>
                </tr>
                <tr> 
                    <td width="60%" class="fontarial"> 
                        <div align="right"><b>Discount</b></div>
                    </td>
                    <td width="17%" class="fontarial"> 
                        <div align="center"> 
                            <%=receive.getDiscountPercent()%>
                            <input name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>" type="hidden" value="<%=receive.getDiscountPercent()%>" size="5" style="text-align:center" onBlur="javascript:calculateAmount()" onClick="this.select()">
                        % </div>
                        <%ig.setDiscount1(receive.getDiscountPercent());%>
                    </td>
                    <td width="23%"> 
                        <div align="right"> 
                            <%=JSPFormater.formatNumber(recTotal.getDiscountTotal(), "#,###.##")%>
                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(recTotal.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                        </div>
                        <%ig.setDiscount2(recTotal.getDiscountTotal());%>
                    </td>
                </tr>
                <tr> 
                    <td width="60%" class="fontarial"> 
                        <div align="right"><b>VAT</b></div>
                    </td>
                    <td width="17%" class="fontarial"> 
                        <div align="center">
                            <%=receive.getTaxPercent()%>
                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>" size="5" value="<%=receive.getTaxPercent()%>" readOnly class="readOnly" style="text-align:center">
                        % </div>
                        <%ig.setVat1(receive.getTaxPercent());%>
                    </td>
                    <td width="23%" class="fontarial"> 
                        <div align="right" class="fontarial"> 
                            <%=JSPFormater.formatNumber(recTotal.getTotalTax(), "#,###.##")%>
                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(recTotal.getTotalTax(), "#,###.##")%>" style="text-align:right">
                        </div>
                        <%ig.setVat2(recTotal.getTotalTax());%>
                    </td>
                </tr>
                <tr> 
                    <td width="60%" class="fontarial"> 
                        <div align="right"><b>Grand Total</b></div>
                    </td>
                    <td width="17%">&nbsp;</td>
                    <td width="23%" class="fontarial"> 
                        <div align="right"> 
                            <%=JSPFormater.formatNumber(recTotal.getTotalAmount() + recTotal.getTotalTax() - recTotal.getDiscountTotal(), "#,###.##")%>
                            <input type="hidden" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(recTotal.getTotalAmount() + recTotal.getTotalTax() - recTotal.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                        </div>
                        <%ig.setGrandTotal(recTotal.getTotalAmount() + recTotal.getTotalTax() - recTotal.getDiscountTotal());%>
                    </td>
                </tr>
                <tr> 
                    <td width="60%">&nbsp;</td>
                    <td width="17%">&nbsp;</td>
                    <td width="23%">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>