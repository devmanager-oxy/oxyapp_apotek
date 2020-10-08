package com.project.fms.master;

/**
 *
 * @author gwawan
 */
public class CommonObj {
    long id = 0;
    String number = "";
    String memo = "";

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

}
