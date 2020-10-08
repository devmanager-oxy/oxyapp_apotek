 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
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
boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_COUNTRY);
boolean masterPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_COUNTRY, AppMenu.PRIV_VIEW);
boolean masterPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_COUNTRY, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspBankAccount frmObject, BankAccount objEntity, Vector objectClass,  long bankAccountId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Bank Account Name","20%");
		ctrlist.addHeader("Account Number","20%");
		ctrlist.addHeader("Account Name","20%");
		//ctrlist.addHeader("Type","10%");
		ctrlist.addHeader("Currency","10%");
		ctrlist.addHeader("Account Code","20%");
		ctrlist.addHeader("Status","10%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected Type*/
		Vector type_value = new Vector(1,1);
		Vector type_key = new Vector(1,1);
		type_value.add("");
		type_key.add("---select---");

		/* selected CoaId*/
		Vector coaid_value = new Vector(1,1);
		Vector coaid_key = new Vector(1,1);
		Vector temp = DbCoa.list(0,0, "status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"' and account_group='"+I_Project.ACC_GROUP_LIQUID_ASSET+"'", "code");
		if(temp!=null && temp.size()>0){
			for(int i=0; i<temp.size(); i++){
				Coa c = (Coa)temp.get(i);
				coaid_value.add(""+c.getOID());
				coaid_key.add(""+c.getCode()+" - "+c.getName());
			}
		}
		
		Vector currid_value = new Vector(1,1);
		Vector currid_key = new Vector(1,1);
		temp = DbCurrency.list(0,0, "", "");
		if(temp!=null && temp.size()>0){
			for(int i=0; i<temp.size(); i++){
				Currency c = (Currency)temp.get(i);
				currid_value.add(""+c.getOID());
				currid_key.add(""+c.getCurrencyCode());
			}
		}

		/* selected Status*/
		Vector status_value = new Vector(1,1);
		Vector status_key = new Vector(1,1);
		for(int i=0; i<I_Project.statusArray1.length; i++){
			status_value.add(""+i);
			status_key.add(""+I_Project.statusArray1[i]);
		}

		for (int i = 0; i < objectClass.size(); i++) {
			 BankAccount bankAccount = (BankAccount)objectClass.get(i);
			 rowx = new Vector();
			 if(bankAccountId == bankAccount.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"40\" name=\""+frmObject.colNames[JspBankAccount.JSP_BANK_NAME] +"\" value=\""+bankAccount.getBankName()+"\" class=\"formElemen\"></div>");
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"30\" name=\""+frmObject.colNames[JspBankAccount.JSP_ACC_NUMBER] +"\" value=\""+bankAccount.getAccNumber()+"\" class=\"formElemen\"></div>");
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"40\" name=\""+frmObject.colNames[JspBankAccount.JSP_NAME] +"\" value=\""+bankAccount.getName()+"\" class=\"formElemen\"></div>");
				//rowx.add(JSPCombo.draw(frmObject.colNames[JspBankAccount.JSP_TYPE],null, ""+bankAccount.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspBankAccount.JSP_CURRENCY_ID],null, ""+bankAccount.getCurrencyId(), currid_value , currid_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspBankAccount.JSP_COA_ID],null, ""+bankAccount.getCoaId(), coaid_value , coaid_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspBankAccount.JSP_STATUS],null, ""+bankAccount.getStatus(), status_value , status_key, "formElemen", "")+"</div>");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(bankAccount.getOID())+"')\">"+bankAccount.getBankName()+"</a>");
				rowx.add(bankAccount.getAccNumber());
				rowx.add(bankAccount.getName());
				//rowx.add(String.valueOf(bankAccount.getType()));
				
				Currency cx1 = new Currency();
				try{
					cx1 = DbCurrency.fetchExc(bankAccount.getCurrencyId());
				}
				catch(Exception e){
				}
				
				Coa cx = new Coa();
				try{
					cx = DbCoa.fetchExc(bankAccount.getCoaId());
				}
				catch(Exception e){
				}
				rowx.add(cx1.getCurrencyCode());
				rowx.add(cx.getCode()+" - "+cx.getName());
				rowx.add(I_Project.statusArray1[bankAccount.getStatus()]);
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"40\" name=\""+frmObject.colNames[JspBankAccount.JSP_BANK_NAME] +"\" value=\""+objEntity.getBankName()+"\" class=\"formElemen\"></div>");
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"30\" name=\""+frmObject.colNames[JspBankAccount.JSP_ACC_NUMBER] +"\" value=\""+objEntity.getAccNumber()+"\" class=\"formElemen\"></div>");
				rowx.add("<div align=\"center\"><input type=\"text\" size=\"40\" name=\""+frmObject.colNames[JspBankAccount.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\"></div>");
				//rowx.add(JSPCombo.draw(frmObject.colNames[JspBankAccount.JSP_TYPE],null, ""+objEntity.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspBankAccount.JSP_CURRENCY_ID],null, ""+objEntity.getCurrencyId(), currid_value , currid_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspBankAccount.JSP_COA_ID],null, ""+objEntity.getCoaId(), coaid_value , coaid_key, "formElemen", "")+"</div>");
				rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspBankAccount.JSP_STATUS],null, ""+objEntity.getStatus(), status_value , status_key, "formElemen", "")+"</div>");

		}

		lstData.add(rowx);

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidBankAccount = JSPRequestValue.requestLong(request, "hidden_bank_account_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
//String whereClause = "company_id="+appSessUser.getCompanyOID();
String whereClause = "";
String orderClause = "";

CmdBankAccount ctrlBankAccount = new CmdBankAccount(request);
JSPLine ctrLine = new JSPLine();
Vector listBankAccount = new Vector(1,1);

/*switch statement */
//iErrCode = ctrlBankAccount.action(iJSPCommand , oidBankAccount, appSessUser.getCompanyOID());
iErrCode = ctrlBankAccount.action(iJSPCommand , oidBankAccount);
/* end switch*/
JspBankAccount jspBankAccount = ctrlBankAccount.getForm();

/*count list All BankAccount*/
int vectSize = DbBankAccount.getCount(whereClause);

/*switch list BankAccount*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlBankAccount.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

BankAccount bankAccount = ctrlBankAccount.getBankAccount();
msgString =  ctrlBankAccount.getMessage();

/* get record to display */
listBankAccount = DbBankAccount.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listBankAccount.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listBankAccount = DbBankAccount.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">


function cmdAdd(){
	document.frmbankaccount.hidden_bank_account_id.value="0";
	document.frmbankaccount.command.value="<%=JSPCommand.ADD%>";
	document.frmbankaccount.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdAsk(oidBankAccount){
	document.frmbankaccount.hidden_bank_account_id.value=oidBankAccount;
	document.frmbankaccount.command.value="<%=JSPCommand.ASK%>";
	document.frmbankaccount.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdConfirmDelete(oidBankAccount){
	document.frmbankaccount.hidden_bank_account_id.value=oidBankAccount;
	document.frmbankaccount.command.value="<%=JSPCommand.DELETE%>";
	document.frmbankaccount.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdSave(){
	document.frmbankaccount.command.value="<%=JSPCommand.SAVE%>";
	document.frmbankaccount.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdEdit(oidBankAccount){
	document.frmbankaccount.hidden_bank_account_id.value=oidBankAccount;
	document.frmbankaccount.command.value="<%=JSPCommand.EDIT%>";
	document.frmbankaccount.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdCancel(oidBankAccount){
	document.frmbankaccount.hidden_bank_account_id.value=oidBankAccount;
	document.frmbankaccount.command.value="<%=JSPCommand.EDIT%>";
	document.frmbankaccount.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdBack(){
	document.frmbankaccount.command.value="<%=JSPCommand.BACK%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdListFirst(){
	document.frmbankaccount.command.value="<%=JSPCommand.FIRST%>";
	document.frmbankaccount.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdListPrev(){
	document.frmbankaccount.command.value="<%=JSPCommand.PREV%>";
	document.frmbankaccount.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdListNext(){
	document.frmbankaccount.command.value="<%=JSPCommand.NEXT%>";
	document.frmbankaccount.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

function cmdListLast(){
	document.frmbankaccount.command.value="<%=JSPCommand.LAST%>";
	document.frmbankaccount.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmbankaccount.action="bankaccount.jsp";
	document.frmbankaccount.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidBankAccount){
	document.frmimage.hidden_bank_account_id.value=oidBankAccount;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="bankaccount.jsp";
	document.frmimage.submit();
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
  
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
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
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Bank Account List</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                          <tr> 
                            <td valign="top"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                <tr> 
                                  <td valign="top"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                      <!--DWLayoutTable-->
                                      <tr> 
                                        <td width="100%" valign="top"> 
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                              <td> 
                                                <form name="frmbankaccount" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                  <input type="hidden" name="hidden_bank_account_id" value="<%=oidBankAccount%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="8"  colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                  <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                </tr>
                                                                <%
							try{
							%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="3"> 
                                                                    <%= drawList(iJSPCommand,jspBankAccount, bankAccount,listBankAccount,oidBankAccount)%> 
                                                                  </td>
                                                                </tr>
                                                                <% 
						  }catch(Exception exc){ 
						  }%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" align="left" colspan="3" class="command"> 
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
                                                                    <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                                                    </span> </td>
                                                                </tr>
                                                                <%if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="3"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="97%">&nbsp;</td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="97%"> 
                                                                          <%if(masterPrivUpdate){%>
                                                                          <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a> 
                                                                          <%}%>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                            <td height="8" colspan="2" width="83%">&nbsp; 
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top" > 
                                                            <td colspan="3" class="command"> 
                                                              <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidBankAccount+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidBankAccount+"')";
									String scancel = "javascript:cmdEdit('"+oidBankAccount+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									ctrLine.setDeleteCaption("");
									
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
                                                </form>
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
                              </table>
                            </td>
                          </tr>
                        </table>
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
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

