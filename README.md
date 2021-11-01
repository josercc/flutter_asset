# flutter_asset

将蓝湖下载的资源文件整合到 Flutter 对应的图片路径

## 怎么安装？

如果还没有安装 Mint，请先安装 Mint。

```bash
brew install mint
```

安装

```bash
mint install josercc/flutter_asset@main --force
```

## 怎么使用

### 1. 使用默认

```bash
# 在 Flutter 工程的目录下
cd /Users/king/Documents/flutter_win+

# 将下载蓝湖的资源复制到工程目录下面 ⚠️默认是导出在工程 images 文件夹下面
# 如果需要强行覆盖同名的添加 --allow-rewrite
# example `mint run flutter_asset@main /Users/king/Downloads/托盘绑定箱号_slices --allow-rewrite`
mint run flutter_asset@main /Users/king/Downloads/托盘绑定箱号_slices
```

### 2. 使用自定义导出目录

```bash
mint run flutter_asset@main /Users/king/Downloads/托盘绑定箱号_slices --to /Users/king/Documents/flutter_win+/images --allow-rewrite
```
