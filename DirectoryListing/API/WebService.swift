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
            let directory: Directory? = response//response.result.value!
            
            guard (directory != nil) else {
                closureIndividuals(List<Individual>())
                return
            }
            
            let individuals = directory!.individuals
            
            guard (individuals != nil) else {
                closureIndividuals(List<Individual>())
                return
            }
            
            for individual in individuals! {
                DLog("Individual Found: \(individual.debugText())")
            }
            
            DLog("Individual Count: \(directory!.individuals!.count)")
            
            closureIndividuals(individuals!)
        }
    }
    
    func fetchIndividuals(_ closureIndividuals: @escaping ClosureIndividuals) {
        let realm = try! Realm()
        let savedIndividuals = realm.objects(Individual.self)
        if (savedIndividuals.count > 0) {
            DLog("Loaded \(savedIndividuals.count) individuals from database.")
            closureIndividuals(self.convertResultsToList(savedIndividuals))
            return
        }
        
        getIndividuals { individuals in
            try! realm.write {
                for individual in individuals {
                    realm.add(individual, update: true)
                }
            }
            let savedIndividuals = realm.objects(Individual.self)
            DLog("Written \(savedIndividuals.count) individuals from internet to database.")
            closureIndividuals(self.convertResultsToList(savedIndividuals))
        }
        
        
    }
}
