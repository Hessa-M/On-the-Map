//
//  TableViewContrroller.swift
//  On the Map
//
//  Created by Hessa Mohamed on 01/01/2019.
//  Copyright © 2019 Hessa Mohamed. All rights reserved.
//

import UIKit

class TableViewContrroller: TabBarViewController, UITableViewDelegate  , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocation()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    var locationsData: StudentLocationData? {
        didSet {
            guard let locationsData = locationsData else { return }
            locations = locationsData.studentLocations
        }
    }
    var locations: [StudentLocationInfo] = [] {
        didSet {
            DispatchQueue.main.async {
            self.tableView.reloadData()
           }
        }
    }
    
 override func getStudentLocation(){
        
        ParseAPI.getStudentLocations { (data, error) in
            
           if error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "No internet connection found", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                    { _ in
                        return
                }))
            self.present(errorAlert, animated: true, completion: nil)
          }
            
            guard let data = data else {
                let errorAlert = UIAlertController(title: "Error", message: "No data found", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)

                return
            }
            
            guard data.studentLocations.count > 0 else {
                let errorAlert = UIAlertController(title: "Error", message: "No Data found", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)

                return
            }
            self.locationsData = data
        }
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return locations.count
  }
    
   func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath)-> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell", for: indexPath) as! LocationTableCell

    cell.nameTextField!.text = "\(locations[indexPath.row].firstName ?? "") \(locations[indexPath.row].lastName ?? "")"
    cell.linkTextField!.text = locations[indexPath.row].mediaURL

    cell.pinImageView!.image = UIImage(named:"baseline_place_black_36pt")

    return cell
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let app = UIApplication.shared
        if let toOpen =  locations[indexPath.row].mediaURL,
            let url = URL(string: toOpen), app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
        } else{
            
            let errorAlert = UIAlertController(title: "Invalid URL", message: "Could not open URL", preferredStyle: .alert )
            
            errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                { _ in
                    return
            }))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
    }
    
}
