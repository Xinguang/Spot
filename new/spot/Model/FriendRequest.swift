@objc(FriendRequest)
class FriendRequest: _FriendRequest {

    override func awakeFromInsert() {
        self.createAt = NSDate()
    }

}
