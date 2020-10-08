
<%-- 
    Document   : moduleg.jsp
    Created on : Sep 18, 2011, 11:28:18 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %> 
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privUpdate = true;
            boolean privAdd = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public String getSubstring(String s) {
        if (s.length() > 25) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 23) + "...</font></a>";
        }
        return s;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidModule = JSPRequestValue.requestLong(request, "hidden_module_id");
            String var = JSPRequestValue.requestStringExcTitikKoma(request, "hidden_var");
            int code = JSPRequestValue.requestInt(request, "hidden_code");
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            long activityPeriodId = JSPRequestValue.requestLong(request, "activity_period_id");
            int docStatus = JSPRequestValue.requestInt(request, "doc_status");
            
            if(iJSPCommand == JSPCommand.NONE){
                docStatus = DbModule.DOC_STATUS_APPROVE;
            }

            String whereMd = "";
            String oidMd = "";

            long jenAktifitas = 0;

            if (vSeg != null && vSeg.size() > 0) {

                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {

                    int pg = iSeg + 1;
                    long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");

                    if (segment_id != 0) {

                        oidMd = oidMd + ";" + segment_id;

                        if (iSeg == 2) {
                            jenAktifitas = segment_id;
                        }

                        if (whereMd.length() > 0) {
                            whereMd = whereMd + " and ";
                        }
                        if (iSeg == 0) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                        } else if (iSeg == 1) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                        } else if (iSeg == 2) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                        } else if (iSeg == 3) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                        } else if (iSeg == 4) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                        } else if (iSeg == 5) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                        } else if (iSeg == 6) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                        } else if (iSeg == 7) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                        } else if (iSeg == 8) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                        } else if (iSeg == 9) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                        } else if (iSeg == 10) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                        } else if (iSeg == 11) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                        } else if (iSeg == 12) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                        } else if (iSeg == 13) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                        } else if (iSeg == 14) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                        }
                    }
                }
            }

            ActivityPeriod apx = DbActivityPeriod.getOpenPeriod();

            if (activityPeriodId == 0) {
                activityPeriodId = apx.getOID();
            }

            boolean isOpen = true;
            if (activityPeriodId != apx.getOID()) {
                isOpen = false;
            }

            boolean yes = false;

            if (iJSPCommand == JSPCommand.YES) {
                if (var.length() > 0) {
                    iJSPCommand = JSPCommand.LIST;
                    yes = true;
                } else {
                    iJSPCommand = JSPCommand.NONE;
                }
            }

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            String whereClause = "";

            if (yes) {

                String[] condition;
                StringTokenizer strTokenizerCondition = new StringTokenizer(var, ";");
                condition = new String[strTokenizerCondition.countTokens()];
                int z = 0;
                whereMd = "";
                while (strTokenizerCondition.hasMoreTokens()) {
                    condition[z] = strTokenizerCondition.nextToken();
                    if (whereMd.length() > 0) {
                        whereMd = whereMd + " and ";
                    }
                    if (z != 0) {
                        if (z == 1) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + condition[z];
                        } else if (z == 2) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + condition[z];
                        } else if (z == 3) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + condition[z];
                        } else if (z == 4) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + condition[z];
                        } else if (z == 5) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + condition[z];
                        } else if (z == 6) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + condition[z];
                        } else if (z == 7) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + condition[z];
                        } else if (z == 8) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + condition[z];
                        } else if (z == 9) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + condition[z];
                        } else if (z == 10) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + condition[z];
                        } else if (z == 11) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + condition[z];
                        } else if (z == 12) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + condition[z];
                        } else if (z == 13) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + condition[z];
                        } else if (z == 14) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + condition[z];
                        } else if (z == 15) {
                            whereMd = whereMd + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + condition[z];
                        }
                    }
                    z++;
                }

                whereClause = "activity_period_id = " + condition[0];
            } else {
                whereClause = "activity_period_id = " + activityPeriodId;
            }      

            if (whereMd.length() > 0) {
                whereClause = whereClause + " and " + whereMd;
            }
            
            whereClause = whereClause + " and " +DbModule.colNames[DbModule.COL_DOC_STATUS]+" = "+docStatus;

            String orderClause = "" + DbModule.colNames[DbModule.COL_CODE];

            CmdModule cmdModule = new CmdModule(request);
            JSPLine ctrLine = new JSPLine();
            Vector listModule = new Vector(1, 1);
            Vector listModuleRpt = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdModule.action(iJSPCommand, oidModule);
            /* end switch*/
            JspModule jspModule = cmdModule.getForm();

            Module module = cmdModule.getModule();
            msgString = cmdModule.getMessage();

            int vectSize = 0;

            if (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV ||
                    iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST) {

                vectSize = DbModule.getCount(whereClause);

                if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                        (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                    start = cmdModule.actionList(iJSPCommand, start, vectSize, recordToGet);
                }

                listModule = DbModule.list(start, recordToGet, whereClause, orderClause);
                listModuleRpt = DbModule.list(0, 0, whereClause, orderClause);

                if (session.getValue("MODULE_GEREJA") != null) {
                    session.removeValue("MODULE_GEREJA");
                }

                session.putValue("MODULE_GEREJA", listModuleRpt);

                /*handle condition if size of record to display = 0 and start > 0 	after delete*/
                if (listModule.size() < 1 && start > 0) {
                    if (vectSize - recordToGet > recordToGet) {
                        start = start - recordToGet;
                    } //go to JSPCommand.PREV
                    else {
                        start = 0;
                        iJSPCommand = JSPCommand.FIRST;
                        prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                    }
                    listModule = DbModule.list(start, recordToGet, whereClause, orderClause);
                }
            }

            String[] langMD = {"Number", "Activity", "Target", "Days", "Date",
                "Time", "Memo", "Budget"
            };

            String[] langNav = {"Activity", "Activity List", "Period", "Data not found", "Please click search button to show activity datas","Doc. Status"};

            if (lang == LANG_ID) {
                String[] langID = {"No", "Kegiatan", "Sasaran", "Hari", "Tanggal",
                    "Waktu", "Keterangan", "Anggaran","Status Dok."
                };

                langMD = langID;
                String[] navID = {"Kegiatan", "Data Kerja", "Periode", "Data tidak ditemukan", "Click tombol search untuk menampilkan data kerja"};
                langNav = navID;
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdChangePeriod(){
                document.frmmodule.command.value="<%=JSPCommand.LIST%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdSearch(){
                document.frmmodule.command.value="<%=JSPCommand.LIST%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdAdd(){
                document.frmmodule.hidden_module_id.value="0";
                document.frmmodule.command.value="<%=JSPCommand.ADD%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdAsk(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.ASK%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdConfirmDelete(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.DELETE%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            function cmdSave(){
                document.frmmodule.command.value="<%=JSPCommand.SAVE%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdEdit(oidModule,count,actPeriodId){
                
                var val = "";
                switch(count){
                    case '1' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;                    
                    val = seg1;
                    break;
                    
                    case '2' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;                    
                    val = seg1+";"+seg2;
                    break;
                    
                    case '3' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3;
                    break;
                    
                    case '4' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3+";"+seg4;
                    break; 
                    case '5' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5;
                    break;
                    case '6' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6;
                    break;  
                    case '7' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7;
                    break; 
                    case '8' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                    var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7+";"+seg8;
                    break;
                    case '9' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                    var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                    var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7+";"+seg8+";"+seg9;
                    break; 
                    case '10' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                    var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                    var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                    var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7+""+seg8+";"+seg9+";"+seg10;
                    break;
                    case '11' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                    var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                    var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                    var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                    var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;                      
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7+";"+seg8+";"+seg9+";"+seg10+";"+seg11;
                    break;
                    case '12' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                    var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                    var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                    var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                    var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                    var seg12 = document.frmmodule.JSP_SEGMENT12_ID.value;                    
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7+";"+seg8+";"+seg9+";"+seg10+";"+seg11+";"+seg12;
                    break;
                    case '13' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                    var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                    var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                    var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                    var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                    var seg12 = document.frmmodule.JSP_SEGMENT12_ID.value;
                    var seg13 = document.frmmodule.JSP_SEGMENT13_ID.value;                      
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7+";"+seg8+";"+seg9+";"+seg10+";"+seg11+";"+seg12+";"+seg13;
                    break;  
                    case '14' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                    var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                    var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                    var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                    var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                    var seg12 = document.frmmodule.JSP_SEGMENT12_ID.value;
                    var seg13 = document.frmmodule.JSP_SEGMENT13_ID.value;
                    var seg14 = document.frmmodule.JSP_SEGMENT14_ID.value;                      
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7+";"+seg8+";"+seg9+";"+seg10+";"+seg11+";"+seg12+";"+seg13+";"+seg14;
                    break;
                    case '15' :
                    var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                    var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                    var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                    var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                    var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                    var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                    var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                    var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                    var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                    var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                    var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                    var seg12 = document.frmmodule.JSP_SEGMENT12_ID.value;
                    var seg13 = document.frmmodule.JSP_SEGMENT13_ID.value;
                    var seg14 = document.frmmodule.JSP_SEGMENT14_ID.value;
                    var seg15 = document.frmmodule.JSP_SEGMENT15_ID.value;                      
                    val = seg1+";"+seg2+";"+seg3+";"+seg4+";"+seg5+";"+seg6+";"+seg7+";"+seg8+";"+seg9+";"+seg10+";"+seg11+";"+seg12+";"+seg13+";"+seg14+";"+seg15;
                    break;    
                } 
                
                var result = actPeriodId + ";"+val;
                
                <%if (privUpdate) {%>
                document.frmmodule.hidden_module_id.value=oidModule;                
                document.frmmodule.hidden_var.value=result;
                document.frmmodule.hidden_code.value=1;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
                <%}%>
            }
            
            function cmdCancel(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdBack(){
                document.frmmodule.command.value="<%=JSPCommand.BACK%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListFirst(){
                document.frmmodule.command.value="<%=JSPCommand.FIRST%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListPrev(){
                document.frmmodule.command.value="<%=JSPCommand.PREV%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();                
            }
            
            function cmdListNext(){
                document.frmmodule.command.value="<%=JSPCommand.NEXT%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListLast(){
                document.frmmodule.command.value="<%=JSPCommand.LAST%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmmodule.action="moduleg.jsp";
                document.frmmodule.submit();
            }
            
            function cmdToEditor(){                
                document.frmmodule.hidden_module_id.value=0;
                document.frmmodule.command.value="<%=JSPCommand.ADD%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }	
            
            function cmdPrintXls(activityPeriodId,jenisActv,segment){                
                pathUrl = "<%=printroot%>.report.RptModuleXLS?activity_period_id="+activityPeriodId+"&jenisAct="+jenisActv+"&segment="+segment;
                window.open(pathUrl,"",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdPrintPdf(activityPeriodId,jenisActv,segment){                
                pathUrl = "<%=printroot%>.report.RptModulePdf?activity_period_id="+activityPeriodId+"&jenAkt="+jenisActv+"&segment="+segment;
                window.open(pathUrl,"",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            //-------------- script control line -------------------
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_findObj(n, d) { //v4.0
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && document.getElementById) x=document.getElementById(n); return x;
            }
            
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/printxls2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" -->  
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --> 
                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmmodule" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_module_id" value="<%=oidModule%>">
                                                            <input type="hidden" name="hidden_var" value="<%=var%>">
                                                            <input type="hidden" name="hidden_code" value="<%=code%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="buttom"> 
                                                                                            <td height="15" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr > 
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                        <td class="tab"> 
                                                                                                            <div align="center">&nbsp;&nbsp;Records&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tabin"> 
                                                                                                            <div align="center"> 
                                                                                                                <%if (isOpen && iJSPCommand != JSPCommand.NONE) {%>
                                                                                                                &nbsp;&nbsp;<a href="javascript:cmdToEditor()" class="tablink">Editor</a>&nbsp;&nbsp; 
                                                                                                                <%} else {%>
                                                                                                                <b>Editor</b> 
                                                                                                                <%}%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="20" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="400px">
                                                                                                    <tr> 
                                                                                                        <td width="28%"><%=langNav[2]%></td>
                                                                                                        <td width="2%">:</td>
                                                                                                        <td width="70%"> 
                                                                                                            <%
            Vector actPeriods = DbActivityPeriod.list(0, 0, "", "");
                                                                                                            %>
                                                                                                            <select name="activity_period_id">
                                                                                                                <%if (actPeriods != null && actPeriods.size() > 0) {
                for (int i = 0; i < actPeriods.size(); i++) {
                    ActivityPeriod ap = (ActivityPeriod) actPeriods.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=ap.getOID()%>" <%if (ap.getOID() == activityPeriodId) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                                                <%
                }
            }
                                                                                                                %>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
            if (vSeg != null && vSeg.size() > 0) {

                User usr = new User();
                try {
                    usr = DbUser.fetch(appSessUser.getUserOID());
                } catch (Exception e) {
                }

                for (int xs = 0; xs < vSeg.size(); xs++) {

                    Segment oSegment = (Segment) vSeg.get(xs);
                    int pgs = xs + 1;
                    long seg_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pgs + "_ID");

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="28%"><%=oSegment.getName()%></td>
                                                                                                        <td width="2%">:</td>
                                                                                                        <td width="70%"> 
                                                                                                            <%
                                                                                                            String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + oSegment.getOID();
                                                                                                            boolean isAll = false;

                                                                                                            switch (xs + 1) {
                                                                                                                case 1:
                                                                                                                    //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                                                                                                                    //maka akan di tampikan sesuai dengan segment yang ditentukan
                                                                                                                    if (usr.getSegment1Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment1Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }

                                                                                                                    break;
                                                                                                                case 2:
                                                                                                                    if (usr.getSegment2Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment2Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 3:
                                                                                                                    if (usr.getSegment3Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment3Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 4:
                                                                                                                    if (usr.getSegment4Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment4Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 5:
                                                                                                                    if (usr.getSegment5Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment5Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 6:
                                                                                                                    if (usr.getSegment6Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment6Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 7:
                                                                                                                    if (usr.getSegment7Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment7Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 8:
                                                                                                                    if (usr.getSegment8Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment8Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 9:
                                                                                                                    if (usr.getSegment9Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment9Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 10:
                                                                                                                    if (usr.getSegment10Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment10Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 11:
                                                                                                                    if (usr.getSegment11Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment11Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 12:
                                                                                                                    if (usr.getSegment12Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment12Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 13:
                                                                                                                    if (usr.getSegment13Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment13Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 14:
                                                                                                                    if (usr.getSegment14Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment14Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 15:
                                                                                                                    if (usr.getSegment15Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment15Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                            }
                                                                                                            Vector segDet = DbSegmentDetail.list(0, 0, wh, "");
                                                                                                            %>
                                                                                                            <select name="JSP_SEGMENT<%=xs + 1%>_ID" >
                                                                                                                <%if (isAll) {%>	
                                                                                                                <option value="0">ALL</option>
                                                                                                                <%}%>
                                                                                                                <%if (actPeriods != null && actPeriods.size() > 0) {
                                                                                                                for (int i = 0; i < segDet.size(); i++) {
                                                                                                                    SegmentDetail ap = (SegmentDetail) segDet.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=ap.getOID()%>" <%if (ap.getOID() == seg_id) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                                                <%
                                                                                                                }
                                                                                                            }
                                                                                                                %>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
                }
            }
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="28%"><%=langMD[8]%></td>
                                                                                                        <td width="2%">:</td>
                                                                                                        <td width="70%"> 
                                                                                                            <select name="doc_status">                                                                                                                
                                                                                                                <option value="0" <%if (docStatus == 0) {%>selected<%}%>>DRAFT</option>
                                                                                                                <option value="1" <%if (docStatus == 1) {%>selected<%}%>>APPROVED</option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3"> 
                                                                                                <a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/search2.gif',1)"><img src="../images/search.gif" name="post" height="21" border="0" width="59"></a> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="20" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <%if (iJSPCommand == JSPCommand.NONE) {%>
                                                                                        <tr> 
                                                                                            <td height="22" valign="middle" class="page"> 
                                                                                                <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td class="tablecell1" ><%=langNav[4]%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
            try {
                if (listModule != null && listModule.size() > 0) {
                    double totBudget = 0;
                    double budget = 0;
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3"> 
                                                                                                <table width="120%" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="2%" class="tablehdr"><%=langMD[0]%></td>
                                                                                                        <td width="7%" class="tablehdr"><%=(lang == LANG_ID) ? "Kode" : "Code"%></td>
                                                                                                        <td width="18%" class="tablehdr"><%=langMD[1]%></td>
                                                                                                        <td width="10%" class="tablehdr"><%=langMD[2]%></td>
                                                                                                        <td width="6%" class="tablehdr"><%=langMD[3]%></td>
                                                                                                        <td width="10%" class="tablehdr"><%=langMD[4]%></td>
                                                                                                        <td width="6%" class="tablehdr"><%=langMD[5]%></td>
                                                                                                        <td width="6%" class="tablehdr"><%=langMD[6]%></td>
                                                                                                        <td width="11%" class="tablehdr"><%=langMD[7]%></td>
                                                                                                        <td width="24%" class="tablehdr">Perkiraan</td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                int pages = start + 1;
                                                                                                String idr = "Rp.";
                                                                                                try {
                                                                                                    idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                for (int i = 0; i < listModule.size(); i++) {

                                                                                                    Module modules = (Module) listModule.get(i);

                                                                                                    String mdBudget = "";
                                                                                                    double totalBud = 0;

                                                                                                    Vector vMb = DbModuleBudget.list(0, 0, DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID] + "=" + modules.getOID(), null);

                                                                                                    if (vMb != null && vMb.size() > 0) {
                                                                                                    %>
                                                                                                    <%
                                                                                                            for (int x = 0; x < vMb.size(); x++) {

                                                                                                                ModuleBudget mb = (ModuleBudget) vMb.get(x);

                                                                                                                String currency = "";
                                                                                                                try {
                                                                                                                    Currency objCur = DbCurrency.fetchExc(mb.getCurrencyId());
                                                                                                                    currency = objCur.getCurrencyCode();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                                totalBud = totalBud + mb.getAmount();
                                                                                                                if (x != 0) {
                                                                                                                    mdBudget = mdBudget + " <BR> ";
                                                                                                                }
                                                                                                                mdBudget = mdBudget + mb.getDescription() + " = " + currency + "" + JSPFormater.formatNumber(mb.getAmount(), "#,###.##");

                                                                                                            }

                                                                                                            mdBudget = mdBudget + "<BR><BR> <B>TOTAL = " + idr + "" + JSPFormater.formatNumber(totalBud, "#,###.##") + "</B>";
                                                                                                            budget = budget + totalBud;
                                                                                                    %>
                                                                                                    <%
                                                                                                        }

                                                                                                        //Tokenizer untuk Sasaran
                                                                                                        String outputDeliver = "";
                                                                                                        StringTokenizer strTokenizerOutputDeliver = new StringTokenizer(modules.getOutputDeliver(), ";");

                                                                                                        int countOut = 0;

                                                                                                        while (strTokenizerOutputDeliver.hasMoreTokens()) {

                                                                                                            if (countOut != 0) {
                                                                                                                outputDeliver = outputDeliver + "<BR>";
                                                                                                            }

                                                                                                            outputDeliver = outputDeliver + strTokenizerOutputDeliver.nextToken();
                                                                                                            countOut++;
                                                                                                        }
                                                                                                        //=== END Tokenizer untuk Sasaran ===

                                                                                                        //Tokenizer untuk action Day
                                                                                                        String actDays = "";
                                                                                                        StringTokenizer strTokenizerDays = new StringTokenizer(modules.getActDay(), ";");

                                                                                                        int countDays = 0;

                                                                                                        while (strTokenizerDays.hasMoreTokens()) {

                                                                                                            if (countDays != 0) {
                                                                                                                actDays = actDays + "<BR>";
                                                                                                            }

                                                                                                            actDays = actDays + strTokenizerDays.nextToken();
                                                                                                            countDays++;
                                                                                                        }
                                                                                                        //=== END Tokenizer untuk act day ===

                                                                                                        //Tokenizer untuk Date
                                                                                                        String date = "";
                                                                                                        StringTokenizer strTokenizerDate = new StringTokenizer(modules.getActDate(), ";");

                                                                                                        int countDate = 0;

                                                                                                        while (strTokenizerDate.hasMoreTokens()) {

                                                                                                            if (countDate != 0) {
                                                                                                                date = date + "<BR>";
                                                                                                            }

                                                                                                            date = date + strTokenizerDate.nextToken();
                                                                                                            countDate++;
                                                                                                        }
                                                                                                        //=== END Tokenizer untuk date

                                                                                                        //Tokenizer untuk Time
                                                                                                        String time = "";
                                                                                                        StringTokenizer strTokenizerTime = new StringTokenizer(modules.getActTime(), ";");

                                                                                                        int countTime = 0;

                                                                                                        while (strTokenizerTime.hasMoreTokens()) {

                                                                                                            if (countTime != 0) {
                                                                                                                time = time + "<BR>";
                                                                                                            }

                                                                                                            time = time + strTokenizerTime.nextToken();
                                                                                                            countTime++;
                                                                                                        }
                                                                                                        //=== END Tokenizer untuk time

                                                                                                        //Tokenizer untuk Keterangan
                                                                                                        String note = "";
                                                                                                        StringTokenizer strTokenizerNote = new StringTokenizer(modules.getNote(), ";");

                                                                                                        int countNote = 0;

                                                                                                        while (strTokenizerNote.hasMoreTokens()) {

                                                                                                            if (countNote != 0) {
                                                                                                                note = note + "<BR>";
                                                                                                            }

                                                                                                            note = note + strTokenizerNote.nextToken();
                                                                                                            countNote++;
                                                                                                        }
                                                                                                        //=== END Tokenizer untuk keterangan

                                                                                                        String str = "";

                                                                                                        switch (modules.getModuleLevel()) {
                                                                                                            case 1:
                                                                                                                break;
                                                                                                            case 2:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                            case 3:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                            case 4:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                            case 5:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                            case 6:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                        }

                                                                                                        //Tokenizer untuk Description
                                                                                                        String description = "";
                                                                                                        StringTokenizer strTokenizerDescription = new StringTokenizer(modules.getDescription(), ";");

                                                                                                        int countDesc = 0;

                                                                                                        while (strTokenizerDescription.hasMoreTokens()) {

                                                                                                            if (countDesc != 0) {
                                                                                                                description = description + "<BR>";
                                                                                                            }

                                                                                                            description = description + strTokenizerDescription.nextToken();
                                                                                                            countDesc++;
                                                                                                        }
                                                                                                        //=== END Tokenizer untuk Description ===

                                                                                                    %>
                                                                                                    <%if (i % 2 == 0) {%>
                                                                                                    <tr> 
                                                                                                        <td width="2%" class="tablecell" valign="top" align="center"><%=pages%></td>
                                                                                                        <td width="7%" class="tablecell" valign="top" nowrap><%=modules.getCode()%></td>
                                                                                                        <td width="18%" class="tablecell" valign="top">
                                                                                                            <%if (isOpen) {%>
                                                                                                            <a href="javascript:cmdEdit('<%=modules.getOID()%>','<%=vSeg.size()%>','<%=activityPeriodId%>')" >
                                                                                                                <%}%>                                                   
                                                                                                                <%=description%> 
                                                                                                        <%if (isOpen) {%></a><%}%></td>
                                                                                                        <td width="10%" class="tablecell" valign="top"><%= outputDeliver %></td>
                                                                                                        <td width="6%" class="tablecell" valign="top"><%= actDays %></td>
                                                                                                        <td width="10%" class="tablecell" valign="top"><%= date%></td>
                                                                                                        <td width="6%" class="tablecell" valign="top"><%= time%></td>
                                                                                                        <td width="6%" class="tablecell" valign="top"><%= note%></td>
                                                                                                        <td width="11%" class="tablecell" valign="top"><%=mdBudget%></td>
                                                                                                        <td width="24%" class="tablecell" valign="top"> 
                                                                                                            <% if (vMb != null && vMb.size() > 0) {%>
                                                                                                            <table width="300" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr> 
                                                                                                                    <td width="130" class="tablehdr">Akun Perkiraan</td>
                                                                                                                    <td width="100" class="tablehdr">keterangan</td>
                                                                                                                    <td width="70" class="tablehdr">Anggaran</td>
                                                                                                                </tr>
                                                                                                                <%
     for (int x = 0; x < vMb.size(); x++) {
         ModuleBudget mb = (ModuleBudget) vMb.get(x);
         Coa coabg = new Coa();

         try {
             coabg = DbCoa.fetchExc(mb.getCoaId());
         } catch (Exception e) {
         }
         totBudget = totBudget + mb.getAmount();

                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td><%=coabg.getCode()%> - <%=coabg.getName()%></td>
                                                                                                                    <td><%=mb.getDescription()%></td>
                                                                                                                    <td><%=JSPFormater.formatNumber(mb.getAmount(), "#,###.##")%></td>
                                                                                                                </tr>
                                                                                                                <%
     }
                                                                                                                %>
                                                                                                            </table>
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td width="2%" class="tablecell1" valign="top" align="center"><%=pages%></td>
                                                                                                        <td width="7%" class="tablecell1" valign="top" nowrap><%=modules.getCode()%></td>
                                                                                                        <td width="18%" class="tablecell1" valign="top">
                                                                                                            <%if (isOpen) {%><a href="javascript:cmdEdit('<%=modules.getOID()%>','<%=vSeg.size()%>','<%=activityPeriodId%>')" ><%}%>                                                   
                                                                                                                <%=description%>                                                   
                                                                                                        <%if (isOpen) {%></a><%}%></td>
                                                                                                        <td width="10%" class="tablecell1" valign="top"><%=outputDeliver%></td>
                                                                                                        <td width="6%" class="tablecell1" valign="top"><%=actDays%></td>
                                                                                                        <td width="10%" class="tablecell1" valign="top"><%=date%></td>
                                                                                                        <td width="6%" class="tablecell1" valign="top"><%=time%></td>
                                                                                                        <td width="6%" class="tablecell1" valign="top"><%=note%></td>
                                                                                                        <td width="11%" class="tablecell1" valign="top"><%=mdBudget%></td>
                                                                                                        <td width="24%" class="tablecell" valign="top"> 
                                                                                                            <% if (vMb != null && vMb.size() > 0) {%>
                                                                                                            <table width="300" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr> 
                                                                                                                    <td width="130" class="tablehdr">Akun Perkiraan</td>
                                                                                                                    <td width="100" class="tablehdr">keterangan</td>
                                                                                                                    <td width="70" class="tablehdr">Anggaran</td>
                                                                                                                </tr>
                                                                                                                <%
     for (int x = 0; x < vMb.size(); x++) {
         ModuleBudget mb = (ModuleBudget) vMb.get(x);
         Coa coabg = new Coa();

         try {
             coabg = DbCoa.fetchExc(mb.getCoaId());
         } catch (Exception e) {
         }
         totBudget = totBudget + mb.getAmount();
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td><%=coabg.getCode()%> - <%=coabg.getName()%></td>
                                                                                                                    <td><%=mb.getDescription()%></td>
                                                                                                                    <td><%=JSPFormater.formatNumber(mb.getAmount(), "#,###.##")%></td>                                                      
                                                                                                                </tr>
                                                                                                                <%
     }
                                                                                                                %>
                                                                                                            </table>
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%
                                                                                                    pages++;
                                                                                                }
                                                                                                    %>
                                                                                                    
                                                                                                    <tr>
                                                                                                        <td colspan="8" class="tablehdr"><b>TOTAL</b></td>
                                                                                                        <td class="tablehdr"><b><%=idr%><%=JSPFormater.formatNumber(budget,"###,###.##")%></b></td>
                                                                                                        <td class="tablehdr" align="right"><b><%=idr%><%=JSPFormater.formatNumber(totBudget,"###,###.##")%></b></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <%if (iJSPCommand != 0) {%>
                                                                                        <tr> 
                                                                                            <td height="22" valign="middle" class="page"> 
                                                                                                <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td class="tablecell1" ><%=langNav[3]%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                        <%} catch (Exception exc) {
            }%>
                                                                                        <tr> 
                                                                                            <td >&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command" valign="top"> 
                                                                                                <span class="command"> 
                                                                                                    <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevJSPCommand;
                }
            }
                                                                                                    %>
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="15">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <%if (isOpen) {%>
                                                                                                        <td width="100">
                                                                                                            
                                                                                                        <a href="javascript:cmdToEditor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td><%}%>                                               
                                                                                                        <%
            if (listModule != null && listModule.size() > 0) {
%>
                                                                                                        <td width="80">
                                                                                                            <a href="javascript:cmdPrintXls('<%=activityPeriodId%>','<%=jenAktifitas%>','<%=oidMd%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="new211" height="22" border="0"></a>                                                    
                                                                                                        </td>
                                                                                                        <td width="80">
                                                                                                            <a href="javascript:cmdPrintPdf('<%=activityPeriodId%>','<%=jenAktifitas%>','<%=oidMd%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/print2.gif',1)"><img src="../images/print.gif" name="new2" height="22" border="0"></a>                                                    
                                                                                                        </td>
                                                                                                        <%
            }
                                                                                                        %>
                                                                                                        <td width="40">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                    <!-- #EndEditable --> </td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate -->
</html>
