
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%
            String approot = "";
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
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

        ctrlist.addHeader("No.", "5%");
        ctrlist.addHeader("Date", "10%");
        ctrlist.addHeader("Lokasi", "20%");
        ctrlist.addHeader("Mata Uang", "10%");
        ctrlist.addHeader("Total", "20%");

        ctrlist.setLinkRow(-1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        //ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkPrefix("javascript:targetPage('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            CreditPayment objCreditPayment = (CreditPayment) objectClass.get(i);
            Vector rowx = new Vector();

            Currency currency = new Currency();
            CashCashier c = new CashCashier();
            CashMaster cm = new CashMaster();
            Location loc = new Location();
            try {
                currency = DbCurrency.fetchExc(objCreditPayment.getCurrency_id());
                c = DbCashCashier.fetchExc(objCreditPayment.getCash_cashier_id());
                cm = DbCashMaster.fetchExc(c.getCashMasterId());
                loc = DbLocation.fetchExc(cm.getLocationId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
            rowx.add("<div align=\"center\">" + String.valueOf(objCreditPayment.getPay_datetime()) + "</div>");
            rowx.add("<div align=\"center\">" + loc.getName() + "</div>");
            rowx.add("<div align=\"center\">" + String.valueOf(currency.getCurrencyCode()) + "</div>");
            rowx.add("<div align=\"right\">" + String.valueOf(JSPFormater.formatNumber(objCreditPayment.getAmount(), "#,##0")) + "</div>");


            lstData.add(rowx);
            lstLinkData.add("0");

        }


        return ctrlist.draw(index);
    }

    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                SalesDetail salesProductDetail = (SalesDetail) listx.get(i);
                result = result + (salesProductDetail.getSellingPrice() * salesProductDetail.getQty()) - (salesProductDetail.getDiscountAmount());
            }
        }
        return result;
    }

    public long getValidId(long oid, Vector vItemMaster) {
        if (vItemMaster != null && vItemMaster.size() > 0) {
            long selOID = 0;
            for (int i = 0; i < vItemMaster.size(); i++) {
                ItemMaster c = (ItemMaster) vItemMaster.get(i);

                //jika kosong dan urutan pertama
                if (oid == c.getOID()) {
                    return oid;
                }
            }

            ItemMaster c = (ItemMaster) vItemMaster.get(0);
            return c.getOID();

        }
        return 0;
    }

    public double getTtDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                //SalesTerm salesTerm = (SalesTerm)listx.get(i);
                result = 0;//result + salesTerm.getAmount();
            //System.out.println(salesTerm.getAmount());
            }
        }
        return result;
    }

%>
<%
            long oidSales = JSPRequestValue.requestLong(request, "hidden_sales_id");
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");

            Sales sales = new Sales();
            CreditPayment creditPayment = new CreditPayment();

// variable declaration
            int recordToGet = 15;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + "=" + oidSales;
            String orderClause = "";

            CmdCreditPayment cmdCP = new CmdCreditPayment(request);
            Shift shift = new Shift();
            JSPLine jspLine = new JSPLine();
            Vector listCP = new Vector(1, 1);

// switch statement
            iErrCode = cmdCP.action(iCommand, 0, 0);

// end switch
            JspCreditPayment jspCP = cmdCP.getForm();

// count list All SalesDetail 
            int vectSize = DbCreditPayment.getCount(whereClause);
            msgString = cmdCP.getMessage();

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                start = cmdCP.actionList(iCommand, start, vectSize, recordToGet);
            }

// get record to display
            listCP = DbCreditPayment.list(start, recordToGet, whereClause, orderClause);

// handle condition if size of record to display = 0 and start > 0 	after delete
            if (listCP.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } else {
                    start = 0;
                    iCommand = JSPCommand.FIRST;
                    prevCommand = JSPCommand.FIRST;
                }
                listCP = DbCreditPayment.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>OXY Pos</title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            
            function cmdBack(){
                document.frmsalesproductdetail.command.value="<%=JSPCommand.BACK%>";
                document.frmsalesproductdetail.action="creditmember.jsp";
                document.frmsalesproductdetail.submit();
            }
            
            function cmdListFirst(){
                document.frmsalesproductdetail.command.value="<%=JSPCommand.FIRST%>";
                document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmsalesproductdetail.action="creditmember.jsp";
                document.frmsalesproductdetail.submit();
            }
            
            function cmdListPrev(){
                document.frmsalesproductdetail.command.value="<%=JSPCommand.PREV%>";
                document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmsalesproductdetail.action="creditmember.jsp";
                document.frmsalesproductdetail.submit();
            }
            
            function cmdListNext(){
                document.frmsalesproductdetail.command.value="<%=JSPCommand.NEXT%>";
                document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmsalesproductdetail.action="creditmember.jsp";
                document.frmsalesproductdetail.submit();
            }
            
            function cmdListLast(){
                document.frmsalesproductdetail.command.value="<%=JSPCommand.LAST%>";
                document.frmsalesproductdetail.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmsalesproductdetail.action="creditmember.jsp";
                document.frmsalesproductdetail.submit();
            }
            
            function check(evt){
                var charCode = (evt.which) ? evt.which : event.keyCode
                if (charCode > 31 && (charCode < 48 || charCode > 57) ){
                    alert("Numeric input")
                    return false
                }	return true
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/new2.gif','../images/savedoc.gif2.gif','../images/savedoc2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif">&nbsp;</td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
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
                                                                                                        <!--Begin Region Content-->
                                                                                                        <form name="frmsalesproductdetail" method ="post" action="">
                                                                                                        <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                                        <input type="hidden" name="start" value="<%=start%>">
                                                                                                        <input type="hidden" name="cekPayment" value="0">
                                                                                                        
                                                                                                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                                        <input type="hidden" name="hidden_sales_id" value="<%=oidSales%>">
                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr> 
                                                                                                                <td class="container"> 
                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                            <td height="8"  colspan="3"> 
                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                    <tr> 
                                                                                                                                        <td colspan="4" height="25"><b>Histori Pembayaran</b></td>
                                                                                                                                    </tr>
                                                                                                                                    <%
            try {
                                                                                                                                    %>
                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                        <td height="22" valign="middle" colspan="4"> 
                                                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                <tr> 
                                                                                                                                                    <td class="boxed1"><%= drawList(listCP, 0)%></td>
                                                                                                                                                </tr>
                                                                                                                                            </table>
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                    <%
            } catch (Exception exc) {
            }
                                                                                                                                    %>
                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                        <td height="8" align="left" colspan="4" class="command" valign="top"> 
                                                                                                                                            <span class="command"> 
                                                                                                                                                <%
            int cmd = 0;
            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                cmd = iCommand;
            } else {
                if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevCommand;
                }
            }
                                                                                                                                                %>
                                                                                                                                                <%
            jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
            jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                                                                %>
                                                                                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> 
                                                                                                                                        </span> </td>
                                                                                                                                    </tr>
                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                        <td height="22" valign="middle" colspan="4"> 
                                                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                <tr> 
                                                                                                                                                    <td width="97%">&nbsp;</td>
                                                                                                                                                </tr>
                                                                                                                                                <tr> 
                                                                                                                                                    <td width="97%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back2','','../images/back2.gif',1)"><img src="../images/back.gif" name="back2" border="0"></a>
                                                                                                                                                    </td>
                                                                                                                                                </tr>
                                                                                                                                                <tr> 
                                                                                                                                                    <td width="97%">&nbsp;</td>
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
                                                                                                        <!--End Region Content-->
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    <!-- #EndEditable --> </td>
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
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

