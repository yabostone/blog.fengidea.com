---
title: "Nginx源码分析七 红黑树变化"
date: 2024-06-19T16:34:33+08:00
draft: false
tags:
  - 源码
categories:
  - 技术
---

Nginx 使用红黑树来管理各种数据结构，如定时器事件、虚拟服务器等。红黑树是一种自平衡二叉搜索树，它通过特定的属性和操作保持树的平衡，从而确保搜索、插入和删除操作的最坏情况时间复杂度为 O(log n)。下面详细介绍 Nginx 中红黑树的实现和关键操作。

### 红黑树的属性
红黑树的每个节点具有以下属性：
- **颜色**：每个节点被涂成红色或黑色。
- **链接**：每个节点包含左子节点、右子节点和父节点的链接。
- **键值**：用于树的排序和搜索。

红黑树的平衡通过以下规则维护：
1. 每个节点非红即黑。
2. 根节点是黑色的。
3. 红色节点的子节点必须是黑色的（不会有两个连续的红色节点）。
4. 从任一节点到其每个叶子的所有路径都包含相同数目的黑色节点。

### 关键函数和操作

#### 插入操作
插入操作首先像在普通二叉搜索树中一样插入节点，然后通过一系列的颜色更改和树旋转来修复可能违反红黑树性质的问题。

- **ngx_rbtree_insert**：这是插入操作的主函数，它调用 `ngx_rbtree_insert_value` 或 `ngx_rbtree_insert_timer_value` 来插入节点，并保持树的平衡。

```c
void ngx_rbtree_insert(ngx_rbtree_t *tree, ngx_rbtree_node_t *node) {
    ngx_rbtree_node_t  **root, *temp, *sentinel;

    /* 标准的二叉搜索树插入 */
    root = &tree->root;
    sentinel = tree->sentinel;

    if (*root == sentinel) {
        node->parent = NULL;
        node->left = sentinel;
        node->right = sentinel;
        ngx_rbt_black(node);
        *root = node;
        return;
    }

    tree->insert(*root, node, sentinel);

    /* 修复红黑树性质 */
    while (node != *root && ngx_rbt_is_red(node->parent)) {
        if (node->parent == node->parent->parent->left) {
            temp = node->parent->parent->right;
            if (ngx_rbt_is_red(temp)) {
                ngx_rbt_black(node->parent);
                ngx_rbt_black(temp);
                ngx_rbt_red(node->parent->parent);
                node = node->parent->parent;
            } else {
                if (node == node->parent->right) {
                    node = node->parent;
                    ngx_rbtree_left_rotate(root, sentinel, node);
                }
                ngx_rbt_black(node->parent);
                ngx_rbt_red(node->parent->parent);
                ngx_rbtree_right_rotate(root, sentinel, node->parent->parent);
            }
        } else {
            // 对称的操作
        }
    }

    ngx_rbt_black(*root);
}
```

#### 删除操作
删除操作也需要进行树的平衡调整。删除可能会破坏红黑树的性质，因此需要通过旋转和重新着色来修复。

- **ngx_rbtree_delete**：从树中删除指定的节点，并通过旋转和重新着色维持红黑树的性质。

```c
void ngx_rbtree_delete(ngx_rbtree_t *tree, ngx_rbtree_node_t *node) {
    ngx_uint_t           red;
    ngx_rbtree_node_t  **root, *sentinel, *subst, *temp, *w;

    /* 标准的二叉搜索树删除 */
    root = &tree->root;
    sentinel = tree->sentinel;

    // 省略具体删除逻辑

    /* 修复红黑树性质 */
    if (ngx_rbt_is_red(temp)) {
        ngx_rbt_black(temp);
    } else {
        while (temp != *root && ngx_rbt_is_black(temp)) {
            if (temp == temp->parent->left) {
                w = temp->parent->right;
                if (ngx_rbt_is_red(w)) {
                    ngx_rbt_black(w);
                    ngx_rbt_red(temp->parent);
                    ngx_rbtree_left_rotate(root, sentinel, temp->parent);
                    w = temp->parent->right;
                }
                if (ngx_rbt_is_black(w->left) && ngx_rbt_is_black(w->right)) {
                    ngx_rbt_red(w);
                    temp = temp->parent;
                } else {
                    if (ngx_rbt_is_black(w->right)) {
                        ngx_rbt_black(w->left);
                        ngx_rbt_red(w);
                        ngx_rbtree_right_rotate(root, sentinel, w);
                        w = temp->parent->right;
                    }
                    ngx_rbt_copy_color(w, temp->parent);
                    ngx_rbt_black(temp->parent);
                    ngx_rbt_black(w->right);
                    ngx_rbtree_left_rotate(root, sentinel, temp->parent);
                    temp = *root;
                }
            } else {
                // 对称的操作
            }
        }
        ngx_rbt_black(temp);
    }
}
```

这次文章详细介绍了nginx中的红黑树操作，并且给出了红黑树的具体操作字段。给出对应的代码。

具体的算法和红黑树的原理其实可以在算法里面进行描述。



