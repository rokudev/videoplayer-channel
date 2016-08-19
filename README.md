# videoplayer-channel example
![Roku](https://img.shields.io/badge/Roku-Dev-blue.svg)

VideoPlayer Sample Channel for the Roku Platform.

## Use case
This sample channel should be used as a starter template for your channel development. It is a barebones template for displaying categories of content.

## How to run this sample
- Zip up the entire project directory and deploy to your roku device. Follow the developer set-up guide here for a quick guide on how to do so: https://blog.roku.com/developer/2016/02/04/developer-setup-guide/
- Alternatively, open up this project in Eclipse or Atom and use the corresponding plugin/package to export/deploy the channel.
  - Eclipse plugin documentation in the SDK docs: https://sdkdocs.roku.com/display/sdkdoc/Eclipse+Plugin+Guide
  - The blog post for the Eclipse plugin: https://blog.roku.com/developer/2016/04/20/roku-eclipse-plugin/
  - Roku Deploy package for Atom: https://atom.io/packages/roku-deploy

## Features
- Replicates the UI and functionality of the SDK1 SimpleVideoPlayer example

## Directory Structure
- **Components:** The Scene Graph components
  - **Task.xml** A task node that is used to exit the channel on buttonpress.
  - **SimpleVideoScene.brs/xml:** The main scene.
- **Images:** Contains image assets used in the channel
- **Source:** Contains the main brightscript file that runs right when the channel starts

'm.CRow.content = invalid
'm.UriHandler.categorycontent = invalid
'fieldnames = []
'for i = 0 to m.UriHandler.numRows
''  fieldnames.push(i.tostr())
'end for
'm.UriHandler.ContentCache.removeFields(fieldnames)
