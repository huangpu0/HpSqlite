//
//  ViewController.swift
//  HpSqlite
//
//  Created by iTrader-dev on 2021/1/10.
//

import UIKit

class ViewController: UIViewController {

    let show   = UILabel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn1 = UIButton.init()
        btn1.frame = CGRect.init(x: 10, y: 100, width: 80, height: 80)
        btn1.backgroundColor = .red
        btn1.setTitle("增", for: .normal)
        btn1.addTarget(self, action: #selector(creatEvent(_:)), for: .touchUpInside)
        self.view.addSubview(btn1)
        
        let btn2 = UIButton.init()
        btn2.frame = CGRect.init(x: 100, y: 100, width: 80, height: 80)
        btn2.backgroundColor = .red
        btn2.setTitle("删", for: .normal)
        btn2.addTarget(self, action: #selector(deleteEvent(_:)), for: .touchUpInside)
        self.view.addSubview(btn2)
        
        let btn3 = UIButton.init()
        btn3.frame = CGRect.init(x: 190, y: 100, width: 80, height: 80)
        btn3.backgroundColor = .red
        btn3.setTitle("改", for: .normal)
        btn3.addTarget(self, action: #selector(updateEvent(_:)), for: .touchUpInside)
        self.view.addSubview(btn3)
        
        print("测试代码")
        
        let btn4 = UIButton.init()
        btn4.frame = CGRect.init(x: 280, y: 100, width: 80, height: 80)
        btn4.backgroundColor = .red
        btn4.setTitle("查", for: .normal)
        btn4.addTarget(self, action: #selector(queryEvent(_:)), for: .touchUpInside)
        self.view.addSubview(btn4)
        
        show.text  = "暂无数据"
        show.frame = CGRect.init(x: 30, y: 200, width: UIScreen.main.bounds.width - 60, height: 300)
        show.numberOfLines = 0
        show.textColor = .black
        show.textAlignment = .center
        self.view.addSubview(show)
        
        
       
        
    }

    /// 增
    @objc
    func creatEvent(_ btn: UIButton) -> Void {
        var params:[String: Any] = [:]
        params["id"]   = 123
        params["name"] = "名字"
        params["desc"] = "描述"
        HpUserInfo.share.add(params)
        var params1:[String: Any] = [:]
        params1["id"]   = 456
        params1["name"] = "名字"
        params1["desc"] = "描述"
        HpUserInfo.share.add(params1)
        
        let dict0 = HpUserInfo.share.query(123)
        let dict1 = HpUserInfo.share.query(456)
        show.text = HpJsonString.toJSONString(dict0 ?? [:]) + HpJsonString.toJSONString(dict1 ?? [:])
        
       
    }
    
    /// 删
    @objc
    func deleteEvent(_ btn: UIButton) -> Void {
        HpUserInfo.share.deleteTab()
        
    }
    
    /// 改
    @objc
    func updateEvent(_ btn: UIButton) -> Void {
        HpUserInfo.share.reset("userInfo", new: "userInfo22")
    }
    
    /// 查
    @objc
    func queryEvent(_ btn: UIButton) -> Void {
        let dict0 = HpUserInfo.share.query(123)
        show.text = HpJsonString.toJSONString(dict0 ?? [:])
    }

}

