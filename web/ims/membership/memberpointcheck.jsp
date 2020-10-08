<%@ page language = "java" %>
<%@ page import = "java.util.*" %>  
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>  
<%@ page import = "com.project.util.*" %>  
<%@ page import = "com.project.util.jsp.*" %> 
<%//@ page import = "com.project.fms.journal.*" %>    
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.postransaction.memberpoint.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long memberPointId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tableheader");
        ctrlist.setCellStyle("cellStyle");
        ctrlist.setHeaderStyle("tableheader");
        ctrlist.addHeader("Date", "14%");
        ctrlist.addHeader("Customer", "14%");
        ctrlist.addHeader("Type", "14%");
        ctrlist.addHeader("Point", "14%");
        ctrlist.addHeader("In Out", "14%");
        ctrlist.addHeader("Point Value", "14%");
        ctrlist.addHeader("Sales", "14%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            MemberPoint memberPoint = (MemberPoint) objectClass.get(i);
            Vector rowx = new Vector();
            if (memberPointId == memberPoint.getOID()) {
                index = i;
            }

            String str_dt_Date = "";
            try {
                Date dt_Date = memberPoint.getDate();
                if (dt_Date == null) {
                    dt_Date = new Date();
                }

                str_dt_Date = JSPFormater.formatDate(dt_Date, "dd/MM/yyyy");
            } catch (Exception e) {
                str_dt_Date = "";
            }

            rowx.add(str_dt_Date);

            Customer cus = new Customer();
            try {
                cus = DbCustomer.fetchExc(memberPoint.getCustomerId());
            } catch (Exception e) {
            }

            rowx.add(cus.getName());

            rowx.add(String.valueOf(memberPoint.getPoint()));

            rowx.add(String.valueOf(memberPoint.getInOut()));

            rowx.add(String.valueOf(memberPoint.getType()));

            rowx.add(String.valueOf(memberPoint.getPointUnitValue()));

            rowx.add(String.valueOf(memberPoint.getSalesId()));

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(memberPoint.getOID()));
        }

        return ctrlist.drawList(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidMemberPoint = JSPRequestValue.requestLong(request, "hidden_member_point_id");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcDate = JSPRequestValue.requestString(request, "src_start_date");
            Date srcStartDate = new Date();
            if (iJSPCommand != JSPCommand.NONE) {
                srcStartDate = JSPFormater.formatDate(srcDate, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdMemberPoint ctrlMemberPoint = new CmdMemberPoint(request);
            JSPLine ctrLine = new JSPLine();
            Vector listMemberPoint = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlMemberPoint.action(iJSPCommand, oidMemberPoint);
            /* end switch*/
            JspMemberPoint jspMemberPoint = ctrlMemberPoint.getForm();

            /*count list All MemberPoint*/
            int vectSize = DbMemberPoint.getCount(whereClause);

            Customer cus = new Customer();
            Vector result = new Vector();
            double pointx = 0;
            if (iJSPCommand == JSPCommand.POST) {
                try {
                    Vector temp = DbCustomer.list(0, 1, "code='" + srcCode + "'", "");
                    if (temp != null && temp.size() > 0) {
                        cus = (Customer) temp.get(0);

                        CONResultSet dbrs = null;
                        try {
                            String sql = "select sum(point*in_out) from pos_member_point where customer_id=" + cus.getOID();

                            dbrs = CONHandler.execQueryResult(sql);
                            ResultSet rs = dbrs.getResultSet();

                            int count = 0;
                            while (rs.next()) {
                                pointx = rs.getDouble(1);
                            }

                            rs.close();

                        } catch (Exception e) {

                        } finally {
                            CONResultSet.close(dbrs);
                        }


                    }
                } catch (Exception e) {
                }

            }


%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Finance System</title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdSearch(){
                document.frmmemberpoint.hidden_member_point_id.value="0";
                document.frmmemberpoint.command.value="<%=JSPCommand.POST%>";
                document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdAdd(){
                document.frmmemberpoint.hidden_member_point_id.value="0";
                document.frmmemberpoint.command.value="<%=JSPCommand.ADD%>";
                document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdAsk(oidMemberPoint){
                document.frmmemberpoint.hidden_member_point_id.value=oidMemberPoint;
                document.frmmemberpoint.command.value="<%=JSPCommand.ASK%>";
                document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdConfirmDelete(oidMemberPoint){
                document.frmmemberpoint.hidden_member_point_id.value=oidMemberPoint;
                document.frmmemberpoint.command.value="<%=JSPCommand.DELETE%>";
                document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            function cmdSave(){
                document.frmmemberpoint.command.value="<%=JSPCommand.SAVE%>";
                document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdEdit(oidMemberPoint){
                document.frmmemberpoint.hidden_member_point_id.value=oidMemberPoint;
                document.frmmemberpoint.command.value="<%=JSPCommand.EDIT%>";
                document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdCancel(oidMemberPoint){
                document.frmmemberpoint.hidden_member_point_id.value=oidMemberPoint;
                document.frmmemberpoint.command.value="<%=JSPCommand.EDIT%>";
                document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdBack(){
                document.frmmemberpoint.command.value="<%=JSPCommand.BACK%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdListFirst(){
                document.frmmemberpoint.command.value="<%=JSPCommand.FIRST%>";
                document.frmmemberpoint.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdListPrev(){
                document.frmmemberpoint.command.value="<%=JSPCommand.PREV%>";
                document.frmmemberpoint.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdListNext(){
                document.frmmemberpoint.command.value="<%=JSPCommand.NEXT%>";
                document.frmmemberpoint.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
            }
            
            function cmdListLast(){
                document.frmmemberpoint.command.value="<%=JSPCommand.LAST%>";
                document.frmmemberpoint.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmmemberpoint.action="memberpointcheck.jsp";
                document.frmmemberpoint.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/search2.gif')">
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmmemberpoint" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_member_point_id" value="<%=oidMemberPoint%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                    <tr valign="bottom"> 
                                                                                                        <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                                                Maintenance </font><font class="tit1">&raquo; 
                                                                                                                </font><span class="lvl2">Check 
                                                                                                        Point</span></b></td>
                                                                                                        <td width="40%" height="23"> 
                                                                                                            <%@ include file = "../main/userpreview.jsp" %>
                                                                                                            <%@ include file="../calendar/calendarframe.jsp"%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr > 
                                                                                                        <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="14" valign="middle" colspan="3" class="comment"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="9%" height="18">Member 
                                                                                                        Number</td>
                                                                                                        <td width="15%" height="18"> 
                                                                                                            <input type="text" name="src_code" value="<%=srcCode%>">
                                                                                                        </td>
                                                                                                        <td width="49%" height="18"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('src21','','../images/search2.gif',1)"><img src="../images/search.gif" name="src21" border="0"></a></td>
                                                                                                        <td width="27%" height="18">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="9%" height="17">&nbsp;</td>
                                                                                                        <td width="15%" height="17">&nbsp;</td>
                                                                                                        <td width="49%" height="17">&nbsp;</td>
                                                                                                        <td width="27%" height="17">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (iJSPCommand == JSPCommand.POST) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="20" valign="middle" colspan="3" class="comment"><b>Member 
                                                                                            Name : <%=cus.getName()%></b></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="20" valign="middle" colspan="3" class="comment"><b>Code 
                                                                                            : <%=cus.getCode()%></b></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="34" valign="middle" colspan="3" class="comment"><b><font size="3">Your 
                                                                                                    </font><font size="3">Current Point 
                                                                                            : <%=JSPFormater.formatNumber(pointx, "#,###")%></font></b></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <%if (iJSPCommand == JSPCommand.POST && cus.getOID() == 0) {%>
                                                                                                <font color="#FF0000">Can't found 
                                                                                                member data</font> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">&nbsp; </td>
                                                                            </tr>
                                                                    </table></td>
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
