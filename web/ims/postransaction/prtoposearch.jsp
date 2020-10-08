<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.request.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "java.util.Date" %>
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
<%!

	public String drawList(Vector objectClass, int start)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("80%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setHeaderStyle("tablehdr");
		
		cmdist.addHeader("No","3%");
		cmdist.addHeader("Date","10%");
        cmdist.addHeader("PR Number","12%");		
		cmdist.addHeader("Department","20%");
		cmdist.addHeader("Notes","40%");		
        //cmdist.addHeader("Status","15%");

		cmdist.setLinkRow(1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			PurchaseRequest purchaseRequest = (PurchaseRequest)objectClass.get(i);
			 Vector rowx = new Vector();

                        rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");         			
			if(purchaseRequest.getDate()==null)
				rowx.add("");
			else	
				rowx.add("<div align=\"center\">"+JSPFormater.formatDate(purchaseRequest.getDate(),"dd-MMM-yyyy")+"</div>");
                        rowx.add(purchaseRequest.getNumber());        
                        Department department = new Department();        
                        try{
                            department = DbDepartment.fetchExc(purchaseRequest.getDepartmentId());
                            }catch(Exception e){}
			rowx.add(""+department.getName());
                        rowx.add(purchaseRequest.getNote());
			//rowx.add("<div align=\"center\">"+purchaseRequest.getStatus()+"</div>");

                        lstData.add(rowx);
			lstLinkData.add(String.valueOf(purchaseRequest.getOID()));
		}

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPurchaseRequest = JSPRequestValue.requestLong(request, "hidden_purchase_request_id");

long srcDepartmentId = JSPRequestValue.requestLong(request, "src_department_id");
String srcStatus = JSPRequestValue.requestString(request, "src_status");

/*variable declaration*/
int recordToGet = 15;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = DbPurchaseRequest.colNames[DbPurchaseRequest.COL_DATE];

whereClause = DbPurchaseRequest.colNames[DbPurchaseRequest.COL_STATUS]+"='"+I_Project.DOC_STATUS_APPROVED+"'";		
if(srcDepartmentId!=0){
	whereClause = whereClause +" and "+DbPurchaseRequest.colNames[DbPurchaseRequest.COL_DEPARTMENT_ID]+"="+srcDepartmentId;
}

/*
if(srcStatus!=null && srcStatus.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and "+DbPurchaseRequest.colNames[DbPurchaseRequest.COL_STATUS]+"='"+srcStatus+"'";	
	}
	else{
		whereClause = DbPurchaseRequest.colNames[DbPurchaseRequest.COL_STATUS]+"='"+srcStatus+"'";	
	}
}*/

//out.println(whereClause);

CmdPurchaseRequest cmdPurchaseRequest = new CmdPurchaseRequest(request);
JSPLine ctrLine = new JSPLine();
Vector listPurchaseRequest = new Vector(1,1);

/*switch statement */
iErrCode = cmdPurchaseRequest.action(iJSPCommand , oidPurchaseRequest);
/* end switch*/
JspPurchaseRequest jspPurchaseRequest = cmdPurchaseRequest.getForm();

/*count list All PurchaseRequest*/
int vectSize = DbPurchaseRequest.getCount(whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
	start = cmdPurchaseRequest.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
orderClause = DbPurchaseRequest.colNames[DbPurchaseRequest.COL_DATE];
listPurchaseRequest = DbPurchaseRequest.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listPurchaseRequest.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listPurchaseRequest = DbPurchaseRequest.list(start,recordToGet, whereClause , orderClause);
}
Vector deps = DbDepartment.list(0,0, "level=0", "code");

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--

<%if(!posPReqPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdSearch(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.LIST%>";
	document.frmpurchaserequest.action="prtoposearch.jsp";
	document.frmpurchaserequest.submit();
}

function cmdEdit(oid){
	document.frmpurchaserequest.hidden_purchase_request_id.value=oid;
	document.frmpurchaserequest.command.value="<%=JSPCommand.EDIT%>";
	document.frmpurchaserequest.prev_command.value="<%=prevJSPCommand%>";
	document.frmpurchaserequest.action="prtopo.jsp";
	document.frmpurchaserequest.submit();
}

function cmdListFirst(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpurchaserequest.action="prtoposearch.jsp";
	document.frmpurchaserequest.submit();
}

function cmdListPrev(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.PREV%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpurchaserequest.action="prtoposearch.jsp";
	document.frmpurchaserequest.submit();
	}

function cmdListNext(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpurchaserequest.action="prtoposearch.jsp";
	document.frmpurchaserequest.submit();
}

function cmdListLast(){
	document.frmpurchaserequest.command.value="<%=JSPCommand.LAST%>";
	document.frmpurchaserequest.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpurchaserequest.action="prtoposearch.jsp";
	document.frmpurchaserequest.submit();
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
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpurchaserequest" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_purchase_request_id" value="<%=oidPurchaseRequest%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Export 
                                      PR to PO </span>&raquo; <span class="lvl2">Analysis</span></font></b></td>
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
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td class="height="22" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                              <tr> 
                                                <td width="10%">PR from Department</td>
                                                <td width="20%"> 
                                                  <select name="src_department_id" onChange="javascript:cmdSearch()">
                                                    <option value="0" <%if(srcDepartmentId==0){%>selected<%}%>>- 
                                                    All -</option>
                                                    <%
											  if(deps!=null && deps.size()>0){
											  	for(int i=0; i<deps.size(); i++){
											  		Department d = (Department)deps.get(i);
													String str = "";
													%>
                                                    <option value="<%=d.getOID()%>" <%if(srcDepartmentId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="56%">&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="5"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
										if (listPurchaseRequest.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listPurchaseRequest,start)%> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <%  
										}else{ 
										%>
                                        <tr align="left" valign="top"> 
                                          <td height="23" align="left" colspan="3" class="command" valign="middle"><font color="#FF0000">&nbsp;No 
                                            APPROVED purchase request document 
                                            available</font></td>
                                        </tr>
                                        <%}
						  }catch(Exception exc){ 
						  	System.out.println("sdsdf : "+exc.toString());
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
                                            <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								
								ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <%if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"></a></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp; </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						    <%if(iJSPCommand==JSPCommand.NONE){%>
							cmdSearch();
							<%}%>
							</script>
                        </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable --> </td>
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
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
