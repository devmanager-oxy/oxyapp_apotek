
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>

<%
            String approot = "";
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long customerId) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setHeaderStyle("tablehdr");
        cmdist.addHeader("Barcode", "10%");
        cmdist.addHeader("Nama", "20%");
        cmdist.addHeader("Alamat", "40%");
        cmdist.addHeader("Telp", "20%");

        //cmdist.addHeader("Country","15%");
        //cmdist.addHeader("Nationality","15%");
        //cmdist.addHeader("ID","15%");

        cmdist.setLinkRow(-1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Customer customer = (Customer) objectClass.get(i);
            Vector rowx = new Vector();
            if (customerId == customer.getOID()) {
                index = i;
            }

            rowx.add(customer.getCode());
            rowx.add(customer.getName());
            rowx.add(customer.getAddress1() + ((customer.getCity() == null || customer.getCity().length() < 1) ? "" : ", " + customer.getCity()) + ((customer.getState() == null || customer.getState().length() < 1) ? "" : ", " + customer.getState()));
            if (customer.getHp().length() > 0) {
                rowx.add("Telp: " + customer.getPhoneArea() + "" + customer.getPhone() + " HP: " + customer.getHp());
            } else {
                rowx.add("Telp: " + customer.getPhoneArea() + "" + customer.getPhone());
            }
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(customer.getOID()));
        }

        return cmdist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
            int isSearch = JSPRequestValue.requestInt(request, "hidden_search");

            /*variable declaration*/
            int recordToGet = 1;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            SrcCustomer srcCus = new SrcCustomer();
            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.NEXT ||
                    iJSPCommand == JSPCommand.LAST || iJSPCommand == JSPCommand.PREV || iJSPCommand == JSPCommand.BACK) {

                try {
                    if (iJSPCommand != JSPCommand.BACK) {
                        srcCus.setName(JSPRequestValue.requestString(request, "src_name"));
                        srcCus.setAddress(JSPRequestValue.requestString(request, "src_address"));
                        srcCus.setCountry(JSPRequestValue.requestString(request, "src_country"));
                        srcCus.setNationality(JSPRequestValue.requestString(request, "src_nationality"));
                        srcCus.setDobFrom(JSPRequestValue.requestString(request, "src_dobfrom"));
                        srcCus.setDobTo(JSPRequestValue.requestString(request, "src_dobto"));
                        srcCus.setDobIgnore(JSPRequestValue.requestInt(request, "src_dobignore"));

                    /*out.println("srcCus.setName : "+srcCus.getName());
                    out.println("<br>srcCus.setAddress : "+srcCus.getAddress());
                    out.println("<br>srcCus.setCountry : "+srcCus.getCountry());
                    out.println("<br>srcCus.setNationality : "+srcCus.getNationality());
                    out.println("<br>srcCus.setDobFrom : "+srcCus.getDobFrom());
                    out.println("<br>srcCus.setDobTo : "+srcCus.getDobTo());
                    out.println("<br>srcCus.setDobIgnore : "+srcCus.getDobIgnore());
                     */
                    } else {
                        srcCus = ((SrcCustomer) session.getValue("SRC_CUS") == null) ? new SrcCustomer() : (SrcCustomer) session.getValue("SRC_CUS");
                    }

                } catch (Exception e) {
                }

                if (srcCus.getName().length() > 0) {
                    whereClause = "upper(name) like upper('%" + srcCus.getName() + "%')";
                }
                if (srcCus.getAddress().length() > 0) {
                    whereClause = ((whereClause.length() < 1) ? "" : whereClause + " and ") + "(upper(address) like upper('%" + srcCus.getAddress() + "%') or upper(city ) like upper('" + srcCus.getNationality() + "')" +
                            " or upper(state) like upper('%" + srcCus.getNationality() + "%'))";
                }

                if (srcCus.getCountry().length() > 0) {
                    whereClause = ((whereClause.length() < 1) ? "" : whereClause + " and ") + "(upper(code) like upper('%" + srcCus.getCountry() + "%'))";
                }
                /*if(srcCus.getNationality().length()>0){
                whereClause = ((whereClause.length()<1) ? "" : whereClause+" and ") + "(upper(nationality_name) like upper('%"+srcCus.getNationality()+"%'))";
                }
                if(srcCus.getDobIgnore()==0){
                whereClause = ((whereClause.length()<1) ? "" : whereClause+" and ") + 
                "(dob >= '"+JSPFormater.formatDate(JSPFormater.formatDate(srcCus.getDobFrom(), "dd/MM/yyyy"), "yyyy-MM-dd")+"' and  "+
                "dob <= '"+JSPFormater.formatDate(JSPFormater.formatDate(srcCus.getDobTo(), "dd/MM/yyyy"), "yyyy-MM-dd")+"')";
                }*/

                session.putValue("SRC_CUS", srcCus);

            }

//out.println(whereClause);

            CmdCustomer cmdCustomer = new CmdCustomer(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCustomer = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdCustomer.action(iJSPCommand, oidCustomer);
            /* end switch*/
            JspCustomer jspCustomer = cmdCustomer.getForm();

            /*count list All Customer*/
            int vectSize = DbCustomer.getCount(whereClause);

            Customer customer = cmdCustomer.getCustomer();
            msgString = cmdCustomer.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdCustomer.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listCustomer = DbCustomer.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCustomer.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCustomer = DbCustomer.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title>OXY Pos</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <%@ include file="../calendar/calendarframe.jsp"%>
        <script language="JavaScript">
            <!--
            
            function cmdResetX(){
                document.frmcustomer.src_name.value="";
                document.frmcustomer.src_address.value="";
                document.frmcustomer.src_country.value="";
                document.frmcustomer.src_nationality.value="";
                document.frmcustomer.src_dobfrom.value='<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>';
                document.frmcustomer.src_dobto.value='<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>';
                document.frmcustomer.src_dobignore.checked;
            }
            
            function cmdAdd(){
                document.frmcustomer.hidden_customer_id.value="0";
                document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customeredt.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdAsk(oidCustomer){
                document.frmcustomer.hidden_customer_id.value=oidCustomer;
                document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdConfirmDelete(oidCustomer){
                document.frmcustomer.hidden_customer_id.value=oidCustomer;
                document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            function cmdSave(){
                document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdEdit(oidCustomer){
                document.frmcustomer.hidden_customer_id.value=oidCustomer;
                document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customeredt.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdCancel(oidCustomer){
                document.frmcustomer.hidden_customer_id.value=oidCustomer;
                document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdBack(){
                document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdListFirst(){
                document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
                document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdListPrev(){
                document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
                document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdListNext(){
                document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
                document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdListLast(){
                document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
                document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdSearch(){
                document.frmcustomer.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmcustomer.action="customer.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdSearchActive(){
                document.all.searching.style.display="";
                document.all.activate.style.display="none";
                document.all.deactivate.style.display="";
                document.frmcustomer.hidden_search.value="1";
            }
            
            function cmdSearchHide(){
                document.all.searching.style.display="none";
                document.all.activate.style.display="";
                document.all.deactivate.style.display="none";
                document.frmcustomer.hidden_search.value="0";
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
            
            //-------------- script control line -------------------
            //-->
        </script>
        <!-- #EndEditable -->
    </head>
    <body>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcustomer" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                                                            <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr  id="searching"> 
                                                                                <td height="14" valign="top" colspan="3" class="comment" width="99%"> 
                                                                                    <table width="70%" border="0" cellspacing="1" cellpadding="1">
                                                                                        
                                                                                        <tr>
                                                                                            <td>Barcode</td>
                                                                                            <td><input type="text" name="src_country"  value="<%= srcCus.getCountry() %>" class="formElemen" size="30"></td>
                                                                                            <td>&nbsp;</td>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="13%">Nama</td>
                                                                                            <td width="48%"> 
                                                                                            <input type="text" name="src_name"  value="<%= srcCus.getName() %>" class="formElemen" size="30">                                          </td>
                                                                                            <td width="8%">&nbsp;</td>
                                                                                            <td width="31%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="13%" nowrap>Alamat</td>
                                                                                            <td width="48%"> 
                                                                                            <input type="text" name="src_address"  value="<%= srcCus.getAddress() %>" class="formElemen" size="35">                                          </td>
                                                                                            <td width="8%">&nbsp;</td>
                                                                                            <td width="31%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                            <td><input type="button" name="Button" value="Search" onClick="javascript:cmdSearch()">
                                                                                            <input type="button" name="Button" value="Reset" onClick="javascript:cmdResetX()"></td>
                                                                                            <td>&nbsp;</td>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                </table></td>
                                                                            </tr>
                                                                            
                                                                            <tr id="activate"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment" width="99%"><b></b></td>
                                                                            </tr>
                                                                            <%
            try {
                if (listCustomer.size() > 0) {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3" width="99%"> 
                                                                                <%= drawList(listCustomer, oidCustomer)%> </td>
                                                                            </tr>
                                                                            <%  }
            } catch (Exception exc) {
            }%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="3" class="command" width="99%"> 
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
                                                                                        <% ctrLine.setLocationImg("../images/ctr_line");
            ctrLine.initDefault();
                                                                                        %>
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
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
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
