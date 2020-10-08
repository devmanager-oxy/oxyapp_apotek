
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.posmaster.ItemGroup" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
<%@ include file = "../../main/checksl.jsp" %>
<%@ include file="../../calendar/calendarframe.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%

            if (session.getValue("PARAMETER") != null) {
                session.removeValue("PARAMETER");
            }

           


int x = (request.getParameter("target_page")==null) ? 0 : Integer.parseInt(request.getParameter("target_page"));
long locationId = JSPRequestValue.requestLong(request, "src_location_id");
long groupId = JSPRequestValue.requestLong(request, "src_group_id");
long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
int yearVal = JSPRequestValue.requestInt(request, "src_year");
int type = JSPRequestValue.requestInt(request, "src_type");
int sort = JSPRequestValue.requestInt(request, "src_sort");

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long customerId = JSPRequestValue.requestLong(request, "HIDDEN_JSP_CUSTOMER_ID");
long customerId1 = JSPRequestValue.requestLong(request, "JSP_CUSTOMER_ID");

Vector vLoc = SQLGeneral.getLocation();
if(iJSPCommand==JSPCommand.NONE){
    if(locationId==0){
        Location loc = (Location) vLoc.get(0);
        locationId= loc.getOID();
    }
}
if(customerId ==0){
    customerId=customerId1;
}
Customer cus = new Customer();
if(customerId >0){
    try{
        cus=DbCustomer.fetchExc(customerId);
    }catch(Exception e){
        
    }
        
}

Vector vParameter = new Vector();
vParameter.add(locationId);
vParameter.add(groupId);
vParameter.add(vendorId);
vParameter.add(type);
vParameter.add(yearVal);
vParameter.add(customerId);
vParameter.add(sort);
session.putValue("PARAMETER", vParameter);


/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Oxy-Sales</title>
<link href="../../css/csssl.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
function cmdPrintXLS(){	                       
                window.open("<%=printroot%>.report.RptSalesYearXLS?idx=<%=System.currentTimeMillis()%>");
            }
function cmdSearch(){
	document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
	document.frmsales.action="rptsalesyear.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdListFirst(){
	document.frmsales.command.value="<%=JSPCommand.FIRST%>";
	document.frmsales.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsales.action="rptsalesyear.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdSearchCustomer(){  
         
            
            
            window.open("<%=approot%>/sales/closing/searchCustomer.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
            //document.frmpurchase.submit();    
        }
function cmdListPrev(){
	document.frmsales.command.value="<%=JSPCommand.PREV%>";
	document.frmsales.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsales.action="rptsalesyear.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
	}

function cmdListNext(){
	document.frmsales.command.value="<%=JSPCommand.NEXT%>";
	document.frmsales.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsales.action="rptsalesyear.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();
}

function cmdListLast(){
	document.frmsales.command.value="<%=JSPCommand.LAST%>";
	document.frmsales.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsales.action="rptsalesyear.jsp?menu_idx=<%=menuIdx%>";
	document.frmsales.submit();

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
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../../images/search2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../../main/hmenusl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../../main/menusl.jsp"%>
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
                                                <form name="frmsales" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <input type="hidden" name="JSP_CUSTOMER_ID" value="<%= customerId %>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                          <tr valign="bottom"> 
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                              </font><font class="tit1">&raquo; 
                                                              <span class="lvl2">SALES 
                                                              SUMMARY YEAR Report<br>
                                                              </span></font></b></td>
                                                            <td width="40%" height="23"> 
                                                              <%@ include file = "../../main/userpreview.jsp" %>
                                                            </td>
                                                          </tr>
                                                          <tr > 
                                                            <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td height="8"  colspan="3" class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" colspan="3" align="left" valign="middle"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap>&nbsp;</td>
                                                                  <td colspan="3" height="14">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap>Year</td>
                                                                  <%
                                                                    Date dt = new Date ();
                                                                            
                                                                    int tahunMax = dt.getYear() + 1900;
                                                                  %>
                                                                  <td width="33%" colspan="3" nowrap><select name="src_year">
                                                                      <%for(int i=(tahunMax-10);i<=tahunMax;i++){%>
                                                                      <option value="<%=i%>" <%if(yearVal==i){%>selected<%}%>><%=i%></option>
                                                                      
                                                                      <%}%>
                                                                    </select> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap> 
                                                                    Location</td>
                                                                  <td height="14" colspan="3"> 
                                                                    <%
																	//Vector vLoc = SQLGeneral.getLocation();
																	%> 
                                                                    <select name="src_location_id">
                                                                      <%if(vLoc!=null && vLoc.size()>0){
																	  for(int i=0; i<vLoc.size(); i++){
																	  	Location us = (Location)vLoc.get(i);
																	  %>
                                                                      <option value="<%=us.getOID()%>" <%if(us.getOID()==locationId){%>selected<%}%>><%=us.getName()%></option>
                                                                      <%}%>
                                                                       <option value="0" <%if(locationId==0){%>selected<%}%>>ALL LOCATION</option>                                                                   
                                                                      <%}%>
                                                                    </select> 
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap> 
                                                                    Department</td>
                                                                  <td height="14" colspan="3"> 
                                                                    <%
																	Vector vGroup = SQLGeneral.getGroup();
																	%> 
                                                                    <select name="src_group_id">
                                                                      <option value="0">All 
                                                                      group</option>
                                                                      <%if(vGroup!=null && vGroup.size()>0){
																	  for(int i=0; i<vGroup.size(); i++){
																	  	ItemGroup it = (ItemGroup)vGroup.get(i);
																	  %>
                                                                      <option value="<%=it.getOID()%>" <%if(it.getOID()==groupId){%>selected<%}%>><%=it.getName()%></option>
                                                                      <%}}%>
                                                                    </select> 
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap> 
                                                                    Supplier</td>
                                                                  <td height="14" colspan="3"> 
                                                                    <%
																	Vector vSup = SQLGeneral.getVendor();
																	%> 
                                                                    <select name="src_vendor_id">
                                                                      <option value="0">All
                                                                      Vendor</option>
                                                                      <%if(vSup!=null && vSup.size()>0){
																	  for(int i=0; i<vSup.size(); i++){
																	  	Vendor vd = (Vendor)vSup.get(i);
																	  %>
                                                                      <option value="<%=vd.getOID()%>" <%if(vd.getOID()==vendorId){%>selected<%}%>><%=vd.getName()%></option>
                                                                      <%}}%>
                                                                    </select> 
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap>Customer</td>
                                                                  <td width="33%" colspan="3" nowrap>
                                                                      <input type="hidden" size="70" name="HIDDEN_JSP_CUSTOMER_ID" >
                                                                  <input type="text" readonly size="30" name="JSP_VENDOR_item" onchange="javascript:cmdSearchCustomer()" value="<%=cus.getName()%>" >
                                                  
                                                                        <a href="javascript:cmdSearchCustomer()" >search</a>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap>Show by</td>
                                                                  <td width="33%" colspan="3" nowrap><select name="src_type">
                                                                      <option value="0" <%if(type==0){%>selected<%}%>>Total QTY</option>
                                                                      <option value="1" <%if(type==1){%>selected<%}%>>Total Value</option>
                                                                    </select> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="14" nowrap>Sort by</td>
                                                                  <td width="33%" colspan="3" nowrap><select name="src_sort">
                                                                      <option value="0" <%if(sort==0){%>selected<%}%>>Item Name</option>
                                                                      <option value="1" <%if(sort==1){%>selected<%}%>>Total</option>
                                                                    </select> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="33%" height="15">&nbsp;</td>
                                                                  <td width="8%" height="15">&nbsp;</td>
                                                                  <td width="49%" height="15">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="33">&nbsp;</td>
                                                                  <td height="33" colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../../images/search2.gif',1)"><img src="../../images/search.gif" name="new2" border="0"></a> 
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="15">&nbsp;</td>
                                                                  <td width="33%" height="15">&nbsp; 
                                                                  </td>
                                                                  <td width="8%" height="15">&nbsp;</td>
                                                                  <td width="49%" height="15">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15" colspan="4"><%@ include file ="transaksiyear.jsp"%></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                   <%if(yearVal!=0 && iJSPCommand==JSPCommand.SEARCH){%> 
                                                                  <td width="97"> 
                                                                       <a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../../images/printxls.gif',1)"><img src="../../images/printxls.gif" name="new2" border="0"></a>
                                                                  </td>
                                                                  <%}%>
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                  <td height="15">&nbsp;</td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" colspan="4" align="left" valign="middle"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                  <td class="boxed1"></td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="8" align="left" colspan="3" class="command"> 
                                                              <span class="command"> 
                                                              </span> </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" colspan="4" align="left" valign="middle"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td width="97%">&nbsp;</td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td height="8" valign="middle" colspan="3">&nbsp; 
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
        <tr> 
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../../main/footersl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

