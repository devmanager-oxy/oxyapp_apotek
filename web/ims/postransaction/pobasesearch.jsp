 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
String srcPoNumber = JSPRequestValue.requestString(request, "src_po_number");
long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
String strStDate = JSPRequestValue.requestString(request, "src_start_date");
String strEndDate = JSPRequestValue.requestString(request, "src_end_date");
int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

if(iJSPCommand==JSPCommand.NONE){
	srcIgnore = 1;
}

JSPLine ctrLine = new JSPLine();

Date srcStartDate = new Date();
Date srcEndDate = new Date();

if(strStDate!=null && strStDate.length()>0){
	srcStartDate = JSPFormater.formatDate(strStDate, "dd/MM/yyyy");
}
if(strEndDate!=null && strEndDate.length()>0){
	srcEndDate = JSPFormater.formatDate(strEndDate, "dd/MM/yyyy");
}


int start = JSPRequestValue.requestInt(request, "start");

/*variable declaration*/
int recordToGet = 15;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "status='CHECKED'";
String orderClause = "";

if(srcVendorId!=0){
	whereClause = whereClause +" and vendor_id="+srcVendorId;	
}

if(srcPoNumber!=null && srcPoNumber.length()>0){
	whereClause = whereClause +" and number like '%"+srcPoNumber+"%'";	
}

if(srcIgnore==0){// && iJSPCommand!=JSPCommand.NONE){
	whereClause = whereClause + " and (to_days(purch_date)>=to_days('"+JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd")+"')"+
			" and to_days(purch_date)<=to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"'))";	
}

//out.println(whereClause);

/*count list All Receive*/
int vectSize = DbPurchase.getCount(whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
  	Control c = new Control();
	start = c.actionList(iJSPCommand, start, vectSize, recordToGet);
} 

Vector purchases = DbPurchase.list(start, recordToGet, whereClause, orderClause);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

function cmdReceive(oid){
	document.form1.hidden_po_id.value=oid;
	document.form1.command.value="<%=JSPCommand.ADD%>";
	document.form1.action="receiveitempo.jsp";
	document.form1.submit();
}

function cmdSearch(){
	document.form1.command.value="<%=JSPCommand.LIST%>";
	document.form1.action="pobasesearch.jsp";
	document.form1.submit();
}

function cmdListFirst(){
	document.form1.command.value="<%=JSPCommand.FIRST%>";
	document.form1.prev_command.value="<%=JSPCommand.FIRST%>";
	document.form1.action="pobasesearch.jsp";
	document.form1.submit();
}

function cmdListPrev(){
	document.form1.command.value="<%=JSPCommand.PREV%>";
	document.form1.prev_command.value="<%=JSPCommand.PREV%>";
	document.form1.action="pobasesearch.jsp";
	document.form1.submit();
	}

function cmdListNext(){
	document.form1.command.value="<%=JSPCommand.NEXT%>";
	document.form1.prev_command.value="<%=JSPCommand.NEXT%>";
	document.form1.action="pobasesearch.jsp";
	document.form1.submit();
}

function cmdListLast(){
	document.form1.command.value="<%=JSPCommand.LAST%>";
	document.form1.prev_command.value="<%=JSPCommand.LAST%>";
	document.form1.action="pobasesearch.jsp";
	document.form1.submit();
}

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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
							<input type="hidden" name="command" value="">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="hidden_po_id" value="">
						  <%
						  try{
						  %>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td > 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Incoming 
                                      Goods </span>&raquo; <span class="lvl2">PO 
                                      Based Incoming</span></font></b></td>
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
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td colspan="4" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td height="5" colspan="2"><b><i>Search Parameters 
                                      :</i></b></td>
                                    <td height="5" width="7%">&nbsp;</td>
                                    <td height="5" width="58%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="5" width="6%">Supplier</td>
                                    <td height="5" width="29%"> 
                                      <%
									Vector v = DbVendor.list(0,0,"","");
									%>
                                      <select name="src_vendor_id" onChange="javascript:cmdSearch()">
                                        <option value="0" <%if(srcVendorId==0){%>selected<%}%>>All..</option>
                                        <%if(v!=null && v.size()>0){
											for(int i=0; i<v.size(); i++){
												Vendor vnd = (Vendor)v.get(i);	
										%>
                                        <option value="<%=vnd.getOID()%>" <%if(srcVendorId==vnd.getOID()){%>selected<%}%>><%=vnd.getCode()+" - "+vnd.getName()%></option>
                                        <%}}%>
                                      </select>
                                    </td>
                                    <td height="5" width="7%">&nbsp;PO Number</td>
                                    <td height="5" width="58%"> 
                                      <input type="text" name="src_po_number" value="<%=srcPoNumber%>">
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="5" width="6%">PO Date</td>
                                    <td height="5" width="29%"> 
                                      <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="23%" nowrap> 
                                            <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                          <td width="15%" nowrap><img src="../images/spacer.gif" width="5" height="1">to<img src="../images/spacer.gif" width="5" height="1"></td>
                                          <td width="31%" nowrap> 
                                            <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                          </td>
                                          <td width="31%" nowrap> <img src="../images/spacer.gif" width="5" height="1"> 
                                            <input type="checkbox" name="src_ignore" value="1" <%if(srcIgnore==1){%>checked<%}%>>
                                            ignore<img src="../images/spacer.gif" width="5" height="1"> 
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td height="5" width="7%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                    <td height="5" width="58%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="3" background="../images/line1.gif"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="15"><font color="#009900">&nbsp;<font color="#006600">List 
                                      of PO with CHECKED status, ready to be proceed 
                                      to incoming goods.</font></font></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="10%">PO 
                                            Date</td>
                                          <td class="tablehdr" width="10%">PO 
                                            Number</td>
                                          <td class="tablehdr" width="19%">Supplier</td>
                                          <td class="tablehdr" width="20%">Supplier 
                                            Address </td>
                                          <td class="tablehdr" width="20%">Note</td>
                                          <td class="tablehdr" width="11%">Total 
                                            Amount</td>
                                          <td class="tablehdr" width="10%">Status</td>
                                        </tr>
                                        <%
										if(purchases!=null && purchases.size()>0){
											for(int i=0; i<purchases.size(); i++){
												Purchase p = (Purchase)purchases.get(i);
												Vendor vx = new Vendor();
												try{
													vx = DbVendor.fetchExc(p.getVendorId());
												}
												catch(Exception ex){
												}
												if(i%2==0){	
										%>
                                        <tr> 
                                          <td class="tablecell1" width="10%"><a href="javascript:cmdReceive('<%=p.getOID()%>')"> 
                                            <%=JSPFormater.formatDate(p.getPurchDate(), "dd MMMM yyyy")%> </a></td>
                                          <td class="tablecell1" width="10%"><%=p.getNumber()%></td>
                                          <td class="tablecell1" width="19%"><%=vx.getCode()+" - "+vx.getName()%></td>
                                          <td class="tablecell1" width="20%"><%=vx.getAddress()%></td>
                                          <td class="tablecell1" width="20%"><%=p.getNote()%></td>
                                          <td class="tablecell1" width="11%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(p.getTotalAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="10%"> 
                                            <div align="center"><%=p.getStatus()%></div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td class="tablecell" width="10%"><a href="javascript:cmdReceive('<%=p.getOID()%>')"><%=JSPFormater.formatDate(p.getPurchDate(), "dd MMMM yyyy")%></a></td>
                                          <td class="tablecell" width="10%"><%=p.getNumber()%></td>
                                          <td class="tablecell" width="19%"><%=vx.getCode()+" - "+vx.getName()%></td>
                                          <td class="tablecell" width="20%"><%=vx.getAddress()%></td>
                                          <td class="tablecell" width="20%"><%=p.getNote()%></td>
                                          <td class="tablecell" width="11%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(p.getTotalAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="10%"> 
                                            <div align="center"><%=p.getStatus()%></div>
                                          </td>
                                        </tr>
                                        <%}}}else{%>
                                        <tr> 
                                          <td colspan="7" height="21"><font color="#FF0000">No 
                                            PO with status CHECKED available.</font></td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"><span class="command"> 
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
                                      <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span></td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="58%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="6%">&nbsp;</td>
                                    <td width="29%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="58%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="6%">&nbsp;</td>
                                    <td width="29%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="58%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="6%">&nbsp;</td>
                                    <td width="29%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="58%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
						  <%}
						  catch(Exception e){
						  	System.out.println(e.toString());
						  }%>
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
