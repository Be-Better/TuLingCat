

import UIKit
import Parse
import Alamofire

class ChatTableViewController: UITableViewController, UITextViewDelegate {

    //消息所用的字体
    let messageFontSize: CGFloat = 17
    //输入框的高度
    let toolBarMinHeight: CGFloat = 44
    let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)
    
    var toolBar: UIToolbar!
    var textView: UITextView!
    var sendButton: UIButton!
    
    var question = " "
    
    var messages: [[Message]] = [[]]
    
    override var inputAccessoryView: UIView! {
        get{
            if toolBar == nil {
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight - 0.5))
                
                textView = InputTextView(frame:CGRectZero)
                textView.backgroundColor = UIColor(white: 250.0/255.0, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.layer.borderColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 205.0/255.0, alpha: 1.0).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton(type: .Custom)
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                sendButton.setTitle("发送", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1.0), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
                sendButton.addTarget(self, action: "sendAction", forControlEvents: .TouchUpInside)
                toolBar.addSubview(sendButton)
                
                //对组件进行Autolayout设置
                textView.translatesAutoresizingMaskIntoConstraints = false
                sendButton.translatesAutoresizingMaskIntoConstraints = false
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Left, multiplier: 1, constant: 8))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: sendButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
                
                /**
                textView.snp_makeConstraints{ (make) -> Void in
                    
                    make.left.equalTo(self.toolBar.snp_left).offset(8)
                    make.top.equalTo(self.toolBar.snp_top).offset(7.5)
                    make.right.equalTo(self.sendButton.snp_left).offset(-2)
                    make.bottom.equalTo(self.toolBar.snp_bottom).offset(-8)
                    
                    
                }
                sendButton.snp_makeConstraints{ (make) -> Void in
                    make.right.equalTo(self.toolBar.snp_right)
                    make.bottom.equalTo(self.toolBar.snp_bottom).offset(-4.5)
                    
                }
                **/
                
            }
            return toolBar
        }
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        tableView.registerClass(MessageSentDateTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MessageSentDateTableViewCell))
        //键盘随着tableview的滚动而消失
        tableView.keyboardDismissMode = .Interactive
        //设置单元格的预估行高
        self.tableView.estimatedRowHeight = 44
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, toolBarMinHeight, 0)
        self.tableView.separatorStyle = .None
        
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    //加载数据
    func loadData() {
        
        var index = 0
        var section = 0
        var currentDate: NSDate?
        
        let query: PFQuery = PFQuery(className: "Messages")

        messages = [[Message(messageType: .Receive, message: "图灵机器人", sendDate: NSDate())]]
        query.orderByAscending("sentDate")
        query.cachePolicy = PFCachePolicy.CacheElseNetwork
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            guard error == nil  else {
                print("Error \(error?.userInfo)")
                return
            }
                
            if objects!.count > 0 {
                //这里是一个循环，遍历所有接收的数据
                for object in objects as! [PFObject] {
                    if index == objects!.count - 1 {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })
                    }
                    let message = Message(messageType: (object["incoming"] as! Bool) ? .Receive : .Send, message: object["text"] as! String, sendDate: object["sentDate"] as! NSDate)
                    if let url = object["url"] as? String {
                        message.url = url
                    }
                    if index == 0 {
                        currentDate = message.sendDate
                    }
                    let timInterval = message.sendDate.timeIntervalSinceDate(currentDate!)
                    
                    if timInterval < 120 {
                        self.messages[section].append(message)
                    } else {
                        section++
                        self.messages.append([message])
                    }
                    currentDate = message.sendDate
                    index++
                }
            }
        }
    }
    
    //MARK: UIButton Send
    func sendAction() {
        let message = Message(messageType: .Send, message: textView.text, sendDate: NSDate())
        saveMessage(message)
        messages.append([message])
        question = textView.text
        
        textView.text = nil
        updateTextViewHeight()
        
        sendButton.enabled = false
        
        let lastSetion = tableView.numberOfSections
        tableView.beginUpdates()
        tableView.insertSections(NSIndexSet(index: lastSetion), withRowAnimation: .Automatic)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: lastSetion), NSIndexPath(forRow: 1, inSection: lastSetion)], withRowAnimation: .Automatic)
        tableView.endUpdates()
        tableViewScrollToBottomAnimated(true)
        
        
        Alamofire.request(.GET, NSURL(string: TLUtils.api_url)!, parameters:["key": TLUtils.api_key, "info": question, "userid": TLUtils.userID]).responseJSON {
            response in
            
            guard response.result.isSuccess else {
                print("Data read error \(response.result.error)")
                return
            }
            guard let text = response.result.value!["text"] as? String else {
                print("text is nil!")
                return
            }
            if let url = response.result.value!["url"] as? String{
                let message = Message(messageType: .Receive, message: text+"\n(点击该消息并打开查看)", sendDate: NSDate())
                message.url = url
                self.saveMessage(message)
                self.messages[lastSetion].append(message)
            } else {
                let message = Message(messageType: .Receive, message: text, sendDate: NSDate())
                self.saveMessage(message)
                self.messages[lastSetion].append(message)
            }
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: lastSetion)], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            self.tableViewScrollToBottomAnimated(false)
            
        }
    }
    
    //MARK: 消息保存
    func saveMessage(message: Message) {
     
        let saveObject = PFObject(className: "Messages")
        switch (message.messageType) {
        case .Receive:
            saveObject["incoming"] = true
        case .Send:
            saveObject["incoming"] = false
        }
        saveObject["text"] = message.message
        saveObject["sentDate"] = message.sendDate
        saveObject["url"] = message.url
//        let user = PFUser.currentUser()
//        saveObject["createdBy"] = TLUtils.userID
        saveObject.saveEventually { (success, error) -> Void in
            if success {
                print("保存成功!")
            } else {
                print("保存失败\(error)")
            }
        }
    }

    func tableViewScrollToBottomAnimated(animated: Bool) {
        let numberOfSaections = messages.count
        let numberOfRows = messages[numberOfSaections - 1].count
        if numberOfRows > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows, inSection: numberOfSaections - 1), atScrollPosition: .Bottom, animated: animated)
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages[section].count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cellIdentifier = NSStringFromClass(MessageSentDateTableViewCell)
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessageSentDateTableViewCell
            let message = messages[indexPath.section][0]
            
            cell.sentDateLabel.text = formateDate(message.sendDate)
            return cell
        } else {
            let cellIdentifier = NSStringFromClass(MessageBubbleTableViewCell)
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MessageBubbleTableViewCell!
            if cell == nil {
                cell = MessageBubbleTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            }
            let message = messages[indexPath.section][indexPath.row - 1]
            cell.configureWithMessage(message)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectCell = tableView.cellForRowAtIndexPath(indexPath) as? MessageBubbleTableViewCell {
            if selectCell.url != "" {
                let webViewController = WebViewController(url:selectCell.url)
//                self.presentViewController(webViewController, animated: true, completion: nil)
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }

    //MARK:格式化时间
    func formateDate(date: NSDate) -> String {
        //获取当前的日历
        let calendar = NSCalendar.currentCalendar()
        var dateFormatter = NSDateFormatter()
        //新建日期格式化器，设置地区为中国大陆
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        
        let last18hours = (-18*60*60 < date.timeIntervalSinceNow)
        let isToday = calendar.isDateInToday(date)
        let isLast7Days = (calendar.compareDate(NSDate(timeIntervalSinceNow: -7*24*60*60), toDate: date, toUnitGranularity: NSCalendarUnit.NSDayCalendarUnit) == NSComparisonResult.OrderedAscending)
    /**
        占位符	含义
        YYYY	年份
        MM      月份
        dd      日
        HH      小时
        mm      分钟
        ss      秒
        a       表示上午、下午等
        EEEE	星期几
    **/
        if last18hours || isToday {
            dateFormatter.dateFormat = "a HH:mm"
        } else if isLast7Days {
            dateFormatter.dateFormat = "MM月dd日 a HH:mm EEEE"
        } else {
            dateFormatter.dateFormat = "YYYY年MM月dd日 a HH:mm"
        }
        return dateFormatter.stringFromDate(date)
    }
    
    // MARK:UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        updateTextViewHeight()
        sendButton.enabled = textView.hasText()
    }
    
    //MARK: keyboard
    func keyboardWillShow(notification: NSNotification) {
        //取出通知
        let userInfo = notification.userInfo! as NSDictionary
        //获取键盘的位置、frame
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //参考的view
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height
        let insetOld = tableView.contentInset
        let insetChange = insetNewBottom - insetOld.bottom
        //所有消息的总高度和键盘弹出前contentInset的差值，实际上就是没有显示部分的高度，也就是溢出的部分。
        let overflow = tableView.contentSize.height - (tableView.frame.height - insetOld.top - insetOld.bottom)
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations: (() -> Void) = {
            if !(self.tableView.tracking || self.tableView.decelerating) {
                //根据键盘位置调整Inset
                if overflow > 0 {
                    self.tableView.contentOffset.y += insetChange
                    if self.tableView.contentOffset.y < -insetOld.top {
                        self.tableView.contentOffset.y = -insetOld.top
                    }
                } else if insetChange > -overflow {
                    self.tableView.contentOffset.y += insetChange + overflow
                }
            }
        }
        if duration > 0 {
            // http://stackoverflow.com/a/18873820/242933
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
        
    }
    
    //MARK: Update TextView Height
    func updateTextViewHeight() {
        let oldHeight = textView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.max)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
        #else
            newHeight = CGFloat(ceil(newHeight.native))
        #endif
        
        
        if newHeight != oldHeight {
            toolBar.frame.size.height = newHeight + 8 * 2 - 0.5
        }
    }
    
    //MARK: 是用来防止出现底下的白边，原理就是限制显示出的高度
    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height
        
        let contentOffsetY = tableView.contentOffset.y
        tableView.contentInset.bottom = insetNewBottom
        tableView.scrollIndicatorInsets.bottom = insetNewBottom
        if self.tableView.tracking || self.tableView.decelerating {
            tableView.contentOffset.y = contentOffsetY
        }
    }

    
}

