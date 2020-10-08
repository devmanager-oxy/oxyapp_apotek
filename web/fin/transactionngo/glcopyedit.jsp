
<%-- 
    Document   : glcopyedit
    Created on : Oct 11, 2013, 9:51:13 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
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
            int glType = JSPRequestValue.requestInt(request, "gl_type");

            String journalNumber = JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_JOURNAL_NUMBER]);
            String journalPrefix = JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_JOURNAL_PREFIX]);
            int journalCounter = JSPRequestValue.requestInt(request, JspGl.colNames[JspGl.JSP_JOURNAL_COUNTER]);
            int journalType = JSPRequestValue.requestInt(request, JspGl.colNames[JspGl.JSP_JOURNAL_TYPE]);
            String refNumber = JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_REF_NUMBER]);
            long periodId = JSPRequestValue.requestLong(request, JspGl.colNames[JspGl.JSP_PERIOD_ID]);
            Date transDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_TRANS_DATE]), "dd/MM/yyyy");
            String memo = JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_MEMO]);

            Gl gl = new Gl();
            Gl copyGl = new Gl();
            int counter = DbGl.getNextCounter();

            if (oidGl != 0) {
                try {
                    gl = DbGl.fetchExc(oidGl);
                } catch (Exception e) {
                }
            }

            String errDate = "";
            String msgString = "";
            String msgStyle = "";
            long oidGlReverse = 0;
            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                /** check if transdate out of period date */
                boolean isValidDate = DbPeriode.isValidDate(periodId, transDate);

                if (isValidDate) {
                    copyGl.setJournalNumber(journalNumber);
                    copyGl.setJournalPrefix(journalPrefix);
                    copyGl.setJournalCounter(journalCounter);
                    copyGl.setJournalType(journalType);
                    copyGl.setRefNumber(refNumber);
                    copyGl.setPeriodId(periodId);
                    copyGl.setMemo(memo);

                    if (transDate != null) {
                        copyGl.setTransDate(transDate);
                    }

                    oidGlReverse = DbGl.doCopyPostedJournal(oidGl, copyGl, user.getOID());
                    if (oidGlReverse == 0) {
                        msgString = "Data tidak bisa tersimpan";
                        msgStyle = "errfont";
                    } else {
                        isSave = true;
                        msgString = "Data sudah tersimpan";
                        msgStyle = "info";
                        try {
                            gl = DbGl.fetchExc(oidGlReverse);
                        } catch (Exception e) {
                            System.out.println("[Exception] while fetch GL");
                        }
                    }
                } else {
                    errDate = "Tanggal tidak sesuai dengan periode";
                    msgStyle = "errfont";
                }
            }

            Vector listGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID]+" = " + gl.getOID(), "");
            double totalDebet = getTotalDetail(listGlDetail, 0);
            double totalCredit = getTotalDetail(listGlDetail, 1);

            /*** LANG ***/
            String[] langGL = {"Posted Journal", "Reverse Posted Journal", "Journal Number", "Transaction Date", "Reference Number", "Memo", //0-5
                "Account - Description", "Jemaat", "Currency", "Booked Rate", "Debet", "Credit", "Description", "Code", "Amount", "Period"}; //7-15

            String[] langNav = {"Journal", "Reverse Posted Journal", "Date"};

            if (lang == LANG_ID) {
                String[] langID = {"Jurnal Terposting", "Jurnal Pembalikkan", "Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Memo",
                    "Perkiraan", "Jemaat", "Mata Uang", "Kurs Transaksi", "Debet", "Credit", "Keterangan", "Kode", "Jumlah", "Periode"
                };
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
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdBack(){
                document.frmglarchive.command.value="<%=JSPCommand.BACK%>";
                document.frmglarchive.prev_command.value="<%=prevJSPCommand%>";
                document.frmglarchive.action="glbaliklist.jsp";
                document.frmglarchive.submit();
            }
            
            function cmdSave(){
                var journalNumber = document.frmglarchive.<%=JspGl.colNames[JspGl.JSP_JOURNAL_NUMBER]%>.value;
                var refNumber = document.frmglarchive.<%=JspGl.colNames[JspGl.JSP_REF_NUMBER]%>.value;
                if(journalNumber == "" || refNumber == "") {
                    alert("Data belum lengkap.");
                } else {
                if(journalNumber == "<%=gl.getJournalNumber()%>") {
                    alert("Nomor jurnal masih sama.");
                }
                else {
                    document.frmglarchive.command.value="<%=JSPCommand.SAVE%>";
                    document.frmglarchive.action="glcopyedit.jsp";
                    document.frmglarchive.submit();
                }
            }
        }
        
        function reloadPeriod(oidGl) {
            document.frmglarchive.command.value="<%=JSPCommand.EDIT%>";
            document.frmglarchive.hidden_gl_id.value=oidGl;
            document.frmglarchive.action="glcopyedit.jsp";
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
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/back2.gif')">
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
                                            <!-- #BeginEditable "menu" -->
                                            <%@ include file="../main/menu.jsp"%>
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
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="gl_type" value="<%=glType%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">                                                                                                 
                                                                                                    <tr>                                                                                                         
                                                                                                        <td colspan="5" height="10"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><font face="arial"><%=langGL[2]%></font></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"><font face="arial">: <%=gl.getJournalNumber()%></font></td>
                                                                                                        <td width="12%"><font face="arial"><%=langGL[3]%></font></td>
                                                                                                        <td width="42%"><font face="arial">: <%=JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy")%></font></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><font face="arial"><%=langGL[4]%></font></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"><font face="arial">: <%=gl.getRefNumber()%></font></td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="42%">&nbsp; </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><font face="arial"><%=langGL[5]%></font></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td colspan="3"><font face="arial">: <%=gl.getMemo()%></font></td>
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
                                                                                            <td>&nbsp; </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="100%" class="page"> 
                                                                                                            <table id="list" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr height="22"> 
                                                                                                                                <td rowspan="2" class="tablearialhdr" nowrap width="20%"><%=langGL[6]%></td>                                                                                                                                
                                                                                                                                <td colspan="2" class="tablearialhdr" width="18%"><%=langGL[8]%></td>
                                                                                                                                <td rowspan="2" class="tablearialhdr" width="7%"><%=langGL[9]%></td>
                                                                                                                                <td rowspan="2" class="tablearialhdr" width="12%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                                <td rowspan="2" class="tablearialhdr" width="12%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                                                                                                <td rowspan="2" class="tablearialhdr" ><%=langGL[12]%></td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td  class="tablearialhdr"><%=langGL[13]%></td>
                                                                                                                                <td width="15%" class="tablearialhdr"><%=langGL[14]%></td>
                                                                                                                            </tr>
                                                                                                                            <%
            if (listGlDetail != null && listGlDetail.size() > 0) {
                for (int i = 0; i < listGlDetail.size(); i++) {
                    GlDetail crd = (GlDetail) listGlDetail.get(i);
                    Coa c = new Coa();

                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                    } catch (Exception e) {
                    }

                    Currency curr = new Currency();
                    try {
                        curr = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                    } catch (Exception e) {
                    }

                    String style = "";
                    if (i % 2 == 0) {
                        style = "tablearialcell";
                    } else {
                        style = "tablearialcell1";
                    }

                                                                                                                            %>
                                                                                                                            <tr height="22">
                                                                                                                                <td class="<%=style%>" nowrap><%=c.getCode() + " - " + c.getName()%></td>                                                                                                                                                                                                                                                               
                                                                                                                                <td class="<%=style%>" align="center"><%=curr.getCurrencyCode()%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"> 
                                                                                                                                    <div align="left"><%=crd.getMemo()%></div>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
                }
            }
                                                                                                                            %>
                                                                                                                            <tr height="22"> 
                                                                                                                                <td colspan="4" class="tablearialcell1" height="20"> 
                                                                                                                                    <div align="right"><b>TOTAL : </b></div>
                                                                                                                                </td>
                                                                                                                                <td class="tablearialcell1" height="20"> 
                                                                                                                                    <div align="right"><b><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b></div>
                                                                                                                                </td>
                                                                                                                                <td class="tablearialcell1" height="20"> 
                                                                                                                                    <div align="right"><b><%=JSPFormater.formatNumber(totalCredit, "#,###.##")%></b></div>
                                                                                                                                </td>
                                                                                                                                <td height="20" class="tablearialcell1">&nbsp;</td>
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
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <% if (!(iJSPCommand == JSPCommand.SAVE && oidGlReverse != 0)) {%>
                                                                            <tr> 
                                                                                <td colspan="4">&nbsp;</td> 
                                                                            </tr>    
                                                                            <tr> 
                                                                                <td colspan="4"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="700" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" > 
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="10"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5">&nbsp;</td>
                                                                                                                    <td colspan="4" class="fontarial"><b><%=langGL[1]%></b></td>
                                                                                                                </tr>
                                                                                                                <%
     String where = DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "' OR " +
             DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'";
     Vector vPeriod = DbPeriode.list(0, 0, where, DbPeriode.colNames[DbPeriode.COL_START_DATE]+" desc");

     Periode periodeSelected = new Periode();
     if (periodId != 0) {
         periodeSelected = DbPeriode.fetchExc(periodId);
     } else {
         periodeSelected = (Periode) vPeriod.get(0);
     }
     String strNumber = "";      
     String prefixGl = gl.getJournalPrefix();
     int counterGl = gl.getJournalCounter();
     
     if ((gl.getOID() != 0 || oidGl != 0) && isSave == false) {
         strNumber = gl.getJournalNumber() + "CP";         
     } else {
         strNumber = gl.getJournalNumber();
     }


                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td width="5">&nbsp;</td>
                                                                                                                    <td width="20%" class="fontarial"><%=langGL[2]%></td>
                                                                                                                    <td width="30%" class="fontarial">:
                                                                                                                        <%=strNumber%>
                                                                                                                        <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_NUMBER]%>" value="<%=strNumber%>">
                                                                                                                        <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_PREFIX]%>" value="<%=prefixGl%>">
                                                                                                                        <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_COUNTER]%>" value="<%=counterGl%>">
                                                                                                                        <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_TYPE]%>" value="<%=I_Project.JOURNAL_TYPE_REVERSE%>">
                                                                                                                    </td>
                                                                                                                    <td width="18%" class="fontarial"><%=langGL[15]%></td>
                                                                                                                    <td >:
                                                                                                                        <select name="<%=JspGl.colNames[JspGl.JSP_PERIOD_ID]%>" onChange="javascript:reloadPeriod('<%=oidGl%>')">
                                                                                                                            <%
     if (vPeriod != null && vPeriod.size() > 0) {
         for (int i = 0; i < vPeriod.size(); i++) {
             Periode p = (Periode) vPeriod.get(i);
             out.println("<option " + (p.getOID() == periodeSelected.getOID() ? "selected" : "") + " value=\"" + p.getOID() + "\">" + p.getName() + "</option>");
         }
     }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5">&nbsp;</td>
                                                                                                                    <td class="fontarial"><%=langGL[4]%></td>
                                                                                                                    <td >:
                                                                                                                        <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_REF_NUMBER]%>" value="<%=gl.getJournalNumber()%>"><%=gl.getJournalNumber()%>
                                                                                                                    </td>
                                                                                                                    <td class="fontarial"><%=langGL[3]%></td>
                                                                                                                    <td >:
                                                                                                                        <input type="text" name="<%=JspGl.colNames[JspGl.JSP_TRANS_DATE]%>" value="<%=JSPFormater.formatDate(transDate != null ? transDate : new Date(), "dd/MM/yyyy")%>" size="11">
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=JspGl.colNames[JspGl.JSP_TRANS_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                        <font class="<%=msgStyle%>"><%=errDate%></font>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td width="5">&nbsp;</td>
                                                                                                                    <td valign="top" class="fontarial"><%=langGL[5]%></td>                                                                                                                  
                                                                                                                    <td colspan="3" valign="top"> &nbsp;&nbsp;<textarea name="<%=JspGl.colNames[JspGl.JSP_MEMO]%>" cols="30" rows="2"><%=memo.equals("") ? gl.getMemo() : memo%></textarea></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="5"><font class="<%=msgStyle%>"><%=msgString%></font></td>
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
                                                                            <% }%>
                                                                            <tr id="command_line"> 
                                                                                <td colspan="4"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <!--DWLayoutTable-->
                                                                                        <tr> 
                                                                                            <td colspan="2" height="24"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="629"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <% if (oidGlReverse == 0) {%>
                                                                                                        <td width="17%">
                                                                                                            <%if (privAdd || privUpdate) {%>
                                                                                                            <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new13','','../images/save2.gif',1)"><img src="../images/save.gif" name="new13"  border="0"></a>
                                                                                                            <%}%>
                                                                                                        &nbsp;</td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <% }%>
                                                                                                        <td width="17%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new13','','../images/back2.gif',1)"><img src="../images/back.gif" name="new13"  border="0"></a></td>
                                                                                                        <td width="63%">&nbsp;</td>
                                                                                                        <% if (oidGlReverse != 0) {%><td width="17%">&nbsp;</td>
                                                                                                        <td width="3%">&nbsp;</td><% } %>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="178">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp;</td>
                                                                </tr>
                                                            </table>
                                                        </form>                                                        
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
                                <%@ include file="../main/footer.jsp"%>                                
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
