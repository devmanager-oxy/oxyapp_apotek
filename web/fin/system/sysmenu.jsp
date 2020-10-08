
<%-- 
    Document   : sysmenu
    Created on : Sep 30, 2011, 10:30:37 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.menu.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>

<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_DELETE);
%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidMenu = JSPRequestValue.requestLong(request, "hidden_menu_id");

            /*variable declaration*/
            int recordToGet = 100;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = DbMenu.colNames[DbMenu.COL_CODE_MENU] + " ASC ";

            CmdMenu ctrlMenu = new CmdMenu(request);
            JSPLine ctrLine = new JSPLine();
            Vector listMenu = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlMenu.action(iJSPCommand, oidMenu);
            /* end switch*/
            JspMenu jspMenu = ctrlMenu.getForm();

            /*count list All Company*/
            int vectSize = DbMenu.getCount(whereClause);

            Menu menu = ctrlMenu.getMenu();
            msgString = ctrlMenu.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlMenu.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listMenu = DbMenu.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listMenu.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listMenu = DbMenu.list(start, recordToGet, whereClause, orderClause);
            }

%>
<html ><!-- #BeginTemplate "/Templates/indexwomenu.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmsysmenu.hidden_menu_id.value="0";
                document.frmsysmenu.command.value="<%=JSPCommand.ADD%>";
                document.frmsysmenu.prev_command.value="<%=prevJSPCommand%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            
            function cmdDelete(oidMenu){
                 var cfrm = confirm('Hapus data menu ?');
                    
                    if( cfrm==true){
                        document.frmsysmenu.hidden_menu_id.value=oidMenu;                        
                        document.frmsysmenu.command.value="<%=JSPCommand.DELETE%>";
                        document.frmsysmenu.action="sysmenu.jsp";
                        document.frmsysmenu.submit();
                    }
        
            }
            
            function cmdAsk(oidCompany){
                document.frmsysmenu.hidden_menu_id.value=oidCompany;
                document.frmsysmenu.command.value="<%=JSPCommand.ASK%>";
                document.frmsysmenu.prev_command.value="<%=prevJSPCommand%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            function cmdConfirmDelete(oidCompany){
                document.frmsysmenu.hidden_menu_id.value=oidCompany;
                document.frmsysmenu.command.value="<%=JSPCommand.DELETE%>";
                document.frmsysmenu.prev_command.value="<%=prevJSPCommand%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            function cmdSave(){
                document.frmsysmenu.command.value="<%=JSPCommand.SAVE%>";
                document.frmsysmenu.prev_command.value="<%=prevJSPCommand%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            function cmdEdit(oidMenu){
                document.frmsysmenu.hidden_menu_id.value=oidMenu;
                document.frmsysmenu.command.value="<%=JSPCommand.EDIT%>";
                document.frmsysmenu.prev_command.value="<%=prevJSPCommand%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            function cmdCancel(oidCompany){
                document.frmsysmenu.hidden_menu_id.value=oidCompany;
                document.frmsysmenu.command.value="<%=JSPCommand.EDIT%>";
                document.frmsysmenu.prev_command.value="<%=prevJSPCommand%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            function cmdBack(){
                document.frmsysmenu.command.value="<%=JSPCommand.BACK%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            function cmdListFirst(){
                document.frmsysmenu.command.value="<%=JSPCommand.FIRST%>";
                document.frmsysmenu.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            function cmdListPrev(){
                document.frmsysmenu.command.value="<%=JSPCommand.PREV%>";
                document.frmsysmenu.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            function cmdListNext(){
                document.frmsysmenu.command.value="<%=JSPCommand.NEXT%>";
                document.frmsysmenu.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
            function cmdListLast(){
                document.frmsysmenu.command.value="<%=JSPCommand.LAST%>";
                document.frmsysmenu.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmsysmenu.action="sysmenu.jsp";
                document.frmsysmenu.submit();
            }
            
        </script>
        <script type="text/javascript">
            <!--
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            //-->
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">System Menu</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmsysmenu" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_menu_id" value="<%=oidMenu%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" colspan="3">&nbsp;</td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td class="container" height="8" valign="top" colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                            <tr align="left"> 
                                                                                <td colspan="4" valign="top">&nbsp;
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                        <%
            String style = "";
            int maxPage = 0;
                                                                                        %>
                                                                                        <%if (listMenu != null && listMenu.size() > 0) {%>
                                                                                        <tr>
                                                                                            <td width="5%" class="tablehdr">No</td>
                                                                                            <td width="10%" class="tablehdr">Kode</td>
                                                                                            <td width="10%" class="tablehdr">Menu Indonesia</td>
                                                                                            <td width="10%" class="tablehdr">Menu English</td>
                                                                                            <td width="5%" class="tablehdr">Level</td>
                                                                                            <td width="15%" class="tablehdr">Url</td>
                                                                                            <td width="8%" class="tablehdr">Folder</td>
                                                                                            <td width="8%" class="tablehdr">Index Cmd</td>
                                                                                            <td width="9%" class="tablehdr">Start</td>
                                                                                            <td width="5%" class="tablehdr">Idx1</td>
                                                                                            <td width="5%" class="tablehdr">Idx2</td>
                                                                                            <td width="5%" class="tablehdr">Idx3</td>
                                                                                            <td width="5%" class="tablehdr">Link</td>
                                                                                        </tr>  
                                                                                        <%

    for (int iList = 0; iList < listMenu.size(); iList++) {

        Menu objMenu = (Menu) listMenu.get(iList);
        maxPage = iList + 1;
        String str = "";

        switch (objMenu.getLevel()) {
            case 1:
                break;
            case 2:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 3:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 4:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
        }

        if (iList % 2 == 0) {
            style = "tablecell";
        } else {
            style = "tablecell1";
        }

        if (menu.getOID() == objMenu.getOID() && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK || iErrCode != 0)) {

                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="<%=style%>" align="center"><%=iList + 1%></td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_CODE_MENU] %>"  value="<%= menu.getCodeMenu() %>" class="formElemen" size="12">
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_CODE_MENU) %>
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_MENU_IND] %>"  value="<%= menu.getMenuInd() %>" class="formElemen" size="20">
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_MENU_IND) %>
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_MENU_ENG] %>"  value="<%= menu.getMenuEng() %>" class="formElemen" size="20">
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_MENU_ENG) %>
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="center">
                                                                                                <select name="<%=jspMenu.colNames[JspMenu.JSP_LEVEL]%>">
                                                                                                    <%
             for (int iLevel = 0; iLevel < DbMenu.valueLevel.length; iLevel++) {
                                                                                                    %>            
                                                                                                    <option <%if (menu.getLevel() == DbMenu.valueLevel[iLevel]) {%>selected<%}%> value="<%=DbMenu.valueLevel[iLevel]%>"><%=DbMenu.valueLevel[iLevel]%></option>
                                                                                                    
                                                                                                    <%
             }
                                                                                                    %>
                                                                                                    
                                                                                                </select>                                                                                                
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_LEVEL) %> 
                                                                                                
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_URL] %>"  value="<%= menu.getUrl() %>" class="formElemen" size="20">                                                                                                 
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_FOLDER] %>"  value="<%= menu.getFolder() %>" class="formElemen" size="10">
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_INDEX_CMD] %>"  value="<%= menu.getIndexCmd() %>" class="formElemen" size="5">
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_INDEX_CMD) %> 
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                               <select name="<%=jspMenu.colNames[JspMenu.JSP_START]%>">
                                                                                                    <%
             for (int iStart = 0; iStart < DbMenu.strValStart.length; iStart++) {
                                                                                                    %>            
                                                                                                    <option <%if (menu.getStart() == DbMenu.intValStart[iStart]) {%>selected<%}%> value="<%=DbMenu.intValStart[iStart]%>"><%=DbMenu.strValStart[iStart]%></option>
                                                                                                    
                                                                                                    <%
             }
                                                                                                    %>
                                                                                                    
                                                                                                </select>                                                                                                
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_START) %>  
                                                                                            </td> 
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_IDX1] %>"  value="<%= menu.getIdxPertama() %>" class="formElemen" size="5">                                                                                                 
                                                                                            </td>
                                                                                             <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_IDX2] %>"  value="<%= menu.getIdxKedua() %>" class="formElemen" size="5">
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_IDX3] %>"  value="<%= menu.getIdxKetiga() %>" class="formElemen" size="5">                                                                                                 
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                               <select name="<%=jspMenu.colNames[JspMenu.JSP_LINK]%>">
                                                                                                    <%
             for (int iLink = 0; iLink < DbMenu.valueLink.length; iLink++) {
                                                                                                    %>            
                                                                                                    <option <%if (menu.getLink() == DbMenu.valueLink[iLink]) {%>selected<%}%> value="<%=DbMenu.valueLink[iLink]%>"><%=DbMenu.strLink[iLink]%></option>
                                                                                                    
                                                                                                    <%
             }
                                                                                                    %>
                                                                                                    
                                                                                                </select>                                                                                                
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_START) %>  
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <%
         } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="<%=style%>" align="center"><%=iList + 1%></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=str%><a href="javascript:cmdEdit('<%=objMenu.getOID()%>')"><%=objMenu.getCodeMenu()%></a></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=objMenu.getMenuInd()%></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=objMenu.getMenuEng()%></td>
                                                                                            <td class="<%=style%>" align="center"><%=objMenu.getLevel()%></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=objMenu.getUrl()%></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=objMenu.getFolder() %></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=objMenu.getIndexCmd() %></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=DbMenu.strValStart[objMenu.getStart()]%></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=objMenu.getIdxPertama() %></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=objMenu.getIdxKedua() %></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=objMenu.getIdxKetiga() %></td>
                                                                                            <td class="<%=style%>">&nbsp;<%=DbMenu.strLink[objMenu.getLink()]%></td>
                                                                                        </tr>  
                                                                                        <%}%>
                                                                                        
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                        
                                                                                        <%
            if (iJSPCommand == JSPCommand.ADD ||(iJSPCommand == JSPCommand.SAVE && iErrCode != 0 && menu.getOID()==0) ) {

                if (style.compareTo("") == 0 || style.compareTo("tablecell1") == 0) {
                    style = "tablecell";
                } else {
                    style = "tablecell1";
                }
                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="<%=style%>" align="center"><%=maxPage + 1%></td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_CODE_MENU] %>"  value="<%= menu.getCodeMenu() %>" class="formElemen" size="12">
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_CODE_MENU) %>
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_MENU_IND] %>"  value="<%= menu.getMenuInd() %>" class="formElemen" size="20">
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_MENU_IND) %>
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_MENU_ENG] %>"  value="<%= menu.getMenuEng() %>" class="formElemen" size="20">
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_MENU_ENG) %>
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="center">
                                                                                                <select name="<%=jspMenu.colNames[JspMenu.JSP_LEVEL]%>">
                                                                                                    <%
                                                                                            for (int iLevel = 0; iLevel < DbMenu.valueLevel.length; iLevel++) {
                                                                                                    %>            
                                                                                                    <option <%if (menu.getLevel() == DbMenu.valueLevel[iLevel]) {%>selected<%}%> value="<%=DbMenu.valueLevel[iLevel]%>"><%=DbMenu.strLevel[iLevel]%></option>
                                                                                                    
                                                                                                    <%
                                                                                            }
                                                                                                    %>
                                                                                                    
                                                                                                </select>                                                                                                
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_LEVEL) %> 
                                                                                                
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_URL] %>"  value="<%= menu.getUrl() %>" class="formElemen" size="20">                                                                                                 
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_FOLDER] %>"  value="<%= menu.getFolder() %>" class="formElemen" size="10">
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_INDEX_CMD] %>"  value="<%= menu.getIndexCmd() %>" class="formElemen" size="5">
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_INDEX_CMD) %> 
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                               <select name="<%=jspMenu.colNames[JspMenu.JSP_START]%>">
                                                                                                    <%
             for (int iStart = 0; iStart < DbMenu.strValStart.length; iStart++){
                                                                                                    %>            
                                                                                                    <option <%if (menu.getStart() == DbMenu.intValStart[iStart]) {%>selected<%}%> value="<%=DbMenu.intValStart[iStart]%>"><%=DbMenu.strValStart[iStart]%></option>
                                                                                                    
                                                                                                    <%
             }
                                                                                                    %>
                                                                                                    
                                                                                                </select>                                                                                                
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_START) %>  
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_IDX1] %>"  value="<%= menu.getIdxPertama() %>" class="formElemen" size="5">                                                                                                 
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_IDX2] %>"  value="<%= menu.getIdxKedua() %>" class="formElemen" size="5">                                                                                                 
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="left">
                                                                                                &nbsp;<input type="text" name="<%=jspMenu.colNames[JspMenu.JSP_IDX3] %>"  value="<%= menu.getIdxKetiga() %>" class="formElemen" size="5">                                                                                                 
                                                                                            </td>  
                                                                                            <td class="<%=style%>" align="left">
                                                                                               <select name="<%=jspMenu.colNames[JspMenu.JSP_LINK]%>">
                                                                                                    <%
             for (int iLink = 0; iLink < DbMenu.valueLink.length; iLink++) {
                                                                                                    %>            
                                                                                                    <option <%if (menu.getLink() == DbMenu.valueLink[iLink]) {%>selected<%}%> value="<%=DbMenu.valueLink[iLink]%>"><%=DbMenu.strLink[iLink]%></option>
                                                                                                    
                                                                                                    <%
             }
                                                                                                    %>
                                                                                                    
                                                                                                </select>                                                                                                
                                                                                                * <%= jspMenu.getErrorMsg(JspMenu.JSP_START) %>  
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <%}%>                                                                                         
                                                                                    </table>    
                                                                                </td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>                                                                          
                                                                            <tr align="left"> 
                                                                                <td colspan="3" class="command" valign="top">                                                                                   
                                                                                    <%if (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.ASK || iErrCode != 0) {%>
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save1','','../images/save2.gif',1)"><img src="../images/save.gif" name="save1" border="0"></a></td>
                                                                                            <td width="20"></td>
                                                                                            <td><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel1','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel1" border="0"></a></td>
                                                                                            <td width="20"></td>
                                                                                            <%if (iJSPCommand != JSPCommand.ADD) {%>
                                                                                            <td><a href="javascript:cmdDelete('<%=menu.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('delete1','','../images/delete2.gif',1)"><img src="../images/delete.gif" name="delete1" border="0"></a></td>
                                                                                            <%}%>
                                                                                        </tr>    
                                                                                    </table>  
                                                                                    <%} else {%>
                                                                                    <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newd1','','../images/new2.gif',1)"><img src="../images/new.gif" name="newd1" border="0"></a>
                                                                                    <%}%>
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