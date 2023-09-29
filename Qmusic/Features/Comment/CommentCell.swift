//
//  CommentCell.swift
//  Qmusic
//
//  Created by QuangHo on 14/09/2023.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var imgAVa: UIImageView!
    
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblTimeAt: UILabel!
    @IBOutlet weak var lblNumberLike: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(comment: CommentModel) {
        if let date = comment.createAt?.stringFormatter() {
            lblTimeAt.text = date.dateFormatter(partern: "dd/mm/yyyy - hh:MM:ss")
        }
        lblContent.attributedText = NSAttributedString(string: comment.comment ?? "")
    }
    
    @IBAction func reportComment(_ sender: Any) {
        (sender as! UIButton).tintColor = UIColor(named: "CovidRed")
    }
    
}
