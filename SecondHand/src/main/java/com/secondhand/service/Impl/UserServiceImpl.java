package com.secondhand.service.Impl;

import com.secondhand.dao.UserDao;
import com.secondhand.dao.Impl.UserDaoImpl;
import com.secondhand.entity.User;
import com.secondhand.service.UserService;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class UserServiceImpl implements UserService {

    private UserDao userDao = new UserDaoImpl();

    // ================= 密码加密工具（MD5，作业够用） =================
    private String encryptPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("加密算法不存在", e);
        }
    }

    @Override
    public boolean register(User user) {
        // 1. 检查用户名是否已存在（业务校验）
        if (userDao.findByUsername(user.getUsername()) != null) {
            return false;
        }

        // 2. 密码加密存储（核心要求：不能存明文）
        user.setPassword(encryptPassword(user.getPassword()));

        // 3. 调用Dao插入数据库
        return userDao.insert(user) > 0;
    }

    @Override
    public User login(String username, String password) {
        // 1. 查询用户
        User user = userDao.findByUsername(username);

        // 2. 比对加密后的密码
        if (user != null && user.getPassword().equals(encryptPassword(password))) {
            return user;
        }
        return null;
    }

    @Override
    public User getById(Long id) {
        return userDao.findById(id);
    }
}