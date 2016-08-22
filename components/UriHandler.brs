' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub init()
  print "UriHandler.brs - [init]"
  m.port = createObject("roMessagePort")
  ' fields for checking if content has been loaded
  m.top.count = 0
  m.top.numRows = 0
  m.top.numRowsReceived = 0
  m.top.numBadRequests = 0
  m.top.contentSet = false
  ' Stores the content if not all requests are ready
  m.top.ContentCache = createObject("roSGNode", "ContentNode")
  m.top.Cache        = createObject("roSGNode", "Node")
  ' setting callbacks for url request and response
  m.top.observeField("request", m.port)
  m.top.observeField("encodeRequest", m.port)
  m.top.observeField("ContentCache", m.port)
  ' setting the task thread function
  m.top.functionName = "go"
  m.top.control = "RUN"
end sub

'Task function
sub go()
  print "UriHandler.brs - [go]"
  ' Holds requests by id
  m.jobsById = {}
	' UriFetcher event loop
  while true
    msg = wait(0, m.port)
    mt = type(msg)
    print "--------------------------------------------------------------------------"
    print "Received event type '"; mt; "'"
    ' If a request was made
    if mt = "roSGNodeEvent"
      if msg.getField()="request"
        if addRequest(msg.getData()) <> true then print "Invalid request"
      else if msg.getField()="encodeRequest"
        if encodeRequest(msg.getData()) <> true then print "Invalid request"
      else if msg.getField()="ContentCache"
        updateContent()
      else
        print "Error: unrecognized field '"; msg.getField() ; "'"
      end if
    ' If a response was received
    else if mt="roUrlEvent"
      processResponse(msg)
    ' Handle unexpected cases
    else
	   print "Error: unrecognized event type '"; mt ; "'"
    end if
  end while
end sub

' Encode the url and call addRequest
function encodeRequest(request as Object) as Boolean
  encoder = createObject("roUrlTransfer")
  encodedStr = encoder.escape(request.strToEncode)
  newParam = { uri: request.context.parameters.uri + encodedStr }
  request.context.parameters = newParam
  return addRequest(request)
end function

' @Params:
'   request: an AA containing a "context" node
'     Context node fields:
'      parameters: the request parameters: Headers, Method, and Url
'      num: the number related to the request
function addRequest(request as Object) as Boolean
  print "UriHandler.brs - [addRequest]"
  if type(request) = "roAssociativeArray"
    context = request.context
  	if type(context) = "roSGNode"
      parameters = context.parameters
      if type(parameters)="roAssociativeArray"
        headers = parameters.headers
        method = parameters.method
      	uri = parameters.uri
        if type(uri) = "roString"
          urlXfer = createObject("roUrlTransfer")
          urlXfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
          urlXfer.InitClientCertificates()
          urlXfer.setUrl(uri)
          urlXfer.setPort(m.port)
          ' Add headers to the request
          for each header in headers
            urlXfer.AddHeader(header, headers.lookup(header))
          end for
          ' should transfer more stuff from parameters to urlXfer
          idKey = stri(urlXfer.getIdentity()).trim()
          'Make request based on request method
          ' AsyncGetToString returns false if the request couldn't be issued
          if method = "POST" or method = "PUT" or method = "DELETE"
            urlXfer.setRequest(method)
            ok = urlXfer.AsyncPostFromString("")
          else
            ok = urlXfer.AsyncGetToString()
          end if
          if ok then
            m.jobsById[idKey] = {
              context: request,
              xfer: urlXfer
            }
          else
            print "Error: request couldn't be issued"
          end if
  		    print "Initiating transfer '"; idkey; "' for URI '"; uri; "'"; " succeeded: "; ok
        else
          print "Error: invalid uri: "; uri
          m.top.numBadRequests++
  			end if
      else
        print "Error: parameters is the wrong type: " + type(parameters)
        return false
      end if
  	else
      print "Error: context is the wrong type: " + type(context)
  		return false
  	end if
  else
    print "Error: request is the wrong type: " + type(request)
    return false
  end if
  print "--------------------------------------------------------------------------"
  return true
end function

'Received a response
sub processResponse(msg as Object)
  print "UriHandler.brs - [processResponse]"
  idKey = stri(msg.GetSourceIdentity()).trim()
  job = m.jobsById[idKey]
  if job <> invalid
    context = job.context
    parameters = context.context.parameters
    jobnum = job.context.context.num
    uri = parameters.uri
    print "Response for transfer '"; idkey; "' for URI '"; uri; "'"
    result = {
      code:    msg.GetResponseCode(),
      headers: msg.GetResponseHeaders(),
      content: msg.GetString(),
      num:     jobnum
    }
    ' could handle various error codes, retry, etc. here
    m.jobsById.delete(idKey)
    job.context.context.response = result
    if msg.GetResponseCode() = 200
      if result.num = 3 or result.num = 4
        parseFollowedContent(job)
      else if result.num = 0
        parseResponse(job)
      else if result.num = 1
        parseLeaf(job)
      end if
    else if msg.GetResponseCode() = 204 and result.num = -7
      parseLogout(job)
    else if msg.GetResponseCode() = 204 and result.num = -10
      parseUnfollow(true)
    else
      if result.num > 0 and result.num < 3
        m.top.numBadRequests++
        m.top.numRowsReceived++
      else
        print "Error: status code was: " + (msg.GetResponseCode()).toStr()
      end if
    end if
  else
    print "Error: event for unknown job "; idkey
  end if
  print "--------------------------------------------------------------------------"
end sub

sub parseLeaf(job as object)
  print "UriHandler.brs - [parseLeaf]"
  result = job.context.context.response
  str = result.content
  num = result.num
  title = job.context.context.title

  xml = CreateObject("roXMLElement")

  if xml.parse(result.content)
    if xml.feed <> invalid
      row = CreateObject("roSGNode", "ContentNode")
      row.title = title
      for each element in xml.getChildElements()
        if element.getChildElements() <> invalid
          contentNode = CreateObject("roSGNode","ContentNode")
          contentNode.hdposterurl = element@hdImg
          contentNode.sdposterurl = element@sdImg
          for each child in element.getchildElements()
            if child.getname() = "title"
              contentNode.title = child.getText()
            else if child.getname() = "contentId"
              contentnode.episodeNumber = child.gettext()
            else if child.getname() = "genres"
              contentnode.categories = child.getText()
            'else if child.getname() = "contentQuality"
            ''  contentnode.contentQuality = child.gettext()
            else if child.getname() = "media"
              for each item in child.getchildElements()
                if item.getname() = "streamQuality"
                  contentnode.rating = item.gettext()
                else if item.getname() = "streamBitrate"
                  contentNode.maxBandWidth = item.gettext().toint()
                else if item.getname() = "streamUrl"
                  contentNode.url = item.gettext()
                else if item.getname() = "streamFormat"
                  contentnode.streamFormat = item.gettext()
                else
                  print "WHY AM I HERE: " ; item.getName() ; item.getText()
                end if
              end for
            else if child.getname() = "synopsis"
              contentnode.description = child.gettext()
            else if child.getname() = "genres"
              contentnode.shortdescriptionline1 = child.gettext()
            else if child.getname() = "runtime"
              contentnode.shortdescriptionline2 = child.gettext()
            end if
          end for
          row.appendChild(contentNode)
        end if
      end for
      if m.top.contentcache.hasfield(m.top.numRowsReceived.tostr()) then m.top.numRowsReceived++
      contentAA = {}
      contentAA[m.top.numRowsReceived.toStr()] = row
      m.top.contentCache.addFields(contentAA)
    end if
  end if
end sub

' For loading rowlist content
sub parseResponse(job as object)
  print "UriHandler.brs - [parseResponse]"
  result = job.context.context.response
  str = result.content
  num = result.num

  xml = CreateObject("roXMLElement")
  if xml.parse(result.content)
    if xml.category <> invalid
      if xml.category[0].GetName() = "category"
        print "begin category node parsing"

        categories = xml.GetChildElements()
        print "number of categories: " + categories.Count().toStr()

        '@ operator:
        'The @ operator can be used on an roXMLElement to return a named attribute.
        'It is always case insensitive (altho XML is technically case sensitive).
        'When used on an roXMLList, the @ operator will return a value only if
        'the list contains exactly one element.
        contentRoot = CreateObject("roSGNode","ContentNode")
        contentRow = CreateObject("roSGNode","ContentNode")
        'Create a category node for each category'
        for each category in categories
          if category.getname() = "banner_ad"
            print "skipped banner_ad"
          else if category.getname() = "category"
            contentNode = CreateObject("roSGNode","ContentNode")
            print "category: " + category@title + " | " + category@description
            aa = {}
            aa.title = category@title
            aa.description = category@description
            aa.shortdescriptionline1 = category@title
            aa.shortdescriptionline2 = category@description
            aa.sdPosterUrl = category@sd_img
            aa.hdposterurl = category@hd_img
            m.count = 0
            categoryLeaves = category.getChildElements()
            for each leaf in categoryLeaves
              subAA = {}
              subAA.title = leaf@title
              subAA.url = leaf@feed
              a = {}
              a[subAA.title] = subAA
              AddAndSetFields(contentNode, a)
              m.count++
            end for
            AddAndSetFields(contentNode,{count: m.count})
            AddAndSetFields(contentNode, aa)
            contentRow.appendChild(contentNode)
          end if
        end for
        contentRoot.appendChild(contentRow)
        m.top.content = contentRoot
      end if
    end if
  end if
  print "done with parseResponse"
end sub


' Callback function for when content has finished parsing
sub updateContent()
  print "UriHandler.brs - [updateContent]"
  if m.top.contentSet return
  if m.top.numRows - 1 = m.top.numRowsReceived
    parent = createObject("roSGNode", "ContentNode")
    for i = (m.top.numRows - m.top.numCurrentRows) to m.top.numRowsReceived
      parent.appendchild(m.top.contentCache.getField(i.toStr()))
    end for
    print "All content has finished loading"
    m.top.contentSet = true
    m.top.categorycontent = parent
    itemToCache = {}
    itemToCache[m.top.category] = parent
    AddAndSetFields(m.top.cache, itemToCache)
  else
    print "Not all content has finished loading yet"
  end if
end sub
