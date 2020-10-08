

<%-- 
    Document   : costarchive
    Created on : Apr 11, 2012, 4:19:59 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, int start, String langAR[]) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
        cmdist.addHeader("No", "5%");
        cmdist.addHeader("" + langAR[5], "10%");
        cmdist.addHeader("" + langAR[2], "10%");
        cmdist.addHeader("" + langAR[0], "10%");
        cmdist.addHeader("" + langAR[1], "10%");
        cmdist.addHeader("" + langAR[6], "40%");

        cmdist.setLinkRow(1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {

            Costing costing = (Costing) objectClass.get(i);
            Vector rowx = new Vector();

            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add("<div align=\"center\">" + costing.getNumber() + "</div>");

            if (costing.getDate() == null) {
                rowx.add("");
            } else {
                rowx.add("<div align=\"center\">" + JSPFormater.formatDate(costing.getDate(), "dd-MMM-yyyy") + "</div>");
            }

            Location location = new Location();
            try {
                location = DbLocation.fetchExc(costing.getLocationId());
            } catch (Exception e) {
            }

            rowx.add("" + location.getName());
            rowx.add("<div align=\"center\">" + costing.getStatus().toLowerCase() + "</div>");
            rowx.add(costing.getNote());
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(costing.getOID()));
        }

        return cmdist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCosting = JSPRequestValue.requestLong(request, "hidden_costing_id");

            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            long srcLocationExpId = JSPRequestValue.requestLong(request, "src_locationexp_id");
            String number = JSPRequestValue.requestString(request, "txtnumber");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");

            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
            }
            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            if (srcLocationId != 0) {
                whereClause = DbCosting.colNames[DbCosting.COL_LOCATION_ID] + "=" + srcLocationId;
            }
            
            if(srcLocationExpId != 0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCosting.colNames[DbCosting.COL_LOCATION_POST_ID] + "=" + srcLocationExpId;
            }
            
            if(number != null && number.length() > 0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCosting.colNames[DbCosting.COL_NUMBER] + " like '%"+number+"%'";
            }

            if (srcStatus != null && srcStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbCosting.colNames[DbCosting.COL_STATUS] + "='" + srcStatus + "'";
                } else {
                    whereClause = DbCosting.colNames[DbCosting.COL_STATUS] + "='" + srcStatus + "'";
                }
            }

            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = "(to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbCosting.colNames[DbCosting.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            CmdCosting cmdCosting = new CmdCosting(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCosting = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdCosting.action(iJSPCommand, oidCosting);
            /* end switch*/
            JspCosting jspCosting = cmdCosting.getForm();

            /*count list All Costing*/
            int vectSize = DbCosting.getCount(whereClause);

            Costing vendor = cmdCosting.getCosting();
            msgString = cmdCosting.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdCosting.actionList(iJSPCommand, start, vectSize, recordToGet);
            }


            orderClause = DbCosting.colNames[DbCosting.COL_DATE];
            listCosting = DbCosting.list(start, recordToGet, whereClause, orderClause);


            if (listCosting.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCosting = DbCosting.list(start, recordToGet, whereClause, orderClause);
            }

            String msg = "";

            String[] langAR = {"Location", "Document Status", "Date", "Ignored", "To", "Transaction Number", "Notes", "Costing", "Posted journal success",
                "Some journal can't be posted, please check coa configuration in group item","Location Expense"
            };
            String[] langNav = {"Costing Journal", "Archieve", "Records", "Costing Stock", "Search Parameters","Records not found"};

            if (lang == LANG_ID) {
                String[] langID = {"Lokasi", "Status Dokumen", "Tanggal", "Abaikan", "Sampai", "Nomor Transaksi", "Memo", "Jurnal berhasil diposting",
                    "Beberapa jurnal gagal di posting, cek setup coa di item group","Lokasi Biaya"
                };
                langAR = langID;

                String[] navID = {"Jurnal Costing", "Arsip", "Arsip", "Penyesuaian Stock", "Parameter Pencarian", "Biaya","Data tidak ditemukan"};
                langNav = navID;
            }

Vector locations = DbLocation.list(0, 0, "", "name");
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script language="JavaScript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmcosting.command.value="<%=JSPCommand.LIST%>";
                document.frmcosting.action="costarchive.jsp";
                document.frmcosting.submit();
            }
            
            function setChecked(val){
                 <%
            for (int k = 0; k < listCosting.size(); k++) {
                Costing adj = (Costing) listCosting.get(k);
                 %>
                     document.frmcosting.post<%=adj.getOID()%>.checked=val.checked;
                     <% }%>
                 }
                 
                 
                 function cmdEdit(oid){
                     document.frmcosting.hidden_costing_id.value=oid;
                     document.frmcosting.command.value="<%=JSPCommand.EDIT%>";
                     document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
                     document.frmcosting.action="costarchiveitem.jsp";
                     document.frmcosting.submit();
                 }
                 
                 function cmdAdd(){
                     document.frmcosting.hidden_costing_id.value="0";
                     document.frmcosting.command.value="<%=JSPCommand.ADD%>";
                     document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
                     document.frmcosting.action="costitem.jsp";
                     document.frmcosting.submit();
                 }
                 
                 function cmdListFirst(){
                     document.frmcosting.command.value="<%=JSPCommand.FIRST%>";
                     document.frmcosting.prev_command.value="<%=JSPCommand.FIRST%>";
                     document.frmcosting.action="costarchive.jsp";
                     document.frmcosting.submit();
                 }
                 
                 function cmdListPrev(){
                     document.frmcosting.command.value="<%=JSPCommand.PREV%>";
                     document.frmcosting.prev_command.value="<%=JSPCommand.PREV%>";
                     document.frmcosting.action="costarchive.jsp";
                     document.frmcosting.submit();
                 }
                 
                 function cmdListNext(){
                     document.frmcosting.command.value="<%=JSPCommand.NEXT%>";
                     document.frmcosting.prev_command.value="<%=JSPCommand.NEXT%>";
                     document.frmcosting.action="costarchive.jsp";
                     document.frmcosting.submit();
                 }
                 
                 function cmdListLast(){
                     document.frmcosting.command.value="<%=JSPCommand.LAST%>";
                     document.frmcosting.prev_command.value="<%=JSPCommand.LAST%>";
                     document.frmcosting.action="costarchive.jsp";
                     document.frmcosting.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
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
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcosting" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_costing_id" value="<%=oidCosting%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">&nbsp;<%=langNav[0]%> 
                                                                                </font><font class="tit1">&raquo; <span class="lvl2"><%=langNav[1]%></span></font></b></td>
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
                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="750">                                                                                                                                        
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" >
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5">
                                                                                                                    <td colspan="4" class="fontarial" ><b><i><%=langNav[4]%>:</i></b></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5">
                                                                                                                    <td colspan="4" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5">
                                                                                                                    <td width="100" class="fontarial" ><%=langAR[0]%></td>
                                                                                                                    <td width="200"> 
                                                                                                                        <select name="src_location_id">
                                                                                                                            <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>All Location</option>
                                                                                                                            <%

            

            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    String str = "";
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td align="left"><%=langAR[2]%></td>
                                                                                                                    <td >
                                                                                                                        <table border = "0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcosting.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td>    
                                                                                                                                <td class="fontarial" >
                                                                                                                                    &nbsp;&nbsp;<%=langAR[4]%>&nbsp;&nbsp; 
                                                                                                                                </td>    
                                                                                                                                <td>
                                                                                                                                    <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                </td>    
                                                                                                                                <td>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcosting.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td>     
                                                                                                                                <td>
                                                                                                                                <input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>>
                                                                                                                                       </td>    
                                                                                                                                <td>
                                                                                                                                    <%=langAR[3]%>
                                                                                                                                </td>    
                                                                                                                            </tr>   
                                                                                                                        </table>   
                                                                                                                        
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5">
                                                                                                                    <td class="fontarial"><%=langAR[5]%></td>
                                                                                                                    <td ><input type="text" name="txtnumber" size="25" value="<%=number %>" class="fontarial"></td>
                                                                                                                    <td class="fontarial" align="left"><%=langAR[1]%></td>
                                                                                                                    <td >
                                                                                                                        <select name="src_status" class="fontarial">
                                                                                                                            <option value="" <%if (srcStatus.equals("")) {%>selected<%}%>>ALL STATUS</option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_POSTED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_POSTED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_POSTED%></option>
                                                                                                                    </select></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5">
                                                                                                                    <td class="fontarial" ><%=langAR[9]%></td>
                                                                                                                    <td colspan="3">    
                                                                                                                        <select name="src_locationexp_id">
                                                                                                                            <option value="0" <%if (srcLocationExpId == 0) {%>selected<%}%>>All Location</option>
                                                                                                                            <%

            

            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    String str = "";
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (srcLocationExpId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" height="5"></td>
                                                                                                                </tr>                                                                                                               
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                            <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listCosting.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(listCosting, start, langAR)%> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3">
                                                                                                <span class="command"> 
                                                                                                    <%
                                                                                                int cmd = 0;
                                                                                                if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                                                                                                        (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                                                                                                    cmd = iJSPCommand;
                                                                                                } else {
                                                                                                    if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                                                                                                        cmd = JSPCommand.FIRST;
                                                                                                    } else {
                                                                                                        cmd = prevJSPCommand;
                                                                                                    }
                                                                                                }
                                                                                                    %>
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                ctrLine.initDefault();
                                                                                                    %>
                                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span>
                                                                                                
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <% }else{%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i><%=langNav[6]%></i></td>
                                                                                        </tr>
                                                                                        <%}
            } catch (Exception exc) {
                System.out.println("sdsdf : " + exc.toString());
            }%>
                                                                                        
                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>                                                                                       
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
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
