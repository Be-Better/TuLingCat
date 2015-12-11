

import UIKit
import SnapKit

class MessageSentDateTableViewCell: UITableViewCell {

    //时间label
    lazy var sentDateLabel: UILabel = {
        let sentDateLabel = UILabel(frame: CGRectZero)
        sentDateLabel.backgroundColor = UIColor.clearColor()
        sentDateLabel.font = UIFont.systemFontOfSize(10)
        sentDateLabel.textAlignment = .Center
        sentDateLabel.textColor = UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1.0)
        return sentDateLabel
    
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        contentView.addSubview(sentDateLabel)
        
        sentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: sentDateLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: sentDateLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 13))
        contentView.addConstraint(NSLayoutConstraint(item: sentDateLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))
//        contentView.snp_makeConstraints { (make) -> Void in
//            make.centerX.equalTo(contentView.snp_centerX)
//            make.top.equalTo(contentView.snp_top).offset(13)
//            make.bottom.equalTo(contentView.snp_bottom).offset(-4.5)
//        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
