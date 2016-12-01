  sub Init()
    m.Poster = m.top.findNode("poster")
    m.Label = m.top.findNode("label")
    m.Label.color = "#333333"
    m.SubLabel = m.top.findNode("sublabel")
    m.SubLabel.color = "#444444"
  end sub

  sub itemContentChanged()
    m.Poster.loadDisplayMode = "scaleToZoom"
    m.Label.text = m.top.itemcontent.Title
    m.SubLabel.text = m.top.itemcontent.shortdescriptionline2
    updateLayout()
    m.Poster.uri = m.top.itemContent.HDPOSTERURL
    m.Label.translation = [10, m.poster.height + 20]
    m.SubLabel.translation = [10, m.poster.height + 65]
  end sub

  sub updateLayout()
    if m.top.height > 0 And m.top.width > 0 then
      m.Poster.width  = m.top.width
      m.Poster.height = m.top.height
      m.Label.width = m.top.width
      m.SubLabel.width = m.top.width
    end if
  end sub