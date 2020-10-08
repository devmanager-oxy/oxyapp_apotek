<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.project.main.db.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.fms.transaction.*"%>
<%@ page import="com.project.fms.master.*"%>
<%@ page import="com.project.main.db.*"%>
<%

String strx =   "4.1;2236826152.03636-"+
				"4.1.1;142320000-"+
				"4.1.1.1;58800000-"+
				"4.1.1.1.3;58800000-"+
				"4.1.1.1.3.01;58800000-"+
				"4.1.1.1.3.02;0-"+
				"4.1.1.1.4;0-"+
				"4.1.1.1.4.01;0-"+
				"4.1.1.2;83520000-"+
				"4.1.1.2.3;83520000-"+
				"4.1.1.2.3.01;83520000-"+
				"4.1.1.2.3.02;0-"+
				"4.1.1.2.4;0-"+
				"4.1.1.2.4.01;0-"+
				
				"4.1.2;2019506152.03636-"+
				"4.1.2.1;134400000-"+
				"4.1.2.1.3;134400000-"+
				"4.1.2.1.3.01;134400000-"+
				"4.1.2.2;153600000-"+
				"4.1.2.2.3;153600000-"+
				"4.1.2.2.3.01;153600000-"+
				"4.1.2.3;72960000-"+
				"4.1.2.3.3;72960000-"+
				"4.1.2.3.3.01;72960000-"+
				"4.1.2.4;96000000-"+
				"4.1.2.4.3;96000000-"+
				"4.1.2.4.3.01;96000000-"+
				"4.1.2.5;1094400000-"+
				"4.1.2.5.3;1094400000-"+
				"4.1.2.5.3.01;1094400000-"+
				"4.1.2.6;242880000-"+
				"4.1.2.6.3;242880000-"+
				"4.1.2.6.3.01;242880000-"+
				"4.1.2.7;39266152.0363636-"+
				"4.1.2.7.3;39266152.0363636-"+
				"4.1.2.7.3.01;39266152.0363636-"+
				"4.1.2.8;90000000-"+
				"4.1.2.8.3;90000000-"+
				"4.1.2.8.5.01;90000000-"+
				"4.1.2.9;96000000-"+
				"4.1.2.9.3;96000000-"+
				"4.1.2.9.3.01;96000000-"+
				"4.1.2.9.4;0-"+
				"4.1.2.9.4.01;0-"+
				
				"4.1.3;75000000-"+
				"4.1.3.1;75000000-"+
				"4.1.3.1.1;0-"+
				"4.1.3.1.1.01;0-"+
				"4.1.3.1.1.02;0-"+
				"4.1.3.1.3;75000000-"+
				"4.1.3.1.3.01;75000000-"+
				
				"4.2;21993160817.1818-"+
				"4.2.1;1500839497-"+
				"4.2.1.1;1500839497-"+
				"4.2.1.1.4;1500839497-"+
				"4.2.1.1.4.01;1500839497-"+
				
				"4.2.2;342124090.909091-"+
				"4.2.2.1;60000000-"+
				"4.2.2.1.4;60000000-"+
				"4.2.2.1.4.01;60000000-"+
				"4.2.2.2;82408090.9090909-"+
				"4.2.2.2.1;82408090.9090909-"+
				"4.2.2.2.1.02;82408090.9090909-"+
				"4.2.2.3;199716000-"+
				"4.2.2.3.1;199716000-"+
				"4.2.2.3.1.01;0-"+
				"4.2.2.3.1.02;199716000-"+
				"4.2.2.3.4;0-"+
				"4.2.2.3.4.01;0-"+
				
				"4.2.3;20150197229.2727-"+
				"4.2.3.1;19800000000-"+
				"4.2.3.1.1;19800000000-"+
				"4.2.3.1.1.01;0-"+
				"4.2.3.1.1.02;19800000000-"+
				"4.2.3.1.3;0-"+
				"4.2.3.1.3.01;0-"+
				"4.2.3.1.4;0-"+
				"4.2.3.1.4.01;0-"+
				"4.2.3.2;135600000-"+
				"4.2.3.2.1;135600000-"+
				"4.2.3.2.1.01;0-"+
				"4.2.3.2.1.02;135600000-"+
				"4.2.3.2.4;0-"+
				"4.2.3.2.4.01;0-"+
				
				"4.2.3.3;214597229.272727-"+
				"4.2.3.3.3;214597229.272727-"+
				"4.2.3.3.3.01;214597229.272727-"+
				
				"4.3;5607170564.868-"+
				"4.3.1;5607170564.868-"+
				"4.3.1.1;2007033984-"+
				"4.3.1.1.3;2007033984-"+
				"4.3.1.1.3.01;2007033984-"+
				"4.3.1.2;1702790844-"+
				"4.3.1.2.3;1702790844-"+
				"4.3.1.2.3.01;1702790844-"+
				"4.3.1.3;1455218988-"+
				"4.3.1.3.3;1455218988-"+
				"4.3.1.3.3.01;1455218988-"+
				"4.3.1.4;82457931.948-"+
				"4.3.1.4.3;82457931.948-"+
				"4.3.1.4.3.01;82457931.948-"+
				"4.3.1.5;359668816.92-"+
				"4.3.1.4.1;359668816.92-"+
				"4.3.1.5.1.01;359668816.92-"+
				
				"4.4;7534980321-"+
				"4.4.1;1865933136-"+
				"4.4.1.1;1865933136-"+
				"4.4.1.1.3;1865933136-"+
				"4.4.1.1.3.01;1865933136-"+
				"4.4.1.2;869047185-"+
				"4.4.1.2.1;170382900-"+
				"4.4.1.2.1.01;170382900-"+
				"4.4.1.2.1.02;0-"+
				"4.4.1.2.3;698664285-"+
				"4.4.1.2.3.01;698664285-"+
				"4.4.1.2.4;0-"+
				"4.4.1.2.4.01;0-"+
				"4.4.1.3;4800000000-"+
				"4.4.1.3.3;4800000000-"+
				"4.4.1.3.3.01;4800000000-"+
				
				"4.9;48000000-"+
				"4.9.0;48000000-"+
				"4.9.0.1;36000000-"+
				"4.9.0.2;0-"+
				"4.9.0.3;12000000-";





int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.SUBMIT){

	out.println("start --- processing fixing budget .. ");
	System.out.println("start --- processing fixing budget .. ");
	
	StringTokenizer strTok = new StringTokenizer(strx, "-");
	Vector temp = new Vector();
	while(strTok.hasMoreTokens()){
		temp.add((String)strTok.nextToken());
	}
	
	if(temp!=null && temp.size()>0){
		
		System.out.println("temp.size() "+temp.size());
	
		for(int i=0; i<temp.size(); i++){
		
			String cr = (String)temp.get(i);
			StringTokenizer strTok1 = new StringTokenizer(cr, ";");
			
			Vector vct = new Vector();
			while(strTok1.hasMoreTokens()){
				vct.add((String)strTok1.nextToken());
			}
			
			if(vct!=null && vct.size()>0 && vct.size()==2){
				System.out.println("----> processing idx :"+i+", "+cr);
				String coaCode = (String)vct.get(0);
				String amount = (String)vct.get(1);
				
				Coa coa = DbCoa.getCoaByCode(coaCode);
				if(coa.getOID()!=0 && coa.getStatus().equals("POSTABLE") && Double.parseDouble(amount)>0){
					try{
						CoaBudget cb = new CoaBudget();
						cb.setCoaId(coa.getOID());
						//cb.setCoaCode(coaCode);
						cb.setBgtYear(2010);
						cb.setAmount(Double.parseDouble(amount));
						cb.setPeriodeId(504404001);
						DbCoaBudget.insertExc(cb);
					}
					catch(Exception e){
					}
				}
				
			}
		}
	}
	
	out.println("end --- processing fixing data ..");
	System.out.println("end --- processing fixing data ..");
	
}



%>

<html>
<head>
<title>fixing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<script language="JavaScript">

function cmdFix(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="fixing-budget-income.jsp";
	document.form1.submit();
}

</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <p>
    <input type="hidden" name="command">
    <input type="button" name="Button" value="Fixing Budget Income 2010" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

