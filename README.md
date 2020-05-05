
# 创建基本的PHP S2I镜像构建器 

## 入门 

### 依赖环境
- docker >= 1.6
- Go >= 1.7.1
- go-md2man
- (可选) Git
### 文件和目录
| 文件                   | 必须 | 描述                                               |
|------------------------|-----------|--------------------------------------------------------------|
| s2i-builder/Dockerfile             | Yes       | 定义基础构建镜像                   |
| s2i-builder/s2i/bin/assemble       | Yes       | 生成应用程序的脚本                 |
| s2i-builder/s2i/bin/usage          | Yes       | 构建用法描述脚本                   |
| s2i-builder/s2i/bin/run            | Yes       | 运行应用程序的脚本                 |
| s2i-builder/s2i/bin/save-artifacts | No        | 用于增量构建的脚本，用于保存构建的工件 |
| s2i-builder/test/run               | Yes       | 镜像构建测试脚本                   |
| s2i-builder/test/test-app          | Yes       | 测试应用程序源代码                 |

#### Dockerfile
创建一个Dockerfile，其中安装了构建和运行应用程序所需的所有必要工具和库。该文件还将处理将s2i脚本复制到创建的映像中的过程。

#### S2I脚本

##### assemble
创建一个汇编脚本来构建我们的应用程序，例如：
- 构建PHP模块
- 捆绑安装 composer
- 设置应用程序特定的配置

该脚本还可以指定一种基础镜像还原所有保存的工件的方法。   

##### run
创建一个运行脚本，将启动应用程序。

##### save-artifacts (可选)
创建一个save-artifacts脚本，该脚本允许新版本重用应用程序映像先前版本中的内容。

##### usage (可选) 
创建一个用法脚本，该脚本将打印出有关如何使用图像的说明。

##### 脚本权限添加
chmod +x s2i/bin/* 添加脚本文件可执行权限。

#### 开始构建镜像
应用程序映像将构建器映像与您的应用程序源代码组合在一起，该源代码可通过Dockerfile安装，使用汇编脚本进行编译并使用运行脚本运行的任何应用程序来提供。以下命令将创建应用程序映像：
```
cd s2i-builder
make build
```
输出如下信息代表构建成功

镜像完成构建后 命令 *s2i usage php-73-centos7* 将打印出用法脚本中定义的帮助信息.

#### 测试镜像构建
可以使用以下命令测试镜像：
```
cd s2i-builder
make test
```

#### 运行应用程序镜像
运行应用程序映像就像调用docker run命令一样简单：
```
cd s2i-builder
docker run -d -p 9501:9501 -v ./test/test-app:/vsoole/app/src soinx/php-73-centos7
```
该应用程序由一个简单的静态网页组成，现在应该可以从 [http://localhost:8080](http://localhost:8080)进行访问 。

#### kubesphere 应用模板定义
推送 镜像到镜像仓库 
修改 s2i-php-swoole.yaml 中的 defaultBaseImage 和 builderImage 为你的镜像地址
使用如下命令 推送模板到 kubesphere集群 
```
kubectl apply -f s2i-php-swoole.yaml
```