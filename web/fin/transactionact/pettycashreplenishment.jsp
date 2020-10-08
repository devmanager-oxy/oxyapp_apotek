
<%
            /*******************************************************************
             *  eka
             *******************************************************************/
%>

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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPR, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String getDefaultMemo(Vector openPaymants) {
        String result = "";
        if (openPaymants != null && openPaymants.size() > 0) {
            if (openPaymants.size() == 1) {
                PettycashPayment pp = (PettycashPayment) openPaymants.get(0);
                result = "Replenishment for payment number " + pp.getJournalNumber() + ", transaction date " + JSPFormater.formatDate(pp.getTransDate(), "dd-MM-yyyy");
            } else {
                PettycashPayment pp = (PettycashPayment) openPaymants.get(0);
                PettycashPayment pp1 = (PettycashPayment) openPaymants.get(openPaymants.size() - 1);
                result = "Replenishment for payment number " + pp.getJournalNumber() + " to " + pp1.getJournalNumber() + ", transaction date " + JSPFormater.formatDate(pp.getTransDate(), "dd-MM-yyyy") + " to " + JSPFormater.formatDate(pp1.getTransDate(), "dd-MM-yyyy");
            }
        }
        return result;
    }

    public static String getAccountRecursif(int minus, Coa coa, long oid, boolean isPostableOnly) {

        System.out.println("in recursif : " + coa.getOID());
		
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
						
						//str = "minus : "+minus+", "+coax.getLevel()+" level = "+level;
					
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
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidPettycashReplenishment = JSPRequestValue.requestLong(request, "hidden_pettycash_replenishment_id");
            long oidReplaceCoa = JSPRequestValue.requestLong(request, JspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_COA_ID]);

            if (iJSPCommand == JSPCommand.LOAD) {
                try {
                    oidPettycashReplenishment = JSPRequestValue.requestLong(request, "cash_id");
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdPettycashReplenishment ctrlPettycashReplenishment = new CmdPettycashReplenishment(request);
            JSPLine ctrLine = new JSPLine();
            Vector listPettycashReplenishment = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlPettycashReplenishment.action(iJSPCommand, oidPettycashReplenishment);

            /* end switch*/
            JspPettycashReplenishment jspPettycashReplenishment = ctrlPettycashReplenishment.getForm();

            /*count list All PettycashReplenishment*/
            int vectSize = DbPettycashReplenishment.getCount(whereClause);

            PettycashReplenishment pettycashReplenishment = ctrlPettycashReplenishment.getPettycashReplenishment();

            if (iJSPCommand == JSPCommand.LOAD) {
                try {
                    pettycashReplenishment = DbPettycashReplenishment.fetchExc(oidPettycashReplenishment);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }

            msgString = ctrlPettycashReplenishment.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlPettycashReplenishment.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Vector bankAccounts = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT + "'", "");
			
			

            Vector bankBalance = DbAccLink.getBankAccountBalance(bankAccounts);
			
			//out.println("bankBalance : "+bankBalance);

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_PETTY_CASH_CREDIT + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");

            if (oidReplaceCoa == 0) {
                if (accLinks != null && accLinks.size() > 0) {
                    AccLink al = (AccLink) accLinks.get(0);
                    oidReplaceCoa = al.getCoaId();
                }
            }

            Vector v = DbPettycashReplenishment.list(0, 0, "status='" + I_Project.STATUS_NOT_POSTED + "'", "");

            PettycashReplenishment prt = new PettycashReplenishment();

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.SUBMIT) {
                prt = DbPettycashReplenishment.getOpenReplenishment(oidReplaceCoa);
            } else {
                prt = pettycashReplenishment;
            }

            if (v != null && v.size() > 0) {
                prt = (PettycashReplenishment) v.get(0);
            }

            //Vector openPaymants = DbPettycashPayment.getOpenPayment(oidReplaceCoa);
			String wherex = "coa_id="+oidReplaceCoa+" and replace_status=0";
			//Vector openPaymants = DbPettycashPayment.list(0,0, wherex, "");//DbPettycashPayment.getOpenPayment(oidReplaceCoa);
			Vector openPaymants = DbPettycashPayment.getOpenPayment(oidReplaceCoa);

            if (openPaymants != null && openPaymants.size() > 0 && pettycashReplenishment.getOID() != 0 && iJSPCommand == JSPCommand.SAVE) {
                DbPettycashExpense.insertExpenses(pettycashReplenishment.getOID(), openPaymants);
            }

            if (iJSPCommand == JSPCommand.NONE) {
                pettycashReplenishment.setMemo(getDefaultMemo(openPaymants));
            }

            /*** LANG ***/
            String[] langCT = {"Replenishment for", "Transaction Date", "From Account", "Memo", "Journal Number", "Account Balance", //0-5
                "Number", "Amount in", "Data is empty", "No expenses to replenish", "Insufficient cash  balance", "Journal is ready to be posted", "Search Journal Number", "Customer"}; //6-14

            String[] langNav = {"Petty Cash", "Replenishment", "Date", "Select..."};

            if (lang == LANG_ID) {
                String[] langID = {"Pengisian Kembali untuk", "Tanggal Transaksi", "Dari Perkiraan", "Catatan", "Nomor Jurnal", "Saldo Perkiraan", //0-5
                    "Nomor", "Jumlah", "Tidak ada data", "Tidak ada biaya untuk diganti", "Saldo kas tidak mencukupi", "Jurnal siap untuk diposting", "Cari Nomor Jurnal", "Sarana"}; //6-14
                langCT = langID;

                String[] navID = {"Kas Kecil", "Pengisian Kembali", "Tanggal", "Pilih..."};
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
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            <%if (prt.getOID() != 0) {%>
            window.location="pettycashreplenishmentconfirm.jsp?hidden_pettycash_replenishment_id=<%=prt.getOID()%>&menu_idx=1";
            <%}%>
            
            function cmdSearchJurnal(){
                window.open("<%=approot%>/transactionact/s_nomjurnal_pattycashreplenishment.jsp?formName=frmpettycashreplenishment&txt_Id=cash_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }                
                
                function cmdUpdate(){
                    document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
                    document.frmpettycashreplenishment.submit();
                }
                
                function cmdGetBalance(){
                    
                    var x = document.frmpettycashreplenishment.<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_REPLACE_FROM_COA_ID]%>.value;
                    
         <%if (bankBalance != null && bankBalance.size() > 0) {
                for (int i = 0; i < bankBalance.size(); i++) {
                    Coa c = (Coa) bankBalance.get(i);

                    double coaBalance = DbCoa.getCoaBalance(c.getOID());

         %>
             
             if(x=='<%=c.getOID()%>'){
                 if(<%=coaBalance%><0)
                     {
                         document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber((coaBalance < 0) ? coaBalance * -1 : coaBalance, "###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
                         }else
                         {
                             document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber((coaBalance < 0) ? coaBalance * -1 : coaBalance, "###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                             }
                             var total = 0;
                             <%if (openPaymants != null && openPaymants.size() > 0) {%>
                             total = document.frmpettycashreplenishment.<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_AMOUNT] %>.value;
                             <%}%>
                             
                             <%if (coaBalance < 1) {%>
                             
                             document.all.command_line.style.display="none";
                             document.all.emptymessage.style.display="";
                             <%} else {%>
                          
                             if(parseFloat('<%=coaBalance%>')<parseFloat(total)){
                                 document.all.command_line.style.display="none";
                                 document.all.emptymessage.style.display="";
                             }
                             else{
                                 document.all.command_line.style.display="";
                                 document.all.emptymessage.style.display="none";
                             }
                             <%}%>
                         }
         <%}
            }%>
        }
        
        function cmdChangeIt(){
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdAdd(){
            document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value="0";
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.ADD%>";
            document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdAsk(oidPettycashReplenishment){
            document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.ASK%>";
            document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdConfirmDelete(oidPettycashReplenishment){
            document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.DELETE%>";
            document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        function cmdSave(){
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.SAVE%>";
            document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdEdit(oidPettycashReplenishment){
            <%if(privUpdate){%>
            document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.EDIT%>";
            document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashreplenishment.action="pettycashreplenishmentconfirm.jsp";
            document.frmpettycashreplenishment.submit();
            <%}%>
        }
        
        function cmdCancel(oidPettycashReplenishment){
            document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.EDIT%>";
            document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdBack(){
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.BACK%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdListFirst(){
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.FIRST%>";
            document.frmpettycashreplenishment.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdListPrev(){
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.PREV%>";
            document.frmpettycashreplenishment.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdListNext(){
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.NEXT%>";
            document.frmpettycashreplenishment.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
        }
        
        function cmdListLast(){
            document.frmpettycashreplenishment.command.value="<%=JSPCommand.LAST%>";
            document.frmpettycashreplenishment.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
            document.frmpettycashreplenishment.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/save2.gif','../images/print2.gif','../images/post_journal2.gif')">
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
            String navigator = "&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmpettycashreplenishment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_pettycash_replenishment_id" value="<%=oidPettycashReplenishment%>">
                                                            <input type="hidden" name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_id_replace_coa" value="<%=oidReplaceCoa%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" width="100%" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="31%">&nbsp;</td>
                                                                                                        <td width="32%">&nbsp;</td>
                                                                                                        <td width="37%"> 
                                                                                                            <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                                                                            : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_OPERATOR_ID) %>&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="3" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="10%" nowrap>&nbsp;</td>
                                                                                                        <td width="42%">&nbsp;</td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="36%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (v != null && v.size() > 0) {%>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td width="10%" height="22" nowrap><%=langCT[12]%></td>
                                                                                                        <td width="42%" height="22">
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input size="50" readonly type="text" name="jurnal_number" value="<%=pettycashReplenishment.getJournalNumber()%>">
                                                                                                                        <input size="50" type="hidden" name="cash_id" value="<%=pettycashReplenishment.getOID()%>">
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>
                                                                                                                    </td>    
                                                                                                                </tr>
                                                                                                            </table>     
                                                                                                        </td>    
                                                                                                        <td width="12%" height="22">&nbsp;</td>
                                                                                                        <td width="36%" height="22">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan=4 height=20px>&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr> 
                                                                                                        <td colspan="4" width="100%"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td height="2">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan=4 height=20px>&nbsp;</td>
                                                                                                    </tr>  
                                                                                                    <tr> 
                                                                                                        <td width="10%" height="22" nowrap><%=langCT[4]%></td>
                                                                                                        <td width="42%" height="22">
                                                                                                            <%
            String strNumber = "";

            Date dt = new Date();
            
            Periode opnPeriode = new Periode();
                        
            try{
                opnPeriode = DbPeriode.getOpenPeriod();
            }catch(Exception e){}
            
            int periodeTaken = 0;
            
            try{
                periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
            }catch(Exception e){}
            
            if(periodeTaken == 0){
                dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
            }else if(periodeTaken == 1){
                dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
            }
            
            Date dtx = (Date) dt.clone();
            dtx.setDate(1);
            int mnth = dt.getMonth() + 1;

            String month = "";
            //Untuk memberikan value, jika antara bulan 1 sampai 9 maka di awalnya akan di tambahkan 0, 
            //sedangkan bila bulan 10 - 12 maka tidak di berikan 0 di depannya

            if (mnth >= 10) {
                month = "" + mnth;
            } else {
                month = "0" + mnth;
            }

            SystemDocCode systemDocCode = new SystemDocCode();
            systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);
            String formatDocCode = systemDocCode.getCode() + systemDocCode.getSeparator() + month + systemDocCode.getSeparator() + JSPFormater.formatDate(dtx, "yy");

            //int counterJournal = DbSystemDocNumber.getDocCodeCounter(formatDocCode);
            int counterJournal = DbSystemDocNumber.getDocCodeCounter(formatDocCode,opnPeriode,DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);
            strNumber = counterJournal + systemDocCode.getSeparator() + formatDocCode;

            //int counter = DbPettycashReplenishment.getNextCounter();
            //String strNumber = DbPettycashReplenishment.getNextNumber(counter);

            if (pettycashReplenishment.getOID() != 0) {
                strNumber = pettycashReplenishment.getJournalNumber();
            }

                                                                                                            %>
                                                                                                            <%=strNumber%> 
                                                                                                            <input type="hidden" name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_JOURNAL_NUMBER]%>">
                                                                                                            <input type="hidden" name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_JOURNAL_COUNTER]%>">
                                                                                                            <input type="hidden" name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_JOURNAL_PREFIX]%>">
                                                                                                        </td>
                                                                                                        <td width="12%" height="22">&nbsp;</td>
                                                                                                        <td width="36%" height="22">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td width="10%" nowrap height="22"><%=langCT[0]%></td>
                                                                                                        <td width="42%" height="22"> <b> 
                                                                                                                <select name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_COA_ID]%>" onChange="javascript:cmdUpdate()">
                                                                                                                    <%if (accLinks != null && accLinks.size() > 0) {
																														for (int i = 0; i < accLinks.size(); i++) {
																															AccLink accLink = (AccLink) accLinks.get(i);
																															Coa coa = new Coa();
																															try {
																																coa = DbCoa.fetchExc(accLink.getCoaId());
																															} catch (Exception e) {
																															}
																													%>
                                                                                                                    <option <%if (oidReplaceCoa == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                    <%=getAccountRecursif(coa.getLevel()*-1, coa, oidReplaceCoa, isPostableOnly)%> 
                                                                                                                    <%}
} else {%>
                                                                                                                    <option><%=langNav[3]%></option>
                                                                                                                    <%}%>
                                                                                                                </select>
                                                                                                        <%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_REPLACE_COA_ID) %> </b></td>
                                                                                                        <td width="12%" height="22">&nbsp;</td>
                                                                                                        <td width="36%" height="22">&nbsp; </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%" height="22"><%=langCT[1]%></td>
                                                                                                        <td width="42%" height="22"> 
                                                                                                            <input name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((pettycashReplenishment.getTransDate() == null) ? new Date() : pettycashReplenishment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpettycashreplenishment.<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%if (iJSPCommand != JSPCommand.SUBMIT) {%>
                                                                                                            <%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_TRANS_DATE) %> 
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td width="12%" height="22"><%//=langCT[13]%></td>
                                                                                                        <td width="36%" height="22">
                                                                                                            <%

            String order = DbCustomer.colNames[DbCustomer.COL_NAME];

            Vector vCustomer = DbCustomer.list(0, 0, "", order);
                                                                                                            %>
                                                                                                            <!--select name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_CUSTOMER_ID]%>">                                                                
                                                                                                                <%
            if (vCustomer != null && vCustomer.size() > 0) {

                for (int iC = 0; iC < vCustomer.size(); iC++) {

                    Customer objCustomer = (Customer) vCustomer.get(iC);

                                                                                                                %>                                                                                                                
                                                                                                                <option <%if (pettycashReplenishment.getCustomerId() == objCustomer.getOID()) {%>selected<%}%> value="<%=objCustomer.getOID()%>"><%=objCustomer.getName()%></option>                                                                                                                
                                                                                                                <%
                                                                                                                    }
                                                                                                                } else {
                                                                                                                %>
                                                                                                                <option>select ..</option>
                                                                                                                <%}%>
                                                                                                            </select-->
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%" height="22"><%=langCT[2]%></td>
                                                                                                        <td width="42%" height="22"> 
                                                                                                            <select name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_FROM_COA_ID]%>" onChange="javascript:cmdGetBalance()">
                                                                                                             <%if (bankAccounts != null && bankAccounts.size() > 0) {
																												for (int i = 0; i < bankAccounts.size(); i++) {
																								
																													AccLink accLink = (AccLink) bankAccounts.get(i);
																													Coa coa = new Coa();
																								
																													try {
																														coa = DbCoa.fetchExc(accLink.getCoaId());
																													} catch (Exception e) {
																														System.out.println("[exception] " + e.toString());
																													}
                                                                                                                %>
                                                                                                                <option <%if (pettycashReplenishment.getReplaceFromCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                <%=getAccountRecursif(coa.getLevel()*-1, coa, pettycashReplenishment.getReplaceFromCoaId(), isPostableOnly)%> 
                                                                                                                <%}
																												} else {%>
                                                                                                                <option><%=langNav[3]%></option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        <%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_REPLACE_COA_ID) %> &nbsp;&nbsp; </td>
                                                                                                        <td width="12%" height="22" nowrap>&nbsp;<b><%=langCT[5]%> <%=baseCurrency.getCurrencyCode()%></b></td>
                                                                                                        <td width="36%" height="22"> <b><a id="tot_saldo_akhir"></a></b> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%" height="22"><%=langCT[3]%></td>
                                                                                                        <td colspan="3" height="22"> 
                                                                                                            <textarea name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_MEMO] %>" class="formElemen" cols="50" rows="2"><%= pettycashReplenishment.getMemo() %></textarea>
                                                                                                            <%if (iJSPCommand != JSPCommand.SUBMIT) {%>
                                                                                                            <br>
                                                                                                            <%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_MEMO) %> 
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%" height="8"></td>
                                                                                                        <td width="42%" height="8"></td>
                                                                                                        <td width="12%" height="8"></td>
                                                                                                        <td width="36%" height="8"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">&nbsp;</td>
                                                                                                        <td width="42%">&nbsp;</td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="36%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%

            double total = 0;

            if (openPaymants != null && openPaymants.size() > 0) {

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td colspan="4"> 
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr > 
                                                                                                                    <td class="tabheader" width="1%"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                                                                                    <td class="tab" width="11%"> 
                                                                                                                        <div align="center">Disbursement</div>
                                                                                                                    </td>
                                                                                                                    <td class="tabheader" width="25%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                    <td class="tabheader" width="0%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                    <td class="tabheader" width="0%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                    <td width="63%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" class="page"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="15%" class="tablehdr"> 
                                                                                                                        <div align="center"><%=langCT[6]%></div>
                                                                                                                    </td>
                                                                                                                    <td width="14%" class="tablehdr"> 
                                                                                                                        <div align="center"><%=langCT[1]%></div>
                                                                                                                    </td>
                                                                                                                    <td width="54%" class="tablehdr"> 
                                                                                                                        <div align="center"><%=langCT[3]%></div>
                                                                                                                    </td>
                                                                                                                    <td width="17%" class="tablehdr"> 
                                                                                                                        <div align="center"><%=langCT[7]%>(<%=baseCurrency.getCurrencyCode()%>)</div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%

                                                                                                                    for (int i = 0; i < openPaymants.size(); i++) {

                                                                                                                        PettycashPayment pp = (PettycashPayment) openPaymants.get(i);
                                                                                                                        total = total + pp.getAmount();

                                                                                                                        String cssName = "tablecell";
                                                                                                                        if (i % 2 != 0) {
                                                                                                                            cssName = "tablecell1";
                                                                                                                        }

                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td width="15%" class="<%=cssName%>"><%=pp.getJournalNumber()%>&nbsp;</td>
                                                                                                                    <td width="14%" class="<%=cssName%>"> 
                                                                                                                        <div align="center"><%=JSPFormater.formatDate(pp.getTransDate(), "dd MMMM yyyy")%></div>
                                                                                                                    </td>
                                                                                                                    <td width="54%" class="<%=cssName%>"> 
                                                                                                                        <div align="left"><%=pp.getMemo()%></div>
                                                                                                                    </td>
                                                                                                                    <td width="17%" class="<%=cssName%>"> 
                                                                                                                        <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr> 
                                                                                                                    <td width="15%" height="1"></td>
                                                                                                                    <td width="14%" height="1"></td>
                                                                                                                    <td width="54%" height="1"></td>
                                                                                                                    <td width="17%" height="1"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="15%" class="tablecell">&nbsp;</td>
                                                                                                                    <td width="14%" class="tablecell">&nbsp;</td>
                                                                                                                    <td width="54%" class="tablecell"> 
                                                                                                                        <div align="right"><b>TOTAL 
                                                                                                                        : </b></div>
                                                                                                                    </td>
                                                                                                                    <td width="17%" class="tablecell"> 
                                                                                                                        <div align="right"><b> 
                                                                                                                                <input type="hidden" name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_AMOUNT] %>"  value="<%=total%>" class="textdisabled" style="text-align:right" readOnly>
                                                                                                                        <%= JSPFormater.formatNumber(total, "#,###.##") %></b></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="13" class="boxed1"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="15%" class="tablehdr"> 
                                                                                                                        <div align="center"><%=langCT[6]%></div>
                                                                                                                    </td>
                                                                                                                    <td width="14%" class="tablehdr"> 
                                                                                                                        <div align="center"><%=langCT[1]%></div>
                                                                                                                    </td>
                                                                                                                    <td width="54%" class="tablehdr"> 
                                                                                                                        <div align="center"><%=langCT[3]%></div>
                                                                                                                    </td>
                                                                                                                    <td width="17%" class="tablehdr"> 
                                                                                                                        <div align="center"><%=langCT[7]%> <%=baseCurrency.getCurrencyCode()%></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" class="tablecell"> 
                                                                                                                    <font color="#000"><%=langCT[8]%></font></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="15%" height="1"></td>
                                                                                                                    <td width="14%" height="1"></td>
                                                                                                                    <td width="54%" height="1"></td>
                                                                                                                    <td width="17%" height="1"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="15%" class="tablecell">&nbsp;</td>
                                                                                                                    <td width="14%" class="tablecell">&nbsp;</td>
                                                                                                                    <td width="54%" class="tablecell"> 
                                                                                                                        <div align="right"><b>TOTAL 
                                                                                                                        : </b></div>
                                                                                                                    </td>
                                                                                                                    <td width="17%" class="tablecell"> 
                                                                                                                        <div align="right"><b> 
                                                                                                                                <input type="hidden" name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_AMOUNT] %>2"  value="<%=total%>" class="textdisabled" style="text-align:right" readOnly>
                                                                                                                        0.00</b></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        <i></i></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" id="command_line"> 
                                                                                                            <%
            if (prt.getOID() == 0) {
                if (total > 0) {%>
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="4">&nbsp;</td>
                                                                                                                    <td width="74%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <%if (iJSPCommand != JSPCommand.SUBMIT && msgString != null && msgString.length() > 0) {%>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4"> 
                                                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="warning" align="left">
                                                                                                                            <tr> 
                                                                                                                                <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                                                                                <td width="270" nowrap><%=msgString%></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td width="74%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr> 
                                                                                                                    <td width="2%">
                                                                                                                        <%
                                                                                                                    if (pettycashReplenishment.getPostedStatus() == 0) {
                                                                                                                        %>    
                                                                                                                        <%if(privUpdate || privAdd){%>
                                                                                                                        <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/save2.gif',1)"><img src="../images/save.gif" name="new" height="22" border="0"></a>
                                                                                                                        <%}%>
                                                                                                                        <%
                                                                                                                        } else {
                                                                                                                        %>
                                                                                                                        &nbsp;
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="2%">&nbsp;</td>
                                                                                                                    <td width="16%">&nbsp;</td>
                                                                                                                    <td width="74%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            <%} else {%>
                                                                                                            <br>
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="5"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td height="2">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="2%"><img src="../images/save.gif" width="55" height="22"></td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="2%">&nbsp;</td>
                                                                                                                    <td width="16%">&nbsp;</td>
                                                                                                                    <td width="74%" class="msgnextaction"> 
                                                                                                                        <div align="left"></div>
                                                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right">
                                                                                                                            <tr> 
                                                                                                                                <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                                                                                <td width="150" nowrap><%=langCT[9]%></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            <%}
            }%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%if (prt.getOID() != 0) {%>
                                                                                        <tr> 
                                                                                            <td colspan="5"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td height="2">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="5"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                                                                        <td width="2%">&nbsp;</td>
                                                                                                        <td width="16%"><a href="javascript:cmdNewJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                                                                                        <td width="44%">&nbsp;</td>
                                                                                                        <td width="33%"> 
                                                                                                            <div align="right" class="msgnextaction"> 
                                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="info" width="210" align="right">
                                                                                                                    <tr> 
                                                                                                                        <td width="20"><img src="../images/inform.gif" width="20" height="20"></td>
                                                                                                                        <td width="140" nowrap><%=langCT[12]%></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr id="emptymessage"> 
                                                                                            <td colspan="5"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td height="2">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td> 
                                                                                                            <div align="left" class="msgnextaction"> 
                                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right">
                                                                                                                    <tr> 
                                                                                                                        <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                                                                        <td width="230" nowrap><%=langCT[10]%></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
            try {
                if (listPettycashReplenishment.size() > 0) {
                                                                            %>
                                                                            <%  }
            } catch (Exception exc) {
                System.out.println("[exception] " + exc.toString());
            }%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" width="100%">&nbsp; 
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                //cmdGetBalance();
                                                            </script>
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
