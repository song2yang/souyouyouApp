package com.song.archives.bean;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by souyouyou on 2018/3/12.
 */
public class Main {
    public static void main(String[] args) {
        String str = "<p>2222</p>\n";

        Pattern p = Pattern.compile("\n");
        Matcher m = p.matcher(str);
        boolean b = m.find();

        int i = str.lastIndexOf("\n");
        System.out.println(str.substring(0,i));
    }

}
