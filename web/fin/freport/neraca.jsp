
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA, AppMenu.PRIV_DELETE);
%>
<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            Vector temp = DbRptFormat.list(0, 0, DbRptFormat.colNames[DbRptFormat.COL_REPORT_TYPE] + "=" + DbRptFormat.REPORT_TYPE_BALANCE_SHEET, DbRptFormat.colNames[DbRptFormat.COL_CREATE_DATE]);
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            boolean isGereja = DbSystemProperty.getModSysPropGereja();

            /*** LANG ***/
            String[] langFR = {"Show List", "Account With Transaction", "All", "BALANCE SHEET", "PERIOD", //0-4
                "Description", "Total"}; //5-6
            String[] langNav = {"Financial Report", "Balance Sheet"};

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "NERACA", "PERIODE", //0-4
                    "Keterangan", "Total"}; //5-6
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Neraca"};
                langNav = navID;
            }

            Vector actPeriods = DbActivityPeriod.list(0, 0, "", "");
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            //-->
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
                                                    <td class="title"><!-- #BeginEditable "title" --><%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form id="form1" name="frmneraca" method="post" action="neraca_rpt.jsp">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">						  
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="92%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%" nowrap>Select Report&nbsp;&nbsp;</td>
                                                                                <td width="92%"> 
                                                                                    <select name="rpt_format_id">
                                                                                        <%if (temp != null && temp.size() > 0) {
                for (int i = 0; i < temp.size(); i++) {
                    RptFormat rptFormat = (RptFormat) temp.get(i);
                                                                                        %>
                                                                                        <option value="<%=rptFormat.getOID()%>"><%=rptFormat.getName()%></option>
                                                                                        <%}
            }%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                            <td height="5">
                                                                                <td></td>
                                                                                <td></td>
                                                                            </tr> 
                                                                            <%if (isGereja || (vSeg != null && vSeg.size() > 0)) {%>
                                                                            <%
    if (vSeg != null && vSeg.size() > 0) {

        User usr = new User();
        try {
            usr = DbUser.fetch(appSessUser.getUserOID());
        } catch (Exception e) {
        }

        for (int xs = 0; xs < vSeg.size(); xs++) {

            Segment oSegment = (Segment) vSeg.get(xs);
            int pgs = xs + 1;
            long seg_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pgs + "_ID");

                                                                            %>
                                                                            <tr>
                                                                                <td ><%=oSegment.getName()%></td>
                                                                                <td >
                                                                                    <%
                                                                                    String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + oSegment.getOID();

                                                                                    switch (xs + 1) {
                                                                                        case 1:
                                                                                            //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                                                                                            //maka akan di tampikan sesuai dengan segment yang ditentukan
                                                                                            if (usr.getSegment1Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment1Id();
                                                                                            }
                                                                                            break;
                                                                                        case 2:
                                                                                            if (usr.getSegment2Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment2Id();
                                                                                            }
                                                                                            break;
                                                                                        case 3:
                                                                                            if (usr.getSegment3Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment3Id();
                                                                                            }
                                                                                            break;
                                                                                        case 4:
                                                                                            if (usr.getSegment4Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment4Id();
                                                                                            }
                                                                                            break;
                                                                                        case 5:
                                                                                            if (usr.getSegment5Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment5Id();
                                                                                            }
                                                                                            break;
                                                                                        case 6:
                                                                                            if (usr.getSegment6Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment6Id();
                                                                                            }
                                                                                            break;
                                                                                        case 7:
                                                                                            if (usr.getSegment7Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment7Id();
                                                                                            }
                                                                                            break;
                                                                                        case 8:
                                                                                            if (usr.getSegment8Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment8Id();
                                                                                            }
                                                                                            break;
                                                                                        case 9:
                                                                                            if (usr.getSegment9Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment9Id();
                                                                                            }
                                                                                            break;
                                                                                        case 10:
                                                                                            if (usr.getSegment10Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment10Id();
                                                                                            }
                                                                                            break;
                                                                                        case 11:
                                                                                            if (usr.getSegment11Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment11Id();
                                                                                            }
                                                                                            break;
                                                                                        case 12:
                                                                                            if (usr.getSegment12Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment12Id();
                                                                                            }
                                                                                            break;
                                                                                        case 13:
                                                                                            if (usr.getSegment13Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment13Id();
                                                                                            }
                                                                                            break;
                                                                                        case 14:
                                                                                            if (usr.getSegment14Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment14Id();
                                                                                            }
                                                                                            break;
                                                                                        case 15:
                                                                                            if (usr.getSegment15Id() != 0) {
                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment15Id();
                                                                                            }
                                                                                            break;
                                                                                    }
                                                                                    Vector segDet = DbSegmentDetail.list(0, 0, wh, "");
                                                                                    %>
                                                                                    <select name="JSP_SEGMENT<%=xs + 1%>_ID" >
                                                                                        <%if (actPeriods != null && actPeriods.size() > 0) {
                                                                                        for (int i = 0; i < segDet.size(); i++) {
                                                                                            SegmentDetail ap = (SegmentDetail) segDet.get(i);
                                                                                        %>
                                                                                        <option value="<%=ap.getOID()%>" <%if (ap.getOID() == seg_id) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                        <%
                                                                                        }
                                                                                    }
                                                                                        %>
                                                                                    </select>
                                                                                </td>
                                                                            </tr> 
                                                                            <td height="5">
                                                                                <td></td>
                                                                                <td></td>
                                                                            </tr> 
                                                                            <%
        }
    }
                                                                            %>                                                                            
                                                                            <%}%>                                                                            
                                                                            
                                                                            <tr> 
                                                                                <td colspan="2" height="5"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="92%"> 
                                                                                    <input type="submit" name="Submit" value="Create Report">
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="92%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="92%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="92%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="92%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="92%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="92%">&nbsp;</td>
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
