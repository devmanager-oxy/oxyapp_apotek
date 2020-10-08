
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER);%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privView = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- JSP Block -->
<%!
    public String drawListGroup(Vector objectClass){
        
        String temp = "";
        String regdatestr = "";

        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");        
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Group. Name", "30%");
        ctrlist.addHeader("Description", "40%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");

        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();

        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();

        for (int i = 0; i < objectClass.size(); i++) {
            
            Group appGroup = (Group) objectClass.get(i);

            Vector rowx = new Vector();

            rowx.add(String.valueOf(appGroup.getGroupName()));
            rowx.add(String.valueOf(appGroup.getDescription()));
            try {
                Date regdate = appGroup.getRegDate();
                regdatestr = JSPFormater.formatDate(regdate, "dd MMMM yyyy");
            } catch (Exception e) {
                regdatestr = "";
            }

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(appGroup.getOID()));
        }

        return ctrlist.draw();
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int recordToGet = 15;

            String order = " " + DbGroup.colNames[DbGroup.COL_GROUP_NAME];

            Vector listGroup = new Vector(1, 1);
            JSPLine ctrLine = new JSPLine();
            
            int start = JSPRequestValue.requestInt(request, "start");
            long appGroupOID = JSPRequestValue.requestLong(request, "group_oid");
            int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
            if (listJSPCommand == JSPCommand.NONE) {
                listJSPCommand = JSPCommand.LIST;
            }

            CmdGroup ctrlGroup = new CmdGroup(request);

            int vectSize = DbGroup.getCount("");

            start = ctrlGroup.actionList(listJSPCommand, start, vectSize, recordToGet);
            
            String where = "";

            listGroup = DbGroup.list(start, recordToGet, "", order);
%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=titleIS%></title>
        <script language="JavaScript">
            
            <%if (!adminPriv) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (!privView && !privAdd && !privUpdate && !privDelete) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <% if (privAdd) {%>
            function addNew(){
                document.frmGroup.group_oid.value="0";
                document.frmGroup.list_command.value="<%=listJSPCommand%>";
                document.frmGroup.command.value="<%=JSPCommand.ADD%>";
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            <%}%>
            
            function cmdEdit(oid){
                document.frmGroup.group_oid.value=oid;
                document.frmGroup.list_command.value="<%=listJSPCommand%>";
                document.frmGroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            
            function first(){
                document.frmGroup.command.value="<%=JSPCommand.FIRST%>";
                document.frmGroup.list_command.value="<%=JSPCommand.FIRST%>";
                document.frmGroup.action="grouplist.jsp";
                document.frmGroup.submit();
            }
            function prev(){
                document.frmGroup.command.value="<%=JSPCommand.PREV%>";
                document.frmGroup.list_command.value="<%=JSPCommand.PREV%>";
                document.frmGroup.action="grouplist.jsp";
                document.frmGroup.submit();
            }
            
            function next(){
                document.frmGroup.command.value="<%=JSPCommand.NEXT%>";
                document.frmGroup.list_command.value="<%=JSPCommand.NEXT%>";
                document.frmGroup.action="grouplist.jsp";
                document.frmGroup.submit();
            }
            function last(){
                document.frmGroup.command.value="<%=JSPCommand.LAST%>";
                document.frmGroup.list_command.value="<%=JSPCommand.LAST%>";
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                        
                                                        <form name="frmGroup" method="post" action="">
                                                            <input type="hidden" name="command" value="">
                                                            <input type="hidden" name="group_oid" value="<%=appGroupOID%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Administrator</font><font class="tit1"> 
                                                                                        &raquo; </font><span class="lvl2">User Group 
                                                                                List</span></b></td>
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
                                                                        <table width="100%" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp; </td>
                                                                            </tr>
                                                                            <% if ((listGroup != null) && (listGroup.size() > 0)) {%>
                                                                            <tr> 
                                                                                <td colspan="2"><%=drawListGroup(listGroup)%></td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td colspan="2" height="20">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2"> 
                                                                                    <div class="comment">&nbsp;&nbsp;&nbsp;&nbsp;No 
                                                                                    Group available</div>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                        <table width="100%" cellpadding="0" cellspacing="0">
                                                                            <tr> 
                                                                                <td colspan="2"> <span class="command"> <%=ctrLine.drawMeListLimit(listJSPCommand, vectSize, start, recordToGet, "first", "prev", "next", "last", "left")%> </span> </td>
                                                                            </tr>
                                                                            <% if (privAdd) {%>
                                                                            <tr> 
                                                                                <td colspan="2" class="command"> 
                                                                                    <table width="39%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="24%">&nbsp;</td>
                                                                                            <td width="76%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <% if (privAdd) {%>
                                                                                            <td width="24%"><a href="javascript:addNew()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100','','<%=approot%>/images/new2.gif',1)"><img name="Image100" border="0" src="../images/new.gif" width="71" height="22" alt="Add New User"></a></td>
                                                                                            <%}%>
                                                                                            <td width="76%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr> 
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="87%">&nbsp;</td>
                                                                            </tr>
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
