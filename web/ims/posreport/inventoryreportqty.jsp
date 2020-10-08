
<%-- 
    Document   : inventoryreportqty
    Created on : Mar 11, 2015, 7:39:00 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_INVENTORY_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_INVENTORY_REPORT, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_INVENTORY_REPORT, AppMenu.PRIV_PRINT);            
%>

<%!
    public static ItemGroup getGroup(long groupId) {
        CONResultSet dbrs = null;
        ItemGroup ig = new ItemGroup();
        try {
            String sql = "select "+DbItemGroup.colNames[DbItemGroup.COL_CODE]+","+
                    DbItemGroup.colNames[DbItemGroup.COL_NAME]+" from "+DbItemGroup.DB_ITEM_GROUP+" where "+
                    DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = "+groupId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                ig.setCode(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_CODE]));
                ig.setName(rs.getString(DbItemGroup.colNames[DbItemGroup.COL_NAME]));
            }

            rs.close();
        } catch (Exception e) {
            return ig;
        } finally {
            CONResultSet.close(dbrs);
        }
        return ig;

    }
    
    public static ItemCategory getCategory(long categoryId) {
        CONResultSet dbrs = null;
        ItemCategory ic = new ItemCategory();
        try {
            String sql = "select "+DbItemCategory.colNames[DbItemCategory.COL_NAME]+
                    " from "+DbItemCategory.DB_ITEM_CATEGORY+" where "+
                    DbItemCategory.colNames[DbItemCategory.COL_ITEM_CATEGORY_ID]+" = "+categoryId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {                
                ic.setName(rs.getString(DbItemCategory.colNames[DbItemCategory.COL_NAME]));
            }

            rs.close();
        } catch (Exception e) {
            return ic;
        } finally {
            CONResultSet.close(dbrs);
        }
        return ic;

    }
%>
<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_INVENTORY_STOCK_SUMMARY") != null) {
                session.removeValue("REPORT_INVENTORY_STOCK_SUMMARY");
            }

            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");

            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");

            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int orderBy = JSPRequestValue.requestInt(request, "order_by");  
            int filterBy = JSPRequestValue.requestInt(request, "filter_by");                       
            int grpType = JSPRequestValue.requestInt(request, "grp_type");
            int invType = JSPRequestValue.requestInt(request, "inv_type");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int all = JSPRequestValue.requestInt(request, "all");
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            Vector vCategory = DbItemGroup.list(0, 0, "", "" + DbItemGroup.colNames[DbItemGroup.COL_NAME]);
            String whereGrp = "";
            
            if(iJSPCommand == JSPCommand.NONE){
                filterBy = -1;
            }

            if (vCategory != null && vCategory.size() > 0) {
                for (int i = 0; i < vCategory.size(); i++) {
                    ItemGroup ic = (ItemGroup) vCategory.get(i);
                    int ok = JSPRequestValue.requestInt(request, "grp" + ic.getOID());
                    if (ok == 1) {
                        if (whereGrp != null && whereGrp.length() > 0) {
                            whereGrp = whereGrp + ",";
                        }
                        whereGrp = whereGrp + ic.getOID();
                    }
                }
            }
            
            if(whereGrp==null || whereGrp.length() <=0){
                whereGrp = "0";
            }
            
            Vector resultXLS = new Vector();

            Vector result = new Vector();
            ReportParameter rParameter = new ReportParameter();
            rParameter.setLocationId(locationId);
            rParameter.setDateFrom(invStartDate);
            rParameter.setDateTo(invEndDate);
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournalXls(){	                       
                window.open("<%=printroot%>.report.ReportInvSummaryXLS?user_id=<%=appSessUser.getUserOID()%>&inv_type=<%=1%>&location_id=<%=locationId%>&type=<%=grpType%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsalescategory.command.value="<%=JSPCommand.SEARCH%>";    
                    <%if (invType == 0) {%>
                        document.frmsalescategory.action="inventoryreportvalue.jsp?menu_idx=<%=menuIdx%>";
                    <%} else {%>
                        document.frmsalescategory.action="inventoryreportqty.jsp?menu_idx=<%=menuIdx%>";
                    <%}%>
                    document.frmsalescategory.submit();
                }
                
                function cmdOnChange(){
                    document.frmsalescategory.command.value="<%=JSPCommand.NONE%>";    
                    var x = document.frmsalescategory.inv_type.value;  
                    if (x == 0){                        
                        document.frmsalescategory.action="inventoryreportvalue.jsp?menu_idx=<%=menuIdx%>";
                    } else {                        
                        document.frmsalescategory.action="inventoryreportqty.jsp?menu_idx=<%=menuIdx%>";
                    }
                    document.frmsalescategory.submit();
                }
            
            function setChecked(val){
                 <%
            for (int k = 0; k < vCategory.size(); k++) {
                ItemGroup ic = (ItemGroup) vCategory.get(k);
                %>
                    document.frmsalescategory.grp<%=ic.getOID()%>.checked=val.checked;
                    
                    <%}%>
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
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
                                                                                                        <form name="frmsalescategory" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                            
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                                                                                                                                                                                        
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                    <span class="lvl2">Inventory Report<br></span></font></b>
                                                                                                                                </td>
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
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table border="0" cellpadding="1" cellspacing="1" >                                                                                                                                        
                                                                                                                                        <tr>                                                                                                                                            
                                                                                                                                            <td >                                                                                                                                                
                                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" >
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="5" nowrap colspan="3" height="4"></td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="3" height="14" nowrap class="fontarial"><i>Searching Parameter :</i></td>                                                                                                                                                        
                                                                                                                                                    </tr>              
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="1" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ></td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">                                                                                                                                                         
                                                                                                                                                        <td width="100" class="fontarial" style="padding:3px;">Inventory Type</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td >                                                                                                                                                             
                                                                                                                                                            <select name="inv_type" onchange="javascript:cmdOnChange()" class="fontarial" >    
                                                                                                                                                                <option value="0" <%if (invType == 0) {%> selected<%}%> >Value</option>
                                                                                                                                                                <option value="1" <%if (invType == 1) {%> selected<%}%> >Qty</option>                                                                                                                                                                
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>             
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="1" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">                                                                                                                                                         
                                                                                                                                                        <td class="fontarial" style="padding:3px;">Report Type</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td >                                                                                                                                                             
                                                                                                                                                            <select name="grp_type" class="fontarial" >    
                                                                                                                                                                <option value="0" <%if (grpType == 0) {%> selected<%}%> >Category</option>
                                                                                                                                                                <option value="1" <%if (grpType == 1) {%> selected<%}%> >Item Master</option>                                                                                                                                                                
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="1" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="fontarial" style="padding:3px;">Period</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td >
                                                                                                                                                            <table cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>                                                                                                                                                                    
                                                                                                                                                                    <td>
                                                                                                                                                                        <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsalescategory.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                                    </td> 
                                                                                                                                                                    <td>&nbsp;&nbsp;to&nbsp;&nbsp;</td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsalescategory.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                                    </td>                                                                                                                                                       
                                                                                                                                                                </tr>
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>          
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="1" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="fontarial" style="padding:3px;">Location</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td > 
                                                                                                                                                            <%
            Vector vLoc = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
                                                                                                                                                            %>
                                                                                                                                                            <select name="src_location_id" class="fontarial">                                                                              
                                                                                                                                                                <option value="0" <%if (0 == locationId) {%>selected<%}%>>- All Location -</option>
                                                                                                                                                                <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                                                                                <%}
            }%>
                                                                                                                                                            </select>
                                                                                                                                                        </td>                                                                                                                                                       
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="1" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22"> 
                                                                                                                                                        <td  valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr height="24"><td class="fontarial" style="padding:3px;">Category</td></tr></table></td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td >                                                                                                                                                             
                                                                                                                                                            <%
            if (vCategory != null && vCategory.size() > 0) {
                                                                                                                                                            %>
                                                                                                                                                            <table width="800" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <%
                                                                                                                                                                int x = 0;
                                                                                                                                                                boolean ok = true;
                                                                                                                                                                while (ok) {

                                                                                                                                                                    for (int t = 0; t < 4; t++) {
                                                                                                                                                                        ItemGroup ic = new ItemGroup();
                                                                                                                                                                        try {
                                                                                                                                                                            ic = (ItemGroup) vCategory.get(x);
                                                                                                                                                                        } catch (Exception e) {
                                                                                                                                                                            ok = false;
                                                                                                                                                                            ic = new ItemGroup();
                                                                                                                                                                            break;
                                                                                                                                                                        }
                                                                                                                                                                        int o = JSPRequestValue.requestInt(request, "grp" + ic.getOID());
                                                                                                                                                                        if (t == 0) {
                                                                                                                                                                %>
                                                                                                                                                                <tr>
                                                                                                                                                                    <%}%>
                                                                                                                                                                    <td width="5"><input type="checkbox" name="grp<%=ic.getOID()%>" value="1" <%if (o == 1) {%> checked<%}%> ></td>
                                                                                                                                                                    <td class="fontarial"><%=ic.getName()%></td>                                                                                                                                                                    
                                                                                                                                                                    <%if (t == 3) {
                                                                                                                                                                    %>
                                                                                                                                                                </tr>
                                                                                                                                                                <%}%>
                                                                                                                                                                <%
                                                                                                                                                                        x++;
                                                                                                                                                                    }
                                                                                                                                                                }%>
                                                                                                                                                                <tr>
                                                                                                                                                                    <td><input type="checkbox" name="all" value="1" <%if (all == 1) {%> checked <%}%>   onClick="setChecked(this)"></td>
                                                                                                                                                                    <td class="fontarial">SELECT ALL</td>
                                                                                                                                                                </tr>   
                                                                                                                                                            </table>
                                                                                                                                                            <%}%>                                                                                                                                                       
                                                                                                                                                        </td>                                                                                                                                                       
                                                                                                                                                    </tr> 
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="1" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">                                                                                                                                                         
                                                                                                                                                        <td class="fontarial" style="padding:3px;">Filter Item</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td >                                                                                                                                                             
                                                                                                                                                            <select name="filter_by" class="fontarial" >    
                                                                                                                                                                <option value="-1" <%if (filterBy == -1) {%> selected<%}%> >-All-</option>
                                                                                                                                                                <option value="1" <%if (filterBy == 1) {%> selected<%}%> >Aktif</option>
                                                                                                                                                                <option value="0" <%if (filterBy == 0) {%> selected<%}%> >Non Aktif</option>                                                                                                                                                                
                                                                                                                                                                <option value="2" <%if (filterBy == 2) {%> selected<%}%> >Freeze Purchese</option>
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="1" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">                                                                                                                                                         
                                                                                                                                                        <td class="fontarial" style="padding:3px;">Order By</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td >                                                                                                                                                             
                                                                                                                                                            <select name="order_by" class="fontarial" >    
                                                                                                                                                                <option value="0" <%if (orderBy == 0) {%> selected<%}%> >Code</option>
                                                                                                                                                                <option value="1" <%if (orderBy == 1) {%> selected<%}%> >Name</option>                                                                                                                                                                
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="1" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td ></td>
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="4"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="4" height="30">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%
            try {
                if (iJSPCommand == JSPCommand.SEARCH) {
                    int period = 0;
                    try {
                        period = SessReportInventory.getPeriodDate(invEndDate, invStartDate);
                    } catch (Exception e) {}
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="1500" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr height="20">                                                                                                                                             
                                                                                                                                            <td class="tablearialhdr" width="30" rowspan="2">Code</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" nowrap>Category</td>
                                                                                                                                            <%if(grpType == 1){%>
                                                                                                                                            <td class="tablearialhdr" rowspan="2">Sub Category</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2">Sku</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2">Item Name</td>                                                                                                                                            
                                                                                                                                            <%}%>
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2">Begining</td>
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2">Incoming</td>
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2" nowrap>Incoming Adj</td>       
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2">RTV</td>
                                                                                                                                            <td class="tablearialhdr" width="160" colspan="2">Transfer</td>                                                                                                                                            
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2">Costing</td>
                                                                                                                                            <td class="tablearialhdr" width="160" colspan="2">Repack</td>
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2">Shringkage</td>
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2">COGS</td>
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2">Net Sales</td>
                                                                                                                                            <td class="tablearialhdr" width="80" rowspan="2">Ending</td>
                                                                                                                                            <td class="tablearialhdr" width="50" rowspan="2" nowrap>Inv. Turn Over</td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr height="20">                                                                                                                                             
                                                                                                                                            <td class="tablearialhdr" width="80">In</td>
                                                                                                                                            <td class="tablearialhdr" width="80">Out</td>
                                                                                                                                            <td class="tablearialhdr" width="80">Stock Out</td>
                                                                                                                                            <td class="tablearialhdr" width="80">Stock In</td>
                                                                                                                                        </tr>    
                                                                                                                                        <%
                                                                                                                                    CONResultSet crs = null;
                                                                                                                                    int seq = 0;
                                                                                                                                    try {

                                                                                                                                        String wherer = "";
                                                                                                                                        String wherec = "";
                                                                                                                                        String wheret = "";
                                                                                                                                        String wheretout = "";
                                                                                                                                        String wheres = "";
                                                                                                                                        
                                                                                                                                        String grp = "m.item_group_id";
                                                                                                                                        String grp1 = "item_group_id";
                                                                                                                                        
                                                                                                                                        String sql1 = "select g.item_group_id as item_group_id,g.code as code,sum(yprevincoming) as xprevincoming,sum(yprevincoming_ajustment) as xprevincoming_ajustment,sum(yprevretur) as xprevretur,sum(yprevcosting) as xprevcosting,sum(yprevtransfer_in) as xprevtransfer_in,sum(yprevtransfer_out) as xprevtransfer_out,sum(yprevrepack_in) as xprevrepack_in,sum(yprevrepack_out) as xprevrepack_out,sum(yprevsales) as xprevsales,sum(yprevcogs) as xprevcogs,sum(yprevadjustment) as xprevadjustment,sum(yincoming) as xincoming,sum(yincoming_ajustment) as xincoming_ajustment,sum(yretur) as xretur,sum(ycosting) as xcosting,sum(ytransfer_in) as xtransfer_in,sum(ytransfer_out) as xtransfer_out,sum(yrepack_in) as xrepack_in,sum(yrepack_out) as xrepack_out,sum(ysales) as xsales,sum(ycogs) as xcogs,sum(yadjustment) as xadjustment from ( ";
                                                                                                                                        String sql2 = "item_group_id";
                                                                                                                                        if(grpType == 0){
                                                                                                                                            grp = "m.item_group_id";
                                                                                                                                            grp1 = "item_group_id";
                                                                                                                                            sql1 = "select g.item_group_id as item_group_id,g.code as code,item_category_id,sum(yprevincoming) as xprevincoming,sum(yprevincoming_ajustment) as xprevincoming_ajustment,sum(yprevretur) as xprevretur,sum(yprevcosting) as xprevcosting,sum(yprevtransfer_in) as xprevtransfer_in,sum(yprevtransfer_out) as xprevtransfer_out,sum(yprevrepack_in) as xprevrepack_in,sum(yprevrepack_out) as xprevrepack_out,sum(yprevsales) as xprevsales,sum(yprevcogs) as xprevcogs,sum(yprevadjustment) as xprevadjustment,sum(yincoming) as xincoming,sum(yincoming_ajustment) as xincoming_ajustment,sum(yretur) as xretur,sum(ycosting) as xcosting,sum(ytransfer_in) as xtransfer_in,sum(ytransfer_out) as xtransfer_out,sum(yrepack_in) as xrepack_in,sum(yrepack_out) as xrepack_out,sum(ysales) as xsales,sum(ycogs) as xcogs,sum(yadjustment) as xadjustment from ( ";
                                                                                                                                            sql2 = " ) y inner join pos_item_group g on y.item_group_id = g.item_group_id group by g.item_group_id ";
                                                                                                                                            
                                                                                                                                            if(orderBy == 0){
                                                                                                                                                sql2 = sql2 + " order by g.code ";
                                                                                                                                            }else{
                                                                                                                                                sql2 = sql2 + " order by g.name ";
                                                                                                                                            }
                                                                                                                                        }else{
                                                                                                                                            grp = "m.item_master_id";
                                                                                                                                            grp1 = "item_master_id";
                                                                                                                                            sql1 = "";
                                                                                                                                            sql2 = "";
                                                                                                                                            
                                                                                                                                            if(orderBy == 0){
                                                                                                                                                sql2 = sql2 + " order by sku ";
                                                                                                                                            }else{
                                                                                                                                                sql2 = sql2 + " order by item_name ";
                                                                                                                                            }
                                                                                                                                        }

                                                                                                                                        if (locationId != 0) {
                                                                                                                                            wherer = " and r.location_id = " + locationId;
                                                                                                                                            wherec = " and c.location_id = " + locationId;
                                                                                                                                            wheret = " and t.to_location_id = " + locationId;
                                                                                                                                            wheretout = " and t.from_location_id = " + locationId;
                                                                                                                                            wheres = " and s.location_id = " + locationId;
                                                                                                                                        }
                                                                                                                                        
                                                                                                                                        String whereGroup = "";
                                                                                                                                        if (whereGrp != null && whereGrp.length() > 0) {
                                                                                                                                            whereGroup = " and m.item_group_id in (" + whereGrp + ")";
                                                                                                                                        }
                                                                                                                                        
                                                                                                                                        if(filterBy != -1){                    
                                                                                                                                            if(filterBy==2){
                                                                                                                                                whereGroup = whereGroup +" and m.for_buy = "+0;
                                                                                                                                            }else{
                                                                                                                                                if(filterBy==1){
                                                                                                                                                    whereGroup = whereGroup +" and m.is_active = "+filterBy+" and m.for_buy = "+1;
                                                                                                                                                }else{
                                                                                                                                                    whereGroup = whereGroup +" and m.is_active = "+filterBy;
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }

                                                                                                                                        String sql = sql1+" select item_name,sku,item_master_id,item_group_id,item_category_id,sum(previncoming) as yprevincoming,sum(previncoming_ajustment) as yprevincoming_ajustment,sum(prevretur) as yprevretur,sum(prevcosting) as yprevcosting,sum(prevtransfer_in) as yprevtransfer_in,sum(prevtransfer_out) as yprevtransfer_out,sum(prevrepack_in) as yprevrepack_in,sum(prevrepack_out) as yprevrepack_out,sum(prevsales) as yprevsales,sum(prevcogs) as yprevcogs,sum(prevadjustment) as yprevadjustment,sum(incoming) as yincoming,sum(incoming_ajustment) as yincoming_ajustment,sum(retur) as yretur,sum(costing) as ycosting,sum(transfer_in) as ytransfer_in,sum(transfer_out) as ytransfer_out,sum(repack_in) as yrepack_in,sum(repack_out) as yrepack_out,sum(sales) as ysales,sum(cogs) as ycogs,sum(adjustment) as yadjustment from ( " +                                                                                                                                                
                                                                                                                                                //pos_receive
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,sum(ri.qty) as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id " +
                                                                                                                                                " where r.type_ap = 0 and r.status in ('APPROVED','CHECKED') and r.approval_1_date < ('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00') "+wherer+" "+whereGroup+" group by "+grp+" union " +    
                                                                                                                                                
                                                                                                                                                //pos_rec_adj
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,sum(ri.qty) as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id " +
                                                                                                                                                " where r.type_ap = 3 and r.status in ('APPROVED','CHECKED') and r.approval_1_date < ('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00') "+wherer+" "+whereGroup+" group by "+grp+" union " +                                                                                                                                                 
                                                                                                                                                
                                                                                                                                                //pos_retur
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,sum(ri.qty) as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_retur r inner join pos_retur_item ri on r.retur_id = ri.retur_id inner join pos_item_master m on ri.item_master_id = m.item_master_id " +
                                                                                                                                                " where r.status in ('APPROVED','POSTED') and r.approval_1_date < ('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00') "+wherer+" "+whereGroup+" group by "+grp+" union " +   
                                                                                                                                                
                                                                                                                                                //costing
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,sum(ci.qty) as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_costing c inner join pos_costing_item ci on c.costing_id = ci.costing_id inner join pos_item_master m on ci.item_master_id = m.item_master_id where c.status in ('APPROVED','POSTED') " + wherec + " and to_days(c.effective_date) < to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                
                                                                                                                                                //pos_transfer
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,sum(ti.qty) as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_transfer t inner join pos_transfer_item ti on t.transfer_id = ti.transfer_id inner join pos_item_master m on ti.item_master_id = m.item_master_id where t.status = 'APPROVED' " + wheret + " and to_days(t.approval_1_date) < to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,sum(ti.qty) as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_transfer t inner join pos_transfer_item ti on t.transfer_id = ti.transfer_id inner join pos_item_master m on ti.item_master_id = m.item_master_id where t.status = 'APPROVED' " + wheretout + " and to_days(t.approval_1_date) < to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                
                                                                                                                                                //pos_repack
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,sum(ri.qty) as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_repack r inner join pos_repack_item ri on r.repack_id = ri.repack_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.type = 0 " + wherer + " and to_days(r.effective_date) < to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and r.status in ('APPROVED','POSTED') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,sum(ri.qty) as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_repack r inner join pos_repack_item ri on r.repack_id = ri.repack_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.type = 1 " + wherer + " and to_days(r.effective_date) < to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and r.status in ('APPROVED','POSTED') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                
                                                                                                                                                //pos_sales                                                                                                                                                
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,sum(s.qty * s.in_out *-1 ) as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs ,0 as prevadjustment,0 as adjustment from pos_stock s inner join pos_item_master m on s.item_master_id = m.item_master_id where s.status= 'APPROVED' and s.type=7 " + wheres + " and to_days(s.date) < to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                
                                                                                                                                                //pos_adjustment
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,sum(qty_balance) as prevadjustment,0 as adjustment from pos_adjusment r inner join pos_adjusment_item ai on r.adjusment_id = ai.adjusment_id inner join pos_item_master m on ai.item_master_id = m.item_master_id where r.status in ('APPROVED','POSTED') "+ wherer +" and to_days(approval_1_date) < to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union "+
                                                                                                                                                
                                                                                                                                                //pos_receive
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,sum(ri.qty) as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id " +
                                                                                                                                                " where r.type_ap = 0 and r.status in ('APPROVED','CHECKED') and r.approval_1_date between ('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00') and ('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59') "+wherer+" "+whereGroup+" group by "+grp+" union " +    
                                                                                                                                                                                                                                                                                                
                                                                                                                                                //incoming_adj
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,sum(ri.qty) as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id " +
                                                                                                                                                " where r.type_ap = 3 and r.status in ('APPROVED','CHECKED') and r.approval_1_date between ('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00') and ('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59') "+wherer+" "+whereGroup+" group by "+grp+" union " +                                                                                                                                                    
                                                                                                                                                
                                                                                                                                                //pos_retur                                                                                                                                                
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,sum(ri.qty) as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_retur r inner join pos_retur_item ri on r.retur_id = ri.retur_id inner join pos_item_master m on ri.item_master_id = m.item_master_id " +
                                                                                                                                                " where r.status in ('APPROVED','POSTED') and r.approval_1_date between ('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00') and ('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59') "+wherer+" "+whereGroup+" group by "+grp+" union " +   
                                                                                                                                                
                                                                                                                                                //costing
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,sum(ci.qty) as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_costing c inner join pos_costing_item ci on c.costing_id = ci.costing_id inner join pos_item_master m on ci.item_master_id = m.item_master_id where c.status in ('APPROVED','POSTED') " + wherec + " and to_days(c.effective_date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(c.effective_date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                
                                                                                                                                                //pos_transfer
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,sum(ti.qty) as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_transfer t inner join pos_transfer_item ti on t.transfer_id = ti.transfer_id inner join pos_item_master m on ti.item_master_id = m.item_master_id where t.status = 'APPROVED' " + wheret + " and to_days(t.approval_1_date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(t.approval_1_date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,sum(ti.qty) as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_transfer t inner join pos_transfer_item ti on t.transfer_id = ti.transfer_id inner join pos_item_master m on ti.item_master_id = m.item_master_id where t.status = 'APPROVED' " + wheretout + " and to_days(t.approval_1_date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(t.approval_1_date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                
                                                                                                                                                //pos_repack
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,sum(ri.qty) as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_repack r inner join pos_repack_item ri on r.repack_id = ri.repack_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.type = 0 " + wherer + " and to_days(r.effective_date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(r.effective_date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and r.status in ('APPROVED','POSTED') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,sum(ri.qty) as repack_out,0 as sales,0 as cogs,0 as prevadjustment,0 as adjustment from pos_repack r inner join pos_repack_item ri on r.repack_id = ri.repack_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.type = 1 " + wherer + " and to_days(r.effective_date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(r.effective_date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and r.status in ('APPROVED','POSTED') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                
                                                                                                                                                //pos_sales                                                                                                                                                
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,sum(s.qty * s.in_out * -1) as sales,0 as cogs ,0 as prevadjustment,0 as adjustment from pos_stock s inner join pos_item_master m on s.item_master_id = m.item_master_id where s.status= 'APPROVED' and s.type=7 " + wheres + " and to_days(s.date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(s.date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" union " +
                                                                                                                                                
                                                                                                                                                //pos_adjustment
                                                                                                                                                " select m.name as item_name,m.code as sku,m.item_master_id as item_master_id,m.item_group_id as item_group_id,m.item_category_id as item_category_id,0 as previncoming,0 as previncoming_ajustment,0 as prevretur,0 as prevcosting,0 as prevtransfer_in,0 as prevtransfer_out,0 as prevrepack_in,0 as prevrepack_out,0 as prevsales,0 as prevcogs,0 as incoming,0 as incoming_ajustment,0 as retur,0 as costing,0 as transfer_in,0 as transfer_out,0 as repack_in,0 as repack_out,0 as sales,0 as cogs,0 as prevadjustment,sum(qty_balance) as adjustment from pos_adjusment r inner join pos_adjusment_item ai on r.adjusment_id = ai.adjusment_id inner join pos_item_master m on ai.item_master_id = m.item_master_id where r.status in ('APPROVED','POSTED') "+ wherer +" and to_days(approval_1_date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(approval_1_date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') " + whereGroup + " group by "+grp+" "+
                                                                                                                                                
                                                                                                                                                " ) as x group by "+grp1+ " "+sql2;

                                                                                                                                        crs = CONHandler.execQueryResult(sql);
                                                                                                                                        ResultSet rs = crs.getResultSet();

                                                                                                                                        double totBegining = 0;
                                                                                                                                        double totReceiving = 0;
                                                                                                                                        double totRecAdj = 0;
                                                                                                                                        double totRtv = 0;
                                                                                                                                        double totTrfIn = 0;
                                                                                                                                        double totTrfOut = 0;
                                                                                                                                        double totCost = 0;
                                                                                                                                        double totRpc = 0;
                                                                                                                                        double totRpcOut = 0;
                                                                                                                                        double totAdj = 0;
                                                                                                                                        double totCogs = 0;
                                                                                                                                        double totSales = 0;
                                                                                                                                        double totEnd = 0;
                                                                                                                                        double totTurnOver = 0;

                                                                                                                                        while (rs.next()) {
                                                                                                                                            
                                                                                                                                            long gId = rs.getLong("item_group_id");
                                                                                                                                            long categoryId = rs.getLong("item_category_id");
                                                                                                                                            long idx = gId;
                                                                                                                                            String itemName = "";
                                                                                                                                            if(grpType == 1){
                                                                                                                                                itemName = rs.getString("item_name");
                                                                                                                                                idx = rs.getLong("item_master_id");
                                                                                                                                            }
                                                                                                                                            
                                                                                                                                            double begining = 0;                                                                                                                                            
                                                                                                                                            double prevreceiving = 0;
                                                                                                                                            double prevrecAdj =0;
                                                                                                                                            double prevrtv = 0;
                                                                                                                                            double prevCosting = 0;
                                                                                                                                            double prevTransferIn = 0;
                                                                                                                                            double prevTransferOut = 0;
                                                                                                                                            double prevRepack = 0;
                                                                                                                                            double prevRepackOut = 0;
                                                                                                                                            double prevSales = 0;
                                                                                                                                            double prevCogs = 0;
                                                                                                                                            double prevAdjustment = 0;
                                                                                                                                            String sku = "";
                                                                                                                                            
                                                                                                                                            if(grpType == 0){
                                                                                                                                                    prevreceiving = rs.getDouble("xprevincoming");
                                                                                                                                                    prevrecAdj =rs.getDouble("xprevincoming_ajustment");                                                                                                                                            
                                                                                                                                                    prevrtv = rs.getDouble("xprevretur");
                                                                                                                                                    prevCosting = rs.getDouble("xprevcosting");
                                                                                                                                                    prevTransferIn = rs.getDouble("xprevtransfer_in");
                                                                                                                                                    prevTransferOut = rs.getDouble("xprevtransfer_out");
                                                                                                                                                    prevRepack = rs.getDouble("xprevrepack_in");
                                                                                                                                                    prevRepackOut = rs.getDouble("xprevrepack_out");                                                                                                                                            
                                                                                                                                                    prevSales = rs.getDouble("xprevsales");
                                                                                                                                                    prevCogs = rs.getDouble("xprevcogs");
                                                                                                                                                    prevAdjustment = rs.getDouble("xprevadjustment");
                                                                                                                                            }else{
                                                                                                                                                    prevreceiving = rs.getDouble("yprevincoming");
                                                                                                                                                    prevrecAdj =rs.getDouble("yprevincoming_ajustment");                                                                                                                                            
                                                                                                                                                    prevrtv = rs.getDouble("yprevretur");
                                                                                                                                                    prevCosting = rs.getDouble("yprevcosting");
                                                                                                                                                    prevTransferIn = rs.getDouble("yprevtransfer_in");
                                                                                                                                                    prevTransferOut = rs.getDouble("yprevtransfer_out");
                                                                                                                                                    prevRepack = rs.getDouble("yprevrepack_in");
                                                                                                                                                    prevRepackOut = rs.getDouble("yprevrepack_out");                                                                                                                                            
                                                                                                                                                    prevSales = rs.getDouble("yprevsales");
                                                                                                                                                    prevCogs = rs.getDouble("yprevcogs");
                                                                                                                                                    prevAdjustment = rs.getDouble("yprevadjustment");
                                                                                                                                                    sku = rs.getString("sku");
                                                                                                                                            }
                                                                                                                                            
                                                                                                                                            begining = prevreceiving + prevrecAdj - prevrtv - prevCosting + prevTransferIn - prevTransferOut - prevRepack + prevRepackOut + prevAdjustment - prevSales;
                                                                                                                                            
                                                                                                                                            
                                                                                                                                            ItemGroup ig = new ItemGroup();
                                                                                                                                            ItemCategory ic = new ItemCategory();
                                                                                                                                            try{
                                                                                                                                                ig = getGroup(gId);
                                                                                                                                            }catch(Exception e){}
                                                                                                                                            String code = ig.getCode();
                                                                                                                                            String name = ig.getName();
                                                                                                                                            
                                                                                                                                            String nameCategory = "";
                                                                                                                                            try{
                                                                                                                                                ic = getCategory(categoryId);
                                                                                                                                                nameCategory = ic.getName();
                                                                                                                                            }catch(Exception e){}
                                                                                                                                            
                                                                                                                                            double receiving = 0;
                                                                                                                                            double recAdj = 0;
                                                                                                                                            double rtv = 0;
                                                                                                                                            double trvIn = 0;
                                                                                                                                            double trvOut = 0;
                                                                                                                                            double cost = 0;
                                                                                                                                            double repack = 0;
                                                                                                                                            double repackOut = 0;
                                                                                                                                            double adj = 0;
                                                                                                                                            
                                                                                                                                            if(grpType == 0){
                                                                                                                                                receiving = rs.getDouble("xincoming");
                                                                                                                                                recAdj =rs.getDouble("xincoming_ajustment");
                                                                                                                                                rtv = rs.getDouble("xretur");
                                                                                                                                                trvIn = rs.getDouble("xtransfer_in");
                                                                                                                                                trvOut = rs.getDouble("xtransfer_out");                                                                                                                                            
                                                                                                                                                cost = rs.getDouble("xcosting");                                                                                                                                            
                                                                                                                                                repack = rs.getDouble("xrepack_in");
                                                                                                                                                repackOut = rs.getDouble("xrepack_out");
                                                                                                                                                adj = rs.getDouble("xadjustment");
                                                                                                                                            }else{
                                                                                                                                                receiving = rs.getDouble("yincoming");
                                                                                                                                                recAdj =rs.getDouble("yincoming_ajustment");
                                                                                                                                                rtv = rs.getDouble("yretur");
                                                                                                                                                trvIn = rs.getDouble("ytransfer_in");
                                                                                                                                                trvOut = rs.getDouble("ytransfer_out");                                                                                                                                            
                                                                                                                                                cost = rs.getDouble("ycosting");                                                                                                                                            
                                                                                                                                                repack = rs.getDouble("yrepack_in");
                                                                                                                                                repackOut = rs.getDouble("yrepack_out");
                                                                                                                                                adj = rs.getDouble("yadjustment");
                                                                                                                                            }
                                                                                                                                                
                                                                                                                                            String style = "";
                                                                                                                                            if (seq % 2 == 0) {
                                                                                                                                                style = "tablearialcell";
                                                                                                                                            } else {
                                                                                                                                                style = "tablearialcell1";
                                                                                                                                            }
                                                                                                                                            
                                                                                                                                            double sales = 0;
                                                                                                                                            double cogs = 0;
                                                                                                                                            
                                                                                                                                            if(grpType == 0){
                                                                                                                                                sales = rs.getDouble("xsales");
                                                                                                                                                cogs = sales;
                                                                                                                                            }else{
                                                                                                                                                sales = rs.getDouble("ysales");
                                                                                                                                                cogs = sales;
                                                                                                                                            }
                                                                                                                                            

                                                                                                                                            double ending = begining + receiving + recAdj - rtv + trvIn - trvOut - cost - repack + repackOut + adj - cogs;
                                                                                                                                            double turnOfer = 0;
                                                                                                                                            if (sales != 0) {
                                                                                                                                                turnOfer = (ending / sales) * period;
                                                                                                                                            }
                                                                                                                                            
                                                                                                                                            totBegining = totBegining + begining;
                                                                                                                                            totReceiving = totReceiving + receiving;
                                                                                                                                            totRecAdj = totRecAdj + recAdj;
                                                                                                                                            totRtv = totRtv + rtv;
                                                                                                                                            totTrfIn = totTrfIn + trvIn;
                                                                                                                                            totTrfOut = totTrfOut + trvOut;
                                                                                                                                            totCost = totCost + cost;
                                                                                                                                            totRpc = totRpc + repack;
                                                                                                                                            totRpcOut = totRpcOut + repackOut;
                                                                                                                                            totAdj = totAdj + adj;
                                                                                                                                            totCogs = totCogs + cogs;
                                                                                                                                            totSales = totSales + sales;
                                                                                                                                            totEnd = totEnd + ending;
                                                                                                                                            totTurnOver = totTurnOver + turnOfer;

                                                                                                                                            InvReport iReport = new InvReport();
                                                                                                                                            iReport.setCode(code);
                                                                                                                                            iReport.setSectionName(name);
                                                                                                                                            iReport.setCodeClass(nameCategory); 
                                                                                                                                            iReport.setSku(sku);
                                                                                                                                            iReport.setDesription(itemName);
                                                                                                                                            iReport.setBegining(begining);
                                                                                                                                            iReport.setReceiving(receiving);
                                                                                                                                            iReport.setReceivingAdjustment(recAdj);
                                                                                                                                            iReport.setRtv(rtv);
                                                                                                                                            iReport.setTransferIn(trvIn);
                                                                                                                                            iReport.setTransferOut(trvOut);
                                                                                                                                            iReport.setCosting(cost);
                                                                                                                                            iReport.setMutation(repack);
                                                                                                                                            iReport.setRepackOut(repackOut);
                                                                                                                                            iReport.setStockAdjustment(adj);
                                                                                                                                            iReport.setCogs(cogs);
                                                                                                                                            iReport.setNetSales(sales);
                                                                                                                                            iReport.setEnding(ending);
                                                                                                                                            iReport.setTurnOvr(turnOfer);
                                                                                                                                            result.add(iReport);
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="<%=style%>" align="center"><%=code%></td>                                                                                                                                            
                                                                                                                                            <td class="<%=style%>" style="padding:3px;" nowrap><%=name%></td>
                                                                                                                                            <%if(grpType == 1){%>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;" nowrap><%=nameCategory%></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;" nowrap><%=sku%></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;" nowrap><%=itemName %></td>
                                                                                                                                            
                                                                                                                                            <%}%>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(begining, "#,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(receiving, "#,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(recAdj, "#,###.##") %></td>                                                                                    
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(rtv, "#,###.##") %></td>   
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(trvIn, "#,###.##") %></td>   
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(trvOut, "#,###.##") %></td>   
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(cost, "#,###.##") %></td>  
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(repack, "#,###.##") %></td>  
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(repackOut, "#,###.##") %></td>                                                                                                                                            
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(adj, "#,###.##") %></td>   
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(cogs, "#,###.##") %></td> 
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(sales, "#,###.##") %></td> 
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(ending, "#,###.##") %></td> 
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(turnOfer, "#,###.##") %></td>                                                                                                                                             
                                                                                                                                        </tr>                                                                                                                                         
                                                                                                                                        <%
                                                                                                                                                seq++;
                                                                                                                                            }%>
                                                                                                                                        <%
                                                                                                                                            if (seq > 0) {
                                                                                                                                                resultXLS.add(result);
                                                                                                                                                resultXLS.add(rParameter);
                                                                                                                                                session.putValue("REPORT_INVENTORY_STOCK_SUMMARY", resultXLS);
                                                                                                                                                
                                                                                                                                                double totTurnOfer = 0;
                                                                                                                                                if(totSales != 0){
                                                                                                                                                    totTurnOfer = (totEnd * period)/totSales;
                                                                                                                                                }
                                                                                                                                                
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <%if(grpType == 1){%>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" colspan="5" align="center"><b>GRAND TOTAL</b></td>  
                                                                                                                                            <%}else{%>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" colspan="2" align="center"><b>GRAND TOTAL</b></td>  
                                                                                                                                            <%}%>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totBegining, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totReceiving, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totRecAdj, "#,###.##") %></b></td>                                                                                    
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totRtv, "#,###.##") %></b></td>    
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totTrfIn, "#,###.##") %></b></td>    
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totTrfOut, "#,###.##") %></b></td>    
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totCost, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totRpc, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totRpcOut, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totAdj, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totCogs, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totSales, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totEnd, "#,###.##") %></b></td>
                                                                                                                                            <td class="fontarial" bgcolor="#CCCCCC" align="right" style="padding:3px;"></td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="4">&nbsp;</td>
                                                                                                                                        </tr>    
                                                                                                                                        <%if(privPrint){%>
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="4">                                                                                                                                                 
                                                                                                                                                <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                            </td>     
                                                                                                                                        </tr>    
                                                                                                                                        <%}%>
                                                                                                                                        <%}else{%>
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" class="fontarial" colspan="4"><i>Data not found</i></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%}%>
                                                                                                                                        <%} catch (Exception e) {
                                                                                                                                    }
                                                                                                                                        %>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            
                                                                                                                            <%  } else {%>
                                                                                                                            <tr align="left" valign="top">                                                                                                                                 
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial">&nbsp;</td>
                                                                                                                            </tr>    
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <%if (iJSPCommand == JSPCommand.SEARCH) {%>
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial"><i>Data not found..</i></td>
                                                                                                                                <%} else {%>
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial"><i>Click serach buton to seraching the data..</i></td>
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <%}
            } catch (Exception exc) {
            }%>                                                                                                             
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3"></td>
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
