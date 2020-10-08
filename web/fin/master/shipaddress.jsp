
<%
            /***********************************|
            |  Create by Dek-Ndut               |
            |                                   |
            |  12/3/2007 10:41:32 AM
            |***********************************/
%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long shipAddressOid, String approot, int start, int recordToGet, String[] lang) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader(lang[2], "20%");
        jsplist.addHeader(lang[3], "20%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        jsplist.setLinkPrefix("javascript:cmdEdit('");
        jsplist.setLinkSufix("')");
        jsplist.reset();
        int index = -1;

        int loopInt = 0;
        if (CONHandler.CONSVR_TYPE == CONHandler.CONSVR_MSSQL) {
            if ((start + recordToGet) > objectClass.size()) {
                loopInt = recordToGet - ((start + recordToGet) - objectClass.size());
            } else {
                loopInt = recordToGet;
            }
        } else {
            start = 0;
            loopInt = objectClass.size();
        }

        int count = 0;
        for (int i = start; (i < objectClass.size() && count < loopInt); i++) {
            count = count + 1;
            ShipAddress objShipAddress = (ShipAddress) objectClass.get(i);
            Vector rowx = new Vector();
            if (shipAddressOid == objShipAddress.getOID()) {
                index = i;
            }

            rowx.add(objShipAddress.getName());
            rowx.add(objShipAddress.getAddress());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(objShipAddress.getOID()));
        }
        return jsplist.draw(index);
    }
%>
<%
            int iCommand = JSPRequestValue.requestCommand(request);
//if(iCommand==JSPCommand.NONE)
//{
//	iCommand = JSPCommand.ADD;
//}

            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidShipAddress = JSPRequestValue.requestLong(request, "hidden_shipaddress");

// variable declaration
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdShipAddress cmdShipAddress = new CmdShipAddress(request);
            JSPLine jspLine = new JSPLine();
            Vector listShipAddress = new Vector(1, 1);

// switch statement
            iErrCode = cmdShipAddress.action(iCommand, oidShipAddress);

// end switch
            JspShipAddress jspShipAddress = cmdShipAddress.getForm();

// count list All ShipAddress
            int vectSize = DbShipAddress.getCount(whereClause);

//recordToGet = vectSize;

//out.println(jspShipAddress.getErrors());

            ShipAddress shipAddress = cmdShipAddress.getShipAddress();
            msgString = cmdShipAddress.getMessage();
//out.println(msgString);

// switch list ShipAddress
//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
//{
//	start = DbShipAddress.generateFindStart(shipAddress.getOID(),recordToGet, whereClause);
//}

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                start = cmdShipAddress.actionList(iCommand, start, vectSize, recordToGet);
            }

// get record to display
            listShipAddress = DbShipAddress.list(start, recordToGet, whereClause, orderClause);

// handle condition if size of record to display = 0 and start > 0 	after delete
            if (listShipAddress.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } else {
                    start = 0;
                    iCommand = JSPCommand.FIRST;
                    prevCommand = JSPCommand.FIRST;
                }
                listShipAddress = DbShipAddress.list(start, recordToGet, whereClause, orderClause);
            }

//if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0)
//{
//	iCommand = JSPCommand.ADD;
//	shipAddress = new ShipAddress();
//	oidShipAddress = 0;
//}

            /*** LANG ***/
            String[] langMD = {"Masterdata", "Shipping Address", "Name", "Address"}; //0-1
            if (lang == LANG_ID) {
                String[] langID = {"Data Induk", "Alamat Pengiriman", "Nama", "Alamat"}; //0-1
                langMD = langID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmshipaddress.hidden_shipaddress.value="0";
                document.frmshipaddress.command.value="<%=JSPCommand.ADD%>";
                document.frmshipaddress.prev_command.value="<%=prevCommand%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdAsk(oidShipAddress){
                document.frmshipaddress.hidden_shipaddress.value=oidShipAddress;
                document.frmshipaddress.command.value="<%=JSPCommand.ASK%>";
                document.frmshipaddress.prev_command.value="<%=prevCommand%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdDelete(oidShipAddress){
                document.frmshipaddress.hidden_shipaddress.value=oidShipAddress;
                document.frmshipaddress.command.value="<%=JSPCommand.ASK%>";
                document.frmshipaddress.prev_command.value="<%=prevCommand%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdConfirmDelete(oidShipAddress){
                document.frmshipaddress.hidden_shipaddress.value=oidShipAddress;
                document.frmshipaddress.command.value="<%=JSPCommand.DELETE%>";
                document.frmshipaddress.prev_command.value="<%=prevCommand%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdSave(){
                document.frmshipaddress.command.value="<%=JSPCommand.SAVE%>";
                document.frmshipaddress.prev_command.value="<%=prevCommand%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdEdit(oidShipAddress){
                <%if (privUpdate) {%>
                document.frmshipaddress.hidden_shipaddress.value=oidShipAddress;
                document.frmshipaddress.command.value="<%=JSPCommand.EDIT%>";
                document.frmshipaddress.prev_command.value="<%=prevCommand%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
                <%}%>
            }
            
            function cmdCancel(oidShipAddress){
                document.frmshipaddress.hidden_shipaddress.value=oidShipAddress;
                document.frmshipaddress.command.value="<%=JSPCommand.EDIT%>";
                document.frmshipaddress.prev_command.value="<%=prevCommand%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdBack(){
                document.frmshipaddress.command.value="<%=JSPCommand.BACK%>";
                //document.frmshipaddress.hidden_shipaddress.value="0";
                //document.frmshipaddress.command.value="<%//=JSPCommand.ADD%>//";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdListFirst(){
                document.frmshipaddress.command.value="<%=JSPCommand.FIRST%>";
                document.frmshipaddress.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdListPrev(){
                document.frmshipaddress.command.value="<%=JSPCommand.PREV%>";
                document.frmshipaddress.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdListNext(){
                document.frmshipaddress.command.value="<%=JSPCommand.NEXT%>";
                document.frmshipaddress.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
            }
            
            function cmdListLast(){
                document.frmshipaddress.command.value="<%=JSPCommand.LAST%>";
                document.frmshipaddress.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmshipaddress.action="shipaddress.jsp";
                document.frmshipaddress.submit();
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
                  <%@ include file="../main/menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langMD[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langMD[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <!--Begin Region Content-->
                                                        <form name="frmshipaddress" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_shipaddress" value="<%=oidShipAddress%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left"> 
                                                                                <td height="8" valign="top" colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                                <td height="8"  colspan="3" valign="top"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <%
            try {
                if (listShipAddress != null && listShipAddress.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td class="boxed1"><%=drawList(listShipAddress, oidShipAddress, approot, start, recordToGet, langMD)%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                }
            } catch (Exception exc) {
            }
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"> 
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
                                                                                            <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="15" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            if (iCommand != JSPCommand.EDIT && iCommand != JSPCommand.ADD && iCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"><%if (privAdd) {%><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a><%}%></td>
                                                                                        </tr>
                                                                                        <%
            }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="2%" height="8" valign="top">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                                <td height="8" valign="top" colspan="3"><br>
                                                                                    <%if ((iCommand == JSPCommand.ADD) || (iCommand == JSPCommand.SAVE) && (jspShipAddress.errorSize() > 0) || (iCommand == JSPCommand.EDIT) || (iCommand == JSPCommand.ASK)) {%>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="9%">&nbsp;<%=langMD[2]%></td>
                                                                                        <td height="21" width="1%">&nbsp; 
                                                                                        <td height="21" colspan="2" width="90%"> 
                                                                                        <input type="text" name="<%=jspShipAddress.colNames[jspShipAddress.JSP_NAME] %>"  value="<%= shipAddress.getName() %>" class="formElemen" size="75">
                                                                                        * <%= jspShipAddress.getErrorMsg(jspShipAddress.JSP_NAME) %> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="9%">&nbsp;<%=langMD[3]%></td>
                                                                                        <td height="21" width="1%">&nbsp; 
                                                                                        <td height="21" colspan="2" width="90%"> 
                                                                                        <textarea name="<%=jspShipAddress.colNames[jspShipAddress.JSP_ADDRESS] %>" class="formElemen" rows="4" cols="75"><%= shipAddress.getAddress() %></textarea>
                                                                                        * <%= jspShipAddress.getErrorMsg(jspShipAddress.JSP_ADDRESS) %> 
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" colspan="4">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="4" class="command" valign="top"> 
                                                                                                <%
    jspLine.setLocationImg(approot + "/images/ctr_line");
    jspLine.initDefault();
    jspLine.setTableWidth("60%");
    String scomDel = "javascript:cmdAsk('" + oidShipAddress + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidShipAddress + "')";
    String scancel = "javascript:cmdEdit('" + oidShipAddress + "')";
    jspLine.setBackCaption("Cancel");
    //if(iCommand==JSPCommand.ADD)
    //{
    jspLine.setBackCaption("Back to List");
    //}
    jspLine.setConfirmDelCaption("Yes Delete");
    jspLine.setDeleteCaption("Delete");
    jspLine.setSaveCaption("Save");
    jspLine.setJSPCommandStyle("buttonlink");

    jspLine.setOnMouseOut("MM_swapImgRestore()");
    jspLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    jspLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

    //jspLine.setOnMouseOut("MM_swapImgRestore()");
    jspLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
    jspLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

    jspLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
    jspLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

    jspLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
    jspLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


    jspLine.setWidthAllJSPCommand("90");
    jspLine.setErrorStyle("warning");
    jspLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    jspLine.setQuestionStyle("warning");
    jspLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    jspLine.setInfoStyle("success");
    jspLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

    if (privDelete) {
        jspLine.setConfirmDelJSPCommand(sconDelCom);
        jspLine.setDeleteJSPCommand(scomDel);
        jspLine.setEditJSPCommand(scancel);
    } else {
        jspLine.setConfirmDelCaption("");
        jspLine.setDeleteCaption("");
        jspLine.setEditCaption("");
    }

    if (privAdd == false && privUpdate == false) {
        jspLine.setSaveCaption("");
    }

    if (privAdd == false) {
        jspLine.setAddCaption("");
    }
                                                                                                %>
                                                                                            <%= jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                    </table></td>
                                                                </tr>
                                                            </table>
                                                            
                                                        </form>
                                                        <!--End Region Content-->
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
