
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.posmaster.ItemGroup" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checksl.jsp" %>
<%@ include file="../../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean privPrint = true;
%>
<!-- Jsp Block -->
<%
            if (session.getValue("REPORT_TOP_SALES_PARAMETER") != null) {
                session.removeValue("REPORT_TOP_SALES_PARAMETER");
            }

            ReportParameterTopSales rpts = new ReportParameterTopSales();

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long groupId = JSPRequestValue.requestLong(request, "src_group_id");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            int maxLimit = 0;
            int groupSts = JSPRequestValue.requestInt(request, "src_group_sts");
            int vendorSts = JSPRequestValue.requestInt(request, "src_vendor_sts");
            int itemSts = JSPRequestValue.requestInt(request, "src_item_sts");
            int locSts = JSPRequestValue.requestInt(request, "src_loc_sts");
            int all = JSPRequestValue.requestInt(request, "all");
            try {
                maxLimit = JSPRequestValue.requestInt(request, "src_max_limit");
            } catch (Exception e) {
                maxLimit = 0;
            }

            if (all == 1) {
                maxLimit = 0;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            rpts.setStartDate(tanggal);
            rpts.setEndDate(tanggalEnd);
            rpts.setLocationId(locationId);
            rpts.setDepartmentId(groupId);
            rpts.setVendorId(vendorId);

            rpts.setGroupStatus(groupSts);
            rpts.setItemStatus(itemSts);
            rpts.setLocationStatus(locSts);
            rpts.setVendorStatus(vendorSts);

            rpts.setMaxLimit(maxLimit);
            rpts.setAll(all);

            session.putValue("REPORT_TOP_SALES_PARAMETER", rpts);

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            if (tanggal == null) {
                tanggal = new Date();
            }

            int wdth = 1000;
            if (groupSts == 1) {
                wdth = wdth + 20;
            }
            if (vendorSts == 1) {
                wdth = wdth + 15;
            }
            if (locSts == 1) {
                wdth = wdth + 15;
            }
            if (groupSts == 0 && vendorSts == 0 && locSts == 0) {
                itemSts = 1;
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.ReportTopSalesXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.action="rptsalestop.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Top Sales Report<br>
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
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="3" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">
                                                                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="400">                                                                                                                                        
                                                                                                                                                    <tr>                                                                                                                                            
                                                                                                                                                        <td class="tablecell1" >                                                                                                                                                
                                                                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" style="border:1px solid #ABA8A8">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td height="10" colspan="4"></td>
                                                                                                                                                                </tr>    
                                                                                                                                                                <tr>
                                                                                                                                                                    <td width="5"></td>
                                                                                                                                                                    <td width="20%" height="14" nowrap>Period</td>
                                                                                                                                                                    <td > 
                                                                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                            <tr>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="Start date"></a> 
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>&nbsp;&nbsp;to&nbsp;&nbsp;
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="End date"></a>
                                                                                                                                                                                </td>
                                                                                                                                                                            </tr>
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td width="5"></td>
                                                                                                                                                                </tr>  
                                                                                                                                                                <tr>
                                                                                                                                                                    <td ></td>
                                                                                                                                                                    <td  nowrap> Location</td>
                                                                                                                                                                    <td > 
                                                                                                                                                                        <%
            Vector vLoc = userLocations;
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="src_location_id">
                                                                                                                                                                            <%if (vLoc.size() == totLocationxAll) {%>
                                                                                                                                                                            <option value="0"> - All Location -</option>
                                                                                                                                                                            <%}%>
                                                                                                                                                                            <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                                            %>
                                                                                                                                                                            <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                                            <%}
            }%>
                                                                                                                                                                        </select>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td ></td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr> 
                                                                                                                                                                    <td ></td>
                                                                                                                                                                    <td >Department</td>
                                                                                                                                                                    <td > 
                                                                                                                                                                        <%
            Vector vGroup = SQLGeneral.getGroup();
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="src_group_id">
                                                                                                                                                                            <option value="0">All Group</option>
                                                                                                                                                                            <%if (vGroup != null && vGroup.size() > 0) {
                for (int i = 0; i < vGroup.size(); i++) {
                    ItemGroup it = (ItemGroup) vGroup.get(i);
                                                                                                                                                                            %>
                                                                                                                                                                            <option value="<%=it.getOID()%>" <%if (it.getOID() == groupId) {%>selected<%}%>><%=it.getName()%></option>
                                                                                                                                                                            <%}
            }%>
                                                                                                                                                                        </select>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td ></td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr> 
                                                                                                                                                                    <td ></td>
                                                                                                                                                                    <td > Supplier</td>
                                                                                                                                                                    <td > 
                                                                                                                                                                        <%
            Vector vSup = SQLGeneral.getVendor();
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="src_vendor_id">
                                                                                                                                                                            <option value="0">All Vendor</option>
                                                                                                                                                                            <%if (vSup != null && vSup.size() > 0) {
                for (int i = 0; i < vSup.size(); i++) {
                    Vendor vd = (Vendor) vSup.get(i);
                                                                                                                                                                            %>
                                                                                                                                                                            <option value="<%=vd.getOID()%>" <%if (vd.getOID() == vendorId) {%>selected<%}%>><%=vd.getName()%></option>
                                                                                                                                                                            <%}
            }%>
                                                                                                                                                                        </select>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td ></td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr>
                                                                                                                                                                    <td ></td>    
                                                                                                                                                                    <td >Group</td>		
                                                                                                                                                                    <td >	
                                                                                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                            <tr>
                                                                                                                                                                                <td width="1%" height="15"><input type="checkbox" <%if (itemSts == 1) {%>checked<%}%> value="1" name="src_item_sts"></td>
                                                                                                                                                                                <td width="10%" height="15">Item</td>
                                                                                                                                                                                <td width="1%" height="15"><input type="checkbox" <%if (locSts == 1) {%>checked<%}%> value="1" name="src_loc_sts"></td>
                                                                                                                                                                                <td width="10%" height="15">Location</td>
                                                                                                                                                                                <td width="1%" height="15"><input type="checkbox" <%if (groupSts == 1) {%>checked<%}%> value="1" name="src_group_sts"></td>
                                                                                                                                                                                <td width="10%" height="15">Department</td>
                                                                                                                                                                                <td width="1%" height="15"><input type="checkbox" <%if (vendorSts == 1) {%>checked<%}%> value="1" name="src_vendor_sts"></td>
                                                                                                                                                                                <td width="10%" height="15">Supplier</td>
                                                                                                                                                                            </tr>
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>	
                                                                                                                                                                    <td ></td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr> 
                                                                                                                                                                    <td ></td>
                                                                                                                                                                    <td >Top </td>
                                                                                                                                                                    <td >
                                                                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                            <tr>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <input type="text" name = "src_max_limit" value ="<%=maxLimit%>" size="5">
                                                                                                                                                                                </td>    
                                                                                                                                                                                <td>
                                                                                                                                                                                    &nbsp;&nbsp;or&nbsp;
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>
                                                                                                                                                                                <input type="checkbox" name="all" value="1" <%if (all == 1) {%> checked<%}%>></td>
                                                                                                                                                                                <td>All Data</td>
                                                                                                                                                                            </tr>
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td ></td>
                                                                                                                                                                </tr>    
                                                                                                                                                                <tr>
                                                                                                                                                                    <td height="10" colspan="4"></td>
                                                                                                                                                                </tr> 
                                                                                                                                                            </table> 
                                                                                                                                                        </td>
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                </table> 
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                                                       
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../../images/search2.gif',1)"><img src="../../images/search.gif" name="new2" border="0"></a></td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4" height="15"></td>                                                                                                                                          
                                                                                                                                        </tr>
                                                                                                                                        <%if (iJSPCommand == JSPCommand.SUBMIT) {%>                                                                                                                                        
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4"><%@ include file ="transaksitop.jsp"%></td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4"><i>klik search button to seaching the data</i></td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                        </tr>  
                                                                                                                                        <%if (privPrint) {%>
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="4" height="10">
                                                                                                                                                <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../../images/printxls2.gif',1)"><img src="../../images/printxls.gif" name="print2" height="22" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
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
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
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
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
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

