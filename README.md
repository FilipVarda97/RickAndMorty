# Rick and Morty app writen in Swift

<div id="header" align="center">
  <img src="https://media.giphy.com/media/3oKIPic2BnoVZkRla8/giphy.gif?cid=ecf05e47fy45883mn9qdmbwjipeioxskk30vg3qta7pyi28r&rid=giphy.gif&ct=s" width="150"/>
</div>

Note: This project uses CocoaPods (SnapKit). Open RickAndMorty.xcworkspace instead of RickAndMorty.xcodeproj.
Also, keep an eye out for SplashScreen since it's writen in SwiftUI.

This app fetches Character models and presentes them in UICollectionView. The UICollectionView supports paging, since there are over 800 characters. Each page/request returns 20 characters.
The app uses MVVM desing pattern.
## Some Functionlities
- fetch characters and present them in UIViewController using UICollectionView
- save/load/delete character from CoreData
- present saved characters in seperated UIViewController
- open single character details in UIViewController that has a custom UICollectionView layout
- in single character details UIViewController, at the bottom of UI, there is a section with episodes. Those episodes are fetch individually, so that the UI is not blocked. 
