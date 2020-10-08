
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<%@ include file = "../main/check.jsp" %>
<!-- Jsp Block -->
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_DELETE);
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            String bankid = JSPRequestValue.requestString(request, "bankid");
            String jurnalname = JSPRequestValue.requestString(request, "jurnalname");
            String v_txt_jurnal = JSPRequestValue.requestString(request, "txt_jurnal");
            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);
            JSPLine ctrLine = new JSPLine();


            Vector listBankPo = new Vector();

            String where = " bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PENGAKUAN_BIAYA;
            if (v_txt_jurnal != null && v_txt_jurnal.length() > 0) {
                where = where + " and bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + v_txt_jurnal + "%'";
            }

            int vectSize = DbBankpoPayment.countDetail(where);

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlBankpoPayment.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            listBankPo = DbBankpoPayment.listDetail(start, recordToGet, where, DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]);

            if (listBankPo.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listBankPo = DbBankpoPayment.listDetail(start, recordToGet, where, DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <style type="text/css">
            <!--
            .style1 {color: #FF0000}
            -->
        </style>
        <script language="JavaScript">
            function cmdSelect(jurnalname,bankOid){      
                self.opener.document.frmap.jurnal_number.value = jurnalname;
                self.opener.document.frmap.bankpo_id.value = bankOid;
                self.opener.document.frmap.command.value="<%=JSPCommand.REFRESH%>";    
                self.opener.document.frmap.submit();                
                self.close();
            }
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){                           
                document.frm_nomorjurnal.command.value="<%=JSPCommand.SEARCH%>";
                document.frm_nomorjurnal.action="sbankpayment.jsp";
                document.frm_nomorjurnal.submit();            
            }
            
            function cmdListFirst(){
                document.frm_nomorjurnal.command.value="<%=JSPCommand.FIRST%>";
                document.frm_nomorjurnal.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frm_nomorjurnal.action="sbankpayment.jsp";
                document.frm_nomorjurnal.submit();
            }
            
            function cmdListPrev(){
                document.frm_nomorjurnal.command.value="<%=JSPCommand.PREV%>";
                document.frm_nomorjurnal.prev_command.value="<%=JSPCommand.PREV%>";
                document.frm_nomorjurnal.action="sbankpayment.jsp";
                document.frm_nomorjurnal.submit();
            }
            
            function cmdListNext(){
                document.frm_nomorjurnal.command.value="<%=JSPCommand.NEXT%>";
                document.frm_nomorjurnal.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frm_nomorjurnal.action="sbankpayment.jsp";
                document.frm_nomorjurnal.submit();
            }
            
            function cmdListLast(){
                document.frm_nomorjurnal.command.value="<%=JSPCommand.LAST%>";
                document.frm_nomorjurnal.prev_command.value="<%=JSPCommand.LAST%>";
                document.frm_nomorjurnal.action="sbankpayment.jsp";
                document.frm_nomorjurnal.submit();
            }
            
            //-------------- script form image -------------------
            function cmdDelPict(oidCashReceiveDetail){
                document.frmimage.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="cashreceivedetail.jsp";
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
        </script>
        <!-- #EndEditable -->
    </head>
    <body> 
        <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">            
            <tr>
                <td class="container">
                    <table width="100%" border="0">                     
                        <form name="frm_nomorjurnal" method ="post" action="">
                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                            <input type="hidden" name="bankid" value="<%=bankid%>">
                            <input type="hidden" name="jurnalname" value="<%=jurnalname%>">
                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                            <input type="hidden" name="start" value="<%=start%>">
                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                            <tr>
                                <td width="5px">&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="340" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="100" class="tablecell" style="padding:3px;">Nomor Jurnal</td>
                                            <td width="1" class="fontarial" style="padding:3px;">:</td>
                                            <td><input type="text" name="txt_jurnal" value="<%=v_txt_jurnal%>" size="22">&nbsp;</td>
                                            <td><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new1" width="59" height="21" border="0"></a></td>                                            
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td width="5px">&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <%
            if (listBankPo != null && listBankPo.size() > 0) {
                            %>    
                            <tr>
                                <td width="5px">&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan=2>
                                    <table width="750" border=0 cellpadding="1" cellspacing="1">
                                        <tr height="25">
                                            <td class="tablehdr" width="25" >No</td>
                                            <td class="tablehdr" width="100" >Nomor Journal</td>
                                            <td class="tablehdr" >Memo</td>
                                            <td class="tablehdr" width="90">Amount</td>
                                        </tr>    
                                        <%
                                for (int i = 0; i < listBankPo.size(); i++) {

                                    BankpoPayment bankpoPayment = (BankpoPayment) listBankPo.get(i);

                                    String style = "";
                                    if (i % 2 == 0) {
                                        style = "tablecell";
                                    } else {
                                        style = "tablecelll";
                                    }

                                        %>
                                        <tr>
                                            <td class="<%=style%>" align="center" style="padding:3px;"><%=(start+i+1)%></td>
                                            <td class="<%=style%>" align="left" style="padding:3px;">
                                                <%
                                            out.println("<a style='color:blue' href=\"javascript:cmdSelect('" + bankpoPayment.getJournalNumber() + "','" + bankpoPayment.getOID() + "')\">" + bankpoPayment.getJournalNumber() + "</a>");
                                                %>
                                            </td>
                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=bankpoPayment.getMemo()%></td>
                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>&nbsp;</td>
                                        </tr> 
                                        <%
                                }
                                        %>
                                        <tr align="left" valign="top"> 
                                            <td height="8" align="left" colspan="4" class="command"> 
                                                <span class="command"> 
                                                    <%
                                int cmd = 0;
                                if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                                        (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                                    cmd = iJSPCommand;
                                } else {
                                    if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                                        cmd = JSPCommand.FIRST;
                                    } else {
                                        cmd = prevJSPCommand;
                                    }
                                }
                                                    %>
                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
                                ctrLine.initDefault();
                                                    %>
                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> 
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <%
            }
                            %>
                        </form>
                        <tr height = "40px">
                            <td>&nbsp</td>
                        </tr>
                    </table>
                </td>
            </tr>           
        </table>
    </body>
</html>
