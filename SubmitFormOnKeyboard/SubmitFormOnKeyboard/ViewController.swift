//
//  ViewController.swift
//  SubmitFormOnKeyboard
//
//  Created by rMac on 2019/02/10.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var submitForm: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitFormBottomConstraints: NSLayoutConstraint!
    
    var submitFormY:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textLabel.layer.borderColor = UIColor.blue.cgColor
        textLabel.layer.borderWidth = 1
        
        // 通知センターの取得
        let notification =  NotificationCenter.default
        
        // keyboardのframe変化時
        notification.addObserver(self,
                                 selector: #selector(self.keyboardChangeFrame(_:)),
                                 name: UIResponder.keyboardDidChangeFrameNotification,
                                 object: nil)
        
        // keyboard登場時
        notification.addObserver(self,
                                 selector: #selector(self.keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification,
                                 object: nil)
        
        // keyboard退場時
        notification.addObserver(self,
                                 selector: #selector(self.keyboardDidHide(_:)),
                                 name: UIResponder.keyboardDidHideNotification,
                                 object: nil)
    }

    // 「送信フォームを表示」ボタン押下時の処理
    @IBAction func showKeyboard(_ sender: Any) {
        // キーボードを表示
        textField.becomeFirstResponder()
    }
    
    // 画面タップ時の処理
    @IBAction func closeKeyboard(_ sender: Any) {
        // キーボードをしまう
        view.endEditing(true)
    }
    
    @IBAction func submitText(_ sender: Any) {
        textLabel.text = textField.text
    }
    
    // キーボードのフレーム変化時の処理
    @objc func keyboardChangeFrame(_ notification: NSNotification) {
        // keyboardのframeを取得
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // submitFormの最大Y座標と、keybordの最小Y座標の差分を計算
        let diff = self.submitForm.frame.maxY -  keyboardFrame.minY
        
        if (diff > 0) {
            //submitFormのbottomの制約に差分をプラス
            self.submitFormBottomConstraints.constant += diff
            self.view.layoutIfNeeded()
        }
    }
    
    // キーボード登場時の処理
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // 現在のsubmitFormの最大Y座標を保存
        submitFormY = self.submitForm.frame.maxY
        textField.text = textLabel.text
    }
    
    //キーボードが退場時の処理
    @objc func keyboardDidHide(_ notification: NSNotification) {
        //submitFormのbottomの制約を元に戻す
        self.submitFormBottomConstraints.constant = -submitFormY
        self.view.layoutIfNeeded()
    }
    
}

