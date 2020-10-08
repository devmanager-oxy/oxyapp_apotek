 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content
Vector categories = DbItemGroup.list(0,0, "", "");
Vector subCategories = DbItemCategory.list(0,0, "", "");
int start = JSPRequestValue.requestInt(request, "start");
int recordToGet = 0; 
String code = JSPRequestValue.requestString(request, "code"); 
String name = JSPRequestValue.requestString(request, "name");
long groupid  = JSPRequestValue.requestLong(request, "group_id");
long categoryid = JSPRequestValue.requestLong(request, "category_id");

Vector listItemStock = DbStock.getStockList(start, recordToGet, code, name, groupid, categoryid);

out.println(listItemStock);

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
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
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                        <tr valign="bottom"> 
                                          <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                            </font><font class="tit1">&raquo; 
                                            </font><span class="lvl2">Stock List</span></b></td>
                                          <td width="40%" height="23"> 
                                            <%@ include file = "../main/userpreview.jsp" %>
                                          </td>
                                        </tr>
                                        <tr > 
                                          <td colspan="2" height="3" background="../images/line1.gif" ></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">Code</td>
                                          <td width="15%"> 
                                            <input type="text" name="textfield2" size="30">
                                          </td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">Item Name</td>
                                          <td width="15%"> 
                                            <input type="text" name="textfield" size="30">
                                          </td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">Cetegory</td>
                                          <td width="15%"> 
                                            <select name="select">
                                              <option value="0">All ...</option>
                                              <%if(categories!=null && categories.size()>0){
											  		for(int i=0; i<categories.size(); i++){
														ItemGroup ig = (ItemGroup)categories.get(i);
											  %>
                                              <option value="<%=ig.getOID()%>"><%=ig.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">Sub Category</td>
                                          <td width="15%"> 
                                            <select name="select2">
                                              <option value="0">All ..</option>
                                              <%if(subCategories!=null && subCategories.size()>0){
											  		for(int i=0; i<subCategories.size(); i++){
														ItemCategory ic = (ItemCategory)subCategories.get(i);
											  %>
                                              <option value="<%=ic.getOID()%>"><%=ic.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                          <td width="44%">&nbsp; </td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td width="11%">&nbsp;</td>
                                          <td width="15%">
                                            <input type="button" name="Button" value="Search">
                                          </td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="6%" class="tablehdr">Code</td>
                                                <td width="16%" class="tablehdr">Name</td>
                                                <td width="12%" class="tablehdr">Category</td>
                                                <td width="12%" class="tablehdr">Sub 
                                                  Category</td>
                                                <td width="12%" class="tablehdr">Location 
                                                  1</td>
                                                <td width="10%" class="tablehdr">Location 
                                                  2</td>
                                                <td width="23%" class="tablehdr">Total 
                                                  Stock </td>
                                                <td width="18%" class="tablehdr">Average 
                                                  Price</td>
                                                <td width="15%" class="tablehdr">Total 
                                                  Amount</td>
                                              </tr>
											  <%if(listItemStock!=null && listItemStock.size()>0){
											  for(int i=0; i<listItemStock.size(); i++){
											  	Stock stock = (Stock)listItemStock.get(i);
											  %>
                                              <tr> 
                                                <td width="6%"><%=stock.getItemCode()%></td>
                                                <td width="16%"><%=stock.getItemName()%></td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%"><%=stock.getQty()%></td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
											  <%}}%>
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="16%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="11%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="44%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
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
