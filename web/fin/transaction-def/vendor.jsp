<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean purchasePriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_VENDOR);
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long vendorId)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("90%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("Code","10%");
		cmdist.addHeader("Name","20%");
		cmdist.addHeader("Address","25%");
		cmdist.addHeader("Phone / Fax","15%");
		cmdist.addHeader("Contact","15%");
		cmdist.addHeader("Hp","10%");		
		cmdist.addHeader("Due Date","5%");

		cmdist.setLinkRow(0);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Vendor vendor = (Vendor)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(vendorId == vendor.getOID())
				 index = i;

			rowx.add(vendor.getCode());

			rowx.add(vendor.getName());

			rowx.add(vendor.getAddress()+((vendor.getCity().length()>0) ? ", "+vendor.getCity() : ""));

			rowx.add(vendor.getPhone()+" / "+((vendor.getFax().length()>0)? vendor.getFax() : "-"));
			
			rowx.add(vendor.getContact());

			rowx.add(vendor.getHp());

			rowx.add("<div align=\"right\">"+String.valueOf(vendor.getDueDate())+"</div>");

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(vendor.getOID()));
		}

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidVendor = JSPRequestValue.requestLong(request, "hidden_vendor_id");
int returnPage = JSPRequestValue.requestInt(request, "return_page");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdVendor ctrlVendor = new CmdVendor(request);
JSPLine ctrLine = new JSPLine();
Vector listVendor = new Vector(1,1);

/*switch statement */
iErrCode = ctrlVendor.action(iJSPCommand , oidVendor);
/* end switch*/
JspVendor jspVendor = ctrlVendor.getForm();

/*count list All Vendor*/
int vectSize = DbVendor.getCount(whereClause);

Vendor vendor = ctrlVendor.getVendor();
msgString =  ctrlVendor.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlVendor.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listVendor = DbVendor.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listVendor.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listVendor = DbVendor.list(start,recordToGet, whereClause , orderClause);
}

if(iJSPCommand==JSPCommand.SAVE && iErrCode==0){
	vendor = new Vendor();
	iJSPCommand = JSPCommand.ADD;
}

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- #BeginTemplate "/Templates/clean.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!purchasePriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && vendor.getOID()!=0){
	if(returnPage==0){
%>
		//alert('submit and close');
		//alert('vendor.getOID() : '+<%=vendor.getOID()%>);
		self.opener.frmbanknonpopaymentdetail.<%=JspBanknonpoPayment.colNames[JspBanknonpoPayment.JSP_VENDOR_ID]%>.value="<%=vendor.getOID()%>";	
		self.opener.frmbanknonpopaymentdetail.xxx.value="<%=vendor.getOID()%>";	
		self.opener.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.PRINT%>";
		self.opener.frmbanknonpopaymentdetail.select_idx.value="-1";
		self.opener.frmbanknonpopaymentdetail.submit();
		self.close();
<%	}else{%>
		//alert('submit and close');
		//alert('vendor.getOID() : '+<%=vendor.getOID()%>);
		self.opener.frmpurchaseitem.<%=JspPurchase.colNames[JspPurchase.JSP_VENDOR_ID]%>.value="<%=vendor.getOID()%>";	
		self.opener.frmpurchaseitem.xxx.value="<%=vendor.getOID()%>";	
		self.opener.frmpurchaseitem.command.value="<%=JSPCommand.PRINT%>";
		self.opener.frmpurchaseitem.select_idx.value="-1";
		self.opener.frmpurchaseitem.submit();
		self.close();
<%	}
}%>

function cmdCloseX(){
	window.close();
}

function cmdAdd(){
	document.frmvendor.hidden_vendor_id.value="0";
	document.frmvendor.command.value="<%=JSPCommand.ADD%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
}

function cmdAsk(oidVendor){
	document.frmvendor.hidden_vendor_id.value=oidVendor;
	document.frmvendor.command.value="<%=JSPCommand.ASK%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
}

function cmdConfirmDelete(oidVendor){
	document.frmvendor.hidden_vendor_id.value=oidVendor;
	document.frmvendor.command.value="<%=JSPCommand.DELETE%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
}
function cmdSave(){
	document.frmvendor.command.value="<%=JSPCommand.SAVE%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
	}

function cmdSubmit(){
	document.frmvendor.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
	}

function cmdEdit(oidVendor){
	document.frmvendor.hidden_vendor_id.value=oidVendor;
	document.frmvendor.command.value="<%=JSPCommand.EDIT%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
	}

function cmdCancel(oidVendor){
	document.frmvendor.hidden_vendor_id.value=oidVendor;
	document.frmvendor.command.value="<%=JSPCommand.EDIT%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
}

function cmdBack(){
	document.frmvendor.command.value="<%=JSPCommand.BACK%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
	}

function cmdListFirst(){
	document.frmvendor.command.value="<%=JSPCommand.FIRST%>";
	document.frmvendor.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
}

function cmdListPrev(){
	document.frmvendor.command.value="<%=JSPCommand.PREV%>";
	document.frmvendor.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
	}

function cmdListNext(){
	document.frmvendor.command.value="<%=JSPCommand.NEXT%>";
	document.frmvendor.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
}

function cmdListLast(){
	document.frmvendor.command.value="<%=JSPCommand.LAST%>";
	document.frmvendor.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmvendor.action="vendor.jsp";
	document.frmvendor.submit();
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

function MM_findObj(n, d) { //v4.0
		var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
		if(!x && document.getElementById) x=document.getElementById(n); return x;
	}

function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

</script>
<!-- #EndEditable --> 
</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF" onLoad="MM_preloadImages('../images/new2.gif','../images/close2.gif')">
<center>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr> 
      <td valign="top"> 
        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
          <!--DWLayoutTable-->
          <tr> 
            <td width="7" valign="top"  height="40"><img src="<%=approot%>/images/spacer.gif" width="3" height="1"></td>
            <td height="40" valign="top" > <!-- #BeginEditable "content" --> 
              <form name="frmvendor" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                <input type="hidden" name="hidden_vendor_id" value="<%=oidVendor%>">
                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
				<input type="hidden" name="return_page" value="<%=returnPage%>">
				
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                          <td height="8" valign="middle" colspan="3"></td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="16" valign="middle" colspan="3" class="container"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td class="title">Vendor<span class="level1"></span> 
                                  &raquo; <span class="level2">Editor<br>
                                  </span></td>
                              </tr>
                              <tr> 
                                <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                              </tr>
                              <tr> 
                                <td>&nbsp; </td>
                              </tr>
                              <tr> 
                                <td> 
                                  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr > 
                                      <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                      <td class="tab" height="22" nowrap> 
                                        <div align="center">Vendor Editor</div>
                                      </td>
                                      <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                      <td class="tabin" height="22" nowrap> 
                                        <div align="center"><a href="vendor_list.jsp?command=<%=JSPCommand.LIST%>&return_page=<%=returnPage%>" class="tablink">Records</a></div>
                                      </td>
                                      <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                      <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                      <td width="100%" class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr> 
                                <td> 
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="100%" class="page"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                          <tr align="left"> 
                                            <td height="21" valign="middle" width="14%">&nbsp;</td>
                                            <td height="21" colspan="2" width="86%" class="comment" valign="top">&nbsp;</td>
                                          </tr>
                                          <tr align="left"> 
                                            <td height="21" valign="middle" width="14%">&nbsp;</td>
                                            <td height="21" colspan="2" width="86%" class="comment" valign="top">*)= 
                                              required</td>
                                          </tr>
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;Code</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_CODE] %>"  value="<%= vendor.getCode() %>" class="formElemen" size="15" maxlength="3">
                                              * <%= jspVendor.getErrorMsg(JspVendor.JSP_CODE) %> 
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;Name</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_NAME] %>"  value="<%= vendor.getName() %>" class="formElemen" size="60">
                                              * <%= jspVendor.getErrorMsg(JspVendor.JSP_NAME) %> 
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;Address</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_ADDRESS] %>"  value="<%= vendor.getAddress() %>" class="formElemen" size="90">
                                              * <%= jspVendor.getErrorMsg(JspVendor.JSP_ADDRESS) %> 
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;City</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_CITY] %>"  value="<%= vendor.getCity() %>" class="formElemen" size="50">
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;State</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_STATE] %>"  value="<%= vendor.getState() %>" class="formElemen" size="50">
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;Country</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <% Vector countryid_value = new Vector(1,1);
						Vector countryid_key = new Vector(1,1);
						
						Vector vctr = DbCountry.list(0,0, "", "name");
						
					 	String sel_countryid = ""+vendor.getCountryId();
						if(vctr!=null && vctr.size()>0){
							for(int i=0; i<vctr.size(); i++){
							   Country c = (Country)vctr.get(i);
							   countryid_key.add(""+c.getOID());
							   countryid_value.add(""+c.getName());
					    	}
						}
					   %>
                                              <%= JSPCombo.draw(jspVendor.colNames[JspVendor.JSP_COUNTRY_ID],null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %> 
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;Phone</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_PHONE] %>"  value="<%= vendor.getPhone() %>" class="formElemen" size="30">
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;Fax</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_FAX] %>"  value="<%= vendor.getFax() %>" class="formElemen" size="30">
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;Due 
                                              Date</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <select name="<%=jspVendor.colNames[JspVendor.JSP_DUE_DATE] %>" class="formElemen">
                                                <%for(int i=0; i<100; i++){%>
                                                <option value="<%=i%>" <%if(i==vendor.getDueDate()){%>selected<%}%>><%=i%></option>
                                                <%}%>
                                              </select>
                                              day(s) 
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;Contact 
                                              Person</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_CONTACT] %>"  value="<%= vendor.getContact() %>" class="formElemen" size="50">
                                              <!--tr align="left"> 
                          <td height="21" width="10%">&nbsp;Vendor Type</td>
                          <td height="21" colspan="2" width="90%"> 
                            <% Vector vendortype_value = new Vector(1,1);
						Vector vendortype_key = new Vector(1,1);
					 	String sel_vendortype = ""+vendor.getVendorType();
					   vendortype_key.add("---select---");
					   vendortype_value.add("");
					   %>
                            <%= JSPCombo.draw(jspVendor.colNames[JspVendor.JSP_VENDOR_TYPE],null, sel_vendortype, vendortype_key, vendortype_value, "", "formElemen") %> 
						</tr-->
                                          <tr align="left"> 
                                            <td height="21" width="14%" nowrap>&nbsp;HP</td>
                                            <td height="21" colspan="2" width="86%"> 
                                              <input type="text" name="<%=jspVendor.colNames[JspVendor.JSP_HP] %>"  value="<%= vendor.getHp() %>" class="formElemen" size="30">
                                          <tr align="left"> 
                                            <td height="8" valign="middle" width="14%">&nbsp;</td>
                                            <td height="8" colspan="2" width="86%" valign="top">&nbsp;</td>
                                          </tr>
                                          <tr align="left"> 
                                            <td height="8" valign="middle" width="14%">&nbsp;</td>
                                            <td height="8" colspan="2" width="86%" valign="top">&nbsp;</td>
                                          </tr>
                                          
                                          <%if(iErrCode!=0){%>
                                          
										  <tr align="left"> 
                                            <td height="8" valign="middle" colspan="3"><font color="#FF0000"><i><%=msgString%> </i></font></td>
                                          </tr>
										  <tr align="left">
                                            <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                          </tr>
                                          <%}%>
                                          <tr align="left" > 
                                            <td colspan="3" class="command" valign="top"> 
                                              <table width="450" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                  <td width="31%"><a href="javascript:cmdSubmit()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/saveclose2.gif',1)"><img src="../images/saveclose.gif" name="new1" width="121" height="22" border="0"></a></td>
                                                  <td width="30%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/savenew2.gif',1)"><img src="../images/savenew.gif" name="new11" width="116" height="22" border="0"></a></td>
                                                  <td width="39%"><a href="javascript:cmdCloseX()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new111','','../images/close2.gif',1)"><img src="../images/close.gif" name="new111"  border="0"></a></td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                          <tr align="left" > 
                                            <td colspan="3" class="command" valign="top"> 
                                              <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidVendor+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidVendor+"')";
									String scancel = "javascript:cmdEdit('"+oidVendor+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");

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
									%>
                                              <%//= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td width="14%">&nbsp;</td>
                                            <td width="86%">&nbsp;</td>
                                          </tr>
                                          <tr align="left" > 
                                            <td colspan="3" valign="top"> 
                                              <div align="left"></div>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <%
							try{
								if (listVendor.size()>0){
							%>
                        <%  } 
						  }catch(Exception exc){ 
						  }%>
                        <%if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
                        <%}%>
                      </table>
                    </td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
                  </tr>
                </table>
				
				<script language="JavaScript">
window.focus();
</script>
				
              </form>
             
              <!-- #EndEditable --></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="1" valign="top"><img src="<%=approot%>/images/spacer.gif" width="1" height="1" /></td>
    </tr>
  </table>
</center>
</body>
<!-- #EndTemplate -->
</html>
