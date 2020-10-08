<% 
/*******************************************************************
 *  eka
 *******************************************************************/
%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.activity.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean glPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_NEWGL);
%>
<!-- Jsp Block -->
<%!

	public Vector addNewDetail(Vector listGlActivity, TransactionActivityDetail activityDetail){
		try{
			boolean found = false;
			//diblok sementara
			if(listGlActivity!=null && listGlActivity.size()>0){
				for(int i=0; i<listGlActivity.size(); i++){
					TransactionActivityDetail cr = (TransactionActivityDetail)listGlActivity.get(i);
					//if(cr.getType()==activityDetail.getType() && cr.getModuleId()==activityDetail.getModuleId() && cr.getDonorId()==activityDetail.getDonorId()){
					if(activityDetail.getIsDirect()==cr.getIsDirect() && cr.getType()==activityDetail.getType() && cr.getModuleId()==activityDetail.getModuleId()){
						//jika coa sama dan currency sama lakukan penggabungan					
						//cr.setAmount(cr.getAmount()+activityDetail.getAmount());
						cr.setAmount(cr.getAmount() + activityDetail.getAmount());
						found = true;
					}
				}
			}
			
			if(!found){
				listGlActivity.add(activityDetail);
			}
		}
		catch(Exception e){
			System.out.println(e.toString());
		}
		
		return listGlActivity;
	}
	
	public Vector concatVector(Vector listInvoiceActivity, Vector vctNewActivityDetail, double maxAmount, double maxTrx, double maxActAmountFA, double maxActAmountLog, double maxActAmountMod){
		try{
			System.out.println("maxAmount awal = "+maxAmount);
			System.out.println("maxActAmountMod = "+maxActAmountMod);
			//diblok sementara
			double freeAmount = maxTrx-maxAmount-maxActAmountMod;
			System.out.println("maxTrx = "+maxTrx);
			System.out.println("maxAmount = "+maxAmount);
			System.out.println("maxActAmountMod = "+maxActAmountMod);						
			System.out.println("maxTrx-maxAmount ="+freeAmount);
			System.out.println("maxActAmountFA = "+maxActAmountFA);
			System.out.println("maxActAmountLog = "+maxActAmountLog);
			if(maxActAmountFA>0){
				if(freeAmount>0){
					if(maxActAmountFA>freeAmount){
						maxActAmountFA=freeAmount;
						freeAmount=0;
					}else{
						freeAmount = freeAmount-maxActAmountFA;
					}
				}else{
					maxActAmountFA = 0;
				}
			}
			System.out.println("maxActAmountFA = "+maxActAmountFA);
			
			if(maxActAmountLog>0){
				if(freeAmount>0){
					if(maxActAmountLog>freeAmount){
						maxActAmountLog=freeAmount;
						freeAmount=0;
					}else{
						freeAmount = freeAmount-maxActAmountFA;
					}
				}else{
					maxActAmountLog = 0;
				}
			}
			System.out.println("maxActAmountLog = "+maxActAmountLog);

			if(listInvoiceActivity!=null && listInvoiceActivity.size()>0){
			
				if(vctNewActivityDetail!=null && vctNewActivityDetail.size()>0){		
				
					for(int i=0; i<vctNewActivityDetail.size(); i++){
						
						TransactionActivityDetail cr = (TransactionActivityDetail)vctNewActivityDetail.get(i);
												
						for(int x=0; x<listInvoiceActivity.size(); x++){
						
							TransactionActivityDetail activityDetailx = (TransactionActivityDetail)listInvoiceActivity.get(x);
							
							if(cr.getType()==activityDetailx.getType() && cr.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_FA){
								double oldAmount = 0;
								oldAmount = cr.getAmount();
								cr.setAmount(oldAmount+maxActAmountFA);
								listInvoiceActivity.remove(x);
								break;
							}else if(cr.getType()==activityDetailx.getType() && cr.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_LOG){
								double oldAmount = 0;
								oldAmount = cr.getAmount();
								cr.setAmount(oldAmount+maxActAmountLog);
								listInvoiceActivity.remove(x);
								break;
							}
							
						}
						
					}
					
					listInvoiceActivity.addAll(vctNewActivityDetail);
				}
			}

/*
			if(listInvoiceActivity!=null && listInvoiceActivity.size()>0){
			
				if(vctNewActivityDetail!=null && vctNewActivityDetail.size()>0){		
				
					/*for(int i=0; i<vctNewActivityDetail.size(); i++){
						
						TransactionActivityDetail cr = (TransactionActivityDetail)vctNewActivityDetail.get(i);
												
						for(int x=0; x<listInvoiceActivity.size(); x++){
						
							TransactionActivityDetail activityDetailx = (TransactionActivityDetail)listInvoiceActivity.get(x);
							
							if(cr.getType()==activityDetailx.getType() && cr.getModuleId()==activityDetailx.getModuleId()){// && cr.getDonorId()==activityDetailx.getDonorId()){
								cr.setAmount(cr.getAmount() + activityDetailx.getAmount());
								listInvoiceActivity.remove(x);
								break;
							}
							
						}
						
					}
					
					listInvoiceActivity.addAll(vctNewActivityDetail);
				}
			}
*/			
			else{
				listInvoiceActivity = new Vector();
				listInvoiceActivity.addAll(vctNewActivityDetail);
			}
			
		}
		catch(Exception e){
			System.out.println(e.toString());
		}
		
		return listInvoiceActivity;
	}
	
		
	public Vector concatVectorx(Vector listGlActivity, Vector vctNewActivityDetail){
		try{
			
			//diblok sementara
			if(listGlActivity!=null && listGlActivity.size()>0){
			
				if(vctNewActivityDetail!=null && vctNewActivityDetail.size()>0){		
				
					/*for(int i=0; i<vctNewActivityDetail.size(); i++){
						
						TransactionActivityDetail cr = (TransactionActivityDetail)vctNewActivityDetail.get(i);
												
						for(int x=0; x<listGlActivity.size(); x++){
						
							TransactionActivityDetail activityDetailx = (TransactionActivityDetail)listGlActivity.get(x);
							
							if(cr.getType()==activityDetailx.getType() && cr.getModuleId()==activityDetailx.getModuleId()){// && cr.getDonorId()==activityDetailx.getDonorId()){
								cr.setAmount(cr.getAmount() + activityDetailx.getAmount());
								listGlActivity.remove(x);
								break;
							}
							
						}
						
					}*/
					
					listGlActivity.addAll(vctNewActivityDetail);
				}
			}
			else{
				listGlActivity = new Vector();
				listGlActivity.addAll(vctNewActivityDetail);
			}
			
		}
		catch(Exception e){
			System.out.println(e.toString());
		}
		
		return listGlActivity;
	}
	
	
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				TransactionActivityDetail crd = (TransactionActivityDetail)listx.get(i);
				result = result + crd.getAmount();
			}
		}
		return result;
	}
	
	public double getTotalDetail(Vector listx, int typex){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				GlDetail crd = (GlDetail)listx.get(i);
				
				com.project.fms.master.Coa coa = new com.project.fms.master.Coa();
				try{
					coa = DbCoa.fetchExc(crd.getCoaId());
					
					//kalau expense pada posisi debet - pengeluaran bertambah
					if(crd.getDebet()>0 && (coa.getCoaCategoryId()!=0 && coa.getCoaGroupAliasId()!=0)){
						//debet
						if(typex==0){
							result = result + crd.getDebet();
						}
						//credit
						else{
							result = result + crd.getCredit();
						}
					}
				}
				catch(Exception e){
				}
				
			}
		}
		return result;
	}

%>
<%

//main data

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidGl = JSPRequestValue.requestLong(request, "hidden_glarchive");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");
ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();

//out.println("oidGl : "+oidGl);

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	if(session.getValue("GLACTIVITY_DETAILXX")!=null){
		session.removeValue("GLACTIVITY_DETAILXX");
	}
	//iJSPCommand = JSPCommand.ADD;
	recIdx = -1;
}
//===============================================================

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";
JSPLine ctrLine = new JSPLine();

CmdGl ctrlGl = new CmdGl(request);

Vector listGl = new Vector(1,1);

/*switch statement */
int iErrCodeMain = 0;//ctrlGl.action(iJSPCommand , oidGl);
/* end switch*/
JspGl jspGl = ctrlGl.getForm();

/*count list All Gl*/
int vectSize = DbGl.getCount(whereClause);

Gl gl = new Gl();//ctrlGl.getGl();

try{
	gl = DbGl.fetchExc(oidGl);
}
catch(Exception e){
}


//out.println("gl : "+totalDebet );

String msgStringMain =  "";//ctrlGl.getMessage();

//System.out.println("\n -- start detail session ---\n");

%>
<%

//detail 

//bagian CASH RECEIVE DETAIL
//===================================update============================
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
}
//=====================================================================

//int iJSPCommand = JSPRequestValue.requestJSPCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidTransactionActivityDetail = JSPRequestValue.requestLong(request, "hidden_gl_activity_id");


//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdTransactionActivityDetail ctrlTransactionActivityDetail = new CmdTransactionActivityDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listGlActivity = new Vector(1,1);


//iErrCode = ctrlTransactionActivityDetail.action(iJSPCommand , oidTransactionActivityDetail);

JspTransactionActivityDetail jspTransactionActivityDetail = ctrlTransactionActivityDetail.getForm();

//out.println(jspTransactionActivityDetail.getErrors());

TransactionActivityDetail pettycashActivityDetail = ctrlTransactionActivityDetail.getTransactionActivityDetail();
msgString =  ctrlTransactionActivityDetail.getMessage();

double maxActAmountFA = 0;
double maxActAmountLog = 0;
double maxActAmountMod = 0;
if(session.getValue("GLACTIVITY_DETAILXX")!=null){
	listGlActivity = (Vector)session.getValue("GLACTIVITY_DETAILXX");
	
	//out.println("in meer ...");
	
	if(iJSPCommand!=JSPCommand.SAVE && listGlActivity!=null && listGlActivity.size()>0){
		
		for(int i=0; i<listGlActivity.size(); i++){
		
			//out.println("<br>in meer ..2.");
			
			TransactionActivityDetail xx = (TransactionActivityDetail)listGlActivity.get(i);		

			//if(xx.getIsDirect()==0){
			if(xx.getIsDirect()==0 && xx.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_MODULE){
				//out.println("<br>in meer ..3.");
				
				listGlActivity.remove(i);
				i=i-1;
			}else if(xx.getIsDirect()==1 && xx.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_MODULE){
				Vector activityPredefined = DbGlDetail.getActivityPredefined(gl.getOID());
				System.out.println(activityPredefined);
				if(activityPredefined!=null && activityPredefined.size()>0){
					for(int iz=0; iz<activityPredefined.size(); iz++){
						Vector v = (Vector)activityPredefined.get(iz);
						GlDetail ppd = (GlDetail)v.get(1);
						//System.out.println("ppd = "+ppd.getCoaId());
						if(ppd.getCoaId()==xx.getCoaId()){
							listGlActivity.remove(i);
							i=i-1;
						}
					}
				}			
				//System.out.println("xx = "+xx.getCoaId());			

			}
		}
	}

	//load max fa+log trx
	if(listGlActivity!=null && listGlActivity.size()>0){
		for(int ix=0; ix<listGlActivity.size(); ix++){
			TransactionActivityDetail ppdxx = (TransactionActivityDetail)listGlActivity.get(ix);
			if(ppdxx.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_FA)
				maxActAmountFA = maxActAmountFA + ppdxx.getAmount();
			else if (ppdxx.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_LOG)	
				maxActAmountLog = maxActAmountLog + ppdxx.getAmount();
			else
				maxActAmountMod = maxActAmountMod + ppdxx.getAmount();
		}
	}

}

String wherex = "(account_group='"+I_Project.ACC_GROUP_EXPENSE+"' or account_group='"+I_Project.ACC_GROUP_OTHER_EXPENSE+"') "+
				" and (location_id="+sysLocation.getOID()+" or location_id=0)";

//Vector incomeCoas = DbCoa.list(0,0, wherex, "code");

//Vector currencies = DbCurrency.list(0,0,"", "");

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_PETTY_CASH+"' and location_id="+sysCompany.getSystemLocation(), "");
									  
ExchangeRate eRate = DbExchangeRate.getStandardRate();

Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

//out.println("accountBalance : "+accountBalance);

double balance = 0;

//out.println("listGlActivity : "+listGlActivity);

double totalDetail = 0;//getTotalDetail(listGlActivity);
String where = "";

//balance = totalDebet  - totalDetail; 

//gl.setAmount(totalDetail);

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && iErrCodeMain==0 && recIdx==-1){
	iJSPCommand = JSPCommand.ADD;
	pettycashActivityDetail = new TransactionActivityDetail();
}

Vector modules = DbModule.list(0,0, "activity_period_id="+openAp.getOID(), "code");

Vector donors = DbDonor.list(0,0, "", "");

//count dari input ke database
int cntActivity = DbTransactionActivityDetail.getCount("transaction_id="+oidGl); 
if(cntActivity>0){
	listGlActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+gl.getOID(), "");
}


Vector activityPredefined = DbGlDetail.getActivityPredefined(gl.getOID());

Vector submodules = DbModule.list(0,0, "level='S' and activity_period_id="+openAp.getOID(), "code");

//out.println("<br>activityPredefined :"+activityPredefined);
Vector actSubmit = new Vector();

String error = "";
boolean isOK = true;
double maxAmount = 0;
double maxTrx = 0;
double maxFreeAmount = 0;

if(iJSPCommand==JSPCommand.SAVE){
	//load detail Amount alocated
	if(activityPredefined!=null && activityPredefined.size()>0){
		for(int i=0; i<activityPredefined.size(); i++){
			Vector v = (Vector)activityPredefined.get(i);
			CoaActivityBudget cab = (CoaActivityBudget)v.get(0);
			GlDetail ppd = (GlDetail)v.get(1);
			if(ppd.getDebet()>0){
				maxAmount = maxAmount + ppd.getDebet();
			//}else if(ppd.getCredit()>0){
			//	maxAmount = maxAmount + ppd.getCredit();
			}			
		}
	}
	//load total payment transaction
	Vector listGlActivityX = DbGlDetail.list(0,0, "gl_id="+gl.getOID(), "");

	if(listGlActivityX!=null && listGlActivityX.size()>0){
		for(int ix=0; ix<listGlActivityX.size(); ix++){
			GlDetail ppdx = (GlDetail)listGlActivityX.get(ix);
			if(ppdx.getDebet()>0){
				maxTrx = maxTrx + ppdx.getDebet();
			//}else if(ppdx.getCredit()>0){
			//	maxTrx = maxTrx + ppdx.getCredit();
			}	
			
		}
	}
	System.out.println("MaxTrx = "+maxTrx);
	System.out.println("MaxAmount = "+maxAmount);
	//Amount
	maxFreeAmount = maxTrx - maxAmount;

	if(activityPredefined!=null && activityPredefined.size()>0){
	
		int idx = 0;
	
		for(int i=0; i<activityPredefined.size(); i++){
			Vector v = (Vector)activityPredefined.get(i);
			
			CoaActivityBudget cab = (CoaActivityBudget)v.get(0);
			
			idx = idx + 1;
			
			//out.println("<br>---oid : "+cab.getOID());
			
			double faPercent = JSPRequestValue.requestDouble(request, idx+"_fapercent_"+cab.getOID());
			double faAmount = JSPRequestValue.requestDouble(request, idx+"_faamount_"+cab.getOID());
			
			//out.println("<br>---------------------------");
			//out.println("<br>"+idx+"_fapercent_"+cab.getOID()+" : "+faPercent);
			//out.println("<br>"+idx+"_faamount_"+cab.getOID()+" : "+faAmount);
			
			TransactionActivityDetail ta = new TransactionActivityDetail();
			if(faAmount>0){				
                ta.setTransactionId(oidGl);
                ta.setAmount(faAmount);
                ta.setType(DbTransactionActivityDetail.ACTIVITY_TYPE_FA);
                ta.setIsDirect(0);
                ta.setPercent(faPercent);
				ta.setCoaExpenseCategoryId(0);//cab.getCoaExpenseCategoryId());
				ta.setCoaNatureExpenseCategoryId(0);//cab.getCoaNatureExpenseCategoryId());
				
				actSubmit = addNewDetail(actSubmit, ta);
				//actSubmit.add(ta);
			}
			
			//DbTransactionActivityDetail.insertNonModularActivityDetail(oidGl, DbTransactionActivityDetail.ACTIVITY_TYPE_FA, faAmount, faPercent);
			
			double logPercent = JSPRequestValue.requestDouble(request, idx+"_logpercent_"+cab.getOID());
			double logAmount = JSPRequestValue.requestDouble(request, idx+"_logamount_"+cab.getOID());
			
			//out.println("<br>"+idx+"_logpercent_"+cab.getOID()+" : "+logPercent);
			//out.println("<br>"+idx+"_logamount_"+cab.getOID()+" : "+logAmount);
			
			TransactionActivityDetail ta1 = new TransactionActivityDetail();
			if(logAmount>0){				
                ta1.setTransactionId(oidGl);
                ta1.setAmount(logAmount);
                ta1.setType(DbTransactionActivityDetail.ACTIVITY_TYPE_LOG);
                ta1.setIsDirect(0);
                ta1.setPercent(logPercent);
				ta1.setCoaExpenseCategoryId(0);//cab.getCoaExpenseCategoryId());
				ta1.setCoaNatureExpenseCategoryId(0);//cab.getCoaNatureExpenseCategoryId());
				
				//listInvoiceActivity = addNewDetail(listInvoiceActivity, ta1);
				actSubmit = addNewDetail(actSubmit, ta1);
				//actSubmit.add(ta1);
			}
			
			//DbTransactionActivityDetail.insertNonModularActivityDetail(oidGl, DbTransactionActivityDetail.ACTIVITY_TYPE_LOG, logAmount, logPercent);
			
			//out.println("<br>faPercent : "+faPercent);
			///out.println("<br>faAmount : "+faAmount);
			//out.println("<br>logPercent : "+logPercent);
			//out.println("<br>logAmount : "+logAmount);
						
			Vector vx = new Vector();
			if(submodules!=null && submodules.size()>0){
				
				int idxq = 0;	
			
				for(int ix=0; ix<submodules.size(); ix++){
					Module mx = (Module)submodules.get(ix);
					
					idxq = idxq + 1;
					
					where = "module_id="+mx.getOID()+" and coa_activity_budget_id="+cab.getOID();
					vx = DbCoaActivityBudgetDetail.list(0,0, where, "");
					CoaActivityBudgetDetail cabd = new CoaActivityBudgetDetail();
					if(vx!=null && vx.size()>0){
						cabd = (CoaActivityBudgetDetail)vx.get(0);
						if(cabd.getPercent()>0){
							double modulePercent = JSPRequestValue.requestDouble(request, idx+""+idxq+"_modulepercent_"+cabd.getOID());
							double moduleAmount = JSPRequestValue.requestDouble(request, idx+""+idxq+"_moduleamount_"+cabd.getOID());
							long moduleIdx = JSPRequestValue.requestLong(request, idx+""+idxq+"_moduleactivity_"+cabd.getOID());
							
							//out.println("<br>"+idx+""+idxq+"_modulepercent_"+cabd.getOID()+" : "+modulePercent);
							//out.println("<br>"+idx+""+idxq+"_moduleamount_"+cabd.getOID()+" : "+moduleAmount);
							//out.println("<br>"+idx+""+idxq+"_moduleactivity_"+cabd.getOID()+" : "+moduleIdx);							
							
							if(moduleAmount>0){
								/*Module m = new Module();
								try{
									m = DbModule.fetchExc(moduleIdx);
									if(!(m.getLevel().equals("A") || m.getLevel().equals("SA"))){
										isOK = false;
									}
								}
								catch(Exception e){
								}
								*/
												
								ta1 = new TransactionActivityDetail();
								ta1.setTransactionId(oidGl);
								ta1.setAmount(moduleAmount);
								ta1.setType(DbTransactionActivityDetail.ACTIVITY_TYPE_MODULE);
								ta1.setIsDirect(0);
								ta1.setPercent(modulePercent);
								ta1.setModuleId(cabd.getModuleId());
								ta1.setCoaId(cab.getCoaId());  
								
								Coa coa = new Coa();
								try{
									coa = DbCoa.fetchExc(cab.getCoaId());
								}
								catch(Exception e){
								}
								
								ta1.setCoaExpenseCategoryId(coa.getCoaCategoryId());//cab.getCoaExpenseCategoryId());
								ta1.setCoaNatureExpenseCategoryId(coa.getCoaGroupAliasId());//cab.getCoaNatureExpenseCategoryId());  
								
								//listInvoiceActivity = addNewDetail(listInvoiceActivity, ta1);
								actSubmit = addNewDetail(actSubmit, ta1);
								//actSubmit.add(ta1);
							}
														
							
							//out.println("<br>modulePercent : "+modulePercent);
							//out.println("<br>moduleAmount : "+moduleAmount);
							
						}
					}					
					
				}
			}	
		}
	}	
}

//listGlActivity = concatVector(listGlActivity, actSubmit);
listGlActivity = concatVector(listGlActivity, actSubmit, maxAmount, maxTrx, maxActAmountFA, maxActAmountLog, maxActAmountMod);


/*if(!isOK){
	iErrCode = 1;
	error = "Only Activity(A) and Sub Activity(SA) level should in the activity section";	
	if(listGlActivity!=null && listGlActivity.size()>0){
		for(int i=0; i<listGlActivity.size(); i++){
			TransactionActivityDetail tadx = (TransactionActivityDetail)listGlActivity.get(i);
			if(tadx.getIsDirect()==0){
				listGlActivity.remove(i);
				i=i-1;
			}
		}
	}
}*/

Vector listGlDetail = DbGlDetail.list(0,0, "gl_id="+gl.getOID(), "");

double totalDebet = getTotalDetail(listGlDetail, 0);

session.putValue("GLACTIVITY_DETAILXX", listGlActivity);

//out.println("<br>listGlActivity : "+listGlActivity);

%>
<html >
<head>
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!glPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<!--
//=======================================update===========================================================

<%if(iJSPCommand==JSPCommand.SAVE && isOK){%>
	window.location="glactivity.jsp?hidden_gl_id=<%=oidGl%>&command=<%=JSPCommand.ADD%>&select_idx=-1";
<%}%>

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptPCPaymentPDF?oid=<%=appSessUser.getLoginId()%>&pcPayment_id=<%=gl.getOID()%>");
}

function cmdClickIt(){
	document.frmpettycashpaymentdetail.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.select();
}

function cmdGetBalance(){
	
	
}

function cmdFixing(){	
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.POST%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();	
}

function cmdNewJournal(){	
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();	
}

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function removeChar(number){
	
	var ix;
	var result = "";
	for(ix=0; ix<number.length; ix++){
		var xx = number.charAt(ix);
		//alert(xx);
		if(!isNaN(xx)){
			result = result + xx;
		}
		else{
			if(xx==',' || xx=='.'){
				result = result + xx;
			}
		}
	}
	
	return result;
}

function checkNumber(){
	}

function checkNumber2(){
	}

function cmdSubmitCommand(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SAVE%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdGl(oid){
	<%if(cntActivity>0){%>
		document.frmpettycashpaymentdetail.hidden_glarchive.value=oid;
		document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
		document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
		document.frmpettycashpaymentdetail.action="pettycashpaymentdetailprint.jsp";
		document.frmpettycashpaymentdetail.submit();
	<%}else{%>
		alert('Please finish and post activity transaction before go to payment archive');
	<%}%>
	
}

//===============================================================================================

function cmdAdd(){
	document.frmpettycashpaymentdetail.select_idx.value="-1";
	document.frmpettycashpaymentdetail.hidden_gl_id.value="0";
	document.frmpettycashpaymentdetail.hidden_gl_activity_id.value="0";
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdAsk(idx){
	document.frmpettycashpaymentdetail.select_idx.value=idx;
	document.frmpettycashpaymentdetail.hidden_gl_activity_id.value=0;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ASK%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdConfirmDelete(oidTransactionActivityDetail){
	document.frmpettycashpaymentdetail.hidden_gl_activity_id.value=oidTransactionActivityDetail;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.DELETE%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdSave(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdEdit(idxx){
	document.frmpettycashpaymentdetail.select_idx.value=idxx;
	document.frmpettycashpaymentdetail.hidden_gl_activity_id.value=0;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdCancel(oidTransactionActivityDetail){
	document.frmpettycashpaymentdetail.hidden_gl_activity_id.value=oidTransactionActivityDetail;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdBack(oid){
	document.frmpettycashpaymentdetail.hidden_gl_id.value=oid;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmpettycashpaymentdetail.action="glactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListFirst(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListPrev(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListNext(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListLast(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashpaymentdetail.action="glactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidTransactionActivityDetail){
	document.frmimage.hidden_gl_activity_id.value=oidTransactionActivityDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="glactivitypredefined.jsp";
	document.frmimage.submit();
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
//-->
</script>
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','images/first2.gif','../images/print2.gif','../images/saveclose2.gif','../images/cancel2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <%@ include file="../main/hmenu.jsp"%>
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title">
					  <%
					  String navigator = "<font class=\"lvl1\">General Journal</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Activity Predefined</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  </td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td> 
                        <form name="frmpettycashpaymentdetail" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_gl_activity_id" value="<%=oidTransactionActivityDetail%>">
                          <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                          <input type="hidden" name="hidden_glarchive" value="<%=oidGl%>">
                          <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="max_pcash_transaction" value="<%=sysCompany.getMaxPettycashTransaction()%>">
                          <input type="hidden" name="pcash_balance" value="">
                          <%try{%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="4" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="31%">&nbsp;</td>
                                                <td width="32%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspGl.getErrorMsg(jspGl.JSP_OPERATOR_ID) %>&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                              <tr> 
                                                <td width="10%" nowrap>Journal 
                                                  Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="29%"><%=gl.getJournalNumber()%></td>
                                                <td width="11%" nowrap>Transaction 
                                                  Date</td>
                                                <td width="48%"> <b><a id="tot_saldo_akhir"></a><%=JSPFormater.formatDate((gl.getTransDate()==null) ? new Date() : gl.getTransDate(), "dd/MM/yyyy")%></b> </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Reference Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="29%"> <%=gl.getRefNumber()%> </td>
                                                <td width="11%">Amount <%=baseCurrency.getCurrencyCode()%></td>
                                                <td width="48%"><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%> 
                                                  <input type="hidden" name="gl_amount" value="<%=totalDebet%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="12%" align="left"  >Memo</td>
                                                <td width="2%">&nbsp;</td>
                                                <td colspan="3"><%=gl.getMemo()%></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%">&nbsp;</td>
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                          <tr > 
                                                            <td class="tabheader" width="1%"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                            <td class="tab" width="4%" nowrap>Predefined 
                                                              Activity</td>
                                                            <td class="tabheader" width="0%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabheader" width="1%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td width="85%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="13" height="10"> 
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="100%" class="page"> 
                                                              <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                <tr> 
                                                                  <td class="tablehdr" height="20" width="47%"> 
                                                                    <div align="center"><b><font color="#FFFFFF">Expense</font></b></div>
                                                                  </td>
                                                                  <td width="53%" class="tablehdr" height="20">Allocation 
                                                                    Detail </td>
                                                                </tr>
                                                                <%
																//out.println("activityPredefined : "+activityPredefined);
																if(activityPredefined!=null && activityPredefined.size()>0){
																		
																		int idxc = 0;
																	
																		for(int i=0; i<activityPredefined.size(); i++){
																			Vector vx123 = (Vector)activityPredefined.get(i);
																			
																			idxc = idxc + 1;
																			
																			CoaActivityBudget cab = (CoaActivityBudget)vx123.get(0);
																			GlDetail glDetail = (GlDetail)vx123.get(1);
																			
																			double totalAmount = 0;
																			if(glDetail.getDebet()!=0){
																				totalAmount = glDetail.getDebet();
																			}
																			else{
																				totalAmount = glDetail.getCredit();
																			}
																			
																			Coa coa = new Coa();
																			try{
																				coa = DbCoa.fetchExc(cab.getCoaId());
																			}
																			catch(Exception e){
																			}
																			
																			CoaCategory cec = new CoaCategory();
																			try{
																				cec = DbCoaCategory.fetchExc(cab.getCoaExpenseCategoryId());
																			}
																			catch(Exception e){
																			}
																			
																			CoaGroupAlias cnec = new CoaGroupAlias();
																			try{
																				cnec = DbCoaGroupAlias.fetchExc(cab.getCoaNatureExpenseCategoryId());
																			}
																			catch(Exception e){
																			}
																			
																%>
                                                                <tr> 
                                                                  <td width="47%" class="tablecell" height="17" nowrap valign="top"> 
                                                                    <div align="left"><b><%=coa.getCode()+" - "+coa.getName()%> 
                                                                      </b><br>
                                                                      <br>
                                                                    </div>
                                                                    <p align="left"><i>Account 
                                                                      Category 
                                                                      : </i><b><br>
                                                                      <%=cec.getName()%> 
                                                                      </b></p>
                                                                    <p align="left"><i>Account 
                                                                      Group : 
                                                                      </i><b><br>
                                                                      <%=cnec.getName()%> 
                                                                      </b></p>
                                                                    <p align="left"></p>
                                                                    <div align="left"><br>
                                                                    </div>
                                                                  </td>
                                                                  <td width="53%" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <table width="73%" border="0" cellspacing="1" cellpadding="0" align="left">
                                                                        <tr> 
                                                                          <td colspan="4" height="5"> 
                                                                          </td>
                                                                        </tr>
                                                                        <tr> 
                                                                          <td width="3%" height="19">&nbsp;</td>
                                                                          <td width="29%" height="19"><b>Module</b></td>
                                                                          <td width="25%" height="19" nowrap> 
                                                                            <div align="center"><b>Allocation 
                                                                              % 
                                                                              </b></div>
                                                                          </td>
                                                                          <td width="43%" height="19"> 
                                                                            <div align="center"><b>Amount</b></div>
                                                                          </td>
                                                                        </tr>
                                                                        <%if(cab.getAdminPercent()>0){%>
                                                                        <tr> 
                                                                          <td width="3%">&nbsp;</td>
                                                                          <td width="29%">F 
                                                                            &amp; 
                                                                            A&nbsp;</td>
                                                                          <td width="25%"> 
                                                                            <div align="center"> 
                                                                              <%
																		   //out.println("fapercent_"+cab.getOID());
																		   %>
                                                                              <input type="text" name="<%=idxc%>_fapercent_<%=cab.getOID()%>" size="5" maxlength="3" style="text-align:center" value="<%=JSPFormater.formatNumber(cab.getAdminPercent(),"#,###")%>" onClick="this.select()" class="readonly" readOnly>
                                                                            </div>
                                                                          </td>
                                                                          <td width="43%"> 
                                                                            <div align="right"> 
                                                                              <input type="text" name="<%=idxc%>_faamount_<%=cab.getOID()%>" size="25" value="<%=JSPFormater.formatNumber(totalAmount*cab.getAdminPercent()/100, "#,###.##")%>" style="text-align:right" class="readonly" readOnly>
                                                                            </div>
                                                                          </td>
                                                                        </tr>
                                                                        <%}
																	  if(cab.getLogisticPercent()>0){
																	  %>
                                                                        <tr> 
                                                                          <td width="3%">&nbsp;</td>
                                                                          <td width="29%">Logistic&nbsp;&nbsp;</td>
                                                                          <td width="25%"> 
                                                                            <div align="center"> 
                                                                              <input type="text" name="<%=idxc%>_logpercent_<%=cab.getOID()%>" size="5" maxlength="3" style="text-align:center" value="<%=JSPFormater.formatNumber(cab.getLogisticPercent(), "#,###")%>" onClick="this.select()" class="readonly" readOnly>
                                                                            </div>
                                                                          </td>
                                                                          <td width="43%"> 
                                                                            <div align="right"> 
                                                                              <input type="text" name="<%=idxc%>_logamount_<%=cab.getOID()%>" size="25" value="<%=JSPFormater.formatNumber(totalAmount*cab.getLogisticPercent()/100, "#,###.##")%>" style="text-align:right" class="readonly" readOnly>
                                                                            </div>
                                                                          </td>
                                                                        </tr>
                                                                        <%}%>
                                                                        <%
																	  Vector vx12 = new Vector();
																	  if(submodules!=null && submodules.size()>0){
																	  		
																			int idxqq = 0;
																	  
																			for(int ix=0; ix<submodules.size(); ix++){
																				Module mx = (Module)submodules.get(ix);
																				
																				idxqq = idxqq + 1;
																				
																				where = "module_id="+mx.getOID()+" and coa_activity_budget_id="+cab.getOID();
																				vx12 = DbCoaActivityBudgetDetail.list(0,0, where, "");
																				CoaActivityBudgetDetail cabd = new CoaActivityBudgetDetail();
																				if(vx12!=null && vx12.size()>0){
																					cabd = (CoaActivityBudgetDetail)vx12.get(0);
																				}
																				
																				if(cabd.getPercent()>0){
																	  %>
                                                                        <tr> 
                                                                          <td width="3%">&nbsp;</td>
                                                                          <td width="29%"><%=mx.getInitial()%></td>
                                                                          <td width="25%"> 
                                                                            <div align="center"> 
                                                                              <input type="text" name="<%=idxc%><%=idxqq%>_modulepercent_<%=cabd.getOID()%>" size="5" maxlength="3" style="text-align:center" value="<%=JSPFormater.formatNumber(cabd.getPercent(), "#,###")%>" onClick="this.select()" onChange="javascript:cmdUpdateData('504404353099418270', '0')" class="readonly" readOnly>
                                                                            </div>
                                                                          </td>
                                                                          <td width="43%"> 
                                                                            <div align="right"> 
                                                                              <input type="text" name="<%=idxc%><%=idxqq%>_moduleamount_<%=cabd.getOID()%>" size="25" value="<%=JSPFormater.formatNumber(totalAmount*cabd.getPercent()/100, "#,###.##")%>" style="text-align:right" class="readonly" readOnly>
                                                                            </div>
                                                                          </td>
                                                                        </tr>
                                                                        <%}}}%>
                                                                        <tr> 
                                                                          <td width="3%" height="13">&nbsp;</td>
                                                                          <td width="29%" height="13">&nbsp;</td>
                                                                          <td width="25%" height="13"> 
                                                                            <div align="center"></div>
                                                                          </td>
                                                                          <td width="43%" height="13"> 
                                                                            <div align="center"></div>
                                                                          </td>
                                                                        </tr>
                                                                        <tr > 
                                                                          <td height="2" ></td>
                                                                          <td colspan="3" height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                        </tr>
                                                                        <tr> 
                                                                          <td width="3%">&nbsp;</td>
                                                                          <td width="29%">&nbsp;</td>
                                                                          <td width="25%"> 
                                                                            <div align="right"><b>Total 
                                                                              <%=baseCurrency.getCurrencyCode()%> 
                                                                              : 
                                                                              </b></div>
                                                                          </td>
                                                                          <td width="43%"> 
                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalAmount, "#,###.##")%></b></div>
                                                                          </td>
                                                                        </tr>
                                                                        <tr> 
                                                                          <td width="3%">&nbsp;</td>
                                                                          <td width="29%">&nbsp;</td>
                                                                          <td width="25%">&nbsp;</td>
                                                                          <td width="43%">&nbsp;</td>
                                                                        </tr>
                                                                      </table>
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td width="47%" class="tablecell1" height="17"> 
                                                                    <div align="right">&nbsp;&nbsp;</div>
                                                                  </td>
                                                                  <td width="53%" class="tablecell1" height="17">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <%}}%>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr id="command_line"> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td colspan="3" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="43%">&nbsp;</td>
                                                      <td width="46%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="11%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/saveclose2.gif',1)"><img src="../images/saveclose.gif" name="post" width="121" height="22" border="0"></a> 
                                                      </td>
                                                      <td width="43%"><a href="javascript:cmdBack('<%=oidGl%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post1','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="post1" height="23" border="0" width="63"></a></td>
                                                      <td width="46%"> 
                                                        <%if(!isOK){%>
                                                        <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right">
                                                          <tr> 
                                                            <td width="18"><img src="../images/error.gif" width="20" height="20"></td>
                                                            <td width="322" nowrap><%=error%></td>
                                                          </tr>
                                                        </table>
                                                        <%}else{%>
                                                        &nbsp; 
                                                        <%}%>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%if(totalDebet !=0 && iErrCode==0 && iErrCodeMain==0 && balance==0 && cntActivity==0){%>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td height="2">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="8%">&nbsp;</td>
                                                      <td width="60%">&nbsp;</td>
                                                      <td width="32%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                          <table border="0" cellpadding="5" cellspacing="0" class="info" width="220" align="right">
                                                            <tr> 
                                                              <td width="20"><img src="../images/inform.gif" width="20" height="20"></td>
                                                              <td width="200" nowrap>Activity 
                                                                is ready to be posted</td>
                                                            </tr>
                                                          </table>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <%if(cntActivity!=0){%>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td height="2">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="4%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="49%">&nbsp;</td>
                                                      <td width="36%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                          <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                            <tr> 
                                                              <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                              <td width="220">Activity 
                                                                has been posted 
                                                                successfully</td>
                                                            </tr>
                                                          </table>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <tr id="emptymessage"> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="18%">&nbsp;</td>
                                          <td width="28%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="4" class="command">&nbsp; </td>
                            </tr>
                          </table>
                          <%}
				catch(Exception e){
					out.println(e.toString());
				}%>
                          <script language="JavaScript">
				//cmdGetBalance();
				
				<%if(iErrCode!=0 || iErrCodeMain!=0 || iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT){%>
				//checkNumber2();
				<%}%>
				</script>
                        </form> </td>
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
          <td height="25"> 
            <%@ include file="../main/footer.jsp"%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
