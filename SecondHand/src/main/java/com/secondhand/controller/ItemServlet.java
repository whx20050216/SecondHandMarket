package com.secondhand.controller;

import com.google.gson.Gson;
import com.secondhand.entity.Item;
import com.secondhand.entity.User;
import com.secondhand.service.ItemService;
import com.secondhand.service.Impl.ItemServiceImpl;
import com.secondhand.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/item/*")
public class ItemServlet extends HttpServlet {

    private ItemService itemService = new ItemServiceImpl();
    private Gson gson = JsonUtil.getGson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        if ("/list".equals(action) || action == null) {
            String keyword = req.getParameter("keyword");
            List<Item> items = (keyword != null && !keyword.isEmpty())
                    ? itemService.searchItems(keyword)
                    : itemService.getAllItems();

            req.setAttribute("items", items);
            req.setAttribute("keyword", keyword);

            // 🎯 如果是 AJAX 请求，只返回列表片段
            if ("true".equals(req.getParameter("ajax"))) {
                req.getRequestDispatcher("/WEB-INF/views/_items_fragment.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
            }
        } else if ("/detail".equals(action)) {
            Long id = Long.parseLong(req.getParameter("id"));
            req.setAttribute("item", itemService.getById(id));
            req.getRequestDispatcher("/WEB-INF/views/detail.jsp").forward(req, resp);
        } else if ("/my".equals(action)) {
            if (loginUser == null) {
                resp.sendRedirect(req.getContextPath() + "/user/login");
                return;
            }
            req.setAttribute("items", itemService.getUserItems(loginUser.getId()));
            req.getRequestDispatcher("/WEB-INF/views/my_items.jsp").forward(req, resp);
        } else if ("/publish".equals(action)) {
            if (loginUser == null) {
                resp.sendRedirect(req.getContextPath() + "/user/login");
                return;
            }
            req.getRequestDispatcher("/WEB-INF/views/publish.jsp").forward(req, resp);
        } else if ("/edit".equals(action)) {
            if (loginUser == null) {
                resp.sendRedirect(req.getContextPath() + "/user/login");
                return;
            }
            Long id = Long.parseLong(req.getParameter("id"));
            Item item = itemService.getById(id);
            if (item == null || !item.getUserId().equals(loginUser.getId())) {
                resp.sendError(403, "无权操作");
                return;
            }
            req.setAttribute("item", item);
            req.getRequestDispatcher("/WEB-INF/views/edit.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();
        resp.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        // 🎯 根据 action 类型分别处理
        if ("/publish".equals(action) || "/update".equals(action)) {
            // 这些请求使用 JSON body
            String jsonBody = readJsonBody(req);

            if ("/publish".equals(action)) {
                if (loginUser == null) {
                    result.put("success", false);
                    result.put("message", "请先登录");
                } else {
                    Item item = gson.fromJson(jsonBody, Item.class);
                    item.setUserId(loginUser.getId());
                    boolean publishSuccess = itemService.publish(item);
                    result.put("success", publishSuccess);
                    result.put("message", publishSuccess ? "发布成功" : "发布失败");
                }
            } else if ("/update".equals(action)) {
                if (loginUser == null) {
                    result.put("success", false);
                    result.put("message", "请先登录");
                } else {
                    Item item = gson.fromJson(jsonBody, Item.class);
                    boolean updateSuccess = itemService.update(item, loginUser.getId());
                    result.put("success", updateSuccess);
                    result.put("message", updateSuccess ? "修改成功" : "无权修改");
                }
            }
        }
        else if ("/delete".equals(action) || "/mark-sold".equals(action)) {
            // 这些请求使用 application/x-www-form-urlencoded
            if (loginUser == null) {
                result.put("success", false);
                result.put("message", "请先登录");
            } else {
                Long itemId = Long.parseLong(req.getParameter("id"));

                if ("/delete".equals(action)) {
                    boolean deleteSuccess = itemService.delete(itemId, loginUser.getId());
                    result.put("success", deleteSuccess);
                    result.put("message", deleteSuccess ? "删除成功" : "无权删除");
                } else if ("/mark-sold".equals(action)) {
                    boolean markSuccess = itemService.markAsSold(itemId, loginUser.getId());
                    result.put("success", markSuccess);
                    result.put("message", markSuccess ? "标记成功" : "操作失败");
                }
            }
        }
        else if ("/purchase".equals(action)) {
            if (loginUser == null) {
                result.put("success", false);
                result.put("message", "请先登录");
            } else {
                Long itemId = Long.parseLong(req.getParameter("id"));
                boolean purchaseSuccess = itemService.purchase(itemId, loginUser.getId());
                result.put("success", purchaseSuccess);
                result.put("message", purchaseSuccess ? "购买成功！" : "购买失败（可能已售出或不能购买自己的物品）");
            }
        }

        resp.getWriter().write(gson.toJson(result));
    }

    private String readJsonBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }
}