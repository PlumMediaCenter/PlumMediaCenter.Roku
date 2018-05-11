
function init()
    print "in SimpleRowListPanel init()"
    m.top.itemComponentName = "MainGridItem"
    m.top.numRows = 2
    m.top.itemSize = [196 * 3 + 20 * 2, 213]
    m.top.rowHeights = [213]
    m.top.rowItemSize = [ [196, 213], [196, 213], [196, 213] ]
    m.top.itemSpacing = [ 0, 80 ]
    m.top.rowItemSpacing = [ [20, 0] ]
    m.top.rowLabelOffset = [ [0, 30] ]
    m.top.rowFocusAnimationStyle = "floatingFocus"
    m.top.showRowLabel = [true, true]
    m.top.rowLabelColor="0xFFFFFFFF"
    'm.top.content = GetRowListContent()
    m.top.visible = true
    m.top.SetFocus(true)
    m.top.ObserveField("rowItemFocused", "onRowItemFocused")
    LoadRowListContent()
end function

function LoadRowListContent() as object
    Api().getMovies(function(movies, m)
        'Populate the RowList content here
        rowsNode = CreateObject("roSGNode", "ContentNode")
        for numRows = 0 to 1
            row = rowsNode.CreateChild("ContentNode")
            row.title = "Row " + stri(numRows)
            for i = 0 to movies.Count() - 1
                movie = movies[i]
                item = row.CreateChild("MainGridItemData")
                item.posterUrl = movie.posterUrl
                item.labelText = movie.title
            end for
        end for
        m.top.content = rowsNode
    end function, m)
    
end function

function onRowItemFocused() as void
    row = m.top.rowItemFocused[0]
    col = m.top.rowItemFocused[1]
    print "Row Focused: " + stri(row)
    print "Col Focused: " + stri(col)
end function