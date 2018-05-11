function GetTaskService()
    return {
        new: function (resolver, scope = invalid)
            return {
                taskId: m.taskId,
                scope: scope,
                result: invalid,
                resolver: resolver,
                error: invalid,
                'wait for the result. Will only calculate the result once
                wait: function()
                    if m.result = invalid then
                        'get the result, and accept any error
                        m.result = m.resolver(m.scope, m)
                        'if we got a TaskError returned, blank the result and set the error
                        if b_isAssociativeArray(m.result) and m.result.class = "NewTaskError" then
                            b_printc("Task has error -- ", m.hasError)
                            m.error = m.result 
                            m.result = invalid
                        end if
                    end if
                    return m
                end function
            }
        end function,
        '''
        ''' Get a new task error object
        '''
        getTaskError: function (message as string, data = invalid as dynamic)
            return {
                class: "NewTaskError",
                message: message,
                data: data
            }
        end function,
        '''
        '''Wait for every task in the list to complete
        '''
        waitAll: function(tasks) as dynamic
            for each task in tasks
                task.wait()
            end for
        end function
    }
end function
