
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL);
boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_VIEW);
boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_UPDATE);
boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_ADD);
boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass, long pekerjaanId, String[] lang) {
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("50%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		
		//ctrlist.addHeader("Province","30%");
		//ctrlist.addHeader("Kode","20%");
		ctrlist.addHeader(lang[0],"30%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Pekerjaan pekerjaan = (Pekerjaan)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(pekerjaanId == pekerjaan.getOID())
				 index = i;
				 /*
				 Province province = new Province();
				 try{
				 	
				 	province = DbProvince.fetchExc(pekerjaan.getProvinceId());
					
				 }catch(Exception e){
				 	System.out.println(e.toString());
				 }
				 */
				 
			//rowx.add(province.getNama());
			//rowx.add(""+pekerjaan.getKode());
			rowx.add(pekerjaan.getNama());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(pekerjaan.getOID()));
		}

		//return ctrlist.drawList(index);

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPekerjaan = JSPRequestValue.requestLong(request, "hidden_pekerjaan_id");


int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPekerjaan ctrlPekerjaan = new CmdPekerjaan(request);
JSPLine ctrLine = new JSPLine();
Vector listPekerjaan = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPekerjaan.action(iJSPCommand , oidPekerjaan);
/* end switch*/
JspPekerjaan jspPekerjaan = ctrlPekerjaan.getForm();

/*count list All Pekerjaan*/
int vectSize = DbPekerjaan.getCount(whereClause);

Pekerjaan pekerjaan = ctrlPekerjaan.getPekerjaan();
msgString =  ctrlPekerjaan.getMessage();

/*switch list Pekerjaan*/
if((iJSPCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE)){
	//start = DbPekerjaan.findLimitStart(pekerjaan.getOID(),recordToGet, whereClause);
	oidPekerjaan = pekerjaan.getOID();
}

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlPekerjaan.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listPekerjaan = DbPekerjaan.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listPekerjaan.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listPekerjaan = DbPekerjaan.list(start,recordToGet, whereClause , orderClause);
}

//out.println(listPekerjaan);

/*** LANG ***/
String[] langMD = {"Job Name", "Job Data", "required"};
String[] langNav = {"Masterdata", "Occupation List"};
if(lang == LANG_ID) {
	String[] langID = {"Nama Pekerjaan", "Data Pekerjaan", "harus diisi"};
	langMD = langID;
	String[] navID = {"Data Induk", "Daftar Pekerjaan"};
	langNav = navID;
}

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<title><%=systemTitle%></title>
<script language="JavaScript">
<%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
function cmdAdd(){
	document.jsppekerjaan.hidden_pekerjaan_id.value="0";
	document.jsppekerjaan.command.value="<%=JSPCommand.ADD%>";
	document.jsppekerjaan.prev_command.value="<%=prevJSPCommand%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
}

function cmdAsk(oidPekerjaan){
	document.jsppekerjaan.hidden_pekerjaan_id.value=oidPekerjaan;
	document.jsppekerjaan.command.value="<%=JSPCommand.ASK%>";
	document.jsppekerjaan.prev_command.value="<%=prevJSPCommand%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
}

function cmdConfirmDelete(oidPekerjaan){
	document.jsppekerjaan.hidden_pekerjaan_id.value=oidPekerjaan;
	document.jsppekerjaan.command.value="<%=JSPCommand.DELETE%>";
	document.jsppekerjaan.prev_command.value="<%=prevJSPCommand%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
}
function cmdSave(){
	document.jsppekerjaan.command.value="<%=JSPCommand.SAVE%>";
	document.jsppekerjaan.prev_command.value="<%=prevJSPCommand%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
	}

function cmdEdit(oidPekerjaan){
    <%if (privUpdate) {%>
	document.jsppekerjaan.hidden_pekerjaan_id.value=oidPekerjaan;
	document.jsppekerjaan.command.value="<%=JSPCommand.EDIT%>";
	document.jsppekerjaan.prev_command.value="<%=prevJSPCommand%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
     <%}%>    
	}

function cmdCancel(oidPekerjaan){
	document.jsppekerjaan.hidden_pekerjaan_id.value=oidPekerjaan;
	document.jsppekerjaan.command.value="<%=JSPCommand.EDIT%>";
	document.jsppekerjaan.prev_command.value="<%=prevJSPCommand%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
}

function cmdBack(){
	document.jsppekerjaan.command.value="<%=JSPCommand.BACK%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
	}

function cmdListFirst(){
	document.jsppekerjaan.command.value="<%=JSPCommand.FIRST%>";
	document.jsppekerjaan.prev_command.value="<%=JSPCommand.FIRST%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
}

function cmdListPrev(){
	document.jsppekerjaan.command.value="<%=JSPCommand.PREV%>";
	document.jsppekerjaan.prev_command.value="<%=JSPCommand.PREV%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
	}

function cmdListNext(){
	document.jsppekerjaan.command.value="<%=JSPCommand.NEXT%>";
	document.jsppekerjaan.prev_command.value="<%=JSPCommand.NEXT%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
}

function cmdListLast(){
	document.jsppekerjaan.command.value="<%=JSPCommand.LAST%>";
	document.jsppekerjaan.prev_command.value="<%=JSPCommand.LAST%>";
	document.jsppekerjaan.action="pekerjaan.jsp";
	document.jsppekerjaan.submit();
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
</SCRIPT>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','<%=approot%>/images/BtnNewOn.jpg')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file = "../main/hmenu.jsp" %>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp" %>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">"+langNav[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+langNav[1]+"</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="jsppekerjaan" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_pekerjaan_id" value="<%=oidPekerjaan%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="100%"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                          <%
							try{
								if (listPekerjaan.size()>0){
								
									//out.println("ada data : ");
								
									//db server selection
										
										Vector temp = new Vector();
										
										switch (CONHandler.CONSVR_TYPE) {
											case CONHandler.CONSVR_MYSQL :
														temp = listPekerjaan;
													break;
							
											 case CONHandler.CONSVR_POSTGRESQL :
														temp = listPekerjaan;
													break;
							
											 case CONHandler.CONSVR_SYBASE :
												 		temp = listPekerjaan;
													break;
							
											 case CONHandler.CONSVR_ORACLE :
											 			temp = listPekerjaan;
													break;
							
											 case CONHandler.CONSVR_MSSQL :
														int loopInt = 0;		
														if((start + recordToGet)> listPekerjaan.size()){
															loopInt = recordToGet - ((start + recordToGet) - listPekerjaan.size());
														}
														else{
															loopInt = recordToGet;
														}
														
														int count = 0;
														for(int i=start; (i<listPekerjaan.size() && count<loopInt); i++){
															Pekerjaan im = (Pekerjaan)listPekerjaan.get(i);
															count = count + 1;
															temp.add(im);
														}
													break;
							
											default:
													temp = listPekerjaan;
												break;
										}
										
										//out.println("temp : "+temp);
										
							%>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="3"><%= drawList(temp, oidPekerjaan, langMD)%> </td>
                                                          </tr>
                                                          <%  } 
						  }catch(Exception exc){ 
						  }%>
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" align="left" colspan="3" class="command"><span class="command"> 
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
                                                              <% ctrLine.setLocationImg(approot+"/images");
							   	ctrLine.initDefault();
								 %>
                                                              <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> 
                                                            </td>
                                                          </tr>
                                                          <%
						if((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iJSPCommand != JSPCommand.EDIT)&& (jspPekerjaan.errorSize()<1)){
					   if(privAdd){%>
                                                          <tr align="left" valign="top"> 
                                                            <td> 
                                                              <table cellpadding="0" cellspacing="0" border="0">
                                                                <tr> 
                                                                  <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                  <td width="20"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/ctr_line/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/ctr_line/BtnNew.jpg" width="18" height="16" alt="Add new data"></a></td>
                                                                  <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                  <td height="22" valign="middle" colspan="3" width="951"> 
                                                                  <%if (privAdd) {%>
                                                                        <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a> 
                                                                  <%}%>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <%}
						  }%>
                                                          <tr align="left" valign="top"> 
                                                            <td> 
                                                              <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(jspPekerjaan.errorSize()>0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td colspan="2" class="listtitle"><b><%=oidPekerjaan==0?"Entry":"Edit"%>&nbsp;<%=langMD[1]%></b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="100%" colspan="2"> 
                                                                    <table border="0" cellspacing="1" cellpadding="0" width="56%">
                                                                      <tr align="left"> 
                                                                        <td valign="top" width="17%">&nbsp;</td>
                                                                        <td width="83%" class="comment" valign="top"><font color="#ff0000">*) <%=langMD[2]%></font></td>
                                                                      </tr>
                                                                      <tr align="left"> 
                                                                        <td width="17%" height="39"><%=langMD[0]%></td>
                                                                        <td width="83%" height="39"> 
                                                                          <input type="text" name="<%=jspPekerjaan.fieldNames[JspPekerjaan.JSP_NAMA] %>"  value="<%= (pekerjaan.getNama()==null) ? "" : pekerjaan.getNama() %>" class="elemenForm" size="70">
                                                                          * <%=jspPekerjaan.getErrorMsg(JspPekerjaan.JSP_NAMA)%> 
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                  <td colspan="2" class="command"> 
                                                                    <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("40%");
									String scomDel = "javascript:cmdAsk('"+oidPekerjaan+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPekerjaan+"')";
									String scancel = "javascript:cmdEdit('"+oidPekerjaan+"')";
									ctrLine.setBackCaption("Back");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("Entry Literatur Baru");

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
									
									/*if(privNone){
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("Entry Literatur Baru");
									}*/
									
									%>
                                                                    <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="13%">&nbsp;</td>
                                                                  <td width="87%">&nbsp;</td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                  <td colspan="3"> 
                                                                    <div align="left"></div>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              <%}%>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td>&nbsp; </td>
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
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3">&nbsp;</td>
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
            <%@ include file = "../main/footer.jsp" %>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

