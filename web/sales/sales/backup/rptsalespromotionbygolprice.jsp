
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>  
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %> 
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %> 
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean masterPriv = true;
            boolean masterPrivView = true;
            boolean masterPrivUpdate = true;
%>
<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_COGS") != null) {
                session.removeValue("REPORT_COGS");
            }

            JSPLine jspLine = new JSPLine();
            int start = JSPRequestValue.requestInt(request, "start");
            int recordToGet = JSPRequestValue.requestInt(request, "src_diplay_limit");
            String strdate1 = JSPRequestValue.requestString(request, "start_date");
            String strdate2 = JSPRequestValue.requestString(request, "end_date");
            Date startDate = (strdate1 == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date endDate = (strdate2 == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            int chkInvDate = 0;
            String golPrice = JSPRequestValue.requestString(request, "src_gol_price");
            int sortBy = JSPRequestValue.requestInt(request, "src_sort_by");
            String srcGroupCat = JSPRequestValue.requestString(request, "src_group_cat");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int sortType = JSPRequestValue.requestInt(request, "src_sort_type");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");


//hanya untuk start   
            int vectSize = 0;

            Vector result = new Vector();

            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV ||
                    iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST) {

                vectSize = SessCogsBySection.getCountSalesPromotionReport(startDate, endDate, srcGroupCat, golPrice, locationId);

                CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
                start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);

                result = SessCogsBySection.getSalesPromotionReport(start, recordToGet, startDate, endDate, srcGroupCat, golPrice, locationId, sortBy, sortType);

                Vector rptParam = new Vector();
                rptParam.add(startDate);
                rptParam.add(endDate);
                rptParam.add(golPrice);
                rptParam.add(srcGroupCat);
                rptParam.add("" + sortBy);
                rptParam.add("" + sortType);
                rptParam.add("" + locationId);
                session.putValue("REPORT_PROMO_GOL_PRICE", rptParam);
                session.putValue("REPORT_PROMO_GOL_PRICE_USER", user.getLoginId());

            }

//out.println(result); 

%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Sales System</title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!masterPriv || !masterPrivView) {%>
            window.location="<%=approot%>/nopriv.jsp"; 
            <%}%>
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptSalesPromotionByGolPriceXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmsales.action="rptsalespromotionbygolprice.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsales.submit();
                }
                
                function cmdListFirst(){
                    document.frmsales.command.value="<%=JSPCommand.FIRST%>";
                    document.frmsales.action="rptsalespromotionbygolprice.jsp";
                    document.frmsales.submit();
                }
                
                function cmdListPrev(){
                    document.frmsales.command.value="<%=JSPCommand.PREV%>";
                    document.frmsales.action="rptsalespromotionbygolprice.jsp";
                    document.frmsales.submit();
                }
                
                function cmdListNext(){
                    document.frmsales.command.value="<%=JSPCommand.NEXT%>";
                    document.frmsales.action="rptsalespromotionbygolprice.jsp";
                    document.frmsales.submit();
                }
                
                function cmdListLast(){
                    document.frmsales.command.value="<%=JSPCommand.LAST%>";
                    document.frmsales.action="rptsalespromotionbygolprice.jsp";
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
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                                        <!-- #EndEditable --> </td>
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
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                            
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                                                                                                                                                                                        
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                                            
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                                                                                                        Report </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Sales 
                                                                                                                                                Promotion by Gol 
                                                                                                                                                Price<br>
                                                                                                                                </span></font></b></td>
                                                                                                                                <td width="40%" height="23"> 
                                                                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr > 
                                                                                                                                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="9%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="9%" height="22" nowrap>Promotion 
                                                                                                                                            Between</td>
                                                                                                                                            <td colspan="3" height="22"> 
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr> 
                                                                                                                                                        <td > 
                                                                                                                                                            <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td> &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                                                                                                                        </td>
                                                                                                                                                        <td> 
                                                                                                                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td width="9%" height="22">Location</td>
                                                                                                                                            <td colspan="2" height="22">
                                                                                                                                                <%
            Vector locs = userLocations;
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id">
                                                                                                                                                    <%if (locs.size() == totLocationxAll) {%>
                                                                                                                                                    <option value="0"> - All Location -</option>
                                                                                                                                                    <%}%>
                                                                                                                                                    <%if (locs != null && locs.size() > 0) {
                for (int i = 0; i < locs.size(); i++) {
                    Location l = (Location) locs.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=l.getOID()%>" <%if (l.getOID() == locationId) {%>selected<%}%>><%=l.getName()%></option>
                                                                                                                                                    <%	}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="9%" height="22">Gol 
                                                                                                                                            Price </td>
                                                                                                                                            <td colspan="2" height="22"> 
                                                                                                                                                <%
            Vector golP = SessCogsBySection.getAvailableGolPrice();
                                                                                                                                                %>
                                                                                                                                                <select name="src_gol_price">
                                                                                                                                                    <%if (golP != null && golP.size() > 0) {
                for (int i = 0; i < golP.size(); i++) {
                    String usx = (String) golP.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=usx%>" <%if (usx.equals(golPrice)) {%>selected<%}%>><%=usx.toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="9%" height="22">Group 
                                                                                                                                            &amp; Category</td>
                                                                                                                                            <td colspan="2" height="22"> 
                                                                                                                                                <%
            Vector tempGroup = DbItemGroup.list(0, 0, "", "name");
                                                                                                                                                %>
                                                                                                                                                <select name="src_group_cat">
                                                                                                                                                    <option value="0,0" <%if (srcGroupCat.equals("0,0")) {%>selected<%}%>>--All-- 
                                                                                                                                                            &amp; --All--</option>
                                                                                                                                                    <%if (tempGroup != null && tempGroup.size() > 0) {
                for (int i = 0; i < tempGroup.size(); i++) {
                    ItemGroup ig = (ItemGroup) tempGroup.get(i);
                    Vector cats = DbItemCategory.list(0, 0, "", "name");
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ig.getOID()%>,0" <%if (srcGroupCat.equals(ig.getOID() + ",0")) {%>selected<%}%>><%=ig.getName()%> 
                                                                                                                                                            &amp; ---All---</option>
                                                                                                                                                    <%
                                                                                                                                                        if (cats != null && cats.size() > 0) {
                                                                                                                                                            for (int x = 0; x < cats.size(); x++) {
                                                                                                                                                                ItemCategory ic = (ItemCategory) cats.get(x);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ig.getOID()%>,<%=ic.getOID()%>" <%if (srcGroupCat.equals(ig.getOID() + "," + ic.getOID())) {%>selected<%}%>><%=ig.getName()%> 
                                                                                                                                                            &amp; <%=ic.getName()%></option>
                                                                                                                                                    <%
                        }
                    }
                }
            }
                                                                                                                                                    %>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="9%" height="22">Order 
                                                                                                                                            By </td>
                                                                                                                                            <td width="30%" height="22"> 
                                                                                                                                                <select name="src_sort_by">
                                                                                                                                                    <option value="0" <%if (sortBy == 0) {%>selected<%}%>>Item 
                                                                                                                                                            Code</option>
                                                                                                                                                    <option value="1" <%if (sortBy == 1) {%>selected<%}%>>Item 
                                                                                                                                                            Name</option>
                                                                                                                                                    <option value="2" <%if (sortBy == 2) {%>selected<%}%>>Sales 
                                                                                                                                                            Qty</option>
                                                                                                                                                    <option value="3" <%if (sortBy == 3) {%>selected<%}%>>Sales 
                                                                                                                                                            Amount</option>
                                                                                                                                                </select>
                                                                                                                                                <select name="src_sort_type">
                                                                                                                                                    <option value="0" <%if (sortType == 0) {%>selected<%}%>>Asc</option>
                                                                                                                                                    <option value="1" <%if (sortType == 1) {%>selected<%}%>>Desc</option>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="61%" height="22">&nbsp; 
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="9%" height="22">Max 
                                                                                                                                            List Display</td>
                                                                                                                                            <td width="30%" height="22"> 
                                                                                                                                                <select name="src_diplay_limit">
                                                                                                                                                    <option value="100" <%if (recordToGet == 100) {%>selected<%}%>>100</option>
                                                                                                                                                    <option value="500" <%if (recordToGet == 500) {%>selected<%}%>>500</option>
                                                                                                                                                    <option value="1000" <%if (recordToGet == 1000) {%>selected<%}%>>1000</option>
                                                                                                                                                    <option value="1500" <%if (recordToGet == 1500) {%>selected<%}%>>1500</option>
                                                                                                                                                    <option value="2000" <%if (recordToGet == 2000) {%>selected<%}%>>2000</option>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="61%" height="22">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="9%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td width="30%" height="33">&nbsp;</td>
                                                                                                                                            <td width="61%" height="33">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="9%" height="15">&nbsp;</td>
                                                                                                                                            <td width="30%" height="15">&nbsp; 
                                                                                                                                            </td>
                                                                                                                                            <td width="61%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
            if (result != null && result.size() > 0) {
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td width="6%">&nbsp;</td>
                                                                                                                                            <td width="18%">&nbsp;</td>
                                                                                                                                            <td colspan="2" class="tablehdr"><font size="1">Period 
                                                                                                                                                    Promotion 
                                                                                                                                            </font><font size="1"></font></td>
                                                                                                                                            <td colspan="2" class="tablehdr"><font size="1">Promotion</font></td>
                                                                                                                                            <td width="4%">&nbsp;</td>
                                                                                                                                            <td class="tablehdr" colspan="2"><font size="1">Sales 
                                                                                                                                            Promotion</font></td>
                                                                                                                                            <td width="8%">&nbsp;</td>
                                                                                                                                            <td class="tablehdr" colspan="2"><font size="1">Stock</font></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablehdr" width="6%" nowrap><font size="1">SKU</font></td>
                                                                                                                                            <td class="tablehdr" width="18%" nowrap ><font size="1">Item</font></td>
                                                                                                                                            <td class="tablehdr" width="8%" nowrap><font size="1">Start 
                                                                                                                                            Date </font></td>
                                                                                                                                            <td class="tablehdr" width="8%" nowrap><font size="1">End 
                                                                                                                                            Date </font></td>
                                                                                                                                            <td class="tablehdr" width="7%" nowrap><font size="1">Cogs</font></td>
                                                                                                                                            <td class="tablehdr" width="8%" nowrap><font size="1">Selling 
                                                                                                                                            Price </font></td>
                                                                                                                                            <td class="tablehdr" width="4%" nowrap><font size="1">Margin</font></td>
                                                                                                                                            <td class="tablehdr" width="5%" nowrap><font size="1">Qty</font></td>
                                                                                                                                            <td class="tablehdr" width="8%" nowrap><font size="1">Amount</font></td>
                                                                                                                                            <td class="tablehdr" width="8%" nowrap><font size="1">Profit</font></td>
                                                                                                                                            <td class="tablehdr" width="4%" nowrap><font size="1">Qty</font></td>
                                                                                                                                            <td class="tablehdr" width="10%" nowrap><font size="1">Amount</font></td>
                                                                                                                                        </tr>
                                                                                                                                        <%

                                                                                                                                for (int i = 0; i < result.size(); i++) {
                                                                                                                                    Vector v = (Vector) result.get(i);
                                                                                                                                    String sku = (String) v.get(1);
                                                                                                                                    String itemName = (String) v.get(3);
                                                                                                                                    double cogs = Double.parseDouble((String) v.get(4));
                                                                                                                                    double lastPrice = Double.parseDouble((String) v.get(11));
                                                                                                                                    double selingPrice = Double.parseDouble((String) v.get(12));
                                                                                                                                    double margin = (lastPrice > 0) ? ((selingPrice - cogs) / cogs) * 100 : 0;
                                                                                                                                    double stock = Double.parseDouble((String) v.get(14));
                                                                                                                                    double stockAmount = stock * cogs;
                                                                                                                                    Date stDate = JSPFormater.formatDate((String) v.get(7), "yyyy-MM-dd");
                                                                                                                                    Date enDate = JSPFormater.formatDate((String) v.get(8), "yyyy-MM-dd");
                                                                                                                                    double qty = Double.parseDouble((String) v.get(5));
                                                                                                                                    double omset = Double.parseDouble((String) v.get(6));
                                                                                                                                    double hpp = Double.parseDouble((String) v.get(16));
                                                                                                                                    selingPrice = omset / qty;
                                                                                                                                    //double monthQty = Double.parseDouble((String)v.get(13));
                                                                                                                                    //double monthSales = Double.parseDouble((String)v.get(14));
                                                                                                                                    //double weekQty = Double.parseDouble((String)v.get(15));
                                                                                                                                    //double weekSales = Double.parseDouble((String)v.get(16));

                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell" align="center" width="6%" nowrap><font size="1"><%=sku%></font></td>
                                                                                                                                            <td class="tablecell" align="left" width="18%" nowrap><font size="1"><%=itemName%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="8%" nowrap> 
                                                                                                                                                <div align="center"><%=JSPFormater.formatDate(stDate, "dd-MM-yyyy")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell" align="right" width="8%" nowrap> 
                                                                                                                                                <div align="center"><%=JSPFormater.formatDate(enDate, "dd-MM-yyyy")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell" align="right" width="7%" nowrap><font size="1"><%=JSPFormater.formatNumber(cogs, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber(selingPrice, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="4%" nowrap><font size="1"><%=JSPFormater.formatNumber(((selingPrice - cogs) / cogs) * 100, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="5%" nowrap><font size="1"><%=JSPFormater.formatNumber(qty, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber(omset, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber((omset - (hpp)), "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="4%" nowrap><font size="1"><%=JSPFormater.formatNumber(stock, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="10%" nowrap><font size="1"><%=JSPFormater.formatNumber(stockAmount, "#,###.##")%></font></td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="12" height="25"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="12"><span class="command"> 
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
                                                                                                                                                    <% jspLine.setLocationImg(approot + "/images/ctr_line");
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
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top">  
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp; 
                                                                                                                                    
                                                                                                                                </td>     
                                                                                                                            </tr> 
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr>     
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                                                    </td>
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
                        <tr> 
                            <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

