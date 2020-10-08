
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%
            String approot = "";
%>
<%


            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long salesId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");

        ctrlist.addHeader("No", "5%");
        ctrlist.addHeader("Tanggal", "10%");
        ctrlist.addHeader("Nomor", "15%");
        ctrlist.addHeader("Member", "30%");
        ctrlist.addHeader("Total", "15%");
        ctrlist.addHeader("Terbayar", "15%");
        ctrlist.addHeader("Sisa", "15%");

        ctrlist.setLinkRow(2);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        //ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkPrefix("javascript:targetPage('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Sales sales = (Sales) objectClass.get(i);
            Vector rowx = new Vector();
            if (salesId == sales.getOID()) {
                index = i;
            }
            rowx.add("<div align=\"center\">" + (i + 1) + "</div>");

            String str_dt_Date = "";
            try {
                Date dt_Date = sales.getDate();
                if (dt_Date == null) {
                    dt_Date = new Date();
                } else {
                    str_dt_Date = JSPFormater.formatDate(dt_Date, "dd/MM/yy");
                }
            } catch (Exception e) {
                str_dt_Date = "";
            }


            rowx.add(str_dt_Date);
            rowx.add(sales.getNumber());
            rowx.add(sales.getName());
            double totalPayment = 0;//DbCreditPayment.getTotalPayment(DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + "=" + sales.getOID());
            double balance = sales.getAmount() - totalPayment;

            double totalPaid = 0;
            String strdata = "";
            
            try {
                Vector list = SessCreditTransaction.getTotalAmount(sales.getNumber(), "", 0, 1);

                if (list != null && list.size() > 0) {
                    CreditMember cm = (CreditMember) list.get(0);
                    balance = cm.getTotal();
                    totalPaid = cm.getPaid();
                    sales = DbSales.fetchExc(cm.getSalesId());

                }
            } catch (Exception e) {
            }


            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(balance, "#,##0") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(totalPaid, "#,##0") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(balance, "#,##0") + "</div>");

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(sales.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%
            String name = JSPRequestValue.requestString(request, "proj_name");
            String number = JSPRequestValue.requestString(request, "proj_number");
            String code_member = JSPRequestValue.requestString(request, "member_code");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidSales = JSPRequestValue.requestLong(request, "hidden_sales_id");

            double totalCredit = 0;
            double totalPaidCus = 0;
            double totalBalance = 0;

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
//String whereClause = "company_id="+systemCompanyId;
            String whereClause = "";
            String orderClause = "";

            whereClause = "type=" + DbSales.TYPE_CREDIT + " and payment_status=1";
            if (name.length() > 0) {
                whereClause = whereClause + " and name like '%" + name + "%'";
            }
            if (number.length() > 0) {
                whereClause = whereClause + " and number like '%" + number + "%'";
            }

            User user = new User();
            CmdSales ctrlSales = new CmdSales(request);
            JSPLine ctrLine = new JSPLine();
            Vector listSales = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlSales.action(iJSPCommand, oidSales, 0, user);
            /* end switch*/
            JspSales jspSales = ctrlSales.getForm();

            /*count list All Sales*/
            int vectSize = DbSales.getCount(whereClause);

            Sales sales = ctrlSales.getSales();
            msgString = ctrlSales.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlSales.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listSales = DbSales.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listSales.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listSales = DbSales.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html >
    
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>OXY Pos</title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function targetPage(oidSales){
                document.frmsales.hidden_sales_id.value=oidSales;
                document.frmsales.command.value="<%=JSPCommand.LIST%>";
                document.frmsales.prev_command.value="<%=prevJSPCommand%>";
                document.frmsales.action="creditpaymenthis.jsp";
                document.frmsales.submit();
            }
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmsales.action="creditmember-old.jsp";
                document.frmsales.submit();
            }
            function cmdEdit(oidSales, oidProd){
                document.frmsales.hidden_sales_id.value=oidSales;
                document.frmsales.command.value="<%=JSPCommand.LIST%>";
                document.frmsales.prev_command.value="<%=prevJSPCommand%>";
                document.frmsales.action="creditpaymenthis.jsp";
                document.frmsales.submit();
            }
            
            function cmdListFirst(){
                document.frmsales.command.value="<%=JSPCommand.FIRST%>";
                document.frmsales.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmsales.action="creditmember.jsp";
                document.frmsales.submit();
            }
            
            function cmdListPrev(){
                document.frmsales.command.value="<%=JSPCommand.PREV%>";
                document.frmsales.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmsales.action="creditmember.jsp";
                document.frmsales.submit();
            }
            
            function cmdListNext(){
                document.frmsales.command.value="<%=JSPCommand.NEXT%>";
                document.frmsales.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmsales.action="creditmember.jsp";
                document.frmsales.submit();
            }
            
            function cmdListLast(){
                document.frmsales.command.value="<%=JSPCommand.LAST%>";
                document.frmsales.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmsales.action="creditmember.jsp";
                document.frmsales.submit();
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
        <script type="text/javascript">
            <!--
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
    </head>
    <body>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" >&nbsp;</td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td>                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                                                        <tr> 
                                                                            <td valign="top"> 
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                                    <!--DWLayoutTable-->
                                                                                    <tr> 
                                                                                        <td width="100%" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> 
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            <input type="hidden" name="hidden_sales_id" value="<%=oidSales%>">
                                                                                                            <input type="hidden" name="hidden_sales" value="<%=oidSales%>">
                                                                                                            <input type="hidden" name="hidden_proposal_id" value="<%=sales.getProposalId()%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14" nowrap><b>Daftar Kredit Member</b></td>
                                                                                                                                            <td width="38%" height="14"></td>
                                                                                                                                            <td width="54%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14" nowrap>Nomor Faktur</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                            <input type="text" name="proj_number" value="<%=(number == null) ? "" : number%>" size="35">                                                                  </td>
                                                                                                                                            <td width="54%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14" nowrap>Member</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                            <input type="text" name="proj_name" value="<%=(name == null) ? "" : name%>" size="35">                                                                  </td>
                                                                                                                                            <td width="54%" height="15"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                        </tr>                                                                
                                                                                                                                </table>                                                            </td>
                                                                                                                            </tr>
                                                                                                                            <%
            try {
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td class="boxed1"><%= drawList(listSales, oidSales)%></td>
                                                                                                                                        </tr>
                                                                                                                                </table>                                                            </td>
                                                                                                                            </tr>
                                                                                                                            <%
            } catch (Exception exc) {
            }%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" class="command"> 
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
                                                                                                                                        <%
            ctrLine.setLocationImg(approot + "/ims/images/ctr_line");
            ctrLine.initDefault();

            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/ims/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/ims/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/ims/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/ims/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/ims/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/ims/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/ims/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/ims/images/last2.gif',1)");
                                                                                                                                        %>
                                                                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span>                                                            </td>
                                                                                                                            </tr>
                                                                                                                            
                                                                                                                    </table>                                                      </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp;                                                      </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                    </form>                                              </td>
                                                                                                </tr>
                                                                                        </table>                                        </td>
                                                                                    </tr>
                                                                            </table>                                  </td>
                                                                        </tr>
                                                                </table>                            </td>
                                                            </tr>
                                                    </table> </td>
                                                </tr>
                                        </table>                </td>
                                    </tr>
                            </table>          </td>
                        </tr>
                </table>    </td>
            </tr>
        </table>
    </body>
    
</html>

