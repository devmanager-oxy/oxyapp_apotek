
<%-- 
    Document   : printdesign
    Created on : Jan 11, 2012, 2:42:39 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>

<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_DELETE);
%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int previJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidPrintDesign = JSPRequestValue.requestLong(request, "hidden_printdesign_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdPrintDesign ctrlPrintDesign = new CmdPrintDesign(request);
            JSPLine ctrLine = new JSPLine();
            Vector listPrintDesign = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlPrintDesign.action(iJSPCommand, oidPrintDesign);
            /* end switch*/
            JspPrintDesign jspPrintDesign = ctrlPrintDesign.getForm();

            /*count list All PrintDesign*/
            int vectSize = DbPrintDesign.getCount(whereClause);

            /*switch list PrintDesign*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlPrintDesign.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            PrintDesign printDesign = ctrlPrintDesign.getPrintDesign();
            msgString = ctrlPrintDesign.getMessage();

            /* get record to display */
            listPrintDesign = DbPrintDesign.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listPrintDesign.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    previJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listPrintDesign = DbPrintDesign.list(start, recordToGet, whereClause, orderClause);
            }

            String[] langCT = {"Doc. Name", "Print Width", "Print Height", "Font Header", "Size Font Header",
                "Font Data Main", "Size Font Data Main", "Width Table Data Main", "Height Table Data Main", "Border Title Column",
                "Font Title Column", "Size Font Title Column", "Border Data Detail", "Font Data Detail", "Size Font Data Detail",
                "Border Data Total", "Font Data Total", "Size Font Data Total", "Border Data Approval", "Font Data Approval", "Size Font Data Approval",
                "Border Data Footer", "Font Data Footer", "Size Font Data Footer"
            };

            String[] langNav = {"Master Data", "Document", "Printout Design"};

            if (lang == LANG_ID) {

                String[] langID = {"Nama Dok.", "Lebar Print", "Panjang Kertas", "Tulisan Header", "Ukuran Tulisan Header", //0-4
                    "Tulisan Data Main", "Ukuran Tulisan Data Main", "Lebar Table Data Main", "Tinggi Table Data Main", "Border Judul Kolom", //5-9
                    "Tulisan Judul Kolom", "Ukuran Tulisan Judul Kolom", "Border Data Detail", "Tulisan Data Detail", "Ukuran Tulisan Data Detail", // 10 - 14
                    "Border Data Total", "Font Data Total", "Ukuran Font Data Total", "Border Data Approval", "Font Data Approval", "Ukuran Font data Approval", //15 - 20;
                    "Border Data Footer", "Font Data Footer", "Ukuran Font Data Footer"}; //21 - 23

                langCT = langID;

                String[] navID = {"Data Induk", "Dokumen", "Desain Printout"};
                langNav = navID;
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />        
        <title><%=systemTitle%></title>
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmprintdesign.hidden_printdesign_id.value="0";
                document.frmprintdesign.command.value="<%=JSPCommand.ADD%>";
                document.frmprintdesign.prev_command.value="<%=previJSPCommand%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdAsk(oidPrintDesign){
                document.frmprintdesign.hidden_printdesign_id.value=oidPrintDesign;
                document.frmprintdesign.command.value="<%=JSPCommand.ASK%>";
                document.frmprintdesign.prev_command.value="<%=previJSPCommand%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdConfirmDelete(oidPrintDesign){
                document.frmprintdesign.hidden_printdesign_id.value=oidPrintDesign;
                document.frmprintdesign.command.value="<%=JSPCommand.DELETE%>";
                document.frmprintdesign.prev_command.value="<%=previJSPCommand%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdSave(){
                document.frmprintdesign.command.value="<%=JSPCommand.SAVE%>";
                document.frmprintdesign.prev_command.value="<%=previJSPCommand%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdEdit(oidPrintDesign){
                <%if (privUpdate) {%>
                document.frmprintdesign.hidden_printdesign_id.value=oidPrintDesign;
                document.frmprintdesign.command.value="<%=JSPCommand.EDIT%>";
                document.frmprintdesign.prev_command.value="<%=previJSPCommand%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
                <%}%>   
            }
            
            function cmdCancel(oidPrintDesign){
                document.frmprintdesign.hidden_printdesign_id.value=oidPrintDesign;
                document.frmprintdesign.command.value="<%=JSPCommand.EDIT%>";
                document.frmprintdesign.prev_command.value="<%=previJSPCommand%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdBack(){
                document.frmprintdesign.command.value="<%=JSPCommand.BACK%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdListFirst(){
                document.frmprintdesign.command.value="<%=JSPCommand.FIRST%>";
                document.frmprintdesign.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdListPrev(){
                document.frmprintdesign.command.value="<%=JSPCommand.PREV%>";
                document.frmprintdesign.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdListNext(){
                document.frmprintdesign.command.value="<%=JSPCommand.NEXT%>";
                document.frmprintdesign.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            function cmdListLast(){
                document.frmprintdesign.command.value="<%=JSPCommand.LAST%>";
                document.frmprintdesign.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmprintdesign.action="printdesign.jsp";
                document.frmprintdesign.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidPrintDesign){
                document.frmimage.hidden_printdesign_id.value=oidPrintDesign;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="printdesign.jsp";
                document.frmimage.submit();
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
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title">
                                                        <font color="#990000" class="lvl1"><%=langNav[0]%></font> <font class="tit1">&raquo;</font> 
                                                        <font color="#990000" class="lvl1"><%=langNav[1]%></font> <font class="tit1">&raquo;</font> 
                                                    <span class="lvl2"><%=langNav[2]%></span></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmprintdesign" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=previJSPCommand%>">
                                                            <input type="hidden" name="hidden_printdesign_id" value="<%=oidPrintDesign%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <%
                                                                                            if (listPrintDesign != null && listPrintDesign.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" cellpadding="0" cellspacing="1" border="0">
                                                                                                    <tr>
                                                                                                        <td class="tablehdr" align="center"><%=langCT[0]%></td>
                                                                                                        <td class="tablehdr" align="center"><%=langCT[1]%></td>
                                                                                                        <td class="tablehdr" align="center"><%=langCT[2]%></td>
                                                                                                        <td class="tablehdr" align="center"><%=langCT[3]%></td>
                                                                                                        <td class="tablehdr" align="center"><%=langCT[4]%></td>
                                                                                                        <td class="tablehdr" align="center"><%=langCT[5]%></td>
                                                                                                        <td class="tablehdr" align="center"><%=langCT[6]%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                            for (int i = 0; i < listPrintDesign.size(); i++) {

                                                                                                PrintDesign objprintDesign = (PrintDesign) listPrintDesign.get(i);

                                                                                                String style = "tablecell";

                                                                                                if (i % 2 == 0) {
                                                                                                    style = "tablecell1";
                                                                                                }

                                                                                                if (printDesign.getOID() == objprintDesign.getOID() && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {


                                                                                                }
                                                                                                    %>    
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>"><a href="javascript:cmdEdit('<%=objprintDesign.getOID()%>')"><%=objprintDesign.getNameDocument()%></a></td>
                                                                                                        <td class="<%=style%>"><%=objprintDesign.getWidthPrint()%></td>
                                                                                                        <td class="<%=style%>"><%=objprintDesign.getHeightPrint()%></td>
                                                                                                        <td class="<%=style%>"><%=objprintDesign.getFontHeader()%></td>
                                                                                                        <td class="<%=style%>"><%=objprintDesign.getSizeFontHeader()%></td>
                                                                                                        <td class="<%=style%>"><%=objprintDesign.getFontDataMain()%></td>                                                                                                       
                                                                                                        <td class="<%=style%>"><%=objprintDesign.getSizeFontDataMain()%></td>                                                                                                       
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr>
                                                                                                        <td colspan="7">&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td colspan="7">
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%//= drawList(iJSPCommand, jspPrintDesign, printDesign, listPrintDesign, oidPrintDesign)%> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }
                                                                                        %>
                                                                                        <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%">
                                                                                                    <tr>
                                                                                                        <td width="20%"><%=langCT[0]%><td>
                                                                                                        <td width="1%">:<td>
                                                                                                        <td width="79%">                                                                                                        
                                                                                                        <select name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_NAME_DOCUMENT]%>">                                                                                                            
                                                                                                            <%
    if(DbPrintDesign.colNamesDocument.length > 0){
        for (int t = 0; t < DbPrintDesign.colNamesDocument.length; t++){
            String selected = "";
            if (DbPrintDesign.colNamesDocument[t].compareTo(printDesign.getNameDocument()) == 0) {
                selected = "selected";
            }
                                                                                                            %>
                                                                                                            <option value="<%=DbPrintDesign.colNamesDocument[t]%>" <%=selected%> ><%=DbPrintDesign.colNamesDocument[t]%></option>
                                                                                                            <%        
        }
    }
                                                                                                            %>
                                                                                                        </select>
                                                                                                        <%= jspPrintDesign.getErrorMsg(JspPrintDesign.JSP_NAME_DOCUMENT) %>
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[1]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_WIDTH_PRINT]%>" value ="<%=printDesign.getWidthPrint()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[2]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_HEIGHT_PRINT]%>" value ="<%=printDesign.getHeightPrint()%>"> px<td>  
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[3]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                        <select name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_FONT_HEADER]%>" >
                                                                                                            <%
    if(DbPrintDesign.colNamesFont.length > 0){
        for (int t = 0; t < DbPrintDesign.colNamesFont.length; t++){
            String selected = "";
            if (DbPrintDesign.colNamesFont[t].compareTo(printDesign.getFontHeader()) == 0) {
                selected = "selected";
            }
                                                                                                            %>
                                                                                                            <option value="<%=DbPrintDesign.colNamesFont[t]%>" <%=selected%> ><%=DbPrintDesign.colNamesFont[t]%></option>
                                                                                                            <%        
        }
    }
                                                                                                            %>
                                                                                                        </select>
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[4]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_SIZE_FONT_HEADER]%>" value ="<%=printDesign.getSizeFontHeader()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[5]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                        <select name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_FONT_DATA_MAIN]%>" >
                                                                                                            <%
    if(DbPrintDesign.colNamesFont.length > 0){
        for (int t = 0; t < DbPrintDesign.colNamesFont.length; t++){
            String selected = "";
            if (DbPrintDesign.colNamesFont[t].compareTo(printDesign.getFontDataMain()) == 0) {
                selected = "selected";
            }
                                                                                                            %>
                                                                                                            <option value="<%=DbPrintDesign.colNamesFont[t]%>" <%=selected%> ><%=DbPrintDesign.colNamesFont[t]%></option>
                                                                                                            <%        
        }
    }
                                                                                                            %>
                                                                                                        </select>
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[6]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_SIZE_FONT_DATA_MAIN]%>" value ="<%=printDesign.getSizeFontDataMain()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[7]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_WIDTH_TABLE_DATA_MAIN]%>" value ="<%=printDesign.getWidthTableDataMain()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[8]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_HEIGHT_TABLE_DATA_MAIN]%>" value ="<%=printDesign.getHeightTableDataMain()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[9]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_BORDER_TITLE_COLUMN]%>" value ="<%=printDesign.getBorderTitleColumn()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[10]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                            <select name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_FONT_TITLE_COLUMN]%>" >
                                                                                                            <%
    if(DbPrintDesign.colNamesFont.length > 0){
        for (int t = 0; t < DbPrintDesign.colNamesFont.length; t++){
            String selected = "";
            if (DbPrintDesign.colNamesFont[t].compareTo(printDesign.getFontTitleColumn()) == 0) {
                selected = "selected";
            }
                                                                                                            %>
                                                                                                            <option value="<%=DbPrintDesign.colNamesFont[t]%>" <%=selected%> ><%=DbPrintDesign.colNamesFont[t]%></option>
                                                                                                            <%        
        }
    }
                                                                                                            %>
                                                                                                        </select>
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[11]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                        <input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_SIZE_FONT_TITLE_COLUMN]%>" value ="<%=printDesign.getSizeFontTitleColumn()%>"> px    
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[12]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                        <input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_BORDER_DATA_DETAIL]%>" value ="<%=printDesign.getBorderDataDetail()%>"> px    
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[13]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                        <select name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_FONT_DATA_DETAIL]%>" >
                                                                                                            <%
    if(DbPrintDesign.colNamesFont.length > 0){
        for (int t = 0; t < DbPrintDesign.colNamesFont.length; t++){
            String selected = "";
            if (DbPrintDesign.colNamesFont[t].compareTo(printDesign.getFontDataDetail()) == 0) {
                selected = "selected";
            }
                                                                                                            %>
                                                                                                            <option value="<%=DbPrintDesign.colNamesFont[t]%>" <%=selected%> ><%=DbPrintDesign.colNamesFont[t]%></option>
                                                                                                            <%        
        }
    }
                                                                                                            %>
                                                                                                        </select>   
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[14]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_SIZE_FONT_DATA_DETAIL]%>" value ="<%=printDesign.getSizeFontDataDetail()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[15]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_BORDER_DATA_TOTAL]%>" value ="<%=printDesign.getBorderDataTotal()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[16]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                        <select name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_FONT_DATA_TOTAL]%>" >
                                                                                                            <%
    if(DbPrintDesign.colNamesFont.length > 0){
        for (int t = 0; t < DbPrintDesign.colNamesFont.length; t++){
            String selected = "";
            if (DbPrintDesign.colNamesFont[t].compareTo(printDesign.getFontDataTotal()) == 0) {
                selected = "selected";
            }
                                                                                                            %>
                                                                                                            <option value="<%=DbPrintDesign.colNamesFont[t]%>" <%=selected%> ><%=DbPrintDesign.colNamesFont[t]%></option>
                                                                                                            <%        
        }
    }
                                                                                                            %>
                                                                                                        </select>     
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[17]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_SIZE_FONT_DATA_TOTAL]%>" value ="<%=printDesign.getSizeFontDataTotal()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[18]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_BORDER_DATA_APPROVAL]%>" value ="<%=printDesign.getBorderDataApproval()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[19]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                        <select name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_FONT_DATA_APPROVAL]%>" >
                                                                                                            <%
    if(DbPrintDesign.colNamesFont.length > 0){
        for (int t = 0; t < DbPrintDesign.colNamesFont.length; t++){
            String selected = "";
            if (DbPrintDesign.colNamesFont[t].compareTo(printDesign.getFontDataApproval()) == 0) {
                selected = "selected";
            }
                                                                                                            %>
                                                                                                            <option value="<%=DbPrintDesign.colNamesFont[t]%>" <%=selected%> ><%=DbPrintDesign.colNamesFont[t]%></option>
                                                                                                            <%        
        }
    }
                                                                                                            %>
                                                                                                        </select>                                                                                                           
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[20]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_SIZE_FONT_DATA_APPROVAL]%>" value ="<%=printDesign.getSizeFontDataApproval()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[21]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_BORDER_DATA_FOOTER]%>" value ="<%=printDesign.getBorderDataFooter()%>"> px<td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[22]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td >
                                                                                                            <select name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_FONT_DATA_FOOTER]%>" >
                                                                                                            <%
    if(DbPrintDesign.colNamesFont.length > 0){
        for (int t = 0; t < DbPrintDesign.colNamesFont.length; t++){
            String selected = "";
            if (DbPrintDesign.colNamesFont[t].compareTo(printDesign.getFontDataFooter()) == 0) {
                selected = "selected";
            }
                                                                                                            %>
                                                                                                            <option value="<%=DbPrintDesign.colNamesFont[t]%>" <%=selected%> ><%=DbPrintDesign.colNamesFont[t]%></option>
                                                                                                            <%        
        }
    }
                                                                                                            %>
                                                                                                        </select> 
                                                                                                        <td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td ><%=langCT[23]%><td>
                                                                                                        <td >:<td>
                                                                                                        <td ><input type="text" name="<%=jspPrintDesign.colNames[jspPrintDesign.JSP_SIZE_FONT_DATA_FOOTER]%>" value ="<%=printDesign.getSizeFontDataFooter()%>"> px<td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>    
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
            } catch (Exception exc) {
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"> 
                                                                                                <span class="command"> 
                                                                                                    <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || previJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = previJSPCommand;
                }
            }
                                                                                                    %>
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && (iErrCode == 0)) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">
                                                                                    <%if (privAdd) {%>
                                                                                    <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a> 
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr align="left" valign="top" > 
                                                                                <td class="command"> 
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidPrintDesign + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidPrintDesign + "')";
    String scancel = "javascript:cmdEdit('" + oidPrintDesign + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");

    if (privDelete) {
        ctrLine.setConfirmDelJSPCommand(sconDelCom);
        ctrLine.setDeleteJSPCommand(scomDel);
        ctrLine.setEditJSPCommand(scancel);
    } else {
        ctrLine.setConfirmDelCaption("");
        ctrLine.setDeleteCaption("");
        ctrLine.setEditCaption("");
    }

    if (privAdd == false && privUpdate == false) {
        ctrLine.setSaveCaption("");
    }

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }
                                                                                    %>
                                                                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            
                                                        </form>
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

