<%@ page import="java.util.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.admin.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%!
public String drawList(int iCommand, JspSystemProperty jspSystemProperty, Vector objectClass, String groupName, long lOid){
	JSPList cmdist = new JSPList();
	cmdist.setAreaWidth("100%");
	cmdist.setListStyle("listgen");
	cmdist.setTitleStyle("tablehdr");
	cmdist.setCellStyle("tablecell");
	cmdist.setHeaderStyle("tablehdr");	
	cmdist.setTitle(groupName + " Properties");	
	cmdist.dataFormat("Name","20%","center","center");
	cmdist.dataFormat("Value","20%","left","left");
	cmdist.dataFormat("Value Type","10%","left","left");	
	cmdist.dataFormat("Description","50%","left","left");	

	String editValPre = "<input type=\"text\" name=\"" + jspSystemProperty.fieldNames[jspSystemProperty.JSP_VALUE] +"\" size=\"20\" value=\"";
	String editValSup = "\"> * "+ jspSystemProperty.getErrorMsg(jspSystemProperty.JSP_NAME);

	cmdist.setLinkRow(0);
	cmdist.setLinkSufix("");
	Vector lstData 		= cmdist.getData();
	Vector lstLinkData 	= cmdist.getLinkData();
	cmdist.setLinkPrefix("javascript:cmdEdit('");
	cmdist.setLinkSufix("')");
	cmdist.reset();
	
	try{
		if((objectClass!=null) && (objectClass.size()>0)){  
			for(int i=0; i<objectClass.size(); i++){
				 Vector rowx = new Vector();
  				 System.out.println("========>2");

				 SystemProperty sysProp2 = (SystemProperty)objectClass.get(i);
				 rowx.add(sysProp2.getName());

				 if(iCommand==JSPCommand.ASSIGN && lOid==sysProp2.getOID()){
					rowx.add(editValPre + sysProp2.getValue() + editValSup);
				 }else{
					rowx.add("<a href=\"javascript:cmdAssign('"+sysProp2.getOID()+"')\">"+sysProp2.getValue()+"</a>");
				 }

				 rowx.add(sysProp2.getValueType());
				 rowx.add(sysProp2.getNote());

				 lstData.add(rowx); 
				 lstLinkData.add(String.valueOf(sysProp2.getOID()));
			}
		}
	}catch(Exception e){
		System.out.println("Exc : " + e.toString());
	} 
	return cmdist.draw();
}
%>
<%   
int iCommand = JSPRequestValue.requestCommand(request);
long lOid = JSPRequestValue.requestLong(request, "oid");
CmdSystemProperty cmdSystemProperty = new CmdSystemProperty(request);
cmdSystemProperty.action(iCommand, lOid, request);
if ( iCommand==JSPCommand.LOAD){
 /* Load system property */
			//AppValue.loadSystemProperty();
}

SystemProperty sysProp = cmdSystemProperty.getSystemProperty();
JspSystemProperty jspSystemProperty = cmdSystemProperty.getForm();
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language=javascript>

<%if(!adminPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdList() {
  document.jspData.command.value="<%= JSPCommand.LIST %>";          
  document.jspData.action = "sysprop.jsp";
  document.jspData.submit();
}

function cmdLoad() {
  document.jspData.command.value="<%= JSPCommand.LOAD %>";          
  document.jspData.action = "sysprop.jsp";
  document.jspData.submit();
}

function cmdNew() {
  document.jspData.command.value="<%= JSPCommand.ADD %>";          
  document.jspData.action = "syspropnew.jsp";
  document.jspData.submit();
}

function cmdEdit(oid) {
  document.jspData.command.value="<%= JSPCommand.EDIT %>";                    
  document.jspData.oid.value = oid;
  document.jspData.action = "syspropnew.jsp";
  document.jspData.submit();
}

function cmdAssign(oid) {
  document.jspData.command.value="<%= JSPCommand.ASSIGN %>";       
  document.jspData.oid.value= oid;          
  document.jspData.action = "sysprop.jsp";
  document.jspData.submit();
}

function cmdUpdate(oid) {
  document.jspData.command.value="<%= JSPCommand.UPDATE %>";          
  document.jspData.oid.value = oid;
  document.jspData.action = "sysprop.jsp";
  document.jspData.submit();
    }
	
function backMenu(){
	document.jspData.action="<%=approot%>/management/main_systemadmin.jsp";
	document.jspData.submit();
}
	
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                        <form name="jspData" method="post" action="">
                          <input type="hidden" name="command" value="0">
                          <input type="hidden" name="oid" value="<%=lOid%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Administrator 
                                      </font><font class="tit1">&raquo; </font><span class="lvl2">System 
                                      Properties </span></b></td>
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
                              <td>&nbsp;</td>
                            </tr>
                          </table>
						  
                          <table width="80%" border="0" cellspacing="6" cellpadding="0">
                            <tr> 
                              <td> 
                                <%
					String cbxName = JspSystemProperty.fieldNames[JspSystemProperty.JSP_GROUP];
		
					String groupName = JSPRequestValue.requestString(request, cbxName);
					if(groupName == null || groupName.equals("")) groupName = "";
		
					Vector grs = Validator.toVector(QrSystemProperty.groups, QrSystemProperty.subGroups, "> ", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ", true);
					Vector val = Validator.toVector(QrSystemProperty.groups, QrSystemProperty.subGroups, "", "", false);
					
					String strChange = "onChange=\"javascript:cmdList()\"";
					out.println("&nbsp;"+JSPCombo.draw(cbxName, "formElemen", null, groupName, val, grs, strChange));
					//System.out.println("========>1");
					Vector vctData = DbSystemProperty.listByGroup(groupName);							
					//System.out.println("========>2");
					%>
                                <!--<a href='javascript:cmdList()'>List</a> </td>-->
                            </tr>
                            <tr> 
                              <td><%=drawList(iCommand,jspSystemProperty,vctData,groupName,lOid)%></td>
                            </tr>
                            <tr> 
                              <td align="right"><%="<i>"+cmdSystemProperty.getMessage()+"</i>"%> </td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                                <% 
					if(iCommand==JSPCommand.ASSIGN){
						out.println("<a href=\"javascript:cmdUpdate('"+lOid+"')\">Update Value</a> | <a href='javascript:cmdList()'>Cancel</a> | ");
					}
					out.println("<a href=\"javascript:cmdNew()\">New Property</a>  ");
					//out.println("<a href=\"javascript:cmdLoad()\">Load New value</a> | ");
					//out.println("<a href=\"javascript:backMenu()\">Back To Management Menu</a>&nbsp;");
					%>
                              </td>
                            </tr>
                            <tr> 
                              <td align="left"> N O T E : <br>
                                - Use "\\" character when you want to input "\" 
                                character in value field.<br>
                                - Click "Load new value" link when property it's 
                                updated. </td>
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
