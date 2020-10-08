<%
/*
 * Page Name  		:  billingtypeitem.jsp
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
<%@ page import = "java.util.*,
                   com.berlian.fdms.entity.search.SrcBillingTypeItem,
                   com.berlian.fdms.form.search.FrmSrcBillingTypeItem" %>
<!-- package berlian -->
<%@ page import = "com.berlian.util.*" %>
<!-- package qdep -->
<%@ page import = "com.berlian.gui.jsp.*" %>
<%@ page import = "com.berlian.qdep.form.*" %>
<!--package fdms -->
<%@ page import = "com.berlian.fdms.entity.masterdata.*" %>
<%@ page import = "com.berlian.harisma.entity.masterdata.*" %>
<%@ page import = "com.berlian.fdms.form.masterdata.*" %>
<%@ page import = "com.berlian.harisma.form.masterdata.*" %>
<%@ page import = "com.berlian.fdms.entity.admin.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 0;//AppObjInfo.composeObjCode(AppObjInfo.G1_DATA_MANAGEMENT, AppObjInfo.G2_DATA_MANAG_MASTER_D, AppObjInfo.OBJ_D_MANAG_MASTER_BILLING_TYPE_ITEM); %>
<%@ include file = "../main/checksl.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd= true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//out.println("privDelete : "+privDelete);

%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long billingTypeItemId, Vector billGroup, String strForeignCurrencyDefault)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell1");
		ctrlist.setCellStyle1("tablecell");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Category","15%");
		ctrlist.addHeader("Code","8%");
		ctrlist.addHeader("Name","27%");
		ctrlist.addHeader("Selling Price","25%");
		ctrlist.addHeader("Cost","25%");
		//ctrlist.addHeader("Description","20%");

		ctrlist.setLinkRow(2);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			BillingTypeItem billingTypeItem = (BillingTypeItem)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(billingTypeItemId == billingTypeItem.getOID())
				 index = i;

			rowx.add(getGroupName(billingTypeItem.getBillingItemGroupId(), billGroup));

			rowx.add(billingTypeItem.getItemCode());

			rowx.add(billingTypeItem.getItemName());

			rowx.add("<b>Rp.</b> "+Formater.formatNumber(billingTypeItem.getSellingPrice(), "#,###.##")+", &nbsp;&nbsp;<b>"+strForeignCurrencyDefault+"</b> "+Formater.formatNumber(billingTypeItem.getSellingPriceUsd(), "#,###.##"));

			rowx.add("<b>Rp.</b> "+Formater.formatNumber(billingTypeItem.getItemCost(), "#,###.##")+", &nbsp;&nbsp;<b>"+strForeignCurrencyDefault+"</b> "+Formater.formatNumber(billingTypeItem.getItemCostUsd(), "#,###.##"));

			//rowx.add();

			//rowx.add(billingTypeItem.getDescription());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(billingTypeItem.getOID()));
		}

		return ctrlist.draw();
	}


public String getGroupName(long oid, Vector billGroup){
	if(billGroup!=null && billGroup.size()>0){
		for(int i=0; i<billGroup.size(); i++){
			BillingItemGroup billingGroup = (BillingItemGroup)billGroup.get(i);
			if(billingGroup.getOID()==oid){
				return billingGroup.getGroupName();
			}
		}
	}
	return "";
}


%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int start1 = FRMQueryString.requestInt(request, "start1");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidBillingTypeItem = FRMQueryString.requestLong(request, "hidden_billing_type_item_id");
long oidBillingType = FRMQueryString.requestLong(request, "hidden_billing_type_id");
String code = FRMQueryString.requestString(request, "code");
String name = FRMQueryString.requestString(request, "name");
Vector billingGroup = PstBillingItemGroup.listAll();
SrcBillingTypeItem srcBillType = new SrcBillingTypeItem();
FrmSrcBillingTypeItem frmSrcBillType = new FrmSrcBillingTypeItem(request, srcBillType);
/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

//get billing type by bil type oid
BillingType billTypeObj = new BillingType();
if(oidBillingType!=0){
	whereClause = PstBillingType.fieldNames[PstBillingType.FLD_BILLING_TYPE_ID]+"="+oidBillingType;
	Vector bilType = PstBillingType.list(0,0, whereClause, null);
	if(bilType!=null && bilType.size()>0){
		billTypeObj = (BillingType)bilType.get(0);
	}
}

CtrlBillingTypeItem ctrlBillingTypeItem = new CtrlBillingTypeItem(request);
ControlLine ctrLine = new ControlLine();
Vector listAllBillingTypeItem = new Vector(1,1);

/*switch statement */
iErrCode = ctrlBillingTypeItem.action(iCommand , oidBillingTypeItem, oidBillingType);
/* end switch*/
FrmBillingTypeItem frmBillingTypeItem = ctrlBillingTypeItem.getForm();

/* get record to display */
whereClause = PstBillingTypeItem.fieldNames[PstBillingTypeItem.FLD_BILLING_TYPE_ID]+"="+oidBillingType;

int vectSize = PstBillingTypeItem.getCountBillingItemByOutlet(code,name,oidBillingType);

 if(iCommand == Command.LIST){
        frmSrcBillType.requestEntityObject(srcBillType);
        session.putValue("SRC_BILLING_TYPE", srcBillType);
    }
    else{
        if(session.getValue("SRC_BILLING_TYPE")!=null){
            srcBillType = (SrcBillingTypeItem)session.getValue("SRC_BILLING_TYPE");
        }
    }

if(iCommand != Command.BACK){
        start1 = ctrlBillingTypeItem.actionList(iCommand, start1, vectSize, recordToGet);
}


//out.println("whereClause : "+whereClause);

if(iCommand==Command.EDIT || iCommand==Command.ADD || iCommand==Command.SUBMIT ||
   iCommand==Command.ASK || iCommand==Command.SAVE ||
   iCommand == Command.FIRST || iCommand == Command.PREV ||
   iCommand == Command.NEXT || iCommand == Command.LAST || iCommand == Command.BACK){
    listAllBillingTypeItem = PstBillingTypeItem.listBillingItemByOutlet(start1,recordToGet, code, name, oidBillingType);
}
/* end switch list */


BillingTypeItem billingTypeItem = ctrlBillingTypeItem.getBillingTypeItem();
msgString =  ctrlBillingTypeItem.getMessage();

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listAllBillingTypeItem.size() < 1 && start1 > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start1 = start1 - recordToGet;   //go to Command.PREV
	 else{
		 start1 = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 
	 
	 listAllBillingTypeItem = PstBillingTypeItem.list(start1,recordToGet, whereClause , orderClause);
}


//out.println(listAllBillingTypeItem);
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
(iCommand==Command.SAVE && iErrCode!=FRMMessage.NONE)){%>
	window.location="#go";
<%}%>

function cmdAdd(){
	document.frmbillingtypeitem.hidden_billing_type_item_id.value="0";
	document.frmbillingtypeitem.command.value="<%=Command.ADD%>";
	document.frmbillingtypeitem.prev_command.value="<%=prevCommand%>";
	document.frmbillingtypeitem.action="outlet_item.jsp";
	document.frmbillingtypeitem.submit();
}

function cmdAsk(oidBillingTypeItem){
	document.frmbillingtypeitem.hidden_billing_type_item_id.value=oidBillingTypeItem;
	document.frmbillingtypeitem.command.value="<%=Command.ASK%>";
	document.frmbillingtypeitem.prev_command.value="<%=prevCommand%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
}

function cmdConfirmDelete(oidBillingTypeItem){
	document.frmbillingtypeitem.hidden_billing_type_item_id.value=oidBillingTypeItem;
	document.frmbillingtypeitem.command.value="<%=Command.DELETE%>";
	document.frmbillingtypeitem.prev_command.value="<%=prevCommand%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
}
function cmdSave(){
	document.frmbillingtypeitem.command.value="<%=Command.SAVE%>";
	document.frmbillingtypeitem.prev_command.value="<%=prevCommand%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
}

function cmdEdit(oidBillingTypeItem){
	document.frmbillingtypeitem.hidden_billing_type_item_id.value=oidBillingTypeItem;
	document.frmbillingtypeitem.command.value="<%=Command.EDIT%>";
	document.frmbillingtypeitem.prev_command.value="<%=prevCommand%>";
	document.frmbillingtypeitem.action="outlet_item.jsp";
	document.frmbillingtypeitem.submit();
}

function cmdCancel(oidBillingTypeItem){
	document.frmbillingtypeitem.hidden_billing_type_item_id.value=oidBillingTypeItem;
	document.frmbillingtypeitem.command.value="<%=Command.EDIT%>";
	document.frmbillingtypeitem.prev_command.value="<%=prevCommand%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
}

function cmdBack(){
    document.frmbillingtypeitem.command.value="<%=Command.BACK%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
	}

function cmdListFirst(){
	document.frmbillingtypeitem.command.value="<%=Command.FIRST%>";
	document.frmbillingtypeitem.prev_command.value="<%=Command.FIRST%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
}

function cmdListPrev(){
	document.frmbillingtypeitem.command.value="<%=Command.PREV%>";
	document.frmbillingtypeitem.prev_command.value="<%=Command.PREV%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
	}

function cmdListNext(){
	document.frmbillingtypeitem.command.value="<%=Command.NEXT%>";
	document.frmbillingtypeitem.prev_command.value="<%=Command.NEXT%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
}

function cmdListLast(){
	document.frmbillingtypeitem.command.value="<%=Command.LAST%>";
	document.frmbillingtypeitem.prev_command.value="<%=Command.LAST%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
}

function cmdBackType(){
	<%--document.frmbillingtypeitem.command.value="<%=Command.BACK%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();--%>
    <%--document.frmbillingtypeitem.action="<%=approot%>/management/masterdata/billingtype.jsp";
	document.frmbillingtypeitem.submit();--%>
    document.frmbillingtypeitem.command.value="<%=Command.EDIT%>";
	document.frmbillingtypeitem.action="billingtype.jsp";
	document.frmbillingtypeitem.submit();

}
function cmdSearch(){
	document.frmbillingtypeitem.command.value="<%=Command.SUBMIT%>";
	document.frmbillingtypeitem.action="billingtypeitem.jsp";
	document.frmbillingtypeitem.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','<%=approot%>/images/ctr_line/search_f2.jpg')">
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
                        
                        <form name="frmbillingtypeitem" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start1" value="<%=start1%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                          <input type="hidden" name="hidden_billing_type_item_id" value="<%=oidBillingTypeItem%>">
                          <input type="hidden" name="hidden_billing_type_id" value="<%=oidBillingType%>">
						  <%
									  String navigator = "<font class=\"lvl1\">Outlet/Sales Location</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Item Sale List</span></font>";
									  %>
									  <%@ include file="../main/navigatorsl.jsp"%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="1">
                            <tr> 
                              <td width="88%" class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td colspan="3"><b><font size="4" color="#0000CC"><%=billTypeObj.getTypeCode()%> / <%=billTypeObj.getTypeName().toUpperCase()%></font></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="17%">&nbsp;</td>
                                    <td width="2%">&nbsp;</td>
                                    <td width="81%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="3"><b><i>Search For Outlet Item</i></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="17%">Item Code</td>
                                    <td width="2%">:</td>
                                    <td width="81%"> 
                                      <input type="text"  name="code" class="formElemen" value="<%=code%>" size="20">
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="17%">Item Name</td>
                                    <td width="2%">:</td>
                                    <td width="81%"> 
                                      <input type="text"  name="name" class="formElemen" value="<%=name%>" size="20">
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="17%">&nbsp;</td>
                                    <td width="2%"></td>
                                    <td width="81%"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="4%"><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1010','','<%=approot%>/images/ctr_line/search_f2.jpg',1)"><img name="Image1010" border="0" src="<%=approot%>/images/ctr_line/search.jpg" width="24" height="24" alt="List Item"></a></td>
                                          <td width="96%"><a href="javascript:cmdSearch()">Search</a></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                                <%if(iCommand==Command.BACK || iCommand==Command.ASK || iCommand==Command.SAVE || iCommand==Command.ADD ||iCommand==Command.EDIT || iCommand==Command.SUBMIT || iCommand==Command.FIRST || iCommand==Command.NEXT || iCommand==Command.PREV || iCommand==Command.LAST){%>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3" class="msgquestion">&nbsp;&nbsp; 
                                          </td>
                                        </tr>
                                        <%
					                 try{
								        if (listAllBillingTypeItem.size()>0){
							         %>
                                        <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3">&nbsp;<b><%=billTypeObj.getTypeName().toUpperCase()%> ITEM LIST</b></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listAllBillingTypeItem,oidBillingTypeItem, billingGroup, strForeignCurrencyDefault)%> </td>
                                        </tr>
                                        <%}
							            else{%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3" class="msgquestion">&nbsp;&nbsp;no 
                                            item available ....</td>
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
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start1,recordToGet)%> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="37%" border="0" cellspacing="2" cellpadding="3">
                                              <tr> 
                                                <%if(privAdd){%>
                                                <%}%>
                                                <td width="10%"><a href="javascript:cmdBackType()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image300','','<%=approot%>/images/ctr_line/back_f2.jpg',1)"><img name="Image300" border="0" src="<%=approot%>/images/ctr_line/back.jpg" width="24" height="24" alt="Back To Management Menu"></a></td>
                                                <td nowrap width="37%"><a href="javascript:cmdBackType()" class="command">Back 
                                                  To List</a></td>
                                                <td nowrap width="15%"> 
                                                  <% if(privAdd){%>
                                                  <a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/ctr_line/add_f2.jpg',1)"><img name="Image10" border="0" src="<%=approot%>/images/ctr_line/add.jpg" width="24" height="24" alt="Add New Item"></a> 
                                                  <%}%>
                                                </td>
                                                <td nowrap width="38%"> 
                                                  <% if(privAdd ){%>
                                                  <a href="javascript:cmdAdd()">Add 
                                                  New </a> 
                                                  <%}%>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmBillingTypeItem.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                                      <table width="100%" border="0" cellspacing="3" cellpadding="1">
                                        <%if(iCommand ==Command.ADD){%>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" colspan="3"><b>Outlet 
                                            Item</b></td>
                                        </tr>
                                        <%}%>
                                        <%if(iCommand ==Command.EDIT){%>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" colspan="3"><b>Outlet 
                                            Item Editor</b></td>
                                        </tr>
                                        <%}%>
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="17%"><a name="go"></a></td>
                                          <td height="21" colspan="2" width="83%" valign="top"><font color="#FF0000"><i>*) 
                                            required</i></font></td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="17%">Item Group</td>
                                          <td height="21" colspan="2" width="83%" valign="top"> 
                                            <%
								//Vector billGroup = PstBillingItemGroup.listAll();

								Vector val_group = new Vector(1,1); //hidden values that will be deliver on request (oids)
								Vector key_group = new Vector(1,1); //texts that displayed on combo box

								if(billingGroup!=null && billingGroup.size()>0){
									for(int i=0; i<billingGroup.size(); i++){
										BillingItemGroup bGroup = (BillingItemGroup)billingGroup.get(i);
										val_group.add(""+bGroup.getOID());
										key_group.add(bGroup.getGroupName());
									}
								}

								String select_group = ""+billingTypeItem.getBillingItemGroupId(); //selected on combo box
								%>
                                            <%=ControlCombo.draw(frmBillingTypeItem.fieldNames[frmBillingTypeItem.FRM_FIELD_BILLING_ITEM_GROUP_ID], null, select_group, val_group, key_group, "", "formElemen")%>* <%=frmBillingTypeItem.getErrorMsg(frmBillingTypeItem.FRM_FIELD_BILLING_ITEM_GROUP_ID)%> 
                                        <tr align="left"> 
                                          <td height="21" width="17%">Item Code</td>
                                          <td height="21" colspan="2" width="83%" valign="top"> 
                                            <input type="text" name="<%=frmBillingTypeItem.fieldNames[FrmBillingTypeItem.FRM_FIELD_ITEM_CODE] %>"  value="<%= billingTypeItem.getItemCode() %>" class="formElemen" size="10">
                                            * <%= frmBillingTypeItem.getErrorMsg(FrmBillingTypeItem.FRM_FIELD_ITEM_CODE) %> 
                                        <tr align="left"> 
                                          <td height="21" width="17%">Item Name</td>
                                          <td height="21" colspan="2" width="83%" valign="top"> 
                                            <input type="text" name="<%=frmBillingTypeItem.fieldNames[FrmBillingTypeItem.FRM_FIELD_ITEM_NAME] %>"  value="<%= billingTypeItem.getItemName() %>" class="formElemen" size="35">
                                            * <%= frmBillingTypeItem.getErrorMsg(FrmBillingTypeItem.FRM_FIELD_ITEM_NAME) %> 
                                        <tr align="left"> 
                                          <td height="21" width="17%">Selling 
                                            Price</td>
                                          <td height="21" colspan="2" width="83%" valign="top"> 
                                            Rp. 
                                            <input type="text" name="<%=frmBillingTypeItem.fieldNames[FrmBillingTypeItem.FRM_FIELD_SELLING_PRICE] %>"  value="<%= billingTypeItem.getSellingPrice() %>" class="formElemen" size="10">
                                            <%= frmBillingTypeItem.getErrorMsg(FrmBillingTypeItem.FRM_FIELD_SELLING_PRICE) %> <font color="#FF0000">&nbsp;</font>, 
                                            <%=strForeignCurrencyDefault%> 
                                            <input type="text" name="<%=frmBillingTypeItem.fieldNames[FrmBillingTypeItem.FLM_FIELD_SELLING_PRICE_USD] %>"  value="<%= billingTypeItem.getSellingPriceUsd() %>" class="formElemen" size="10">
                                        <tr align="left"> 
                                          <td height="21" width="17%">Item Cost</td>
                                          <td height="21" colspan="2" width="83%" valign="top"> 
                                            Rp. 
                                            <input type="text" name="<%=frmBillingTypeItem.fieldNames[FrmBillingTypeItem.FRM_FIELD_ITEM_COST] %>"  value="<%= billingTypeItem.getItemCost() %>" class="formElemen" size="10">
                                            <%= frmBillingTypeItem.getErrorMsg(FrmBillingTypeItem.FRM_FIELD_ITEM_COST) %> , <%=strForeignCurrencyDefault%> 
                                            <input type="text" name="<%=frmBillingTypeItem.fieldNames[FrmBillingTypeItem.FLM_FIELD_ITEM_COST_USD]%>"  value="<%= billingTypeItem.getItemCostUsd() %>" class="formElemen" size="10">
                                        <tr align="left"> 
                                          <td height="21" valign="top" width="17%">Description</td>
                                          <td height="21" colspan="2" width="83%" valign="top"> 
                                            <textarea name="<%=frmBillingTypeItem.fieldNames[FrmBillingTypeItem.FRM_FIELD_DESCRIPTION] %>" class="formElemen" cols="45" rows="3"><%= billingTypeItem.getDescription() %></textarea>
                                        <tr align="left"> 
                                          <td height="21" valign="top" width="17%">&nbsp;</td>
                                          <td height="21" colspan="2" width="83%" valign="top"> 
                                            <i> <font color="#FF0000"> 
                                            <input type="radio" name="<%=frmBillingTypeItem.fieldNames[frmBillingTypeItem.FLM_FIELD_TYPE] %>" value="<%=PstBillingTypeItem.TYPE_REGULAR%>" <%if(billingTypeItem.getType()==PstBillingTypeItem.TYPE_REGULAR){%>checked<%}%>>
                                            Exclude Room Rate 
                                            <input type="radio" name="<%=frmBillingTypeItem.fieldNames[frmBillingTypeItem.FLM_FIELD_TYPE] %>" value="<%=PstBillingTypeItem.TYPE_INCLUDE%>" <%if(billingTypeItem.getType()==PstBillingTypeItem.TYPE_INCLUDE){%>checked<%}%>>
                                            Include Room Rate 
                                            <input type="radio" name="<%=frmBillingTypeItem.fieldNames[frmBillingTypeItem.FLM_FIELD_TYPE] %>" value="<%=PstBillingTypeItem.TYPE_ADJUSTMENT%>" <%if(billingTypeItem.getType()==PstBillingTypeItem.TYPE_ADJUSTMENT){%>checked<%}%>>
                                            </font></i><i><font color="#FF0000"> 
                                            Adjustment</font></i> 
                                        <tr align="left"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <i> </i></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="3" class="command" valign="top"> 
                                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidBillingTypeItem+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidBillingTypeItem+"')";
									String scancel = "javascript:cmdEdit('"+oidBillingTypeItem+"')";
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

