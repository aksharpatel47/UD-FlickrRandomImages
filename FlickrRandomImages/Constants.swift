//
//  Constants.swift
//  FlickrRandomImages
//
//  Created by Akshar Patel on 05/03/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import Foundation

struct Constants {
    struct FlickrParameterKeys {
        static let RequestMethod = "method"
        static let ApiKey = "api_key"
        static let GalleryId = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
    }
    
    struct FlickrParamaterValues {
        static let GetPhotosFromGalleryMethod = "flickr.galleries.getPhotos"
        static let ApiKey = "3d7116d2e05099f6c1efb314c7d08418"
        static let GalleryId = "66911286-72157647263150569"
        static let UrlmExtras = "url_m"
        static let JSONFormat = "json"
        static let NoJSONCallback = "1"
    }
}