//
//  JIRAClient.swift
//  jtm
//
//  Created by Scott A. Guyer on 8/24/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Foundation


// For now, this is a simple in memory store
// TODO: update to keychain storage
class CredentialsProvider {
    var host: String
    var user: String
    var pass: String
    
    init ( _ aHost: String, _ aUser: String, _ aPass: String ) {
        host = aHost
        user = aUser
        pass = aPass
    }
    
    func basicAuthToken() -> String? {
        let nsString = NSString(format: "%@:%@", user, pass)
        if let data = nsString.dataUsingEncoding( NSASCIIStringEncoding) {
            return "Basic " + data.base64EncodedStringWithOptions( NSDataBase64EncodingOptions(0))
        } else {
            return nil
        }
    }
    
    func username() -> String {
        return user
    }
    
    
    func persist() {
        // TODO:
    }
}




//
// I didn't find a "validate credentials" type of endpoint using basic auth.
// But this endpoint has the desired effect ...
//
// http://scotts-mbp.home:2990/jira/rest/api/latest/user?username=joe
//
// NOTE: all these endpoints should be HTTPS since we are using basic



class SimpleDownloader {
    
    var url: NSURL
    var credsProvider: CredentialsProvider?

    var session: NSURLSession? = nil
    
    
    convenience init ( url aString: String ) {
        let nsurl = NSURL(string: aString)
        self.init( nsurl)
    }
    
    init ( _ aURL: NSURL ) {
        url = aURL
    }
    
    
    func getSession () -> NSURLSession {
        if session == nil {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            var headers: [String:String] = [
                "Accept" : "application/json"
            ]
            
            if let cp = self.credsProvider {
                if let token = cp.basicAuthToken() {
                    println( "adding token: " + token)
                    headers["Authorization"] = token
                }
            }
            
            config.HTTPAdditionalHeaders = headers
            
            session = NSURLSession( configuration: config)
        }
        
        return session!
    }
    
    
    func start( completion: ((NSData?) -> ()) )  {
        let task = getSession().dataTaskWithURL( self.url ) {
            (let data, let response, let error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    completion(data)
                    
                case 401:
                    println( "invalid credentials")
                    completion(nil)
                    
                default:
                    println( "bad request: \(error)")
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    
}


enum JIRAErrorCodes: Int {
    
    case Usage = 1
    
    case Authentication = 2
}


class JIRAError {
    class var errorDomain: String {
        return "JIRAClient"
    }
    

    
    class func usageError( msg: String) -> NSError {
        return NSError( domain: errorDomain,
            code: JIRAErrorCodes.Usage.toRaw(),
            userInfo: [  NSLocalizedDescriptionKey : msg ] )
    }
    
    
    class func authError( msg: String ) -> NSError {
        return NSError( domain: errorDomain,
            code: JIRAErrorCodes.Authentication.toRaw(),
            userInfo: [  NSLocalizedDescriptionKey : msg ] )
    }
    
}



public typealias JIRACallback = ((Dictionary<String,AnyObject>?,NSError?)->())


public class JIRAClient {
    
    var host: String? = nil
    let apiPath = "/jira/rest/api"
    var credentials: CredentialsProvider?

    
    //
    // Host is expected to be just the domain
    //
    init ( host: String ) {
        self.host = host
    }
    
    
    
    //
    // You must have called setHost prior to this call
    //
    func authenticate( user: String, pass: String, completion: JIRACallback? ) {
        
        if self.host == nil {
            if let callback = completion {
                callback( nil, JIRAError.usageError( "no host setting"))
            }
            return
        }
        
        
        credentials = CredentialsProvider( self.host!, user, pass)
        
        let urlString = "http://" + self.host! + self.apiPath + "/2/user?username=" + user
        
        println(urlString)
        
        let url = NSURL( string: urlString)
        
        let downloader = SimpleDownloader( url)
        downloader.credsProvider = credentials
        
        downloader.start() { (let data) in
            if data != nil {
                // TODO: parsing
                
                self.credentials?.persist()
                
                if let callback = completion {
                    callback( nil, nil) // successful auth
                }
                
            } else {
                if let callback = completion {
                    callback( nil, JIRAError.authError( "authentication failed"))
                }

            }
        }
        
        
    }
}
