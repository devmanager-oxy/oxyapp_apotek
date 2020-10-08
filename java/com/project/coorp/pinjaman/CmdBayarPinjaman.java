

package com.project.coorp.pinjaman;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class CmdBayarPinjaman extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private BayarPinjaman bayarPinjaman;
	private DbBayarPinjaman pstBayarPinjaman;
	private JspBayarPinjaman jspBayarPinjaman;
	int language = LANGUAGE_DEFAULT;

	public CmdBayarPinjaman(HttpServletRequest request){
		msgString = "";
		bayarPinjaman = new BayarPinjaman();
		try{
			pstBayarPinjaman = new DbBayarPinjaman(0);
		}catch(Exception e){;}
		jspBayarPinjaman = new JspBayarPinjaman(request, bayarPinjaman);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspBayarPinjaman.addError(jspBayarPinjaman.JSP_FIELD_bayar_pinjaman_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public BayarPinjaman getBayarPinjaman() { return bayarPinjaman; } 

	public JspBayarPinjaman getForm() { return jspBayarPinjaman; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidBayarPinjaman){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidBayarPinjaman != 0){
					try{
						bayarPinjaman = DbBayarPinjaman.fetchExc(oidBayarPinjaman);
					}catch(Exception exc){
					}
				}

				jspBayarPinjaman.requestEntityObject(bayarPinjaman);

				if(jspBayarPinjaman.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(bayarPinjaman.getOID()==0){
					try{
                                                int cnt = DbBayarPinjaman.getNextCounter(bayarPinjaman.getTypePinjaman());
                                                String prefix = DbBayarPinjaman.getNumberPrefix(bayarPinjaman.getTypePinjaman());
                                                String number = DbBayarPinjaman.getNextNumber(cnt, bayarPinjaman.getTypePinjaman());
                                                if(!number.equalsIgnoreCase(bayarPinjaman.getNoTransaksi())){
                                                    number = bayarPinjaman.getNoTransaksi();
                                                }
                                                
                                                bayarPinjaman.setCounter(cnt);
                                                bayarPinjaman.setPrefixNumber(prefix);
                                                bayarPinjaman.setNoTransaksi(number);
                                            
						long oid = pstBayarPinjaman.insertExc(this.bayarPinjaman);
                                                
                                                //update status pinjaman detail
                                                if(oid!=0){                                                    
                                                    PinjamanDetail pd = DbPinjamanDetail.fetchExc(bayarPinjaman.getPinjamanDetailId());
                                                    
                                                    Pinjaman p = new Pinjaman();
                                                    try{
                                                        p = DbPinjaman.fetchExc(pd.getPinjamanId());
                                                    }
                                                    catch(Exception e){
                                                    }
                                                    
                                                    boolean yupUpdate = false;
                                                    //lakukan update hanya untuk yang anuitas
                                                    if(p.getJenisCicilan()==DbPinjaman.JENIS_CICILAN_ANUITAS && pd.getAmount()!=bayarPinjaman.getAmount()){
                                                    
                                                        yupUpdate = true;
                                                        
                                                        //ambil prev detail
                                                        if(pd.getCicilanKe()>1){
                                                            Vector tmp = DbPinjamanDetail.list(0,0,DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]+"="+pd.getPinjamanId()+" and "+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_CICILAN_KE]+"="+(pd.getCicilanKe()-1), "");
                                                            if(tmp!=null && tmp.size()>0){
                                                                PinjamanDetail pdx = (PinjamanDetail)tmp.get(0);
                                                                pd.setSaldoKoperasi(pdx.getSaldoKoperasi()-bayarPinjaman.getAmount());
                                                                pd.setSaldoBank(pdx.getSaldoBank()-bayarPinjaman.getAmount());
                                                                pd.setAmount(bayarPinjaman.getAmount());
                                                                pd.setAmountBank(bayarPinjaman.getAmount());
                                                            }
                                                        }
                                                        else{
                                                            pd.setSaldoKoperasi(p.getTotalPinjaman()-bayarPinjaman.getAmount());
                                                            pd.setSaldoBank(p.getTotalPinjaman()-bayarPinjaman.getAmount());
                                                            pd.setAmount(bayarPinjaman.getAmount());
                                                            pd.setAmountBank(bayarPinjaman.getAmount());
                                                        }
                                                        
                                                        pd.setBunga(bayarPinjaman.getBunga());  
                                                        
                                                        pd.setTotalKoperasi(pd.getAmount()+pd.getBunga());
                                                        pd.setTotalBank(pd.getAmountBank()+pd.getBungaBank());
                                                        
                                                    }
                                                    
                                                    pd.setStatus(DbPinjaman.PAYMENT_STATUS_LUNAS);
                                                    DbPinjamanDetail.updateExc(pd);
                                                    
                                                    if(p.getJenisCicilan()==DbPinjaman.JENIS_CICILAN_ANUITAS && yupUpdate){
                                                        Vector tmp = DbPinjamanDetail.list(0,0,DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]+"="+pd.getPinjamanId()+" and "+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_CICILAN_KE]+"="+(pd.getCicilanKe()+1), "");
                                                        if(tmp!=null && tmp.size()>0){
                                                            PinjamanDetail pdx = (PinjamanDetail)tmp.get(0);
                                                            DbPinjamanDetail.updateDetailPinjamanAnuitas(pdx, pdx.getBungaKoperasiPercent()*12, pdx.getBungaBankPercent()*12);
                                                        }
                                                    }
                                                    
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
						long oid = pstBayarPinjaman.updateExc(this.bayarPinjaman);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidBayarPinjaman != 0) {
					try {
						bayarPinjaman = DbBayarPinjaman.fetchExc(oidBayarPinjaman);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidBayarPinjaman != 0) {
					try {
						bayarPinjaman = DbBayarPinjaman.fetchExc(oidBayarPinjaman);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidBayarPinjaman != 0){
					try{
						long oid = DbBayarPinjaman.deleteExc(oidBayarPinjaman);
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

			default :

		}
		return rsCode;
	}
}
