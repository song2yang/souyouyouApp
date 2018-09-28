package com.song.archives.enums;

/**
 * Created by souyouyou on 2018/2/3.
 */
public enum Views {
    Login("login","login");
    private String viewName;
    private String value;

    public String getViewName() {
        return viewName;
    }

    public void setViewName(String viewName) {
        this.viewName = viewName;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    Views(String viewName, String value) {
        this.viewName = viewName;
        this.value = value;
    }
}
