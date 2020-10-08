
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("No","2%"); 
		jsplist.addHeader("Code/Name","15%");
		jsplist.addHeader("Price","5%");
		jsplist.addHeader("Qty","3%");
		jsplist.addHeader("Uom","5%");
		jsplist.addHeader("Discount","5%");
		jsplist.addHeader("Total","8%");
		jsplist.addHeader("Delivery Date","7%");
                
		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		for (int i = 0; i < objectClass.size(); i++) {
			 PurchaseItem purchaseItem = (PurchaseItem)objectClass.get(i);
			 rowx = new Vector();
                        ItemMaster itemMaster = new ItemMaster();
                        try{
                                itemMaster = DbItemMaster.fetchExc(purchaseItem.getItemMasterId());
                        }catch(Exception e){}

                        Uom uom = new Uom();
                        try{
                                uom = DbUom.fetchExc(purchaseItem.getUomId());
                        }catch(Exception e){}
                        rowx.add("<div align=\"center\">"+(i+1)+"</div>");		
                        rowx.add("<a href=\"javascript:cmdEditItem('"+String.valueOf(purchaseItem.getOID())+"')\">"+itemMaster.getCode()+" / "+itemMaster.getName()+"</a>");
                        rowx.add("<div align=\"right\">"+purchaseItem.getAmount()+"</div>");
                        rowx.add("<div align=\"right\">"+purchaseItem.getQty()+"</div>");
                        rowx.add("<div align=\"right\">"+uom.getUnit()+"</div>");
                        rowx.add("<div align=\"right\">"+purchaseItem.getTotal_discount()+"</div>");
                        rowx.add("<div align=\"right\">"+purchaseItem.getTotal_amount()+"</div>");
                        rowx.add("<div align=\"center\">"+purchaseItem.getDelivery_date()+"</div>");

			lstData.add(rowx);
		}
		return jsplist.draw(index);
	}
%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPurchase = JSPRequestValue.requestLong(request, "hidden_purchase_id");
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidPurchase =0;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPurchase cmdPurchase = new CmdPurchase(request);
JSPLine ctrLine = new JSPLine();
iErrCode = cmdPurchase.action(iJSPCommand , oidPurchase);
JspPurchase jspPurchase = cmdPurchase.getForm();
Purchase purchase = cmdPurchase.getPurchase();
msgString =  cmdPurchase.getMessage();
        
if(oidPurchase==0){
    oidPurchase = purchase.getOID();
}else{
        if(iJSPCommand==JSPCommand.DELETE)
            oidPurchase=0;
    }

whereClause = DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+"="+oidPurchase;
orderClause = DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ITEM_ID];
Vector purchReqItems = DbPurchaseItem.list(0,0, whereClause, orderClause);

Vector exchanges = DbExchangeRate.list(0,0, "", DbExchangeRate.fieldNames[DbExchangeRate.FLD_DATE]+" desc ");
ExchangeRate exchangeRate = new ExchangeRate();
if(exchanges.size()>0){
    exchangeRate = (ExchangeRate)exchanges.get(0);
}


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--

function checkRate(){
    var oid = document.frmpurchase.<%=jspPurchase.colNames[JspPurchase.JSP_CURRENCY_ID]%>.value;
    switch(oid){
        case '<%=exchangeRate.getCurrencyIdrId()%>':
            document.all.exc_rate.innerHTML = 'Used Rate : <%=exchangeRate.getValueIdr()%>';
            break;
        case '<%=exchangeRate.getCurrencyEuroId()%>':
            document.all.exc_rate.innerHTML = 'Used Rate : <%=exchangeRate.getValueEuro()%>';
            break;
        case '<%=exchangeRate.getCurrencyUsdId()%>':
            document.all.exc_rate.innerHTML = 'Used Rate : <%=exchangeRate.getValueUsd()%>';
            break;
        default:    
            document.all.exc_rate.innerHTML = 'Used Rate :';
            break;
        }
    }
    
function cmdAdd(){
	document.frmpurchase.hidden_purchase_item_id.value="0";
	document.frmpurchase.command.value="<%=JSPCommand.ADD%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdAsk(oidPurchase){
	document.frmpurchase.hidden_purchase_id.value=oidPurchase;
	document.frmpurchase.command.value="<%=JSPCommand.ASK%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchase.jsp";
	document.frmpurchase.submit();
}

function cmdConfirmDelete(oidPurchase){
	document.frmpurchase.hidden_purchase_id.value=oidPurchase;
	document.frmpurchase.command.value="<%=JSPCommand.DELETE%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchase.jsp";
	document.frmpurchase.submit();
}
function cmdSave(){
	document.frmpurchase.command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchase.jsp";
	document.frmpurchase.submit();
	}

function cmdEdit(oidPurchase){
	document.frmpurchase.hidden_purchase_id.value=oidPurchase;
	document.frmpurchase.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchase.jsp";
	document.frmpurchase.submit();
	}

function cmdEditItem(oidPurchaseItem){
	document.frmpurchase.hidden_purchase_item_id.value=oidPurchaseItem;
	document.frmpurchase.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
	}
         
function cmdCancel(oidPurchase){
	document.frmpurchase.hidden_purchase_id.value=oidPurchase;
	document.frmpurchase.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchase.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchase.action="purchase.jsp";
	document.frmpurchase.submit();
}

function cmdBack(){
	document.frmpurchase.command.value="<%=JSPCommand.BACK%>";
	document.frmpurchase.action="purchase.jsp";
	document.frmpurchase.submit();
	}

function cmdListFirst(){
	document.frmpurchase.command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchase.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdListPrev(){
	document.frmpurchase.command.value="<%=JSPCommand.PREV%>";
	document.frmpurchase.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
	}

function cmdListNext(){
	document.frmpurchase.command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchase.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

function cmdListLast(){
	document.frmpurchase.command.value="<%=JSPCommand.LAST%>";
	document.frmpurchase.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpurchase.action="purchaseitem.jsp";
	document.frmpurchase.submit();
}

//-------------- script control line -------------------
	function MM_swapImgRestore() { //v3.0
		var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

function MM_preloadImages() { //v3.0
		var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
//-->
</script>
               
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpurchase" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=jspPurchase.colNames[JspPurchase.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_purchase_item_id" value="0">
                          <input type="hidden" name="hidden_purchase_id" value="<%=oidPurchase%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;Purchase 
                                              Order&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <%if((iJSPCommand !=JSPCommand.DELETE)){%>
                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                              <tr align="left"> 
                                                <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                <td height="21" valign="middle" width="30%">&nbsp;</td>
                                                <td height="21" valign="middle" width="11%">&nbsp;</td>
                                                <td height="21" colspan="2" width="47%" class="comment" valign="top">
                                                  <div align="right"><i>Date : 
                                                    <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                    <%if(purchaseRequest.getOID()==0){%>
                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                    <%}else{
											User us = new User();
											try{
												us = DbUser.fetch(purchaseRequest.getUserId());
											}
											catch(Exception e){
											}
											%>
                                                    Prepared By : <%=us.getLoginId()%> 
                                                    <%}%>
                                                    </i>&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                <td height="21" valign="middle" width="30%">&nbsp;</td>
                                                <td height="21" valign="middle" width="11%">&nbsp;</td>
                                                <td height="21" colspan="2" width="47%" class="comment" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="26" valign="middle" width="12%">&nbsp;&nbsp;Vendor</td>
                                                <td height="26" valign="middle" width="30%"> 
                                                  <select name="<%=JspPurchase.colNames[JspPurchase.JSP_VENDOR_ID]%>">
                                                    <%                                          Vector vendors = DbVendor.list(0,0, "", "code");
											  if(vendors!=null && vendors.size()>0){
											  	for(int i=0; i<vendors.size(); i++){
											  		Vendor d = (Vendor)vendors.get(i);
													%>
                                                    <option value="<%=d.getOID()%>" <%if(purchase.getVendor_id()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                                <td height="26" valign="middle" width="11%">PO 
                                                  Number</td>
                                                <td height="26" colspan="2" width="47%" class="comment"><%=purchase.getNumber()%></td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21">&nbsp;&nbsp;Location</td>
                                                <td height="21"> 
                                                  <select name="<%=JspPurchase.colNames[JspPurchase.JSP_LOCATION_ID]%>">
                                                    <%                                          Vector locations = DbLocation.list(0,0, "", "code");
											  if(locations!=null && locations.size()>0){
											  	for(int i=0; i<locations.size(); i++){
											  		Location d = (Location)locations.get(i);
													%>
                                                    <option value="<%=d.getOID()%>" <%if(purchase.getLocation_id()==d.getOID()){%>selected<%}%>><%=d.getCode()+" - "+d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                                <td>Document Status</td>
                                                <td colspan="2" class="comment"> 
                                                  <% 
                                                Vector status_value = new Vector(1,1);
						Vector status_key = new Vector(1,1);
					 	String sel_status = ""+purchase.getStatus();
                                                status_key.add(DbPurchase.strStatus[DbPurchase.STATUS_DRAFT]);
                                                status_value.add(DbPurchase.strStatus[DbPurchase.STATUS_DRAFT]);
                                                status_key.add(DbPurchase.strStatus[DbPurchase.STATUS_PROCESS]);
                                                status_value.add(DbPurchase.strStatus[DbPurchase.STATUS_PROCESS]);
                                                status_key.add(DbPurchase.strStatus[DbPurchase.STATUS_CLOSE]);
                                                status_value.add(DbPurchase.strStatus[DbPurchase.STATUS_CLOSE]);
					   %>
                                                  <%= JSPCombo.draw(jspPurchase.colNames[JspPurchase.JSP_STATUS],null, sel_status, status_key, status_value, "", "formElemen") %> </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21">&nbsp;&nbsp;Currency</td>
                                                <td height="21"> 
                                                  <%
                                              Vector currs = DbCurrency.list(0, 0, "", "");
                                              Vector exchange_value = new Vector(1,1);
                                                    Vector exchange_key = new Vector(1,1);
                                                    String sel_exchange = ""+purchase.getCurrency_id();
                                                  if(currs!=null && currs.size()>0){
                                                        for(int i=0; i<currs.size(); i++){
                                                            Currency d = (Currency)currs.get(i);
                                                            exchange_key.add(""+d.getOID());
                                                            exchange_value.add(d.getCurrencyCode());
                                                        }
                                                  }          
                                              %>
                                                  <%= JSPCombo.draw(jspPurchase.colNames[JspPurchase.JSP_CURRENCY_ID],null, sel_exchange, exchange_key, exchange_value, "onchange=\"javascript:checkRate()\"", "formElemen") %> 
                                                  <input type="hidden" name="<%=jspPurchase.colNames[JspPurchase.JSP_EXCHANGERATE_ID]%>" value="<%=exchangeRate.getOID()%>">
                                                  <a id="exc_rate"></a> </td>
                                                <td width="11%">Include Tax</td>
                                                <td width="47%" colspan="2" class="comment"> 
                                                  <% 
                                                Vector include_value = new Vector(1,1);
						Vector include_key = new Vector(1,1);
					 	String sel_include = ""+purchase.getIncluce_tax();
                                                include_value.add(DbPurchase.strIncludeTax[DbPurchase.INCLUDE_TAX_NO]);
                                                include_key.add(""+DbPurchase.INCLUDE_TAX_NO);
                                                include_value.add(DbPurchase.strIncludeTax[DbPurchase.INCLUDE_TAX_YES]);
                                                include_key.add(""+DbPurchase.INCLUDE_TAX_YES);
					   %>
                                                  <%= JSPCombo.draw(jspPurchase.colNames[JspPurchase.JSP_INCLUDE_TAX],null, sel_include, include_key, include_value, "", "formElemen") %> 
                                                  <input type="text" name="<%=JspPurchase.colNames[JspPurchase.JSP_TAX_PERCENT]%>" size="6" value="<%=purchase.getTax_percent()%>">
                                                  % </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="30%"> 
                                                  <input name="<%=jspPurchase.colNames[JspPurchase.JSP_PURCH_DATE]%>" value="<%=JSPFormater.formatDate((purchase.getPurch_date()==null) ? new Date() : purchase.getPurch_date(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpurchase.<%=jspPurchase.colNames[JspPurchase.JSP_PURCH_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                </td>
                                                <td width="11%">Discount</td>
                                                <td width="47%" colspan="2" class="comment"> 
                                                  <input name="<%=jspPurchase.colNames[JspPurchase.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=purchase.getDiscount_percent()%>" size="6">
                                                  % </td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td height="21">&nbsp;&nbsp;Payment 
                                                  Type </td>
                                                <td height="21"> 
                                                  <% 
                                                Vector payment_value = new Vector(1,1);
						Vector payment_key = new Vector(1,1);
					 	String sel_payment = ""+purchase.getPayment_type();
                                                payment_key.add(DbPurchase.strPaymentType[DbPurchase.PAYMENT_TYPE_CASH]);
                                                payment_value.add(DbPurchase.strPaymentType[DbPurchase.PAYMENT_TYPE_CASH]);
                                                payment_key.add(DbPurchase.strPaymentType[DbPurchase.PAYMENT_TYPE_CREDIT]);
                                                payment_value.add(DbPurchase.strPaymentType[DbPurchase.PAYMENT_TYPE_CREDIT]);
					   %>
                                                  <%= JSPCombo.draw(jspPurchase.colNames[JspPurchase.JSP_PAYMENT_TYPE],null, sel_payment, payment_key, payment_value, "", "formElemen") %> </td>
                                                <td width="11%">Notes</td>
                                                <td width="47%" colspan="2" class="comment"> 
                                                  <textarea name="<%=jspPurchase.colNames[JspPurchase.JSP_NOTE]%>" cols="40"><%=purchase.getNote()%></textarea>
                                                </td>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top"> 
                                                  <div align="left"> 
                                                    <%                                                                        
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidPurchase+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPurchase+"')";
									String scancel = "javascript:cmdEdit('"+oidPurchase+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									ctrLine.setDeleteCaption("Delete");
									
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
									if((iJSPCommand==JSPCommand.ADD) || (iJSPCommand==JSPCommand.EDIT))
										ctrLine.setBackCaption("");
									
									if((iJSPCommand==JSPCommand.SAVE && iErrCode==0)){
										iJSPCommand=JSPCommand.EDIT;
										ctrLine.setBackCaption("");
									}	
									
									%>
                                                    <%//if(iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK || iErrCode!=0){%>
                                                    <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                    <%//}%>
                                                  </div>
                                                </td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;&nbsp;List 
                                                  of Item PO</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;<%=drawList(purchReqItems)%></td>
                                              </tr>
                                              <%if(oidPurchase!=0){%>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                              </tr>
                                              <%}%>
                                            </table>
                                            <%}else{%>
                                            <br>
                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                              <tr> 
                                                <td width="20"><img src="/ccs/images/success.gif" width="20" height="20"></td>
                                                <td width="200" nowrap>Data is 
                                                  deleted</td>
                                              </tr>
                                            </table>
                                            <%}%>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
                            checkRate();  
                        </script>
                        </form>
                        Transaction 
                        &raquo; <span class="level2">Purchase Order<br>
                        </span><!-- #EndEditable -->
                      </td>
                    </tr>
                    
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="25"> 
            <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
