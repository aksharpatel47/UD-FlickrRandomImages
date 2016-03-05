//
//  RandomImagesViewController.swift
//  FlickrRandomImages
//
//  Created by Akshar Patel on 05/03/16.
//  Copyright © 2016 Akshar Patel. All rights reserved.
//

import UIKit

class RandomImagesViewController: UIViewController {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageTitle.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getRandomImage(sender: UIBarButtonItem) {
        guard let url = getFlickrURLForRandomImagesFromGallery() else {
            print("Cannot build the required url")
            return
        }
        
        print("Request Started")
        
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            
            // Making sure the request was successful
            guard error == nil else {
                print("Error while getting data from the flickr api: \(error)")
                print(url)
                return
            }
            
            // unwrapping the value in variable data
            guard let data = data else {
                return
            }
            
            let parsedResult: [String:AnyObject]
            
            // Parsing result into 'parsedResult'
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String:AnyObject]
            } catch {
                print("Error while parsing error : \(error)")
                print(url)
                return
            }
            
            // Making sure we have the root photo key in the response
            guard let photos = parsedResult["photos"] as? [String:AnyObject] else {
                print("Cannot find key 'photos' in the response")
                return
            }
            
            guard let photosArray = photos["photo"] as? [[String:AnyObject]] else {
                print("Cannot find key 'photo' in the photos dictionary.")
                return
            }
            
            let index = Int(rand()) % photosArray.count

            let photo = photosArray[index]
            
            guard let photoURLString = photo["url_m"] as? String, photoTitle = photo["title"] as? String else {
                print("Cannot find the url/title of the random photo")
                return
            }
            
            guard let photoURL = NSURL(string: photoURLString) else {
                print("Cannot create url from the string")
                return
            }
            
            guard let photoData = NSData(contentsOfURL: photoURL) else {
                print("Cannot download the data from the url")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView.image = UIImage(data: photoData)
                self.imageTitle.hidden = false
                self.imageTitle.text = photoTitle
            })
        })
        
        task.resume()
    }
    
    func getFlickrURLForRandomImagesFromGallery() -> NSURL? {
        let queryParameters: [String:AnyObject] = [
            Constants.FlickrParameterKeys.RequestMethod : Constants.FlickrParamaterValues.GetPhotosFromGalleryMethod,
            Constants.FlickrParameterKeys.GalleryId: Constants.FlickrParamaterValues.GalleryId,
            Constants.FlickrParameterKeys.ApiKey : Constants.FlickrParamaterValues.ApiKey,
            Constants.FlickrParameterKeys.Format : Constants.FlickrParamaterValues.JSONFormat,
            Constants.FlickrParameterKeys.NoJSONCallback : Constants.FlickrParamaterValues.NoJSONCallback,
            Constants.FlickrParameterKeys.Extras : Constants.FlickrParamaterValues.UrlmExtras        ]
        
        return buildFlickrURL(queryParameters)
    }
    
    func buildFlickrURL(query: [String:AnyObject]) -> NSURL? {
        let flickrURL = NSURLComponents()
        flickrURL.scheme = "https"
        flickrURL.host = "api.flickr.com"
        flickrURL.path = "/services/rest"
        flickrURL.queryItems = [NSURLQueryItem]()
        
        for (key, value) in query {
            let item = NSURLQueryItem(name: key, value: value as? String)
            flickrURL.queryItems?.append(item)
        }
        
        return flickrURL.URL
    }
}

