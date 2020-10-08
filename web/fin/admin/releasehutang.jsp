
<%-- 
    Document   : releasehutang
    Created on : Sep 1, 2014, 5:12:16 PM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_RELEASE_INVOICE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_RELEASE_INVOICE, AppMenu.PRIV_VIEW);
%>

<%!
    public double getTotal(long bankpo_payment_id) {
        CONResultSet dbrs = null;
        double total = 0;
        try {
            String sql = "select sum(payment_by_inv_currency_amount) as amount from bankpo_payment_detail where bankpo_payment_id = " + bankpo_payment_id;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble("amount");
            }

            rs.close();
            return total;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }

    public long getStatusPaid(long bankpo_payment_id) {
        CONResultSet dbrs = null;
        long oid = 0;
        try {
            String sql = "select bankpo_payment_id from bankpo_payment where ref_id = " + bankpo_payment_id + " limit 0,1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                oid = rs.getLong("bankpo_payment_id");
            }

            rs.close();
            return oid;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }

    public long updateStatus(long bankpo_payment_id) {
        CONResultSet dbrs = null;
        try {
            String sql = "update bankpo_payment set status = 'Not Posted',posted_status = 0,posted_by_id = 0,posted_date=null,effective_date = null where bankpo_payment_id = " + bankpo_payment_id;
            CONHandler.execUpdate(sql);
            return 1;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }


%>

<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String number = JSPRequestValue.requestString(request, "number");
            number = number.trim();

            String where = DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = 0 ";

            if (number != null && number.length() > 0) {
                where = where + " and " + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " = '" + number + "'";
            }

            Vector listBankpo = new Vector();
            if ((number != null && number.length() > 0) && (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.POST)) {
                listBankpo = DbBankpoPayment.list(0, 0, where, DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]);

                if (iJSPCommand == JSPCommand.POST) {

                    if (listBankpo != null && listBankpo.size() > 0) {
                        for (int i = 0; i < listBankpo.size(); i++) {
                            BankpoPayment bp = (BankpoPayment) listBankpo.get(i);
                            int x = JSPRequestValue.requestInt(request, "bankpo" + bp.getOID());
                            if (x == 1) {
                                long y = updateStatus(bp.getOID());
                                if (y != 0) {
                                    BankpoHistory history = new BankpoHistory();
                                    history.setDate(new Date());
                                    history.setJournalNumber(bp.getJournalNumber());
                                    history.setRefId(bp.getOID());
                                    history.setType(DbBankpoHistory.TYPE_RELEASE_STATUS);
                                    history.setUserId(user.getOID());
                                    try {
                                        DbBankpoHistory.insertExc(history);
                                    } catch (Exception e) {
                                    }
                                }
                            }
                        }
                    }
                    listBankpo = DbBankpoPayment.list(0, 0, where, DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]);
                }
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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
            
            function cmdSearch(){
                document.form1.command.value="<%=JSPCommand.LIST%>";
                document.form1.action="releasehutang.jsp";
                document.form1.submit();
            }
            
            function cmdPostJournal(){
                document.form1.command.value="<%=JSPCommand.POST%>";
                document.form1.action="releasehutang.jsp?menu_idx=<%=menuIdx%>";
                document.form1.submit();
            }
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                                                    <td class="title"><!-- #BeginEditable "title" --> 
                        <%
            String navigator = "<font class=\"lvl1\">Hutang</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Release Hutang</span></font>";
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
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">    
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>                                                                                                                                                        
                                                                            <tr> 
                                                                                <td width="90" class="tablecell1" style="padding:3px;">Number</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td ><input type="text" name="number" value="<%=number%>" size="25"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>  
                                                                <tr> 
                                                                    <td height="6" class="container">
                                                                        <table width="80%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                                                              
                                                                            <tr> 
                                                                                <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    
                                                                    <td class="container"> 
                                                                        <table border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="25">&nbsp;</td>
                                                                </tr>  
                                                                <%if (listBankpo != null && listBankpo.size() > 0) {%>
                                                                <tr> 
                                                                    <td class="container">
                                                                        <table border="0" cellpadding="0" cellspacing="1" width="1000">
                                                                            <tr height="24">
                                                                                <td class="tablehdr" width="15">No</td>
                                                                                <td class="tablehdr" width="90">Number</td>
                                                                                <td class="tablehdr" width="90">Date</td>
                                                                                <td class="tablehdr" width="90">Amount</td>
                                                                                <td class="tablehdr">Memo</td>
                                                                                <td class="tablehdr" width="60">Status</td>
                                                                                <td class="tablehdr" width="170">Posted By</td>
                                                                                <td class="tablehdr" width="50">Release</td>
                                                                            </tr>    
                                                                            <%
    for (int i = 0; i < listBankpo.size(); i++) {

        BankpoPayment bp = (BankpoPayment) listBankpo.get(i);

        String style = "tablecell1";
        if (i % 2 == 0) {
            style = "tablecell1";
        } else {
            style = "tablecell";
        }

        double total = getTotal(bp.getOID());
        long refId = getStatusPaid(bp.getOID());

        String name = "";
        try {
            User u = DbUser.fetch(bp.getPostedById());
            name = u.getFullName();
        } catch (Exception e) {
        }

        String status = "DRAFT";
        if (bp.getPostedStatus() == 1) {
            if (refId != 0) {
                status = "PAID";
            } else {
                status = "POSTED";
            }
        }


                                                                            %>
                                                                            <tr height="23" >
                                                                                <td class="<%=style%>" style="padding:3px;" align="center"><%=(i + 1)%></td>
                                                                                <td class="<%=style%>" style="padding:3px;" align="center"><%=bp.getJournalNumber()%></td>
                                                                                <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(bp.getTransDate(), "dd MMM yyyy")%></td> 
                                                                                <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(total, "###,###.##")%></td>                                                                                
                                                                                <td class="<%=style%>" style="padding:3px;"><%=bp.getMemo()%></td>   
                                                                                <td class="<%=style%>" align="center"><%=status%></td>
                                                                                <td class="<%=style%>" style="padding:3px;"><%=name%></td>                                                                                   
                                                                                <td bgcolor="#D5E649" align="center">
                                                                                    <%if (bp.getPostedStatus() == 1 && refId == 0) {%>
                                                                                    <input type="checkbox" name="bankpo<%=bp.getOID()%>" value="1">
                                                                                    <%} else {%>                                               
                                                                                    &nbsp;
                                                                                    <%}%>
                                                                                </td>                       
                                                                            </tr>        
                                                                            <%}%>
                                                                            <tr > 
                                                                                <td colspan="7">                                                                                    
                                                                                    &nbsp;
                                                                                </td>
                                                                            </tr>     
                                                                            <tr > 
                                                                                <td colspan="7">                                                                                    
                                                                                    <a href="javascript:cmdPostJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a>                                                                                                                                                                   
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>                              
                                                                <%} else {%>
                                                                <tr > 
                                                                    <td class="container">
                                                                        <table>
                                                                            <tr>
                                                                                <td class="fontarial">
                                                                                    <%if (iJSPCommand == JSPCommand.LIST) {%>
                                                                                        <%if (number == null || number.length() <= 0) {%>
                                                                                            <i>Masukan Number terlebih dahulu</i>
                                                                                        <%}else{%>
                                                                                            <i>Data tidak ditemukan</i>
                                                                                        <%}%>
                                                                                    
                                                                                    <%} else {%>
                                                                                    <i>Masukan number kemudian klik search untuk melakukan pencarian</i>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                                <%}%>
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
<!-- #EndTemplate --></html>
