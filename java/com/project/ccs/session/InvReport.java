/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy Andika
 */
public class InvReport {
    
    private String code = "";
    private String sectionName = "";
    private String sectionCode = "";
    private String codeClass = "";
    private String sku = "";
    private String desription = "";
    
    //value 
    private double begining = 0;    
    private double receiving = 0;
    private double receivingAdjustment = 0;
    private double rtv = 0;
    private double transferIn = 0;
    private double transferOut = 0;
    private double costing = 0;
    private double mutation = 0;
    private double repackOut = 0;
    private double stockAdjustment = 0;
    private double cogs = 0;
    private double netSales = 0;
    private double ending = 0;
    private double turnOvr = 0;
    private double adjVal = 0;
    
    //qty
    private double beginingQty = 0;    
    private double receivingQty = 0;
    private double receivingAdjustmentQty = 0;
    private double rtvQty = 0;
    private double transferInQty = 0;
    private double transferOutQty = 0;
    private double costingQty = 0;
    private double mutationQty = 0;
    private double repackOutQty = 0;
    private double stockAdjustmentQty = 0;
    private double cogsQty = 0;
    private double netSalesQty = 0;
    private double endingQty = 0;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getSectionName() {
        return sectionName;
    }

    public void setSectionName(String sectionName) {
        this.sectionName = sectionName;
    }

    public String getSectionCode() {
        return sectionCode;
    }

    public void setSectionCode(String sectionCode) {
        this.sectionCode = sectionCode;
    }

    public String getCodeClass() {
        return codeClass;
    }

    public void setCodeClass(String codeClass) {
        this.codeClass = codeClass;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getDesription() {
        return desription;
    }

    public void setDesription(String desription) {
        this.desription = desription;
    }

    public double getBegining() {
        return begining;
    }

    public void setBegining(double begining) {
        this.begining = begining;
    }

    public double getReceiving() {
        return receiving;
    }

    public void setReceiving(double receiving) {
        this.receiving = receiving;
    }

    public double getReceivingAdjustment() {
        return receivingAdjustment;
    }

    public void setReceivingAdjustment(double receivingAdjustment) {
        this.receivingAdjustment = receivingAdjustment;
    }

    public double getRtv() {
        return rtv;
    }

    public void setRtv(double rtv) {
        this.rtv = rtv;
    }

    public double getTransferIn() {
        return transferIn;
    }

    public void setTransferIn(double transferIn) {
        this.transferIn = transferIn;
    }

    public double getTransferOut() {
        return transferOut;
    }

    public void setTransferOut(double transferOut) {
        this.transferOut = transferOut;
    }

    public double getCosting() {
        return costing;
    }

    public void setCosting(double costing) {
        this.costing = costing;
    }

    public double getMutation() {
        return mutation;
    }

    public void setMutation(double mutation) {
        this.mutation = mutation;
    }

    public double getStockAdjustment() {
        return stockAdjustment;
    }

    public void setStockAdjustment(double stockAdjustment) {
        this.stockAdjustment = stockAdjustment;
    }

    public double getCogs() {
        return cogs;
    }

    public void setCogs(double cogs) {
        this.cogs = cogs;
    }

    public double getNetSales() {
        return netSales;
    }

    public void setNetSales(double netSales) {
        this.netSales = netSales;
    }

    public double getEnding() {
        return ending;
    }

    public void setEnding(double ending) {
        this.ending = ending;
    }

    public double getTurnOvr() {
        return turnOvr;
    }

    public void setTurnOvr(double turnOvr) {
        this.turnOvr = turnOvr;
    }

    public double getRepackOut() {
        return repackOut;
    }

    public void setRepackOut(double repackOut) {
        this.repackOut = repackOut;
    }

    public double getAdjVal() {
        return adjVal;
    }

    public void setAdjVal(double adjVal) {
        this.adjVal = adjVal;
    }

    public double getBeginingQty() {
        return beginingQty;
    }

    public void setBeginingQty(double beginingQty) {
        this.beginingQty = beginingQty;
    }

    public double getReceivingQty() {
        return receivingQty;
    }

    public void setReceivingQty(double receivingQty) {
        this.receivingQty = receivingQty;
    }

    public double getReceivingAdjustmentQty() {
        return receivingAdjustmentQty;
    }

    public void setReceivingAdjustmentQty(double receivingAdjustmentQty) {
        this.receivingAdjustmentQty = receivingAdjustmentQty;
    }

    public double getRtvQty() {
        return rtvQty;
    }

    public void setRtvQty(double rtvQty) {
        this.rtvQty = rtvQty;
    }

    public double getTransferInQty() {
        return transferInQty;
    }

    public void setTransferInQty(double transferInQty) {
        this.transferInQty = transferInQty;
    }

    public double getTransferOutQty() {
        return transferOutQty;
    }

    public void setTransferOutQty(double transferOutQty) {
        this.transferOutQty = transferOutQty;
    }

    public double getCostingQty() {
        return costingQty;
    }

    public void setCostingQty(double costingQty) {
        this.costingQty = costingQty;
    }

    public double getMutationQty() {
        return mutationQty;
    }

    public void setMutationQty(double mutationQty) {
        this.mutationQty = mutationQty;
    }

    public double getRepackOutQty() {
        return repackOutQty;
    }

    public void setRepackOutQty(double repackOutQty) {
        this.repackOutQty = repackOutQty;
    }

    public double getStockAdjustmentQty() {
        return stockAdjustmentQty;
    }

    public void setStockAdjustmentQty(double stockAdjustmentQty) {
        this.stockAdjustmentQty = stockAdjustmentQty;
    }

    public double getCogsQty() {
        return cogsQty;
    }

    public void setCogsQty(double cogsQty) {
        this.cogsQty = cogsQty;
    }

    public double getNetSalesQty() {
        return netSalesQty;
    }

    public void setNetSalesQty(double netSalesQty) {
        this.netSalesQty = netSalesQty;
    }

    public double getEndingQty() {
        return endingQty;
    }

    public void setEndingQty(double endingQty) {
        this.endingQty = endingQty;
    }


}
