
<%-- 
    Document   : incomingbyitem
    Created on : Aug 10, 2015, 10:06:51 AM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.* " %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_INCOMING_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_INCOMING_REPORT, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_INCOMING_REPORT, AppMenu.PRIV_PRINT);            
%>
<!-- Jsp Block -->
<%
            if (session.getValue("PARAMETER_INCOMING_ITEM") != null) {
                session.removeValue("PARAMETER_INCOMING_ITEM");
            }

            if (session.getValue("DETAIL_INCOMING_ITEM") != null) {
                session.removeValue("DETAIL_INCOMING_ITEM");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");            
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            
            String srcStartApp = JSPRequestValue.requestString(request, "src_start_date_app");
            String srcEndApp = JSPRequestValue.requestString(request, "src_end_date_app");
            
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            int srcIgnoreApp = JSPRequestValue.requestInt(request, "src_ignore_app");
            
            int all = JSPRequestValue.requestInt(request, "all");

            Date srcStartDate = new Date();
            Date srcEndDate = new Date();
            
            Date srcStartDateApp = new Date();
            Date srcEndDateApp = new Date();            
            
            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }
            
            if(iJSPCommand== JSPCommand.NONE){
                srcIgnoreApp = 1;
            }
            
            if(srcIgnoreApp==0){
                srcStartDateApp = JSPFormater.formatDate(srcStartApp, "dd/MM/yyyy");
                srcEndDateApp = JSPFormater.formatDate(srcEndApp, "dd/MM/yyyy");
            }

            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");

            Vector vCategory = DbItemGroup.list(0, 0, "", "" + DbItemGroup.colNames[DbItemGroup.COL_NAME]);
            String whereGrp = "";
            String strGrp = "";

            if (vCategory != null && vCategory.size() > 0) {
                for (int i = 0; i < vCategory.size(); i++) {
                    ItemGroup ic = (ItemGroup) vCategory.get(i);
                    int ok = JSPRequestValue.requestInt(request, "grp" + ic.getOID());
                    if (ok == 1) {
                        if (whereGrp != null && whereGrp.length() > 0) {
                            whereGrp = whereGrp + ",";
                            strGrp = strGrp + "/";
                        }
                        whereGrp = whereGrp + ic.getOID();
                        strGrp = strGrp + ic.getName();
                    }
                }
            }

            Vector vpar = new Vector();
            vpar.add("" + srcLocationId);            
            vpar.add("" + srcIgnore);
            vpar.add("" + JSPFormater.formatDate(srcStartDate, "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(srcEndDate, "dd/MM/yyyy"));
            vpar.add("" + srcStatus);
            vpar.add("" + srcCode);
            vpar.add("" + srcName);
            vpar.add("" + user.getFullName());
            vpar.add("" + strGrp);

            Vector print = new Vector();
            
            Hashtable hashLocation = new Hashtable();
            Vector locationsx = DbLocation.list(0, 0, "",null);
            if(locationsx != null && locationsx.size() > 0){
                for(int i = 0 ; i < locationsx.size() ; i++){
                    Location l = (Location)locationsx.get(i);
                    hashLocation.put(String.valueOf(l.getOID()), l.getName());
                }
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RptIncomingItemXLS?user_id=<%=appSessUser.getUserOID()%>");
                }
                
                function setChecked(val){
                 <%
            for (int k = 0; k < vCategory.size(); k++) {
                ItemGroup ic = (ItemGroup) vCategory.get(k);
                %>
                    document.frmadjusment.grp<%=ic.getOID()%>.checked=val.checked;
                    
                    <%}%>
                }
                
                function cmdSearch(){
                    document.frmadjusment.command.value="<%=JSPCommand.LIST%>";                    
                    document.frmadjusment.action="incomingbyitem.jsp";
                    document.frmadjusment.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif','../images/print2.gif')">
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
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmadjusment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Report 
                                                                                        </font><font class="tit1">&raquo; 
                                                                                <span class="lvl2">Incoming By Item</span></font></b></td>
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
                                                                                <td height="5"  colspan="3"></td>
                                                                            </tr>
                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td  class="fontarial" colspan="4"><b><i>Search Parameters :</i></b></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%
            Vector locations = userLocations;
                                                                                                    %>
                                                                                                    <tr height="23"> 
                                                                                                        <td width="100" class="tablearialcell1">&nbsp;&nbsp;From Location</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td width="300"> 
                                                                                                            <select name="src_location_id">
                                                                                                                <%if (locations.size() == totLocationxAll) {%>
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>- All Location -</option>
                                                                                                                <%}%>
                                                                                                                <%


            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Date Create</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td >&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                    <td ><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>>Ignored</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Document Status </td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td class="fontarial"> <i>Approved, Checked</i></td>
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Date Approved</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input name="src_start_date_app" value="<%=JSPFormater.formatDate((srcStartDateApp == null) ? new Date() : srcStartDateApp, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date_app);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td >&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                    <td ><input name="src_end_date_app" value="<%=JSPFormater.formatDate((srcEndDateApp == null) ? new Date() : srcEndDateApp, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date_app);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td><input type="checkbox" name="src_ignore_app" value="1" <%if (srcIgnoreApp == 1) {%>checked<%}%>>Ignored</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;SKU</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <input type="text" name="src_code" value="<%=srcCode%>" class="fontarial">
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Item Name</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <input type="text" name="src_name" size="20" value="<%=srcName%>" class="fontarial">
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablearialcell1" valign="top">&nbsp;&nbsp;Category</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td colspan="4">                                                                                                             
                                                                                                            <%
            if (vCategory != null && vCategory.size() > 0) {
                                                                                                            %>
                                                                                                            <table width="700" border="0" cellpadding="0" cellspacing="0">
                                                                                                                <%
                                                                                                                int x = 0;
                                                                                                                boolean ok = true;
                                                                                                                while (ok) {

                                                                                                                    for (int t = 0; t < 3; t++) {
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
                                                                                                                    <%if (t == 2) {
                                                                                                                    %>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%
                                                                                                                        x++;
                                                                                                                    }
                                                                                                                }%>
                                                                                                                <tr>
                                                                                                                    <td><input type="checkbox" name="all" value="1" <%if (all == 1) {%> checked <%}%>   onClick="setChecked(this)"></td>
                                                                                                                    <td>ALL CATEGORY</td>
                                                                                                                </tr>   
                                                                                                            </table>
                                                                                                            <%}%>     
                                                                                                        </td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="6">
                                                                                                            <table width="80%" border="0" cellspacing="0" cellpadding="0">                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td height="2" background="../images/line1.gif" ><img src="../images/line1.gif"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        <td colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr height="40">
                                                                                                        <td colspan="6">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

            if (iJSPCommand == JSPCommand.LIST) {
                CONResultSet dbrs = null;
                try {

                    String where1 = "";
                    String where = "";
                    String where2 = "";
                    
                    if (srcLocationId != 0) {
                        where1 = where1 + " and r." + DbReceive.colNames[DbReceive.COL_LOCATION_ID] + " = " + srcLocationId;
                        where = where + " and r." + DbReceive.colNames[DbReceive.COL_LOCATION_ID] + " = " + srcLocationId;
                        where2 = where2 + " and rc." + DbReceive.colNames[DbReceive.COL_LOCATION_ID] + " = " + srcLocationId;
                    }

                    if (srcIgnore == 0) {
                        where1 = where1 + " and r." + DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' ";
                        where = where + " and r." + DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' ";
                        where2 = where2 + " and rc." + DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' ";
                    }
                    
                    if (srcIgnoreApp == 0) {
                        where1 = where1 + " and r." + DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE] + " between '" + JSPFormater.formatDate(srcStartDateApp, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDateApp, "yyyy-MM-dd") + " 23:59:59' ";
                        where = where + " and r." + DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE] + " between '" + JSPFormater.formatDate(srcStartDateApp, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDateApp, "yyyy-MM-dd") + " 23:59:59' ";
                        where2 = where2 + " and rc." + DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE] + " between '" + JSPFormater.formatDate(srcStartDateApp, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDateApp, "yyyy-MM-dd") + " 23:59:59' ";
                    }

                    if (srcCode != null && srcCode.length() > 0) {
                        where = where + " and m." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode.trim() + "%'";
                        where2 = where2 + " and m." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode.trim() + "%'";
                    }

                    if (srcName != null && srcName.length() > 0) {
                        where = where + " and m." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName.trim() + "%'";
                        where2 = where2 + " and m." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName.trim() + "%'";
                    }

                    if (whereGrp != null && whereGrp.length() > 0) {
                        where = where + " and m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " in (" + whereGrp + ")";
                        where2 = where2 + " and m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " in (" + whereGrp + ")";
                    }

                    String sql ="select rc.number as number,rc.location_id as location_id,rc.date as date,rc.approval_1_date as approval_1_date,m.code as code,m.barcode as barcode,m.name as item_name,ri.qty as qty,ri.amount as price,ri.discount_amount as discount_amount,(discount_percent*total_amount/100) as discount_global,sum(round(total_amount - (discount_percent*total_amount/100),2)) as incoming "+
                                " from ( "+
                                " select r.receive_id,r.location_id,r.date,r.approval_1_date,r.number,ri.receive_item_id,ri.item_master_id,round(r.discount_total/sum(ri.total_amount)*100,2) as discount_percent from ( "+
                                " select r.* from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where r.type_ap = 0 and r.status in ('APPROVED','CHECKED') and m.item_category_id != 0 "+where+" group by r.receive_id ) r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where r.type_ap = 0 and r.status in ('APPROVED','CHECKED') "+where1+" group by r.receive_id) rc "+
                                " inner join pos_receive_item ri on rc.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where m.item_category_id != 0 "+where2+" group by ri.receive_item_id";

                    System.out.println(sql);
                    dbrs = CONHandler.execQueryResult(sql);
                    
                    ResultSet rs = dbrs.getResultSet();
                    int no = 0;
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">
                                                                                                <table width="1200" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr height="24">
                                                                                                        <td width="18" class="tablearialhdr">No</td>
                                                                                                        <td width="160" class="tablearialhdr">Location</td>
                                                                                                        <td width="60" class="tablearialhdr">Date</td>                                                                                                        
                                                                                                        <td width="90" class="tablearialhdr">Number</td>
                                                                                                        <td width="90" class="tablearialhdr">SKU</td>
                                                                                                        <td width="110" class="tablearialhdr">Barcode</td>
                                                                                                        <td class="tablearialhdr">Item Name</td>
                                                                                                        <td width="50" class="tablearialhdr">Qty</td>
                                                                                                        <td width="80" class="tablearialhdr">Unit Price</td>
                                                                                                        <td width="80" class="tablearialhdr">Discount</td>
                                                                                                        <td width="80" class="tablearialhdr">Total</td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                            double grandQty = 0;
                                                                                                            double grandTotal = 0;
                                                                                                            double grandDiscount = 0;                                                                                                            

                                                                                                            while (rs.next()) {

                                                                                                                String location = "";
                                                                                                                String code = rs.getString("code");
                                                                                                                String barcode = rs.getString("barcode");
                                                                                                                String number = rs.getString("number");
                                                                                                                String itemName = rs.getString("item_name");
                                                                                                                Date date = rs.getDate("date");                                                                                                                
                                                                                                                
                                                                                                                long locationId = rs.getLong("location_id");

                                                                                                                double qty = rs.getDouble("qty");
                                                                                                                double price = rs.getDouble("price");
                                                                                                                double discountAmount = rs.getDouble("discount_amount");
                                                                                                                double discountGlobal = rs.getDouble("discount_global");
                                                                                                                double discount = discountAmount + discountGlobal;
                                                                                                                grandDiscount = grandDiscount + discount;
                                                                                                                double total = (qty * price)-discount;
                                                                                                                
                                                                                                                if(locationId != 0){
                                                                                                                    try{
                                                                                                                        location = String.valueOf(hashLocation.get(String.valueOf(locationId)));
                                                                                                                    }catch(Exception e){}
                                                                                                                }
                                                                                                                
                                                                                                                String style = "";
                                                                                                                if (no % 2 == 0) {
                                                                                                                    style = "tablearialcell";
                                                                                                                } else {
                                                                                                                    style = "tablearialcell1";
                                                                                                                }
                                                                                                                no++;
                                                                                                                grandQty = grandQty + qty;
                                                                                                                grandTotal = grandTotal + total;

                                                                                                                Vector tmpPrint = new Vector();
                                                                                                                tmpPrint.add(location);
                                                                                                                tmpPrint.add(code);
                                                                                                                tmpPrint.add(barcode);
                                                                                                                tmpPrint.add(number);
                                                                                                                tmpPrint.add(itemName);
                                                                                                                tmpPrint.add("" + JSPFormater.formatDate(date, "dd/MM/yyyy"));
                                                                                                                tmpPrint.add("" + qty);
                                                                                                                tmpPrint.add("" + price);
                                                                                                                tmpPrint.add("" + discount);
                                                                                                                print.add(tmpPrint);

                                                                                                    %>
                                                                                                    <tr height="23">
                                                                                                        <td align="center" class="<%=style%>" ><%=no%>.</td>
                                                                                                        <td class="<%=style%>" style="padding:3px;"><%=location%></td>
                                                                                                        <td align="center" class="<%=style%>"><%=JSPFormater.formatDate(date, "dd/MM/yyyy") %></td>                                                                                                        
                                                                                                        <td align="center" class="<%=style%>"><%=number%></td>
                                                                                                        <td align="center" class="<%=style%>"><%=code%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px;"><%=barcode%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px;"><%=itemName%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(qty, "###,###.##")%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(price, "###,###.##")%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(discount, "###,###.##")%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(total, "###,###.##")%></td>
                                                                                                    </tr>   
                                                                                                    <%}%>
                                                                                                    <tr height="23">
                                                                                                        <td bgcolor="#BFD8AF" align="center" colspan="7" class="fontarial" ><b>Grand Total</b></td>                                                                                                        
                                                                                                        <td bgcolor="#BFD8AF" align="right" class="fontarial" style="padding:3px;" ><b><%=JSPFormater.formatNumber(grandQty, "###,###.##")%></b></td>
                                                                                                        <td bgcolor="#BFD8AF" style="padding:3px;" colspan="" align="right">&nbsp;</td>
                                                                                                        <td bgcolor="#BFD8AF" class="fontarial" style="padding:3px;" align="right"><b><%=JSPFormater.formatNumber(grandDiscount, "###,###.##")%></b></td>
                                                                                                        <td bgcolor="#BFD8AF" class="fontarial" style="padding:3px;" align="right"><b><%=JSPFormater.formatNumber(grandTotal, "###,###.##")%></b></td>
                                                                                                    </tr>  
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="8" align="left" colspan="10" class="command">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                            if (no > 0) {
                                                                                                                session.putValue("PARAMETER_INCOMING_ITEM", vpar);
                                                                                                                session.putValue("DETAIL_INCOMING_ITEM", print);
                                                                                                                if (privPrint) {
                                                                                                    %>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="8" align="left" colspan="10" class="command"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" border="0"></a></td>
                                                                                                    </tr>
                                                                                                    <%}
                                                                                                            }%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

                                                                                                            rs.close();


                                                                                                        } catch (Exception e) {
                                                                                                        } finally {
                                                                                                            CONResultSet.close(dbrs);
                                                                                                        }
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                                <%
                                                                                                    //Vector x = drawList(listReport, start);
                                                                                                    //String strTampil = (String) x.get(0);
                                                                                                    //Vector rptObj = (Vector) x.get(1);
%>
                                                                                                <%//=strTampil%> 
                                                                                                <%
                                                                                                    //session.putValue("DETAIL", rptObj);
                                                                                                %>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <% }%>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>                                                        
                                                        <!-- #EndEditable -->
                                                    </td>
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
