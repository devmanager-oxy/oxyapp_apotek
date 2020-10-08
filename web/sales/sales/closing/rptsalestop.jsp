
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
<%@ page import = "java.sql.ResultSet" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checksl.jsp" %>
<%@ include file="../../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privPrint = true;
%>
<!-- Jsp Block -->
<%
            if (session.getValue("REPORT_TOP_SALES_PARAMETER") != null) {
                session.removeValue("REPORT_TOP_SALES_PARAMETER");
            }
            
            if (session.getValue("REPORT_TOP_SALES") != null) {
                session.removeValue("REPORT_TOP_SALES");
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

            if (tanggal == null) {
                tanggal = new Date();
            }

            int wdth = 1050;
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
            
            Vector print = new Vector();
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
                window.open("<%=printroot%>.report.ReportTopSalesXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
                                                                                                                                            <td colspan="4">
                                                                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="400">                                                                                                                                        
                                                                                                                                                    <tr>                                                                                                                                            
                                                                                                                                                        <td >                                                                                                                                                
                                                                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td height="10" colspan="4"></td>
                                                                                                                                                                </tr>    
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td width="80" class="tablearialcell1" nowrap>&nbsp;&nbsp;Period</td>
                                                                                                                                                                    <td width="1" class="fontarial">:</td>
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
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td class="tablearialcell1" nowrap>&nbsp;&nbsp;Location</td>
                                                                                                                                                                    <td class="fontarial">:</td>
                                                                                                                                                                    <td > 
                                                                                                                                                                        <%
            Vector vLoc = userLocations;
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="src_location_id" class="fontarial">
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
                                                                                                                                                                <tr height="22"> 
                                                                                                                                                                    <td class="tablearialcell1" nowrap>&nbsp;&nbsp;Category</td>
                                                                                                                                                                    <td class="fontarial">:</td>
                                                                                                                                                                    <td > 
                                                                                                                                                                        <%
            Vector vGroup = SQLGeneral.getGroup();
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="src_group_id" class="fontarial">
                                                                                                                                                                            <option value="0">- All Category -</option>
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
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td class="tablearialcell1" nowrap>&nbsp;&nbsp;Supplier</td>
                                                                                                                                                                    <td class="fontarial">:</td>
                                                                                                                                                                    <td > 
                                                                                                                                                                        <%
            Vector vSup = SQLGeneral.getVendor();
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="src_vendor_id" class="fontarial">
                                                                                                                                                                            <option value="0">- All Suplier -</option>
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
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td class="tablearialcell1" nowrap>&nbsp;&nbsp;Group</td>
                                                                                                                                                                    <td class="fontarial">:</td>
                                                                                                                                                                    <td >	
                                                                                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                            <tr>
                                                                                                                                                                                <td width="1%" height="15"><input type="checkbox" <%if (itemSts == 1) {%>checked<%}%> value="1" name="src_item_sts"></td>
                                                                                                                                                                                <td width="10%" height="15" class="fontarial">Item</td>
                                                                                                                                                                                <td width="1%" height="15"><input type="checkbox" <%if (locSts == 1) {%>checked<%}%> value="1" name="src_loc_sts"></td>
                                                                                                                                                                                <td width="10%" height="15" class="fontarial">Location</td>
                                                                                                                                                                                <td width="1%" height="15"><input type="checkbox" <%if (groupSts == 1) {%>checked<%}%> value="1" name="src_group_sts"></td>
                                                                                                                                                                                <td width="10%" height="15" class="fontarial">Department</td>
                                                                                                                                                                                <td width="1%" height="15"><input type="checkbox" <%if (vendorSts == 1) {%>checked<%}%> value="1" name="src_vendor_sts"></td>
                                                                                                                                                                                <td width="10%" height="15" class="fontarial">Supplier</td>
                                                                                                                                                                            </tr>
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>	
                                                                                                                                                                    <td ></td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td class="tablearialcell1" nowrap>&nbsp;&nbsp;Top </td>
                                                                                                                                                                    <td class="fontarial">:</td>
                                                                                                                                                                    <td >
                                                                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                            <tr>
                                                                                                                                                                                <td ><input type="text" name = "src_max_limit" value ="<%=maxLimit%>" size="4" class="fontarial" style="text-align:right"></td>    
                                                                                                                                                                                <td class="fontarial">&nbsp;&nbsp;or&nbsp;</td>
                                                                                                                                                                                <td><input type="checkbox" name="all" value="1" <%if (all == 1) {%> checked<%}%>></td>
                                                                                                                                                                                <td class="fontarial">All Data</td>
                                                                                                                                                                            </tr>
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td ></td>
                                                                                                                                                                </tr>    
                                                                                                                                                            </table> 
                                                                                                                                                        </td>
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                </table> 
                                                                                                                                            </td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="4">
                                                                                                                                                <table width="80%" border="0" cellspacing="1" cellpadding="1" height="3">
                                                                                                                                                    <tr > 
                                                                                                                                                        <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>    
                                                                                                                                            </td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">
                                                                                                                                                <table border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                    <tr >
                                                                                                                                                        <td width="80" nowrap>&nbsp;</td>
                                                                                                                                                        <td width="1" class="fontarial"></td>
                                                                                                                                                        <td><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../../images/search2.gif',1)"><img src="../../images/search.gif" name="new2" border="0"></a></td>                                                                                                                                            
                                                                                                                                                    </tr>                  
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4" height="15"></td>                                                                                                                                          
                                                                                                                                        </tr>
                                                                                                                                        <%
             int count = 0;
            if (iJSPCommand == JSPCommand.SUBMIT) {%>                                                                                                                                        
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4">
                                                                                                                                                <table width="<%=wdth%>" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="2" class="fontarial"><b><i>Data Top <%if (all == 0) {%><%=maxLimit%><%}%> Sales</i></b> </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="2" height="5"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="5%" align="center" class="tablearialhdr">No</td>
                                                                                                                                                        <%if (locSts == 1) {%>	
                                                                                                                                                        <td width="12%" align="center" class="tablearialhdr">Location</td>
                                                                                                                                                        <% }
                                                                                                                                            if (groupSts == 1) {%>	
                                                                                                                                                        <td width="10%" align="center" class="tablearialhdr">Category</td>
                                                                                                                                                        <%}
                                                                                                                                            if (vendorSts == 1) {
                                                                                                                                                        %>
                                                                                                                                                        <td width="15%" align="center" class="tablearialhdr">Suplier</td>	
                                                                                                                                                        <%}
                                                                                                                                            if (itemSts == 1) {
                                                                                                                                                        %>
                                                                                                                                                        <td width="10%" align="center" class="tablearialhdr">Code</td>
                                                                                                                                                        <td width="10%" align="center" class="tablearialhdr">Barcode</td>
                                                                                                                                                        <td align="center" class="tablearialhdr">Description</td>
                                                                                                                                                        <%}%>
                                                                                                                                                        <td width="7%" align="center" class="tablearialhdr">Qty</td>
                                                                                                                                                        <td width="7%" align="center" class="tablearialhdr">Price</td>
                                                                                                                                                        <td width="10%" align="center" class="tablearialhdr">Total</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%

                                                                                                                                            CONResultSet dbrs = null;
                                                                                                                                            double totQty = 0;
                                                                                                                                            double totAmount = 0;
                                                                                                                                            try {

                                                                                                                                                String sql = " select master_id,code,barcode,name,sum(sum_qty) as qtyx,sum(total) as totalx";

                                                                                                                                                String sqlInduk = "";

                                                                                                                                                if (groupSts == 1) {
                                                                                                                                                    sql = sql + ", namegroup,item_group_id";
                                                                                                                                                    sqlInduk = sqlInduk + ",ig.name as namegroup,ig.item_group_id ";
                                                                                                                                                }

                                                                                                                                                if (vendorSts == 1) {
                                                                                                                                                    sql = sql + ", namevd,default_vendor_id";
                                                                                                                                                    sqlInduk = sqlInduk + ",vd.name as namevd,m.default_vendor_id as default_vendor_id";
                                                                                                                                                }

                                                                                                                                                if (locSts == 1) {
                                                                                                                                                    sql = sql + ", nameloc,location_id";
                                                                                                                                                    sqlInduk = sqlInduk + ",loc.name as nameloc,loc.location_id as location_id";
                                                                                                                                                }


                                                                                                                                                String inner = "";

                                                                                                                                                if (groupSts == 1) {
                                                                                                                                                    inner = inner + " inner join pos_item_group as ig on m.item_group_id=ig.item_group_id";
                                                                                                                                                }

                                                                                                                                                if (vendorSts == 1) {
                                                                                                                                                    inner = inner + " inner join vendor as vd on m.default_vendor_id=vd.vendor_id";
                                                                                                                                                }

                                                                                                                                                if (locSts == 1) {
                                                                                                                                                    inner = inner + " inner join pos_location as loc on s.location_id=loc.location_id";
                                                                                                                                                }

                                                                                                                                                String wherex = " and to_days(s.date) >= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') and to_days(s.date) <= to_days('" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + "') ";

                                                                                                                                                if (groupId != 0) {
                                                                                                                                                    wherex = wherex + " and m.item_group_id=" + groupId;
                                                                                                                                                }

                                                                                                                                                if (vendorId != 0) {
                                                                                                                                                    wherex = wherex + " and m.default_vendor_id=" + vendorId;
                                                                                                                                                }

                                                                                                                                                if (locationId != 0) {
                                                                                                                                                    wherex = wherex + " and s.location_id=" + locationId;
                                                                                                                                                }



                                                                                                                                                String groupSQL = "";
                                                                                                                                                String groupSQLx = "";

                                                                                                                                                // create default
                                                                                                                                                if (groupSts == 0 && vendorSts == 0 && locSts == 0) {
                                                                                                                                                    itemSts = 1;
                                                                                                                                                }

                                                                                                                                                if (itemSts == 1) {
                                                                                                                                                    groupSQL = groupSQL + " sd.product_master_id";
                                                                                                                                                    groupSQLx = groupSQLx + " master_id ";
                                                                                                                                                }

                                                                                                                                                if (locSts == 1) { // group by item
                                                                                                                                                    if (groupSQL.length() > 0) {
                                                                                                                                                        groupSQL = groupSQL + ", s.location_id ";
                                                                                                                                                    } else {
                                                                                                                                                        groupSQL = groupSQL + " s.location_id ";
                                                                                                                                                    }


                                                                                                                                                    if (groupSQLx.length() > 0) {
                                                                                                                                                        groupSQLx = groupSQLx + ", location_id ";
                                                                                                                                                    } else {
                                                                                                                                                        groupSQLx = groupSQLx + " location_id ";
                                                                                                                                                    }
                                                                                                                                                }

                                                                                                                                                if (groupSts == 1) { // group by group
                                                                                                                                                    if (groupSQL.length() > 0) {
                                                                                                                                                        groupSQL = groupSQL + ", m.item_group_id ";
                                                                                                                                                    } else {
                                                                                                                                                        groupSQL = groupSQL + " m.item_group_id ";
                                                                                                                                                    }

                                                                                                                                                    if (groupSQLx.length() > 0) {
                                                                                                                                                        groupSQLx = groupSQLx + ", item_group_id ";
                                                                                                                                                    } else {
                                                                                                                                                        groupSQLx = groupSQLx + " item_group_id ";
                                                                                                                                                    }
                                                                                                                                                }

                                                                                                                                                if (vendorSts == 1) { // group by vendor
                                                                                                                                                    if (groupSQL.length() > 0) {
                                                                                                                                                        groupSQL = groupSQL + ", m.default_vendor_id ";
                                                                                                                                                    } else {
                                                                                                                                                        groupSQL = groupSQL + " m.default_vendor_id ";
                                                                                                                                                    }

                                                                                                                                                    if (groupSQLx.length() > 0) {
                                                                                                                                                        groupSQLx = groupSQLx + ", default_vendor_id ";
                                                                                                                                                    } else {
                                                                                                                                                        groupSQLx = groupSQLx + " default_vendor_id ";
                                                                                                                                                    }
                                                                                                                                                }

                                                                                                                                                if (groupSQL.length() > 0) {
                                                                                                                                                    groupSQL = " group by " + groupSQL;
                                                                                                                                                }

                                                                                                                                                if (groupSQLx.length() > 0) {
                                                                                                                                                    groupSQLx = " group by " + groupSQLx;
                                                                                                                                                }

                                                                                                                                                String orderx = "";

                                                                                                                                                if (all == 1) {
                                                                                                                                                    orderx = orderx + " order by qtyx desc";
                                                                                                                                                } else {
                                                                                                                                                    orderx = orderx + " order by qtyx desc limit 0," + maxLimit;
                                                                                                                                                }

                                                                                                                                                sql = sql + "  from ( " +
                                                                                                                                                        " select sd.product_master_id as master_id,m.code as code,m.barcode as barcode,m.name as name,sum(sd.qty) as sum_qty,sum((sd.qty * sd.selling_price)- sd.discount_amount) as total " + sqlInduk + " from pos_sales s  inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id " + inner + " where s.type in (0,1) " + wherex + " " + groupSQL + " union " +
                                                                                                                                                        " select sd.product_master_id as master_id,m.code as code,m.barcode as barcode,m.name as name,sum(sd.qty)*-1 as sum_qty,sum((sd.qty * sd.selling_price)- sd.discount_amount)*-1 as total " + sqlInduk + " from pos_sales s  inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id " + inner + " where s.type in (2,3) " + wherex + " " + groupSQL + " ) as x " + groupSQLx + " " + orderx;


                                                                                                                                                dbrs = CONHandler.execQueryResult(sql);
                                                                                                                                                ResultSet rs = dbrs.getResultSet();

                                                                                                                                                while (rs.next()) {

                                                                                                                                                    String code = rs.getString("code");
                                                                                                                                                    String barcode = rs.getString("barcode");
                                                                                                                                                    String name = rs.getString("name");
                                                                                                                                                    double qty = rs.getDouble("qtyx");
                                                                                                                                                    double total = rs.getDouble("totalx");
                                                                                                                                                    String locName = "";
                                                                                                                                                    String groupName = "";
                                                                                                                                                    String vendorName = "";
                                                                                                                                                    
                                                                                                                                                    String style = "";
                                                                                                                                                    if(count %2 == 0){
                                                                                                                                                        style = "tablearialcell";
                                                                                                                                                    }else{
                                                                                                                                                        style = "tablearialcell1";
                                                                                                                                                    }
                                                                                                                                                    totQty = totQty + qty;
                                                                                                                                                    totAmount = totAmount + total;        

                                                                                                                                                    %>  
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td align="center" class="<%=style%>"><%=(count + 1)%></td>
                                                                                                                                                        <%
                                                                                                                                                            if (locSts == 1) {
                                                                                                                                                                locName = rs.getString("nameloc");
                                                                                                                                                        %>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px"><%=locName%></td>
                                                                                                                                                        <%}
                                                                                                                                                            if (groupSts == 1) {
                                                                                                                                                                groupName = rs.getString("namegroup");
                                                                                                                                                        %>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px"><%=groupName%></td>
                                                                                                                                                        <%}
                                                                                                                                                            if (vendorSts == 1) {
                                                                                                                                                                vendorName = rs.getString("namevd");
                                                                                                                                                        %>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px"><%=vendorName%></td>		
                                                                                                                                                        <%}
                                                                                                                                                            if (itemSts == 1) {
                                                                                                                                                        %>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px"><%=code%></td>	
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px"><%=barcode%></td>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px"><%=name%></td>
                                                                                                                                                        <%}%>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px"><%=JSPFormater.formatNumber(qty, "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px"><%=JSPFormater.formatNumber((total / qty), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px"><%=JSPFormater.formatNumber(total, "###,###.##")%></td>
                                                                                                                                                    </tr>   
                                                                                                                                                    <%
                                                                                                                                                    Vector tmpPrint = new Vector();
                                                                                                                                                    tmpPrint.add(locName);
                                                                                                                                                    tmpPrint.add(groupName);
                                                                                                                                                    tmpPrint.add(vendorName);
                                                                                                                                                    tmpPrint.add(code);
                                                                                                                                                    tmpPrint.add(barcode);
                                                                                                                                                    tmpPrint.add(name);
                                                                                                                                                    tmpPrint.add(""+qty);
                                                                                                                                                    tmpPrint.add(""+total);
                                                                                                                                                    print.add(tmpPrint);
                                                                                                                                                    count++;
                                                                                                                                                }

                                                                                                                                                rs.close();

                                                                                                                                            } catch (Exception e) {
                                                                                                                                            }

                                                                                                                                            if (count == 0) {
                                                                                                                                                    %>    
                                                                                                                                                    <tr>        
                                                                                                                                                        <%int colsp = 1;%>                                                                                                                                                        
                                                                                                                                                        <%if (locSts == 1) {
                                                                                                                                                        colsp = colsp + 1;
                                                                                                                                                    }
                                                                                                                                                    if (groupSts == 1) {
                                                                                                                                                        colsp = colsp + 1;

                                                                                                                                                    }
                                                                                                                                                    if (vendorSts == 1) {
                                                                                                                                                        colsp = colsp + 1;
                                                                                                                                                    }
                                                                                                                                                    if (itemSts == 1) {
                                                                                                                                                        colsp = colsp + 3;
                                                                                                                                                    }
                                                                                                                                                    colsp = colsp + 3;
                                                                                                                                                        %>
                                                                                                                                                        <td colspan = "<%=colsp %>" class="tablecell1" ><i>Data not found</i></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
                                                                                                                                            }else{
                                                                                                                                                int colsp = 0;
                                                                                                                                                    %>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td bgcolor="#F3A78D">&nbsp;</td>
                                                                                                                                                        <%
                                                                                                                                                            if (locSts == 1) {
                                                                                                                                                                colsp++;
                                                                                                                                                        }
                                                                                                                                                            if (groupSts == 1) {
                                                                                                                                                                colsp++;
                                                                                                                                                       }
                                                                                                                                                            if (vendorSts == 1) {                                                                                                                                                                
                                                                                                                                                                colsp++;
                                                                                                                                                        }
                                                                                                                                                            if (itemSts == 1) {
                                                                                                                                                                colsp = colsp + 3;
                                                                                                                                                        }%>
                                                                                                                                                        <td align="center" colspan="<%=colsp%>" bgcolor="#F3A78D" style="padding:3px" class="fontarial"><b>T o t a l</b></td>
                                                                                                                                                        <td align="right" bgcolor="#F3A78D" style="padding:3px" class="fontarial"><b><%=JSPFormater.formatNumber(totQty, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" bgcolor="#F3A78D">&nbsp;</td>
                                                                                                                                                        <td align="right" bgcolor="#F3A78D" style="padding:3px" class="fontarial"><b><%=JSPFormater.formatNumber(totAmount, "###,###.##")%></b></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>
                                                                                                                                                </table>
                                                                                                                                            </td>
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
                                                                                                                                        <%
                                                                                                                                        if (privPrint && count > 0) {
                                                                                                                                            session.putValue("REPORT_TOP_SALES", print);
                                                                                                                                        %>
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
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                               
                                                                                                            </table>
                                                                                                        </form>
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

