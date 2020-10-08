package com.project.fms.transaction;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class BankRegister extends Entity {
    private long userId = 0;
    private String docNumber = "";
    private Date transDate = new Date();
    private String checkBGNumber = "";
    private String name = "";
    private String description = "";
    private double debet = 0;
    private double credit = 0;
    private int status = 0;

    public String getCheckBGNumber() {
        return checkBGNumber;
    }

    public void setCheckBGNumber(String checkBGNumber) {
        this.checkBGNumber = checkBGNumber;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public double getDebet() {
        return debet;
    }

    public void setDebet(double debet) {
        this.debet = debet;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDocNumber() {
        return docNumber;
    }

    public void setDocNumber(String docNumber) {
        this.docNumber = docNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getTransDate() {
        return transDate;
    }

    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

}
