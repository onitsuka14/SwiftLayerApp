//
//  ConversationViewController.swift
//  LayerSample
//

import Atlas
import SafariServices


struct CustomIdentier {
    static let outgoing = "cell_outgoing"
    static let incoming = "cell_incoming"
    static let generic = "generic"
}

class ConversationViewController : ATLConversationViewController, ATLConversationViewControllerDataSource, ATLConversationViewControllerDelegate, SFSafariViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        self.delegate = self
        self.dataSource = self
        
        self.registerClass(ConversationMessageCell.self, forMessageCellWithReuseIdentifier: CustomIdentier.outgoing)
        self.registerClass(ConversationMessageCell.self, forMessageCellWithReuseIdentifier: CustomIdentier.incoming)
        self.registerClass(ATLMessageCollectionViewCell.self, forMessageCellWithReuseIdentifier: CustomIdentier.generic)
        
    }

    func conversationViewController(_ viewController: ATLConversationViewController, heightFor message: LYRMessage, withCellWidth cellWidth: CGFloat) -> CGFloat {
        return 250.00
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, participantFor identity: LYRIdentity) -> ATLParticipant{
        return identity
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOf date: Date) -> NSAttributedString{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "MMM dd, yyyy"
        return NSAttributedString(string: formatter.string(from: date))
    }
    
    public func conversationViewController(_ viewController: ATLConversationViewController, didSelect message: LYRMessage) {
        
        let userData = message.conversation?.metadata as! [String : String]
        showWebContent(metaData:userData)
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOfRecipientStatus recipientStatus: [AnyHashable : Any]) -> NSAttributedString{
        print(recipientStatus)
        return NSAttributedString(string: "")
    }
    
    public func conversationViewController(_ viewController: ATLConversationViewController, reuseIdentifierFor message: LYRMessage) -> String? {
        
        
        let userData = message.conversation?.metadata as! [String : String]
        let customType:String = userData["mime_type"]!
        if customType == "text/html" {
            if message.sender != self.layerClient.authenticatedUser {
                return CustomIdentier.incoming
            } else {
                return CustomIdentier.outgoing
            }
        }
        
        return CustomIdentier.generic
    }

    public func showWebContent(metaData:[String:String]) {
        let link:String = metaData["recipe_url"]!
        let url = URL(string: link)!
        let svc = SFSafariViewController(url: url,
                                         entersReaderIfAvailable: true)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
