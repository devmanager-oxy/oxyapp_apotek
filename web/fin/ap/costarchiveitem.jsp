
<%-- 
    Document   : costarchiveitem
    Created on : Apr 11, 2012, 4:40:28 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>

<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_COSTING_ARCHIVES, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(int iJSPCommand, JspCostingItem frmObject,
            CostingItem objEntity, Vector objectClass,
            long adjusmentItemId, String approot, long oidFromLocationId,
            int iErrCode2, String status, String langAR[]) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "25");
        jsplist.addHeader("" + langAR[5], "");
        jsplist.addHeader("" + langAR[7], "10%");
        jsplist.addHeader("" + langAR[10], "15%");
        jsplist.addHeader("" + langAR[11], "15%");

        jsplist.setLinkRow(-1);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

        Vector temp = new Vector();
        double total = 0;

        for (int i = 0; i < objectClass.size(); i++) {

            CostingItem costingItem = (CostingItem) objectClass.get(i);

            rowx = new Vector();
            if (adjusmentItemId == costingItem.getOID()) {
                index = i;
            }

            ItemMaster itemMaster = new ItemMaster();
            ItemGroup ig = new ItemGroup();
            ItemCategory ic = new ItemCategory();
            try {
                itemMaster = DbItemMaster.fetchExc(costingItem.getItemMasterId());
                ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
            rowx.add(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
            rowx.add("<div align=\"center\">" + costingItem.getQty() + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(costingItem.getPrice(), "#,###.##") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(costingItem.getQty() * costingItem.getPrice(), "#,###.##") + "</div>");
            total = total + (costingItem.getQty() * costingItem.getPrice());

            lstData.add(rowx);
        }

        rowx = new Vector();

        lstData.add(rowx);

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        v.add(""+total);
        return v;
    }
%>
<%
        

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCosting = JSPRequestValue.requestLong(request, "hidden_costing_id");

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidCosting = 0;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdCosting cmdCosting = new CmdCosting(request);
            JSPLine ctrLine = new JSPLine();
            iErrCode = cmdCosting.action(iJSPCommand, oidCosting);
            JspCosting JspCosting = cmdCosting.getForm();
            Costing costing = cmdCosting.getCosting();
            msgString = cmdCosting.getMessage();

            RptAdjustment rptKonstan = new RptAdjustment();

            if (oidCosting == 0) {
                oidCosting = costing.getOID();
                costing.setStatus(I_Project.DOC_STATUS_DRAFT);
            }
%>	
<%
            long oidCostingItem = JSPRequestValue.requestLong(request, "hidden_costing_item_id");
            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            CmdCostingItem cmdCostingItem = new CmdCostingItem(request);

            iErrCode2 = cmdCostingItem.action(iJSPCommand, oidCostingItem, oidCosting, 0);
            JspCostingItem jspCostingItem = cmdCostingItem.getForm();
            CostingItem costingItem = cmdCostingItem.getCostingItem();
            msgString2 = cmdCostingItem.getMessage();

            whereClause = DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID] + "=" + oidCosting;
            orderClause = DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID];
            Vector costingItems = DbCostingItem.list(0, 0, whereClause, orderClause);
            

            Vector locations = DbLocation.list(0, 0, "", "code");
            if (costing.getLocationId() == 0 && locations != null && locations.size() > 0) {
                Location lxx = (Location) locations.get(0);
                costing.setLocationId(lxx.getOID());
            }

            String[] langAR = {"Number", "Date", "Location", "Doc. Status", "Notes", "Group/Category/Code - Name", "Qty System", "Qty", // 0-7
                "Balance", "Unit", "@ Price", "Total Amount", "Total"}; // 8 - 12
            String[] langNav = {"Journal", "Costing - Detail", "Posting", "Detail", "Search Parameters"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor", "Tanggal", "Lokasi", "Status Dok.", "Memo", "Grup/Kategori/Kode - Nama", "Qty Sistem", "Qty", //0 - 7
                    "Balance", "Satuan", "@ Harga", "Jum. Total", "Total"}; //8-12
                langAR = langID;

                String[] navID = {"Jurnal", "Costing - Detail", "Posting", "Detail", "Parameter Pencarian"};
                langNav = navID;
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=systemTitle%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        <!--
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
       
                
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
                        }
                        else{
                            if(xx==',' || xx=='.'){
                                result = result + xx;
                            }
                        }
                    }
                    return result;
                }
                
                function cmdBack(){
                    document.frmcosting.command.value="<%=JSPCommand.NONE%>";
                    document.frmcosting.action="costarchive.jsp";
                    document.frmcosting.submit();
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
                
                function MM_swapImage() { //v3.0
                    var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                    if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                }
                
                function MM_findObj(n, d) { //v4.01
                    var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                    if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                    for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                    if(!x && d.getElementById) x=d.getElementById(n); return x;
                }
                //-->
    </script>
    
    <!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
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
                        <td><!-- #BeginEditable "content" --> 
                            <form name="frmcosting" method ="post" action="">
                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                            <input type="hidden" name="start" value="0">
                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                            <input type="hidden" name="<%=JspCosting.colNames[JspCosting.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                            <input type="hidden" name="hidden_costing_item_id" value="<%=oidCostingItem%>">
                            <input type="hidden" name="hidden_costing_id" value="<%=oidCosting%>">
                            <input type="hidden" name="<%=JspCostingItem.colNames[JspCostingItem.JSP_COSTING_ID]%>" value="<%=oidCosting%>">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                    <td valign="top"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                            <tr valign="bottom"> 
                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">&nbsp;<%=langNav[0]%> 
                                                </font><font class="tit1">&raquo; <span class="lvl2"><%=langNav[1]%></span></font></b></td>
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
                                            <tr> 
                                                <td height="10"></td>
                                            </tr>
                                            <tr> 
                                                <td> 
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" colspan="3"> 
                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <tr align="left"> 
                                                                    <td colspan="5">
                                                                        <table border="0" cellpadding="1" cellspacing="1" width="500">                                                                                                                                        
                                                                            <tr>                                                                                                                                            
                                                                                <td class="tablecell1" >                                                                                                            
                                                                                    <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                        <tr align="left" >
                                                                                            <td colspan="5" class="fontarial" height="5"></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td width="60" class="fontarial">&nbsp;&nbsp;<%=langAR[0]%></td>
                                                                                            <td width="220" class="fontarial">:&nbsp;<%=costing.getNumber()%></td>
                                                                                            <td class="fontarial"><%=langAR[1]%></td>
                                                                                            <td colspan="2" class="fontarial">:&nbsp;<%=JSPFormater.formatDate(costing.getDate(), "dd/MM/yyyy")%></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td class="fontarial">&nbsp;&nbsp;<%=langAR[2]%></td>
                                                                                            <td class="fontarial"> 
                                                                                                <%
            String loc = "";
            try {
                Location locx = DbLocation.fetchExc(costing.getLocationId());
                loc = locx.getName();
            } catch (Exception e) {
            }
                                                                                                %>
                                                                                                :&nbsp;<%=loc%>
                                                                                            </td>
                                                                                            <td class="fontarial"><%=langAR[3]%></td>
                                                                                            <td colspan="2" class="fontarial">:&nbsp;
                                                                                                <%
            if (costing.getStatus() == null) {
                costing.setStatus(I_Project.DOC_STATUS_DRAFT);
            }
                                                                                                %>
                                                                                                <%=(costing.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((costing.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : costing.getStatus())%>
                                                                                            </td>
                                                                                        </tr>                                                                                                                        
                                                                                        <tr align="left" > 
                                                                                            <td class="fontarial">&nbsp;&nbsp;<%=langAR[4]%></td>
                                                                                            <td colspan="4" class="fontarial">:&nbsp;<%=costing.getNote()%></td>
                                                                                        </tr>
                                                                                        <tr align="left" >
                                                                                            <td colspan="5" class="fontarial" height="5"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                            </td>
                                                        </tr>       
                                                        
                                                        <%
            rptKonstan.setNotes(costing.getNote());
                                                        %>
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top">&nbsp;</td>
                                                        </tr>
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top"> 
                                                                &nbsp; 
                                                                <%
            Vector x = drawList(iJSPCommand, jspCostingItem, costingItem, costingItems, oidCostingItem, approot, costing.getLocationId(), iErrCode2, costing.getStatus(), langAR);
            String strString = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
            double total = 0;
            try{
                total = Double.parseDouble(""+ x.get(2));
            }catch(Exception e){}
                                                                %>
                                                                <%=strString%> 
                                                                <% session.putValue("DETAIL", rptObj);%>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top"> 
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr> 
                                                                        <td colspan="3" height="5"></td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td colspan="3" height="5"></td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td width="45%" valign="middle"></td>
                                                                        <td width="55%" colspan="2"> 
                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                <tr> 
                                                                                    <td width="60%"> 
                                                                                        <div align="right" class="fontarial"><b><%=langAR[12]%></b></div>
                                                                                    </td>
                                                                                    <td width="17%"></td>         
                                                                                    <td width="23%" class="fontarial" align="right"><b><%=JSPFormater.formatNumber(total, "#,###.##")%></b></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr> 
                                                            <td colspan="5" height="5">
                                                                <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','../images/back2.gif',1)"><img src="../images/back.gif" name="cancel" height="22" border="0"></a>                                                                                                            
                                                            </td>
                                                        </tr>                                                        
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top" height="25">&nbsp;</td>
                                                        </tr>
                                                        <%if (costing.getOID() != 0) {%>
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top"> 
                                                                <table width="32%" border="0" cellspacing="1" cellpadding="1">
                                                                    <tr> 
                                                                        <td width="33%" class="tablecell1"><b><i>Document 
                                                                        History</i></b></td>
                                                                        <td width="34%" class="tablecell1"> 
                                                                            <div align="center"><b><i>User</i></b></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell1"> 
                                                                            <div align="center"><b><i>Date</i></b></div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td width="33%" class="tablecell1"><i>Prepared 
                                                                        By</i></td>
                                                                        <td width="34%" class="tablecell1"> 
                                                                            <div align="left"> <i> 
                                                                                    <%
    User u = new User();
    try {
        u = DbUser.fetch(costing.getUserId());
    } catch (Exception e) {
    }
                                                                                    %>
                                                                            <%=u.getLoginId()%></i></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell1"> 
                                                                            <div align="center"><i><%=JSPFormater.formatDate(costing.getDate(), "dd MMMM yy")%></i></div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td width="33%" class="tablecell1"><i>Approved 
                                                                        by</i></td>
                                                                        <td width="34%" class="tablecell1"> 
                                                                            <div align="left"> <i> 
                                                                                    <%
    u = new User();
    try {
        u = DbUser.fetch(costing.getApproval1());
    } catch (Exception e) {
    }
                                                                                    %>
                                                                            <%=u.getLoginId()%></i></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell1"> 
                                                                            <%if(costing.getApproval1() !=0){%>
                                                                            <div align="center"> <i><%=JSPFormater.formatDate(costing.getEffectiveDate(), "dd MMMM yy")%> </i></div>
                                                                            <%}%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td width="33%" class="tablecell1"><i>Posted by</i></td>
                                                                        <td width="34%" class="tablecell1"> 
                                                                            <div align="left"> <i> 
                                                                                    <%
    u = new User();
    try {
        u = DbUser.fetch(costing.getPostedById());
    } catch (Exception e) {
    }
                                                                                    %>
                                                                            <%=u.getLoginId()%></i></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell1"> 
                                                                            <%if(costing.getPostedById() != 0 && costing.getPostedDate() != null){%>
                                                                            <div align="center"> <i><%=JSPFormater.formatDate(costing.getPostedDate(), "dd MMMM yy")%> </i></div>
                                                                            <%}%>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <%}%>
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top">&nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr> 
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                
                
                <%

                %>
                </form>
                <%
            session.putValue("KONSTAN", rptKonstan);
                %>
                <span class="level2"><br>
                </span><!-- #EndEditable -->
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

