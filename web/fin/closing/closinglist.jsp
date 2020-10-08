
<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_ADD);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_UPDATE);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_DELETE);
            boolean closingPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD);
            boolean closingPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_VIEW);
            boolean closingPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector vList) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("50%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("No.", "7%");
        ctrlist.addHeader("Journal Number", "23%");
        ctrlist.addHeader("Memo", "70%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < vList.size(); i++) {
            CommonObj obj = (CommonObj) vList.get(i);

            rowx = new Vector();
            rowx.add("<div align='center'>" + (i + 1) + "</div>");
            rowx.add("<div align='center'>" + obj.getNumber() + "</div>");
            rowx.add(obj.getMemo());
            lstData.add(rowx);
        }
        return ctrlist.draw(index);
    }
%>
<%!    public String getSubstring1(String s) {
        if (s.length() > 60) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 55) + "...</font></a>";
        }
        return s;
    }

    public String getSubstring(String s) {
        if (s.length() > 105) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 100) + "...</font></a>";
        }
        return s;
    }
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);

            Periode p = new Periode();
            try {
                p = DbPeriode.getOpenPeriod();
            } catch (Exception e) {
            }

            String whereQry = "trans_date between '" + JSPFormater.formatDate(p.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(p.getEndDate(), "yyyy-MM-dd") + "' ";
            Vector pcPayment = DbPettycashPayment.list(0, 0, whereQry + "and activity_status <> 'Posted' ", "");
            Vector pcReplenishment = DbPettycashReplenishment.list(0, 0, whereQry + "and status <> 'Posted' ", "");
            Vector bankNonPO = DbBanknonpoPayment.list(0, 0, whereQry + "and activity_status <> 'Posted' and type<>" + I_Project.TYPE_INT_EMPLOYEE_ADVANCE, "");
            Vector bankPO = DbBankpoPayment.list(0, 0, whereQry + "and status <> 'Posted' ", "");
            Vector inv = DbInvoice.list(0, 0, whereQry + "and (status <> 'Posted' or activity_status <> 'Posted') and status <> 'closed'", "");
            Vector gl = DbGl.list(0, 0, whereQry + "and activity_status <> 'Posted'", "");

            if ((pcPayment != null && pcPayment.size() > 0) || (pcReplenishment != null && pcReplenishment.size() > 0) || (bankPO != null && bankPO.size() > 0) || (bankNonPO != null && bankNonPO.size() > 0) || (inv != null && inv.size() > 0) || (gl != null && gl.size() > 0)) {
//response.sendRedirect("closinglist.jsp?menu_idx=13");			
            } else {
                //response.sendRedirect("periode.jsp?menu_idx=13&cmd="+JSPCommand.ADD);
                response.sendRedirect("closeperiod.jsp?menu_idx=13");
            }

            Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();
            Vector vTransaction = DbPeriode.preClosingPeriod(preClosedPeriod.getOID());

            String[] langMD = {"Period closing process can not continue, there is still a draft transaction", "No", "Journal Number", "Memo"};
            String[] langNav = {"Close Period", "Documents Not In Process"};
            if (lang == LANG_ID) {
                String[] langID = {"Proses tutup periode tidak dapat di lanjutkan, masih ada transaksi dengan status draft", "No", "Nomor Jurnal", "Keterangan"};
                langMD = langID;
                String[] navID = {"Tutup Periode", "Dokumen Yang Belum Di Proses"};
                langNav = navID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            <!--
            <%if (!closingPriv || !closingPrivView || !closingPrivUpdate) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdBack(){
                document.frmperiode.action = "../closing/periode.jsp?menu_idx=13";
                document.frmperiode.submit();
            }
            
            function cmdPostPayment(oidPost){
                document.frmperiode.hidden_casharchive.value=oidPost;
                document.frmperiode.action="../closing/pettycashpaymentclosing.jsp?menu_idx=13";
                document.frmperiode.submit();
            }
            
            function cmdPostReplenishment(oidPost){
                document.frmperiode.hidden_casharchive.value=oidPost;
                document.frmperiode.action="../closing/pettycashreplenishmentclosing.jsp?hidden_pettycash_replenishment_id="+oidPost+"&menu_idx=13";
                document.frmperiode.submit();
            }
            
            function cmdPostNonPO(oidPost){
                document.frmperiode.hidden_bankarchive.value=oidPost;
                document.frmperiode.action="../closing/banknonpopaymentclosing.jsp?menu_idx=13";
                document.frmperiode.submit();
            }
            
            function cmdPostInvoice(oidPost){
                document.frmperiode.hidden_invoice_id.value=oidPost;
                document.frmperiode.action="../closing/invoiceclosing.jsp?menu_idx=13";
                document.frmperiode.submit();
            }
            
            function cmdPostPO(oidPost){
                document.frmperiode.hidden_bankarchive.value=oidPost;
                document.frmperiode.action="../closing/bankpopaymentclosing.jsp?hidden_pettycash_replenishment_id="+oidPost+"&menu_idx=13";
                document.frmperiode.submit();
            }
            
            function cmdPostGl(oidPost){
                document.frmperiode.hidden_glarchive.value=oidPost;
                document.frmperiode.action="../closing/glclosing.jsp?gl_id="+oidPost+"&menu_idx=13";
                document.frmperiode.submit();
            }
            //-------------- script control line -------------------
            //-->
        </script>
        <!--End Region JavaScript-->
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
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
                                                        <form id="form1" name="form1" method="post" action="">
                                                            <input type="hidden" name="command">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td></td>
                                                                </tr>
                                                                <%if (vTransaction != null && vTransaction.size() > 0) {%>
                                                                <tr>
                                                                    <td><i><%=langMD[0]%></i></td>
                                                                </tr>
                                                                
                                                                <tr>
                                                                    <td>
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr height="20">
                                                                                <td class="tablehdr"><%=langMD[1]%></td>
                                                                                <td class="tablehdr"><%=langMD[2]%></td>
                                                                                <td class="tablehdr"><%=langMD[3]%></td>
                                                                            </tr>
                                                                            <%
    for (int i = 0; i < vTransaction.size(); i++) {
        CommonObj obj = (CommonObj) vTransaction.get(i);
                                                                %>
                                                                            <tr height="20">
                                                                                <td class="tablecell"><%=i+1%></td>
                                                                                <td class="tablecell"><%=obj.getNumber()%></td>
                                                                                <td class="tablecell"><%=obj.getMemo()%></td>
                                                                            </tr>    
                                                                            <%
                }
            }%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
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
