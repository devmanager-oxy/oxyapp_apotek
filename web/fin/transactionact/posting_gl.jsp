
<%-- 
    Document   : posting_gl
    Created on : May 25, 2011, 10:10:04 AM
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_POST_GL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%@ include file="../calendar/calendarframe.jsp"%>

<%
            
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long periodeId = JSPRequestValue.requestLong(request, "periode_id");
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            int ignoreTrans = JSPRequestValue.requestInt(request, "ignore_trans");
            String jurnalNumber = JSPRequestValue.requestString(request, "jurnal_number");

            if (iCommand == JSPCommand.NONE) {
                ignore = 1;
                ignoreTrans = 1;
            }

            Date startDate = new Date();
            Date endDate = new Date();

            if (JSPRequestValue.requestString(request, "start_date").length() > 0) {
                startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, "end_Date").length() > 0) {
                endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_Date"), "dd/MM/yyyy");
            }


            Date transStartDate = new Date();
            Date transEndDate = new Date();

            if (JSPRequestValue.requestString(request, "trans_start_date").length() > 0) {
                transStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "trans_start_date"), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, "trans_end_Date").length() > 0) {
                transEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "trans_end_Date"), "dd/MM/yyyy");
            }


            Vector listGl = new Vector();
            String order = " year(" + DbGl.colNames[DbGl.COL_TRANS_DATE] + "),month(" + DbGl.colNames[DbGl.COL_TRANS_DATE] + ")," + DbGl.colNames[DbGl.COL_JOURNAL_COUNTER];
            String where = DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + DbGl.IS_NOT_REVERSAL + " and " + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_GENERAL_LEDGER+
                    " and ("+ DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.NOT_POSTED+" OR gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " IS NULL )";

            if (jurnalNumber != null && jurnalNumber.length() > 0) {
                if (where != null && where.length() > 0) {
                    where = where + " and ";
                }

                where = where + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurnalNumber + "%'";
            }

            if (periodeId != 0) {
                if (where != null && where.length() > 0) {
                    where = where + " and ";
                }

                where = where + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + periodeId;
            }


            if (ignore == 0) {
                if (where != null && where.length() > 0) {
                    where = where + " and ";
                }

                where = where + " to_days(" + DbGl.colNames[DbGl.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(" + DbGl.colNames[DbGl.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";
            }

            if (ignoreTrans == 0) {
                if (where != null && where.length() > 0) {
                    where = where + " and ";
                }

                where = where + " to_days(" + DbGl.colNames[DbGl.COL_TRANS_DATE] + ") >= to_days('" + JSPFormater.formatDate(transStartDate, "yyyy-MM-dd") + "') and to_days(" + DbGl.colNames[DbGl.COL_TRANS_DATE] + ") <= to_days('" + JSPFormater.formatDate(transEndDate, "yyyy-MM-dd") + "') ";
            }

            
            if(iCommand == JSPCommand.SEARCH || iCommand == JSPCommand.POST){
                listGl = DbGl.list(0, 0, where, order);
            }

            if (iCommand == JSPCommand.POST) {

                if (listGl != null && listGl.size() > 0) {
                    for (int i = 0; i < listGl.size(); i++) {
                        Gl gl = (Gl) listGl.get(i);
                        if (JSPRequestValue.requestInt(request, "check_" + gl.getOID()) == 1) {
                            DbGl.updateStatusPosting(gl, user.getOID());
                        }
                    }
                }

                listGl = DbGl.list(0, 0, where, order);
            }

            String[] langCT = {"Journal Number", "Transaction Date", "Receipt to Account", "Currency", "Memo", "Posting", "Code", "Summary", "Data not found", "Journal has been posted successfully."};
            String[] langNav = {"Journal", "Post Jurnal", "Search for", "General Journal", "Journal Reversal", "Period", "Create Date", "Location", "Ignore", "To", "Date Transaction"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Perkiraan Penerimaan", "Mata Uang", "Memo", "Posting", "Code", "Jumlah", "Transaksi Bank", "Post Jurnal", "Data tidak ditemukan", "Jurnal selesai di posting"};
                langCT = langID;

                String[] navID = {"Jurnal", "Post Jurnal", "Pencarian", "Jurnal Umum", "Jurnal Reversal", "Periode", "Tanggal Dibuat", "Lokasi", "Abaikan", "Sampai", "Tanggal Transaksi"};
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
                document.frmposgl.command.value="<%=JSPCommand.SEARCH %>";
                document.frmposgl.prev_command.value="<%=prevCommand%>";
                document.frmposgl.action="posting_gl.jsp";
                document.frmposgl.submit();
            }
            
            function cmdPost(){            	
                document.frmposgl.command.value="<%=JSPCommand.POST%>";
                document.frmposgl.prev_command.value="<%=prevCommand%>";
                document.frmposgl.action="posting_gl.jsp";
                document.frmposgl.submit();
            }
            
            function setChecked(val) {
                 <%
            for (int k = 0; k < listGl.size(); k++) {
                Gl oGl = (Gl) listGl.get(k);
                 %>
                     document.frmposgl.check_<%=oGl.getOID()%>.checked=val.checked;
                     <% }%>
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/savedoc2.gif','../images/post_journal2.gif')">
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
                                                        <form name="frmposgl" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <!--DWLayoutTable-->
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" valign="top"> 
                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="750">                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" >
                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td width="5"></td>
                                                                                                        <td width="75"></td>
                                                                                                        <td width="180"></td>
                                                                                                        <td width="100"></td> 
                                                                                                        <td ></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td class="fontarial"><%=langCT[0]%></td>
                                                                                                        <td  ><input type="text" name="jurnal_number"  value="<%= jurnalNumber %>"></td>
                                                                                                        <td class="fontarial"><%=langNav[6]%></td>
                                                                                                        <td>
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">  
                                                                                                                <tr>
                                                                                                                    <td><input name="start_date" value="<%=JSPFormater.formatDate((startDate == null ? new Date() : startDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmposgl.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td>&nbsp;&nbsp;<%=langNav[9]%>&nbsp;&nbsp</td>
                                                                                                                    <td><input name="end_date" value="<%=JSPFormater.formatDate((endDate == null ? new Date() : endDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmposgl.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td><input name="ignore" type="checkBox" class="formElemen"  value="1" <%if (ignore == 1) {%>checked<%}%>></td>
                                                                                                                    <td><%=langNav[8]%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>                                                                                                        
                                                                                                    </tr>  
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td class="fontarial"><%=langNav[5]%></td>
                                                                                                        <td  >
                                                                                                            <select name="periode_id" class="formElemen">
                                                                                                                <option value="0" <%if (periodeId == 0) {%> selected <%}%> >- All period -</option>
                                                                                                                <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC ");

            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=period.getOID()%>" <%if (periodeId == period.getOID()) {%> selected <%}%> ><%=period.getName().trim()%></option>
                                                                                                                <%
                }
            }
                                                                                                                %>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td class="fontarial"><%=langNav[10]%></td>
                                                                                                        <td>
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">  
                                                                                                                <tr>
                                                                                                                    <td><input name="trans_start_date" value="<%=JSPFormater.formatDate((transStartDate == null ? new Date() : transStartDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmposgl.trans_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td>&nbsp;&nbsp;<%=langNav[9]%>&nbsp;&nbsp</td>
                                                                                                                    <td><input name="trans_end_date" value="<%=JSPFormater.formatDate((transEndDate == null ? new Date() : transEndDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmposgl.trans_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td><input name="ignore_trans" type="checkBox" class="formElemen"  value="1" <%if (ignoreTrans == 1) {%>checked<%}%>></td>
                                                                                                                    <td><%=langNav[8]%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>                                                                                                        
                                                                                                    </tr>  
                                                                                                    <tr height="10">
                                                                                                        <td colspan="5"></td>                                                                                                        
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
                                                                                <td>&nbsp;</td>
                                                                            </tr>    
                                                                            <%
            if(iCommand == JSPCommand.SEARCH || iCommand == JSPCommand.POST){                                                                
                                                                            
            if (listGl != null && listGl.size() > 0) {
                                                                            %>                                                               
                                                                            <tr> 
                                                                                <td>
                                                                                    
                                                                                    <table width="1150" border="0" cellpadding="1" cellspacing="1">
                                                                                        <tr>
                                                                                            <td width="10" class="tablehdr">No.</td>
                                                                                            <td width="15%" class="tablehdr"><%=langCT[0]%></td>                                                                                            
                                                                                            <td width="13%" class="tablehdr"><%=langNav[6]%></td>
                                                                                            <td width="13%" class="tablehdr"><%=langCT[1]%></td>
                                                                                            <td class="tablehdr"><%=langCT[4]%></td>
                                                                                            <td width="5%"  class="tablehdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>                                                        
                                                                                        <%
                                                                                for (int i = 0; i < listGl.size(); i++) {
                                                                                    Gl gl = (Gl) listGl.get(i);
                                                                                    Vector vgld = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), "debet desc");
                                                                                        %>                                                                                        
                                                                                        <tr>
                                                                                            <td class="fontarial" bgcolor="#94D296" align="center"><%=(i + 1)%></td>
                                                                                            <td class="tablecell1" align="center"><%=gl.getJournalNumber()%></td>
                                                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatDate(gl.getDate(), "dd MMM yyyy")%></td>
                                                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatDate(gl.getTransDate(), "dd MMM yyyy")%></td>
                                                                                            <td class="tablecell1" align="left"><%=gl.getMemo()%></td>
                                                                                            <td class="tablecell1" align="center"><input type="checkbox" name="check_<%=gl.getOID()%>" value="1"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            if (vgld.size() != 0) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="tablecell1" ></td>
                                                                                            <td class="tablecell1" colspan="5">
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0" align="right">
                                                                                                    <tr>
                                                                                                        <td width="36%" class="tablecell" align="center"><b>Perkiraan</b></td>
                                                                                                        <td width="15%" class="tablecell" align="center"><b>Segmen</b></td>
                                                                                                        <td width="12%" class="tablecell" align="center"><b>Debet</b></td>
                                                                                                        <td width="12%" class="tablecell" align="center"><b>Kredit</b></td>
                                                                                                        <td class="tablecell" align="center"><b>Keterangan</b></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                            double subDebet = 0;
                                                                                            double subCredit = 0;
                                                                                            for (int j = 0; j < vgld.size(); j++) {
                                                                                                GlDetail ogld = (GlDetail) vgld.get(j);
                                                                                                Coa oCoa = new Coa();
                                                                                                subDebet += ogld.getDebet();
                                                                                                subCredit += ogld.getCredit();

                                                                                                try {
                                                                                                    oCoa = DbCoa.fetchExc(ogld.getCoaId());
                                                                                                } catch (Exception e) {

                                                                                                }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablecell"><%=oCoa.getCode() + " - " + oCoa.getName()%></td>
                                                                                                        <td class="tablecell" >
                                                                                                            <div align="left"> 
                                                                                                                <%
                                                                                                        String segment = "";
                                                                                                        try {
                                                                                                            if (ogld.getSegment1Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment1Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment2Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment2Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment3Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment3Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment4Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment4Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment5Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment5Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment6Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment6Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment7Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment7Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment8Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment8Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment9Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment9Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment10Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment10Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment11Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment11Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment12Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment12Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment13Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment13Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment14Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment14Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (ogld.getSegment15Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(ogld.getSegment15Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                        } catch (Exception e) {
                                                                                                        }

                                                                                                        if (segment.length() > 0) {
                                                                                                            segment = segment.substring(0, segment.length() - 3);
                                                                                                        }
                                                                                                                %>
                                                                                                            <%=segment%></div>
                                                                                                        </td>  
                                                                                                        <td class="tablecell" align="right"><%=ogld.getDebet() == 0 ? "" : JSPFormater.formatNumber(ogld.getDebet(), "#,###.##")%>&nbsp;&nbsp;</td>
                                                                                                        <td class="tablecell" align="right"><%=ogld.getCredit() == 0 ? "" : JSPFormater.formatNumber(ogld.getCredit(), "#,###.##")%>&nbsp;&nbsp;</td>
                                                                                                        <td class="tablecell"><%=ogld.getMemo()%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                            }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablecell1" colspan="2" align="center"><b>Total</b></td>
                                                                                                        <td class="tablecell1" align="right"><b><%=subDebet == 0 ? "" : JSPFormater.formatNumber(subDebet, "#,###.##")%></b>&nbsp;&nbsp;</td>
                                                                                                        <td class="tablecell1" align="right"><b><%=subCredit == 0 ? "" : JSPFormater.formatNumber(subCredit, "#,###.##")%></b>&nbsp;&nbsp;</td>
                                                                                                        <td class="tablecell1">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="tablecell" colspan="6">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }
                                                                                        %>
                                                                                        
                                                                                        
                                                                                        <%
                                                                                }
                                                                                        %>
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr>
                                                                            <%
                                                                                if (iCommand == JSPCommand.POST) {
                                                                            %>
                                                                            <tr>
                                                                                <td height="40px;">
                                                                                    <div align="left" class="msgnextaction"> 
                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                                                            <tr> 
                                                                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                <td width="180"><i><%=langCT[11]%></i></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr>
                                                                                <td height="20px;">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr>
                                                                                <td class="container">
                                                                                    <%if (privUpdate || privAdd) {%>
                                                                                    <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                    <%}%>
                                                                                </td>                                     
                                                                            </tr>    
                                                                            <tr>
                                                                                <td height="40px;">&nbsp;</td>
                                                                            </tr>    
                                                                            <% } else {%>
                                                                            <%if (iCommand == JSPCommand.POST) {%>
                                                                            <tr>
                                                                                <td height="40px;">
                                                                                    <div align="left" class="msgnextaction"> 
                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                                                            <tr> 
                                                                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                <td width="180"><i><%=langCT[11]%></i></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr> 
                                                                            <%} else {%>
                                                                            <tr>
                                                                                <td height="40px;"><i><%=langCT[10]%></i></td>
                                                                            </tr> 
                                                                            <%}%>
                                                                            <%}%>
                                                                            <%}else{%>
                                                                            <tr>
                                                                                <td height="40px;"><i>Klik seardh button to seraching the data</i></td>
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
                                <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>

