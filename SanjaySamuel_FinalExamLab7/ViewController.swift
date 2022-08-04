//
//  ViewController.swift
//  SanjaySamuel_FinalExamLab7
//
//  Created by Sanjay Sekar Samuel on 2022-07-27.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Function to return the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    // Function to populate the table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = model[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = m.name
        return cell
    }
    
    // function to delete a table row
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Function which deletes the row both in the core data base and as well as in the table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            let item = model[indexPath.row]
            model.remove(at: indexPath.row)
            self.deleteItem(item: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Programatically creating the table view
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Assigning a cell for the table
        
        return table
    }()
    
    // Setting up the model to be from the ToDoList core data model
    private var model = [ToDoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "To Do List"
        getAllStoredItems()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addNewToDoItem))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    // Function that gets triggered when the add button gets clicked from above
    @objc private func addNewToDoItem(){
        let alert = UIAlertController(title: "New Task", message: "Enter new task", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            
            self?.createNewItem(name: text)
        }))
        
        present(alert, animated: true)
    }
    
    // Function to get all the stored items from the core data presistence
    func getAllStoredItems(){
        do {
            model = try context.fetch(ToDoList.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch{
            print(error)
        }
    }
    
    // Function that creates a new item in core data with the key "name"
    func createNewItem(name: String){
        let newToDoItem = ToDoList(context: context)
        newToDoItem.name = name
        
        do{
            try context.save()
            getAllStoredItems()
        } catch{
            print(error)
        }
    }
    
    // Function that deletes an item in the core data
    func deleteItem(item: ToDoList){
        context.delete(item)
        
        do{
            try context.save()
        } catch{
            print(error)
        }
    }
}

