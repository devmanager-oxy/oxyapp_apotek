package com.project.general;

import com.project.admin.DbUser;
import com.project.admin.User;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;

public class CmdVendor extends Control {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Succes", "Duplicate entry for vendor code", "Duplicate entry for vendor code", "Data incomplete"},//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Vendor vendor;
    private DbVendor dbVendor;
    private JspVendor jspVendor;
    private int language = 0;
    private long userId = 0;

    public CmdVendor(HttpServletRequest request) {
        msgString = "";
        vendor = new Vendor();
        try {
            dbVendor = new DbVendor(0);
        } catch (Exception e) {
        }
        jspVendor = new JspVendor(request, vendor);
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

    public Vendor getVendor() {
        return vendor;
    }

    public JspVendor getForm() {
        return jspVendor;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public String getLogsUpdate(Vendor oldVendor, Vendor vendor) {

        String logs = "";
        //Group Type
        if (oldVendor.getType() != vendor.getType()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Group Type:" + DbVendor.vendorType[oldVendor.getType()] + "->" + DbVendor.vendorType[vendor.getType()];
        }

        //Code
        if (oldVendor.getCode() == null || oldVendor.getCode().length() <= 0 || oldVendor.getCode().compareTo("null") == 0) {
            if (vendor.getCode() != null && vendor.getCode().length() > 0 && vendor.getCode().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Code : " + vendor.getCode();
            }
        } else {
            if (oldVendor.getCode().compareToIgnoreCase(vendor.getCode()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Code : " + oldVendor.getCode() + " -> " + vendor.getCode();
            }
        }

        //Name
        if (oldVendor.getName() == null || oldVendor.getName().length() <= 0 || oldVendor.getName().compareTo("null") == 0) {
            if (vendor.getName() != null && vendor.getName().length() > 0 && vendor.getName().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Name : " + vendor.getName();
            }
        } else {
            if (oldVendor.getName().compareToIgnoreCase(vendor.getName()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Name : " + oldVendor.getName() + " -> " + vendor.getName();
            }
        }

        //Address
        if (oldVendor.getAddress() == null || oldVendor.getAddress().length() <= 0 || oldVendor.getAddress().compareTo("null") == 0) {
            if (vendor.getAddress() != null && vendor.getAddress().length() > 0 && vendor.getAddress().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Address : " + vendor.getAddress();
            }
        } else {
            if (oldVendor.getAddress().compareToIgnoreCase(vendor.getAddress()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Address : " + oldVendor.getAddress() + " -> " + vendor.getAddress();
            }
        }

        //include ppn
        if (oldVendor.getIncludePPN() != vendor.getIncludePPN()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getIncludePPN() == 1) {
                logs = logs + "Include PPN : Yes -> No ";
            } else {
                logs = logs + "Include PPN : No -> Yes ";
            }
        }

        //Pkp
        if (oldVendor.getIsPKP() != vendor.getIsPKP()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getIsPKP() == 1) {
                logs = logs + "PKP : Yes -> No ";
            } else {
                logs = logs + "PKP : No -> Yes ";
            }
        }

        //Direct Receive
        if (oldVendor.getDirectReceive() != vendor.getDirectReceive()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getDirectReceive() == 1) {
                logs = logs + "Direct Receive : Yes -> No ";
            } else {
                logs = logs + "Direct Receive : No -> Yes ";
            }
        }

        //city                            
        if (oldVendor.getCity() == null || oldVendor.getCity().length() <= 0 || oldVendor.getCity().compareTo("null") == 0) {
            if (vendor.getCity() != null && vendor.getCity().length() > 0 && vendor.getCity().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "City : " + vendor.getCity();
            }
        } else {
            if (oldVendor.getCity().compareToIgnoreCase(vendor.getCity()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "City : " + oldVendor.getCity() + " -> " + vendor.getCity();
            }
        }

        //Due Date
        if (oldVendor.getDueDate() != vendor.getDueDate()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Due Date : " + oldVendor.getDueDate() + " -> " + vendor.getDueDate();

        }

        //State                            
        if (oldVendor.getState() == null || oldVendor.getState().length() <= 0 || oldVendor.getState().compareTo("null") == 0) {
            if (vendor.getState() != null && vendor.getState().length() > 0 && vendor.getState().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "State : " + vendor.getState();
            }
        } else {
            if (oldVendor.getState().compareToIgnoreCase(vendor.getState()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "State : " + oldVendor.getState() + " -> " + vendor.getState();
            }
        }

        //Discount
        if (oldVendor.getDiscount() != vendor.getDiscount()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Discount : " + oldVendor.getDiscount() + " -> " + vendor.getDiscount();
        }

        if (oldVendor.getCountryId() != vendor.getCountryId()) {
            String strCountry = "";
            if (oldVendor.getCountryId() != 0) {
                try {
                    Country c = DbCountry.fetchExc(oldVendor.getCountryId());
                    strCountry = c.getName();
                } catch (Exception e) {
                }
            }

            if (vendor.getCountryId() != 0) {
                if (strCountry != null && strCountry.length() > 0) {
                    strCountry = strCountry + "->";
                }
                try {
                    Country c = DbCountry.fetchExc(vendor.getCountryId());
                    strCountry = strCountry + c.getName();
                } catch (Exception e) {
                }
            }

            if (strCountry != null && strCountry.length() > 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Country :" + logs;
            }
        }

        //Phone                                                  
        if (oldVendor.getPhone() == null || oldVendor.getPhone().length() <= 0 || oldVendor.getPhone().compareTo("null") == 0) {
            if (vendor.getPhone() != null && vendor.getPhone().length() > 0 && vendor.getPhone().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Phone : " + vendor.getPhone();
            }
        } else {
            if (oldVendor.getPhone().compareToIgnoreCase(vendor.getPhone()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Phone : " + oldVendor.getPhone() + " -> " + vendor.getPhone();
            }
        }

        //Fax
        if (oldVendor.getFax() == null || oldVendor.getFax().length() <= 0 || oldVendor.getFax().compareTo("null") == 0) {
            if (vendor.getFax() != null && vendor.getFax().length() > 0 && vendor.getFax().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Fax : " + vendor.getFax();
            }
        } else {
            if (oldVendor.getFax().compareToIgnoreCase(vendor.getFax()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Fax : " + oldVendor.getFax() + " -> " + vendor.getFax();
            }
        }

        //NPWP
        if (oldVendor.getNpwp() == null || oldVendor.getNpwp().length() <= 0 || oldVendor.getNpwp().compareTo("null") == 0) {
            if (vendor.getNpwp() != null && vendor.getNpwp().length() > 0 && vendor.getNpwp().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "NPWP : " + vendor.getNpwp();
            }
        } else {
            if (oldVendor.getNpwp().compareToIgnoreCase(vendor.getNpwp()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "NPWP : " + oldVendor.getNpwp() + " -> " + vendor.getNpwp();
            }
        }

        //Email
        if (oldVendor.getEmail() == null || oldVendor.getEmail().length() <= 0 || oldVendor.getEmail().compareTo("null") == 0) {
            if (vendor.getEmail() != null && vendor.getEmail().length() > 0 && vendor.getEmail().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Email : " + vendor.getEmail();
            }
        } else {
            if (oldVendor.getEmail().compareToIgnoreCase(vendor.getEmail()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Email : " + oldVendor.getEmail() + " -> " + vendor.getEmail();
            }
        }

        //Pending One PO
        if (oldVendor.getPendingOnePo() != vendor.getPendingOnePo()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getPendingOnePo() == 0) {
                logs = logs + "Pending One PO : NO -> YES ";
            } else {
                logs = logs + "Pending One PO : YES -> NO ";
            }
        }

        //PIC
        if (oldVendor.getPic() == null || oldVendor.getPic().length() <= 0 || oldVendor.getPic().compareTo("null") == 0) {
            if (vendor.getPic() != null && vendor.getPic().length() > 0 && vendor.getPic().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Contact Person : " + vendor.getPic();
            }
        } else {
            if (oldVendor.getPic().compareToIgnoreCase(vendor.getPic()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Contact Person : " + oldVendor.getPic() + " -> " + vendor.getPic();
            }
        }

        //HP
        if (oldVendor.getHp() == null || oldVendor.getHp().length() <= 0 || oldVendor.getHp().compareTo("null") == 0) {
            if (vendor.getHp() != null && vendor.getHp().length() > 0 && vendor.getHp().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Hp : " + vendor.getHp();
            }
        } else {
            if (oldVendor.getHp().compareToIgnoreCase(vendor.getHp()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Hp : " + oldVendor.getHp() + " -> " + vendor.getHp();
            }
        }

        //Flaq Konsinyasi
        if (oldVendor.getIsKonsinyasi() != vendor.getIsKonsinyasi()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getIsKonsinyasi() == 0) {
                logs = logs + "Konsinyasi : NO -> YES ";
            } else {
                logs = logs + "Konsinyasi : YES -> NO ";
            }
        }

        //System Konsinyasi
        if (oldVendor.getSystem() != vendor.getSystem()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getSystem() == DbVendor.TYPE_SYSTEM_HJ) {
                logs = logs + "System Konsinyasi : Harga Jual -> Harga Beli";
            } else {
                logs = logs + "System Konsinyasi : Harga Beli -> Harga Jual";
            }
        }

        //Konsinyasi Margin
        if (oldVendor.getPercentMargin() != vendor.getPercentMargin()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Konsinyasi Margin : " + oldVendor.getPercentMargin() + " -> " + vendor.getPercentMargin();
        }

        //Konsinyasi Promosi
        if (oldVendor.getPercentPromosi() != vendor.getPercentPromosi()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Konsinyasi Promosi : " + oldVendor.getPercentPromosi() + " -> " + vendor.getPercentPromosi();
        }

        //Konsinyasi Barcode
        if (oldVendor.getPercentBarcode() != vendor.getPercentBarcode()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Konsinyasi Barcode : " + oldVendor.getPercentBarcode() + " -> " + vendor.getPercentBarcode();
        }

        //System Komisi
        if (oldVendor.getIsKomisi() != vendor.getIsKomisi()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getIsKomisi() == 0) {
                logs = logs + "Komisi : NO -> YES ";
            } else {
                logs = logs + "Komisi : YES -> NO ";
            }
        }

        //Komisi Margin
        if (oldVendor.getKomisiMargin() != vendor.getKomisiMargin()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Komisi Margin : " + oldVendor.getKomisiMargin() + " -> " + vendor.getKomisiMargin();
        }

        //Komisi Promosi
        if (oldVendor.getKomisiPromosi() != vendor.getKomisiPromosi()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Komisi Promosi : " + oldVendor.getKomisiPromosi() + " -> " + vendor.getKomisiPromosi();
        }

        //Komisi Barcode
        if (oldVendor.getKomisiBarcode() != vendor.getKomisiBarcode()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            logs = logs + "Komisi Barcode : " + oldVendor.getKomisiBarcode() + " -> " + vendor.getKomisiBarcode();
        }

        //Order Senin
        if (oldVendor.getOdrSenin() != vendor.getOdrSenin()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getOdrSenin() == 0) {
                logs = logs + "Order Senin : NO -> YES ";
            } else {
                logs = logs + "Order Senin : YES -> NO ";
            }
        }

        //Order Selasa
        if (oldVendor.getOdrSelasa() != vendor.getOdrSelasa()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getOdrSelasa() == 0) {
                logs = logs + "Order Selasa : NO -> YES ";
            } else {
                logs = logs + "Order Selasa : YES -> NO ";
            }
        }

        //Order Rabu
        if (oldVendor.getOdrRabu() != vendor.getOdrRabu()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getOdrRabu() == 0) {
                logs = logs + "Order Rabu : NO -> YES ";
            } else {
                logs = logs + "Order Rabu : YES -> NO ";
            }
        }

        //Order Kamis
        if (oldVendor.getOdrKamis() != vendor.getOdrKamis()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getOdrKamis() == 0) {
                logs = logs + "Order Kamis : NO -> YES ";
            } else {
                logs = logs + "Order Kamis : YES -> NO ";
            }
        }

        //Order Jumat
        if (oldVendor.getOdrJumat() != vendor.getOdrJumat()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getOdrJumat() == 0) {
                logs = logs + "Order Jumat : NO -> YES ";
            } else {
                logs = logs + "Order Jumat : YES -> NO ";
            }
        }

        //Order Sabtu
        if (oldVendor.getOdrSabtu() != vendor.getOdrSabtu()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getOdrSabtu() == 0) {
                logs = logs + "Order Sabtu : NO -> YES ";
            } else {
                logs = logs + "Order Sabtu : YES -> NO ";
            }
        }

        //Order Minggu
        if (oldVendor.getOdrMinggu() != vendor.getOdrMinggu()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getOdrMinggu() == 0) {
                logs = logs + "Order Minggu : NO -> YES ";
            } else {
                logs = logs + "Order Minggu : YES -> NO ";
            }
        }

        //Type Loc Incoming                            
        if (oldVendor.getTypeLocIncoming() == null || oldVendor.getTypeLocIncoming().length() <= 0 || oldVendor.getTypeLocIncoming().compareTo("null") == 0) {
            if (vendor.getTypeLocIncoming() != null && vendor.getTypeLocIncoming().length() > 0 && vendor.getTypeLocIncoming().compareTo("null") != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Type Location Incoming : " + vendor.getTypeLocIncoming();
            }
        } else {
            if (oldVendor.getTypeLocIncoming().compareToIgnoreCase(vendor.getTypeLocIncoming()) != 0) {
                if (logs.length() > 0) {
                    logs = logs + ",";
                }
                logs = logs + "Type Location Incoming : " + oldVendor.getTypeLocIncoming() + " -> " + vendor.getTypeLocIncoming();
            }
        }
        
        if (oldVendor.getLiabilitiesType() != vendor.getLiabilitiesType()) {
            if (logs.length() > 0) {
                logs = logs + ",";
            }
            if (oldVendor.getLiabilitiesType() == 0) {
                logs = logs + "Liabilities : Retail -> Grosir ";
            } else {
                logs = logs + "Liabilities : Grosir -> Retail ";
            }
        }
        
        return logs;
    }

    public int action(int cmd, long oidVendor) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                Vendor oldVendor = new Vendor();
                if (oidVendor != 0) {
                    try {
                        vendor = DbVendor.fetchExc(oidVendor);
                        oldVendor = DbVendor.fetchExc(oidVendor);
                    } catch (Exception exc) {
                    }
                }

                jspVendor.requestEntityObject(vendor);
                if (jspVendor.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (vendor.getOID() == 0) {
                    try {
                        if (vendor.getIsKonsinyasi() == 0) {
                            vendor.setPercentBarcode(0);
                            vendor.setSystem(0);
                            vendor.setPercentMargin(0);
                            vendor.setPercentPromosi(0);
                        }

                        if (vendor.getIsKomisi() == 0) {
                            vendor.setKomisiBarcode(0);
                            vendor.setKomisiMargin(0);
                            vendor.setKomisiPromosi(0);
                        }

                        long oid = dbVendor.insertExc(this.vendor);

                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_VENDOR);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);
                            historyUser.setDescription("Pembuatan vendor baru : " + this.vendor.getName());
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }
                            try {
                                DbHistoryUser.insertExc(historyUser);
                            } catch (Exception e) {}
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
                        if (vendor.getIsKonsinyasi() == 0) {
                            vendor.setPercentBarcode(0);
                            vendor.setSystem(0);
                            vendor.setPercentMargin(0);
                            vendor.setPercentPromosi(0);
                        }

                        if (vendor.getIsKomisi() == 0) {
                            vendor.setKomisiBarcode(0);
                            vendor.setKomisiMargin(0);
                            vendor.setKomisiPromosi(0);
                        }

                        long oid = dbVendor.updateExc(this.vendor);
                        if (oid != 0) {
                            
                            String logs = getLogsUpdate(oldVendor,vendor);

                            if (logs != null && logs.length() > 0) {
                                logs = "Perubahan data : " + logs;
                                HistoryUser historyUser = new HistoryUser();
                                historyUser.setType(DbHistoryUser.TYPE_VENDOR);
                                historyUser.setDate(new Date());
                                historyUser.setRefId(oid);
                                historyUser.setDescription(logs);
                                try {
                                    User u = DbUser.fetch(userId);
                                    historyUser.setUserId(userId);
                                    historyUser.setEmployeeId(u.getEmployeeId());
                                } catch (Exception e) {
                                }

                                try {
                                    DbHistoryUser.insertExc(historyUser);
                                } catch (Exception e) {
                                }
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

            case JSPCommand.SUBMIT:
                oldVendor = new Vendor();
                if (oidVendor != 0) {
                    try {
                        vendor = DbVendor.fetchExc(oidVendor);
                        oldVendor = DbVendor.fetchExc(oidVendor);
                    } catch (Exception exc) {
                    }
                }

                jspVendor.requestEntityObject(vendor);

                if (jspVendor.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (vendor.getOID() == 0) {
                    try {
                        long oid = dbVendor.insertExc(this.vendor);
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_VENDOR);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);
                            historyUser.setDescription("Pembuatan vendor baru : " + this.vendor.getName());
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }
                            try {
                                DbHistoryUser.insertExc(historyUser);
                            } catch (Exception e) {}
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
                        long oid = dbVendor.updateExc(this.vendor);
                        if(oid != 0){
                            String logs = getLogsUpdate(oldVendor,vendor);

                            if (logs != null && logs.length() > 0) {
                                logs = "Perubahan data : " + logs;
                                HistoryUser historyUser = new HistoryUser();
                                historyUser.setType(DbHistoryUser.TYPE_VENDOR);
                                historyUser.setDate(new Date());
                                historyUser.setRefId(oid);
                                historyUser.setDescription(logs);
                                try {
                                    User u = DbUser.fetch(userId);
                                    historyUser.setUserId(userId);
                                    historyUser.setEmployeeId(u.getEmployeeId());
                                } catch (Exception e) {
                                }

                                try {
                                    DbHistoryUser.insertExc(historyUser);
                                } catch (Exception e) {
                                }
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
                if (oidVendor != 0) {
                    try {
                        vendor = DbVendor.fetchExc(oidVendor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidVendor != 0) {
                    try {
                        vendor = DbVendor.fetchExc(oidVendor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidVendor != 0) {
                    try {
                        oldVendor = new Vendor();
                        try{
                            oldVendor = DbVendor.fetchExc(oidVendor);
                        }catch(Exception e){}
                        long oid = DbVendor.deleteExc(oidVendor);
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_VENDOR);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);
                            historyUser.setDescription("Penghapusan data vendor : " + this.vendor.getName());
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }
                            try {
                                DbHistoryUser.insertExc(historyUser);
                            } catch (Exception e) {}
                            
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
}
