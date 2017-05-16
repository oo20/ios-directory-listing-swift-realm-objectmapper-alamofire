//
//  DirectoryController.swift
//  Directory
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

protocol DirectoryControllerDelegate {
    func getIndividuals();
}

class DirectoryController: UITableViewController , SwipeTableViewCellDelegate, DirectoryControllerDelegate {
    
    var individuals : List<Individual> = List<Individual> ()
    var selectedIndividual : Individual? = nil
    var selectedIndividualIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        getIndividuals()
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return individuals.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction func refresh(_ sender: Any) {
        AppManager.shared().clearData()
        getIndividuals()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryCell", for: indexPath)

        let directoryCell = cell as! DirectoryCell
        directoryCell.delegate = self
        directoryCell.selectionStyle = .none
        directoryCell.individualIndex = indexPath.row
        directoryCell.individual = individuals[indexPath.row]
        directoryCell.displayData()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndividualIndex = indexPath.row
        selectedIndividual = individuals[indexPath.row]
        return indexPath
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "IndividualDetailSegue") {
            assert(selectedIndividual != nil)
            assert(selectedIndividualIndex != -1)
            let destination = segue.destination as! IndividualDetailController
            destination.individualIndex = selectedIndividualIndex
            destination.individual = selectedIndividual
            destination.directoryDelegate = self
        }
        
        if (segue.identifier == "CreateIndividualDetailSegue") {
            selectedIndividual = nil
            selectedIndividualIndex = -1
            let destination = segue.destination as! IndividualDetailController
            destination.individualIndex = -1
            destination.individual = Individual()
            destination.directoryDelegate = self
        }
    }
    
    func getIndividuals() {
        AppManager.shared().webService.fetchIndividuals { (individuals) in
            self.individuals = individuals
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard AppManager.shared().authenticated() == true else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in

            let deleteIndividual = self.individuals[indexPath.row]
            
            AppManager.shared().webService.deleteIndividual(deleteIndividual.id, deleteIndividual, { (id) in
                
                self.individuals.remove(at: indexPath.row)
                
                self.selectedIndividualIndex = -1
                self.selectedIndividual = nil
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                self.tableView.endUpdates()
            })

        }

        // customize the action appearance
        deleteAction.image = UIImage.getSystemImage(UIBarButtonSystemItem.trash)

        return [deleteAction]
    }

}
