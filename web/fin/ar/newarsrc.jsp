
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean masterPriv = true;
            boolean masterPrivView = true;
            boolean masterPrivUpdate = true;
%>
<%
//jsp content
            long oidCustomer = JSPRequestValue.requestLong(request, "customer_id");
            String name = JSPRequestValue.requestString(request, "proj_name");
            String number = JSPRequestValue.requestString(request, "proj_number");
            int start = JSPRequestValue.requestInt(request, "start");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long unitUsahaId = JSPRequestValue.requestLong(request, "src_unit_usaha_id");
            JSPLine jspLine = new JSPLine();

            int recordToGet = 10;

            int vectSize = QrAR.getCount(oidCustomer, name, number, unitUsahaId);
            CmdCashArchive cmdCashArchive = new CmdCashArchive(request);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdCashArchive.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            Vector temp = QrAR.list(start, recordToGet, oidCustomer, name, number, unitUsahaId);

            String[] langAR = {"Customer","Project Name","Project Number"};

            String[] langNav = {"Account Receiveable", "New Invoice"};

            if (lang == LANG_ID) {
                String[] langID = {"Customer","Nama Proyek","Nomor Proyek"};
                langAR = langID;

                String[] navID = {"Piutang", "Faktur Baru"};
                langNav = navID;
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            
            <%if (!masterPriv || !masterPrivView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdListFirst(){
                document.form1.command.value="<%=JSPCommand.FIRST%>";
                document.form1.prev_command.value="<%=JSPCommand.FIRST%>";
                document.form1.action="newarsrc.jsp";
                document.form1.submit();
            }
            
            function cmdListPrev(){
                document.form1.command.value="<%=JSPCommand.PREV%>";
                document.form1.prev_command.value="<%=JSPCommand.PREV%>";
                document.form1.action="newarsrc.jsp";
                document.form1.submit();
            }
            
            function cmdListNext(){
                document.form1.command.value="<%=JSPCommand.NEXT%>";
                document.form1.prev_command.value="<%=JSPCommand.NEXT%>";
                document.form1.action="newarsrc.jsp";
                document.form1.submit();
            }
            
            function cmdListLast(){
                document.form1.command.value="<%=JSPCommand.LAST%>";
                document.form1.prev_command.value="<%=JSPCommand.LAST%>";
                document.form1.action="newarsrc.jsp";
                document.form1.submit();
            }
            
            function cmdSearch(){
                document.form1.command.value="<%=JSPCommand.SUBMIT%>";
                document.form1.action="newarsrc.jsp";
                document.form1.submit();
            }
            
            function cmdInvoice(idProj, idPt){
                document.form1.command.value="<%=JSPCommand.ADD%>";
                document.form1.hidden_project_id.value=idProj;
                document.form1.hidden_project_term_id.value=idPt;
                document.form1.action="arinvoice.jsp";
                document.form1.submit();
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
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">&nbsp;"+langNav[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+langNav[1]+"</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
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
                                                                                                        <form id="form1" name="form1" method="post" action="">
                                                                                                            <input type="hidden" name="command">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="hidden_project_id" value="">
                                                                                                            <input type="hidden" name="hidden_project_term_id" value="<%=start%>">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td width="7%">&nbsp;</td>
                                                                                                                                <td width="20%">&nbsp;</td>
                                                                                                                                <td width="7%">&nbsp;</td>
                                                                                                                                <td width="20%">&nbsp;</td>
                                                                                                                                <td width="46%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="7%">Customer</td>
                                                                                                                                <td colspan="4"> 
                                                                                                                                    <%
            Vector cust = DbCustomer.list(0, 0, "", "name");
                                                                                                                                    %>
                                                                                                                                    <select name="customer_id" onChange="javascript:cmdSearch()">
                                                                                                                                        <option value="0">-- 
                                                                                                                                        All --</option>
                                                                                                                                        <%if (cust != null && cust.size() > 0) {
                for (int i = 0; i < cust.size(); i++) {
                    Customer c = (Customer) cust.get(i);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=c.getOID()%>" <%if (c.getOID() == oidCustomer) {%>selected<%}%>><%=c.getName()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="7%" height="14" nowrap>Project 
                                                                                                                                Name</td>
                                                                                                                                <td width="20%" height="14"> 
                                                                                                                                    <input type="text" name="proj_name" value="<%=(name == null) ? "" : name%>" size="35">
                                                                                                                                </td>
                                                                                                                                <td width="7%" height="14" nowrap>Project 
                                                                                                                                Number</td>
                                                                                                                                <td width="20%" height="14"> 
                                                                                                                                    <input type="text" name="proj_number" value="<%=(number == null) ? "" : number%>" size="35">
                                                                                                                                </td>
                                                                                                                                <td width="46%" height="14">&nbsp; 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="7%" height="15">Unit 
                                                                                                                                Usaha </td>
                                                                                                                                <td width="20%" height="15"> 
                                                                                                                                    <%
            Vector unitUsh = DbUnitUsaha.list(0, 0, "", "name");
                                                                                                                                    %>
                                                                                                                                    <select name="src_unit_usaha_id">
                                                                                                                                        <option value="0">-- 
                                                                                                                                        All --</option>
                                                                                                                                        <%if (unitUsh != null && unitUsh.size() > 0) {
                for (int i = 0; i < unitUsh.size(); i++) {
                    UnitUsaha us = (UnitUsaha) unitUsh.get(i);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=us.getOID()%>" <%if (us.getOID() == unitUsahaId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <td width="7%" height="15">&nbsp;</td>
                                                                                                                                <td width="20%" height="15">&nbsp;</td>
                                                                                                                                <td width="46%" height="15">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="7%" height="15">&nbsp;</td>
                                                                                                                                <td width="20%" height="15"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                <td width="7%" height="15">&nbsp;</td>
                                                                                                                                <td width="20%" height="15">&nbsp;</td>
                                                                                                                                <td width="46%" height="15">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="7%" height="15">&nbsp;</td>
                                                                                                                                <td width="20%" height="15">&nbsp; 
                                                                                                                                </td>
                                                                                                                                <td width="7%" height="15">&nbsp;</td>
                                                                                                                                <td width="20%" height="15">&nbsp;</td>
                                                                                                                                <td width="46%" height="15">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="5" class="boxed1"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablehdr" width="2%" height="19">No</td>
                                                                                                                                            <td class="tablehdr" width="15%" height="19">Customer</td>
                                                                                                                                            <td class="tablehdr" width="17%" height="19">Address</td>
                                                                                                                                            <td class="tablehdr" width="16%" height="19">Project 
                                                                                                                                            Number</td>
                                                                                                                                            <td class="tablehdr" width="15%" height="19">Project 
                                                                                                                                            Name</td>
                                                                                                                                            <td class="tablehdr" width="14%" height="19">Start 
                                                                                                                                            Date</td>
                                                                                                                                            <td class="tablehdr" width="21%" height="19">End 
                                                                                                                                            Date </td>
                                                                                                                                        </tr>
                                                                                                                                        <%if (temp != null && temp.size() > 0) {
                for (int i = 0; i < temp.size(); i++) {
                    //Vector v = (Vector)temp.get(i);
                    //Project p = (Project)v.get(0);
                    //ProjectTerm pt = (ProjectTerm)v.get(1);

                    Project p = (Project) temp.get(i);

                    Customer c = new Customer();
                    try {
                        c = DbCustomer.fetchExc(p.getCustomerId());
                    } catch (Exception e) {
                    }

                    String where = "project_id=" + p.getOID() + " and status=" + I_Crm.TERM_STATUS_READY_TO_INV;
                    String order = "squence";

                    Vector listTerm = DbProjectTerm.list(0, 0, where, order);
                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="2%" class="tablecell" height="14"> 
                                                                                                                                                <div align="center"><%=start + i + 1%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="15%" class="tablecell" height="14" nowrap><%=c.getName()%></td>
                                                                                                                                            <td width="17%" class="tablecell" height="14" nowrap><%=c.getAddress1()%></td>
                                                                                                                                            <td width="16%" class="tablecell" height="14" nowrap> 
                                                                                                                                                <div align="center"><%=p.getNumber()%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="15%" class="tablecell" height="14" nowrap><%=p.getName()%></td>
                                                                                                                                            <td width="14%" class="tablecell" height="14" nowrap> 
                                                                                                                                                <div align="center"><%=JSPFormater.formatDate(p.getStartDate(), "dd MMMM yyyy")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="21%" class="tablecell" height="14" nowrap> 
                                                                                                                                                <div align="center"><%=JSPFormater.formatDate(p.getEndDate(), "dd MMMM yyyy")%></div>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="2%" class="tablecell">&nbsp;</td>
                                                                                                                                            <td colspan="6" class="tablecell"> 
                                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#F8F8F8">
                                                                                                                                                    <tr> 
                                                                                                                                                        <td width="34%" height="17"><b><font size="1"><u>Term 
                                                                                                                                                        Description</u></font></b></td>
                                                                                                                                                        <td width="12%" height="17"><b><font size="1"><u>Currency</u></font></b></td>
                                                                                                                                                        <td width="14%" height="17"><b><font size="1"><u>Amount</u></font></b></td>
                                                                                                                                                        <td width="25%" height="17"> 
                                                                                                                                                            <div align="left"><font size="1"><b><u>Action</u></b></font></div>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%if (listTerm != null && listTerm.size() > 0) {
                                                                                                                                                for (int ix = 0; ix < listTerm.size(); ix++) {
                                                                                                                                                    ProjectTerm pt = (ProjectTerm) listTerm.get(ix);

                                                                                                                                                    Currency cur = new Currency();
                                                                                                                                                    try {
                                                                                                                                                        cur = DbCurrency.fetchExc(pt.getCurrencyId());
                                                                                                                                                    } catch (Exception ex) {
                                                                                                                                                    }
                                                                                                                                                    %>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td width="34%" height="20"><font color="#009900"><%=pt.getDescription()%></font></td>
                                                                                                                                                        <td width="12%" height="20"><font color="#009900"><%=cur.getCurrencyCode()%></font></td>
                                                                                                                                                        <td width="14%" height="20"> 
                                                                                                                                                            <div align="left"><font color="#009900"><%=JSPFormater.formatNumber(pt.getAmount(), "#,###.##")%></font></div>
                                                                                                                                                        </td>
                                                                                                                                                        <td width="25%" height="20"> 
                                                                                                                                                            <div align="left"></div>
                                                                                                                                                            <table width="29%" border="0" cellspacing="1" cellpadding="1" height="12" align="left">
                                                                                                                                                                <tr> 
                                                                                                                                                                    <td width="82%" nowrap><font color="#009900"><a href="javascript:cmdInvoice('<%=p.getOID()%>','<%=pt.getOID()%>')">Create 
                                                                                                                                                                                Invoice 
                                                                                                                                                                    </a></font></td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%}
                                                                                                                                            }%>
                                                                                                                                                    <tr > 
                                                                                                                                                        <td background="../images/line1.gif" colspan="4" height="3"></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="7%">&nbsp;</td>
                                                                                                                                <td width="20%">&nbsp;</td>
                                                                                                                                <td width="7%">&nbsp;</td>
                                                                                                                                <td width="20%">&nbsp;</td>
                                                                                                                                <td width="46%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="5"> 
                                                                                                                                    <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) || (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
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
                                                                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp;</td>
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
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

