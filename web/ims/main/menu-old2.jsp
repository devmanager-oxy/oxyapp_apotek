
<%
            menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
%>
<script language="JavaScript">
    
    function cmdChangeMenu(idx){
        var x = idx;        
        
        switch(parseInt(idx)){ 
            
            case 1 : 
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="none";
                    document.all.purchase2.style.display="";
                    document.all.purchase.style.display="";
                <%}%>
            
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
            
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
            
                 <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory  ) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                break;	
                    
            case 2 : 
                
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                    
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="none";
                    document.all.incoming2.style.display="";
                    document.all.incoming.style.display="";
                <%}%>
               
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
            
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
            
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory ) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                
                break;
                    
                    
            case 3 : 
                
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                    
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="none";
                    document.all.stock2.style.display="";
                    document.all.stock.style.display="";
                <%}%>
                    
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
                
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory  ) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>	
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                
                break;	
                    
            case 4 : 
                    
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                    
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
                    
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="none";
                    document.all.production2.style.display="";
                    document.all.production.style.display="";
                <%}%>
                
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory ) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>						
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                					
                break;	
                    
            case 6 :
            
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                    
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
                    
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
                
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory  ) {%>			
                    document.all.master1x.style.display="none";
                    document.all.master2.style.display="";
                    document.all.master.style.display="";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>	
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                break;
                
            case 7 :
                    
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                    
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
                    
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
                
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="none";
                    document.all.dtransfer2.style.display="";
                    document.all.dtransfer.style.display="";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory ) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>	
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                break;
                    
              case 12 :
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                    
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
                    
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
                
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory  ) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="none";
                    document.all.admin2.style.display="";
                    document.all.admin.style.display="";
                <%}%>	
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                break;
                    
        case 13 :
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                    
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
                    
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
                
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="none";
                    document.all.report2.style.display="";
                    document.all.report.style.display="";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory  ) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>	
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                break;
                
        case 14 :
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                    
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
                    
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
                
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales ) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory   ) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>	
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>
                    document.all.fakturPajak1.style.display="none";
                    document.all.fakturPajak2.style.display="";
                    document.all.fakturPajak.style.display="";
                <%}%>	
                
                break;   
                    
        case 0 :
                <%if (purcRequest || listPendingPR || prArchives || expPRtoPO || dirPO || poArchives) {%>
                    document.all.purchase1.style.display="";
                    document.all.purchase2.style.display="none";
                    document.all.purchase.style.display="none";
                <%}%>
                
                <%if (incomFromPo || directIncom || incomArchives) {%>
                    document.all.incoming1.style.display="";
                    document.all.incoming2.style.display="none";
                    document.all.incoming.style.display="none";
                <%}%>
                    
                <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                    document.all.stock1.style.display="";
                    document.all.stock2.style.display="none";
                    document.all.stock.style.display="none";
                <%}%>
                    
                <%if (newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                    document.all.production1.style.display="";
                    document.all.production2.style.display="none";
                    document.all.production.style.display="none";
                <%}%>
                
                <%if (dataSync) {%>
                    document.all.dtransfer1.style.display="";
                    document.all.dtransfer2.style.display="none";
                    document.all.dtransfer.style.display="none";
                <%}%>
            
                <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales) {%>
                    document.all.report1.style.display="";
                    document.all.report2.style.display="none";
                    document.all.report.style.display="none";
                <%}%>
                
                <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory) {%>			
                    document.all.master1x.style.display="";
                    document.all.master2.style.display="none";
                    document.all.master.style.display="none";		
                <%}%>	
                
                <%if (sysConfig || administrator || genUser) {%>
                    document.all.admin1.style.display="";
                    document.all.admin2.style.display="none";
                    document.all.admin.style.display="none";
                <%}%>	
                
                <%if (rptFakturPajak || rptFakturPajakSales) {%>                
                    document.all.fakturPajak1.style.display="";
                    document.all.fakturPajak2.style.display="none";
                    document.all.fakturPajak.style.display="none";
                <%}%>    
                break;
                    
                }
            }
            
            </script>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td valign="top" height="32"><img src="<%=approot%>/images/logo-finance2.jpg" width="216" height="32" /></td>
                </tr>
                <tr> 
                    <td><img src="<%=approot%>/images/spacer.gif" width="1" height="5"></td>
                </tr>
                <tr> 
                    <td style="padding-left:10px" valign="top" height="1"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td><img src="<%=approot%>/images/spacer.gif" width="1" height="1" /></td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                            </tr>
              <%if (purcRequest || listPendingPR || expPRtoPO || dirPO || poArchives){%>
                            <tr id="purchase1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Purchasing</a></td>
                            </tr>
                            <tr id="purchase2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Purchasing</span></a></td>
                            </tr>
                            <tr id="purchase"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <%if (purcRequest){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/purchaserequestitem.jsp?menu_idx=1">Purchase Request</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (listPendingPR){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/prpending.jsp?menu_idx=1">List Pending PR</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (prArchives){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/purchaserequestlist.jsp?menu_idx=1&start=0">PR Archives</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (expPRtoPO){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/prtoposearch.jsp?menu_idx=1">Export PR to PO </a></td>
                                        </tr>
                                        <%}%>                                        
                                        <%if (dirPO) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/purchaseitemx.jsp?menu_idx=1">Direct PO</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (poArchives) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/purchaselist.jsp?menu_idx=1&start=0">PO Archives</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (poArchives) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/poanalisis.jsp?menu_idx=1&start=0">PO Analisis</a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td class="menu1">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (incomFromPo || directIncom || incomArchives) {%>
                            <tr id="incoming1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Incoming 
                                Goods</a></td>
                            </tr>
                            <tr id="incoming2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Incoming 
                                Goods</span></a></td>
                            </tr>
                            <tr id="incoming"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <%if (incomFromPo) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/pobasesearch.jsp?menu_idx=2">Incoming 
                                            From PO</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (directIncom) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/receiveitem.jsp?menu_idx=2">Direct 
                                            Incoming</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (incomingKomisi) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/incomingkomisi.jsp?menu_idx=2">Incoming
                                            Komisi</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (incomArchives) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/receivelist.jsp?menu_idx=2">Incoming 
                                            Archives</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (receivingAdjusment) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/receivelistRecAdj.jsp?menu_idx=2">Incoming  
                                            Adjusment</a></td>
                                        </tr>
                                        <%}%>
					    <%if (receivingAdjusment) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/recadjlist.jsp?menu_idx=2">Inc 
                                            Adjusment Archives</a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td class="menu1">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            
                            <%if(newProject || newStock || mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter || shopFlor || finishGoods || deliv || instExp) {%>
                            <tr id="production1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Production</a></td>
                            </tr>
                            <tr id="production2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Production</span></a></td>
                            </tr>
                            <tr id="production"> 
                                <td class="submenutd"> 
                                    <table width="99%" cellpadding="0" cellspacing="0" class="submenu">
                                        <%if(newProject || newStock){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Job Order</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/sales/prdsales.jsp">New 
                                            Project </a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/sales/stockorder.jsp">New 
                                            Stock </a></td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (mstProdCategory || mstProdSubCategory || mstProdList || mstProdWorkCenter) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Product Master</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <%if (mstProdCategory) {%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/production/productcategory.jsp?menu_idx=4">Product 
                                                        Category</a></td>
                                                    </tr>
                                                    <%}%>
                                                    <%if (mstProdSubCategory) {%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/production/productsubcategory.jsp?menu_idx=4">Product 
                                                        Sub Category</a></td>
                                                    </tr>
                                                    <%}%>
                                                    <%if (mstProdList) {%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/production/productlist.jsp?menu_idx=4">Product 
                                                        List</a></td>
                                                    </tr>
                                                    <%}%>
                                                    <%if (mstProdWorkCenter) {%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/workcenter.jsp?menu_idx=4">Product 
                                                        Work Center</a></td>
                                                    </tr>
                                                    <%}%>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        
                                        
                                        <%if (shopFlor || finishGoods) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Manufacturing</td>
                                        </tr>
                                        <%if (shopFlor) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu3">Shop Floor Management</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu4"><a href="<%=approot%>/manufacturing/createshoporder.jsp?menu_idx=4">Create 
                                                        Shop Order</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu4"><a href="<%=approot%>/manufacturing/shopfloorcontrol.jsp?menu_idx=4">Shop 
                                                        Floor Control</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (finishGoods){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu3"><a href="<%=approot%>/manufacturing/finishgoods.jsp?menu_idx=4">Finish 
                                            Goods</a></td>
                                        </tr>
                                        <%}%>
                                        <%}%>
                                        <%if (deliv || instExp){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Delivery</td>
                                        </tr>
                                        <%if (deliv){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu3">Delivery Order</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu4"><a href="<%=approot%>/production/templatedo.jsp?menu_idx=4">Template 
                                                        Delivery Order</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu4"><a href="<%=approot%>/production/previewdo.jsp?menu_idx=4">Preview 
                                                        Delivery Order</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (instExp) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu3"><a href="<%=approot%>/production/instalationexpense.jsp?menu_idx=4">Instalation 
                                            Expense</a></td>
                                        </tr>
                                        <%}%>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            
                            
                            <%if (mTransfer || mTransferRequest || purchRetur || newRetur || newReturArc || madjustment || mOpname || mCosting || mRepack) {%>
                            <tr id="stock1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('3')"> <a href="javascript:cmdChangeMenu('3')">Stock 
                                Management</a></td>
                            </tr>
                            <tr id="stock2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Stock 
                                Management</span></a></td>
                            </tr>
                            <tr id="stock"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <%if (mTransfer) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/transferlist.jsp?menu_idx=3">Transfer</a></td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (mTransferRequest) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/transferanalist.jsp?menu_idx=3">Transfer Analisis</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (purchRetur || newRetur || newReturArc) {%>
                                        <tr> 
                                            <td class="menu1">Purchase Retur</td>
                                        </tr>
                                        <%if (purchRetur){%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/postransaction/returpobasesearch.jsp?menu_idx=3">New 
                                            Retur</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (newReturArc){%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/postransaction/returlist.jsp?menu_idx=3"> 
                                            Archives</a></td>
                                        </tr>
                                        <%}%>
                                        <%}%>    
                                        <%if (mDirectRetur){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/returtovendor.jsp?menu_idx=3">Direct Retur</a></td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (madjustment){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/adjusmentlist.jsp?menu_idx=3">Adjusment</a></td>
                                        </tr>
                                        <%}%>
                                        
                                       
                                         <%if (mOpname) {%>
                                        <tr> 
                                            <td class="menu1">Opname</td>
                                        </tr>
                                        <%if (mOpname){%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/postransaction/opnamelist.jsp?menu_idx=3">Stock Opname 
                                            </a></td>
                                        </tr>
                                        <%}%>
                                        <%if (mOpname){%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/postransaction/opnamesumarylist.jsp?menu_idx=3">Summary Opname</a></td>
                                        </tr>
                                        <%}%>
                                        
                                        <%}%>  
                                        <%if (false) {%>
                                        <tr> 
                                            <td class="menu1">Closing Stock ?</td>
                                        </tr>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/transaction/stockopname.jsp?menu_idx=3">Close 
                                            Stock </a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu2"><a href="#?menu_idx=3">Stock Period</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (mCosting){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/costingitem.jsp?menu_idx=3">Costing</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (mRepack){%>
                                        <tr> 
                                            <td class="menu1">Repack</td>
                                        </tr>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/postransaction/repackitem.jsp?menu_idx=3">Single Output 
                                            </a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/postransaction/repackitemmulty.jsp?menu_idx=3">Multy Output 
                                            </a></td>
                                        </tr>                                        <%}%>
                                        <tr> 
                                            <td class="menu1">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (rptFakturPajak || rptFakturPajakSales){%>
                            <tr id="fakturPajak1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('14')"> <a href="javascript:cmdChangeMenu('14')">Tax Invoice</a></td>
                            </tr>
                            <tr id="fakturPajak2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Tax Invoice</span></a></td>
                            </tr>
                            <tr id="fakturPajak"> 
                                <td class="submenutd"> 
                                    <table width="99%" cellpadding="0" cellspacing="0" class="submenu">
                                        <%if (rptFakturPajak) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/postransaction/fakturpajak.jsp?menu_idx=14">Transfer Tax</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (rptFakturPajakSales){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/postransaction/fakturpajaksales.jsp?menu_idx=14">Sales Tax</a></td>
                                        </tr>
                                        <%}%>
                                    </table>    
                                 </td>     
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%            
                if (dataSync) {
                            %>
                            <tr id="dtransfer1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('7')"> <a href="javascript:cmdChangeMenu('7')">Data 
                                Synchronization</a></td>
                            </tr>
                            <tr id="dtransfer2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Data 
                                Synchronization</span></a></td>
                            </tr>
                            <tr id="dtransfer"> 
                                <td class="submenutd"> 
                                    <table width="99%" cellpadding="0" cellspacing="0" class="submenu">
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Backup</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/datasync/backupcheck.jsp?menu_idx=7">Transfer 
                                                        To File</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/datasync/maintain.jsp?menu_idx=7">Maintenance</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>                                        
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> 
                                            </td>
                                        </tr>                                        
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%
                }
            %>
                            <%if (rptPoReport || rptIncomReport || rptPoRetur || rptItemTransfer || rptStockReport || rptStockCard  || rptCostingReport || rptRepackReport || rptFakturPajak || rptFakturPajakSales) {%>
                            <tr id="report1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('13')"> <a href="javascript:cmdChangeMenu('13')">Reports</a></td>
                            </tr>
                            <tr id="report2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Reports</span></a></td>
                            </tr>
                            <tr id="report"> 
                                <td class="submenutd"> 
                                    <table width="99%" cellpadding="0" cellspacing="0" class="submenu">
                                        <%if (rptPoReport) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Service Level</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/service-supplier.jsp?menu_idx=13">
                                                        Supplier</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/service-dc.jsp?menu_idx=13"> 
                                                        DC</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (rptPoReport) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">PO Report</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/poreport-supplier.jsp?menu_idx=13">By 
                                                        Supplier</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/poreport-category.jsp?menu_idx=13">By 
                                                        Item Category</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (rptIncomReport) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Incoming Report</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/recreport-supplier.jsp?menu_idx=13">By 
                                                        Supplier</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/recreport-category.jsp?menu_idx=13">By 
                                                        Item Category</a></td>
                                                    </tr>
                                                    
                                                    <%if (1 == 2) {%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/period.jsp?menu_idx=13">Account 
                                                        Payable</a></td>
                                                    </tr>
                                                    <%}%>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>                                        
                                        <%if (rptPoRetur) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">PO Retur</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/returreport-supplier.jsp?menu_idx=13">By 
                                                        Supplier</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/returreport-category.jsp?menu_idx=13">By 
                                                        Item Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/returreport-subcategory.jsp?menu_idx=13">By 
                                                        Item Sub Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/returreport-itemmaster.jsp?menu_idx=13">By 
                                                        Item</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (rptItemTransfer) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Item Transfer</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/reportSumaryTransfer.jsp?menu_idx=13">By 
                                                        Location </a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/treport-category.jsp?menu_idx=13">By 
                                                        Item Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/treport-subcategory.jsp?menu_idx=13">By 
                                                        Item Sub Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/treport-itemmaster.jsp?menu_idx=13">By 
                                                        Item</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/treport-bysupplier.jsp?menu_idx=13">By 
                                                        Supplier</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/treport-transaksi.jsp?menu_idx=13">By 
                                                        Transaksi</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (rptStockReport) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Stock Report</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-location.jsp?menu_idx=13">By 
                                                        Location </a></td>
                                                    </tr>
                                                     <tr>
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-locationsumm.jsp?menu_idx=13">Total Stock
                                                        by Location</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-category.jsp?menu_idx=13">By 
                                                        Item Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-subcategory.jsp?menu_idx=13">By 
                                                        Item Sub Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-minimum.jsp?menu_idx=13"> 
                                                        Minimum Stock</a></td>
                                                    </tr>
                                                    <%if(false){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/inventoryreport.jsp?menu_idx=13">Inventory Report</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/inventorygroupreport.jsp?menu_idx=13">Inventory Report (Summary)</a></td>
                                                    </tr>
                                                    <%}%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/inventoryreportvalue.jsp?menu_idx=13">Inventory Report</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (rptStockReport && DbLocation.getCount("type='Restaurant'")>0) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Resto Stock Report</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-location-resto.jsp?menu_idx=13">By 
                                                        Location </a></td>
                                                    </tr>
                                                    
                                                    <tr>  
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-category-resto.jsp?menu_idx=13">By 
                                                        Item Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-subcategory-resto.jsp?menu_idx=13">By 
                                                        Item Sub Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posreport/stock-minimum-resto.jsp?menu_idx=13"> 
                                                        Minimum Stock</a></td>
                                                    </tr>
                                                    
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (rptStockCard) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/posreport/stock-card-non-consigment.jsp?menu_idx=13">Stock Card</a></td>
                                        </tr>
                                        <%}%>       
					     <%if (rptStockCard) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/posreport/reportstockstandar.jsp?menu_idx=13">Stock Standart</a></td>
                                        </tr>
                                        <%}%>       
					     <%if (rptStockCard) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/posreport/reportorder.jsp?menu_idx=13">Order List</a></td>
                                        </tr>
                                        <%}%>       
	
	
                                        <%if (rptCostingReport) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/posreport/costingReport_item.jsp?menu_idx=13">Costing Report</a></td>
                                        </tr>
                                        <%}%>   
                                        <%if (rptRepackReport) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/posreport/repackReport.jsp?menu_idx=13">Repack Report</a></td>
                                        </tr>
                                        <%}%>
					     <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/posreport/sinkrondata.jsp?menu_idx=13">Sinkron Data</a></td>
                                        </tr>

					     <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/posreport/stockbalance.jsp?menu_idx=13">Cek Stock Sales</a></td>
                                        </tr>
		
                                        <%
    if (1 == 2){
                                        %>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Invoice Payment Report</td>
                                        </tr>
                                        <%
    }%>
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (mstMaintenance || mstAccounting || mstMaterial || mstProduct || mstAsset || mstMerk || mstCompany || mstGeneral || mstMember || mstCashier || mstBackupData || mstMenu || mstMaterial || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory ) {%>
                            <tr id="master1x"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('6')"> <a href="javascript:cmdChangeMenu('6')">Master 
                                Maintenance</a></td>
                            </tr>
                            <tr id="master2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Master 
                                Maintenance</span></a></td>
                            </tr>
                            <tr id="master"> 
                                <td class="submenutd"> 
                                    <table width="99%" cellpadding="0" cellspacing="0" class="submenu">
                                        <%if (mstMaintenance) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/company.jsp?menu_idx=6">Configuration</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (mstAccounting) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Accounting</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/exchangerate.jsp?menu_idx=6">Bookkeeping 
                                                        Rate</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/period.jsp?menu_idx=6">Period</a></td>
                                                    </tr>                                                    
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (mstMaterial || mstPriceChange || mstStandarStock || mstPromotion || mstCategory || mstSubCategory) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Material</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">      
                                                    <%if(mstCategory){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/itemgroup.jsp?menu_idx=6">Material 
                                                        Category</a></td>
                                                    </tr>    
                                                    <%}%>
                                                    <%if(mstSubCategory){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/itemcategory.jsp?menu_idx=6">Material 
                                                        Sub Category</a></td>
                                                    </tr>  
                                                    <%}%>
                                                    <%if(mstMaterial){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/itemmaster.jsp?menu_idx=6">Material 
                                                        List</a></td>
                                                    </tr>
                                                    <%}%>
                                                     <%if(false){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/updateHarga.jsp?menu_idx=6">Update Sell Price 
                                                        </a></td>
                                                    </tr>
                                                    <%}%>
                                                    
                                                    <%if(mstPriceChange){%>
							   <tr> 
                                                        
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/sellingpricechange.jsp?menu_idx=6">Update 
                              Sell Price - New</a></td>
                                                    </tr>
													<tr> 
                                                        
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/costpricechange.jsp?menu_idx=6">Cost Price Change - New</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/pricechangelist.jsp?menu_idx=6">Price Change 
                                                        List</a></td>
                                                    </tr>
							   <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/pricechangelistnew.jsp?menu_idx=6">Price Change 
                                                        List - New</a></td>
                                                    </tr>
                                                    <%}%>
                                                    <%if(mstStandarStock){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/stockstandarlist.jsp?menu_idx=6">Standart Stock 
                                                        List</a></td>
                                                    </tr>
                                                    <%}%>
                                                    <%if(mstPromotion){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/postransaction/promotionitem.jsp?menu_idx=6">Promotion 
                                                        List</a></td>
                                                    </tr>
                                                    <%}%>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (mstProduct) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Product</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/materialbrand.jsp?menu_idx=6">Material 
                                                        Brand</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/productgroup.jsp?menu_idx=6">Product 
                                                        Category</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/productcategory.jsp?menu_idx=6">Product 
                                                        Sub Category</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/productmaster.jsp?menu_idx=6">Product 
                                                        List</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/workcenter.jsp?menu_idx=6">Material 
                                                        Work Center</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/showlist.jsp?menu_idx=6">Specification 
                                                        Show List</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/categoryshowlist.jsp?menu_idx=6">Category 
                                                        Show List</a></td>
                                                    </tr>                                                    
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (mstAsset) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Asset </td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                              
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/assetgroup.jsp?menu_idx=6">Asset 
                                                        Category</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/assetcategory.jsp?menu_idx=6">Asset 
                                                        Sub Category</a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/assetmaster.jsp?menu_idx=6">Asset 
                                                        List</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if(mstMerk){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Merk</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                       
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/merk.jsp?menu_idx=6">Merk 
                                                        List</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%
        if (mstCompany) {
                                        %>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Company</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/employee.jsp?menu_idx=6">Employee 
                                                        as User</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/department.jsp?menu_idx=6">Department</a></td>
                                                    </tr>                                                    
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (mstGeneral){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">General</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <%
    if (1 == 2) {
        
                                                   %>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/country.jsp?menu_idx=6">Country</a></td>
                                                    </tr>
        
                                                   
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/currency.jsp?menu_idx=6">Currency</a></td>
                                                    </tr>
                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/customer.jsp?menu_idx=6">Customer</a></td>
                                                    </tr>
                                                    <%
    }%>
                                                   
                                                    <%if(user.getLoginId().equals("superuser")){%>    
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/shipaddress.jsp?menu_idx=6">Shipping 
                                                        Address</a></td>
                                                    </tr>
                                                    
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/location.jsp?menu_idx=6">Warehouse 
                                                        Location</a></td>
                                                    </tr>
							   <%}%>
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/subLocation.jsp?menu_idx=6">Sub 
                                                        Location</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/vendor.jsp?menu_idx=6">Vendor 
                                                        List </a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/posmaster/uom.jsp?menu_idx=6">Unit 
                                                        Master </a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/bank.jsp?menu_idx=6">Bank 
                                                        </a></td>
                                                    </tr>                                                   
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if(mstMember){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Member</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/customerinduklist.jsp?menu_idx=6">Group Member</a></td>                                                        
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/customer.jsp?menu_idx=6">New Member</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/customerPending.jsp?menu_idx=6">List Member Pending</a></td>
                                                    </tr>
							   <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/membership/memberpointsetup.jsp?menu_idx=6">Member Point Setup</a></td>
                                                    </tr>
													<tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/membership/memberpointcheck.jsp?menu_idx=6">Check Point</a></td>
                                                    </tr>
													<tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/membership/memberpoint.jsp?menu_idx=6">Point Mutation</a></td>
                                                    </tr>
                                                </table>  
                                            </td>
                                        </tr>   
                                        <%}%>
                                        
                                        <%if(mstCashier){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Master Cashier</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/cashMaster.jsp?menu_idx=6">Cashier Location</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/posmaster/shift.jsp?menu_idx=6">Shift</a></td>
                                                    </tr>
                                                    
                                                </table>  
                                            </td>
                                        </tr>    
                                        <%}%>
                                        
                                        <%if(mstBackupData){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Backup Data </td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/datasync/backup.jsp?menu_idx=6">Save To File</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/datasync/maintain.jsp?menu_idx=6">Maintenance</a></td>
                                                    </tr>
                                                    
                                                </table>  
                                            </td>
                                        </tr> 
                                        <%}%>
                                        
                                        <%if (mstMenu){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Menu</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/showlist.jsp?menu_idx=6">Specification 
                                                        Show List</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/categoryshowlist.jsp?menu_idx=6">Category 
                                                        Show List</a></td>
                                                    </tr>                                                    
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (sysConfig || administrator || genUser){%>
                            <tr id="admin1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('12')"> <a href="javascript:cmdChangeMenu('12')">Administrator</a></td>
                            </tr>
                            <tr id="admin2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Administrator</span></a></td>
                            </tr>
                            <tr id="admin"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <%if (sysConfig){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/system/sysprop.jsp?menu_idx=12">System 
                                            Configuration</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (administrator || true){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/payroll/employee.jsp?menu_idx=12">Employee 
                                            List</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/admin/userlist.jsp?menu_idx=12">User 
                                            List </a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/admin/grouplist.jsp?menu_idx=12">User 
                                            Group</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (genUser){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/admin/generateUserKey.jsp?menu_idx=12">Generate User Key
                                            </a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td class="menu1">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <tr> 
                                <td class="menu0"><a href="<%=approot%>/logout.jsp">Logout</a></td>
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
