
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
boolean privAdd = true;
boolean privUpdate = true;
boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!

         public String drawList(int iJSPCommand,JspItemCategory frmObject, ItemCategory objEntity, Vector objectClass,  long itemCategoryId)

         {
                 JSPList jsplist = new JSPList();
                 jsplist.setAreaWidth("60%");
                 jsplist.setListStyle("listgen");
                 jsplist.setTitleStyle("tablehdr");
                 jsplist.setCellStyle("tablecell");
                 jsplist.setCellStyle1("tablecell1");
                 jsplist.setHeaderStyle("tablehdr");
                 
                 jsplist.addHeader("Item Category","20%");
                 jsplist.addHeader("Sub Cadegory Code","20%");
                 jsplist.addHeader("Sub Category Name","25%");

                 jsplist.setLinkRow(0);
                 jsplist.setLinkSufix("");
                 Vector lstData = jsplist.getData();
                 Vector lstLinkData = jsplist.getLinkData();
                 Vector rowx = new Vector(1,1);
                 jsplist.reset();
                 int index = -1;
                 String whereCls = "";
                 String orderCls = "";

                 /* selected ItemGroupId*/
                 Vector igroup = DbItemGroup.list(0,0, "type<>"+I_Ccs.TYPE_CATEGORY_CIVIL_WORK, "");
                 Vector itemgroupid_value = new Vector(1,1);
                 Vector itemgroupid_key = new Vector(1,1);
                 if(igroup!=null && igroup.size()>0){
                         for(int i=0; i<igroup.size(); i++){
                                 ItemGroup ig = (ItemGroup)igroup.get(i);
                                 itemgroupid_key.add(""+ig.getName());
                                 itemgroupid_value.add(""+ig.getOID());
                         }
                 }

                 /* selected Priority*/
                 Vector priority_value = new Vector(1,1);
                 Vector priority_key = new Vector(1,1);
                 for(int i=1; i<50; i++){
                         priority_value.add(""+i);
                         priority_key.add(""+i);
                 }

                 for (int i = 0; i < objectClass.size(); i++) {
                          ItemCategory itemCategory = (ItemCategory)objectClass.get(i);
                          rowx = new Vector();
                          if(itemCategoryId == itemCategory.getOID())
                                  index = i; 

                          if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
                                         
                                 rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspItemCategory.JSP_ITEM_GROUP_ID],null, ""+itemCategory.getItemGroupId(), itemgroupid_value , itemgroupid_key, "formElemen", "")+"</div>");
                                 rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspItemCategory.JSP_CODE] +"\" value=\""+itemCategory.getCode()+"\" class=\"formElemen\">"+"</div>");
                                 rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"45\" name=\""+frmObject.colNames[JspItemCategory.JSP_NAME] +"\" value=\""+itemCategory.getName()+"\" class=\"formElemen\">"+"</div>");                                 
                         }else{
                                 
                                 ItemGroup igg = new ItemGroup();
                                 try{
                                         igg = DbItemGroup.fetchExc(itemCategory.getItemGroupId());
                                 }
                                 catch(Exception e){
                                 }
                         
                                 rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(itemCategory.getOID())+"')\">"+igg.getName()+"</a>");
                                 rowx.add(itemCategory.getCode());
                                 rowx.add(itemCategory.getName());                                 
                         } 

                         lstData.add(rowx);
                 }

                  rowx = new Vector();

                 if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
                                 rowx.add("<div align=\"center\">"+JSPCombo.draw(frmObject.colNames[JspItemCategory.JSP_ITEM_GROUP_ID],null, ""+objEntity.getItemGroupId(), itemgroupid_value , itemgroupid_key, "formElemen", "")+"</div>");
                                 rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"20\" name=\""+frmObject.colNames[JspItemCategory.JSP_CODE] +"\" value=\""+objEntity.getCode()+"\" class=\"formElemen\">"+"</div>");
                                 rowx.add("<div align=\"center\">"+"<input type=\"text\" size=\"45\" name=\""+frmObject.colNames[JspItemCategory.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">"+"</div>");                                

                 }

                 lstData.add(rowx);

                 return jsplist.draw(index);
         }

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidItemCategory = JSPRequestValue.requestLong(request, "hidden_item_category_id");

/*variable declaration*/
int recordToGet = 1000;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "group_type<>"+I_Ccs.TYPE_CATEGORY_CIVIL_WORK;
String orderClause = "code";

CmdItemCategory ctrlItemCategory = new CmdItemCategory(request);
JSPLine ctrLine = new JSPLine();
Vector listItemCategory = new Vector(1,1);

/*switch statement */
iErrCode = ctrlItemCategory.action(iJSPCommand , oidItemCategory);
/* end switch*/
JspItemCategory jspItemCategory = ctrlItemCategory.getForm();

/*count list All ItemCategory*/
int vectSize = DbItemCategory.getCount(whereClause);

/*switch list ItemCategory*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
                 start = ctrlItemCategory.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

ItemCategory itemCategory = ctrlItemCategory.getItemCategory();
msgString =  ctrlItemCategory.getMessage();

/* get record to display */
listItemCategory = DbItemCategory.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listItemCategory.size() < 1 && start > 0)
{
          if (vectSize - recordToGet > recordToGet)
                         start = start - recordToGet;   //go to JSPCommand.PREV
          else{
                  start = 0 ;
                  iJSPCommand = JSPCommand.FIRST;
                  prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
          }
          listItemCategory = DbItemCategory.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=titleIS%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">
function cmdAdd(){
         document.frmitemcategory.hidden_item_category_id.value="0";
         document.frmitemcategory.command.value="<%=JSPCommand.ADD%>";
         document.frmitemcategory.prev_command.value="<%=prevJSPCommand%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdAsk(oidItemCategory){
         document.frmitemcategory.hidden_item_category_id.value=oidItemCategory;
         document.frmitemcategory.command.value="<%=JSPCommand.ASK%>";
         document.frmitemcategory.prev_command.value="<%=prevJSPCommand%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdConfirmDelete(oidItemCategory){
         document.frmitemcategory.hidden_item_category_id.value=oidItemCategory;
         document.frmitemcategory.command.value="<%=JSPCommand.DELETE%>";
         document.frmitemcategory.prev_command.value="<%=prevJSPCommand%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdSave(){
         document.frmitemcategory.command.value="<%=JSPCommand.SAVE%>";
         document.frmitemcategory.prev_command.value="<%=prevJSPCommand%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdEdit(oidItemCategory){
         document.frmitemcategory.hidden_item_category_id.value=oidItemCategory;
         document.frmitemcategory.command.value="<%=JSPCommand.EDIT%>";
         document.frmitemcategory.prev_command.value="<%=prevJSPCommand%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdCancel(oidItemCategory){
         document.frmitemcategory.hidden_item_category_id.value=oidItemCategory;
         document.frmitemcategory.command.value="<%=JSPCommand.EDIT%>";
         document.frmitemcategory.prev_command.value="<%=prevJSPCommand%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdBack(){
         document.frmitemcategory.command.value="<%=JSPCommand.BACK%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdListFirst(){
         document.frmitemcategory.command.value="<%=JSPCommand.FIRST%>";
         document.frmitemcategory.prev_command.value="<%=JSPCommand.FIRST%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdListPrev(){
         document.frmitemcategory.command.value="<%=JSPCommand.PREV%>";
         document.frmitemcategory.prev_command.value="<%=JSPCommand.PREV%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdListNext(){
         document.frmitemcategory.command.value="<%=JSPCommand.NEXT%>";
         document.frmitemcategory.prev_command.value="<%=JSPCommand.NEXT%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

function cmdListLast(){
         document.frmitemcategory.command.value="<%=JSPCommand.LAST%>";
         document.frmitemcategory.prev_command.value="<%=JSPCommand.LAST%>";
         document.frmitemcategory.action="itemcategory.jsp";
         document.frmitemcategory.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidItemCategory){
         document.frmimage.hidden_item_category_id.value=oidItemCategory;
         document.frmimage.command.value="<%=JSPCommand.POST%>";
         document.frmimage.action="itemcategory.jsp";
         document.frmimage.submit();
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
    <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
      <!-- #BeginEditable "menu" --> 
<%@ include file="../main/menu.jsp"%>
<!-- #EndEditable -->
</td>
<td width="100%" valign="top"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  
  <tr> 
    <td><!-- #BeginEditable "content" --> 
      <form name="frmitemcategory" method ="post" action="">
        <input type="hidden" name="command" value="<%=iJSPCommand%>">
        <input type="hidden" name="vectSize" value="<%=vectSize%>">
        <input type="hidden" name="start" value="<%=start%>">
        <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
        <input type="hidden" name="hidden_item_category_id" value="<%=oidItemCategory%>">
                                 <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                 <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td> 
              <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                <tr valign="bottom"> 
                  <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                    Maintenance </font><font class="tit1">&raquo; 
                    </font> <span class="lvl2">Sub Category 
                    </span></b></td>
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
<tr align="left" valign="top"> 
<td height="8"  colspan="3"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr align="left" valign="top"> 
      <td height="5" valign="middle" colspan="3"> 
      </td>
    </tr>
<%
try{
%>
<tr align="left" valign="top"> 
  <td height="22" valign="middle" colspan="3"> 
<%= drawList(iJSPCommand,jspItemCategory, itemCategory,listItemCategory,oidItemCategory)%> </td>
</tr>
<% 
}catch(Exception exc){ 
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
<%
if(iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.ASK && iErrCode==0)
{
%>
<tr align="left" valign="top"> 
  <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
</tr>
<%}%>
</table>
</td>
</tr>
<tr align="left" valign="top"> 
<td height="8" valign="middle" width="17%">&nbsp;</td>
<td height="8" colspan="2" width="83%">&nbsp; </td>
</tr>
<%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE && iErrCode!=0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
<tr align="left" valign="top" > 
  <td colspan="3" class="command"> 
<%
ctrLine.setLocationImg(approot+"/images/ctr_line");
ctrLine.initDefault();
ctrLine.setTableWidth("80%");
String scomDel = "javascript:cmdAsk('"+oidItemCategory+"')";
String sconDelCom = "javascript:cmdConfirmDelete('"+oidItemCategory+"')";
String scancel = "javascript:cmdEdit('"+oidItemCategory+"')";
ctrLine.setBackCaption("Back to List");
ctrLine.setJSPCommandStyle("buttonlink");

ctrLine.setOnMouseOut("MM_swapImgRestore()");
ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

//ctrLine.setOnMouseOut("MM_swapImgRestore()");
ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


ctrLine.setWidthAllJSPCommand("90");
ctrLine.setErrorStyle("warning");
ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
ctrLine.setQuestionStyle("warning");
ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
ctrLine.setInfoStyle("success");
ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

if (privDelete){
        ctrLine.setConfirmDelJSPCommand(sconDelCom);
        ctrLine.setDeleteJSPCommand(scomDel);
        ctrLine.setEditJSPCommand(scancel);
}else{ 
        ctrLine.setConfirmDelCaption("");
        ctrLine.setDeleteCaption("");
        ctrLine.setEditCaption("");
}

if(privAdd == false  && privUpdate == false){
        ctrLine.setSaveCaption("");
}

if (privAdd == false){
        ctrLine.setAddCaption("");
}
%>
<%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
</tr>
<%}%>
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
