//
//  WebService.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/22/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class WebService: REST {
    let directoryURL = AppManager.baseURL + "directory"

    private func getIndividuals(_ closureIndividuals: @escaping ClosureIndividuals) {
        DLog("Directory - Get Individuals - URL: \(directoryURL)")
        
        self.getObject(url:  directoryURL) { (response: Directory?) in
            
            guard let directory: Directory = response else {
                closureIndividuals(List<Individual>())
                return
            }
        
            let individuals = directory.individuals
            
            if (individuals.count <= 0) {
                closureIndividuals(List<Individual>())
                return
            }
            
            for individual in individuals {
                DLog("Individual Found: \(individual.debugText())")
            }
            
            DLog("Individual Count: \(directory.individuals.count)")
            
            closureIndividuals(individuals)
        }
    }
    
    func fetchIndividuals(_ closureIndividuals: @escaping ClosureIndividuals) {
        do {
            let realm = try Realm()
            
            let savedIndividuals = realm.objects(Individual.self)
            
            if (savedIndividuals.count > 0) {
                DLog("Loaded \(savedIndividuals.count) individuals from database.")
                closureIndividuals(self.convertResultsToList(savedIndividuals))
                
                return
            }
            
            getIndividuals { individuals in
                do {
                    try realm.write {
                        for individual in individuals {
                            realm.add(individual, update: true)
                        }
                    }
                } catch let error {
                    DLog("Realm write individuals error \(error)")
                    closureIndividuals(List<Individual>())
                    return
                }
                
                let savedIndividuals = realm.objects(Individual.self)
                
                DLog("Written \(savedIndividuals.count) individuals from internet to database.")
                closureIndividuals(self.convertResultsToList(savedIndividuals))
            }
            
        } catch let error {
            DLog("Realm open individuals error \(error)")
            closureIndividuals(List<Individual>())
            return
        }
        

        
        
    }
}
