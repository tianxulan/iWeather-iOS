//
//  weatherDataService.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/23/21.
//

import Foundation
protocol AutocompleteServiceDelegate
{
    func didUpdateAutocomplete(autocompletemodel:AutocompleteModel)
}
struct AutocompleteService
{
    let weatherURL = ""
    var delegate: AutocompleteServiceDelegate?
    
    func fetchAutocomplete(keyword: String)
    {
        
        let urlString = "https://weather-node-330706.wn.r.appspot.com/autoComplete?keyword=\(keyword)"
        performRequest(urlString: urlString)
            
            
       
        
    }
    func performRequest (urlString: String)
    {
        if let url = URL(string:urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with:url) { (data,response,error) in
                if error != nil
                {
                    print(error!)
                    return
                }
                if let safeData = data
                {
                    if let autocomplete = self.parseJSON(autoCompleteData:safeData)
                    {
                        self.delegate?.didUpdateAutocomplete(autocompletemodel: autocomplete)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(autoCompleteData: Data) -> AutocompleteModel?
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode([AutocompleteData].self, from: autoCompleteData)
            var autoCompleteCellsArray: Array<AutocompleteCellModel> = []
        
            for decodedDataCell in decodedData {
                let description = String(decodedDataCell.description)
                let name = String(decodedDataCell.name)
                
                let autoCompleteCell = AutocompleteCellModel(cityDescription: description, cityName: name)
                autoCompleteCellsArray.append(autoCompleteCell)
            }
            let autoCompleteModel = AutocompleteModel(placeCells: autoCompleteCellsArray)
            
            
            
            
            return autoCompleteModel
            
        }catch
        {
            print(error)
            return nil
        }
        
        
    }
    
}
