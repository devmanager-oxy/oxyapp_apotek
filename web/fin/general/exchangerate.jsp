
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%

            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_DELETE);

%>
<!-- Jsp Block -->
<%
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidExchangeRate = JSPRequestValue.requestLong(request, "hidden_exchangerate_id");
            int historyType = JSPRequestValue.requestInt(request, "history_type");
            int historyRange = JSPRequestValue.requestInt(request, "history_range");
            String isReversal = JSPRequestValue.requestString(request, "chk_reversal");

            /*** LANG ***/
            String[] langMD = {"Date", "USD", "EUR", "PIC", //0-3
                "UPDATE BOOKEEPING RATE", "Date", "Currency Code", "IDR", "USD", "EUR", "Is automatic generate reversal journal?", //4-10
                "Data incomplete, please check again.", "Automatic generate reversal journal is failed.","YEN","ASD"};//11-14
            String[] langNav = {"Masterdata", "Bookkeeping Rate"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal", "USD", "EUR", "PIC",
                    "PERBAHARUI KURS PEMBUKUAN", "Tanggal", "Mata Uang", "IDR", "USD", "EUR", "Otomatis membuat jurnal reversal?",
                    "Data belum lengkap, silahkan dicek kembali.", "Gagal membuat jurnal reversal.","YEN","ASD"};
                langMD = langID;

                String[] navID = {"Data Induk", "Kurs Pembukuan"};
                langNav = navID;
            }

            int NUM_BACKUP_DAYS = 25;

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            JSPLine ctrLine = new JSPLine();

            Vector currencies = DbCurrency.list(0, 0, "", "");
            Vector vctHistory = new Vector();

            double valUsd = JSPRequestValue.requestDouble(request, "usd_curr");
            double valIdr = JSPRequestValue.requestDouble(request, "idr_curr");
            double valEuro = JSPRequestValue.requestDouble(request, "euro_curr");
            
            double valYen = JSPRequestValue.requestDouble(request, "yen_curr");
            double valAsd = JSPRequestValue.requestDouble(request, "asd_curr");

            ExchangeRate erx = new ExchangeRate();

            if (iCommand == JSPCommand.SAVE) {
                if (valUsd > 0 && valIdr > 0 && valEuro > 0) {

                    erx.setUserId(appSessUser.getUserOID());
                    erx.setDate(new Date());
                    erx.setValueUsd(valUsd);
                    erx.setValueIdr(valIdr);
                    erx.setValueEuro(valEuro);
                    erx.setValueYen(valYen);
                    erx.setValueAsd(valAsd);
                    erx.setStatus(0);
                    try {
                        //get standard rate before update
                        ExchangeRate stdRate = DbExchangeRate.getStandardRate();

                        //update standard rate
                        CONHandler.execUpdate("update exchangerate set status=1");
                        long oidERateNew = DbExchangeRate.insertExc(erx);

                        if (isReversal.equals("on")) {
                            //do auto reverse journal
                            boolean isAutoReverse = DbExchangeRate.generateAutoReverseGL(oidERateNew);

                            if (!isAutoReverse) {//if false
                                msgString = langMD[12];

                                //rollback new rate with delete
                                DbExchangeRate.deleteExc(oidERateNew);

                                //rollback standard rate
                                DbExchangeRate.updateExc(stdRate);
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("Exception while update exchangerate : " + e.toString());
                    }

                } else {
                    msgString = langMD[11];
                }
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdHistory(type){
                document.frmexchangerate.history_type.value=type;
                document.frmexchangerate.command.value="<%=JSPCommand.LIST%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            
            function cmdAdd(){
                document.frmexchangerate.hidden_exchangerate_id.value="0";
                document.frmexchangerate.command.value="<%=JSPCommand.ADD%>";
                document.frmexchangerate.prev_command.value="<%=prevCommand%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdAsk(oidExchangeRate){
                document.frmexchangerate.hidden_exchangerate_id.value=oidExchangeRate;
                document.frmexchangerate.command.value="<%=JSPCommand.ASK%>";
                document.frmexchangerate.prev_command.value="<%=prevCommand%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdConfirmDelete(oidExchangeRate){
                document.frmexchangerate.hidden_exchangerate_id.value=oidExchangeRate;
                document.frmexchangerate.command.value="<%=JSPCommand.DELETE%>";
                document.frmexchangerate.prev_command.value="<%=prevCommand%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            function cmdSave(){
                document.frmexchangerate.command.value="<%=JSPCommand.SAVE%>";
                document.frmexchangerate.prev_command.value="<%=prevCommand%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdEdit(oidExchangeRate){
                document.frmexchangerate.hidden_exchangerate_id.value=oidExchangeRate;
                document.frmexchangerate.command.value="<%=JSPCommand.EDIT%>";
                document.frmexchangerate.prev_command.value="<%=prevCommand%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdCancel(oidExchangeRate){
                document.frmexchangerate.hidden_exchangerate_id.value=oidExchangeRate;
                document.frmexchangerate.command.value="<%=JSPCommand.EDIT%>";
                document.frmexchangerate.prev_command.value="<%=prevCommand%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdBack(){
                document.frmexchangerate.command.value="<%=JSPCommand.BACK%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdListFirst(){
                document.frmexchangerate.command.value="<%=JSPCommand.FIRST%>";
                document.frmexchangerate.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdListPrev(){
                document.frmexchangerate.command.value="<%=JSPCommand.PREV%>";
                document.frmexchangerate.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdListNext(){
                document.frmexchangerate.command.value="<%=JSPCommand.NEXT%>";
                document.frmexchangerate.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
            }
            
            function cmdListLast(){
                document.frmexchangerate.command.value="<%=JSPCommand.LAST%>";
                document.frmexchangerate.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmexchangerate.action="exchangerate.jsp";
                document.frmexchangerate.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/save2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96">                                 
                                <%@ include file="../main/hmenu.jsp"%>                                
                            </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="<%="background:url("+approot+"/images/leftmenu-bg.gif) repeat-y"%>"> 
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
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmexchangerate" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_exchangerate_id" value="<%=oidExchangeRate%>">
                                                            <input type="hidden" name="history_type" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3" class="listtitle"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="middle" colspan="3"> 
                                                                                                <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="boxed1"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" class="listgen">
                                                                                                                <tr> 
                                                                                                                    <td width="251" height="19" class="tablehdr"><%=langMD[0]%></td>                                                                                                            
                                                                                                                    <td width="137" height="19" class="tablehdr"><%=langMD[1]%></td>
                                                                                                                    <td width="125" height="19" class="tablehdr"><%=langMD[2]%></td>
                                                                                                                    <td width="257" height="19" class="tablehdr"><%=langMD[13]%></td>
                                                                                                                    <td width="257" height="19" class="tablehdr"><%=langMD[14]%></td>
                                                                                                                    <td width="257" height="19" class="tablehdr"><%=langMD[3]%></td>
                                                                                                                </tr>
                                                                                                                <%
            vctHistory = DbExchangeRate.list(0, 0, "", "DATE");

            if (vctHistory != null && vctHistory.size() > 0) {
                for (int i = 0; i < vctHistory.size(); i++) {
                    ExchangeRate er = (ExchangeRate) vctHistory.get(i);

                    String css = "tablecell";
                    if (i % 2 != 0) {
                        css = "tablecell1";
                    }
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td width="251" class="<%=css%>"><%=JSPFormater.formatDate(er.getDate(), "dd MMMM yyyy")%> <%=JSPFormater.formatDate(er.getTime(), "HH:mm:ss")%></td>
                                                                                                                    <!--td width="80" class="tablecell"> 
                                  <div align="right"><%=JSPFormater.formatNumber(er.getValueUsd(), "#,###.##")%> 
                                </td-->
                                                                                                                    <td width="137" class="<%=css%>"> 
                                                                                                                        <div align="right"><%=JSPFormater.formatNumber(er.getValueUsd(), "#,###.##")%> </div>
                                                                                                                    </td>
                                                                                                                    <td width="125" class="<%=css%>"> 
                                                                                                                        <div align="right"><%=JSPFormater.formatNumber(er.getValueEuro(), "#,###.##")%> </div>
                                                                                                                    </td>
                                                                                                                    <td width="137" class="<%=css%>"> 
                                                                                                                        <div align="right"><%=JSPFormater.formatNumber(er.getValueYen(), "#,###.##")%> </div>
                                                                                                                    </td>
                                                                                                                    <td width="125" class="<%=css%>"> 
                                                                                                                        <div align="right"><%=JSPFormater.formatNumber(er.getValueAsd(), "#,###.##")%> </div>
                                                                                                                    </td>
                                                                                                                    <td width="257" height="19" class="<%=css%>"> 
                                                                                                                        <%try {
                                                                                                                            User au = DbUser.fetch(er.getUserId());
                                                                                                                        %>
                                                                                                                        <%=au.getLoginId()%> 
                                                                                                                        <%} catch (Exception e) {
                                                                                                                        }%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}
            }%>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="83%" class="comment">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="middle" colspan="3"><b><%=langMD[4]%></b></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="top" colspan="3"> 
                                                                                                <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="boxed1"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#EAEAEA">
                                                                                                                <tr> 
                                                                                                                    <td colspan="6" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="25%" height="19" align="center"><b><%=langMD[5]%></b></td>
                                                                                                                    <td width="14%" height="19" align="center"><b><%=langMD[6]%></b></td>
                                                                                                                    <td width="12%" height="19" align="center"><b><%=langMD[7]%></b></td>
                                                                                                                    <td width="12%" height="19" align="center"><b><%=langMD[8]%></b></td>
                                                                                                                    <td width="12%" height="19" align="center"><b><%=langMD[9]%></b></td>
                                                                                                                    <td width="12%" height="19" align="center"><b><%=langMD[13]%></b></td>
                                                                                                                    <td width="12%" height="19" align="center"><b><%=langMD[14]%></b></td>
                                                                                                                    <td width="25%" height="19" align="center"><b><%=langMD[10]%></b></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td nowrap><%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy HH:mm:ss")%></td>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                    <td><input type="text" name="idr_curr" size="10" maxlength="20" class="formElemen" value="1" readOnly style="text-align:right"></td>
                                                                                                                    <td><input type="text" name="usd_curr" size="10" maxlength="20" class="formElemen" value="<%=JSPHandler.userFormatStringDecimal(valUsd, 2)%>" style="text-align:right"></td>
                                                                                                                    <td><input type="text" name="euro_curr" size="10" maxlength="20" class="formElemen" value="<%=JSPHandler.userFormatStringDecimal(valEuro, 2)%>" style="text-align:right"></td>
                                                                                                                    <td><input type="text" name="yen_curr" size="10" maxlength="20" class="formElemen" value="<%=JSPHandler.userFormatStringDecimal(valYen, 2)%>" style="text-align:right"></td>
                                                                                                                    <td><input type="text" name="asd_curr" size="10" maxlength="20" class="formElemen" value="<%=JSPHandler.userFormatStringDecimal(valAsd, 2)%>" style="text-align:right"></td>
                                                                                                                    <td align="center"><input type="checkbox" name="chk_reversal"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="top" colspan="3"><font color="#FF0000"><%=msgString%></font></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="top" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="94%">
                                                                                                            <%if (privAdd || privUpdate) {%>
                                                                                                            <a href="javascript:cmdSave()" class="command"></a><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2" border="0"></a>
                                                                                                            <%} else {%>
                                                                                                            &nbsp;
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="top" width="17%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="83%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="top" width="17%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="83%">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top" > 
                                                                                            <td colspan="3" class="command">&nbsp; </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="13%">&nbsp;</td>
                                                                                            <td width="87%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td colspan="3"><div align="left"></div></td>
                                                                                        </tr>                                                                                
                                                                                    </table>
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
