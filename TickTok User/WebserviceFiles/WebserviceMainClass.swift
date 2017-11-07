//
//  WebserviceMainClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 27/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Alamofire





var request : Request!


let header: [String:String] = ["key":"TicktocApp123*"]

//-------------------------------------------------------------
// MARK: - Webservice For PostData Method
//-------------------------------------------------------------

func postData(_ dictParams: AnyObject, nsURL: String, completion: @escaping (_ result: AnyObject, _ sucess: Bool) -> Void)
{
    let url = WebserviceURLs.kBaseURL + nsURL

    
    Alamofire.request(url, method: .post, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default, headers: header)
        .validate()
        .responseJSON
        { (response) in
            if let JSON = response.result.value
            {
                if (JSON as AnyObject).object(forKey:("status")) as! Bool == false
                {
                    completion(JSON as AnyObject, false)
                }
                else
                {
                    completion(JSON as AnyObject, true)
                }
            }
    }
}


//-------------------------------------------------------------
// MARK: - Webservice For GetData Method
//-------------------------------------------------------------

func getData(_ dictParams: AnyObject, nsURL: String,  completion: @escaping (_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = WebserviceURLs.kBaseURL + nsURL

    
    
    Alamofire.request(url, method: .get, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default, headers: header)
        .validate()
        .responseJSON
        { (response) in
            
            if let JSON = response.result.value
            {
                
                if (JSON as AnyObject).object(forKey:("status")) as! Bool == false
                {
                    completion(JSON as AnyObject, false)
                    //                    HUD.flash(HUDContentType.systemActivity, delay: 0.0)
                }
                else
                {
                    completion(JSON as AnyObject, true)
                    
                }
            }
            else
            {
                print("Data not Found")
            }
            
    }
}




//-------------------------------------------------------------
// MARK: - Webservice For Send Image Method
//-------------------------------------------------------------

func sendImage(_ dictParams: [String:AnyObject], image1: UIImage, nsURL: String, completion: @escaping (_ result: AnyObject, _ success: Bool) -> Void) {
    
    let url = WebserviceURLs.kBaseURL + nsURL
    
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        
        if let imageData1 = UIImageJPEGRepresentation(image1, 0.6) {
            
            multipartFormData.append(imageData1, withName: "Image", fileName: "image.png", mimeType: "image/png")
        }
        
        for (key, value) in dictParams
        {
            
            print(value)
            multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key )
            
        }
    }, usingThreshold: 10 * 1024 * 1024, to: url, method: .post, headers: header) { (encodingResult) in
        switch encodingResult
        {
        case .success(let upload, _, _):
            request =  upload.responseJSON {
                response in
                
                if let JSON = response.result.value {
                    
                    if ((JSON as AnyObject).object(forKey: "status") as! Bool) == true
                    {
                        completion(JSON as AnyObject, true)
                        print("If JSON")
                        
                    }
                    else
                    {
                        completion(JSON as AnyObject, false)
                        print("else JSON")
                    }
                }
                else
                {
                    print("ERROR")
                }
                
                
            }
        case .failure( _):
            print("failure")
            
            break
        }
    }
}

