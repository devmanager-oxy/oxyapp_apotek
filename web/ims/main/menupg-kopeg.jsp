
<%
menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
//out.println(idx1);
%>
<script language="JavaScript">

function cmdChangeMenu(idx){
	var x = idx;
	
	//document.frm_data.menu_idx.value=idx;
	
	switch(parseInt(idx)){
	
		case 1 : 
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="none";
			document.all.purchase2.style.display="";
			document.all.purchase.style.display="";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="";
			document.all.incoming2.style.display="none";
			document.all.incoming.style.display="none";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="";
			//document.all.stock2.style.display="none";
			//document.all.stock.style.display="none";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="";
			//document.all.production2.style.display="none";
			//document.all.production.style.display="none";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="";
			//document.all.master2.style.display="none";
			//document.all.master.style.display="none";		
			<%}%>		
			<%if(adminPriv){%>
			//document.all.admin1.style.display="";
			//document.all.admin2.style.display="none";
			//document.all.admin.style.display="none";
			<%}%>		
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="";
			//document.all.dtransfer2.style.display="none";
			//document.all.dtransfer.style.display="none";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="";
			//document.all.report2.style.display="none";
			//document.all.report.style.display="none";
			<%}%>
								
			break;	

		case 2 : 
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="";
			document.all.purchase2.style.display="none";
			document.all.purchase.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="none";
			document.all.incoming2.style.display="";
			document.all.incoming.style.display="";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="";
			//document.all.stock2.style.display="none";
			//document.all.stock.style.display="none";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="";
			//document.all.production2.style.display="none";
			//document.all.production.style.display="none";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="";
			//document.all.master2.style.display="none";
			//document.all.master.style.display="none";		
			<%}%>		
			<%if(adminPriv){%>
			//document.all.admin1.style.display="";
			//document.all.admin2.style.display="none";
			//document.all.admin.style.display="none";
			<%}%>								
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="";
			//document.all.dtransfer2.style.display="none";
			//document.all.dtransfer.style.display="none";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="";
			//document.all.report2.style.display="none";
			//document.all.report.style.display="none";
			<%}%>					
			break;	
		
		case 3 : 
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="";
			document.all.purchase2.style.display="none";
			document.all.purchase.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="";
			document.all.incoming2.style.display="none";
			document.all.incoming.style.display="none";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="none";
			//document.all.stock2.style.display="";
			//document.all.stock.style.display="";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="";
			//document.all.production2.style.display="none";
			//document.all.production.style.display="none";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="";
			//document.all.master2.style.display="none";
			//document.all.master.style.display="none";		
			<%}%>		
			<%if(adminPriv){%>
			//document.all.admin1.style.display="";
			//document.all.admin2.style.display="none";
			//document.all.admin.style.display="none";
			<%}%>								
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="";
			//document.all.dtransfer2.style.display="none";
			//document.all.dtransfer.style.display="none";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="";
			//document.all.report2.style.display="none";
			//document.all.report.style.display="none";
			<%}%>					
			break;	

		case 4 : 
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="";
			document.all.purchase2.style.display="none";
			document.all.purchase.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="";
			document.all.incoming2.style.display="none";
			document.all.incoming.style.display="none";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="";
			//document.all.stock2.style.display="none";
			//document.all.stock.style.display="none";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="none";
			//document.all.production2.style.display="";
			//document.all.production.style.display="";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="";
			//document.all.master2.style.display="none";
			//document.all.master.style.display="none";		
			<%}%>		
			<%if(adminPriv){%>
			//document.all.admin1.style.display="";
			//document.all.admin2.style.display="none";
			//document.all.admin.style.display="none";
			<%}%>								
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="";
			//document.all.dtransfer2.style.display="none";
			//document.all.dtransfer.style.display="none";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="";
			//document.all.report2.style.display="none";
			//document.all.report.style.display="none";
			<%}%>					
			break;	

		case 6 :
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="";
			document.all.purchase2.style.display="none";
			document.all.purchase.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="";
			document.all.incoming2.style.display="none";
			document.all.incoming.style.display="none";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="";
			//document.all.stock2.style.display="none";
			//document.all.stock.style.display="none";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="";
			//document.all.production2.style.display="none";
			//document.all.production.style.display="none";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="none";
			//document.all.master2.style.display="";
			//document.all.master.style.display="";		
			<%}%>
			<%if(adminPriv){%>
			//document.all.admin1.style.display="";
			//document.all.admin2.style.display="none";
			//document.all.admin.style.display="none";
			<%}%>			
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="";
			//document.all.dtransfer2.style.display="none";
			//document.all.dtransfer.style.display="none";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="";
			//document.all.report2.style.display="none";
			//document.all.report.style.display="none";
			<%}%>					
			break;	

		case 7 :
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="";
			document.all.purchase2.style.display="none";
			document.all.purchase.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="";
			document.all.incoming2.style.display="none";
			document.all.incoming.style.display="none";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="";
			//document.all.stock2.style.display="none";
			//document.all.stock.style.display="none";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="";
			//document.all.production2.style.display="none";
			//document.all.production.style.display="none";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="";
			//document.all.master2.style.display="none";
			//document.all.master.style.display="none";		
			<%}%>
			<%if(adminPriv){%>
			//document.all.admin1.style.display="";
			//document.all.admin2.style.display="none";
			//document.all.admin.style.display="none";
			<%}%>			
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="none";
			//document.all.dtransfer2.style.display="";
			//document.all.dtransfer.style.display="";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="";
			//document.all.report2.style.display="none";
			//document.all.report.style.display="none";
			<%}%>					
			break;
		
		case 12 :
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="";
			document.all.purchase2.style.display="none";
			document.all.purchase.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="";
			document.all.incoming2.style.display="none";
			document.all.incoming.style.display="none";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="";
			//document.all.stock2.style.display="none";
			//document.all.stock.style.display="none";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="";
			//document.all.production2.style.display="none";
			//document.all.production.style.display="none";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="";
			//document.all.master2.style.display="none";
			//document.all.master.style.display="none";		
			<%}%>
			<%if(adminPriv){%>
			//document.all.admin1.style.display="none";
			//document.all.admin2.style.display="";
			//document.all.admin.style.display="";
			<%}%>		
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="";
			//document.all.dtransfer2.style.display="none";
			//document.all.dtransfer.style.display="none";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="";
			//document.all.report2.style.display="none";
			//document.all.report.style.display="none";
			<%}%>					
			break;
				
		case 13 :
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="";
			document.all.purchase2.style.display="none";
			document.all.purchase.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="";
			document.all.incoming2.style.display="none";
			document.all.incoming.style.display="none";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="";
			//document.all.stock2.style.display="none";
			//document.all.stock.style.display="none";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="";
			//document.all.production2.style.display="none";
			//document.all.production.style.display="none";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="";
			//document.all.master2.style.display="none";
			//document.all.master.style.display="none";		
			<%}%>
			<%if(adminPriv){%>
			//document.all.admin1.style.display="";
			//document.all.admin2.style.display="none";
			//document.all.admin.style.display="none";
			<%}%>		
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="";
			//document.all.dtransfer2.style.display="none";
			//document.all.dtransfer.style.display="none";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="none";
			//document.all.report2.style.display="";
			//document.all.report.style.display="";
			<%}%>					
			break;
			
		case 0 :
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.purchase1.style.display="";
			document.all.purchase2.style.display="none";
			document.all.purchase.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.incoming1.style.display="";
			document.all.incoming2.style.display="none";
			document.all.incoming.style.display="none";
			<%}%>
		    <%if(sTransferPriv || sReturnPriv || sAdjustmentPriv || sOpnamePriv || sArcPriv){%>
			//document.all.stock1.style.display="";
			//document.all.stock2.style.display="none";
			//document.all.stock.style.display="none";
			<%}%>
			<%if(mMasterCategoryPriv || mMasterSubCategoryPriv || pMasterProductListPriv ||  pMasterWorkCenterPriv || 
				pManagementCreateSfOrderPriv || pManagementSfControlPriv || pManagementFinishGoodsPriv){%>
			//document.all.production1.style.display="";
			//document.all.production2.style.display="none";
			//document.all.production.style.display="none";
			<%}%>
		    <%if(mConfigurationPriv || 
				mAccRatePriv || mAccPeridPriv ||
				mMaterialBrandPriv || mMaterialCategoryPriv || mMaterialSubCategoryPriv || mMaterialMasterListPriv || mMaterialWorkCenterPriv || 
				mHrdEmployeePriv || mHrdDepartmentPriv ||
				mGeneralContinentPriv || mGeneralCountryPriv || mGeneralCurrencyPriv || mGeneralCustomerPriv || mGeneralShippingAddressPriv || 
				mGeneralWarehouseLocationPriv || mGeneralVendorPriv || mGeneralUomPriv || mMenuListPriv || mCategoryListPriv){%>			
			//document.all.master1x.style.display="";
			//document.all.master2.style.display="none";
			//document.all.master.style.display="none";		
			<%}%>					
			<%if(adminPriv){%>
			//document.all.admin1.style.display="";
			//document.all.admin2.style.display="none";
			//document.all.admin.style.display="none";
			<%}%>			
			<%if(datasyncPriv){%>
			//document.all.dtransfer1.style.display="";
			//document.all.dtransfer2.style.display="none";
			//document.all.dtransfer.style.display="none";
			<%}%>
			<%if(mPOReport || mPORetur || mItemTransfer || mStockReport || mPaymantReport){%>
			//document.all.report1.style.display="";
			//document.all.report2.style.display="none";
			//document.all.report.style.display="none";
			<%}%>					
			break;
				
	}
}

</script>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td valign="top" style="background:url(<%=approot%>/imagespg/leftmenu-bg.gif) repeat-y"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td valign="top" height="32"><img src="<%=approot%>/imagespg/logo-finance2.jpg" width="216" height="32" /></td>
        </tr>
        <tr> 
          <td><img src="<%=approot%>/imagespg/spacer.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td style="padding-left:10px" valign="top" height="1"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><img src="<%=approot%>/imagespg/spacer.gif" width="1" height="1" /></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <!--tr> 
                <td height="49" valign="top"> 
                  <div align="center"> Operator : <%=appSessUser.getLoginId()%><br>
                    <a href="<%=approot%>/updatepwd.jsp?menu_idx=0">[ 
                    update password ]</a></div>
                </td>
              </tr-->
              <%if(pRequestPriv || pOrderPriv || pArcPriv){%>
              <tr id="purchase1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Customer</a></td>
              </tr>
              <tr id="purchase2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Customer</a><a href="javascript:cmdChangeMenu('0')"></a></td>
              </tr>
              <tr id="purchase"> 
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/general/customerpg.jsp?menu_idx=1">Data 
                        Query</a></td>
                    </tr>
                    <%if(pRequestPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/general/customeredtcompg.jsp?menu_idx=1&command=<%=JSPCommand.ADD%>">New 
                        Customer</a></td>
                    </tr>
                    <%}%>
                    <%if(pOrderPriv){%>
                    <%}%>
                    <%if(pArcPriv){%>
                    <%}%>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagespg/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(iReceiptPriv || iArcPriv){%>
              <tr id="incoming1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Project</a></td>
              </tr>
              <tr id="incoming2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Project</a></td>
              </tr>
              <tr id="incoming"> 
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <%if(iReceiptPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/newproject.jsp?menu_idx=2&command=<%=JSPCommand.ADD%>">New 
                        Project</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/projectlist.jsp?target_page=0&menu_idx=2">Project 
                        List</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/projectlist.jsp?target_page=1&menu_idx=2">Order 
                        Confirmation</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/projectlist.jsp?target_page=2&menu_idx=2">Installation</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/projectlist.jsp?target_page=3&menu_idx=2">Closing 
                        Project</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/installationbudgettype.jsp?target_page=3&menu_idx=2">Budget 
                        Type</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/installationexpensetype.jsp?target_page=3&menu_idx=2">Expense 
                        Type</a></td>
                    </tr>
                    <%}%>
					<tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagespg/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
			  <tr> 
                <td class="menu0"><a href="<%=approot%>/logoutpg.jsp">Logout</a></td>
              </tr>
			  <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="100%">&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script language="JavaScript">
	cmdChangeMenu('<%=menuIdx%>');
</script>
