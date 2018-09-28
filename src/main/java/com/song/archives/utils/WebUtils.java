package com.song.archives.utils;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.ConversionException;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.Converter;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Map;

public class WebUtils {



    public static <T> T request2Bean(HttpServletRequest request, Class<T> beanClass){

        ConvertUtils.register(new Converter()
        {


            @SuppressWarnings("rawtypes")
            @Override
            public Object convert(Class arg0, Object arg1)
            {
                if(arg1 == null)
                {
                    return null;
                }
                if(!(arg1 instanceof String))
                {
                    throw new ConversionException("只支持字符串转换 !");
                }
                String str = (String)arg1;
                if(str.trim().equals(""))
                {
                    return null;
                }

                SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd");

                try{
                    return sd.parse(str);
                }
                catch(ParseException e)
                {
                    throw new RuntimeException(e);
                }

            }

        }, java.util.Date.class);

        try{
            //实例化传进来的类型
            T t = beanClass.newInstance();
            //之前使用request.getParameter("name")根据表单中的name值获取value值
            //request.getParameterMap()方法不需要参数，返回结果为Map<String,String[]>，也是通过前台表单中的name值进行获取
            Map map = request.getParameterMap();

            //将Map中的值设入bean中，其中Map中的key必须与目标对象中的属性名相同，否则不能实现拷贝
            BeanUtils.populate(t, map);
            return t;
        }catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

}