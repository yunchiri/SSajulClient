//
//  SettingViewController.swift
//  Ssajul
//
//  Created by yunchiri on 2016. 11. 27..
//  Copyright © 2016년 youngchill. All rights reserved.
//

import UIKit
import SwiftyFORM



class SettingViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()

    }
    
    
    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "프로필 설정"
        builder.toolbarMode = .simple
        builder.demo_showInfo("")
        builder += SectionHeaderTitleFormItem().title("프로필")
        
        
        
        builder += SectionHeaderTitleFormItem().title("옵션")
        builder += ViewControllerFormItem().title("어그로 리스트").viewController(SettingBlockUserTableViewController.self)

        
    }
    
    lazy var aggro: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("차단 어그로")
//        instance.value = "dd"
        
        instance.keyboardType = .asciiCapable
        instance.submitValidate(CountSpecification.min(1), message: "한글자는 넘어야됨")
        
        return instance
    }()
    


}
