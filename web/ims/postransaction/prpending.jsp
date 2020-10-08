 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.postransaction.request.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
int recordToGet = 10;
JSPLine jspLine = new JSPLine();

int vectSize = SessRequest.getCountPending();
Control control = new Control();

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = control.actionList(iJSPCommand, start, vectSize, recordToGet);
 }

Vector vct = SessRequest.getPendingRequest(start, recordToGet);


%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

function cmdListFirst(){
	document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmitemmaster.action="prpending.jsp";
	document.frmitemmaster.submit();
}

function cmdListPrev(){
	document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmitemmaster.action="prpending.jsp";
	document.frmitemmaster.submit();
	}

function cmdListNext(){
	document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmitemmaster.action="prpending.jsp";
	document.frmitemmaster.submit();
}

function cmdListLast(){
	document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
	document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmitemmaster.action="prpending.jsp";
	document.frmitemmaster.submit();
}


<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="frmitemmaster" name="form1" method="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                      </font><font class="tit1">&raquo; <span class="lvl2">Purchase 
                                      Request </span>&raquo; <span class="lvl2">Status 
                                      Pending </span></font></b></td>
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
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="9%" height="21">PR 
                                            Number</td>
                                          <td class="tablehdr" width="10%" height="21">Date</td>
                                          <td class="tablehdr" width="17%" height="21">Department</td>
                                          <td class="tablehdr" width="10%" height="21">Category</td>
                                          <td class="tablehdr" width="11%" height="21">Sub 
                                            Category</td>
                                          <td class="tablehdr" width="21%" height="21">Item 
                                            Code/Name</td>
                                          <td class="tablehdr" width="5%" height="21">Qty</td>
                                          <td class="tablehdr" width="8%" height="21">Status</td>
                                          <td class="tablehdr" width="9%" height="21">Action</td>
                                        </tr>
                                        <%if(vct!=null && vct.size()>0){
										for(int i=0; i<vct.size(); i++){
											Vector v = (Vector)vct.get(i);
											PurchaseRequest pr = (PurchaseRequest)v.get(0);
											PurchaseRequestItem pi = (PurchaseRequestItem)v.get(1);
											
											Department d = new Department();
											try{
												d = DbDepartment.fetchExc(pr.getDepartmentId());
											}
											catch(Exception e){
											}
											
											ItemMaster im = new ItemMaster();
											try{
												im = DbItemMaster.fetchExc(pi.getItemMasterId());
											}
											catch(Exception e){
											}
											
											ItemGroup ig = new ItemGroup();
											try{
												ig = DbItemGroup.fetchExc(im.getItemGroupId());
											}
											catch(Exception e){
											}
											
											ItemCategory ic = new ItemCategory();
											try{
												ic = DbItemCategory.fetchExc(im.getItemCategoryId());
											}
											catch(Exception e){
											}
											
											if(i%2==0){
										%>
                                        <tr> 
                                          <td class="tablecell1" width="9%"><%=pr.getNumber()%></td>
                                          <td class="tablecell1" width="10%"> 
                                            <div align="center"><%=JSPFormater.formatDate(pr.getDate(),"dd MMMM yyyy")%></div>
                                          </td>
                                          <td class="tablecell1" width="17%"><%=d.getName()%></td>
                                          <td class="tablecell1" width="10%"><%=ig.getName()%></td>
                                          <td class="tablecell1" width="11%"><%=ic.getName()%></td>
                                          <td class="tablecell1" width="21%"><%=im.getCode()+"/"+im.getName()%></td>
                                          <td class="tablecell1" width="5%"> 
                                            <div align="right"><%=pi.getQty()%></div>
                                          </td>
                                          <td class="tablecell1" width="8%"> 
                                            <div align="center"><%=pr.getStatus()%></div>
                                          </td>
                                          <td class="tablecell1" width="9%"> 
                                            <div align="center"><a href="prtopo.jsp?hidden_purchase_request_id=<%=pr.getOID()%>&command=<%=JSPCommand.EDIT%>&menu_idx=<%=menuIdx%>">purchase</a></div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td class="tablecell" width="9%"><%=pr.getNumber()%></td>
                                          <td class="tablecell" width="10%"> 
                                            <div align="center"><%=JSPFormater.formatDate(pr.getDate(),"dd MMMM yyyy")%></div>
                                          </td>
                                          <td class="tablecell" width="17%"><%=d.getName()%></td>
                                          <td class="tablecell" width="10%"><%=ig.getName()%></td>
                                          <td class="tablecell" width="11%"><%=ic.getName()%></td>
                                          <td class="tablecell" width="21%"><%=im.getCode()+"/"+im.getName()%></td>
                                          <td class="tablecell" width="5%"> 
                                            <div align="right"><%=pi.getQty()%></div>
                                          </td>
                                          <td class="tablecell" width="8%"> 
                                            <div align="center"><%=pr.getStatus()%></div>
                                          </td>
                                          <td class="tablecell" width="9%"> 
                                            <div align="center"><a href="prtopo.jsp?hidden_purchase_request_id=<%=pr.getOID()%>&command=<%=JSPCommand.EDIT%>&menu_idx=<%=menuIdx%>">purchase</a></div>
                                          </td>
                                        </tr>
                                        <%}}}else{%>
                                        <tr> 
                                          <td class="tablecell" colspan="9" height="20">&nbsp;No 
                                            pending item purchase request available.</td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td><span class="command"> 
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
                                      <% jspLine.setLocationImg(approot+"/images/ctr_line");
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
                                      <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          
                        </form>
                        <!-- #EndEditable --> </td>
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

