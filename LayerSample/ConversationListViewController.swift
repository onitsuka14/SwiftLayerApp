//
//  ConversationListViewController.swift
//  LayerSample
//

import Atlas

class ConversationListViewController : ATLConversationListViewController, ATLConversationListViewControllerDelegate, ATLConversationListViewControllerDataSource {
    
    public func conversationListViewController(_ conversationListViewController: ATLConversationListViewController, didSelect conversation: LYRConversation){
        let nextViewController = ConversationViewController(layerClient: self.layerClient)
        nextViewController.conversation = conversation
        self.navigationController?.show(nextViewController, sender: nil)
    }
    
    public func conversationListViewController(_ conversationListViewController: ATLConversationListViewController, titleFor conversation: LYRConversation) -> String {
        
        var participants = Array(conversation.participants)
        participants = participants.filter() { $0.userID == (self.layerClient.authenticatedUser?.userID)! }
        
        guard participants.count == 0 else { return "Personal Conversation" }
        guard participants.count == 1 else { return participants[0].displayName! }
        
        var firstNames = [String]()
        for user in participants {
            let name = user.displayName!
            if conversation.lastMessage?.sender.userID == user.userID {
                firstNames.insert(name, at: 0)
            } else {
                firstNames.append(name)
            }
        }
        let names = firstNames.joined(separator: ", ")
        
        return names
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        // Custom Code
        self.setupRecipeButton()
    }
    
    
    // MARK: Custom Code
    public func setupRecipeButton() {
        let recipeButton = UIBarButtonItem(title: "Recipe",
                                           style: .plain,
                                           target: self,
                                           action: #selector(createConversation) )
        self.navigationItem.rightBarButtonItem = recipeButton
    }
    
    public func createConversation() {
        
        // Create Conversatoin View
        let conversationView = ConversationViewController(layerClient: self.layerClient)
        let participants = participantList()
        
        let options = LYRConversationOptions()
        options.distinctByParticipants = false
        
        let conversation = try! self.layerClient.newConversation(withParticipants: participants, options: options)
        conversationView.conversation = conversation
        
        // Define User Meta Data from Recipe
        let metadata = userMetaData()
        conversationView.conversation.setValuesForMetadataKeyPathsWith(metadata, merge: true)
        
        // Send Message
        let envelope = messageParts(conversation: conversationView.conversation)
        let message = try? self.layerClient.newMessage(with: envelope, options: nil)
        _ = try? conversationView.conversation.send(message!)
    }
    
    public func participantList() -> Set<String> {
        //Participant
        let userID:String = (self.layerClient.authenticatedUser?.userID)!
        let participants = Set<String>([userID])
        return participants
    }
    
    public func userMetaData() -> [String:String] {
        let meta:[String:String] = [
            "title":"Neopolitan Dream Cake",
            "recipe_url":"https://cookpad.com/us/recipes/750290-neapolitan-dream-cake",
            "image_url":"https://cookpad.com/us/recipe/images/0dd9b524851241f8",
            "image_file":"cakeimage",
            "mime_type":"text/html"]
        return meta
    }
    
    public func messageParts(conversation:LYRConversation) -> [LYRMessagePart] {
        
        let userMetaData = conversation.metadata!
        
        // TEXT PART
        let title = userMetaData["title"] as! String
        let part1 = LYRMessagePart(text: title)
        
        // IMAGE PART
        let cakeImage:UIImage! = UIImage(named: "cakeimage")
        let imageData:Data! = UIImagePNGRepresentation(cakeImage)
        let part2 = LYRMessagePart(mimeType: ATLMIMETypeImagePNG, data: imageData)
        
        let messageParts:[LYRMessagePart] = [part1,part2]

        return messageParts
    }
    
    func imageDownload(imageURL:String, completionHandler:@escaping (Bool, Data) -> () ) {
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: imageURL)! )
        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                let image: UIImage = UIImage(data: data!)!
                let imageData = UIImagePNGRepresentation(image)!
                completionHandler(true, imageData)
            } else {
                completionHandler(false, Data())
            }
        })
    }
}
