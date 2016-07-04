//
//  ViewController.swift
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testTextField: UITextField!
    
    //管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!
    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            //管理オブジェクトコンテキストを取得する。
            let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            managedContext = applicationDelegate.managedObjectContext
            
            //管理オブジェクトコンテキストからPlayerエンティティを取得する。
            let fetchRequest = NSFetchRequest(entityName: "Player")
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            //すべてのPlayerエンティティの名前をラベルに表示する。
            for data in result {
                testLabel.text = testLabel.text! + "," + String(data.valueForKey("name")!)
            }
            
            //デリゲート先に自分を設定する。
            testTextField.delegate = self
            
        } catch {
            print(error)
        }
    }
    
    
    //Returnキー押下時の呼び出しメソッド
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        do {
            //ラベルの値にテキストフィールドの値を追記する。
            testLabel.text = testLabel.text! + "," + testTextField.text!
            
            //新しいPlayerエンティティを管理オブジェクトコンテキストに格納する。
            let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: managedContext)
            
            //Playerエンティティの名前にテキストフィールドの値を設定する。
            player.setValue(testTextField.text, forKey:"name")
            
            //管理オブジェクトコンテキストの中身を永続化する。
            try managedContext.save()
            
            //キーボードをしまう
            self.view.endEditing(true)
            
        } catch {
            print(error)
        }
        return true
    }
}
