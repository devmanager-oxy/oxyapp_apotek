<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
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
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidExchangeRate = JSPRequestValue.requestLong(request, "hidden_exchangerate_id");
int historyType = JSPRequestValue.requestInt(request, "history_type");
int historyRange = JSPRequestValue.requestInt(request, "history_range");

int NUM_BACKUP_DAYS = 25;

//out.println("historyRange : "+historyRange);

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

JSPLine ctrLine = new JSPLine();

Vector currencies = DbCurrency.list(0,0, "", "");	
Vector vctHistory = new Vector();

double valUsd = JSPRequestValue.requestDouble(request, "usd_curr");
double valIdr = JSPRequestValue.requestDouble(request, "idr_curr");
double valEuro = JSPRequestValue.requestDouble(request, "euro_curr");

ExchangeRate erx = new ExchangeRate();

if(iJSPCommand==JSPCommand.SAVE){
	if(valUsd>0 && valIdr>0 && valEuro>0){
		
		erx.setUserId(appSessUser.getUserOID());
		erx.setDate(new Date());
		erx.setValueUsd(valUsd);
		erx.setValueIdr(valIdr);
		erx.setValueEuro(valEuro);
		erx.setStatus(0);
		try{
			CONHandler.execUpdate("update exchangerate set status=1");
			DbExchangeRate.insertExc(erx);
		}
		catch(Exception e){
		}
				
	}
	else{
		msgString = "Data incomplete, please fill in all fields.";
	}
}

if(currencies!=null && currencies.size()>0){

	
/*
	if(iJSPCommand==JSPCommand.SAVE){
		double val = JSPRequestValue.requestDouble(request, "_curr");
		double val = JSPRequestValue.requestDouble(request, c.getOID()+"_curr");
		double val = JSPRequestValue.requestDouble(request, c.getOID()+"_curr");
		
		Date dt = new Date();
		Vector vctExc = new Vector(1,1);
		for(int x=0; x<currencies.size(); x++){
			Currency c = (Currency)currencies.get(x);
			double val = JSPRequestValue.requestDouble(request, c.getOID()+"_curr");
			
			out.println("code : "+c.getCurrencyCode()+", "+val);
			
			if(val>0){
				ExchangeRate  exr = new ExchangeRate();
				exr.setValue(val);
				exr.setDate(dt);
				exr.setCurrencyId(c.getOID());
				exr.setUserId(appSessUser.getUserOID());
				vctExc.add(exr);
			}
			else{
				msgString = msgString + "All data sould be fill in";				
			}
		}
		
		if(msgString.length()==0 && vctExc!=null && vctExc.size()>0){
			//check apakah sudah ada exchange pada tanggal ini			
			//if(DbExchangeRate.getCount("TO_DAYS(DATE)=TO_DAYS('"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd")+"')")>0){
				
				try{
					CONHandler.execUpdate("update exchangerate set status=1");					
				}
				catch(Exception e){
				}
				
				for(int ix=0; ix<vctExc.size(); ix++){
				
					out.println("<br>insert exchange");
					
					ExchangeRate er = (ExchangeRate)vctExc.get(ix);
					er.setStatus(0);
					//Date dt = er.getDate();
					//for(int iz=0; iz<NUM_BACKUP_DAYS; iz++){					
						try{
							//dt = (Date)dt.clone();
							//er.setDate(dt);
							DbExchangeRate.insertExc(er);
							//dt.setDate(dt.getDate()+1);
						}
						catch(Exception e){
							out.println(e.toString());
						}
					//}
					
				}
				
			
			
		}
		
	}


	Date dtEnd = new Date();	
	Date dtStart = (Date)dtEnd.clone();
	
	Vector dts = new Vector();

	switch(historyType){
		case 0 :
		dtStart.setDate(1);
		
		break;
		
		case 1 :
		dtStart.setDate(dtStart.getDate()-historyRange);
		break;
		
		case 2 :
		dtStart.setMonth(0);
		dtStart.setDate(1);
		break;
	}
	
	while(!dtStart.after(dtEnd)){
		Vector temp = new Vector(1,1);
		temp.add((Date)dtStart.clone());
		
		out.println("<br>"+dtStart);
		
		long oidUser = 0;
		
		for(int i=0; i<currencies.size(); i++){
			Currency c = (Currency)currencies.get(i);
			
			out.println("<br>TO_DAYS(DATE)=TO_DAYS('"+JSPFormater.formatDate(dtStart, "yyyy-MM-dd")+"') AND CURRENCY_ID="+c.getOID());
			
			Vector v = DbExchangeRate.list(0,0, "TO_DAYS(DATE)=TO_DAYS('"+JSPFormater.formatDate(dtStart, "yyyy-MM-dd")+"') AND CURRENCY_ID="+c.getOID(), "");
			if(v!=null && v.size()>0){
				ExchangeRate er = (ExchangeRate)v.get(0);
				temp.add(""+er.getValue());
				oidUser = er.getUserId();
			}
			else{
				temp.add("0");
			}
		}
		
		out.println("<br>oidUser : "+oidUser);
				
		try{
			User su = DbUser.fetch(oidUser);
			temp.add(su.getLoginId());
		}
		catch(Exception e){
			temp.add("-");
		}		
		
		vctHistory.add(temp);
		
		dtStart.setDate(dtStart.getDate()+1);
	}
	
	*/

	
}


//Vector currencies = DbCurrency.list(0,0, "", "");


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>POS Back Office</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdHistory(type){
	document.frmexchangerate.history_type.value=type;
	document.frmexchangerate.command.value="<%=JSPCommand.LIST%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
}


function cmdAdd(){
	document.frmexchangerate.hidden_exchangerate_id.value="0";
	document.frmexchangerate.command.value="<%=JSPCommand.ADD%>";
	document.frmexchangerate.prev_command.value="<%=prevJSPCommand%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
}

function cmdAsk(oidExchangeRate){
	document.frmexchangerate.hidden_exchangerate_id.value=oidExchangeRate;
	document.frmexchangerate.command.value="<%=JSPCommand.ASK%>";
	document.frmexchangerate.prev_command.value="<%=prevJSPCommand%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
}

function cmdConfirmDelete(oidExchangeRate){
	document.frmexchangerate.hidden_exchangerate_id.value=oidExchangeRate;
	document.frmexchangerate.command.value="<%=JSPCommand.DELETE%>";
	document.frmexchangerate.prev_command.value="<%=prevJSPCommand%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
}
function cmdSave(){
	document.frmexchangerate.command.value="<%=JSPCommand.SAVE%>";
	document.frmexchangerate.prev_command.value="<%=prevJSPCommand%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
	}

function cmdEdit(oidExchangeRate){
	document.frmexchangerate.hidden_exchangerate_id.value=oidExchangeRate;
	document.frmexchangerate.command.value="<%=JSPCommand.EDIT%>";
	document.frmexchangerate.prev_command.value="<%=prevJSPCommand%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
	}

function cmdCancel(oidExchangeRate){
	document.frmexchangerate.hidden_exchangerate_id.value=oidExchangeRate;
	document.frmexchangerate.command.value="<%=JSPCommand.EDIT%>";
	document.frmexchangerate.prev_command.value="<%=prevJSPCommand%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
}

function cmdBack(){
	document.frmexchangerate.command.value="<%=JSPCommand.BACK%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
	}

function cmdListFirst(){
	document.frmexchangerate.command.value="<%=JSPCommand.FIRST%>";
	document.frmexchangerate.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
}

function cmdListPrev(){
	document.frmexchangerate.command.value="<%=JSPCommand.PREV%>";
	document.frmexchangerate.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
	}

function cmdListNext(){
	document.frmexchangerate.command.value="<%=JSPCommand.NEXT%>";
	document.frmexchangerate.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
}

function cmdListLast(){
	document.frmexchangerate.command.value="<%=JSPCommand.LAST%>";
	document.frmexchangerate.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmexchangerate.action="exchangerate.jsp";
	document.frmexchangerate.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/save2.gif')">
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
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmexchangerate" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_exchangerate_id" value="<%=oidExchangeRate%>">
                          <input type="hidden" name="history_type" value="0">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3" class="listtitle"></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="top" colspan="3"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="21" valign="middle" colspan="3"> 
                                            <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td class="boxed1"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1" class="listgen">
                                                    <tr> 
                                                      <td width="251" height="19" class="tablehdr">Date</td>
                                                      <!--td width="80" height="19" class="tablehdr">USD</td-->
                                                      <td width="137" height="19" class="tablehdr">USD</td>
                                                      <td width="125" height="19" class="tablehdr">EUR</td>
                                                      <td width="257" height="19" class="tablehdr">PIC</td>
                                                    </tr>
                                                    <%
							  vctHistory = DbExchangeRate.list(0,0, "", "DATE");
							  
							  if(vctHistory!=null && vctHistory.size()>0){
							  		for(int i=0; i<vctHistory.size(); i++){
							  			ExchangeRate er = (ExchangeRate)vctHistory.get(i);
										
										String css = "tablecell";
										if(i%2!=0){
											css = "tablecell1";
										}
							  %>
                                                    <tr> 
                                                      <td width="251" class="<%=css%>"><%=JSPFormater.formatDate(er.getDate(), "dd MMMM yy")%> <%=JSPFormater.formatDate(er.getTime(), "HH:mm:ss")%></td>
                                                      <!--td width="80" class="tablecell"> 
                                  <div align="right"><%=JSPFormater.formatNumber(er.getValueUsd(), "#,###.##")%> </div>
                                </td-->
                                                      <td width="137" class="<%=css%>"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(er.getValueUsd(), "#,###.##")%> </div>
                                                      </td>
                                                      <td width="125" class="<%=css%>"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(er.getValueEuro(), "#,###.##")%> </div>
                                                      </td>
                                                      <td width="257" height="19" class="<%=css%>"> 
                                                        <%try{
									 User au = DbUser.fetch(er.getUserId());	
								%>
                                                        <%=au.getLoginId()%> 
                                                        <%}
								catch(Exception e){}%>
                                                      </td>
                                                    </tr>
                                                    <%}}%>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" width="17%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%" class="comment">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" colspan="3"><b>UPDATE 
                                      BOOKEEPING RATE</b></td>
                                  </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="21" valign="top" colspan="3"> 
                                            <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td class="boxed1"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#EAEAEA">
                                                    <tr> 
                                                      <td colspan="5" height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="220" height="19">&nbsp;</td>
                                                      <td width="106" height="19">&nbsp;</td>
                                                      <td width="96" height="19">&nbsp;</td>
                                                      <td width="113" height="19">&nbsp;</td>
                                                      <td width="250" height="19">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="220" height="19"><b>Date</b></td>
                                                      <td width="106" height="19"><b>Currency 
                                                        Code</b></td>
                                                      <td width="96" height="19"><b>IDR</b></td>
                                                      <td width="113" height="19"><b>USD</b></td>
                                                      <td width="250" height="19"><b>EUR</b></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="220" nowrap><%=JSPFormater.formatDate(new Date(), "dd MMMM yy HH:mm:ss")%></td>
                                                      <td width="106">&nbsp;</td>
                                                      <td width="96"> 
                                                        <input type="text" name="idr_curr" size="5" maxlength="20" class="formElemen" value="1" readOnly style="text-align:right">
                                                      </td>
                                                      <td width="113"> 
                                                        <input type="text" name="usd_curr" size="10" maxlength="20" class="formElemen" value="<%=JSPHandler.userFormatStringDecimal(valUsd, 2)%>" style="text-align:right">
                                                      </td>
                                                      <td width="250"> 
                                                        <input type="text" name="euro_curr" size="10" maxlength="20" class="formElemen" value="<%=JSPHandler.userFormatStringDecimal(valEuro, 2)%>" style="text-align:right">
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="5" nowrap height="3"></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" colspan="3"> 
                                      <font color="#FF0000"><%=msgString%> </font></td>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="94%"><a href="javascript:cmdSave()" class="command"></a><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2" border="0"></a></td>
                                        </tr>
                                      </table>
                                    </td>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%">&nbsp; 
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="17%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%">&nbsp; 
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                  </tr>
                                  <tr align="left" valign="top" > 
                                    <td colspan="3" class="command">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="13%">&nbsp;</td>
                                    <td width="87%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top" > 
                                    <td colspan="3"> 
                                      <div align="left"></div>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table></td>
  </tr>
</table>
                          
                        </form>
                        <span class="level1">Master 
                        Maintenance</span> &raquo; <span class="level1">Accounting</span> 
                        &raquo; <span class="level2">Bookkeeping Rate<br>
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
