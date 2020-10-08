
<%-- 
    Document   : menu-t
    Created on : Sep 30, 2011, 4:11:55 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import="com.project.fms.menu.*"%>
<%
            menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
            Periode per13x = DbPeriode.getOpenPeriod13();
            boolean gereja = DbSystemProperty.getModSysPropGereja();
            String transactionFolder = "";
            if (gereja) {
                transactionFolder = "transactionact";
            } else {
                transactionFolder = "transaction";
            }
%>

<%

            Vector vmenuobjx = new Vector();

            Vector vMenuLevel1xxx = new Vector();
            Vector vmenuidbarisobjx = new Vector();   // where  

            int countxxxx = 0;

            String orderby = "" + DbMenu.colNames[DbMenu.COL_CODE_MENU];
            vmenuobjx = DbMenu.list(0, 0, "", orderby);

            vMenuLevel1xxx = DbMenu.list(0, 0, DbMenu.colNames[DbMenu.COL_LEVEL] + "=" + 1, orderby);

            if (vmenuobjx != null && vmenuobjx.size() > 0) {

                for (int ixmenuobjx = 0; ixmenuobjx < vmenuobjx.size(); ixmenuobjx++) {

                    Menu objxMenux = (Menu) vmenuobjx.get(ixmenuobjx);

                }
            }
%>

<script language="JavaScript">
    
    function cmdHelp(){
        window.open("<%=approot%>/help.htm"); 
        }
        
        function cmdChangeMenu(idx){            
                    <%
            if (vMenuLevel1xxx != null && vMenuLevel1xxx.size() > 0) {

                for (int vmxx = 0; vmxx < vMenuLevel1xxx.size(); vmxx++) {

                    Menu mnLevel1 = (Menu) vMenuLevel1xxx.get(vmxx);

                    int pgs = vmxx + 1;

        %>  
            
            if(idx == '0'){
                
                document.all.<%=mnLevel1.getIdxPertama()%>.style.display="";
                document.all.<%=mnLevel1.getIdxKedua()%>.style.display="none";
                document.all.<%=mnLevel1.getIdxKetiga()%>.style.display="none";
                
            }else{
            
                if(idx == <%=pgs%>){                    
                    document.all.<%=mnLevel1.getIdxPertama()%>.style.display="none";
                    document.all.<%=mnLevel1.getIdxKedua()%>.style.display="";
                    document.all.<%=mnLevel1.getIdxKetiga()%>.style.display="";
                }else{
                    document.all.<%=mnLevel1.getIdxPertama()%>.style.display="";
                    document.all.<%=mnLevel1.getIdxKedua()%>.style.display="none";
                    document.all.<%=mnLevel1.getIdxKetiga()%>.style.display="none";
                }
    }
    
                <%
                }
            }
                %>
                }
                
                </script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src="<%=approot%>/images/logo-finance2.jpg" width="216" height="32"/></td>
                </tr>
                <tr> 
                    <td><img src="<%=approot%>/images/spacer.gif" width="1" height="5"></td>
                </tr>                
                <tr> 
                    <td style="padding-left:10px"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <%
            Periode periodeXXX = DbPeriode.getOpenPeriod();
            String openPeriodXXX = JSPFormater.formatDate(periodeXXX.getStartDate(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(periodeXXX.getEndDate(), "dd MMM yyyy");
                                %>
                                <td height="49" align="center"><br><%=openPeriodXXX%><br></td>
                            </tr>
                            <tr> 
                                <td><img src="<%=approot%>/images/spacer.gif" width="1" height="4"></td>
                            </tr>
                            <%
            boolean first = true;
            String transFolder = "";

            for (int idxxmenu = 0; idxxmenu < vmenuobjx.size(); idxxmenu++){

                Menu objxmenu = (Menu) vmenuobjx.get(idxxmenu);
                
                transFolder = "";
                
                if(objxmenu.getFolder().compareTo("") != 0){ 
                        if(objxmenu.getFolder().compareTo("transaction") == 0){
                            transFolder = transactionFolder;
                        }
                }

                String namemenu = "";

                if (lang == LANG_ID){
                    namemenu = objxmenu.getMenuInd();
                } else {
                    namemenu = objxmenu.getMenuEng();
                }

                if (objxmenu.getLevel() == 1) {

                    if (first == false){
                            %>        
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                </tr>
                <%
                                    }

                                    first = false;
                %>
                <tr id="<%=objxmenu.getIdxPertama()%>"> 
                    <td class="menu0" onClick="javascript:cmdChangeMenu('<%=objxmenu.getIndexCmd()%>')"><a href="javascript:cmdChangeMenu('<%=objxmenu.getIndexCmd()%>')"><%=namemenu%></a></td>
                </tr>
                <tr id="<%=objxmenu.getIdxKedua()%>"> 
                    <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=namemenu%></a></td>
                </tr>
                <tr id="<%=objxmenu.getIdxKetiga()%>"> 
                    <td class="submenutd"> 
                        <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                            <%}if(objxmenu.getLevel() == 2){%>
                            <tr>
                                <td class="menu1">
                                    <%if(objxmenu.getLink() == DbMenu.LINK){
                                        if(objxmenu.getFolder().compareTo("") != 0 && objxmenu.getFolder().compareTo("transaction") == 0){%>
                                            <a href="<%=approot%>/<%=transFolder%>/<%=objxmenu.getUrl()%>?menu_idx=<%=objxmenu.getIndexCmd()%>"><%=namemenu%></a>                                        
                                        <%}else{%>
                                            <a href="<%=approot%>/<%=objxmenu.getUrl()%>?menu_idx=<%=objxmenu.getIndexCmd()%>"><%=namemenu%></a>
                                        <%}%>
                                    <%}else{%>
                                        <%=namemenu%>
                                    <%}%>
                                </td>
                            </tr>                                     
                            <%}if(objxmenu.getLevel() == 3){%>                        
                            <tr>
                                <td class="menu2">
                                    <%if(objxmenu.getLink() == DbMenu.LINK){%>
                                        <%if(objxmenu.getFolder().compareTo("") != 0 && objxmenu.getFolder().compareTo("transaction") == 0){%>
                                            <a href="<%=approot%>/<%=transFolder%>/<%=objxmenu.getUrl()%>?menu_idx=<%=objxmenu.getIndexCmd()%>"><%=namemenu%></a>
                                        <%}else{%>
                                            <a href="<%=approot%>/<%=objxmenu.getUrl()%>?menu_idx=<%=objxmenu.getIndexCmd()%>"><%=namemenu%></a>
                                        <%}%>
                                    <%}else{%>
                                        <%=namemenu%>
                                    <%}%></td>
                            </tr>                                                                 
                            <%}%>
                            <%
            }
                            %>   
                        </table>
                    </td>
                </tr>
            </table>   
        </td>        
    </tr>
</table>  
</tr>
</td>
</table>
<script language="JavaScript">
    cmdChangeMenu('0');        
    </script>