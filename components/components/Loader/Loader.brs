Function Init()

    m.top.backgroundUri = ""
    m.top.backgroundColor = "transparent"
    spinner = m.top.FindNode("spinner")
	spinner.poster.uri="pkg:/images/loader.png"

    label = m.top.FindNode("label")
    label.text = m.message
End Function 
