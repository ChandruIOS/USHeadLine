//
//  NewsDetailViewController.swift
//  USHeadlines
//
//  Created by siva chitran p on 12/08/22.
//
import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var News_Img: UIImageView!
    @IBOutlet weak var description_Lbl: UILabel!
    @IBOutlet weak var likeCount_Lbl: UILabel!
    @IBOutlet weak var commentCount_Lbl: UILabel!
        
    var articlesObj : Articles?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        guard let dict = articlesObj else{ return}
        title_Lbl.text = Constant.checkNull(dict.title)
        description_Lbl.text = Constant.checkNull(dict.description)
        self.News_Img.layer.cornerRadius = 20.0
        Constant.sharedInstance.loadImageFromUrl(urlString: Constant.checkNull(dict.urlToImage),
                                                 placeholderImage: "placeHolder",
                                                 imageView: self.News_Img)
        self.likeCount_Lbl.text = "\(Constant.checkNull(dict.likes)) Likes"
        self.commentCount_Lbl.text = "\(Constant.checkNull(dict.comments)) Comments"
    }

    @IBAction func didClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
