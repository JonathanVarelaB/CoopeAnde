//
//  Constants.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import UIKit // Revisar referencia (Originalmente no esta)

struct Constants
{
    static let Device = UIDevice.current
    static let iosVersion = NSString(string: Device.systemVersion).doubleValue
    static let deviceType = Device.model
    static var iOS8 : Bool  {
        get{
            return Constants.iosVersion >= 8
        }
    }
    static var iOS7 : Bool {
        get{
            return Constants.iosVersion >= 7 && Constants.iosVersion < 8
        }
    }
    static var  iPhone : Bool
    {
        return deviceType.lowercased().range(of: "iphone") != nil
    }
    static var  iPad : Bool
    {
        return deviceType.lowercased().range(of: "ipad") != nil
    }
    static var orientation : UIInterfaceOrientation
    {
        get
        {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    
    ///mainMenuOrder
    //0:Ubicanos
    //1:NO SE USA
    //2:Noticias
    //3:Tipo de Cambio
    //4:Acerca de
    //5:Inicio
    //6:NO SE USA
    //7:Iniciar Sesiòn
    static let mainMenuOrder = [5,7,0,3,2,4]
    
    //0:Cuentas
    //1:Transaderencias
    //2:pago de servicios
    //3:Créditos
    //4:calculadora de ahorro y credito
    //5:SINPE Movil
    //6:Anuncios
    //7:Cerrar Sesión
    static let loginMenuOrder = [0,1,2,3,4,5,6,7]
    static let rowsPerPage : Int = 20
    static  var formatter : NumberFormatter?
    //Se determina que el aplicativo debe de usar los mensajes que provee el backend
    //static let loggoutCode :String = "MC1.97|APP.50|APP.01|APP.1|MC1.96|"
    static let loggoutCode :String = "MC1.97|APP.50|MC1.96|"
}
enum RecipeType
{
    case transfers
    case bills
    case loans
}
