//
//  ViewController.swift
//  BuscadorUsuarios
//
//  Created by Néstor Iván on 11/06/18.
//  Copyright © 2018 Néstor Iván. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addUserTextField: UITextField!
    
    var users = [UserStats]()
    
    var array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self

    }

    @IBAction func addUserTapped(_ sender: Any) {
        if addUserTextField.text != ""{
            
            guard let gitUrl = URL(string: "https://api.github.com/users/" + addUserTextField.text!) else { return }
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                , error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(UserStats.self, from: data)
                    
                    if gitData.name != nil{
                        
                        self.add(gitData)
                    }else{
                        print(123)
                        self.alertInexistentUser()
                    }
                } catch let err {
                    print("Err", err)
                }
                }.resume()
        }
    }
    
    func add(_ user: UserStats){
        
        self.users.append(user)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.users.count-1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .bottom)
            self.addUserTextField.text = ""
            self.view.endEditing(true)
        }
    }
    
    func alertInexistentUser(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "Usuario no encontrado", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.addUserTextField.text = ""
            self.view.endEditing(true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserViewController{
            destination.user = users[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = users[indexPath.row].name?.capitalized
        cell.imageView?.downloadedFrom(url: users[indexPath.row].avatarUrl!)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        users.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}


