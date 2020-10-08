
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->

	
<%




int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidOpname = JSPRequestValue.requestLong(request, "opname_id");
long idOpname =JSPRequestValue.requestLong(request, "hidden_opname_id");
long location_id = JSPRequestValue.requestLong(request, "hidden_location_id");
long locationId =JSPRequestValue.requestLong(request, "location_id");


if(oidOpname==0){
    oidOpname=idOpname;
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;

Opname op = new Opname();
try{
    op= DbOpname.fetchExc(oidOpname);
}catch(Exception ex){
    
}
if(locationId==0){
    locationId=location_id;
}
Location locOp= new Location();
try{
    locOp = DbLocation.fetchExc(locationId);
}catch(Exception ex){
    
}


//SessOpnameOrder prOrder = new SessOpnameOrder();
CmdOpnameSubLocation cmdOpnamesub = new CmdOpnameSubLocation(request);
JSPLine ctrLine = new JSPLine();
iErrCode = cmdOpnamesub.action(iJSPCommand , oidOpname, 0);
JspOpnameSubLocation jspOpname = cmdOpnamesub.getForm();
OpnameSubLocation opnamesub = cmdOpnamesub.getOpnameSubLocation();
msgString =  cmdOpnamesub.getMessage();

//object for report
//RptStockOpname rptKonstan = new RptStockOpname();

 Vector sublocations = DbSubLocation.list(0,0, "location_id="+locationId, "");       

%>	
	
<%






%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--


<%if(!posPReqPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";







function cmdSearch(){
	document.frmopname.command.value="<%=JSPCommand.SEARCH %>";
	document.frmopname.action="opnameitem.jsp?menu_idx=<%=menuIdx%>";
	document.frmopname.submit();
}
function cmdCloseDoc(){
	document.frmopname.action="<%=approot%>/home.jsp";
	document.frmopname.submit();
}

function cmdAskDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdDeleteDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdCancelDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdSaveDoc(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="addopnamesub.jsp";
	document.frmopname.submit();
         
}
function cmdSaveClose(){
	
        
        self.close();  
}

function cmdAdd(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.ADD%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAsk(oidOpnameItem){
	document.frmopname.hidden_opname_item_id.value=oidOpnameItem;
	document.frmopname.command.value="<%=JSPCommand.ASK%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAskMain(oidOpname){
	document.frmopname.hidden_opname_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.ASK%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdConfirmDelete(oidOpnameItem){
	document.frmopname.hidden_opname_item_id.value=oidOpnameItem;
	document.frmopname.command.value="<%=JSPCommand.DELETE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}
function cmdSaveMain(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
	}

function cmdSave(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdEdit(oidOpname){
	document.frmopname.hidden_opname_item_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdCancel(oidOpname){
	document.frmopname.hidden_opname_item_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdBack(){
	document.frmopname.command.value="<%=JSPCommand.BACK%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdListFirst(){
	document.frmopname.command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdListPrev(){
	document.frmopname.command.value="<%=JSPCommand.PREV%>";
	document.frmopname.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdListNext(){
	document.frmopname.command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdListLast(){
	document.frmopname.command.value="<%=JSPCommand.LAST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
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

function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
//-->
</script>
               
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
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
                  <!-- #BeginEditable "menu" --> 
                  
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmopname" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="0">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspOpname.colNames[JspOpname.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_opname_id" value="<%=oidOpname%>">
                          <input type="hidden" name="hidden_location_id" value="<%=locationId%>">
                          <input type="hidden" name="<%=JspOpnameItem.colNames[JspOpnameItem.JSP_OPNAME_ID]%>" value="<%=oidOpname%>">
                          <input type="hidden" name="<%=JspOpnameItem.colNames[JspOpnameItem.JSP_TYPE]%>" value="<%=DbOpnameItem.TYPE_NON_CONSIGMENT%>">
                          <input type="hidden" name="<%=JspOpname.colNames[JspOpnameItem.JSP_TYPE]%>" value="<%=DbOpname.TYPE_NON_CONSIGMENT%>">
                          <%if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
                            <input type="hidden" name="<%=JspOpname.colNames[JspOpname.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
                          <%}%>
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="5"></td>
                                  </tr>
                                  
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                              
                                              <tr align="left"> 
                                                <td height="26" width="12%" >&nbsp;&nbsp;Number</td>
                                                <td height="26" width="14%"> 
                                                    <input size="15" class="readOnly" type="text" readonly value="<%=op.getNumber()%>"> 
                                                </td>
                                                <td height="26" width="9%">Location</td>
                                                <td height="26" colspan="2" width="52%" class="comment">
                                                    <input size="40" class="readOnly" type="text" readonly value="<%=locOp.getName()%>"> 
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                  Type </td>
                                                <td width="14%" height="14"> 
                                                    <%if(op.getTypeOpname()==0){%>
                                                        <input size="15" class="readOnly" type="text" readonly value="Global"> 
                                                    <%}else{%>
                                                        <input size="15" class="readOnly" type="text" readonly value="Partial"> 
                                                    <%}%>
                                                </td>
                                                <td width="9%">status</td>
                                                <td colspan="2" class="comment" width="52%">
                                                    <input size="15" class="readOnly" type="text" readonly value="<%=op.getStatus()%>"> 
                                                </td>
                                              </tr>
						  
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                 Sub Location </td>
                                                <td height="21" width="27%">
												<%if(((!op.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
												<span class="comment"> 
                                                  <select name="<%=JspOpnameSubLocation.colNames[JspOpnameSubLocation.JSP_SUB_LOCATION_ID]%>" >
                                                    <%                                          
													
													  if(sublocations!=null && sublocations.size()>0){
														for(int i=0; i<sublocations.size(); i++){
															SubLocation d = (SubLocation)sublocations.get(i);
															
												    %>
                                                    <option value="<%=d.getOID()%>" <%if(opnamesub.getSubLocationId()==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                    <%}}%> 
                                                  </select> 
                                                  </span> 
												 <%}%> 
												  </td>
                                                <td width="9%">Form Number</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                    <input type="text" name="<%=JspOpnameSubLocation.colNames[JspOpnameSubLocation.JSP_FORM_NUMBER]%>">
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="27%"> 
                                                  <input name="<%=JspOpnameSubLocation.colNames[JspOpnameSubLocation.JSP_DATE]%>" value="<%=JSPFormater.formatDate((opnamesub.getDate()==null) ? new Date() : opnamesub.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmopname.<%=JspOpname.colNames[JspOpname.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <% 
												  
												  %> 
                                                </td>
                                                <td width="9%"></td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                        
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              
                                              <tr>
                                                <td height="21" width="12%">&nbsp;&nbsp;</td>
                                                <%if(opnamesub.getOID()==0 && oidOpname !=0){%>
                                                <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/save2.gif',1)"><img src="../images/save.gif" name="save211" height="22" border="0"></a></td>
                                                <%}%>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                             
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
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
        
      </table>
   <%if(iJSPCommand==JSPCommand.SAVE){%>
                    <script language="JavaScript">
                                                                cmdSaveClose();
                    </script>
                    <%}%>                                        

</body>
<!-- #EndTemplate --></html>
