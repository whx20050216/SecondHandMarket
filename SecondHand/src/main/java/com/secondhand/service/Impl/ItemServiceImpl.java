package com.secondhand.service.Impl;

import com.secondhand.dao.ItemDao;
import com.secondhand.dao.Impl.ItemDaoImpl;
import com.secondhand.entity.Item;
import com.secondhand.service.ItemService;
import java.util.List;

public class ItemServiceImpl implements ItemService {

    private ItemDao itemDao = new ItemDaoImpl();

    @Override
    public boolean publish(Item item) {
        // 发布时默认状态就是on_sale，Dao里已处理
        return itemDao.insert(item) > 0;
    }

    @Override
    public boolean update(Item item, Long currentUserId) {
        // 1. 检查物品是否存在且属于当前用户
        Item oldItem = itemDao.findById(item.getId());
        if (oldItem == null || !oldItem.getUserId().equals(currentUserId)) {
            return false; // 无权修改
        }

        // 2. 已售出的物品不允许任何修改
        if ("sold".equals(oldItem.getStatus())) {
            return false; // 已售出物品不可编辑
        }

        // 禁止将状态从已售出改回在售
        if ("sold".equals(oldItem.getStatus()) && "on_sale".equals(item.getStatus())) {
            return false;
        }

        // 3. 正常更新
        return itemDao.update(item) > 0;
    }

    @Override
    public boolean delete(Long itemId, Long currentUserId) {
        // 只能删除自己的物品
        Item item = itemDao.findById(itemId);
        if (item == null || !item.getUserId().equals(currentUserId)) {
            return false; // 无权删除
        }
        return itemDao.delete(itemId, currentUserId) > 0;
    }

    @Override
    public Item getById(Long id) {
        return itemDao.findById(id);
    }

    @Override
    public List<Item> getAllItems() {
        return itemDao.findAll();
    }

    @Override
    public List<Item> getUserItems(Long userId) {
        return itemDao.findByUserId(userId);
    }

    // 模糊查询
    @Override
    public List<Item> searchItems(String keyword) {
        // 1. 处理参数：前后加 % 实现模糊匹配
        String fuzzyKeyword = "%" + keyword + "%";

        // 2. 调用Dao的模糊查询
        return itemDao.findByFuzzyKeyword(fuzzyKeyword);
    }

    // 标记售出
    @Override
    public boolean markAsSold(Long itemId, Long userId) {
        Item item = itemDao.findById(itemId);
        if (item == null || !item.getUserId().equals(userId)) {
            return false; // 只能标记自己的
        }
        return itemDao.markAsSold(itemId, userId) > 0;
    }

    @Override
    public boolean purchase(Long itemId, Long buyerId) {
        Item item = itemDao.findById(itemId);

        // 校验：物品必须存在、在售、且不能购买自己的
        if (item == null || !item.getStatus().equals("on_sale") || item.getUserId().equals(buyerId)) {
            return false;
        }

        return itemDao.markAsSold(itemId, item.getUserId()) > 0; // 标记为已售出
    }
}