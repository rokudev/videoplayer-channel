  sub Init()
    m.Poster = m.top.findNode("poster")
    m.Label = m.top.findNode("label")
    m.Label.color = "#383838"
  end sub

  sub itemContentChanged()
    m.Poster.loadDisplayMode = "scaleToZoom"
    m.Label.text = m.top.itemcontent.Title
    updateLayout()
    m.Poster.uri = m.top.itemContent.HDPOSTERURL
    m.Label.translation = [10, m.poster.height + 15]
  end sub

  sub updateLayout()
    if m.top.height > 0 And m.top.width > 0 then
      m.Poster.width  = m.top.width
      m.Poster.height = m.top.height
      m.Label.width = m.top.width
    end if
  end sub