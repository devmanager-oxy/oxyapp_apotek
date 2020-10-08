
<%-- 
    Document   : salespayment_editor
    Created on : Jun 12, 2014, 9:16:59 PM
    Author     : Roy Andika
--%>

<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_DELETE);
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            String number = JSPRequestValue.requestString(request, "number");
            int type = JSPRequestValue.requestInt(request, "type");
            int statusPosted = JSPRequestValue.requestInt(request, "posted_status");

            if (tanggal == null) {
                tanggal = new Date();
            }
            if (tanggalEnd == null) {
                tanggalEnd = new Date();
            }

            Vector locations = new Vector();
            try {
                locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
            } catch (Exception e) {
            }


            Vector result = new Vector();
            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.ACTIVATE) {
                result = DbMerchant.getPaymentMerchant(locationId, tanggal, tanggalEnd, number, type, statusPosted);

                if (iJSPCommand == JSPCommand.ACTIVATE) {

                    if (result != null && result.size() > 0) {
                        for (int t = 0; t < result.size(); t++) {
                            PayMerchant pm = (PayMerchant) result.get(t);
                            int ex = JSPRequestValue.requestInt(request, "ex" + pm.getPaymentId());
                            if (ex == 1) {
                                long merchantx = JSPRequestValue.requestLong(request, "merchant_id" + pm.getPaymentId());
                                DbMerchant.updatePaymentMerchant(pm.getPaymentId(), merchantx);
                            }
                        }
                    }
                    result = DbMerchant.getPaymentMerchant(locationId, tanggal, tanggalEnd, number, type, statusPosted);
                }
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=systemTitle%></title>
        <script language="JavaScript">        
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmsaleseditor.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmsaleseditor.action="saleseditor.jsp?menu_idx=<%=menuIdx%>";
                document.frmsaleseditor.submit();
            }
            
            function cmdSave(){
                document.frmsaleseditor.command.value="<%=JSPCommand.ACTIVATE %>";
                document.frmsaleseditor.action="saleseditor.jsp?menu_idx=<%=menuIdx%>";
                document.frmsaleseditor.submit();
            }
            
            <!--
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
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                  <%@ include file="menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Sales Editor</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td class="container" ><!-- #BeginEditable "content" --> 
                                                        <form name="frmsaleseditor" method="post" action="">
                                                            <input type="hidden" name="command" value="">    
                                                            <table width="100%" border="0" >
                                                                <tr height="22">
                                                                    <td>
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="14%" class="tablearialcell1">&nbsp;Location</td>
                                                                                <td width="86%">: 
                                                                                    <%

                                                                                    %>
                                                                                    <select name="src_location_id" class="fontarial">
                                                                                        <%if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location us = (Location) locations.get(i);
                                                                                        %>
                                                                                        <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                        <%}
            }%>
                                                                                    </select>   
                                                                                </td>
                                                                            </tr>  
                                                                            <tr height="22"> 
                                                                                <td width="14%" class="tablearialcell1">&nbsp;Date</td>
                                                                                <td width="86%"><table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td>:<td>
                                                                                            <td>&nbsp;<input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsaleseditor.invStartDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                            <td>&nbsp;&nbsp;to&nbsp;</td>
                                                                                            <td>&nbsp;<input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsaleseditor.invEndDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                        </tr>
                                                                                    </table>   
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="14%" class="tablearialcell1">&nbsp;Number</td>
                                                                                <td width="86%">:&nbsp;<input type="text" name="number" value="<%=number%>" size="25"> 
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="14%" class="tablearialcell1">&nbsp;Payment Type</td>
                                                                                <td width="86%">: 
                                                                                    <select name="type" class="fontarial">
                                                                                        <option value="-1" <%if (-1 == type) {%>selected<%}%> >All Type</option>                                                                                        
                                                                                        <option value="<%=DbPayment.PAY_TYPE_CREDIT_CARD %>" <%if (DbPayment.PAY_TYPE_CREDIT_CARD == type) {%>selected<%}%>>Credit Card</option>                                                                                        
                                                                                        <option value="<%=DbPayment.PAY_TYPE_DEBIT_CARD%>" <%if (DbPayment.PAY_TYPE_DEBIT_CARD == type) {%>selected<%}%>>Debit Card</option>                                                                                        
                                                                                    </select>  
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="14%" class="tablearialcell1">&nbsp;Posted Status</td>
                                                                                <td width="86%">: 
                                                                                    <select name="posted_status" class="fontarial">
                                                                                        <option value="-1" <%if (-1 == statusPosted) {%>selected<%}%>>All Status</option>
                                                                                        <option value="0" <%if (0 == statusPosted) {%>selected<%}%>>Un-Posted</option>                                                                                        
                                                                                        <option value="1" <%if (1 == statusPosted) {%>selected<%}%>>Posted</option>                                                                                        
                                                                                    </select>  
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="14%" >&nbsp;</td>
                                                                                <td width="86%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                </tr> 
                                                                <tr>
                                                                    <td>
                                                                        <table cellpadding="0" cellspacing="1" width="900">
                                                                            <tr height="22">
                                                                                <td class="tablehdr" width="150">Number</td>
                                                                                <td class="tablehdr" width="100">Date</td>
                                                                                <td class="tablehdr" width="70">Status</td>
                                                                                <td class="tablehdr">Type</td>
                                                                                <td class="tablehdr" width="20%">Merchant</td>
                                                                                <td class="tablehdr" width="20%">New Merchant</td>
                                                                                <td class="tablehdr" width="20">&nbsp;</td>
                                                                            </tr>
                                                                            <%if (result != null && result.size() > 0) {

                Vector merchants = new Vector();
                String whereClause = DbMerchant.colNames[DbMerchant.COL_LOCATION_ID] + " = " + locationId;

                if (type == DbPayment.PAY_TYPE_CREDIT_CARD) {
                    whereClause = whereClause + " and " + DbMerchant.colNames[DbMerchant.COL_TYPE_PAYMENT] + " = " + DbMerchant.TYPE_CREDIT_CARD;
                } else if (type == DbPayment.PAY_TYPE_DEBIT_CARD) {
                    whereClause = whereClause + " and " + DbMerchant.colNames[DbMerchant.COL_TYPE_PAYMENT] + " = " + DbMerchant.TYPE_DEBIT_CARD;
                }else if (type == DbPayment.PAY_TYPE_FIF || type == DbPayment.PAY_TYPE_ADIRA) {
                    whereClause = whereClause + " and " + DbMerchant.colNames[DbMerchant.COL_TYPE_PAYMENT] + " = " + DbMerchant.TYPE_FINANCE;
                }
                merchants = DbMerchant.list(0, 0, whereClause, null);

                for (int x = 0; x < result.size(); x++) {
                    PayMerchant pm = (PayMerchant) result.get(x);
                    Merchant m = new Merchant();
                    String name = "";
                    try {
                        m = DbMerchant.fetchExc(pm.getMerchantId());
                        if (m.getTypePayment() == DbMerchant.TYPE_CREDIT_CARD) {
                            name = "Credit Card - " + m.getDescription();
                        } else if (m.getTypePayment() == DbMerchant.TYPE_DEBIT_CARD) {
                            name = "Debit Card - " + m.getDescription();
                        } else if (m.getTypePayment() == DbMerchant.TYPE_FINANCE) {
                            name = "Finance - "+m.getDescription();
                        }else{
                            name = ""+m.getDescription();
                        }
                    } catch (Exception e) {
                    }

                    


                                                                            %>
                                                                            <tr height="22">
                                                                                <td class="tablecell1" align="center"><%=pm.getNumber() %></td>
                                                                                <td class="tablecell1" align="center"><%=JSPFormater.formatDate(pm.getDate(), "dd MMM yyyy")%></td>
                                                                                <%if (pm.getPostedStatus() == 1) {%>
                                                                                <td class="fontarial" bgcolor="#E79191" align="center">POSTED</td>
                                                                                <%} else {%>
                                                                                <td class="tablecell1" align="center">-</td>
                                                                                <%}%>
                                                                                <td class="tablecell1">
                                                                                    <%if (pm.getPayType() == DbPayment.PAY_TYPE_CREDIT_CARD) {%>
                                                                                    Credit Card 
                                                                                    <%} else if(pm.getPayType() == DbPayment.PAY_TYPE_DEBIT_CARD) {%>
                                                                                    Debit Card
                                                                                    <%} else if(pm.getPayType() == DbPayment.PAY_TYPE_FIF || pm.getPayType() == DbPayment.PAY_TYPE_ADIRA){ %>
                                                                                    Finance
                                                                                    <%}%>
                                                                                    </td>
                                                                                <td class="tablecell1"><%=name%></td>
                                                                                <td class="tablecell1">
                                                                                    <select name="merchant_id<%=pm.getPaymentId()%>" class="fontarial">
                                                                                        <%if (merchants != null && merchants.size() > 0) {
                                                                                                    for (int z = 0; z < merchants.size(); z++) {
                                                                                                        Merchant mx = (Merchant) merchants.get(z);
                                                                                                        String namex = "";
                                                                                                        if (mx.getTypePayment() == DbMerchant.TYPE_CREDIT_CARD) {
                                                                                                            namex = "Credit Card - " + mx.getDescription();
                                                                                                        } else if (mx.getTypePayment() == DbMerchant.TYPE_DEBIT_CARD) {
                                                                                                            namex = "Debit Card - " + mx.getDescription();
                                                                                                        } else if (mx.getTypePayment() == DbMerchant.TYPE_FINANCE) {    
                                                                                                            namex = "Finance - " + mx.getDescription();
                                                                                                        } else {
                                                                                                            namex = mx.getDescription();
                                                                                                        }
                                                                                        %>
                                                                                        <option value="<%=mx.getOID()%>" <%if (mx.getOID() == pm.getMerchantId()) {%>selected<%}%>><%=namex.toUpperCase()%></option>
                                                                                        <%}
                                                                                                }%>
                                                                                    </select>   
                                                                                </td>
                                                                                <td class="tablecell1" align="center">
                                                                                    <%//if (pm.getPostedStatus() == 1) {%>
                                                                                    &nbsp;
                                                                                    <%//}else{%>
                                                                                    <input type="checkbox" name="ex<%=pm.getPaymentId()%>" value="1">
                                                                                    <%//}%>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr height="22">
                                                                                <td colspan="7">&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22">
                                                                                <td colspan="7">
                                                                                    <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/save2.gif',1)"><img src="../images/save.gif" name="post" border="0"></a>                                                                               
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22">
                                                                                <td colspan="7">&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22">
                                                                                <td colspan="7">&nbsp;</td>
                                                                            </tr>
                                                                            <%}%>
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
