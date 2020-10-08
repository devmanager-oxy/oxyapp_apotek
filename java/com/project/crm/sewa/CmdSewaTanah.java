package com.project.crm.sewa;

import com.project.crm.transaction.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class CmdSewaTanah extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;
	public static int RSLT_DATA_EXIST = 4;
        

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap",
                "Data kontrak sudah ada"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete",
                "Contract data already exist"}
	};

	private int start;
	private String msgString;
	private SewaTanah sewaTanah;
	private DbSewaTanah pstSewaTanah;
	private JspSewaTanah jspSewaTanah;
	int language = LANGUAGE_DEFAULT;

	public CmdSewaTanah(HttpServletRequest request){
		msgString = "";
		sewaTanah = new SewaTanah();
		try{
			pstSewaTanah = new DbSewaTanah(0);
		}catch(Exception e){;}
		jspSewaTanah = new JspSewaTanah(request, sewaTanah);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspSewaTanah.addError(jspSewaTanah.JSP_sewa_tanah_id, resultText[language][RSLT_EST_CODE_EXIST] );
				return resultText[language][RSLT_EST_CODE_EXIST];
			default:
				return resultText[language][RSLT_UNKNOWN_ERROR]; 
		}
	}

	private int getControlMsgId(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	public int getLanguage(){ return language; }

	public void setLanguage(int language){ this.language = language; }

	public SewaTanah getSewaTanah() { return sewaTanah; } 

	public JspSewaTanah getForm() { return jspSewaTanah; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidSewaTanah, Vector temp){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidSewaTanah != 0){
					try{
						sewaTanah = DbSewaTanah.fetchExc(oidSewaTanah);
					}catch(Exception exc){
					}
				}

				jspSewaTanah.requestEntityObject(sewaTanah);
                                                        
				if(jspSewaTanah.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(sewaTanah.getOID()==0){
					try{
						if(DbSewaTanah.isContractExist(this.sewaTanah)) {
                                                    msgString = resultText[language][RSLT_DATA_EXIST];
                                                    return RSLT_DATA_EXIST;
                                                } else {
                                                    long oid = pstSewaTanah.insertExc(this.sewaTanah);
                                                }
					}catch(CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
						return getControlMsgId(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
						return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
					}

				}else{
					try {
						long oid = pstSewaTanah.updateExc(this.sewaTanah);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidSewaTanah != 0) {
					try {
						sewaTanah = DbSewaTanah.fetchExc(oidSewaTanah);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidSewaTanah != 0) {
					try {
						sewaTanah = DbSewaTanah.fetchExc(oidSewaTanah);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidSewaTanah != 0){
					try{
						long oid = DbSewaTanah.deleteExc(oidSewaTanah);
						if(oid!=0){
							msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
							excCode = RSLT_OK;
						}else{
							msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCOMPLETE;
						}
					}catch(CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch(Exception exc){	
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;
				
			case JSPCommand.SUBMIT :
				
				if(oidSewaTanah != 0){
					try{
						sewaTanah = DbSewaTanah.fetchExc(oidSewaTanah);
					}catch(Exception exc){
					}
				}
				
				System.out.println("perubahan kontrak");

				jspSewaTanah.requestEntityObject(sewaTanah);

				if(jspSewaTanah.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
				
				System.out.println("perubahan kontrak 1");
				
				//inserting new kontrak
				sewaTanah.setOID(0);
				sewaTanah.setRefId(oidSewaTanah);
				long oid = 0;
				try{
					oid = pstSewaTanah.insertExc(this.sewaTanah);
				}catch(CONException dbexc){
					excCode = dbexc.getErrorCode();
					msgString = getSystemMessage(excCode);
					return getControlMsgId(excCode);
				}catch (Exception exc){
					msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
				}
				
				System.out.println("perubahan kontrak oid = "+oid);
				
				if(oid!=0){
					
					if(temp!=null && temp.size()>0){
						int copyKomin = Integer.parseInt((String)temp.get(0));
						int copyKompres = Integer.parseInt((String)temp.get(1));	
						int copyAssesment = Integer.parseInt((String)temp.get(2));	
						int copyInvoice = Integer.parseInt((String)temp.get(3));			
						int copyBPP = Integer.parseInt((String)temp.get(4));
						
						System.out.println("perubahan kontrak copyKomin : "+copyKomin+", copyKompres : "+copyKompres+", copyAssesment : "+copyAssesment+", copyInvoice : "+copyInvoice+", copyBPP : "+copyBPP);
						
						Vector tempx = new Vector();
						
						System.out.println("start komin");
						
						//kompensasi minimum
						if(copyKomin==1){
							tempx = DbSewaTanahKomin.list(0,0, DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_SEWA_TANAH_ID]+"="+oidSewaTanah, "");
							if(tempx!=null && tempx.size()>0){
								for(int i=0; i<tempx.size(); i++){
									SewaTanahKomin stk = (SewaTanahKomin)tempx.get(i);
									stk.setOID(0);
									stk.setSewaTanahId(oid);
									try{
										DbSewaTanahKomin.insertExc(stk);
									}
									catch(Exception e){
										
									}
								}
							}
						}
						
						System.out.println("start kompres");
							
						//kompensasi percen
						if(copyKompres==1){
							tempx = DbSewaTanahKomper.list(0,0, DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_SEWA_TANAH_ID]+"="+oidSewaTanah, "");
							if(tempx!=null && tempx.size()>0){
								for(int i=0; i<tempx.size(); i++){
									SewaTanahKomper stk = (SewaTanahKomper)tempx.get(i);
									stk.setOID(0);
									stk.setSewaTanahId(oid);
									try{
										DbSewaTanahKomper.insertExc(stk);
									}
									catch(Exception e){
										
									}
								}
							}
						}
						
						//assesment
						if(copyAssesment==1){
							tempx = DbSewaTanahAssesment.list(0,0, DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_SEWA_TANAH_ID]+"="+oidSewaTanah, "");
							if(tempx!=null && tempx.size()>0){
								for(int i=0; i<tempx.size(); i++){
									SewaTanahAssesment stk = (SewaTanahAssesment)tempx.get(i);
									stk.setOID(0);
									stk.setSewaTanahId(oid);
									try{
										DbSewaTanahAssesment.insertExc(stk);
									}
									catch(Exception e){
										
									}
								}
							}
						}
						
						//bppembantu
						if(copyBPP==1){
							tempx = DbSewaTanahBp.list(0,0, DbSewaTanahBp.colNames[DbSewaTanahBp.COL_SEWA_TANAH_ID]+"="+oidSewaTanah, "");
							if(tempx!=null && tempx.size()>0){
								for(int i=0; i<tempx.size(); i++){
									SewaTanahBp stk = (SewaTanahBp)tempx.get(i);
									stk.setOID(0);
									stk.setSewaTanahId(oid);
									try{
										DbSewaTanahBp.insertExc(stk);
									}
									catch(Exception e){
										
									}
								}
							}
						}
						
						//invoice
						if(copyInvoice==1){
							tempx = DbSewaTanahInvoice.list(0,0, DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_ID]+"="+oidSewaTanah, "");
							if(tempx!=null && tempx.size()>0){
								for(int i=0; i<tempx.size(); i++){
									SewaTanahInvoice stk = (SewaTanahInvoice)tempx.get(i);
									
									//income
									Vector tempincome = DbSewaTanahIncome.list(0,0, DbSewaTanahIncome.colNames[DbSewaTanahIncome.COL_SEWA_TANAH_INVOICE_ID]+"="+stk.getOID(), "");
									Vector tempdenda = DbDenda.list(0,0, DbDenda.colNames[DbDenda.COL_SEWA_TANAH_INVOICE_ID]+"="+stk.getOID(), "");
									//Vector tempbayar = DbPembayaran.list(0,0, DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+"="+stk.getOID(), "");
									
									stk.setOID(0);
									stk.setSewaTanahId(oid);
									try{
										long oidInv = DbSewaTanahInvoice.insertExc(stk);
										
										if(tempincome!=null && tempincome.size()>0){
											for(int x=0; x<tempincome.size(); x++){
												SewaTanahIncome sti = (SewaTanahIncome)tempincome.get(i);
												sti.setOID(0);
												sti.setSewaTanahInvoiceId(oidInv);
												try{
													DbSewaTanahIncome.insertExc(sti);
												}
												catch(Exception e){
													
												}
											}
										}
										
										if(tempdenda!=null && tempdenda.size()>0){
											for(int x=0; x<tempdenda.size(); x++){
												Denda dd = (Denda)tempdenda.get(i);
												dd.setOID(0);
												dd.setSewaTanahInvoiceId(oidInv);
												try{
													DbDenda.insertExc(dd);
												}
												catch(Exception e){
													
												}
											}
										}
									}
									catch(Exception e){
										
									}
									
								}
							}
							
							//upadate status
							if(oidSewaTanah != 0){
								try{
									SewaTanah sewaTanahx = DbSewaTanah.fetchExc(oidSewaTanah);
									sewaTanahx.setStatus(DbSewaTanah.STATUS_TIDAK_AKTIF);
									DbSewaTanah.updateExc(sewaTanahx);
								}catch(Exception exc){
								}
							}
							
						}
								
					}
				}

				
				break;	

			default :

		}
		return rsCode;
	}
}
