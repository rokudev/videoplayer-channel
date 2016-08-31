# videoplayer-channel example
![Roku](https://img.shields.io/badge/Roku-Dev-blue.svg)

VideoPlayer Sample Channel for the Roku Platform.

The Categories Screen

![VideoPlayerHome](https://raw.githubusercontent.com/rokudev/videoplayer-channel/master/images/VideoPlayerHome.jpg "VideoPlayerHome")

The Screen after clicking on a category

![VideoPlayerCategories](https://raw.githubusercontent.com/rokudev/videoplayer-channel/master/images/VideoPlayerCategories.jpg "VideoPlayerCategories")

The Springboard 

![VideoPlayerSpringboard](https://raw.githubusercontent.com/rokudev/videoplayer-channel/master/images/VideoPlayerSpringBoard.jpg "VideoPlayerSpringboard")

## Overview
Many developers as of August 23, 2016 have either published or are publishing channels based on the sample template channel "VideoPlayer." This channel was built to help Roku developers using the "VideoPlayer" template migrate their channels to SceneGraph. Roku encourages developers to start using Roku SceneGraph to create performant channels on the platform.

## Migration Guide
- Move all images into the images folder
- To recreate the overhang:
  - Overhang_Logo_HD/SD.png can be used on line 17 in `VideoScene.xml`
  - Overhang_Background_HD/SD.png can be used on line 18 in `VideoScene.xml`
- Update the manifest (Channel Posters/Splashart) to reference the corresponding image assets.
- To request the feed:
  - Replace the url string on line 22 in `VideoScene.brs` with the link to the feed
  - If the structure of your XML feed matches the VideoPlayer sample feed, there are no other changes that need to be made!
- roElements turn into SceneGraph nodes... for example, roPosterScreens are converted into SceneGraph RowLists.

## Use case
- This sample channel was developed to demonstrate how to migrate your channel from Roku SDK1 (BrightScript only) to SceneGraph SDK 2 (BrightScript + SceneGraph). This channel has most of the functionality that was included in the original "videoplayer" template channel in SDK1.
- This channel should be used as a starter template for your channel development. It is a barebones template for displaying categories of content from an XML feed.

## How to run this sample
- Zip up the entire project directory and deploy to your roku device. Follow the developer set-up guide here for a quick guide on how to do so: https://blog.roku.com/developer/2016/02/04/developer-setup-guide/
- Alternatively, open up this project in Eclipse or Atom and use the corresponding plugin/package to export/deploy the channel.
  - Eclipse plugin documentation in the SDK docs: https://sdkdocs.roku.com/display/sdkdoc/Eclipse+Plugin+Guide
  - The blog post for the Eclipse plugin: https://blog.roku.com/developer/2016/04/20/roku-eclipse-plugin/
  - Roku Deploy package for Atom: https://atom.io/packages/roku-deploy

## Features
- All the assets used in the SDK1 VideoPlayer example can be used in this channel without any changes.
- Replicates the UI and functionality of the SDK1 VideoPlayer example
  - Saves the position that the user left off at during the previous session
    - i.e. if you don't finish a video, you can resume at where you left off even if you restarted the channel.
- Two task components (nodes that extend task) are used to demonstrate how to perform actions on a task thread. More specifically, (1) Url requests/responses and (2) reading/writing from registry can't be done in the render thread and must be done in a task thread. Both task components have fields in their interfaces to allow other components to interact with them. https://sdkdocs.roku.com/display/sdkdoc/Scene+Graph+BrightScript+Support

## Directory Structure
- **Components:** The Scene Graph components
  - **HomeScreen.brs/xml** The 1st screen; shown when the channel starts.
  - **CategoryScreen.xml** The 2nd screen; shown after an item is selected on the HomeScreen
  - **SpringBoard.brs/xml** The 3rd screen (aka a details screen); shown when an item is selected on the CategoryScreen
  - **Item.xml** The custom item component used for the HomeScreen.
  - **CItem.xml** The custom item component used for the CategoryScreen
  - **Task.xml** A task node used to read/write from registry.
  - **UriHandler.brs/xml** A task node used for handling url request/responses.
  - **SGHelperFunctions.xml** Script with useful SG functions.
  - **VideoScene.brs/xml:** The main scene. Controls most navigation logic
- **Images:** Contains image assets used in the channel
- **Source:** Contains the main brightscript file that runs right when the channel starts

## Feature Requests
- Please submit an issue on this repository or post on the Roku forums about this channel. To create an issue: https://help.github.com/articles/creating-an-issue/ The Roku forum: https://forums.roku.com/

## Warning
- This sample does not utilize deep-linking and warning dialog messages but has them in the code if a developer desires to use them.
