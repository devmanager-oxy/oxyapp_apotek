package com.project.fms.master;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.general.DbHistoryUser;
import com.project.general.DbLocation;
import com.project.general.HistoryUser;
import com.project.general.Location;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;

public class CmdSegmentDetail extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private SegmentDetail segmentDetail;
    private DbSegmentDetail pstSegmentDetail;
    private JspSegmentDetail jspSegmentDetail;
    int language = LANGUAGE_DEFAULT;
    private long userId = 0;

    public CmdSegmentDetail(HttpServletRequest request) {
        msgString = "";
        segmentDetail = new SegmentDetail();
        try {
            pstSegmentDetail = new DbSegmentDetail(0);
        } catch (Exception e) {
        }
        jspSegmentDetail = new JspSegmentDetail(request, segmentDetail);
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

    public SegmentDetail getSegmentDetail() {
        return segmentDetail;
    }

    public JspSegmentDetail getForm() {
        return jspSegmentDetail;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSegmentDetail) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                SegmentDetail sdOld = new SegmentDetail();
                if (oidSegmentDetail != 0) {
                    try {
                        segmentDetail = DbSegmentDetail.fetchExc(oidSegmentDetail);
                        sdOld = DbSegmentDetail.fetchExc(oidSegmentDetail);
                    } catch (Exception exc) {
                    }
                }

                jspSegmentDetail.requestEntityObject(segmentDetail);

                if (DbSegmentDetail.isExist(segmentDetail.getOID(), segmentDetail.getCode(), segmentDetail.getSegmentId())) {
                    jspSegmentDetail.addError(jspSegmentDetail.JSP_CODE, "Data sudah dipakai");
                }

                if (jspSegmentDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (segmentDetail.getOID() == 0) {
                    try {
                        long oid = pstSegmentDetail.insertExc(this.segmentDetail);
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_SEGMENT_DETAIL);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);
                            historyUser.setDescription("Pembuatan segment detail baru : " + this.segmentDetail.getName());
                            try {
                                User u = DbUser.fetch(getUserId());
                                historyUser.setUserId(getUserId());
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
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

                } else {
                   
                    try {
                        long oid = pstSegmentDetail.updateExc(this.segmentDetail);
                        String str = "";
                        if (sdOld.getCode().compareToIgnoreCase(this.segmentDetail.getCode()) != 0) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            str = str + "Code :" + sdOld.getCode() + "->" + this.segmentDetail.getCode();
                        }

                        if (sdOld.getName().compareToIgnoreCase(this.segmentDetail.getName()) != 0) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            str = str + "Name :" + sdOld.getName() + "->" + this.segmentDetail.getName();
                        }

                        if (sdOld.getLocationId() != this.segmentDetail.getLocationId()) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            String locOld = "";
                            String locNew = "";

                            try {
                                Location l = DbLocation.fetchExc(sdOld.getLocationId());
                                locOld = l.getName();
                            } catch (Exception e) {
                            }

                            try {
                                Location l = DbLocation.fetchExc(this.segmentDetail.getLocationId());
                                locNew = l.getName();
                            } catch (Exception e) {
                            }
                            str = str + "location :" + locOld + "->" + locNew;
                        }

                        if (sdOld.getRefSegmentDetailId() != this.segmentDetail.getRefSegmentDetailId()) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            String locOld = "";
                            String locNew = "";

                            try {
                                SegmentDetail l = DbSegmentDetail.fetchExc(sdOld.getRefSegmentDetailId());
                                locOld = l.getName();
                            } catch (Exception e) {
                            }

                            try {
                                SegmentDetail l = DbSegmentDetail.fetchExc(this.segmentDetail.getRefSegmentDetailId());
                                locNew = l.getName();
                            } catch (Exception e) {
                            }
                            str = str + "Location Post :" + locOld + "->" + locNew;
                        }


                        if (sdOld.getRefId() != this.segmentDetail.getRefId()) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }

                            String segOld = "";
                            String segNew = "";

                            try {
                                SegmentDetail sdetOld = DbSegmentDetail.fetchExc(sdOld.getRefId());
                                segOld = sdetOld.getName();
                            } catch (Exception e) {
                            }

                            try {
                                SegmentDetail sdet = DbSegmentDetail.fetchExc(segmentDetail.getRefId());
                                segNew = sdet.getName();
                            } catch (Exception e) {
                            }
                            str = str + "parent :" + segOld + "->" + segNew;
                        }

                        if (sdOld.getTypeSalesReport() != this.segmentDetail.getTypeSalesReport()) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            str = str + "type  :" + DbSegmentDetail.typeSaleStr[sdOld.getTypeSalesReport()] + "->" + DbSegmentDetail.typeSaleStr[this.segmentDetail.getTypeSalesReport()];

                        }

                        if (sdOld.getStatus() != this.segmentDetail.getStatus()) {
                            if (str != null && str.length() > 0) {
                                str = str + ",";
                            }
                            str = str + "Status  :" + DbSegmentDetail.strKeyStatus[sdOld.getStatus()] + "->" + DbSegmentDetail.strKeyStatus[this.segmentDetail.getStatus()];
                        }

                        if (str != null && str.length() > 0) {
                            str = "Perubahan data : " + str;
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_SEGMENT_DETAIL);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);
                            historyUser.setDescription(str);
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


                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidSegmentDetail != 0) {
                    try {
                        segmentDetail = DbSegmentDetail.fetchExc(oidSegmentDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidSegmentDetail != 0) {
                    try {
                        segmentDetail = DbSegmentDetail.fetchExc(oidSegmentDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSegmentDetail != 0) {
                    try {
                        sdOld = new SegmentDetail();
                        try{
                            sdOld = DbSegmentDetail.fetchExc(oidSegmentDetail);
                        }catch(Exception e){}
                        long oid = DbSegmentDetail.deleteExc(oidSegmentDetail);
                        if (oid != 0) {
                            String str = "Penghapusan data : " + sdOld.getName();
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_SEGMENT_DETAIL);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(oid);
                            historyUser.setDescription(str);
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
