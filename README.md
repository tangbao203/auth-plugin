# auth-plugin 
这个插件对所有的请求进行鉴权，具体是调用授权管理服务，根据其返回值来决定是否放行


## kong 插件目录结构
```
custom-plugin 
├── api.lua 
├── daos.lua 
├── handler.lua 
├── migrations
│ ├── cassandra.lua
│ └── postgres.lua
└── schema.lua # (必需)插件配置参数定义, 可加入自定义校验函数
```

## kong 插件的生命周期
```lua
-- 继承BasePlugin
local BasePlugin = require "kong.plugins.base_plugin" local CustomHandler = BasePlugin:extend()
-- 插件构造函数
function CustomHandler:new()
CustomHandler.super.new(self, "my-custom-plugin") end
function CustomHandler:init_worker() CustomHandler.super.init_worker(self) -- 在每个Nginx Worker启动时执行
end
function CustomHandler:certificate(config) CustomHandler.super.certificate(self)
-- 在SSL握手的SSL证书服务阶段执行
end
-- 用于扩展Admin API # 数据访问层
-- (必需)包含请求的生命周期, 提供接口来实现插件逻辑 # 插件的表结构定义语句
function CustomHandler:rewrite(config) CustomHandler.super.rewrite(self)
-- 每个请求中的rewrite阶段执行
end
function CustomHandler:access(config) CustomHandler.super.access(self)
-- 在被代理至上游服务前执行
end
function CustomHandler:header_filter(config) CustomHandler.super.header_filter(self)
-- 从上游服务器接收所有Response headers后执行
end
function CustomHandler:body_filter(config)
CustomHandler.super.body_filter(self)
-- 从上游服务接收的响应主体的每个块时执行。 由于响应被流回客户端，因此它可以超过缓冲区大小并按块
-- 进行流式传输。 因此,如果响应很大，则会多次调用此方法 end
function CustomHandler:log(config) CustomHandler.super.log(self)
-- 当最后一个响应字节输出完毕时执行
end
return CustomHandler
```


