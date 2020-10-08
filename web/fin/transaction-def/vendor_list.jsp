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
		cmdist.setAreaWidth("100%");
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
int recordToGet = 15;
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

function cmdAdd(){
	document.frmvendor.hidden_vendor_id.value="0";
	document.frmvendor.command.value="<%=JSPCommand.ADD%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
}

function cmdAsk(oidVendor){
	document.frmvendor.hidden_vendor_id.value=oidVendor;
	document.frmvendor.command.value="<%=JSPCommand.ASK%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
}

function cmdConfirmDelete(oidVendor){
	document.frmvendor.hidden_vendor_id.value=oidVendor;
	document.frmvendor.command.value="<%=JSPCommand.DELETE%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
}
function cmdSave(){
	document.frmvendor.command.value="<%=JSPCommand.SAVE%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
	}

function cmdEdit(oidVendor){
	/*document.frmvendor.hidden_vendor_id.value=oidVendor;
	document.frmvendor.command.value="<%=JSPCommand.EDIT%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
	*/
	
	/*
	self.opener.frmbanknonpopaymentdetail.<%=JspBanknonpoPayment.colNames[JspBanknonpoPayment.JSP_VENDOR_ID]%>.value=oidVendor;	
	self.opener.frmbanknonpopaymentdetail.xxx.value=oidVendor;	
	self.opener.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.PRINT%>";
	self.opener.frmbanknonpopaymentdetail.select_idx.value="-1";
	self.opener.frmbanknonpopaymentdetail.submit();
	self.close();
	*/
	
<%	
	if(returnPage==0){
%>
		//alert('submit and close');
		//alert('vendor.getOID() : '+<%=vendor.getOID()%>);
		self.opener.frmbanknonpopaymentdetail.<%=JspBanknonpoPayment.colNames[JspBanknonpoPayment.JSP_VENDOR_ID]%>.value=oidVendor;//"<%=vendor.getOID()%>";	
		self.opener.frmbanknonpopaymentdetail.xxx.value=oidVendor;//"<%=vendor.getOID()%>";	
		self.opener.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.PRINT%>";
		self.opener.frmbanknonpopaymentdetail.select_idx.value="-1";
		self.opener.frmbanknonpopaymentdetail.submit();
		self.close();
<%	}else{%>
		//alert('submit and close');
		//alert('vendor.getOID() : '+<%=vendor.getOID()%>);
		self.opener.frmpurchaseitem.<%=JspPurchase.colNames[JspPurchase.JSP_VENDOR_ID]%>.value=oidVendor;//"<%=vendor.getOID()%>";	
		self.opener.frmpurchaseitem.xxx.value=oidVendor;//"<%=vendor.getOID()%>";	
		self.opener.frmpurchaseitem.command.value="<%=JSPCommand.PRINT%>";
		self.opener.frmpurchaseitem.select_idx.value="-1";
		self.opener.frmpurchaseitem.submit();
		self.close();
<%	}%>
	
}

function cmdCancel(oidVendor){
	document.frmvendor.hidden_vendor_id.value=oidVendor;
	document.frmvendor.command.value="<%=JSPCommand.EDIT%>";
	document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
}

function cmdBack(){
	document.frmvendor.command.value="<%=JSPCommand.BACK%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
	}

function cmdListFirst(){
	document.frmvendor.command.value="<%=JSPCommand.FIRST%>";
	document.frmvendor.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
}

function cmdListPrev(){
	document.frmvendor.command.value="<%=JSPCommand.PREV%>";
	document.frmvendor.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
	}

function cmdListNext(){
	document.frmvendor.command.value="<%=JSPCommand.NEXT%>";
	document.frmvendor.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmvendor.action="vendor_list.jsp";
	document.frmvendor.submit();
}

function cmdListLast(){
	document.frmvendor.command.value="<%=JSPCommand.LAST%>";
	document.frmvendor.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmvendor.action="vendor_list.jsp";
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
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">
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
                          <td height="16" valign="top" colspan="3" class="container"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td class="title">Vendor<span class="level1"></span> 
                                  &raquo; <span class="level2">Records<br>
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
                                      <td class="tabin" height="22" nowrap> 
                                        <div align="center"><a href="vendor.jsp" class="tablink">Vendor Editor</a></div>
                                      </td>
                                      <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                      <td class="tab" height="22" nowrap> 
                                        <div align="center">Records</div>
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
                                      <td width="100%" class="page" valign="top"> 
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td><%= drawList(listVendor,oidVendor)%></td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td><span class="command"> 
                                              <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
								   }
								   
								   ctrLine.setLocationImg(approot+"/images");
								   ctrLine.initDefault(); 
								   
								   ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								   
							    %>
                                              <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span></td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
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
                            </table>
                          </td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="16" valign="middle" colspan="3" class="comment">&nbsp;</td>
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
                    <td height="8" valign="middle" colspan="3"> 
                      <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspVendor.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                      <%}%>
                    </td>
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
