<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%
int cmdPrint = JSPRequestValue.requestInt(request, "command_print"); int typeDoc = JSPRequestValue.requestInt(request, "type_document"); boolean typeDocDetailOnly = false;
// proses cetak data sesuai pilihan dokumen yang ada // 1. bkk // 2. bkm // 3. bkk kasbon // 4. bkm bank // 5. bkm sisa kasbon
if(docChoice==6){ typeDocDetailOnly = true; }
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
				obj = printBKK.PrintSummaryFormBKK(typeDoc, generalOID,30);			
			} catch (Exception exc3){ 
				System.out.println("Print Exc "+exc3);   
			}						 
			break;			
		case 2: // BKM
			PrintBKM printBKM = new PrintBKM();
			try{
				obj = printBKM.PrintSummaryFormBKM(typeDoc, generalOID, 30);			
			} catch (Exception exc3){
				System.out.println("Print Exc "+exc3);   
			}		
			break;			
		case 3: // BKK kasbon
			PrintBKKKasbon printBKKK = new PrintBKKKasbon();
			try{
				obj = printBKKK.PrintSummaryFormBKK(typeDoc, generalOID, 30);			
			} catch (Exception exc3){
				System.out.println("Print Exc "+exc3);   
			}		
			break;			
		case 4: // BKM Bank
			PrintBKMBank printBKKB = new PrintBKMBank();
			try{
				obj = printBKKB.PrintSummaryFormBKM(typeDoc, generalOID, 30);			
			} catch (Exception exc3){
				System.out.println("Print Exc "+exc3);   
			}		
			break;
		case 5: // BKM sisa kasbon
			printBKM = new PrintBKM();
			try{
				obj = printBKM.PrintSummaryFormBKM(typeDoc, generalOID,30);			
			} catch (Exception exc3){
				System.out.println("Print Exc "+exc3);   
			}		
			break;
                case 6: // Kas Register
			PrintKasRegister printKasRegister = new PrintKasRegister();
			try{
				obj = printKasRegister.PrintKR(generalOID,genDate);			
			} catch (Exception exc3){
				System.out.println("Print Exc "+exc3);   
			}		
			break;
               case 7: // BKK Bank
			PrintBKKBank printBKKBank = new PrintBKKBank();
			try{
				obj = printBKKBank.PrintSummaryFormBKK(typeDoc, generalOID,30);			
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
<input type="hidden" name="command_print" value="<%=cmdPrint%>">
<table border="0" cellspacing="0" cellpadding="0"><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td >&nbsp;Daftar printer :</td><td ><%
Vector hostLst = null; // proses pencarian printer
try{
         hostLst = RemotePrintMan.getHostList();
		if(hostLst!=null){
		   for(int h=0;h<hostLst.size();h++){
			PrinterHost host = (PrinterHost )hostLst.get(h);
			if(host!=null){ //out.println(""+h+")"+host.getHostName()+"<br>");
                        }
		   }
		}else{
			PrinterHost host = (PrinterHost)RemotePrintMan.getPrinterHostByIP("192.100.100.120");
			hostLst = new Vector();
			hostLst.add(host);
		}}catch(Exception exc){System.out.println("HostLst:  "+exc);}
%>
                                                                                                                    <select name="printeridx">
                                                                                                                      <%
        Vector prnLst = null;
        PrinterHost host = null;
        if(hostLst!=null){
            for(int h = 0; h< hostLst.size();h++){
                try{
                    host = (PrinterHost )hostLst.get(h);
                    if(host!=null){
                        prnLst = host.getListOfPrinters(false);//getPrinterListWithStatus(host);
                    }	
                    if(prnLst!=null){
                        for(int i = 0; i< prnLst.size();i++){
                            try{
                                PrnConfig prnConf= (PrnConfig) prnLst.get(i);
                                out.print(" <option value='"+ host.getHostIP()+";"+prnConf.getPrnIndex()+"'> ");
                                out.println(host.getHostName()+ " / " + prnConf.getPrnIndex()+ " "+prnConf.getPrnName()+" "+prnConf.getPrnPort());
                                out.print(" </option>");
                            } catch (Exception exc){out.println("ERROR "+ exc);}
                        }
                    }
                } catch (Exception exc1){out.println("ERROR" + exc1);}
            }
        }
        %>
                                                                                                                  </select></td><td ><label><select name="type_document"><%if(typeDocDetailOnly==false){%><option value="1">Summary</option><%}%><option value="2">Detail</option></select></label><label></label></td>
                                                                                                                  <td ><%													  
    out.print("<a href=\"javascript:cmdCetak(1)\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('dprit','','../images/print2.gif',1)\" ><img src=\"../images/print.gif\" name=\"dprit\" height=\"22\" border=\"0\"></a></div>");
                                                                                                                        %></td></tr></table>