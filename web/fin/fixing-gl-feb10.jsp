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

String strx =   "704402;1.1.2.1.01;TRM ANGS PINJ WAY SUDASTRA MANDIRI;79752;0|"+
				"704402;2.1.5.1.01;TRM ANGS PINJ WAY SUDASTRA MANDIRI;0;79752|"+
				
				
				"704403;1.1.2.1.01;TRM ANGS PINJ AN JOKO RANTAU;3354;0|"+
				"704403;2.1.5.1.01;TRM ANGS PINJ AN JOKO RANTAU;0;3354|"+
				
				
				"704404;1.1.2.1.01;TRM PENDPT POT GAJI DATEL, INFRATEL;0;985348|"+
				"704404;5.2.1.1.1.12;FEE KOPEGTEL GAJI DATEL, INFRATEL;985348;0|"+
				
				"704405;5.2.1.1.2.01;BYA GAJI KARY SP FEB\' 10;1424400;0|"+
				"704405;1.1.1.1.01;BYA GAJI KARY SP FEB\' 10;0;1424400|"+
				
				"704406;5.2.1.1.2.09;BY LEMBUR KARY SP;106627;0|"+
				"704406;1.1.1.1.01;BY LEMBUR KARY SP;0;106627|"+
				
				
				"704407;5.2.1.1.2.11;DANA PENSIUN KARY SP;100000;0|"+
				"704407;1.1.2.1.01;DANA PENSIUN KARY SP;0;100000|"+
				
				
				"704408;5.2.1.1.2.06;BYMHD JAMSOSTEK KARY SP;117328;0|"+
				"704408;1.1.2.1.01;BYMHD JAMSOSTEK KARY SP;0;117328|"+
				
				
				"704409;4.2.1.1.4.01;MTR PINJ AN SANG MD RENA/511120;0;6500|"+
				"704409;1.1.1.1.01;PEMBY PINJ AN SANG MD RENA/511120;6500;0|"+
				
				"704410;2.1.1.1.18;PEMBY HUTANG MANDIRI IB SUBIKSA BATC 2;52880298;0|"+
				"704410;1.1.2.1.01;PEMBY HUTANG MANDIRI IB SUBIKSA BATC 2;0;52880298|"+
				
				"704411;2.1.5.1.20;ASRNS PINJ AN WYN SURATA/550135;0;18750|"+
				"704411;4.2.1.1.4.01;METR PINJ AN WYN SURATA/550135;0;6500|"+
				"704411;1.1.1.1.01;PEMBY PINJ AN WYN SURATA/550135;25250;0|"+
				
				"704412;2.1.5.1.20;ASRS PINJ AN HABALONG/450215;0;37500|"+
				"704412;4.2.1.1.4.01;METR PINJ AN HABALONG/450215;0;6500|"+
				"704412;1.1.1.1.01;PEMBY PINJ AN HABALONG/450215;44000;0|"+
				
				"704413;2.1.4.1.01;BYMHD PPH PSL 21 KARY SP JAN\' 10;42288;0|"+
				"704413;1.1.2.1.01;BYMHD PPH PSL 21 KARY SP JAN\' 10;0;42288|"+
				
				"704414;4.2.1.1.4.01;METR PINJ AN JULIANA DIJAHUBESY/611866;0;6500|"+
				"704414;1.1.2.1.01;PEMBY PINJ AN JULIANA DIJAHUBESY/611866;6500;0|"+
				
				"704415;4.2.1.1.4.01;METR PINJ AN WYN SUSILA/671231;0;6500|"+
				"704415;1.1.2.1.01;PEMBY PINJ AN WYN SUSILA/671231;6500;0|"+
				
				"704416;2.1.5.1.20;ASRN PINJ AN MARIATI/430491;0;18750|"+
				"704416;4.2.1.1.4.01;METR PINJ AN MARIATI/430491;0;6500|"+
				"704416;1.1.1.1.01;PEMBY PINJ AN MARIATI/430491;25250;0|"+
				
				
				"704417;4.2.1.1.4.01;METR PINJ AN UCOK NOVRANDO SIBARANI;0;6500|"+
				"704417;1.1.2.1.01;PEMBY PINJ AN UCOK NOVRANDO SIBARANI;6500;0|"+
				
				"704418;5.2.1.1.1.14;BY MEMORY DDR I U IBU IDA/ SP;275000;0|"+
				"704418;1.1.1.1.01;BY MEMORY DDR I U IBU IDA/ SP;0;275000|"+
				
				
				"704419;4.2.1.1.4.01;METR PINJ AN I MADE WENDA/640027;0;6500|"+
				"704419;1.1.2.1.01;PEMBY PINJ AN I MADE WENDA/640027;6500;0|"+
				
				"704420;4.2.1.1.4.01;METR PINJ AN KT SANDIASIH/621559;0;6500|"+
				"704420;1.1.2.1.01;PEMBY PINJ AN KT SANDIASIH/621559;6500;0|"+
				
				"704421;4.2.1.1.4.01;METR PINJ AN PETRUS S/621036;0;6500|"+
				"704421;1.1.2.1.01;PEMBY PINJ AN PETRUS S/621036;6500;0|"+
				
				"704422;4.2.1.1.4.01;METR PINJ AN NYM SRI NURYADI/640026;0;6500|"+
				"704422;1.1.2.1.01;PEMBY PINJ AN NYM SRI NURYADI/640026;6500;0|"+
				
				"704423;4.2.1.1.4.01;METR PINJ AN NYM SUGIARTO/591939;0;6500|"+
				"704423;1.1.2.1.01;PEMBY PINJ AN NYM SUGIARTO/591939;6500;0|"+
				
				
				"704424;4.2.1.1.4.01;METR PINJ AN IB MD DARMIKA/SATPAM;0;6500|"+
				"704424;1.1.2.1.01;PEMBY PINJ AN IB MD DARMIKA/SATPAM;6500;0|"+
				
				
				"704425;4.2.1.1.4.01;METR PINJ AN SETYAJI NAWANDONO/730583;0;6500|"+
				"704425;1.1.2.1.01;PEMBY PINJ AN SETYAJI NAWANDONO/730583;6500;0|"+
				
				"704426;4.2.1.1.4.01;METR PINJ AN MASRI TAHER/440882;0;6500|"+
				"704426;2.1.5.1.20;ASRN PINJ AN MASRI TAHER/440882;0;37500|"+
				"704426;1.1.1.1.01;PEMBY PINJ AN MASRI TAHER/440882;44000;0|"+
				
				"704427;4.2.1.1.4.01;METR PINJ AN WYN RUDJA/450929;0;6500|"+
				"704427;2.1.5.1.20;ASRN PINJ AN WYN RUDJA/450929;0;18750|"+
				"704427;1.1.2.1.01;PEMBY PINJ AN WYN RUDJA/450929;25250;0|"+
				
				
				"704428;2.1.5.1.01;PENGB TTP JMN PINJ MANRI NGH SUTRIANI;2070886;0|"+
				"704428;1.1.1.1.01;PENGB TTP JMN PINJ MANRI NGH SUTRIANI;0;2070886|"+
				
				
				"704429;4.2.1.1.4.01;METR PINJ AN NGH SUTRIANI/630453 10X;0;6500|"+
				"704429;1.1.1.1.01;PEMBY PINJ AN NGH SUTRIANI/630453 10X;6500;0|"+
				
				"704430;4.2.1.1.4.01;METR PINJ AN BENYAMIN MENDES/680005;0;6500|"+
				"704430;1.1.2.1.01;PEMBY PINJ AN BENYAMIN MENDES/680005;6500;0|"+
				
				
				"704431;4.2.1.1.4.01;METR PINJ AN GST A. SRI ADNYANI/611482;0;6500|"+
				"704431;1.1.2.1.01;PEMBY PINJ AN GST A. SRI ADNYANI/611482;6500;0|"+
				
				"704432;2.1.1.1.18;ANGS PINJ BATCH I  FEB\' 10;8747142;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH I  FEB\' 10;4406233;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH I  FEB\' 10;0;13153375|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 3 FEB\' 10;5255583;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 3 FEB\' 10;3148059;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 3 FEB\' 10;0;8403642|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 4 FEB\' 10;5096532;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 4 FEB\' 10;1715521;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 4 FEB\' 10;0;6812053|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 5 FEB\' 10;10771135;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 5 FEB\' 10;6071729;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 5 FEB\' 10;0;16842864|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 6 FEB\' 10;8500326;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 6 FEB\' 10;5180310;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 6 FEB\' 10;0;13680636|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 7 FEB\' 10;4035117;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 7 FEB\' 10;2706066;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 7 FEB\' 10;0;6741183|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 8 FEB\' 10;5226852;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 8 FEB\' 10;3684888;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 8 FEB\' 10;0;8911740|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 9 FEB\' 10;6340184;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 9 FEB\' 10;4595894;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 9 FEB\' 10;0;10936078|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 10 FEB\' 10;4252382;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 10 FEB\' 10;3187555;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 10 FEB\' 10;0;7439937|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 11  FEB\' 10;3599486;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 11  FEB\' 10;3763977;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 11  FEB\' 10;0;7363463|"+
				"704432;2.1.1.1.18;ANGS PINJ BATCH 2 FEB\' 10;7238070;0|"+
				"704432;5.2.1.1.1.16;ANGS PINJ BATCH 2 FEB\' 10;3720294;0|"+
				"704432;1.1.2.1.01;ANGS PINJ BATCH 2 FEB\' 10;0;10958364|"+
				
				"704433;5.2.1.1.1.12;BY MATERAI DAN BANK;48000;0|"+
				"704433;1.1.2.1.01;BY MATERAI DAN BANK;0;48000|"+
				
				"704434;5.2.1.1.2.06;BY TUNJ JAMSOSTEK KARY SP FEB\' 10;128640;0|"+
				"704434;5.2.1.1.2.06;BY TUNJ JAMSOSTEK KARY SP FEB\' 10;0;128640|"+
				
				"704435;1.1.91.01;KOR SIMP WAJIB NYM TAMBIR/580547;720000;0|"+
				"704435;2.1.3.1.01;KOR SIMP WAJIB NYM TAMBIR/580547;0;720000|"+
				
				"704436;5.2.1.1.2.10;BY PPH PSL 21 KARY SP;42288;0|"+
				"704436;2.1.4.1.01;BY PPH PSL 21 KARY SP;0;42288|"+
				"704436;1.2.2.1.01;BY PENYUSU INV SIMPAN PINJAM;17578;0|"+
				"704436;1.2.2.1.01;BY PENYUSU INV SIMPAN PINJAM;0;17578|"+
				"704436;5.2.1.1.2.07;BY THR KARY SP;301417;0|"+
				"704436;5.2.1.1.2.08;BY PAKSER KARY SP;50000;0|"+
				"704436;2.1.4.1.01;BY PAKSER KARY SP DAN THR;0;351417|"+
				
				"704437;1.1.91.01;PENYERTAAN KAS NSP FEB\' 10;160000000;0|"+
				"704437;1.1.1.1.01;PENYERTAAN KAS NSP FEB\' 10;0;160000000|";



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
	document.form1.action="fixing-gl-feb10.jsp";
	document.form1.submit();
}

</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <p>
    <input type="hidden" name="command">
    <input type="button" name="Button" value="Upload Gl Feb 10 - SP" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

