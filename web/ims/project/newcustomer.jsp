<%
	/***********************************|
	|  Create by Dek-Ndut               |
	|  Karya kami mohon jangan dibajak  |
	|                                   |
	|  9/17/2008 3:13:00 PM
	|***********************************/
%>
 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.crm.project.*" %>
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
	/* User Priv*/
	boolean masterPriv = true;//QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_CRM_MASTER, AppMenu.M2_CRM_GENERAL_CUSTOMER);
	boolean masterPrivView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_MASTER, AppMenu.M2_CRM_GENERAL_CUSTOMER, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_CRM_MASTER, AppMenu.M2_CRM_GENERAL_CUSTOMER, AppMenu.PRIV_UPDATE);
%>

<!-- Jsp Block -->
<%
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
	int isSearch = JSPRequestValue.requestInt(request, "hidden_search");

	if(iJSPCommand==JSPCommand.NONE)
	{
		iJSPCommand = JSPCommand.ADD;
	}

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
	iErrCode = cmdCustomer.action(iJSPCommand , oidCustomer, systemCompanyId);
	/* end switch*/
	JspCustomer jspCustomer = cmdCustomer.getForm();
	//out.println(jspCustomer.getErrors());
	
	/*count list All Customer*/
	int vectSize = DbCustomer.getCount(whereClause);
	
	Customer customer = cmdCustomer.getCustomer();
	msgString =  cmdCustomer.getMessage();
	
	Country country = new Country();
	try{
		country = DbCountry.fetchExc(customer.getCountryId());
	}catch(Exception e){
		System.out.println();
	}
	customer.setCountryName(country.getName());
	
	Country country1 = new Country();
	try{
		country1 = DbCountry.fetchExc(customer.getNationalityId());
	}catch(Exception e){
		System.out.println();
	}
	customer.setNationalityName(country.getNationality());


%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- #BeginTemplate "/Templates/clean.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "javascript" -->
<title>TITLE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

	<%if(!masterPriv || !masterPrivView){%>
		window.location="<%=approot%>/nopriv.jsp";
	<%}%>

function cmdChange(){
	var x = document.frmcustomer.<%=jspCustomer.fieldNames[JspCustomer.JSP_TYPE] %>.value;
	if(parseInt(x)==0){
		document.all.comp1.style.display="none";
		document.all.comp2.style.display="none";
		document.all.person1.style.display="";
	}
	else{
		document.all.comp1.style.display="";
		document.all.comp2.style.display="";
		document.all.person1.style.display="none";
	}
}

<%if((iJSPCommand==JSPCommand.SAVE || iJSPCommand==JSPCommand.DELETE) && iErrCode==0 ){%>	
    self.opener.frmproject.<%=JspProject.colNames[JspProject.JSP_CUSTOMER_ID]%>.value = <%=oidCustomer%>;
	self.opener.frmproject.submit();
    self.close();
	//cmdBack();
<%}%>

function cmdAdd(){
	document.frmcustomer.hidden_customer_id.value="0";
	document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
}

function cmdAsk(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
}

function cmdConfirmDelete(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
}
function cmdSave(){
	document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
	}

function cmdEdit(oidCustomer){
	<%if(masterPrivUpdate){%>
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
	<%}%>
	}

function cmdCancel(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
}

function cmdBack(){
	//document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
	//document.frmcustomer.action="customer.jsp";
	//document.frmcustomer.submit();
	self.opener.frmproject.submit();
    self.opener.frmproject.<%=JspProject.colNames[JspProject.JSP_CUSTOMER_ID]%>.value = <%=oidCustomer%>;
    self.close();
}

function cmdListFirst(){
	document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
}

function cmdListPrev(){
	document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
	}

function cmdListNext(){
	document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.action="newcustomer.jsp";
	document.frmcustomer.submit();
}

function cmdListLast(){
	document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.action="newcustomer.jsp";
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

</script><!-- #EndEditable -->
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
                        <form name="frmcustomer" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                          <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="5" valign="middle" width="1%"></td>
                                    <td height="5" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="1%">&nbsp;</td>
                                    <td height="21" valign="middle" width="15%">&nbsp;</td>
                                    <td height="21" colspan="2" width="84%" class="comment" valign="top">*)= 
                                      required</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Customer Type</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <select name="<%=jspCustomer.fieldNames[JspCustomer.JSP_TYPE] %>" onChange="javascript:cmdChange()">
                                        <option value="0" <%if(customer.getType()==0){%>selected<%}%>>Personel</option>
                                        <option value="1" <%if(customer.getType()==1){%>selected<%}%>>Company</option>
                                      </select>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Code</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CODE] %>"  value="<%= customer.getCode() %>" class="formElemen" size="15">
									  *
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Salutation</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <%try{%>
                                      <select name="<%=jspCustomer.fieldNames[JspCustomer.JSP_SALUTATION] %>">
                                        <%for(int i=0; i<I_Project.salutationArray.length; i++){%>
                                        <option value="<%=I_Project.salutationArray[i]%>" <%if(customer.getSalutation()!=null && customer.getSalutation().equals(I_Project.salutationArray[i])){%>selected<%}%>><%=I_Project.salutationArray[i]%></option>
                                        <%}%>
                                      </select>
                                      <%}
					catch(Exception e){
						out.println(e.toString());
					}
					
					%>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr id="person1">
                                          <td>Name</td>
                                        </tr>
                                        <tr id="comp2">
                                          <td>Company Name</td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_NAME] %>"  value="<%= customer.getName() %>" class="formElemen" size="50">
                                      * 
                                  <tr align="left" id="comp1"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Contact Person</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CONTACT_PERSON] %>"  value="<%= customer.getContactPerson() %>" class="formElemen" size="50">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Address</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_ADDRESS] %>"  value="<%= customer.getAddress() %>" class="formElemen" size="50">
                                      * 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">City</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CITY] %>"  value="<%= customer.getCity() %>" class="formElemen" size="30">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Province</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_STATE] %>"  value="<%= customer.getState() %>" class="formElemen" size="30">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Country</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <% 
						Vector vctCtr = DbCountry.list(0,0,  "", "name");
					
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
									  *
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Nationality</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <% Vector nationalityid_value = new Vector(1,1);
						Vector nationalityid_key = new Vector(1,1);
					 	String sel_nationalityid = "";
						if(customer.getNationalityId()>0){
							sel_nationalityid = ""+customer.getNationalityId();
						}else{
							sel_nationalityid = ""+0;
						}
						
						nationalityid_key.add("0");
					   	nationalityid_value.add(" ");
						
						if(vctCtr!=null && vctCtr.size()>0){
							for(int i=0; i<vctCtr.size(); i++){
								Country ctr = (Country)vctCtr.get(i);
					   			nationalityid_key.add(""+ctr.getOID());
					   			nationalityid_value.add(""+ctr.getNationality());
					   		}
						}
						
					   %>
                                      <%= JSPCombo.draw(jspCustomer.fieldNames[JspCustomer.JSP_NATIONALITY_ID],null, sel_nationalityid, nationalityid_key, nationalityid_value, "", "formElemen") %> 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Zip Code</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_ZIP_CODE] %>"  value="<%= customer.getZipCode() %>" class="formElemen" size="30">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Telephone</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_PHONE] %>"  value="<%= customer.getPhone() %>" class="formElemen" size="30">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Fax</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_FAX] %>"  value="<%= customer.getFax() %>" class="formElemen" size="30">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Mobile Phone</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_HP] %>"  value="<%= customer.getHp() %>" class="formElemen" size="30">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Tax ID/NPWP/SS</td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <% Vector idtype_value = new Vector(1,1);
						Vector idtype_key = new Vector(1,1);
					 	String sel_idtype = ""+customer.getIdType();
						for(int i=0; i<I_Project.idTypeArray.length; i++){
						   idtype_key.add(I_Project.idTypeArray[i]);
						   idtype_value.add(I_Project.idTypeArray[i]);
					    }
					   %>
                                      <%//= JSPCombo.draw(jspCustomer.fieldNames[JspCustomer.JSP_ID_TYPE],null, sel_idtype, idtype_key, idtype_value, "", "formElemen") %>
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_ID_NUMBER] %>"  value="<%= customer.getIdNumber() %>" class="formElemen" size="40">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="15%">Occupation/Business 
                                      Sector </td>
                                    <td height="21" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_OCCUPATION] %>"  value="<%= customer.getOccupation() %>" class="formElemen" size="40">
									  
									  <input type="hidden" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_DOB] %>"  value="<%= JSPFormater.formatDate(new Date(), "dd/MM/yyyy") %>" class="formElemen" size="15">
									  <input type="hidden" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_DOB_IGNORE] %>" value="1">
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
                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                    <td height="8" width="15%">Email</td>
                                    <td height="8" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_EMAIL] %>"  value="<%= customer.getEmail() %>" class="formElemen" size="40">
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                    <td height="8" width="15%">Website</td>
                                    <td height="8" colspan="2" width="84%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_WEBSITE] %>"  value="<%= customer.getWebSite() %>" class="formElemen" size="40">
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                    <td height="8" width="15%"> Note</td>
                                    <td height="8" colspan="2" width="84%"> 
                                      <textarea name="<%=jspCustomer.fieldNames[JspCustomer.JSP_HOTEL_NOTE] %>" class="formElemen" cols="70" rows="3"><%= customer.getHotelNote() %></textarea>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                    <td height="8" valign="middle" width="15%">&nbsp;</td>
                                    <td height="8" colspan="2" width="84%" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                    <td height="8" valign="middle" colspan="3"> 
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
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/back2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/back.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
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
                                      <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" class="command" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="1%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="84%">&nbsp;</td>
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
						cmdChange();
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
<!-- #EndTemplate --></html>
