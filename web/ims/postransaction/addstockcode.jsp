
<%-- 
    Document   : addstockcode
    Created on : Oct 18, 2011, 1:22:20 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<!-- Jsp Block -->
<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);

            long locationId = JSPRequestValue.requestLong(request, "locationId");
            String txtSearch = JSPRequestValue.requestString(request, "txtSearch");
            double maxStock = JSPRequestValue.requestDouble(request, "maxStock");
            String codes = JSPRequestValue.requestString(request, "codes");
            long transferId = JSPRequestValue.requestLong(request, "transferId");
            long transferItemId = JSPRequestValue.requestLong(request, "transferItemId");
            long itemMasterId =JSPRequestValue.requestLong(request, "itemMasterId");
            int type =JSPRequestValue.requestInt(request, "type");
            String[] cods;
            StringTokenizer strTokenizerCondition = new StringTokenizer(codes, ",");
            cods = new String[strTokenizerCondition.countTokens()];
            
            String whereSD = "";
            
            while (strTokenizerCondition.hasMoreTokens()) {
                
                if(whereSD.length() <= 0){
                    whereSD = ""+DbStockCode.colNames[DbStockCode.COL_STOCK_CODE_ID]+" != "+strTokenizerCondition.nextToken();
                }else{
                    whereSD = whereSD + " AND "+DbStockCode.colNames[DbStockCode.COL_STOCK_CODE_ID]+" != "+strTokenizerCondition.nextToken();
                }
                
            }

            int maxStockCode = 0;

            for (double idob = 0; idob < maxStock; idob++) {
                maxStockCode++;
            }

            int stockSize = JSPRequestValue.requestInt(request, "stockReady");

            int stockCanGet = maxStockCode - stockSize;  //Adalah stock yang bisa diambil

            int size = 0;
            Vector vStockCode = new Vector();

            if (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.ACTIVATE){

                String where = "";
                
                if(whereSD.length() > 0){
                    where = whereSD;
                }
                
                if (txtSearch.length() > 0) {
                    
                    if(where.length() > 0){
                        where = where + " AND " + DbStockCode.colNames[DbStockCode.COL_CODE] + " like '%" + txtSearch + "%' ";
                    }else{
                        where = DbStockCode.colNames[DbStockCode.COL_CODE] + " like '%" + txtSearch + "%' ";
                    }
                }
                
                if(where.length() > 0){
                    where= where + " and " + DbStockCode.colNames[DbStockCode.COL_TYPE_ITEM] + "=" + type;
                }else{
                    where = DbStockCode.colNames[DbStockCode.COL_TYPE_ITEM] + "=" + type;
                }
                
                vStockCode = DbStockCode.getAddStockCode(locationId,itemMasterId, where);
                
                size = vStockCode.size();
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <style type="text/css">
            .style1 {color: #FF0000}
        </style>
        <script language="JavaScript">
            
            function cmdSelect(transferId,transferItemId){
                
                <%
            if (stockCanGet <= 0) {
                %>    
                    self.opener.document.frmtransfer.OID_STOCK_CODE.value = "";
                    self.opener.document.frmtransfer.hidden_transfer_item_id.value = transferItemId;
                    self.opener.document.frmtransfer.hidden_transfer_id.value = transferId;
                    self.opener.document.frmtransfer.command.value="<%=JSPCommand.VIEW%>";    
                    self.opener.document.frmtransfer.submit();                
                    self.close();  
                <%
            } else {
                
                %>
                    var txs = "";
                    var loop = <%=stockCanGet%>;                    
                    var minus = "0";
                    
                <%
                for (int sc = 0; sc < size; sc++) {

                    String chk = "CHECK" + sc;
                    String oid = "OID_STOCK" + sc;
                %>    
                    if(document.frmaddstockcode.<%=chk%>.checked == true){                        
                        loop --;
                        
                        if(loop < 0){
                            minus = 1;
                        }    
                        
                        var txt = document.frmaddstockcode.<%=oid%>.value;
                        if(txs.length <= 0){
                            txs = txt;
                        }else{
                        txs = txs+","+txt; 
                    }   
                    
                }    
                <%
                }
                %>  
                    if(minus == 1){
                        alert("You can only select "+<%=stockCanGet%>+" item(s)");
                    }else{    
                        self.opener.document.frmtransfer.OID_STOCK_CODE.value = txs;
                        self.opener.document.frmtransfer.hidden_transfer_item_id.value = transferItemId;
                        self.opener.document.frmtransfer.hidden_transfer_id.value = transferId;
                        self.opener.document.frmtransfer.command.value="<%=JSPCommand.VIEW%>";    
                        self.opener.document.frmtransfer.submit();                
                        self.close();  
                    }
                    <%
            }
                    %>
                    }
                    
                    function cmdSearch(){                   
                        document.frmaddstockcode.command.value="<%=JSPCommand.LIST%>";
                        document.frmaddstockcode.action="addstockcode.jsp";
                        document.frmaddstockcode.submit();
                    }
                    //-------------- script form image -------------------
                    function cmdDelPict(oidCashReceiveDetail){
                        document.frmaddstockcode.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                        document.frmaddstockcode.command.value="<%=JSPCommand.POST%>";
                        document.frmaddstockcode.action="addstockcode.jsp";
                        document.frmaddstockcode.submit();
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
    <body> 
        <table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
            <form name="frmaddstockcode" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="locationId" value="<%=locationId%>">
                <input type="hidden" name="stockReady" value="<%=stockSize%>">
                <input type="hidden" name="locationId" value="<%=locationId%>">
                <input type="hidden" name="maxStock" value="<%=maxStock%>">                
                <input type="hidden" name="codes" value="<%=codes%>">                    
                <input type="hidden" name="OID_STOCK_CODE" value="">
                <input type="hidden" name="transferId" value="<%=transferId%>">    
                <input type="hidden" name="transferItemId" value="<%=transferItemId%>">                            
                <input type="hidden" name="itemMasterId" value="<%=itemMasterId%>">                            
                <input type="hidden" name="type" value="<%=type%>">                            
                <tr>
                    <td colspan="2" height="20">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table border="0">
                            <tr>
                                <td width="40">Code</td>
                                <td width="140"><input type="text" name="txtSearch" value="<%=txtSearch%>"></td>
                                <td><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new1" width="59" height="21" border="0"></a></td>
                            </tr>
                        </table>   
                    </td>
                </tr>
                <tr>
                    <td colspan="2" height="10"></td>
                </tr>
                <tr> 
                    <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                </tr>
                <tr>
                    <td colspan="2" height="15"></td>
                </tr>
                <%
            if (vStockCode != null && vStockCode.size() > 0) {

                int pg = 1;
                %>
                <tr>
                    <td colspan="2">
                        <table width="80%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                                <td width="6%" class="tablehdr">No</td>
                                <td width="90%" class="tablehdr">Code</td>
                                <td width="4%" class="tablehdr">Action</td>
                            </tr>   
                            <%

                    for (int sc = 0; sc < vStockCode.size(); sc++) {

                        StockCode stockCode = (StockCode) vStockCode.get(sc);

                            %>
                            <tr>
                                <td width="10%" class= "tablecell" align="center"><%=pg%></td>
                                <td width="80%" class= "tablecell">&nbsp;<%=stockCode.getCode()%></td>
                                <td width="10%" class= "tablecell" align="center">
                                    <input type="checkbox" name="CHECK<%=sc%>" value="1">
                                    <input type="hidden" name="OID_STOCK<%=sc%>" value="<%=stockCode.getOID()%>">
                                </td>
                            </tr>
                            <%
                        pg++;
                    }
                            %>   
                            <tr>
                                <td colspan="3">&nbsp;</td>                               
                            </tr>                    
                            <tr>
                                <td colspan="3">
                                    <a href="javascript:cmdSelect('<%=transferId%>','<%=transferItemId%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/add.gif',1)"><img src="../images/add2.gif" name="new21" height="22" border="0" style="padding:0px"></a> 
                                </td>                               
                            </tr>
                        </table>    
                    </td>
                </tr>
                <%}%>
            </form>
            <tr height = "40px">
                <td>&nbsp</td>
            </tr>
        </table>
    </body>
</html>
