

package com.project.fms.asset;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.stock.*;
import com.project.fms.master.*;

public class CmdAssetData extends Control implements I_Language 
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
	private AssetData assetData;
	private DbAssetData pstAssetData;
	private JspAssetData jspAssetData;
	int language = LANGUAGE_DEFAULT;

	public CmdAssetData(HttpServletRequest request){
		msgString = "";
		assetData = new AssetData();
		try{
			pstAssetData = new DbAssetData(0);
		}catch(Exception e){;}
		jspAssetData = new JspAssetData(request, assetData);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspAssetData.addError(jspAssetData.JSP_asset_data_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public AssetData getAssetData() { return assetData; } 

	public JspAssetData getForm() { return jspAssetData; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidAssetData, long stockId){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;

			case JSPCommand.SAVE :
				if(oidAssetData != 0){
					try{
						assetData = DbAssetData.fetchExc(oidAssetData);
					}catch(Exception exc){
					}
				}

				jspAssetData.requestEntityObject(assetData);
                                
                                Coa coa = new Coa();
                                try{
                                    coa = DbCoa.fetchExc(assetData.getCoaAkumDepId());
                                    if(coa.getStatus().equals("HEADER")){
                                        jspAssetData.addError(jspAssetData.JSP_COA_AKUM_DEP_ID, "non postable account");
                                    }
                                }
                                catch(Exception e){
                                    
                                }
                                
                                coa = new Coa();
                                try{
                                    coa = DbCoa.fetchExc(assetData.getCoaExpenseDepId());
                                    if(coa.getStatus().equals("HEADER")){
                                        jspAssetData.addError(jspAssetData.JSP_COA_EXPENSE_DEP_ID, "non postable account");
                                    }
                                }
                                catch(Exception e){
                                    
                                }

				if(jspAssetData.errorSize()>0 || stockId==0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                System.out.println("\n\n===> in cmd asset data -------------");
                                
                                ItemMaster im = new ItemMaster();
                                try{
                                    im = DbItemMaster.fetchExc(assetData.getItemMasterId());
                                    assetData.setItemGroupId(im.getItemGroupId());
                                    assetData.setItemCategoryId(im.getItemCategoryId());
                                    //assetData.setType(im.getType());                                         
                                }
                                catch(Exception e){
                                    System.out.println("000 - > "+e.toString());
                                }
                                
                                System.out.println("aaaa 123 -------------");

                                Stock stock = new Stock();
                                try{
                                    stock = DbStock.fetchExc(stockId);
                                    assetData.setAmountPerolehan(stock.getQty()*im.getCogs());
                                    //assetData.setTglPerolehan(stock.getDate());
                                    assetData.setLocationId(stock.getLocationId());
                                    assetData.setQty(stock.getQty());
                                }
                                catch(Exception e){
                                    System.out.println("111 - > "+e.toString());
                                }
                                
                                assetData.setYearlyDepresiasi(((assetData.getAmountPerolehan()-assetData.getResidu())*assetData.getDepresiasiPercent())/100);
                                assetData.setMthDepresiasi(assetData.getYearlyDepresiasi()/12);
                                assetData.setYearPerolehan(assetData.getTglPerolehan().getYear()+1900);
                                
                                System.out.println("xxxx 123 -------------");
                                
				if(assetData.getOID()==0){
					try{                                                
                                                System.out.println("insert ---- ");
                                                
                                                assetData.setDate(new Date());                                                  
						long oid = pstAssetData.insertExc(this.assetData);
                                                
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
                                                
                                                System.out.println("update ---- ");
                                                
						long oid = pstAssetData.updateExc(this.assetData);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case JSPCommand.EDIT :
				if (oidAssetData != 0) {
					try {
						assetData = DbAssetData.fetchExc(oidAssetData);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidAssetData != 0) {
					try {
						assetData = DbAssetData.fetchExc(oidAssetData);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.DELETE :
				if (oidAssetData != 0){
					try{
						long oid = DbAssetData.deleteExc(oidAssetData);
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
