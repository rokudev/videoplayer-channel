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
  x = m.Details.localBoundingRect()
  m.RuntimeLabel.text = "Length: " + minutes.toStr() + " minutes " + seconds.toStr() + " seconds"
  translation = [m.RuntimeLabel.translation[0], m.Details.translation[1] + x.height + 30]
  m.RuntimeLabel.translation = translation
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

sub onItemSelected(event as object)
  print "onItemSelected"
  m.Video.control = "play"
  if event.getData() <> 0 then m.Video.seek = m.top.seekposition
  m.SpringDetails.visible = false
  m.Video.visible = true
  m.Video.setFocus(true)
end sub

' Called when a key on the remote is pressed
function onKeyEvent(key as String, press as Boolean) as Boolean
  print "in SimpleVideoScene.xml onKeyEvent ";key;" "; press
  if press then
    if key = "back"
      print "------ [back pressed] ------"
      if m.Video.visible
        m.Video.control = "pause"
        m.Video.visible = false
        m.SpringDetails.visible = true
        position = m.Video.position
        if position > 0
          if m.LabelList.content.getChildCount() > 1 then m.LabelList.content.removeChildIndex(1)
          minutes = position \ 60
          seconds = position MOD 60
          contentNode = createObject("roSGNode","ContentNode")
          contentNode.title = "Resume Video (" + minutes.toStr() + " min " + seconds.toStr() + " sec)"
          m.LabelList.content.appendChild(contentNode)
          'Write position to registry so that re-opening the channel works
          m.global.registryTask.write = {
            contentid: m.top.content.episodenumber,
            position: position.toStr()
          }
          m.top.seekposition = position
        else
          print "Do nothing"
        end if
        m.LabelList.setFocus(true)
        return true
      else
        return false
      end if
    else if key = "OK"
      print "------- [ok pressed] -------"
    else
      return false
    end if
  end if
  return false
end function
