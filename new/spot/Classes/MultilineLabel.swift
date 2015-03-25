import UIKit

class MultilineLabel: UILabel {
    override var bounds : CGRect {
        didSet {
            super.bounds = bounds
            
            if self.numberOfLines != 1 && bounds.width != self.preferredMaxLayoutWidth {
                self.preferredMaxLayoutWidth = bounds.size.width
                self.setNeedsUpdateConstraints()
            }
        }
    }
}
