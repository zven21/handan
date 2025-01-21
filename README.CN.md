# Handan :construction: :construction: :construction:

简体中文 | [English](./README.md)

项目正在建设中，它是面向中小企业的企业资源计划（制造执行系统）解决方案之一。

前端页面基于 NextJS 框架，[点击此处](https://github.com/zven21/handan_web)。

<div align="center">
	<img src="./docs/live-demo.jpg"/>
</div>

<div align="center">
	<a href="https://handan-web.vercel.app">Live Demo</a>
</div>

## 简介

许多中小型企业在寻找 ERP（制造执行系统）软件时面临两难境地。市场上的相关软件要么功能过于复杂，企业在使用时需要投入大量时间和精力去学习与适应，这导致员工上手困难，甚至可能降低工作效率而非提高。要么价格过高，对于资金和资源相对有限的小企业来说，采购及后续维护成本成为沉重负担，极大地限制了企业数字化转型的步伐。
基于对这些痛点的深刻理解，我们决心自主开发一款适合小企业的可配置流程的 ERP（MES）系统。
目前，我们已成功完成最小可行产品（MVP）版本。尽管现阶段可能仍存在一些小漏洞，但核心业务流程，即我们常说的 “Happy Path”，已能顺利完成。这意味着企业最关键的业务操作，如生产计划制定、物料管理、订单跟踪等，都可通过该系统高效实现。

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

- [x] MVP 
- [x] 账号和Session模块
- [ ] 企业模块
- [ ] 库存 && 商品模块
- [ ] 销售模块
- [ ] 采购模块
- [ ] 生产制造模块
- [ ] 财务模块
- [ ] 外协模块

## **贡献**

欢迎提交 Bug 报告或提交 Pull Request。

## **提交 Pull Request**

* fork 本项目
* 创建你的特性分支（`git checkout -b my-new-feature`）
* 提交你的更改（`git commit -am 'Add some feature'`）
* 推送至该分支（`git push origin my-new-feature`）
* 创建新的 Pull Request

如有必要，请为你的代码编写单元测试。

## **开源许可**

本项目依据 [MIT License](http://opensource.org/licenses/MIT) 开源。
