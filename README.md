# Handan :construction: :construction: :construction:  :construction: :construction: :construction: 

简体中文 | [English](./README.EN.md)

项目正在建设中，它是面向中小企业的企业资源计划（制造执行系统）解决方案之一。

前端页面基于 NextJS 框架，[点击此处](https://github.com/zven21/handan_web)。

## **快速上手**

要启动 Phoenix 服务器并运行测试：
* 运行 `mix setup` 安装并设置依赖项。
* 运行 `mix test` 来运行应用程序的测试。
* 使用 `mix phx.server` 启动 Phoenix 端点，或者在 IEx 中使用 `iex -S mix phx.server` 启动。
* 现在你可以从浏览器访问 `http://localhost:4000`。

## **技术栈**

本项目使用了以下技术：

* **Phoenix**: 一个用于 Elixir 的 web 框架，允许创建快速、可扩展和可维护的 web 应用程序。
* **Commanded(CQRS)**: 一个用于构建事件驱动系统的命令处理框架。
* **Absinthe(GraphQL)**: 一个用于 API 的查询语言，允许更灵活和高效的数据检索。


## **流程图**

![flow](./docs/flow.jpg)

## **任务**

- [x] 核心领域模型
- [x] 账号和Session模块
- [x] 企业模块
- [x] 库存 && 商品模块
- [x] 销售模块
- [x] 采购模块
- [x] 生产制造模块
- [x] 财务模块
- [x] 外协模块
- [x] GraphQL API

## **贡献**

欢迎提交 Bug 报告或提交 Pull Request。

## **提交 Pull Request**

* fork 本项目
* 创建你的特性分支（`git checkout -b my-new-feature`）
* 提交你的更改（`git commit -am 'Add some feature'`）
* 推送至该分支（`git push origin my-new-feature`）
* 创建新的 Pull Request

如有必要，请为你的代码编写单元测试。

## **许可证**

本项目依据 [MIT License](http://opensource.org/licenses/MIT) 开源。
