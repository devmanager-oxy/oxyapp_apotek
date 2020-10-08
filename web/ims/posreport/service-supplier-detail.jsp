
<%-- 
    Document   : serviceleveldetail
  Created on : Mei 02, 2013, 1:22:20 PM
    Author     : Ngurah
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.JSPFormater" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<!-- Jsp Block -->

<%!
	public Vector drawList(Vector objectClass){
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		
		
                cmdist.addHeader("Date","5%");                
		cmdist.addHeader("PO Number","10%");
                cmdist.addHeader("Incoming Number","10%");
                cmdist.addHeader("SKU","10%");
                cmdist.addHeader("Barcode","10%");
                cmdist.addHeader("Name","34%");
		cmdist.addHeader("Qty PO","7%");
		cmdist.addHeader("Qty Inc","7%");
		cmdist.addHeader("Variant","7%");
				

		cmdist.setLinkRow(-1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;
                double totqtypo=0;
                double totqtyrec=0;
                Vector vold= new Vector(1);
		for(int i=0;i<objectClass.size();i++){
                    Vector rowx = new Vector();
                    Vector vtdet = new Vector();
                    vtdet = (Vector)objectClass.get(i);
                    
                        String t=(String) vtdet.get(1).toString();
                    
                    if(i!=0){
                       
                       
                        if(vtdet.get(0).toString().equalsIgnoreCase(vold.get(0).toString())){
                            rowx.add("");
                            rowx.add("");
                        }else{
                            rowx.add("<div align=\"center\">"+JSPFormater.formatDate(((Date)vtdet.get(7)),"dd-MMM-yyyy")+"</div>");
                            rowx.add(""+vtdet.get(0));
                        }
                    }else{
                        
                        rowx.add("<div align=\"center\">"+JSPFormater.formatDate(((Date)vtdet.get(7)),"dd-MMM-yyyy")+"</div>");
                        rowx.add(""+vtdet.get(0));
                    }
                        
                    
                    rowx.add(""+vtdet.get(1));
                    rowx.add(""+vtdet.get(2));
                    rowx.add(""+vtdet.get(3));
                    rowx.add(""+vtdet.get(4));
                    rowx.add("<div align=\"right\">"+vtdet.get(5)+"</div>");
                    rowx.add("<div align=\"right\">"+vtdet.get(6)+"</div>");
                    
                    
                    double qtypo = Double.parseDouble(String.valueOf(vtdet.get(5)));
                    double qtyRec =Double.parseDouble(String.valueOf(vtdet.get(6)));
                    totqtypo = totqtypo + qtypo;
                    totqtyrec = totqtyrec + qtyRec;
                    if((qtyRec-qtypo)!=0){
                        rowx.add("<div align=\"right\">"+(qtyRec-qtypo)+"</div>");
                    }else{
                        rowx.add("<div align=\"right\">0</div>");
                    }
                    vold= vtdet;
                   lstData.add(rowx);
			
                }
		
                Vector rowx = new Vector();
                
                rowx.add("");
                rowx.add("");
                rowx.add("");
                rowx.add("");
                rowx.add("");
                rowx.add("");
		rowx.add(""+totqtypo);	
                rowx.add(""+totqtyrec);	
                rowx.add("");
                lstData.add(rowx);
                
		Vector vx = new Vector();
		vx.add(cmdist.draw(index));
		
		return  vx;
	}

%>





<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);

            long locationId = JSPRequestValue.requestLong(request, "locationId");
           
            long vendorId =JSPRequestValue.requestLong(request, "vendorId");
            
            String startDate = JSPRequestValue.requestString(request, "src_start_date");
            String endDate = JSPRequestValue.requestString(request, "src_end_date");
            
            //Location location = new Location();
            Vendor vendor = new Vendor();
            try{
                vendor =  DbVendor.fetchExc(vendorId);
            }catch(Exception ex){
                
            }
            
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            if(startDate != ""){
                srcStartDate = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(endDate, "dd/MM/yyyy");
            }
            
                       
            Vector vstockDetail = new Vector();
               
            vstockDetail= DbReceiveItem.getDetailServiceLevel(vendorId, locationId, srcStartDate, srcEndDate);
                     
          
            

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
                <input type="hidden" name="src_start_date" value="<%=startDate%>">
                <input type="hidden" name="src_end_date" value="<%=endDate%>">
                
                 <tr>
                    <td colspan="2" height="10"></td>
                </tr>
                 
                
               <tr>
                    <td colspan="2">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td  height="10" width="20%"><b>Vendor </b></td>
                            <td  height="10"  width="2%" align="left"><b>:</b></td>
                            <td  height="10" align="left" width="75%"><%=vendor.getName()%> </td>
                        </tr>
                        <tr>
                            <td  height="10" width="20%"><b>Incoming Date</b></td>
                            <td  height="10" width="2%" align="left"><b>:</b></td>
                            <td  height="10" align="left" width="75%"><%= JSPFormater.formatDate(srcStartDate,"dd-MM-yyyy")%>  -  <%=JSPFormater.formatDate(srcEndDate,"dd-MM-yyyy")%></td>
                            
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
            if (vstockDetail != null ) {

                int pg = 1;
                
                    
                
                %>
                <tr>
                    <td colspan="2">
                        <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                                <td>
                                    <%
					Vector x = drawList(vstockDetail);
					String strTampil = (String)x.get(0);
					//Vector rptObj = (Vector)x.get(1);
				     %>
                                            <%=strTampil%>
                                    
                                </td>
                                
                            </tr> 
                          
                        </table>    
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
