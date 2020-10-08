<%-- 
    Document   : print_Invoice_Priview
    Created on : Dec 28, 2011, 2:01:43 PM
    Author     : Ngurah Wirata
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>


<style type="text/css">
    #font-tittle{
        font-family:Arial, Helvetica, sans-serif;
        font-size:12px;
        font-weight:bold;
        padding-left:5px;
        padding-right:5px;
        text-align:center;
    }  
    
    #font-header{
        font-family:Arial, Helvetica, sans-serif;
        font-size:11px;
        font-weight:bold;
        padding-left:5px;
        padding-right:5px;
        text-align:center;
		vertical-align:middle;
        
    }    
    
    #font-text{
        font-family:Arial, Helvetica, sans-serif;
        font-size:12px;
        padding-left:5px;
        padding-right:5px;
		vertical-align:top;
		padding-top:3px;
    }
    
    </style>    

<%
            
            
      
        

       

        

      
%>
<table width="100%">
<tr>
<td width="5%">&nbsp;</td>
<td >

<table width="100%" cellpadding="0" cellspacing="0" border="0" >
  <tr> 
    <td colspan="3" class id="font-text" width="4%">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" class id="font-text" width="4%">&nbsp;</td>
  </tr>
  <tr> 
      <td colspan="3" class id="font-headert" width="4%"><b>User list</b></td>
  </tr>
  <tr> 
    <td colspan="3" class id="font-text" width="4%">&nbsp;</td>
  </tr>
  <tr> 
    <td class id="font-header" style="border-left:#000000 1.5px solid;border-top:#000000 1.5px solid;border-bottom:#000000 1.5px solid"  width="30%"> 
      <div align="center">LOGIN ID</div>
    </td>
    <td class id="font-header" style="border-left:#000000 1.5px solid;border-top:#000000 1.5px solid;border-bottom:#000000 1.5px solid" width="40%"> 
      <div align="center">FULL NAME</div>
    </td>
    <td class id="font-header" style="border-left:#000000 1.5px solid;border-top:#000000 1.5px solid;border-bottom:#000000 1.5px solid;border-right:#000000 1.5px solid" width="30%"> 
      <div align="center">USER KEY</div>
    </td>
  </tr>
  <%
    Vector Vuser = new Vector();
    Vuser = DbUser.listPartObj(0, 0,"","");
    User us = new User();
    if(Vuser.size()>0){
        for(int i=0;i<Vuser.size();i++){
            us = (User) Vuser.get(i);
        
        
  %> 

      <tr> 
        <td class id="font-text" style="border-left:#000000 1.5px solid" width="30%"><%=us.getLoginId()%></td>
        <td class id="font-text" style="border-left:#000000 1.5px solid" width="40%"><%=us.getFullName()%></td>
        <td class id="font-text" style="border-left:#000000 1.5px solid;border-right:#000000 1.5px solid" width="30%"><%=us.getUserKey()%></td>
            
        
      </tr>
       
     
  <%}%>
  <tr> 
        <td class id="font-text" style="border-top:#000000 1px solid" width="30%">&nbsp;</td>
        <td class id="font-text" style="border-top:#000000 1px solid" width="40%">&nbsp;</td>
        <td class id="font-text" style="border-top:#000000 1px solid" width="30%">&nbsp;</td>
        
  </tr> 
  <%}%> 
<tr> 
        <td class id="font-text" width="4%">&nbsp;</td>
        <td class id="font-text" width="32%">&nbsp;</td>
        <td class id="font-text" width="6%">&nbsp;</td>
       
           
            
        </td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  <tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  <tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  
 </table>

</td>
<td width="5%">&nbsp;</td>
</tr>
</table>




  
 
  
 
  


