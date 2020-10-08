
<%-- 
    Document   : akrualdetail
    Created on : Mar 22, 2013, 10:44:12 AM
    Author     : Roy Andika
--%>


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
<%!
    public String getStrLevel(int level) {
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
%>
<%!    public Vector addNewDetail(Vector listGlDetail, GlDetail glDetail) {
        boolean found = false;
        if (listGlDetail != null && listGlDetail.size() > 0) {
            for (int i = 0; i < listGlDetail.size(); i++) {
                GlDetail cr = (GlDetail) listGlDetail.get(i);
                if (cr.getCoaId() == glDetail.getCoaId() && cr.getForeignCurrencyId() == glDetail.getForeignCurrencyId()) {
                    cr.setForeignCurrencyAmount(cr.getForeignCurrencyAmount() + glDetail.getForeignCurrencyAmount());
                    if (cr.getDebet() > 0 && glDetail.getDebet() > 0) {
                        cr.setDebet(cr.getDebet() + glDetail.getDebet());
                        found = true;
                    } else {
                        if (cr.getCredit() > 0 && glDetail.getCredit() > 0) {
                            cr.setCredit(cr.getCredit() + glDetail.getCredit());
                            found = true;
                        }
                    }
                }
            }
        }

        if (!found) {
            listGlDetail.add(glDetail);
        }

        return listGlDetail;
    }

    public double getTotalDetail(Vector listx, int typex) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                GlDetail crd = (GlDetail) listx.get(i);
                //debet
                if (typex == 0) {
                    result = result + crd.getDebet();
                } //credit
                else {
                    result = result + crd.getCredit();
                }
            }
        }
        return result;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidGl = JSPRequestValue.requestLong(request, "hidden_gl_id");
            long oidGlDetail = JSPRequestValue.requestLong(request, "hidden_gl_detail_id");
            long oidRef = JSPRequestValue.requestLong(request, "hidden_ref_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");          

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("GL_DETAIL");
                oidGl = 0;
                recIdx = -1;
            }
            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            if (iJSPCommand == JSPCommand.LOAD) {
                session.removeValue("GL_DETAIL");
                String whereAp = DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_AKRUAL + " and " + DbGl.colNames[DbGl.COL_REFERENSI_ID] + " = " + oidRef;
                Vector vGl = DbGl.list(0, 1, whereAp, null);
                if (vGl != null && vGl.size() > 0) {
                    Gl tmpGl = (Gl) vGl.get(0);
                    oidGl = tmpGl.getOID();
                }
                recIdx = -1;
            }

            CmdGl ctrlGl = new CmdGl(request);
            JSPLine ctrLine = new JSPLine();
            Vector listGl = new Vector(1, 1);

            int iErrCodeMain = ctrlGl.action(iJSPCommand, oidGl);

            JspGl jspGl = ctrlGl.getForm();
            int vectSize = DbGl.getCount(whereClause);

            Gl gl = ctrlGl.getGl();
            String msgStringMain = ctrlGl.getMessage();

            if (oidGl == 0) {
                oidGl = gl.getOID();
            }

            if (iJSPCommand == JSPCommand.LOAD) {
                try {
                    gl = DbGl.fetchExc(oidGl);
                } catch (Exception e) {
                }
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlGl.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            /* get record to display */
            listGl = DbGl.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listGl.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listGl = DbGl.list(start, recordToGet, whereClause, orderClause);
            }

%>
<%
            boolean load = false;

            if (iJSPCommand == JSPCommand.LOAD) {
                load = true;
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }

            CmdGlDetail ctrlGlDetail = new CmdGlDetail(request);
            Vector listGlDetail = new Vector(1, 1);
            if (load) {
                listGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), null);
            }

            /*switch statement */
            iErrCode = ctrlGlDetail.action(iJSPCommand, DbPeriode.getOpenPeriod(), oidGlDetail);
            /* end switch*/
            JspGlDetail jspGlDetail = ctrlGlDetail.getForm();

            /*count list All GlDetail*/
            vectSize = DbGlDetail.getCount(whereClause);

            /*switch list GlDetail*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlGlDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            GlDetail glDetail = ctrlGlDetail.getGlDetail();
            msgString = ctrlGlDetail.getMessage();

            if (session.getValue("GL_DETAIL") != null) {
                listGlDetail = (Vector) session.getValue("GL_DETAIL");
            }

            session.putValue("GL_DETAIL", listGlDetail);
            String wherex = "(location_id=" + sysLocation.getOID() + " or location_id=0)";

            if (isPostableOnly) {
                wherex = wherex + " and status='" + I_Project.ACCOUNT_LEVEL_POSTABLE + "'";
            }

            double totalDebet = getTotalDetail(listGlDetail, 0);
            double totalCredit = getTotalDetail(listGlDetail, 1);

            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0 && iErrCodeMain == 0) {
                iJSPCommand = JSPCommand.ADD;
                glDetail = new GlDetail();
                recIdx = -1;
            }

            boolean diffCoaClass = false;

            /*** LANG ***/
            String[] langGL = {"Journal Number", "Transaction Date", "Reference Number", "Journal Detail", //0-3
                "Account - Description", "Department", "Currency", "Code", "Amount", "Booked Rate", "Debet", "Credit", "Description", //4-12
                "Error, can't posting journal when details mixed between SP and NSP", "Journal has been saved successfully.", "Searching", "Journal is ready to be saved", "Memo", "Period", "Segment"};//13-19
            String[] langNav = {"Recurring Journal", "Recurring Detail", "Date", "SEARCHING", "EDITOR JOURNAL"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Detail Jurnal", //0-3
                    "Perkiraan", "Departemen", "Mata Uang", "Kode", "Jumlah", "Kurs", "Debet", "Credit", "Keterangan", //4-12
                    "Error, tidak bisa posting journal dengan detail gabungan SP dan NSP.", "Jurnal sukses disimpan.", "Pencarian", "Jurnal siap untuk disimpan", "Memo", "Periode", "Segmen"}; //13-19

                langGL = langID;

                String[] navID = {"Jurnal Akrual", "Jurnal Detail", "Tanggal", "PENCARIAN", "EDITOR JURNAL"};
                langNav = navID;
            }

            Vector segments = DbSegment.list(0, 0, "", "count");
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>   
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(){	 
                window.open("<%=printroot%>.report.RptGLPDF?oid=<%=appSessUser.getLoginId()%>&gl_id=<%=gl.getOID()%>");
                }
                
                function cmdBack(){
                    document.frmgl.command.value="<%=JSPCommand.BACK%>";
                    document.frmgl.action="akrualarsip.jsp";
                    document.frmgl.submit();
                }
                
                function cmdDelPict(oidGlDetail){
                    document.frmimage.hidden_gl_detail_id.value=oidGlDetail;
                    document.frmimage.command.value="<%=JSPCommand.POST%>";
                    document.frmimage.action="akrualdetail.jsp";
                    document.frmimage.submit();
                }
                
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmgl" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_gl_detail_id" value="<%=oidGlDetail%>">
                                                            <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_TYPE]%>" value="<%=I_Project.JOURNAL_TYPE_GENERAL_LEDGER%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="31">&nbsp;</td>
                                                                                                        <td width="32%">&nbsp;</td>
                                                                                                        <td width="37%"> 
                                                                                                            <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                                                                            : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspGl.getErrorMsg(JspGl.JSP_OPERATOR_ID) %>&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="700" border="0" cellspacing="1" cellpadding="0">    
                                                                                                    <%
            Periode p = new Periode();
            try {
                p = DbPeriode.fetchExc(gl.getPeriodId());
            } catch (Exception e) {
            }
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="5"></td>
                                                                                                        <td width="17%"><%=langGL[0]%></td>
                                                                                                        <td width="1%">:&nbsp;</td>
                                                                                                        <td width="23%"><input type="text" name="number" value="<%=gl.getJournalNumber()%>" readonly class="readOnly"></td>
                                                                                                        <td width="17%"><%=langGL[18]%></td>
                                                                                                        <td >:&nbsp;<input type="text" name="period" value="<%=p.getName()%>" readonly class="readOnly"></td>
                                                                                                        <td width="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td >&nbsp; </td>
                                                                                                        <td ><%=langGL[2]%></td>
                                                                                                        <td >:&nbsp;</td>
                                                                                                        <td ><input type="text" name="ref" value="<%=gl.getRefNumber()%>" readonly class="readOnly"></td>
                                                                                                        <td ><%=langGL[1]%></td>
                                                                                                        <td >:&nbsp;<input type="text" name="trans" value="<%=JSPFormater.formatDate(gl.getTransDate(), "dd MMM yyyy")%>" readonly class="readOnly"></td>
                                                                                                        <td ></td>
                                                                                                    </tr>   
                                                                                                    <tr>
                                                                                                        <td >&nbsp; </td>
                                                                                                        <td valign="top"><%=langGL[17]%></td>
                                                                                                        <td valign="top">:&nbsp;</td>
                                                                                                        <td valign="top" colspan="3"><textarea name="memo" class="readOnly" cols="25"><%=gl.getMemo()%></textarea></td>                                                                                                                                                                                                                
                                                                                                        <td ></td>
                                                                                                    </tr> 
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>                                                                                       
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr> 
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                                                                        <td class="tabheader" nowrap></td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000"> 
                                                                                                        </font></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="100%" class="page"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <%
            if (listGlDetail != null && listGlDetail.size() > 0) {

                int ct = 0;
                for (int i = 0; i < listGlDetail.size(); i++) {
                    GlDetail crd = (GlDetail) listGlDetail.get(i);

                    if (crd.getDebet() > 0) {
                        crd.setIsDebet(0);
                    } else {
                        crd.setIsDebet(1);
                    }

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                        if (i == 0) {
                            ct = c.getAccountClass();
                        } else {
                            if (!diffCoaClass && ct != c.getAccountClass()) {
                                if (ct == 2) {
                                    if (c.getAccountClass() != 2) {
                                        diffCoaClass = true;
                                    }
                                } else {
                                    if (c.getAccountClass() == 2) {
                                        diffCoaClass = true;
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                                                                                                                %>
                                                                                                                <% if (i == 0) {%>                                                                                                                
                                                                                                                <tr>
                                                                                                                    <td rowspan="2" class="tablehdr" nowrap width="15%"><%=langGL[19]%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" nowrap width="21%"><%=langGL[4]%></td>
                                                                                                                    <td rowspan="2" class="tablehdr"><%=langGL[5]%></td>                                                                                                                    
                                                                                                                    <td colspan="2" class="tablehdr"><%=langGL[6]%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="7%"><%=langGL[9]%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="10%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="10%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="30%"><%=langGL[12]%></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="4%" class="tablehdr"><%=langGL[7]%></td>
                                                                                                                    <td width="10%" class="tablehdr"><%=langGL[8]%></td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" > 
                                                                                                                        <%

                                                                                                                        String outStr = "";

                                                                                                                        if (crd.getModuleId() != 0) {
                                                                                                                            Module module = new Module();
                                                                                                                            try {
                                                                                                                                module = DbModule.fetchExc(crd.getModuleId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            StringTokenizer strTok = new StringTokenizer(module.getDescription(), ";");

                                                                                                                            int countOut = 0;

                                                                                                                            while (strTok.hasMoreTokens()) {

                                                                                                                                if (countOut != 0) {
                                                                                                                                    outStr = "(" + (countOut + 1) + ") " + outStr + " ";
                                                                                                                                }

                                                                                                                                outStr = outStr + strTok.nextToken();
                                                                                                                                countOut++;
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                        %>
                                                                                                                        <table border="0" cellpadding="1" cellspacing="1" >
                                                                                                                            <%
                                                                                                                                                                                                                                                                                                                                                                        for (int is = 0; is < segments.size(); is++) {
                                                                                                                                                                                                                                                                                                                                                                            Segment objSeg = (Segment) segments.get(is);

                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td >&nbsp;&nbsp;&nbsp;<%=objSeg.getName()%></td>
                                                                                                                                <%
                                                                                                                                String nameSeg = "";
                                                                                                                                switch (is + 1) {
                                                                                                                                    case 1:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment1Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 2:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment2Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 3:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment3Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 4:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment4Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 5:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment5Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 6:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment6Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 7:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment7Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 8:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment8Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 9:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment9Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 10:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment10Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 11:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment11Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 12:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment12Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 13:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment13Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 14:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment14Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 15:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment15Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                }
                                                                                                                                %>
                                                                                                                                <td >&nbsp;:&nbsp;&nbsp;<%=nameSeg%></td>
                                                                                                                            </tr>                                                                                                                                                
                                                                                                                            <%
                                                                                                                                                                                                                                                                                                                                                                        }
                                                                                                                            %>    
                                                                                                                        </table>
                                                                                                                        <%
                                                                                                                        }

                                                                                                                        out.println(outStr);
                                                                                                                        %>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell" nowrap height="17"><%=c.getCode() + " - " + c.getName()%> </td>
                                                                                                                    <td class="tablecell">
                                                                                                                        <%
                                                                                                                        try {
                                                                                                                            if (crd.getDepartmentId() != 0) {
                                                                                                                                Department dept = DbDepartment.fetchExc(crd.getDepartmentId());
                                                                                                                                out.println(dept.getName());
                                                                                                                            } else {
                                                                                                                                out.println("-");
                                                                                                                            }
                                                                                                                        } catch (Exception xcc) {
                                                                                                                        }
                                                                                                                        %>
                                                                                                                    </td>                                                                                                                    
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <%
                                                                                                                        Currency xc = new Currency();
                                                                                                                        try {
                                                                                                                            xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                                                                                        } catch (Exception e) {
                                                                                                                        }
                                                                                                                            %>
                                                                                                                        <%=xc.getCurrencyCode()%> </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%> </div>                                                      </td>
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>                                                      </td>
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></div>                                                      </td>
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></div>                                                      </td>
                                                                                                                    <td class="tablecell" height="17"><%=crd.getMemo()%></td>
                                                                                                                </tr>
                                                                                                                
                                                                                                                <%}
            }%>                                                                                                                                                                          
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" colspan="10" height="1">&nbsp</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="6"> 
                                                                                                                    <div align="right"><b>TOTAL : </b></div></td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="total_debet" value="<%=JSPFormater.formatNumber(totalDebet, "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="total_credit" value="<%=JSPFormater.formatNumber(totalCredit, "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell">&nbsp;</td>
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
                                                                            <%if (gl.getOID() != 0 && gl.getPostedStatus() == 1) {%>
                                                                            <tr>
                                                                                <td>&nbsp;</td>
                                                                            </tr>  
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <div align="left"> 
                                                                                        <table border="0" cellpadding="5" cellspacing="0">
                                                                                            <tr> 
                                                                                                <td width="10"><img src="../images/success.gif"></td>
                                                                                                <td width="50"><i>Posted</i></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <%}%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>        
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <div align="left"> 
                                                                                     <a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/back2.gif',1)"><img src="../images/back.gif" name="new21" border="0"></a>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>          
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

