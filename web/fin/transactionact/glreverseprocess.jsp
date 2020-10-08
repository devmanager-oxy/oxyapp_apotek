
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

            Gl gl = new Gl();
            Gl reverseGl = new Gl();
            int counter = DbGl.getNextCounter();

            if (oidGl != 0) {
                try {
                    gl = DbGl.fetchExc(oidGl);
                } catch (Exception e) {
                }
            }

            String msgString = "";
            String msgStyle = "";
            long oidGlReverse = 0;
            if (iJSPCommand == JSPCommand.SAVE) {
                reverseGl.setJournalNumber(JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_JOURNAL_NUMBER]));
                reverseGl.setRefNumber(JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_REF_NUMBER]));
                if (JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_TRANS_DATE]).length() > 0) {
                    reverseGl.setTransDate(JSPFormater.formatDate(JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_TRANS_DATE]), "dd/MM/yyyy"));
                }

                oidGlReverse = DbGl.doReversePostedJournal(oidGl, reverseGl);
                if (oidGlReverse == 0) {
                    msgString = "Data tidak bisa tersimpan";
                    msgStyle = "errfont";
                } else {
                    msgString = "Data sudah tersimpan";
                    msgStyle = "info";
                    try {
                        gl = DbGl.fetchExc(oidGlReverse);
                    } catch (Exception e) {
                    }
                }
            }

            Vector listGlDetail = DbGlDetail.list(0, 0, "gl_id=" + gl.getOID(), "");
            double totalDebet = getTotalDetail(listGlDetail, 0);
            double totalCredit = getTotalDetail(listGlDetail, 1);

            /*** LANG ***/
            String[] langGL = {"Posted Journal", "Reverse Posted Journal", "Journal Number", "Transaction Date", "Reference Number", "Memo", //0-5
                "Account - Description", "Department", "Currency", "Booked Rate", "Debet", "Credit", "Description", "Code", "Amount"}; //7-14

            String[] langNav = {"Journal Reversal", "Reverse Posted Journal", "Date"};

            if (lang == LANG_ID) {
                String[] langID = {"Jurnal Terposting", "Jurnal Pembalikkan", "Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Memo",
                    "Perkiraan", "Departemen", "Mata Uang", "Kurs Transaksi", "Debet", "Credit", "Description", "Kode", "Jumlah"
                };
                langGL = langID;

                String[] navID = {"Jurnal Reversal", "Jurnal Pembalikkan", "Tanggal"};
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
                document.frmglarchive.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmglarchive.prev_command.value="<%=prevJSPCommand%>";
                document.frmglarchive.action="glreverse.jsp";
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
                    document.frmglarchive.action="glreverseprocess.jsp";
                    document.frmglarchive.submit();
                }
            }
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
                                                        <form name="frmglarchive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
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
                                                                                                        <td width="31%">&nbsp;</td>
                                                                                                        <td width="32%">&nbsp;</td>
                                                                                                        <td width="37%"> 
                                                                                                            <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(gl.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator : 
                                                                                                                <%
            User u = new User();
            try {
                u = DbUser.fetch(gl.getOperatorId());
            } catch (Exception e) {
            }
                                                                                                                %>
                                                                                                            <%=u.getLoginId()%>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="5">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <% if (oidGlReverse == 0) {%>
                                                                                                        <td colspan="5"><b><%=langGL[0]%></b></td>
                                                                                                        <% } else {%>
                                                                                                        <td colspan="5"><b><%=langGL[1]%></b></td>
                                                                                                        <% }%>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langGL[2]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"><%=gl.getJournalNumber()%></td>
                                                                                                        <td width="12%"><%=langGL[3]%></td>
                                                                                                        <td width="42%"><%=JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy")%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langGL[4]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"><%=gl.getRefNumber()%></td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="42%">&nbsp; </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langGL[5]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td colspan="3"><%=gl.getMemo()%></td>
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
                                                                                                                            <tr> 
                                                                                                                                <td rowspan="2"  class="tablehdr" nowrap width="25%"><%=langGL[6]%></td>
                                                                                                                                <td rowspan="2" class="tablehdr" width="5%">&nbsp;</td>
                                                                                                                                <td rowspan="2" class="tablehdr" width="24%"><%=langGL[7]%></td>
                                                                                                                                <td colspan="2" class="tablehdr"><%=langGL[8]%></td>
                                                                                                                                <td rowspan="2" class="tablehdr" width="5%"><%=langGL[9]%></td>
                                                                                                                                <td rowspan="2" class="tablehdr" width="8%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                                <td rowspan="2" class="tablehdr" width="8%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                                                                                                <td rowspan="2" class="tablehdr" width="13%"><%=langGL[12]%></td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="4%" class="tablehdr"><%=langGL[13]%></td>
                                                                                                                                <td width="8%" class="tablehdr"><%=langGL[14]%></td>
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

                                                                                                                            %>
                                                                                                                            <tr> 
                                                                                                                                <td class="tablecell" width="25%" nowrap><%=c.getCode() + " - " + c.getName()%></td>
                                                                                                                                <td width="5%" class="tablecell" align="center" nowrap> 
                                                                                                                                    <%
                                                                                                                                    if (c.getAccountClass() == DbCoa.ACCOUNT_CLASS_SP) {
                                                                                                                                        out.println("SP");
                                                                                                                                    } else {
                                                                                                                                        out.println("NSP");
                                                                                                                                    }
                                                                                                                                    %>
                                                                                                                                </td>
                                                                                                                                <td width="24%" class="tablecell" align="center" nowrap> 
                                                                                                                                    <div align="left"> 
                                                                                                                                        <%if (crd.getDepartmentId() == 0) {%> 0.0.0.0 - TOTAL CORPORATE 
                                                                                                                                        <%} else {
    long oidx = crd.getDepartmentId();

    if (crd.getSectionId() != 0) {
        oidx = crd.getSectionId();
    }

    if (crd.getSubSectionId() != 0) {
        oidx = crd.getSubSectionId();
    }

    if (crd.getJobId() != 0) {
        oidx = crd.getJobId();
    }

    Department d = new Department();

    try {
        d = DbDepartment.fetchExc(oidx);
    } catch (Exception e) {
    }
                                                                                                                                        %>
                                                                                                                                        <%=d.getCode() + " - " + d.getName()%> 
                                                                                                                                        <%}%>
                                                                                                                                    </div>
                                                                                                                                </td>
                                                                                                                                <td width="4%" class="tablecell" align="center"><%=curr.getCurrencyCode()%></td>
                                                                                                                                <td width="8%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%></td>
                                                                                                                                <td width="5%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%></td>
                                                                                                                                <td width="8%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></td>
                                                                                                                                <td width="8%" class="tablecell" align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></td>
                                                                                                                                <td width="13%" class="tablecell" align="right"> 
                                                                                                                                    <div align="left"><%=crd.getMemo()%></div>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
                }
            }
                                                                                                                            %>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="6" height="20"> 
                                                                                                                                    <div align="right"><b>TOTAL : </b></div>
                                                                                                                                </td>
                                                                                                                                <td width="8%" bgcolor="#CCCCCC" height="20"> 
                                                                                                                                    <div align="right"><b><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b></div>
                                                                                                                                </td>
                                                                                                                                <td width="8%" bgcolor="#CCCCCC" height="20"> 
                                                                                                                                    <div align="right"><b><%=JSPFormater.formatNumber(totalCredit, "#,###.##")%></b></div>
                                                                                                                                </td>
                                                                                                                                <td width="13%" bgcolor="#CCCCCC" height="20">&nbsp;</td>
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
                                                                                <td colspan="4"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr> 
                                                                                        <td colspan="4" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                <tr> 
                                                                                                    <td colspan="5">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td colspan="5"><b><%=langGL[1]%></b></td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td width="10%"><%=langGL[2]%></td>
                                                                                                    <td width="3%">&nbsp;</td>
                                                                                                    <td width="87%"><input type="text" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_NUMBER]%>" value="<%=DbGl.getNextNumber(counter)%>" size="20"></td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td width="10%"><%=langGL[4]%></td>
                                                                                                    <td width="3%">&nbsp;</td>
                                                                                                    <td width="87%"><input type="text" name="<%=JspGl.colNames[JspGl.JSP_REF_NUMBER]%>" value="<%=gl.getJournalNumber()%>" size="20"></td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td width="10%"><%=langGL[3]%></td>
                                                                                                    <td width="3%">&nbsp;</td>
                                                                                                    <td width="87%"><input type="text" name="<%=JspGl.colNames[JspGl.JSP_TRANS_DATE]%>" value="<%=JSPFormater.formatDate(reverseGl.getTransDate(), "dd/MM/yyyy")%>" size="11">
                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=JspGl.colNames[JspGl.JSP_TRANS_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
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
                                                                            <% }%>
                                                                            <tr id="command_line"> 
                                                                                <td colspan="4"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr> 
                                                                                            <td colspan="2" height="24"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="629"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <% if (oidGlReverse == 0) {%><td width="17%">
                                                                                                            <%if(privAdd || privUpdate){%>
                                                                                                            <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new13','','../images/save2.gif',1)"><img src="../images/save.gif" name="new13"  border="0"></a>
                                                                                                            <%}%>
                                                                                                            &nbsp;</td>
                                                                                                        <td width="3%">&nbsp;</td><% }%>
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
