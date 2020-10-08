package com.project.general;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

public class CmdLocation extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Location location;
    private DbLocation pstLocation;
    private JspLocation jspLocation;
    int language = LANGUAGE_DEFAULT;
    private long userId = 0;
    private long employeeId = 0;

    public CmdLocation(HttpServletRequest request) {
        msgString = "";
        location = new Location();
        try {
            pstLocation = new DbLocation(0);
        } catch (Exception e) {}
        jspLocation = new JspLocation(request, location);
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

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public Location getLocation() {
        return location;
    }

    public JspLocation getForm() {
        return jspLocation;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidLocation) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                Location lOld = new Location();
                if (oidLocation != 0) {
                    try {
                        location = DbLocation.fetchExc(oidLocation);
                        lOld = DbLocation.fetchExc(oidLocation);
                    } catch (Exception exc) {
                    }
                }

                jspLocation.requestEntityObject(location);

                if (jspLocation.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (location.getOID() == 0) {
                    try {
                        long oid = pstLocation.insertExc(this.location);
                        
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_LOCATION);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);                            
                            historyUser.setDescription("Pembuatan lokasi baru : " + this.location.getName());
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }
                            
                            try{
                                DbHistoryUser.insertExc(historyUser);
                            }catch(Exception e){}

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
                        long oid = pstLocation.updateExc(this.location);                        
                        if(oid != 0){
                            String str = "";
                            if(lOld.getType().compareToIgnoreCase(this.location.getType()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "type :"+lOld.getType()+"->"+this.location.getType();
                            }
                            
                            if(lOld.getCode().compareToIgnoreCase(this.location.getCode()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "code :"+lOld.getCode()+"->"+this.location.getCode();
                            }
                            
                            if(lOld.getName().compareToIgnoreCase(this.location.getName()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "name :"+lOld.getName()+"->"+this.location.getName();
                            }
                            
                            if(lOld.getAddressStreet().compareToIgnoreCase(this.location.getAddressStreet()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "alamat :"+lOld.getAddressStreet()+"->"+this.location.getAddressStreet();
                            }
                            
                            if(lOld.getTelp().compareToIgnoreCase(this.location.getTelp()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "telp :"+lOld.getTelp()+"->"+this.location.getTelp();
                            }
                            
                            if(lOld.getPic().compareToIgnoreCase(this.location.getPic()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "telp :"+lOld.getPic()+"->"+this.location.getPic();
                            }
                            
                            if(lOld.getLocationIdRequest() != this.location.getLocationIdRequest()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String locOld = "";
                                String locNew = "";
                                
                                try{
                                    Location l = DbLocation.fetchExc(lOld.getLocationIdRequest());
                                    locOld = l.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Location l = DbLocation.fetchExc(this.location.getLocationIdRequest());
                                    locNew = l.getName();
                                }catch(Exception e){}
                                str = str + "location :"+locOld+"->"+locNew;
                            }
                            
                            if(lOld.getGol_price().compareToIgnoreCase(this.location.getGol_price()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "gol price :"+lOld.getGol_price()+"->"+this.location.getGol_price();
                            }
                            
                            if(lOld.getCoaArId() != this.location.getCoaArId()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaArId());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaArId());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. Ar :"+coaOld+"->"+coaNew;
                            }
                            
                            if(lOld.getCoaApId() != this.location.getCoaApId()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaApId());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaApId());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. Ap :"+coaOld+"->"+coaNew;
                            }
                            
                            if(lOld.getCoaPpnId() != this.location.getCoaPpnId()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaPpnId());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaPpnId());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. Ppn :"+coaOld+"->"+coaNew;
                            }
                            
                            if(lOld.getCoaPphId() != this.location.getCoaPphId()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaPphId());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaPphId());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. Pph :"+coaOld+"->"+coaNew;
                            }
                            
                            if(lOld.getCoaDiscountId() != this.location.getCoaDiscountId()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaDiscountId());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaDiscountId());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. Discount :"+coaOld+"->"+coaNew;
                            }
                            
                            if(lOld.getCoaSalesId() != this.location.getCoaSalesId()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaSalesId());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaSalesId());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. Sales :"+coaOld+"->"+coaNew;
                            }
                            
                            if(lOld.getCoaProjectPPHPasal23Id() != this.location.getCoaProjectPPHPasal23Id()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaProjectPPHPasal23Id());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaProjectPPHPasal23Id());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. PPH Pasal 23 :"+coaOld+"->"+coaNew;
                            }
                            
                            if(lOld.getCoaProjectPPHPasal22Id() != this.location.getCoaProjectPPHPasal22Id()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaProjectPPHPasal22Id());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaProjectPPHPasal22Id());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. PPH Pasal 22 :"+coaOld+"->"+coaNew;
                            }
                            
                            if(lOld.getDateStart() == null && this.location.getDateStart() != null){                                
                                String strDate = "";
                                try{
                                    strDate = JSPFormater.formatDate(this.location.getDateStart());
                                    if(str != null && str.length() > 0){ str = str +",";}
                                    str = str + "Start Date -> "+strDate;
                                }catch(Exception e){}
                                
                            }else{
                                if(lOld.getDateStart() != null && this.location.getDateStart() != null && JSPFormater.formatDate(lOld.getDateStart(),"dd/MM/yyyy").compareTo(JSPFormater.formatDate(this.location.getDateStart(),"dd/MM/yyyy")) != 0){                                    
                                    if(str != null && str.length() > 0){ str = str +",";}
                                    String strDate = "";
                                    String strDateEnd = "";
                                    try{
                                        strDate = JSPFormater.formatDate(lOld.getDateStart());                                        
                                    }catch(Exception e){}                                    
                                    
                                    try{
                                        strDateEnd = JSPFormater.formatDate(this.location.getDateStart());                                        
                                    }catch(Exception e){}
                                    str = str + "Start Date :"+strDate+"->"+strDateEnd;
                                
                                }
                            }
                            
                            if(lOld.getTypeGrosir() !=  this.location.getTypeGrosir()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "Type  :"+DbLocation.strKeyTypes[lOld.getTypeGrosir()]+"->"+DbLocation.strKeyTypes[this.location.getTypeGrosir()];
                            }
                            
                            if(lOld.getType24Hour() !=  this.location.getType24Hour()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "Status  :"+DbLocation.strKey24Hour[lOld.getType24Hour()]+"->"+DbLocation.strKey24Hour[this.location.getType24Hour()];
                            }
                            
                            if(lOld.getAktifAutoOrder() !=  this.location.getAktifAutoOrder()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                
                                if(lOld.getAktifAutoOrder() == 1){
                                    str = str + "Auto order : Aktif ->";
                                }else{
                                    str = str + "Auto order : Non Aktif ->";                                    
                                }
                                
                                if(this.location.getAktifAutoOrder() == 1){
                                    str = str + "Aktif";
                                }else{
                                    str = str + "Non Aktif";                                    
                                }                                
                            }
                            
                            if(lOld.getNpwp().compareToIgnoreCase(this.location.getNpwp()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "npwp :"+lOld.getNpwp()+"->"+this.location.getNpwp();
                            }
                            
                            if(lOld.getPrefixFakturPajak().compareToIgnoreCase(this.location.getPrefixFakturPajak()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "Prefix faktur pajak :"+lOld.getPrefixFakturPajak()+"->"+this.location.getPrefixFakturPajak();
                            }
                            
                            if(lOld.getPrefixFakturTransfer().compareToIgnoreCase(this.location.getPrefixFakturTransfer()) != 0){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "Prefix faktur transfer :"+lOld.getPrefixFakturTransfer()+"->"+this.location.getPrefixFakturTransfer();
                            }
                            
                            if(lOld.getAmountTarget() != this.location.getAmountTarget()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "Amount Target :"+JSPFormater.formatNumber(lOld.getAmountTarget(),"###,###.##")+"->"+JSPFormater.formatNumber(this.location.getAmountTarget(),"###,###.##");
                            }     
                            
                            if(lOld.getCoaApGrosirId() != this.location.getCoaApGrosirId()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                String coaOld = "";
                                String coaNew = "";
                                
                                try{
                                    Coa c = DbCoa.fetchExc(lOld.getCoaApGrosirId());
                                    coaOld = c.getName();
                                }catch(Exception e){}
                                
                                try{
                                    Coa c = DbCoa.fetchExc(this.location.getCoaApGrosirId());
                                    coaNew = c.getName();
                                }catch(Exception e){}
                                str = str + "Acc. Ap Grosir :"+coaOld+"->"+coaNew;
                            }
                            
                            
                            if(str != null && str.length() > 0){
                                str = "Perubahan data location "+lOld.getName()+": "+str;
                                HistoryUser historyUser = new HistoryUser();
                                historyUser.setType(DbHistoryUser.TYPE_LOCATION);
                                historyUser.setDate(new Date());
                                historyUser.setRefId(oid);                                
                                historyUser.setDescription(str);
                                try {
                                    User u = DbUser.fetch(userId);
                                    historyUser.setUserId(userId);
                                    historyUser.setEmployeeId(u.getEmployeeId());
                                } catch (Exception e) {}
                            
                                try{
                                    DbHistoryUser.insertExc(historyUser);
                                }catch(Exception e){}
                            }
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
                if (oidLocation != 0) {
                    try {
                        location = DbLocation.fetchExc(oidLocation);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidLocation != 0) {
                    try {
                        location = DbLocation.fetchExc(oidLocation);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidLocation != 0) {
                    try {
                        lOld = new Location();
                        try{
                            lOld = DbLocation.fetchExc(oidLocation);
                        }catch(Exception e){}
                        long oid = DbLocation.deleteExc(oidLocation);
                        
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_LOCATION);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);                            
                            historyUser.setDescription("Penghapusan data lokasi : " + lOld.getName());
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }
                            
                            try{
                                DbHistoryUser.insertExc(historyUser);
                            }catch(Exception e){}
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

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }
}
