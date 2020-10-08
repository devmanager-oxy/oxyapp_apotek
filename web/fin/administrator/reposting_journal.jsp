
<%-- 
    Document   : reposting_journal
    Created on : Oct 12, 2015, 1:39:57 PM
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
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            Date invPostDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "inv_post_date"), "dd/MM/yyyy");

            String number = JSPRequestValue.requestString(request, "number");
            int journalType = JSPRequestValue.requestInt(request, "journal_type");
            int igoreTrans = JSPRequestValue.requestInt(request, "ignore_trans_date");
            int igorePosted = JSPRequestValue.requestInt(request, "ignore_posted_date");

            if (iJSPCommand == JSPCommand.NONE) {
                igoreTrans = 1;
                igorePosted = 1;
                journalType = -1;
            }

            if (tanggal == null) {
                tanggal = new Date();
            }
            if (tanggalEnd == null) {
                tanggalEnd = new Date();
            }

            Vector list = new Vector();
            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.ACTIVATE) {
                list = SessRePosting.getJournal(journalType, igoreTrans, tanggal, tanggalEnd, igorePosted, invPostDate, number, periodId);
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
            
            function cmdSearch(){
                document.journaleditor.command.value="<%=JSPCommand.SUBMIT%>";
                document.journaleditor.action="reposting_journal.jsp?menu_idx=<%=menuIdx%>";
                document.journaleditor.submit();
            }
            
            function cmdSales(oid){
                document.journaleditor.command.value="<%=JSPCommand.SEARCH%>";
                document.journaleditor.gl_id.value=oid;
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
                                                            <input type="hidden" name="gl_id" value="0">    
                                                            <table width="100%" border="0" >
                                                                <tr height="22">
                                                                    <td>
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="100" class="tablearialcell1">&nbsp;Period</td>
                                                                                <td >
                                                                                    <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", "start_date desc");
            Vector p_value = new Vector(1, 1);
            Vector p_key = new Vector(1, 1);
            if (p != null && p.size() > 0) {
                                                                                    %>
                                                                                    <select name="period_id">
                                                                                    <%
                                                                                        for (int i = 0; i < p.size(); i++) {
                                                                                            Periode period = (Periode) p.get(i);
                                                                                    %>
                                                                                    <option value="<%=period.getOID()%>" <%if (periodId == period.getOID()) {%> selected<%}%> ><%=period.getName()%></option>
                                                                                    <%}%>
                                                                                    <select>                    
                                                                                    <%}
                                                                                    %>
                                                                                </td>
                                                                            </tr>  
                                                                            <tr height="22"> 
                                                                                <td class="tablearialcell1">&nbsp;Transaction Date</td>
                                                                                <td >
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td><input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.journaleditor.invStartDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                            <td>&nbsp;&nbsp;to&nbsp;</td>
                                                                                            <td>&nbsp;<input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.journaleditor.invEndDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                            <td>&nbsp;<input type="checkbox" name="ignore_trans_date" value="1" <%if (igoreTrans == 1) {%> checked<%}%> ></td>
                                                                                        </tr>
                                                                                    </table>   
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td class="tablearialcell1">&nbsp;Posted Date</td>
                                                                                <td >
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>                                                                                            
                                                                                            <td><input name="inv_post_date" value="<%=JSPFormater.formatDate((invPostDate == null) ? new Date() : invPostDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.journaleditor.inv_post_date);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>                                                                                            
                                                                                            <td>&nbsp;<input type="checkbox" name="ignore_posted_date" value="1" <%if (igorePosted == 1) {%> checked<%}%>></td>
                                                                                        </tr>
                                                                                    </table>   
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td class="tablearialcell1">&nbsp;Number</td>
                                                                                <td ><input type="text" name="number" value="<%=number%>" size="25"> 
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <tr height="22"> 
                                                                                <td class="tablearialcell1">&nbsp;Journal Type</td>
                                                                                <td> 
                                                                                    <select name="journal_type" class="fontarial">
                                                                                        <option value="-1" <%if (journalType == -1) {%>selected<%}%>>< All Type ></option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_CASH_RECEIVE%>" <%if (journalType == I_Project.JOURNAL_TYPE_CASH_RECEIVE) {%>selected<%}%>>Cash Receive</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_PETTYCASH_PAYMENT%>" <%if (journalType == I_Project.JOURNAL_TYPE_PETTYCASH_PAYMENT) {%>selected<%}%>>Pettycash Payment</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_PETTYCASH_REPLENISHMENT%>" <%if (journalType == I_Project.JOURNAL_TYPE_PETTYCASH_REPLENISHMENT) {%>selected<%}%>>Pettycash Replenishment</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_BANK_DEPOSIT%>" <%if (journalType == I_Project.JOURNAL_TYPE_BANK_DEPOSIT) {%>selected<%}%>>Bank Deposit</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_BANKPAYMENT_PO%>" <%if (journalType == I_Project.JOURNAL_TYPE_BANKPAYMENT_PO) {%>selected<%}%>>Bank Payment PO</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_BANKPAYMENT_NONPO%>" <%if (journalType == I_Project.JOURNAL_TYPE_BANKPAYMENT_NONPO) {%>selected<%}%>>Bank Payment Non PO</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_PURCHASE_ORDER%>" <%if (journalType == I_Project.JOURNAL_TYPE_PURCHASE_ORDER) {%>selected<%}%>>Purchase Order</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_GENERAL_LEDGER%>" <%if (journalType == I_Project.JOURNAL_TYPE_GENERAL_LEDGER) {%>selected<%}%>>General Ledger</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_INVOICE%>" <%if (journalType == I_Project.JOURNAL_TYPE_INVOICE) {%>selected<%}%>>Invoice</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_SALES%>" <%if (journalType == I_Project.JOURNAL_TYPE_SALES) {%>selected<%}%>>Sales</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_AKRUAL%>" <%if (journalType == I_Project.JOURNAL_TYPE_AKRUAL) {%>selected<%}%>>Akrual</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_ADJUSMENT%>" <%if (journalType == I_Project.JOURNAL_TYPE_ADJUSMENT) {%>selected<%}%>>Adjustment</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_COSTING%>" <%if (journalType == I_Project.JOURNAL_TYPE_COSTING) {%>selected<%}%>>Costing</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_AP_MEMO%>" <%if (journalType == I_Project.JOURNAL_TYPE_AP_MEMO) {%>selected<%}%>>AP Memo</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_BANK_PAYMENT%>" <%if (journalType == I_Project.JOURNAL_TYPE_BANK_PAYMENT) {%>selected<%}%>>Bank Payment</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_RETUR%>" <%if (journalType == I_Project.JOURNAL_TYPE_RETUR) {%>selected<%}%>>Retur Purchase</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_CREDIT_PAYMENT%>" <%if (journalType == I_Project.JOURNAL_TYPE_CREDIT_PAYMENT) {%>selected<%}%>>Credit Payment</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_AR_MEMO%>" <%if (journalType == I_Project.JOURNAL_TYPE_AR_MEMO) {%>selected<%}%>>AR Memo</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_REVERSE%>" <%if (journalType == I_Project.JOURNAL_TYPE_REVERSE) {%>selected<%}%>>Journal Reverse</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_COPY%>" <%if (journalType == I_Project.JOURNAL_TYPE_COPY) {%>selected<%}%>>Journal Copy</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_PEMAKAIAN_KASBON%>" <%if (journalType == I_Project.JOURNAL_TYPE_PEMAKAIAN_KASBON) {%>selected<%}%>>Pemakaian Kasbon</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_REPACK%>" <%if (journalType == I_Project.JOURNAL_TYPE_REPACK) {%>selected<%}%>>Repack</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_GIRO_MASUK%>" <%if (journalType == I_Project.JOURNAL_TYPE_GIRO_MASUK) {%>selected<%}%>>Giro Masuk</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_GIRO_KELUAR%>" <%if (journalType == I_Project.JOURNAL_TYPE_GIRO_KELUAR) {%>selected<%}%>>Giro Keluar</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_PIUTANG_CARD%>" <%if (journalType == I_Project.JOURNAL_TYPE_PIUTANG_CARD) {%>selected<%}%>>Piutang Card</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_SELISIH_KASIR%>" <%if (journalType == I_Project.JOURNAL_TYPE_SELISIH_KASIR) {%>selected<%}%>>Selisih Kasir</option>
                                                                                        <option value="<%=I_Project.JOURNAL_TYPE_GENERAL_AFFAIR%>" <%if (journalType == I_Project.JOURNAL_TYPE_GENERAL_AFFAIR) {%>selected<%}%>>General Affair</option>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <tr height="22"> 
                                                                                <td >&nbsp;</td>
                                                                                <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                </tr> 
                                                                <tr>
                                                                    <td>
                                                                        <table cellpadding="0" cellspacing="1" >
                                                                            <tr height="22">
                                                                                <td class="tablehdr" width="15">No.</td>
                                                                                <td class="tablehdr" width="150">Number</td>
                                                                                <td class="tablehdr" width="80">Date</td>
                                                                                <td class="tablehdr" width="100">Debet</td>
                                                                                <td class="tablehdr" width="100">Credit</td>
                                                                                <td class="tablehdr" width="100">Balance</td>
                                                                                <td class="tablehdr" width="80">Posted Date</td>
                                                                                <td class="tablehdr" width="150">Posted By</td>
                                                                            </tr>
                                                                            <%
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    Vector tmp = (Vector) list.get(i);
                    long glId = 0;
                    String numb = "";
                    double debet = 0;
                    double credit = 0;

                    Date transDate = new Date();
                    Date postedDate = new Date();
                    long postedById = 0;
                    int type = 0;

                    try {
                        glId = Long.parseLong(String.valueOf(tmp.get(0)));
                    } catch (Exception e) {
                    }

                    try {
                        numb = String.valueOf(tmp.get(1));
                    } catch (Exception e) {
                    }

                    try {
                        debet = Double.parseDouble(String.valueOf(tmp.get(2)));
                    } catch (Exception e) {
                    }

                    try {
                        credit = Double.parseDouble(String.valueOf(tmp.get(3)));
                    } catch (Exception e) {
                    }

                    try {
                        transDate = JSPFormater.formatDate("" + tmp.get(4), "dd/MM/yyyy");
                    } catch (Exception e) {
                    }

                    try {
                        postedDate = JSPFormater.formatDate("" + tmp.get(5), "dd/MM/yyyy");
                    } catch (Exception e) {
                    }

                    User userPost = new User();
                    try {
                        postedById = Long.parseLong(String.valueOf(tmp.get(6)));
                        if (postedById != 0) {
                            userPost = DbUser.fetch(postedById);
                        }
                    } catch (Exception e) {
                    }

                    try {
                        type = Integer.parseInt(String.valueOf(tmp.get(7)));
                    } catch (Exception e) {
                    }



                                                                            %>
                                                                            <tr height="22">
                                                                                <td class="tablecell1" align="center" style="padding:3px;"><%=(i + 1)%></td> 
                                                                                <%if (type == I_Project.JOURNAL_TYPE_SALES || true) {%>
                                                                                <td class="tablecell1" align="left" style="padding:3px;"><a href="javascript:cmdSales('<%=glId%>')"><%=numb%></a></td>
                                                                                <%} else {%>
                                                                                <td class="tablecell1" align="left" style="padding:3px;"><%=numb%></td>
                                                                                <%}%>
                                                                                <td class="tablecell1" align="center" style="padding:3px;"><%=JSPFormater.formatDate(transDate, "dd MMM yyyy")  %></td>
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(debet, "###,###.##")%></td>                                                                                
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(credit, "###,###.##")%></td>   
                                                                                <td class="tablecell1" align="right" style="padding:3px;"><%=JSPFormater.formatNumber((debet - credit), "###,###.##")%></td>   
                                                                                <td class="tablecell1" align="center" style="padding:3px;"><%=JSPFormater.formatDate(postedDate, "dd MMM yyyy")  %></td>
                                                                                <td class="tablecell1" align="left" style="padding:3px;"><%=userPost.getFullName()%></td>
                                                                            </tr>
                                                                            <%
                                                                                }%>
                                                                            <tr height="22">
                                                                                <td colspan="4">&nbsp;</td>
                                                                            </tr>
                                                                            <%}
                                                                            %>
                                                                            
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
