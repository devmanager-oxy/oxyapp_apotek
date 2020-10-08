
<%-- 
    Document   : cashregister
    Created on : Sep 16, 2011, 3:04:57 PM
    Author     : Roy Andika
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../printing/printingvariables.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_REPORT_CASH_REGISTER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_REPORT_CASH_REGISTER, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_REPORT_CASH_REGISTER, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_REPORT_CASH_REGISTER, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_REPORT_CASH_REGISTER, AppMenu.PRIV_DELETE);
%>
<%!
public static String getAccountRecursif(int minus, Coa coa, long oid, boolean isPostableOnly) {

        int level = 0;

        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {

            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");

            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {

                    Coa coax = (Coa) coas.get(i);
                    String str = "";

                    if (!isPostableOnly) {

                        level = coax.getLevel() + minus;

                        switch (level) {
                            case 0:
                                break;
                            case 1:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 2:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 3:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 4:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 5:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                        }
                    }

                    result = result + "<option value=\"" + coax.getOID() + "\"" + ((oid == coax.getOID()) ? "selected" : "") + ">" + str + coax.getCode() + " - " + coax.getName() + "</option>";

                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccountRecursif(minus, coax, oid, isPostableOnly);
                    }
                }
            }
        }
        return result;
    }
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

<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);

            if (session.getValue("CASH_REGISTER") != null) {
                session.removeValue("CASH_REGISTER");
            }

            if (session.getValue("GL_REPORT_PDF") != null) {
                session.removeValue("GL_REPORT_PDF");
            }

            Vector accLinks = new Vector();
            Date findDt = new Date();
            long accLinkId = 0;

            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.PRINT){
                
                findDt = JSPFormater.formatDate(JSPRequestValue.requestString(request, "TRANSACTION_DATE"), "dd/MM/yyyy");
                accLinkId = JSPRequestValue.requestLong(request,"ACC_LINK_ID");                
                Periode p = DbPeriode.getOpenPeriod();
                
                String whereAccLink = DbCoa.colNames[DbCoa.COL_COA_ID] + " = " + accLinkId;
                
                accLinks = DbCoa.list(0, 0, whereAccLink, null);
                
            }
            
             // printing
            genDate = findDt;
            docChoice = 6;
            generalOID = accLinkId;
            // ====================

            Vector listReport = new Vector();
            SesReportBs sesReport = new SesReportBs();
            Vector vSesDep = new Vector();
            Vector listReportGL = new Vector();

            /*** LANG ***/
            String[] langFR = {"CASH REGISTER", "Acc. Group", //0-1
                "BKK/BKM number", "Check/GB Number", "Memo", "Debet", "Credit", "Balance", "Opening Balance", "Check Number/Gb", "Receive From/Pay to", "Summary (Rp)"}; //2-8
            String[] langNav = {"Cash Transaction", "Cash Register", "Date", "Data not found", "Please click search button to show report", "Account - Description"};

            if (lang == LANG_ID) {
                String[] langID = {"KAS REGISTER", "Kelompok Akun",
                    "No. BKK/BKM", "No Cek/GB", "Uraian", "Penerimaan", "Pengeluaran", "Saldo", "Saldo Awal", "No. Cek/Gb", "Diterima dari/bayar kepada", "Jumlah (Rp)"
                };
                langFR = langID;
                String[] navID = {"Transaksi Tunai", "Kas Register", "Tanggal", "Data tidak ditemukan", "Click tombol search untuk menampilkan report", "Perkiraan"};
                langNav = navID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
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
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';            
            hs.outlineType = 'rounded-white';
        </script>     
        <script type="text/javascript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdCetak(param){	
				document.form1.command.value="<%=JSPCommand.PRINT%>";
				document.form1.command_print.value=param;
				document.form1.action="cashregister.jsp";
				document.form1.submit();	
            }

            
            function cmdSearch(){                        
                document.form1.command.value="<%=JSPCommand.SEARCH%>";
                document.form1.action="cashregister.jsp";
                document.form1.submit();	
            }
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            //-->
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/print2.gif','../images/printxls2.gif')">
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
                                           <%@ include file="../calendar/calendarframe.jsp"%>
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
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td height="16">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td width = "100px"><%=langNav[2]%>&nbsp;</td>
                                                                                            <td >:</td>
                                                                                            <td width = "300px">
                                                                                                <input name="TRANSACTION_DATE" value="<%=JSPFormater.formatDate((findDt == null) ? new Date() : findDt, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.TRANSACTION_DATE);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>         
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            //String where = DbAccLink.colNames[DbAccLink.COL_TYPE] + " = '" + I_Project.ACC_LINK_GROUP_CASH + "'"; 
            //Vector listAcc = DbAccLink.list(0, 0, where, DbAccLink.colNames[DbAccLink.COL_COA_CODE]);
            Vector listAcc = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_CASH, sysLocation.getOID());

                                                                                        %>
                                                                                        
                                                                                        <tr>
                                                                                            <td ><%=langNav[5]%>&nbsp;</td>
                                                                                            <td >:</td>
                                                                                            <td >
                                                                                                <select name="ACC_LINK_ID">
                                                                                                <%
            if (listAcc != null && listAcc.size() > 0){
                
                for (int lc = 0; lc < listAcc.size(); lc++){
                    //AccLink accLink = (AccLink) listAcc.get(lc);                    
                    Coa coax = (Coa) listAcc.get(lc);

                    String str = "";                    
                    //if (!isPostableOnly) {
                    //str = getStrLevel(coax.getLevel());
                    //}
                                                                                                %>
                    <option value="<%=coax.getOID()%>" <%if (accLinkId == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                    
                    <%=getAccountRecursif(coax.getLevel() * -1, coax, accLinkId, isPostableOnly)%>
                                                                                                <%
                }                
            }
                                                                                                %>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>  
                                                                                    </table>        
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="4px"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11112','','../images/search2.gif',1)"><img src="../images/search.gif" name="new11112"  border="0" width="59" height="21"></a>
                                                                                </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand == JSPCommand.NONE){%>
                                                                            <tr> 
                                                                                <td height="10"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height="22" valign="middle" class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                        <tr> 
                                                                                            <td class="tablecell1" ><%=langNav[4]%></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%
            if (accLinks != null && accLinks.size() > 0){
                                                                            %>   
                                                                            <tr> 
                                                                                <td> 
                                                                                    <div align="center"><font size="4" face="Arial, Helvetica, sans-serif">LAPORAN HARIAN KAS</font></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <div align="center"><font size="4" face="Arial, Helvetica, sans-serif">Tanggal : <%=JSPFormater.formatDate(findDt, "dd/MM/yyyy")%></font></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <%
                                                                                for (int i = 0; i < accLinks.size(); i++){

                                                                                    //AccLink accLink = (AccLink) accLinks.get(i);
                                                                                    //Coa coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                    
                                                                                    Coa coa = (Coa)accLinks.get(i);

                                                                                    boolean isDebetPosition = false;

                                                                                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                                                                        isDebetPosition = true;
                                                                                    }
                                                                            %>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="18"> 
                                                                                            <td class="tablehdr2"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr2" align ="center">No Perkiraan : &nbsp;<%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

                                                                                Vector temp = DbGlDetail.getGeneralLedger(findDt, coa.getOID());

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="98%" height="20" cellpadding="1" cellspacing="1" align="center">
                                                                                                    <tr> 
                                                                                                        <td width="10%" rowspan="2" class="tablehdr" align="center"><b><%=langFR[2].toUpperCase()%></b></td>
                                                                                                        <td width="10%" rowspan="2" class="tablehdr" align="center"><b><%=langFR[3].toUpperCase()%></b></td>
                                                                                                        <td width="25%" rowspan="2" class="tablehdr" align="center"><b><%=langFR[10].toUpperCase()%></b></td>
                                                                                                        <td width="25%" rowspan="2" class="tablehdr" align="center"><b><%=langFR[4].toUpperCase()%></b></td>
                                                                                                        <td width="20%" colspan="2" class="tablehdr" align="center"><b><%=langFR[11].toUpperCase()%></b></td>
                                                                                                        <td width="10%" rowspan="2" class="tablehdr" align="center"><b><%=langFR[7].toUpperCase()%></b></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="10%" class="tablehdr" align="center"><b><%=langFR[5]%></b></td>
                                                                                                        <td width="10%" class="tablehdr" align="center"><b><%=langFR[6]%></b></td>
                                                                                                    </tr> 
                                                                                                    <%

                                                                                double openingBalance = 0;
                                                                                double totalCredit = 0;
                                                                                double totalDebet = 0;

                                                                                //jika bukan expense dan revenue
                                                                                if (!(coa.getAccountGroup().equals("Expense") || coa.getAccountGroup().equals("Other Expense") ||
                                                                                        coa.getAccountGroup().equals("Revenue") || coa.getAccountGroup().equals("Other Revenue"))) {
                                                                                    try{        
                                                                                        openingBalance = DbGlDetail.getGLOpeningBalance(findDt, coa);
                                                                                    }catch(Exception e){}

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell1" align="center">&nbsp;</td>
                                                                                                        <td class="tablecell1" align="center">&nbsp;</td>                                                                                                        
                                                                                                        <td class="tablecell1" align="center">&nbsp;</td>
                                                                                                        <td class="tablecell1" align="left">&nbsp;<%=langFR[8]%></td>
                                                                                                        <td class="tablecell1" align="right">-</td>
                                                                                                        <td class="tablecell1" align="right">-</td>
                                                                                                        <td class="tablecell1" align="right"><div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                }// end jika bukan revenue 	  

                                                                                if (temp != null && temp.size() > 0) {

                                                                                    for (int x = 0; x < temp.size(); x++) {

                                                                                        Vector gld = (Vector) temp.get(x);
                                                                                        Gl gl = (Gl) gld.get(0);
                                                                                        GlDetail gd = (GlDetail) gld.get(1);

                                                                                        try {
                                                                                            gd = DbGlDetail.fetchExc(gd.getOID());
                                                                                        } catch (Exception e) {
                                                                                        }

                                                                                        if (isDebetPosition) {
                                                                                            openingBalance = openingBalance + (gd.getDebet() - gd.getCredit());
                                                                                        } else {
                                                                                            openingBalance = openingBalance + (gd.getCredit() - gd.getDebet());
                                                                                        }

                                                                                        totalDebet = totalDebet + gd.getDebet();
                                                                                        totalCredit = totalCredit + gd.getCredit();
                                                                                        String name = "";

                                                                                        try {
                                                                                            name = SessReport.getPemberiOrPenerima(gd.getGlId());
                                                                                        } catch (Exception e) {
                                                                                        }
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell1" > 
                                                                                                            <div align="center"><%=gl.getJournalNumber()%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell1">&nbsp;</td>
                                                                                                        <td class="tablecell1" align="left" >&nbsp;<%=name%></td>
                                                                                                        <td class="tablecell1">&nbsp;<%=((gl.getMemo().length() > 0) ? gl.getMemo() + " : " : "") + gd.getMemo()%></td>
                                                                                                        <td class="tablecell1"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(gd.getDebet(), "#,###.##") %></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" > 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(gd.getCredit(), "#,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell1" > 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div>
                                                                                                        </td>
                                                                                                    </tr>   
                                                                                                    <%}
                                                                                }%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" height="15" ></td>
                                                                                                        <td class="tablecell" >&nbsp;</td>
                                                                                                        <td class="tablecell" >&nbsp;</td>
                                                                                                        <td class="tablecell" > 
                                                                                                            <div align="right"><b>Total 
                                                                                                            <%=baseCurrency.getCurrencyCode()%></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" > 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" > 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalCredit, "#,###.##") %></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablecell" > 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></b></div>
                                                                                                        </td>
                                                                                                    </tr>									
                                                                                                    <tr> 
                                                                                                        <td class="" height="20" colspan="7"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setDescription(coa.getCode() + " - " + coa.getName());
                                                                                sesReport.setStrAmount(coa.getAccountGroup());
                                                                                sesReport.setDepartment(vSesDep);
                                                                                listReport.add(sesReport);
                                                                            %>
                                                                            <%
                                                                                }%>
                                                                            <tr> 
                                                                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%
                                                                                out.print("<a href=\"../freport/cashregister_priview.jsp?transaction_date='" + JSPFormater.formatDate(findDt, "dd/MM/yyyy") + "'&acc_link_id="+accLinkId+"\"  onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
                                                                                    %>
                                                                                </td>
                                                                            </tr>
                                                                           
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td><%if (iJSPCommand == JSPCommand.SEARCH) {%>  
                                                                                    <B><%=langNav[3]%></B>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>                                                                
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                            </table>
                                                            <%
            session.putValue("GL_REPORT", listReport);
            session.putValue("GL_REPORT_PDF", listReportGL);							
                                                            %>
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

