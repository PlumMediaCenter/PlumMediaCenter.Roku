function HttpGet(url as string, params as object)
    request = CreateObject("roUrlTransfer")
    request.SetURL(sUrl)
    responseText = http.GetToString()
    return result
end function