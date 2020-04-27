# Virtual Tourist
This is the fourth portfolio app from Udacity iOS Developer Nanodegree.
The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures 
from Flicker for the location and persist both the pictures, and the association of the pictures with the pin coordinates.

 * [Project Rubric](https://review.udacity.com/#!/rubrics/1990/view)

## This project focused on
* Store media on the device file system
* Use Core Data for local persistence of an object structure
* Accessing networked data - Flicker API
* Parsing JSON file using Codable (Decodable , Encodable)
* Creating user interfaces that are responsive using asynchronous requests
* Use MapKit framework to display pins on a map

## App Structure
Virstual Tourist is following the MVC pattern. The application uses CoreData to store Pins and Images 

<img src="https://github.com/RowanHisham/IOS_nanodegree-VirtualTourist/blob/master/Images/virtualTourist1.png" alt="alt text" width="800" height="500" >

## Implementation
### Map Screen 
Shows the map and allows user to drop pins around the world. Users can add new pins by long press gesture. As soon as a pin
is dropped it is persisted and available on app relaunch, tapping the pin opens the Photo Album of that pin.

<img src="https://github.com/RowanHisham/IOS_nanodegree-VirtualTourist/blob/master/Images/virtualTourist2.png" alt="alt text" width="300" height="550" >

### Photo Album Screen 
Displays Images downloaded from Flicker using the pin Geolocation. Images are fetched from memory, if there's no images saved,
a set of Images is downloded form Flicker with placeholder images displayed until the images finishes downloading. Users can delete photos from existing albums by tapping them. The New Collection
button initiates the download of a new album, replacing the images in the photo album with a new set from Flickr and saves them.

<img src="https://github.com/RowanHisham/IOS_nanodegree-VirtualTourist/blob/master/Images/virtualTourist3.png" alt="alt text" width="300" height="550" ><img src="https://github.com/RowanHisham/IOS_nanodegree-VirtualTourist/blob/master/Images/virtualTourist4.png" alt="alt text" width="300" height="550" >


## Frameworks
UIKit

CoreData

MapKit
