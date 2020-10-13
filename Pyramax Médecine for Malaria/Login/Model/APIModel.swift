//
//  Api.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 22.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.

import Alamofire
import UIKit
import AVFoundation

protocol APIProtocol {
    func createUserSimple(userEmail: String, userPassword: String, userPasswordConfirmation: String)
    func createUserAdvanced(userEmail: String, userPassword: String, userPasswordConfirmation: String, userName: String, userLastName: String, userPhone: String, userFunction: String, userCountry: String, userCity: String, userOrganization: String, userAvatar: UIImage)
    func login(userEmail: String, userPassword: String) -> Bool
    func logout(userEmail: String, userPassword: String)
    func refreshToken()
    func resetPassword(userEmail: String)
}

protocol APIReportProtocol {
    func createSimpleReport(userId: Int, reportName: String)
    func createAdvancedReportWithMeetType(userId: Int, name: String, date: Date, countPeople: String, place: String, comment: String, meetType: Int)
    func createAdvancedReportWithoutMeetType(userId: Int, name: String, date: Date, countPeople: String, place: String, comment: String, meetTypeName: String)
}

class API: APIProtocol, APIReportProtocol {
    
    private let api = "http://92.222.71.100/v1"
    // "http://92.222.71.100/v1/sessions?session[email]=ikholodoff@gmail.com&session[password]=Qwerty20"

    private func postRequest(req: String) {
        guard let url = URL(string: req) else {
            return
        }
        
        request(url, method: .post).validate().responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                do {
                    let myResponse = try JSONDecoder().decode(APIEntitie.self, from: data)
                    print(myResponse)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func postRequestResetPassword(request: String) {
        Alamofire.request(request, method: .post).validate().responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                
                do {
                    let myResponse = try JSONDecoder().decode(APIEntitieResetPassword.self, from: data)
                    print(myResponse)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func postRequestReport(request: String) {
        
        Alamofire.request(request, method: .post).validate().responseJSON { response in
            switch response.result {
            case .success(let sucess):
                print(sucess)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createUserSimple(userEmail: String, userPassword: String, userPasswordConfirmation: String) {
        let apiRequest = api +  "/users?user_form[user][email]=\(userEmail)&user_form[user][password]=\(userPassword)&user_form[user][password_confirmation]=\(userPasswordConfirmation)"
        
        postRequest(req: apiRequest)
    }
    
    func createUserAdvanced(userEmail: String,
                            userPassword: String,
                            userPasswordConfirmation: String,
                            userName: String,
                            userLastName: String,
                            userPhone: String,
                            userFunction: String,
                            userCountry: String,
                            userCity: String,
                            userOrganization: String,
                            userAvatar: UIImage) {
        let apiRequest = api + """
        /users?user_form[user][email]=\(userEmail)&
        user_form[user][password]=\(userPassword)&
        user_form[user][password_confirmation]=\(userPasswordConfirmation)&
        user_form[user][name]=\(userName)&
        user_form[user][last_name]=\(userLastName)&
        user_form[user][phone]=\(userPhone)&
        user_form[user][function]=\(userFunction)&
        user_form[user][country]=\(userCountry)&
        user_form[user][city]=\(userCity)&
        user_form[user][organization]=\(userOrganization)&
        user_form[user][avatar]=\(userAvatar)
        """
        
        postRequest(req: apiRequest)
    }
    
    func login(userEmail: String, userPassword: String) -> Bool {
        var status = false
        let apiRequest = api + "/sessions?session[email]=\(userEmail)&session[password]=\(userPassword)"
        request(apiRequest, method: .post)
            .validate()
            .responseJSON {responseJSON in
                switch responseJSON.result  {
                case .success(let value):
                    guard let jsonArray = value as? [String: Any] else {
                        print("guard let jsonArray = value as? [[String: Any]] else")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        let jsonArrayData = jsonArray["data"]! as? [String: Any]
                        print("jsonArrayData:", jsonArrayData!)
                        
                        let token = jsonArrayData!["api_token"]
                        User.shared.token = String(describing: token)
                        print("User.shared.token :", User.shared.token)
                        
                        let id = jsonArrayData!["id"]
                        User.shared.id = Int(String(describing: id!)) ?? 0
                        print("User.shared.id =", User.shared.id)
                        
                        status = true
                    }
                    
                case .failure(let error):
                    print("case .failure(let error):", error)
                }
        }
       
        return status
    }
    
    func logout(userEmail: String, userPassword: String) {
        let apiRequest = api + "/sessions?session[email]=\(userEmail)&session[password]=\(userPassword)"
        print(apiRequest)
        postRequest(req: apiRequest)
    }
    
    func refreshToken() {
        let apiRequest = api + "/sessions/refresh"
        postRequest(req: apiRequest)
    }
    
    func resetPassword(userEmail: String) {
        let apiRequest = api + "/users/reset_password?email=\(userEmail)"
        postRequestResetPassword(request: apiRequest)
    }
    
    func createSimpleReport(userId: Int, reportName: String) {
        let apiRequest = api + "/reports?report_form[report][user_id]=\(userId)&report_form[report][name]=\(reportName)"
        postRequestReport(request: apiRequest)
    }
    
    func createAdvancedReportWithMeetType(userId: Int, name: String, date: Date, countPeople: String, place: String, comment: String, meetType: Int) {
        let apiRequest = api + """
        /reports?report_form[report][user_id]=\(userId)&report_form[report][name]=\(name)&report_form[report][meet_day]=\(date)&
        report_form[report][count_people]=\(countPeople)&
        report_form[report][place]=\(place)&
        report_form[report][comment]=\(comment)&
        report_form[report][meet_type][id]=\(meetType)
        """
        
        postRequestReport(request: apiRequest)
    }
    
    func createAdvancedReportWithoutMeetType(userId: Int, name: String, date: Date, countPeople: String, place: String, comment: String, meetTypeName: String) {
        
        let apiRequest = api + """
        /reports?
        report_form[report][user_id]=\(userId)&
        report_form[report][name]=\(name)&
        report_form[report][meet_day]=\(date)&
        report_form[report][count_people]=\(countPeople)&
        report_form[report][place]=\(place)&
        report_form[report][comment]=\(comment)&
        report_form[report][meet_type][name]=\(meetTypeName)
        """
        
        postRequestReport(request: apiRequest)
    }
}

extension API {
    
    func sendReport(_ report: RightReport){
        
        guard Connectivity.isConnectedToInternet() else { return }
                        
        var data = [Data?]()
        var images =  [UIImage]()
        
        if let img = report.image01 {
            images.append(img)
        }
        if let img = report.image02 {
            images.append(img)
        }
        if let img = report.image03 {
            images.append(img)
        }
        
        var totalImages: UIImage? = nil
        if images.count > 0 {
            totalImages = stitchImages(images: images, isVertical: true)
        }
        print("totalImages = ", totalImages as Any)
        
        if let jpgData: Data = totalImages?.jpegData(compressionQuality: 0.8) {
            data.append(jpgData)
        }
        
        for d in data {
            print(d as Any)
        }
        print("")
        
        let nameToken = "AUTHTOKEN"
        
        let token = User.shared.token
        let email = User.shared.email
        print("User.shared.token =", User.shared.token)
        print("email =", email)
        
        var count = data.count
        if count == 0 { count = 1 }
        
        for i in 0..<count {
            
            let heads: HTTPHeaders = [nameToken: token]
            upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(String(User.shared.id).data(using: String.Encoding.utf8)!,
                                         withName: "report_form[report][user_id]")
                multipartFormData.append(report.presentationName!.data(using: String.Encoding.utf8)!,
                                         withName: "report_form[report][name]")
                multipartFormData.append(report.data!.data(using: String.Encoding.utf8)!,
                                         withName: "report_form[report][meet_day]")
                multipartFormData.append(report.comment.data(using: String.Encoding.utf8)!,
                                         withName: "report_form[report][comment]")
                multipartFormData.append((report.country + ", " + report.city).data(using: String.Encoding.utf8)!,
                                         withName: "report_form[report][place]")
                multipartFormData.append(String(report.visitType).data(using: String.Encoding.utf8)!,
                                         withName: "report_form[report][meet_type][id]")
                multipartFormData.append(String(report.countPeople).data(using: String.Encoding.utf8)!,
                                         withName: "report_form[report][count_people]")
                if 0 < data.count {
                    if let tmpData = data[i]  {
                        multipartFormData.append(tmpData, withName: "report_form[report][reports_image][file]", fileName: "Plus", mimeType: "image/png")
                    }
                }
                
            },
                   to: "http://92.222.71.100/v1/reports?",
                   method: .post,
                   headers: heads,
                   encodingCompletion: { (result) in switch result {
                       case .success(let upload, _ , _):
                        upload.responseJSON { response in
                            print("report done")
                            print("report upload:", upload)
                            print("report response: ", response.result.value ?? "report error") }
                       case .failure(let encodingError):
                        print("report failed");
                        print("report encoding error-", encodingError)
                    }
            })
        }
    }
}

extension API {
    
    func registerUser(_ name: String, _ lastName: String, _ country: String, _ city: String, _ phone: String, _ function: String, _ organization: String, _ email: String, _ password: String, _ confirmPassword: String, _ avatar: UIImage?) {
        var data: Data?
        
        if let dataPng: Data = avatar?.pngData() {
            data = dataPng
        }
       
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(name.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][name]")
            multipartFormData.append(lastName.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][last_name]")
            multipartFormData.append(phone.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][phone]")
            multipartFormData.append(function.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][function]")
            multipartFormData.append(organization.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][organization]")
            multipartFormData.append(country.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][country]")
            multipartFormData.append(city.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][city]")
            multipartFormData.append(email.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][email]")
            multipartFormData.append(password.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][password]")
            multipartFormData.append(confirmPassword.data(using: String.Encoding.utf8)!,
                                     withName: "user_form[user][password_confirmation]")
            if let tmpData = data {
                multipartFormData.append(tmpData, withName: "user_form[user][avatar]", fileName: "Avatar", mimeType: "image/png")
            }
        },
               to: "http://92.222.71.100/v1/users?",
               method: .post,
               headers: nil,
               encodingCompletion: { (result) in switch result {
               case .success(let upload, _ , _):
                upload.uploadProgress(closure: { (progress) in print("register uploding") } )
                upload.responseJSON { response in
                    print("register done"); print("register upload:", upload); print("register response: ", response.result.value ?? "register error") }
               case .failure(let encodingError): print("register failed"); print(encodingError) }
        })
    }
}

extension API {
    
    func stitchImages(images: [UIImage], isVertical: Bool) -> UIImage {
        var stitchedImages : UIImage!
        if images.count > 0 {
            var maxWidth = CGFloat(0), maxHeight = CGFloat(0)
            for image in images {
                if image.size.width > maxWidth {
                    maxWidth = image.size.width
                }
                if image.size.height > maxHeight {
                    maxHeight = image.size.height
                }
            }
            var totalSize : CGSize
            let maxSize = CGSize(width: maxWidth, height: maxHeight)
            if isVertical {
                totalSize = CGSize(width: maxSize.width, height: maxSize.height * (CGFloat)(images.count))
            } else {
                totalSize = CGSize(width: maxSize.width  * (CGFloat)(images.count), height:  maxSize.height)
            }
            UIGraphicsBeginImageContext(totalSize)
            for image in images {
                let offset = (CGFloat)(images.firstIndex(of: image)!)
                let rect =  AVMakeRect(aspectRatio: image.size, insideRect: isVertical ?
                    CGRect(x: 0, y: maxSize.height * offset, width: maxSize.width, height: maxSize.height) :
                    CGRect(x: maxSize.width * offset, y: 0, width: maxSize.width, height: maxSize.height))
                image.draw(in: rect)
            }
            stitchedImages = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return stitchedImages
      }
}
