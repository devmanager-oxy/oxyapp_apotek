<script language="JavaScript">
	function hitungMargin(vall){
		var realPrice = document.frmitemmaster.<%=jspVendorItem.colNames[JspVendorItem.JSP_REAL_PRICE]%>.value;
		var lastPrice = realPrice - ((realPrice * vall) / 100);
		document.frmitemmaster.<%=jspVendorItem.colNames[JspVendorItem.JSP_LAST_PRICE]%>.value = lastPrice;
	}
		
	function removeSpaces(string) {
		return string.split(' ').join('');
	}
	
	function splitText(val){				
		var vals = val.split('#');
		return removeSpaces(vals[1]);
	}
	
	/**
	* funsi di gunakan pengambilan persentase margin 
	* berdasarkan parameter yg di pilih
	**/
	function parsing(){
		var val1;
		var selIndex = document.frmitemmaster.<%=jspVendorItem.colNames[JspVendorItem.JSP_VENDOR_ID]%>.selectedIndex;
		val1 = document.frmitemmaster.<%=jspVendorItem.colNames[JspVendorItem.JSP_VENDOR_ID]%>.options[selIndex].text;
		val1 = splitText(val1);
		document.frmitemmaster.<%=jspVendorItem.colNames[JspVendorItem.JSP_MARGIN_PRICE] %>.value = val1;
		
		hitungMargin(val1);
	}
</script>
<table width="100%" border="0" cellspacing="1" cellpadding="0">
                                              <tr align="left"> 
                                                <td height="21" valign="middle" width="16%">&nbsp;</td>
                                                <td height="21" colspan="2" width="84%" class="comment" valign="top">*)= 
                                                  required</td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" valign="top" width="16%">&nbsp;</td>
                                                <td height="21" colspan="2" width="84%" valign="top"> 
                                                  <input type="hidden" name="<%=jspVendorItem.colNames[JspVendorItem.JSP_ITEM_MASTER_ID] %>"  value="<%= itemMaster.getOID() %>" class="formElemen"> 
                                              <tr align="left"> 
                                                
    <td height="21" width="16%">Vendor Name</td>
                                                <td height="21" colspan="2" width="84%" valign="top"> 
                                                  <%
												  String whereVendor = "(is_konsinyasi=1 or is_komisi=1)";
										  		  Vector temp = DbVendor.list(0,0, whereVendor, "name");
										  %> <select name="<%=jspVendorItem.colNames[JspVendorItem.JSP_VENDOR_ID] %>" onChange="javascript:parsing()">
                                                    <%if(temp!=null && temp.size()>0){
													String strMargin = "";
											  		for(int i=0; i<temp.size(); i++){
														Vendor v = (Vendor)temp.get(i);
														strMargin = " # 0";
														if(v.getPercentMargin()>0){
															strMargin = " # "+v.getPercentMargin();
														}
											  %>
                                                    <option value="<%=v.getOID()%>" <%if(v.getOID()==vendorItem.getVendorId()){%>selected<%}%>><%=v.getCode()+ " - "+v.getName()+ "" +strMargin%></option>
                                                    <%}}%>
                                                  </select>
                                                  * <%= jspVendorItem.getErrorMsg(JspVendorItem.JSP_VENDOR_ID) %> 
                                              <tr align="left"> 
                                                <td height="21">Real Price (from 
                                                  Vendor) </td>
                                                <td height="21" colspan="2" valign="top"><input type="text" onKeyUp="javascript:parsing()"   name="<%=jspVendorItem.colNames[JspVendorItem.JSP_REAL_PRICE] %>"  value="<%= JSPFormater.formatNumber(vendorItem.getRealPrice(), "#,###.##") %>" style="text-align:right" class="formElemen"> 
                                              <tr align="left">
                                                <td height="21">Price Margin %</td>
                                                <td height="21" colspan="2" valign="top"><input type="text" name="<%=jspVendorItem.colNames[JspVendorItem.JSP_MARGIN_PRICE] %>"  value="<%= vendorItem.getMarginPrice() %>" class="formElemen" size="5" maxlength="3" style="text-align:right">
                                              <tr align="left"> 
                                                
    <td height="21" width="16%">Vendor Price</td>
                                                <td height="21" colspan="2" width="84%" valign="top"> 
                                                  <input type="text" name="<%=jspVendorItem.colNames[JspVendorItem.JSP_LAST_PRICE] %>"  value="<%= JSPFormater.formatNumber(vendorItem.getLastPrice(), "#,###.##") %>" style="text-align:right" class="formElemen">
                                                  / <%=purUom.getUnit()%> 
                                              <tr align="left"> 
                                                <td height="21" width="16%">Last 
                                                  Discount</td>
                                                <td height="21" colspan="2" width="84%" valign="top"> 
                                                  <input type="text" name="<%=jspVendorItem.colNames[JspVendorItem.JSP_LAST_DISCOUNT] %>"  value="<%= vendorItem.getLastDiscount() %>" class="formElemen" size="5" maxlength="3" style="text-align:right">
                                                  % 
                                              <tr align="left"> 
                                                <td height="8" valign="middle" width="16%">&nbsp;</td>
                                                <td height="8" colspan="2" width="84%" valign="top">&nbsp; 
                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="3" class="command" valign="top"> 
                                                  <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidVendorItem+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidVendorItem+"')";
									String scancel = "javascript:cmdEdit('"+oidVendorItem+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");
										
										ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									
									ctrLine.setWidthAllJSPCommand("90");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setQuestionStyle("warning");
									ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setInfoStyle("success");
									ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

									if (privDelete){
										ctrLine.setConfirmDelJSPCommand(sconDelCom);
										ctrLine.setDeleteJSPCommand(scomDel);
										ctrLine.setEditJSPCommand(scancel);
									}else{ 
										ctrLine.setConfirmDelCaption("");
										ctrLine.setDeleteCaption("");
										ctrLine.setEditCaption("");
									}

									if(privAdd == false  && privUpdate == false){
										ctrLine.setSaveCaption("");
									}

									if (privAdd == false){
										ctrLine.setAddCaption("");
									}
									%> <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="16%">&nbsp;</td>
                                                <td width="84%">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="3" valign="top"> 
                                                  <div align="left"></div></td>
                                              </tr>
                                            </table>