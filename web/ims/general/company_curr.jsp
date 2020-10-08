 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
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

	public String drawList(int iJSPCommand,JspCurrency jspObject, Currency objEntity, Vector objectClass,  long currencyOid)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("70%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("Currency Code","20%");
		cmdist.addHeader("Description","80%");

		cmdist.setLinkRow(0);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		Vector rowx = new Vector(1,1);
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 Currency currency = (Currency)objectClass.get(i);
			 rowx = new Vector();
			 if(currencyOid == currency.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+jspObject.colNames[JspCurrency.JSP_CURRENCY_CODE] +"\" value=\""+currency.getCurrencyCode()+"\" class=\"formElemen\" size=\"30\">");
				rowx.add("<input type=\"text\" name=\""+jspObject.colNames[JspCurrency.JSP_DESCRIPTION] +"\" value=\""+currency.getDescription()+"\" class=\"formElemen\" size=\"50\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(currency.getOID())+"')\">"+currency.getCurrencyCode()+"</a>");
				rowx.add(currency.getDescription());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && jspObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+jspObject.colNames[JspCurrency.JSP_CURRENCY_CODE] +"\" value=\""+objEntity.getCurrencyCode()+"\" class=\"formElemen\" size=\"30\">"+ jspObject.getErrorMsg(jspObject.JSP_CURRENCY_CODE));
				rowx.add("<input type=\"text\" name=\""+jspObject.colNames[JspCurrency.JSP_DESCRIPTION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\" size=\"50\">");

		}

		lstData.add(rowx);

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCurrency = JSPRequestValue.requestLong(request, "hidden_currency_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdCurrency ctrlCurrency = new CmdCurrency(request);
JSPLine ctrLine = new JSPLine();
Vector listCurrency = new Vector(1,1);

/*switch statement */
iErrCode = ctrlCurrency.action(iJSPCommand , oidCurrency);
/* end switch*/
JspCurrency jspCurrency = ctrlCurrency.getForm();

/*count list All Currency*/
int vectSize = DbCurrency.getCount(whereClause);

/*switch list Currency*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlCurrency.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

Currency currency = ctrlCurrency.getCurrency();
msgString =  ctrlCurrency.getMessage();

/* get record to display */
listCurrency = DbCurrency.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCurrency.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCurrency = DbCurrency.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/indexwomenu.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>POS Back Office</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">
function cmdAdd(){
	document.jspcurrency.hidden_currency_id.value="0";
	document.jspcurrency.command.value="<%=JSPCommand.ADD%>";
	document.jspcurrency.prev_command.value="<%=prevJSPCommand%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdAsk(oidCurrency){
	document.jspcurrency.hidden_currency_id.value=oidCurrency;
	document.jspcurrency.command.value="<%=JSPCommand.ASK%>";
	document.jspcurrency.prev_command.value="<%=prevJSPCommand%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdConfirmDelete(oidCurrency){
	document.jspcurrency.hidden_currency_id.value=oidCurrency;
	document.jspcurrency.command.value="<%=JSPCommand.DELETE%>";
	document.jspcurrency.prev_command.value="<%=prevJSPCommand%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdSave(){
	document.jspcurrency.command.value="<%=JSPCommand.SAVE%>";
	document.jspcurrency.prev_command.value="<%=prevJSPCommand%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdEdit(oidCurrency){
	document.jspcurrency.hidden_currency_id.value=oidCurrency;
	document.jspcurrency.command.value="<%=JSPCommand.EDIT%>";
	document.jspcurrency.prev_command.value="<%=prevJSPCommand%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdCancel(oidCurrency){
	document.jspcurrency.hidden_currency_id.value=oidCurrency;
	document.jspcurrency.command.value="<%=JSPCommand.EDIT%>";
	document.jspcurrency.prev_command.value="<%=prevJSPCommand%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdBack(){
	document.jspcurrency.command.value="<%=JSPCommand.BACK%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdListFirst(){
	document.jspcurrency.command.value="<%=JSPCommand.FIRST%>";
	document.jspcurrency.prev_command.value="<%=JSPCommand.FIRST%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdListPrev(){
	document.jspcurrency.command.value="<%=JSPCommand.PREV%>";
	document.jspcurrency.prev_command.value="<%=JSPCommand.PREV%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdListNext(){
	document.jspcurrency.command.value="<%=JSPCommand.NEXT%>";
	document.jspcurrency.prev_command.value="<%=JSPCommand.NEXT%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

function cmdListLast(){
	document.jspcurrency.command.value="<%=JSPCommand.LAST%>";
	document.jspcurrency.prev_command.value="<%=JSPCommand.LAST%>";
	document.jspcurrency.action="company_curr.jsp";
	document.jspcurrency.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidCurrency){
	document.jspimage.hidden_currency_code.value=oidCurrency;
	document.jspimage.command.value="<%=JSPCommand.POST%>";
	document.jspimage.action="company_curr.jsp";
	document.jspimage.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Configuration</span> 
                        &raquo; <span class="level1">Step 2 of 5</span> &raquo; 
                        <span class="level2">Currency Setup<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
              <form name="jspcurrency" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                <input type="hidden" name="hidden_currency_id" value="<%=oidCurrency%>">
                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="4"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" width="2%" class="listtitle"></td>
                                    <td height="8" valign="middle" colspan="3" class="listtitle" width="98%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="15" valign="middle" width="2%">&nbsp;</td>
                                    <td height="15" valign="middle" colspan="3" width="98%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="2%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="98%">Please 
                                      specify currencies that are allowed in your 
                                      finance transaction. </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="15" valign="middle" width="2%">&nbsp;</td>
                                    <td height="15" valign="middle" colspan="3" width="98%">&nbsp;</td>
                                  </tr>
                                  <%
							try{
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="2%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="98%"> 
                                      <%= drawList(iJSPCommand,jspCurrency, currency,listCurrency,oidCurrency)%> </td>
                                  </tr>
                                  <% 
						  }catch(Exception exc){ 
						  }%>
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" width="2%" class="command" valign="top">&nbsp;</td>
                                    <td height="8" align="left" colspan="3" class="command" valign="top" width="98%"> 
                                      <span class="command"> 
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
							    %>
                                      <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								 %>
                                      <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <%if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="2%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="98%">&nbsp; 
                                      <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="9%"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/new2.gif',1)"><img src="../images/new.gif" name="new" width="71" height="22" border="0"></a></td>
                                          <td width="6%"><a href="company.jsp?command=<%=JSPCommand.BACK%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" width="51" height="22" border="0"></a></td>
                                          <td width="8%"><a href="company_loc.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('next','','../images/next2.gif',1)"><img src="../images/next.gif" name="next" width="55" height="22" border="0"></a></td>
                                          <td width="77%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" width="2%">&nbsp;</td>
                                    <td height="22" valign="middle" colspan="3" width="98%"> 
                                      <table width="48%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td>
                                            <%
									ctrLine.setLocationImg(approot+"/images");
									ctrLine.initDefault();
									ctrLine.setTableWidth("100%");
									String scomDel = "javascript:cmdAsk('"+oidCurrency+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidCurrency+"')";
									String scancel = "javascript:cmdEdit('"+oidCurrency+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									ctrLine.setDeleteCaption("");
									//ctrLine.setSaveCaption("");
									ctrLine.setAddCaption("");
									
									ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setWidthAllJSPCommand("70");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");


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
                                            <%if(iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.ASK || iErrCode!=0){%>
                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                            <%}%>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                    </td>
                  </tr>
                  <tr align="left" valign="top">
                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                  </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="4" class="command">&nbsp; </td>
                  </tr>
                </table>
              </form>
              
              <!-- #EndEditable --> </td>
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
