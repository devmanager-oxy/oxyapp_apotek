<%
	/***********************************|
	|  Create by Dek-Ndut               |
	|                                   |
	|  10/31/2007 2:55:30 PM
	|***********************************/
%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
	public String drawList(Vector objectClass, long donorComponentOid, String approot, int start, int recordToGet)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("Code","10%");
		jsplist.addHeader("Component Name","30%");
		jsplist.addHeader("Donor Name","20%");
		jsplist.addHeader("Description","30%");
		

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		jsplist.setLinkPrefix("javascript:cmdEdit('");
		jsplist.setLinkSufix("')");
		jsplist.reset();
		int index = -1;

		int loopInt = 0;
		if(CONHandler.CONSVR_TYPE==CONHandler.CONSVR_MSSQL)
		{
			if((start + recordToGet)> objectClass.size())
			{
				loopInt = recordToGet - ((start + recordToGet) - objectClass.size());
			}
			else
			{
				loopInt = recordToGet;
			}
		}
		else
		{
			start = 0;
			loopInt = objectClass.size();
		}

		int count = 0;
		for(int i=start; (i<objectClass.size() && count<loopInt); i++)
		{
			count = count + 1;
			DonorComponent objDonorComponent = (DonorComponent)objectClass.get(i);
			Vector rowx = new Vector();
			if(donorComponentOid == objDonorComponent.getOID())
				index = i;

			rowx.add(objDonorComponent.getCode());
			rowx.add(getSubstring(objDonorComponent.getName()));
			
			Donor d =  new Donor();
			try 
			{
				d = DbDonor.fetchExc(objDonorComponent.getDonorId());
			} catch (Exception e)
			{
				System.out.println(e);
			}
			rowx.add(d.getName());
			rowx.add(getSubstring(objDonorComponent.getDescription()));
			

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objDonorComponent.getOID()));
		}
		return jsplist.draw(index);
	}
	public String getSubstring(String s){
		if(s.length()>60){
			s="<a href=\"#\" title=\""+s+"\"><font color=\"black\">"+s.substring(0,55)+"...</font></a>";
		}
		return s;
	}
%>
<%
	int iCommand = JSPRequestValue.requestCommand(request);
	//if(iCommand==JSPCommand.NONE)
	//{
	//	iCommand = JSPCommand.ADD;
	//}

	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidDonorComponent = JSPRequestValue.requestLong(request, "hidden_donorcomponent");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "";

	CmdDonorComponent cmdDonorComponent = new CmdDonorComponent(request);
	JSPLine jspLine = new JSPLine();
	Vector listDonorComponent = new Vector(1,1);

	// switch statement
	iErrCode = cmdDonorComponent.action(iCommand , oidDonorComponent);

	// end switch
	JspDonorComponent jspDonorComponent = cmdDonorComponent.getForm();

	// count list All DonorComponent
	int vectSize = DbDonorComponent.getCount(whereClause);

	recordToGet = vectSize;

	//out.println(jspDonorComponent.getErrors());

	DonorComponent donorComponent = cmdDonorComponent.getDonorComponent();
	msgString =  cmdDonorComponent.getMessage();
	//out.println(msgString);

	// switch list DonorComponent
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbDonorComponent.generateFindStart(donorComponent.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdDonorComponent.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listDonorComponent = DbDonorComponent.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listDonorComponent.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listDonorComponent = DbDonorComponent.list(start,recordToGet, whereClause , orderClause);
	}

	//if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0)
	//{
	//	iCommand = JSPCommand.ADD;
	//	donorComponent = new DonorComponent();
	//	oidDonorComponent = 0;
	//}
	Vector temp = new Vector(1,1);
	temp = DbDonor.list(0,0, "", "NAME");								
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">

<%if(!masterPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	function cmdAdd(){
		document.frmdonorcomponent.hidden_donorcomponent.value="0";
		document.frmdonorcomponent.command.value="<%=JSPCommand.ADD%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdAsk(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.ASK%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdDelete(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.ASK%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdConfirmDelete(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.DELETE%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdSave(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.SAVE%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
		}

	function cmdEdit(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.EDIT%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
		}
	
	function cmdToEditor(){
		document.frmdonorcomponent.hidden_donorcomponent.value="0";
		document.frmdonorcomponent.command.value="<%=JSPCommand.ADD%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponentedt.jsp";
		document.frmdonorcomponent.submit();
}	

	function cmdCancel(oidDonorComponent){
		document.frmdonorcomponent.hidden_donorcomponent.value=oidDonorComponent;
		document.frmdonorcomponent.command.value="<%=JSPCommand.EDIT%>";
		document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdBack(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.BACK%>";
		//document.frmdonorcomponent.hidden_donorcomponent.value="0";
		//document.frmdonorcomponent.command.value="<%=JSPCommand.ADD%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
		}

	function cmdListFirst(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.FIRST%>";
		document.frmdonorcomponent.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdListPrev(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.PREV%>";
		document.frmdonorcomponent.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
		}

	function cmdListNext(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.NEXT%>";
		document.frmdonorcomponent.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
	}

	function cmdListLast(){
		document.frmdonorcomponent.command.value="<%=JSPCommand.LAST%>";
		document.frmdonorcomponent.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmdonorcomponent.action="donorcomponent.jsp";
		document.frmdonorcomponent.submit();
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
<!--End Region JavaScript-->
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" -->
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Donor Component</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <!--Begin Region Content-->
                        <form name="frmdonorcomponent" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                          <input type="hidden" name="hidden_donorcomponent" value="<%=oidDonorComponent%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
                              <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"></td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="15" valign="middle" colspan="3" class="comment"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                <td class="tab"> 
                                                  <div align="center">&nbsp;&nbsp;Records&nbsp;&nbsp;</div>
                                                </td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabin"> 
                                                  <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToEditor()" class="tablink">Editor</a>&nbsp;&nbsp;</div>
                                                </td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try
							{
								if (listDonorComponent != null && listDonorComponent.size()>0)
								{
						%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3" class="page"><%=drawList(listDonorComponent,oidDonorComponent, approot, start, recordToGet)%> </td>
                                        </tr>
                                        <%  
								}else{%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="28" height="20">&nbsp;</td>
                                                <td width="67" height="20">&nbsp;</td>
                                                <td width="30" height="20">&nbsp;</td>
                                                <td width="216" height="20">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="28"><a href="javascript:cmdToEditor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                <td width="67">&nbsp;</td>
                                                <td width="30">&nbsp;</td>
                                                <td width="216">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%}
							}catch(Exception exc)
							{
							} 
						%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <span class="command"> 
                                            <% 
									int cmd = 0;
									if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) 
										cmd = iCommand; 
									else
									{
										if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
											cmd = JSPCommand.FIRST;
										else 
											cmd = prevCommand; 
									} 
									jspLine.setLocationImg(approot+"/images/ctr_line");
									jspLine.initDefault();
									
									jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								%>
                                            <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <%if(listDonorComponent!=null && listDonorComponent.size()>0){%>
                                            <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td width="71">&nbsp;</td>
                                                <td width="45">&nbsp;</td>
                                                <td width="76">&nbsp;</td>
                                                <td width="176">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="71"><a href="javascript:cmdToEditor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a></td>
                                                <td width="45">&nbsp;</td>
                                                <td width="76">&nbsp;</td>
                                                <td width="176">&nbsp;</td>
                                              </tr>
                                            </table>
                                            <%}%>
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
                        <!--End Region Content-->
                        <!-- #EndEditable -->
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
