 
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_ADD));
boolean privView=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_VIEW));
boolean privUpdate=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_DELETE));
%>
<!-- JSP Block -->
<%!
public String ctrCheckBox(long userID)
{ 
	JSPCheckBox chkBx=new JSPCheckBox();		
	chkBx.setCellSpace("0");		
	chkBx.setCellStyle("");
	chkBx.setWidth(5);
	chkBx.setTableAlign("left");
	chkBx.setCellWidth("10%");
	
        try{
            Vector checkValues = new Vector(1,1);
            Vector checkCaptions = new Vector(1,1);
			String order = DbGroup.colNames[DbGroup.COL_GROUP_NAME];
            Vector allGroups = DbGroup.list(0, 0, "", order);

            if(allGroups!=null){
                int maxV = allGroups.size(); 
                for(int i=0; i< maxV; i++){
                    Group appGroup = (Group) allGroups.get(i);
                    checkValues.add(Long.toString(appGroup.getOID()));
                    checkCaptions.add(appGroup.getGroupName());
                }
            }

            Vector checkeds = new Vector(1,1);
            DbUserGroup dbUg = new DbUserGroup(0);
            Vector groups = QrUser.getUserGroup(userID);

            if(groups!=null){
                int maxV = groups.size(); 
                for(int i=0; i< maxV; i++){
                    Group appGroup = (Group) groups.get(i);
                    checkeds.add(Long.toString(appGroup.getOID()));
                }
            }
 
            chkBx.setTableWidth("100%");

            String fldName = JspUser.colNames[JspUser.JSP_USER_GROUP];
            return chkBx.draw(fldName,checkValues,checkCaptions,checkeds);

        } catch (Exception exc){
            return "No group assigned";
        }
        
}

%>
<%

/* VARIABLE DECLARATION */ 

JSPLine jspLine = new JSPLine();
 
/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);

long appUserOID = JSPRequestValue.requestLong(request,"user_oid");
//long marketing_id =JSPRequestValue.requestLong(request,JspUser.colNames[JspUser.JSP_MARKETING_ID]);
int start = JSPRequestValue.requestInt(request, "start"); 
User appUser = new User();
CmdUser cmdUser = new CmdUser(request);
JspUser jspUser = cmdUser.getForm();

int excCode = JSPMessage.NONE;
String msgString =  "";
if(iJSPCommand == JSPCommand.SAVE){
	jspUser.requestEntityObject(appUser);
	String pwd = JSPRequestValue.requestString(request,jspUser.colNames[jspUser.JSP_PASSWORD]);
	String repwd  = JSPRequestValue.requestString(request,jspUser.colNames[jspUser.JSP_CJSP_PASSWORD]);
	if(!pwd.equals(repwd)){
		excCode = JSPMessage.ERR_PWDSYNC;
		msgString = JSPMessage.getMessage(excCode);
	}
}

//out.println(jspUser.getErrors());

if(excCode == JSPMessage.NONE){
	excCode = cmdUser.action(iJSPCommand,appUserOID);
	msgString =  cmdUser.getMessage();
	appUser = cmdUser.getUser();
	
	if(appUserOID==0){
		appUserOID = appUser.getOID();
	}
	
	if(jspUser.getErrors().size()<1){
		msgString = "";
	}
}

//out.println(jspUser.getErrors());
if(iJSPCommand==JSPCommand.SAVE){	
	DbUserGroup.deleteByUser(appUser.getOID());
	long oid = JSPRequestValue.requestLong(request, "group_id");
	
	//out.println(oid);
	
	UserGroup ugroup = new UserGroup();
	try{
		ugroup.setUserID(appUser.getOID());
		ugroup.setGroupID(oid);
		DbUserGroup.insert(ugroup);
	}
	catch(Exception e){
	}
	
}

%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!adminPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if(!privView &&  !privAdd && !privUpdate && !privDelete){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if(iJSPCommand==JSPCommand.SAVE || iJSPCommand==JSPCommand.ASK || iJSPCommand==JSPCommand.DELETE){%>
	window.location="#go";
<%}%>

function cmdCancel(){
	//document.jspUser.user_oid.value=oid;
	document.jspUser.command.value="<%=JSPCommand.EDIT%>";
	document.jspUser.action="useredit.jsp";
	document.jspUser.submit();
}

<% if(privAdd || privUpdate) {%>
function cmdSave(){
	document.jspUser.command.value="<%=JSPCommand.SAVE%>";
	document.jspUser.action="useredit.jsp";
	document.jspUser.submit();
}
<%}%>

<% if(privDelete) {%>
function cmdDelete(oid){
	document.jspUser.user_oid.value=oid;
	document.jspUser.command.value="<%=JSPCommand.ASK%>";
	document.jspUser.action="useredit.jsp";
	document.jspUser.submit();
}

function cmdConfirmDelete(oid){
	document.jspUser.user_oid.value=oid;
	document.jspUser.command.value="<%=JSPCommand.DELETE%>";
	document.jspUser.action="useredit.jsp";
	document.jspUser.submit();
}
<%}%>


function cmdBack(oid){
	document.jspUser.user_oid.value=oid;
	document.jspUser.command.value="<%=JSPCommand.LIST%>";
	document.jspUser.action="userlist.jsp";
	document.jspUser.submit();
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" -->
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="jspUser" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="user_oid" value="<%=appUserOID%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" height="17">
                                  <tr valign="middle"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Administrator</font><font class="tit1"> 
                                      &raquo; </font><span class="lvl2">User Editor</span></b></td>
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
                            <tr> 
                              <td class="container"> 
                                <table width="100%" cellpadding="1" cellspacing="1">
                                  <%if((excCode>-1) || ((iJSPCommand==JSPCommand.SAVE)&&(jspUser.errorSize()>0))
                    ||(iJSPCommand==JSPCommand.ADD)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                  <tr> 
                                    <td colspan="3">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="3" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%" height="26">Login ID</td>
                                    <td width="33%" height="26"> 
                                      <input type="text" name="<%=jspUser.colNames[jspUser.JSP_LOGIN_ID] %>" value="<%=appUser.getLoginId()%>" class="formElemen">
                                      * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_LOGIN_ID) %></td>
                                    <td rowspan="7" height="26" valign="top" width="52%"> 
                                      <%if(appUser.getOID()!=0){%>
                                      <a href="user_image.jsp?user_oid=<%=appUserOID%>"><img src="../images/<%=appUser.getEmployeeNum()%>.jpg" width="115" border="0"></a> 
                                      <%}%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Password</td>
                                    <td width="33%"> 
                                      <input type="password" name="<%=jspUser.colNames[jspUser.JSP_PASSWORD] %>" value="<%=appUser.getPassword()%>" class="formElemen">
                                      * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_PASSWORD) %></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Confirm Password</td>
                                    <td width="33%"> 
                                      <input type="password" name="<%=jspUser.colNames[jspUser.JSP_CJSP_PASSWORD] %>" value="<%=appUser.getPassword()%>" class="formElemen">
                                      * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_CJSP_PASSWORD) %></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Full Name</td>
                                    <td width="33%"> 
                                      <input type="text" name="<%=jspUser.colNames[jspUser.JSP_FULL_NAME] %>" value="<%=appUser.getFullName()%>" class="formElemen">
                                      * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_FULL_NAME) %></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Employee Number</td>
                                    <td width="33%"> 
                                      <input type="text" name="<%=jspUser.colNames[jspUser.JSP_EMPLOYEE_NUM] %>" value="<%=(appUser.getEmployeeNum()==null) ? "" : appUser.getEmployeeNum()%>" class="formElemen">
                                      * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_EMPLOYEE_NUM) %></td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Employe </td>
                                    <td width="33%"> 
                                        <% 
                                            
                                            User usr = new User();
                                            if(appUserOID !=0){
                                                try{
                                                    usr = DbUser.fetch(appUserOID);
                                                }catch(Exception e){

                                                }
                                            }											  Vector vEmploye = DbEmployee.list(0,0, "", "");
																  %>
                                                                    <select name="<%=jspUser.colNames[jspUser.JSP_EMPLOYEE_ID]%>" >
                                                                     
                                                                      <%if(vEmploye!=null && vEmploye.size()>0){
																	  for(int j=0; j<vEmploye.size(); j++){
																	  	Employee em = (Employee)vEmploye.get(j);
                                                                                                                                                
                                                                                                                                                
																	  %>
                                                                      <option value="<%=em.getOID()%>" <%if(em.getOID()==usr.getEmployeeId()){%>selected<%}%>><%=em.getName()%></option>
                                                                      <%}
																	  }%>
                                                                    </select>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Level</td>
                                    <td width="33%"> 
                                      <select name="<%=jspUser.colNames[jspUser.JSP_USER_LEVEL] %>" class="formElemen">
                                        <%for(int i=0; i<DbUser.levelStr.length; i++){%>
                                        <option <%if(i==appUser.getUserLevel()){%>selected<%}%> value="<%=i%>"><%=DbUser.levelStr[i]%></option>
                                        <%}%>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Email</td>
                                    <td width="33%"> 
                                      <input type="text" name="<%=jspUser.colNames[jspUser.JSP_EMAIL] %>" value="<%=(appUser.getEmail()==null) ? "" : appUser.getEmail()%>" size="48" class="formElemen">
                                      &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_EMAIL) %></td>
                                  </tr>
                                  <!--tr> 
                    <td width="13%" valign="top">Employee</td>
                    <td width="87%"> 
                      <%
                                       //   Vector listEmployee = new Vector();//DbEmployee.list(0, 0, "RESIGNED = 0", "EMPLOYEE_NUM");
                                        //  Vector empKey = new Vector(1,1);
                                        //  Vector empValue = new Vector(1,1);
				//						  if(listEmployee!=null && listEmployee.size()>0){
                                 //         for(int i =0;i <listEmployee.size();i++){
                                                /*Employee employee = (Employee)listEmployee.get(i);
												Department dept = new Department();
												try{
                                                	dept = DbDepartment.fetchExc(employee.getDepartmentId());
												}
												catch(Exception e){
													System.out.println("Exception e : "+e.toString());
												}
                                                empKey.add(employee.getEmployeeNum() + " - " + employee.getFullName() + " - (" + dept.getDepartment() + ")");
                                                empValue.add(""+employee.getOID());*/
                                  //        }
				//						  }
                                          %>
                     //
                  </tr-->
                                  <tr> 
                                    <td width="15%" valign="top">Description</td>
                                    <td width="33%"> 
                                      <textarea name="<%=jspUser.colNames[jspUser.JSP_DESCRIPTION] %>" cols="48" rows="4" class="formElemen"><%=(appUser.getDescription()==null) ? "" : appUser.getDescription()%></textarea>
                                      &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_DESCRIPTION) %></td>
                                    <td width="52%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">User Status</td>
                                    <td width="33%"> 
                                      <%
                        JSPCombo cmbox = new JSPCombo();
                        Vector sts = User.getStatusTxts();
                        Vector stsVals = User.getStatusVals();
                    %>
                                      <%=cmbox.draw(jspUser.colNames[jspUser.JSP_USER_STATUS] ,"formElemen",
                        null, Integer.toString(appUser.getUserStatus()), stsVals, sts)%> &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_USER_STATUS) %></td>
                                    <td width="52%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Last Update Date</td>
                                    <td width="33%"><%=(appUser.getUpdateDate()==null) ? "-": JSPFormater.formatDate(appUser.getUpdateDate(), "dd MMMM yyyy")%> 
                                      <input type="hidden" name="<%=jspUser.colNames[jspUser.JSP_UPDATE_DATE] %>2" value="<%=appUser.getUpdateDate()%>">
                                    </td>
                                    <td width="52%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Registered Date</td>
                                    <td width="33%"><%=(appUser.getRegDate()==null) ? "-" : JSPFormater.formatDate(appUser.getRegDate(), "dd MMMM yyyy")%></td>
                                    <td width="52%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Last Login Date</td>
                                    <td width="33%"> 
                                      <% if(appUser.getLastLoginDate()==null)
                                                out.println("-");
                                            else 
                                                out.println(appUser.getLastLoginDate());%>
                                    </td>
                                    <td width="52%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="15%">Last Login IP</td>
                                    <td width="33%"> 
                                      <% if(appUser.getLastLoginIp()==null)
                                                out.println("-");
                                            else 
                                                out.println(appUser.getLastLoginIp());%>
                                    </td>
                                    <td width="52%">&nbsp;</td>
                                  </tr>
                                  
                                  
                                  
                                  
                                  <tr> 
                                    <td width="15%" height="14" nowrap>Group Privilege 
                                    </td>
                                    <td width="33%" height="14"> 
                                      <%
								Vector grp = DbGroup.list(0,0, "", "");
								
								Vector vx = DbUserGroup.list(0,0, DbUserGroup.colNames[DbUserGroup.COL_USER_ID]+"="+appUser.getOID(), "");
								long oidx = 0;
								if(vx!=null && vx.size()>0){
									UserGroup ug = (UserGroup)vx.get(0);
									oidx = ug.getGroupID();
								}
								
								//out.println("appUser.getOID() : "+appUser.getOID());
								//out.println("vx : "+vx);
								
								%>
                                      <select name="group_id">
                                        <option value="0">- select - </option>
                                        <%if(grp!=null && grp.size()>0){
								 		for(int i=0; i<grp.size(); i++){
											Group g = (Group)grp.get(i);
											//out.println(g.getOID());
								 %>
                                        <option value="<%=g.getOID()%>" <%if(g.getOID()==oidx){%>selected<%}%>><%=g.getGroupName()%></option>
                                        <%}}%>
                                      </select>
                                    </td>
                                    <td width="52%" height="14">&nbsp;</td>
                                    <!--tr> 
                    <td width="13%" valign="top" height="14" nowrap>Privilege 
                      Assigned</td>
                    <td width="87%" height="14"> <%=ctrCheckBox(appUserOID)%> </td>
                  <tr-->
                                  <tr> 
                                    <td width="15%" valign="top" height="14" nowrap><a name="go"></a></td>
                                    <td width="33%" height="14">&nbsp;</td>
                                    <td width="52%" height="14">&nbsp;</td>
                                  <tr> 
                                    <td colspan="3" class="command">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="3"> 
                                      <%
							jspLine.setLocationImg(approot+"/images/ctr_line");
							jspLine.initDefault();
							jspLine.setTableWidth("60%");
							String scomDel = "javascript:cmdDelete('"+appUserOID+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+appUserOID+"')";
							String scancel = "javascript:cmdCancel('"+appUserOID+"')";
							jspLine.setBackCaption("Back to List");
							jspLine.setJSPCommandStyle("buttonlink");
							//jspLine.setSaveCaption(" ");
							jspLine.setDeleteCaption("Delete Data");
							jspLine.setAddCaption("");
							
							jspLine.setOnMouseOut("MM_swapImgRestore()");
							jspLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
							jspLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
							
							//jspLine.setOnMouseOut("MM_swapImgRestore()");
							jspLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
							jspLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
							
							jspLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
							jspLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
							
							jspLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
							jspLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
							
							
							jspLine.setWidthAllJSPCommand("90");
							jspLine.setErrorStyle("warning");
							jspLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
							jspLine.setQuestionStyle("warning");
							jspLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
							jspLine.setInfoStyle("success");
							jspLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

							if (privDelete){
								jspLine.setConfirmDelJSPCommand(sconDelCom);
								jspLine.setDeleteJSPCommand(scomDel);
								jspLine.setEditJSPCommand(scancel);
							}else{ 
								jspLine.setConfirmDelCaption("");
								jspLine.setDeleteCaption("");
								jspLine.setEditCaption("");
							}

							if(privAdd == false  && privUpdate == false){
								jspLine.setSaveCaption("");
							}
                                                        
							if (privAdd == false){
								jspLine.setAddCaption("");
							}
							%>
                                      <%= jspLine.drawImageOnly(iJSPCommand, excCode, msgString)%></td>
                                  </tr>
                                  <%} else {%>
                                  <tr> 
                                    <td width="15%">&nbsp; Processing OK .. back 
                                      to list. </td>
                                    <td width="33%">&nbsp; <a href="javascript:cmdBack()">click 
                                      here</a> 
                                      <script language="JavaScript">
						cmdBack();
					</script>
                                    </td>
                                    <td width="52%">&nbsp;</td>
                                  </tr>
                                  <% }
                    %>
                                  <tr> 
                                    <td width="15%">&nbsp;</td>
                                    <td width="33%">&nbsp;</td>
                                    <td width="52%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable -->
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
