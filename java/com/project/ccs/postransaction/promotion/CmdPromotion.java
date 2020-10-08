
package com.project.ccs.postransaction.promotion;

import com.project.ccs.postransaction.promotion.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.system.DbSystemProperty;

public class CmdPromotion extends Control implements I_Language 
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
	private Promotion promotion;
	private DbPromotion pstCosting;
	private JspPromotion jspPromotion;
	int language = LANGUAGE_DEFAULT;

	public CmdPromotion(HttpServletRequest request){
		msgString = "";
		promotion = new Promotion();
		try{
			pstCosting = new DbPromotion(0);
		}catch(Exception e){;}
		jspPromotion = new JspPromotion(request, promotion);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_CONExceptionInfo.MULTIPLE_ID :
				//this.jspPromotion.addError(jspPromotion.JSP_FIELD_promotion_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public Promotion getPromotion() { return promotion; } 

	public JspPromotion getForm() { return jspPromotion; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidPromotion){
		msgString = "";
		int excCode = I_CONExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case JSPCommand.ADD :
				break;
                        
                        case JSPCommand.ACTIVATE :
                                if(oidPromotion != 0){
					try{
						promotion = DbPromotion.fetchExc(oidPromotion);
					}catch(Exception exc){
					}
				}
			break;             

			case JSPCommand.SAVE :
				if(oidPromotion != 0){
					try{
						promotion = DbPromotion.fetchExc(oidPromotion);
					}catch(Exception exc){
					}
				}

				jspPromotion.requestEntityObject(promotion);

				if(jspPromotion.errorSize()>0) {
					msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(promotion.getOID()==0){
					try{
                                            //int ctr = DbPromotion.getNextCounter();
                                            //promotion.setCounter(ctr);
                                            //promotion.setPrefixNumber(DbPromotion.getNumberPrefix());
                                            //promotion.setNumber(DbPromotion.getNextNumber(ctr));
                                            //promotion.setStatus(I_Project.DOC_STATUS_DRAFT);
                                            //if(promotion.getDate()==null){
                                            //    promotion.setDate(date);
                                            //}
                                            
                                            
						long oid = pstCosting.insertExc(this.promotion);
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
                                                //if(promotion.getDate()==null){
                                                //    promotion.setDate(date);
                                                //}
						long oid = pstCosting.updateExc(this.promotion);
					}catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN); 
					}

				}
				break;
                                
                        case JSPCommand.POST:

                                System.out.println("\n\nPOSTING command POST\n");

                                long userId = 0;
                                long app1Id = 0;
                                long app2Id = 0;
                                long app3Id = 0;

                                if (oidPromotion != 0) {
                                    try {
                                        promotion = DbPromotion.fetchExc(oidPromotion);

                                        //userId = promotion.getUserId();
                                        //app1Id = promotion.getApproval1();
                                       // app2Id = promotion.getApproval2();
                                        //app3Id = promotion.getApproval3();

                                    } catch (Exception exc) {
                                    }
                                }

                                jspPromotion.requestEntityObject(promotion);
                                //if(promotion.getDate()==null){
                                  //  promotion.setDate(date);
                                //}

                                //System.out.println("\n\n status = "+promotion.getStatus());

                                //approval check ----------------
                                //if (promotion.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                                    //approved status
                                 //   promotion.setApproval1(0);
                                    //check status
                                //    promotion.setApproval2(0);
                                    //close status
                                //    promotion.setApproval3(0);
                               // } else if (promotion.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                                    //approved status
                                //    promotion.setApproval1(promotion.getUserId());
                                    //promotion.setApproval1Date(new Date());
                                    //draft status
                                //    promotion.setUserId(userId);
                                    //check status
                               //     promotion.setApproval2(0);
                                    //close status
                               //     promotion.setApproval3(0);
                               // } else if (promotion.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {
                                    //close statusc
                                //    promotion.setApproval2(promotion.getUserId());
                                    //promotion.setApproval2Date(new Date());
                                    //draft status
                                //    promotion.setUserId(userId);
                                    //close
                                //    promotion.setApproval3(0);
                               // } else if (promotion.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {
                                    //close status
                               //     promotion.setApproval3(promotion.getUserId());
                                    //promotion.setApproval3Date(new Date());
                                    //draft status
                               //     promotion.setUserId(userId);
                               // }
                                //--------------------------------

                                if (jspPromotion.errorSize() > 0) {
                                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                                    return RSLT_FORM_INCOMPLETE;
                                }

                                if (promotion.getOID() == 0) {
                                    try {

                                       // int ctr = DbPromotion.getNextCounter();
                                       // promotion.setCounter(ctr);
                                       // promotion.setPrefixNumber(DbPromotion.getNumberPrefix());
                                       // promotion.setNumber(DbPromotion.getNextNumber(ctr));

                                        long oid = pstCosting.insertExc(this.promotion);

                                        //System.out.println("\n--- insert oid : "+oid+", "+promotion.getStatus());

                                        

                                    } catch (CONException dbexc) {
                                        excCode = dbexc.getErrorCode();
                                        msgString = getSystemMessage(excCode);
                                        return getControlMsgId(excCode);
                                    } catch (Exception exc) {
                                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                                    }

                                } else {
                                    try {
                                        long oid = pstCosting.updateExc(this.promotion);

                                        //System.out.println("update oid : "+oid+", "+promotion.getStatus());

                                       



                                    } catch (CONException dbexc) {
                                        excCode = dbexc.getErrorCode();
                                        msgString = getSystemMessage(excCode);
                                    } catch (Exception exc) {
                                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                                    }

                                }
                                break;

			case JSPCommand.EDIT :
				if (oidPromotion != 0) {
					try {
						promotion = DbPromotion.fetchExc(oidPromotion);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			case JSPCommand.ASK :
				if (oidPromotion != 0) {
					try {
						promotion = DbPromotion.fetchExc(oidPromotion);
					} catch (CONException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
					}
				}
				break;

			

			case JSPCommand.SUBMIT:
                            if (oidPromotion != 0){
                                try {
                                    promotion = DbPromotion.fetchExc(oidPromotion);
                                } catch (CONException dbexc) {
                                    excCode = dbexc.getErrorCode();
                                    msgString = getSystemMessage(excCode);
                                } catch (Exception exc) {
                                    msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                                }
                            }
                            break;


                    case JSPCommand.CONFIRM:
                        if (oidPromotion != 0){

                           int rslt = DbPromotionItem.deleteAllItem(oidPromotion);     

                           try {

                                long oid = DbPromotion.deleteExc(oidPromotion);
                                

                                if (rslt == 0) {
                                    msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                                    excCode = RSLT_OK;
                                } else {
                                    msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                                    excCode = RSLT_FORM_INCOMPLETE;
                                }
                            } catch (CONException dbexc) {
                                excCode = dbexc.getErrorCode();
                                msgString = getSystemMessage(excCode);
                            } catch (Exception exc) {
                                msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                            }

                        }
                        break;
                
                    default:    
		}
		return rsCode;
	}
}
