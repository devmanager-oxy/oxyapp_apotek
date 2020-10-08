package com.project.ccs.posmaster;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.I_Ccs;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;
import com.project.general.DbHistoryUser;
import com.project.general.HistoryUser;

public class CmdItemGroup extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private long userId = 0;
    private long employeeId = 0;
    private String msgString;
    private ItemGroup itemGroup;
    private DbItemGroup pstItemGroup;
    private JspItemGroup jspItemGroup;
    int language = LANGUAGE_DEFAULT;

    public CmdItemGroup(HttpServletRequest request) {
        msgString = "";
        itemGroup = new ItemGroup();
        try {
            pstItemGroup = new DbItemGroup(0);
        } catch (Exception e) {
        }
        jspItemGroup = new JspItemGroup(request, itemGroup);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspItemGroup.addError(jspItemGroup.JSP_FIELD_item_group_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public ItemGroup getItemGroup() {
        return itemGroup;
    }

    public JspItemGroup getForm() {
        return jspItemGroup;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidItemGroup) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                ItemGroup iGOld = new ItemGroup();
                if (oidItemGroup != 0) {
                    try {
                        itemGroup = DbItemGroup.fetchExc(oidItemGroup);
                        iGOld = DbItemGroup.fetchExc(oidItemGroup);
                    } catch (Exception exc) {
                    }
                }

                jspItemGroup.requestEntityObject(itemGroup);

                if (jspItemGroup.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (itemGroup.getOID() == 0) {
                    try {
                        long oid = pstItemGroup.insertExc(this.itemGroup);
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_ITEM_GROUP);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);                            
                            historyUser.setDescription("Pembuatan category baru : " + itemGroup.getName());
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
                        long oid = pstItemGroup.updateExc(this.itemGroup);
                        
                        if(oid != 0){
                            String str = "";
                            if(iGOld.getType() != itemGroup.getType()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "type :"+I_Ccs.strCategoryType[iGOld.getType()]+"->"+I_Ccs.strCategoryType[itemGroup.getType()];
                            }
                            
                            if(iGOld.getCode().compareToIgnoreCase(itemGroup.getCode()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "code : "+iGOld.getCode()+"->"+itemGroup.getCode();
                            }
                            
                            if(iGOld.getName().compareToIgnoreCase(itemGroup.getName()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "name : "+iGOld.getName()+"->"+itemGroup.getName();
                            }
                            
                            if(iGOld.getAccountSales().compareToIgnoreCase(itemGroup.getAccountSales()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. sales : "+iGOld.getAccountSales()+"->"+itemGroup.getAccountSales();
                            }
                            if(iGOld.getAccountCogs().compareToIgnoreCase(itemGroup.getAccountCogs()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. cogs : "+iGOld.getAccountCogs()+"->"+itemGroup.getAccountCogs();
                            }
                            
                            if(iGOld.getAccountInv().compareToIgnoreCase(itemGroup.getAccountInv()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. inventory :"+iGOld.getAccountInv()+"->"+itemGroup.getAccountInv();
                            }
                            
                            if(iGOld.getAccountSalesCash().compareToIgnoreCase(itemGroup.getAccountSalesCash()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. sales cash :"+iGOld.getAccountSalesCash()+"->"+itemGroup.getAccountSalesCash();
                            }
                            
                            if(iGOld.getAccountCashIncome().compareToIgnoreCase(itemGroup.getAccountCashIncome()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. cash income :"+iGOld.getAccountCashIncome()+"->"+itemGroup.getAccountCashIncome();
                            }
                            
                            if(iGOld.getAccountCreditIncome().compareToIgnoreCase(itemGroup.getAccountCreditIncome()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. credit income :"+iGOld.getAccountCreditIncome()+"->"+itemGroup.getAccountCreditIncome();
                            }
                            
                            if(iGOld.getAccountVat().compareToIgnoreCase(itemGroup.getAccountVat()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. vat :"+iGOld.getAccountVat()+"->"+itemGroup.getAccountVat();
                            }
                            
                            if(iGOld.getAccountPph().compareToIgnoreCase(itemGroup.getAccountPph()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. pph:"+iGOld.getAccountPph()+"->"+itemGroup.getAccountPph();
                            }
                            
                            if(iGOld.getAccountDiscount().compareToIgnoreCase(itemGroup.getAccountDiscount()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. discount:"+iGOld.getAccountDiscount()+"->"+itemGroup.getAccountDiscount();
                            }
                            
                            if(iGOld.getAccountSalesJasa().compareToIgnoreCase(itemGroup.getAccountSalesJasa()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. service :"+iGOld.getAccountSalesJasa()+"->"+itemGroup.getAccountSalesJasa();
                            }
                            
                            if(iGOld.getAccountCosting().compareToIgnoreCase(itemGroup.getAccountCosting()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. costing :"+iGOld.getAccountCosting()+"->"+itemGroup.getAccountCosting();
                            }
                            
                            if(iGOld.getAccountBonusIncome().compareToIgnoreCase(itemGroup.getAccountBonusIncome()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. bonus:"+iGOld.getAccountBonusIncome()+"->"+itemGroup.getAccountBonusIncome();
                            }
                            
                            if(iGOld.getAccountOtherIncome().compareToIgnoreCase(itemGroup.getAccountOtherIncome()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. other income:"+iGOld.getAccountOtherIncome()+"->"+itemGroup.getAccountOtherIncome();
                            }
                            
                            if(iGOld.getAccountAjustment().compareToIgnoreCase(itemGroup.getAccountAjustment()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. ajustment :"+iGOld.getAccountAjustment()+"->"+itemGroup.getAccountAjustment();
                            }
                            
                            if(iGOld.getBonus() != itemGroup.getBonus()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "type bonus :";
                                if(iGOld.getBonus() == 0){
                                    str = str + " No -> ";
                                }else{
                                    str = str + " Yes -> ";
                                }
                                
                                if(itemGroup.getBonus() == 0){
                                    str = str + " No ";
                                }else{
                                    str = str + " Yes";
                                }
                            }
                            
                            if(iGOld.getQtyBeli() != itemGroup.getQtyBeli()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "qty beli :"+iGOld.getQtyBeli()+"->"+itemGroup.getQtyBeli();
                            }
                            
                            if(iGOld.getQtyBonus() != itemGroup.getQtyBonus()){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "qty bonus :"+iGOld.getQtyBonus()+"->"+itemGroup.getQtyBonus();
                            }
                            
                            if(iGOld.getAccountGrosirSales().compareToIgnoreCase(itemGroup.getAccountGrosirSales()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. grosir sales :"+iGOld.getAccountGrosirSales()+"->"+itemGroup.getAccountGrosirSales();
                            }
                            
                            if(iGOld.getAccountGrosirCOGS().compareToIgnoreCase(itemGroup.getAccountGrosirCOGS()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. grosir cogs:"+iGOld.getAccountGrosirCOGS()+"->"+itemGroup.getAccountGrosirCOGS();
                            }
                            
                            if(iGOld.getAccountGrosirInventory().compareToIgnoreCase(itemGroup.getAccountGrosirInventory()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. grosir inventory:"+iGOld.getAccountGrosirInventory()+"->"+itemGroup.getAccountGrosirInventory();
                            }
                            
                            if(iGOld.getAccountGrosirDiscount().compareToIgnoreCase(itemGroup.getAccountGrosirDiscount()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. grosir discount:"+iGOld.getAccountGrosirDiscount()+"->"+itemGroup.getAccountGrosirDiscount();
                            }
                            
                            if(iGOld.getAccountGrosirAdjusment().compareToIgnoreCase(itemGroup.getAccountGrosirAdjusment()) != 0 ){
                                if(str != null && str.length() > 0){ str = str +",";}
                                str = str + "acc. grosir ajustment:"+iGOld.getAccountGrosirAdjusment()+"->"+itemGroup.getAccountGrosirAdjusment();
                            }
                            
                            if(str != null && str.length() > 0){
                                str = "Perubahan data category "+iGOld.getName()+": "+str;
                                HistoryUser historyUser = new HistoryUser();
                                historyUser.setType(DbHistoryUser.TYPE_ITEM_GROUP);
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
                if (oidItemGroup != 0) {
                    try {
                        itemGroup = DbItemGroup.fetchExc(oidItemGroup);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidItemGroup != 0) {
                    try {
                        itemGroup = DbItemGroup.fetchExc(oidItemGroup);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidItemGroup != 0) {
                    try {
                        ItemGroup iGOldx = new ItemGroup();
                        try {                            
                            iGOldx = DbItemGroup.fetchExc(oidItemGroup);
                        } catch (Exception exc) {}
                        long oid = DbItemGroup.deleteExc(oidItemGroup);
                        if (oid != 0) {                            
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_ITEM_GROUP);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);                                
                            historyUser.setDescription("Penghapusan category : "+iGOldx.getName());
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {}
                            
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
