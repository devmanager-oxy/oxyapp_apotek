
<%-- 
    Document   : gettransferlist
    Created on : Sep 25, 2012, 7:15:15 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidTransfer = JSPRequestValue.requestLong(request, "hidden_transfer_id");

            long fromLocation = JSPRequestValue.requestLong(request, "from_location");
            long toLocation = JSPRequestValue.requestLong(request, "to_location");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();
            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
            }
            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            if (fromLocation != 0) {
                whereClause = DbTransfer.colNames[DbTransfer.COL_FROM_LOCATION_ID] + "=" + fromLocation;
            }

            if (toLocation != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbTransfer.colNames[DbTransfer.COL_TO_LOCATION_ID] + "=" + toLocation;
            }

            if (srcStatus != null && srcStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbTransfer.colNames[DbTransfer.COL_STATUS] + "='" + srcStatus + "'";
                } else {
                    whereClause = DbTransfer.colNames[DbTransfer.COL_STATUS] + "='" + srcStatus + "'";
                }
            }
            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbTransfer.colNames[DbTransfer.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbTransfer.colNames[DbTransfer.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = "(to_days(" + DbTransfer.colNames[DbTransfer.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbTransfer.colNames[DbTransfer.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            if (whereClause.length() > 0) {
                whereClause = whereClause + " and " + DbTransfer.colNames[DbTransfer.COL_TYPE] + " = " + DbTransfer.TYPE_NON_CONSIGMENT;
            } else {
                whereClause = DbTransfer.colNames[DbTransfer.COL_TYPE] + " = " + DbTransfer.TYPE_NON_CONSIGMENT;
            }


            CmdTransfer cmdTransfer = new CmdTransfer(request);
            JSPLine ctrLine = new JSPLine();
            Vector listTransfer = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdTransfer.action(iJSPCommand, oidTransfer);
            /* end switch*/
            JspTransfer jspTransfer = cmdTransfer.getForm();

            /*count list All Transfer*/
            int vectSize = DbTransfer.getCount(whereClause);

            Transfer vendor = cmdTransfer.getTransfer();
            msgString = cmdTransfer.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdTransfer.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            orderClause = DbTransfer.colNames[DbTransfer.COL_DATE];
            listTransfer = DbTransfer.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listTransfer.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listTransfer = DbTransfer.list(start, recordToGet, whereClause, orderClause);
            }

            Vector vLocation = new Vector();
            Vector vLocationTo = new Vector();
            String where1 = DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = "+fromLocation;
            String where2 = DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = "+toLocation;
            vLocation = DbLocation.list(0, 0, where1, DbLocation.colNames[DbLocation.COL_NAME]);            
            vLocationTo = DbLocation.list(0, 0, where2, DbLocation.colNames[DbLocation.COL_NAME]);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            function cmdSelect(oidTransfer){
                self.opener.document.frmfakturpajak.hidden_tmp_transfer_id.value = oidTransfer;                
                self.opener.document.frmfakturpajak.command.value="<%=JSPCommand.REFRESH%>";
                self.opener.document.frmfakturpajak.submit();           
                self.close();
            }
            
            function cmdSearch(){                
                document.frmtransfer.start.value="0";
                document.frmtransfer.command.value="<%=JSPCommand.SEARCH%>";
                document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                document.frmtransfer.action="gettransferlist.jsp";
                document.frmtransfer.submit();
            }
            
            function cmdAdd(){
                document.frmtransfer.hidden_transfer_id.value="0";
                document.frmtransfer.command.value="<%=JSPCommand.ADD%>";
                document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                document.frmtransfer.action="gettransferlist.jsp";
                document.frmtransfer.submit();
            }
            
            function cmdListFirst(){
                document.frmtransfer.command.value="<%=JSPCommand.FIRST%>";
                document.frmtransfer.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmtransfer.action="gettransferlist.jsp";
                document.frmtransfer.submit();
            }
            
            function cmdListPrev(){
                document.frmtransfer.command.value="<%=JSPCommand.PREV%>";
                document.frmtransfer.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmtransfer.action="gettransferlist.jsp";
                document.frmtransfer.submit();
            }
            
            function cmdListNext(){
                document.frmtransfer.command.value="<%=JSPCommand.NEXT%>";
                document.frmtransfer.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmtransfer.action="gettransferlist.jsp";
                document.frmtransfer.submit();
            }
            
            function cmdListLast(){
                document.frmtransfer.command.value="<%=JSPCommand.LAST%>";
                document.frmtransfer.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmtransfer.action="gettransferlist.jsp";
                document.frmtransfer.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">                      
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="1" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr>
                                        <td width="100%" valign="top"> 
                                            <%@ include file="../calendar/calendarframe.jsp"%>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmtransfer" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_transfer_id" value="<%=oidTransfer%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="hidden_tmp_transfer_id" value="0">                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            
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
                                                                                                        <td width="10%">From Location</td>
                                                                                                        <td idth="90%">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <select name="from_location">                                                                                                                            
                                                                                                                            <%

            if (vLocation != null && vLocation.size() > 0) {

                for (int ix = 0; ix < vLocation.size(); ix++) {
                    Location location = (Location) vLocation.get(ix);

                                                                                                                            %>
                                                                                                                            <option value ="<%=location.getOID()%>" <%if (location.getOID() == fromLocation) {%>selected<%}%> ><%=location.getName()%></option>
                                                                                                                            <%

                }
            }
                                                                                                                            %>
                                                                                                                        </select>   
                                                                                                                    </td>
                                                                                                                    <td width="15"></td>
                                                                                                                    <td>To Location</td>
                                                                                                                    <td>
                                                                                                                        &nbsp;&nbsp;<select name="to_location">                                                                                                                            
                                                                                                                            <%

            if (vLocationTo != null && vLocationTo.size() > 0) {

                for (int ix = 0; ix < vLocationTo.size(); ix++) {
                    Location location = (Location) vLocationTo.get(ix);

                                                                                                                            %>
                                                                                                                            <option value ="<%=location.getOID()%>" <%if (location.getOID() == toLocation) {%>selected<%}%> ><%=location.getName()%></option>
                                                                                                                            <%

                }
            }
                                                                                                                            %>
                                                                                                                        </select>   
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">Document Status</td>
                                                                                                        <td width="90%"> 
                                                                                                            <select name="src_status">
                                                                                                                <option value="" >- All -</option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_CHECKED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CHECKED%></option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_CLOSE)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">PO Between</td>
                                                                                                        <td width="90%"> 
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmtransfer.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmtransfer.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                    <input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        Ignored
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                            </table>   
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="2" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        <td width="90%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">&nbsp;</td>
                                                                                                        <td width="90%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listTransfer.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td class="tablehdr" width="5%">No</td>
                                                                                                        <td class="tablehdr" width="10%">Number</td>
                                                                                                        <td class="tablehdr" width="12%">Date</td>
                                                                                                        <td class="tablehdr" width="23%">From</td>
                                                                                                        <td class="tablehdr" width="23%">To</td>
                                                                                                        <td class="tablehdr" width="10%">Status</td>
                                                                                                        <td class="tablehdr">Notes</td>
                                                                                                    </tr>    
                                                                                                    <%     for (int i = 0; i < listTransfer.size(); i++) {
            
                                                                                                            Transfer transfer = (Transfer) listTransfer.get(i);
                                                                                                            int isBkp = DbFakturPajak.getMaxData(transfer.getOID());
                                                                                                            
            Location location = new Location();
            try {
                location = DbLocation.fetchExc(transfer.getFromLocationId());
            } catch (Exception e) {
            }

            Location location2 = new Location();
            try {
                location2 = DbLocation.fetchExc(transfer.getToLocationId());
            } catch (Exception e) {
            }
            
            String bkp = "NON BKP";            
            if(isBkp != 0){
                bkp = "BKP";
            }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablecell1" align="center"><%=i+1%></td>
                                                                                                        <%if(isBkp > 0 || true){%>
                                                                                                        <td class="tablecell1" align="center"><a href="javascript:cmdSelect('<%=transfer.getOID()%>')" ><%=transfer.getNumber()%></a></td>
                                                                                                        <%}else{%>
                                                                                                        <td class="tablecell1" align="center"><%=transfer.getNumber()%></td>
                                                                                                        <%}%>
                                                                                                        <td class="tablecell1" align="center"><%=JSPFormater.formatDate(transfer.getDate(),"dd MMM yyyy")%></td>
                                                                                                        <td class="tablecell1" ><%=location.getName()%></td>
                                                                                                        <td class="tablecell1" ><%=location2.getName()%></td>
                                                                                                        <td class="tablecell1" align="center"><%=bkp%></td>
                                                                                                        <td class="tablecell1"><%=transfer.getNote()%></td>
                                                                                                    </tr> 
                                                                                                   <%
                                                                                                    }
                                                                                                    %>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>                                                                                     
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%  }
            } catch (Exception exc) {
                System.out.println("exception : " + exc.toString());
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
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3">&nbsp; </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
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
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>

