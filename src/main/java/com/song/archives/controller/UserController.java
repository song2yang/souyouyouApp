package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.OperationRepository;
import com.song.archives.dao.UserRepository;
import com.song.archives.model.OperationLog;
import com.song.archives.model.User;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import org.apache.shiro.subject.Subject;
import org.springframework.web.servlet.ModelAndView;

import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by souyouyou on 2018/2/1.
 */

@Controller
@RequestMapping("/")
public class UserController {

    Logger logger = Logger.getLogger(UserController.class);

    public static String SUCCESS = "success";

    private String msg = "failed";

    private String operationLogInfo = "";

    private JSONObject result = new JSONObject();

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OperationRepository operationRepository;


    /**
     * 视图跳转
     *
     * @param viewName
     * @return
     */
    @ArchivesLog(operationType = "viewName", operationName = "视图跳转")
    @RequestMapping(value = "/{viewName}")
    String viewJump(@PathVariable("viewName") String viewName) {
        return viewName;
    }

    @ArchivesLog(operationType = "login", operationName = "登录页面")
    @RequestMapping(value = "/")
    String login() {
        return "login";
    }


    /**
     * 日志页面
     *
     * @return
     */
    @ArchivesLog(operationType = "logList", operationName = "日志页面")
    @RequestMapping(value = "logList")
    String logList() {
        return "log/list";
    }

    @ArchivesLog(operationType = "userInfo", operationName = "用户基本信息")
    @RequestMapping(value = "userInfo")
    public ModelAndView userInfo(@RequestParam(value = "uId") Long uId) {
        ModelAndView mav = new ModelAndView("member/info");
        User userInfo = userRepository.findOne(uId);
        mav.addObject("userInfo",userInfo);
        return mav;
    }

    /**
     * 日志列表
     *
     * @param page
     * @param size
     * @return
     */
    @ArchivesLog(operationType = "logs", operationName = "日志列表")
    @RequestMapping(value = "logs")
    @ResponseBody
    String logs(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                @RequestParam(value = "operationUsername", defaultValue = "") String operationUsername,
                @RequestParam(value = "operationDetail", defaultValue = "") String operationDescrib) {
        page = page - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(page, size, sort);


        Specification<OperationLog> specification = (root, criteriaQuery, criteriaBuilder) -> {

            List<Predicate> predicates = new ArrayList<>();

            if (!operationUsername.equals("")) {
                predicates.add(criteriaBuilder.like(root.get("operationUserName"), "%" + operationUsername + "%"));
            }

            if (!operationDescrib.equals("")) {
                predicates.add(criteriaBuilder.like(root.get("operationDescrib"), "%" + operationDescrib + "%"));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
        };

        Page<OperationLog> operationLogs = operationRepository.findAll(specification, pageable);

        operationLogInfo = "用户【" + getUser().getUsername() + "】执行查询日志操作";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(operationLogs));
        return result.toString();
    }

    /**
     * 修改账户状态
     *
     * @param id
     * @param status
     * @return
     */
    @ArchivesLog(operationType = "operateUser", operationName = "修改账户状态")
    @RequestMapping(value = "operateUser")
    @ResponseBody
    String operateUser(@RequestParam(value = "uid") Long id,
                       @RequestParam(value = "status") Boolean status) {

        result = new JSONObject();

        try {

            User user = userRepository.findOne(id);
            user.setAvailable(status);
            userRepository.save(user);

            operationLogInfo = "用户【" + getUser().getUsername() + "】修改用户【" + user.getUsername() + "】状态为:" + status;
            msg = SUCCESS;

        } catch (Exception e) {
            logger.error("修改账户状态:" + e.getMessage());
            msg = "Exception";
        }

        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);

        return result.toString();
    }

    @RequestMapping(value = "updatePassword")
    @ResponseBody
    public String updatePwd(@RequestParam(value = "oldPwd")String oldPwd,
                            @RequestParam(value = "newPwd")String newPwd,
                            @RequestParam(value = "repeatPwd")String repeatPwd){

        operationLogInfo = "用户【" + getUser().getUsername() + "】修改密码";
        result = new JSONObject();
        String passWord = new SimpleHash(Md5Hash.ALGORITHM_NAME, oldPwd, getUser().getUsername(), 2).toHex();

        if (!getUser().getPassword().equals(passWord)){
            msg = "原始密码错误";
        }else {

            if (!newPwd.equals(repeatPwd)){
                msg = "新密码与确认密码不一致";
            }

            User user = getUser();
            user.setPassword(new SimpleHash(Md5Hash.ALGORITHM_NAME, repeatPwd, getUser().getUsername(), 2).toHex());
            userRepository.save(user);
            msg = SUCCESS;

        }




        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);

        return result.toString();

    }

    /**
     * 新建用户
     *
     * @param user
     * @return
     */
    @ArchivesLog(operationType = "saveUser", operationName = "新建用户")
    @RequestMapping(value = "saveUser")
    @ResponseBody
    String saveUser(User user) {

        user.setPassword(new SimpleHash(Md5Hash.ALGORITHM_NAME, user.getPassword(), user.getUsername(), 2).toHex());
        user.setType(0);
        user.setAvailable(true);

        try {
            userRepository.save(user);
            msg = "success";
        } catch (Exception e) {
            msg = "save user failed";
        }

        operationLogInfo = "用户【" + getUser().getUsername() + "】新建用户:" + user.toString();
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @ArchivesLog(operationType = "getUserInfo", operationName = "新建用户")
    @RequestMapping(value = "getUserInfo")
    @ResponseBody
    String getUserInfo(Long uid) {

        User user = userRepository.findOne(uid);

        return JSONObject.fromObject(user).toString();

    }

    /**
     * 删除勾选用户
     *
     * @param uids
     * @return
     */
    @ArchivesLog(operationType = "deleteUserByIds", operationName = "删除勾选用户")
    @RequestMapping(value = "deleteUserByIds")
    @ResponseBody
    String deleteUserByIds(Long[] uids) {

        operationLogInfo = "用户【" + getUser().getUsername() + "】删除用户【";
        try {
            if (uids != null && uids.length > 0) {

                for (Long uid : uids) {
                    User userObj = userRepository.findOne(uid);
                    operationLogInfo += userObj.getUsername() + ",";
                    userRepository.delete(userObj);
                }
            }

            msg = SUCCESS;
        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "delete user failed";
        }

        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果【" + msg + "】";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }


    /**
     * 用户列表
     *
     * @return
     */
    @ArchivesLog(operationType = "memberList", operationName = "用户列表")
    @RequestMapping(value = "/memberList")
    String memberList() {
        return "member/list";
    }


    /**
     * 查询用户信息
     *
     * @param page
     * @param size
     * @return
     */
    @RequestMapping(value = "/users")
    @ResponseBody
    @ArchivesLog(operationType = "users", operationName = "查询用户信息")
    String users(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                 @RequestParam(value = "pageSize", defaultValue = "10") Integer size) {
        page = page - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(page, size, sort);

        Specification<User> specification = (root, criteriaQuery, criteriaBuilder) -> {

            List<Predicate> predicates = new ArrayList<>();

            //屏蔽超级管理员
            predicates.add(criteriaBuilder.notEqual(root.get("username"), "superadmin"));
            predicates.add(criteriaBuilder.notEqual(root.get("username"), "administrator"));
            predicates.add(criteriaBuilder.notEqual(root.get("username"), "securitor"));
            predicates.add(criteriaBuilder.notEqual(root.get("username"), "comptroller"));

            return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
        };


        List<User> users = userRepository.findAll(specification, pageable);

        operationLogInfo = "用户【" + getUser().getUsername() + "】执行查询用户列表操作";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(users));
        return result.toString();
    }

    @RequestMapping(value = "/getlallusers")
    @ResponseBody
    @ArchivesLog(operationType = "getlallusers", operationName = "查询所有用户信息")
    String GetAllUsers() {

        Specification<User> specification = (root, criteriaQuery, criteriaBuilder) -> {

            // List<Predicate> predicates = new ArrayList<>();

            Path<Integer> usertype = root.get("type");


            Predicate predicate = criteriaBuilder.equal(usertype.as(Integer.class), 0);


            //return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            return predicate;
        };


        Iterable<User> users = userRepository.findAll(specification);


        return JSONArray.fromObject(users).toString();
    }


    /**
     * 用户登录
     *
     * @param username
     * @param password
     * @return
     */
    @RequestMapping(value = "/sign_in")
    @ResponseBody
    @ArchivesLog(operationType = "sign_in", operationName = "登录")
    String sign_in(@RequestParam("username") String username,
                   @RequestParam("password") String password, HttpSession session) {


        Subject currentUser = SecurityUtils.getSubject();

        Md5Hash mh = new Md5Hash(password, username, 2);
        UsernamePasswordToken token = new UsernamePasswordToken(username, mh.toString());

        token.setRememberMe(true);


        try {
            currentUser.login(token);
            User user = (User) currentUser.getPrincipal();
//            SecurityUtils.getSubject().getSession().setTimeout(1000);
            session.setAttribute("user", user);
            msg = SUCCESS;
        } catch (UnknownAccountException e) {
            msg = "账户不存在!";
        } catch (IncorrectCredentialsException e) {
            msg = "账户密码错误!";
        } catch (DisabledAccountException e) {
            msg = "账户状态异常!";
        } catch (AuthenticationException e) {
            logger.error("认证失败 : " + e.getMessage());
            msg = "登录异常!";
        }

        operationLogInfo = "用户【" + username + "】登录操作,操作结果 【" + msg + "】";

        result.put("operationLog", operationLogInfo);
        result.put("msg", msg);
        return JSONObject.fromObject(result).toString();

    }


    @RequestMapping(value = "/sign_out")
    @ArchivesLog(operationType = "sign_out", operationName = "登出")
    public String sign_out() {

        Subject subject = SecurityUtils.getSubject();
        subject.logout();
        return "login";

    }

    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }

}
