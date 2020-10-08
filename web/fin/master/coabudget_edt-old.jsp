
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>

<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
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

	public String drawList(int iCommand,JspCoaBudget frmObject, CoaBudget objEntity, Vector objectClass,  long coaBudgetId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		//ctrlist.setCellStyle("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Period","50%");
		ctrlist.addHeader("Amount","50%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 CoaBudget coaBudget = (CoaBudget)objectClass.get(i);
			 rowx = new Vector();
			 if(coaBudgetId == coaBudget.getOID())
				 index = i; 

			 if(index == i && (iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCoaBudget.JSP_COA_ID] +"\" value=\""+coaBudget.getCoaId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCoaBudget.JSP_AMOUNT] +"\" value=\""+coaBudget.getAmount()+"\" class=\"formElemen\">");
			}else{
				Periode p = new Periode();
				try{
					p = DbPeriode.fetchExc(coaBudget.getPeriodeId());
				}
				catch(Exception e){
				}
				rowx.add(p.getName());
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(coaBudget.getAmount(), "#,###.##")+"</div>");
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCoaBudget.JSP_COA_ID] +"\" value=\""+objEntity.getCoaId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCoaBudget.JSP_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCoaBudget = JSPRequestValue.requestLong(request, "hidden_coa_budget_id");
long oidCoa = JSPRequestValue.requestLong(request, "coa_id");

Coa coa = new Coa();
try{
	coa = DbCoa.fetchExc(oidCoa);
}
catch(Exception e){
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "coa_id="+oidCoa;
String orderClause = "periode_id";

CmdCoaBudget ctrlCoaBudget = new CmdCoaBudget(request);
JSPLine ctrLine = new JSPLine();
Vector listCoaBudget = new Vector(1,1);

/*switch statement */
iErrCode = ctrlCoaBudget.action(iCommand , oidCoaBudget);
/* end switch*/
JspCoaBudget jspCoaBudget = ctrlCoaBudget.getForm();

/*count list All CoaBudget*/
int vectSize = DbCoaBudget.getCount(whereClause);

/*switch list CoaBudget*/
if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
  (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)){
		start = ctrlCoaBudget.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

CoaBudget coaBudget = ctrlCoaBudget.getCoaBudget();
msgString =  ctrlCoaBudget.getMessage();

/* get record to display */
listCoaBudget = DbCoaBudget.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCoaBudget.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iCommand = JSPCommand.FIRST;
		 prevCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCoaBudget = DbCoaBudget.list(start,recordToGet, whereClause , orderClause);
}
%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- #BeginTemplate "/Templates/clean.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<%//if(!masterPriv){%>
//	window.location="<%=approot%>/nopriv.jsp";
<%//}%>
</script>
<!-- #EndEditable -->
</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF"> 
<center>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
      <td valign="top"> 
        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
          <!--DWLayoutTable-->
          <tr> 
            <td width="7" valign="top"  height="40"><img src="<%=approot%>/images/spacer.gif" width="3" height="1"></td>
            <td height="40" valign="top" > <!-- #BeginEditable "content" --> 
			  <table width="98%" border="0" cellspacing="1" cellpadding="1" height="100%">
                <tr> 
                  <td height="5"></td>
                </tr>
                <tr> 
                  <td valign="top" height="100%" > 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="18" valign="middle" colspan="3" class="comment"><b>&nbsp;Account 
                          Budgeting : <%=coa.getName().toUpperCase()%></b></td>
                      </tr>
                      <%
							try{
							%>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,jspCoaBudget, coaBudget,listCoaBudget,oidCoaBudget)%> </td>
                      </tr>
                      <% 
						  }catch(Exception exc){ 
						  }%>
                      <tr align="left" valign="top"> 
                        <td height="8" align="left" colspan="3" class="command"> 
                          <span class="command"> 
                          <% 
								   int cmd = 0;
									   if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| 
										(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
											cmd =iCommand; 
								   else{
									  if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevCommand; 
								   } 
							    %>
                          <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								 %>
                          <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td height="20">
                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="20">
                      <tr>
                        <td width="33%" height="16">&nbsp;</td>
                        <td width="53%" height="16">&nbsp;</td>
                        <td width="14%" height="16" bgcolor="#000066"> 
                          <div align="center"><a href="javascript:cmdClosex()"><font color="#FFFFFF"><b>Close</b></font></a></div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              
                <script language="JavaScript">
					function cmdClosex(){
						window.close();
					}
					window.focus();
				</script>
              
               
        
        <!-- #EndEditable --></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="1" valign="top"><img src="<%=approot%>/images/spacer.gif" width="1" height="1" /></td> 
    </tr>

    
  </table>
</center>
</body>
<!-- #EndTemplate --></html>
