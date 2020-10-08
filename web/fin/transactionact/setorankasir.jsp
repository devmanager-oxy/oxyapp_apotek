
<%-- 
    Document   : setorankasir
    Created on : Mar 6, 2015, 11:07:14 AM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %> 
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.interfaces.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_PRINT);
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
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, JspSetoranKasir.colNames[JspSetoranKasir.JSP_LOCATION_ID]);
            long oidSetoranKasir = JSPRequestValue.requestLong(request, "hidden_setoran_kasir_id");
            long oidSetoranKasirDetail = JSPRequestValue.requestLong(request, "hidden_setoran_kasir_detail_id");
            long oidSelisihSetoran = 0;
            try {
                oidSelisihSetoran = Long.parseLong(DbSystemProperty.getValueByName("OID_COA_SELISIH_KASIR"));
            } catch (Exception e) {
            }
            
            String interfaceDb = "NO";
            try {
                interfaceDb = DbSystemProperty.getValueByName("OID_COA_SELISIH_KASIR");
            } catch (Exception e) {
            }

            if (session.getValue("REPORT_SETORAN_KASIR") != null) {
                session.removeValue("REPORT_SETORAN_KASIR");
            }

            if (session.getValue("REPORT_SETORAN_KASIR_PARAMETER") != null) {
                session.removeValue("REPORT_SETORAN_KASIR_PARAMETER");
            }

            if (tanggal == null) {
                tanggal = new Date();
            }

            if (tanggalEnd == null) {
                tanggalEnd = new Date();
            }


            CmdSetoranKasir ctrlSetoranKasir = new CmdSetoranKasir(request);
            JSPLine ctrLine = new JSPLine();

            int iErrCodeMain = ctrlSetoranKasir.action(iJSPCommand, oidSetoranKasir);
            JspSetoranKasir jspSetoranKasir = ctrlSetoranKasir.getForm();
            SetoranKasir setoranKasir = ctrlSetoranKasir.getSetoranKasir();
            String msgStringMain = ctrlSetoranKasir.getMessage();

            Vector setoranKasirDetails = new Vector();
            if (iJSPCommand == JSPCommand.LOAD) {
                try {
                    setoranKasir = DbSetoranKasir.fetchExc(oidSetoranKasir);
                    locationId = setoranKasir.getLocationId();
                } catch (Exception e) {
                }
                setoranKasirDetails = DbSetoranKasirDetail.list(0, 0, DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_SETORAN_KASIR_ID] + " = " + oidSetoranKasir, DbSetoranKasirDetail.colNames[DbSetoranKasirDetail.COL_TANGGAL]);
                if (setoranKasirDetails != null && setoranKasirDetails.size() > 0) {
                    for (int r = 0; r < setoranKasirDetails.size(); r++) {
                        SetoranKasirDetail sdx = (SetoranKasirDetail) setoranKasirDetails.get(r);
                        if (r == 0) {
                            tanggal = sdx.getTanggal();
                        }
                        tanggalEnd = sdx.getTanggal();
                    }
                }
            }

            Vector result = new Vector();
            try {                
                if(interfaceDb.equals("YES")){
                    result = InterfaceSetoranKasir.reportSetoranGroupByDate(locationId, tanggal, tanggalEnd);
                }else{
                    result = SessReportSetoran.reportSetoranGroupByDate(locationId, tanggal, tanggalEnd);
                }
            } catch (Exception e) {
            }
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_CASH_SALES + "'", "");

            if (iJSPCommand == JSPCommand.SAVE && setoranKasir.getOID() != 0) {

                if (setoranKasir.getOID() != 0) {
                    DbSetoranKasirDetail.getDelete(setoranKasir.getOID());
                }

                if (result != null && result.size() > 0) {

                    for (int i = 0; i < result.size(); i++) {

                        Vector tmp = (Vector) result.get(i);
                        double cash = 0;
                        double card = 0;
                        double cashBack = 0;

                        try {
                            card = Double.parseDouble(String.valueOf(tmp.get(2)));
                        } catch (Exception e) {
                        }

                        try {
                            cashBack = Double.parseDouble(String.valueOf(tmp.get(3)));
                        } catch (Exception e) {
                        }

                        Date tgl = JSPFormater.formatDate(String.valueOf("" + tmp.get(0)), "dd/MM/yyyy");
                        String valname = JSPFormater.formatDate(tgl, "ddMMyyyy");
                        double setoran = JSPRequestValue.requestDouble(request, "setoran" + valname);
                        double system = JSPRequestValue.requestDouble(request, "sys" + valname);
                        cash = JSPRequestValue.requestDouble(request, "cash" + valname);

                        SetoranKasirDetail skd = new SetoranKasirDetail();
                        skd.setSetoranKasirId(setoranKasir.getOID());
                        skd.setTanggal(tgl);
                        skd.setCash(cash);
                        skd.setCard(card);
                        skd.setCashBack(cashBack);
                        skd.setSetoranToko(setoran);
                        skd.setSystem(system);
                        skd.setCoaId(oidSelisihSetoran);
                        try {
                            DbSetoranKasirDetail.insertExc(skd);
                        } catch (Exception e) {
                        }
                    }
                }
            }

            Vector vpar = new Vector();
            vpar.add("" + locationId);
            vpar.add("" + JSPFormater.formatDate(tanggal, "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(tanggalEnd, "dd/MM/yyyy"));
            vpar.add("" + user.getFullName());

            Vector report = new Vector();

            String[] langCT = {"Journal Number", "Period", "Akun", "Date Transaction", "Description"};

            String[] langNav = {"Cash Transaction", "Setoran Kasir"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Periode", "Akun Perkiraan", "Tanggal Transaksi", "Catatan"};
                langCT = langID;

                String[] navID = {"Transaksi Kas", "Setoran Kasir"};
                langNav = navID;
            }
%>
<html>
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
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
            
            function cmdPrintXls(){	                       
                window.open("<%=printrootinv%>.report.ReportSetoranXLS?user_id=<%=appSessUser.getUserOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.setorankasir.command.value="<%=JSPCommand.SEARCH%>";
                    document.setorankasir.action="setorankasir.jsp?menu_idx=<%=menuIdx%>";
                    document.setorankasir.submit();
                }
                
                function cmdSubmitCommand(){
                    document.all.closecmd.style.display="none";
                    document.all.closemsg.style.display="";
                    document.setorankasir.command.value="<%=JSPCommand.SAVE%>";
                    document.setorankasir.action="setorankasir.jsp?menu_idx=<%=menuIdx%>";
                    document.setorankasir.submit();
                }
                
                
                var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
                var usrDigitGroup = "<%=sUserDigitGroup%>";
                var usrDecSymbol = "<%=sUserDecimalSymbol%>";
                
                function removeChar(number){
                    var ix;
                    var result = "";
                    for(ix=0; ix<number.length; ix++){
                        var xx = number.charAt(ix);                        
                        if(!isNaN(xx)){
                            result = result + xx;
                        }else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }                    
                return result;
            }
            
            function setCalc(val){        
                 <%
            for (int k = 0; k < result.size(); k++) {

                Vector tmp = (Vector) result.get(k);
                double cash = 0;
                double card = 0;
                double cashBack = 0;
                Date tgl = JSPFormater.formatDate(String.valueOf("" + tmp.get(0)), "dd/MM/yyyy");
                try {
                    card = Double.parseDouble(String.valueOf(tmp.get(2)));
                } catch (Exception e) {
                }

                try {
                    cashBack = Double.parseDouble(String.valueOf(tmp.get(3)));
                } catch (Exception e) {
                }

                String valname = JSPFormater.formatDate(tgl, "ddMMyyyy");

                 %>
                     if(val == '<%=valname%>'){
                         
                         var cash = document.setorankasir.cash<%=valname%>.value;                         
                         cash = removeChar(cash);
                         cash = cleanNumberFloat(cash, sysDecSymbol, usrDigitGroup, usrDecSymbol);                     
                         document.setorankasir.cash<%=valname%>.value=formatFloat(cash, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         
                         var card_cash_back = document.setorankasir.card_cash_back<%=valname%>.value;                         
                         card_cash_back = removeChar(card_cash_back);
                         card_cash_back = cleanNumberFloat(card_cash_back, sysDecSymbol, usrDigitGroup, usrDecSymbol);                     
                         document.setorankasir.card_cash_back<%=valname%>.value=formatFloat(card_cash_back, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         
                         var setoran = parseFloat(cash) + parseFloat(card_cash_back);                           
                         document.setorankasir.setoran<%=valname%>.value=formatFloat(setoran, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         var temp_setoran = document.setorankasir.setoran<%=valname%>.value;                         
                         temp_setoran = removeChar(temp_setoran);
                         temp_setoran = cleanNumberFloat(temp_setoran, sysDecSymbol, usrDigitGroup, usrDecSymbol);    
                         
                         
                         var sys = document.setorankasir.sys<%=valname%>.value;                         
                         sys = removeChar(sys);
                         sys = cleanNumberFloat(sys, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                              
                         var selisih = parseFloat(temp_setoran) - parseFloat(sys);                                                  
                         document.setorankasir.selisih<%=valname%>.value=formatFloat(selisih, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                         
                     }
                     <%}%>
                 }
                 
                 //-------------- script form image -------------------
                 
                 function cmdDelPict(oidBankpopaymentDetail){
                     document.frmimage.hidden_bankpopayment_detail_id.value=oidBankpopaymentDetail;
                     document.frmimage.command.value="<%=JSPCommand.POST%>";
                     document.frmimage.action="bankpayment.jsp";
                     document.frmimage.submit();
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
                 //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
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
                                                        <form name="setorankasir" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="hidden_setoran_kasir_detail_id" value="<%=oidSetoranKasirDetail%>">
                                                            <input type="hidden" name="hidden_setoran_kasir_id" value="<%=oidSetoranKasir%>">
                                                            <input type="hidden" name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <%try {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="4" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td colspan="4" height="10">
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="60" height="14" nowrap></td>
                                                                                            <td width="2" height="14" nowrap></td>
                                                                                            <td colspan="2" height="14"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" class="fontarial"><b><i>Parameter pencarian :</i></b></td>
                                                                                        </tr>
                                                                                        <tr height="23"> 
                                                                                            <td class="tablecell1" nowrap>&nbsp;&nbsp;Date</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td colspan="2" > 
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.setorankasir.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                        </td>
                                                                                                        <td>&nbsp;&nbsp;to&nbsp;&nbsp;</td>
                                                                                                        <td>
                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.setorankasir.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="23">
                                                                                            <td class="tablecell1">&nbsp;&nbsp;Location</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td colspan="2">
                                                                                                <%
    Vector vLoc = userLocations;
                                                                                                %>          
                                                                                                <select name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_LOCATION_ID] %>" class="fontarial" onChange="javascript:cmdchange()">                                                                                                                                                           
                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
        for (int i = 0; i < vLoc.size(); i++) {
            Location us = (Location) vLoc.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                    <%}
    }%>
                                                                                                </select>           
                                                                                            </td>
                                                                                        </tr>   
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="1" valign="middle" colspan="4" > 
                                                                                                <table width="500" border="0" cellspacing="0" cellpadding="0">                                                                                                                
                                                                                                    <tr> 
                                                                                                        <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%if(setoranKasir.getPostedStatus()==0){%>
                                                                                        <tr>
                                                                                            <td colspan="4"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>                                                                  </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="25">&nbsp;</td>    
                                                                            </tr>
                                                                            <%
    if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.LOAD) {
        if ((result != null && result.size() > 0) || iJSPCommand == JSPCommand.LOAD) {
                                                                            %>
                                                                            <tr> 
                                                                                <td colspan="4" height="25">
                                                                                    <table border="0" cellspacing="1" cellpadding="0" width="1000"> 
                                                                                        <tr height="23">
                                                                                            <td width="100" class="tablearialcell1">&nbsp;&nbsp;<%=langCT[0]%></td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td width="350" class="fontarial"> 
                                                                                                <%
                                                                                    Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
                                                                                    String strNumber = "";
                                                                                    Periode open = new Periode();
                                                                                    if (setoranKasir.getPeriodeId() != 0) {
                                                                                        try {
                                                                                            open = DbPeriode.fetchExc(setoranKasir.getPeriodeId());
                                                                                        } catch (Exception e) {
                                                                                        }
                                                                                    } else {
                                                                                        if (periods != null && periods.size() > 0) {
                                                                                            open = (Periode) periods.get(0);
                                                                                        }
                                                                                    }

                                                                                    int counterJournal = DbSystemDocNumber.getNextCounter(open.getOID(), DbSystemDocCode.TYPE_DOCUMENT_SETORAN_KASIR);
                                                                                    strNumber = DbSystemDocNumber.getNextNumber(counterJournal, open.getOID(), DbSystemDocCode.TYPE_DOCUMENT_SETORAN_KASIR);
                                                                                    if (setoranKasir.getOID() != 0 || oidSetoranKasir != 0) {
                                                                                        strNumber = setoranKasir.getJournalNumber();
                                                                                    }

                                                                                                %>
                                                                                                <%=strNumber%> 
                                                                                                <input type="hidden" name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_JOURNAL_NUMBER]%>">
                                                                                                <input type="hidden" name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_JOURNAL_COUNTER]%>">
                                                                                                <input type="hidden" name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_JOURNAL_PREFIX]%>">
                                                                                            </td>
                                                                                            <td width="120" class="tablearialcell1"> 
                                                                                                <%if (periods.size() > 1) {%>
                                                                                                <div align="left">&nbsp;&nbsp;<%=langCT[1]%></div>
                                                                                                <%} else {%>
                                                                                                &nbsp;
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td class="fontarial"> 
                                                                                                <%if (open.getStatus().equals("Closed") || setoranKasir.getOID() != 0) {%>
                                                                                                <%=open.getName()%>
                                                                                                <input type="hidden" name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                                                <%} else {%>
                                                                                                <%if (periods.size() > 1) {%>
                                                                                                <select name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_PERIODE_ID]%>">
                                                                                                    <%
    if (periods != null && periods.size() > 0) {

        for (int t = 0; t < periods.size(); t++) {

            Periode objPeriod = (Periode) periods.get(t);

                                                                                                    %>
                                                                                                    <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == setoranKasir.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                    <%}%>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                                <%} else {%>
                                                                                                <input type="hidden" name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                                                <%}
                                                                                    }%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="23">                                                                                            
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;<%=langCT[2]%></td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_COA_ID]%>" class="fontarial">
                                                                                                    <%if (accLinks != null && accLinks.size() > 0) {
                                                                                        for (int i = 0; i < accLinks.size(); i++) {

                                                                                            AccLink accLink = (AccLink) accLinks.get(i);
                                                                                            Coa coa = new Coa();
                                                                                            try {
                                                                                                coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                            } catch (Exception e) {
                                                                                                System.out.println("Exception " + e.toString());
                                                                                            }
                                                                                                    %>
                                                                                                    <option <%if (setoranKasir.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                    <%=getAccountRecursif(coa.getLevel() * -1, coa, setoranKasir.getCoaId(), isPostableOnly)%> 
                                                                                                    <%}
} else {%>
                                                                                                    <option>select ..</option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            <%= jspSetoranKasir.getErrorMsg(JspSetoranKasir.JSP_COA_ID) %></td>
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;<%=langCT[3]%></td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td >
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <input name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_TRANSACTION_DATE] %>" value="<%=JSPFormater.formatDate((setoranKasir.getTransDate() == null) ? new Date() : setoranKasir.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.setorankasir.<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_TRANSACTION_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        </td>
                                                                                                        <td valign="top">&nbsp;<%=jspSetoranKasir.getErrorMsg(jspSetoranKasir.JSP_TRANSACTION_DATE) %></td>
                                                                                                    </tr>
                                                                                                </table>       
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                    Vector segment1 = DbSegment.list(0, 1, DbSegment.colNames[DbSegment.COL_COUNT] + " = 1", null);
                                                                                    Vector segments = new Vector();
                                                                                    if (segment1 != null && segment1.size() > 0) {
                                                                                        Segment s = (Segment) segment1.get(0);
                                                                                        try {
                                                                                            segments = DbSegmentDetail.list(0, 0, DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + s.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);
                                                                                        } catch (Exception e) {
                                                                                        }
                                                                                    }
                                                                                        %>
                                                                                        
                                                                                        <tr>                                                                                            
                                                                                            <td class="tablearialcell1" >&nbsp;&nbsp;<%=langCT[4]%></td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td ><textarea name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_MEMO]%>" cols="40" rows="2"><%=setoranKasir.getMemo()%></textarea>
                                                                                            <%= jspSetoranKasir.getErrorMsg(jspSetoranKasir.JSP_MEMO) %></td>
                                                                                            <td class="tablearialcell1" >&nbsp;&nbsp;Segment</td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td >
                                                                                                <select name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_SEGMENT1_ID]%>" >
                                                                                                    <%if (segments != null && segments.size() > 0) {
                                                                                        for (int t = 0; t < segments.size(); t++) {
                                                                                            SegmentDetail sd = (SegmentDetail) segments.get(t);
                                                                                                    %>
                                                                                                    <option value="<%=sd.getOID()%>" <%if (sd.getOID() == setoranKasir.getSegment1Id()) {%> selected<%}%>  ><%=sd.getName()%></option>
                                                                                                    <%}
                                                                                    }%>    
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>    
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="10"></td>
                                                                            </tr>    
                                                                            <%}
    }%>
                                                                            <tr> 
                                                                                <td colspan="4" height="10">
                                                                                    <table border="0" cellspacing="1" cellpadding="0">                                                                                                                                        
                                                                                        <tr height="26">                                                                                                 
                                                                                            <td width="100" class="tablearialhdr">TANGGAL</td>
                                                                                            <td width="150" class="tablearialhdr">CASH</td>
                                                                                            <td width="150" class="tablearialhdr">CARD</td>
                                                                                            <td width="150" class="tablearialhdr">CASH BACK</td>
                                                                                            <td width="150" class="tablearialhdr">SETORAN TOKO</td>
                                                                                            <td width="150" class="tablearialhdr">SYSTEM</td>
                                                                                            <td width="150" class="tablearialhdr">SELISIH</td>                                                                                                                                                        
                                                                                        </tr>    
                                                                                        <%
    if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.SAVE) {
        if (result != null && result.size() > 0) {
            String style = "";
            int nomor = 1;
            for (int i = 0; i < result.size(); i++) {

                Vector tmp = (Vector) result.get(i);
                double card = 0;
                double cashBack = 0;
                double system = 0;
                double cash = 0;
                
                if (nomor % 2 == 0) {
                    style = "tablearialcell";
                } else {
                    style = "tablearialcell1";
                }

                Date tgl = JSPFormater.formatDate(String.valueOf("" + tmp.get(0)), "dd/MM/yyyy");
                try {
                    card = Double.parseDouble(String.valueOf(tmp.get(2)));
                } catch (Exception e) {
                }

                try {
                    cashBack = Double.parseDouble(String.valueOf(tmp.get(3)));
                } catch (Exception e) {
                }                
                
                try {
                    system = Double.parseDouble(String.valueOf(tmp.get(4)));
                } catch (Exception e) {
                }                

                String valname = JSPFormater.formatDate(tgl, "ddMMyyyy");
                cash = JSPRequestValue.requestDouble(request, "cash" + valname);
                double inputCash = JSPRequestValue.requestDouble(request, "cash" + valname);
                double setoran = JSPRequestValue.requestDouble(request, "setoran" + valname);                

                setoran = cash + card + cashBack;
                double selisih = setoran - system;
                double ccashback = card + cashBack;

                Vector tmpReport = new Vector();
                tmpReport.add(JSPFormater.formatDate(tgl, "dd/MM/yyyy"));
                tmpReport.add("" + inputCash);
                tmpReport.add("" + card);
                tmpReport.add("" + cashBack);
                tmpReport.add("" + setoran);
                tmpReport.add("" + system);
                tmpReport.add("" + (setoran - system));
                report.add(tmpReport);

                                                                                        %>
                                                                                        <input type="hidden" name="card_cash_back<%=valname%>"  value="<%=JSPFormater.formatNumber(ccashback, "###,###.##")%>">                                                                                        
                                                                                        <input type="hidden" name="sys<%=valname%>"  value="<%=JSPFormater.formatNumber(system, "###,###.##")%>">
                                                                                        <tr height="23">                                                                                                                                                        
                                                                                            <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(tgl, "dd-MMM")%></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><input type="text" name="cash<%=valname%>"  value="<%=JSPFormater.formatNumber(inputCash, "###,###.##")%>" onChange="javascript:setCalc('<%=valname%>')"  size="15" style="text-align:right"></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(card, "###,###.##") %></td>                                                                                                                                                        
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(cashBack, "###,###.##") %></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><input type="text" name="setoran<%=valname%>"  value="<%=JSPFormater.formatNumber(setoran, "###,###.##")%>" onChange="javascript:setCalc('<%=valname%>')"  size="15" style="text-align:right" class="readOnly" readonly></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(system, "###,###.##") %></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><input type="text" name="selisih<%=valname%>" value="<%=JSPFormater.formatNumber(selisih, "###,###.##")%>" size="15" style="text-align:right" class="readOnly" readonly></td>
                                                                                        </tr> 
                                                                                        <%nomor++;
                                                                                                }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="7"></td>     
                                                                                        </tr> 
                                                                                        <%if (iJSPCommand == JSPCommand.SAVE) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="7"> 
                                                                                                <%if (iErrCodeMain != 0) {%>
                                                                                                <table border="0" cellpadding="0" cellspacing="0" class="warning" width="293" align="left">
                                                                                                    <tr height="25"> 
                                                                                                        <td width="20"><img src="../images/error.gif" width="18" height="18"></td>
                                                                                                        <td width="253" nowrap><%=msgStringMain%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%} else {%>
                                                                                                <table border="0" cellpadding="0" cellspacing="0" align="left" class="success">
                                                                                                    <tr height="25">
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" ></td>
                                                                                                        <td width="150" class="fontarial"><%=msgStringMain%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%}%>
                                                                                            </td>     
                                                                                        </tr> 
                                                                                        <%}%>
                                                                                        <%

                                                                                                session.putValue("REPORT_SETORAN_KASIR", report);
                                                                                                session.putValue("REPORT_SETORAN_KASIR_PARAMETER", vpar);
                                                                                        %>
                                                                                        <%if(setoranKasir.getPostedStatus()==1){%>
                                                                                        <tr>
                                                                                            <td colspan="7">
                                                                                                <table  cellpadding="0" cellspacing="5" align="right" class="success">
                                                                                                    <tr>
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" ></td>
                                                                                                        <td width="50" class="fontarial"><b>Posted</b></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>    
                                                                                        </tr>    
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="7"> 
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <%if (iJSPCommand == JSPCommand.SEARCH || (iJSPCommand != JSPCommand.SAVE || (iJSPCommand == JSPCommand.SAVE && iErrCodeMain != 0))) {%>
                                                                                                        <td >
                                                                                                            <table width="100" border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr id="closecmd">
                                                                                                                    <td height="15" colspan="4">                                                                                                                                                
                                                                                                                        <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr id="closemsg" align="left" valign="top"> 
                                                                                                                    <td height="22" valign="middle" colspan="10"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td> <font color="#006600">Posting setoran kasir in progress, please wait .... </font> </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="1">&nbsp; </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td> <img src="../images/progress_bar.gif" border="0"> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>    
                                                                                                        </td>
                                                                                                        <%}%> 
                                                                                                        <%if (setoranKasir.getOID() != 0) {%>
                                                                                                        <td>&nbsp;</td>
                                                                                                        <td><a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a></td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>     
                                                                                        </tr>  
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="35" valign="middle" colspan="7"></td>     
                                                                                        </tr> 
                                                                                        <%
                                                                                            }




                                                                                        } else {%>
                                                                                        <%if (iJSPCommand != JSPCommand.LOAD) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="7" class="tablearialcell"> 
                                                                                                <i>Klik tombol search untuk melakukan pencarian</i>
                                                                                            </td>     
                                                                                        </tr>
                                                                                        <%}%> 
                                                                                        <%}%> 
                                                                                        <%if (iJSPCommand == JSPCommand.LOAD) {
        int nomor = 1;
        if (setoranKasirDetails != null && setoranKasirDetails.size() > 0) {
            String style = "";
            for (int i = 0; i < setoranKasirDetails.size(); i++) {
                SetoranKasirDetail skd = (SetoranKasirDetail) setoranKasirDetails.get(i);
                String valname = JSPFormater.formatDate(skd.getTanggal(), "ddMMyyyy");
                double system = skd.getSystem();
                double selisih = skd.getSetoranToko() - system;
                if (nomor % 2 == 0) {
                    style = "tablearialcell";
                } else {
                    style = "tablearialcell1";
                }

                Vector tmpReport = new Vector();
                tmpReport.add(JSPFormater.formatDate(skd.getTanggal(), "dd/MM/yyyy"));
                tmpReport.add("" + skd.getCash());
                tmpReport.add("" + skd.getCard());
                tmpReport.add("" + skd.getCashBack());
                tmpReport.add("" + skd.getSetoranToko());
                tmpReport.add("" + system);
                tmpReport.add("" + (selisih));
                report.add(tmpReport);
                                                                                        %>
                                                                                        <tr height="23">                                                                                                                                                        
                                                                                            <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(skd.getTanggal(), "dd-MMM")%></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><input type="text" name="cash<%=valname%>"  value="<%=JSPFormater.formatNumber(skd.getCash(), "###,###.##")%>" onChange="javascript:setCalc('<%=valname%>')"  size="15" style="text-align:right"></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(skd.getCard(), "###,###.##") %></td>                                                                                                                                                        
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(skd.getCashBack(), "###,###.##") %></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><input type="text" name="setoran<%=valname%>"  value="<%=JSPFormater.formatNumber(skd.getSetoranToko(), "###,###.##")%>" onChange="javascript:setCalc('<%=valname%>')"  size="15" style="text-align:right" class="readOnly" readonly></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(system, "###,###.##") %></td>
                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><input type="text" name="selisih<%=valname%>" value="<%=JSPFormater.formatNumber(selisih, "###,###.##")%>" size="15" style="text-align:right" class="readOnly" readonly></td>
                                                                                        </tr> 
                                                                                        <%
            nomor++;
        }
        session.putValue("REPORT_SETORAN_KASIR", report);
        session.putValue("REPORT_SETORAN_KASIR_PARAMETER", vpar);
    }%>
                                                                                        <tr>
                                                                                            <td colspan="7">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if(setoranKasir.getPostedStatus()==1){%>
                                                                                        <tr>
                                                                                            <td colspan="7">
                                                                                                <table  cellpadding="0" cellspacing="5" align="left" class="success">
                                                                                                    <tr>
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" ></td>
                                                                                                        <td width="50" class="fontarial"><b>Posted</b></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>    
                                                                                        </tr>  
                                                                                        <tr>
                                                                                            <td colspan="7">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td colspan="7"><a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td height="35" colspan="7">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>    
                                                                            </tr>    
                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                            </table>
                                                            <%} catch (Exception e) {
            }%>
                                                            <script language="JavaScript">
                                                                document.all.closecmd.style.display="";
                                                                document.all.closemsg.style.display="none";
                                                            </script>  
                                                        </form>
                                                        
                                                    <!-- #EndEditable --> </td>
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
    <!-- #EndTemplate --> 
</html>
