' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' 1st function that runs for the scene component on channel startup
sub init()
  m.Video       = m.top.findNode("Video")
  m.Exiter      = m.top.findNode("Exiter")
  m.Warning     = m.top.findNode("Warning")
  m.HomeScreen  = m.top.findNode("HomeScreen")
  m.SpringBoard = m.top.findNode("SpringBoard")
  m.SpringList  = m.top.findNode("LabelList")
  m.HomeRow     = m.top.findNode("HomeRow")
  m.CScreen     = m.top.findNode("CategoryScreen")
  m.CRow        = m.top.findNode("CategoryRow")

  m.temp = invalid

  m.UriHandler  = createObject("roSGNode","UriHandler")
  url = "http://rokudev.roku.com/rokudev/examples/videoplayer/xml/categories.xml"
  makeRequest({}, url, "GET", 0, "")
  'm.ButtonGroup.setFocus(true)
  'm.ButtonGroup.observeField("buttonSelected","onButtonSelected")
  m.UriHandler.observeField("content","onContentSet")
  m.UriHandler.observeField("categorycontent","onCategoryContentSet")
end sub

sub onRowItemSelected(event as object)
  print "onRowItemSelected"
  item = m.HomeScreen.rowItemSelected[1]
  node = m.HomeRow.content.getchild(0).getchild(item)
  m.UriHandler.category = node.title
  m.UriHandler.contentSet = false
  print "m.URIHANDLER.CATEGORY: " ; m.UriHandler.category

  if m.UriHandler.cache.hasField(m.UriHandler.category)
    setCategoryContent()
    return
  end if
  m.uriHandler.numRows += node.count
  m.uriHandler.numCurrentRows = node.count
  for each field in node.getFields()
    if type(node.getField(field)) = "roAssociativeArray"
      if field <> "change"
        aa = node.getfield(field)
        url = aa.url
        title = aa.title
        makeRequest({}, url, "GET", 1, title)
      end if
    end if
  end for
end sub

sub onCategoryItemSelected()
  print "onCategoryItemSelected"
  item = m.CScreen.rowItemSelected[1]
  node = m.CRow.content.getchild(0).getchild(item)
  m.CScreen.visible = false
  m.SpringBoard.visible = true
  m.SpringList.setFocus(true)
  m.SpringBoard.content = node
end sub

sub setCategoryContent()
  print "setCategoryContent"
  m.CRow.content = m.UriHandler.Cache[m.UriHandler.category]
  m.HomeScreen.visible = false
  m.CScreen.visible = true
  m.CRow.setFocus(true)
end sub

sub onContentSet(event as object)
  print "onContentSet"
  m.HomeRow.content = m.UriHandler.content
  m.HomeScreen.visible = true
  m.HomeRow.setFocus(true)
end sub

sub onCategoryContentSet(event as object)
  print "onCategoryContentSet"
  m.CRow.content = m.UriHandler.categorycontent
  m.HomeScreen.visible = false
  m.CScreen.visible = true
  m.CRow.setFocus(true)
  'm.UriHandler.numRowsReceived = 0
  'm.UriHandler.contentSet = false
end sub

sub makeRequest(headers as object, url as String, method as String, num as Integer, title as String)
  print "[makeRequest] - " + url
  context = createObject("roSGNode", "Node")
  params = {
    headers: headers,
    uri: url,
    method: method
  }
  context.addFields({
    parameters: params,
    title: title,
    num: num,
    response: {}
  })
  m.UriHandler.request = { context: context }
end sub

sub onButtonSelected()
  'Ok'
  if m.ButtonGroup.buttonSelected = 0
    m.Video.visible = "true"
    m.Video.control = "play"
    m.Video.setFocus(true)
  'Exit button pressed'
  else
    m.Exiter.control = "RUN"
  end if
end sub

' Called when a key on the remote is pressed
function onKeyEvent(key as String, press as Boolean) as Boolean
  print "in SimpleVideoScene.xml onKeyEvent ";key;" "; press
  if press then
    if key = "back"
      print "------ [back pressed] ------"
      if m.Warning.visible
        m.Warning.visible = false
        return true
      else if m.Video.visible
        m.Video.control = "stop"
        m.Video.visible = false
        m.ButtonGroup.setFocus(true)
        return true
      else if m.CScreen.visible
        m.CScreen.visible = false
        m.CRow.content = invalid
        m.HomeScreen.visible = true
        m.HomeRow.setFocus(true)
        return true
      else
        return false
      end if
    else if key = "OK"
      print "------- [ok pressed] -------"
      if m.Warning.visible
        m.Warning.visible = false
        return true
      end if
    else
      return false
    end if
  end if
  return false
end function
