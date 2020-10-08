
<%-- 
    Document   : giro_archives
    Created on : Apr 23, 2014, 2:29:36 PM
    Author     : Roy Andika
--%>

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
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privUpdate = true;
            boolean privAdd = true;
            boolean privDelete = true;
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
            String src_memo = JSPRequestValue.requestString(request, "src_memo");

            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String orderClause = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];
            String where = DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_GIRO_MASUK;

            CmdGlArchive cmdGlArchive = new CmdGlArchive(request);
            JSPLine jspLine = new JSPLine();
            Vector listGlArchive = new Vector(1, 1);
            GlArchive glArchive = new GlArchive();
            JspGlArchive jspGlArchive = new JspGlArchive(request, glArchive);

            iErrCode = cmdGlArchive.action(iCommand, oidGlArchive);
            jspGlArchive.requestEntityObject(glArchive);
            msgString = cmdGlArchive.getMessage();           
            
            if (iCommand == JSPCommand.NONE) {
                glArchive.setIgnoreTransactionDate(1);
                glArchive.setIgnoreInputDate(1);
            }
            
            if (glArchive.getIgnoreTransactionDate() == 0 && glArchive.getTransactionDate() != null) {//trans_date
                where = where + " AND " + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(glArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
            }

            if (glArchive.getJournalNumber() != null && glArchive.getJournalNumber().length() > 0) {
                where = where + " AND "+ DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + glArchive.getJournalNumber() + "%'";
            }

            if (glArchive.getPeriodeId() != 0) {
                where = where + " AND " + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + glArchive.getPeriodeId() + "'";
            }

            if (glArchive.getIgnoreInputDate() == 0) {
                where = where + " AND " + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(glArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(glArchive.getEndDate(), "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                where = where + " AND " + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (src_memo != null && src_memo.length() > 0) {
                where = where + " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + src_memo + "%'";
            }

            int vectSize = 0;
            vectSize = DbGl.getCount(where);

            start = cmdGlArchive.actionList(iCommand, start, vectSize, recordToGet);
            listGlArchive = DbGl.list(start, recordToGet, where, orderClause);


            /*** LANG ***/
            String[] langGL = {"Journal Number", "Status", "Input Date", "to", "Ignore", //0-4
                "Period", "Transaction Date", "General Journal List", "Memo", "Please click search button to get your data.", "Data not found.", "Debet", "Credit", "Advance Journal", "Notes", "Amount"}; //5-15

            String[] langNav = {"BG", "Archives", "Date", "General Journal", "Advance Journal", "Type", "Searching Parameter"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Status", "Tanggal Dibuat", "sampai", "Abaikan", //0-4
                    "Periode", "Tanggal Transaksi", "Daftar Jurnal Umum", "Memo", "Silahkan tekan tombol pencarian untuk menampilkan data.", "Data tidak ditemukan.", "Debet", "Credit", "Daftar Jurnal Kasbon", "Memo", "Jumlah"}; //5-15
                langGL = langID;

                String[] navID = {"BG", "Arsip", "Tanggal", "Jurnal Umum", "Jurnal Kasbon", "Type", "Parameter Pencarian"};
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
                document.frmgiroarchives.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmgiroarchives.prev_command.value="<%=prevCommand%>";
                document.frmgiroarchives.action="giro_archives.jsp";
                document.frmgiroarchives.submit();
            }
            
            function cmdEditGl(oidGl){                
                <%if (privUpdate) {%>
                document.frmgiroarchives.gl_id.value = oidGl;
                document.frmgiroarchives.command.value="<%=JSPCommand.LOAD%>";                
                document.frmgiroarchives.action="giro_archives_detail.jsp";
                document.frmgiroarchives.submit();                
                <%}%>
            }
            
            function cmdListFirst(){
                document.frmgiroarchives.command.value="<%=JSPCommand.FIRST%>";
                document.frmgiroarchives.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmgiroarchives.action="giro_archives.jsp";
                document.frmgiroarchives.submit();
            }
            
            function cmdListPrev(){
                document.frmgiroarchives.command.value="<%=JSPCommand.PREV%>";
                document.frmgiroarchives.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmgiroarchives.action="giro_archives.jsp";
                document.frmgiroarchives.submit();
            }
            
            function cmdListNext(){
                document.frmgiroarchives.command.value="<%=JSPCommand.NEXT%>";
                document.frmgiroarchives.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmgiroarchives.action="giro_archives.jsp";
                document.frmgiroarchives.submit();
            }
            
            function cmdListLast(){
                document.frmgiroarchives.command.value="<%=JSPCommand.LAST%>";
                document.frmgiroarchives.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmgiroarchives.action="giro_archives.jsp";
                document.frmgiroarchives.submit();
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
                                                        <form name="frmgiroarchives" method ="post" action="">
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
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmgiroarchives.<%=jspGlArchive.colNames[jspGlArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td>&nbsp;&nbsp;<%=langGL[3]%>&nbsp;&nbsp</td>
                                                                                                                                <td><input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getEndDate() == null ? new Date() : glArchive.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmgiroarchives.<%=jspGlArchive.colNames[jspGlArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
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
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmgiroarchives.<%=jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td><input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreTransactionDate() == 1) {%>checked<%}%>></td>
                                                                                                                                <td><%=langGL[4]%></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td class="fontarial">&nbsp;</td>
                                                                                                                    <td class="fontarial"><%=langGL[5]%></td>
                                                                                                                    <td > 
                                                                                                                        <select name="<%=jspGlArchive.colNames[JspGlArchive.JSP_PERIODE_ID]%>" class="formElemen">
                                                                                                                            <option value="0" <%if (glArchive.getPeriodeId() == 0) {%> selected <%}%> >All period..</option>
                                                                                                                            <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC ");
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
                                                                                                                    <td ><%=langGL[14]%></td>
                                                                                                                    <td ><input type="text" name="src_memo"  value="<%=src_memo%>" size="30"></td>
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
                                                                                <td >&nbsp;</td> 
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

                                                                                        %>
                                                                                        <tr height="25"> 
                                                                                            <td class="<%=style%>" align="center">
                                                                                                <%if (type == DbGl.TYPE_JURNAL_UMUM) {%>
                                                                                                <a href="<%="javascript:cmdEditGl('" + bd.getOID() + "')"%>"><%=bd.getJournalNumber()%></a>
                                                                                                <%} else if (type == DbGl.TYPE_JURNAL_KASBON) {%>
                                                                                                <a href="<%="javascript:cmdEditGlKasbon('" + bd.getReferensiId() + "')"%>"><%=bd.getJournalNumber()%></a>        
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=style%>" ><div align="center"><%=JSPFormater.formatDate(bd.getTransDate(), "dd MMM yyyy")%></div></td>                                                                                            
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
