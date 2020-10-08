<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, int start) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("85%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("No", "5%");
        cmdist.addHeader("Code/SKU", "15%");
        cmdist.addHeader("Barcode", "15%");
        cmdist.addHeader("Item Name", "40%");
        cmdist.addHeader("Stock Standart", "10%");
        cmdist.addHeader("Delivery Unit", "10%");

        cmdist.setLinkRow(-1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        Vector temp = new Vector();

        //double totalamount = 0.0;

        for (int i = 0; i < objectClass.size(); i++) {
            StockMinItem ss = (StockMinItem) objectClass.get(i);
            ItemMaster im = new ItemMaster();
            try {
                im = DbItemMaster.fetchExc(ss.getItemMasterId());
            } catch (Exception ex) {

            }

            Vector rowx = new Vector();


            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");

            rowx.add("" + im.getCode());
            rowx.add("" + im.getBarcode());
            rowx.add("" + im.getName());
            rowx.add("<div align=\"right\">" + ss.getMinStock() + "</div>");
            rowx.add("<div align=\"right\">" + im.getDeliveryUnit() + "</div>");


            lstData.add(rowx);

            lstLinkData.add(String.valueOf(-1));
        }





        return cmdist.draw(index);


    }

%>
<%

            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }



           // Vector vlocFrom = DbLocation.list(0, 0, "", "name");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long srcGroupId = JSPRequestValue.requestLong(request, "src_group");
            long srcCategoryId = JSPRequestValue.requestLong(request, "src_category");
            long srcFromLocationId = JSPRequestValue.requestLong(request, "src_fromlocation_id");
            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");

            Vector locations = userLocations;


            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            
            if(iJSPCommand == JSPCommand.NONE){
                 try{
                    Location d = (Location) locations.get(0);
                    srcFromLocationId = d.getOID();
                }catch(Exception e){}
            }

            JSPLine ctrLine = new JSPLine();
            Vector listStock = new Vector(1, 1);

            if (srcFromLocationId != 0) {
                whereClause = whereClause + DbStockMin.colNames[DbStockMin.COL_LOCATION_ID] + "=" + srcFromLocationId + " and min_stock > 0";
            } else {
                Location loc = (Location) locations.get(0);
                srcFromLocationId = loc.getOID();
                whereClause = whereClause + DbStockMin.colNames[DbStockMin.COL_LOCATION_ID] + "=" + loc.getOID() + " and min_stock > 0";
            }

            Vector vkonstan = new Vector();
            vkonstan.add(srcCategoryId);
            vkonstan.add(srcGroupId);
            vkonstan.add(srcVendorId);
            vkonstan.add(srcFromLocationId);
            session.putValue("KONSTAN", vkonstan);

            int vectSize = DbStockMin.getCount(srcCategoryId, srcGroupId, srcVendorId, srcFromLocationId);

            CmdStockMin cmdStockMin = new CmdStockMin(request);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdStockMin.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            listStock = DbStockMin.listByParameter(start, recordToGet, srcCategoryId, srcGroupId, srcVendorId, srcFromLocationId);

            if (listStock.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listStock = DbStockMin.listByParameter(start, recordToGet, srcCategoryId, srcGroupId, srcVendorId, srcFromLocationId);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RptStockStandar?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdSearch(){
                    document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
                    document.frmadjusment.action="reportstockstandar.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListFirst(){
                    document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmadjusment.action="reportstockstandar.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListPrev(){
                    document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmadjusment.action="reportstockstandar.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListNext(){
                    document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmadjusment.action="reportstockstandar.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListLast(){
                    document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmadjusment.action="reportstockstandar.jsp";
                    document.frmadjusment.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif','../images/print2.gif')">
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmadjusment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Report 
                                                                                        </font><font class="tit1">&raquo; </font><font color="#990000" class="lvl1">Standart Stock 
                                                                                        </font><font class="tit1">&raquo; 
                                                                                <span class="lvl2">By Location</span></font></b></td>
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
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="5"  colspan="3"></td>
                                                                            </tr>
                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="2"><b><i>Search Parameters 
                                                                                                        :</i></b></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="9%">Location</td>
                                                                                                        <td width="91%"> 
                                                                                                            <select name="src_fromlocation_id">
                                                                                                                <%
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);

                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcFromLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="5%">Group</td>
                                                                                                        <td width="11%"> 
                                                                                                            <%
            Vector groupsx = DbItemGroup.list(0, 0, "", "name");
                                                                                                            %>
                                                                                                            <select name="src_group">
                                                                                                                <option value="0" <%if (srcGroupId == 0) {%>selected<%}%>>All 
                                                                                                                        ..</option>
                                                                                                                <%if (groupsx != null && groupsx.size() > 0) {
                for (int i = 0; i < groupsx.size(); i++) {
                    ItemGroup ig = (ItemGroup) groupsx.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=ig.getOID()%>" <%if (srcGroupId == ig.getOID()) {%>selected<%}%>><%=ig.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>       
                                                                                                    <tr>
                                                                                                        <td width="5%">Category</td>
                                                                                                        <td width="11%"> 
                                                                                                            <%
            Vector categoryx = DbItemCategory.list(0, 0, "", "name");
                                                                                                            %>
                                                                                                            <select name="src_category">
                                                                                                                <option value="0" <%if (srcCategoryId == 0) {%>selected<%}%>>All 
                                                                                                                        ..</option>
                                                                                                                <%if (categoryx != null && categoryx.size() > 0) {
                for (int i = 0; i < categoryx.size(); i++) {
                    ItemCategory ic = (ItemCategory) categoryx.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=ic.getOID()%>" <%if (srcCategoryId == ic.getOID()) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td> 
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="5%">Vendor</td>
                                                                                                        <td width="11%">
                                                                                                            <select name="src_vendor_id">
                                                                                                                <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>>- 
                                                                                                                        All -</option>
                                                                                                                <%

            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor d = (Vendor) vendors.get(i);
                    String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcVendorId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="9%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        <td width="91%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="9%">&nbsp;</td>
                                                                                                        <td width="91%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                                        <%=drawList(listStock, start)%> </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        
                                                                                        
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
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();

            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (listStock.size() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
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