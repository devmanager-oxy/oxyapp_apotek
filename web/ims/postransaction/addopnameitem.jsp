
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.main.db.CONException" %>
<%@ page import = "com.project.main.db.CONHandler" %>
<%@ page import = "com.project.main.db.CONResultSet" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//appSessUser.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("75%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		cmdist.setCellStyle1("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		
		cmdist.addHeader("SKU","10%");
		cmdist.addHeader("Barcode","10%");
		cmdist.addHeader("Name","40%");
                
                    cmdist.setLinkRow(1);
                
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;
                ItemMaster im = new ItemMaster();
		for (int i = 0; i < objectClass.size(); i++) {
			im = (ItemMaster)objectClass.get(i);
			Vector rowx = new Vector();
                        
                        rowx.add(im.getCode());
			rowx.add(im.getBarcode());
                        rowx.add(im.getName());
			
                        lstData.add(rowx);
                        lstLinkData.add(String.valueOf(im.getOID()));
                        
			
		}

		return cmdist.draw(index);
	}
	
	public Vector getGroupDistinct(long oidOpname){
	
		if(oidOpname!=0){
			String sql = "select distinct item_group_id, item_category_id  from pos_closing_opname co "+
				"inner join pos_item_master im on im.item_master_id=co.item_master_id where opname_id="+oidOpname;
				
			CONResultSet crs = null;
			Vector list = new Vector();
			try {
				crs = CONHandler.execQueryResult(sql);
				ResultSet rs = crs.getResultSet();
				while (rs.next()) {
					Vector temp = new Vector();
					String groupId = ""+rs.getLong("item_group_id");
					String catId = ""+rs.getLong("item_category_id");
					temp.add(groupId);
					temp.add(catId);
					list.add(temp);
				}
			} catch (Exception e) {
				System.out.println(e.toString());
			} finally {
				CONResultSet.close(crs);
			}
			
			return list;	
		}
		else{
			return new Vector();
		}

	}
	
	public boolean isIncluded(long oidOpname, ItemMaster im){
		
		Vector temp = getGroupDistinct(oidOpname);
		
		if(temp!=null && temp.size()>0 && im.getOID()!=0 && im.getItemGroupId()!=0 && im.getItemCategoryId()!=0){
			for(int i=0; i<temp.size(); i++){
				Vector vct = (Vector)temp.get(i);
				long groupId = Long.parseLong((String)vct.get(0));
				long catId = Long.parseLong((String)vct.get(1));
				if(im.getItemGroupId()==groupId && im.getItemCategoryId()==catId){
					return true;
				}
			}			
		}
		
		return false;
	}
        
        
        public static Vector getOpnameItem(Vector temp, Vector grps){
            Vector result = new Vector();
            if(temp!=null && temp.size()>0){
                for(int i=0; i<temp.size(); i++){
                    ItemMaster im = (ItemMaster) temp.get(i); 
                    //bukan barang komisi
                    if(im.getTypeItem()!=2 && im.getNeedRecipe()==0){
                        for(int x=0;x<grps.size();x++){
                            Vector vct = (Vector)grps.get(x);
                            long groupId = Long.parseLong((String)vct.get(0));
                            long catId = Long.parseLong((String)vct.get(1));
                            if(im.getItemGroupId()==groupId && im.getItemCategoryId()==catId){
                                    result.add(im);
                            }
                        }
                    }
                    
                }
            }
            
            return result;
        }
	
%>
	
<%
    int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidOpname = JSPRequestValue.requestLong(request, "opname_id");
long oidOpnameSub =JSPRequestValue.requestLong(request, "opname_sub_location_id");
long opnameId = JSPRequestValue.requestLong(request, "hidden_opname_id");
long opnameSubId = JSPRequestValue.requestLong(request, "hidden_opname_sub_id");
long itemMasterId = JSPRequestValue.requestLong(request, "hidden_item_master_id");
String code = JSPRequestValue.requestString(request, "src_code");
String itemName =JSPRequestValue.requestString(request, "src_item_name");
double qty = JSPRequestValue.requestDouble(request, "src_qty");

long oidOpnameItem = JSPRequestValue.requestLong(request, "hidden_opname_item_id");
long oidOpnameItem2 = JSPRequestValue.requestLong(request, "hidden_opname_item_id2");

if(oidOpnameItem==0){
    oidOpnameItem = oidOpnameItem2;
}

OpnameItem opi = new OpnameItem();
if(oidOpnameItem!=0){
        try{
            opi = DbOpnameItem.fetchExc(oidOpnameItem);
        }catch(Exception ex){
            
        }    
}

ItemMaster im = new ItemMaster();
if(opi.getItemMasterId()!=0){
    try{
        im = DbItemMaster.fetchExc(opi.getItemMasterId());
    }catch(Exception ex){

    }
}

if(oidOpnameSub==0){
    oidOpnameSub= opnameSubId;
}

if(oidOpname==0){
    oidOpname =  opnameId;
}

//Opname opname = new Opname();
OpnameSubLocation opnameSub = new OpnameSubLocation();

try{
    opnameSub= DbOpnameSubLocation.fetchExc(oidOpnameSub);
}catch(Exception ex){
    
}

SubLocation subLocation = new SubLocation();
try{
    subLocation = DbSubLocation.fetchExc(opnameSub.getSubLocationId());
}catch(Exception ex){
    
}


Opname op = new Opname();
try{
    op= DbOpname.fetchExc(oidOpname);
}catch(Exception ex){
    
}

Location locOp= new Location();
try{
    locOp = DbLocation.fetchExc(op.getLocationId());
}catch(Exception ex){
    
}
String mesage="";
Vector vim = new Vector();
if(iJSPCommand==JSPCommand.SEARCH){  
    
           /*
           vim =   DbClosingOpname.getItemMaster(code, itemName, op.getLocationId(),opnameId);
           if(vim!=null && vim.size()==1){
               im = (ItemMaster) vim.get(0);
           }
           //ED jika tidak ditemukan di table closing
           else if(vim.size()>1){ 
               mesage="please select one item from list below";
           }
           else if(vim.size()==0){
           */      
          
                String where = "";
                if(code!=null && code.length()>0){
                    where = "code='"+code+"' or barcode='"+code+"' or barcode_2='"+code+"' or barcode_3='"+code+"'";
                }
                else if(itemName!=null && itemName.length()>0){
                    where = "name like '%"+itemName+"%'";
                }
   		
                Vector tempx = DbItemMaster.list(0,0, where, "");
                
                //out.println("tempx : "+tempx);
		
                if(tempx!=null && tempx.size()==1){
			
			im = (ItemMaster) tempx.get(0);
                        
                        //bukan komisi
                        if(im.getTypeItem()!=2 && im.getNeedRecipe()==0){
                        
                            boolean isInclude = isIncluded(op.getOID(), im);

                            //jika tidak termasuk tetapi opname global, tambahkan saja
                            if(!isInclude && op.getTypeOpname()==0){
                                isInclude = true;
                            }

                            if(isInclude){ 
                                    //cek closing opname
                                    Vector tmpClose = DbClosingOpname.list(0,1,"item_master_id="+im.getOID()+" and opname_id="+op.getOID()+" and location_id="+op.getLocationId(),"");

                                    ClosingOpname co = new ClosingOpname();

                                    if(tmpClose!=null && tmpClose.size()>0){
                                            co = (ClosingOpname)tmpClose.get(0);
                                    }

                                    try{										
                                            //kalau tidak ada di closing, insert baru					
                                            if(co.getOID()==0){	
                                                    co.setDate(new Date());
                                                    co.setItemMasterId(im.getOID());
                                                    co.setLocationId(op.getLocationId());
                                                    co.setQty(DbStock.getItemTotalStock(locOp.getOID(), im.getOID()));
                                                    co.setOpnameId(op.getOID());
                                                    co.setHpp(im.getNew_cogs());
                                                    co.setHarga_jual(DbPriceType.getPrice(1, locOp.getGol_price(), im.getOID()));                                                    
                                                    DbClosingOpname.insertExc(co);
                                            }                                            
                                    }
                                    catch(Exception e){
                                    }
                            }
                            else{
                                    mesage="Item "+itemName+" - group & category out of selected groups and categories";
                                    im = new ItemMaster();
                                    itemMasterId = 0;
                                    opi.setQtyReal(0);
                            }
                        }
                        else{
                            mesage="No opname for KOMISI / RECIPE item - "+im.getName()+"/barcode : "+im.getBarcode();
                            im = new ItemMaster();
                            itemMasterId = 0;
                            opi.setQtyReal(0);
                        }
		}
		//barang sama sekali tidak terdaftar di master beri message
		else{ 
			if(tempx==null||tempx.size()==0){
				mesage="Item code/barcode = "+code+" - not exist in master data, please check";
				im  = new ItemMaster();
				itemMasterId = 0;
				opi.setQtyReal(0);
			}
			else{
                                //im = (ItemMaster) tempx.get(0);                        
                                //boolean isInclude = isIncluded(op.getOID(), im);
                                //jika global
                                if(op.getTypeOpname()==0){
                                    vim = tempx;
                                }
                                //jika partial - lakukan filtering
                                else{
                                    Vector grps = getGroupDistinct(oidOpname);                                
                                    vim = getOpnameItem(tempx, grps);
                                }
                                //out.println("vim : "+vim);
                                
                                if(vim!=null && vim.size()>0){
                                    mesage="please select one item from list below";
                                    //vim = tempx;
                                }
                                else{
                                    mesage="Item "+itemName+" - group & category out of selected groups and categories";
                                    im = new ItemMaster();
                                    itemMasterId = 0;
                                    opi.setQtyReal(0);
                                }
			}
		}
               
           //}

           Vector vopitem = DbOpnameItem.list(0, 0, "item_master_id="+ im.getOID() + " and opname_sub_location_id="+ oidOpnameSub , "");
           if(vopitem.size()>0){
               opi=(OpnameItem) vopitem.get(0);
               mesage="Item already exist";
               oidOpnameItem= opi.getOID();
               itemMasterId=im.getOID();
           }else{
               oidOpnameItem=0;
           }
   
}

if(iJSPCommand==JSPCommand.EDIT){
    
   //vim =   DbClosingOpname.getItemMaster(code, itemName, op.getLocationId());
   try{
       im = DbItemMaster.fetchExc(itemMasterId);
   }catch(Exception ex){
       
   }
       
   Vector vopitem = DbOpnameItem.list(0, 0, "item_master_id="+ im.getOID() + " and opname_sub_location_id="+ oidOpnameSub, "");
   if(vopitem.size()>0){
       opi=(OpnameItem) vopitem.get(0);
       mesage="Item already exist";
       oidOpnameItem= opi.getOID();
       itemMasterId=im.getOID();
   }else{
       oidOpnameItem=0;
   }
   
}

if(iJSPCommand==JSPCommand.SAVE){
   if(oidOpnameItem!=0){//update
        opi.setItemMasterId(itemMasterId);
        opi.setQtyReal(qty);
        
        try{
            DbOpnameItem.updateExc(opi);
            //im = DbItemMaster.fetchExc(itemMasterId);
            im = new ItemMaster();
            opi = new OpnameItem();
             mesage="Data has been saved, please continue data entry";
             oidOpnameItem=0;
        }catch(Exception ex){
            
        }
       
        
   }else{//inset baru
        if(itemMasterId!=0){
            opi.setItemMasterId(itemMasterId);
            opi.setOpnameId(opnameId);
            opi.setQtyReal(qty);
            opi.setSubLocationId(opnameSub.getSubLocationId());
            opi.setOpnameSubLocationId(opnameSub.getOID());
            opi.setType(DbStock.TYPE_NON_CONSIGMENT);
            opi.setDate(new Date());
            DbOpnameItem.insertExc(opi);
            im = new ItemMaster();
            opi = new OpnameItem();
        }
        mesage="Data has been saved, please continue data entry";
   }
   
}
if(iJSPCommand==JSPCommand.CONFIRM){
    if(opi.getOID()!=0){
        DbOpnameItem.deleteExc(opi.getOID());
        oidOpnameItem=0;
        mesage="Data has been deleted";
        im = new ItemMaster();
    }
    
}
String whereClause="";
whereClause= DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_SUB_LOCATION_ID]+ "=" + oidOpnameSub ;
int vectSize = DbOpnameItem.getCount(whereClause);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

                        
<script language="JavaScript">
<!--


<%if(!posPReqPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";


function cmdSearchbycode(){
	document.frmopname.command.value="<%=JSPCommand.SEARCH %>";
        document.frmopname.src_item_name.value=""; 
	document.frmopname.action="addopnameitem.jsp";
        document.frmopname.src_qty.focus();  
	document.frmopname.submit();
        
}
function cmdSearchbyname(){
	document.frmopname.command.value="<%=JSPCommand.SEARCH%>";
        document.frmopname.src_code.value=""; 
	document.frmopname.action="addopnameitem.jsp";
	document.frmopname.submit();
}
function cmdCloseDoc(){
	document.frmopname.action="<%=approot%>/home.jsp";
	document.frmopname.submit();
}

function cmdAskDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdDeleteDoc(){
	
	document.frmopname.command.value="<%=JSPCommand.CONFIRM%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="addopnameitem.jsp";
	document.frmopname.submit();
}

function cmdCancelDoc(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdSaveDoc(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="addopnameitem.jsp";
         
	document.frmopname.submit();
        
}

function cmdAdd(){
	document.frmopname.hidden_opname_item_id.value="0";
	document.frmopname.command.value="<%=JSPCommand.ADD%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAsk(oidOpnameItem){
	document.frmopname.hidden_opname_item_id.value=oidOpnameItem;
	document.frmopname.command.value="<%=JSPCommand.ASK%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdAskMain(oidOpname){
	document.frmopname.hidden_opname_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.ASK%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdConfirmDelete(oidOpnameItem){
	document.frmopname.hidden_opname_item_id.value=oidOpnameItem;
	document.frmopname.command.value="<%=JSPCommand.DELETE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}
function cmdSaveMain(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
	}

function cmdSave(){
	document.frmopname.command.value="<%=JSPCommand.SAVE%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
        
	}

function cmdEdit(oidItemMaster){
	document.frmopname.hidden_item_master_id.value=oidItemMaster;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="addopnameitem.jsp";
	document.frmopname.submit();
	}

function cmdCancel(oidOpname){
	document.frmopname.hidden_opname_item_id.value=oidOpname;
	document.frmopname.command.value="<%=JSPCommand.EDIT%>";
	document.frmopname.prev_command.value="<%=prevJSPCommand%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdBack(){
	document.frmopname.command.value="<%=JSPCommand.BACK%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdListFirst(){
	document.frmopname.command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdListPrev(){
	document.frmopname.command.value="<%=JSPCommand.PREV%>";
	document.frmopname.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
	}

function cmdListNext(){
	document.frmopname.command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmopname.action="opnameitem.jsp";
	document.frmopname.submit();
}

function cmdListLast(){
	document.frmopname.command.value="<%=JSPCommand.LAST%>";
	document.frmopname.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmopname.action="opnameitem.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  
		
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmopname" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="0">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="<%=JspOpname.colNames[JspOpname.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_opname_id" value="<%=oidOpname%>">
                          <input type="hidden" name="hidden_opname_sub_id" value="<%=oidOpnameSub%>">
                          <input type="hidden" name="hidden_item_master_id" value="<%=im.getOID()%>">
                          <input type="hidden" name="hidden_opname_item_id2" value="<%=oidOpnameItem%>">
                          
                          
                          <input type="hidden" name="<%=JspOpnameItem.colNames[JspOpnameItem.JSP_OPNAME_ID]%>" value="<%=oidOpname%>">
                          
                          <%if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
                            <input type="hidden" name="<%=JspOpname.colNames[JspOpname.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
                          <%}%>
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            
                            <tr> 
                              <td valign="top" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="5"></td>
                                  </tr>
                                  
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                              
                                              <tr align="left"> 
                                                <td height="26" width="12%" >&nbsp;&nbsp;Number</td>
                                                <td height="26" width="14%"> 
                                                  <%
                                                    String number = "";
                                                    number = ""+op.getNumber();
						  %>
                                                  <%=number%> </td>
                                                <td height="26" width="9%">Location</td>
                                                <td height="26" colspan="2" width="52%" class="comment"><%=locOp.getName()%></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                  Type </td>
                                                <td width="14%" height="14"> 
                                                    <%if(op.getTypeOpname()==0){%>
                                                    Global
                                                    <%}else{%>
                                                    Partial
                                                    <%}%>
                                                </td>
                                                <td width="9%">status</td>
                                                <td colspan="2" class="comment" width="52%"><%=op.getStatus()%></td>
                                              </tr>
						  
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                 Sub Location </td>
                                                <td height="21" width="27%">
                                                    <%=subLocation.getName()%>
                                                </td>
                                                <td width="9%">Form Number</td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                    <%=opnameSub.getFormNumber()%>
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                <td height="21" width="27%"> 
                                                  <%=JSPFormater.formatDate(opnameSub.getDate(),"dd-MM-yyyy") %>
                                                </td>
                                                <td width="9%"></td>
                                                <td colspan="2" class="comment" width="52%"> 
                                                        
                                                </td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="5" colspan="5"></td>
                                              </tr>
                                              <tr > 
                                                <td colspan="5" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                              </tr>
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                SKU/Barcode </td>
                                                <td height="21" width="27%">
                                                    <input type="text" name="src_code" value="<%=im.getCode()%>" onchange="javascript:cmdSearchbycode()" >
                                                </td>
                                              </tr>  
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                Item Name </td>
                                                <td height="21" width="27%">
                                                    <input type="text" size="50" name="src_item_name" value="<%=im.getName() %>" onchange="javascript:cmdSearchbyname()" >
                                                </td>
                                              </tr>  
                                              <tr align="left"> 
                                                <td height="21" width="12%">&nbsp; 
                                                Qty </td>
                                                <td height="21" width="27%">
                                                    <input type="text" name="src_qty" value="<%=(opi.getQtyReal()==0)? "" : opi.getQtyReal() %>">
                                                </td>
                                              </tr>  
                                              <tr>
                                                <%if(oidOpnameItem!=0){%>
                                                <td height="21" width="12%">
                                                    <a href="javascript:cmdDeleteDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/delete2.gif',1)"><img src="../images/delete.gif" name="save211" height="22" border="0"></a>
                                                </td>
                                                <%}else{%>
                                                <td height="21" width="12%">
                                                    
                                                </td>
                                                <%}%>
                                                <%if(im.getOID()!=0){%>
                                                <td width="149"><div onclick="this.style.visibility='hidden'"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/save2.gif',1)"><img src="../images/save.gif" name="save211" height="22" border="0"></a></div></td>
                                                <%}%>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="2" valign="top" bgcolor="yellow"><%=mesage%></td>
                                              </tr>
                                              
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                              <tr align="left" > 
                                                <td colspan="5" valign="top">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%if(iJSPCommand==JSPCommand.SEARCH){%>
                                   <script language="JavaScript">
                                            document.frmopname.src_qty.focus();
                                   </script>
                                   <%}%>
                                    
                                   <script language="JavaScript">
								   			<%if(iJSPCommand==JSPCommand.SAVE){%> 
                                            document.frmopname.src_code.focus();
											<%}%>
											window.focus();
                                   </script>
                                   
                                  <tr> 
                                    <td>Total Input : <%=vectSize%></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr>
                                <td>
                                    <%if(vim.size()>1){%>
                                    <%= drawList(vim)%>
                                    <%}%>
                                </td>
                            </tr>
                          </table>
                                             
						
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
   

</body>
<!-- #EndTemplate --></html>
