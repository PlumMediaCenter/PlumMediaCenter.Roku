function Api()
    if m.api <> invalid then 
        return m.api
    end if
    
    m.api = {
        getMovies: function(callback, callerScope)
            HttpRequest({
                url: "http://192.168.1.20:7586/api/movies"
            }, function(data, scope) 
                scope.callback(data, scope.callerScope)
            end function, {callback: callback, callerScope: callerScope})
        end function
    }
    
    return m.api
end function

'''
''' Parameters for the request
''' {url}
'''
sub HttpRequest(params, callback, scope)
    'keep a list of all running requests
    if m.requestTaskContainers = invalid then
        m.requestTaskContainers = []
        m.taskIdCounter = 0
    end if
    
    requestTask = CreateObject("roSGNode", "RequestTask")
    requestTask.url = params.url
    requestTask.taskId = m.taskIdCounter
    requestTask.control = "RUN"
    
    m.requestTaskContainers.Push({
        requestTask: requestTask,
        callback: callback,
        scope: scope
    })
    
    requestTask.observeField("completed", "HttpRequestHandleCompleted")
end sub

sub HttpRequestHandleCompleted()
    if m.requestTaskContainers.Count() = 0 then
        return
    end if
    indexesToDelete = []
    for i = 0 to m.requestTaskContainers.Count() - 1
        container = m.requestTaskContainers[i]
        
        'only handle the current task
        if container.requestTask.completed = true then
            'remove this task from the list of pending tasks
            m.requestTaskContainers.delete(i)
            container.requestTask.unobserveField("completed")
            'back the index up to account for the newly deleted item
            indexesToDelete.push(i)
            jsonObject = ParseJson(container.requestTask.responseJson)
            container.callback(jsonObject, container.scope)
            'exit this function. Every request will call this function once, so even if we processed the wrong request, it will get processed soon
            return
        end if
    end for
end sub