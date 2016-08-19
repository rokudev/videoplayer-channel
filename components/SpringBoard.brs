' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' 1st function that runs for the scene component on channel startup
sub init()
  'To see print statements/debug info, telnet on port 8089
  m.Image         = m.top.findNode("Image")
  m.Details       = m.top.findNode("Details")
  m.Title         = m.top.findNode("Title")
  m.Video         = m.top.findNode("Video")
  m.SpringDetails = m.top.findNode("SpringBoardDetails")
  m.LabelList     = m.top.findNode("LabelList")
  m.CategoryLabel = m.top.findNode("CategoryLabel")
  m.RuntimeLabel  = m.top.findNode("RuntimeLabel")
  m.Title.font.size = 40
  m.CategoryLabel.color = "#333333"
  m.Title.color = "#333333"
  m.Details.color = "#444444"
  m.RuntimeLabel.color = "#333333"
end sub

sub onContentChange(event as object)
  print "onContentChange"
  content = event.getdata()

  runtime = content.shortdescriptionline2.toInt()
  minutes = runtime \ 60
  seconds = runtime MOD 60

  m.Image.uri = content.hdposterurl
  m.Title.text = content.title
  m.Details.text = content.description
  m.RuntimeLabel.text = "Length: " + minutes.toStr() + " minutes " + seconds.toStr() + " seconds"
  m.CategoryLabel.text = content.categories

  ContentNode = CreateObject("roSGNode", "ContentNode")
  ContentNode.streamFormat = content.streamformat
  ContentNode.url = content.url
  ContentNode.Title = content.title
  ContentNode.Description = content.Description
  ContentNode.ShortDescriptionLine1 = content.title
  ContentNode.StarRating = 80
  ContentNode.Length = 1972
  ContentNode.subtitleConfig = {Trackname: "pkg:/source/CraigVenter.srt" }

  m.Video.content = ContentNode
end sub

sub onItemSelected()
  print "onItemSelected"
  m.SpringDetails.visible = false
  m.Video.visible = true
  m.Video.control = "play"
  m.Video.setFocus(true)
end sub

' Called when a key on the remote is pressed
function onKeyEvent(key as String, press as Boolean) as Boolean
  print "in SimpleVideoScene.xml onKeyEvent ";key;" "; press
  if press then
    if key = "back"
      print "------ [back pressed] ------"
      if m.Video.visible
        m.Video.control = "stop"
        m.Video.visible = false
        m.SpringDetails.visible = true
        if m.Video.position <> invalid or m.Video.position <> 0
          minutes = m.Video.position \ 60
          seconds = m.Video.position MOD 60
          contentNode = createObject("roSGNode","ContentNode")
          contentNode.title = "Resume Video (" + minutes.toStr() + " min " + seconds.toStr() + " sec)"
          m.LabelList.content.appendChild(contentNode)
        end if
        m.LabelList.setFocus(true)
        return true
      else
        return false
      end if
    else if key = "OK"
      print "------- [ok pressed] -------"
      'm.ButtonGroup.setFocus(true)
      'return true
    else
      return false
    end if
  end if
  return false
end function

'******************************************************
'Get remaining hours from a total seconds
'******************************************************
Function hoursLeft(seconds As Integer) As Integer
  hours% = seconds / 3600
  return hours%
End Function

'******************************************************
'Get remaining minutes from a total seconds
'******************************************************
Function minutesLeft(seconds As Integer) As Integer
  hours% = seconds / 3600
  mins% = seconds - (hours% * 3600)
  mins% = mins% / 60
  return mins%
End Function
