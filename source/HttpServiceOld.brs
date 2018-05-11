function GetHttpService()
    if m.http = invalid then 
        m.http =  {
            request: function (url as string)
                taskService = GetTaskService()
                request = CreateObject("roUrlTransfer")
                request.SetUrl(url)
                port = CreateObject("roMessagePort")
                request.SetMessagePort(port)
                
                scope = {
                    request: request, 
                    port: port, 
                    url: url, 
                    immediatelyFailed: invalid
                }
                if (request.AsyncGetToString()) then
                    scope.immediatelyFailed = false
                else
                    scope.immediatelyFailed = true
                end if
                
                'return a task that will wait for the response at a later time
                t = taskService.new(function(scope, taskService)
                    if (scope.immediatelyFailed <> true) then
                        while (true)
                            b_printc("http: waiting for response: ", scope.url)
                            msg = wait(0, scope.port)
                            if (type(msg) = "roUrlEvent") then
                                responseText = msg.GetString()
                                b_printc("http: server responded: ", scope.url, " -- ", responseText)
                                code = msg.GetResponseCode()
                                if len(responseText) > 0 then
                                    b_printc("http: parse as json: ", scope.url)
                                    obj = ParseJson(responseText)
                                else
                                    b_printc("http: empty response")
                                    obj = responseText
                                end if
                                if (code = 200) then
                                    return obj
                                else
                                    b_printc("http: failed with status code: ", scope.url, " -- ", code)
                                    return taskService.getTaskError("Request failed. See data for more details", {url: scope.url, code: code, data: obj})
                                end if
                            else if (event = invalid)
                                request.AsyncCancel()
                                b_printc("http: unknown error: ", scope.url)
                                return taskService.getTaskError("Unknown error", {url: scope.url})
                            end if
                        end while
                    else
                        b_printc("http: request immediately failed: ", scope.url)
                        return taskService.getTaskError("Unknown error", {url: scope.url})
                    end if
                end function, scope)
                return t
            end function,
            get: function(url as string)
                return request(url)
            end function
        }
    end if
    return m.http
end function