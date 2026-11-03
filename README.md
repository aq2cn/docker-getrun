### 直接拿到重建容器的完整 run 命令（神器）

安装工具 `docker run` 反向生成命令：

```
# 安装 docker-getrun（可选，快速拿到启动命令）
curl -s https://raw.githubusercontent.com/aq2cn/docker-getrun/master/docker-getrun.sh > docker-getrun.sh
chmod +x docker-getrun.sh
./docker-getrun.sh <容器ID>
```

输出类似：

```
docker run -d --name xxx -p 8080:80 -v /host:/container -e ENV=xxx 镜像名
```

**把这条命令保存到 txt 文件！重装系统装好 docker 后，直接执行这条命令就能重建一模一样的容器。**
