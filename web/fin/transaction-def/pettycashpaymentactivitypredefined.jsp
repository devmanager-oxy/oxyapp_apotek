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
boolean cashPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT);
%>
<!-- Jsp Block -->
<%!

	public Vector addNewDetail(Vector listPettycashPaymentActivity, TransactionActivityDetail activityDetail){
		try{
			boolean found = false;
			//diblok sementara
			if(listPettycashPaymentActivity!=null && listPettycashPaymentActivity.size()>0){
				for(int i=0; i<listPettycashPaymentActivity.size(); i++){
					TransactionActivityDetail cr = (TransactionActivityDetail)listPettycashPaymentActivity.get(i);
					if(activityDetail.getCoaId()== cr.getCoaId() && activityDetail.getIsDirect()==cr.getIsDirect() && cr.getType()==activityDetail.getType() && cr.getModuleId()==activityDetail.getModuleId()){// && cr.getDonorId()==activityDetail.getDonorId()){
					//if(activityDetail.getCoaId()== cr.getCoaId()){
						//jika coa sama dan currency sama lakukan penggabungan					
						//cr.setAmount(cr.getAmount()+activityDetail.getAmount());
						cr.setAmount(cr.getAmount() + activityDetail.getAmount());
						found = true;
					}
				}
			}
			
			if(!found){
				listPettycashPaymentActivity.add(activityDetail);
			}
		}
		catch(Exception e){
			System.out.println(e.toString());
		}
		
		return listPettycashPaymentActivity;
	}
	
	public Vector concatVector(Vector listPettycashPaymentActivity, Vector vctNewActivityDetail, double maxAmount, double maxTrx, double maxActAmountFA, double maxActAmountLog, double maxActAmountMod){
		try{
			System.out.println("maxAmount awal = "+maxAmount);
			//diblok sementara
			double freeAmount = maxTrx-maxAmount-maxActAmountMod;
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
			
			if(listPettycashPaymentActivity!=null && listPettycashPaymentActivity.size()>0){
			
				if(vctNewActivityDetail!=null && vctNewActivityDetail.size()>0){		
				
					for(int i=0; i<vctNewActivityDetail.size(); i++){
						
						TransactionActivityDetail cr = (TransactionActivityDetail)vctNewActivityDetail.get(i);
												
						for(int x=0; x<listPettycashPaymentActivity.size(); x++){
						
							TransactionActivityDetail activityDetailx = (TransactionActivityDetail)listPettycashPaymentActivity.get(x);
							
							if(cr.getType()==activityDetailx.getType() && cr.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_FA){
								double oldAmount = 0;
								oldAmount = cr.getAmount();
								cr.setAmount(oldAmount+maxActAmountFA);
								listPettycashPaymentActivity.remove(x);
								break;
							}else if(cr.getType()==activityDetailx.getType() && cr.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_LOG){
								double oldAmount = 0;
								oldAmount = cr.getAmount();
								cr.setAmount(oldAmount+maxActAmountLog);
								listPettycashPaymentActivity.remove(x);
								break;
							}
							
						}
						
					}
					
					listPettycashPaymentActivity.addAll(vctNewActivityDetail);
				}
			}
			else{
				listPettycashPaymentActivity = new Vector();
				listPettycashPaymentActivity.addAll(vctNewActivityDetail);
			}
			
		}
		catch(Exception e){
			System.out.println(e.toString());
		}
		
		return listPettycashPaymentActivity;
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

%>
<%

//main data

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPettycashPayment = JSPRequestValue.requestLong(request, "hidden_casharchive");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");
ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();

//out.println("oidPettycashPayment : "+oidPettycashPayment);

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	if(session.getValue("PPACTIVITY_DETAILX")!=null){
		session.removeValue("PPACTIVITY_DETAILX");
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

CmdPettycashPayment ctrlPettycashPayment = new CmdPettycashPayment(request);

Vector listPettycashPayment = new Vector(1,1);

/*switch statement */
int iErrCodeMain = 0;//ctrlPettycashPayment.action(iJSPCommand , oidPettycashPayment);
/* end switch*/
JspPettycashPayment jspPettycashPayment = ctrlPettycashPayment.getForm();

/*count list All PettycashPayment*/
int vectSize = DbPettycashPayment.getCount(whereClause);

PettycashPayment pettycashPayment = new PettycashPayment();//ctrlPettycashPayment.getPettycashPayment();

try{
	pettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
}
catch(Exception e){
}

//out.println("pettycashPayment : "+pettycashPayment.getAmount());

String msgStringMain =  "";//ctrlPettycashPayment.getMessage();

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
long oidTransactionActivityDetail = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_activity_id");


//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdTransactionActivityDetail ctrlTransactionActivityDetail = new CmdTransactionActivityDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listPettycashPaymentActivity = new Vector(1,1);


//iErrCode = ctrlTransactionActivityDetail.action(iJSPCommand , oidTransactionActivityDetail);

JspTransactionActivityDetail jspTransactionActivityDetail = ctrlTransactionActivityDetail.getForm();

//out.println(jspTransactionActivityDetail.getErrors());

TransactionActivityDetail pettycashActivityDetail = ctrlTransactionActivityDetail.getTransactionActivityDetail();
msgString =  ctrlTransactionActivityDetail.getMessage();

double maxActAmountFA = 0;
double maxActAmountLog = 0;
double maxActAmountMod = 0;
if(session.getValue("PPACTIVITY_DETAILX")!=null){
	listPettycashPaymentActivity = (Vector)session.getValue("PPACTIVITY_DETAILX");
	
	//out.println("in meer ...");
	
	if(iJSPCommand!=JSPCommand.SAVE && listPettycashPaymentActivity!=null && listPettycashPaymentActivity.size()>0){
		for(int i=0; i<listPettycashPaymentActivity.size(); i++){
		
			//out.println("<br>in meer ..2.");
			
			TransactionActivityDetail xx = (TransactionActivityDetail)listPettycashPaymentActivity.get(i);
			//if(xx.getIsDirect()==0){
			if(xx.getIsDirect()==0 && xx.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_MODULE){
				//out.println("<br>in meer ..3.");
				//diblok dulu
				listPettycashPaymentActivity.remove(i);
				i=i-1;
			}else if(xx.getIsDirect()==1 && xx.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_MODULE){
				Vector activityPredefined = DbPettycashPaymentDetail.getActivityPredefined(pettycashPayment.getOID());
				System.out.println(activityPredefined);
				if(activityPredefined!=null && activityPredefined.size()>0){
					for(int iz=0; iz<activityPredefined.size(); iz++){
						Vector v = (Vector)activityPredefined.get(iz);
						PettycashPaymentDetail ppd = (PettycashPaymentDetail)v.get(1);
						//System.out.println("ppd = "+ppd.getCoaId());
						if(ppd.getCoaId()==xx.getCoaId()){
							listPettycashPaymentActivity.remove(i);
							i=i-1;
						}
					}
				}			
				//System.out.println("xx = "+xx.getCoaId());			
				
			}
		}
	}

	//load max fa+log trx
	if(listPettycashPaymentActivity!=null && listPettycashPaymentActivity.size()>0){
		for(int ix=0; ix<listPettycashPaymentActivity.size(); ix++){
			TransactionActivityDetail ppdxx = (TransactionActivityDetail)listPettycashPaymentActivity.get(ix);
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

//out.println("listPettycashPaymentActivity : "+listPettycashPaymentActivity);

double totalDetail = 0;//getTotalDetail(listPettycashPaymentActivity);
String where = "";

balance = pettycashPayment.getAmount() - totalDetail; 

//pettycashPayment.setAmount(totalDetail);

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && iErrCodeMain==0 && recIdx==-1){
	iJSPCommand = JSPCommand.ADD;
	pettycashActivityDetail = new TransactionActivityDetail();
}

Vector modules = DbModule.list(0,0, "activity_period_id="+openAp.getOID(), "code");

Vector donors = DbDonor.list(0,0, "", "");

//count dari input ke database
int cntActivity = DbTransactionActivityDetail.getCount("transaction_id="+oidPettycashPayment); 
if(cntActivity>0){
	listPettycashPaymentActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+pettycashPayment.getOID(), "");	
}

Vector activityPredefined = DbPettycashPaymentDetail.getActivityPredefined(pettycashPayment.getOID());
/*
long prevId = 0;
double oldAmountX = 0;
double totalX = 0;
for(int i123 = 0; i123<activityPredefined.size(); i123++){ 
	Vector v = (Vector)activityPredefined.get(i123);	
	PettycashPaymentDetail ppd = (PettycashPaymentDetail)v.get(1);
	try{
		if(ppd.getCoaId()==prevId){
			ppd.setAmount(oldAmountX+ppd.getAmount());
			activityPredefined.remove(i123);
			totalX = oldAmountX+ppd.getAmount();			
		}
	}
	catch(Exception e){
	}
	prevId = ppd.getCoaId();
	oldAmountX = ppd.getAmount();
}
System.out.println(totalX);
*/


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
			PettycashPaymentDetail ppd = (PettycashPaymentDetail)v.get(1);
			maxAmount = maxAmount + ppd.getAmount();
		}
	}
	//load total payment transaction
	Vector listPettycashPaymentX = DbPettycashPaymentDetail.list(0,0, "pettycash_payment_id="+pettycashPayment.getOID(), "");	
	if(listPettycashPaymentX!=null && listPettycashPaymentX.size()>0){
		for(int ix=0; ix<listPettycashPaymentX.size(); ix++){
			PettycashPaymentDetail ppdx = (PettycashPaymentDetail)listPettycashPaymentX.get(ix);
			maxTrx = maxTrx + ppdx.getAmount();
		}
	}
	System.out.println("MaxTrx = "+maxTrx);
	System.out.println("MaxAmount = "+maxAmount);
	//Amount
	maxFreeAmount = maxTrx - maxAmount;
	System.out.println("Total Activity Perdifined = "+activityPredefined.size());
	if(activityPredefined!=null && activityPredefined.size()>0){
		for(int i=0; i<activityPredefined.size(); i++){
			System.out.println("Number Activity Perdifined = "+i);
			Vector v = (Vector)activityPredefined.get(i);
			
			CoaActivityBudget cab = (CoaActivityBudget)v.get(0);
			
			//out.println("<br>---oid : "+cab.getOID());
			
			double faPercent = JSPRequestValue.requestDouble(request, "fapercent_"+cab.getOID());
			double faAmount = JSPRequestValue.requestDouble(request, "faamount_"+cab.getOID());
			
			TransactionActivityDetail ta = new TransactionActivityDetail();
			if(faAmount>0){				
                ta.setTransactionId(oidPettycashPayment);
                ta.setAmount(faAmount);
                ta.setType(DbTransactionActivityDetail.ACTIVITY_TYPE_FA);
                ta.setIsDirect(0);
                ta.setPercent(faPercent);
				//ta.setCoaExpenseCategoryId(cab.getCoaExpenseCategoryId());
				//ta.setCoaNatureExpenseCategoryId(cab.getCoaNatureExpenseCategoryId());
				ta.setCoaExpenseCategoryId(0);
				ta.setCoaNatureExpenseCategoryId(0);
				actSubmit = addNewDetail(actSubmit, ta);
				//actSubmit.add(ta);
			}
			
			//DbTransactionActivityDetail.insertNonModularActivityDetail(oidPettycashPayment, DbTransactionActivityDetail.ACTIVITY_TYPE_FA, faAmount, faPercent);
			
			double logPercent = JSPRequestValue.requestDouble(request, "logpercent_"+cab.getOID());
			double logAmount = JSPRequestValue.requestDouble(request, "logamount_"+cab.getOID());
			
			TransactionActivityDetail ta1 = new TransactionActivityDetail();
			if(logAmount>0){				
                ta1.setTransactionId(oidPettycashPayment);
                ta1.setAmount(logAmount);
                ta1.setType(DbTransactionActivityDetail.ACTIVITY_TYPE_LOG);
                ta1.setIsDirect(0);
                ta1.setPercent(logPercent);
				//ta1.setCoaExpenseCategoryId(cab.getCoaExpenseCategoryId());
				//ta1.setCoaNatureExpenseCategoryId(cab.getCoaNatureExpenseCategoryId());
				ta1.setCoaExpenseCategoryId(0);
				ta1.setCoaNatureExpenseCategoryId(0);
				//listPettycashPaymentActivity = addNewDetail(listPettycashPaymentActivity, ta1);
				actSubmit = addNewDetail(actSubmit, ta1);
				//actSubmit.add(ta1);
			}
			
			//DbTransactionActivityDetail.insertNonModularActivityDetail(oidPettycashPayment, DbTransactionActivityDetail.ACTIVITY_TYPE_LOG, logAmount, logPercent);
			
			//out.println("<br>faPercent : "+faPercent);
			///out.println("<br>faAmount : "+faAmount);
			//out.println("<br>logPercent : "+logPercent);
			//out.println("<br>logAmount : "+logAmount);
						
			Vector vx = new Vector();
			if(submodules!=null && submodules.size()>0){
				for(int ix=0; ix<submodules.size(); ix++){
					Module mx = (Module)submodules.get(ix);
					
					where = "module_id="+mx.getOID()+" and coa_activity_budget_id="+cab.getOID();
					vx = DbCoaActivityBudgetDetail.list(0,0, where, "");
					CoaActivityBudgetDetail cabd = new CoaActivityBudgetDetail();
					if(vx!=null && vx.size()>0){
						cabd = (CoaActivityBudgetDetail)vx.get(0);
						if(cabd.getPercent()>0){
							double modulePercent = JSPRequestValue.requestDouble(request, "modulepercent_"+cabd.getOID());
							double moduleAmount = JSPRequestValue.requestDouble(request, "moduleamount_"+cabd.getOID());
							long moduleIdx = JSPRequestValue.requestLong(request, "moduleactivity_"+cabd.getOID());
							
							if(moduleAmount>0){
								/*Module m = new Module();
								try{
									m = DbModule.fetchExc(moduleIdx);
									//if(!(m.getLevel().equals("A") || m.getLevel().equals("SA"))){
									//	isOK = false;
									//}
								}
								catch(Exception e){
								}
								*/
												
								ta1 = new TransactionActivityDetail();
								ta1.setTransactionId(oidPettycashPayment);
								ta1.setAmount(moduleAmount);
								ta1.setType(DbTransactionActivityDetail.ACTIVITY_TYPE_MODULE);
								ta1.setIsDirect(0);
								ta1.setPercent(modulePercent);
								ta1.setModuleId(mx.getOID());//moduleIdx);
								ta1.setCoaId(cab.getCoaId()); 
								
								Coa c = new Coa();
								try{
									c = DbCoa.fetchExc(cab.getCoaId());
								}
								catch(Exception e){
								}
								
								ta1.setCoaExpenseCategoryId(c.getCoaCategoryId());
								ta1.setCoaNatureExpenseCategoryId(0);   
								
								//listPettycashPaymentActivity = addNewDetail(listPettycashPaymentActivity, ta1);
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
																	
System.out.println("Total New Activity Perdifined = "+actSubmit.size());																		
listPettycashPaymentActivity = concatVector(listPettycashPaymentActivity, actSubmit, maxAmount, maxTrx, maxActAmountFA, maxActAmountLog, maxActAmountMod);

/*if(!isOK){
	iErrCode = 1;
	error = "Only Activity(A) and Sub Activity(SA) level should in the activity section";	
	if(listPettycashPaymentActivity!=null && listPettycashPaymentActivity.size()>0){
		for(int i=0; i<listPettycashPaymentActivity.size(); i++){
			TransactionActivityDetail tadx = (TransactionActivityDetail)listPettycashPaymentActivity.get(i);
			if(tadx.getIsDirect()==1){
				listPettycashPaymentActivity.remove(i);
				i=i-1;
			}
		}
	}
}*/

session.putValue("PPACTIVITY_DETAILX", listPettycashPaymentActivity);

//out.println("<br>listPettycashPaymentActivity : "+listPettycashPaymentActivity);

%>
<html >
<head>
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
//=======================================update===========================================================

<%if(iJSPCommand==JSPCommand.SAVE && isOK){%>
	window.location="pettycashpaymentactivity.jsp?hidden_pettycash_payment_id=<%=oidPettycashPayment%>&command=<%=JSPCommand.ADD%>&select_idx=-1";
<%}%>

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptPCPaymentPDF?oid=<%=appSessUser.getLoginId()%>&pcPayment_id=<%=pettycashPayment.getOID()%>");
}

function cmdClickIt(){
	document.frmpettycashpaymentdetail.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.select();
}

function cmdGetBalance(){
	
	var x = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_COA_ID]%>.value;
	//alert(x);
	<%if(accountBalance!=null && accountBalance.size()>0){
		for(int i=0; i<accountBalance.size(); i++){
			Coa c = (Coa)accountBalance.get(i);
	%>
		if(x=='<%=c.getOID()%>'){
			document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
			document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);//"<%=c.getOpeningBalance()%>";
			document.frmpettycashpaymentdetail.pcash_balance.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
			<%if(c.getOpeningBalance()<1){%>
				//alert('No account balance to do transaction.');
				document.all.command_line.style.display="none";
				document.all.emptymessage.style.display="";
			<%}else{%>
				document.all.command_line.style.display="";
				document.all.emptymessage.style.display="none";
			<%}%>
		}
	<%}}%>
	
	//checkNumber();
}

function cmdFixing(){	
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.POST%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();	
}

function cmdNewJournal(){	
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
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
	var st = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value;		
	var ab = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>.value;		
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	if(parseFloat(result) > parseFloat(ab)){
		if(parseFloat(ab)<1){
			result = "0";
			//result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			alert("No account balance available,\nCan not continue the transaction.");
		}
		else{
			result = ab;
			//result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			alert("Transaction amount over the account balance");
		}
	}
	
	document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber2(){
	var main = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value;		
	main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var currTotal = document.frmpettycashpaymentdetail.total_detail.value;
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
	var idx = document.frmpettycashpaymentdetail.select_idx.value;
	
	var maxtransaction = document.frmpettycashpaymentdetail.max_pcash_transaction.value;
	var pbalanace = document.frmpettycashpaymentdetail.pcash_balance.value;
	var limit = parseFloat(maxtransaction);
	if(limit > parseFloat(pbalanace)){
		limit = parseFloat(pbalanace);
	}		
	
	var st = document.frmpettycashpaymentdetail.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("result : "+result);
	
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(currTotal) + parseFloat(result);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+limit+", \nsystem will reset the data");
			//result = parseFloat(main)-parseFloat(currTotal);			
			result = "0";//parseFloat(limit)-parseFloat(currTotal);
			//amount = 0;//limit;			
		}
		
		var amount = parseFloat(currTotal) + parseFloat(result);
		
		document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	//edit
	else{
		var editAmount =  document.frmpettycashpaymentdetail.edit_amount.value;
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+limit+", \nsystem will reset the data");
			//result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));			
			result = parseFloat(editAmount);			
			amount = limit;
		}
		
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		
		document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	
	document.frmpettycashpaymentdetail.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
}

function cmdSubmitCommand(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SAVE%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdPettycashPayment(oid){
	<%if(cntActivity>0){%>
		document.frmpettycashpaymentdetail.hidden_casharchive.value=oid;
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
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value="0";
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdAsk(idx){
	document.frmpettycashpaymentdetail.select_idx.value=idx;
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value=0;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ASK%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdConfirmDelete(oidTransactionActivityDetail){
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.DELETE%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdSave(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdEdit(idxx){
	document.frmpettycashpaymentdetail.select_idx.value=idxx;
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value=0;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdCancel(oidTransactionActivityDetail){
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdBack(oid){
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value=oid;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListFirst(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListPrev(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListNext(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListLast(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivitypredefined.jsp";
	document.frmpettycashpaymentdetail.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidTransactionActivityDetail){
	document.frmimage.hidden_pettycash_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="pettycashpaymentactivitypredefined.jsp";
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
					  String navigator = "<font class=\"lvl1\">Petty Cash</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Payment Activity Predefined</span></font>";
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
                          <input type="hidden" name="hidden_pettycash_payment_activity_id" value="<%=oidTransactionActivityDetail%>">
                          <input type="hidden" name="hidden_pettycash_payment_id" value="<%=oidPettycashPayment%>">
                          <input type="hidden" name="hidden_casharchive" value="<%=oidPettycashPayment%>">
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
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_OPERATOR_ID) %>&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                              <tr> 
                                                <td width="10%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%">&nbsp;</td>
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" nowrap>Payment 
                                                  from Account</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"> <b> 
                                                  <%
										Coa coay = new Coa();
										//if(accLinks!=null && accLinks.size()>0){
											//AccLink accLink = (AccLink)accLinks.get(0);																						
											try{
												coay = DbCoa.fetchExc(pettycashPayment.getCoaId());
											}
											catch(Exception e){
											}
										//}%>
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_COA_ID]%>" value="<%=coay.getOID()%>">
                                                  <%=coay.getCode()+ " - "+coay.getName()%> </b></td>
                                                <td width="13%">Journal Number</td>
                                                <td width="38%"> <%=pettycashPayment.getJournalNumber()%></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%">&nbsp; </td>
                                                <td width="13%" height="16">Transaction 
                                                  Date</td>
                                                <td width="38%" height="16"> <%=JSPFormater.formatDate((pettycashPayment.getTransDate()==null) ? new Date() : pettycashPayment.getTransDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="16">Memo</td>
                                                <td width="2%" height="16">&nbsp;</td>
                                                <td width="37%" valign="top"> 
                                                  <%=pettycashPayment.getMemo()%></td>
                                                <td width="13%" height="16">&nbsp;</td>
                                                <td width="38%" height="16">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%" valign="top">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
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
                                                                  <td class="tablehdr" height="23" width="34%"> 
                                                                    <div align="center"><b>Account</b></div>
                                                                  </td>
                                                                  <td width="57%" class="tablehdr" height="23">Allocation 
                                                                    Detail </td>
                                                                </tr>
                                                                <%if(activityPredefined!=null && activityPredefined.size()>0){
																		for(int i=0; i<activityPredefined.size(); i++){
																			Vector v = (Vector)activityPredefined.get(i);
																			CoaActivityBudget cab = (CoaActivityBudget)v.get(0);
																			PettycashPaymentDetail ppd = (PettycashPaymentDetail)v.get(1);
																			
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
                                                                  <td width="34%" class="tablecell" height="17" nowrap valign="top"> 
                                                                    <p><b><%=coa.getCode()+" - "+coa.getName()%></b><br>
                                                                      <br>
                                                                    </p>
                                                                    </td>
                                                                  <td width="57%" class="tablecell" height="17"> 
                                                                    
                                                                      
                                                                    <table width="51%" border="0" cellspacing="1" cellpadding="0">
                                                                      <tr> 
                                                                        <td colspan="4" height="5"> 
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="3%" height="19">&nbsp;</td>
                                                                        <td width="29%" height="19"><b>Module</b></td>
                                                                        <td width="25%" height="19"> 
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
                                                                            <input type="text" name="fapercent_<%=cab.getOID()%>" size="5" maxlength="3" style="text-align:center" value="<%=JSPFormater.formatNumber(cab.getAdminPercent(),"#,###")%>" onClick="this.select()" class="readonly" readOnly>
                                                                          </div>
                                                                        </td>
                                                                        <td width="43%"> 
                                                                          <div align="center"> 
                                                                            <input type="text" name="faamount_<%=cab.getOID()%>" size="25" value="<%=JSPFormater.formatNumber(ppd.getAmount()*cab.getAdminPercent()/100, "#,###")%>" style="text-align:right" class="readonly" readOnly>
                                                                          </div>
                                                                        </td>
                                                                      </tr>
																	  <%}
																	  if(cab.getLogisticPercent()>0){
																	  %>
                                                                      <tr> 
                                                                        <td width="3%">&nbsp;</td>
                                                                        <td width="29%">Logictic&nbsp;&nbsp;</td>
                                                                        <td width="25%"> 
                                                                          <div align="center"> 
                                                                            <input type="text" name="logpercent_<%=cab.getOID()%>" size="5" maxlength="3" style="text-align:center" value="<%=JSPFormater.formatNumber(cab.getLogisticPercent(), "#,###")%>" onClick="this.select()" class="readonly" readOnly>
                                                                          </div>
                                                                        </td>
                                                                        <td width="43%"> 
                                                                          <div align="center"> 
                                                                            <input type="text" name="logamount_<%=cab.getOID()%>" size="25" value="<%=JSPFormater.formatNumber(ppd.getAmount()*cab.getLogisticPercent()/100, "#,###")%>" style="text-align:right" class="readonly" readOnly>
                                                                          </div>
                                                                        </td>
                                                                      </tr>
																	  <%}%>
                                                                      <%
																	  Vector vx = new Vector();
																	  if(submodules!=null && submodules.size()>0){
																			for(int ix=0; ix<submodules.size(); ix++){
																				Module mx = (Module)submodules.get(ix);
																				
																				where = "module_id="+mx.getOID()+" and coa_activity_budget_id="+cab.getOID();
																				vx = DbCoaActivityBudgetDetail.list(0,0, where, "");
																				CoaActivityBudgetDetail cabd = new CoaActivityBudgetDetail();
																				if(vx!=null && vx.size()>0){
																					cabd = (CoaActivityBudgetDetail)vx.get(0);
																				}
																				
																				if(cabd.getPercent()>0){
																	  %>
                                                                      <tr> 
                                                                        <td width="3%">&nbsp;</td>
                                                                        <td width="29%"><%=mx.getInitial()%></td>
                                                                        <td width="25%"> 
                                                                          <div align="center"> 
                                                                            <input type="text" name="modulepercent_<%=cabd.getOID()%>" size="5" maxlength="3" style="text-align:center" value="<%=JSPFormater.formatNumber(cabd.getPercent(), "#,###")%>" onClick="this.select()" onChange="javascript:cmdUpdateData('504404353099418270', '0')" class="readonly" readOnly>
                                                                          </div>
                                                                        </td>
                                                                        <td width="43%"> 
                                                                          <div align="center"> 
                                                                            <input type="text" name="moduleamount_<%=cabd.getOID()%>" size="25" value="<%=JSPFormater.formatNumber(ppd.getAmount()*cabd.getPercent()/100, "#,###")%>" style="text-align:right" class="readonly" readOnly>
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
                                                                          <div align="right"><b><%=JSPFormater.formatNumber(ppd.getAmount(), "#,###.##")%></b></div>
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="3%">&nbsp;</td>
                                                                        <td width="29%">&nbsp;</td>
                                                                        <td width="25%">&nbsp;</td>
                                                                        <td width="43%">&nbsp;</td>
                                                                      </tr>
                                                                    </table>
                                                                    
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="2" class="tablecell1" height="17">&nbsp; 
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
                                                      <td width="43%"><a href="javascript:cmdBack('<%=oidPettycashPayment%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post1','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="post1" height="23" border="0" width="63"></a></td>
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
                                              <%if(pettycashPayment.getAmount()!=0 && iErrCode==0 && iErrCodeMain==0 && balance==0 && cntActivity==0){%>
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
                                                      <td width="68%">&nbsp;</td>
                                                      <td width="24%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                          <table border="0" cellpadding="5" cellspacing="0" class="info" width="193" align="right">
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
				//document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value= formatFloat('<%=totalDetail%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
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
