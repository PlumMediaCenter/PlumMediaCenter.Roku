function util_findServerUrls(ipAddresses=invalid)
    di = CreateObject("roDeviceInfo")
    b_printc("di: ", di)
    
    info = di.GetConnectionInfo()
    ip = info.ip
    parts = ip.split(".")
    tasks = []
    taskContainers = []
    if ipAddresses = invalid then
        ipAddresses = []
        'make a list of all ip addresses in the subnet
        for i=0 to 255 step 1
            ipAddress = b_concat(parts[0], ".", parts[1], ".", parts[2], ".", i)
            ipAddresses.push(ipAddress)
        end for
    end if
    
    'send a request to every ip address in the list
    for each ipAddress in ipAddresses
        baseUrl = b_concat("http://", ipAddress, ":7586/")
        isAliveUrl = b_concat(baseUrl, "api/isAlive")
        task = http_get(isAliveUrl)
        tasks.push(task)
        taskContainers.push({
            task: task,
            url: baseUrl
        })
    end for
    'wait for all of the requests to finish
    task_waitAll(tasks)
    
    urls = []
    'find any non-failed requests
    for each taskContainer in taskContainers
        if taskContainer.task.error = invalid then
            urls.push(taskContainer.url)
        end if
    end for
    return urls
end function