

import Foundation
import UIKit

enum MessageSentType{
    case Send
    case Receive
}

enum BubbleImageType {
    case SendNormal
    case SendHighlighted
    case ReciveNormal
    case ReciveHighlighted
    
}

func BubbleImageMake(bubbleImageType: BubbleImageType) -> UIImage {
    let maskReceiveImage = UIImage(named: "MessageBubble")!
    let maskSendImage = UIImage(CGImage: maskReceiveImage.CGImage!, scale: 2.0, orientation: UIImageOrientation.UpMirrored)
    
    let capInsetsReceive = UIEdgeInsetsMake(17, 26.5, 17.5, 21)
    let capInsetsSend = UIEdgeInsetsMake(17, 21, 17.5, 26.5)
    
    //图片拉伸
    switch(bubbleImageType) {
    case .SendNormal:
        return ColorImage(maskReceiveImage, red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0).resizableImageWithCapInsets(capInsetsSend)
    case .SendHighlighted:
        return ColorImage(maskReceiveImage, red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0).resizableImageWithCapInsets(capInsetsSend)
    case .ReciveNormal:
        return ColorImage(maskSendImage, red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0).resizableImageWithCapInsets(capInsetsReceive)
    case .ReciveHighlighted:
        return ColorImage(maskSendImage, red: 32.0/255.0, green: 96.0/255.0, blue: 200.0/255.0, alpha: 1.0).resizableImageWithCapInsets(capInsetsReceive)
    }
}
//图片进行染色处理
private func ColorImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha:CGFloat) -> UIImage {
    //获取图片大小
    let rect = CGRect(origin: CGPointZero, size: image.size)
    //创建位图绘图上下文
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    //获取位图绘图上下文，并开始渲染
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, .SourceAtop)
    CGContextFillRect(context, rect)
    //获取绘图结果，结束位图绘图上下文并返回绘图结果
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}
