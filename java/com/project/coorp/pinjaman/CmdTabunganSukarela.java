package com.project.coorp.pinjaman;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.master.*;
import com.project.util.lang.*;
import com.project.fms.master.*;

public class CmdTabunganSukarela extends Control implements I_Language 
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
	private TabunganSukarela tabunganSukarela;
	private DbTabunganSukarela pstTabunganSukarela;
	private JspTabunganSukarela jspTabunganSukarela;
	int language = LANGUAGE_DEFAULT;

	public CmdTabunganSukarela(HttpServletRequest request){
		msgString = "";
		tabunganSukarela = new TabunganSukarela();
		try{
			pstTabunganSukarela = new DbTabunganSukarela(0);
		}catch(Exception e){;}
		jspTabunganSukarela = new JspTabunganSukarela(request, tabunganSukarela);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspTabunganSukarela.addError(jspTabunganSukarela.JSP_FIELD_tabungan_sukarela_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public TabunganSukarela getTabunganSukarela() { return tabunganSukarela; } 

	public JspTabunganSukarela getForm() { return jspTabunganSukarela; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidTabunganSukarela){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidTabunganSukarela != 0){
					try{
						tabunganSukarela = DbTabunganSukarela.fetchExc(oidTabunganSukarela);
					}catch(Exception exc){
					}
				}

				jspTabunganSukarela.requestEntityObject(tabunganSukarela);
                                
                                Periode per = DbPeriode.getOpenPeriod();
                                TabunganSukarela tb = DbTabunganSukarela.getLatestTransaction(tabunganSukarela.getMemberId());
                                
                                tabunganSukarela.setTransDate(new Date());
                                
                                if(tb.getOID()!=0){
                                    if(tb.getTransDate().after(tabunganSukarela.getTransDate())){                                
                                        jspTabunganSukarela.addError(jspTabunganSukarela.JSP_TRANS_DATE, "tanggal harus sesudah transaksi terakhir");
                                    }
                                }
                                
                                if(tabunganSukarela.getTransDate()!=null){
                                    if(tabunganSukarela.getTransDate().before(per.getStartDate()) 
                                    || tabunganSukarela.getTransDate().after(per.getEndDate())){
                                        jspTabunganSukarela.addError(jspTabunganSukarela.JSP_TRANS_DATE, "tanggal harus pada periode terbaru");
                                    }
                                }

				if(jspTabunganSukarela.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(tabunganSukarela.getOID()==0){
					try{
                                                
                                                tabunganSukarela.setCounter(tb.getCounter()+1);
                                                tabunganSukarela.setTanggal(new Date());                                                
                                                tabunganSukarela.setSortNum(DbTabunganSukarela.getNextSortNum());
                                                tabunganSukarela.setNumber(DbTabunganSukarela.getNextNumber(tabunganSukarela.getType(), tabunganSukarela.getSortNum()));
                                                
                                                switch(tabunganSukarela.getType()){
                                                    //SIMPANAN
                                                    case DbTabunganSukarela.TABUNGAN_TYPE_CREDIT : 
                                                        tabunganSukarela.setCredit(tabunganSukarela.getJumlah());
                                                        tabunganSukarela.setSaldo(tabunganSukarela.getJumlah()+tb.getSaldo());
                                                        break;
                                                    //PENGAMBILAN    
                                                    case DbTabunganSukarela.TABUNGAN_TYPE_DEBET : 
                                                        tabunganSukarela.setDebet(tabunganSukarela.getJumlah());
                                                        tabunganSukarela.setSaldo(tb.getSaldo() - tabunganSukarela.getJumlah());
                                                        break;
                                                    case DbTabunganSukarela.TABUNGAN_TYPE_BUNGA : 
                                                        tabunganSukarela.setCredit(tabunganSukarela.getJumlah());
                                                        tabunganSukarela.setSaldo(tabunganSukarela.getJumlah()+tb.getSaldo());
                                                        break;
                                                    case DbTabunganSukarela.TABUNGAN_TYPE_ADMIN : 
                                                        tabunganSukarela.setDebet(tabunganSukarela.getJumlah());
                                                        tabunganSukarela.setSaldo(tb.getSaldo() - tabunganSukarela.getJumlah());
                                                        break;
                                                    case DbTabunganSukarela.TABUNGAN_TYPE_PAJAK : 
                                                        tabunganSukarela.setDebet(tabunganSukarela.getJumlah());
                                                        tabunganSukarela.setSaldo(tb.getSaldo() - tabunganSukarela.getJumlah());
                                                        break;    
                                                }
                                                
                                                //Periode per = DbPeriode.getOpenPeriod();
                                                tabunganSukarela.setPeriodId(per.getOID());
                                                
						long oid = pstTabunganSukarela.insertExc(this.tabunganSukarela);
                                                
                                                if(oid!=0){
                                                    DbTabunganSukarela.postJournal(tabunganSukarela);
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
						long oid = pstTabunganSukarela.updateExc(this.tabunganSukarela);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidTabunganSukarela != 0) {
					try {
						tabunganSukarela = DbTabunganSukarela.fetchExc(oidTabunganSukarela);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidTabunganSukarela != 0) {
					try {
						tabunganSukarela = DbTabunganSukarela.fetchExc(oidTabunganSukarela);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidTabunganSukarela != 0){
					try{
						long oid = DbTabunganSukarela.deleteExc(oidTabunganSukarela);
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
