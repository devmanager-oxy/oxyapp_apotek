

<%-- 
    Document   : pricematerial_curr
    Created on : Jan 3, 2014, 8:30:01 PM
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
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "startp");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            long oidPriceType = JSPRequestValue.requestLong(request, "hidden_price_type_id");
            double ppn_value = 0;

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
            ItemMaster im = new ItemMaster();
            try {
                im = DbItemMaster.fetchExc(oidItemMaster);
            } catch (Exception ex) {

            }
            if (im.getIs_bkp() == 1) {
                try{
                    ppn_value = Integer.parseInt(DbSystemProperty.getValueByName("ppn")) * im.getCogs() / 100;
                }catch(Exception e){}
            }

            PriceType priceType = ctrlPriceType.getPriceType();

            boolean saveSuccess = false;
            boolean deleteSuccess = false;

            if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {
                saveSuccess = true;
                priceType = new PriceType();
                iJSPCommand = JSPCommand.BACK;
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0) {
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
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
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
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="itemlist.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdToEditor(){            
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="itemmaster.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdToMinimumStock(){
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="stockMinItem.jsp";
            document.frmitemmaster.submit();
        }
        function cmdVendorItem(){
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="vendoritem.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdToRecipe(){
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="recipe.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdAdd(){
            document.frmitemmaster.hidden_price_type_id.value="0";
            document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="pricematerialexchangerate.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdAsk(oidPriceType){
            document.frmitemmaster.hidden_price_type_id.value=oidPriceType;
            document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="pricematerialexchangerate.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdDelete(oidPriceType){
            var cfrm = confirm('Are you sure want to delete ?');
            
            if( cfrm==true){
                document.frmitemmaster.hidden_price_type_id.value=oidPriceType;
                document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="pricematerialexchangerate.jsp";
                document.frmitemmaster.submit();
            }
        }
        
        function cmdConfirmDelete(oidPriceType){
            document.frmitemmaster.hidden_price_type_id.value=oidPriceType;
            document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="pricematerialexchangerate.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdSave(){
            document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="pricematerialexchangerate.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdEdit(oidPriceType){
            document.frmitemmaster.hidden_price_type_id.value=oidPriceType;
            document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="pricematerialexchangerate.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdCancel(oidPriceType){
            document.frmitemmaster.hidden_price_type_id.value=oidPriceType;
            document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="pricematerialexchangerate.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdBack(){
            document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
            document.frmitemmaster.action="pricematerialexchangerate.jsp";
            document.frmitemmaster.submit();
        }       
        
        function checkGol1(){
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_1]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL1_MARGIN]%>.value;                        
            var ppn_val=0;            
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                  
            mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;            
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL1_MARGIN]%>.value = formatFloat(mar, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
        }
        
        function checkMargin1(){                    
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_1]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL1_MARGIN]%>.value;	  
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                  
            var ppn_val=0;                
            st=((100/(100-parseFloat(mar)))* (parseFloat(cog)));
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_1]%>.value = formatFloat(st, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
        }
        
        
        
        function checkGol2(){            
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_2]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL2_MARGIN]%>.value;	            
            var ppn_val=0;
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                                          
            mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL2_MARGIN]%>.value =mar; 
        }
        function checkMargin2(){
            //alert("tes");
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_2]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL2_MARGIN]%>.value;	
            //var ppn_val=document.frmitemmaster.ppn_value.value;
            var ppn_val=0;
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
            st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
            
            
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_2]%>.value =st; 
        }
        
        function checkGol3(){
            //alert("tes");
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_3]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL3_MARGIN]%>.value;	
            //var ppn_val=document.frmitemmaster.ppn_value.value;
            var ppn_val=0;
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                             
            //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
            mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
            
            
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL3_MARGIN]%>.value =mar; 
        }
        function checkMargin3(){
            //alert("tes");
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_3]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL3_MARGIN]%>.value;	
            //var ppn_val=document.frmitemmaster.ppn_value.value;
            var ppn_val=0;
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
            st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
            
            
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_3]%>.value =st; 
        }
        
        function checkGol4(){
            //alert("tes");
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_4]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL4_MARGIN]%>.value;	
            
            //var ppn_val=document.frmitemmaster.ppn_value.value;
            var ppn_val=0;
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
            //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
            mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
            
            
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL4_MARGIN]%>.value =mar; 
        }
        function checkMargin4(){            
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_4]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL4_MARGIN]%>.value;	            
            var ppn_val=0;
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	            
            st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_4]%>.value =st; 
        }
        
        function checkGol5(){            
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_5]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL5_MARGIN]%>.value;	            
            var ppn_val=0;
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                                          
            mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL5_MARGIN]%>.value =mar; 
        }
        function checkMargin5(){            
            var st = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_5]%>.value;	
            var cog = document.frmitemmaster.cogs.value;
            var mar = document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL5_MARGIN]%>.value;	            
            var ppn_val=0;
            cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	            
            st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
            document.frmitemmaster.<%=jspPriceType.colNames[jspPriceType.JSP_GOL_5]%>.value =st; 
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
                                <%@ include file="../main/hmenu.jsp"%>
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
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmitemmaster" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="startp" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="hidden_price_type_id" value="<%=oidPriceType%>">
                                                            <input type="hidden" name="ppn_value" value="<%=ppn_value%>">
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
                                                                                            <td class="tab" nowrap><div align="center">&nbsp;&nbsp;Price List&nbsp;&nbsp;</div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%if (oidItemMaster != 0) {%>
                                                                                            <td class="tabin" nowrap><div align="center">
                                                                                                    &nbsp;&nbsp;<a href="javascript:cmdToMinimumStock()" class="tablink">Minimum Stock</a>&nbsp;&nbsp;
                                                                                            </div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}%>
                                                                                            <%if (oidItemMaster != 0) {
    if (im.getForSale() == 1 && im.getNeedBom() == 1) {
                                                                                            %>
                                                                                            <td class="tabin"> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecipe()" class="tablink">BOM</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%
                }
            }%>
                                                                                            <%if (oidItemMaster != 0) {%>
                                                                                            <td class="tabin" nowrap><div align="center">
                                                                                                    &nbsp;&nbsp;<a href="javascript:cmdVendorItem()" class="tablink">Vendor Item</a>&nbsp;&nbsp;
                                                                                            </div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}%>
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

            } catch (Exception e) {
            }

                                                                            %>
                                                                            <tr>
                                                                                <td>
                                                                                    <table width="100%" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="fontarial">&nbsp;<i><B>Price List :</B></i></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td height="5"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>   
                                                                                                <table width="400" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr height="22">
                                                                                                        <td width="70" class="tablecell1">&nbsp;Item Master</td>
                                                                                                        <td class="fontarial">:&nbsp;<%=name%></td>
                                                                                                    </tr>  
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell1">&nbsp;C.O.G.S</td>
                                                                                                        <td>:&nbsp;<%=JSPFormater.formatNumber(itMaster.getCogs(), "#,###.##")%>
                                                                                                            <input type="hidden" name="cogs" value="<%=JSPFormater.formatNumber(itMaster.getCogs(), "#,###.##")%>" class="fontarial">  
                                                                                                        </td>
                                                                                                    </tr> 
                                                                                                    <%

            if (itMaster.getIs_bkp() == 1) {
                double ppn = Double.parseDouble(DbSystemProperty.getValueByName("PPN"));
                double ppn_val = (ppn / 100) * itMaster.getCogs();

                                                                                                    %>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell1">&nbsp;PPN</td>
                                                                                                        <td>:&nbsp;<%=DbSystemProperty.getValueByName("PPN")%><input type="hidden" size="5" readonly name="ppn" value="<%=DbSystemProperty.getValueByName("PPN")%>" > % </td>
                                                                                                    </tr> 
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell1">&nbsp;PPN value</td>
                                                                                                        <td>:&nbsp;<%=JSPFormater.formatNumber(ppn_val, "#,###.##")%><input type="hidden" size="10" readonly name="ppn_val" value="<%=JSPFormater.formatNumber(ppn_val, "#,###.##")%>" ></td>
                                                                                                    </tr> 
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>   
                                                                                                <table width="1600" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td colspan="2" class="tablearialhdr">Qty</td>                                                                                                        
                                                                                                        <td colspan="4" width="8%" class="tablearialhdr">GOL 1</td>
                                                                                                        <td colspan="4" width="8%" class="tablearialhdr">GOL 2</td>
                                                                                                        <td colspan="4" width="8%" class="tablearialhdr">GOL 3</td>
                                                                                                        <td colspan="4" width="8%" class="tablearialhdr">GOL 4</td>
                                                                                                        <td colspan="4" width="8%" class="tablearialhdr">GOL 5</td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="tablearialhdr">From</td>
                                                                                                        <td width="3%" class="tablearialhdr">To</td>
                                                                                                        
                                                                                                        <td width="5%" class="tablearialhdr">Margin (%)</td>
                                                                                                        <td width="5%" class="tablearialhdr">Seling Price</td>
                                                                                                        <td width="4%" class="tablearialhdr">Currency</td>
                                                                                                        <td width="5%" class="tablearialhdr">Diskon (%)</td>
                                                                                                        
                                                                                                        <td width="5%" class="tablearialhdr">Margin (%)</td>
                                                                                                        <td width="5%" class="tablearialhdr">Seling Price</td>
                                                                                                        <td width="4%" class="tablearialhdr">Currency</td>
                                                                                                        <td width="5%" class="tablearialhdr">Diskon (%)</td>
                                                                                                        
                                                                                                        <td width="5%" class="tablearialhdr">Margin (%)</td>
                                                                                                        <td width="5%" class="tablearialhdr">Seling Price</td>
                                                                                                        <td width="4%" class="tablearialhdr">Currency</td>
                                                                                                        <td width="5%" class="tablearialhdr">Diskon (%)</td>
                                                                                                        
                                                                                                        <td width="5%" class="tablearialhdr">Margin (%)</td>
                                                                                                        <td width="5%" class="tablearialhdr">Seling Price</td>
                                                                                                        <td width="4%" class="tablearialhdr">Currency</td>
                                                                                                        <td width="5%" class="tablearialhdr">Diskon (%)</td>
                                                                                                        
                                                                                                        <td width="5%" class="tablearialhdr">Margin (%)</td>
                                                                                                        <td width="5%" class="tablearialhdr">Seling Price</td>
                                                                                                        <td width="4%" class="tablearialhdr">Currency</td>
                                                                                                        <td width="5%" class="tablearialhdr">Diskon (%)</td>
                                                                                                    </tr>
                                                                                                    <%
            boolean edit = false;

            Vector vCurrency = DbCurrency.list(0, 0, "", DbCurrency.colNames[DbCurrency.COL_CURRENCY_CODE]);

            if (listPriceType != null && listPriceType.size() > 0) {
                for (int ix = 0; ix < listPriceType.size(); ix++) {

                    PriceType objPriceType = new PriceType();

                    objPriceType = (PriceType) listPriceType.get(ix);

                    if (priceType.getOID() == objPriceType.getOID()) {

                        edit = true;

                                                                                                    %>
                                                                                                    <input type="hidden" name="<%=jspPriceType.colNames[JspPriceType.JSP_ITEM_MASTER_ID]%>" value="<%=oidItemMaster%>">
                                                                                                    <tr height="23">
                                                                                                        <td class="tablearialcell"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_QTY_FROM]%>" size="4" value="<%=priceType.getQtyFrom()%>" style="text-align:right" ><%= jspPriceType.getErrorMsg(jspPriceType.JSP_QTY_FROM) %></td>
                                                                                                        <td class="tablearialcell"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_QTY_TO]%>" size="4" value="<%=priceType.getQtyTo()%>" style="text-align:right"><%= jspPriceType.getErrorMsg(jspPriceType.JSP_QTY_TO)%></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL1_MARGIN]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol1_margin(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkMargin1()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_1]%>" size="10" value="<%=JSPFormater.formatNumber(priceType.getGol1(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkGol1()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL1]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol1()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                                for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                                    Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol1()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL1_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol1Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL2_MARGIN]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol2_margin(), "#,###.##") %>" style="text-align:right" onChange="javascript:checkMargin2()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_2]%>" size="10" value="<%=JSPFormater.formatNumber(priceType.getGol2(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkGol2()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL2]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol2()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                                for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                                    Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol2()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL2_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol2Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL3_MARGIN]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol3_margin(), "#,###.##")%>" style="text-align:right" onChange="javascript:checkMargin3()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_3]%>" size="10" value="<%=JSPFormater.formatNumber(priceType.getGol3(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkGol3()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL3]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol3()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                                for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                                    Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol3()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL3_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol3Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL4_MARGIN]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol4_margin(), "#,###.##") %>" style="text-align:right" onChange="javascript:checkMargin4()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_4]%>" size="10" value="<%=JSPFormater.formatNumber(priceType.getGol4(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkGol4()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL4]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol4()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                                for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                                    Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol4()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL4_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol4Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>            
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL5_MARGIN]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol5_margin(), "#,###.##") %>" style="text-align:right" onChange="javascript:checkMargin5()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_5]%>" size="10" value="<%=JSPFormater.formatNumber(priceType.getGol5(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkGol5()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL5]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol5()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                                for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                                    Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol5()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL5_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol5Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%} else {%>    
                                                                                                    <tr height="23">
                                                                                                        <td class="tablearialcell1" align="center"><a href="javascript:cmdEdit('<%=objPriceType.getOID()%>')"><%=objPriceType.getQtyFrom()%></a></td>
                                                                                                        <td class="tablearialcell1" align="center"><%=objPriceType.getQtyTo()%></td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol1_margin(), "#,###.##")%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol1(), "#,###.##")%>&nbsp;</td>
                                                                                                        <%
                                                                                                                Currency c1 = new Currency();
                                                                                                                c1.setCurrencyCode("-");
                                                                                                                try {
                                                                                                                    if (objPriceType.getCurrGol1() != 0) {
                                                                                                                        c1 = DbCurrency.fetchExc(objPriceType.getCurrGol1());
                                                                                                                    }
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                        %>
                                                                                                        <td class="tablearialcell1" align="right"><%=c1.getCurrencyCode()%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol1Diskon(), "#,###.##")%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol2_margin(), "#,###.##")%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol2(), "#,###.##")%>&nbsp;</td>
                                                                                                        <%
                                                                                                                Currency c2 = new Currency();
                                                                                                                c2.setCurrencyCode("-");
                                                                                                                try {
                                                                                                                    if (objPriceType.getCurrGol2() != 0) {
                                                                                                                        c2 = DbCurrency.fetchExc(objPriceType.getCurrGol2());
                                                                                                                    }
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                        %>
                                                                                                        <td class="tablearialcell1" align="right"><%=c2.getCurrencyCode()%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol2Diskon(), "#,###.##")%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol3_margin(), "#,###.##")%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol3(), "#,###.##")%>&nbsp;</td>
                                                                                                        <%
                                                                                                                Currency c3 = new Currency();
                                                                                                                c3.setCurrencyCode("-");
                                                                                                                try {
                                                                                                                    if (objPriceType.getCurrGol3() != 0) {
                                                                                                                        c3 = DbCurrency.fetchExc(objPriceType.getCurrGol3());
                                                                                                                    }
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                        %>
                                                                                                        <td class="tablearialcell1" align="right"><%=c3.getCurrencyCode()%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol3Diskon(), "#,###.##")%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol4_margin(), "#,###.##")%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol4(), "#,###.##")%>&nbsp;</td>
                                                                                                        <%
                                                                                                                Currency c4 = new Currency();
                                                                                                                c4.setCurrencyCode("-");
                                                                                                                try {
                                                                                                                    if (objPriceType.getCurrGol4() != 0) {
                                                                                                                        c4 = DbCurrency.fetchExc(objPriceType.getCurrGol4());
                                                                                                                    }
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                        %>
                                                                                                        <td class="tablearialcell1" align="right"><%=c4.getCurrencyCode()%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol4Diskon(), "#,###.##")%>&nbsp;</td>                                                                                                        
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol5_margin(), "#,###.##")%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol5(), "#,###.##")%>&nbsp;</td>
                                                                                                        <%
                                                                                                                Currency c5 = new Currency();
                                                                                                                c5.setCurrencyCode("-");
                                                                                                                try {
                                                                                                                    if (objPriceType.getCurrGol5() != 0) {
                                                                                                                        c5 = DbCurrency.fetchExc(objPriceType.getCurrGol5());
                                                                                                                    }
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                        %>
                                                                                                        <td class="tablearialcell1" align="right"><%=c5.getCurrencyCode()%>&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(objPriceType.getGol5Diskon(), "#,###.##")%>&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%
                }
            }
                                                                                                    %>
                                                                                                    <%
            if (edit== false && (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0))) {

                                                                                                    %>
                                                                                                    <input type="hidden" name="<%=jspPriceType.colNames[JspPriceType.JSP_ITEM_MASTER_ID]%>" value="<%=oidItemMaster%>">
                                                                                                    <tr height="23">
                                                                                                        <td class="tablearialcell1"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_QTY_FROM]%>" size="4" value="<%=priceType.getQtyFrom()%>" style="text-align:right"></td>
                                                                                                        <td class="tablearialcell1"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_QTY_TO]%>" size="4" value="<%=priceType.getQtyTo()%>" style="text-align:right"></td>                                                                                                        
                                                                                                        <td class="tablearialcell1" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL1_MARGIN]%>" size="8" value="<%=priceType.getGol1_margin() %>" style="text-align:right" onChange="javascript:checkMargin1()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell1" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_1]%>" size="10" value="<%=priceType.getGol1()%>" style="text-align:right" onChange="javascript:checkGol1()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell1" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL1]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol1()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                        for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                            Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol1()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell1" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL1_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol1Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL2_MARGIN]%>" size="8" value="<%=priceType.getGol1_margin() %>" style="text-align:right" onChange="javascript:checkMargin2()" onClick="this.select()"></td>                                                                                                        
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_2]%>" size="10" value="<%=priceType.getGol2()%>" style="text-align:right" onBlur="javascript:checkGol2()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell1" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL2]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol2()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                        for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                            Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol2()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell1" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL2_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol2Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL3_MARGIN]%>" size="8" value="<%=priceType.getGol1_margin() %>" style="text-align:right" onChange="javascript:checkMargin3()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_3]%>" size="10" value="<%=priceType.getGol3()%>" style="text-align:right" onBlur="javascript:checkGol3()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell1" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL3]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol3()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                        for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                            Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol3()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell1" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL3_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol3Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL4_MARGIN]%>" size="8" value="<%=priceType.getGol1_margin() %>" style="text-align:right" onChange="javascript:checkMargin4()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_4]%>" size="10" value="<%=priceType.getGol4()%>" style="text-align:right" onBlur="javascript:checkGol4()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell1" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL4]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol4()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                        for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                            Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol4()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell1" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL4_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol4Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL5_MARGIN]%>" size="8" value="<%=priceType.getGol1_margin() %>" style="text-align:right" onChange="javascript:checkMargin5()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL_5]%>" size="10" value="<%=priceType.getGol5()%>" style="text-align:right" onBlur="javascript:checkGol5()" onClick="this.select()"></td>
                                                                                                        <td class="tablearialcell1" align="right">
                                                                                                            <select name="<%=jspPriceType.colNames[JspPriceType.JSP_CURR_GOL5]%>">
                                                                                                                <option value="0" <%if (0 == priceType.getCurrGol5()) {%> selected<%}%> >-</option>
                                                                                                                <%
                                                                                                        for (int c = 0; c < vCurrency.size(); c++) {
                                                                                                            Currency curr = (Currency) vCurrency.get(c);
                                                                                                                %>
                                                                                                                <option value="<%=curr.getOID()%>" <%if (curr.getOID() == priceType.getCurrGol5()) {%> selected<%}%> ><%=curr.getCurrencyCode()%></option>
                                                                                                                
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td class="tablearialcell1" align="right"><input type="text" name="<%=jspPriceType.colNames[JspPriceType.JSP_GOL5_DISKON]%>" size="8" value="<%=JSPFormater.formatNumber(priceType.getGol5Diskon(), "#,###.##")%>" style="text-align:right" onClick="this.select()"></td>
                                                                                                        
                                                                                                    </tr> 
                                                                                                    <%
            }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td colspan="6">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (iErrCode > 0) {%>
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
                                                                                                    <%if (saveSuccess) {%>
                                                                                                    <tr>
                                                                                                        <td colspan="6" align="left">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                <tr>
                                                                                                                    <td width="20"><img src="<%=approot%>/images/success.gif" width="20" height="20"></td>
                                                                                                                    <td width="100" nowrap class="fontarial">Data is Saved</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if (deleteSuccess) {%>
                                                                                                    <tr>
                                                                                                        <td colspan="6" align="left">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                <tr>
                                                                                                                    <td width="20"><img src="<%=approot%>/images/success.gif" width="20" height="20"></td>
                                                                                                                    <td width="100" nowrap class="fontarial">Delete data success</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>                                                                                                   
                                                                                                    <tr>
                                                                                                        <td colspan="6">
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <%if (iJSPCommand == JSPCommand.BACK) {%>
                                                                                                                    <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0)) {%>
                                                                                                                    <td><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save21','','../images/save2.gif',1)"><img src="../images/save.gif" name="save21" height="22" border="0"></a></td>
                                                                                                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back21','','../images/back2.gif',1)"><img src="../images/back.gif" name="back21" height="22" border="0"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <%if (priceType.getOID() != 0) {%>
                                                                                                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:cmdDelete('<%=priceType.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del21','','../images/del2.gif',1)"><img src="../images/del.gif" name="del21" height="22" border="0"></a></td>
                                                                                                                    <%}%>
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
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>                                                        
                                                    </td>
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
