sub init()
    m.grid = m.top.FindNode("grid")
    m.grid.visible = true
    m.grid.translation="[50,50]" 
    m.grid.basePosterSize="[200,300]" 
    m.grid.itemSpacing="[32,32]" 
    m.grid.caption1NumLines="0" 
    m.grid.caption2NumLines="0" 
    
    Api().getMovies(function(movies, m)
        m.grid.numColumns = 5
        m.grid.numRows = movies.count() / m.grid.numColumns + 1
        contentNode = createObject("roSGNode","ContentNode")
        for i = 0 to movies.Count() - 1
            movie = movies[i]
            posterNode = createObject("roSGNode","ContentNode")
            'use the 200px wide poster
            posterUrl = left(movie.posterUrl, movie.posterUrl.len() - 4) + "w200.jpg"
            posterNode.hdposterurl = posterUrl
            posterNode.sdposterurl = posterUrl
            contentNode.appendChild(posterNode)
        end for
        m.grid.content = contentNode
        m.grid.visible = true
        m.grid.setFocus(true)
        m.top.setFocus(true)
    end function, m)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    'only handle the keyup events
    if press = false then
        if key = "ok" then
            
        end if
    end if
end function
