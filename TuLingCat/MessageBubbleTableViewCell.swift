

import UIKit
import SnapKit


class MessageBubbleTableViewCell: UITableViewCell {
    
    var url = ""
    
    let bubbleImageView: UIImageView = {
        let bubbleImageView = UIImageView(image:BubbleImageMake(.ReciveNormal), highlightedImage:BubbleImageMake(.ReciveHighlighted))
        bubbleImageView.userInteractionEnabled = true //CopyMessage
        return bubbleImageView
    }()

    let messageLabel: UILabel = {
        let messageLabel = UILabel(frame:CGRectZero)
        messageLabel.font = UIFont.systemFontOfSize(17)
        messageLabel.numberOfLines = 0
        messageLabel.userInteractionEnabled = false
        return messageLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 4.5))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Width, relatedBy: .Equal, toItem: messageLabel, attribute: .Width, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))
        
        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterX, multiplier: 1, constant: 3))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterY, multiplier: 1, constant: -0.5))
        messageLabel.preferredMaxLayoutWidth = 218
        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Height, relatedBy: .Equal, toItem: bubbleImageView, attribute: .Height, multiplier: 1, constant: -15))
    }

    func configureWithMessage(message: Message) {
        //设置消息的内容
        messageLabel.text = message.message
        if message.url != "" {
            url = message.url
        }
        let constraints: NSArray = contentView.constraints
        let indexOfConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) -> Bool in
            return (constraint.firstItem as! UIView).isEqual(self.bubbleImageView) && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
        }
    
        //删除气泡的left或right约束，以便于重新设置
        contentView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        if message.messageType == .Receive {
            bubbleImageView.image = BubbleImageMake(.ReciveNormal)
            bubbleImageView.highlightedImage = BubbleImageMake(.ReciveHighlighted)
            messageLabel.textColor = UIColor.blackColor()
            contentView.addConstraint(NSLayoutConstraint(item:bubbleImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
            bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterX, multiplier: 1, constant: 3))
            
        } else if message.messageType == .Send {
            bubbleImageView.image = BubbleImageMake(.SendNormal)
            bubbleImageView.highlightedImage = BubbleImageMake(.SendHighlighted)
            messageLabel.textColor = UIColor.whiteColor()
            contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -10))

//            bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterX, multiplier: 1.0, constant: -3.0))
        }
    }
    
    //设置cell高亮
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        bubbleImageView.highlighted = selected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
