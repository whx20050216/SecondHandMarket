package com.secondhand.dao.impl;

import com.secondhand.dao.ItemDao;
import com.secondhand.entity.Item;
import com.secondhand.util.DBUtil;
import java.util.List;

public class ItemDaoImpl implements ItemDao {

    //结果集自动映射器
    private static final DBUtil.RowMapper<Item> ITEM_MAPPER = rs -> {
        Item item = new Item();
        item.setId(rs.getLong("id"));
        item.setTitle(rs.getString("title"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getDouble("price"));
        item.setUserId(rs.getLong("user_id"));
        item.setStatus(rs.getString("status"));
        item.setCreateTime(rs.getTimestamp("create_time").toLocalDateTime());
        item.setDeleted(rs.getInt("deleted"));
        return item;
    };

    @Override
    public int insert(Item item) {
        // 新发布的物品默认状态为'on_sale'
        String sql = "INSERT INTO item(title, description, price, user_id, status) VALUES(?, ?, ?, ?, 'on_sale')";
        return DBUtil.executeUpdate(sql,
                item.getTitle(),
                item.getDescription(),
                item.getPrice(),
                item.getUserId()
        );
    }

    @Override
    public List<Item> findAll() {
        // 只查询未删除的物品，按发布时间倒序
        String sql = "SELECT * FROM item WHERE deleted = 0 ORDER BY create_time DESC";
        return DBUtil.executeQuery(sql, ITEM_MAPPER);
    }

    @Override
    public List<Item> findByUserId(Long userId) {
        // 查询指定用户的所有未删除物品
        String sql = "SELECT * FROM item WHERE user_id = ? AND deleted = 0";
        return DBUtil.executeQuery(sql, ITEM_MAPPER, userId);
    }

    @Override
    public Item findById(Long id) {
        // 查询单个物品详情
        String sql = "SELECT * FROM item WHERE id = ?";
        return DBUtil.executeQuery(sql, ITEM_MAPPER, id)
                .stream()
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Item> findByFuzzyKeyword(String keyword) {
        String sql = "SELECT * FROM item WHERE deleted = 0 AND (title LIKE ? OR description LIKE ?) ORDER BY create_time DESC";
        return DBUtil.executeQuery(sql, ITEM_MAPPER, keyword, keyword);
        // 注意：keyword参数传两次，一次匹配title，一次匹配description
    }

    @Override
    public int update(Item item) {
        // 更新物品信息（标题、描述、价格、状态）
        String sql = "UPDATE item SET title = ?, description = ?, price = ?, status = ? WHERE id = ?";
        return DBUtil.executeUpdate(sql,
                item.getTitle(),
                item.getDescription(),
                item.getPrice(),
                item.getStatus(),
                item.getId()
        );
    }

    @Override
    public int delete(Long id, Long userId) {
        // 逻辑删除：仅标记为删除状态，非物理删除，可恢复
        String sql = "UPDATE item SET deleted = 1 WHERE id = ? AND user_id = ?";
        return DBUtil.executeUpdate(sql, id, userId);
    }

    //标记为已售出
    public int markAsSold(Long id, Long userId) {
        String sql = "UPDATE item SET status = 'sold' WHERE id = ? AND user_id = ?";
        return DBUtil.executeUpdate(sql, id, userId);
    }
}