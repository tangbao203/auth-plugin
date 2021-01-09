--
-- Created by IntelliJ IDEA.
-- User: tangbao
-- Date: 2020/12/8
-- Time: 10:46 上午
-- To change this template use File | Settings | File Templates.
--


return {
    --name="test-auth",
    no_consumer = true, -- this plugin will only be applied to Services or Routes,
    fields = {
        max_request_count = {type="number"},
        time_interval = {type = "number"}
    },
    self_check = function(schema, plugin_t, dao, is_updating)
        -- 自定义的验证函数
        return true
    end
}

