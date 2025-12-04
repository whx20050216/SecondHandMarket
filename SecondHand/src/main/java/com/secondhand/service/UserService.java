package com.secondhand.service;

import com.secondhand.entity.User;

public interface UserService {
    boolean register(User user); // 注册
    User login(String username, String password); // 登录
    User getById(Long id); // 查询用户
}