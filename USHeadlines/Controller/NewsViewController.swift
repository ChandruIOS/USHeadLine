//
//  NewsViewController.swift
//  USHeadlines
//
//  Created by siva chitran p on 12/08/22.
//

import UIKit
import SwiftMessages

class NewsViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var newTableView: UITableView! {
        didSet{
            newTableView.backgroundColor = UIColor.black
        }
    }
    
    let dataSource = NewsDataSource()
    lazy var viewModel : NewsViewModel = {
        var viewModel = NewsViewModel(dataSource: dataSource,
                                      vcs: self)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkHandler.instance.initiateRecahbility()
        self.setUpUI()
    }
    // MARK: - SetUI
    func setUpUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.newTableView.register(UINib(nibName: "NewsTableViewCell",
                                         bundle: nil),
                                   forCellReuseIdentifier: "NewsTableViewCell")
        self.newTableView.delegate = dataSource
        self.newTableView.dataSource = dataSource
        self.dataSource.delegate = self
        self.newsapiCall()
    }
    // MARK: - All NEWS Api Call
    func newsapiCall() {
        self.viewModel.getNewsApiCall { [weak self] status, msg in
            if(status == "1") {
                guard let curvc = self else{return}
                curvc.dataSource.data.addAndNotify(observer: curvc) { [weak self] _ in
                    guard let vc = self else{return}
                    if(vc.dataSource.data.value.count == 0) {
                        MessageHandler.sharedinstance.showErrorMessageWithTxt(msg: "No Data Available.")
                    }else{
                        vc.newTableView.reloadData()
                    }
                }
            }else{
                MessageHandler.sharedinstance.showErrorMessageWithTxt(msg: msg)
            }
        }
    }
}

// MARK: - Protocol via Move TO Detail Page
extension NewsViewController: NewsProtocol {
    func didTapNews(Article: Articles) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.articlesObj = Article
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
