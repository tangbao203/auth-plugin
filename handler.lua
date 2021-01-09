--
-- Created by IntelliJ IDEA.
-- User: tangbao
-- Date: 2020/12/8
-- Time: 10:44 上午
-- To change this template use File | Settings | File Templates.
--

authorityUrl="http://istio-ingressgateway.istio-system/auth/authority"
local BasePlugin = require "kong.plugins.base_plugin"
local TestAuthHandler = BasePlugin:extend()


local zhttp = require "resty.http"
local function http_post_client(url, timeout)
    local httpc = zhttp.new()

    timeout = timeout or 30000
    httpc:set_timeout(timeout)
    local res, err_ = httpc:request_uri(url, {
        method = "GET",
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        }
    })
    httpc:set_keepalive(5000, 100)
    --httpc:close()
    return res, err_
end


function TestAuthHandler:new()
    TestAuthHandler.super.new(self, "test-auth")
end


function TestAuthHandler:access(config)
    TestAuthHandler.super.access(self)
    -- 在这里实现自定义的逻辑
    print("\n===access AuthHandler======")
    print("\n=====当前配置config, max_request_count:",config.max_request_count," ,time_interval:",config.time_interval)
    local url=authorityUrl.."token=test-token";
    local resp, code = http_post_client(url,3000)
    if code ~= 200 or resp.body ~="true" then
        print("\n kong请求url:",url," 返回结果:",resp.body);
        kong.response.exit(401, "无权访问", { ["Content-Type"] = "application/json;charset=UTF-8" } )
    end
    print("\n===授权请求结果,err:",code," resp:",resp.body)
end

return TestAuthHandler

