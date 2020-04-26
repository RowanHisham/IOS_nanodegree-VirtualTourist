//
//  FlickerClient.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/26/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation

class FlickerCLient{
    
    struct Auth {
        static let key: String = "ad9bc83be997d8c07ce7d87472b01a23"
        static let secret: String = "b02b0f79cf88f899"
    }
    
    enum Endpoints {
        
        case photosSearch([Float])
        
        var stringValue: String{
            switch self{
            case .photosSearch(let coordinates): return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Auth.key)&lat=\(coordinates[0])&lon=\(coordinates[1])&per_page=25&format=json"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    static func getPhotosSearch(latitude: Double, longitude: Double, completion: @escaping (FlickerImagesSearchResponse?, Error?) -> Void){
        print("SETTING UP REQUEST")
        let request = URLRequest(url: Endpoints.photosSearch([Float(latitude),Float(longitude)]).url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard var data = data else{
                print(error?.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            data = data.subdata(in: (14..<(data.count-1)))
            let decoder = JSONDecoder()
            do{
                let flickerImagesSearchResponse = try decoder.decode(FlickerImagesSearchResponse.self, from: data)

                print(flickerImagesSearchResponse.photos?.photo.count)
                DispatchQueue.main.async {
                    completion(flickerImagesSearchResponse,nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
