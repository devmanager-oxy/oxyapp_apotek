<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%//@ page import = "com.project.fms.journal.*" %>    
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.clinic.master.*" %>
<%@ page import = "com.project.clinic.transaction.*" %>
<%@ page import = "com.project.clinic.*" %>
<%@ page import = "com.project.system.*" %>
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

	public String drawList(Vector objectClass ,  long doctorId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr"); 
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Title","7%");
		ctrlist.addHeader("Name","7%");
		ctrlist.addHeader("Specialty Id","7%");
		ctrlist.addHeader("Ssn","7%");
		ctrlist.addHeader("Degree","7%");
		ctrlist.addHeader("Email","7%");
		ctrlist.addHeader("Address","7%");
		ctrlist.addHeader("State Id","7%");
		ctrlist.addHeader("Country Id","7%");
		ctrlist.addHeader("Zip","7%");
		ctrlist.addHeader("Fax","7%");
		ctrlist.addHeader("Phone","7%");
		ctrlist.addHeader("Mobile","7%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Doctor doctor = (Doctor)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(doctorId == doctor.getOID())
				 index = i;

			rowx.add(String.valueOf(doctor.getTitle()));

			rowx.add(doctor.getName());

			rowx.add(String.valueOf(doctor.getSpecialtyId()));

			rowx.add(doctor.getSsn());

			rowx.add(doctor.getDegree());

			rowx.add(doctor.getEmail());

			rowx.add(doctor.getAddress());

			rowx.add(String.valueOf(doctor.getStateId()));

			rowx.add(String.valueOf(doctor.getCountryId()));

			rowx.add(doctor.getZip());

			rowx.add(doctor.getFax());

			rowx.add(doctor.getPhone());

			rowx.add(doctor.getMobile());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(doctor.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidDoctor = JSPRequestValue.requestLong(request, "hidden_doctor_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdDoctor ctrlDoctor = new CmdDoctor(request);
JSPLine ctrLine = new JSPLine();
Vector listDoctor = new Vector(1,1);

/*switch statement */
iErrCode = ctrlDoctor.action(iJSPCommand , oidDoctor);
/* end switch*/
JspDoctor jspDoctor = ctrlDoctor.getForm();

/*count list All Doctor*/
int vectSize = DbDoctor.getCount(whereClause);

Doctor doctor = ctrlDoctor.getDoctor();
msgString =  ctrlDoctor.getMessage();

/*switch list Doctor*/
//if((iJSPCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
///	start = DbDoctor.generateFindStart(doctor.getOID(),recordToGet, whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlDoctor.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listDoctor = DbDoctor.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listDoctor.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listDoctor = DbDoctor.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=salesSt%></title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
                        <script language="JavaScript">


function cmdAdd(){
	document.frmdoctor.hidden_doctor_id.value="0";
	document.frmdoctor.command.value="<%=JSPCommand.ADD%>";
	document.frmdoctor.prev_command.value="<%=prevJSPCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdAsk(oidDoctor){
	document.frmdoctor.hidden_doctor_id.value=oidDoctor;
	document.frmdoctor.command.value="<%=JSPCommand.ASK%>";
	document.frmdoctor.prev_command.value="<%=prevJSPCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdConfirmDelete(oidDoctor){
	document.frmdoctor.hidden_doctor_id.value=oidDoctor;
	document.frmdoctor.command.value="<%=JSPCommand.DELETE%>";
	document.frmdoctor.prev_command.value="<%=prevJSPCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}
function cmdSave(){
	document.frmdoctor.command.value="<%=JSPCommand.SAVE%>";
	document.frmdoctor.prev_command.value="<%=prevJSPCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
	}

function cmdEdit(oidDoctor){
	document.frmdoctor.hidden_doctor_id.value=oidDoctor;
	document.frmdoctor.command.value="<%=JSPCommand.EDIT%>";
	document.frmdoctor.prev_command.value="<%=prevJSPCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
	}

function cmdCancel(oidDoctor){
	document.frmdoctor.hidden_doctor_id.value=oidDoctor;
	document.frmdoctor.command.value="<%=JSPCommand.EDIT%>";
	document.frmdoctor.prev_command.value="<%=prevJSPCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdBack(){
	document.frmdoctor.command.value="<%=JSPCommand.BACK%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
	}

function cmdListFirst(){
	document.frmdoctor.command.value="<%=JSPCommand.FIRST%>";
	document.frmdoctor.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdListPrev(){
	document.frmdoctor.command.value="<%=JSPCommand.PREV%>";
	document.frmdoctor.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
	}

function cmdListNext(){
	document.frmdoctor.command.value="<%=JSPCommand.NEXT%>";
	document.frmdoctor.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdListLast(){
	document.frmdoctor.command.value="<%=JSPCommand.LAST%>";
	document.frmdoctor.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif')">
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
                        <form name="frmdoctor" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_doctor_id" value="<%=oidDoctor%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                              <tr valign="bottom"> 
                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                  </font><font class="tit1">&raquo; 
                                                  </font> <span class="lvl2">Daftar 
                                                  Dokter &amp; Staff</span></b></td>
                                                <td width="40%" height="23"> 
                                                  <%@ include file = "../main/userpreview.jsp" %>
                                                </td>
                                              </tr>
                                              <tr > 
                                                <td colspan="2" height="3" background="<%=approot%>/imagessl/line1.gif" ></td>
                                              </tr>
                                            </table>
                                          </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                  </tr>
                                  <%
							try{
								if (listDoctor.size()>0){
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <%= drawList(listDoctor,oidDoctor)%> </td>
                                  </tr>
                                  <%  } 
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
                                      <% ctrLine.setLocationImg(approot+"/imagessl/ctr_line");
							   	ctrLine.initDefault();
								 %>
                                      <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <%
						if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0 && iJSPCommand!=JSPCommand.SAVE)
						{
					%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../imagessl/new2.gif',1)"><img src="../imagessl/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
                                        <%}%>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3"> 
                                <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspDoctor.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="21" valign="middle" width="11%">&nbsp;</td>
                                          <td height="21" colspan="2" width="89%" class="comment" valign="top">*)= 
                                            required</td>
                                  </tr>
                                        <tr align="left"> 
                                          <td height="21" width="11%">Title</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% 
									  
									  try{
									  
									  Vector title_value = new Vector(1,1);
						Vector title_key = new Vector(1,1);
					 	String sel_title = ""+doctor.getTitle();
					   title_key.add("Mr.");
					   title_value.add("Mr.");
					   title_key.add("Mrs.");
					   title_value.add("Mrs.");
					   title_key.add("Miss");
					   title_value.add("Miss");
					   %>
                                      <%= JSPCombo.draw(jspDoctor.colNames[JspDoctor.JSP_FIELD_TITLE],null, sel_title, title_key, title_value, "", "formElemen") %> 
									  <%}									  
									  catch(Exception e){
									  	
									  }%>
                                        <tr align="left"> 
                                          <td height="21" width="11%">Nama</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_NAME] %>"  value="<%= doctor.getName() %>" class="formElemen" size="35">
                                            * <%= jspDoctor.getErrorMsg(JspDoctor.JSP_FIELD_NAME) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Spesialis</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% Vector specialtyid_value = new Vector(1,1);
						Vector specialtyid_key = new Vector(1,1);
					 	String sel_specialtyid = ""+doctor.getSpecialtyId();
						Vector sps = DbSpecialty.list(0,0,"", "");
						if(sps!=null && sps.size()>0){
							for(int i=0; i<sps.size(); i++){
								Specialty sp = (Specialty)sps.get(i);
						   		specialtyid_key.add(""+sp.getOID());
						   		specialtyid_value.add(sp.getName());
						    }
						}
					   %>
                                      <%= JSPCombo.draw(jspDoctor.colNames[JspDoctor.JSP_FIELD_SPECIALTY_ID],null, sel_specialtyid, specialtyid_key, specialtyid_value, "", "formElemen") %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">S S N</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_SSN] %>"  value="<%= doctor.getSsn() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%">Gelar</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_DEGREE] %>"  value="<%= doctor.getDegree() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%">Email</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_EMAIL] %>"  value="<%= doctor.getEmail() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%" valign="top">Alamat</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <textarea name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_ADDRESS] %>" class="formElemen" cols="35" rows="3"><%= doctor.getAddress() %></textarea>
                                      * <%= jspDoctor.getErrorMsg(JspDoctor.JSP_FIELD_ADDRESS) %> 
                                        <!--tr align="left"> 
                                          <td height="21" width="11%">Propinsi</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% Vector stateid_value = new Vector(1,1);
						Vector stateid_key = new Vector(1,1);
					 	String sel_stateid = ""+doctor.getStateId();
					   stateid_key.add("---select---");
					   stateid_value.add("");
					   %>
                                      <%= JSPCombo.draw(jspDoctor.colNames[JspDoctor.JSP_FIELD_STATE_ID],null, sel_stateid, stateid_key, stateid_value, "", "formElemen") %> * <%= jspDoctor.getErrorMsg(JspDoctor.JSP_FIELD_STATE_ID) %> 
                                        <tr align="left"> 
                                          <td height="21" width="11%">Negara</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <% Vector countryid_value = new Vector(1,1);
						Vector countryid_key = new Vector(1,1);
					 	String sel_countryid = ""+doctor.getCountryId();
					   countryid_key.add("---select---");
					   countryid_value.add("");
					   %>
                                      <%= JSPCombo.draw(jspDoctor.colNames[JspDoctor.JSP_FIELD_COUNTRY_ID],null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %> * <%= jspDoctor.getErrorMsg(JspDoctor.JSP_FIELD_COUNTRY_ID) %> 
									  </tr-->
                                        <tr align="left"> 
                                          <td height="21" width="11%">Kode Post</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_ZIP] %>"  value="<%= doctor.getZip() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%">Fax</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_FAX] %>"  value="<%= doctor.getFax() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%">Telephone</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_PHONE] %>"  value="<%= doctor.getPhone() %>" class="formElemen" size="35">
                                        <tr align="left"> 
                                          <td height="21" width="11%">Mobile/HP</td>
                                          <td height="21" colspan="2" width="89%"> 
                                            <input type="text" name="<%=jspDoctor.colNames[JspDoctor.JSP_FIELD_MOBILE] %>"  value="<%= doctor.getMobile() %>" class="formElemen" size="35">
                                      * <%= jspDoctor.getErrorMsg(JspDoctor.JSP_FIELD_MOBILE) %> 
                                        <tr align="left"> 
                                          <td height="8" valign="middle" width="11%">&nbsp;</td>
                                          <td height="8" colspan="2" width="89%" valign="top">&nbsp; 
                                          </td>
                                  </tr>
                                        <tr align="left" > 
                                          <td colspan="3" class="command" valign="top"> 
                                            <%
									ctrLine.setLocationImg(approot+"/imagessl/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("40%");
									String scomDel = "javascript:cmdAsk('"+oidDoctor+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidDoctor+"')";
									String scancel = "javascript:cmdEdit('"+oidDoctor+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");

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
                                      <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                  </tr>
                                  <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="89%">&nbsp;</td>
                                  </tr>
                                        <tr align="left" > 
                                          <td colspan="3" valign="top"> 
                                            <div align="left"></div>
                                    </td>
                                  </tr>
                                </table>
                                <%}%>
                              </td>
                            </tr>
                          </table></td>
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
