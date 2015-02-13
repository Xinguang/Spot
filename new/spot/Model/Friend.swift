@objc(Friend)
class Friend: _Friend {

    override func awakeFromInsert() {
        self.createAt = NSDate()
    }

}
