 
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER); %>
<%//@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_ADD));
boolean privView=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_VIEW));
boolean privUpdate=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_DELETE));
%>
<!-- JSP Block -->
<%!

public String drawListPriv(Vector objectClass)
{
	String temp = "";
	String regdatestr = "";
	
	JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		//ctrlist.setAreaWidth("20%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		
	ctrlist.addHeader("Priv. Name","30%");
	ctrlist.addHeader("Description","50%");
	ctrlist.addHeader("Creation Date ","20%");		

	ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();

	Vector lstLinkData 	= ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
								
	for (int i = 0; i < objectClass.size(); i++) {
		 Priv appPriv = (Priv)objectClass.get(i);

		 Vector rowx = new Vector();
		 
		 rowx.add(String.valueOf(appPriv.getPrivName()));		 
		 rowx.add(String.valueOf(appPriv.getDescr()));
		 try{
			 Date regdate = appPriv.getRegDate();
			 regdatestr = JSPFormater.formatDate(regdate, "dd MMMM yyyy");
		 }catch(Exception e){
			 regdatestr = "";
		 }
		 
		 rowx.add(regdatestr);
		 		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(appPriv.getOID()));
	}						

	return ctrlist.draw();
}

%>
<%

/* VARIABLE DECLARATION */
int recordToGet = 18;
String order = " " + DbPriv.colNames[DbPriv.COL_PRIV_NAME];

Vector listPriv = new Vector(1,1);
JSPLine jspLine = new JSPLine();

/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start"); 
long appPrivOID = JSPRequestValue.requestLong(request,"appriv_oid");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
int prevSaveJSPCommand = JSPRequestValue.requestInt(request, "prev_save_command");

CmdPriv ctrlPriv = new CmdPriv(request);

 
int vectSize = DbPriv.getCount(""); 

int excCode = ctrlPriv.action(iJSPCommand,appPrivOID,start,vectSize,recordToGet);
JspPriv frmPriv = ctrlPriv.getForm();
vectSize = DbPriv.getCount(""); 
String msgString = ctrlPriv.getMessage(); 
Priv appPriv = ctrlPriv.getPriv();

appPrivOID = appPriv.getOID();


if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
	(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST) ){
		//out.println("in start 1");
		start = ctrlPriv.getStart();
		
	}

if((iJSPCommand == JSPCommand.SAVE)&&(frmPriv.errorSize()<1)){
	//out.println("in start 2");
	//out.println(".......appPriv.getOID() : "+appPriv.getOID());
	start =  DbPriv.findLimitStart( appPriv.getOID(), recordToGet, "", order);
	//out.println(".......start real : "+start);
}



order= DbPriv.colNames[DbPriv.COL_PRIV_NAME] ;		
listPriv = DbPriv.list(start,recordToGet, "" , order);

//out.println("start : "+start);
//out.println("<br>"+listPriv);

/* TO HANDLE CONDITION AFTER DELETE LAST, IF START LIMIT IS BIGGER THAN VECT SIZE, GET LIST FIRST */
if(((listPriv==null)||(listPriv.size()<1))){		
	start=0;
	listPriv = DbPriv.list(start,recordToGet, "" , order);
}


%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!privView &&  !privAdd && !privUpdate && !privDelete){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if(iJSPCommand==JSPCommand.SAVE || iJSPCommand==JSPCommand.ASK || iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ADD){%>
	window.location="#go";
<%}%>

function addNew(){
	document.frmPriv.appriv_oid.value="0";
	document.frmPriv.prev_command.value="<%=prevJSPCommand%>";
	document.frmPriv.command.value="<%=JSPCommand.ADD%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}

function cmdEdit(oid){
	document.frmPriv.appriv_oid.value=oid;
	document.frmPriv.prev_command.value="<%=prevJSPCommand%>";
	document.frmPriv.command.value="<%=JSPCommand.EDIT%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}


function cmdSave(){
	document.frmPriv.command.value="<%=JSPCommand.SAVE%>";
	document.frmPriv.prev_command.value="<%=prevJSPCommand%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}

function cmdEditObj(oid){
	document.frmPriv.appriv_oid.value=oid;
	document.frmPriv.prev_command.value="<%=prevJSPCommand%>";
	document.frmPriv.command.value="<%=JSPCommand.LIST%>";
	document.frmPriv.action="privilegeedit.jsp";
	document.frmPriv.submit();
}

function cmdAsk(oid){
	document.frmPriv.appriv_oid.value=oid;
	document.frmPriv.prev_command.value="<%=prevJSPCommand%>";
	document.frmPriv.command.value="<%=JSPCommand.ASK%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}
function cmdDelete(oid){
	document.frmPriv.appriv_oid.value=oid;
	document.frmPriv.prev_command.value="<%=prevJSPCommand%>";
	document.frmPriv.command.value="<%=JSPCommand.DELETE%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}

function cmdCancel(){
	document.frmPriv.prev_command.value="<%=prevJSPCommand%>";
	document.frmPriv.command.value="<%=JSPCommand.EDIT%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}


function first(){
	document.frmPriv.command.value="<%=JSPCommand.FIRST%>";
	document.frmPriv.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}
function prev(){
	document.frmPriv.command.value="<%=JSPCommand.PREV%>";
	document.frmPriv.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}

function next(){
	document.frmPriv.command.value="<%=JSPCommand.NEXT%>";
	document.frmPriv.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}
function last(){
	document.frmPriv.command.value="<%=JSPCommand.LAST%>";
	document.frmPriv.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}

function cmdBack(){
	document.frmPriv.command.value="<%=JSPCommand.BACK%>";
	document.frmPriv.action="privilegelist.jsp";
	document.frmPriv.submit();
}

function backMenu(){
	document.frmPriv.action="<%=approot%>/management/main_systemadmin.jsp";
	document.frmPriv.submit();
}
</script>
                        <%@ include file="../main/hdscript.jsp"%>
                        <script language="JavaScript">
<!--
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
//-->
</script>
            
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','<%=approot%>/images/new2.gif')">
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
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Administrator</span> 
                        &raquo; <span class="level1">User Admin</span> &raquo; 
                        <span class="level2">Privileges<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        
                        <form name="frmPriv" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="appriv_oid" value="<%=appPrivOID%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="prev_save_command" value="<%=prevSaveJSPCommand%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"> <table width="100%" cellspacing="0" cellpadding="0">
                            <tr> 
                                    <td colspan="2" class="bigtitleflash">&nbsp; </td>
                            </tr>
                          </table>
                          <% if ((listPriv!=null)&&(listPriv.size()>0)){ %>
                          <%=drawListPriv(listPriv)%> 
                          <%}%>
                          <table width="100%">
                            <tr> 
                              <td colspan="2"> <span class="command"> 
                                <% 
								   int cmd = 0;					  
								   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand;								   
								   else{					   
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)						  
										cmd=JSPCommand.FIRST;							
									  else{
										if((iJSPCommand==JSPCommand.SAVE)&&(frmPriv.errorSize()<1)){
											cmd = DbPriv.findLimitJSPCommand(start, recordToGet, vectSize);
											
										}						
										else{ 
											if(iJSPCommand==JSPCommand.DELETE){
												cmd=JSPCommand.FIRST; 
											}
											else{
												cmd =prevJSPCommand;						   
											}
												
										}
										
									  }
								   }						   					   
								%>
                                <%=jspLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
                            </tr>
                            <%if( privAdd && (iJSPCommand!=JSPCommand.ADD)&&(iJSPCommand!=JSPCommand.ASK)&&(iJSPCommand!=JSPCommand.EDIT)&&(frmPriv.errorSize()<1)){%>
                            <tr> 
                              <td colspan="2" class="command"> 
                                <table width="45%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <% if(privAdd){%>
                                          <td width="8%"><a href="javascript:addNew()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100','','<%=approot%>/images/new2.gif',1)"><img name="Image100" border="0" src="../images/new.gif" width="71" height="22" alt=""></a></td>
                                          <td nowrap width="28%">&nbsp;</td>
                                          <%}%>
                                          <td width="8%">&nbsp;</td>
                                          <td nowrap width="56%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <%}%>
                            <tr> 
                              <td width="15%">&nbsp;</td>
                              <td width="85%">&nbsp;</td>
                            </tr>
                            <%if((iJSPCommand==JSPCommand.SAVE)||(iJSPCommand==JSPCommand.ADD)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK) || (frmPriv.errorSize()>0)){%>
                            <tr> 
                              <td colspan="2" class="txtheading1"><b>ADD/EDIT 
                                PRIVILEGE<a name="go"></a></b></td>
                            </tr>
                            <tr> 
                              <td width="15%">&nbsp;</td>
                              <td width="85%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="15%">Privilege Name</td>
                              <td width="85%"> 
                                <input type="text" name="<%=frmPriv.colNames[frmPriv.JSP_PRIV_NAME] %>" value="<%=appPriv.getPrivName()%>" class="formElemen" size="30">
                                * &nbsp;<%= frmPriv.getErrorMsg(frmPriv.JSP_PRIV_NAME) %></td>
                            </tr>
                            <tr> 
                              <td width="15%" valign="top">Description</td>
                              <td width="85%"> 
                                <textarea name="<%=frmPriv.colNames[frmPriv.JSP_DESCRIPTION] %>" cols="45" rows="3" class="formElemen"><%=appPriv.getDescr()%></textarea>
                              </td>
                            </tr>
                            <tr> 
                              <td width="15%" valign="top" height="14">Creation/Update 
                                Date</td>
                              <td width="85%" height="14"><%=JSPDate.drawDate(frmPriv.colNames[JspPriv.JSP_REG_DATE], appPriv.getRegDate(), 0, -30)%> </td>
                            </tr>
                            <tr> 
                              <td colspan="2" class="command">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="2" class="command" height="22"> 
                                <%
							jspLine.setLocationImg(approot+"/images/ctr_line");
							jspLine.initDefault();
							jspLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+appPrivOID+"')";
							String sconDelCom = "javascript:cmdDelete('"+appPrivOID+"')";
							String scancel = "javascript:cmdCancel('"+appPrivOID+"')";
							jspLine.setBackCaption("Back to Privilege List");
							jspLine.setJSPCommandStyle("buttonlink");
							jspLine.setSaveCaption("Save Privilege");
							jspLine.setDeleteCaption("Delete Group");
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
                                <%= jspLine.drawImageOnly(iJSPCommand, excCode, msgString)%> </td>
                            </tr>
                            <% if((privAdd && privUpdate) && (iJSPCommand != JSPCommand.ASK || iJSPCommand == JSPCommand.DELETE || iJSPCommand==JSPCommand.SAVE)){%>
                            <tr> 
                              <td colspan="2" class="command"> 
                                      <table width="17%" border="0" cellspacing="2" cellpadding="2">
                                        <tr> 
                                          <td nowrap width="79%">[ <a href="javascript:cmdEditObj('<%=appPrivOID%>')" class="command">
                                            Edit Module Access</a> ]</td>
                                        </tr>
                                      </table>
                              </td>
                            </tr>
                            <%}%>
                            <tr> 
                              <td width="15%">&nbsp;</td>
                              <td width="85%">&nbsp;</td>
                            </tr>
                            <%}%>
                            <tr> 
                              <td width="15%">&nbsp;</td>
                              <td width="85%">&nbsp;</td>
                            </tr>
                          </table></td>
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
