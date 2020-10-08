
<%-- 
    Document   : memberpointrecords
    Created on : Apr 12, 2015, 5:40:41 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>  
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>  
<%@ page import = "com.project.util.*" %>  
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.memberpoint.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidMemberPoint = JSPRequestValue.requestLong(request, "hidden_member_point_id");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            int pointType = JSPRequestValue.requestInt(request, "point_type");
            int groupBy = JSPRequestValue.requestInt(request, "group_by");
            int orderBy = JSPRequestValue.requestInt(request, "order_by");

            if (session.getValue("REPORT_POINT_MEMBER_XLS") != null) {
                session.removeValue("REPORT_POINT_MEMBER_XLS");
            }

            if (iJSPCommand == JSPCommand.NONE) {
                pointType = 1;
            }

            String srcDate = JSPRequestValue.requestString(request, "src_start_date");
            String srcDateEnd = JSPRequestValue.requestString(request, "src_end_date");

            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            if (iJSPCommand != JSPCommand.NONE) {
                srcStartDate = JSPFormater.formatDate(srcDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcDateEnd, "dd/MM/yyyy");
            }
            
            Vector print = new Vector();
            
            String str = "";
            if(pointType==1){
                str = " In";                
            }else{
                str = " Out";
            }
            
            

%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
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
                window.open("<%=printroot%>.report.ReportPointXLS?user_id=<%=appSessUser.getUserOID()%>&str=<%=str%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmmemberpoint.hidden_member_point_id.value="0";
                    document.frmmemberpoint.command.value="<%=JSPCommand.POST%>";
                    document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                    document.frmmemberpoint.action="memberpointrecords.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmmemberpoint" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_member_point_id" value="<%=oidMemberPoint%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                    <tr valign="bottom"> 
                                                                                                        <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                                                Maintenance </font><font class="tit1">&raquo; 
                                                                                                                </font><span class="lvl2">Member 
                                                                                                        Record</span></b></td>
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
                                                                                                        <td width="9%" height="18">Start Date </td>
                                                                                                        <td width="15%" height="18"> 
                                                                                                            <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmemberpoint.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        </td>
                                                                                                        <td width="49%" height="18">&nbsp;</td>
                                                                                                        <td width="27%" height="18">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="9%" height="18">End Date </td>
                                                                                                        <td width="15%" height="18"> 
                                                                                                            <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmemberpoint.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        </td>
                                                                                                        <td width="49%" height="18">&nbsp;</td>
                                                                                                        <td width="27%" height="18">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="9%" height="18">Member Number</td>
                                                                                                        <td width="15%" height="18"> 
                                                                                                            <input type="text" name="src_code" value="<%=srcCode%>">
                                                                                                        </td>
                                                                                                        <td width="49%" height="18">&nbsp;</td>
                                                                                                        <td width="27%" height="18">&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr> 
                                                                                                        <td width="9%" height="18">Cash Back Type</td>
                                                                                                        <td width="15%" height="18"> 
                                                                                                            <select name="point_type">
                                                                                                                <option value="1" <%if (pointType == 1) {%> selected <%}%> >Cash Back In</option>
                                                                                                                <option value="-1" <%if (pointType == -1) {%> selected <%}%> >Cash Back Out</option>
                                                                                                            </select>    
                                                                                                        </td>
                                                                                                        <td width="49%" height="18">&nbsp;</td>
                                                                                                        <td width="27%" height="18">&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr> 
                                                                                                        <td width="9%" height="18">Group By</td>
                                                                                                        <td width="15%" height="18"> 
                                                                                                            <select name="group_by">
                                                                                                                <option value="0" <%if (groupBy == 0) {%> selected <%}%> >Cash Back Member</option>
                                                                                                                <option value="1" <%if (groupBy == 1) {%> selected <%}%> >Member</option>
                                                                                                            </select>    
                                                                                                        </td>
                                                                                                        <td width="49%" height="18">&nbsp;</td>
                                                                                                        <td width="27%" height="18">&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr> 
                                                                                                        <td width="9%" height="18">Order By</td>
                                                                                                        <td width="15%" height="18"> 
                                                                                                            <select name="order_by">
                                                                                                                <option value="0" <%if (orderBy == 0) {%> selected <%}%> >Member Name</option>
                                                                                                                <option value="1" <%if (orderBy == 1) {%> selected <%}%> >Date Transaction</option>
                                                                                                            </select>    
                                                                                                        </td>
                                                                                                        <td width="49%" height="18">&nbsp;</td>
                                                                                                        <td width="27%" height="18">&nbsp;</td>
                                                                                                    </tr> 
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="14" valign="middle" colspan="3" class="comment"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('src21','','../images/search2.gif',1)"><img src="../images/search.gif" name="src21" border="0"></a></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="25" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="1000" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="25" class="tablehdr">No</td>
                                                                                                        <td width="80" class="tablehdr">Code</td>
                                                                                                        <td class="tablehdr">Member</td>
                                                                                                        <td width="80" class="tablehdr">Date</td>
                                                                                                        <td width="80" class="tablehdr">Cash Back<%=str%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                    int no = 1;
                                                                                                    double totPoint = 0;
            try {
                CONResultSet dbrs = null;
                String sql = "select m.member_point_id,c.customer_id,c.code as code,c.name as name,m.date as dtx,sum(m.point) as point from pos_member_point m inner join customer c on m.customer_id = c.customer_id where m.date between ('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00') and ('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59') and m.in_out = " + pointType;

                
                if(srcCode != null && srcCode.length() > 0){
                    sql = sql + " and c.code like '%"+srcCode+"%'";
                }
                
                if (groupBy == 0) {
                    sql = sql + " group by m.member_point_id ";
                } else {
                    sql = sql + " group by c.customer_id ";
                }

                if (orderBy == 0) {
                    sql = sql + " order by c.name ";
                } else {
                    sql = sql + " order by m.date ";
                }

                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();

                String style = "tablearialcell1";
                
                while (rs.next()) {
                    if (no % 2 == 0) {
                        style = "tablearialcell1";
                    } else {
                        style = "tablearialcell";
                    }
                    String code = rs.getString("code");
                    String name = rs.getString("name");
                    Date dt = rs.getDate("dtx");
                    double point = rs.getDouble("point");
                    totPoint = totPoint + point ;

                    Vector tmpPrint = new Vector();
                    tmpPrint.add(code);
                    tmpPrint.add(name);                    
                    tmpPrint.add("" + JSPFormater.formatDate(dt, "dd/MM/yyyy"));
                    tmpPrint.add("" + point);
                    print.add(tmpPrint);

                                                                                                    %>    
                                                                                                    <tr> 
                                                                                                        <td class="<%=style%>" align="center"><%=no%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px"><%=code%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px"><%=name.toUpperCase()%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px" align="center"><%=JSPFormater.formatDate(dt, "dd-MM-yyyy") %></td>
                                                                                                        <td class="<%=style%>" style="padding:3px" align="right"><%=JSPFormater.formatNumber(point, "###,###.##") %></td>
                                                                                                    </tr>
                                                                                                    <%
                    no++;
                }

            } catch (Exception e) {
            }


            if (no > 1) {
                session.putValue("REPORT_POINT_MEMBER_XLS",print);
                
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td bgcolor="#CCCCCC" align="center" colspan="4"><b>T O T A L</b></td>
                                                                                                        
                                                                                                        <td bgcolor="#CCCCCC" style="padding:3px" align="right"><b><%=JSPFormater.formatNumber(totPoint, "###,###.##") %></b></td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="5">&nbsp;</td>     
                                                                                                    </tr> 
                                                                                                    <%if(privPrint){%>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="5">                                                                                                                                                 
                                                                                                            <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                        </td>     
                                                                                                    </tr> 
                                                                                                    <%}%>
                                                                                                    <%}%>
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
                                                        </form>
                                                    <!-- #EndEditable --> </td>
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
