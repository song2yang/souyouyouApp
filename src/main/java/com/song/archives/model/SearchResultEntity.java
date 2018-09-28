package com.song.archives.model;


public class SearchResultEntity {

    private long id;
    private String resultName;
    private String resultKey;
    private String resultType;

    private String miniResultType;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getResultName() {
        return resultName;
    }

    public void setResultName(String resultName) {
        this.resultName = resultName;
    }

    public String getResultKey() {
        return resultKey;
    }

    public void setResultKey(String resultKey) {
        this.resultKey = resultKey;
    }

    public String getResultType() {
        return resultType;
    }

    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    public String getMiniResultType() {
        return miniResultType;
    }

    public void setMiniResultType(String miniResultType) {
        this.miniResultType = miniResultType;
    }
}
