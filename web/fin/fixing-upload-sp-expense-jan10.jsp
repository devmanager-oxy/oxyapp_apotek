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

String strx =   

			"604401;5.2.1.1.2.06;BY TUNJ JAMSOSTEK KARY SP;117382;0|"+
			"604401;2.1.4.1.01;BY TUNJ JAMSOSTEK KARY SP;0;117382|"+
			
			"604402;3.1.5.1.02;KOR SIMP POKOK KT SUMARMA/550137-SKRL;25000;0|"+
			"604402;2.1.3.1.01;KOR SIMP POKOK KT SUMARMA/550137-SKRL;0;25000|"+
			
			"604403;2.1.5.1.01;PEMBY TTP JAMINAN MADE YANU SUSANTO;2431806;0|"+
			"604403;1.1.91.01;PEMBY TTP JAMINAN MADE YANU SUSANTO;0;2431806|"+
			
			"604404;5.2.1.1.2.07;BY AKRU THR KARY SP;301417;0|"+
			"604404;5.2.1.1.2.08;BY AKRU PAKSER KARY SP;50000;0|"+
			"604404;2.1.4.1.01;BY AKRU PAKSER KARY SP;0;351417|"+
			
			"604405;1.1.4.1.24;KOREKSI PIUT ANGGT MANDIRI JAN' 10;4180604;0|"+
			"604405;2.1.5.1.01;KOREKSI PIUT ANGGT MANDIRI JAN' 10;0;4180604|"+
			
			"604406;5.2.1.1.1.04;BY PENYS INV SIMPAN PINJAM;17578;0|"+
			"604406;1.2.2.1.01;BY PENYS INV SIMPAN PINJAM;0;17578|"+
			
			"604407;5.2.1.1.2.10;BY PAJAK 21 KARY SP;42288;0|"+
			"604407;2.1.4.1.01;BY PAJAK 21 KARY SP;0;42288|"+
			
			
			
			
			"604409;4.2.1.1.4.01;KOREKSI BUNGA PINJAMAN GS (DES' 09);960030;0|"+
			"604409;1.1.4.1.23;KOREKSI BUNGA PINJAMAN GS (DES' 09);0;960030|"+
			
			"604410;1.1.4.1.01;KOR PIUT DESAK MARTINI;534187;0|"+
			"604410;2.1.3.1.01;KOR PIUT DESAK MARTINI;0;534187|"+
			
			"604411;4.2.1.1.4.01;KOR BUNGA PINJ MANDIRI;926997;0|"+
			"604411;2.1.1.1.01;KOR BUNGA PINJ MANDIRI;0;926997|";



			

int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.SUBMIT){

	out.println("start --- processing fixing budget .. ");
	System.out.println("start --- processing fixing budget .. ");
	
	StringTokenizer strTok = new StringTokenizer(strx, "|");
	Vector temp = new Vector();
	while(strTok.hasMoreTokens()){
		temp.add((String)strTok.nextToken());
	}
	
	if(temp!=null && temp.size()>0){
		
		System.out.println("temp.size() |"+temp.size());
	
		for(int i=0; i<temp.size(); i++){
		
			String cr = (String)temp.get(i);
			StringTokenizer strTok1 = new StringTokenizer(cr, ";");
			
			Vector vct = new Vector();
			while(strTok1.hasMoreTokens()){
				vct.add((String)strTok1.nextToken());
			}
			
			if(vct!=null && vct.size()>0 && vct.size()==5){
				
				try{
					System.out.println("----> processing idx :|"+i+", |"+cr);
									
					long glId = Long.parseLong((String)vct.get(0));
					String strCode = (String)vct.get(1);
					String strNote = (String)vct.get(2);
					double debet = Double.parseDouble((String)vct.get(3));
					double credit = Double.parseDouble((String)vct.get(4));
					
					Coa coa = DbCoa.getCoaByCode(strCode);
					
					GlDetail glDetail = new GlDetail();
					glDetail.setBookedRate(1);
					glDetail.setCoaId(coa.getOID());
					glDetail.setCredit(credit);
					glDetail.setCustomerId(0);
					glDetail.setDebet(debet);
					glDetail.setDepartmentId(0);
					glDetail.setForeignCurrencyAmount(1);
					glDetail.setForeignCurrencyId(504404384818397770l);
					glDetail.setGlId(glId);
					//glDetail.setIsDebet();
					glDetail.setJobId(0);
					glDetail.setMemo(strNote);
					glDetail.setSectionId(0);
					glDetail.setStatusTransaction(1);
					glDetail.setSubSectionId(0);
					
					DbGlDetail.insertExc(glDetail);
					
				}
				catch(Exception e){
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
	document.form1.action="fixing-upload-sp-expense-jan10.jsp";
	document.form1.submit();
}

</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <p>
    <input type="hidden" name="command">
    <input type="button" name="Button" value="Upload Gl Jan 10" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

