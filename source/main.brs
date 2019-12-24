sub RunUserInterface()
    '#region
    screen = CreateObject("roSGScreen")
    m.scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()
    '#endregion

    while(true)
        msg = wait(0, port)
    end while

    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
end sub
