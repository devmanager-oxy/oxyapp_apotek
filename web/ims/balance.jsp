<%-- 
    Document   : stockbalance
    Created on : Jan 24, 2013, 9:10:40 AM
    Author     : Ngurah Wirata
--%>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.repack.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.adjusment.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>

<%@ page import = "com.project.util.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%
String approot="/oxyapp/ims/";
Date srcStartDate = new Date();
Date srcStartDateKolom = new Date();
Date srcStartDateTemp = new Date();
Date srcEndDate = new Date();
int iJSPCommand = JSPRequestValue.requestCommand(request);
String startDate = JSPRequestValue.requestString(request, "src_start_date");
String endDate = JSPRequestValue.requestString(request, "src_end_date");
long srcType = JSPRequestValue.requestLong(request, "src_type");
String srcNumber = JSPRequestValue.requestString(request, "number");
if(startDate != ""){
                srcStartDate = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcStartDateKolom = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcStartDateTemp = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(endDate, "dd/MM/yyyy");
}

long start = srcStartDate.getTime();
long end = srcEndDate.getTime();
long lama = (end-start)/(24*60*60*1000) ; 


%>


<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />

<script language="JavaScript">
    
function cmdSearch(){
	
        document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
	document.frmadjusment.action="balance.jsp";
	document.frmadjusment.submit();
}
function cmdTransferBalance(){
	
        document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
	document.frmadjusment.action="stockbalance1.jsp";
	document.frmadjusment.submit();
        
}
function cmdIncomingBalance(){
	
        document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
	document.frmadjusment.action="stockbalance1.jsp";
	document.frmadjusment.submit();
        
}



</script>



<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>STOCK BALANCE</title>
    </head>
    <body>
        <h2>STOCK BALANCING</h2>
        <tr>
            
            <td>
                
                <form name="frmadjusment" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <table border="1">       
                
                <tr>
                     <td width="6%">Transaction Type</td>
                    <td width="38%" colspan="3"> 
                                                  <select name="src_type">
                                                   
                                                    <option value="0" <%if(srcType==0){%>selected<%}%>>Incoming</option>
                                                    <option value="1" <%if(srcType==1){%>selected<%}%>>Transfer</option>
                                                    <option value="2" <%if(srcType==2){%>selected<%}%>>Retur</option>
                                                    <option value="3" <%if(srcType==3){%>selected<%}%>>Costing</option>
                                                    <option value="4" <%if(srcType==4){%>selected<%}%>>Repack</option>
                                                    <option value="5" <%if(srcType==5){%>selected<%}%>>Adjusment</option>
                                                  </select>
                    
                </tr>
                <tr>
                     <td width="6%">Number</td>
                     <td width="38%" colspan="3"><input type="text" name="number" ></td> 
                                                 
                    
                </tr>
                
                 
                 <tr> 
                                                    <td width="6%">Periode</td>
                                                    <td width="38%"> 
                                                      <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11">
                                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                      &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                      <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11">
                                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  </td>
                 </tr>
                 <tr>
                     <td>
                         <table>
                             <tr>
                                 <td width="6%"><a href="javascript:cmdSearch()">Search</a></td>
                                 
                             </tr>
                         </table>
                     </td>
                     
                 </tr>
             </table>
          
                 <%if(iJSPCommand==JSPCommand.FIRST){%>
                 <tr>
                     <td>
                     <table border="1" width="100%">
                         <tr>
                             <td>DATE</td>
                             <td>NUMBER</td>
                             <td>STATUS</td>
                             <td>RECORD TRANS/RECORD STOCK</td>
                             
                         </tr>
                         <%
                            Vector vTrans = new Vector();
                            if(srcType==0){

				    StringTokenizer strTok = new StringTokenizer(srcNumber, ",");
                                Vector loops = new Vector();
                                while(strTok.hasMoreElements()){
                                    loops.add(((String)strTok.nextToken()).trim());
                                }
                                
                                if(loops!=null && loops.size()>0){
                                    
                                    for(int x=0; x<loops.size(); x++){
                                        srcNumber = (String)loops.get(x);		

                                vTrans= DbReceive.list(0, 0, "number='" +  srcNumber + "' and type_ap=0 " , "");
                                Receive rec = new Receive();
                                if(vTrans.size()>0){
                                    
                                        rec = (Receive) vTrans.get(0);
                                        if(rec.getOID()!=0){
                                            DbStock.delete("incoming_id="+ rec.getOID());
                                            rec.setStatus("APPROVED");
                                            DbReceiveItem.proceedStock(rec);
                                            
                                        }
                                        
                                        
                            %>
                            <tr>
                                <td><%= JSPFormater.formatDate(rec.getDate(),"dd-MM-yyyy")%></td>
                                <td><%=rec.getNumber()%></td>
                                <td><%=rec.getStatus()%></td>
                                <%
                                    int stokTrans=0;
                                    int stock=0;
                                    stokTrans=DbReceiveItem.getCount(" receive_id=" + rec.getOID());
                                    stock=DbStock.getTotalStockByTransaksi(" incoming_id=" + rec.getOID()+" and location_id="+ rec.getLocationId());
                                %>
                                <%if(stock !=stokTrans){%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stock%></td> 
                                <%}else{%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                
                                <%}%>
                            </tr>
                                    <%//}
                                   }
				   }}
                                
                            %>    
                            
                            
                          <%  }else if(srcType==1){

				    StringTokenizer strTok = new StringTokenizer(srcNumber, ",");
                                Vector loops = new Vector();
                                while(strTok.hasMoreElements()){
                                    loops.add(((String)strTok.nextToken()).trim());
                                }
                                
                                if(loops!=null && loops.size()>0){
                                    
                                    for(int x=0; x<loops.size(); x++){
                                        srcNumber = (String)loops.get(x);
	
                                
                                 	     vTrans= DbTransfer.list(0, 0, "number='" + srcNumber + "'" , "");
                                 
                                		Transfer rec = new Transfer();
                                		if(vTrans.size()>0){
                                    	//for(int i =0;i< vTrans.size();i++){
                                        		rec = (Transfer) vTrans.get(0);
                                        		if(rec.getOID()!=0){
                                            		DbStock.delete("transfer_id="+rec.getOID());
                                            		Vector vTransferItem = new Vector();
                                           	 	vTransferItem = DbTransferItem.list(0, 0, "transfer_id="+rec.getOID(), "");
                                            		if(vTransferItem.size()>0){
                                                			for(int i=0;i<vTransferItem.size();i++){
                                                    			TransferItem ti = new TransferItem();
                                                    			ti= (TransferItem)vTransferItem.get(i);
                                                    		DbStock.insertTransferGoods(rec, ti);
                                                
                                            		}
                                        		}
                                        
                                        
                                        %>
                            <tr>
                                <td><%= JSPFormater.formatDate(rec.getDate(),"dd-MM-yyyy")%></td>
                                <td><%=rec.getNumber()%></td>
                                <td><%=rec.getStatus()%></td>
                                <%
                                    int stokTrans=0;
                                    int stockTin=0;
                                    int stockTout=0;
                                    stokTrans=DbTransferItem.getCount(" transfer_id=" + rec.getOID());
                                    stockTout=DbStock.getTotalStockByTransaksi(" transfer_id=" + rec.getOID() + " and location_id="+ rec.getFromLocationId() + " and type=2");
                                    stockTin=DbStock.getTotalStockByTransaksi(" transfer_id=" + rec.getOID() + " and location_id="+ rec.getToLocationId() + " and type=3");
                                    
                                    
                                %>
                                <%if(rec.getStatus().equalsIgnoreCase("APPROVED")){%>
                                    <%if(stockTin !=stokTrans || stockTout !=stokTrans){%>
                                        <td bgcolor="red"><%=stokTrans%>/<%=stockTin%>/<%=stockTout%></td> 
                                    <%}else{%>
                                        <td><%=stokTrans%>/<%=stockTin%></td> 

                                    <%}%>
                                <%}else{%>    
                                    <%if(stockTout !=stokTrans){%>
                                        <td bgcolor="red"><%=stokTrans%>/<%=stockTout%></td> 
                                    <%}else{%>
                                        <td><%=stokTrans%>/<%=stockTout%></td> 

                                    <%}%>
                                <%}%>
                            </tr>
                                    <%}
                                   }
					}}
                                
                            %>   
                           <% }else if(srcType==2){
                                vTrans= DbRetur.list(0, 0, "number='" + srcNumber + "'" , "");
                                Retur rec = new Retur();
                                if(vTrans.size()>0){
                                   // for(int i =0;i< vTrans.size();i++){
                                        rec = (Retur) vTrans.get(0);
                                        if(rec.getOID()!=0){
                                            DbStock.delete("retur_id="+ rec.getOID());
                                            rec.setStatus("APPROVED");
                                            DbReturItem.proceedStock(rec);
                                        }
                                        
                                        
                                        
                                        
                                        %>
                            <tr>
                                <td><%= JSPFormater.formatDate(rec.getDate(),"dd-MM-yyyy")%></td>
                                <td><%=rec.getNumber()%></td>
                                <td><%=rec.getStatus()%></td>
                                <%
                                    int stokTrans=0;
                                    int stock=0;
                                    stokTrans=DbReturItem.getCount(" retur_id=" + rec.getOID());
                                    stock=DbStock.getTotalStockByTransaksi(" retur_id=" + rec.getOID()+ " and location_id="+ rec.getLocationId());
                                    
                                %>
                                <%if(stock !=stokTrans){%>
                                    <td bgcolor="red"  ><%=stokTrans%>/<%=stock%></td> 
                                <%}else{%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                
                                <%}%>
                            </tr>
                                    <%//}
                                   }
                                
                            %>   
                           <%     
                            }else if(srcType==3){
                                vTrans= DbCosting.list(0, 0, "number='" + srcNumber + "'" , "");
                                Costing rec = new Costing();
                                if(vTrans.size()>0){
                                    //for(int i =0;i< vTrans.size();i++){
                                        rec = (Costing) vTrans.get(0); 
                                        if(rec.getOID()!=0){
                                            DbStock.delete("costing_id="+ rec.getOID());
                                            rec.setStatus("APPROVED");
                                            DbCostingItem.proceedStock(rec);
                                            
                                        }
                                        
                                        %>
                                        
                                        
                                <tr>
                                <td><%= JSPFormater.formatDate(rec.getDate(),"dd-MM-yyyy")%></td>
                                <td><%=rec.getNumber()%></td>
                                <td><%=rec.getStatus()%></td>
                                <%
                                    int stokTrans=0;
                                    int stock=0;
                                    stokTrans=DbCostingItem.getCount(" costing_id=" + rec.getOID());
                                    stock=DbStock.getTotalStockByTransaksi(" costing_id=" + rec.getOID()+ " and location_id="+ rec.getLocationId());
                                    
                                %>
                                <%if(stock !=stokTrans){%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stock%></td> 
                                <%}else{%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                
                                <%}%>
                                </tr>
                                    <%//}
                                   }
                                
                            %>   
                           <%     
                            }else if(srcType==4){
                                vTrans= DbRepack.list(0, 0, "number='" + srcNumber + "' " , "");
                                Repack rec = new Repack();
                                rec = (Repack) vTrans.get(0);
                                if(vTrans.size()>0){
                                    
                                        rec = (Repack) vTrans.get(0);
                                        if(rec.getOID()!=0){
                                            DbStock.delete("repack_id="+ rec.getOID());
                                           rec.setStatus("APPROVED");
                                           DbRepackItem.proceedStock(rec);
                                        }
                                        
                                        %>
                                <tr>
                                <td><%= JSPFormater.formatDate(rec.getDate(),"dd-MM-yyyy")%></td>
                                <td><%=rec.getNumber()%></td>
                                <td><%=rec.getStatus()%></td>
                                <%
                                    int stokTrans=0;
                                    int stock=0;
                                    stokTrans=DbRepackItem.getCount(" repack_id=" + rec.getOID());
                                    stock=DbStock.getTotalStockByTransaksi(" repack_id=" + rec.getOID());
                                    
                                %>
                                <%if(stock !=stokTrans){%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stock%></td> 
                                <%}else{%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                
                                <%}%>
                            </tr>
                                    <%//}
                                   }
                            
                                
                            %>
                            <%     
                            }else if(srcType==5){
                                vTrans= DbAdjusment.list(0, 0, "number='" + srcNumber + "' " , "");
                                Adjusment rec = new Adjusment();
                                rec = (Adjusment) vTrans.get(0);
                                if(vTrans.size()>0){
                                    
                                        rec = (Adjusment) vTrans.get(0);
                                        if(rec.getOID()!=0){
                                            DbStock.delete("adjustment_id="+ rec.getOID());
                                            rec.setStatus("APPROVED");
                                            DbAdjusmentItem.proceedStock(rec);
                                        }
                                        
                                        %>
                                <tr>
                                <td><%= JSPFormater.formatDate(rec.getDate(),"dd-MM-yyyy")%></td>
                                <td><%=rec.getNumber()%></td>
                                <td><%=rec.getStatus()%></td>
                                <%
                                    int stokTrans=0;
                                    int stock=0;
                                    stokTrans=DbAdjusmentItem.getCount(" adjusment_id=" + rec.getOID());
                                    stock=DbStock.getTotalStockByTransaksi(" adjustment_id=" + rec.getOID());
                                    
                                %>
                                <%if(stock !=stokTrans){%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stock%></td> 
                                <%}else{%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                
                                <%}%>
                            </tr>
                                    <%//}
                                   }
                            }
                                
                            %>
                            

                         
                         
                     </table>
                     
                     
                     
                     </td>
                 </tr>
                <%}%> 
             </form>
            </td>
            
                
           
            
        </tr>
        
        
        
    </body>
</html>
