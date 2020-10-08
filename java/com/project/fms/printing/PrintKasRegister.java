package com.project.fms.printing;

import com.project.I_Project;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.session.SessReport;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.GlDetail;
import com.project.printman.OXY_PrintObj;
import com.project.printman.OXY_PrinterService;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;

public class PrintKasRegister {
	
	static int rowx = 0;
	static int startHeaderRowx = 0;
	static int endHeaderRowx = 0;
	
	public OXY_PrintObj PrintKR(long accLinkId , Date dtView){
		
		OXY_PrintObj obj = new OXY_PrintObj();
		try{
			rowx = 0; //set Row di index 0
			if (obj == null) {
			    obj = new OXY_PrintObj();
			}
			
			OXY_PrinterService prnSvc = OXY_PrinterService.getInstance();
			obj.setObjDescription(" ******** KAS REGISTER ******** ");
			obj.setPageLength(60);
            obj.setTopMargin(1);
            obj.setLeftMargin(0);
            obj.setRightMargin(0);
			obj.setSkipLineIsPaperFix(3);
            obj.setCpiIndex(obj.PRINTER_12_CPI); // 12 CPI = 96 char /line, 12 CPI = 163 char /line
			
			// header    
			obj = (OXY_PrintObj)headerKasRegister(obj);
			
			obj	= (OXY_PrintObj)mainKasRegister(obj,accLinkId,dtView);
				
			for(int k=0;k<14;k++){
				obj.setHeader(k);
			}
				
			obj	= (OXY_PrintObj)footerBKK(obj,accLinkId);

			// setting header
			//System.out.println("startHeaderRowx : "+startHeaderRowx);
			//System.out.println("endHeaderRowx : "+endHeaderRowx);
			//obj.setHeader(startHeaderRowx,endHeaderRowx);
				
			// start untuk printing
		/*	System.out.println("Start Printing");
			prnSvc.print(obj);
			prnSvc.running = true;
			prnSvc.run();*/
			
		}catch(Exception exc){
				System.out.println("CETAK DATA SUMMARY : ");
			}
			
			return obj;
	}	
		
		
	/**
	 * proses pembuatan header untuk bkk
	 * 
	 */	
	public OXY_PrintObj headerKasRegister(OXY_PrintObj obj){
		try{

            int[] cola = {62, 38};   // 2 coloum
            obj.newColumn(2, "", cola);
            
            // proses pencarian nama company
            String company = "";
            String address = "";
            String header = "";
            try {
                Vector vCompany = DbCompany.list(0, 0, "", null);
                if (vCompany != null && vCompany.size() > 0) {
                    Company com = (Company) vCompany.get(0);
                    company = com.getName();
                    address = com.getAddress();
                }
            } catch (Exception e) { System.out.println("[exc] " + e.toString()); }
            try {
                header = DbSystemProperty.getValueByName("HEADER_BKK");
            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }
            
            
			obj.setColumnValue(0, rowx, ""+company, obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			rowx++;
			
			obj.setColumnValue(0, rowx, "-------------------------------------------", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			rowx++;
			
			obj.setColumnValue(0, rowx, ""+header, obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			rowx++;
			
			obj.setColumnValue(0, rowx, ""+address, obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			rowx++;
			
			obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			rowx++;
			
		}catch(Exception exc){}
		
		return obj;
	}
	
	public OXY_PrintObj mainKasRegister(OXY_PrintObj obj, long accLinkId, Date dtView){
		try{
            int[] cola = {4, 92, 4};   // 4 coloum
            obj.newColumn(3, "", cola);
			
			startHeaderRowx = rowx;
				
			obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "LAPORAN HARIAN KAS", obj.TEXT_CENTER);
			obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
			rowx++;

            int[] colaa = {4, 46,46, 4};   // 4 coloum 
            obj.newColumn(4, "", colaa);

			obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "Tanggal", obj.TEXT_RIGHT);
			obj.setColumnValue(2, rowx, ": "+JSPFormater.formatDate(dtView, "dd/MM/yyyy"), obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
			rowx++;

            // start code
            String whereAccLink = DbCoa.colNames[DbCoa.COL_COA_ID] + " = " + accLinkId;
            Vector vAccLinks = DbCoa.list(0, 0, whereAccLink, null);
			
			String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
			
	        for (int i = 0; i < vAccLinks.size(); i++){
	            Coa coa = (Coa)vAccLinks.get(i);
	            boolean isDebetPosition = false;
	            
	            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
	                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
	                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
	                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
	                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
	                    coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
	                    	
	                	isDebetPosition = true;
	            	}			
				
				obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
				obj.setColumnValue(1, rowx, "Perkiraan", obj.TEXT_RIGHT);
				obj.setColumnValue(2, rowx, ": "+coa.getCode(), obj.TEXT_LEFT);
				obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
				rowx++;
				
				// get detail
				detailKasRegister(obj,coa, isDebetPosition, idr, dtView);
	        }
			
		}catch(Exception exc){
				System.out.println("Err>> mainBKK : "+exc.toString());
			}
		return obj;
	}

	public OXY_PrintObj detailKasRegister(OXY_PrintObj obj, Coa coa, boolean isDebetPosition, 
		String currency, Date dtView){
			
		try{
            int[] cola = {1, 18, 1, 10, 1, 15, 1, 25, 1, 30, 1, 15, 1};   // 9 coloum
            obj.newColumn(13, "", cola);
			
			obj.setColumnValue(0, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "==================", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "==========", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "================", obj.TEXT_LEFT);
			obj.setColumnValue(6, rowx, "=",obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "=========================", obj.TEXT_LEFT);
			obj.setColumnValue(8, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, "=============================", obj.TEXT_LEFT);
			obj.setColumnValue(10, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, "===============", obj.TEXT_LEFT);
			obj.setColumnValue(12, rowx, "=", obj.TEXT_LEFT);
			
			rowx++;
			
			obj.setColumnValue(0, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "DITERIMA", obj.TEXT_CENTER);
			obj.setColumnValue(6, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(8, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, "JUMLAH (RP)", obj.TEXT_CENTER);
			obj.setColumnValue(10, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, "", obj.TEXT_CENTER);
			obj.setColumnValue(12, rowx, "|", obj.TEXT_LEFT);

			rowx++; 
			
			obj.setColumnValue(0, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "NO. BKK/BKM", obj.TEXT_CENTER);
			obj.setColumnValue(2, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "NO CEK/GB", obj.TEXT_CENTER);
			obj.setColumnValue(4, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "DARI/BAYAR", obj.TEXT_CENTER);
			obj.setColumnValue(6, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "URAIAN", obj.TEXT_CENTER);
			obj.setColumnValue(8, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, "------------------------------", obj.TEXT_LEFT);
			obj.setColumnValue(10, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, "SALDO", obj.TEXT_CENTER);
			obj.setColumnValue(12, rowx, "|", obj.TEXT_LEFT);

			rowx++; 

            int[] colaa = {1, 18, 1, 10, 1, 15, 1, 25, 1, 15,1 ,15, 1, 15, 1};   // 9 coloum
            obj.newColumn(15, "", colaa);

			obj.setColumnValue(0, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "KEPADA", obj.TEXT_CENTER);
			obj.setColumnValue(6, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(8, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, "PENERIMAAN", obj.TEXT_CENTER);
			obj.setColumnValue(10, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, "PENGELUARAN", obj.TEXT_CENTER);			
			obj.setColumnValue(12, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(13, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(14, rowx, "|", obj.TEXT_LEFT);

			rowx++; 

			int[] colab = {1, 18, 1, 10, 1, 15, 1, 25, 1, 30, 1, 15, 1};   // 9 coloum
            obj.newColumn(13, "", colab);
            
			obj.setColumnValue(0, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "==================", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "==========", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "================", obj.TEXT_LEFT);
			obj.setColumnValue(6, rowx, "=",obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "=========================", obj.TEXT_LEFT);
			obj.setColumnValue(8, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, "=============================", obj.TEXT_LEFT);
			obj.setColumnValue(10, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, "===============", obj.TEXT_LEFT);
			obj.setColumnValue(12, rowx, "=", obj.TEXT_LEFT);
			  
			// end header
			endHeaderRowx = rowx;
			rowx++;
			
            int[] colac = {1, 18, 1, 10, 1, 15, 1, 25, 1, 15,1 ,15, 1, 15, 1};   // 9 coloum
            obj.newColumn(15, "", colac);

			double payment = 0;
			int loop = 0;
			int sisa = 0;
			int startN = 0;
			int startP = 0;
			String strName = "";
			String strPenjelasan = "";

			String noRek = "-";
			String nama = "-";
			String penjelasan = "";
			String strAmount = "";
			
			// start program kas register
			Vector temp = DbGlDetail.getGeneralLedger(dtView, coa.getOID());
			double openingBalance = 0;
			double totalCredit = 0;
			double totalDebet = 0;
			
			//jika bukan expense dan revenue
			// atau pencarian opening balance
			if (!(coa.getAccountGroup().equals("Expense") || coa.getAccountGroup().equals("Other Expense") ||
			        coa.getAccountGroup().equals("Revenue") || coa.getAccountGroup().equals("Other Revenue"))) {
			
			    openingBalance = DbGlDetail.getGLOpeningBalance(dtView, coa);
				
				// mulai opening
				obj.setColumnValue(0, rowx, "|", obj.TEXT_LEFT);
				obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
				obj.setColumnValue(2, rowx, "|", obj.TEXT_LEFT);
				obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
				obj.setColumnValue(4, rowx, "|", obj.TEXT_LEFT);
				obj.setColumnValue(5, rowx, "", obj.TEXT_CENTER);
				obj.setColumnValue(6, rowx, "|", obj.TEXT_LEFT);
				obj.setColumnValue(7, rowx, "Saldo Awal", obj.TEXT_LEFT);
				obj.setColumnValue(8, rowx, "|", obj.TEXT_LEFT);
				obj.setColumnValue(9, rowx, "-", obj.TEXT_RIGHT);
				obj.setColumnValue(10, rowx, "|", obj.TEXT_LEFT);
				obj.setColumnValue(11, rowx, "-", obj.TEXT_RIGHT);			
				obj.setColumnValue(12, rowx, "|", obj.TEXT_LEFT);
				obj.setColumnValue(13, rowx, JSPFormater.formatNumber(openingBalance, "#,###.##"), obj.TEXT_RIGHT);
				obj.setColumnValue(14, rowx, "|", obj.TEXT_LEFT);
				rowx++;
			}
			
			// start proses item looping
			if (temp != null && temp.size() > 0) {
				for (int x = 0; x < temp.size(); x++) {
				
				    Vector gld = (Vector) temp.get(x);
				    Gl gl = (Gl) gld.get(0);
				    GlDetail gd = (GlDetail) gld.get(1);
				
				    try {
				        gd = DbGlDetail.fetchExc(gd.getOID());
				    } catch (Exception e) {
				    }
				
				    if (isDebetPosition) {
				        openingBalance = openingBalance + (gd.getDebet() - gd.getCredit());
				    } else {
				        openingBalance = openingBalance + (gd.getCredit() - gd.getDebet());
				    }
				
				    totalDebet = totalDebet + gd.getDebet();
				    totalCredit = totalCredit + gd.getCredit();
				    //String nama = "";					
					//String penjelasan = "";
					
				    try {
				        nama = SessReport.getPemberiOrPenerima(gd.getGlId());
				        penjelasan = gl.getMemo()+" : "+gd.getMemo();
				    } catch (Exception e) {
				        System.out.println("[exception] " + e.toString());
				    }
				
					try{
						// proses pengecekan data lebih dengan max carakter
						loop = 0;
						sisa = 0;
						startN = 0;
						startP = 0;
						
						if(nama.length() > penjelasan.length()){
							loop = nama.length() / 15;  
							sisa = nama.length() % 15;  
						}else{
							loop = penjelasan.length() / 25;
							sisa = penjelasan.length() % 25;  
						}
						
						loop = loop + 1;
						strName = "";
						strPenjelasan = "";
						
						for(int j=0;j<loop;j++){
							if(j==(loop-1)){
								try{
									if(startN < nama.length()){
										if(nama.length()>0)
											strName = nama.substring(startN,nama.length());
										else
											strName = "";
											
										System.out.println("errrror 1"+j+" "+strName);
									}else{
										strName = "";
									}
								}catch(Exception e){
										strName = "";
									}
								
								try{
									if(startP < penjelasan.length()){
										if(penjelasan.length()>0)
											strPenjelasan = penjelasan.substring(startP,penjelasan.length());
										else
											strPenjelasan = "";
												
										System.out.println("errrror 2"+j+" "+strPenjelasan);
									}else{
										strPenjelasan = "";
									}
									
								}catch(Exception eb){
										strPenjelasan = "";
									}							
							}else{
								try{
									if(nama.length()>0)
										strName = nama.substring(startN,startN+15);
									else
										strName = "";	
									System.out.println("errrror 3"+j+" "+strName);
								}catch(Exception exx){
									strName = nama.substring(startN,nama.length());
								}
									
								try{
									if(penjelasan.length()>0)
										strPenjelasan = penjelasan.substring(startP,startP+25);
									else
										strPenjelasan = "";
										
									System.out.println("errrror 4"+j+" "+strPenjelasan);
								}catch(Exception exc){
									strPenjelasan = penjelasan.substring(startP,penjelasan.length());
								}								
							}
							
							startN = startN + 15;
							startP = startP + 25;
										
							// mulai opening
							obj.setColumnValue(0, rowx, "|", obj.TEXT_LEFT);
							if(j==0)
								obj.setColumnValue(1, rowx, ""+gl.getJournalNumber(), obj.TEXT_LEFT);
							else	
								obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
								
							obj.setColumnValue(2, rowx, "|", obj.TEXT_LEFT); 
							obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
							obj.setColumnValue(4, rowx, "|", obj.TEXT_LEFT);
							obj.setColumnValue(5, rowx, ""+strName, obj.TEXT_CENTER);
							obj.setColumnValue(6, rowx, "|", obj.TEXT_LEFT);
							obj.setColumnValue(7, rowx, ""+strPenjelasan, obj.TEXT_LEFT);
							obj.setColumnValue(8, rowx, "|", obj.TEXT_LEFT);
							if(j==0)
								obj.setColumnValue(9, rowx, ""+JSPFormater.formatNumber(gd.getDebet(), "#,###.##"), obj.TEXT_RIGHT);
							else
								obj.setColumnValue(9, rowx, "", obj.TEXT_RIGHT);
									
							obj.setColumnValue(10, rowx, "|", obj.TEXT_LEFT);
							if(j==0)
								obj.setColumnValue(11, rowx, ""+JSPFormater.formatNumber(gd.getCredit(), "#,###.##"), obj.TEXT_RIGHT);			
							else
								obj.setColumnValue(11, rowx, "", obj.TEXT_RIGHT);		
									
							obj.setColumnValue(12, rowx, "|", obj.TEXT_LEFT);
							if(j==0)
								obj.setColumnValue(13, rowx, JSPFormater.formatNumber(openingBalance, "#,###.##"), obj.TEXT_RIGHT);
							else
								obj.setColumnValue(13, rowx, "", obj.TEXT_RIGHT);
									
							obj.setColumnValue(14, rowx, "|", obj.TEXT_LEFT);
							 
							rowx++;
						}
					}catch(Exception xx){
						System.out.println("XX "+xx.toString());
					}
				}
			}

			int[] colad = {1, 18, 1, 10, 1, 15, 1, 25, 1, 30, 1, 15, 1};   // 9 coloum
            obj.newColumn(13, "", colad);
            
			obj.setColumnValue(0, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "==================", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "==========", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "================", obj.TEXT_LEFT);
			obj.setColumnValue(6, rowx, "=",obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "=========================", obj.TEXT_LEFT);
			obj.setColumnValue(8, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, "=============================", obj.TEXT_LEFT);
			obj.setColumnValue(10, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, "===============", obj.TEXT_LEFT);
			obj.setColumnValue(12, rowx, "=", obj.TEXT_LEFT);
			rowx++;
			
            int[] colae = {1, 18, 1, 10, 1, 15, 1, 25, 1, 15,1 ,15, 1, 15, 1};   // 9 coloum
            obj.newColumn(15, "", colae);

			// last footer
			obj.setColumnValue(0, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(6, rowx, "|",obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "TOTAL "+currency, obj.TEXT_RIGHT); // TOTAL
			obj.setColumnValue(8, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, ""+JSPFormater.formatNumber(totalDebet, "#,###.##"), obj.TEXT_RIGHT); // debet
			obj.setColumnValue(10, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, ""+JSPFormater.formatNumber(totalCredit, "#,###.##"), obj.TEXT_RIGHT); // kredit
			obj.setColumnValue(12, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(13, rowx, ""+JSPFormater.formatNumber(openingBalance, "#,###.##"), obj.TEXT_RIGHT); // saldo
			obj.setColumnValue(14, rowx, "|", obj.TEXT_LEFT);
			rowx++;
			
			int[] colaf = {1, 18, 1, 10, 1, 15, 1, 25, 1, 30, 1, 15, 1};   // 9 coloum
            obj.newColumn(13, "", colaf);
            
			obj.setColumnValue(0, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "==================", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "==========", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "================", obj.TEXT_LEFT);
			obj.setColumnValue(6, rowx, "=",obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "=========================", obj.TEXT_LEFT);
			obj.setColumnValue(8, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, "=============================", obj.TEXT_LEFT);
			obj.setColumnValue(10, rowx, "=", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, "===============", obj.TEXT_LEFT);
			obj.setColumnValue(12, rowx, "=", obj.TEXT_LEFT);
			
			
			rowx++;

			// last footer
			/*obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "-----", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "-", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "----------------------------------------", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "-", obj.TEXT_LEFT);
			obj.setColumnValue(6, rowx, "----------------------------------", obj.TEXT_LEFT);
			obj.setColumnValue(7, rowx, "-", obj.TEXT_LEFT);
			obj.setColumnValue(8, rowx, "----------------------------------", obj.TEXT_LEFT);
			obj.setColumnValue(9, rowx, "|", obj.TEXT_LEFT);
			obj.setColumnValue(10, rowx, "----------------------------------", obj.TEXT_LEFT);
			obj.setColumnValue(11, rowx, "|", obj.TEXT_LEFT);
			rowx++;*/
		}catch(Exception exc){}	
			
			return obj;
	}
	
	// footer dari list
	public OXY_PrintObj footerBKK(OXY_PrintObj obj, long pettyCashOID){
		try{
            int[] colb = {1,50,50,1};// 5 coloum
            obj.newColumn(4, "", colb);
            
			obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
			rowx++;

            obj.setColumnValue(0, rowx, "", obj.TEXT_CENTER);
            obj.setColumnValue(1, rowx, "Mengetahui,", obj.TEXT_CENTER);
			obj.setColumnValue(2, rowx, "Dibuat oleh,", obj.TEXT_CENTER);
			obj.setColumnValue(3, rowx, "", obj.TEXT_CENTER);
			
			rowx++;

						
			obj.setFooter(rowx);
			rowx++;
			
			obj.setColumnValue(0, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(1, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(2, rowx, "Dicetak Tanggal: "+JSPFormater.formatDate(new Date(), "dd/MM/yy"), obj.TEXT_LEFT);
			obj.setColumnValue(3, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(4, rowx, "", obj.TEXT_LEFT);
			obj.setColumnValue(5, rowx, "", obj.TEXT_LEFT);
			
			obj.setFooter(rowx);
			rowx++;
		}catch(Exception e){}
		
		return obj;
	}	
}
