
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.admin.*" %>
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
<!-- JSP Block -->
<%!
    public String drawListGroup(Vector objectClass, String[] lang,int start) {

        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");        
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        
        ctrlist.addHeader("No", "20");
        ctrlist.addHeader(lang[0], "300");
        ctrlist.addHeader(lang[1], "");
        ctrlist.addHeader("Last Update Date", "120");
        ctrlist.addHeader("Last Update By", "150");

        ctrlist.setLinkRow(1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Group appGroup = (Group) objectClass.get(i);
            Vector rowx = new Vector();
            rowx.add("<div align=\"center\">"+String.valueOf(""+(start+i+1))+"</div>");
            rowx.add(String.valueOf(appGroup.getGroupName()));
            rowx.add(String.valueOf(appGroup.getDescription()));
            String regdatestr = "";
            String empName = "";
            try {
                Date regdate = appGroup.getRegDate();
                regdatestr = JSPFormater.formatDate(regdate, "dd MMM yyyy HH:mm:ss");
            } catch (Exception e) {
                regdatestr = "";
            }
            
            Vector historys = new Vector();
            historys = DbHistoryUser.list(0, 1, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_USER_GROUP + " and " + DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID] + " = " + appGroup.getOID(), DbHistoryUser.colNames[DbHistoryUser.COL_DATE]+" desc");
            
            if(historys != null && historys.size() > 0){
                try{
                    HistoryUser hu = (HistoryUser)historys.get(0);
                    regdatestr = JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss");
                    Employee emp = DbEmployee.fetchExc(hu.getEmployeeId());
                    empName = emp.getName();
                }catch(Exception e){}
            }            
            rowx.add("<div align=\"center\">"+String.valueOf(regdatestr)+"</div>");
            //rowx.add("<div align=\"center\"></div>");
            rowx.add(empName);

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(appGroup.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%

            /* VARIABLE DECLARATION */
            int recordToGet = 30;
            String order = " " + DbGroup.colNames[DbGroup.COL_GROUP_NAME];
            Vector listGroup = new Vector(1, 1);
            JSPLine ctrLine = new JSPLine();

            /* GET REQUEST FROM HIDDEN TEXT */
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");                        
            long appGroupOID = JSPRequestValue.requestLong(request, "group_oid");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            
            if (prevCommand == JSPCommand.NONE) {
                prevCommand = JSPCommand.LIST;
            }

            CmdGroup ctrlGroup = new CmdGroup(request);

            int vectSize = DbGroup.getCount("");

            start = ctrlGroup.actionList(prevCommand, start, vectSize, recordToGet);
            listGroup = DbGroup.list(start, recordToGet, "", order);
            
            if (listGroup.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevCommand = JSPCommand.FIRST;
                }
                listGroup = DbGroup.list(start, recordToGet, "", order);
            }

            /*** LANG ***/
            String[] langMD = {"Group Name", "Description"};
            if (lang == LANG_ID) {
                String[] langID = {"Nama Kelompok", "Keterangan"};
                langMD = langID;
            }
%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=systemTitle%></title>        
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <% if (privAdd) {%>
            function addNew(){
                document.frmGroup.group_oid.value="0";
                document.frmGroup.prev_command.value="<%=prevCommand%>";
                document.frmGroup.command.value="<%=JSPCommand.ADD%>";
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            <%}%>
            
            function cmdEdit(oid){
                <%if (privUpdate) {%>
                document.frmGroup.group_oid.value=oid;
                document.frmGroup.prev_command.value="<%=prevCommand%>";
                document.frmGroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmGroup.action="groupedit.jsp";                
                document.frmGroup.submit();
                <%}%>
            }
            
            function first(){
                document.frmGroup.command.value="<%=JSPCommand.FIRST%>";
                document.frmGroup.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmGroup.action="grouplist.jsp";
                document.frmGroup.submit();
            }
            
            function prev(){
                document.frmGroup.command.value="<%=JSPCommand.PREV%>";
                document.frmGroup.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmGroup.action="grouplist.jsp";
                document.frmGroup.submit();
            }
            
            function next(){
                document.frmGroup.command.value="<%=JSPCommand.NEXT%>";
                document.frmGroup.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmGroup.action="grouplist.jsp";
                document.frmGroup.submit();
            }
            function last(){
                document.frmGroup.command.value="<%=JSPCommand.LAST%>";
                document.frmGroup.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmGroup.action="grouplist.jsp";
                document.frmGroup.submit();
            }
            
            function backMenu(){
                document.frmGroup.action="<%=approot%>/management/main_systemadmin.jsp";
                document.frmGroup.submit();
            }
            
        </script>
        <%@ include file="../main/hdscript.jsp"%>
        <script language="JavaScript">
            <!--
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
            //-->
        </script>
        
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','<%=approot%>/images/new2.gif')">
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
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Group List</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        
                                                        <form name="frmGroup" method="post" action="">
                                                            <input type="hidden" name="command" value="">
                                                            <input type="hidden" name="group_oid" value="<%=appGroupOID%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">                                                            
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <% if ((listGroup != null) && (listGroup.size() > 0)) {%>
                                                                            <tr> 
                                                                                <td colspan="2"><%=drawListGroup(listGroup, langMD,start)%></td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td colspan="2" height="20">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2"> 
                                                                                    <div class="comment">&nbsp;&nbsp;&nbsp;&nbsp;No Group available</div>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                        <table width="100%">
                                                                            <tr> 
                                                                                <td colspan="2"> <span class="command"> <%=ctrLine.drawMeListLimit(prevCommand, vectSize, start, recordToGet, "first", "prev", "next", "last", "left")%> </span> </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2" class="command"> 
                                                                                    <table width="39%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <% if (privAdd) {%>
                                                                                            <td width="24%"><a href="javascript:addNew()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100','','<%=approot%>/images/new2.gif',1)"><img name="Image100" border="0" src="../images/new.gif" width="71" height="22" alt="Add New User"></a></td>
                                                                                            <%} else {%>
                                                                                            <td width="24%">&nbsp;</td>
                                                                                            <%}%>
                                                                                            <td width="76%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="87%">&nbsp;</td>
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
