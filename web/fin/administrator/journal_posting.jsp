
<%-- 
    Document   : journal_posting
    Created on : Oct 12, 2015, 4:02:18 PM
    Author     : Roy
--%>

<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.*"%>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_DELETE);
%>

<%

            int iCommand = JSPRequestValue.requestCommand(request);
            long glId = JSPRequestValue.requestLong(request, "gl_id");
            Gl gl = new Gl();
            try {
                gl = DbGl.fetchExc(glId);
            } catch (Exception e) {
            }

            Vector details = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), "debet desc");
            User userPost = new User();
            try {

                if (gl.getPostedById() != 0) {
                    userPost = DbUser.fetch(gl.getPostedById());
                }
            } catch (Exception e) {
            }

            if (iCommand == JSPCommand.SUBMIT) {

                if (gl.getJournalType() == I_Project.JOURNAL_TYPE_SALES) {
                    Vector sysDoc = DbSystemDocNumber.list(0, 1, DbSystemDocNumber.colNames[DbSystemDocNumber.COL_DOC_NUMBER] + " = '" + gl.getJournalNumber().trim() + "'", null);
                    Vector list = new Vector();
                    Sales sales = new Sales();
                    if (sysDoc != null && sysDoc.size() > 0) {
                        try {
                            SystemDocNumber sDoc = (SystemDocNumber) sysDoc.get(0);
                            if (sDoc.getOID() != 0) {
                                Vector sl = DbSales.list(0, 1, DbSales.colNames[DbSales.COL_SYSTEM_DOC_NUMBER_ID] + " = " + sDoc.getOID(), null);
                                try {
                                    sales = (Sales) sl.get(0);
                                    list = DbSales.getDataClosing(sales.getDate(), sales.getLocation_id(), sales.getCashCashierId());
                                } catch (Exception e) {
                                }
                            }
                        } catch (Exception e) {
                        }
                    }
                    if (gl.getOID() != 0 && sales.getOID() != 0) {
                        int stockable = 0;
                        try {
                            stockable = Integer.parseInt(DbSystemProperty.getValueByName("STOCKABLE_DEFAULT"));
                        } catch (Exception e) {
                        }
                        Vector currencys = DbCurrency.list(0, 0, "", DbCurrency.colNames[DbCurrency.COL_CURRENCY_ID]);
                        SessRePosting.rePostSales(gl, list, sales.getPostedById(), sysCompany, sales.getLocation_id(), currencys, sales.getDate(), sales.getCashCashierId(), stockable);
                        
                    }
                } else if (gl.getJournalType() == I_Project.JOURNAL_TYPE_RETUR) {
                    SessRePosting.rePostRetur(gl);
                } else if (gl.getJournalType() == I_Project.JOURNAL_TYPE_PURCHASE_ORDER) {
                    SessRePosting.rePostReceiving(gl);
                } else if (gl.getJournalType() == I_Project.JOURNAL_TYPE_REPACK) {
                    SessRePosting.rePostRepack(gl);
                } else if(gl.getJournalType() == I_Project.JOURNAL_TYPE_AP_MEMO){
                    SessRePosting.rePostAPMemo(gl);
                } else if(gl.getJournalType() == I_Project.JOURNAL_TYPE_PIUTANG_CARD){
                    SessRePosting.rePostReconBank(gl,sysCompany);
                }else if(gl.getJournalType() == I_Project.JOURNAL_TYPE_GENERAL_AFFAIR){
                    SessRePosting.rePostJournalGA(gl);
                }else if(gl.getJournalType() == I_Project.JOURNAL_TYPE_BANK_PAYMENT){
                    SessRePosting.rePostJournalPembayaran(gl);
                }else if(gl.getJournalType() == I_Project.JOURNAL_TYPE_BANK_DEPOSIT){
                    SessRePosting.rePostJournalBankDeposit(gl);
                }else if(gl.getJournalType() == I_Project.JOURNAL_TYPE_BANK_PAYMENT){
                    SessRePosting.rePostJournalPembayaran(gl);
                }else if(gl.getJournalType() == I_Project.JOURNAL_TYPE_COSTING){
                    SessRePosting.rePostJournalCosting(gl);
                }else if(gl.getJournalType() == I_Project.JOURNAL_TYPE_ADJUSMENT){
                    
                }
                details = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), "debet desc");
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=systemTitle%></title>
        <script language="JavaScript">        
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSave(){
                document.journaleditor.command.value="<%=JSPCommand.SUBMIT%>";
                document.journaleditor.action="journal_posting.jsp?menu_idx=<%=menuIdx%>";
                document.journaleditor.submit();
            }
            
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
                  <%@ include file="menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Sales Editor</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td class="container" ><!-- #BeginEditable "content" --> 
                                                        <form name="journaleditor" method="post" action="">
                                                            <input type="hidden" name="command" value="">    
                                                            <input type="hidden" name="gl_id" value="<%=glId%>">                                                                
                                                            <table width="100%" border="0" >                                                               
                                                                <tr>
                                                                    <td>
                                                                        <table width="800" border="0" cellpadding="0" cellspacing="1">
                                                                            <tr height="22">
                                                                                <td class="tablecell" width="100" style="padding:3px;">Nomor Journal</td>
                                                                                <td class="fontarial" width="1">:</td>
                                                                                <td class="fontarial" width="200" style="padding:3px;"><b><%=gl.getJournalNumber()%></b></td>
                                                                                <td class="tablecell" width="100" style="padding:3px;">Tanggal Transaksi</td>
                                                                                <td class="fontarial" width="1">:</td>
                                                                                <td class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatDate(gl.getTransDate(), "dd MMM yyyy")%><b></td>
                                                                            </tr>
                                                                            <tr height="22">
                                                                                <td class="tablecell" style="padding:3px;">Tanggal Dibuat</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatDate(gl.getDate(), "dd MMM yyyy")%><b></td>
                                                                                <td class="tablecell" style="padding:3px;">Posted Date</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatDate(gl.getPostedDate(), "dd MMM yyyy")%><b></td>
                                                                            </tr>
                                                                            <tr height="22">
                                                                                <td class="tablecell" style="padding:3px;">Posted By</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td class="fontarial" colspan="4" style="padding:3px;"><b><%=userPost.getFullName() %><b></td>                                                                                
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                                <tr>
                                                                    <td>
                                                                        <table width="1100" cellpadding="0" cellspacing="1" >
                                                                            <tr height="22">
                                                                                <td class="tablehdr" width="300">Perkiraan</td>
                                                                                <td class="tablehdr" width="100">Debet</td>
                                                                                <td class="tablehdr" width="100">Credit</td>
                                                                                <td class="tablehdr" >Keterangan</td>
                                                                                <td class="tablehdr" width="170">Segment</td>                                                                                
                                                                            </tr>
                                                                            <%
            if (details != null && details.size() > 0) {
                double totalDebet = 0;
                double totalCredit = 0;
                for (int i = 0; i < details.size(); i++) {
                    GlDetail gld = (GlDetail) details.get(i);
                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(gld.getCoaId());
                    } catch (Exception e) {
                    }

                    SegmentDetail sd = new SegmentDetail();
                    try {
                        if (gld.getSegment1Id() != 0) {
                            sd = DbSegmentDetail.fetchExc(gld.getSegment1Id());
                        }
                    } catch (Exception e) {
                    }

                    totalDebet = totalDebet + gld.getDebet();
                    totalCredit = totalCredit + gld.getCredit();
                                                                            %>
                                                                            <tr height="22">
                                                                                <td class="tablecell1" style="padding:3px;"><%=coa.getName()%></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=(gld.getDebet() == 0) ? "" : JSPFormater.formatNumber(gld.getDebet(), "###,###.##")%></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=(gld.getCredit() == 0) ? "" : JSPFormater.formatNumber(gld.getCredit(), "###,###.##")%></td>
                                                                                <td class="tablecell1" style="padding:3px;"><%=gld.getMemo()%></td>
                                                                                <td class="tablecell1" style="padding:3px;"><%=sd.getName()%></td>                                                                               
                                                                            </tr>
                                                                            <%
                                                                                }
                                                                            %>
                                                                            <tr height="22">
                                                                                <td bgcolor="#cccccc" class="fontarial" style="padding:3px;"><b>Grand Total</b></td>
                                                                                <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><b><%=(totalDebet == 0) ? "" : JSPFormater.formatNumber(totalDebet, "###,###.##")%></b></td>
                                                                                <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><b><%=(totalCredit == 0) ? "" : JSPFormater.formatNumber(totalCredit, "###,###.##")%></b></td>
                                                                                <td bgcolor="#cccccc" class="fontarial" style="padding:3px;"></td>
                                                                                <td bgcolor="#cccccc" class="fontarial" style="padding:3px;"></td>                                                                               
                                                                            </tr>
                                                                            <tr height="22">
                                                                                <td colspan="4" class="fontarial"><b><i>Balance = <%=JSPFormater.formatNumber((totalDebet - totalCredit), "###,###.##")%></i><b></td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr height="10" >
                                                                                <td colspan="4"></td>
                                                                            </tr>
                                                                            <%if (gl.getJournalType() == I_Project.JOURNAL_TYPE_SALES || gl.getJournalType() == I_Project.JOURNAL_TYPE_RETUR || gl.getJournalType() == I_Project.JOURNAL_TYPE_PURCHASE_ORDER
                                                                            || gl.getJournalType() == I_Project.JOURNAL_TYPE_REPACK || gl.getJournalType() == I_Project.JOURNAL_TYPE_AP_MEMO || gl.getJournalType() == I_Project.JOURNAL_TYPE_PIUTANG_CARD || gl.getJournalType() == I_Project.JOURNAL_TYPE_GENERAL_AFFAIR
                                                                            || gl.getJournalType() == I_Project.JOURNAL_TYPE_BANK_PAYMENT || gl.getJournalType() == I_Project.JOURNAL_TYPE_BANK_DEPOSIT || gl.getJournalType() == I_Project.JOURNAL_TYPE_BANK_PAYMENT
                                                                            || gl.getJournalType() == I_Project.JOURNAL_TYPE_COSTING){%>
                                                                            <tr height="22">
                                                                                <td colspan="4">
                                                                                    <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/save2.gif',1)"><img src="../images/save.gif" name="post" border="0"></a>                                                                               
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <%}%>
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
