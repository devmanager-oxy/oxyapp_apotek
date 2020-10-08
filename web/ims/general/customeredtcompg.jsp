 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
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
<!-- Jsp Block -->
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
int isSearch = JSPRequestValue.requestInt(request, "hidden_search");

//out.println("oidCustomer : "+oidCustomer);
//out.println("iJSPCommand : "+iJSPCommand);

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdCustomer cmdCustomer = new CmdCustomer(request);
JSPLine ctrLine = new JSPLine();
Vector listCustomer = new Vector(1,1);

/*switch statement */
iErrCode = cmdCustomer.action(iJSPCommand , oidCustomer);
/* end switch*/
JspCustomer jspCustomer = cmdCustomer.getForm();

/*count list All Customer*/
int vectSize = DbCustomer.getCount(whereClause);

Customer customer = cmdCustomer.getCustomer();
msgString =  cmdCustomer.getMessage();

customer.setType(1);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = cmdCustomer.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listCustomer = DbCustomer.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCustomer.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCustomer = DbCustomer.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/indexpg.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleSP%></title>
<link href="../css/csspg.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdChange(){
	var x = document.frmcustomer.<%=jspCustomer.fieldNames[JspCustomer.JSP_TYPE] %>.value;
	if(parseInt(x)==0){
	/*	document.all.comp1.style.display="none";
		document.all.comp2.style.display="none";
		document.all.person1.style.display="";
		//document.all.name_title.style.display="";
		document.all.name_title1.style.display="";
		document.all.name_title2.style.display="";
		document.frmcustomer.<%=jspCustomer.fieldNames[JspCustomer.JSP_NAME] %>.size=20;
		//alert("person");
	}
	else{
		document.all.comp1.style.display="";
		document.all.comp2.style.display="";
		document.all.person1.style.display="none";
		//document.all.name_title.style.display="none";
		document.all.name_title1.style.display="none";
		document.all.name_title2.style.display="none";
		//alert("comp");
		document.frmcustomer.<%=jspCustomer.fieldNames[JspCustomer.JSP_NAME] %>.size=42;
	}
	*/
	
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
	}
}

<%if(!custQueryPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if((iJSPCommand==JSPCommand.SAVE || iJSPCommand==JSPCommand.DELETE) && iErrCode==0 ){%>
	window.location="customerpg.jsp?command=<%=JSPCommand.BACK%>&hidden_customer_id=<%=oidCustomer%>&menu_idx=1";
	//cmdBack();
<%}%>

function cmdAdd(){
	document.frmcustomer.hidden_customer_id.value="0";
	document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
}

function cmdAsk(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
}

function cmdConfirmDelete(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
}
function cmdSave(){
	document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
	}

function cmdEdit(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
	}

function cmdCancel(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
}

function cmdBack(){
	document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
	document.frmcustomer.action="customerpg.jsp";
	document.frmcustomer.submit();
	}

function cmdListFirst(){
	document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
}

function cmdListPrev(){
	document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
	}

function cmdListNext(){
	document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
}

function cmdListLast(){
	document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.action="customeredtcompg.jsp";
	document.frmcustomer.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagespg/home2.gif','<%=approot%>/imagespg/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenupg.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagespg/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menupg.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                                        <form name="frmcustomer" method ="post" action="">
                                                                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                          <input type="hidden" name="start" value="<%=start%>">
                                                                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                          <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                                                                          <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                                                                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                              <td valign="top"> 
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                  <tr valign="bottom"> 
                                                                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Customer</font><font class="tit1"> 
                                                                                      &raquo; 
                                                                                      </font></b><b><font class="tit1"><span class="lvl2">Editor 
                                                                                      </span></font></b></td>
                                                                                    <td width="40%" height="23"> 
                                                                                      <%@ include file = "../main/userpreview.jsp" %>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr > 
                                                                                    <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                  </tr>
                                                                                </table>
                                                                              </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                              <td height="8" valign="middle" colspan="3" class="container"> 
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                  <tr align="left"> 
                                                                                    <td height="21" valign="middle" width="11%">&nbsp;</td>
                                                                                    <td height="21" width="27%" class="comment" valign="middle">*)= 
                                                                                      required</td>
                                                                                    <td height="21" width="15%" class="comment" valign="top">&nbsp;</td>
                                                                                    <td height="21" width="46%" class="comment" valign="top">&nbsp;</td>
                                                                                  </tr>
                                                                                  <!--tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">Customer Type</td>
                                    <td height="21" width="27%"> 
                                      <select name="<%=jspCustomer.fieldNames[JspCustomer.JSP_TYPE]%>" onChange="javascript:cmdChange()">
                                        <option value="0" <%if(customer.getType()==0){%>selected<%}%>>Private House</option>
                                        <option value="1" <%if(customer.getType()==1){%>selected<%}%>>Apartment</option>
                                        <option value="2" <%if(customer.getType()==2){%>selected<%}%>>Cafe</option>
                                        <option value="3" <%if(customer.getType()==3){%>selected<%}%>>Factory</option>
                                        <option value="4" <%if(customer.getType()==4){%>selected<%}%>>Garment</option>
                                        <option value="5" <%if(customer.getType()==5){%>selected<%}%>>Hospital</option>
                                        <option value="6" <%if(customer.getType()==6){%>selected<%}%>>Hotel</option>
                                        <option value="7" <%if(customer.getType()==7){%>selected<%}%>>Night 
                                        Club</option>
                                        <option value="8" <%if(customer.getType()==8){%>selected<%}%>>Office 
                                        Building</option>
                                        <option value="9" <%if(customer.getType()==9){%>selected<%}%>>Private 
                                        House</option>
                                        <option value="10" <%if(customer.getType()==10){%>selected<%}%>>Resort</option>
                                        <option value="11" <%if(customer.getType()==11){%>selected<%}%>>Villa</option>
                                      </select>                                      
                                    <td height="21" width="15%">&nbsp; 
                                    <td height="21" width="46%">&nbsp; </td>
									</tr-->
                                                                                  <!--tr align="left"> 
                                    <td height="21" valign="top" width="0%">&nbsp;</td>
                                    <td height="21" width="8%">Code</td>
                                    <td height="21" width="23%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CODE] %>"  value="<%= customer.getCode() %>" class="formElemen" size="15">
                                    <td height="21" width="11%">&nbsp; 
                                    <td height="21" width="58%">&nbsp; 
									</td></tr-->
                                                                                  <tr align="left"> 
                                                                                    <td height="5" valign="top" colspan="4"></td>
                                                                                  <tr align="left"> 
                                                                                    <td height="21" width="11%"> 
                                                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr id="comp2"> 
                                                                                          <td>Company 
                                                                                            Name</td>
                                                                                        </tr>
                                                                                      </table>
                                                                                    </td>
                                                                                    <td height="21" colspan="3"> 
                                                                                      <table width="31%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                          <td width="20" nowrap> 
                                                                                            <select name="<%=jspCustomer.fieldNames[JspCustomer.JSP_SALUTATION] %>">
                                                                                              <option value=""></option>
                                                                                              <%//for(int i=0; i<I_Project.salutationArray.length; i++){%>
                                                                                              <option value="<%=I_Project.SALUTATION_MR%>" <%if(customer.getSalutation()!=null && customer.getSalutation().equals(I_Project.SALUTATION_MR)){%>selected<%}%>><%=I_Project.SALUTATION_MR%></option>
                                                                                              <option value="<%=I_Project.SALUTATION_MRS%>" <%if(customer.getSalutation()!=null && customer.getSalutation().equals(I_Project.SALUTATION_MRS)){%>selected<%}%>><%=I_Project.SALUTATION_MRS%></option>
                                                                                              <option value="<%=I_Project.SALUTATION_COMP_CV%>" <%if(customer.getSalutation()!=null && customer.getSalutation().equals(I_Project.SALUTATION_COMP_CV)){%>selected<%}%>><%=I_Project.SALUTATION_COMP_CV%></option>
                                                                                              <option value="<%=I_Project.SALUTATION_COMP_PT%>" <%if(customer.getSalutation()!=null && customer.getSalutation().equals(I_Project.SALUTATION_COMP_PT)){%>selected<%}%>><%=I_Project.SALUTATION_COMP_PT%></option>
                                                                                              <option value="<%=I_Project.SALUTATION_COMP_UD%>" <%if(customer.getSalutation()!=null && customer.getSalutation().equals(I_Project.SALUTATION_COMP_UD)){%>selected<%}%>><%=I_Project.SALUTATION_COMP_UD%></option>
                                                                                              <%//}%>
                                                                                            </select>
                                                                                          </td>
                                                                                          <td width="2" nowrap><img src="../images/spacer.gif" width="2" height="1"></td>
                                                                                          <td width="65" nowrap> 
                                                                                            <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_NAME] %>"  value="<%= customer.getName() %>" class="formElemen" size="42">
                                                                                          </td>
                                                                                          <td width="2" nowrap><img src="../images/spacer.gif" width="2" height="1"></td>
                                                                                          <td nowrap width="25" id="name_title1">&nbsp; 
                                                                                          </td>
                                                                                          <td width="2" nowrap><img src="../images/spacer.gif" width="2" height="1"></td>
                                                                                          <td width="65" id="name_title2" nowrap> 
                                                                                            <input type="hidden" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_TYPE] %>" value="1">
                                                                                          </td>
                                                                                        </tr>
                                                                                      </table>
                                                                                  <tr align="left"> 
                                                                                    <td height="21" width="11%">Address</td>
                                                                                    <td height="21" width="27%" nowrap> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_ADDRESS] %>"  value="<%= customer.getAddress() %>" size="52">
                                                                                      * 
                                                                                    <td height="21" width="15%"> 
                                                                                      <div align="right">City&nbsp;&nbsp; 
                                                                                      </div>
                                                                                    <td height="21" width="46%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CITY] %>"  value="<%= customer.getCity() %>" class="formElemen" size="40">
                                                                                  <tr align="left"> 
                                                                                    <td height="21" width="11%">Province/State</td>
                                                                                    <td height="21" width="27%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_STATE] %>"  value="<%= customer.getState() %>" class="formElemen" size="52">
                                                                                    <td height="21" width="15%"> 
                                                                                      <div align="right">Country&nbsp;&nbsp; 
                                                                                      </div>
                                                                                    <td height="21" width="46%"> 
                                                                                      <% 
						Vector vctCtr = DbCountry.list(0,0, "", "name");
					
						Vector countryid_value = new Vector(1,1);
						Vector countryid_key = new Vector(1,1);
					 	String sel_countryid = ""+customer.getCountryId();
						
						countryid_key.add("0");
			   			countryid_value.add(" ");
						
						if(vctCtr!=null && vctCtr.size()>0){
							for(int i=0; i<vctCtr.size(); i++){
								Country ctr = (Country)vctCtr.get(i);
					   			countryid_key.add(""+ctr.getOID());
					   			countryid_value.add(""+ctr.getName());
					   		}
						}	
					   %>
                                                                                      <%= JSPCombo.draw(jspCustomer.fieldNames[JspCustomer.JSP_COUNTRY_ID],null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %> 
                                                                                  <tr align="left"> 
                                                                                    <td height="21" width="11%">Zip 
                                                                                      Code</td>
                                                                                    <td height="21" width="27%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_ZIP_CODE] %>"  value="<%= (customer.getZipCode()==null) ? "" :customer.getZipCode() %>" class="formElemen" size="52">
                                                                                    <td height="21" width="15%"> 
                                                                                      <div align="right"></div>
                                                                                    <td height="21" width="46%">&nbsp; 
                                                                                  <tr align="left"> 
                                                                                    <td height="21" width="11%">Telephone</td>
                                                                                    <td height="21" width="27%" nowrap> 
                                                                                      <input type="hidden" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_PHONE_AREA] %>"  value="<%= (customer.getPhoneArea()==null) ? "" : customer.getPhoneArea() %>" class="formElemen" size="7" maxlength="4">
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_PHONE] %>"  value="<%= (customer.getPhone()==null) ? "" : customer.getPhone() %>" class="formElemen" size="52">
                                                                                    <td height="21" width="15%"> 
                                                                                      <div align="right">Fax&nbsp;&nbsp; 
                                                                                      </div>
                                                                                    <td height="21" width="46%"> 
                                                                                      <input type="hidden" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_FAX_AREA] %>"  value="<%= (customer.getFaxArea()==null) ? "" : customer.getFaxArea() %>" class="formElemen" size="7">
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_FAX] %>"  value="<%= (customer.getFax()==null) ? "" : customer.getFax() %>" class="formElemen" size="40">
                                                                                  <tr align="left"> 
                                                                                    <td height="21" width="11%" nowrap>Tax 
                                                                                      ID/NPWP&nbsp;&nbsp;</td>
                                                                                    <td height="10" width="27%"> 
                                                                                      <% Vector idtype_value = new Vector(1,1);
						Vector idtype_key = new Vector(1,1);
					 	String sel_idtype = ""+customer.getIdType();
						for(int i=0; i<I_Project.idTypeArray.length; i++){
						   idtype_key.add(I_Project.idTypeArray[i]);
						   idtype_value.add(I_Project.idTypeArray[i]);
					    }
					   %>
                                                                                      <%//= JSPCombo.draw(jspCustomer.fieldNames[JspCustomer.JSP_ID_TYPE],null, sel_idtype, idtype_key, idtype_value, "", "formElemen") %>
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_ID_NUMBER] %>"  value="<%= customer.getIdNumber() %>" class="formElemen" size="52">
                                                                                    <td height="10" width="15%" nowrap> 
                                                                                      <div align="right">Occupation/Business 
                                                                                        Type&nbsp;&nbsp; 
                                                                                      </div>
                                                                                    <td height="10" width="46%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_OCCUPATION] %>"  value="<%= customer.getOccupation() %>" class="formElemen" size="40">
                                                                                      <!--tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">Dob</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="15%"> 
                                            <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_DOB] %>"  value="<%= JSPFormater.formatDate(customer.getDob(), "dd/MM/yyyy") %>" class="formElemen" size="15">
                                          </td>
                                          <td width="7%"><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.<%=jspCustomer.fieldNames[JspCustomer.JSP_DOB]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height=18 border="0" alt="sob" width="24""></a></td>
                                          <td width="2%"> 
                                            <input type="checkbox" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_DOB_IGNORE] %>" value="1" <%if(customer.getDobIgnore()==1){%>checked<%}%>>
                                          </td>
                                          <td width="76%"> Ignored </td>
                                        </tr>
                                      </table>
								  </tr-->
                                                                                  <tr align="left"> 
                                                                                    <td height="8" width="11%">Email</td>
                                                                                    <td height="8" width="27%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_EMAIL] %>"  value="<%= (customer.getEmail()==null) ? "" : customer.getEmail() %>" class="formElemen" size="52">
                                                                                    </td>
                                                                                    <td height="8" width="15%"> 
                                                                                      <div align="right">Website&nbsp;&nbsp;</div>
                                                                                    </td>
                                                                                    <td height="8" width="46%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_WEBSITE] %>"  value="<%= customer.getWebSite() %>" class="formElemen" size="40">
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="5" valign="middle" colspan="4"></td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="8" colspan="4"> 
                                                                                      <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                          <td background="../images/line1.gif" height="3"></td>
                                                                                        </tr>
                                                                                      </table>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="5" valign="middle" colspan="4"></td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="8" width="11%" nowrap>Contact 
                                                                                      Person 
                                                                                      ( 
                                                                                      F 
                                                                                      M 
                                                                                      L 
                                                                                      )</td>
                                                                                    <td height="8" width="27%"> 
                                                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                          <td width="10%"> 
                                                                                            <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CONTACT_PERSON] %>"  value="<%= (customer.getContactPerson()==null) ? "" : customer.getContactPerson() %>" class="formElemen" size="52">
                                                                                          </td>
                                                                                          <td nowrap width="2%"> 
                                                                                            <img src="../images/spacer.gif" width="1" height="1"> 
                                                                                            <!--input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CONTACT_MIDDLE_NAME] %>"  value="<%= (customer.getContactMiddleName()==null) ? "" : customer.getContactMiddleName() %>" class="formElemen" size="3" maxlength="1"-->
                                                                                            <img src="../images/spacer.gif" width="1" height="1"> 
                                                                                          </td>
                                                                                          <td width="88%"> 
                                                                                            <!--input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CONTACT_LAST_NAME] %>"  value="<%= (customer.getContactLastName()==null) ? "" : customer.getContactLastName() %>" class="formElemen" size="19"-->
                                                                                          </td>
                                                                                        </tr>
                                                                                      </table>
                                                                                    </td>
                                                                                    <td height="8" width="15%">&nbsp;</td>
                                                                                    <td height="8" width="46%">&nbsp; 
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="8" width="11%">Position</td>
                                                                                    <td height="8" width="27%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CONTACT_POSITION] %>" value="<%=customer.getContactPosition()%>" size="52">
                                                                                    </td>
                                                                                    <td height="8" width="15%"> 
                                                                                      <div align="right">Email&nbsp;&nbsp;</div>
                                                                                    </td>
                                                                                    <td height="8" width="46%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CONTACT_EMAIL] %>"  value="<%=customer.getContactEmail()%>" class="formElemen" size="40">
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="8" width="11%">Phone</td>
                                                                                    <td height="8" width="27%"> 
                                                                                      <input type="hidden" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CONTACT_PHONE_AREA] %>" value="<%=customer.getContactPhoneArea()%>" size="7">
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CONTACT_PHONE] %>" value="<%=customer.getContactPhone()%>" size="52">
                                                                                    </td>
                                                                                    <td height="8" width="15%"> 
                                                                                      <div align="right">Mobile&nbsp;&nbsp;</div>
                                                                                    </td>
                                                                                    <td height="8" width="46%"> 
                                                                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_HP] %>"  value="<%= (customer.getHp()==null) ? "" : customer.getHp() %>" class="formElemen" size="40">
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="5" valign="middle" colspan="4"></td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="8" colspan="4"> 
                                                                                      <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                          <td background="../images/line1.gif" height="3"></td>
                                                                                        </tr>
                                                                                      </table>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="5" valign="middle" colspan="4"></td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="8" width="11%"> 
                                                                                      Note</td>
                                                                                    <td height="8" colspan="3"> 
                                                                                      <textarea name="<%=jspCustomer.fieldNames[JspCustomer.JSP_HOTEL_NOTE] %>" class="formElemen" cols="120" rows="2"><%= customer.getHotelNote() %></textarea>
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="8" valign="middle" width="11%">&nbsp;</td>
                                                                                    <td height="8" width="27%" valign="top">&nbsp;</td>
                                                                                    <td height="8" width="15%" valign="top">&nbsp;</td>
                                                                                    <td height="8" width="46%" valign="top">&nbsp;</td>
                                                                                  </tr>
                                                                                  <tr align="left"> 
                                                                                    <td height="8" valign="middle" colspan="4"> 
                                                                                      <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("60%");
									String scomDel = "javascript:cmdAsk('"+oidCustomer+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidCustomer+"')";
									String scancel = "javascript:cmdEdit('"+oidCustomer+"')";
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
									%>
                                                                                      <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left" > 
                                                                                    <td colspan="4" class="command" valign="top">&nbsp; 
                                                                                    </td>
                                                                                  </tr>
                                                                                  <tr align="left" > 
                                                                                    <td colspan="4" valign="top"> 
                                                                                      <div align="left"></div>
                                                                                    </td>
                                                                                  </tr>
                                                                                </table>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                          <script language="JavaScript">
						//cmdChange();
						</script>
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
            <%@ include file="../main/footerpg.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
