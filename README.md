# videoplayer-channel example
![Roku](https://img.shields.io/badge/Roku-Dev-blue.svg)

VideoPlayer Sample Channel for the Roku Platform.

## Use case
- This sample channel was developed to demonstrate how to migrate your channel from Roku SDK1 (BrightScript only) to SceneGraph SDK 2. This channel has most of the functionality that was included in the original "videoplayer" template channel in SDK1.
- Read the migration guide that goes along with this channel to get a better understanding of how things fit together.
- This channel should be used as a starter template for your channel development. It is a barebones template for displaying categories of content.

## How to run this sample
- Zip up the entire project directory and deploy to your roku device. Follow the developer set-up guide here for a quick guide on how to do so: https://blog.roku.com/developer/2016/02/04/developer-setup-guide/
- Alternatively, open up this project in Eclipse or Atom and use the corresponding plugin/package to export/deploy the channel.
  - Eclipse plugin documentation in the SDK docs: https://sdkdocs.roku.com/display/sdkdoc/Eclipse+Plugin+Guide
  - The blog post for the Eclipse plugin: https://blog.roku.com/developer/2016/04/20/roku-eclipse-plugin/
  - Roku Deploy package for Atom: https://atom.io/packages/roku-deploy

## Features
- Replicates the UI and functionality of the SDK1 VideoPlayer example
  - Saves the position that the user left off at during the previous session
    - i.e. if you don't finish a video, you can resume at where you left off even if you restarted the channel.

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
  - **SimpleVideoScene.brs/xml:** The main scene. Controls most navigation logic
- **Images:** Contains image assets used in the channel
- **Source:** Contains the main brightscript file that runs right when the channel starts

## Feature Requests?
- Please submit an issue on this repository or post on the Roku forums about this channel. I will try to respond as soon as possible :)
