
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.request.*" %>
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
		jsplist.setAreaWidth("80%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");
		
		jsplist.addHeader("No","3%");
		jsplist.addHeader("Code/Name","25%");
		jsplist.addHeader("Qty","5%");
		jsplist.addHeader("Uom","5%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		for (int i = 0; i < objectClass.size(); i++) {
			 PurchaseRequestItem purchaseRequestItem = (PurchaseRequestItem)objectClass.get(i);
			 rowx = new Vector();
			ItemMaster itemMaster = new ItemMaster();
			try{
				itemMaster = DbItemMaster.fetchExc(purchaseRequestItem.getItemMasterId());
			}catch(Exception e){}
			Uom uom = new Uom();
			try{
				uom = DbUom.fetchExc(purchaseRequestItem.getUomId());
			}catch(Exception e){}

				rowx.add("<div align=\"center\">"+(i+1)+"</div>");		
                rowx.add("<a href=\"javascript:cmdEditItem('"+String.valueOf(purchaseRequestItem.getOID())+"')\">"+itemMaster.getCode()+" / "+itemMaster.getName()+"</a>");
				rowx.add("<div align=\"right\">"+purchaseRequestItem.getQty()+"</div>");
				rowx.add("<div align=\"center\">"+uom.getUnit()+"</div>");

			lstData.add(rowx);
		}
		return jsplist.draw(index);
	}
%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPurchaseRequest = JSPRequestValue.requestLong(request, "hidden_purchase_request_id");
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
	oidPurchaseRequest =0;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPurchaseRequest ctrlPurchaseRequest = new CmdPurchaseRequest(request);
JSPLine ctrLine = new JSPLine();
iErrCode = ctrlPurchaseRequest.action(iJSPCommand , oidPurchaseRequest);
JspPurchaseRequest jspPurchaseRequest = ctrlPurchaseRequest.getForm();
PurchaseRequest purchaseRequest = ctrlPurchaseRequest.getPurchaseRequest();
msgString =  ctrlPurchaseRequest.getMessage();
        
if(oidPurchaseRequest==0){
    oidPurchaseRequest = purchaseRequest.getOID();
}else{
        if(iJSPCommand==JSPCommand.DELETE)
            oidPurchaseRequest=0;
    }

whereClause = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]+"="+oidPurchaseRequest;
orderClause = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ITEM_ID];
Vector purchReqItems = DbPurchaseRequestItem.list(0,0, whereClause, orderClause);
Vector deps = DbDepartment.list(0,0, "", "code");

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--
function cmdAdd(){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value="0";
	document.frmpurchaserequest.command.value="<%=JSPCommand.ADD%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdAsk(oidPurchaseRequest){
	document.frmpurchaserequest.hidden_purchase_request_id.value=oidPurchaseRequest;
	document.frmpurchaserequest.command.value="<%=JSPCommand.ASK%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequest.jsp";
	document.frmpurchaserequest.submit();
}

function cmdConfirmDelete(oidPurchaseRequest){
	document.frmpurchaserequest.hidden_purchase_request_id.value=oidPurchaseRequest;
	document.frmpurchaserequest.command.value="<%=JSPCommand.DELETE%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequest.jsp";
	document.frmpurchaserequest.submit();
}
function cmdSave(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.SAVE%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequest.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdEdit(oidPurchaseRequest){
	document.frmpurchaserequest.hidden_purchase_request_id.value=oidPurchaseRequest;
	document.frmpurchaserequest.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequest.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdEditItem(oidPurchaseRequestItem){
	document.frmpurchaserequest.hidden_purchase_request_item_id.value=oidPurchaseRequestItem;
	document.frmpurchaserequest.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
	}
         
function cmdCancel(oidPurchaseRequest){
	document.frmpurchaserequest.hidden_purchase_request_id.value=oidPurchaseRequest;
	document.frmpurchaserequest.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="purchaserequest.jsp";
	document.frmpurchaserequest.submit();
}

function cmdBack(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.BACK%>";
	document.frmpurchaserequest.action="purchaserequest.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdListFirst(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdListPrev(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.PREV%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdListNext(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
}

function cmdListLast(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.LAST%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpurchaserequest.action="purchaserequestitem.jsp";
	document.frmpurchaserequest.submit();
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
                        <form name="frmpurchaserequest" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=jspPurchaseRequest.colNames[JspPurchaseRequest.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_purchase_request_item_id" value="0">
                          <input type="hidden" name="hidden_purchase_request_id" value="<%=oidPurchaseRequest%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top" class="container"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <%if((iJSPCommand !=JSPCommand.DELETE)){%> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="12%">&nbsp;</td>
                                          <td height="21" valign="middle" width="30%">&nbsp;</td>
                                          <td height="21" valign="middle" width="11%">&nbsp;</td>
                                          <td height="21" colspan="2" width="47%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="26" valign="middle" width="12%">&nbsp;&nbsp;Department</td>
                                          <td height="26" valign="middle" width="30%"><select name="<%=JspPurchaseRequest.colNames[JspPurchaseRequest.JSP_DEPARTMENT_ID]%>">
                                              <%
											  if(deps!=null && deps.size()>0){
											  	for(int i=0; i<deps.size(); i++){
											  		Department d = (Department)deps.get(i);
													String str = "";
													if(d.getLevel()==1){
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}
													else if(d.getLevel()==2){
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}
													else if(d.getLevel()==3){
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}	
													%>
                                              <option value="<%=d.getOID()%>" <%if(purchaseRequest.getDepartment_id()==d.getOID()){%>selected<%}%>><%=str+d.getCode()+" - "+d.getName()%></option>
                                              <%}}%>
                                            </select></td>
                                          <td height="26" valign="middle" width="11%">Number</td>
                                          <td height="26" colspan="2" width="47%" class="comment"><%=purchaseRequest.getNumber()%></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                          <td height="21" width="30%"><input name="<%=jspPurchaseRequest.colNames[JspPurchaseRequest.JSP_REQ_DATE]%>" value="<%=JSPFormater.formatDate((purchaseRequest.getReq_date()==null) ? new Date() : purchaseRequest.getReq_date(), "dd/MM/yyyy")%>" size="11" readonly> 
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpurchaserequest.<%=jspPurchaseRequest.colNames[JspPurchaseRequest.JSP_REQ_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                          </td>
                                          <td width="11%" rowspan="2">Notes</td>
                                          <td width="47%" colspan="2" rowspan="2" class="comment"> 
                                            <textarea name="<%=jspPurchaseRequest.colNames[JspPurchaseRequest.JSP_NOTE]%>" cols="40"><%=purchaseRequest.getNote()%></textarea> 
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="21">&nbsp;&nbsp;Status</td>
                                          <td height="21"> <% 
                                                Vector status_value = new Vector(1,1);
						Vector status_key = new Vector(1,1);
					 	String sel_status = ""+purchaseRequest.getStatus();
                                                status_key.add(DbPurchaseRequest.strStatus[DbPurchaseRequest.STATUS_DRAFT]);
                                                status_value.add(DbPurchaseRequest.strStatus[DbPurchaseRequest.STATUS_DRAFT]);
                                                status_key.add(DbPurchaseRequest.strStatus[DbPurchaseRequest.STATUS_PROCESS]);
                                                status_value.add(DbPurchaseRequest.strStatus[DbPurchaseRequest.STATUS_PROCESS]);
                                                status_key.add(DbPurchaseRequest.strStatus[DbPurchaseRequest.STATUS_CLOSE]);
                                                status_value.add(DbPurchaseRequest.strStatus[DbPurchaseRequest.STATUS_CLOSE]);
					   %> <%= JSPCombo.draw(jspPurchaseRequest.colNames[JspPurchaseRequest.JSP_STATUS],null, sel_status, status_key, status_value, "", "formElemen") %> * <%= jspPurchaseRequest.getErrorMsg(JspPurchaseRequest.JSP_STATUS) %> </td>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top"> <div align="left"> 
                                              <%                                                                        
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidPurchaseRequest+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPurchaseRequest+"')";
									String scancel = "javascript:cmdEdit('"+oidPurchaseRequest+"')";
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
                                            </div></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;&nbsp;List 
                                            of Item PR</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;<%=drawList(purchReqItems)%></td>
                                        </tr>
										<%if(oidPurchaseRequest!=0){%>
                                        <tr align="left" > 
                                          <td colspan="5" valign="top">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
										<%}%>
                                      </table>
                                      <%}else{%><br><table border="0" cellpadding="5" cellspacing="0" class="success"><tr><td width="20"><img src="/ccs/images/success.gif" width="20" height="20"></td><td width="200" nowrap>Data is deleted</td></tr></table><%}%></td>
                                  </tr>
                                </table></td>
  </tr>
</table>
                          
                        </form>
                        Transaction 
                        &raquo; <span class="level2">Purchase Request<br>
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
