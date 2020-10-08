
<%-- 
    Document   : generate_pnl
    Created on : Apr 27, 2015, 3:50:26 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS, AppMenu.PRIV_DELETE);
%>
<%!
    public String switchLevel(int level) {
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
        return str;
    }

    public String switchLevel1(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "       ";
                break;
            case 3:
                str = "              ";
                break;
            case 4:
                str = "                     ";
                break;
            case 5:
                str = "                            ";
                break;
        }
        return str;
    }

    public String strDisplay(double amount, String coaStatus, int header) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
        } else if (amount >= 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###.##");
        }

        if (header == 1) {
            if (coaStatus.equals("POSTABLE")) {
                displayStr = "";
            }
        } else {
            if (coaStatus.equals("HEADER")) {
                displayStr = "";
            }
        }

        return displayStr;
    }

%>
<%


            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            long periodeId = JSPRequestValue.requestLong(request, "periode_id");

            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            String whereMd = "";
            String oidMd = "";
            long segment1Id = 0;

            if (vSeg != null && vSeg.size() > 0 && iJSPCommand != JSPCommand.NONE) {
                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {
                    int pg = iSeg + 1;
                    long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");
                    oidMd = oidMd + ";" + segment_id;

                    if (segment_id != 0) {
                        if (whereMd.length() > 0) {
                            whereMd = whereMd + " and ";
                        }

                        if (iSeg == 0) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                            segment1Id = segment_id;
                        } else if (iSeg == 1) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                        } else if (iSeg == 2) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                        } else if (iSeg == 3) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                        } else if (iSeg == 4) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                        } else if (iSeg == 5) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                        } else if (iSeg == 6) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                        } else if (iSeg == 7) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                        } else if (iSeg == 8) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                        } else if (iSeg == 9) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                        } else if (iSeg == 10) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                        } else if (iSeg == 11) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                        } else if (iSeg == 12) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                        } else if (iSeg == 13) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                        } else if (iSeg == 14) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                        }
                    }
                }
            }


            String[] langNav = {"Financial Report", "Generate Profit & Loss ", "Previous Period", "Period", "Klik GO button to searching the data", "Month", "Year", "Searching Parameter"};

            if (lang == LANG_ID) {
                String[] navID = {"Laporan Keuangan", "Generate Laba Rugi", "Periode Sebelumnya", "Periode", "Klik tombol GO untuk melakukan pencarian", "Bulan", "Tahun", "Parameter Pencarian"};
                langNav = navID;
            }

            if (iJSPCommand == JSPCommand.ACTIVATE) {
                SessGeneratePNL.genPNL(segment1Id, periodeId);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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
            
            function cmdGO(){
                document.all.closecmd.style.display="none";
                document.all.closemsg.style.display="";
                document.frmcoa.action="generate_pnl.jsp";
                document.frmcoa.command.value="<%=JSPCommand.ACTIVATE%>";
                document.frmcoa.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/printxls2.gif')">
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
                                                        <form name="frmcoa" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                                        
                                                            <input type="hidden" name="hidden_coa_id" value="<%=oidCoa%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table border="0" width="100%" cellpadding="1" cellspacing="1">          
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr>
                                                                                            <td colspan="6" height="10"></td>
                                                                                        </tr>    
                                                                                        <tr>                                                                                                         
                                                                                            <td colspan="6" ><table ><tr><td class="tablehdr"></td><td class="fontarial"><b><i><%=langNav[7]%> :</i></b></td></tr></table></td>
                                                                                        </tr>
                                                                                        <%
            if (vSeg != null && vSeg.size() > 0) {
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
                                                                                        
                                                                                        <tr align="left" height="22"> 
                                                                                            <td width="80" class="tablecell1">&nbsp;&nbsp;<%=oSegment.getName()%></td>
                                                                                            <td class="fontarial" width="1">:</td>
                                                                                            <td > 
                                                                                                <%
                                                                                                    String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + oSegment.getOID();
                                                                                                    switch (xs + 1) {
                                                                                                        case 1:
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
                                                                                                    Vector segDet = DbSegmentDetail.list(0, 0, wh, DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
                                                                                                %>
                                                                                                <select name="JSP_SEGMENT<%=xs + 1%>_ID" >
                                                                                                    <option value="0" <%if (0 == seg_id) {%>selected<%}%>>- All Location - </option>
                                                                                                    <%
                                                                                                    for (int i = 0; i < segDet.size(); i++) {
                                                                                                        SegmentDetail ap = (SegmentDetail) segDet.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=ap.getOID()%>" <%if (ap.getOID() == seg_id) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                                    <%
                                                                                                    }
                                                                                                    %>
                                                                                                </select>     
                                                                                            </td>                                                                                            
                                                                                        </tr> 
                                                                                        <%
                    }

                }
            }%>
                                                                                        
                                                                                        
                                                                                        <%
            Vector vPeriode = new Vector();
            vPeriode = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc ");
                                                                                        %>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablecell1">&nbsp;&nbsp;<%=langNav[5]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name="periode_id" class="fontarial">
                                                                                                    <%
            if (vPeriode != null && vPeriode.size() > 0) {
                for (int i = 0; i < vPeriode.size(); i++) {
                    Periode p = (Periode) vPeriode.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=p.getOID()%>" <%if (p.getOID() == periodeId) {%>selected<%}%>><%=p.getName()%></option>
                                                                                                    <%
                }
            }%>                                                                                                    
                                                                                                </select>
                                                                                            </td>                                                                                           
                                                                                        </tr>     
                                                                                        <tr align="left" > 
                                                                                            <td colspan="6">
                                                                                                <table width="800">
                                                                                                    <tr>
                                                                                                        <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22" id="closecmd">                                                                                             
                                                                                            <td colspan="3"><input type="button" name="Button" value="GO" onClick="javascript:cmdGO()"></td>
                                                                                        </tr>
                                                                                        <tr id="closemsg" align="left" valign="top"> 
                                                                                            <td colspan="3" height="22" valign="middle" > 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                      
                                                                                                    <tr> 
                                                                                                        <td><font color="#006600">Generate in progress, please wait .... </font> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td height="1">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td><img src="../images/progress_bar.gif" border="0"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>                                                                                                                                            
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>                                                                            
                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                                                                                
                                                            </table>
                                                            <script language="JavaScript">
                    document.all.closecmd.style.display="";
                    document.all.closemsg.style.display="none";
                </script>
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

