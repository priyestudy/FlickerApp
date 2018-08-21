# FlickerApp
FlickerApp Starter Project
The App follows MVVM .
APP is divede into View, Model and ViewModel along with Network layer
Each module  has seperate folder structure.  I have used protocol oriented design.

ListViewController - It is view in  MVVM and launch source controller. It has responsiblity to manage request logic and handles UI          
part of application 

ListViewModel -  It is view model for application , it is carrier of data source and also also network request goes through this class

DownloadManager - It is used for downloading images it has operation queues for handling image donloading

NetworkManager - This class is used for making bnetwok calls, it uses NSURLSession for network calls

ImageCacheManager - For in memory  image caching

AppUtility - For persisting images to disk

I have included basic test cases for Model and ViewModel  
