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

int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.SUBMIT){

	out.println("start --- processing fixing data .. titipan, bymhd");
	System.out.println("start --- processing fixing data .. titipan, bymhd");
	
	Vector v = DbCashReceive.list(0,0, "", "");
	if(v!=null && v.size()>0){
		
		System.out.println("v.size() "+v.size());
	
		for(int i=0; i<v.size(); i++){
			CashReceive cr = (CashReceive)v.get(i);
			Vector temp = DbCashReceiveDetail.list(0,0,"cash_receive_id="+cr.getOID(), "");
			System.out.println("----> processing idx :"+i+", "+cr.getJournalNumber());
			if(temp!=null && temp.size()>0){
				for(int x=0; x<temp.size(); x++){
					CashReceiveDetail crd = (CashReceiveDetail)temp.get(x);
					try{
						if(crd.getCustomerId()==0){
							crd.setCustomerId(cr.getCustomerId());
							DbCashReceiveDetail.updateExc(crd);
							System.out.println("-------> success processing idx :"+i+", "+cr.getJournalNumber());
						}						
					}
					catch(Exception e){
						System.out.println("-------> "+e.toString());
					}
				
				}
			}
		}
	}
	
	out.println("end --- processing fixing data .. titipan, bymhd");
	System.out.println("end --- processing fixing data .. titipan, bymhd");
	
}

if(iCommand==JSPCommand.START){

	out.println("start --- processing fixing bymhd oid");
	System.out.println("start --- pprocessing fixing bymhd oid");
	
	Vector v = DbCashReceive.list(0,0, "type=4 or type=3", "");
	if(v!=null && v.size()>0){
		
		System.out.println("v.size() "+v.size());
	
		for(int i=0; i<v.size(); i++){
			CashReceive cr = (CashReceive)v.get(i);
			Vector temp = DbCashReceiveDetail.list(0,0,"cash_receive_id="+cr.getOID(), "");
			System.out.println("----> processing idx :"+i+", "+cr.getJournalNumber());
			if(temp!=null && temp.size()>0){
				for(int x=0; x<temp.size(); x++){
					CashReceiveDetail crd = (CashReceiveDetail)temp.get(x);
					try{
						//baru
						if(cr.getType()==4){
							crd.setBymhdCoaId(cr.getCoaId());
						}
						else{
							crd.setBymhdCoaId(crd.getCoaId());
						}
						//if(crd.getCustomerId()==0){
							//crd.setCustomerId(cr.getCustomerId());
							DbCashReceiveDetail.updateExc(crd);
							System.out.println("-------> success processing idx :"+i+", "+cr.getJournalNumber());
						//}						
					}
					catch(Exception e){
						System.out.println("-------> "+e.toString());
					}
				
				}
			}
		}
	}
	
	out.println("end --- processing fixing data .. titipan, bymhd");
	System.out.println("end --- processing fixing data .. titipan, bymhd");
	
}


if(iCommand==JSPCommand.SAVE){
	Vector gls = DbGl.list(0,0,"", "");
	for(int i=0; i<gls.size(); i++){
		Gl gl = (Gl)gls.get(i);
		Vector glx = DbGlDetail.list(0,0,"gl_id="+gl.getOID(), "");
		
		boolean found = false;
		int a = 0;
		for(int x=0; x<glx.size(); x++){
			GlDetail gd = (GlDetail)glx.get(x);
			Coa coa = new Coa();
			try{
				coa = DbCoa.fetchExc(gd.getCoaId());
				if(x==0){
					a = coa.getAccountClass();
				}
				else{
					if(a!=coa.getAccountClass()){
						found = true;	
					}
				}							
								
			}
			catch(Exception e){
			}				
		}
		
		if(found){
			out.println("<br>gl : "+gl.getOID()+", a : "+a);
		}
		
		found = false;
	}
}

if(iCommand==JSPCommand.POST){
	
	String sql = "select c.name, gd.* from gl_detail gd "+
				 "inner join coa c on c.coa_id = gd.coa_id where c.account_class=2  order by gl_id, debet desc";
				 
	CONResultSet crs = null;
	Vector v = new Vector();
	try{
		crs = CONHandler.execQueryResult(sql);
		ResultSet rs = crs.getResultSet();
		
		while(rs.next()){
			GlDetail gd = new GlDetail();
			DbGlDetail.resultToObject(rs, gd);
			v.add(gd);
		}
	}
	catch(Exception e){
	}
	finally{
		CONResultSet.close(crs);
	}
	
	if(v!=null && v.size()>0){
	
		double debet = 0;
		double credit = 0;
		long oidbefore = 0;
		for(int i=0; i<v.size(); i++){
			GlDetail gd = (GlDetail)v.get(i);
			if(i==0){
				oidbefore = gd.getGlId();
				debet = debet + gd.getDebet();
				credit = credit + gd.getCredit();				
			}
			else{
				if(oidbefore==gd.getGlId()){
					debet = debet + gd.getDebet();
					credit = credit + gd.getCredit();
				}
				else{
					if(debet!=credit){
						out.println("<br>gl : "+oidbefore+", debet : "+JSPFormater.formatNumber(debet,"#,###.##")+", credit : "+JSPFormater.formatNumber(credit,"#,###.##"));						
					}
					
					debet = gd.getDebet();
					credit = gd.getCredit();
					oidbefore = gd.getGlId();
					
				}
			}	
		}
		
		if(debet!=credit){
			out.println("<br>gl : "+oidbefore+", debet : "+JSPFormater.formatNumber(debet,"#,###.##")+", credit : "+JSPFormater.formatNumber(credit,"#,###.##"));						
		}
		
		
	}
	 
}

if(iCommand==JSPCommand.ASK){
	
	
	Vector v = DbGl.list(0,0, "date>'2009-10-30' and trans_date>'2009-10-30'", "");
	
	if(v!=null && v.size()>0){
	
		Date dt = new Date();
		dt.setDate(30);
		dt.setMonth(9);
		
		out.println("update to : "+dt);
		
		//dt.setYears(2009);
		for(int i=0; i<v.size(); i++){
			Gl gl = (Gl)v.get(i);
			
			gl.setDate(dt);		
			gl.setTransDate(dt);
			try{
				DbGl.updateExc(gl);
			}
			catch(Exception e){
			}
		}
		
		
	}
	
	out.println("end update date ...");
	 
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
	document.form1.action="fixing.jsp";
	document.form1.submit();
}

function cmdFixBymd(){
	document.form1.command.value="<%=JSPCommand.START%>";
	document.form1.action="fixing.jsp";
	document.form1.submit();
}

function cmdAbc(){
	document.form1.command.value="<%=JSPCommand.SAVE%>";
	document.form1.action="fixing.jsp";
	document.form1.submit();
}

function cmdCek1(){
	document.form1.command.value="<%=JSPCommand.POST%>";
	document.form1.action="fixing.jsp";
	document.form1.submit();
}

function cmdUpdatGl(){
	document.form1.command.value="<%=JSPCommand.ASK%>";
	document.form1.action="fixing.jsp";
	document.form1.submit();
}
</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <p>
    <input type="hidden" name="command">
    <input type="button" name="Button" value="Fixing Titipan dan  BYMHD" onClick="javascript:cmdFix()">
    <input type="button" name="Button" value="Fixing BYMHD ID" onClick="javascript:cmdFixBymd()">
    <br>
    <input type="button" name="Button" value="Check Aja" onClick="javascript:cmdAbc()">
    <input type="button" name="Button" value="Cek 2 SP" onCLick="javascript:cmdCek1()">
  </p>
  <p>
    <input type="button" name="Button" value="Update gl date to october 09" onClick="javascript:cmdUpdatGl()">
  </p>
</form>
</body>
</html>

