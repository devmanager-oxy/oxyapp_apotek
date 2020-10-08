/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.DbSystemProperty;
import com.project.util.jsp.*;
import com.project.util.lang.*;
/**
 *
 * @author Roy Andika
 */


public class CmdPriceType extends Control implements I_Language{

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    
    private int start;
    private String msgString;
    private PriceType priceType;
    private DbPriceType pstPriceType;
    private JspPriceType jspPriceType;
    int language = LANGUAGE_DEFAULT;
    private long userId = 0;
    private String userName = "";

    public CmdPriceType(HttpServletRequest request) {
        msgString = "";
        priceType = new PriceType();
        try {
            pstPriceType = new DbPriceType(0);
        } catch (Exception e) {
        }
        jspPriceType = new JspPriceType(request, priceType);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return resultText[language][RSLT_EST_CODE_EXIST];
            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return RSLT_EST_CODE_EXIST;
            default:
                return RSLT_UNKNOWN_ERROR;
        }
    }
    
    public long getUserId(){ return userId; }

    public void setUserId(long userId){ this.userId = userId; }

    public String getUserName(){ return userName; }

    public void setUserName(String userName){ this.userName = userName; }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public PriceType getPriceType() {
        return priceType;
    }

    public JspPriceType getForm() {
        return jspPriceType;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }
    
    
    public PriceType UpdatePrice(PriceType pt, long up){
        long s,t;
        String r;
        String valUp;
        valUp= String.valueOf(up);
        
        //gol1
        if(priceType.getGol1()>0){
        t = Math.round(priceType.getGol1());
        r= String.valueOf(t);
        if(r.length()>1 && r!=null){
            String p = r.substring((r.length()- (valUp.length())), r.length());
            if(p!=null && p.length()>0){
                s = Long.parseLong(p);
                if(s<up && s!=0){
                    t= (t-s) + up;

                }else if(s>up){
                    t= (t-s) +(2*up);
                }
                this.priceType.setGol1(t);
            }
        }
        }
        //gol2
        if(priceType.getGol2()>0){
        t = Math.round(priceType.getGol2());
        r= String.valueOf(t);
        if(r.length()>1 && r!=null){
            String p = r.substring((r.length()-(valUp.length())), r.length());
            if(p!=null && p.length()>0){
                s = Long.parseLong(p);
                if(s< up && s!=0){
                    t= (t-s) + up;

                }else if(s>up){
                    t= (t-s) +(2*up);
                }
                this.priceType.setGol2(t);
            }
        }
        }
        //gol3
        if(priceType.getGol3()>0){
         t = Math.round(priceType.getGol3());
        r= String.valueOf(t);
        if(r.length()>1 && r!=null){
            String p = r.substring((r.length()-(valUp.length())), r.length());
            if(p!=null && p.length()>0){
                s = Long.parseLong(p);
                if(s<up && s!=0){
                    t= (t-s) + up;

                }else if(s>up){
                    t= (t-s) +(2*up);
                }
                this.priceType.setGol3(t);
            }
        }
        }
        //gol4
        if(priceType.getGol4()>0){
         t = Math.round(priceType.getGol4());
        r= String.valueOf(t);
        if(r.length()>1 && r!=null){
            String p = r.substring((r.length()-(valUp.length())), r.length());
            if(p!=null && p.length()>0){
                s = Long.parseLong(p);
                if(s<up && s!=0){
                    t= (t-s) + up;

                }else if(s>up){
                    t= (t-s) +(2*up);
                }
                this.priceType.setGol4(t);
            }
        }
        }
        //gol5
        /*if(priceType.getGol5()>0){
        t = Math.round(priceType.getGol5());
        r= String.valueOf(t);
        if(r.length()>0 && r!=null){
            String p = r.substring((r.length()-(valUp.length())), r.length());
            if(p!=null && p.length()>0){
                s = Long.parseLong(p);
                if(s<up && s!=0){
                    t= (t-s) + up;

                }else if(s>up){
                    t= (t-s) +(2*up);
                }
                this.priceType.setGol5(t);
            }
        }
        }*/
        return pt;
    }

    public int action(int cmd, long oidStockCode) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                
                PriceType oldPriceType = new PriceType();
                
                if (oidStockCode != 0) {
                    try {
                        priceType = DbPriceType.fetchExc(oidStockCode);
                        oldPriceType = DbPriceType.fetchExc(oidStockCode);
                    } catch (Exception exc) {
                    }
                }

                jspPriceType.requestEntityObject(priceType);

                if (jspPriceType.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (priceType.getOID() == 0) {
                    try {
                        //untuk membulatkan price
                        String r=DbSystemProperty.getValueByName("ROUND_PRICE");
                        long rounding=0;
                        if(!(r.equalsIgnoreCase("Not initialized"))){
                            rounding =  Long.parseLong((r));
                        }
                        if(rounding>0)   {
                           this.priceType= UpdatePrice(this.priceType,rounding);
                                                
                        }
                        long oid = pstPriceType.insertExc(this.priceType);
                        //if(oid!=0){
                        //    DbPriceType.insertOperationLog(oid, userId, userName, priceType);
                       // }
                        String logsdec = DbPriceType.getLogDesc(oldPriceType, priceType);
                        if(logsdec.length()>0){
                               priceType.setChangeDate(new Date()); 
                               pstPriceType.updateExc(this.priceType);
                        }
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
                        //untuk membulatkan price
                        String r=DbSystemProperty.getValueByName("ROUND_PRICE");
                        long rounding=0;
                        if(!(r.equalsIgnoreCase("Not initialized"))){
                            rounding =  Long.parseLong((r));
                        }
                        if(rounding>0)   {
                           this.priceType= UpdatePrice(this.priceType, rounding);
                                                
                        }
                        
                        long oid = pstPriceType.updateExc(this.priceType);
                        if(oid!=0){
                            DbPriceType.insertOperationLog(oid, userId, userName, oldPriceType, priceType);
                            String logdec = DbPriceType.getLogDesc(oldPriceType, priceType);
                            if(logdec.length()>0){
                               priceType.setChangeDate(new Date()); 
                               pstPriceType.updateExc(this.priceType);
                            }
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:
                jspPriceType.requestEntityObject(priceType);

                if (jspPriceType.errorSize() > 0){
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.EDIT:
                if (oidStockCode != 0) {
                    try {
                        priceType = DbPriceType.fetchExc(oidStockCode);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidStockCode != 0) {
                    try {
                        priceType = DbPriceType.fetchExc(oidStockCode);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidStockCode != 0) {
                    try {
                        long oid = DbPriceType.deleteExc(oidStockCode);
                        if (oid != 0) {
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
