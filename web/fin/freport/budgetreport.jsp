
<%-- 
    Document   : budgetreport
    Created on : Apr 1, 2016, 9:52:57 AM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT_BUDGET);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT_BUDGET, AppMenu.PRIV_VIEW);
%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String grpType = JSPRequestValue.requestString(request, "groupType");
            String[] a = request.getParameterValues("segment1_id");
            long segment1Id = JSPRequestValue.requestLong(request, "segment1_id");
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            Date startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
            Date endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_date"), "dd/MM/yyyy");

            String[] langNav = {"Financial Report", "Budget Used Report", "Segment", "Range Date"};

            if (lang == LANG_ID) {
                String[] navID = {"Laporan Keuangan", "Laporan Penggunaan Anggaran", "Segment", "Range Tanggal"};
                langNav = navID;
            }

            String whereClause = "";
            if (a != null && a.length > 0) {
                String str = "";
                for (int x = 0; x < a.length; x++) {
                    if (str != null && str.length() > 0) {
                        str = str + ",";
                    }
                    str = str + Long.parseLong(a[x].trim());
                }
                whereClause = " br." + DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID] + " in (" + str + ") ";
            } else {
                whereClause = " br." + DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID] + " = 0 ";
            }

            Vector segments = DbSegmentUser.userSegments(user.getOID(), 0);
            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");

            Periode p = new Periode();
            try {
                if (periodId != 0) {
                    p = DbPeriode.fetchExc(periodId);
                }
            } catch (Exception e) {
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />        
        <script type="text/javascript" src="<%=approot%>/js/jquery.min.js"></script>
        <link href="<%=approot%>/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%=approot%>/js/bootstrap.min.js"></script>
        <link href="<%=approot%>/js/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
        <script src="<%=approot%>/js/bootstrap-multiselect.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(function () {
                $('#lstSegment').multiselect({
                    includeSelectAllOption: true
                });
                $('#btnSelected').click(function () {
                    var selected = $("#lstSegment option:selected");
                    var message = "";
                    selected.each(function () {
                        message += $(this).text() + " " + $(this).val() + "\n";
                    });
                    alert(message);
                });
            });
        </script>
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmbudgetreport.command.value="<%=JSPCommand.SEARCH%>";    
                document.frmbudgetreport.action="budgetreport.jsp";
                document.frmbudgetreport.submit();
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
            //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif','../images/newdoc2.gif','../images/deletedoc2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --> 
                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmbudgetreport" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                                                               
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                    
                                                            <%try {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="4" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td colspan="3" height="10"></td>
                                                                                        </tr>         
                                                                                        <tr>
                                                                                            <td width="100" class="fontarial" style="padding:3px;">Period</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td>
                                                                                                <select name="period_id">
                                                                                                    <%
    if (periods != null && periods.size() > 0) {
        for (int i = 0; i < periods.size(); i++) {
            Periode per = (Periode) periods.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=per.getOID()%>" <%if (per.getOID() == periodId) {%>selected<%}%>><%=per.getName()%></option>
                                                                                                    <% }
    }%>
                                                                                                </select>    
                                                                                            </td>                                                                                
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="100" class="fontarial" style="padding:3px;">Group</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td>
                                                                                                <select name="groupType" class="fontarial">
                                                                                                    <option value="All" <%if (grpType.equals("All")) {%>selected<%}%>>- Semua Group -</option>
                                                                                                    <%for (int i = 0; i < I_Project.accGroup.length; i++) {%>
                                                                                                    <option value="<%=I_Project.accGroup[i]%>" <%if (I_Project.accGroup[i].equals(grpType)) {%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                                                                                                    <%}%>
                                                                                                </select>  
                                                                                            </td>                                                                                
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="100" class="fontarial" style="padding:3px;">Segment</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td>
                                                                                                <select name="segment1_id" id="lstSegment" multiple="multiple"  >
                                                                                                    <%
    if (segments != null && segments.size() > 0) {
        for (int i = 0; i < segments.size(); i++) {
            SegmentDetail sd = (SegmentDetail) segments.get(i);
            boolean selected = false;
            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.BACK) {
                selected = true;
            } else {
                if (a != null) {
                    for (int x = 0; x < a.length; x++) {
                        if (sd.getOID() == Long.parseLong(a[x].trim())) {
                            selected = true;
                            break;
                        }
                    }
                }
            }
                                                                                                    %>
                                                                                                    
                                                                                                    <option value="<%=sd.getOID()%>" <%if (selected) {%> selected<%}%> ><%=sd.getName()%></option>
                                                                                                    <% }
    }%>                                                                                                    
                                                                                                </select>
                                                                                            </td>                                                                                
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="20"><a href="javascript:cmdSearch()"><img src="../images/success.gif" border="0"></a></td>                                                                                            
                                                                                        <td class="fontarial"><a href="javascript:cmdSearch()"><i>Search</i></a></td>
                                                                                    </tr>
                                                                                    
                                                                                </td>
                                                                            </tr> 
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> &nbsp;</td>
                                                                            </tr> 
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3">
                                                                                    <table border="0" cellpadding="0" cellspacing="1"> 
                                                                                        <tr>
                                                                                            <td class="tablehdr" width="35">No</td>
                                                                                            <td class="tablehdr" width="400">Akun Perkiraan</td>
                                                                                            <td class="tablehdr" width="150">Ytd</td>
                                                                                            <td class="tablehdr" width="50">%</td>
                                                                                            <td class="tablehdr" width="150">Mtd</td>
                                                                                            <td class="tablehdr" width="50">%</td>
                                                                                        </tr>    
                                                                                        <%

    String grp = "";
    if (grpType.compareTo("All") != 0) {
        grp = " where c.account_group = '" + grpType + "' ";
    }

    CONResultSet crs = null;

    try {

        String sql = "select coa_id,code,level,name,sum(ytd) as ytd,sum(mtd) as mtd from ( " +
                " select 1 as idx,c.coa_id as coa_id,c.code as code,c.level,c.name,0 as ytd,sum(brd.mtd) as mtd from coa c left join " +
                " (select brd.coa_id,br.segment1_id,0 as ytd,sum(brd.request) as mtd from budget_request br inner join budget_request_detail brd on br.budget_request_id = brd.budget_request_id inner join coa c on brd.coa_id = c.coa_id where " + whereClause + " and c.account_group = 'expense' and brd.date between '" + JSPFormater.formatDate(p.getStartDate(), "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(p.getEndDate(), "yyyy-MM-dd") + " 23:59:59' group by c.coa_id) brd on c.coa_id = brd.coa_id " +
                grp + " group by c.coa_id union " +
                " select 2 as idx,c.coa_id as coa_id,c.code as code,c.level,c.name,sum(ytd) as ytd,0 as mtd from coa c left join " +
                " (select brd.coa_id,br.segment1_id,sum(brd.request) as ytd,0 as mtd from budget_request br inner join budget_request_detail brd on br.budget_request_id = brd.budget_request_id inner join coa c on brd.coa_id = c.coa_id where " + whereClause + " and c.account_group = 'expense' and brd.date between '" + (p.getEndDate().getYear() + 1900) + "-01-31 00:00:00' and '" + JSPFormater.formatDate(p.getEndDate(), "yyyy-MM-dd") + " 23:59:59' group by c.coa_id) brd on c.coa_id = brd.coa_id " +
                grp + " group by c.coa_id ) as x group by coa_id order by code ";
        
        
        crs = CONHandler.execQueryResult(sql);
        ResultSet rs = crs.getResultSet();
        int i = 1;
        while (rs.next()) {
            String cssString = "tablecell";
            if (i % 2 != 0) {
                cssString = "tablecell1";
            }

            int level = rs.getInt("level");
            String code = rs.getString("code");
            String name = rs.getString("name");
            String str = "";
            switch (level) {
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
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }
            
            double ytd = rs.getDouble("ytd");
            double mtd = rs.getDouble("mtd");


                                                                                        %>
                                                                                        
                                                                                        <tr>
                                                                                            <td class="<%=cssString%>" align="center" style="padding:3px;" ><%=i%></td>
                                                                                            <td class="<%=cssString%>" style="padding:3px;"><%=(str + code + " - " + name)%> </td>
                                                                                            <td class="<%=cssString%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(ytd, "###,###.##")%></td>
                                                                                            <td class="<%=cssString%>" align="center" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")%></td>
                                                                                            <td class="<%=cssString%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(mtd, "###,###.##")%></td>
                                                                                            <td class="<%=cssString%>" align="center" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")%></td>
                                                                                        </tr> 
                                                                                        
                                                                                        
                                                                                        <%
            i++;

        }

    } catch (Exception e) {
    }
                                                                                        
                                                                                        
                                                                                        %> 
                                                                                    </table>
                                                                                </td>
                                                                            </tr> 
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                
                                                            </table>
                                                            <%} catch (Exception e) {
                out.println(e.toString());
            }%>                                             
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
                            <td height="25" colspan="2"> <!-- #BeginEditable "footer" --> 
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
