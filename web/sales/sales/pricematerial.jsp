
<%-- 
    Document   : pricematerial
    Created on : Nov 21, 2011, 1:40:07 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            long oidPriceType = JSPRequestValue.requestLong(request, "hidden_price_type_id");

            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbPriceType.colNames[DbPriceType.COL_ITEM_MASTER_ID] + " = " + oidItemMaster;
            String orderClause = "";

            CmdPriceType ctrlPriceType = new CmdPriceType(request);
            JSPLine jspLine = new JSPLine();

            Vector listPriceType = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlPriceType.action(iJSPCommand, oidPriceType);
            /* end switch*/            
            
            JspPriceType jspPriceType = ctrlPriceType.getForm();

            /*count list All ItemMaster*/
            int vectSize = DbPriceType.getCount(whereClause);

            PriceType priceType = ctrlPriceType.getPriceType();
            
            boolean saveSuccess = false;
            boolean deleteSuccess = false;
            
            if(iJSPCommand == JSPCommand.SAVE && iErrCode == 0){
                saveSuccess = true;
                priceType = new PriceType();
                iJSPCommand = JSPCommand.BACK;
            }
            
             if(iJSPCommand == JSPCommand.DELETE && iErrCode == 0){
                deleteSuccess = true;
                priceType = new PriceType();
                iJSPCommand = JSPCommand.BACK;
            }

            msgString = ctrlPriceType.getMessage();

            if (oidPriceType == 0) {
                oidPriceType = priceType.getOID();
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlPriceType.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listPriceType = DbPriceType.list(start, recordToGet, whereClause, DbPriceType.colNames[DbPriceType.COL_QTY_FROM]);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listPriceType.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listPriceType = DbPriceType.list(start, recordToGet, whereClause, DbPriceType.colNames[DbPriceType.COL_QTY_FROM]);
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Oxy-Sales</title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
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
                    }else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }
                return result;
            }
            
            function cmdToRecords(){
                document.frmpricematerial.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmpricematerial.command.value="<%=JSPCommand.LIST%>";
                document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                document.frmpricematerial.action="itemlist.jsp";
                document.frmpricematerial.submit();
            }
            
            function cmdToEditor(){
                document.frmpricematerial.hidden_item_master_id.value="0";
                document.frmpricematerial.command.value="<%=JSPCommand.ADD%>";
                document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                document.frmpricematerial.action="itemmaster.jsp";
                document.frmpricematerial.submit();
            }
            
            function cmdAdd(){
                document.frmpricematerial.hidden_price_type_id.value="0";
                document.frmpricematerial.command.value="<%=JSPCommand.ADD%>";
                document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                document.frmpricematerial.action="pricematerial.jsp";
                document.frmpricematerial.submit();
            }
            
            function cmdAsk(oidPriceType){
                document.frmpricematerial.hidden_price_type_id.value=oidPriceType;
                document.frmpricematerial.command.value="<%=JSPCommand.ASK%>";
                document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                document.frmpricematerial.action="pricematerial.jsp";
                document.frmpricematerial.submit();
            }
            
            function cmdDelete(oidPriceType){
                var cfrm = confirm('Are you sure want to delete ?');
                    
                if( cfrm==true){
                    document.frmpricematerial.hidden_price_type_id.value=oidPriceType;
                    document.frmpricematerial.command.value="<%=JSPCommand.DELETE%>";
                    document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                    document.frmpricematerial.action="pricematerial.jsp";
                    document.frmpricematerial.submit();
                }
            }
            
            function cmdConfirmDelete(oidPriceType){
                document.frmpricematerial.hidden_price_type_id.value=oidPriceType;
                document.frmpricematerial.command.value="<%=JSPCommand.DELETE%>";
                document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                document.frmpricematerial.action="pricematerial.jsp";
                document.frmpricematerial.submit();
            }
            
            function cmdSave(){
                document.frmpricematerial.command.value="<%=JSPCommand.SAVE%>";
                document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                document.frmpricematerial.action="pricematerial.jsp";
                document.frmpricematerial.submit();
            }
            
            function cmdEdit(oidPriceType){
                document.frmpricematerial.hidden_price_type_id.value=oidPriceType;
                document.frmpricematerial.command.value="<%=JSPCommand.EDIT%>";
                document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                document.frmpricematerial.action="pricematerial.jsp";
                document.frmpricematerial.submit();
            }
            
            function cmdCancel(oidPriceType){
                document.frmpricematerial.hidden_price_type_id.value=oidPriceType;
                document.frmpricematerial.command.value="<%=JSPCommand.EDIT%>";
                document.frmpricematerial.prev_command.value="<%=prevJSPCommand%>";
                document.frmpricematerial.action="pricematerial.jsp";
                document.frmpricematerial.submit();
            }
            
            function cmdBack(){
                document.frmpricematerial.command.value="<%=JSPCommand.BACK%>";
                document.frmpricematerial.action="pricematerial.jsp";
                document.frmpricematerial.submit();
            }       
            
            function checkGol1(){
                var st = document.frmpricematerial.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_1]%>.value;		                
                result = removeChar(st);
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                document.frmpricematerial.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_1]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function checkGol2(){
                var st = document.frmpricematerial.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_2]%>.value;		                
                result = removeChar(st);
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                document.frmpricematerial.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_2]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function checkGol3(){
                var st = document.frmpricematerial.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_3]%>.value;		                
                result = removeChar(st);
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                document.frmpricematerial.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_3]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function checkGol4(){
                var st = document.frmpricematerial.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_4]%>.value;		                
                result = removeChar(st);
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                document.frmpricematerial.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_4]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> 
                                <%@ include file="../main/hmenusl.jsp"%>
                            </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmpricematerial" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="hidden_price_type_id" value="<%=oidPriceType%>">
                                                            <input type="hidden" name="hidden_vendor_item_id" value="">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                        <tr valign="bottom"> 
                                                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master Maintenance </font><font class="tit1">&raquo; 
                                                                                                    </font><font class="tit1"><span class="lvl2">POS 
                                                                                            </span>&raquo; <span class="lvl2">Price List </span></font></b></td>
                                                                                            <td width="40%" height="23"> 
                                                                                                <%@ include file = "../main/userpreview.jsp" %>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="5"  colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr> 
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecords()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToEditor()" class="tablink">Item Data</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap><div align="center">
                                                                                                    &nbsp;&nbsp;Price List&nbsp;&nbsp;
                                                                                            </div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3" class="page"> 
                                                                                </td>
                                                                            </tr>
                                                                            <%

            ItemMaster itMaster = new ItemMaster();

            String name = "";

            try {
                itMaster = DbItemMaster.fetchExc(oidItemMaster);
                name = itMaster.getCode() + "/" + itMaster.getName();
            } catch (Exception e) {}

                                                                            %>
                                                                            <tr>
                                                                                <td>
                                                                                    <table width="100%" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>   
                                                                                                <U><B>PRICE LIST</B></U>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>   
                                                                                                <table width="400" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td width="70">Item Master&nbsp;:&nbsp;</td>
                                                                                                        <td><%=name%></td>
                                                                                                    </tr>    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>   
                                                                                                <table width="90%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="20%" class="tablehdr">QTY FROM</td>
                                                                                                        <td width="20%" class="tablehdr">QTY TO</td>
                                                                                                        <td width="15%" class="tablehdr">GOL 1</td>
                                                                                                        <td width="15%" class="tablehdr">GOL 2</td>
                                                                                                        <td width="15%" class="tablehdr">GOL 3</td>
                                                                                                        <td width="15%" class="tablehdr">GOL 4</td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                   boolean edit = false; 
                                                                                                    
            if (listPriceType != null && listPriceType.size() > 0) {
                for (int ix = 0; ix < listPriceType.size(); ix++) {
                    
                    PriceType objPriceType = new PriceType();

                    objPriceType = (PriceType) listPriceType.get(ix);
                    
                    if(priceType.getOID() == objPriceType.getOID()){
                        
                        edit = true;

                                                                                                    %>
                                                                                                    <input type="hidden" name="<%=jspPriceType.colNames[JspPriceType.JSP_ITEM_MASTER_ID]%>" value="<%=oidItemMaster%>">
                                                                                                    <tr>
                                                                                                        <td class="tablecell"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_QTY_FROM]%>" size="15" value="<%=priceType.getQtyFrom()%>">* <%= jspPriceType.getErrorMsg(jspPriceType.JSP_QTY_FROM) %></td>
                                                                                                        <td class="tablecell"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_QTY_TO]%>" size="15" value="<%=priceType.getQtyTo()%>">* <%= jspPriceType.getErrorMsg(jspPriceType.JSP_QTY_TO)%></td>
                                                                                                        <td class="tablecell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_1]%>" size="20" value="<%=priceType.getGol1()%>" style="text-align:right" onBlur="javascript:checkGol1()" onClick="this.select()"></td>
                                                                                                        <td class="tablecell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_2]%>" size="20" value="<%=priceType.getGol2()%>" style="text-align:right" onBlur="javascript:checkGol2()" onClick="this.select()"></td>
                                                                                                        <td class="tablecell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_3]%>" size="20" value="<%=priceType.getGol3()%>" style="text-align:right" onBlur="javascript:checkGol3()" onClick="this.select()"></td>
                                                                                                        <td class="tablecell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_4]%>" size="20" value="<%=priceType.getGol4()%>" style="text-align:right" onBlur="javascript:checkGol4()" onClick="this.select()"></td>
                                                                                                        
                                                                                                    </tr>
                                                                                                    <%}else{%>    
                                                                                                    <tr>
                                                                                                        <td class="tablecell"><a href="javascript:cmdEdit('<%=objPriceType.getOID()%>')"><%=objPriceType.getQtyFrom()%></a></td>
                                                                                                        <td class="tablecell"><%=objPriceType.getQtyTo()%></td>
                                                                                                        <td class="tablecell" align="right"><%=objPriceType.getGol1()%>&nbsp;</td>
                                                                                                        <td class="tablecell" align="right"><%=objPriceType.getGol2()%>&nbsp;</td>
                                                                                                        <td class="tablecell" align="right"><%=objPriceType.getGol3()%>&nbsp;</td>
                                                                                                        <td class="tablecell" align="right"><%=objPriceType.getGol4()%>&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%
                }
            }
                                                                                                    %>
                                                                                                    <%  
                                                                                             if((iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0))){       
                                                                                                    
                                                                                                    %>
                                                                                                    <input type="hidden" name="<%=jspPriceType.colNames[JspPriceType.JSP_ITEM_MASTER_ID]%>" value="<%=oidItemMaster%>">
                                                                                                    <tr>
                                                                                                        <td class="tablecell"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_QTY_FROM]%>" size="15" value="<%=priceType.getQtyFrom()%>">* <%= jspPriceType.getErrorMsg(jspPriceType.JSP_QTY_FROM) %></td>
                                                                                                        <td class="tablecell"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_QTY_TO]%>" size="15" value="<%=priceType.getQtyTo()%>">* <%= jspPriceType.getErrorMsg(jspPriceType.JSP_QTY_TO)%></td>
                                                                                                        <td class="tablecell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_1]%>" size="20" value="<%=priceType.getGol1()%>" style="text-align:right" onBlur="javascript:checkGol1()" onClick="this.select()"></td>
                                                                                                        <td class="tablecell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_2]%>" size="20" value="<%=priceType.getGol2()%>" style="text-align:right" onBlur="javascript:checkGol2()" onClick="this.select()"></td>
                                                                                                        <td class="tablecell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_3]%>" size="20" value="<%=priceType.getGol3()%>" style="text-align:right" onBlur="javascript:checkGol3()" onClick="this.select()"></td>
                                                                                                        <td class="tablecell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_4]%>" size="20" value="<%=priceType.getGol4()%>" style="text-align:right" onBlur="javascript:checkGol4()" onClick="this.select()"></td>
                                                                                                    </tr> 
                                                                                                    <%
                                                                                                    }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td colspan="6">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if(iErrCode > 0){%>
                                                                                                    <tr>
                                                                                                        <td colspan="6" align="left">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="warning">
                                                                                                                <tr>
                                                                                                                    <td width="20"><img src="<%=approot%>/images/error.gif" width="20" height="20"></td>
                                                                                                                    <td width="300" nowrap>Can not register data, incomplete data input</td>
                                                                                                                 </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if(saveSuccess){%>
                                                                                                    <tr>
                                                                                                        <td colspan="6" align="left">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                <tr>
                                                                                                                    <td width="20"><img src="<%=approot%>/images/success.gif" width="20" height="20"></td>
                                                                                                                    <td width="100" nowrap><font color="FFFFFF">Data is Saved</font></td>
                                                                                                                 </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if(deleteSuccess){%>
                                                                                                    <tr>
                                                                                                        <td colspan="6" align="left">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                <tr>
                                                                                                                    <td width="20"><img src="<%=approot%>/images/success.gif" width="20" height="20"></td>
                                                                                                                    <td width="100" nowrap><font color="FFFFFF">Delete data success</font></td>
                                                                                                                 </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr>
                                                                                                        <td colspan="6">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="6">
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <%if(iJSPCommand == JSPCommand.BACK){%>
                                                                                                                    <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <%if(iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0)){%>
                                                                                                                    <td><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save21','','../images/save2.gif',1)"><img src="../images/save.gif" name="save21" height="22" border="0"></a></td>
                                                                                                                    <td><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back21','','../images/back2.gif',1)"><img src="../images/back.gif" name="back21" height="22" border="0"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <%if(priceType.getOID() != 0){%>
                                                                                                                    <td><a href="javascript:cmdDelete('<%=priceType.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del21','','../images/del2.gif',1)"><img src="../images/del.gif" name="del21" height="22" border="0"></a></td>
                                                                                                                    <%}%>
                                                                                                                    
                                                                                                                </tr>    
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td colspan="6">
                                                                                                            <%
            jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
            jspLine.setTableWidth("80%");
            String scomDel = "javascript:cmdAsk('" + oidPriceType + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidPriceType + "')";
            String scancel = "javascript:cmdEdit('" + oidPriceType + "')";
            jspLine.setBackCaption("");
            jspLine.setJSPCommandStyle("buttonlink");
            jspLine.setDeleteCaption("Delete");
            jspLine.setSaveCaption("Save");
            jspLine.setAddCaption("Add");
            
            jspLine.setBackCaption("Back to List");
            jspLine.setJSPCommandStyle("buttonlink");

            jspLine.setOnMouseOut("MM_swapImgRestore()");
            jspLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
            jspLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
            
            jspLine.setAddNewImage("<img src=\"" + approot + "/images/new.gif\" name=\"new\" height=\"22\" border=\"0\">");
            
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
                                                                                                            <%//= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>    
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">&nbsp;</td>
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
