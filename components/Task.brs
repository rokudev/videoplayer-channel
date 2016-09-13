  sub init()
    m.port = createObject("roMessagePort")
    m.top.observeField("read", m.port)
    m.top.observeField("write", m.port)
    m.top.functionName = "go"
    m.top.control = "RUN"
  end sub

  sub go()
    print "Task.xml - [go]"
    DeviceInfo  = CreateObject("roDeviceInfo")
    while true
      msg = wait(0, m.port)
      if msg.getField()="read"
        result = RegRead(msg.getData())
        if result = invalid
          m.top.result = "0"
        else
          m.top.result = result
        end if
      else if msg.getField()="write"
        aa = msg.getData()
        RegWrite(aa.contentid, aa.position)
      else
        print "Error: Unknown Field"
      end if
    end while
  end sub

  '******************************************************
  'Registry Helper Functions
  '******************************************************
  Function RegRead(key, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key) then return sec.Read(key)
    return invalid
  End Function

  Function RegWrite(key, val, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
    sec.Flush() 'commit it
  End Function

  Function RegDelete(key, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Delete(key)
    sec.Flush()
  End Function