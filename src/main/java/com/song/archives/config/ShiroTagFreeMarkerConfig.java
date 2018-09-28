package com.song.archives.config;

import com.jagregory.shiro.freemarker.ShiroTags;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

@Component
public class ShiroTagFreeMarkerConfig implements InitializingBean {


    @Autowired
    private FreeMarkerConfigurer freeMarkerConfigurer;

    @Override
    public void afterPropertiesSet() throws Exception {
        freeMarkerConfigurer.getConfiguration().setSharedVariable("shiro", new ShiroTags());
    }
}