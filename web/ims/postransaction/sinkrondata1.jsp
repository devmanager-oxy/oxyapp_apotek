
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%

Date srcStartDate = new Date();
Date srcStartDateKolom = new Date();
Date srcStartDateTemp = new Date();
Date srcEndDate = new Date();
int iJSPCommand = JSPRequestValue.requestCommand(request);
String startDate = JSPRequestValue.requestString(request, "src_start_date");
String endDate = JSPRequestValue.requestString(request, "src_end_date");
long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
if(startDate != ""){
                srcStartDate = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcStartDateKolom = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcStartDateTemp = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(endDate, "dd/MM/yyyy");
}

long start = srcStartDate.getTime();
long end = srcEndDate.getTime();
long lama = (end-start)/(24*60*60*1000) ; 


%>

<%!
public static double getCountlog(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT(log_id) FROM logs ";
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
                        
                        

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			double count = 0;
			while(rs.next()) { count = rs.getDouble(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}

%>
<%

            if (session.getValue("PURCHASE_TITTLE") != null) {
                session.removeValue("PURCHASE_TITTLE");
            }

            if (session.getValue("PURCHASE_DETAIL") != null) {
                session.removeValue("PURCHASE_DETAIL");
            }

            
            
            
            
           

%>	

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
             
    function cmdSearch(){
	
        document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
	document.frmadjusment.action="sinkrondata.jsp";
	document.frmadjusment.submit();
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
                  <%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table border="1">       
                
                <tr>
                     <td width="6%">Location</td>
                     
                    <td width="38%"> 
                                                  <select name="src_location_id">
                                                    <%
														//if(srcLocationId==0){
														//	rptKonstan.setLocation("- All -");
														//}
													%>
                                                    <option value="0" >All </option>
                                                    
                                                    <%
													Vector locations = DbLocation.list(0,0, "", "name");
												    if(locations!=null && locations.size()>0){
														 for(int i=0; i<locations.size(); i++){
															Location d = (Location)locations.get(i);
															
															if(srcLocationId==d.getOID()){
																//rptKonstan.setLocation(d.getName());
															}
													%>
                                                    <option value="<%=d.getOID()%>" <%if(srcLocationId==d.getOID()){%>selected<%}%>><%=d.getName()%></option>
                                                    <%}}%>
                                                  </select>
                    
                </tr>
                
                 <iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="<%=approot%>/calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
                </iframe>   
                 <tr> 
                                                    <td  width="6%">Periode</td>
                                                    <td colspan="2" width="38%"> 
                                                      <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate==null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" >
                                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                      &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                      <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate==null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" >
                                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  </td>
                 </tr>
                 <tr>
                     <td width="6%"><a href="javascript:cmdSearch()">Search</a></td>
                 </tr>
             </table>
                 <%if(iJSPCommand==JSPCommand.FIRST){%>
                 <tr>
                     <td>
                         <table border="1">
                             <tr>
                                 
                                 <td bgcolor="yellow" height="50" width="10%" align="center" > LOCATION</td>
                                
                                    
                                    <td bgcolor="yellow" align="center" height="50">item master</td>
                                    <td bgcolor="yellow" align="center" height="50">harga</td>
                                    <td bgcolor="yellow" align="center" height="50">user</td>
                                    <td bgcolor="yellow" align="center" height="50">customer</td>
                                    
                               
                             </tr>
                             <%
                             Vector vloc= new Vector();
                             Location loc = new Location();
                             if(srcLocationId==0){
                                vloc= DbLocation.list(0, 0, "type='Store'", "");
                             }else{
                                 try{
                                    loc = DbLocation.fetchExc(srcLocationId);
                                 }catch(Exception ex){
                                     
                                 }
                                 
                             }
                            if(vloc.size()>0){
                             for(int i=0;i<vloc.size();i++){
                                 if(vloc.size()>0){
                                    loc= (Location) vloc.get(i);
                                 }
                                     
                                  
                             %>
                             <tr>
                                 <%
                                 double itemMaster=0;
                                 double harga=0;
                                 double user1=0;
                                 double customer=0;
                                 
                                 %>
                                 <td width="10%" ><%=loc.getName()%></td>
                                 <% String statusloc ="";%>
                                <% if(loc.getOID()== Long.valueOf("504404496872121833")){// COCO EXPRESS tanah lot
                                     statusloc="sts_loc2";
                                 }else if(loc.getOID()== Long.valueOf("504404503966365524")){//kediri
                                     statusloc="sts_loc3";
                                 }else if(loc.getOID()== Long.valueOf("504404509309495249")){//blok B
                                     statusloc="sts_loc8";
                                 }else if(loc.getOID()== Long.valueOf("504404509309721581")){//blok C
                                     statusloc="sts_loc7";
                                 }else if(loc.getOID()== Long.valueOf("504404509309798707")){//mengiat
                                     statusloc="sts_loc6";
                                 }else if(loc.getOID()== Long.valueOf("504404509310053214")){//maingate
                                     statusloc="sts_loc4";
                                 }else if(loc.getOID()== Long.valueOf("504404509310147532")){//kuta square
                                     statusloc="sts_loc11";
                                 }else if(loc.getOID()== Long.valueOf("504404509310234780")){//popies 1
                                     statusloc="sts_loc9";
                                 }else if(loc.getOID()== Long.valueOf("504404509310296230")){//popies 2
                                     statusloc="sts_loc10";
                                 }else if(loc.getOID()== Long.valueOf("504404509565141406")){//benesari
                                     statusloc="sts_loc12";
                                 }else if(loc.getOID()== Long.valueOf("504404512503801023")){//beackwalk
                                     statusloc="sts_loc5";
                                 }else if(loc.getOID()== Long.valueOf("504404513115220850")){//sanur
                                     statusloc="sts_loc13";
                                 }else if(loc.getOID()== Long.valueOf("504404519433365934")){//semawang
                                     statusloc="sts_loc14";
                                 }else if(loc.getOID()== Long.valueOf("504404522961557965")){//kasih ibu
                                     statusloc="sts_loc18";
                                 }else if(loc.getOID()== Long.valueOf("504404524951834846")){//lpd
                                     statusloc="sts_loc19";
                                 }else if(loc.getOID()== Long.valueOf("504404504052494548")){//gudang dc3
                                     statusloc="sts_loc1";
                                 }else if(loc.getOID()== Long.valueOf("504404490060662833")){// BPS setiabudi
                                     statusloc="sts_loc1";
                                 }else if(loc.getOID()== Long.valueOf("504404494892878221")){//sanur
                                     statusloc="sts_loc2";
                                 }else if(loc.getOID()== Long.valueOf("504404494892697258")){//renon
                                     statusloc="sts_loc3";
                                 }else if(loc.getOID()== Long.valueOf("504404494893303121")){//seminyak
                                     statusloc="sts_loc4";
                                 }else if(loc.getOID()== Long.valueOf("504404494893955176")){//dalung
                                     statusloc="sts_loc5";
                                 }else if(loc.getOID()== Long.valueOf("504404494894363567")){//teuku umar
                                     statusloc="sts_loc6";
                                 }else if(loc.getOID()== Long.valueOf("504404494893156970")){//tiara
                                     statusloc="sts_loc7";
                                 }else if(loc.getOID()== Long.valueOf("504404490060792161")){//kuta 
                                     statusloc="sts_loc8";
                                 }else if(loc.getOID()== Long.valueOf("504404490060709145")){//sesetan
                                     statusloc="sts_loc9";
                                 }else if(loc.getOID()== Long.valueOf("504404494893646811")){//gatsu
                                     statusloc="sts_loc10";
                                 }else if(loc.getOID()== Long.valueOf("504404494895508576")){//ubud
                                     statusloc="sts_loc11";
                                 }else if(loc.getOID()== Long.valueOf("504404494894907098")){//beackwalk
                                     statusloc="sts_loc12";
                                 }else if(loc.getOID()== Long.valueOf("504404494893444675")){//sanur
                                     statusloc="sts_loc13";
                                 }else if(loc.getOID()== Long.valueOf("504404536627481576")){//cocojimbaran
                                     statusloc="sts_loc21";
                                 }else if(loc.getOID()== Long.valueOf("504404538473308066")){//abd pemuteran
                                     statusloc="sts_loc1";
                                 }else if(loc.getOID()== Long.valueOf("504404539766159522")){//abd udayana
                                     statusloc="sts_loc6";
                                 }else if(loc.getOID()== Long.valueOf("504404539768604800")){//abd supply hotel
                                     statusloc="sts_loc2";
                                 }
                                 %>
                                 
                                    <% 
                                                                             
                                      itemMaster= getCountlog("table_name='pos_item_master' and " + statusloc + "=0 and to_days(date) between to_days('"+ JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')") ;                                        
                                       
                                       if(itemMaster > 0 ){
                                        %>
                                        <td bgcolor="red"><%=itemMaster%></td>
                                       <%}else{%>
                                        <td ><%=itemMaster%> </td>
                                       <%}%>
                                       
                                       <%
                                       harga= getCountlog("table_name='pos_price_type' and " + statusloc + "=0 and to_days(date) between to_days('"+ JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')") ;
                                       if(harga > 0 ){
                                        %>
                                        <td bgcolor="red"><%=harga%></td>
                                       <%}else{%>
                                        <td ><%=harga%> </td>
                                       <%}%>
                                       
                                       
                                       <%
                                       user1= getCountlog("table_name='sysuser' and " + statusloc + "=0 and to_days(date) between to_days('"+ JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')") ; 
                                       if(user1 > 0 ){
                                        %>
                                        <td bgcolor="red"><%=user1%></td>
                                       <%}else{%>
                                        <td ><%=user1%> </td>
                                       <%}%>
                                       
                                       
                                       <%
                                       customer= getCountlog("table_name='customer' and " + statusloc + "=0 and to_days(date) between to_days('"+ JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')") ;                                        
                                       if(customer > 0 ){
                                        %>
                                        <td bgcolor="red"><%=customer%></td>
                                       <%}else{%>
                                        <td ><%=customer%> </td>
                                       <%}%>
                                       

                                       
                                
                                
                             </tr>
                             <%}%>
                             

                             <%}else{%>
                                   <tr>
                                 <%
                                 double itemMaster=0;
                                 double harga=0;
                                 double user1=0;
                                 double customer=0;
                                 
                                 %>
                                 <td width="10%" ><%=loc.getName()%></td>
                                 <% String statusloc ="";%>
                                 <% if(loc.getOID()== Long.valueOf("504404496872121833")){//tanah lot
                                     statusloc="sts_loc2";
                                 }else if(loc.getOID()== Long.valueOf("504404503966365524")){//kediri
                                     statusloc="sts_loc3";
                                 }else if(loc.getOID()== Long.valueOf("504404509309495249")){//blok B
                                     statusloc="sts_loc8";
                                 }else if(loc.getOID()== Long.valueOf("504404509309721581")){//blok C
                                     statusloc="sts_loc7";
                                 }else if(loc.getOID()== Long.valueOf("504404509309798707")){//mengiat
                                     statusloc="sts_loc6";
                                 }else if(loc.getOID()== Long.valueOf("504404509310053214")){//maingate
                                     statusloc="sts_loc4";
                                 }else if(loc.getOID()== Long.valueOf("504404509310147532")){//kuta square
                                     statusloc="sts_loc11";
                                 }else if(loc.getOID()== Long.valueOf("504404509310234780")){//popies 1
                                     statusloc="sts_loc9";
                                 }else if(loc.getOID()== Long.valueOf("504404509310296230")){//popies 2
                                     statusloc="sts_loc10";
                                 }else if(loc.getOID()== Long.valueOf("504404509565141406")){//benesari
                                     statusloc="sts_loc12";
                                 }else if(loc.getOID()== Long.valueOf("504404512503801023")){//beackwalk
                                     statusloc="sts_loc5";
                                 }else if(loc.getOID()== Long.valueOf("504404513115220850")){//sanur
                                     statusloc="sts_loc13";
                                 }else if(loc.getOID()== Long.valueOf("504404519433365934")){//semawang
                                     statusloc="sts_loc14";
                                 }else if(loc.getOID()== Long.valueOf("504404522961557965")){//kasih ibu
                                     statusloc="sts_loc18";
                                 }else if(loc.getOID()== Long.valueOf("504404524951834846")){//lpd
                                     statusloc="sts_loc19";
                                 }else if(loc.getOID()== Long.valueOf("504404504052494548")){//gudang
                                     statusloc="sts_loc1";
                                 }else if(loc.getOID()== Long.valueOf("504404490060662833")){// BPS setiabudi
                                     statusloc="sts_loc1";
                                 }else if(loc.getOID()== Long.valueOf("504404494892878221")){//sanur
                                     statusloc="sts_loc2";
                                 }else if(loc.getOID()== Long.valueOf("504404494892697258")){//renon
                                     statusloc="sts_loc3";
                                 }else if(loc.getOID()== Long.valueOf("504404494893303121")){//seminyak
                                     statusloc="sts_loc4";
                                 }else if(loc.getOID()== Long.valueOf("504404494893955176")){//dalung
                                     statusloc="sts_loc5";
                                 }else if(loc.getOID()== Long.valueOf("504404494894363567")){//teuku umar
                                     statusloc="sts_loc6";
                                 }else if(loc.getOID()== Long.valueOf("504404494893156970")){//tiara
                                     statusloc="sts_loc7";
                                 }else if(loc.getOID()== Long.valueOf("504404490060792161")){//kuta 
                                     statusloc="sts_loc8";
                                 }else if(loc.getOID()== Long.valueOf("504404490060709145")){//sesetan
                                     statusloc="sts_loc9";
                                 }else if(loc.getOID()== Long.valueOf("504404494893646811")){//gatsu
                                     statusloc="sts_loc10";
                                 }else if(loc.getOID()== Long.valueOf("504404494895508576")){//ubud
                                     statusloc="sts_loc11";
                                 }else if(loc.getOID()== Long.valueOf("504404494894907098")){//beackwalk
                                     statusloc="sts_loc12";
                                 }else if(loc.getOID()== Long.valueOf("504404494893444675")){//sanur
                                     statusloc="sts_loc13";
                                 }else if(loc.getOID()== Long.valueOf("504404536627481576")){//coco jimbaran
                                     statusloc="sts_loc21";
                                 }else if(loc.getOID()== Long.valueOf("504404538473308066")){//abd pemuteran
                                     statusloc="sts_loc1";
                                 }else if(loc.getOID()== Long.valueOf("504404539766159522")){//abd udayana
                                     statusloc="sts_loc6";
                                 }else if(loc.getOID()== Long.valueOf("504404539768604800")){//abd supply hotel
                                     statusloc="sts_loc2";
                                 }
                                 
                                 %>
                                 
                                    <% 
                                        itemMaster= getCountlog("table_name='pos_item_master' and " + statusloc + "=0 and to_days(date) between to_days('"+ JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')") ;                                        
                                       
                                       if(itemMaster > 0 ){
                                        %>
                                        <td bgcolor="red"><%=itemMaster%></td>
                                       <%}else{%>
                                        <td ><%=itemMaster%> </td>
                                       <%}%>
                                       
                                       <%
                                       harga= getCountlog("table_name='pos_price_type' and " + statusloc + "=0 and to_days(date) between to_days('"+ JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')") ;                                       
                                       if(harga > 0 ){
                                        %>
                                        <td bgcolor="red"><%=harga%></td>
                                       <%}else{%>
                                        <td ><%=harga%> </td>
                                       <%}%>
                                       
                                       
                                       <%
                                       user1= getCountlog("table_name='sysuser' and " + statusloc + "=0 and to_days(date) between to_days('"+ JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')") ;                                      
                                       if(user1 > 0 ){
                                        %>
                                        <td bgcolor="red"><%=user1%></td>
                                       <%}else{%>
                                        <td ><%=user1%> </td>
                                       <%}%>
                                       
                                       
                                       <%
                                       customer= getCountlog("table_name='customer' and " + statusloc + "=0 and to_days(date) between to_days('"+ JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('"+JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd")+"')") ;                                      
                                       if(customer > 0 ){
                                        %>
                                        <td bgcolor="red"><%=customer%></td>
                                       <%}else{%>
                                        <td ><%=customer%> </td>
                                       <%}%>
                                       
                                       

                                       
                                
                                
                             </tr>

                             <%}%>
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
