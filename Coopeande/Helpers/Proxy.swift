//
//  Proxy.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import SystemConfiguration

struct ProxyManagerData {
    static var logArray:Array<NSString> = []
    static var baseRequestData: BaseRequest?
    static var tokenData: LoginResponse? = nil
    static var actualController: BaseViewController!
    
    //Categorias para
    static var categories : Array<PlaceCategory> = [];
    static var categoriesWithChildren : Array<PlaceCategory> = [];
    
    //TODO Para Produccion
    //static let testUrl = "https://apptest.coope-ande.co.cr/MASWebApi/"
    //static let mainUrl = "https://webservice.coope-ande.co.cr/MASWebapi/"
    
    //TODO Para Produccion
    //static let mainUrl = "https://apptest.coope-ande.co.cr/MASWebApi/"
    //static let  testUrl = "http://172.16.98.34:81/MASWebApiDummyFase3/"
    
    //static let mainUrl = "http://172.16.98.34:81/MASWebApiDummyFase3/"
    //static let  testUrl = "http://172.16.98.34:81/MASWebApiDummyFase3/"
    
    //static let mainUrl = "http://172.16.98.34:81/MASWebApiAppNuevaPrueba/"
    //static let testUrl = "http://172.16.98.34:81/MASWebApiAppNuevaPrueba/"
    
    //static let mainUrl = "http://172.16.99.127:1003/MASMobileWebApi_NewAPP/" // Dummy Tecno Privada
    //static let testUrl = "http://172.16.99.127:1003/MASMobileWebApi_NewAPP/"
    
    static let mainUrl = "http://201.195.70.72/MASWebApi/" // CoopeAnde Pública
    static let testUrl = "http://201.195.70.72/MASWebApi/"
    
    //static let mainUrl = "https://26c633a5.ngrok.io/MASMobileWebApi_NewAPP/" // Dummy Tecno Pública (este es el que expira, cambiar este URL)
    //static let testUrl = "https://26c633a5.ngrok.io/MASMobileWebApi_NewAPP/"
    
    static  var baseUrl : String = mainUrl
    
    static var baseImageURL : String {
        get {
            if Constants.iPhone{
                return baseUrl + "images/"
            }
            else{
                return baseUrl + "imagesTablet/"
            }
        }
    }
}

class UtilProxyManager{
    
    // *** LOGIN
    func PreLogin(_ data : PreLoginRequest, success:((LoginResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            ProxyManagerData.baseUrl = result.isSuccess ? ProxyManagerData.testUrl : ProxyManagerData.mainUrl
            print(ProxyManagerData.baseUrl)
            data.includeParent = true
            self.Login(data,success: success,failure: failure)
        }
        self.callProxy("User/IsTesting", data: data, useSessionData: false, result: (BaseResponse() ), success: internalSuccess, failure: failure)
    }
    
    func Login(_ data : LoginRequest, success:((LoginResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = { (result) in
            if let token  = (result as? LoginResponse)!.data{
                ProxyManagerData.baseRequestData  = BaseRequest()
                ProxyManagerData.baseRequestData?.token = token.token
                ProxyManagerData.baseRequestData?.user = data.user
                success((result as? LoginResponse)!)
            }
            else{
                failure(NSError(domain: "Proxy" , code:200, userInfo: ["message": "Generic Error Message"]))
            }
        }
        self.callProxy("User/Validate", data: data, useSessionData: false, result: (LoginResponse() as BaseResponse), success: internalSuccess, failure: failure)
    }
    
    // *** CERRAR SESIÓN
    func Logout(_ success:((LoginResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            if let token  = (result as? LoginResponse){
                if(token.isSuccess){
                    ProxyManagerData.baseUrl = ProxyManagerData.mainUrl
                    ProxyManagerData.tokenData = nil
                    ProxyManagerData.baseRequestData = nil
                    ProxyManagerData.actualController = nil
                }
                success(token)
            }
        }
        self.callProxy("User/Logout", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (LoginResponse()), success: internalSuccess, failure: failure)
    }
    
    //  *** TIPO DE CAMBIO
    func CurrencyExchange(_ success:((CurrencyExchangeRateResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! CurrencyExchangeRateResponse)
        }
        ProxyManagerData.baseUrl = ProxyManagerData.mainUrl
        self.callProxyPrueba("Currency/GetTodayRateExchange", useSessionData: false, result: (CurrencyExchangeRateResponse()), success: internalSuccess, failure: failure)
    }
    
    // *** UBÍCANOS
    func GetPlaces( _ data: PlacesRequest,  success:((PlacesResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! PlacesResponse)
        }
        ProxyManagerData.baseUrl = ProxyManagerData.mainUrl
        self.callProxy("Geolocation/GetPlaces", data: data, useSessionData: false, result: (PlacesResponse()), success:internalSuccess, failure: failure)
    }
    
    func PlacesCategory( _ success:((PlaceCategoryResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = { (result) in
            let data: PlaceCategoryResponse = result as! PlaceCategoryResponse
            ProxyManagerData.categories = []
            ProxyManagerData.categoriesWithChildren = []
            if(data.isSuccess){
                if let list: Array<PlaceCategory> = data.data?.list{
                    for item in list{
                        if(item.subCategories.count == 0){
                            ProxyManagerData.categories.append(item)
                        }
                        else{
                            ProxyManagerData.categoriesWithChildren.append(item)
                        }
                    }
                }
            }
            success(data)
        }
        ProxyManagerData.baseUrl = ProxyManagerData.mainUrl
        self.callProxyPrueba("Geolocation/GetCategoryPlaces", useSessionData: false, result: (PlaceCategoryResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetPlaceDetail(_ data:PlaceDetailRequest ,success:((PlaceDetailResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! PlaceDetailResponse)
        }
        ProxyManagerData.baseUrl = ProxyManagerData.mainUrl
        self.callProxy("Geolocation/GetPlaceDetail", data: data, useSessionData: false, result: (PlaceDetailResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetTicketCRM(data: TicketCRMRequest, success:((TicketCRMResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! TicketCRMResponse)
        }
        self.callProxy("Geolocation/GetTicketCRM", data: data, useSessionData: false, result: (TicketCRMResponse()), success:internalSuccess, failure: failure)
    }
    
    // *** ANUNCIOS
    func GetNews(data: BaseRequest, success:((AdsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! AdsResponse)
        }
        self.callProxy("News/GetNews", data: data, useSessionData: false, result: (AdsResponse()), success:internalSuccess, failure: failure)
    }
    
    // *** CUENTAS
    func AllBalances(_ success:((AllAccountsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! AllAccountsResponse)
        }
        self.callProxy("Account/GetAll", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (AllAccountsResponse()), success:internalSuccess, failure: failure)
    }
    
    func AccountMovements(_ data: StatementsRequest, success:((StatementsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! StatementsResponse)
        }
        self.callProxy("Account/GetTransactionDetail", data: data, useSessionData: true, result: (StatementsResponse()), success:internalSuccess, failure: failure)
    }
    
    // *** TRANSFERENCIAS
    func TransferTypes(success:((TransferTypesResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! TransferTypesResponse)
        }
        self.callProxy("Transfer/GetAllTypes", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (TransferTypesResponse()), success:internalSuccess, failure: failure)
    }
    
    func AccountsByTransferType(data: TransferAccountsRequest, success:((TransferAccountsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! TransferAccountsResponse)
        }
        self.callProxy("Account/GetAllByTransferTypeId", data: data, useSessionData: true, result: (TransferAccountsResponse()), success:internalSuccess, failure: failure)
    }
    
    func ApplyTransfer(data: TransferRequest, success:((TransferResponse) -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess: ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! TransferResponse)
        }
        self.callProxy("Transfer/Apply", data: data, useSessionData: true, result: (TransferResponse()), success:internalSuccess, failure: failure)
    }
    
    func TransferConfirm(data: TransferRequest, success:((TransferConfirmResponse) -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess: ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! TransferConfirmResponse)
        }
        self.callProxy("Transfer/Confirm", data: data, useSessionData: true, result: (TransferConfirmResponse()), success:internalSuccess, failure: failure)
    }
    
    // *** PAYMENT SERVICES
    func AllServices(_ success:((AllServicesResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! AllServicesResponse)
        }
        self.callProxy("PaymentServices/GetAll", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (AllServicesResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetAllByTypeId(_ data : PaymentServicesRequest, success:((PaymentServicesResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! PaymentServicesResponse)
        }
        self.callProxy("PaymentServices/GetAllByTypeId", data: data, useSessionData: true, result: (PaymentServicesResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetReceiptDetailByService(data:ReceiptDetailServiceRequest,success:((ReceiptDetailServiceResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! ReceiptDetailServiceResponse)
        }
        self.callProxy("PaymentServices/GetDetailByService", data: data, useSessionData: true, result: (ReceiptDetailServiceResponse()), success:internalSuccess, failure: failure)
    }
    
    func PayBill(data:PayServiceBillRequest,success:((PayServiceBillResponse)  -> Void )!, failure: ((NSError)  -> Void )!)
    {
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! PayServiceBillResponse)
        }
        self.callProxy("PaymentServices/Apply", data: data, useSessionData: true, result: (PayServiceBillResponse()), success:internalSuccess, failure: failure)
    }
    
    // *** CREDITS
    func GetTypesByUser(success:((CreditTypesByUserResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! CreditTypesByUserResponse)
        }
        self.callProxy("Credit/GetTypesByUser", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (CreditTypesByUserResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetCreditByType(data:CreditByTypeRequest,success:((CreditByTypeResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! CreditByTypeResponse)
        }
        self.callProxy("Credit/GetByType", data: data, useSessionData: true, result: (CreditByTypeResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetCreditCatalogs(success:((CreditCatalogsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! CreditCatalogsResponse)
        }
        self.callProxy("Credit/GetCreditCatalogs", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (CreditCatalogsResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetAllCreditTransaction(data : GetAllCreditTransactionRequest, success:((GetAllCreditTransactionResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! GetAllCreditTransactionResponse)
        }
        self.callProxy("Credit/GetAllTransaction", data: data, useSessionData: true, result: (GetAllCreditTransactionResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetPayCreditType(data: PayCreditTypeRequest, success:((PayCreditTypeResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! PayCreditTypeResponse)
        }
        self.callProxy("Credit/GetReceiveType", data:data, useSessionData: true, result: (PayCreditTypeResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetPayCreditConfirm(data: PayCreditConfirmRequest, success:((PayCreditResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! PayCreditResponse)
        }
        self.callProxy("Credit/Confirm", data: data, useSessionData: true, result: (PayCreditResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetPayCreditApply(data : PayCreditRequest, success:((PayCreditResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! PayCreditResponse)
        }
        self.callProxy("Credit/Apply", data: data, useSessionData: true, result: (PayCreditResponse()), success:internalSuccess, failure: failure)
    }
    
    // *** CALCULADORA
    func GetCalculatorCatalogs(success:((CalculatorTypesResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! CalculatorTypesResponse)
        }
        self.callProxy("Saves/GetCalculatorCatalogs", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (CalculatorTypesResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetCreditCalc(data : CreditCalculatorRequest, success:((CreditCalculatorResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! CreditCalculatorResponse)
        }
        self.callProxy("Credit/Calculator", data: data, useSessionData: true, result: (CreditCalculatorResponse()), success:internalSuccess, failure: failure)
    }
    
    func getSavingCalculator(data : SavingCalculatorRequest, success:((SavingCalculatorResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! SavingCalculatorResponse)
        }
        self.callProxy("Saves/Calculator", data: data, useSessionData: true, result: (SavingCalculatorResponse()), success:internalSuccess, failure: failure)
    }
    
    // *** SINPE
    func GetAccountToAfiliate(_ success:((AllAccountsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! AllAccountsResponse)
        }
        self.callProxy("Wallet/GetAccountToAfiliate", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (AllAccountsResponse()), success:internalSuccess, failure: failure)
    }
    
    func Afiliate(data: WalletAfilliateNumberRequest, success:((BaseResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result)
        }
        self.callProxy("Wallet/Afiliate", data: data, useSessionData: true, result: (BaseResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetAccountsOrigin(success:((AllAccountsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! AllAccountsResponse)
        }
        self.callProxy("Wallet/GetAccountOrigin", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (AllAccountsResponse()), success:internalSuccess, failure: failure)
    }
    
    func WalletTransferConfirm(data: WalletTransferRequest, success:((TransferConfirmResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! TransferConfirmResponse)
        }
        self.callProxy("Wallet/TransferConfirm", data: data, useSessionData: true, result: (TransferConfirmResponse()), success:internalSuccess, failure: failure)
    }
    
    func WalletApplyTransfer(data: WalletTransferRequest, success:((TransferResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! TransferResponse)
        }
        self.callProxy("Wallet/TransferApply", data: data, useSessionData: true, result: (TransferResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetFavoriteContacts(success:((FavoriteContactsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! FavoriteContactsResponse)
        }
        self.callProxy("Wallet/GetFavoriteContacts", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (FavoriteContactsResponse()), success:internalSuccess, failure: failure)
    }
    
    func AddFavoriteContact(data: FavoriteRequest, success:((BaseResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result)
        }
        self.callProxy("Wallet/AddFavoriteContact", data: data, useSessionData: true, result: (BaseResponse()), success:internalSuccess, failure: failure)
    }
    
    func DeleteFavoriteContact(data: FavoriteRequest, success:((BaseResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result)
        }
        self.callProxy("Wallet/DeleteFavoriteContact", data: data, useSessionData: true, result: (BaseResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetAllWalletAccountsAfilliate(success:((AllAccountsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! AllAccountsResponse)
        }
        self.callProxy("Wallet/GetAccountAfiliate", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (AllAccountsResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetWalletAccountMovements(data : WalletStatementsRequest, success:((StatementsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! StatementsResponse)
        }
        self.callProxy("Wallet/GetTransactionDetail", data: data, useSessionData: true, result: (StatementsResponse()), success:internalSuccess, failure: failure)
    }
    
    func GetWalletTransferAmounts( success:((WalletTransferAmountsResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! WalletTransferAmountsResponse)
        }
        self.callProxy("Wallet/GetMaxAmountTransferValues", data: ProxyManagerData.baseRequestData, useSessionData: false, result: (WalletTransferAmountsResponse()), success:internalSuccess, failure: failure)
    }
    
    func SetMaxAmountTransferValues(data : WalletTransferAmountsRequest, success:((BaseResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess: ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as BaseResponse)
        }
        self.callProxy("Wallet/SetMaxAmountTransferValues", data: data, useSessionData: true, result: (BaseResponse()), success:internalSuccess, failure: failure)
    }
    
    func WalletAccountInactivate(data: WalletAccountInactivateRequest, success:((BaseResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess: ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as BaseResponse)
        }
        self.callProxy("Wallet/Inactive", data: data, useSessionData: true, result: (BaseResponse()), success:internalSuccess, failure: failure)
    }
    
    // *** CAMBIO DE CONTRASEÑA
    func GetPoliciesAboutPassword(_ success:((PasswordPoliciesResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        let internalSuccess : ((BaseResponse)  -> Void )! = {
            (result) in
            success(result as! PasswordPoliciesResponse)
        }
        self.callProxyPrueba("User/GetPoliciesAboutPassword", useSessionData: false, result: (PasswordPoliciesResponse()), success:internalSuccess, failure: failure)
    }
    
    func ChangePassword(_ data: ChangePasswordRequest, success:((BaseResponse)  -> Void )!, failure: ((NSError)  -> Void )!){
        self.callProxy("User/ChangePassword", data: data, useSessionData: false, result: BaseResponse(), success: success, failure: failure)
    }
    
    // ** VALIDAR CONEXIÓN
    fileprivate func hasConnection() -> Bool{
        return Helper.hasConnection()
    }
    
    fileprivate func callProxyPrueba(_ url:String, useSessionData:Bool, result:BaseResponse,success:((BaseResponse)  -> Void )!, failure: ((NSError)  -> Void )!)
    {
        print("hasConnection() : ",hasConnection())
        if(hasConnection())
        {
            var parameters : NSMutableDictionary?
            
            let url = URL(string: ProxyManagerData.baseUrl + url)!
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            //let postString = "id=13&name=Jack"
            //request.httpBody = postString.data(using: .utf8)
            //let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print(jsonString)
            //request.httpBody = jsonString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    failure(NSError(domain: "Proxy" , code:200, userInfo: ["message": "Generic Error Message"]))
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    failure(NSError(domain: "Proxy" , code:200, userInfo: ["message": "Generic Error Message"]))
                    return
                }
                
                let responseString = String(data: data, encoding: .utf8)
                if responseString != nil {
                    
                    do{
                        //var json = try JSONSerialization.dataWithJSONObject(response, options: .allZeros, error: nil)!
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        result.fromJson(json)
                        
                    }catch let error as NSError {
                        failure(NSError(domain: "Proxy" , code:200, userInfo: ["message": "Generic Error Message"]))
                        return
                    }
                    
                    
                }
                else
                {
                    result.code = "IOS.99"
                    result.message = "Not Response"
                    result.isSuccess = false
                }
                if success != nil {
                    success(result)
                    
                }
                
                
                print("responseString = ",responseString!)
            }
            task.resume()
            
        }
        else
        {
            failure(NSError(domain: "Proxy" , code:500, userInfo: ["message":"No existe conexión de internet"]))
        }
    }
    
    fileprivate func callProxy(_ url:String, data: BaseRequest?, useSessionData: Bool, result: BaseResponse, success: ((BaseResponse) -> Void )!, failure: ((NSError) -> Void)!){
        print("*** " + url + " ***")
        print("hasConnection() : ",hasConnection())
        if(hasConnection()) {
            var parameters : NSMutableDictionary?
            if data != nil{
                if(useSessionData){
                    if let token = ProxyManagerData.baseRequestData{
                        if(token.token.length > 0) {
                            data!.token = token.token
                            data!.user = token.user
                        }
                        else {
                            result.isSuccess = false
                            result.code = "APP.50"
                            result.message = "Your session has expired"
                            if success != nil {
                                success(result)
                            }
                            return Void()
                        }
                    }
                    else{
                        result.isSuccess = false
                        result.code = "APP.50"
                        result.message = "Your session has expired"
                        if success != nil {
                            success(result)
                        }
                        return Void()
                    }
                }
                parameters = data!.toJson()
            }
            let url = URL(string: ProxyManagerData.baseUrl + url)!
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters as Any, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print("Data Send: ", jsonString)
            request.httpBody = jsonString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil
                    else {
                        failure(NSError(domain: "Proxy" , code:200, userInfo: ["message": "Generic Error Message"]))
                        return
                    }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    failure(NSError(domain: "Proxy" , code:200, userInfo: ["message": "Generic Error Message"]))
                    return
                }
                let responseString = String(data: data, encoding: .utf8)
                if responseString != nil {
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        result.fromJson(json)
                    } catch _ as NSError {
                        failure(NSError(domain: "Proxy" , code:200, userInfo: ["message": "Generic Error Message"]))
                        return
                    }
                }
                else{
                    result.code = "IOS.99"
                    result.message = "Not Response"
                    result.isSuccess = false
                }
                if success != nil {
                    success(result)
                }
                print("responseString = ",responseString!)
            }
            task.resume()
        }
        else{
            failure(NSError(domain: "Proxy" , code:500, userInfo: ["message":"No existe conexión de internet"]))
        }
    }
    
}
