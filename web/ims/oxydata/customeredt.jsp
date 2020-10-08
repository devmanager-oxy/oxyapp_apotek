 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.sql.*" %>

<!-- Jsp Block -->
<%
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

String approot = "";
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
int isSearch = JSPRequestValue.requestInt(request, "hidden_search");

String strBarcode = JSPRequestValue.requestString(request, "x_code");
String strName = JSPRequestValue.requestString(request, "x_name");
String strAlamat = JSPRequestValue.requestString(request, "x_address");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdCustomer cmdCustomer = new CmdCustomer(request);
JSPLine ctrLine = new JSPLine();
Vector listCustomer = new Vector(1,1);
JspCustomer jspCustomer = new JspCustomer();
Customer customer = new Customer();
customer.setType(0);
msgString = "";
if(iJSPCommand==JSPCommand.SAVE){
	if(strBarcode.length() != 0 && strName.length()!=0 && strAlamat.length()!=0) {
		iErrCode = cmdCustomer.action(iJSPCommand , oidCustomer);
		jspCustomer = cmdCustomer.getForm();
		customer = cmdCustomer.getCustomer();
		msgString =  cmdCustomer.getMessage();

		String fileName = "";
		String path = "//home//bestvilla//tomcat//webapps//oxysystem_retail01//oxydata//customer.txt";
		String sql = "select * from logs where table_name='customer'";
		fileName = SQLGeneral.createExportFile(path,sql);
		%>
			<script language="JavaScript">
				window.location="preview_data_member.jsp";
			</script>
		<%
	}else{
		msgString =  "Barcode dan nama harus diisi.";
	}
}
%>
<html >
<!-- #BeginTemplate "/Templates/indexpg.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>OXY Pos</title>
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdChange(){
	/*var x = document.frmcustomer.<%=jspCustomer.colNames[JspCustomer.JSP_TYPE] %>.value;
	if(parseInt(x)==0){
		document.all.comp1.style.display="none";
		document.all.comp2.style.display="none";
		document.all.person1.style.display="";
		//document.all.name_title.style.display="";
		document.all.name_title1.style.display="";
		document.all.name_title2.style.display="";
		document.frmcustomer.<%=jspCustomer.colNames[JspCustomer.JSP_NAME] %>.size=20;
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
		document.frmcustomer.<%=jspCustomer.colNames[JspCustomer.JSP_NAME] %>.size=42;
	}*/
	
	document.frmcustomer.action="customeredtcom.jsp";
	document.frmcustomer.submit();
}

function cmdAdd(){
	document.frmcustomer.hidden_customer_id.value="0";
	document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
}

function cmdAsk(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
}

function cmdConfirmDelete(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
}
function cmdSave(){
	document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
	}

function cmdEdit(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
	}

function cmdCancel(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
}

function cmdBack(){
	document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
	}

function cmdListFirst(){
	document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
}

function cmdListPrev(){
	document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
	}

function cmdListNext(){
	document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.action="customeredt.jsp";
	document.frmcustomer.submit();
}

function cmdListLast(){
	document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.action="customeredt.jsp";
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
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-style: italic;
}
.style4 {color: #000099}
-->
</style>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <%@ include file="../calendar/calendarframe.jsp"%></td>
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
                                                <form name="frmcustomer" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                  <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                                                  <input type="hidden" name="hidden_search" value="<%=isSearch%>">
												  <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_TYPE] %>" value="0">
												  <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_SALUTATION] %>" value="<%=I_Project.SALUTATION_MR%>">
												  
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr align="left" valign="top"> 
                                                      <td height="8" valign="middle" colspan="3" class="container"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0"><tr align="left">
                                                            <td height="21" colspan="2"><span class="style1"><%=msgString%></span></td>
                                                            <td height="21">                                                          
                                                            <td height="21">                                                          
                                                          <tr align="left">
                                                            <td height="21" nowrap>Barcode</td>
                                                            <td height="21" nowrap><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_CODE] %>"  value="<%= customer.getCode() %>" class="formElemen" size="30"> 
                                                              *                                                           
                                                            <td height="21" nowrap>Negara                                                          
                                                            <td height="21"><% 
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
                                                              <%= JSPCombo.draw(jspCustomer.colNames[JspCustomer.JSP_COUNTRY_ID],null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %>
                                                          <tr align="left">
                                                            <td height="21" nowrap>Nama </td>
                                                            <td height="21" nowrap><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_NAME] %>"  value="<%= customer.getName() %>" class="formElemen" size="30"> 
                                                              * 
                                                            <td height="21" nowrap>Kewarganegaraan<td height="21"><% Vector nationalityid_value = new Vector(1,1);
						Vector nationalityid_key = new Vector(1,1);
					 	String sel_nationalityid = ""+customer.getNationalityId();
						
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
                                                              <%= JSPCombo.draw(jspCustomer.colNames[JspCustomer.JSP_NATIONALITY_ID],null, sel_nationalityid, nationalityid_key, nationalityid_value, "", "formElemen") %>
                                                          <tr align="left">
                                                            <td height="21" nowrap>Alamat</td>
                                                            <td height="21" nowrap><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_ADDRESS_1] %>"  value="<%= customer.getAddress1() %>" class="formElemen" size="40"> 
                                                              *                                                           
                                                            <td height="21" nowrap>Propinsi<td height="21"><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_STATE] %>"  value="<%= customer.getState() %>" class="formElemen" size="30">                                                          
                                                          <tr align="left">
                                                            <td height="21" nowrap>ID / NPWP</td>
                                                            <td height="21" nowrap><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_ID_NUMBER] %>"  value="<%= customer.getIdNumber() %>" class="formElemen" size="30">
                                                            <td height="21" nowrap>Kota                                                            
                                                            <td height="21"><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_CITY] %>"  value="<%= customer.getCity() %>" class="formElemen" size="30">                                                          
                                                          <tr align="left">
                                                            <td height="21" nowrap>Telepone</td>
                                                            <td height="21" nowrap><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_PHONE_AREA] %>"  value="<%= (customer.getPhoneArea()==null) ? "" : customer.getPhoneArea() %>" class="formElemen" size="7" maxlength="4">
                                                              <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_PHONE] %>"  value="<%= (customer.getPhone()==null) ? "" : customer.getPhone() %>" class="formElemen" size="20">                                                          
                                                            <td height="21" nowrap>Kode Pos <td height="21"><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_ZIP_CODE] %>"  value="<%= (customer.getZipCode()==null) ? "" : customer.getZipCode() %>" class="formElemen" size="30">
                                                          <tr align="left">
                                                            <td height="21" nowrap>Fax</td>
                                                            <td height="21" nowrap><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_FAX_AREA] %>"  value="<%= (customer.getFaxArea()==null) ? "" : customer.getFaxArea() %>" class="formElemen" size="7">
                                                              <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_FAX] %>"  value="<%= (customer.getFax()==null) ? "" : customer.getFax() %>" class="formElemen" size="20">                                                          
                                                            <td height="21" nowrap>Tipe Bisnis 
                                                            <td height="21"><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_OCCUPATION] %>"  value="<%= customer.getOccupation() %>" class="formElemen" size="30">
                                                          <tr align="left">
                                                            <td height="21" nowrap>No HP </td>
                                                            <td height="21" nowrap><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_HP] %>"  value="<%= (customer.getHp()==null) ? "" : customer.getHp() %>" class="formElemen" size="30">                                                          
                                                            <td height="21" nowrap>Website&nbsp;                                                          
                                                            <td height="21"><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_WEBSITE] %>"  value="<%= customer.getWebsite() %>" class="formElemen" size="30">                                                          
                                                          <tr align="left">
                                                            <td height="21" nowrap>Email</td>
                                                            <td height="21" nowrap><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_EMAIL] %>"  value="<%= (customer.getEmail()==null) ? "" : customer.getEmail() %>" class="formElemen" size="30">                                                          
                                                            <td height="21" nowrap>Keterangan<td width="34%" rowspan="3" valign="top"><textarea name="<%=jspCustomer.colNames[JspCustomer.JSP_HOTEL_NOTE] %>" class="formElemen" cols="30" rows="2"><%= customer.getHotelNote() %></textarea>                                                          
                                                          <tr align="left"> 
                                                            <td height="8" valign="middle" width="14%">&nbsp;</td>
                                                            <td height="8" width="36%" valign="top">&nbsp;</td>
                                                            <td height="8" width="16%" valign="top">&nbsp;</td>
                                                            <td height="8" width="34%" valign="top">&nbsp;</td>
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
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/ims/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/ims/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/ims/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/ims/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setEditImage("<img src=\""+approot+"/ims/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									ctrLine.setWidthAllJSPCommand("90");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/ims/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setQuestionStyle("warning");
									ctrLine.setQuestionImage(approot+"/ims/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setInfoStyle("success");
									ctrLine.setSuccessImage(approot+"/ims/images/success.gif\" width=\"20\" height=\"20");

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
                                                              <%= ctrLine.drawImageOnly(JSPCommand.ADD, iErrCode, msgString)%> </td>
                                                          </tr>
                                                          <tr align="left" > 
                                                            <td colspan="4" class="command" valign="top">&nbsp;                                                            </td>
                                                          </tr>
                                                          <tr align="left" > 
                                                            <td colspan="4" valign="top"> 
                                                              <div align="left"></div>                                                            </td>
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
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
