
<%-- 
    Document   : glbaliklist
    Created on : Oct 11, 2013, 1:20:50 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.session.SessJournal" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String getSubstring(String s) {
        if (s.length() > 90) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 85) + "...</font></a>";
        }
        return s;
    }
%>

<%@ include file="../calendar/calendarframe.jsp"%>

<%
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidGlArchive = JSPRequestValue.requestLong(request, "hidden_glarchive");
            String srcRefNumber = JSPRequestValue.requestString(request, "src_ref_number");            
            String srcMemo = JSPRequestValue.requestString(request, "src_memo");

            Date startDate = new Date();
            Date endDate = new Date();
            Date transDate = new Date();

            if (JSPRequestValue.requestString(request, JspGlArchive.colNames[JspGlArchive.JSP_START_DATE]).length() > 0) {
                startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspGlArchive.colNames[JspGlArchive.JSP_START_DATE]), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, JspGlArchive.colNames[JspGlArchive.JSP_END_DATE]).length() > 0) {
                endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspGlArchive.colNames[JspGlArchive.JSP_END_DATE]), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, JspGlArchive.colNames[JspGlArchive.JSP_TRANSACTION_DATE]).length() > 0) {
                transDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspGlArchive.colNames[JspGlArchive.JSP_TRANSACTION_DATE]), "dd/MM/yyyy");
            }

            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            CmdGlArchive cmdGlArchive = new CmdGlArchive(request);
            JSPLine jspLine = new JSPLine();
            Vector listGlArchive = new Vector(1, 1);
            GlArchive glArchive = new GlArchive();
            JspGlArchive jspGlArchive = new JspGlArchive(request, glArchive);            
            iErrCode = cmdGlArchive.action(iCommand, oidGlArchive);
            jspGlArchive.requestEntityObject(glArchive);//

            glArchive = jspGlArchive.getEntityObject();
            glArchive.setStartDate(startDate);
            glArchive.setEndDate(endDate);
            glArchive.setTransactionDate(transDate);

            msgString = cmdGlArchive.getMessage();

            if (iCommand == JSPCommand.NONE || iCommand == JSPCommand.BACK) {
                glArchive.setIgnoreTransactionDate(1);
                glArchive.setIgnoreInputDate(1);
            }
            
            if(iCommand == JSPCommand.BACK || iCommand == JSPCommand.NONE ){
                iCommand = JSPCommand.SUBMIT;
            }
     
            int vectSize = DbGl.countGlReverse(glArchive.getIgnoreTransactionDate(), glArchive.getTransactionDate(), glArchive.getJournalNumber(), glArchive.getIgnoreInputDate(), glArchive.getStartDate(), glArchive.getEndDate(), srcRefNumber, glArchive.getPeriodeId(), srcMemo);

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST || iCommand == JSPCommand.BACK || iCommand == JSPCommand.SUBMIT)) {

                start = cmdGlArchive.actionList(iCommand, start, vectSize, recordToGet);
                listGlArchive = DbGl.glReverse(glArchive.getIgnoreTransactionDate(), glArchive.getTransactionDate(), glArchive.getJournalNumber(), glArchive.getIgnoreInputDate(), glArchive.getStartDate(), glArchive.getEndDate(), srcRefNumber,glArchive.getPeriodeId(), srcMemo, start, recordToGet);
            }

            /*** LANG ***/
            String[] langGL = {"Journal Number", "Reference Number", "Input Date", "to", "Ignore", //0-4
                "Period", "Transaction Date", "Journal List", "Memo", "Please click search button to get your data.", "Data not found."}; //5-10

            String[] langNav = {"Journal", "Reverse Posted Journal", "Date"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Nomor Referensi", "Tanggal Dibuat", "sampai", "Abaikan", //0-4
                    "Periode", "Tanggal Transaksi", "Daftar Jurnal", "Memo", "Silahkan tekan tombol pencarian untuk menampilkan data.", "Data tidak ditemukan."}; //5-10
                langGL = langID;

                String[] navID = {"Jurnal", "Jurnal Pembalikkan", "Tanggal"};
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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmglarchive.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmglarchive.prev_command.value="<%=prevCommand%>";
                document.frmglarchive.action="glbaliklist.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdEditGl(oidGl){                
                <%if (privAdd || privDelete || privUpdate) {%>
                document.frmglarchive.command.value="<%=JSPCommand.EDIT%>";
                document.frmglarchive.hidden_gl_id.value=oidGl;
                document.frmglarchive.action="glbalikedit.jsp";
                document.frmglarchive.submit();
                <%}%>
                
            }
            
            function cmdListFirst(){
                document.frmglarchive.command.value="<%=JSPCommand.FIRST%>";
                document.frmglarchive.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmglarchive.action="glbaliklist.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdListPrev(){
                document.frmglarchive.command.value="<%=JSPCommand.PREV%>";
                document.frmglarchive.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmglarchive.action="glbaliklist.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdListNext(){
                document.frmglarchive.command.value="<%=JSPCommand.NEXT%>";
                document.frmglarchive.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmglarchive.action="glbaliklist.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdListLast(){
                document.frmglarchive.command.value="<%=JSPCommand.LAST%>";
                document.frmglarchive.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmglarchive.action="glbaliklist.jsp";
                document.frmglarchive.submit();
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
        <!--End Region JavaScript-->
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="76"> 
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
                                        <td width="165" height="100%" valign="top" style="<%="background:url(" + approot + "/images/leftmenu-bg.gif) repeat-y"%>">
                                            <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%>
                                            <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                                    <%String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";%>
                                                    <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmglarchive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_glarchive" value="<%=oidGlArchive%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                                                            
                                                            <input type="hidden" name="hidden_gl_id" value="">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <!--DWLayoutTable-->
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" height="127" valign="top"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="800" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>                                                                                                                 
                                                                                                    </tr>
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" > 
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="5">&nbsp;</td>                                                                                                                 
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5">&nbsp;</td>
                                                                                                                    <td width="13%"><%=langGL[0]%></td>
                                                                                                                    <td width="28%"><input type="text" name="<%=jspGlArchive.colNames[jspGlArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= glArchive.getJournalNumber() %>"></td>
                                                                                                                    <td width="16%"><%=langGL[2]%></td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getStartDate() == null ? new Date() : glArchive.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> <%=langGL[3]%> 
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getEndDate() == null ? new Date() : glArchive.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreInputDate() == 1) {%>checked<%}%>><%=langGL[4]%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td >&nbsp;</td>    
                                                                                                                    <td ><%=langGL[1]%></td>
                                                                                                                    <td ><input type="text" name="src_ref_number"  value="<%=srcRefNumber %>"></td>
                                                                                                                    <td ><%=langGL[6]%></td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getTransactionDate() == null ? new Date() : glArchive.getTransactionDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreTransactionDate() == 1) {%>checked<%}%>><%=langGL[4]%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td >&nbsp;</td>
                                                                                                                    <td ><%=langGL[5]%></td>
                                                                                                                    <td > 
                                                                                                                        <select name="<%=jspGlArchive.colNames[JspGlArchive.JSP_PERIODE_ID]%>" class="formElemen">
                                                                                                                            <option value="0" <%if (glArchive.getPeriodeId() == 0) {%> selected <%}%> >All period..</option>
                                                                                                                            <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC ");
            Vector p_value = new Vector(1, 1);
            Vector p_key = new Vector(1, 1);
            String sel_p = "" + glArchive.getPeriodeId();
            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=period.getOID()%>" <%if (glArchive.getPeriodeId() == period.getOID()) {%> selected <%}%> ><%=period.getName().trim()%></option>
                                                                                                                            <%
                }
            }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td ><%=langGL[8]%></td>
                                                                                                                    <td ><input type="text" name="src_memo"  value="<%=srcMemo%>" size="50"></td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td colspan="5">&nbsp;</td>
                                                                                                                </tr>                                                                                                                
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>                                                                                            
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                                                </td>
                                                                            </tr>    
                                                                            <tr>
                                                                                <td height="10"></td>
                                                                            </tr>    
                                                                            <%
            if (listGlArchive != null && listGlArchive.size() > 0) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="22"> 
                                                                                            <td height="26" width="13%" class="tablearialhdr"><%=langGL[0]%></td>
                                                                                            <td width="13%" class="tablearialhdr"><%=langGL[6]%></td>
                                                                                            <td width="14%" class="tablearialhdr"><%=langGL[1]%></td>
                                                                                            <td class="tablearialhdr"><%=langGL[8]%></td>
                                                                                            <td width="50" class="tablearialhdr">Status</td>
                                                                                        </tr>
                                                                                        <%
                                                                                for (int i = 0; i < listGlArchive.size(); i++) {
                                                                                    Gl bd = (Gl) listGlArchive.get(i);
                                                                                    
                                                                                    String style = "";
                    if (i % 2 == 0) {
                        style = "tablearialcell";
                    } else {
                        style = "tablearialcell1";
                    }

                                                                                    
                                                                                        %>
                                                                                        <tr height="22"> 
                                                                                            <td class="<%=style%>" ><a href="<%="javascript:cmdEditGl('" + bd.getOID() + "')"%>"><%=bd.getJournalNumber()%></a></td>
                                                                                            <td class="<%=style%>" > 
                                                                                                <div align="center"><%=JSPFormater.formatDate(bd.getTransDate(),"dd MMM yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="<%=style%>" > 
                                                                                                <div align="left"><%=bd.getRefNumber()%></div>
                                                                                            </td>
                                                                                            <td class="<%=style%>" ><%=getSubstring(bd.getMemo())%></td>
                                                                                            <%if(bd.getPostedStatus() == 1){%>
                                                                                            <td  align="center">
                                                                                                <table width="100%" height="21" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td bgcolor="#5DC84F" align="center"><font face="arial">POSTED</font></td>
                                                                                                    </tr>    
                                                                                                    </table>    
                                                                                            </td>
                                                                                            <%}else{%>
                                                                                            <td align="center">
                                                                                                <table width="100%" height="21" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td bgcolor="#E9E37B" align="center"><font face="arial">POSTED</font></td>
                                                                                                    </tr>    
                                                                                                    </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                      <%
                                                                                }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                int cmd = 0;
                                                                                if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                    cmd = iCommand;
                                                                                } else {
                                                                                    if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                        cmd = JSPCommand.FIRST;
                                                                                    } else {
                                                                                        cmd = prevCommand;
                                                                                    }
                                                                                }
                                                                                jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                jspLine.initDefault();

                                                                                jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%} else { //if list null %>
                                                                            <tr> 
                                                                                <td colspan="7"><i> 
                                                                                        <%
                                                                                if (iCommand == JSPCommand.NONE) {
                                                                                    out.println(langGL[9]);
                                                                                } else {
                                                                                    out.println(langGL[10]);
                                                                                }
                                                                                        %>
                                                                                </i></td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                               
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
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
                                <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
