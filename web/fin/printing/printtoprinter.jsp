<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>

<%
long generalOID = Long.parseLong(request.getParameter("oid_general")); // JSPRequestValue.requestInt(request, "oid_general");
int cmdPrint = 1; // JSPRequestValue.requestInt(request, "command_print");
int docChoice = Integer.parseInt(request.getParameter("document_choice")); // JSPRequestValue.requestInt(request, "document_choice");

// proses cetak data sesuai pilihan dokumen yang ada
// 1. bkk
// 2. bkm

//out.println("cmdPrint >>>>> : "+cmdPrint);
docChoice = 1;
out.println("Testing");  
if(cmdPrint!=0){

	// proses request list printer
	String hostIpIdx ="";
	hostIpIdx = request.getParameter("printeridx");
	PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx,";");
	PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx,";");
	OXY_PrintObj obj = null;
	
	// pemilihan documen
	switch(docChoice){
		case 1: // BKK
			PrintBKK printBKK = new PrintBKK();
			try{
				System.out.println("Mulai create object");   
				obj = printBKK.PrintSummaryFormBKK(obj, generalOID);			
				System.out.println("End create object");   
			} catch (Exception exc3){ 
				System.out.println("Print Exc "+exc3);   
			}		
				 
			break;
			
		case 2: // BKM
			PrintBKM printBKM = new PrintBKM();
			try{
				obj = printBKM.PrintSummaryFormBKM(generalOID);			
			} catch (Exception exc3){
				System.out.println("Print Exc "+exc3);   
			}		
			break;
			
	}
	
	// proses printing di mulai jika printer ada
	if(hostIpIdx!=null){
		obj.setPrnIndex(prn.getPrnIndex());					
		RemotePrintMan.printObj(prnHost,obj); 
	}			
	cmdPrint = 0;
}

%>