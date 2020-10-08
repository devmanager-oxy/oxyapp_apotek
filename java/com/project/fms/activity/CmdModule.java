package com.project.fms.activity;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.master.*;
import com.project.*;

public class CmdModule extends Control {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"},//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Module module;
    private DbModule dbModule;
    private JspModule jspModule;

    public CmdModule(HttpServletRequest request) {
        msgString = "";
        module = new Module();
        try {
            dbModule = new DbModule(0);
        } catch (Exception e) {
            ;
        }
        jspModule = new JspModule(request, module);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.frmAdjustment.addError(frmAdjustment.FRM_FIELD_ADJUSTMENT_ID, resultText[language][RSLT_EST_CODE_EXIST] );
                return resultText[1][RSLT_EST_CODE_EXIST];
            default:
                return resultText[1][RSLT_UNKNOWN_ERROR];
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

    public Module getModule() {
        return module;
    }

    public JspModule getForm() {
        return jspModule;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidModule) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SUBMIT:
                if (oidModule != 0) {
                    try {
                        module = DbModule.fetchExc(oidModule);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SAVE:
                long oldParentId = 0;
                if (oidModule != 0) {
                    try {
                        module = DbModule.fetchExc(oidModule);
                        oldParentId = module.getParentId();
                    } catch (Exception exc) {
                    }
                }
                
                boolean replaceCode = false;
                if(module.getCode()==null || module.getCode().length()==0){                    
                    replaceCode = true; 
                }

                jspModule.requestEntityObject(module);

                if (jspModule.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                String code = "";
                
                if(replaceCode){
                    
                    if(module.getParentId()==0){
                    
                        ActivityPeriod ap = new ActivityPeriod();
                        try{
                            ap = DbActivityPeriod.fetchExc(module.getActivityPeriodId());
                            code = JSPFormater.formatDate(ap.getEndDate(),"yy");
                        }
                        catch(Exception e){
                        }

                        if(module.getSegment1Id()!=0){
                            SegmentDetail sd1 = new SegmentDetail();
                            try{
                                sd1 = DbSegmentDetail.fetchExc(module.getSegment1Id());
                                code = code+"."+sd1.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment2Id()!=0){
                            SegmentDetail sd2 = new SegmentDetail();
                            try{
                                sd2 = DbSegmentDetail.fetchExc(module.getSegment2Id());
                                code = code+"."+sd2.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment3Id()!=0){
                            SegmentDetail sd3 = new SegmentDetail();
                            try{
                                sd3= DbSegmentDetail.fetchExc(module.getSegment3Id());
                                code = code+"."+sd3.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment4Id()!=0){
                            SegmentDetail sd4 = new SegmentDetail();
                            try{
                                sd4 = DbSegmentDetail.fetchExc(module.getSegment4Id());
                                code = code+"."+sd4.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment5Id()!=0){
                            SegmentDetail sd5 = new SegmentDetail();
                            try{
                                sd5 = DbSegmentDetail.fetchExc(module.getSegment5Id());
                                code = code+"."+sd5.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment6Id()!=0){
                            SegmentDetail sd6 = new SegmentDetail();
                            try{
                                sd6 = DbSegmentDetail.fetchExc(module.getSegment6Id());
                                code = code+"."+sd6.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment7Id()!=0){
                            SegmentDetail sd7 = new SegmentDetail();
                            try{
                                sd7 = DbSegmentDetail.fetchExc(module.getSegment7Id());
                                code = code+"."+sd7.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment8Id()!=0){
                            SegmentDetail sd8 = new SegmentDetail();
                            try{
                                sd8 = DbSegmentDetail.fetchExc(module.getSegment8Id());
                                code = code+"."+sd8.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment9Id()!=0){
                            SegmentDetail sd9 = new SegmentDetail();
                            try{
                                sd9= DbSegmentDetail.fetchExc(module.getSegment9Id());
                                code = code+"."+sd9.getCode();
                            }
                            catch(Exception e){
                            }
                        }

                        if(module.getSegment10Id()!=0){
                            SegmentDetail sd10 = new SegmentDetail();
                            try{
                                sd10 = DbSegmentDetail.fetchExc(module.getSegment10Id());
                                code = code+"."+sd10.getCode();
                            }
                            catch(Exception e){
                            }
                        }
                        
                        code = code + ".";

                        int cnt = DbModule.getCount(DbModule.colNames[DbModule.COL_CODE]+" like '%"+code+"%'")+1;

                        String srcCode = code;

                        boolean found = true;
                        while(found){

                            if(cnt<10){
                                srcCode = srcCode + "00"+cnt;
                            }
                            else if(cnt<100){
                                srcCode = srcCode + "0"+cnt;                            
                            }
                            else{
                                srcCode = srcCode + "" + cnt;
                            }

                            int chkCount = DbModule.getCount(DbModule.colNames[DbModule.COL_CODE]+" = '"+srcCode+"'");

                            if(chkCount==0){
                                found = false;
                            }
                            else{
                                cnt = cnt + 1; 
                            }
                        }

                        if(cnt<10){
                            code = code + "00"+cnt;
                        }
                        else if(cnt<100){
                            code = code + "0"+cnt;                            
                        }
                        else{
                            code = code + "" + cnt;
                        }

                        System.out.println(code);

                        module.setCode(code);
                        
                    }//parent id ada
                    else{
                        
                        Module parent = new Module();
                        try{
                            parent = DbModule.fetchExc(module.getParentId());
                            
                            code = parent.getCode()+".";
                            
                            int cnt = DbModule.getCount(DbModule.colNames[DbModule.COL_CODE]+" like '%"+code+"%'")+1;

                            String srcCode = code;

                            boolean found = true;
                            while(found){

                                if(cnt<10){
                                    srcCode = srcCode + "00"+cnt;
                                }
                                else if(cnt<100){
                                    srcCode = srcCode + "0"+cnt;                            
                                }
                                else{
                                    srcCode = srcCode + "" + cnt;
                                }

                                int chkCount = DbModule.getCount(DbModule.colNames[DbModule.COL_CODE]+" = '"+srcCode+"'");

                                if(chkCount==0){
                                    found = false;
                                }
                                else{
                                    cnt = cnt + 1; 
                                }
                            }

                            if(cnt<10){
                                code = code + "00"+cnt;
                            }
                            else if(cnt<100){
                                code = code + "0"+cnt;                            
                            }
                            else{
                                code = code + "" + cnt;
                            }

                            System.out.println(code);

                            module.setCode(code);
                            
                        }
                        catch(Exception e){
                        }
                        
                    }
                    
                }
                
                if(replaceCode){
                    module.setCode(code);
                }
                
                /*
                if(module.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
                module.setParentId(module.getParentIdM());
                }
                else if(module.getLevel().equals(I_Project.ACTIVITY_CODE_H)){
                module.setParentId(module.getParentIdS());
                }
                else if(module.getLevel().equals(I_Project.ACTIVITY_CODE_A)){
                module.setParentId(module.getParentIdSH());
                module.setPositionLevel(module.getStatusPost());
                }
                else if(module.getLevel().equals(I_Project.ACTIVITY_CODE_SA)){
                module.setParentId(module.getParentIdA());
                module.setPositionLevel(module.getStatusPost());
                }
                else if(module.getLevel().equals(I_Project.ACTIVITY_CODE_SSA)){
                module.setParentId(module.getParentIdSA()); 
                module.setPositionLevel(module.getStatusPost());
                }
                 */
                if (module.getOID() == 0) {
                    try {
                        this.module.setCreateDate(new Date());
                         if(module.getDocStatus() == DbModule.DOC_STATUS_DRAFT){
                            this.module.setApproval1Date(null);
                            this.module.setApproval1Id(0);
                        }
                        long oid = dbModule.insertExc(this.module);
                        if (oid != 0) {
                            DbModule.updatePostedStatus(this.module.getParentId());
                            rsCode = RSLT_OK;
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
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
                        
                        this.module.setCreateDate(new Date());
                        if(module.getDocStatus() == DbModule.DOC_STATUS_DRAFT){
                            this.module.setApproval1Date(null);
                            this.module.setApproval1Id(0);
                        }
                        
                        long oid = dbModule.updateExc(this.module);
                        if (oid != 0) {
                            DbModule.updatePostedStatus(this.module.getParentId());
                            if (oldParentId != 0) {
                                DbModule.updatePostedStatus(oldParentId);
                            }
                            rsCode = RSLT_OK;
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_UPDATED);
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidModule != 0) {
                    try {
                        module = DbModule.fetchExc(oidModule);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidModule != 0) {
                    try {
                        module = DbModule.fetchExc(oidModule);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.YES:
                if (oidModule != 0) {
                    try {
                        module = DbModule.fetchExc(oidModule);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
            case JSPCommand.LOCK:
                if (oidModule != 0) {
                    try {
                        module = DbModule.fetchExc(oidModule);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;  
            case JSPCommand.DETAIL:
                if (oidModule != 0) {
                    try {
                        module = DbModule.fetchExc(oidModule);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;    
            case JSPCommand.DELETE:
                if (oidModule != 0) {
                    try {
                        Module module = DbModule.fetchExc(oidModule);
                        long oldParentid = module.getParentId();
                        long oid = DbModule.deleteExc(oidModule);

                        if (oid != 0) {
                            if (oldParentid != 0) {
                                DbModule.updatePostedStatus(oldParentid);
                                DbModule.deleteBudget(oid);
                            }
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
