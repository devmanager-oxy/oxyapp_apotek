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

	public Vector getGroupDistinct(long oidOpname){ 
	
		if(oidOpname!=0){
			String sql = "select distinct item_group_id, item_category_id  from pos_closing_opname co "+
				" inner join pos_item_master im on im.item_master_id=co.item_master_id where opname_id="+oidOpname+
				" order by item_group_id, item_category_id";
			
                        System.out.println(sql); 
                        
			CONResultSet crs = null;
			Vector list = new Vector();
			try {
				crs = CONHandler.execQueryResult(sql);
				ResultSet rs = crs.getResultSet();
				while (rs.next()) {
					Vector temp = new Vector();
					String groupId = rs.getString("item_group_id");
					String catId = rs.getString("item_category_id");
					temp.add(groupId);
					temp.add(catId);
					list.add(temp);
				}
			} catch (Exception e) {
				System.out.println(e.toString());
			} finally {
				CONResultSet.close(crs);
			}
			
			Vector grps = new Vector();
			if(list!=null && list.size()>0){
				long prevId = 0;
				for(int i=0; i<list.size(); i++){
					Vector xtemp = (Vector)list.get(i);
					long grId = Long.parseLong((String)xtemp.get(0));
					if(prevId!=grId){
						prevId = grId;
						grps.add(""+prevId);
					}					
				}
			}
			
			Vector temp = new Vector();
			temp.add(grps);
			temp.add(list);
			
			return temp;	
		}
		else{
			return new Vector();
		}

	} 
	
	public Vector getCategories(long grpId, Vector list){
		Vector result = new Vector();
		if(grpId!=0 && list!=null){
			for(int i=0; i<list.size(); i++){
				Vector xtemp = (Vector)list.get(i);
				long grId = Long.parseLong((String)xtemp.get(0));
				long catId = Long.parseLong((String)xtemp.get(1));
				if(grpId==grId){
					result.add(""+catId);
				}
			}
		}
		return result;
	}
	
	public Vector getClosingOpname(long opnameId, long groupId, long catId){ 
	
		String sql = "select item_master_id, sum(totreal) as totalreal, sum(totclosing) as totalclosing, (sum(totreal)-sum(totclosing)) as selisih, "+
				" hpokok, hjual, ((sum(totreal)-sum(totclosing))* hpokok) as selisihhpp, "+
				" ((sum(totreal)-sum(totclosing))* hjual) as selisihjual  from ((select item_master_id, 0 as totreal, sum(qty) as totclosing, "+
				" hpp as hpokok, harga_jual as hjual from pos_closing_opname where opname_id="+opnameId+
				" and (item_master_id in (select item_master_id from pos_item_master where item_group_id="+groupId+" and item_category_id="+catId+")) "+
				" group by item_master_id) union (select item_master_id, sum(qty_real) as totreal, 0 as totclosing, 0 as hpokok, 0 as hjual "+
				" from pos_opname_item where opname_id="+opnameId+
				" and (item_master_id in (select item_master_id from pos_item_master where item_group_id="+groupId+" and item_category_id="+catId+")) "+
				" group by item_master_id)) as tabel group by item_master_id"; 
				
		CONResultSet dbrs = null;
        
                System.out.println(sql);
                
                Vector vsum = new Vector();
        try {
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()){
                Vector vdet = new Vector();
                vdet.add(rs.getLong(1));
                vdet.add(rs.getDouble(2));
                vdet.add(rs.getDouble(3));
                vdet.add(rs.getDouble(4));
                vdet.add(rs.getDouble(5));
                vdet.add(rs.getDouble(6));
                vdet.add(rs.getDouble(7));
                vdet.add(rs.getDouble(8));
                vsum.add(vdet);
                
            }

            rs.close();
            
        } catch (Exception e) {
            return new Vector();
        } finally {
            CONResultSet.close(dbrs);
        }
				
		return vsum;		
	
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





%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
function cmdSearch(){
	document.frmopname.command.value="<%=JSPCommand.LIST%>";
	document.frmopname.action="opnamesumarydetil.jsp";
	document.frmopname.submit();
}
function cmdPrintXLS(){	 
        
            window.open("<%=printroot%>.report.RptOpnameSumaryXLS1?idx=<%=System.currentTimeMillis()%>");
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
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
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
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmopname" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
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
                                      </font><font class="tit1">&raquo; <span class="lvl2">Opname 
                                      Summary </span></font></b></td>
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
                                                <td width="18%"></td>
                                                <td colspan="3">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
								if (true){//listOpnameItem.size()>0){
							%>
                                        <tr align="left" valign="top"> 
                                          <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                            
                                            <%
											
											Vector tempGroupX = getGroupDistinct(oidOpname);
											
											//out.println("tempGroupX : "+tempGroupX);
                                            //out.println("tempGroup : "+tempGroup);
											
											Vector tempGroup = (Vector)tempGroupX.get(0);
											Vector listAllCats = (Vector)tempGroupX.get(1);
											
											Vector vopsubLoc = new Vector();
											vopsubLoc= DbOpnameSubLocation.list(0, 0, " opname_id="+oidOpname + " GROUP BY sub_location_id ", "");
											Vector raks = new Vector();
											for(int i=0 ; i<vopsubLoc.size();i++){
												OpnameSubLocation opsub = (OpnameSubLocation)vopsubLoc.get(i);
												SubLocation subLoc = new SubLocation();
												try{
													subLoc= DbSubLocation.fetchExc(opsub.getSubLocationId());
													raks.add(subLoc);
													//cmdist.addHeader(subLoc.getName(),"5%");
													
												}catch(Exception ex){
													
												}   
											}
                                                                                        
                                            //out.println("oidOpname : "+oidOpname);
                                            //out.println("tempGroup : "+tempGroup);
											//out.println("raks : "+raks);
                                                                                        
											if(tempGroup!=null && tempGroup.size()>0){
											%>
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <%
											  
											  long currIgId = 0;
											  long prevGrId = 0;
											  boolean isIgChanged = true;
											  double finalTotQtyReal = 0;
											  double finalTotQtySystem = 0;
											  double finalTotQtySelisih = 0;
											  double finalTotSelisihHpp = 0;
											  double finalTotSelisihHJual = 0;
                                                                                          
											  
											  for(int i=0; i<tempGroup.size(); i++){
                                                                                              
													double grnTotQtyReal = 0;
													double grnTotQtySystem = 0;
													double grnTotQtySelisih = 0;
													double grnTotSelisihHpp = 0;
													double grnTotSelisihHJual = 0;

													//Vector temp = (Vector)tempGroup.get(i);
													long groupId = Long.parseLong((String)tempGroup.get(i));
													
													ItemGroup ig = new ItemGroup();
													try{
															ig = DbItemGroup.fetchExc(groupId);
													}
													catch(Exception e){
													}
													
													%>
                                              <tr> 
                                                <td colspan="2" bgcolor="#FF9900" height="22"><b>&nbsp;GROUP</b></td>
                                                <td colspan="<%=2+raks.size()+7%>" bgcolor="#FF9900" height="22"><b>: 
                                                  <%=ig.getName()%></b></td>
                                                <!--td width="55" height="28" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="75" height="28" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="75" height="28" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="75" height="28" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="62" height="28" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="75" height="28" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="88" height="28" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="101" height="28" bgcolor="#FF9900"><font size="1"></font></td-->
                                              </tr>
                                              <%
													
                                                                                            Vector categories = getCategories(groupId, listAllCats);

                                                                                            if(categories!=null && categories.size()>0){

                                                                                            for(int ax=0; ax<categories.size(); ax++){

                                                                                                    long catId = Long.parseLong((String)categories.get(ax));


                                                                                                    ItemCategory ic = new ItemCategory();
                                                                                                    try{
                                                                                                                    ic = DbItemCategory.fetchExc(catId);
                                                                                                    }
                                                                                                    catch(Exception e){
                                                                                                    }
													
											  %>
                                              <tr> 
                                                <td colspan="2" bgcolor="#FFCC66" height="22"><b>&nbsp;CATEGORY</b></td>
                                                <td colspan="2" bgcolor="#FFCC66" height="22"><b>: 
                                                  <%=ic.getName()%></b></td>
                                                <td width="55" bgcolor="#FF9900" colspan="<%=raks.size()+7%>" height="22"><font size="1"></font></td>
                                                <!--td width="75" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="75" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="75" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="62" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="75" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="88" bgcolor="#FF9900"><font size="1"></font></td>
                                                <td width="101" bgcolor="#FF9900"><font size="1"></font></td-->
                                              </tr>
                                              <tr> 
                                                <td class="tablehdr" width="23"><font size="1">No</font></td>
                                                <td class="tablehdr" width="57"><font size="1">SKU</font></td>
                                                <td class="tablehdr" width="84"><font size="1">Barcode</font></td>
                                                <td class="tablehdr" width="504"><font size="1">Name</font></td>
                                                <%
												for(int a=0 ; a<vopsubLoc.size();a++){
													//OpnameSubLocation opsub = (OpnameSubLocation)vopsubLoc.get(a);
													SubLocation subLoc = (SubLocation)raks.get(a);
													%>
                                                <td class="tablehdr" width="55"><font size="1"><%=subLoc.getName()%></font></td>
                                                <%}%>
                                                <td class="tablehdr" width="75"><font size="1">Total 
                                                  Real</font></td>
                                                <td class="tablehdr" width="75"><font size="1">Qty 
                                                  System</font></td>
                                                <td class="tablehdr" width="75"><font size="1">Selisih 
                                                  Stock</font></td>
                                                <td class="tablehdr" width="62"><font size="1">Hpp</font></td>
                                                <td class="tablehdr" width="75"><font size="1">Harga 
                                                  Jual</font></td>
                                                <td class="tablehdr" width="88"><font size="1">Total 
                                                  Selisih Hpp</font></td>
                                                <td class="tablehdr" width="101"><font size="1">Total 
                                                  Selisih Harga Jual</font></td>
                                              </tr>
                                              <%
											  
											  //String where = "opname_id="+oidOpname+" and item_master_id in (select item_master_id from pos_item_master where item_group_id="+groupId+" and item_category_id="+catId+")"+
											  //				" group by item_master_id";
															
											  //Vector closingStock = DbClosingOpname.list(0,0, where, "");
											  Vector closingStock = getClosingOpname(oidOpname, groupId, catId);
											  
											  //out.println("closingStock : "+closingStock);
											  
											  
											  if(closingStock!=null && closingStock.size()>0){
											  		
													double subTotQtyReal = 0; 
													double subTotQtySystem = 0;
													double subTotQtySelisih = 0;
													double subTotSelisihHpp = 0;
													double subTotSelisihHJual = 0;
													
													for(int x=0; x<closingStock.size(); x++){
														
														Vector vDet = new Vector();
														vDet = (Vector) closingStock.get(x);
														ItemMaster im = new ItemMaster();
														
														try{
															im = DbItemMaster.fetchExc( Long.valueOf(vDet.get(0).toString()));
														}catch(Exception ex){
									
														}
														
														
														//ClosingOpname co = (ClosingOpname)closingStock.get(x);
														
														//ItemMaster im = new ItemMaster();
														//try{
														//	im = DbItemMaster.fetchExc(co.getItemMasterId());
														//}
														//catch(Exception e){
														//}	
													
														if(x%2==0){
											  %>
                                              <tr> 
                                                <td class="tablecell" width="23"><font size="1"><%=x+1%></font></td>
                                                <td class="tablecell" width="57"><font size="1"><%=im.getCode()%></font></td>
                                                <td class="tablecell" width="84"><font size="1"><%=im.getBarcode()%></font></td>
                                                <td class="tablecell" width="504"><font size="1"><%=im.getName()%></font></td>
                                                <%
												double totalqty=0;
												double grantotalreal=Double.parseDouble(vDet.get(1).toString());
												double qtyClosing= Double.parseDouble(vDet.get(2).toString());//DbClosingOpname.getTotalQtyClosing(im.getOID(), oidOpname, opname.getLocationId());
												double cogs=Double.parseDouble(vDet.get(4).toString());//DbClosingOpname.getCogs(im.getOID(), oidOpname);
						                        double hargaJual = Double.parseDouble(vDet.get(5).toString());//DbClosingOpname.getHargaJual(im.getOID(), oidOpname);
															
												for(int a=0 ; a<vopsubLoc.size();a++){
													OpnameSubLocation opsub = (OpnameSubLocation)vopsubLoc.get(a);
													//SubLocation subLoc = (SubLocation)raks.get(a);
													totalqty = DbOpnameItem.getTotalQty(im.getOID(), oidOpname, opsub.getSubLocationId());
													//grantotalreal= grantotalreal + totalqty ; 
													%>
                                                <td class="tablecell" width="55"> 
                                                  <div align="right"><font size="1"><%=totalqty%></font></div>
                                                </td>
                                                <%}
												%>
                                                <td class="tablecell" width="75"> 
                                                  <div align="right"><font size="1"><%=grantotalreal%></font></div>
                                                </td>
                                                <td class="tablecell" width="75"> 
                                                  <div align="right"><font size="1"><%=qtyClosing%></font></div>
                                                </td>
                                                <td class="tablecell" width="75"> 
                                                  <div align="right"><font size="1"><%=vDet.get(3)%></font></div>
                                                </td>
                                                <td class="tablecell" width="62"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(Double.parseDouble(vDet.get(4).toString()),"#,###.##")%></font></div>
                                                </td>
                                                <td class="tablecell" width="75"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(Double.parseDouble(vDet.get(5).toString()), "#,###.##")%></font></div>
                                                </td>
                                                <td class="tablecell" width="88"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(Double.parseDouble(vDet.get(6).toString()),"#,###.##")%></font></div>
                                                </td>
                                                <td class="tablecell" width="101"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(Double.parseDouble(vDet.get(7).toString()),"#,###.##")%></font></div>
                                                </td>
                                              </tr>
                                              <%
													subTotQtyReal = subTotQtyReal + grantotalreal;
													subTotQtySystem = subTotQtySystem + qtyClosing;
													subTotQtySelisih = subTotQtySelisih + (grantotalreal - qtyClosing);
													subTotSelisihHpp = subTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
													subTotSelisihHJual = subTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));
																									
													grnTotQtyReal = grnTotQtyReal + grantotalreal;
													grnTotQtySystem = grnTotQtySystem + qtyClosing;
													grnTotQtySelisih = grnTotQtySelisih + (grantotalreal - qtyClosing);
													grnTotSelisihHpp = grnTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
													grnTotSelisihHJual = grnTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));
													
													finalTotQtyReal = finalTotQtyReal + grantotalreal; 
													finalTotQtySystem = finalTotQtySystem + qtyClosing;
													finalTotQtySelisih = finalTotQtySelisih + (grantotalreal - qtyClosing);
													finalTotSelisihHpp = finalTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
													finalTotSelisihHJual = finalTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));
											  
											  }else{%>
                                              <tr> 
                                                <td class="tablecell1" width="23"><font size="1"><%=x+1%></font></td>
                                                <td class="tablecell1" width="57"><font size="1"><%=im.getCode()%></font></td>
                                                <td class="tablecell1" width="84"><font size="1"><%=im.getBarcode()%></font></td>
                                                <td class="tablecell1" width="504"><font size="1"><%=im.getName()%></font></td>
                                                <%
												double totalqty=0;
												double grantotalreal=Double.parseDouble(vDet.get(1).toString());
												double qtyClosing= Double.parseDouble(vDet.get(2).toString());//DbClosingOpname.getTotalQtyClosing(im.getOID(), oidOpname, opname.getLocationId());
												double cogs=Double.parseDouble(vDet.get(4).toString());//DbClosingOpname.getCogs(im.getOID(), oidOpname);
						                        double hargaJual = Double.parseDouble(vDet.get(5).toString());//DbClosingOpname.getHargaJual(im.getOID(), oidOpname);
															
												for(int a=0 ; a<vopsubLoc.size();a++){
													OpnameSubLocation opsub = (OpnameSubLocation)vopsubLoc.get(a);
													//SubLocation subLoc = (SubLocation)raks.get(a);
													totalqty = DbOpnameItem.getTotalQty(im.getOID(), oidOpname, opsub.getSubLocationId());
													//grantotalreal= grantotalreal + totalqty ; 
													%>
                                                <td class="tablecell1" width="55"> 
                                                  <div align="right"><font size="1"><%=totalqty%></font></div>
                                                </td>
                                                <%}%>
                                                <td class="tablecell1" width="75"> 
                                                  <div align="right"><font size="1"><%=grantotalreal%></font></div>
                                                </td>
                                                <td class="tablecell1" width="75"> 
                                                  <div align="right"><font size="1"><%=qtyClosing%></font></div>
                                                </td>
                                                <td class="tablecell1" width="75"> 
                                                  <div align="right"><font size="1"><%=(grantotalreal - qtyClosing)%></font></div>
                                                </td>
                                                <td class="tablecell1" width="62"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(cogs,"#,###.##")%></font></div>
                                                </td>
                                                <td class="tablecell1" width="75"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(hargaJual, "#,###.##")%></font></div>
                                                </td>
                                                <td class="tablecell1" width="88"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber((cogs*(grantotalreal - qtyClosing)),"#,###.##")%></font></div>
                                                </td>
                                                <td class="tablecell1" width="101"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber((hargaJual*(grantotalreal - qtyClosing)),"#,###.##")%></font></div>
                                                </td>
                                              </tr>
                                              <%
													subTotQtyReal = subTotQtyReal + grantotalreal;
													subTotQtySystem = subTotQtySystem + qtyClosing;
													subTotQtySelisih = subTotQtySelisih + (grantotalreal - qtyClosing);
													subTotSelisihHpp = subTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
													subTotSelisihHJual = subTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));
																									
													grnTotQtyReal = grnTotQtyReal + grantotalreal;
													grnTotQtySystem = grnTotQtySystem + qtyClosing;
													grnTotQtySelisih = grnTotQtySelisih + (grantotalreal - qtyClosing);
													grnTotSelisihHpp = grnTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
													grnTotSelisihHJual = grnTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));
													
													finalTotQtyReal = finalTotQtyReal + grantotalreal;
													finalTotQtySystem = finalTotQtySystem + qtyClosing;
													finalTotQtySelisih = finalTotQtySelisih + (grantotalreal - qtyClosing);
													finalTotSelisihHpp = finalTotSelisihHpp + (cogs*(grantotalreal - qtyClosing));
													finalTotSelisihHJual = finalTotSelisihHJual + (hargaJual*(grantotalreal - qtyClosing));
												
											  	}//end if else
											  
											  } //end loop items
											  
											  
											  
											  %>
                                              <tr> 
                                                <td width="23" height="20"><font size="1"></font></td>
                                                <td width="57" height="20"><font size="1"></font></td>
                                                <td width="84" height="20"><font size="1"></font></td>
                                                <td width="504" bgcolor="#FFFFCC" height="20"> 
                                                  <div align="center"><font size="1" color="#000000"><b>TOTAL 
                                                    CATEGORY - <%=ic.getName()%></b></font></div>
                                                </td>
                                                <%
												for(int a=0 ; a<vopsubLoc.size();a++){
													//OpnameSubLocation opsub = (OpnameSubLocation)vopsubLoc.get(a);
													//SubLocation subLoc = (SubLocation)raks.get(a);
													%>
                                                <td width="55" bgcolor="#FFFFCC" height="20"><font size="1" color="#000000"></font></td>
                                                <%}%>
                                                <td width="75" bgcolor="#FFFFCC" height="20"> 
                                                  <div align="right"><font size="1" color="#000000"><%=JSPFormater.formatNumber(subTotQtyReal,"#,###.##")%></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFFFCC" height="20"> 
                                                  <div align="right"><font size="1" color="#000000"><%=JSPFormater.formatNumber(subTotQtySystem,"#,###.##")%></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFFFCC" height="20"> 
                                                  <div align="right"><font size="1" color="#000000"><%=JSPFormater.formatNumber(subTotQtySelisih,"#,###.##")%></font></div>
                                                </td>
                                                <td width="62" bgcolor="#FFFFCC" height="20"> 
                                                  <div align="right"><font size="1" color="#000000"></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFFFCC" height="20"> 
                                                  <div align="right"><font size="1" color="#000000"></font></div>
                                                </td>
                                                <td width="88" bgcolor="#FFFFCC" height="20"> 
                                                  <div align="right"><font size="1" color="#000000"><%=JSPFormater.formatNumber(subTotSelisihHpp,"#,###.##")%></font></div>
                                                </td>
                                                <td width="101" bgcolor="#FFFFCC" height="20"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(subTotSelisihHJual,"#,###.##")%></font></div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="23"><font size="1"></font></td>
                                                <td width="57"><font size="1"></font></td>
                                                <td width="84"><font size="1"></font></td>
                                                <td width="504"><font size="1"></font></td>
                                                <%
												for(int a=0 ; a<vopsubLoc.size();a++){
													%>
                                                <td width="55"><font size="1"></font></td>
                                                <%}%>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="62"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="88"><font size="1"></font></td>
                                                <td width="101"><font size="1"></font></td>
                                              </tr>
                                              <%
											  } //end categories
											  
											  } //end if categories
											  
											  
											  %>
                                              <tr> 
                                                <td width="23" height="22"><font size="1"></font></td>
                                                <td width="57" height="22"><font size="1"></font></td>
                                                <td width="84" height="22"><font size="1"></font></td>
                                                <td width="504" bgcolor="#FFCC66" height="22"> 
                                                  <div align="center"><font size="1"><b>TOTAL 
                                                    GROUP - <%=ig.getName()%></b></font></div>
                                                </td>
                                                <%
												for(int a=0 ; a<vopsubLoc.size();a++){
													%>
                                                <td width="55" bgcolor="#FFCC66" height="22"><font size="1"></font></td>
                                                <%}%>
                                                <td width="75" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(grnTotQtyReal,"#,###.##")%></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(grnTotQtySystem,"#,###.##")%></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(grnTotQtySelisih,"#,###.##")%></font></div>
                                                </td>
                                                <td width="62" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"></font></div>
                                                </td>
                                                <td width="88" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(grnTotSelisihHpp,"#,###.##")%></font></div>
                                                </td>
                                                <td width="101" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(grnTotSelisihHJual,"#,###.##")%></font></div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="23"><font size="1">&nbsp;</font></td>
                                                <td width="57"><font size="1"></font></td>
                                                <td width="84"><font size="1"></font></td>
                                                <td width="504"><font size="1"></font></td>
                                                <%
												for(int a=0 ; a<vopsubLoc.size();a++){
													%>
                                                <td width="55"><font size="1"></font></td>
                                                <%}%>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="62"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="88"><font size="1"></font></td>
                                                <td width="101"><font size="1"></font></td>
                                              </tr>
                                              <%
											  
											  }//closingStock
											  %>
                                              <%}%>
                                              <tr> 
                                                <td width="23" height="22"><font size="1"></font></td>
                                                <td width="57" height="22"><font size="1"></font></td>
                                                <td width="84" height="22"><font size="1"></font></td>
                                                <td width="504" bgcolor="#FFCC66" height="22"> 
                                                  <div align="center"><font size="1"><b>GRANT 
                                                    TOTAL ALL</b></font></div>
                                                </td>
                                                <%
												for(int a=0 ; a<vopsubLoc.size();a++){
													%>
                                                <td width="55" bgcolor="#FFCC66" height="22"><font size="1"></font></td>
                                                <%}%>
                                                <td width="75" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(finalTotQtyReal,"#,###.##")%></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(finalTotQtySystem,"#,###.##")%></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(finalTotQtySelisih,"#,###.##")%></font></div>
                                                </td>
                                                <td width="62" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"></font></div>
                                                </td>
                                                <td width="75" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"></font></div>
                                                </td>
                                                <td width="88" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(finalTotSelisihHpp,"#,###.##")%></font></div>
                                                </td>
                                                <td width="101" bgcolor="#FFCC66" height="22"> 
                                                  <div align="right"><font size="1"><%=JSPFormater.formatNumber(finalTotSelisihHJual,"#,###.##")%></font></div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="23"><font size="1">&nbsp;</font></td>
                                                <td width="57"><font size="1"></font></td>
                                                <td width="84"><font size="1"></font></td>
                                                <td width="504"><font size="1"></font></td>
                                                <%
												for(int a=0 ; a<vopsubLoc.size();a++){
													%>
                                                <td width="55"><font size="1"></font></td>
                                                <%}%>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="62"><font size="1"></font></td>
                                                <td width="75"><font size="1"></font></td>
                                                <td width="88"><font size="1"></font></td>
                                                <td width="101"><font size="1"></font></td>
                                              </tr>
                                            </table>
                                            <%}//end group%>
                                            <p>&nbsp; </p>
                                          </td>
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
                                          <td height="8" align="left"  class="command">Total 
                                            selisih hpp</td>
                                          <td height="8" align="left"  class="command"><%= JSPFormater.formatNumber(granTothpp, "###,###.##")  %> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left"  class="command">&nbsp;</td>
                                          <td height="8" align="left"  class="command">Total 
                                            selisih harga jual</td>
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
                                            <span class="command"> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%if(opname.getStatus().equalsIgnoreCase("APPROVED") ){%>
                                        <%}%>
                                        <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td width="149"> 
                                            <div onclick="this.style.visibility='hidden'"></div>
                                          </td>
                                          <td width="102" > 
                                            <div align="left"></div>
                                          </td>
                                          <td width="97"> 
                                            <div align="center"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                          </td>
                                          
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
                        </span><!-- #EndEditable --> </td>
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
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>
