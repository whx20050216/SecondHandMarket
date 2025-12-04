package com.secondhand.controller;

import com.google.gson.Gson;
import com.secondhand.entity.User;
import com.secondhand.service.UserService;
import com.secondhand.service.Impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();
    private Gson gson = new Gson(); // 创建Gson实例

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        // 退出登录
        if ("/logout".equals(action)) {
            req.getSession().removeAttribute("loginUser");
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // 页面跳转（登录/注册页）
        if ("/login".equals(action)) {
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        } else if ("/register".equals(action)) {
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();
        resp.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        // 读取请求体中的JSON
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String jsonBody = sb.toString();

        if ("/login".equals(action)) {
            User user = gson.fromJson(jsonBody, User.class); // Gson解析JSON
            User loginUser = userService.login(user.getUsername(), user.getPassword());

            if (loginUser != null) {
                req.getSession().setAttribute("loginUser", loginUser);
                result.put("success", true);
                result.put("message", "登录成功");
            } else {
                result.put("success", false);
                result.put("message", "用户名或密码错误");
            }
        } else if ("/register".equals(action)) {
            User user = gson.fromJson(jsonBody, User.class); // Gson解析JSON

            if (userService.register(user)) {
                result.put("success", true);
                result.put("message", "注册成功");
            } else {
                result.put("success", false);
                result.put("message", "用户名已存在");
            }
        }

        resp.getWriter().write(gson.toJson(result)); // Gson生成JSON
    }
}