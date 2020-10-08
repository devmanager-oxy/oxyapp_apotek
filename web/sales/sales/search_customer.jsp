
<%-- 
    Document   : search_customer
    Created on : Feb 8, 2011, 2:22:14 PM
    Author     : Tu Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.crm.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.crm.sewa.*" %>
<%@ page import = "com.project.crm.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, int start) {

        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
        cmdist.addHeader("No", "5%");
        cmdist.addHeader("Customer", "30%");
        cmdist.addHeader("Alamat", "70%");

        cmdist.setLinkRow(1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {

            Customer customer = new Customer();

            customer = (Customer) objectClass.get(i);

            Vector rowx = new Vector();
            rowx.add("<div align=\"center\">" + String.valueOf(start + i + 1) + "</div>");
            rowx.add(String.valueOf(customer.getName()));
            rowx.add(String.valueOf(customer.getAddress1()));

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(customer.getOID()) + "','" + String.valueOf(customer.getName()));
        }
        return cmdist.draw();
    }
%>



<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int start = JSPRequestValue.requestInt(request, "start");
            long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
            String formName = JSPRequestValue.requestString(request, "formName");
            String customerName = JSPRequestValue.requestString(request, "customer_name");

            /*variable declaration*/
            int recordToGet = 10;
            String whereClause = "";
            String orderClause = "";

            if (customerName.length() > 0) {
                whereClause += DbCustomer.colNames[DbCustomer.COL_NAME] + " LIKE '%" + customerName + "%'";
            }

            CmdCustomer cmdCustomer = new CmdCustomer(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCustomer = new Vector(1, 1);

            /*count list All Customer*/
            int vectSize = DbCustomer.getCount(whereClause);

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdCustomer.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            /* get record to display */
            listCustomer = DbCustomer.list(start, recordToGet, whereClause, orderClause);

%>
<html >
    <head>
        <title><%=salesSt%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../csssl/default.css" rel="stylesheet" type="text/css" />
        <link href="../csssl/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdEdit(oid, name){                
                self.opener.document.<%=formName%>.<%=JspSewaTanah.colNames[JspSewaTanah.JSP_CUSTOMER_ID]%>.value = oid;
                self.opener.document.<%=formName%>.name_customer.value = name;                
                self.close();
            }
            
            function cmdSearch() {
                document.frm_search_customer.command.value = "<%=String.valueOf(JSPCommand.LIST)%>";									
                document.frm_search_customer.action = "search_customer.jsp";
                document.frm_search_customer.submit();
            }
            
            function cmdListFirst(){
                document.frm_search_customer.command.value="<%=JSPCommand.FIRST%>";
                document.frm_search_customer.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frm_search_customer.action="search_customer.jsp";
                document.frm_search_customer.submit();
            }
            
            function cmdListPrev(){
                document.frm_search_customer.command.value="<%=JSPCommand.PREV%>";
                document.frm_search_customer.prev_command.value="<%=JSPCommand.PREV%>";
                document.frm_search_customer.action="search_customer.jsp";
                document.frm_search_customer.submit();
            }
            
            function cmdListNext(){
                document.frm_search_customer.command.value="<%=JSPCommand.NEXT%>";
                document.frm_search_customer.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frm_search_customer.action="search_customer.jsp";
                document.frm_search_customer.submit();
            }
            
            function cmdListLast(){
                document.frm_search_customer.command.value="<%=JSPCommand.LAST%>";
                document.frm_search_customer.prev_command.value="<%=JSPCommand.LAST%>";
                document.frm_search_customer.action="search_customer.jsp";
                document.frm_search_customer.submit();
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
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
        <form name="frm_search_customer" method ="post" action="">
            <input type="hidden" name="command" value="<%=iJSPCommand%>">
            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
            <input type="hidden" name="start" value="<%=start%>">            
            <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
            <input type="hidden" name="formName" value="<%=String.valueOf(formName)%>">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="container">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr align="left">
                                <td valign="middle" colspan="5" width="2%">&nbsp;</td>
                            </tr>                            
                            <tr align="left">
                                <td colspan="5">
                                    <table width="280" border="0" cellspacing="3" cellpadding="2" bgcolor="#F3F3F3">
                                        <tr>
                                            <td colspan="2" nowrap><B><u>Pencarian</u></B></td>
                                        </tr>
                                        <tr>
                                            <td width="30%" nowrap>Customer</td>
                                            <td width="70%"><input type="text" name="customer_name"  value="<%=customerName%>" class="formElemen" size="35"></td>                                                                                            
                                        </tr>
                                        <tr>
                                            <td colspan="2" height="6"></td>
                                        </tr>
                                    </table>                                    
                                </td>
                            </tr>
                            <tr align="left">
                                <td colspan="5" height="7"></td>
                            </tr>    
                            <tr align="left">
                                <td colspan="5"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../../images/search2.gif',1)"><img src="../../images/search.gif" name="search"  border="0"></a></td>
                            </tr>    
                            <tr align="left">
                                <td colspan="5" height="7"></td>
                            </tr>   
                            <% if (listCustomer != null && listCustomer.size() > 0) {%>
                            <tr align="left">
                                <td height="21" colspan="5" valign="middle"><%=drawList(listCustomer, start)%></td>
                            </tr>
                            <% }%>
                            <tr align="left">
                                <td height="21" colspan="5" valign="middle">
                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
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
                                    <%=ctrLine.drawImageListLimit(iJSPCommand, vectSize, start, recordToGet)%>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
