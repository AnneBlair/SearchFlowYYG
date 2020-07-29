#    A Basic Search Flow 设计思路

* [x] 编译环境：Xcode Version 11.5 
* [x] 系统版本：iOS 13 + 
* [x] 语言：Swift, SwiftUI
* [x] 完成日期：2020年7月26日
* [x] 修改日期：2020年7月27日

-------

**前沿回顾**

页面首选是做一个搜索 - 结果实时展示
>  A Basic Search Flow
> Requirements:

> 1. Reproduce the flow in the right side

> 2. Host a local in-app http server with a search API which:
> (1) returns a group of mock data that can be resolved as
> the second figure when the keyword equals to “Dyson”.

> (2) returns empty data otherwise.
> Bonus:

> 1. Pagination logic

   

**设计梳理：**

## 一、UI部分 
**难度：★★☆☆☆**

-------

### 1. 首选定制的搜索框：
`SearchBar`
### 2. 定制的 **List** 结果 **Row**: 

`FlowRow`

部分问题及替代方案说明：


ScrollView 暂时没有内建的 cell 重用机制，对于例子来说，只展示少部分cell，所以不会带来太大的性能问题 (包括内存消耗和创建 View 的时间消耗)。但是对于更长的列表，使用 List 会是更可靠的选择。

List 的默认格式会为 cell 添加额外的默认 padding，所以左右的间距会有一些问题，但可以通过调整 PokemonInfoRow 的 padding 来修正这个问题。不过真正的问题在于，列表在每个 cell 之间添加了默认的分隔线。当前 SwiftUI API 并没有提供可以移除或者编辑这些分隔线的 API。可以通过桥接一个 UIKit 中的 UITableView 来绕过这个问题，或者使用一些“富有技巧性”的 List 变形来隐藏它们，但我不认为这是合理的解决方案。也许在未来的版本，Apple 会添加编辑 List 分隔线的 API，在此之前，这里选择使用 ScrollView 来布局。

### 3. 键盘处理
`AnyGestureRecognizer`


## 二、数据库
**难度：★★★☆☆**

-------


这里是使用 CoreData 数据库，其底层依然是SQL 对于SQL 语句同样适用，通过自建的数据库模拟网络请求，如果直接使用 **sqlit** 需要集成相关的第三方库，比如 **FMDB** 等, 利用**CoreData** 同样可以解决，这里使用数据库的知识只是 **CoreData** 架构的一部分，笔者对于 **CoreData** 的使用有一些积累.

这里使用大致流程是：

1. **数据建模**
2. **实体和属性映射**
3. **设置 CoreData 栈**
4. **操作数据**


### 1. CoreData 架构

一个基本的 Core Data 栈由四个主要部分组成：

**托管对象** (managed objects) (NSManagedObject)

**托管对象上下文** (managed object context) (NSManagedObjectContext)

**持久化存储协调器** (persistent store coordinator) (NSPersistentStoreCoordinator)

**以及持久化存储** (persistent store) (NSPersistentStore)：

架构图：![参考架构图.PDF (图 1)](https://github.com/AnneBlair/SearchFlowYYG/blob/master/YYG-Image/CoreData%20%E6%9E%B6%E6%9E%84%E5%9B%BE.png?raw=true)


### 2. 相关主要事件函数构建

* 利用单例单记录 `NSManagedObjectContext`

* APP 首次启动 **CoreData** 栈构造 `createMoodyContainer`

* 初次数据初始化：**人工伪数据构造**

* 基本 **NSManagedObjectContext** 相关使用扩展

`saveOrRollback()`

`performSaveOrRollback()`

`performChanges`

* 数据库查询类处理
	`FlowCoreData`
	
	
	利用**谓词**特性：进行匹配拥有某个特定的前缀
	
	**BEGINSWITH**   `cd` 不区分大小写
	
	``` 
	let predicate = NSPredicate(format: "%K BEGINSWITH[cd] %@",
        #keyPath(Flow.brand), brand)
	```

## 三、SwiftUI 架构设计简要说明
**难度：★★★★★**

-------

利用类似于 **Redux**，针对 **SwiftUI** 的特点进行了一些改变的数据管理方式。它遵循数据状态和绑定。

结合 **Combine** 的特性进行处理数据流. 

**Combine 架构图参考:** ![参考架构图.PDF (图 2)](https://github.com/AnneBlair/SearchFlowYYG/blob/master/YYG-Image/Combin%20%E6%A1%86%E6%9E%B6%E5%9B%BE.png?raw=true)

**本 Demo 设计架构图:** ![参考架构图.PDF (图 3)](https://github.com/AnneBlair/SearchFlowYYG/blob/master/YYG-Image/SwiftUI%20%E6%A1%86%E6%9E%B6%E5%9B%BE.png?raw=true)

-------


### 1. SwiftUI 简要架构说明：

-------

将 app 当作一个状态机，状态决定用户界面。


这些状态都保存在一个 **Store** 对象中。

**View** 不能直接操作 **State**，而只能通过发送 **Action** 的方式，间接改变存储在 **Store** 中的 **State**。

**Reducer** 接受原有的 **State** 和发送过来的 **Action**，生成新的 **State**。

用新的 **State** 替换 **Store** 中原有的状态，并用新状态来驱动更新界面。


传统 Redux 有两点比较大的限制，在 SwiftUI 中会显得有些水土不服，可能需要一些改进。

首先，只能通过发送 Action 的方式，间接改变存储在 Store 中的 State 这个要求太过严格。SwiftUI 有着方便和现成的 Binding 行为，来完成状态和界面的双向绑定。使用这个特性可以大幅简化程序的编写，同时保持数据流的清晰稳定。因此，这里为状态改变设置一个例外：除了通过 Action 外，也可以通过 Binding 来改变状态。

其次，希望 Reducer 具有纯函数特性，但是在实际开发中，会遇到非常多带有副作用 (side effect) 的情况：比如在改变状态的同时，需要向磁盘写入文件，或者需要进行网络请求。在上图3中，没有阐释这类副作用应该如何处理。有一些架构实现选择不区分状态和副作用，让它们混在一起进行，有一些架构选择在 Reducer 前添加一层中间件 (middleware)，来把 Action 进行预处理。
在 PokeMaster app 的架构中，选择在 Reducer 处理当前 State 和 Action 后，除了返回新的 State 以外，再额外返回一个 **Command** 值，并让 **Command** 来执行所需的副作用。

结构参考 **Demo:** 目录： **SearchFlowYYG - State - DataFlow**


### 2. SwiftUI Combine 简要说明：

-------

对于通过 Action 改变的状态，如果想要执行网络请求这样的副作用，可以通过同时返回合适的 **AppCommand** 完成。但是对于通过绑定来更新的状态，不会经过 **Store** 的 **reduce** 方法来返回 **Command**



* 使用 Publisher
* 状态合并
* 订阅状态
* 使用 Combine 的网络请求
* 防抖 (debounce) 和过滤重复元素 (removeDuplicates) 「参考：**搜索内容校验**」

-------

### 3. 单向数据流 架构设计说明

首先，将类似交互请求具体逻辑放到 View 中，这让 Model 和 View 形成了高度的耦合。随着
把越来越多的逻辑放在 View 中，最终也必然导致 View 的功能和职责越趋复杂。除了定义样式布局之外，它还需要承担修改 app 状态和组织逻辑的工作，最终出现类似 Massive View Controller 那样的庞大化问题。

更重要的是，对于 AppState 的修改将分散在 app 各处：对于同一个属性的修改可能会在不同的地方进行；某些属性的修改可能对另外的一些属性产生影响；在状态逐渐复杂时，对现有逻辑的修改往往需要在 app 各个 View 代码之间跳转和来回确认。很快 app 状态的复杂程度和维护难度都将超过人类极限，这是绝大部分 bug 产生的来源，会导致项目开发难以持续。


最后，将逻辑代码放在 View 中，导致这部分逻辑难以测试。我们很难去一段测试代码，来模拟按钮的点击，然后去判断写在 View 的事件里的逻辑是否正确。但是如果单纯的状态变化逻辑统一放到 Reducer 中，那单元测试就将轻而易举。通过构建需要的 AppState，我们可以以任意 app 状态作为测试的起始。而与 UI 视图层行为脱钩的 app 状态，和没有副作用的 reducer 方法，让我们有机会覆盖所有的使用情况。

通过 Action 间接改变状态，在短时间和状态很简单 app 中，似乎有点“得不偿失”。但是在长期和复杂的情况下，它的优势将非常明显。


![设计架构图.PDF (图 3)](https://github.com/AnneBlair/SearchFlowYYG/blob/master/YYG-Image/SwiftUI%20%E6%A1%86%E6%9E%B6%E5%9B%BE.png?raw=true)

### 四、单元测试结果

![设计架构图.PDF (图 3)](https://github.com/AnneBlair/SearchFlowYYG/blob/master/YYG-Image/Test%20%E7%BB%93%E6%9E%9C.png?raw=true)

### 五、数据库字段设计说明

![设计架构图.PDF (图 5)](https://github.com/AnneBlair/SearchFlowYYG/blob/master/YYG-Image/%E6%95%B0%E6%8D%AE%E5%BA%93%E5%AD%97%E6%AE%B5%E8%AE%BE%E8%AE%A1%E8%AF%B4%E6%98%8E.png?raw=true)

### 六、效果演示链接
[视频地址](https://github.com/AnneBlair/SearchFlowYYG/blob/master/%E6%BC%94%E7%A4%BA.MP4)

-------

创作不易，分享请注明出处，么么哒😘

