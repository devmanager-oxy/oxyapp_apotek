
<%-- 
    Document   : repackreportransaction
    Created on : Feb 26, 2015, 12:45:57 PM
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
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.repack.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(Vector objectClass, int start) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("No", "5%");
        cmdist.addHeader("Group", "10%");
        cmdist.addHeader("Code", "10%");
        cmdist.addHeader("Name", "35%");
        cmdist.addHeader("Number Repack", "10%");
        cmdist.addHeader("Qty", "8%");
        cmdist.addHeader("Type", "7%");
        cmdist.addHeader("Location", "15%");


        cmdist.setLinkRow(-1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        Vector temp = new Vector();
        double totalamount = 0.0;
        double totalQty = 0.0;
        for (int i = 0; i < objectClass.size(); i++) {
            RepackReport repackReport = (RepackReport) objectClass.get(i);
            Vector rowx = new Vector();
            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add("<div align=\"left\">" + repackReport.getItemCategoryName() + "</div>");
            rowx.add("<div align=\"left\">" + repackReport.getItemCode() + "</div>");
            rowx.add("<div align=\"left\">" + repackReport.getItemName() + "</div>");
            rowx.add("" + repackReport.getNumber());
            rowx.add("<div align=\"center\">" + JSPFormater.formatNumber(repackReport.getTotalQty(), "###,###.##") + "</div>");

            if (repackReport.getType() == 0) {
                rowx.add("<div align=\"left\">Input</div>");
            } else {
                rowx.add("<div align=\"left\">Output</div>");
            }

            rowx.add("<div align=\"left\">" + repackReport.getLocationName() + "</div>");
            totalQty = totalQty + repackReport.getTotalQty();
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(-1));
        }

        Vector rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);

        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("<div align=\"right\"><b>Total</b></div>");
        rowx.add("<div align=\"center\"><b>" + JSPFormater.formatNumber(totalQty, "###,###.##") + "</b></div>");
        lstData.add(rowx);
        Vector vx = new Vector();
        vx.add(cmdist.draw(index));
        vx.add(temp);
        return vx;
    }

%>
<%
            if (session.getValue("REPORT_REPACK") != null) {
                session.removeValue("REPORT_REPACK");
            }

            if (session.getValue("REPORT_REPACK_PARAMETER") != null) {
                session.removeValue("REPORT_REPACK_PARAMETER");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            String srcNumber = JSPRequestValue.requestString(request, "src_number");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
            }

            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            Vector listReport = new Vector(1, 1);
            SrcRepackReport srcRepackReport = new SrcRepackReport();

            srcRepackReport.setLocationId(srcLocationId);
            srcRepackReport.setFromDate(srcStartDate);
            srcRepackReport.setToDate(srcEndDate);
            srcRepackReport.setIgnoreDate(srcIgnore);
            srcRepackReport.setCode(srcNumber);

            if (iJSPCommand == JSPCommand.LIST) {
                listReport = SessRepack.getTransactionRepack(srcRepackReport);
            }

            Vector vpar = new Vector();
            vpar.add("" + srcLocationId);
            vpar.add("" + srcIgnore);
            vpar.add("" + JSPFormater.formatDate(srcStartDate, "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(srcEndDate, "dd/MM/yyyy"));
            vpar.add("" + srcNumber);
            vpar.add("" + user.getFullName());


            Vector locationxs = DbLocation.listAll();
            Hashtable hlocation = new Hashtable();

            if (locationxs != null && locationxs.size() > 0) {
                for (int x = 0; x < locationxs.size(); x++) {
                    Location l = (Location) locationxs.get(x);
                    hlocation.put("" + l.getOID(), l.getName());
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
            function cmdPrintXLS(){	                       
                window.open("<%=printroot%>.report.ReportRepackXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
                    document.frmadjusment.start.value=0;
                    document.frmadjusment.action="repackreportransaction.jsp";
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
                                                                                <span class="lvl2">Repack Report ( By Transaction )</span></font></b></td>
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
                                                                                <td height="8"  colspan="3" > 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr height="10"> 
                                                                                                        <td width="100"></td>
                                                                                                        <td width="1"></td>
                                                                                                        <td ></td>
                                                                                                        <td width="8%"></td>
                                                                                                        <td width="1"></td>
                                                                                                        <td ></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="6" class="fontarial"><b><i>Search Parameters :</i></b></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Number</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <input type="text" name="src_number" value="<%=srcNumber%>" class="fontarial">
                                                                                                        </td>
                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Date Between</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                             
                                                                                                                    <td classs="fontarial">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                    <td><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>>Ignored</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Location</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td colspan="4"> 
                                                                                                            <select name="src_location_id" class="fontarial">                                                                                                                
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>- All Location-</option>
                                                                                                                <%
            Vector locations = DbLocation.list(0, 0, "", "name");
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName().toUpperCase()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Document Status</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td colspan="4"> 
                                                                                                            <select name="src_status" class="fontarial">
                                                                                                                <%
            if (srcStatus == "") {
                srcRepackReport.setStatus("- All Status -");
            }
                                                                                                                %>
                                                                                                                <option value="" >- All Status-</option>
                                                                                                                <%
            if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {
                srcRepackReport.setStatus(I_Project.DOC_STATUS_DRAFT);
            }
                                                                                                                %>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                <%
            if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {
                srcRepackReport.setStatus(I_Project.DOC_STATUS_APPROVED);
            }
                                                                                                                %>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                <%
            if (srcStatus.equals(I_Project.DOC_STATUS_POSTED)) {
                srcRepackReport.setStatus(I_Project.DOC_STATUS_POSTED);
            }
                                                                                                                %>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_POSTED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_POSTED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_POSTED%></option>                                                                                                                
                                                                                                            </select>
                                                                                                        </td>                                                                                                                                                                
                                                                                                    </tr>
                                                                                                    <tr > 
                                                                                                        <td colspan="6" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="6"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        
                                                                                                    </tr>                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%


            try {

                if (iJSPCommand == JSPCommand.LIST) {

                    if (listReport != null && listReport.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                        <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                                <table width="1150" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td class="tablearialhdr" rowspan="2" width="25">No</td>
                                                                                                        <td class="tablearialhdr" rowspan="2" width="80">Number</td>
                                                                                                        <td class="tablearialhdr" rowspan="2" width="70">Date</td>
                                                                                                        <td class="tablearialhdr" rowspan="2" width="100">User</td>
                                                                                                        <td class="tablearialhdr" rowspan="2" width="150">Location</td>                                                                                                        
                                                                                                        <td class="tablearialhdr" colspan="2" >Qty In</td>
                                                                                                        <td class="tablearialhdr" colspan="2" >Qty Out</td>                                                                                                        
                                                                                                        <td class="tablearialhdr" rowspan="2" width="70">Status</td>
                                                                                                        <td class="tablearialhdr" rowspan="2" >Notes</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablearialhdr" width="50">Qty</td>
                                                                                                        <td class="tablearialhdr" width="100">Amount</td>
                                                                                                        <td class="tablearialhdr" width="50">Qty</td>
                                                                                                        <td class="tablearialhdr" width="100">Amount</td>
                                                                                                    </tr>    
                                                                                                    <%
                                                                                                                for (int i = 0; i < listReport.size(); i++) {
                                                                                                                    Repack r = (Repack) listReport.get(i);

                                                                                                                    String style = "";
                                                                                                                    if (i % 2 == 0) {
                                                                                                                        style = "tablearialcell";
                                                                                                                    } else {
                                                                                                                        style = "tablearialcell1";
                                                                                                                    }

                                                                                                                    User ux = new User();
                                                                                                                    try {
                                                                                                                        ux = DbUser.fetch(r.getUserId());
                                                                                                                    } catch (Exception e) {
                                                                                                                    }

                                                                                                                    String strLocation = "";
                                                                                                                    try {
                                                                                                                        strLocation = String.valueOf(hlocation.get("" + r.getLocationId()));
                                                                                                                    } catch (Exception e) {
                                                                                                                    }
                                                                                                                    
                                                                                                                    RepackItem riInput = new RepackItem();
                                                                                                                    riInput = SessRepack.getQty(r.getOID(), DbRepackItem.TYPE_INPUT);
                                                                                                                    
                                                                                                                    RepackItem riOut = new RepackItem();
                                                                                                                    riOut = SessRepack.getQty(r.getOID(), DbRepackItem.TYPE_OUTPUT);

                                                                                                    %>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="<%=style%>" align="center"><%=(i + 1)%></td> 
                                                                                                        <td class="<%=style%>"><%=r.getNumber()%></td> 
                                                                                                        <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(r.getDate(), "dd-MM-yyyy")%></td> 
                                                                                                        <td class="<%=style%>"><%=ux.getFullName()%></td> 
                                                                                                        <td class="<%=style%>"><%=strLocation%></td> 
                                                                                                        <td class="<%=style%>"><%=JSPFormater.formatNumber(riInput.getQty(),"###,###.##")%></td> 
                                                                                                        <td class="<%=style%>"><%=JSPFormater.formatNumber(riInput.getCogs(),"###,###.##")%></td> 
                                                                                                        <td class="<%=style%>"><%=JSPFormater.formatNumber(riOut.getQty(),"###,###.##")%></td> 
                                                                                                        <td class="<%=style%>"><%=JSPFormater.formatNumber(riOut.getCogs(),"###,###.##")%></td> 
                                                                                                        <td class="<%=style%>" align="center"><font size="1"><%=r.getStatus()%></font></td> 
                                                                                                        <td class="<%=style%>"><%=r.getNote()%></td> 
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
                                                                                                                if (listReport != null && listReport.size() > 0) {
                                                                                                                    session.putValue("REPORT_REPACK_PARAMETER", vpar);
                                                                                                                    session.putValue("REPORT_REPACK", listReport);
                                                                                        %>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="10"> 
                                                                                                <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                            </td>     
                                                                                        </tr> 
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%  } else {%>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="25" align="left" colspan="3" class="fontarial">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i>Data repack transaction not found</td>
                                                                                        </tr>
                                                                                        
                                                                                        <%}
                                                                                                        } else {%>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="25" align="left" colspan="3" class="fontarial">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i>Klik search button to searching the data</td>
                                                                                        </tr>
                                                                                        <%}
            } catch (Exception exc) {
                System.out.println("exc : " + exc.toString());
            }%>
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
