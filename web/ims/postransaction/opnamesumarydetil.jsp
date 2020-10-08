<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %> 
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.adjusment.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass, int start, Opname op, Location loc)
	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("No","5%");
                cmdist.addHeader("SKU","10%");
		cmdist.addHeader("Barcode","10%");
		cmdist.addHeader("Item Name","35%");
                
                Vector vopsubLoc = new Vector();
                vopsubLoc= DbOpnameSubLocation.list(0, 0, " opname_id="+op.getOID() + " GROUP BY sub_location_id ", "");
                for(int i=0 ; i<vopsubLoc.size();i++){
                    OpnameSubLocation opsub = (OpnameSubLocation)vopsubLoc.get(i);
                    SubLocation subLoc = new SubLocation();
                    try{
                        subLoc= DbSubLocation.fetchExc(opsub.getSubLocationId());
                        cmdist.addHeader(subLoc.getName(),"5%");
                        
                    }catch(Exception ex){
                        
                    }
                }
                cmdist.addHeader("Total Real","10%");
                cmdist.addHeader("Qty System","10%");
                cmdist.addHeader("Selisih Stock","10%");
                cmdist.addHeader("Hpp","10%");
                cmdist.addHeader("Harga Jual","10%");
                cmdist.addHeader("Total Selisih Hpp","10%");
                cmdist.addHeader("Total Selisih Harga Jual","10%");
				
		//cmdist.setLinkRow(1);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;
                //SubLocation subloc = new SubLocation();
                ItemMaster im = new ItemMaster();
                double totalCogs=0;
		for (int i = 0; i < objectClass.size(); i++){
			ClosingOpname opItem = (ClosingOpname)objectClass.get(i);
			Vector rowx = new Vector();
                        im = new ItemMaster();
                        try{
                            im = DbItemMaster.fetchExc(opItem.getItemMasterId());
                        }catch(Exception ex){
                        }
                                              
                        rowx.add("<div align=\"center\">"+(start+i+1)+"</div>");   
                        rowx.add(im.getCode());
                        rowx.add(im.getBarcode());
                        rowx.add(im.getName());
                        double totalqty=0;
                        double grantotalreal=0;
                        double qtyClosing=0;
                        double cogs=0;
                        double hargaJual=0;
                        
			for(int b=0 ; b<vopsubLoc.size();b++){
                            OpnameSubLocation opsub = (OpnameSubLocation)vopsubLoc.get(b);
                            totalqty = DbOpnameItem.getTotalQty(im.getOID(), op.getOID(), opsub.getSubLocationId());
                            grantotalreal= grantotalreal + totalqty ; 
                            rowx.add("<div align=\"right\">"+totalqty+"</div>");
                        }
                        rowx.add("<div align=\"right\">"+grantotalreal+"</div>");
                        qtyClosing=DbClosingOpname.getTotalQtyClosing(im.getOID(), op.getOID(), op.getLocationId());
                        rowx.add("<div align=\"right\">"+qtyClosing+"</div>");
                        rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\""+im.getOID()+"\" value=\"" + (grantotalreal - qtyClosing)+ "\" readonly style=\"text-align:right\" > </div>");
                        cogs=DbClosingOpname.getCogs(im.getOID(), op.getOID());
                        hargaJual = DbClosingOpname.getHargaJual(im.getOID(), op.getOID());
                        rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(cogs,"#,###.##")+"</div>");
                        rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(hargaJual, "#,###.##")+"</div>");
                        rowx.add("<div align=\"right\">"+JSPFormater.formatNumber((cogs*(grantotalreal - qtyClosing)),"#,###.##")+"</div>");
                        rowx.add("<div align=\"right\">"+JSPFormater.formatNumber((hargaJual*(grantotalreal - qtyClosing)),"#,###.##")+"</div>");
                        totalCogs= totalCogs + (cogs*(grantotalreal - qtyClosing));
                                
                        lstData.add(rowx);
		
		}
                //Vector vt = new Vector();
                //for(int b=0;b<(7+(vopsubLoc.size()));b++){
                //    vt.add("<div align=\"right\"></div>");
                //}
                //vt.add("<div align=\"right\">Total Cogs</div>");
                //vt.add("<div align=\"right\">"+JSPFormater.formatNumber(totalCogs,"#,###.##")+"</div>");
                //lstData.add(vt);
		return cmdist.draw(index);
	}

%>
<%


	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}
	

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start1");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidOpname = JSPRequestValue.requestLong(request, "hidden_opname_id");
long oidOpnameSub = JSPRequestValue.requestLong(request, "hidden_opname_sub_id");
String status = JSPRequestValue.requestString(request, JspOpname.colNames[JspOpname.JSP_STATUS]);

session.putValue("DETAIL", oidOpname);

Opname opname = new Opname();

try{
    opname = DbOpname.fetchExc(oidOpname);
}catch(Exception ex){
    
}
Location locOp = new Location();
try{
    locOp = DbLocation.fetchExc(opname.getLocationId());
}catch(Exception ex){
    
}






/*variable declaration*/
int recordToGet = 20;
String msgString = "";
String whereClause = "";
String orderClause = "";

if(oidOpname!=0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and "+DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ID]+"="+oidOpname;	
	}else{
		whereClause = DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ID]+"="+oidOpname;	
	}
}
//whereClause = whereClause + " GROUP BY item_master_id ";

CmdOpname cmdOpname = new CmdOpname(request);
JSPLine ctrLine = new JSPLine();
Vector listOpnameItem = new Vector(1,1);



/*count list All Opname*/
int vectSize = DbClosingOpname.getCount(whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
	start = cmdOpname.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
//orderClause = DbOpnameItem.colNames[DbOpnameItem.COL_OPNAME_ITEM_ID];

listOpnameItem = DbClosingOpname.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listOpnameItem.size() < 1 && start > 0){
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listOpnameItem = DbClosingOpname.list(start,recordToGet, whereClause , orderClause);
}

if(iJSPCommand==JSPCommand.POST){
    opname.setStatus(status);
    Vector vitem= new Vector();
    
    try{
        if(opname.getStatus().equals(I_Project.DOC_STATUS_POSTED)){
            opname.setApproval2(user.getOID());
            opname.setApproval2_date(new Date());
        }
        DbOpname.updateExc(opname);
        Vector vAdjus = new Vector();
        if(opname.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_POSTED)){
            vitem = DbClosingOpname.list(0,0, whereClause , orderClause);
            Vector vopsubLoc= DbOpnameSubLocation.list(0, 0, " opname_id="+opname.getOID() + " GROUP BY sub_location_id ", "");
            ItemMaster im = new ItemMaster();
            for(int i=0;i<vitem.size();i++){
                ClosingOpname cl = (ClosingOpname) vitem.get(i);
                OpnameItem opi = new OpnameItem();
                try{
                    im = DbItemMaster.fetchExc(cl.getItemMasterId());
                    
                    opi.setItemMasterId(cl.getItemMasterId());
                }catch(Exception ex){
                    
                }
                double totalqty=0;
                double grantotalreal=0;
                double qtyClosing=0;
                for(int b=0 ; b<vopsubLoc.size();b++){
                    OpnameSubLocation opsub = (OpnameSubLocation)vopsubLoc.get(b);
                    totalqty = DbOpnameItem.getTotalQty(im.getOID(), opname.getOID(), opsub.getSubLocationId());
                    grantotalreal= grantotalreal + totalqty ; 
                    
                }
                qtyClosing=DbClosingOpname.getTotalQtyClosing(im.getOID(), opname.getOID(), opname.getLocationId());
                //DbStock.insertOpnameGoods(opname, opi, (grantotalreal-qtyClosing));
                if((grantotalreal-qtyClosing)!=0){
                    opi.setQtyReal(grantotalreal);
                    opi.setQtySystem(qtyClosing);
                    opi.setPrice(cl.getHpp());
                    vAdjus.add(opi);
                }
            }
           if(vAdjus.size() > 0 ){
               //create adjusment tmain
               Adjusment adj = new Adjusment();
               adj.setDate(opname.getDate());
               int ctr = DbAdjusment.getNextCounter();
               adj.setCounter(ctr);
               adj.setPrefixNumber(DbAdjusment.getNumberPrefix());
               adj.setNumber(DbAdjusment.getNextNumber(ctr));
               adj.setStatus(I_Project.DOC_STATUS_APPROVED);
               adj.setNote("ADJUSMENT FROM "+ opname.getNumber());
               adj.setUserId(user.getOID());
               adj.setApproval1(user.getOID());
               adj.setApproval1_date(opname.getDate());
               adj.setDate(opname.getDate());
               adj.setLocationId(opname.getLocationId());
               long oidAdjusment = DbAdjusment.insertExc(adj);
               
               if(vAdjus!=null && vAdjus.size()>0){
		for(int i=0; i<vAdjus.size(); i++){
			OpnameItem opi = (OpnameItem)vAdjus.get(i);
			long itemOID = opi.getItemMasterId();
			
                        //ItemMaster ims = new ItemMaster();
                        //try{
                        //   ims = DbItemMaster.fetchExc(opi.getItemMasterId());
                        //}catch(Exception ex){
                            
                        //}
			double totalAmount =opi.getPrice() * (opi.getQtyReal()-opi.getQtySystem());
			
			//OpnameItem oi = DbOpnameItem.getOpnameItem(oidOpname, itemOID);
                        AdjusmentItem ai = new AdjusmentItem();
                        ai.setAdjusmentId(oidAdjusment);
			ai.setItemMasterId(itemOID);
			ai.setQtySystem(opi.getQtySystem());
			ai.setQtyReal(opi.getQtyReal());
			ai.setPrice(opi.getPrice());
                        ai.setAmount(totalAmount);
                        ai.setQtyBalance(opi.getQtyReal()-opi.getQtySystem());
			
                        
			try{
				if(ai.getOID()==0){
					DbAdjusmentItem.insertExc(ai);
                                        DbStock.insertAdjustmentGoods(adj, ai);   
				}
				//else{
				////	DbOpnameItem.updateExc(oi);					
				//}
			}
			catch(Exception e){
			}
                    }
                }
               
               
           }
            
        }
    }catch(Exception ex){
        
    }
    
    
}

if(iJSPCommand==JSPCommand.GET){
    //penyesuai stock system, karena pada saat closing bisa saja ada stock transaksi penjualan yg blm masuk karena kendala teknis seperti internet mati dll
    //tujuan dari penyesuain ini adalah untuk mengupdate stock system per tanggal opname. sebelum opname ini di posted. supaya selisih yg didapet nanti mendekati valid.
   Vector vitem = DbClosingOpname.list(0,0, whereClause , orderClause);
   if(vitem.size()>0){
       for(int i=0;i<vitem.size();i++){
           CONResultSet crs = null;
           try{
               ClosingOpname cp = new ClosingOpname();
               cp= (ClosingOpname) vitem.get(i);
               Opname op = new Opname();
               if(oidOpname!=0){
                   try{
                       op = DbOpname.fetchExc(oidOpname);
                   }catch(Exception ex){

                   }
               }
               crs = CONHandler.execQueryResult("select sum(in_out * qty) as tot from pos_stock where location_id="+opname.getLocationId() + " and item_master_id=" + cp.getItemMasterId() + " and date < '"+op.getDate()+"'");
               ResultSet rs = crs.getResultSet();
               
               while(rs.next()){ 
                   if(rs.getDouble("tot")!=cp.getQty()){
                       cp.setQty(rs.getDouble("tot"));
                       try{
                           DbClosingOpname.updateExc(cp);
                       }catch(Exception ex){
                           
                       }
                   }
               }
               
               rs.close();
               
           }catch(Exception e){
           
           }
       }
           
       
   }
}


       
        
        
        
    

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

function cmdViewByGroup(){
	document.frmopname.command.value="<%=JSPCommand.LIST%>";
	document.frmopname.action="opnamesumarydetilgroup.jsp";
	document.frmopname.submit();

}

function cmdSearch(){
	document.frmopname.command.value="<%=JSPCommand.LIST%>";
	document.frmopname.action="opnamesumarydetil.jsp";
	document.frmopname.submit();
}
function cmdPrintXLS(){	 
        
            window.open("<%=printroot%>.report.RptOpnameSumaryXLS1?idx=<%=System.currentTimeMillis()%>");
        }
        
function cmdPrintGroupXLS(){	 
        
            window.open("<%=printroot%>.report.RptOpnameSumaryByGroupXLS1?idx=<%=System.currentTimeMillis()%>");
        }        
function cmdEditQtySystem(){
             
             
             document.frmopname.command.value="<%=JSPCommand.GET%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesumarydetil.jsp";
             document.frmopname.submit();
         }
 function cmdDeleteDoc(){
             
             document.frmopname.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesumarydetil.jsp";
             document.frmopname.submit();
 }
  function cmdCancelDoc(){
             
             document.frmopname.command.value="<%=JSPCommand.EDIT%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesumarydetil.jsp";
             document.frmopname.submit();
         }
 function cmdSaveDoc(){
             document.frmopname.command.value="<%=JSPCommand.POST%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesumarydetil.jsp";
             document.frmopname.submit();
         }
 function cmdAskDoc(){
             
             document.frmopname.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmopname.prev_command.value="<%=prevJSPCommand%>";
             document.frmopname.action="opnamesumarydetil.jsp";
             document.frmopname.submit();
         }
function cmdEdit(oid){
	document.frmopname.hidden_opname_sub_id.value=oid;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnamesumarydetil.jsp";
	document.frmopname.submit();
}

 


function cmdListFirst(){
	document.frmopname.command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.action="opnamesumarydetil.jsp";
	document.frmopname.submit();
}

function cmdListPrev(){
	document.frmopname.command.value="<%=JSPCommand.PREV%>";
	document.frmopname.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmopname.action="opnamesumarydetil.jsp";
	document.frmopname.submit();
	}

function cmdListNext(){
	document.frmopname.command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.action="opnamesumarydetil.jsp";
	document.frmopname.submit();
}

function cmdListLast(){
	document.frmopname.command.value="<%=JSPCommand.LAST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmopname.action="opnamesumarydetil.jsp";
	document.frmopname.submit();
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
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
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
                   <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmopname" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start1" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_opname_id" value="<%=oidOpname%>">
                          <input type="hidden" name="hidden_opname_sub_id" value="<%=oidOpnameSub%>">
                          <input type="hidden" name="hidden_location_id" value="<%=opname.getLocationId()%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Opname Summary </span></font></b></td>
                                    <td width="40%" height="23"> 
                                      <%@ include file = "../main/userpreview.jsp" %>
                                    </td>
                                  </tr>
                                  <tr > 
                                    <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
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
                                                <td width="12%">Number</td>
                                                <td width="12%"> 
                                                  <input size="15" class="readOnly" type="text" readonly value="<%=opname.getNumber()%>" > 
                                                </td>
                                                <td width="13%">Location</td>
                                                <td width="57%"> 
                                                  <input size="40" class="readOnly" type="text" readonly value="<%=locOp.getName()%>" > 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="12%">Doc Status</td>
                                                <td width="12%"> 
                                                  <input size="15" class="readOnly" type="text" readonly value="<%=opname.getStatus()%>" > 
                                                </td>
                                                <td width="13%">Opname Type</td>
                                                <td width="57%"> 
                                                  <%if(opname.getTypeOpname()==0){%>
                                                  <input size="15" class="readOnly" type="text" readonly value="Global"> 
                                                  <%}else{%>
                                                  <input size="15" class="readOnly" type="text" readonly value="Partial"> 
                                                  <%}%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="12%">Date</td>
                                                <td width="12%"> 
                                                  <input size="15" class="readOnly" type="text" readonly value="<%=JSPFormater.formatDate(opname.getDate(),"dd-MM-yyyy")%>"> 
                                                </td>
                                                <td width="13%">Note</td>
                                                <td width="57%"> 
                                                  <input size="50" class="readOnly" type="text" readonly value="<%=opname.getNote()%>"> 
                                                </td>
                                              </tr>
                                               <tr > 
                                                <td colspan="5" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                              </tr>
                                              
                                                                                        
                                              <tr> 
                                                <td colspan="4" height="5"></td>
                                              </tr>
                                              <tr> 
                                                <td width="18%"><a href="javascript:cmdViewByGroup()">Preview 
                                                  By Group</a> <a href="javascript:cmdPrintGroupXLS()">Print Summary In Group</a></td>
                                                <td colspan="3">&nbsp;</td>
                                              </tr>
                                              
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
								if (listOpnameItem.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                            <%= drawList(listOpnameItem,start,opname,locOp)%> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <%
                                            double granTothpp =0;
                                            Vector vsumary = new Vector();
                                            vsumary = DbClosingOpname.getTotalSummary(opname.getOID());
                                            granTothpp = Double.parseDouble (vsumary.get(0).toString());
                                            
                                            double granTothargajual = 0;
                                            granTothargajual = Double.parseDouble (vsumary.get(1).toString());
                                        
                                        %>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left"  class="command">&nbsp;</td>
                                          <td height="8" align="left"  class="command">Total selisih hpp</td>
                                          <td height="8" align="left"  class="command"><%= JSPFormater.formatNumber(granTothpp, "###,###.##")  %> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left"  class="command">&nbsp;</td>
                                          <td height="8" align="left"  class="command">Total selisih harga jual</td>
                                          <td height="8" align="left"  class="command"><%= JSPFormater.formatNumber(granTothargajual, "###,###.##")%> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <%  } 
						  }catch(Exception exc){ 
						  	System.out.println("sdsdf : "+exc.toString());
						  }%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <span class="command"> 
                                            <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
								   } 
							    %>
                                            <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								
								ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                       
                                        
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%if(opname.getStatus().equalsIgnoreCase("APPROVED") ){%>
                                        <tr> 
                                                                                                                                <td width="12%"><b>Set Status to</b></td>
                                                                                                                                <td width="14%"> 
                                                                                                                                    <select name="<%=JspOpname.colNames[JspOpname.JSP_STATUS]%>">
                                                                                                                                        
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_POSTED%>" <%if (opname.getStatus().equals(I_Project.DOC_STATUS_POSTED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_POSTED%></option>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                           <td width="74%">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                        <tr align="left" valign="top"> 
                                            <td height="8"  colspan="3">&nbsp; </td>
                                          </tr>
                                        <tr> 
                                                                                                                                <%if(listOpnameItem.size()>0 && opname.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){//jika sudah ada item dan masih draft baru bisa mengubah status%>
                                                                                                                                <td width="149"><div onclick="this.style.visibility='hidden'"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></div></td>
                                                                                                                                <%}%>
                                                                                                                                <%if(opname.getStatus().equalsIgnoreCase("DRAFT") && oidOpnameSub !=0){%>
                                                                                                                                <td width="102" > 
                                                                                                                                    <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                                                                                                </td>
                                                                                                                                <%}%>
                                                                                                                                                                                         
                                                                                                                               <%if(listOpnameItem.size()>0){%>
                                                                                                                                <td width="97"> 
                                                                                                                                    <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                                                                </td>
                                                                                                                                 
                                                                                                                               <%}%>
                                         </tr>
                                        
                                      </table>
                                    </td>
                                  </tr>
                                   <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
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
