 
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

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdCustomer cmdCustomer = new CmdCustomer(request);
JSPLine ctrLine = new JSPLine();
Vector listCustomer = new Vector(1,1);

Company company = new Company();
try{
	company = DbCompany.getCompany();
}catch(Exception ex){
}


/*switch statement */
iErrCode = cmdCustomer.action(iJSPCommand , oidCustomer);//, company.getOID());
/* end switch*/
JspCustomer jspCustomer = cmdCustomer.getForm();

/*count list All Customer*/
int vectSize = DbCustomer.getCount(whereClause);

Customer customer = cmdCustomer.getCustomer();
msgString =  cmdCustomer.getMessage();


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
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />

<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--



<%if(!arCustomer){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if((iJSPCommand==JSPCommand.SAVE || iJSPCommand==JSPCommand.DELETE) && iErrCode==0 ){%>
	window.location="customer.jsp?command=<%=JSPCommand.BACK%>&hidden_customer_id=<%=oidCustomer%>&menu_idx=<%=menuIdx%>";
	//cmdBack();
<%}%>

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
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
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
//-->
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->					 
					  <%
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Customer Editor</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcustomer" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                          <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
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
                                    <td height="21" valign="middle" width="11%">&nbsp;</td>
                                    <td height="21" colspan="2" width="88%" class="comment" valign="top">*)= 
                                      required</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">Code</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CODE] %>"  value="<%= customer.getCode() %>" class="formElemen" size="15">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">Salutation</td>
                                    <td height="21" colspan="2" width="88%"> 
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
                                    <td height="21" width="11%">Name</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_NAME] %>"  value="<%= customer.getName() %>" class="formElemen" size="35">
                                      * 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">Address</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_ADDRESS] %>"  value="<%= customer.getAddress() %>" class="formElemen" size="40">
                                      * 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">City</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_CITY] %>"  value="<%= customer.getCity() %>" class="formElemen" size="30">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">State</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_STATE] %>"  value="<%= customer.getState() %>" class="formElemen" size="30">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">Country</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <% 
						Vector vctCtr = DbCountry.list(0,0, "", "name");
					
						Vector countryid_value = new Vector(1,1);
						Vector countryid_key = new Vector(1,1);
					 	String sel_countryid = ""+customer.getCountryId();
						
						if(vctCtr!=null && vctCtr.size()>0){
							for(int i=0; i<vctCtr.size(); i++){
								Country ctr = (Country)vctCtr.get(i);
					   			countryid_key.add(""+ctr.getOID());
					   			countryid_value.add(""+ctr.getName());
					   		}
						}	
					   %>
                                      <%= JSPCombo.draw(jspCustomer.fieldNames[JspCustomer.JSP_COUNTRY_ID],null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %> * 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">Nationality</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <% Vector nationalityid_value = new Vector(1,1);
						Vector nationalityid_key = new Vector(1,1);
					 	String sel_nationalityid = ""+customer.getNationalityId();
						
						if(vctCtr!=null && vctCtr.size()>0){
							for(int i=0; i<vctCtr.size(); i++){
								Country ctr = (Country)vctCtr.get(i);
					   			nationalityid_key.add(""+ctr.getOID());
					   			nationalityid_value.add(""+ctr.getNationality());
					   		}
						}
						
					   %>
                                      <%= JSPCombo.draw(jspCustomer.fieldNames[JspCustomer.JSP_NATIONALITY_ID],null, sel_nationalityid, nationalityid_key, nationalityid_value, "", "formElemen") %> * 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">ID Personal</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <% Vector idtype_value = new Vector(1,1);
						Vector idtype_key = new Vector(1,1);
					 	String sel_idtype = ""+customer.getIdType();
						for(int i=0; i<I_Project.idTypeArray.length; i++){
						   idtype_key.add(I_Project.idTypeArray[i]);
						   idtype_value.add(I_Project.idTypeArray[i]);
					    }
					   %>
                                      <%= JSPCombo.draw(jspCustomer.fieldNames[JspCustomer.JSP_ID_TYPE],null, sel_idtype, idtype_key, idtype_value, "", "formElemen") %> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_ID_NUMBER] %>"  value="<%= customer.getIdNumber() %>" class="formElemen">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="1%">&nbsp;</td>
                                    <td height="21" width="11%">Occupation</td>
                                    <td height="21" colspan="2" width="88%"> 
                                      <input type="text" name="<%=jspCustomer.fieldNames[JspCustomer.JSP_OCCUPATION] %>"  value="<%= customer.getOccupation() %>" class="formElemen" size="30">
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
									</td></tr-->  
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                    <td height="8" width="11%"> Note</td>
                                    <td height="8" colspan="2" width="88%"> 
                                      <textarea name="<%=jspCustomer.fieldNames[JspCustomer.JSP_HOTEL_NOTE] %>" class="formElemen" cols="70" rows="3"><%= customer.getHotelNote() %></textarea>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                    <td height="8" valign="middle" width="11%">&nbsp;</td>
                                    <td height="8" colspan="2" width="88%" valign="top">&nbsp;</td>
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
                                      <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" class="command" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="1%">&nbsp;</td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="88%">&nbsp;</td>
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
                        </form>
                        <!-- #EndEditable -->
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
