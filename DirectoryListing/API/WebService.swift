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

typealias ClosureIndividuals = (List<Individual>) -> ()
typealias ClosureIndividual = (String?, Individual?) -> ()
typealias ClosureIndividualId = (String?) -> ()

class WebService: REST {
    let directoryURL = AppManager.baseURL + "individuals/directory"
    let createIndividualURL = AppManager.baseURL + "individual/create"
    let modifyIndividualURL = AppManager.baseURL + "individual/modify/"
    let deleteIndividualURL = AppManager.baseURL + "individual/delete/"
    
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
    
    private func writeIndividualsLocally(_ individuals: List<Individual>) {
        
        do {
            let realm = try Realm()
            
            realm.beginWrite()
            
            for individual in individuals {
                realm.add(individual, update: true)
            }
            
            try realm.commitWrite()
            
        } catch let error {
            DLog("Realm write individuals error \(error)")
        }

    }
    
    func fetchIndividuals(_ closureIndividuals: @escaping ClosureIndividuals) {
        do {
            let realmRead = try Realm()
            
            let savedIndividuals = realmRead.objects(Individual.self)
            
            if (savedIndividuals.count > 0) {
                DLog("Loaded \(savedIndividuals.count) individuals from database.")
                closureIndividuals(self.convertResultsToList(savedIndividuals))
                
                return
            }
            
            realmRead.invalidate()
            
            getIndividuals { individuals in
                
                DLog("Written \(individuals.count) individuals from internet to database.")
                closureIndividuals(individuals)
                
                self.writeIndividualsLocally(individuals)
            }
            
        } catch let error {
            DLog("Realm open individuals error \(error)")
            closureIndividuals(List<Individual>())
            return
        }
    }
    
    func createIndividual(_ individual: Individual, _ closureIndividual: @escaping ClosureIndividual) {
        DLog("Directory - Create Individual - URL: \(createIndividualURL)")
        
        let data = Directory()
        data.individuals.append(individual)
        
        self.postObject(url:  createIndividualURL, dataObject: data) { (response: Directory?) in
            
            guard let directory: Directory = response else {
                closureIndividual(nil, nil)
                return
            }
            
            let individuals = directory.individuals
            
            if (individuals.count != 1) {
                closureIndividual(nil, nil)
                return
            }
            
            for individual in individuals {
                DLog("Individual Found: \(individual.debugText())")
            }
            
            self.writeIndividualsLocally(individuals)
            
            DLog("Individual Count: \(directory.individuals.count)")
            
            let individual = individuals[0]
            
            closureIndividual(individual.id, individual)
        }
    }
    
    func modifyIndividual(_ id: String, _ individual: Individual, _ closureIndividual: @escaping ClosureIndividual) {
        DLog("Directory - Modify Individuals - URL: \(modifyIndividualURL)\(id)")
        
        let data = Directory()
        data.individuals.append(individual)
        
        self.putObject(url:  modifyIndividualURL + id, dataObject: data) { (response: Directory?) in
            
            guard let directory: Directory = response else {
                closureIndividual(nil, nil)
                return
            }
            
            let individuals = directory.individuals
            
            if (individuals.count != 1) {
                closureIndividual(nil, nil)
                return
            }
            
            for individual in individuals {
                DLog("Individual Found: \(individual.debugText())")
            }
            
            self.writeIndividualsLocally(individuals)
            
            DLog("Individual Count: \(directory.individuals.count)")
            
            let individual = individuals[0]
            
            closureIndividual(individual.id, individual)
        }
    }
    
    func deleteIndividual(_ id: String, _ individual: Individual, _ closureIndividualId: @escaping ClosureIndividualId) {
        DLog("Directory - Delete Individuals - URL: \(deleteIndividualURL)\(id)")
        
        self.deleteObject(url:  deleteIndividualURL + id) { (response: Directory?) in
            
            do {
                let realm = try Realm()
                
                let deleteId = individual.id
                
                realm.beginWrite()
                
                realm.delete(individual)

                try realm.commitWrite()
                
                closureIndividualId(deleteId)
                
            } catch let error {
                DLog("Realm delete individuals error \(error)")
                
                 closureIndividualId(nil)
            }
            
        }
    }
}
