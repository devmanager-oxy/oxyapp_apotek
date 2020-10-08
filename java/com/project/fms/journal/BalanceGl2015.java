/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.journal;

import com.project.main.entity.Entity;

/**
 *
 * @author Roy
 */
public class BalanceGl2015 extends Entity {

    private long periodId = 0;
    private double amount= 0;
    private long coaId= 0;
	    
    private long coaLevel1Id = 0;
    private long coaLevel2Id = 0;
    private long coaLevel3Id = 0;
    private long coaLevel4Id = 0;
    private long coaLevel5Id = 0;
    private long coaLevel6Id = 0;
    private long coaLevel7Id = 0;    
    
    private long segment1Id = 0;
    private long segment2Id = 0;
    private long segment3Id = 0;
    private long segment4Id = 0;
    private long segment5Id = 0;
    private int balanceType = 0;
    private long userId = 0;

    public long getPeriodId() {
        return periodId;
    }

    public void setPeriodId(long periodId) {
        this.periodId = periodId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public long getCoaLevel1Id() {
        return coaLevel1Id;
    }

    public void setCoaLevel1Id(long coaLevel1Id) {
        this.coaLevel1Id = coaLevel1Id;
    }

    public long getCoaLevel2Id() {
        return coaLevel2Id;
    }

    public void setCoaLevel2Id(long coaLevel2Id) {
        this.coaLevel2Id = coaLevel2Id;
    }

    public long getCoaLevel3Id() {
        return coaLevel3Id;
    }

    public void setCoaLevel3Id(long coaLevel3Id) {
        this.coaLevel3Id = coaLevel3Id;
    }

    public long getCoaLevel4Id() {
        return coaLevel4Id;
    }

    public void setCoaLevel4Id(long coaLevel4Id) {
        this.coaLevel4Id = coaLevel4Id;
    }

    public long getCoaLevel5Id() {
        return coaLevel5Id;
    }

    public void setCoaLevel5Id(long coaLevel5Id) {
        this.coaLevel5Id = coaLevel5Id;
    }

    public long getCoaLevel6Id() {
        return coaLevel6Id;
    }

    public void setCoaLevel6Id(long coaLevel6Id) {
        this.coaLevel6Id = coaLevel6Id;
    }

    public long getCoaLevel7Id() {
        return coaLevel7Id;
    }

    public void setCoaLevel7Id(long coaLevel7Id) {
        this.coaLevel7Id = coaLevel7Id;
    }

    public long getSegment1Id() {
        return segment1Id;
    }

    public void setSegment1Id(long segment1Id) {
        this.segment1Id = segment1Id;
    }

    public long getSegment2Id() {
        return segment2Id;
    }

    public void setSegment2Id(long segment2Id) {
        this.segment2Id = segment2Id;
    }

    public long getSegment3Id() {
        return segment3Id;
    }

    public void setSegment3Id(long segment3Id) {
        this.segment3Id = segment3Id;
    }

    public long getSegment4Id() {
        return segment4Id;
    }

    public void setSegment4Id(long segment4Id) {
        this.segment4Id = segment4Id;
    }

    public long getSegment5Id() {
        return segment5Id;
    }

    public void setSegment5Id(long segment5Id) {
        this.segment5Id = segment5Id;
    }

    public int getBalanceType() {
        return balanceType;
    }

    public void setBalanceType(int balanceType) {
        this.balanceType = balanceType;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
    
    
}
