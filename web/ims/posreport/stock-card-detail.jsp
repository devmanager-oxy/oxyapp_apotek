
<%-- 
    Document   : addstockcode
    Created on : Des 08, 2011, 1:22:20 PM
    Author     : Ngurah
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
           // String txtSearch = JSPRequestValue.requestString(request, "txtSearch");
            //double maxStock = JSPRequestValue.requestDouble(request, "maxStock");
            //String codes = JSPRequestValue.requestString(request, "codes");
            //long transferId = JSPRequestValue.requestLong(request, "transferId");
            //long transferItemId = JSPRequestValue.requestLong(request, "transferItemId");
            long itemMasterId =JSPRequestValue.requestLong(request, "itemMasterId");
            int type_item =JSPRequestValue.requestInt(request, "type_item");
            String startDate = JSPRequestValue.requestString(request, "src_start_date");
            String endDate = JSPRequestValue.requestString(request, "src_end_date");
            
            Location location = new Location();
            ItemMaster itemMaster = new ItemMaster();
            
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            if(startDate != ""){
                srcStartDate = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(endDate, "dd/MM/yyyy");
            }
            
            Vector vStock = new Vector();
            vStock= SessStockReport.getDetailStock(JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd"), JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd"), locationId, itemMasterId, type_item);
            long start = srcStartDate.getTime();
            long end = srcEndDate.getTime();
            long lama = (end-start)/(24*60*60*1000) ; 
            Vector vstockDetail = new Vector();
            for(int i=0;i<(lama+1);i++){
                srcStartDate.setDate(srcStartDate.getDate()+i);
            }
            if(srcStartDate == srcEndDate){
                
            }
            
               
            if (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.ACTIVATE){

               // String where = "";
                
                //if(whereSD.length() > 0){
               //     where = whereSD;
                //}
                
               // if (txtSearch.length() > 0) {
                    
                //    if(where.length() > 0){
                 //       where = where + " AND " + DbStockCode.colNames[DbStockCode.COL_CODE] + " like '%" + txtSearch + "%' ";
                 //   }else{
                 //       where = DbStockCode.colNames[DbStockCode.COL_CODE] + " like '%" + txtSearch + "%' ";
                 //   }
               // }
                
               // if(where.length() > 0){
               //     where= where + " and " + DbStockCode.colNames[DbStockCode.COL_TYPE_ITEM] + "=" + type;
               // }else{
               //     where = DbStockCode.colNames[DbStockCode.COL_TYPE_ITEM] + "=" + type;
               // }
                
               // vStockCode = DbStockCode.getAddStockCode(locationId,itemMasterId, where);
                
                //size = vStockCode.size();
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
            
            
                    
                    function cmdShowStockCode(){                   
                        document.frmstockcardDetailCons.command.value="<%=JSPCommand.LIST%>";
                        document.frmstockcardDetailCons.action="stock-card-detail-Non-Consigment.jsp";
                        document.frmstockcardDetailCons.submit();
                    }
                    function cmdShowSumary(){                   
                        document.frmstockcardDetailCons.command.value="<%=JSPCommand.NONE%>";
                        document.frmstockcardDetailCons.action="stock-card-detail-Non-Consigment.jsp";
                        document.frmstockcardDetailCons.submit();
                    }
                    //-------------- script form image -------------------
                    function cmdDelPict(oidCashReceiveDetail){
                        document.frmaddstockcode.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                        document.frmaddstockcode.command.value="<%=JSPCommand.POST%>";
                        document.frmaddstockcode.action="stock-card-detail-Non-Consigment.jsp";
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
            <form name="frmstockcardDetailCons" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="locationId" value="<%=locationId%>">
                
                <input type="hidden" name="type_item" value="<%=type_item%>">
                
                
                <input type="hidden" name="OID_STOCK_CODE" value="">
                <input type="hidden" name="src_start_date" value="<%=startDate%>">
                <input type="hidden" name="src_end_date" value="<%=endDate%>">
                <input type="hidden" name="itemMasterId" value="<%=itemMasterId%>">                            
                 <tr>
                    <td colspan="2" height="10"></td>
                </tr>
                 <%
                try{
                    location = DbLocation.fetchExc(locationId);
                    itemMaster = DbItemMaster.fetchExc(itemMasterId);
                }catch(Exception e){
                    
                }
                %>
                
               <tr>
                    <td colspan="2">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td  height="10" width="20%"><b>Location Name</b></td>
                            <td  height="10"  width="2%" align="left"><b>:</b></td>
                            <td  height="10" align="left" width="75%"><%=location.getName()%> </td>
                        </tr>
                        <tr>
                            <td  height="10" width="20%"><b>Item Name</b></td>
                            <td  height="10" width="2%" align="left"><b>:</b></td>
                            <td  height="10" align="left" width="75%"><%=itemMaster.getName()%> </td>
                        </tr>
                    </table>
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2" height="15"></td>
                </tr>
                
                <tr> 
                    <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                </tr>
                <tr>
                    <td colspan="2" height="15"></td>
                </tr>
                
                
                <%
            if (vStock != null ) {

                int pg = 1;
                
                    
                
                %>
                <tr>
                    <td colspan="2">
                        <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                                
            <td width="7%" class="tablehdr">No</td>
                                
            <td width="18%" class="tablehdr">Date</td>
                                
            <td width="39%" class="tablehdr">Description</td>
                                
            <td width="18%" class="tablehdr">Qty In</td>
                                
            <td width="18%" class="tablehdr">Qty Out</td>
                            </tr>   
                            <%
             
                    double sumQtyIn =0;
                    double sumQtyOut =0;
                    Vector vStokCode = new Vector();
                    Vector vStokCodeAvb = new Vector();
                    for (int sc = 0; sc < vStock.size(); sc++) {

                        Stock stock = (Stock) vStock.get(sc);
                        if(iJSPCommand==JSPCommand.LIST){
                            if(stock.getIncomingId()!=0){
                                vStokCode = DbStockCode.getStockCode(locationId, itemMasterId, " " + DbStockCode.colNames[DbStockCode.COL_RECEIVE_ID]+ "=" + stock.getIncomingId(),type_item);
                            }else if(stock.getTransferId()!=0){
                                vStokCode = DbStockCode.getStockCode(locationId, itemMasterId, " " + DbStockCode.colNames[DbStockCode.COL_TRANSFER_ID]+ "=" + stock.getTransferId(), type_item);
                            }else if(stock.getSalesDetailId()!=0){
                                vStokCode = DbStockCode.getStockCode(locationId, itemMasterId, " " + DbStockCode.colNames[DbStockCode.COL_SALES_DETAIL_ID]+ "=" + stock.getSalesDetailId(), type_item);
                            }
                            if(stock.getItemMasterId()!=0){
                                vStokCodeAvb = DbStockCode.getStockCode(locationId, itemMasterId, " " + DbStockCode.colNames[DbStockCode.COL_IN_OUT]+ "=" + DbStockCode.STOCK_IN, type_item);
                            }
                            
                        }
                        
                            double qtyIn=0;
                            double qtyOut =0;
                            double qtyInOut = stock.getQty() * stock.getInOut();
                            if(qtyInOut<0){
                                qtyOut= qtyInOut * -1;
                                sumQtyOut = sumQtyOut + qtyOut;
                            } else{
                                qtyIn= qtyInOut;
                                sumQtyIn= sumQtyIn + qtyIn;
                            }
                            
                            %>
                            <tr>
                                <% 
                                Transfer transfer = new Transfer();
                                Location loca = new Location();
                                try{
                                    if(stock.getTransferId()!=0){
                                        transfer= DbTransfer.fetchExc(stock.getTransferId());
                                        if(stock.getType()== DbStock.TYPE_TRANSFER){
                                            loca = DbLocation.fetchExc(transfer.getToLocationId());
                                        }else if(stock.getType()== DbStock.TYPE_TRANSFER_IN){
                                            loca = DbLocation.fetchExc(transfer.getFromLocationId());
                                        }
                                    }
                                    
                                }catch(Exception e) {
                                    
                                }
                                %>
            <%if(pg%2==0){%>                    
            <td width="7%" class= "tablecell1" align="center"><%=pg%></td>
                                
            <td width="18%" class= "tablecell1"><%=JSPFormater.formatDate(stock.getDate(), "dd-MM-yyyy")%></td>
            <% if(stock.getType()==DbStock.TYPE_TRANSFER ){%>
                <td width="39%" class= "tablecell1"><%=DbStock.strType[stock.getType()]%> to <%=loca.getName()%></td>
            <%}else if( stock.getType()==DbStock.TYPE_TRANSFER_IN){%>
                <td width="39%" class= "tablecell1"><%=DbStock.strType[stock.getType()]%> from <%=loca.getName()%></td>
            <%}else{%>    
                <td width="39%" class= "tablecell1"><%=DbStock.strType[stock.getType()]%></td>
            <%}%>
                                
            <td width="18%" class= "tablecell1"><%=qtyIn%></td>
                                
            <td width="18%" class= "tablecell1"><%=qtyOut%></td>
                            </tr>
                            <%
                            if(vStokCode != null){
                                for(int i=0; i<vStokCode.size();i++){
                                    StockCode stockCode = (StockCode ) vStokCode.get(i);  
                                    
                                    %>
                                     <tr>
                                
                                <td width="7%" class= "tablecell1"></td>

                                <td width="18%" class= "tablecell1"></td>

                                <td width="39%" class= "tablecell1"><%=stockCode.getCode()%></td>

                                <td width="18%" class= "tablecell1"></td>

                                <td width="18%" class= "tablecell1"></td>
                            </tr>
                               <% }
                            }
                            
                        pg++;
                        }else{%>
                            <td width="7%" class= "tablecell" align="center"><%=pg%></td>
                                
            <td width="18%" class= "tablecell"><%=JSPFormater.formatDate(stock.getDate(), "dd-MM-yyyy")%></td>
            <% if(stock.getType()==DbStock.TYPE_TRANSFER ){%>
                <td width="39%" class= "tablecell"><%=DbStock.strType[stock.getType()]%> to <%=loca.getName()%></td>
            <%}else if( stock.getType()==DbStock.TYPE_TRANSFER_IN){%>
                <td width="39%" class= "tablecell"><%=DbStock.strType[stock.getType()]%> from <%=loca.getName()%></td>
            <%}else{%>    
                <td width="39%" class= "tablecell"><%=DbStock.strType[stock.getType()]%></td>
            <%}%>
                                
            <td width="18%" class= "tablecell"><%=qtyIn%></td>
                                
            <td width="18%" class= "tablecell"><%=qtyOut%></td>
                            </tr>
                            <%
                            if(vStokCode != null){
                                for(int i=0; i<vStokCode.size();i++){
                                    StockCode stockCode = (StockCode ) vStokCode.get(i);  
                                    
                                    %>
                                     <tr>
                                
                                <td width="7%" class= "tablecell"></td>

                                <td width="18%" class= "tablecell"></td>

                                <td width="39%" class= "tablecell"><%=stockCode.getCode()%></td>

                                <td width="18%" class= "tablecell"></td>

                                <td width="18%" class= "tablecell"></td>
                            </tr>
                               <% }
                            }
                            
                        pg++;        
                        }
     }
                        
                            %> 
                            <tr>
                                
                                <td width="7%" class= "tablecell" align="center"></td>

                                <td width="18%" class= "tablecell"></td>

                                <td width="39%" class= "tablecell" align="center"><b>Total</b></td>

                                <td width="18%" class= "tablecell"><b><%=sumQtyIn%></b></td>

                                <td width="18%" class= "tablecell"><b><%=sumQtyOut%><b></td>
                            </tr>
                           <tr>
                                
                                <td width="7%" class= "tablecell" align="center"></td>

                                <td width="18%" class= "tablecell"></td>

                                <td width="39%" class= "tablecell" align="center"><b>Qty Saldo</b></td>

                                <td width="18%" colspan="2" class= "tablecell"><b><%=sumQtyIn-sumQtyOut%></b></td>

                                
                            </tr>
                            <% 
                                if(vStokCodeAvb.size()>0){
                                    for(int i=0; i<vStokCodeAvb.size();i++){
                                    StockCode stockCode = (StockCode ) vStokCodeAvb.get(i);  
                                    
                                    %>
                                <tr>
                                
                                    <td width="7%" class= "tablecell"></td>

                                    <td width="18%" class= "tablecell"></td>

                                    <td width="39%" class= "tablecell"><%=stockCode.getCode()%></td>

                                    <td width="18%" class= "tablecell"></td>

                                    <td width="18%" class= "tablecell"></td>
                                </tr>
                           <%}
                           }%>
                            
            
            <tr>
                <td colspan="3">&nbsp;</td>                               
            </tr>                    
                          
                        </table>    
                    </td>
                </tr>
                <tr> 
               <td colspan="2">
                   <%if((itemMaster.getApplyStockCode()!= DbItemMaster.NON_APPLY_STOCK_CODE) || (itemMaster.getApplyStockCodeSales()!= DbItemMaster.NON_APPLY_STOCK_CODE_SALES)){%>
                        <table width="100%" border="0" cellpadding="0" cellspacing="1">   
                            <tr>
                            <td width="15%"><a href="javascript:cmdShowStockCode()"> Preview Serial Number</a></td>
                            <td width="15%"><a href="javascript:cmdShowSumary()"> Preview Summary</a></td>
                            </tr  
                        </table>
                   <%}%>
               </td>
               
            
            </tr>  
                  <%}%>
                
                
                
                <tr>
                    <td colspan="2" height="10"></td>
                </tr>
                <tr> 
                    <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                </tr>
                <tr>
                    <td colspan="2" height="15"></td>
                </tr>
                
            
            </form>
            <tr height = "40px">
                <td>&nbsp;</td>
            </tr>
        </table>
    </body>
</html>
