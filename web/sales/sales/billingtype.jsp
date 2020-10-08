<%
/*
 * Page Name  		:  billingtype.jsp
 * Created on 		:  [date] [time] AM/PM
 *
 * @author  		:  [authorName]
 * @version  		:  [version]
 */

/*******************************************************************
 * Page Description 	: [project description ... ]
 * Imput Parameters 	: [input parameter ...]
 * Output 			: [output ...]
 *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package berlian -->
<%@ page import = "com.berlian.util.*" %>
<!-- package qdep -->
<%@ page import = "com.berlian.gui.jsp.*" %>
<%@ page import = "com.berlian.qdep.form.*" %>
<!--package hanoman -->
<%@ page import = "com.berlian.fdms.entity.masterdata.*" %>
<%@ page import = "com.berlian.fdms.form.masterdata.*" %>
<%@ page import = "com.berlian.fdms.entity.admin.*" %>
<%@ page import = "com.berlian.harisma.entity.masterdata.*" %>

<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 0;//AppObjInfo.composeObjCode(AppObjInfo.G1_DATA_MANAGEMENT, AppObjInfo.G2_DATA_MANAG_MASTER_D, AppObjInfo.OBJ_D_MANAG_MASTER_BILLING_TYPE); %>
<%@ include file = "../main/checksl.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privView= true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privUpdate= true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete= true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long billingTypeId, Vector vctDep, String strForeignCurrencyDefault)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell1");
		ctrlist.setCellStyle1("tablecell");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Dep/Location","20%","2","0");
		ctrlist.addHeader("Code","4%","2","0");
		ctrlist.addHeader("Outlet Name","20%","2","0");
		ctrlist.addHeader("Tax & Svc By","5","2","0");
		ctrlist.addHeader("Service","18%","0","2");
		ctrlist.addHeader("%","5%","0","0");
		ctrlist.addHeader("Amount","13%","0","0");
		ctrlist.addHeader("Tax","18%","0","2");
		ctrlist.addHeader("%","5%","0","0");
		ctrlist.addHeader("Amount","13%","0","0");
		ctrlist.addHeader("Description","13%","2","0");

		ctrlist.setLinkRow(2);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			BillingType billingType = (BillingType)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(billingTypeId == billingType.getOID())
				 index = i;

			Location loc = new Location();
			try{
				loc = DbLocation.fetchExc(billingType.getLocationId());
			}			
			catch(Exception e){
			}

			rowx.add(getDepartment(billingType.getDepartmentID(), vctDep)+" / "+loc.getName());

			rowx.add(billingType.getTypeCode());

			rowx.add(billingType.getTypeName());

			rowx.add(PstBillingType.usedKey[billingType.getUsedValue()]);

			rowx.add(String.valueOf(billingType.getServicePercentage()));

			rowx.add("Rp. "+String.valueOf(billingType.getServiceValue())+", "+strForeignCurrencyDefault+" "+String.valueOf(billingType.getServiceValueUsd()));

			rowx.add(String.valueOf(billingType.getTaxPercentage()));

			rowx.add("Rp. "+String.valueOf(billingType.getTaxValue())+", "+strForeignCurrencyDefault+" "+String.valueOf(billingType.getTaxValueUsd()));

			rowx.add(billingType.getDescription());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(billingType.getOID()));
		}

		return ctrlist.drawList();
	}

public String getDepartment(long OID, Vector vct){
	if(vct!=null && vct.size()>0){
		for(int i=0; i<vct.size(); i++){
			Department dep = (Department)vct.get(i);
			if(OID == dep.getOID()){
				return dep.getDepartment();
				//return dep.getName();
			}
		}
	}
	return "not av.";
}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int start1 = FRMQueryString.requestInt(request, "start1");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidBillingType = FRMQueryString.requestLong(request, "hidden_billing_type_id");

/*variable declaration*/
int recordToGet = 15;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = PstBillingType.fieldNames[PstBillingType.FLD_TYPE_NAME];

Vector vctDepart = PstDepartment.listAll();

CtrlBillingType ctrlBillingType = new CtrlBillingType(request);
ControlLine ctrLine = new ControlLine();
Vector listBillingType = new Vector(1,1);

/*switch statement */
iErrCode = ctrlBillingType.action(iCommand , oidBillingType);
/* end switch*/
FrmBillingType frmBillingType = ctrlBillingType.getForm();

/*count list All BillingType*/
Vector listAllBillingType = PstBillingType.listAll();
int vectSize = listAllBillingType.size();
/*switch list BillingType*/
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST )){
		start = ctrlBillingType.actionList(iCommand, start, vectSize, recordToGet);
 }
/* end switch list*/

BillingType billingType = ctrlBillingType.getBillingType();
msgString =  ctrlBillingType.getMessage();

if(oidBillingType==0){
	oidBillingType = billingType.getOID();
}

/* get record to display */
listBillingType = PstBillingType.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listBillingType.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listBillingType = PstBillingType.list(start,recordToGet, whereClause , orderClause);
}

//out.println("oidBillingType : "+oidBillingType);

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=salesSt%></title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!privView &&  !privAdd && !privUpdate && !privDelete){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if(iCommand==Command.ADD || iCommand==Command.EDIT || iCommand==Command.ASK ||
(iCommand==Command.SAVE) || (iCommand==Command.DELETE  && iErrCode!=FRMMessage.NONE)){%>
	window.location="#go";
<%}%>

function cmdAdd(){
	document.frmbillingtype.hidden_billing_type_id.value="0";
	document.frmbillingtype.command.value="<%=Command.ADD%>";
	document.frmbillingtype.prev_command.value="<%=prevCommand%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
}

function cmdAsk(oidBillingType){
	document.frmbillingtype.hidden_billing_type_id.value=oidBillingType;
	document.frmbillingtype.command.value="<%=Command.ASK%>";
	document.frmbillingtype.prev_command.value="<%=prevCommand%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
}

function cmdConfirmDelete(oidBillingType){
	document.frmbillingtype.hidden_billing_type_id.value=oidBillingType;
	document.frmbillingtype.command.value="<%=Command.DELETE%>";
	document.frmbillingtype.prev_command.value="<%=prevCommand%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
}
function cmdSave(){
	document.frmbillingtype.command.value="<%=Command.SAVE%>";
	document.frmbillingtype.prev_command.value="<%=prevCommand%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
	}

function cmdEdit(oidBillingType){
	document.frmbillingtype.hidden_billing_type_id.value=oidBillingType;
	document.frmbillingtype.command.value="<%=Command.EDIT%>";
	document.frmbillingtype.prev_command.value="<%=prevCommand%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
	}

function cmdCancel(oidBillingType){
	document.frmbillingtype.hidden_billing_type_id.value=oidBillingType;
	document.frmbillingtype.command.value="<%=Command.EDIT%>";
	document.frmbillingtype.prev_command.value="<%=prevCommand%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
}

function cmdBack(){
	document.frmbillingtype.command.value="<%=Command.BACK%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
	}

function cmdListFirst(){
	document.frmbillingtype.command.value="<%=Command.FIRST%>";
	document.frmbillingtype.prev_command.value="<%=Command.FIRST%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
}

function cmdListPrev(){
	document.frmbillingtype.command.value="<%=Command.PREV%>";
	document.frmbillingtype.prev_command.value="<%=Command.PREV%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
	}

function cmdListNext(){
	document.frmbillingtype.command.value="<%=Command.NEXT%>";
	document.frmbillingtype.prev_command.value="<%=Command.NEXT%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
}

function cmdListLast(){
	document.frmbillingtype.command.value="<%=Command.LAST%>";
	document.frmbillingtype.prev_command.value="<%=Command.LAST%>";
	document.frmbillingtype.action="billingtype.jsp";
	document.frmbillingtype.submit();
}

function backMenu(){
	document.frmbillingtype.action="<%=approot%>/management/main_masterdata.jsp";
	document.frmbillingtype.submit();
}

function cmdBillingType(){
	document.frmbillingtype.command.value="<%=Command.FIRST%>";
	document.frmbillingtype.action="billingtypeitem.jsp";
	document.frmbillingtype.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','<%=approot%>/images/ctr_line/add_f2.jpg')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        
                        
                        
                        <form name="frmbillingtype" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                          <input type="hidden" name="hidden_billing_type_id" value="<%=oidBillingType%>">
						  <%
									  String navigator = "<font class=\"lvl1\">Outlet/Sales Location</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">List</span></font>";
									  %>
									  <%@ include file="../main/navigatorsl.jsp"%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="1">
                            <tr> 
                              <td width="94%" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3">&nbsp; 
                                          </td>
                                        </tr>
                                        
                                        <%
							try{
								if (listBillingType.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listBillingType,oidBillingType, vctDepart, strForeignCurrencyDefault)%> </td>
                                        </tr>
                                        <%  }
							else{%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3" class="msgquestion">&nbsp;&nbsp;no 
                                            outlet available ... </td>
                                        </tr>
                                        <%}
						  }catch(Exception exc){
						  }%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <span class="command"> 
                                            <%
								   int cmd = 0;
									   if ((iCommand == Command.FIRST || iCommand == Command.PREV )||
										(iCommand == Command.NEXT || iCommand == Command.LAST))
											cmd =iCommand;
								   else{
									  if(iCommand == Command.NONE || prevCommand == Command.NONE)
										cmd = Command.FIRST;
									  else
									  	cmd =prevCommand;
								   }
							    %>
                                            <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="49%" border="0" cellspacing="2" cellpadding="3">
                                              <tr> 
                                                <% if(privAdd){%>
                                                <td width="8%"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100','','<%=approot%>/images/ctr_line/add_f2.jpg',1)"><img name="Image100" border="0" src="<%=approot%>/images/ctr_line/add.jpg" width="24" height="24" alt="Add New Outlet"></a></td>
                                                <td nowrap width="28%"><a href="javascript:cmdAdd()" class="command">Add 
                                                  New </a></td>
                                                <%}%>
                                                <td width="8%"><a href="javascript:backMenu()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image300','','<%=approot%>/images/ctr_line/back_f2.jpg',1)"><img name="Image300" border="0" src="<%=approot%>/images/ctr_line/back.jpg" width="24" height="24" alt="Back To Master Data Management Menu"></a></td>
                                                <td nowrap width="56%"><a href="javascript:backMenu()" class="command">Back 
                                                  To Menu</a></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE) || (iCommand==Command.DELETE && iErrCode!=0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                                      <table width="100%" border="0" cellspacing="3" cellpadding="1">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" colspan="4"><b>Outlet 
                                            Editor</b></td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="19%"><a name="go"></a></td>
                                          <td height="21" colspan="3" class="comment" valign="top">*)= 
                                            required</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="19%">Department</td>
                                          <td height="21" colspan="3"> 
                                            <%
								Vector department = PstDepartment.listAll();
								
								//out.println("department : "+department);

								Vector val_deparment = new Vector(1,1); //hidden values that will be deliver on request (oids)
								Vector key_deparment = new Vector(1,1); //texts that displayed on combo box

								if(department!=null && department.size()>0){
									for(int i=0; i<department.size(); i++){
										Department cDepartment = (Department)department.get(i);
										val_deparment.add(""+cDepartment.getOID());
										key_deparment.add(cDepartment.getDepartment());
									}
								}
								
								//out.println("val_deparment : "+val_deparment);
								//out.println("key_deparment : "+key_deparment);

								String select_department = ""+billingType.getDepartmentID(); //selected on combo box
								%>
                                            <%=ControlCombo.draw(FrmBillingType.fieldNames[FrmBillingType.FRM_FIELD_DEPARTMENT_ID], null, select_department, val_deparment, key_deparment, "", "formElemen")%>* <%=frmBillingType.getErrorMsg(FrmBillingType.FRM_FIELD_DEPARTMENT_ID)%> 
                                        <tr align="left">
                                          <td height="21" width="19%">Location 
                                          </td>
                                          <td height="21" colspan="3"> 
                                            <%
								Vector locs = DbLocation.list(0,0,"", "");
								
								//out.println("department : "+department);

								Vector val_loc = new Vector(1,1); //hidden values that will be deliver on request (oids)
								Vector key_loc = new Vector(1,1); //texts that displayed on combo box

								if(locs!=null && locs.size()>0){
									for(int i=0; i<locs.size(); i++){
										Location cLoc = (Location)locs.get(i);
										val_loc.add(""+cLoc.getOID());
										key_loc.add(cLoc.getName());
									}
								}
								
								//out.println("val_deparment : "+val_deparment);
								//out.println("key_deparment : "+key_deparment);

								String select_loc = ""+billingType.getLocationId(); //selected on combo box
								%>
                                            <%=ControlCombo.draw(FrmBillingType.fieldNames[FrmBillingType.FRM_FIELD_LOCATION_ID], null, select_loc, val_loc, key_loc, "", "formElemen")%>* <%=frmBillingType.getErrorMsg(FrmBillingType.FRM_FIELD_LOCATION_ID)%> 
                                        <tr align="left"> 
                                          <td height="21" width="19%">Outlet Code</td>
                                          <td height="21" colspan="3"> 
                                            <input type="text" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_TYPE_CODE] %>"  value="<%= billingType.getTypeCode() %>" class="formElemen" size="10">
                                            * <%= frmBillingType.getErrorMsg(FrmBillingType.FRM_FIELD_TYPE_CODE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="19%">Outlet Name</td>
                                          <td height="21" colspan="3"> 
                                            <input type="text" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_TYPE_NAME] %>"  value="<%= billingType.getTypeName() %>" class="formElemen" size="35">
                                            * <%= frmBillingType.getErrorMsg(FrmBillingType.FRM_FIELD_TYPE_NAME) %> 
                                        <tr align="left"> 
                                          <td height="21" colspan="4">&nbsp;</td>
                                        <tr align="left"> 
                                          <td height="21" colspan="4">Service 
                                            and Tax Calculation Based on &nbsp;&nbsp; 
                                            <input type="radio" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_USED_VALUE] %>" value="<%=PstBillingType.USED_PERCENTAGE%>" <%=billingType.getUsedValue()==PstBillingType.USED_PERCENTAGE?"checked":""%>>
                                            Percentage 
                                            <input type="radio" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_USED_VALUE] %>" value="<%=PstBillingType.USED_VALUE%>" <%=billingType.getUsedValue()==PstBillingType.USED_VALUE?"checked":""%>>
                                            Amount</td>
                                        <tr align="left"> 
                                          <td height="21" width="19%">&nbsp;</td>
                                          <td height="21" colspan="3">&nbsp; 
                                        <tr align="left"> 
                                          <td height="21" width="19%">Service 
                                            Percentage</td>
                                          <td height="21" width="16%"> 
                                            <input type="text" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_SERVICE_PERCENTAGE] %>"  value="<%if((billingType.getServicePercentage()-0.0f)>0.0f){%><%= billingType.getServicePercentage() %><%}%>" class="formElemen" size="10">
                                            % 
                                          <td height="21" width="15%"> Service 
                                            Amount 
                                          <td height="21" width="50%"> Rp. 
                                            <input type="text" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_SERVICE_VALUE] %>"  value="<%if((billingType.getServiceValue()-0.0f)>0.0f){%><%= billingType.getServiceValue() %><%}%>" class="formElemen" size="15" maxlength="15" style="text-align:right">
                                            , <%=strForeignCurrencyDefault%> 
                                            <input type="text" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_SERVICE_VALUE_USD] %>"  value="<%if((billingType.getServiceValueUsd()-0.0f)>0.0f){%><%= billingType.getServiceValueUsd() %><%}%>" class="formElemen" size="15" maxlength="15" style="text-align:right">
                                        <tr align="left"> 
                                          <td height="24" width="19%">Tax Percentage</td>
                                          <td height="24" width="16%"> 
                                            <input type="text" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_TAX_PERCENTAGE] %>"  value="<%if((billingType.getTaxPercentage()-0.0f)>0.0f){%><%= billingType.getTaxPercentage() %><%}%>" class="formElemen" size="10">
                                            % 
                                          <td height="24" width="15%">Tax Amount 
                                          <td height="24" width="50%"> Rp. 
                                            <input type="text" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_TAX_VALUE] %>"  value="<%if((billingType.getTaxValue()-0.0f)>0.0f){%><%= billingType.getTaxValue() %><%}%>" class="formElemen" size="15" style="text-align:right">
                                            , <%=strForeignCurrencyDefault%> 
                                            <input type="text" name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_TAX_VALUE_USD] %>"  value="<%if((billingType.getTaxValueUsd()-0.0f)>0.0f){%><%= billingType.getTaxValueUsd() %><%}%>" class="formElemen" size="15" style="text-align:right">
                                        <tr align="left"> 
                                          <td height="21" width="19%" valign="top">Description</td>
                                          <td height="21" colspan="3"> 
                                            <textarea name="<%=frmBillingType.fieldNames[FrmBillingType.FRM_FIELD_DESCRIPTION] %>" class="formElemen" cols="45"><%= billingType.getDescription() %></textarea>
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="19%">&nbsp;</td>
                                          <td height="8" colspan="3" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="19%"><i><font color="#FF0000"> 
                                            Report Group On Sales</font></i></td>
                                          <td height="8" colspan="3" valign="top"> 
                                            <%
								//Vector department = PstDepartment.listAll();

								Vector val_rptgroup = new Vector(1,1); //hidden values that will be deliver on request (oids)
								Vector key_rptgroup = new Vector(1,1); //texts that displayed on combo box

								for(int i=0; i<PstBillingType.reportGroupStr.length; i++){
									val_rptgroup.add(""+i);
									key_rptgroup.add(PstBillingType.reportGroupStr[i]);
								}

								String select_rptgroup = ""+billingType.getReportGroup(); //selected on combo box
								%>
                                            <%=ControlCombo.draw(FrmBillingType.fieldNames[FrmBillingType.FRM_FIELD_REPORT_GROUP], null, select_rptgroup, val_rptgroup, key_rptgroup, "", "formElemen")%> <%=frmBillingType.getErrorMsg(FrmBillingType.FRM_FIELD_DEPARTMENT_ID)%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" class="command" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="4" class="command" valign="top"> 
                                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidBillingType+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidBillingType+"')";
									String scancel = "javascript:cmdEdit('"+oidBillingType+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setCommandStyle("buttonlink");

									ctrLine.setSaveCaption("Save Data");
									ctrLine.setDeleteCaption("Delete Data");

									if (privDelete){
										ctrLine.setConfirmDelCommand(sconDelCom);
										ctrLine.setDeleteCommand(scomDel);
										ctrLine.setEditCommand(scancel);
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
                                          </td>
                                        </tr>
                                      </table>
                                      <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%> 
                                      <%if(oidBillingType!=0 && iCommand!=Command.ASK){%>
                                      <table width="24%">
                                        <tr> 
                                          <td nowrap width="16%"><a href="javascript:cmdBillingType()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('xx','','<%=approot%>/images/ctr_line/add_f2.jpg',1)"><img name="xx" border="0" src="<%=approot%>/images/ctr_line/add.jpg" width="24" height="24" alt="Outlet Item"></a></td>
                                          <td nowrap width="84%"><a href="javascript:cmdBillingType()">Outlet 
                                            Item</a></td>
                                        </tr>
                                      </table>
                                      <%}%>
                                      <%}%>
                                    </td>
                                  </tr>
                                </table>
                              </td>
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
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footersl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

