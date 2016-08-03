    //
//  ViewController.swift
//  Qual o Clima
//
//  Created by Iuri Menin on 02/08/16.
//  Copyright © 2016 Iuri Menin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldCidade: UITextField!
    @IBOutlet weak var labelRetorno: UILabel!
    
    @IBAction func buscarClima(sender: UIButton) {
    
        let urlRequisitada  = NSURL(string: "http://www.weather-forecast.com/locations/" +
            textFieldCidade.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = urlRequisitada {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                
                let httpResponse = response as! NSHTTPURLResponse
                
                if httpResponse.statusCode == 200 {
                    
                    if let urlContent = data {
                        
                        let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                        
                        let webSiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                        
                        if webSiteArray.count > 1 {
                            
                            let weatherArray = webSiteArray[1].componentsSeparatedByString("</span>")
                            
                            if weatherArray.count > 1 {
                                
                                let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.labelRetorno.text = weatherSummary
                                })
                            }
                        }
                    }
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.labelRetorno.text = "Cidade não encontrada. Tente novamente"
                    })
                   
                }
                
            }
            
            task.resume()
        } else {
            
            labelRetorno.text = "Url Inválida"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

