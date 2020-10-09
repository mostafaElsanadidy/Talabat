//
//  APIRouter.swift
//  MadeInKuwait
//
//  Created by Amir on 1/29/20.
//  Copyright © 2020 Amir. All rights reserved.
//


import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case login(username:String,password:String)
    case getResturants(langu:String)
    case getResturantOrders(restId:Int,langu:String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
//            el vend details fel post man get request w hena maktop .post ?
        case .login , .getResturants , .getResturantOrders :
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login: return "login"
        case .getResturants(let langu): return "getResturants?langu=\(langu)"
        case .getResturantOrders(let restId, let langu): return "getOrder?restId=\(restId)&langu=\(langu)"
        }
    }
    
    // MARK: - Parameters
//    why get api calls has no parameters and directly inserted within the url or if path == ta7t
    private var parameters: Parameters? {
        switch self {
            
        case .login(let username,let password):
            let parameters: [String:Any] = [
                "mobile" : username ,
                "password" : password ,
                "access_key" : "Gdka52DASWE3DSasWE742Wq" ,
                "access_password" : "yH52dDDF85sddEWqPNV7D12sW5e"
            ]
            return parameters
            
        case .getResturants , .getResturantOrders :
            return nil
        }
    }
    
    
    func getPostString(params:[String:Any]) -> String
          {
              var data = ["{"]
            for(ind, param) in params.enumerated()
              {
                data.append("\n\"\(param.key)\"" + ":\"\(param.value)\"")
                if ind != params.count-1{
                    data.append(",")
                }
              }
            data.append("\n}")
            return data.map { String($0) }.joined(separator: "")
          }
    
//    "{\n\"mobile\":\"\(userName)\",\n\"password\":\"\(password)\",\n\"access_key\":\"Gdka52DASWE3DSasWE742Wq\",\n\"access_password\":\"yH52dDDF85sddEWqPNV7D12sW5e\"\n}"
    
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var main_api_url = ""
        main_api_url = Constants.ProductionServer.baseURL + path
        let urlComponents = URLComponents(string: main_api_url)!
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)
        
        print("URLS REQUEST :\(urlRequest)")
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        let credentialData = "ck_37baea2e07c8960059930bf348d286c7e48eb325:cs_0d74440eb12ac4726080563a4ceb0363ad5a0112".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = "Basic \(base64Credentials)"
        
       // urlRequest.setValue(headers, forHTTPHeaderField: Constants.HTTPHeaderField.authentication.rawValue)
        
        
        // Parameters
        if let parameters = parameters {
            do {
//                            print(parameters)
//                            let postString = self.getPostString(params: parameters)
//
//                            var data = Data()
//
//                            data.append(postString.data(using: .utf8)!)
//                            urlRequest.httpBody = data
//
//                            let theJSONText = NSString(data: urlRequest.httpBody!,
//                                                                    encoding: String.Encoding.ascii.rawValue)
//                            print("JSON string = \(theJSONText!)")
                            
                print(parameters)
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
                        } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }


        }
        
//        if path == "login" {
//            return try
//            URLEncoding.default.encode(urlRequest, with: parameters)
//        }
        

        
        return urlRequest as URLRequest
        

    }
}
