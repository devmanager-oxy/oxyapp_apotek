
<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
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
            long gl_id = JSPRequestValue.requestLong(request, "gl_id");
            String srcRefNumber = JSPRequestValue.requestString(request, "src_ref_number");
            int type = JSPRequestValue.requestInt(request, "TYPE");
            long referensiId = JSPRequestValue.requestLong(request, "hidden_referensi_id");
            int typeJournal = JSPRequestValue.requestInt(request, "type_journal");
            String src_memo = JSPRequestValue.requestString(request, "src_memo");

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

            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String orderClause = "journal_number";

            CmdGlArchive cmdGlArchive = new CmdGlArchive(request);
            JSPLine jspLine = new JSPLine();
            Vector listGlArchive = new Vector(1, 1);
            GlArchive glArchive = new GlArchive();
            JspGlArchive jspGlArchive = new JspGlArchive(request, glArchive);

            iErrCode = cmdGlArchive.action(iCommand, oidGlArchive);

            jspGlArchive.requestEntityObject(glArchive);
            glArchive = jspGlArchive.getEntityObject();
            glArchive.setStartDate(startDate);
            glArchive.setEndDate(endDate);
            glArchive.setTransactionDate(transDate);

            msgString = cmdGlArchive.getMessage();

            if (iCommand == JSPCommand.NONE) {
                glArchive.setIgnoreTransactionDate(1);
                glArchive.setIgnoreInputDate(1);
            }

            int vectSize = 0;

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST || iCommand == JSPCommand.BACK || iCommand == JSPCommand.SUBMIT)) {
                vectSize = DbGl.getCountGLRegulerIByType(DbGl.IS_NOT_REVERSAL, typeJournal, glArchive.getJournalNumber(), glArchive.getIgnoreTransactionDate(), glArchive.getTransactionDate(), glArchive.getPeriodeId(), glArchive.getIgnoreInputDate(), glArchive.getStartDate(), glArchive.getEndDate(), srcRefNumber, src_memo);

                start = cmdGlArchive.actionList(iCommand, start, vectSize, recordToGet);
                listGlArchive = DbGl.getGLRegulerIByType(DbGl.IS_NOT_REVERSAL, typeJournal, glArchive.getJournalNumber(), glArchive.getIgnoreTransactionDate(), glArchive.getTransactionDate(), glArchive.getPeriodeId(), glArchive.getIgnoreInputDate(), glArchive.getStartDate(), glArchive.getEndDate(), srcRefNumber, start, recordToGet, orderClause, src_memo);
            }

            /*** LANG ***/
            String[] langGL = {"Journal Number", "Status", "Input Date", "to", "Ignore", //0-4
                "Period", "Transaction Date", "General Journal List", "Memo", "Please click search button to get your data.", "Data not found.", "Debet", "Credit", "Advance Journal", "Notes", "Amount", "Journal Type"}; //5-16

            String[] langNav = {"General", "Archives", "Date", "General Journal", "Advance Journal", "Type", "Searching Parameter"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Status", "Tanggal Dibuat", "sampai", "Abaikan", //0-4
                    "Periode", "Tanggal Transaksi", "Daftar Jurnal Umum", "Memo", "Silahkan tekan tombol pencarian untuk menampilkan data.", "Data tidak ditemukan.", "Debet", "Credit", "Daftar Jurnal Kasbon", "Memo", "Jumlah", "Tipe Jurnal"}; //5-16
                langGL = langID;

                String[] navID = {"Jurnal", "Arsip", "Tanggal", "Jurnal Umum", "Jurnal Kasbon", "Type", "Parameter Pencarian"};
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
                document.frmglarchive.action="glarchive.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdEditGl(oidGl){                
                <%if (privUpdate) {%>
                document.frmglarchive.gl_id.value = oidGl;
                document.frmglarchive.command.value="<%=JSPCommand.LOAD%>";                
                document.frmglarchive.action="glarchivedetail.jsp";
                document.frmglarchive.submit();                
                <%}%>
            }
            
            function cmdEditGlKasbon(referensiId){
                
                <%if (privUpdate) {%>
                document.frmglarchive.hidden_referensi_id.value = referensiId;
                document.frmglarchive.command.value="<%=JSPCommand.DETAIL%>";
                document.frmglarchive.action="glkasbon.jsp";
                document.frmglarchive.submit();
                
                <%}%>
            }
            
            function cmdListFirst(){
                document.frmglarchive.command.value="<%=JSPCommand.FIRST%>";
                document.frmglarchive.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmglarchive.action="glarchive.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdListPrev(){
                document.frmglarchive.command.value="<%=JSPCommand.PREV%>";
                document.frmglarchive.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmglarchive.action="glarchive.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdListNext(){
                document.frmglarchive.command.value="<%=JSPCommand.NEXT%>";
                document.frmglarchive.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmglarchive.action="glarchive.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdListLast(){
                document.frmglarchive.command.value="<%=JSPCommand.LAST%>";
                document.frmglarchive.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmglarchive.action="glarchive.jsp";
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
                                        <td width="165" height="100%" valign="top" style="<%="background:url(" + approot + "/images/leftmenu-bg.gif) repeat-y"%>"> 
                                            <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%>
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
                                                        <form name="frmglarchive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_glarchive" value="<%=oidGlArchive%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="gl_id" value="<%=gl_id%>">
                                                            <input type="hidden" name="hidden_referensi_id" value="<%=referensiId%>">                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <!--DWLayoutTable-->
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" height="127" valign="top"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="750">                                                                                                                                        
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" >                                                                                                            
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1"> 
                                                                                                                <tr>
                                                                                                                    <td colspan="5" height="5"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td height="10"></td>
                                                                                                                    <td colspan="4" height="10" class="fontarial"><b><i><%=langNav[6]%></i></b></td>
                                                                                                                </tr> 
                                                                                                                <tr> 
                                                                                                                    <td class="fontarial" width="5">&nbsp;</td>
                                                                                                                    <td width="90" class="fontarial"><%=langGL[0]%></td>
                                                                                                                    <td width="180"><input type="text" name="<%=jspGlArchive.colNames[jspGlArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= glArchive.getJournalNumber() %>"></td>
                                                                                                                    <td width="100" class="fontarial"><%=langGL[2]%></td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellspacing="0" cellpadding="0">  
                                                                                                                            <tr>
                                                                                                                                <td><input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getStartDate() == null ? new Date() : glArchive.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td>&nbsp;&nbsp;<%=langGL[3]%>&nbsp;&nbsp</td>
                                                                                                                                <td><input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getEndDate() == null ? new Date() : glArchive.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td><input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreInputDate() == 1) {%>checked<%}%>></td>
                                                                                                                                <td><%=langGL[4]%></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td class="fontarial">&nbsp;</td>
                                                                                                                    <td class="fontarial"><%=langGL[1]%></td>
                                                                                                                    <td class="fontarial"><input type="text" name="src_ref_number"  value="<%=srcRefNumber %>"></td>
                                                                                                                    <td class="fontarial"><%=langGL[6]%></td>
                                                                                                                    <td class="fontarial">
                                                                                                                        <table border="0" cellspacing="0" cellpadding="0">  
                                                                                                                            <tr>
                                                                                                                                <td><input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getTransactionDate() == null ? new Date() : glArchive.getTransactionDate()), "dd/MM/yyyy")%>" size="11" readOnly></td>    
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td><input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreTransactionDate() == 1) {%>checked<%}%>></td>
                                                                                                                                <td><%=langGL[4]%></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td class="fontarial">&nbsp;</td>
                                                                                                                    <td class="fontarial"><%=langGL[16]%></td>
                                                                                                                    <td > 
                                                                                                                        <select name="type_journal" class="formElemen">
                                                                                                                            <option value="-1" <%if (typeJournal == -1) {%> selected <%}%> >- All Type-</option>
                                                                                                                            <option value="<%=I_Project.JOURNAL_TYPE_GENERAL_LEDGER%>" <%if (typeJournal == I_Project.JOURNAL_TYPE_GENERAL_LEDGER) {%> selected <%}%> >Umum</option>
                                                                                                                            <option value="<%=I_Project.JOURNAL_TYPE_REVERSE%>" <%if (typeJournal == I_Project.JOURNAL_TYPE_REVERSE) {%> selected <%}%> >Pembalikan</option>                                                                                                                            
                                                                                                                            <option value="<%=I_Project.JOURNAL_TYPE_COPY%>" <%if (typeJournal == I_Project.JOURNAL_TYPE_COPY) {%> selected <%}%> >Copy</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td ><%=langGL[14]%></td>
                                                                                                                    <td ><input type="text" name="src_memo"  value="<%=src_memo%>" size="30"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td class="fontarial">&nbsp;</td>
                                                                                                                    <td class="fontarial"><%=langGL[5]%></td>
                                                                                                                    <td > 
                                                                                                                        <select name="<%=jspGlArchive.colNames[JspGlArchive.JSP_PERIODE_ID]%>" class="formElemen">
                                                                                                                            <option value="0" <%if (glArchive.getPeriodeId() == 0) {%> selected <%}%> >- All period -</option>
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
                                                                                                                    <td colspan="2"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="10"></td>
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
                                                                                <td >&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td> 
                                                                            </tr>    
                                                                            <tr> 
                                                                                <td height="5">&nbsp;</td> 
                                                                            </tr>    
                                                                            <%
            if (listGlArchive != null && listGlArchive.size() > 0) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">                                                                                        
                                                                                        <tr height="30"> 
                                                                                            <td width="100" class="tablehdr"><%=langGL[0]%></td>
                                                                                            <td width="13%" class="tablehdr"><%=langGL[6]%></td>                                                                                            
                                                                                            <td width="13%" class="tablehdr"><%=langNav[5]%></td>                                                                                            
                                                                                            <td width="15%" class="tablehdr">Create By</td>   
                                                                                            <td class="tablehdr"><%=langGL[8]%></td>
                                                                                            <td width="80" class="tablehdr"><%=langGL[1]%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                for (int i = 0; i < listGlArchive.size(); i++) {
                                                                                    Gl bd = (Gl) listGlArchive.get(i);
                                                                                    String style = "tablecell";
                                                                                    if (i % 2 != 0) {
                                                                                        style = "tablecell";
                                                                                    } else {
                                                                                        style = "tablecell1";
                                                                                    }

                                                                                    String typeJurnal = "";
                                                                                    if (bd.getJournalType() == I_Project.JOURNAL_TYPE_GENERAL_LEDGER) {
                                                                                        typeJurnal = "Jurnal Umum";
                                                                                    } else if (bd.getJournalType() == I_Project.JOURNAL_TYPE_REVERSE) {
                                                                                        typeJurnal = "Jurnal Balik";
                                                                                    } else if (bd.getJournalType() == I_Project.JOURNAL_TYPE_COPY) {
                                                                                        typeJurnal = "Jurnal Copy";
                                                                                    }

                                                                                    String name = "-";
                                                                                    String date = "";
                                                                                    try {
                                                                                        User u = DbUser.fetch(bd.getOperatorId());
                                                                                        Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                                                                                        name = e.getName();
                                                                                    } catch (Exception e) {
                                                                                    }
                                                                                    try {
                                                                                        date = JSPFormater.formatDate(bd.getDate(), "dd MMM yyyy");
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                        %>
                                                                                        <tr height="25"> 
                                                                                            <td class="<%=style%>" align="center">                                                                                                
                                                                                                <a href="<%="javascript:cmdEditGl('" + bd.getOID() + "')"%>"><%=bd.getJournalNumber()%></a>                                                                                                
                                                                                            </td>
                                                                                            <td class="<%=style%>" ><div align="center"><%=JSPFormater.formatDate(bd.getTransDate(), "dd MMM yyyy")%></div></td>
                                                                                            
                                                                                            <td class="<%=style%>" ><div align="center"><%=typeJurnal%></div></td>
                                                                                            <td class="<%=style%>" nowrap><div align="left"><%=name%> ( <%=date%> )</div></td>
                                                                                            <td class="<%=style%>" ><%=getSubstring(bd.getMemo())%></td>
                                                                                            <%if (bd.getPostedStatus() == 1) {%>
                                                                                            <td bgcolor="D4543A" align="center" class="fontarial"><font size="1">POSTED</font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1">NOT POSTED</font></td>
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
                                                                                if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                                                                                        (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                    cmd = iCommand;
                                                                                } else {
                                                                                    if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                        cmd = JSPCommand.FIRST;
                                                                                    } else {
                                                                                        cmd = prevCommand;
                                                                                    }
                                                                                }
                                                                                        %>
                                                                                        <% jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                jspLine.initDefault();
                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr height="22"> 
                                                                                <td class="fontarial" colspan="7"><i> 
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
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
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


