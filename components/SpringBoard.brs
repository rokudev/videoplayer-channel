' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' 1st function that runs for the scene component on channel startup
sub init()
  'To see print statements/debug info, telnet on port 8089
  m.Image       = m.top.findNode("Image")
  m.Details     = m.top.findNode("Details")
  m.Title       = m.top.findNode("Title")
  m.Video       = m.top.findNode("Video")
end sub

sub onContentChange(event as object)
  print "onContentChange"
  content = event.getdata()
  stop
  m.Image.uri = content.hdposterurl
  m.Title.text = content.title
  m.Details.text = content.description

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


' Called when a key on the remote is pressed
function onKeyEvent(key as String, press as Boolean) as Boolean
  print "in SimpleVideoScene.xml onKeyEvent ";key;" "; press
  if press then
    if key = "back"
      print "------ [back pressed] ------"
      if m.Video.visible
        m.Video.control = "stop"
        m.Video.visible = false
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
